import { Controller, Post, Body } from '@nestjs/common';
import { OtpService } from './otp.service';

@Controller('otp')
export class OtpController {
  constructor(private readonly otp: OtpService) {}

  @Post('send')
  send(@Body() body: { email: string }) {
    return this.otp.sendCode(body.email);
  }

  @Post('verify')
  verify(@Body() body: { email: string; code: string }) {
    return this.otp.verifyCode(body.email, body.code);
  }
}