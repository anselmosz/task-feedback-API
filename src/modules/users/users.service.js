import bcrypt from "bcrypt"
import { AppError } from "../../utils/AppError.js";
import usersRepository from "./users.repository.js";
import { database } from "../../config/database.js";

export default {
  criarUsuario: async (data, accountId) => {    
    if (Object.keys(data).length === 0) throw new AppError("O body não pode estar vazio!", 400);
    
    const validarEmail = await usersRepository.buscarEmailDoUsuario(data.email);
    if (validarEmail) throw new AppError("Já existe usuário com este email", 400);

    if (!data.name || !data.email || !data.senha) throw new AppError("Campos obrigatórios para criar usuário pendentes", 400);
    
    const SALT_ROUNDS = 10; // número de rounds para o bcrypt - pode ser alterado conforme a necessidade
    
    // gera o hash da senha utilizando bcrypt e o número de rounds definido
    const senhaHash = await bcrypt.hash(data.senha, SALT_ROUNDS);

    const payload = {
      account_id: accountId,
      name: data.name,
      email: data.email,
      password_hash: senhaHash,
      role: data.role
    };

    const [resultado] = await usersRepository.criarUsuario(payload);
    
    return {
      user_id: resultado, 
      ...payload
    };
  },

  listarUsuarios: async (accountId) => {
    const usuarios = await usersRepository.listarUsuarios(accountId);
    if (!usuarios || usuarios === null || usuarios.length === 0) throw new AppError("Usuários não encontrados", 404);

    return usuarios;
  },

  buscarUsuarioPorID: async (userId, accountId) => {
    const usuario = await usersRepository.buscarUsuarioPorID(userId, accountId);
    if (!usuario || usuario === null ||usuario.length === 0) throw new AppError("Usuário não encontrado", 404);

    return usuario;
  },

  atualizarDadosDoUsuario: async (data, userId, accountId) => {
    if (Object.keys(data).length === 0) throw new AppError("O body não pode estar vazio!", 400);
    
    if (!data.role && !data.name && !data.email) throw new AppError("Atualize pelo menos um dado do usuario!", 400);

    const payload = {
      name: data.name,
      email: data.email,
      role: data.role
    }

    const resultado = await usersRepository.atualizarUsuario(payload, userId, accountId);

    if (!resultado || resultado.length === 0) throw new AppError("Usuário não encontrado", 404);

    const usuario = await usersRepository.buscarUsuarioPorID(userId, accountId);

    return {usuario: usuario};
  },

  excluirUsuario: async(userId, accountId) => {
    const resultado = await usersRepository.deletarUsuario(userId, accountId);

    if (!resultado) throw new AppError("Usuario não encontrado!", 404);

    return resultado;
  },

  ativarUsuario: async(userId, accountId, userIdLogged) => {
    if (userId == userIdLogged) throw new AppError("Você não pode inativar seu perfil", 400);

    const resultado = await usersRepository.ativarUsuario(userId, accountId);
    
    if (!resultado) throw new AppError("Usuario não encontrado!", 404);

    return resultado;
  },

  desativarUsuario: async(userId, accountId, userIdLogged) => {
    if (userId == userIdLogged) throw new AppError("Você não pode inativar seu perfil", 400);

    const resultado = await usersRepository.desativarUsuario(userId, accountId);

    if (!resultado) throw new AppError("Usuario não encontrado!", 404);

    return resultado;
  },
};