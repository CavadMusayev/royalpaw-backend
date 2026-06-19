import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('reviews')
export class Review {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ name: 'booking_id', nullable: true })
  bookingId!: string;

  @Column({ name: 'caretaker_id' })
  caretakerId!: string;

  @Column({ name: 'owner_id' })
  ownerId!: string;

  @Column({ type: 'int' })
  rating!: number;

  @Column({ type: 'text', nullable: true })
  comment!: string;

  @Column({ name: 'pet_photo_url', type: 'text', nullable: true })
  petPhotoUrl!: string;

  @CreateDateColumn({ name: 'created_at' })
  createdAt!: Date;
}