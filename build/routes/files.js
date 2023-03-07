"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
const express_1 = __importDefault(require("express"));
const files_1 = __importDefault(require("../controllers/files"));
const router = express_1.default.Router();
router.get('/health', files_1.default.health);
router.get('/files', files_1.default.getFiles);
router.get('/files/:id', files_1.default.getFile);
router.put('/files/:id', files_1.default.updateFile);
router.post('/files', files_1.default.addFile);
module.exports = router;
