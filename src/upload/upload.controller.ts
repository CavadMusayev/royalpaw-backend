import {
  Controller, Post, UploadedFile, UseInterceptors, UseGuards, BadRequestException,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { extname } from 'path';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('upload')
@UseGuards(JwtAuthGuard)
export class UploadController {
  @Post()
  @UseInterceptors(
    FileInterceptor('file', {
      storage: diskStorage({
        destination: './uploads',
        filename: (req, file, cb) => {
          // unikal ad: vaxt + təsadüfi + uzantı
          const unique = Date.now() + '-' + Math.round(Math.random() * 1e9);
          cb(null, `${unique}${extname(file.originalname)}`);
        },
      }),
      fileFilter: (req, file, cb) => {
        // şəkil, audio və ya video (webm audio bəzən video/webm gəlir)
        const ok = file.mimetype.startsWith('image/') ||
                   file.mimetype.startsWith('audio/') ||
                   file.mimetype.startsWith('video/');
        if (!ok) {
          return cb(new BadRequestException('Yalnız şəkil və ya audio faylı olmalıdır'), false);
        }
        cb(null, true);
      },
      limits: { fileSize: 10 * 1024 * 1024 }, // maks 10MB
    }),
  )
  upload(@UploadedFile() file: Express.Multer.File) {
    if (!file) throw new BadRequestException('Fayl yoxdur');
    // qaytarılan link (mobil bunu istifadə edəcək)
    return { url: `/uploads/${file.filename}` };
  }
}