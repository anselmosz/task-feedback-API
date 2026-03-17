import surveysRepository from "./surveys.repository.js";
import { AppError } from "../../utils/AppError.js"

export default {
  criarPesquisa: async (data, accountId, userId) => {
    if (!accountId || !data.title || !userId) throw new AppError("Campos orbigatórios para criação de pesquisa faltando", 400);

    const payload = {
      account_id: accountId,
      title: data.title,
      description: data.description,
      created_by: userId
    };

    const [pesquisa] = await surveysRepository.criarPesquisa(payload);

    return { survey_id: pesquisa, ...payload }
  },

  listarPesquisas: async (accountId) => {
    if (!accountId) throw new AppError("Conta não informada", 400);

    const pesquisas = await surveysRepository.listarPesquisas(accountId);
    if (!pesquisas || pesquisas.length === 0) throw new AppError("Pesquisas não encontradas", 404);

    return pesquisas;
  },
}