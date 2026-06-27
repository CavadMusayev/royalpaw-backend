import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Booking } from './entities/booking.entity';
import { User } from '../users/entities/user.entity';
import { BookingsService } from './bookings.service';
import { BookingsController } from './bookings.controller';
import { NotificationsModule } from '../notifications/notifications.module';
@Module({
<<<<<<< HEAD
  imports: [TypeOrmModule.forFeature([Booking, User]), NotificationsModule],
=======
  imports: [TypeOrmModule.forFeature([Booking, User])],
>>>>>>> b576ca4874ce02d4ed1973432cc7f55f55af8872
  controllers: [BookingsController],
  providers: [BookingsService],
  exports: [BookingsService],
})
export class BookingsModule {}