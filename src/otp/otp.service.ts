import { Injectable, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, MoreThan } from 'typeorm';
import * as nodemailer from 'nodemailer';
import { OtpCode } from './entities/otp.entity';

@Injectable()
export class OtpService {
  private transporter: nodemailer.Transporter;

  constructor(
    @InjectRepository(OtpCode) private repo: Repository<OtpCode>,
  ) {
    this.transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: process.env.MAIL_USER,
        pass: process.env.MAIL_PASS,
      },
    });
  }

  // 6 rəqəmli kod yarat + e-poçt göndər
  async sendCode(email: string) {
    const code = Math.floor(100000 + Math.random() * 900000).toString();
    const expiresAt = new Date(Date.now() + 10 * 60 * 1000); // 10 dəq

    const otp = this.repo.create({ email, code, expiresAt, used: false });
    await this.repo.save(otp);

    try {
      await this.transporter.sendMail({
        from: `"Royal Paw" <${process.env.MAIL_USER}>`,
        to: email,
        subject: 'Royal Paw - Təsdiq kodu',
        html: `
          <div style="font-family: sans-serif; max-width: 480px; margin: auto; padding: 30px; background: #0A0F0A; border-radius: 16px; color: #F5F7F4;">
            <h2 style="color: #C9F31D;">🐾 Royal Paw</h2>
            <p>Təsdiq kodunuz:</p>
            <div style="font-size: 36px; font-weight: bold; letter-spacing: 8px; color: #C9F31D; text-align: center; padding: 20px; background: #161B16; border-radius: 12px; margin: 16px 0;">
              ${code}
            </div>
            <p style="color: #9BA89B; font-size: 13px;">Kod 10 dəqiqə ərzində etibarlıdır. Bu kodu heç kimlə paylaşmayın.</p>
          </div>
        `,
      });
    } catch (e) {
      console.error('E-poçt göndərilmədi:', e);
      throw new BadRequestException('E-poçt göndərilə bilmədi');
    }

    return { ok: true, message: 'Kod e-poçtunuza göndərildi' };
  }

  // kodu yoxla
  async verifyCode(email: string, code: string) {
    const otp = await this.repo.findOne({
      where: { email, code, used: false, expiresAt: MoreThan(new Date()) },
      order: { createdAt: 'DESC' },
    });
    if (!otp) {
      throw new BadRequestException('Kod yanlış və ya vaxtı keçib');
    }
    otp.used = true;
    await this.repo.save(otp);
    return { ok: true };
  }
}