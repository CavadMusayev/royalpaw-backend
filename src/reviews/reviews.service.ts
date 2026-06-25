import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { Review } from './entities/review.entity';
import { Pet } from '../pets/entities/pet.entity';
import { Booking } from '../bookings/entities/booking.entity';
@Injectable()
export class ReviewsService {
  constructor(
    @InjectRepository(Review) private repo: Repository<Review>,
    @InjectRepository(Pet) private petRepo: Repository<Pet>,
    @InjectRepository(Booking) private bookingRepo: Repository<Booking>,
  ) {}

  // rəy yarat
  create(data: Partial<Review>) {
    const review = this.repo.create(data);
    return this.repo.save(review);
  }

// bir qulluqçunun bütün rəyləri (yeni → köhnə)
  async findForCaretaker(caretakerId: string) {
    const reviews = await this.repo.find({
      where: { caretakerId },
      order: { createdAt: 'DESC' },
    });
    return this.attachPetPhotos(reviews);
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
  async findRecent() {
    const reviews = await this.repo.find({
      order: { createdAt: 'DESC' },
      take: 20,
    });
    return this.attachPetPhotos(reviews);
  }

  // hər rəyə booking-dəki dəqiq heyvanın şəklini əlavə et
  private async attachPetPhotos(reviews: Review[]) {
    const bookingIds = [...new Set(reviews.map((r) => r.bookingId).filter(Boolean))];
    if (bookingIds.length === 0) return reviews;
    // bookingləri tap (pet_id üçün)
    const bookings = await this.bookingRepo.findBy({ id: In(bookingIds) });
    const petIdByBooking: Record<string, string> = {};
    for (const b of bookings) {
      if ((b as any).petId) petIdByBooking[b.id] = (b as any).petId;
    }
    // petləri tap (şəkil üçün)
    const petIds = [...new Set(Object.values(petIdByBooking))];
    const pets = petIds.length ? await this.petRepo.findBy({ id: In(petIds) }) : [];
    const photoByPet: Record<string, string> = {};
    for (const p of pets) {
      if (p.photoUrl) photoByPet[p.id] = p.photoUrl;
    }
    return reviews.map((r) => {
      const petId = petIdByBooking[r.bookingId];
      const photo = petId ? photoByPet[petId] : null;
      return { ...r, petPhotoUrl: r.petPhotoUrl ?? photo ?? null };
    });
  }
}