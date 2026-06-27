<<<<<<< HEAD
import { Controller, Get, Post, Delete, Param, Body, Query } from '@nestjs/common';
=======
import { Controller, Get, Post, Delete, Param, Body } from '@nestjs/common';
>>>>>>> b576ca4874ce02d4ed1973432cc7f55f55af8872
import { BannersService } from './banners.service';

@Controller('banners')
export class BannersController {
  constructor(private readonly banners: BannersService) {}

  @Get()
<<<<<<< HEAD
  active(@Query('role') role?: string) {
    return this.banners.findActive(role);
  }
=======
  active() {
    return this.banners.findActive();
  }

>>>>>>> b576ca4874ce02d4ed1973432cc7f55f55af8872
  @Get('all')
  all() {
    return this.banners.findAll();
  }
<<<<<<< HEAD
=======

>>>>>>> b576ca4874ce02d4ed1973432cc7f55f55af8872
  @Post()
  create(@Body() data: any) {
    return this.banners.create({
      title: data.title,
      imageUrl: data.imageUrl,
      link: data.link,
      sortOrder: data.sortOrder ?? 0,
<<<<<<< HEAD
      target: data.target ?? 'all',
=======
>>>>>>> b576ca4874ce02d4ed1973432cc7f55f55af8872
    });
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.banners.remove(id);
  }
}
