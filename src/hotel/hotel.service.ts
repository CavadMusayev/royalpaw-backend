import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { HotelRoom } from './entities/hotel-room.entity';
import { HotelAddon } from './entities/hotel-addon.entity';
import { CreateRoomDto, UpdateRoomDto, CreateAddonDto, UpdateAddonDto } from './dto/hotel.dto';

@Injectable()
export class HotelService {
  constructor(
    @InjectRepository(HotelRoom) private rooms: Repository<HotelRoom>,
    @InjectRepository(HotelAddon) private addons: Repository<HotelAddon>,
  ) {}

  // --- ROOMS ---
  findActiveRooms() {
    return this.rooms.find({ where: { isActive: true }, order: { sortOrder: 'ASC' } });
  }
  findAllRooms() {
    return this.rooms.find({ order: { sortOrder: 'ASC' } });
  }
  createRoom(dto: CreateRoomDto) {
    return this.rooms.save(this.rooms.create(dto));
  }
  async updateRoom(id: string, dto: UpdateRoomDto) {
    const r = await this.rooms.findOneBy({ id });
    if (!r) throw new NotFoundException('Otaq tapılmadı');
    Object.assign(r, dto);
    return this.rooms.save(r);
  }
  async removeRoom(id: string) {
    const r = await this.rooms.findOneBy({ id });
    if (!r) throw new NotFoundException('Otaq tapılmadı');
    await this.rooms.remove(r);
    return { deleted: true };
  }

  // --- ADDONS ---
  findActiveAddons() {
    return this.addons.find({ where: { isActive: true }, order: { sortOrder: 'ASC' } });
  }
  findAllAddons() {
    return this.addons.find({ order: { sortOrder: 'ASC' } });
  }
  createAddon(dto: CreateAddonDto) {
    return this.addons.save(this.addons.create(dto));
  }
  async updateAddon(id: string, dto: UpdateAddonDto) {
    const a = await this.addons.findOneBy({ id });
    if (!a) throw new NotFoundException('Əlavə tapılmadı');
    Object.assign(a, dto);
    return this.addons.save(a);
  }
  async removeAddon(id: string) {
    const a = await this.addons.findOneBy({ id });
    if (!a) throw new NotFoundException('Əlavə tapılmadı');
    await this.addons.remove(a);
    return { deleted: true };
  }
}