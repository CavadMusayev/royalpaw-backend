import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Booking } from './entities/booking.entity';
import { CreateBookingDto } from './dto/create-booking.dto';

@Injectable()
export class BookingsService {
  constructor(
    @InjectRepository(Booking) private repo: Repository<Booking>,
  ) {}

  create(dto: CreateBookingDto) {
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
    booking.status = status;
    return this.repo.save(booking);
  }
}