import knex from "knex";
import knexfile from "../../knexfile";

// Define qual é o tipo de ambiente rodando - utiliza o ambiente do NODE_ENV (definido nos comandos de execução) e por padrão, o de desenvolvimento
const enviroment = process.env.NODE_ENV || "development";

// Exporta a variável 'database' contendo as definições do arquivo knexfile.js + qual é o ambiente rodando
export const database = knex(knexfile[enviroment]);