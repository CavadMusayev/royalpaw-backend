import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, IsNull } from 'typeorm';
import { Notification } from './entities/notification.entity';
import { CreateNotificationDto } from './dto/notification.dto';

@Injectable()
export class NotificationsService {
  constructor(
    @InjectRepository(Notification) private repo: Repository<Notification>,
  ) {}

  // istifadəçinin bildirişləri (özünə aid + hamıya olanlar)
  forUser(userId: string) {
    return this.repo
      .createQueryBuilder('n')
      .where('n.user_id = :userId OR n.user_id IS NULL', { userId })
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