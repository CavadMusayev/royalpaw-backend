import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('product_events')
export class ProductEvent {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ name: 'product_id', type: 'uuid' })
  productId!: string;

  @Column({ name: 'seller_id', type: 'uuid', nullable: true })
  sellerId!: string;

  @Column({ name: 'event_type', type: 'text' })
  eventType!: string; // view | cart_add | cart_remove

  @CreateDateColumn({ name: 'created_at' })
  createdAt!: Date;
}