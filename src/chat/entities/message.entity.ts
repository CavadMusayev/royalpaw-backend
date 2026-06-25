import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('messages')
export class Message {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ name: 'conversation_id' })
  conversationId!: string;

  @Column({ name: 'sender_id' })
  senderId!: string;

@Column({ nullable: true })
  body!: string;

  @Column({ default: 'text' })
  type!: string;   // text | audio

  @Column({ name: 'audio_url', type: 'text', nullable: true })
  audioUrl!: string;

 @Column({ name: 'audio_duration', type: 'int', nullable: true })
  audioDuration!: number;
  @Column({ name: 'product_name', type: 'text', nullable: true })
  productName!: string;
  @Column({ name: 'product_photo', type: 'text', nullable: true })
  productPhoto!: string;
  @Column({ name: 'product_price', type: 'int', nullable: true })
  productPrice!: number;
 @Column({ name: 'product_qty', type: 'int', nullable: true })
  productQty!: number;
  @Column({ name: 'sale_id', type: 'uuid', nullable: true })
  saleId!: string;
  @Column({ name: 'sale_status', type: 'text', nullable: true })
  saleStatus!: string;
  @Column({ name: 'read_at', type: 'timestamptz', nullable: true })
  readAt!: Date;
  @Column({ default: false })
  edited!: boolean;

  @CreateDateColumn({ name: 'created_at' })
  createdAt!: Date;
}