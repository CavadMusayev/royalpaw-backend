import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('membership_plans')
export class MembershipPlan {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column()
  name!: string;

  @Column({ name: 'price_minor', type: 'int' })
  priceMinor!: number;

  @Column({ default: 'AZN' })
  currency!: string;

  @Column({ default: 'monthly' })
  period!: string;

  @Column({ type: 'text', nullable: true })
  features!: string;

  @Column({ name: 'is_popular', default: false })
  isPopular!: boolean;

  @Column({ name: 'sort_order', type: 'int', default: 0 })
  sortOrder!: number;

  @Column({ name: 'is_active', default: true })
  isActive!: boolean;

  @CreateDateColumn({ name: 'created_at' })
  createdAt!: Date;
}