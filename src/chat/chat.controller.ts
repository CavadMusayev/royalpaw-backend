import { Controller, Get, Post, Body, Param, Query, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { ChatService } from './chat.service';
import { StartConversationDto, SendMessageDto } from './dto/chat.dto';

@Controller('chat')
@UseGuards(JwtAuthGuard)
export class ChatController {
  constructor(private chat: ChatService) {}

  // Söhbət başlat / mövcudu al
  @Post('conversations')
  start(@Body() dto: StartConversationDto) {
    return this.chat.startConversation(dto);
  }

  // İstifadəçinin söhbətləri
  @Get('conversations')
  list(@Query('userId') userId: string) {
    return this.chat.getConversations(userId);
  }

  // Söhbətin mesajları
  @Get('conversations/:id/messages')
  messages(@Param('id') id: string) {
    return this.chat.getMessages(id);
  }

  // Mesaj göndər
  @Post('messages')
  send(@Body() dto: SendMessageDto) {
    return this.chat.sendMessage(dto);
  }
}