import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ServiceItem } from './entities/service.entity';
import { CreateServiceDto, UpdateServiceDto } from './dto/service.dto';

@Injectable()
export class ServicesCatalogService {
  constructor(
    @InjectRepository(ServiceItem) private repo: Repository<ServiceItem>,
  ) {}

  findActive() {
    return this.repo.find({ where: { isActive: true }, order: { sortOrder: 'ASC' } });
  }

  findAll() {
    return this.repo.find({ order: { sortOrder: 'ASC' } });
  }

  create(dto: CreateServiceDto) {
    return this.repo.save(this.repo.create(dto));
  }

  async update(id: string, dto: UpdateServiceDto) {
    const item = await this.repo.findOneBy({ id });
    if (!item) throw new NotFoundException('Xidmət tapılmadı');
    Object.assign(item, dto);
    return this.repo.save(item);
  }

  async remove(id: string) {
    const item = await this.repo.findOneBy({ id });
    if (!item) throw new NotFoundException('Xidmət tapılmadı');
    await this.repo.remove(item);
    return { deleted: true };
  }
}