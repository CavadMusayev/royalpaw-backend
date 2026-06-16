import { Controller, Get, Post, Patch, Param, Body, Query, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { NotificationsService } from './notifications.service';
import { CreateNotificationDto } from './dto/notification.dto';

@Controller('notifications')
@UseGuards(JwtAuthGuard)
export class NotificationsController {
  constructor(private notifications: NotificationsService) {}

  // istifadəçinin bildirişləri
  @Get()
  forUser(@Query('userId') userId: string) {
    return this.notifications.forUser(userId);
  }

  // oxunmamış say
  @Get('unread')
  unread(@Query('userId') userId: string) {
    return this.notifications.unreadCount(userId);
  }

  // admin: bütün bildirişlər
  @Get('all')
  all() {
    return this.notifications.findAll();
  }

  // bildiriş yarat (admin)
  @Post()
  create(@Body() dto: CreateNotificationDto) {
    return this.notifications.create(dto);
  }

  // oxundu işarələ
  @Patch(':id/read')
  markRead(@Param('id') id: string) {
    return this.notifications.markRead(id);
  }
}