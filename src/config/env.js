import dotenv from 'dotenv';
import path from 'path';

const envFile = `.env.${process.env.NODE_ENV || "development"}`;

dotenv.config({
  path: path.resolve(process.cwd(), envFile)
});

export const env = process.env.NODE_ENV;

export const dbConfig = {
  client: process.env.DB_CLIENT,
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  name: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD
}

export const jwtConfig = {
  jwtSecret: process.env.JWT_SECRET
}