import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User) private repo: Repository<User>,
  ) {}

  findAll() {
    return this.repo.find({ order: { createdAt: 'DESC' }, take: 100 });
  }

  async findCaretakers(service?: string) {
    const all = await this.repo.find({
      where: { role: 'caretaker', isActive: true },
      order: { createdAt: 'DESC' },
    });
    if (!service) return all;
    return all.filter((u) => (u.services ?? '').split(',').includes(service));
  }

  findOne(id: string) {
    return this.repo.findOneBy({ id });
  }

  async update(id: string, data: Partial<User>) {
    const allowed: Partial<User> = {};
    if (data.firstName !== undefined) allowed.firstName = data.firstName;
    if (data.lastName !== undefined) allowed.lastName = data.lastName;
    if (data.email !== undefined) allowed.email = data.email;
    if (data.address !== undefined) allowed.address = data.address;
    if (data.avatarUrl !== undefined) allowed.avatarUrl = data.avatarUrl;
    await this.repo.update(id, allowed);
    const user = await this.repo.findOneBy({ id });
    if (!user) return null;
    const { passwordHash, ...safe } = user;
    return safe;
  }
  // istifadəçinin son aktivliyini yenilə
  async ping(id: string) {
    await this.repo.update(id, { lastSeen: new Date() });
    return { ok: true };
  }
}

