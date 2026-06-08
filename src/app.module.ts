import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UsersModule } from './users/users.module';      // ← YENİ
import { AuthModule } from './auth/auth.module';          // ← YENİ
import { AdminModule } from './admin/admin.module';


@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: '127.0.0.1',
      port: 5433,
      username: 'postgres',
      password: 'postgres',
      database: 'royalpaw',
      autoLoadEntities: true,
      synchronize: false,
    }),
    UsersModule,        // ← YENİ
    AuthModule,         // ← YENİ
    AdminModule,        // ← YENİ
  ],
})
export class AppModule {}