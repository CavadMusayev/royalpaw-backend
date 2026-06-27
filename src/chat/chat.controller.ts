import { Controller, Get, Post, Body, Param, Query, UseGuards, Delete, Patch } from '@nestjs/common';
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

  // istifadəçinin oxunmamış mesaj sayı
  @Get('unread-count/:userId')
  unreadCount(@Param('userId') userId: string) {
    return this.chat.unreadCount(userId);
  }
  
  // Söhbətin mesajları
  @Get('conversations/:id/messages')
  messages(@Param('id') id: string) {
    return this.chat.getMessages(id);
  }

  // Mesajları oxundu işarələ
  @Post('conversations/:id/read')
  markRead(@Param('id') id: string, @Body() body: any) {
    return this.chat.markRead(id, body.readerId);
  }



<<<<<<< HEAD
// Mesaj göndər
=======

  // Mesaj göndər
>>>>>>> b576ca4874ce02d4ed1973432cc7f55f55af8872
  @Post('messages')
  send(@Body() dto: SendMessageDto) {
    return this.chat.sendMessage(dto);
  }

  // söhbəti sil
  @Delete('conversations/:id')
  deleteConversation(@Param('id') id: string) {
    return this.chat.deleteConversation(id);
  }

  // mesaj sil
  @Delete('messages/:id')
  deleteMessage(@Param('id') id: string) {
    return this.chat.deleteMessage(id);
  }

  // mesaj redaktə
  @Patch('messages/:id')
  editMessage(@Param('id') id: string, @Body() body: any) {
    return this.chat.editMessage(id, body.body);
  }
}