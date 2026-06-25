import {
  Injectable,
  ConflictException,
  UnauthorizedException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { OAuth2Client } from 'google-auth-library';
import { User } from '../users/entities/user.entity';
import { RegisterDto, LoginDto } from './dto/auth.dto';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User) private repo: Repository<User>,
    private jwt: JwtService,
  ) {}

  async register(dto: RegisterDto) {
    const exists = await this.repo.findOneBy({ phone: dto.phone });
    if (exists) {
      throw new ConflictException('Bu telefon nömrəsi artıq qeydiyyatdadır');
    }
    const passwordHash = await bcrypt.hash(dto.password, 10);
    const user = this.repo.create({
      role: dto.role,
      firstName: dto.firstName,
      lastName: dto.lastName,
      phone: dto.phone,
      email: dto.email,
      services: dto.services,
      passwordHash,
      kycStatus: 'pending',
    });
    await this.repo.save(user);
    return this.sign(user);
  }



  private googleClient = new OAuth2Client();

  async googleLogin(idToken: string, role?: string) {
    // Google token-i yoxla
    let payload;
    try {
      const ticket = await this.googleClient.verifyIdToken({
        idToken,
        audience: '97806159745-tjtuc15r64m4smt3imapthm49sutc4ia.apps.googleusercontent.com',
      });
      payload = ticket.getPayload();
    } catch (e) {
      throw new UnauthorizedException('Google token yanlışdır');
    }
    if (!payload || !payload.email) {
      throw new UnauthorizedException('Google məlumatı alınmadı');
    }

    // istifadəçi varmı?
    let user = await this.repo.findOneBy({ email: payload.email });
    if (!user) {
      // yeni hesab yarat (Google ilə)
      user = this.repo.create({
        role: role ?? 'owner',
        firstName: payload.given_name ?? 'İstifadəçi',
        lastName: payload.family_name ?? '',
        email: payload.email,
        phone: '',
        passwordHash: '',
        avatarUrl: payload.picture,
        kycStatus: 'pending',
      });
      await this.repo.save(user);
    }

    return this.sign(user);
  }

  
async login(dto: LoginDto) {
  const user = await this.repo.findOne({
    where: [{ phone: dto.phone }, { email: dto.phone }],
  });
  if (!user || !user.passwordHash) {
    throw new UnauthorizedException('Məlumatlar yanlışdır');
  }
  const ok = await bcrypt.compare(dto.password, user.passwordHash);
  if (!ok) {
    throw new UnauthorizedException('Məlumatlar yanlışdır');
  }
  return this.sign(user);
}
async me(userId: string) {
    const user = await this.repo.findOneBy({ id: userId });
    if (!user) return null;
    return {
      id: user.id,
      role: user.role,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      phone: user.phone,
      address: user.address,
      avatarUrl: user.avatarUrl,
    points: user.points,
      membershipTier: user.membershipTier,
      kycStatus: user.kycStatus,
      lastSeen: user.lastSeen,
    commissionDebt: user.commissionDebt ?? 0,
      isSuspended: user.isSuspended ?? false,
      oldestDebtAt: user.oldestDebtAt,
      paymentPending: user.paymentPending ?? false,
    };
  }

  async changePassword(userId: string, oldPassword: string, newPassword: string) {
    const user = await this.repo.findOneBy({ id: userId });
    if (!user || !user.passwordHash) {
      throw new UnauthorizedException('İstifadəçi tapılmadı');
    }
    const ok = await bcrypt.compare(oldPassword, user.passwordHash);
    if (!ok) {
      throw new UnauthorizedException('Cari şifrə yanlışdır');
    }
    user.passwordHash = await bcrypt.hash(newPassword, 10);
    await this.repo.save(user);
    return { ok: true };
  }

  // e-poçtla şifrə sıfırlama (OTP təsdiqindən sonra)
  async resetPassword(email: string, newPassword: string) {
    const user = await this.repo.findOneBy({ email });
    if (!user) {
      throw new NotFoundException('Bu e-poçtla istifadəçi tapılmadı');
    }
    user.passwordHash = await bcrypt.hash(newPassword, 10);
    await this.repo.save(user);
    return { success: true };
  }

  private sign(user: User) {
    const payload = { sub: user.id, role: user.role };
    return {
      accessToken: this.jwt.sign(payload),
      user: {
        id: user.id,
        role: user.role,
        firstName: user.firstName,
        lastName: user.lastName,
        kycStatus: user.kycStatus,
      },
    };
  }
}