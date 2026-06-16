import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('monitoring_logs')
export class MonitoringLog {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ name: 'booking_id' })
  bookingId!: string;

  @Column({ nullable: true })
  note!: string;

  @Column({ name: 'photo_url', nullable: true })
  photoUrl!: string;

  @Column({ type: 'numeric', nullable: true })
  lat!: number;

  @Column({ type: 'numeric', nullable: true })
  lng!: number;

  @CreateDateColumn({ name: 'created_at' })
  createdAt!: Date;
}