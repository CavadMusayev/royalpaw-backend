import { Controller, Post, Body, Get, UseGuards, Request } from '@nestjs/common';
import { AuthService } from './auth.service';
import { RegisterDto, LoginDto } from './dto/auth.dto';
import { JwtAuthGuard } from './jwt-auth.guard';

@Controller('auth')
export class AuthController {
  constructor(private auth: AuthService) {}

  @Post('register')
  register(@Body() dto: RegisterDto) {
    return this.auth.register(dto);
  }

  @Post('login')
  login(@Body() dto: LoginDto) {
    return this.auth.login(dto);
  }

@UseGuards(JwtAuthGuard)
@Get('me')
  me(@Request() req: any) {
    return this.auth.me(req.user.id);
  }

  @UseGuards(JwtAuthGuard)
  @Post('change-password')
  changePassword(@Request() req: any, @Body() body: any) {
    return this.auth.changePassword(req.user.id, body.oldPassword, body.newPassword);
  }


  @Post('reset-password')
  resetPassword(@Body() body: { email: string; newPassword: string }) {
    return this.auth.resetPassword(body.email, body.newPassword);
  }

@Post('google')
  google(@Body() body: { idToken: string; role?: string }) {
    return this.auth.googleLogin(body.idToken, body.role);
  }



}


