import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('services')
export class ServiceItem {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column()
  name!: string;

  @Column({ type: 'text', nullable: true })
  description!: string;

  @Column({ name: 'price_minor', type: 'int' })
  priceMinor!: number;

  @Column({ default: 'AZN' })
  currency!: string;

  @Column({ default: 'pawPrint' })
  icon!: string;

  @Column({ name: 'image_url', type: 'text', nullable: true })
  imageUrl!: string;

  @Column({ default: 'general' })
  category!: string;

  @Column({ name: 'sort_order', type: 'int', default: 0 })
  sortOrder!: number;

  @Column({ name: 'is_active', default: true })
  isActive!: boolean;

  @CreateDateColumn({ name: 'created_at' })
  createdAt!: Date;
}