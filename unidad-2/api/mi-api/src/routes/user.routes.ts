import { Router } from "express";
import { getUsers, getUsersById } from "../controllers/user.controller.js";

const router = Router();

router.get('/user', getUsers);
router.get('/userGetId/:id', getUsersById);


export default router;