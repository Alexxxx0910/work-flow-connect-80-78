
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const userModel = require('../models/userModel');

require('dotenv').config();

const authController = {
  // Registrar un nuevo usuario
  async register(req, res) {
    try {
      const { username, email, password, role } = req.body;
      
      // Verificar si el email o nombre de usuario ya existe
      const existingUser = await userModel.findByEmail(email);
      if (existingUser) {
        return res.status(400).json({ success: false, message: 'El email ya está registrado' });
      }
      
      // Crear usuario
      const newUser = await userModel.create({
        username,
        email,
        password,
        role: role || 'client' // Usar el rol proporcionado o client por defecto
      });
      
      // Generar token JWT
      const token = jwt.sign(
        { userId: newUser.id, email: newUser.email },
        process.env.JWT_SECRET,
        { expiresIn: process.env.JWT_EXPIRES_IN }
      );
      
      res.status(201).json({
        success: true,
        user: newUser,
        token
      });
    } catch (error) {
      console.error('Error al registrar usuario:', error);
      res.status(500).json({ success: false, message: 'Error del servidor' });
    }
  },
  
  // Iniciar sesión del usuario
  async login(req, res) {
    try {
      const { email, password } = req.body;
      
      // Verificar si el usuario existe
      const user = await userModel.findByEmail(email);
      if (!user) {
        return res.status(401).json({ success: false, message: 'Credenciales inválidas' });
      }
      
      // Verificar contraseña
      const isPasswordValid = await bcrypt.compare(password, user.password);
      if (!isPasswordValid) {
        return res.status(401).json({ success: false, message: 'Credenciales inválidas' });
      }
      
      // Actualizar estado del usuario a en línea
      await userModel.updateStatus(user.id, 'online');
      
      // Generar token JWT
      const token = jwt.sign(
        { userId: user.id, email: user.email },
        process.env.JWT_SECRET,
        { expiresIn: process.env.JWT_EXPIRES_IN }
      );
      
      // No devolver la contraseña y formatear los datos del usuario correctamente
      const { password: pass, ...userWithoutPassword } = user;
      const formattedUser = {
        id: userWithoutPassword.id,
        name: userWithoutPassword.name,
        email: userWithoutPassword.email,
        photoURL: userWithoutPassword.photoURL,
        bio: userWithoutPassword.bio,
        skills: userWithoutPassword.skills,
        role: userWithoutPassword.role,
        createdAt: userWithoutPassword.createdAt
      };
      
      res.json({
        success: true,
        user: formattedUser,
        token
      });
    } catch (error) {
      console.error('Error al iniciar sesión:', error);
      res.status(500).json({ success: false, message: 'Error del servidor' });
    }
  },
  
  // Verificar token del usuario
  async verify(req, res) {
    try {
      const user = await userModel.findById(req.user.userId);
      
      if (!user) {
        return res.status(404).json({ success: false, message: 'Usuario no encontrado' });
      }
      
      res.json({ success: true, user });
    } catch (error) {
      console.error('Error al verificar token:', error);
      res.status(500).json({ success: false, message: 'Error del servidor' });
    }
  }
};

module.exports = authController;
