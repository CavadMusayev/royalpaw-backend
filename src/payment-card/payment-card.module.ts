import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PaymentCard } from './entities/payment-card.entity';
import { PaymentCardService } from './payment-card.service';
import { PaymentCardController } from './payment-card.controller';

@Module({
  imports: [TypeOrmModule.forFeature([PaymentCard])],
  controllers: [PaymentCardController],
  providers: [PaymentCardService],
  exports: [PaymentCardService],
})
export class PaymentCardModule {}