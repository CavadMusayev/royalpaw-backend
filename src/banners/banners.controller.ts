import { Controller, Get, Post, Delete, Param, Body, Query } from '@nestjs/common';
import { BannersService } from './banners.service';

@Controller('banners')
export class BannersController {
  constructor(private readonly banners: BannersService) {}

  @Get()
  active(@Query('role') role?: string) {
    return this.banners.findActive(role);
  }
  @Get('all')
  all() {
    return this.banners.findAll();
  }
  @Post()
  create(@Body() data: any) {
    return this.banners.create({
      title: data.title,
      imageUrl: data.imageUrl,
      link: data.link,
      sortOrder: data.sortOrder ?? 0,
      target: data.target ?? 'all',
    });
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.banners.remove(id);
  }
}
