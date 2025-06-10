
const userModel = require('../models/userModel');

const userController = {
  // Obtener todos los usuarios
  async getAllUsers(req, res) {
    try {
      const users = await userModel.findAllExcept(req.user.userId);
      res.json({ success: true, users });
    } catch (error) {
      console.error('Error al obtener usuarios:', error);
      res.status(500).json({ success: false, message: 'Error del servidor' });
    }
  },
  
  // Obtener usuario por ID
  async getUserById(req, res) {
    try {
      const user = await userModel.findById(req.params.userId);
      
      if (!user) {
        return res.status(404).json({ success: false, message: 'Usuario no encontrado' });
      }
      
      res.json({ success: true, user });
    } catch (error) {
      console.error('Error al obtener usuario:', error);
      res.status(500).json({ success: false, message: 'Error del servidor' });
    }
  },
  
  // Actualizar perfil de usuario
  async updateProfile(req, res) {
    try {
      const { username, avatar, bio, skills } = req.body;
      
      const updatedUser = await userModel.updateProfile(req.user.userId, {
        username,
        avatar,
        bio,
        skills
      });
      
      res.json({ success: true, user: updatedUser });
    } catch (error) {
      console.error('Error al actualizar perfil:', error);
      res.status(500).json({ success: false, message: 'Error del servidor' });
    }
  }
};

module.exports = userController;
