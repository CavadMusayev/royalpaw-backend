import { Controller, Get, Post, Delete, Patch, Body, Param, Query, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { PetsService } from './pets.service';
import { CreatePetDto } from './dto/create-pet.dto';
import { UpdatePetDto } from './dto/update-pet.dto';

@Controller('pets')
@UseGuards(JwtAuthGuard)
export class PetsController {
  constructor(private pets: PetsService) {}

  @Post()
  create(@Body() dto: CreatePetDto) {
    return this.pets.create(dto);
  }

  @Get()
  findAll(@Query('ownerId') ownerId?: string) {
    return ownerId ? this.pets.findByOwner(ownerId) : this.pets.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.pets.findOne(id);
  }

 @Patch(':id')
  update(@Param('id') id: string, @Body() dto: UpdatePetDto) {
    return this.pets.update(id, dto);
  }
  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.pets.remove(id);
  }
}