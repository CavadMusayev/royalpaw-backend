import { IsUUID, IsInt } from 'class-validator';

export class CreatePaymentDto {
  @IsUUID()
  bookingId!: string;

  @IsInt()
  amountMinor!: number;
}