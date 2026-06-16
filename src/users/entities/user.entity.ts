import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ type: 'varchar' })
  role!: string;

  @Column({ name: 'first_name' })
  firstName!: string;

@Column({ name: 'password_hash', nullable: true })   // ← YENİ
  passwordHash!: string;  


  @Column({ name: 'last_name' })
  lastName!: string;

  @Column({ nullable: true })
  patronymic!: string;

  @Column({ unique: true, nullable: true })
  email!: string;

  @Column({ unique: true, nullable: true })
  phone!: string;

  @Column({ name: 'id_card_serial', nullable: true })
  idCardSerial!: string;

  @Column({ nullable: true })
  address!: string;

  @Column({ name: 'avatar_url', nullable: true })
  avatarUrl!: string;

  @Column({ name: 'is_phone_verified', default: false })
  isPhoneVerified!: boolean;

  @Column({ name: 'kyc_status', type: 'varchar', default: 'pending' })
  kycStatus!: string;

  @Column({ name: 'is_active', default: true })
  isActive!: boolean;

  @CreateDateColumn({ name: 'created_at' })
  createdAt!: Date;

  @Column({ type: 'int', default: 0 })
  points!: number;

  @Column({ name: 'membership_tier', default: 'free' })
  membershipTier!: string;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt!: Date;
}