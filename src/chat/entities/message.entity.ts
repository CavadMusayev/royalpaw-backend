import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('messages')
export class Message {
  @PrimaryGeneratedColumn()
  id!: number;

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

  @Column({ name: 'read_at', type: 'timestamptz', nullable: true })
  readAt!: Date;

  @CreateDateColumn({ name: 'created_at' })
  createdAt!: Date;
}