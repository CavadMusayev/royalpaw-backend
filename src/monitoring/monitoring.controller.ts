import { Controller, Get, Post, Body, Param, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { MonitoringService } from './monitoring.service';
import { CreateLogDto } from './dto/create-log.dto';

@Controller('monitoring')
@UseGuards(JwtAuthGuard)
export class MonitoringController {
  constructor(private monitoring: MonitoringService) {}

  // qulluqçu qeyd əlavə edir
  @Post()
  create(@Body() dto: CreateLogDto) {
    return this.monitoring.create(dto);
  }

  // sahib bir sifarişin timeline-ını görür
  @Get('booking/:bookingId')
  byBooking(@Param('bookingId') bookingId: string) {
    return this.monitoring.findByBooking(bookingId);
  }
}