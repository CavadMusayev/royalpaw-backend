import { IsString, IsOptional, IsInt, IsUUID } from 'class-validator';

export class CreatePetDto {
  @IsUUID()
  ownerId!: string;

  @IsString()
  name!: string;

  @IsString()
  species!: string;

  @IsOptional()
  @IsString()
  breed?: string;

  @IsOptional()
  @IsInt()
  ageMonths?: number;

  @IsOptional()
  @IsString()
  notes?: string;

  @IsOptional()
  @IsString()
  photoUrl?: string;
}