import usersService from "./users.service.js";
import { asyncHandler } from "../../utils/asyncHandler.js";

export default {
  criarUsuario: asyncHandler(async (req, res) => {
    const usuario = await usersService.criarUsuario(req.body, req.user.accountId);

    return res.status(201).json({message: "Usuario criado com sucesso", usuario});
  }),

  listarUsuarios: asyncHandler(async (req, res) => {
    const usuarios = await usersService.listarUsuarios(req.user.accountId);

    return res.status(200).json({usuarios})
  }),

  buscarUsuarioPorID: asyncHandler(async (req, res) => {
    const usuario = await usersService.buscarUsuarioPorID(req.params.id, req.user.accountId);

    return res.status(200).json({usuario});
  }),

  atualizarDadosDoUsuario: asyncHandler(async (req, res) => {
    const resultado = await usersService.atualizarDadosDoUsuario(req.body, req.params.id, req.user.accountId);

    return res.status(200).json({message: "Dados do usuario atualizados com sucesso!", usuario: resultado});
  }),

  excluirUsuario: asyncHandler(async (req, res) => {
    const resultado = await usersService.excluirUsuario(req.params.id, req.user.accountId);
    
    return res.status(200).json({message: "dados do usuário apagados", result: resultado});
  }),

  ativarUsuario: asyncHandler(async (req, res) => {
    await usersService.ativarUsuario(req.params.id, req.user.accountId, req.user.userId);

    return res.status(200).json({message: "Usuário ativado"});
  }),
  
  desativarUsuario: asyncHandler(async (req, res) => {
    await usersService.desativarUsuario(req.params.id, req.user.accountId, req.user.userId);

    return res.status(200).json({message: "Usuário desativado"});
  })
};