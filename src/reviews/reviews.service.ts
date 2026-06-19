import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Review } from './entities/review.entity';

@Injectable()
export class ReviewsService {
  constructor(
    @InjectRepository(Review) private repo: Repository<Review>,
  ) {}

  // rəy yarat
  create(data: Partial<Review>) {
    const review = this.repo.create(data);
    return this.repo.save(review);
  }

  // bir qulluqçunun bütün rəyləri (yeni → köhnə)
  findForCaretaker(caretakerId: string) {
    return this.repo.find({
      where: { caretakerId },
      order: { createdAt: 'DESC' },
    });
  }

  // qulluqçunun orta balı + say
  async statsFor(caretakerId: string) {
    const reviews = await this.repo.find({ where: { caretakerId } });
    if (reviews.length === 0) return { average: 0, count: 0 };
    const sum = reviews.reduce((a, r) => a + r.rating, 0);
    return { average: +(sum / reviews.length).toFixed(1), count: reviews.length };
  }

  // bu sifariş üçün artıq rəy var? (təkrar olmasın)
  async existsForBooking(bookingId: string) {
    const found = await this.repo.findOneBy({ bookingId });
    return found != null;
  }

  // son rəylər (ana səhifə üçün — şəkilli olanlar)
  findRecent() {
    return this.repo.find({
      order: { createdAt: 'DESC' },
      take: 20,
    });
  }
}