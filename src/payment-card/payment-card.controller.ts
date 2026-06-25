import { Controller, Get, Patch, Body } from '@nestjs/common';
import { PaymentCardService } from './payment-card.service';

@Controller('payment-card')
export class PaymentCardController {
  constructor(private readonly service: PaymentCardService) {}

  @Get()
  get() {
    return this.service.get();
  }

  @Patch()
  update(@Body() data: any) {
    return this.service.update({
      cardNumber: data.cardNumber,
      holderName: data.holderName,
      expiry: data.expiry,
      bankName: data.bankName,
      iban: data.iban,
    });
  }
}