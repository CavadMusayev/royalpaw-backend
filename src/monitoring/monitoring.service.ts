import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { MonitoringLog } from './entities/monitoring-log.entity';
import { CreateLogDto } from './dto/create-log.dto';
import { Booking } from '../bookings/entities/booking.entity';
import { NotificationsService } from '../notifications/notifications.service';

@Injectable()
export class MonitoringService {
  constructor(
    @InjectRepository(MonitoringLog) private repo: Repository<MonitoringLog>,
    @InjectRepository(Booking) private bookings: Repository<Booking>,
    private notifications: NotificationsService,
  ) {}

  // qulluqçu yeni qeyd əlavə edir → sahibə bildiriş
  async create(dto: CreateLogDto) {
    const log = this.repo.create(dto);
    const saved = await this.repo.save(log);

    // sifariş sahibini tap, ona bildiriş göndər
    try {
      const booking = await this.bookings.findOneBy({ id: dto.bookingId });
      if (booking && booking.ownerId) {
        await this.notifications.create({
          userId: booking.ownerId,
          title: 'Yeni nəzarət qeydi',
          body: 'Sevimliniz haqqında yeni yenilik əlavə olundu. Baxmaq üçün toxunun.',
          icon: 'eye',
        });
      }
    } catch (_) {
      // bildiriş uğursuz olsa belə qeyd saxlanılıb
    }

    return saved;
  }

  // bir sifarişin nəzarət timeline-ı (sahib görür)
  findByBooking(bookingId: string) {
    return this.repo.find({
      where: { bookingId },
      order: { createdAt: 'DESC' },
    });
  }
}