import { IsString, IsOptional, IsInt, IsUUID, IsNumber } from 'class-validator';

export class UpdatePetDto {
  @IsOptional()
  @IsString()
  name?: string;
  @IsOptional()
  @IsString()
  species?: string;
  @IsOptional()
  @IsString()
  breed?: string;
  @IsOptional()
  @IsInt()
  ageMonths?: number;
  @IsOptional()
  @IsNumber()
  weightKg?: number;
  @IsOptional()
  @IsString()
  notes?: string;
  @IsOptional()
  @IsString()
  photoUrl?: string;
}