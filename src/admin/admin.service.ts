import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../users/entities/user.entity';

@Injectable()
export class AdminService {
  constructor(
    @InjectRepository(User) private users: Repository<User>,
  ) {}

  async getStats() {
    const totalUsers = await this.users.count();
    const caretakers = await this.users.count({ where: { role: 'caretaker' } });
    const owners = await this.users.count({ where: { role: 'owner' } });
    const pendingKyc = await this.users.count({ where: { kycStatus: 'in_review' } });
    return { totalUsers, caretakers, owners, pendingKyc, activeBookings: 0, revenueMinor: 0, openComplaints: 0 };
  }

  listUsers() {
    return this.users.find({ order: { createdAt: 'DESC' }, take: 100 });
  }

  setUserActive(id: string, isActive: boolean) {
    return this.users.update(id, { isActive });
  }

  reviewKyc(id: string, status: 'approved' | 'rejected') {
    return this.users.update(id, { kycStatus: status });
  }
}