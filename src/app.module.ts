import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UsersModule } from './users/users.module';      // ← YENİ
import { AuthModule } from './auth/auth.module';          // ← YENİ
import { AdminModule } from './admin/admin.module';
import { PetsModule } from './pets/pets.module'
import { BookingsModule } from './bookings/bookings.module';
import { ChatModule } from './chat/chat.module';
import { MonitoringModule } from './monitoring/monitoring.module';
import { PaymentsModule } from './payments/payments.module';
import { UploadModule } from './upload/upload.module';
import { MembershipModule } from './membership/membership.module';
import { ServicesCatalogModule } from './services-catalog/services-catalog.module';
import { ProductsModule } from './products/products.module';
import { HotelModule } from './hotel/hotel.module';
import { NotificationsModule } from './notifications/notifications.module';
import { ReviewsModule } from './reviews/reviews.module';
import { OtpModule } from './otp/otp.module';
import { BannersModule } from './banners/banners.module';
import { ScheduleModule } from '@nestjs/schedule';
import { CommissionModule } from './commission/commission.module';
import { PaymentCardModule } from './payment-card/payment-card.module';
import { SalesModule } from './sales/sales.module';

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
    PetsModule,         // ← YENİ
    BookingsModule,     // ← YENİ
    ChatModule,         // ← YENİ
    MonitoringModule,   // ← YENİ
    PaymentsModule,
    UploadModule,
    MembershipModule,
    ServicesCatalogModule,
    ProductsModule,
    HotelModule,
    NotificationsModule,
    NotificationsModule,
    ReviewsModule,
    ReviewsModule,
    OtpModule,
    OtpModule,
    BannersModule,
    ScheduleModule.forRoot(),
    BannersModule,
    CommissionModule,
    CommissionModule,
    PaymentCardModule,
    SalesModule,
  ],
})
export class AppModule {}