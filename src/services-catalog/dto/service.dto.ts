import { IsString, IsInt, IsOptional, IsBoolean } from 'class-validator';

export class CreateServiceDto {
  @IsString()
  name!: string;

  @IsInt()
  priceMinor!: number;

  @IsOptional() @IsString()
  description?: string;

 @IsOptional() @IsString()
  icon?: string;
  @IsOptional() @IsString()
  imageUrl?: string;
  @IsOptional() @IsString()
  category?: string;
  @IsOptional() @IsInt()
  sortOrder?: number;
}

export class UpdateServiceDto {
  @IsOptional() @IsString()
  name?: string;

  @IsOptional() @IsInt()
  priceMinor?: number;

  @IsOptional() @IsString()
  description?: string;

@IsOptional() @IsString()
  icon?: string;
  @IsOptional() @IsString()
  imageUrl?: string;
  @IsOptional() @IsString()
  category?: string;
  @IsOptional() @IsInt()
  sortOrder?: number;
  @IsOptional() @IsBoolean()
  isActive?: boolean;
}