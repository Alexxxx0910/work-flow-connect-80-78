
# WorkFlowConnect - Backend

## Descripción del Proyecto
API REST y servidor de WebSockets para WorkFlowConnect, proporcionando autenticación, gestión de usuarios, chat en tiempo real y sistema de trabajos.

## Tecnologías Utilizadas
- **Node.js** - Entorno de ejecución
- **Express.js** - Framework web
- **PostgreSQL** - Base de datos relacional
- **Socket.io** - Comunicación en tiempo real
- **JWT** - Autenticación con tokens
- **bcryptjs** - Encriptación de contraseñas
- **CORS** - Manejo de origen cruzado

## Paso a Paso del Desarrollo

### 1. Configuración Inicial del Proyecto
```bash
# Creación del proyecto
mkdir workflowconnect-backend
cd workflowconnect-backend
npm init -y
```

### 2. Instalación de Dependencias Base
```bash
# Dependencias principales
npm install express cors dotenv
npm install pg bcryptjs jsonwebtoken
npm install socket.io

# Dependencias de desarrollo
npm install --save-dev nodemon
```

### 3. Configuración de Scripts en package.json
```json
{
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js",
    "init-db": "node scripts/initDb.js"
  }
}
```

### 4. Estructura de Carpetas Implementada
```
backend/
├── config/              # Configuraciones
│   └── database.js     # Configuración de PostgreSQL
├── controllers/         # Controladores de rutas
│   ├── authController.js
│   ├── userController.js
│   ├── chatController.js
│   ├── messageController.js
│   ├── jobController.js
│   └── fileController.js
├── middleware/          # Middlewares personalizados
│   └── auth.js         # Middleware de autenticación
├── models/             # Modelos de datos
│   ├── userModel.js
│   ├── chatModel.js
│   ├── messageModel.js
│   ├── jobModel.js
│   ├── fileModel.js
│   └── db.sql          # Schema de base de datos
├── routes/             # Definición de rutas
│   ├── authRoutes.js
│   ├── userRoutes.js
│   ├── chatRoutes.js
│   ├── messageRoutes.js
│   ├── jobRoutes.js
│   └── fileRoutes.js
├── scripts/            # Scripts de utilidad
│   ├── initDb.js
│   ├── checkDbSchema.js
│   └── resetJobTables.js
├── socket/             # Manejo de WebSockets
│   └── socketHandler.js
└── server.js           # Punto de entrada
```

### 5. Configuración de Base de Datos PostgreSQL
```bash
# Instalación de PostgreSQL (Ubuntu/Debian)
sudo apt update
sudo apt install postgresql postgresql-contrib

# Creación de base de datos
sudo -u postgres createdb workflowconnect
sudo -u postgres createuser workflowconnect_user
```

### 6. Variables de Entorno (.env)
```env
# Base de datos
DB_HOST=localhost
DB_PORT=5432
DB_NAME=workflowconnect
DB_USER=workflowconnect_user
DB_PASSWORD=tu_password

# JWT
JWT_SECRET=tu_jwt_secret_muy_seguro
JWT_EXPIRES_IN=7d

# Servidor
PORT=5000
NODE_ENV=development
```

### 7. Implementación del Schema de Base de Datos
- **Tabla Users** - Información de usuarios
- **Tabla Chats** - Salas de chat
- **Tabla ChatParticipants** - Participantes de chat
- **Tabla Messages** - Mensajes de chat
- **Tabla Jobs** - Ofertas de trabajo
- **Tabla JobLikes** - Likes en trabajos
- **Tabla JobSaves** - Trabajos guardados
- **Tabla Comments** - Comentarios en trabajos
- **Tabla Replies** - Respuestas a comentarios
- **Tabla Files** - Archivos adjuntos

### 8. Sistema de Autenticación
```javascript
// Implementación con JWT y bcrypt
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
```
- Registro de usuarios con hash de contraseñas
- Login con verificación de credenciales
- Middleware de autenticación para rutas protegidas
- Verificación de tokens JWT

### 9. API REST Endpoints

#### Autenticación
- `POST /api/auth/register` - Registro de usuario
- `POST /api/auth/login` - Inicio de sesión
- `GET /api/auth/verify` - Verificación de token

#### Usuarios
- `GET /api/users` - Obtener todos los usuarios
- `GET /api/users/:userId` - Obtener usuario por ID
- `PUT /api/users/profile` - Actualizar perfil

#### Trabajos
- `GET /api/jobs` - Obtener trabajos
- `POST /api/jobs` - Crear trabajo
- `GET /api/jobs/:jobId` - Obtener trabajo por ID
- `PUT /api/jobs/:jobId` - Actualizar trabajo
- `DELETE /api/jobs/:jobId` - Eliminar trabajo
- `POST /api/jobs/:jobId/like` - Like/Unlike trabajo
- `POST /api/jobs/:jobId/save` - Guardar/No guardar trabajo

#### Chat
- `GET /api/chats` - Obtener chats del usuario
- `POST /api/chats/private` - Crear chat privado
- `POST /api/chats/group` - Crear chat grupal
- `POST /api/chats/:chatId/users` - Añadir usuarios al chat

#### Mensajes
- `GET /api/messages/:chatId` - Obtener mensajes del chat
- `POST /api/messages` - Enviar mensaje
- `PUT /api/messages/:messageId` - Editar mensaje
- `DELETE /api/messages/:messageId` - Eliminar mensaje

### 10. Implementación de WebSockets con Socket.io
```javascript
// Configuración de Socket.io
const io = socketIo(server, {
  cors: corsOptions
});
```
- Autenticación de sockets con JWT
- Salas de chat en tiempo real
- Eventos de mensajes instantáneos
- Estados de usuarios online/offline

### 11. Middleware de Seguridad
- **Autenticación JWT** - Verificación de tokens
- **CORS** - Configuración de orígenes permitidos
- **Validación de datos** - Sanitización de inputs
- **Rate limiting** (recomendado para producción)

### 12. Manejo de Archivos
```javascript
// Sistema de archivos con base64
app.use(express.json({ limit: '50mb' }));
```
- Subida de archivos en base64
- Almacenamiento en base de datos
- Descarga con autenticación

### 13. Scripts de Inicialización
- **initDb.js** - Inicialización de base de datos
- **checkDbSchema.js** - Verificación de esquema
- **resetJobTables.js** - Reset de tablas de trabajos

### 14. Gestión de Errores
- Manejo centralizado de errores
- Logs detallados para debugging
- Respuestas consistentes de API

## Comandos de Desarrollo

```bash
# Instalar dependencias
npm install

# Inicializar base de datos
npm run init-db

# Ejecutar en modo desarrollo
npm run dev

# Ejecutar en producción
npm start
```

## Configuración de Base de Datos

### 1. Instalación de PostgreSQL
```bash
# Ubuntu/Debian
sudo apt install postgresql postgresql-contrib

# macOS con Homebrew
brew install postgresql
```

### 2. Configuración de Usuario y Base de Datos
```sql
-- Conectar como superusuario postgres
sudo -u postgres psql

-- Crear base de datos y usuario
CREATE DATABASE workflowconnect;
CREATE USER workflowconnect_user WITH PASSWORD 'tu_password';
GRANT ALL PRIVILEGES ON DATABASE workflowconnect TO workflowconnect_user;
```

### 3. Ejecutar Schema
```bash
# Después de configurar las variables de entorno
npm run init-db
```

## Arquitectura del Sistema

### Patrones Utilizados
1. **MVC Pattern** - Separación de controladores, modelos y rutas
2. **Middleware Pattern** - Procesamiento de peticiones
3. **Repository Pattern** - Abstracción de acceso a datos
4. **Observer Pattern** - Socket.io para eventos en tiempo real

### Seguridad Implementada
- Encriptación de contraseñas con bcrypt
- Autenticación JWT
- Validación de entrada de datos
- Sanitización de SQL queries
- CORS configurado correctamente

### Optimizaciones
- Conexiones de base de datos persistentes
- Índices en consultas frecuentes
- Paginación en listados grandes
- Cache de datos estáticos (recomendado)

## Despliegue en Producción

### Variables de Entorno de Producción
```env
NODE_ENV=production
PORT=5000
DB_HOST=tu_host_de_produccion
DB_SSL=true
JWT_SECRET=jwt_secret_muy_seguro_para_produccion
```

### Consideraciones de Producción
1. **SSL/HTTPS** - Certificados SSL
2. **Process Manager** - PM2 o similar
3. **Load Balancer** - Nginx o similar
4. **Monitoring** - Logs y métricas
5. **Backup** - Respaldo de base de datos
6. **Rate Limiting** - Protección contra ataques

### Comando de Despliegue
```bash
# Con PM2
npm install -g pm2
pm2 start server.js --name "workflowconnect-api"
pm2 save
pm2 startup
```

## Testing (Recomendado para el Futuro)
```bash
# Instalación de herramientas de testing
npm install --save-dev jest supertest
npm install --save-dev mocha chai
```

## Monitoreo y Logs
- Console.log para desarrollo
- Winston para producción (recomendado)
- Health check endpoints
- Error tracking con Sentry (recomendado)
