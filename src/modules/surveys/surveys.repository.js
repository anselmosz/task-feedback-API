import { database } from "../../config/database.js";

export default {
  criarPesquisa: (data, trx = null) => {
    const query = trx || database;
    return query("surveys").insert(data);
  },

  listarPesquisas: (accountId) => {
    return database.select().from("surveys").where({account_id: accountId});
  },
}