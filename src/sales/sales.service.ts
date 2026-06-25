import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Sale } from './entities/sale.entity';
import { User } from '../users/entities/user.entity';

@Injectable()
export class SalesService {
  constructor(
    @InjectRepository(Sale) private repo: Repository<Sale>,
    @InjectRepository(User) private userRepo: Repository<User>,
  ) {}

  // satış yarat (alıcı təsdiqi gözləyir)
  async create(data: {
    sellerId: string; buyerId: string; conversationId?: string;
    productName: string; productPhoto?: string; amountMinor: number; qty?: number;
  }) {
    const qty = data.qty ?? 1;
    const total = data.amountMinor * qty;
    const commission = Math.round(total * 0.05); // 5%
    const sale = this.repo.create({
      sellerId: data.sellerId,
      buyerId: data.buyerId,
      conversationId: data.conversationId,
      productName: data.productName,
      productPhoto: data.productPhoto,
      amountMinor: total,
      qty,
      commissionMinor: commission,
      status: 'pending',
    });
    return this.repo.save(sale);
  }

 // tərəf təsdiqləyir (role: 'buyer' | 'seller', answer: 'yes' | 'no')
  async respond(saleId: string, role: string, answer: string) {
    const sale = await this.repo.findOneBy({ id: saleId });
    if (!sale) throw new NotFoundException('Satış tapılmadı');
    if (sale.status === 'confirmed' || sale.status === 'cancelled') return sale;

    if (role === 'buyer') sale.buyerConfirmed = answer;
    else if (role === 'seller') sale.sellerConfirmed = answer;

    // "no" deyən tərəfin imtina sayğacını artır
    if (answer === 'no') {
      const uid = role === 'buyer' ? sale.buyerId : sale.sellerId;
      const u = await this.userRepo.findOneBy({ id: uid });
      if (u) { u.refusalCount = (u.refusalCount ?? 0) + 1; await this.userRepo.save(u); }
    }

    const b = sale.buyerConfirmed;
    const s = sale.sellerConfirmed;

    // hər ikisi cavab verib
    if (b !== 'pending' && s !== 'pending') {
      if (b === 'yes' && s === 'yes') {
        // təsdiq → komissiya + qazanc
        sale.status = 'confirmed';
        sale.confirmedAt = new Date();
        const seller = await this.userRepo.findOneBy({ id: sale.sellerId });
        if (seller) {
          seller.totalEarnings = (seller.totalEarnings ?? 0) + sale.amountMinor;
          seller.commissionDebt = (seller.commissionDebt ?? 0) + sale.commissionMinor;
          if (!seller.oldestDebtAt && sale.commissionMinor > 0) seller.oldestDebtAt = new Date();
          await this.userRepo.save(seller);
        }
      } else if (b === 'no' && s === 'no') {
        // ikisi də yox → ləğv
        sale.status = 'cancelled';
      } else {
        // ziddiyyət → admin
        sale.status = 'dispute';
        sale.dispute = true;
      }
    }
    await this.repo.save(sale);
    return sale;
  }

  // satışı tap (status üçün)
  findById(saleId: string) {
    return this.repo.findOneBy({ id: saleId });
  }

  // ziddiyyətli satışlar (admin)
  findDisputes() {
    return this.repo.find({ where: { dispute: true }, order: { createdAt: 'DESC' } });
  }

  // admin ziddiyyəti həll edir (resolve: 'confirm' | 'cancel')
  async resolveDispute(saleId: string, resolve: string) {
    const sale = await this.repo.findOneBy({ id: saleId });
    if (!sale) throw new NotFoundException('Satış tapılmadı');
    sale.dispute = false;
    if (resolve === 'confirm') {
      sale.status = 'confirmed';
      sale.confirmedAt = new Date();
      const seller = await this.userRepo.findOneBy({ id: sale.sellerId });
      if (seller) {
        seller.totalEarnings = (seller.totalEarnings ?? 0) + sale.amountMinor;
        seller.commissionDebt = (seller.commissionDebt ?? 0) + sale.commissionMinor;
        if (!seller.oldestDebtAt && sale.commissionMinor > 0) seller.oldestDebtAt = new Date();
        await this.userRepo.save(seller);
      }
    } else {
      sale.status = 'cancelled';
    }
    await this.repo.save(sale);
    return sale;
  }

  // satıcının satışları
  findBySeller(sellerId: string) {
    return this.repo.find({ where: { sellerId }, order: { createdAt: 'DESC' } });
  }

  // satıcının ümumi təsdiqlənmiş qazancı
  async earningsForSeller(sellerId: string) {
    const seller = await this.userRepo.findOneBy({ id: sellerId });
    return { totalEarnings: (seller?.totalEarnings ?? 0) };
  }
}