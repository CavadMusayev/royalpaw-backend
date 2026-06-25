import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { OtpCode } from './entities/otp.entity';
import { OtpService } from './otp.service';
import { OtpController } from './otp.controller';

@Module({
  imports: [TypeOrmModule.forFeature([OtpCode])],
  controllers: [OtpController],
  providers: [OtpService],
  exports: [OtpService],
})
export class OtpModule {}