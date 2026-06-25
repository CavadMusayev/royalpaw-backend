import { IsUUID, IsString, IsOptional } from 'class-validator';

export class StartConversationDto {
  @IsUUID()
  ownerId!: string;
  @IsUUID()
  caretakerId!: string;
}

export class SendMessageDto {
  @IsUUID()
  conversationId!: string;
  @IsUUID()
  senderId!: string;
  @IsOptional()
  @IsString()
  body?: string;
  @IsOptional()
  @IsString()
  type?: string;
@IsOptional()
  @IsString()
  audioUrl?: string;
  @IsOptional()
  audioDuration?: number;
  @IsOptional()
  @IsString()
  productName?: string;
  @IsOptional()
  @IsString()
  productPhoto?: string;
  @IsOptional()
  productPrice?: number;
  @IsOptional()
  productQty?: number;
  @IsOptional()
  @IsString()
  saleId?: string;
  @IsOptional()
  @IsString()
  saleStatus?: string;
}