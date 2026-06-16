import { IsString, IsInt, IsOptional, IsBoolean } from 'class-validator';

export class CreateRoomDto {
  @IsString() name!: string;
  @IsInt() priceMinor!: number;
  @IsOptional() @IsString() description?: string;
  @IsOptional() @IsString() photoUrl?: string;
  @IsOptional() @IsInt() sortOrder?: number;
}

export class UpdateRoomDto {
  @IsOptional() @IsString() name?: string;
  @IsOptional() @IsInt() priceMinor?: number;
  @IsOptional() @IsString() description?: string;
  @IsOptional() @IsString() photoUrl?: string;
  @IsOptional() @IsInt() sortOrder?: number;
  @IsOptional() @IsBoolean() isActive?: boolean;
}

export class CreateAddonDto {
  @IsString() name!: string;
  @IsInt() priceMinor!: number;
  @IsOptional() @IsString() icon?: string;
  @IsOptional() @IsInt() sortOrder?: number;
}

export class UpdateAddonDto {
  @IsOptional() @IsString() name?: string;
  @IsOptional() @IsInt() priceMinor?: number;
  @IsOptional() @IsString() icon?: string;
  @IsOptional() @IsInt() sortOrder?: number;
  @IsOptional() @IsBoolean() isActive?: boolean;
}