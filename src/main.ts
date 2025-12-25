import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { ExpressAdapter } from '@nestjs/platform-express';
import express from 'express';

let cachedServer: any;

const bootstrapServer = async () => {
  if (!cachedServer) {
    const expressApp = express();
    const app = await NestFactory.create(AppModule, new ExpressAdapter(expressApp));
    app.useGlobalPipes(
      new ValidationPipe({
        whitelist: true,
        forbidNonWhitelisted: true,
        transform: true,
      }),
    );
    await app.init();
    cachedServer = expressApp;
  }
  return cachedServer;
};

export default async function handler(req: any, res: any) {
  const server = await bootstrapServer();
  return server(req, res);
}

if (!process.env.VERCEL) {
  (async () => {
    const app = await NestFactory.create(AppModule);
    app.useGlobalPipes(
      new ValidationPipe({
        whitelist: true,
        forbidNonWhitelisted: true,
        transform: true,
      }),
    );
    const port = process.env.PORT ?? 3000;
    await app.listen(port);
    console.log(`App running locally on http://localhost:${port}`);
  })();
}
