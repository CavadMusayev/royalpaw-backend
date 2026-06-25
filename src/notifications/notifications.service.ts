import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, IsNull, LessThan } from 'typeorm';
import { Cron, CronExpression } from '@nestjs/schedule';
import { Notification } from './entities/notification.entity';
import { CreateNotificationDto } from './dto/notification.dto';

@Injectable()
export class NotificationsService {
 constructor(
    @InjectRepository(Notification) private repo: Repository<Notification>,
  ) {}

  // hər gün saat 03:00-da 2 gündən köhnə bildirişləri sil (baza yığılmasın)
  @Cron(CronExpression.EVERY_DAY_AT_3AM)
  async cleanOldNotifications() {
    const twoDaysAgo = new Date(Date.now() - 2 * 24 * 60 * 60 * 1000);
    const result = await this.repo.delete({ createdAt: LessThan(twoDaysAgo) });
    console.log(`🧹 ${result.affected ?? 0} köhnə bildiriş silindi`);
  }

  // istifadəçinin bildirişləri (özünə aid + hamıya olanlar, son 2 gün)
  forUser(userId: string) {
    const twoDaysAgo = new Date(Date.now() - 2 * 24 * 60 * 60 * 1000);
    return this.repo
      .createQueryBuilder('n')
      .where('(n.user_id = :userId OR n.user_id IS NULL)', { userId })
      .andWhere('n.created_at > :twoDaysAgo', { twoDaysAgo })
      .orderBy('n.created_at', 'DESC')
      .getMany();
  }

  // oxunmamış say
  async unreadCount(userId: string) {
    const count = await this.repo
      .createQueryBuilder('n')
      .where('(n.user_id = :userId OR n.user_id IS NULL) AND n.is_read = false', { userId })
      .getCount();
    return { count };
  }

// bildiriş yarat (admin göndərir)
  create(dto: CreateNotificationDto) {
    const n = this.repo.create({
      userId: dto.userId ?? undefined,
      title: dto.title,
      body: dto.body,
      icon: dto.icon ?? 'bell',
      link: dto.link ?? undefined,
    });
    return this.repo.save(n);
  }

  // oxundu işarələ
  async markRead(id: string) {
    await this.repo.update(id, { isRead: true });
    return { ok: true };
  }

  // admin üçün: bütün bildirişlər
  findAll() {
    return this.repo.find({ order: { createdAt: 'DESC' }, take: 100 });
  }
}