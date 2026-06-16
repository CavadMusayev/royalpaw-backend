import { Controller, Get, Post, Patch, Delete, Param, Body, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { ServicesCatalogService } from './services-catalog.service';
import { CreateServiceDto, UpdateServiceDto } from './dto/service.dto';

@Controller('services')
@UseGuards(JwtAuthGuard)
export class ServicesCatalogController {
  constructor(private svc: ServicesCatalogService) {}

  @Get()
  active() {
    return this.svc.findActive();
  }

  @Get('all')
  all() {
    return this.svc.findAll();
  }

  @Post()
  create(@Body() dto: CreateServiceDto) {
    return this.svc.create(dto);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() dto: UpdateServiceDto) {
    return this.svc.update(id, dto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.svc.remove(id);
  }
}