import { Controller, Post, Get, Param, Body } from '@nestjs/common';
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
  notify(@Param('userId') userId: string, @Body() body: any) {
    return this.commission.notifyPayment(userId, body?.receipt);
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