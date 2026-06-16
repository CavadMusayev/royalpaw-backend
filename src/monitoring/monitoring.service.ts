import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { MonitoringLog } from './entities/monitoring-log.entity';
import { CreateLogDto } from './dto/create-log.dto';

@Injectable()
export class MonitoringService {
  constructor(
    @InjectRepository(MonitoringLog) private repo: Repository<MonitoringLog>,
  ) {}

  // qulluqçu yeni qeyd əlavə edir
  create(dto: CreateLogDto) {
    const log = this.repo.create(dto);
    return this.repo.save(log);
  }

  // bir sifarişin nəzarət timeline-ı (sahib görür)
  findByBooking(bookingId: string) {
    return this.repo.find({
      where: { bookingId },
      order: { createdAt: 'DESC' },
    });
  }
}