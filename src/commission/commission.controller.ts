import { Controller, Post, Get, Param } from '@nestjs/common';
import { CommissionService } from './commission.service';

@Controller('commission')
export class CommissionController {
  constructor(private readonly commission: CommissionService) {}

  // admin: borcu ödənildi kimi qeyd et
  @Post('settle/:userId')
  settle(@Param('userId') userId: string) {
    return this.commission.settleDebt(userId);
  }

  @Post('notify/:userId')
  notify(@Param('userId') userId: string) {
    return this.commission.notifyPayment(userId);
  }

  @Get('debts')
  debts() {
    return this.commission.getAllDebts();
  }

  // test: yoxlamanı dərhal işə sal
  @Post('check-now')
  checkNow() {
    return this.commission.runCheckNow();
  }
}