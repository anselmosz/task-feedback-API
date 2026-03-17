import surveysService from "./surveys.service.js";
import { asyncHandler } from "../../utils/asyncHandler.js";

export default {
  criarPesquisa: asyncHandler(async (req, res) => {
    const pesquisa = await surveysService.criarPesquisa(req.body, req.user.accountId, req.user.userId);

    return res.status(201).json({message: "Pesquisa criada", pesquisa});
  }),

  listarPesquisas: asyncHandler(async (req, res) => {
    const pesquisas = await surveysService.listarPesquisas(req.user.accountId);

    return res.status(200).json({surveys: pesquisas});
  }),
}