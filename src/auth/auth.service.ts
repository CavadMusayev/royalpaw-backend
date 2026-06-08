import {
  Injectable,
  ConflictException,
  UnauthorizedException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
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
      passwordHash,
      kycStatus: 'pending',
    });
    await this.repo.save(user);
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