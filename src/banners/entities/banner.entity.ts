import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('banners')
export class Banner {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ nullable: true })
  title!: string;

  @Column({ name: 'image_url', type: 'text' })
  imageUrl!: string;

  @Column({ nullable: true })
  link!: string;

<<<<<<< HEAD
 @Column({ name: 'sort_order', type: 'int', default: 0 })
  sortOrder!: number;
  @Column({ default: 'all' })
  target!: string;   // all | owner | caretaker
=======
  @Column({ name: 'sort_order', type: 'int', default: 0 })
  sortOrder!: number;

>>>>>>> b576ca4874ce02d4ed1973432cc7f55f55af8872
  @Column({ name: 'is_active', default: true })
  isActive!: boolean;

  @CreateDateColumn({ name: 'created_at' })
  createdAt!: Date;
}