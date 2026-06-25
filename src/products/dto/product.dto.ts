import { IsString, IsInt, IsOptional, IsBoolean, IsNumber } from 'class-validator';

export class CreateProductDto {
  @IsString()
  name!: string;

  @IsInt()
  priceMinor!: number;

  @IsOptional() @IsString()
  description?: string;

  @IsOptional() @IsString()
  brand?: string;

  @IsOptional() @IsString()
  photoUrl?: string;

  @IsOptional() @IsString()
  category?: string;

  @IsOptional() @IsString()
  sellerId?: string;

  @IsOptional() @IsNumber()
  rating?: number;

  @IsOptional() @IsInt()
  stock?: number;

  @IsOptional() @IsInt()
  sortOrder?: number;
}

export class UpdateProductDto {
  @IsOptional() @IsString()
  name?: string;

  @IsOptional() @IsInt()
  priceMinor?: number;

  @IsOptional() @IsString()
  description?: string;

  @IsOptional() @IsString()
  brand?: string;

  @IsOptional() @IsString()
  photoUrl?: string;

  @IsOptional() @IsString()
  category?: string;

  @IsOptional() @IsString()
  sellerId?: string;

  @IsOptional() @IsNumber()
  rating?: number;

  @IsOptional() @IsInt()
  stock?: number;

  @IsOptional() @IsInt()
  sortOrder?: number;

  @IsOptional() @IsBoolean()
  isActive?: boolean;
}