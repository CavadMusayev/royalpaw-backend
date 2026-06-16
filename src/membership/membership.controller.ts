import { Controller, Get, Post, Patch, Delete, Param, Body, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { MembershipService } from './membership.service';
import { CreatePlanDto, UpdatePlanDto } from './dto/plan.dto';

@Controller('membership-plans')
@UseGuards(JwtAuthGuard)
export class MembershipController {
  constructor(private membership: MembershipService) {}

  // hamı üçün: aktiv planlar
  @Get()
  active() {
    return this.membership.findActive();
  }

  // admin üçün: bütün planlar
  @Get('all')
  all() {
    return this.membership.findAll();
  }

  @Post()
  create(@Body() dto: CreatePlanDto) {
    return this.membership.create(dto);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() dto: UpdatePlanDto) {
    return this.membership.update(id, dto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.membership.remove(id);
  }
}