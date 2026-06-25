import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Conversation } from './entities/conversation.entity';
import { Message } from './entities/message.entity';
import { User } from '../users/entities/user.entity';
import { StartConversationDto, SendMessageDto } from './dto/chat.dto';
import { NotificationsService } from '../notifications/notifications.service';


@Injectable()
export class ChatService {
 constructor(
    @InjectRepository(Conversation) private convRepo: Repository<Conversation>,
    @InjectRepository(Message) private msgRepo: Repository<Message>,
    @InjectRepository(User) private userRepo: Repository<User>,
    private notifications: NotificationsService,
  ) {}

  // Söhbət yarat (əgər artıq varsa, mövcudu qaytar)
  async startConversation(dto: StartConversationDto) {
    let conv = await this.convRepo.findOne({
      where: { ownerId: dto.ownerId, caretakerId: dto.caretakerId },
    });
    if (!conv) {
      conv = this.convRepo.create(dto);
      await this.convRepo.save(conv);
    }
    return conv;
  }

  // İstifadəçinin bütün söhbətləri (həm sahib, həm qulluqçu kimi)
  async getConversations(userId: string) {
    const convs = await this.convRepo
      .createQueryBuilder('c')
      .where('c.owner_id = :id OR c.caretaker_id = :id', { id: userId })
      .orderBy('c.last_message_at', 'DESC', 'NULLS LAST')
      .getMany();

    // hər söhbətə qarşı tərəfin adı + avatarı əlavə et
    const result: any[] = [];
    for (const c of convs) {
      const otherId = c.ownerId === userId ? c.caretakerId : c.ownerId;
      const other = await this.userRepo.findOneBy({ id: otherId });
      result.push({
        ...c,
        otherUserId: otherId,
        otherName: other ? `${other.firstName} ${other.lastName}` : 'İstifadəçi',
        otherAvatar: other?.avatarUrl ?? null,
      });
    }
    return result;
  }

  // Bir söhbətin mesajları
  getMessages(conversationId: string) {
    return this.msgRepo.find({
      where: { conversationId },
      order: { createdAt: 'ASC' },
    });
  }

  // Qarşı tərəfin mesajlarını oxundu işarələ (mən = reader)
  async markRead(conversationId: string, readerId: string) {
    await this.msgRepo
      .createQueryBuilder()
      .update(Message)
      .set({ readAt: new Date() })
      .where('conversation_id = :cid', { cid: conversationId })
      .andWhere('sender_id != :rid', { rid: readerId })
      .andWhere('read_at IS NULL')
      .execute();
    return { ok: true };
  }


  // istifadəçinin bütün söhbətlərində ona gələn oxunmamış mesaj sayı
async unreadCount(userId: string) {
    // istifadəçinin söhbətləri (find ilə, raw SQL yox)
    const convs = await this.convRepo.find({
      where: [{ ownerId: userId }, { caretakerId: userId }],
    });

    if (convs.length === 0) return { count: 0 };
    const convIds = convs.map((c) => c.id);

    // həmin söhbətlərdə başqasının göndərdiyi, oxunmamış mesajlar
    const count = await this.msgRepo
      .createQueryBuilder('m')
      .where('m.conversationId IN (:...ids)', { ids: convIds })
      .andWhere('m.senderId != :uid', { uid: userId })
      .andWhere('m.readAt IS NULL')
      .getCount();

    return { count };
  }

  // Mesaj göndər
async sendMessage(dto: SendMessageDto) {
    const msg = this.msgRepo.create(dto);
    await this.msgRepo.save(msg);
    await this.convRepo.update(dto.conversationId, { lastMessageAt: new Date() });

    // qarşı tərəfə bildiriş yarat
    const conv = await this.convRepo.findOneBy({ id: dto.conversationId });
    if (conv) {
      // göndərən kimdirsə, qarşı tərəf alıcıdır
      const recipientId = conv.ownerId === dto.senderId ? conv.caretakerId : conv.ownerId;
const isAudio = dto.type === 'audio';
      await this.notifications.create({
        userId: recipientId,
        title: 'Yeni mesaj',
        body: isAudio
            ? '🎤 Səsli mesaj'
            : ((dto.body && dto.body.length > 50) ? `${dto.body.substring(0, 50)}...` : (dto.body || '')),
        icon: 'messageCircle',
      });
    }

    return msg;
  }}