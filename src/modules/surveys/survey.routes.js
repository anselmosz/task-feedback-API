import { Router } from "express";
import surveysController from "./surveys.controller.js";
import { decodeToken, adminOnly } from "../../middlewares/auth.middleware.js"

const router = Router();

router.post("/", decodeToken, adminOnly, surveysController.criarPesquisa);
router.get("/", decodeToken, adminOnly, surveysController.listarPesquisas);

export default router;