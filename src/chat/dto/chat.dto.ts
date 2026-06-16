import { IsUUID, IsString } from 'class-validator';

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

  @IsString()
  body!: string;
}