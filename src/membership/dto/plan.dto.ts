import { IsString, IsInt, IsOptional, IsBoolean } from 'class-validator';

export class CreatePlanDto {
  @IsString()
  name!: string;

  @IsInt()
  priceMinor!: number;

  @IsOptional()
  @IsString()
  period?: string;

  @IsOptional()
  @IsString()
  features?: string;

  @IsOptional()
  @IsBoolean()
  isPopular?: boolean;

  @IsOptional()
  @IsInt()
  sortOrder?: number;
}

export class UpdatePlanDto {
  @IsOptional()
  @IsString()
  name?: string;

  @IsOptional()
  @IsInt()
  priceMinor?: number;

  @IsOptional()
  @IsString()
  period?: string;

  @IsOptional()
  @IsString()
  features?: string;

  @IsOptional()
  @IsBoolean()
  isPopular?: boolean;

  @IsOptional()
  @IsInt()
  sortOrder?: number;

  @IsOptional()
  @IsBoolean()
  isActive?: boolean;
}