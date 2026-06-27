<<<<<<< HEAD
import { Controller, Post, Get, Param, Body } from '@nestjs/common';
=======
import { Controller, Post, Get, Param } from '@nestjs/common';
>>>>>>> b576ca4874ce02d4ed1973432cc7f55f55af8872
import { CommissionService } from './commission.service';

@Controller('commission')
export class CommissionController {
  constructor(private readonly commission: CommissionService) {}

  // admin: borcu ödənildi kimi qeyd et
  @Post('settle/:userId')
  settle(@Param('userId') userId: string) {
    return this.commission.settleDebt(userId);
  }

<<<<<<< HEAD
@Post('notify/:userId')
  notify(@Param('userId') userId: string, @Body() body: any) {
    return this.commission.notifyPayment(userId, body?.receipt);
=======
  @Post('notify/:userId')
  notify(@Param('userId') userId: string) {
    return this.commission.notifyPayment(userId);
>>>>>>> b576ca4874ce02d4ed1973432cc7f55f55af8872
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