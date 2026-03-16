import { database } from "../../config/database.js";

export default {
  criarUsuario: (data, trx = null) => {
    const query = trx || database;
    return query("users").insert(data);
  },
  
  listarUsuarios: (accountId) => {
    return database.select('user_id','account_id', 'name', 'email', 'role', 'user_status', 'created_at', 'updated_at').from("users").where({account_id: accountId});
  },

  buscarUsuarioPorID: (userId, accountId) => {
    return database.select('user_id','account_id', 'name', 'email', 'role', 'user_status', 'created_at', 'updated_at').from("users").where({user_id: userId, account_id: accountId});
  },

  buscarEmailDoUsuario: (email) => {
    return database.select('email').from("users").where({email: email}).first();
  },

  atualizarUsuario: (data, userId, accountId) => {
    return database("users").update(data).where({user_id: userId, account_id: accountId});
  },

  deletarUsuario: (userId, accountId) => {
    return database.delete().from("users").where({user_id: userId, account_id: accountId});
  },
};