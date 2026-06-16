import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { AppModule } from './app.module';
import { join } from 'path';
import { NestExpressApplication } from '@nestjs/platform-express';


async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);
  app.setGlobalPrefix('api/v1');                 // bütün route-lar /api/v1/...
  app.enableCors({ origin: '*' });               // admin panelin qoşulması üçün
  app.useGlobalPipes(new ValidationPipe({ whitelist: true }));
  // yüklənmiş şəkilləri statik göstər
  app.useStaticAssets(join(__dirname, '..', 'uploads'), {
    prefix: '/uploads/',
  });
 await app.listen(3000, '0.0.0.0');
  console.log('🚀 http://localhost:3000/api/v1');
}
bootstrap();