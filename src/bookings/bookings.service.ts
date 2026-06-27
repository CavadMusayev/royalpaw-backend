import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Booking } from './entities/booking.entity';
import { CreateBookingDto } from './dto/create-booking.dto';
import { User } from '../users/entities/user.entity';
<<<<<<< HEAD
import { NotificationsService } from '../notifications/notifications.service';
=======
>>>>>>> b576ca4874ce02d4ed1973432cc7f55f55af8872

@Injectable()
export class BookingsService {
  constructor(
    @InjectRepository(Booking) private repo: Repository<Booking>,
    @InjectRepository(User) private userRepo: Repository<User>,
<<<<<<< HEAD
    private notifications: NotificationsService,
=======
>>>>>>> b576ca4874ce02d4ed1973432cc7f55f55af8872
  ) {}

async create(dto: CreateBookingDto) {
    // qulluqçu suspend olunubsa, sifariş qəbul etmə
    if (dto.caretakerId) {
      const caretaker = await this.userRepo.findOneBy({ id: dto.caretakerId });
      if (caretaker?.isSuspended) {
        throw new NotFoundException('Bu qulluqçu hazırda sifariş qəbul etmir');
      }
    }
<<<<<<< HEAD
  const booking = this.repo.create(dto);
    const saved = await this.repo.save(booking);
    // qulluqçuya bildiriş göndər
    if (dto.caretakerId) {
      try {
        await this.notifications.create({
          userId: dto.caretakerId,
          title: 'Yeni sifariş 🎉',
          body: 'Yeni xidmət sifarişi aldınız. Sifarişlərim bölməsinə baxın.',
          icon: 'clipboardList',
          link: 'bookings',
        });
      } catch (_) {}
    }
    return saved;
=======
    const booking = this.repo.create(dto);
    return this.repo.save(booking);
>>>>>>> b576ca4874ce02d4ed1973432cc7f55f55af8872
  }

  findAll() {
    return this.repo.find({ order: { createdAt: 'DESC' } });
  }

  findOne(id: string) {
    return this.repo.findOneBy({ id });
  }

  // sifariş statusunu dəyişmək (qəbul, başlat, tamamla, ləğv)
  async updateStatus(id: string, status: string) {
    const booking = await this.repo.findOneBy({ id });
    if (!booking) throw new NotFoundException('Sifariş tapılmadı');

    const wasCompleted = booking.status === 'completed';
    booking.status = status;
    await this.repo.save(booking);

    // sifariş YENİ tamamlanırsa → qulluqçuya 10% komissiya borcu yaz
    if (status === 'completed' && !wasCompleted && booking.caretakerId) {
      const caretaker = await this.userRepo.findOneBy({ id: booking.caretakerId });
      if (caretaker) {
<<<<<<< HEAD
      const commission = Math.round((booking.amountMinor ?? 0) * 0.10);
        caretaker.commissionDebt = (caretaker.commissionDebt ?? 0) + commission;
        // sifariş məbləği qazanca əlavə olunur
        caretaker.totalEarnings = (caretaker.totalEarnings ?? 0) + (booking.amountMinor ?? 0);
=======
        const commission = Math.round((booking.amountMinor ?? 0) * 0.10);
        caretaker.commissionDebt = (caretaker.commissionDebt ?? 0) + commission;
>>>>>>> b576ca4874ce02d4ed1973432cc7f55f55af8872
        // ilk borcdursa, tarixi təyin et (15 gün hesablamaq üçün)
        if (!caretaker.oldestDebtAt) {
          caretaker.oldestDebtAt = new Date();
        }
<<<<<<< HEAD
      await this.userRepo.save(caretaker);
      }
    }
    return booking;
  }

  // qulluqçu konum göndərir
  async updateLocation(bookingId: string, lat: number, lng: number) {
    const booking = await this.repo.findOneBy({ id: bookingId });
    if (!booking) throw new NotFoundException('Sifariş tapılmadı');
    booking.liveLat = lat;
    booking.liveLng = lng;
    booking.liveUpdatedAt = new Date();
    booking.trackingActive = true;
    await this.repo.save(booking);
    return { ok: true };
  }

  // konum al (sahib üçün)
  async getLocation(bookingId: string) {
    const booking = await this.repo.findOneBy({ id: bookingId });
    if (!booking) throw new NotFoundException('Sifariş tapılmadı');
    return {
      lat: booking.liveLat ?? null,
      lng: booking.liveLng ?? null,
      updatedAt: booking.liveUpdatedAt ?? null,
      active: booking.trackingActive ?? false,
    };
  }

  // izləməni dayandır
  async stopTracking(bookingId: string) {
    const booking = await this.repo.findOneBy({ id: bookingId });
    if (!booking) throw new NotFoundException('Sifariş tapılmadı');
    booking.trackingActive = false;
    await this.repo.save(booking);
    return { ok: true };
=======
        await this.userRepo.save(caretaker);
      }
    }

    return booking;
>>>>>>> b576ca4874ce02d4ed1973432cc7f55f55af8872
  }
}