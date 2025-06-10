
const express = require('express');
const userController = require('../controllers/userController');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

// Aplicar middleware de autenticación a todas las rutas
router.use(authenticateToken);

// Obtener todos los usuarios
router.get('/', userController.getAllUsers);

// Obtener usuario por ID
router.get('/:userId', userController.getUserById);

// Actualizar perfil de usuario
router.put('/profile', userController.updateProfile);

module.exports = router;
