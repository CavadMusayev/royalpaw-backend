import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Product } from './entities/product.entity';
import { ProductImage } from './entities/product-image.entity';
import { ProductEvent } from './entities/product-event.entity';
import { CreateProductDto, UpdateProductDto } from './dto/product.dto';

@Injectable()
export class ProductsService {
 constructor(
    @InjectRepository(Product) private repo: Repository<Product>,
    @InjectRepository(ProductImage) private imgRepo: Repository<ProductImage>,
    @InjectRepository(ProductEvent) private eventRepo: Repository<ProductEvent>,
  ) {}

  findActive() {
    return this.repo.find({ where: { isActive: true }, order: { sortOrder: 'ASC' } });
  }

  // bir satıcının məhsulları
  findBySeller(sellerId: string) {
    return this.repo.find({ where: { sellerId }, order: { createdAt: 'DESC' } });
  }
  
  findAll() {
    return this.repo.find({ order: { sortOrder: 'ASC' } });
  }

  create(dto: CreateProductDto) {
    return this.repo.save(this.repo.create(dto));
  }

  async update(id: string, dto: UpdateProductDto) {
    const item = await this.repo.findOneBy({ id });
    if (!item) throw new NotFoundException('Məhsul tapılmadı');
    Object.assign(item, dto);
    return this.repo.save(item);
  }

async remove(id: string) {
    const item = await this.repo.findOneBy({ id });
    if (!item) throw new NotFoundException('Məhsul tapılmadı');
    await this.repo.remove(item);
    return { deleted: true };
  }

  // məhsula şəkil əlavə et
  async addImage(productId: string, imageUrl: string) {
    const count = await this.imgRepo.count({ where: { productId } });
    const img = this.imgRepo.create({ productId, imageUrl, sortOrder: count });
    return this.imgRepo.save(img);
  }

  // məhsulun şəkilləri
  getImages(productId: string) {
    return this.imgRepo.find({ where: { productId }, order: { sortOrder: 'ASC' } });
  }

 // şəkil sil
  async removeImage(imageId: string) {
    const img = await this.imgRepo.findOneBy({ id: imageId });
    if (!img) throw new NotFoundException('Şəkil tapılmadı');
    await this.imgRepo.remove(img);
    return { deleted: true };
  }

  // hadisə qeyd et (view / cart_add / cart_remove)
  async trackEvent(productId: string, eventType: string) {
    const product = await this.repo.findOneBy({ id: productId });
    const ev = this.eventRepo.create({
      productId,
      sellerId: product?.sellerId,
      eventType,
    });
    return this.eventRepo.save(ev);
  }

  // satıcının analitikası (son 30 gün)
  async sellerAnalytics(sellerId: string) {
    const since = new Date();
    since.setDate(since.getDate() - 30);

    // hadisələr (view, cart_add, cart_remove)
    const events = await this.eventRepo
      .createQueryBuilder('e')
      .where('e.seller_id = :sellerId', { sellerId })
      .andWhere('e.created_at >= :since', { since })
      .getMany();

    const views = events.filter((e) => e.eventType === 'view').length;
    const cartAdds = events.filter((e) => e.eventType === 'cart_add').length;
    const cartRemoves = events.filter((e) => e.eventType === 'cart_remove').length;

    // məhsul başına baxış (ən çox tələbatlı)
    const viewsByProduct: Record<string, number> = {};
    for (const e of events) {
      if (e.eventType === 'view') {
        viewsByProduct[e.productId] = (viewsByProduct[e.productId] ?? 0) + 1;
      }
    }

    // satıcının məhsulları (ad üçün)
    const products = await this.repo.find({ where: { sellerId } });
    const topProducts = Object.entries(viewsByProduct)
      .map(([pid, count]) => {
        const p = products.find((x) => x.id === pid);
        return { productId: pid, name: p?.name ?? 'Silinmiş məhsul', photoUrl: p?.photoUrl ?? null, views: count };
      })
      .sort((a, b) => b.views - a.views)
      .slice(0, 5);

    return {
      views,
      cartAdds,
      cartRemoves,
      productCount: products.length,
      topProducts,
    };
  }
}