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

findCaretakers() {
    return this.repo.find({
      where: { role: 'caretaker', isActive: true },
      order: { createdAt: 'DESC' },
    });
    
  }
  findOne(id: string) {
    return this.repo.findOneBy({ id });
  }
}

