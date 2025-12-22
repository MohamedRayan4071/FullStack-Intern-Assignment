import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { TypeOrmModule, TypeOrmModuleOptions } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { dbConfig } from './dbConfig/database.config';
import { TaskModule } from './task/task.module';

@Module({
  imports: [TaskModule, ConfigModule.forRoot(
    { load: [dbConfig] }
  ), TypeOrmModule.forRootAsync({
    imports: [ConfigModule], inject: [ConfigService], useFactory: (configService: ConfigService): TypeOrmModuleOptions => {
      return configService.get<TypeOrmModuleOptions>("db")!
    },
  }), TaskModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule { }