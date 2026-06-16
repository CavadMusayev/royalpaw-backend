import { DataSource } from 'typeorm';
import { User } from './users/entities/user.entity';
import { Pet } from './pets/entities/pet.entity';
import { Booking } from './bookings/entities/booking.entity';
import { Conversation } from './chat/entities/conversation.entity';
import { Message } from './chat/entities/message.entity';
import { MonitoringLog } from './monitoring/entities/monitoring-log.entity';

export const AppDataSource = new DataSource({
  type: 'postgres',
  host: '127.0.0.1',
  port: 5433,
  username: 'postgres',
  password: 'postgres',
  database: 'royalpaw',
  synchronize: false,
  entities: [User, Pet, Booking, Conversation, Message, MonitoringLog],
  migrations: ['src/migrations/*.ts'],
});