import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('payments')
export class Payment {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ name: 'booking_id' })
  bookingId!: string;

  @Column({ name: 'amount_minor', type: 'int' })
  amountMinor!: number;

  @Column({ default: 'AZN' })
  currency!: string;

  @Column({ default: 'requires_payment' })
  status!: string;   // requires_payment | held_in_escrow | released | refunded

  @Column({ name: 'held_at', type: 'timestamptz', nullable: true })
  heldAt!: Date;

  @Column({ name: 'released_at', type: 'timestamptz', nullable: true })
  releasedAt!: Date;

  @Column({ name: 'refunded_at', type: 'timestamptz', nullable: true })
  refundedAt!: Date;

  @CreateDateColumn({ name: 'created_at' })
  createdAt!: Date;
}