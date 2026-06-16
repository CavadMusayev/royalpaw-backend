import { IsUUID, IsString, IsOptional, IsNumber } from 'class-validator';

export class CreateLogDto {
  @IsUUID()
  bookingId!: string;

  @IsOptional()
  @IsString()
  note?: string;

  @IsOptional()
  @IsString()
  photoUrl?: string;

  @IsOptional()
  @IsNumber()
  lat?: number;

  @IsOptional()
  @IsNumber()
  lng?: number;
}