import { Controller, Get, Param, Patch, Body, UseGuards, Query, Post } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { UsersService } from './users.service';

@Controller('users')               // → /api/v1/users
export class UsersController {
  constructor(private readonly users: UsersService) {}

  @Get()
  findAll() {
    return this.users.findAll();
  }


  @Get('caretakers')
  caretakers(@Query('service') service?: string) {
    return this.users.findCaretakers(service);
  }

  @UseGuards(JwtAuthGuard)
  @Post(':id/ping')
  ping(@Param('id') id: string) {
    return this.users.ping(id);
  }
  
  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.users.findOne(id);
  }
  @UseGuards(JwtAuthGuard)
  @Patch(':id')
  update(@Param('id') id: string, @Body() data: any) {
    return this.users.update(id, data);
  }
}