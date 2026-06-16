import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { MonitoringLog } from './entities/monitoring-log.entity';
import { MonitoringService } from './monitoring.service';
import { MonitoringController } from './monitoring.controller';

@Module({
  imports: [TypeOrmModule.forFeature([MonitoringLog])],
  controllers: [MonitoringController],
  providers: [MonitoringService],
})
export class MonitoringModule {}