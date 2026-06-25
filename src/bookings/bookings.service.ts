import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Booking } from './entities/booking.entity';
import { CreateBookingDto } from './dto/create-booking.dto';
import { User } from '../users/entities/user.entity';

@Injectable()
export class BookingsService {
  constructor(
    @InjectRepository(Booking) private repo: Repository<Booking>,
    @InjectRepository(User) private userRepo: Repository<User>,
  ) {}

async create(dto: CreateBookingDto) {
    // qulluqçu suspend olunubsa, sifariş qəbul etmə
    if (dto.caretakerId) {
      const caretaker = await this.userRepo.findOneBy({ id: dto.caretakerId });
      if (caretaker?.isSuspended) {
        throw new NotFoundException('Bu qulluqçu hazırda sifariş qəbul etmir');
      }
    }
    const booking = this.repo.create(dto);
    return this.repo.save(booking);
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
        const commission = Math.round((booking.amountMinor ?? 0) * 0.10);
        caretaker.commissionDebt = (caretaker.commissionDebt ?? 0) + commission;
        // ilk borcdursa, tarixi təyin et (15 gün hesablamaq üçün)
        if (!caretaker.oldestDebtAt) {
          caretaker.oldestDebtAt = new Date();
        }
        await this.userRepo.save(caretaker);
      }
    }

    return booking;
  }
}