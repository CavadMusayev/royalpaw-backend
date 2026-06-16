import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Pet } from './entities/pet.entity';
import { CreatePetDto } from './dto/create-pet.dto';

@Injectable()
export class PetsService {
  constructor(
    @InjectRepository(Pet) private repo: Repository<Pet>,
  ) {}

  create(dto: CreatePetDto) {
    const pet = this.repo.create(dto);
    return this.repo.save(pet);
  }

  findAll() {
    return this.repo.find({ order: { createdAt: 'DESC' } });
  }

  findByOwner(ownerId: string) {
    return this.repo.find({ where: { ownerId } });
  }

  findOne(id: string) {
    return this.repo.findOneBy({ id });
  }

  remove(id: string) {
    return this.repo.delete(id);
  }
}