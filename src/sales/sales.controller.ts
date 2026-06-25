import { Controller, Get, Post, Body, Param, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { SalesService } from './sales.service';

@Controller('sales')
@UseGuards(JwtAuthGuard)
export class SalesController {
  constructor(private sales: SalesService) {}

  // satış yarat
  @Post()
  create(@Body() body: any) {
    return this.sales.create({
      sellerId: body.sellerId,
      buyerId: body.buyerId,
      conversationId: body.conversationId,
      productName: body.productName,
      productPhoto: body.productPhoto,
      amountMinor: body.amountMinor,
      qty: body.qty,
    });
  }

 // tərəf cavab verir (buyer/seller, yes/no)
  @Post(':id/respond')
  respond(@Param('id') id: string, @Body() body: any) {
    return this.sales.respond(id, body.role, body.answer);
  }

 // ziddiyyətli satışlar (admin) — :id-dən ƏVVƏL olmalıdır
  @Get('admin/disputes')
  disputes() {
    return this.sales.findDisputes();
  }

  // satışın statusu
  @Get(':id')
  byId(@Param('id') id: string) {
    return this.sales.findById(id);
  }

  // admin ziddiyyəti həll edir
  @Post(':id/resolve')
  resolve(@Param('id') id: string, @Body() body: any) {
    return this.sales.resolveDispute(id, body.resolve);
  }

  // satıcının satışları
  @Get('seller/:sellerId')
  bySeller(@Param('sellerId') sellerId: string) {
    return this.sales.findBySeller(sellerId);
  }

  // satıcının qazancı
  @Get('seller/:sellerId/earnings')
  earnings(@Param('sellerId') sellerId: string) {
    return this.sales.earningsForSeller(sellerId);
  }
}