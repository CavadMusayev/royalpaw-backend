import { IsString, IsEnum, MinLength, IsOptional } from 'class-validator';

export class RegisterDto {
  @IsEnum(['owner', 'caretaker'])
  role!: string;

  @IsString()
  firstName!: string;

  @IsString()
  lastName!: string;

  @IsString()
  phone!: string;

  @IsString()
  @MinLength(6)
  password!: string;

  @IsOptional()
  @IsString()
  email?: string;
}

export class LoginDto {
  @IsString()
  phone!: string;

  @IsString()
  password!: string;
}