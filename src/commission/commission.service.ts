import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, LessThan } from 'typeorm';
import { User } from '../users/entities/user.entity';

@Injectable()
export class CommissionService {
  private readonly logger = new Logger('CommissionService');

  constructor(
    @InjectRepository(User) private userRepo: Repository<User>,
  ) {}

  // hər gün gecə saat 2-də işləyir
  @Cron(CronExpression.EVERY_DAY_AT_2AM)
  async checkOverdueDebts() {
    this.logger.log('Komissiya borcları yoxlanılır...');

    // 15 gün əvvəlki tarix
    const fifteenDaysAgo = new Date();
    fifteenDaysAgo.setDate(fifteenDaysAgo.getDate() - 15);

    // borcu olan + 15 gündən köhnə + hələ suspend olunmamış qulluqçular
    const overdue = await this.userRepo.find({
      where: {
        oldestDebtAt: LessThan(fifteenDaysAgo),
        isSuspended: false,
      },
    });

    let count = 0;
    for (const user of overdue) {
      if ((user.commissionDebt ?? 0) > 0) {
        user.isSuspended = true;
        await this.userRepo.save(user);
        count++;
        this.logger.log(`Qulluqçu suspend edildi: ${user.firstName} (borc: ${user.commissionDebt})`);
      }
    }

    this.logger.log(`Yoxlama bitdi. ${count} qulluqçu suspend edildi.`);
  }

  // admin borcu ödənildi kimi qeyd edir → borc sıfırlanır, aktiv olur
  async settleDebt(userId: string) {
    const user = await this.userRepo.findOneBy({ id: userId });
    if (!user) return null;
    user.commissionDebt = 0;
    user.oldestDebtAt = null as any;
    user.isSuspended = false;
    user.paymentPending = false;
<<<<<<< HEAD
    user.paymentReceipt = null as any;
=======
>>>>>>> b576ca4874ce02d4ed1973432cc7f55f55af8872
    return this.userRepo.save(user);
  }


  

<<<<<<< HEAD
 // qulluqçu "ödədim" bildirir (çek şəkli ilə)
  async notifyPayment(userId: string, receipt?: string) {
    const user = await this.userRepo.findOneBy({ id: userId });
    if (!user) return null;
    user.paymentPending = true;
    if (receipt) user.paymentReceipt = receipt;
=======
  // qulluqçu "ödədim" bildirir
  async notifyPayment(userId: string) {
    const user = await this.userRepo.findOneBy({ id: userId });
    if (!user) return null;
    user.paymentPending = true;
>>>>>>> b576ca4874ce02d4ed1973432cc7f55f55af8872
    return this.userRepo.save(user);
  }
// bütün qulluqçuların komissiya məlumatı (admin)
  async getAllDebts() {
    const caretakers = await this.userRepo.find({
      where: { role: 'caretaker' },
      order: { commissionDebt: 'DESC' },
    });
    return caretakers.map((c) => ({
      id: c.id,
      firstName: c.firstName,
      lastName: c.lastName,
      phone: c.phone,
      avatarUrl: c.avatarUrl,
<<<<<<< HEAD
   commissionDebt: c.commissionDebt ?? 0,
      isSuspended: c.isSuspended ?? false,
      oldestDebtAt: c.oldestDebtAt,
      paymentPending: c.paymentPending ?? false,
      paymentReceipt: c.paymentReceipt ?? null,
=======
    commissionDebt: c.commissionDebt ?? 0,
      isSuspended: c.isSuspended ?? false,
      oldestDebtAt: c.oldestDebtAt,
      paymentPending: c.paymentPending ?? false,
>>>>>>> b576ca4874ce02d4ed1973432cc7f55f55af8872
    }));
  }

  
  
  // əl ilə yoxlama (test üçün)
  async runCheckNow() {
    await this.checkOverdueDebts();
    return { checked: true };
  }
}