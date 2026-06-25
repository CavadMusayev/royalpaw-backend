import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('sales')
export class Sale {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ name: 'seller_id' })
  sellerId!: string;

  @Column({ name: 'buyer_id' })
  buyerId!: string;

  @Column({ name: 'conversation_id', nullable: true })
  conversationId!: string;

  @Column({ name: 'product_name', type: 'text' })
  productName!: string;

  @Column({ name: 'product_photo', type: 'text', nullable: true })
  productPhoto!: string;

  @Column({ name: 'amount_minor', type: 'int' })
  amountMinor!: number;

  @Column({ type: 'int', default: 1 })
  qty!: number;

  @Column({ name: 'commission_minor', type: 'int', default: 0 })
  commissionMinor!: number;

 @Column({ default: 'pending' })
  status!: string;   // pending | confirmed | cancelled | dispute

  @Column({ name: 'buyer_confirmed', default: 'pending' })
  buyerConfirmed!: string;   // pending | yes | no

  @Column({ name: 'seller_confirmed', default: 'pending' })
  sellerConfirmed!: string;  // pending | yes | no

  @Column({ default: false })
  dispute!: boolean;

  @CreateDateColumn({ name: 'created_at' })
  createdAt!: Date;

  @Column({ name: 'confirmed_at', type: 'timestamptz', nullable: true })
  confirmedAt!: Date;
}