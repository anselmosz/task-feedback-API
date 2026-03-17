import jwt from "jsonwebtoken";
import { jwtConfig } from "../config/env.js";

export const decodeToken = (req, res, next) => {
    const tokenHeader = req.headers['authorization'];
    if (!tokenHeader) return res.status(403).json({message: "Token não informado"});

    const [, token] = tokenHeader.split(" ");

    try {
      const decoded = jwt.verify(token, jwtConfig.jwtSecret);
      req.user = decoded;
      next(); 
    }
    catch {
      return res.status(403).json({message: "Token inválido"});
    }
  };


export const adminOnly = (req, res, next) => {
  // verifica se o campo "acesso" do token contém admin para liberar o acesso
  if (req.user.role !== "admin") return res.status(403).json({message: "Acesso negado, somente administradores podem realizar esta ação"});
  next();
};

// Verifica o usuário e o seu nível de acesso
export const validateIsTheAdminOrUser = (req, res, next) => {
  const {userId, role} = req.user;
  const idParam = Number(req.params.id);

  // verifica se o acesso do usuario é "admin"
  if (role === "admin") return next();

  // valida se o acesso do usuario é "user" e se o ID no path é igual ao do payload do token
  if(role === "member" && userId === idParam) return next();

  return res.status(403).json({message: "Acesso negado - Você não possui permissão para executar esta ação"})
};