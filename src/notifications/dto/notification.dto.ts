import { IsString, IsOptional, IsUUID } from 'class-validator';

export class CreateNotificationDto {
  @IsOptional() @IsUUID()
  userId?: string;   // boş olarsa hamıya

  @IsString()
  title!: string;

  @IsOptional() @IsString()
  body?: string;

@IsOptional() @IsString()
  icon?: string;
  @IsOptional() @IsString()
  link?: string;
}