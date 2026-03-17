import jwt from 'jsonwebtoken';
import { jwtConfig } from '../config/env.js';

export const gerarToken = (data) => {
  const token = jwt.sign( 
    {
      userId: data.userId,
      accountId: data.accountId,
      role: data.role
    },
  
    jwtConfig.jwtSecret,
    { expiresIn: jwtConfig.jwtExpiresIn }
  );

  return token;
} 