import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PaymentCard } from './entities/payment-card.entity';

@Injectable()
export class PaymentCardService {
  constructor(
    @InjectRepository(PaymentCard) private repo: Repository<PaymentCard>,
  ) {}

  // tək kartı qaytar (ilk sətir)
  async get() {
    const cards = await this.repo.find();
    return cards[0] ?? null;
  }

  // kartı yenilə (admin)
  async update(data: Partial<PaymentCard>) {
    let card = (await this.repo.find())[0];
    if (!card) {
      card = this.repo.create(data);
    } else {
      Object.assign(card, data);
    }
    return this.repo.save(card);
  }
}