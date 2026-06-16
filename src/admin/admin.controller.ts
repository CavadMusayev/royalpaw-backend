import { Controller, Get, Patch, Param, Body, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { AdminService } from './admin.service';

@Controller('admin')
@UseGuards(JwtAuthGuard)
export class AdminController {
  constructor(private admin: AdminService) {}

  @Get('stats')
  stats() { return this.admin.getStats(); }

  
@Get('kyc/pending')
  pendingKyc() {
    return this.admin.pendingKyc();
  }


  @Get('users')
  users() { return this.admin.listUsers(); }

  @Patch('users/:id')
  setUser(@Param('id') id: string, @Body() b: { isActive: boolean }) {
    return this.admin.setUserActive(id, b.isActive);
  }

  @Patch('kyc/:id/approve')
  approve(@Param('id') id: string) { return this.admin.reviewKyc(id, 'approved'); }

  @Patch('kyc/:id/reject')
  reject(@Param('id') id: string) { return this.admin.reviewKyc(id, 'rejected'); }
}