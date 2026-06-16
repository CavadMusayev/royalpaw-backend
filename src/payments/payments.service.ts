import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Payment } from './entities/payment.entity';
import { CreatePaymentDto } from './dto/create-payment.dto';

@Injectable()
export class PaymentsService {
  constructor(
    @InjectRepository(Payment) private repo: Repository<Payment>,
  ) {}

  // 1. Ödəniş yarat (sifariş üçün) — status: requires_payment
  async create(dto: CreatePaymentDto) {
    // həmin sifariş üçün ödəniş artıq varsa, onu qaytar
    const existing = await this.repo.findOne({ where: { bookingId: dto.bookingId } });
    if (existing) return existing;

    const payment = this.repo.create(dto);
    return this.repo.save(payment);
  }

  // Sifarişin ödənişini al
  getByBooking(bookingId: string) {
    return this.repo.findOne({ where: { bookingId } });
  }

  // 2. Ödə → escrow-a al (Yol A-da Stripe bura girəcək)
  async pay(id: string) {
    const payment = await this.repo.findOneBy({ id });
    if (!payment) throw new NotFoundException('Ödəniş tapılmadı');
    if (payment.status !== 'requires_payment') {
      throw new BadRequestException('Bu ödəniş artıq emal olunub');
    }
    payment.status = 'held_in_escrow';
    payment.heldAt = new Date();
    return this.repo.save(payment);
  }

  // 3. Qulluqçuya buraxıl (xidmət tamamlandıqda)
  async release(id: string) {
    const payment = await this.repo.findOneBy({ id });
    if (!payment) throw new NotFoundException('Ödəniş tapılmadı');
    if (payment.status !== 'held_in_escrow') {
      throw new BadRequestException('Ödəniş escrow-da deyil');
    }
    payment.status = 'released';
    payment.releasedAt = new Date();
    return this.repo.save(payment);
  }

  // Geri qaytar (ləğv)
  async refund(id: string) {
    const payment = await this.repo.findOneBy({ id });
    if (!payment) throw new NotFoundException('Ödəniş tapılmadı');
    payment.status = 'refunded';
    payment.refundedAt = new Date();
    return this.repo.save(payment);
  }
}
