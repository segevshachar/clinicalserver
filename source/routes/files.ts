import express from 'express';
import controller from '../controllers/files';
const router = express.Router();

router.get('/health', controller.health);
router.get('/files', controller.getFiles);
router.get('/files/:id', controller.getFile);
router.put('/files/:id', controller.updateFile);
router.post('/files', controller.addFile);

export = router;