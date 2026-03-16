// Handler de erro para retornar status 500 e o motivo do erro, caso seja usado o ambiente de desenvolviemnto
export function errorHandler(err, req, res, next) {
  console.error(err);

  // retorna o status code personalizado da classe de erro
  // se não for nada previamente configurado/erro do backend, retorna status 500
  const statusCode = err.statusCode || 500;

  return res.status(statusCode).json({
    // retorna a mensagem de erro da classe utilitária de erro padronizado
    // se não for nenhum erro pré configurado nos métodos dos services, retorna Internal server error
    message: err.message || "Internal server error", 
    error: process.env.NODE_ENV === "development" ? err.stack : undefined // retorna onde ocorreu o erro caso o ambiente rodando seja de desenvolvimento
  });
}