import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('products')
export class Product {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column()
  name!: string;

  @Column({ type: 'text', nullable: true })
  description!: string;

  @Column({ nullable: true })
  brand!: string;

  @Column({ name: 'price_minor', type: 'int' })
  priceMinor!: number;

  @Column({ default: 'AZN' })
  currency!: string;

  @Column({ name: 'photo_url', type: 'text', nullable: true })
  photoUrl!: string;

  @Column({ default: 'food' })
  category!: string;

  @Column({ name: 'seller_id', type: 'uuid', nullable: true })
  sellerId!: string;

  @Column({ type: 'numeric', default: 5.0 })
  rating!: number;

  @Column({ type: 'int', default: 0 })
  stock!: number;

  @Column({ name: 'sort_order', type: 'int', default: 0 })
  sortOrder!: number;

  @Column({ name: 'is_active', default: true })
  isActive!: boolean;

  @CreateDateColumn({ name: 'created_at' })
  createdAt!: Date;
}