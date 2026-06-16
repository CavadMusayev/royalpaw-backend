import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('pets')
export class Pet {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ name: 'owner_id' })
  ownerId!: string;

  @Column()
  name!: string;

  @Column()
  species!: string;

  @Column({ nullable: true })
  breed!: string;

  @Column({ name: 'age_months', type: 'smallint', nullable: true })
  ageMonths!: number;

  @Column({ name: 'weight_kg', type: 'numeric', nullable: true })
  weightKg!: number;

  @Column({ name: 'photo_url', nullable: true })
  photoUrl!: string;

  @Column({ nullable: true })
  notes!: string;

  @CreateDateColumn({ name: 'created_at' })
  createdAt!: Date;
}