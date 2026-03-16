import app from "./src/app.js";
import './src/config/env.js'

const port = process.env.PORT || 3000;

app.listen(port, () => {
  console.log(`\nServidor rodando na porta ${port}`);
});