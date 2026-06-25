import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('bookings')
export class Booking {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ name: 'owner_id' })
  ownerId!: string;

  @Column({ name: 'caretaker_id' })
  caretakerId!: string;

  @Column({ name: 'pet_id', nullable: true })
  petId!: string;

  @Column({ name: 'service_type' })
  serviceType!: string;       // boarding | walking | home_care | feeding

  @Column({ default: 'pending' })
  status!: string;            // pending | accepted | in_progress | completed | cancelled

  @Column({ name: 'scheduled_start', type: 'timestamptz' })
  scheduledStart!: Date;

  @Column({ name: 'scheduled_end', type: 'timestamptz', nullable: true })
  scheduledEnd!: Date;

  @Column({ name: 'amount_minor', type: 'int' })
  amountMinor!: number;       // qəpiklə (məs. 4500 = 45.00 AZN)

  @Column({ default: 'AZN' })
  currency!: string;

 @Column({ name: 'live_lat', type: 'double precision', nullable: true })
  liveLat!: number;
  @Column({ name: 'live_lng', type: 'double precision', nullable: true })
  liveLng!: number;
  @Column({ name: 'live_updated_at', type: 'timestamptz', nullable: true })
  liveUpdatedAt!: Date;
  @Column({ name: 'tracking_active', default: false })
  trackingActive!: boolean;

  @CreateDateColumn({ name: 'created_at' })
  createdAt!: Date;
}