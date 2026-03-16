import express from 'express'
import cors from 'cors';
import userRoutes from './modules/users/users.routes.js';
import authRoutes from './modules/auth/auth.routes.js';

const app = express();

app.use(cors());
app.use(express.json());

// Rotas
app.use("/users", userRoutes);
app.use("/auth", authRoutes);

export default app;