import { Controller, Get, Post, Param, Body, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { PaymentsService } from './payments.service';
import { CreatePaymentDto } from './dto/create-payment.dto';

@Controller('payments')
@UseGuards(JwtAuthGuard)
export class PaymentsController {
  constructor(private payments: PaymentsService) {}

  @Post()
  create(@Body() dto: CreatePaymentDto) {
    return this.payments.create(dto);
  }

  @Get('booking/:bookingId')
  byBooking(@Param('bookingId') bookingId: string) {
    return this.payments.getByBooking(bookingId);
  }

  @Post(':id/pay')
  pay(@Param('id') id: string) {
    return this.payments.pay(id);
  }

  @Post(':id/release')
  release(@Param('id') id: string) {
    return this.payments.release(id);
  }

  @Post(':id/refund')
  refund(@Param('id') id: string) {
    return this.payments.refund(id);
  }
}