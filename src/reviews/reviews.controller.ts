import { Controller, Get, Post, Body, Param, Query, UseGuards } from '@nestjs/common';
import { ReviewsService } from './reviews.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('reviews')
export class ReviewsController {
  constructor(private readonly reviews: ReviewsService) {}

  // son rəylər (ana səhifə) — token tələb etmir
  @Get('recent')
  recent() {
    return this.reviews.findRecent();
  }

  // qulluqçunun rəyləri
  @Get('caretaker/:id')
  forCaretaker(@Param('id') id: string) {
    return this.reviews.findForCaretaker(id);
  }

  // qulluqçunun stat (orta bal)
  @Get('caretaker/:id/stats')
  stats(@Param('id') id: string) {
    return this.reviews.statsFor(id);
  }

  // bu booking üçün rəy var?
  @Get('booking/:id/exists')
  async existsForBooking(@Param('id') id: string) {
    return { exists: await this.reviews.existsForBooking(id) };
  }

  // rəy yarat
  @UseGuards(JwtAuthGuard)
  @Post()
  create(@Body() data: any) {
    return this.reviews.create({
      bookingId: data.bookingId,
      caretakerId: data.caretakerId,
      ownerId: data.ownerId,
      rating: data.rating,
      comment: data.comment,
      petPhotoUrl: data.petPhotoUrl,
    });
  }
}