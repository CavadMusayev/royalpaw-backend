import { Controller, Get, Post, Patch, Delete, Param, Body, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { ProductsService } from './products.service';
import { CreateProductDto, UpdateProductDto } from './dto/product.dto';

@Controller('products')
@UseGuards(JwtAuthGuard)
export class ProductsController {
  constructor(private products: ProductsService) {}

  @Get()
  active() {
    return this.products.findActive();
  }

  @Get('all')
  all() {
    return this.products.findAll();
  }

  @Get('seller/:sellerId')
  bySeller(@Param('sellerId') sellerId: string) {
    return this.products.findBySeller(sellerId);
  }

  @Post()
  create(@Body() dto: CreateProductDto) {
    return this.products.create(dto);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() dto: UpdateProductDto) {
    return this.products.update(id, dto);
  }

 @Delete(':id')
  remove(@Param('id') id: string) {
    return this.products.remove(id);
  }

  // məhsulun şəkilləri
  @Get(':id/images')
  images(@Param('id') id: string) {
    return this.products.getImages(id);
  }

  // şəkil əlavə et
  @Post(':id/images')
  addImage(@Param('id') id: string, @Body() body: any) {
    return this.products.addImage(id, body.imageUrl);
  }

// şəkil sil
  @Delete('images/:imageId')
  removeImage(@Param('imageId') imageId: string) {
    return this.products.removeImage(imageId);
  }

  // hadisə qeyd et
  @Post(':id/track')
  track(@Param('id') id: string, @Body() body: any) {
    return this.products.trackEvent(id, body.eventType);
  }

  // satıcının analitikası
  @Get('seller/:sellerId/analytics')
  analytics(@Param('sellerId') sellerId: string) {
    return this.products.sellerAnalytics(sellerId);
  }
}