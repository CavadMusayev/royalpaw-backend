import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.setGlobalPrefix('api/v1');                 // bütün route-lar /api/v1/...
  app.enableCors({ origin: '*' });               // admin panelin qoşulması üçün
  app.useGlobalPipes(new ValidationPipe({ whitelist: true }));
  await app.listen(3000);
  console.log('🚀 http://localhost:3000/api/v1');
}
bootstrap();