import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { HotelRoom } from './entities/hotel-room.entity';
import { HotelAddon } from './entities/hotel-addon.entity';
import { HotelService } from './hotel.service';
import { HotelController } from './hotel.controller';

@Module({
  imports: [TypeOrmModule.forFeature([HotelRoom, HotelAddon])],
  controllers: [HotelController],
  providers: [HotelService],
})
export class HotelModule {}