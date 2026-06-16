import { IsUUID, IsString, IsInt, IsDateString, IsOptional } from 'class-validator';

export class CreateBookingDto {
  @IsUUID()
  ownerId!: string;

  @IsUUID()
  caretakerId!: string;

  @IsOptional()
  @IsUUID()
  petId?: string;

  @IsString()
  serviceType!: string;

  @IsDateString()
  scheduledStart!: string;

  @IsInt()
  amountMinor!: number;
}