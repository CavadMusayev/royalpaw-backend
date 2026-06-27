import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Banner } from './entities/banner.entity';

@Injectable()
export class BannersService {
  constructor(
    @InjectRepository(Banner) private repo: Repository<Banner>,
  ) {}

<<<<<<< HEAD
// aktiv bannerlər (mobil üçün, rola görə)
  findActive(role?: string) {
    const qb = this.repo.createQueryBuilder('b')
      .where('b.is_active = true');
    if (role === 'owner' || role === 'caretaker') {
      // həm hamıya, həm də həmin rola aid bannerlər
      qb.andWhere("(b.target = 'all' OR b.target = :role)", { role });
    }
    return qb.orderBy('b.sort_order', 'ASC').getMany();
=======
  // aktiv bannerlər (mobil üçün)
  findActive() {
    return this.repo.find({ where: { isActive: true }, order: { sortOrder: 'ASC' } });
>>>>>>> b576ca4874ce02d4ed1973432cc7f55f55af8872
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