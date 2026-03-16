import { Router } from "express";
import usersController from "./users.controller.js";
import { decodeToken, adminOnly, validateIsTheAdminOrUse } from "../../middlewares/auth.middleware.js";

const router = Router();

router.get("/", decodeToken, usersController.listarUsuarios);
router.get("/:id", decodeToken, usersController.buscarUsuarioPorID);
router.post("/", decodeToken, adminOnly, usersController.criarUsuario);
router.put("/:id", decodeToken, validateIsTheAdminOrUse, usersController.atualizarDadosDoUsuario);
router.delete("/:id", decodeToken, adminOnly, usersController.excluirUsuario);

export default router;