import { MigrationInterface, QueryRunner } from 'typeorm';

export class Init1781100000000 implements MigrationInterface {
  name = 'Init1781100000000';

  // Cədvəllər artıq mövcuddur — bu, sadəcə başlanğıc nöqtəsidir.
  public async up(_queryRunner: QueryRunner): Promise<void> {
    // boş — hazırkı baza vəziyyəti təməl kimi qəbul olunur
  }

  public async down(_queryRunner: QueryRunner): Promise<void> {
    // boş
  }
}