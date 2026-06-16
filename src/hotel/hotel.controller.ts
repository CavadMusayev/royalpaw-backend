import { Controller, Get, Post, Patch, Delete, Param, Body, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { HotelService } from './hotel.service';
import { CreateRoomDto, UpdateRoomDto, CreateAddonDto, UpdateAddonDto } from './dto/hotel.dto';

@Controller('hotel')
@UseGuards(JwtAuthGuard)
export class HotelController {
  constructor(private hotel: HotelService) {}

  // ROOMS
  @Get('rooms') activeRooms() { return this.hotel.findActiveRooms(); }
  @Get('rooms/all') allRooms() { return this.hotel.findAllRooms(); }
  @Post('rooms') createRoom(@Body() dto: CreateRoomDto) { return this.hotel.createRoom(dto); }
  @Patch('rooms/:id') updateRoom(@Param('id') id: string, @Body() dto: UpdateRoomDto) { return this.hotel.updateRoom(id, dto); }
  @Delete('rooms/:id') removeRoom(@Param('id') id: string) { return this.hotel.removeRoom(id); }

  // ADDONS
  @Get('addons') activeAddons() { return this.hotel.findActiveAddons(); }
  @Get('addons/all') allAddons() { return this.hotel.findAllAddons(); }
  @Post('addons') createAddon(@Body() dto: CreateAddonDto) { return this.hotel.createAddon(dto); }
  @Patch('addons/:id') updateAddon(@Param('id') id: string, @Body() dto: UpdateAddonDto) { return this.hotel.updateAddon(id, dto); }
  @Delete('addons/:id') removeAddon(@Param('id') id: string) { return this.hotel.removeAddon(id); }
}