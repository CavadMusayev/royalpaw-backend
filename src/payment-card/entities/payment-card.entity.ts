import { Entity, PrimaryGeneratedColumn, Column, UpdateDateColumn } from 'typeorm';

@Entity('payment_card')
export class PaymentCard {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ name: 'card_number', nullable: true })
  cardNumber!: string;

  @Column({ name: 'holder_name', nullable: true })
  holderName!: string;

  @Column({ nullable: true })
  expiry!: string;

  @Column({ name: 'bank_name', nullable: true })
  bankName!: string;

  @Column({ nullable: true })
  iban!: string;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt!: Date;
}