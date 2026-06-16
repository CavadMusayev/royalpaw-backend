import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { MembershipPlan } from './entities/membership-plan.entity';
import { CreatePlanDto, UpdatePlanDto } from './dto/plan.dto';

@Injectable()
export class MembershipService {
  constructor(
    @InjectRepository(MembershipPlan) private repo: Repository<MembershipPlan>,
  ) {}

  // hamı üçün: aktiv planlar, sıra ilə
  findActive() {
    return this.repo.find({
      where: { isActive: true },
      order: { sortOrder: 'ASC' },
    });
  }

  // admin üçün: bütün planlar
  findAll() {
    return this.repo.find({ order: { sortOrder: 'ASC' } });
  }

  create(dto: CreatePlanDto) {
    const plan = this.repo.create(dto);
    return this.repo.save(plan);
  }

  async update(id: string, dto: UpdatePlanDto) {
    const plan = await this.repo.findOneBy({ id });
    if (!plan) throw new NotFoundException('Plan tapılmadı');
    Object.assign(plan, dto);
    return this.repo.save(plan);
  }

  async remove(id: string) {
    const plan = await this.repo.findOneBy({ id });
    if (!plan) throw new NotFoundException('Plan tapılmadı');
    await this.repo.remove(plan);
    return { deleted: true };
  }
}