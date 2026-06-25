import { Controller, Get, Post, Patch, Body, Param, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { BookingsService } from './bookings.service';
import { CreateBookingDto } from './dto/create-booking.dto';

@Controller('bookings')
@UseGuards(JwtAuthGuard)
export class BookingsController {
  constructor(private bookings: BookingsService) {}

  @Post()
  create(@Body() dto: CreateBookingDto) {
    return this.bookings.create(dto);
  }

  @Get()
  findAll() {
    return this.bookings.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.bookings.findOne(id);
  }

  @Patch(':id/status')
  updateStatus(@Param('id') id: string, @Body() b: { status: string }) {
    return this.bookings.updateStatus(id, b.status);
  }

  // qulluqçu konum göndərir
  @Post(':id/location')
  updateLocation(@Param('id') id: string, @Body() b: { lat: number; lng: number }) {
    return this.bookings.updateLocation(id, b.lat, b.lng);
  }

  // sahib konum alır
  @Get(':id/location')
  getLocation(@Param('id') id: string) {
    return this.bookings.getLocation(id);
  }

  // izləməni dayandır
  @Post(':id/stop-tracking')
  stopTracking(@Param('id') id: string) {
    return this.bookings.stopTracking(id);
  }
}