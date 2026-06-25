import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Banner } from './entities/banner.entity';

@Injectable()
export class BannersService {
  constructor(
    @InjectRepository(Banner) private repo: Repository<Banner>,
  ) {}

  // aktiv bannerlər (mobil üçün)
  findActive() {
    return this.repo.find({ where: { isActive: true }, order: { sortOrder: 'ASC' } });
  }

  // hamısı (admin üçün)
  findAll() {
    return this.repo.find({ order: { sortOrder: 'ASC' } });
  }

  create(data: Partial<Banner>) {
    return this.repo.save(this.repo.create(data));
  }

  async remove(id: string) {
    const item = await this.repo.findOneBy({ id });
    if (!item) throw new NotFoundException('Banner tapılmadı');
    await this.repo.remove(item);
    return { deleted: true };
  }
}