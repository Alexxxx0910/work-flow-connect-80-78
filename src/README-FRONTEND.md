
# WorkFlowConnect - Frontend

## Descripción del Proyecto
WorkFlowConnect es una plataforma que conecta freelancers con clientes, permitiendo encontrar oportunidades de trabajo, comunicarse a través de chat y gestionar perfiles.

## Tecnologías Utilizadas
- **React 18** - Biblioteca principal para la interfaz de usuario
- **TypeScript** - Tipado estático para mejor desarrollo
- **Vite** - Herramienta de construcción y desarrollo
- **Tailwind CSS** - Framework de estilos utilitarios
- **shadcn/ui** - Componentes de interfaz de usuario pre-construidos
- **React Router DOM** - Navegación y enrutamiento
- **Tanstack Query** - Gestión de estado del servidor
- **Socket.io Client** - Comunicación en tiempo real
- **Axios** - Cliente HTTP para API
- **React Hook Form** - Manejo de formularios
- **Zod** - Validación de esquemas

## Paso a Paso del Desarrollo

### 1. Configuración Inicial del Proyecto
```bash
# Creación del proyecto con Vite
npm create vite@latest workflowconnect-frontend -- --template react-ts
cd workflowconnect-frontend
npm install
```

### 2. Instalación de Dependencias Base
```bash
# Instalación de librerías principales
npm install react-router-dom @tanstack/react-query axios
npm install tailwindcss postcss autoprefixer
npm install @types/node
```

### 3. Configuración de Tailwind CSS
```bash
# Inicialización de Tailwind
npx tailwindcss init -p
```
- Configuración de `tailwind.config.ts`
- Configuración de estilos base en `src/index.css`

### 4. Instalación y Configuración de shadcn/ui
```bash
# Inicialización de shadcn/ui
npx shadcn-ui@latest init
```
- Configuración de `components.json`
- Instalación de componentes base como Button, Input, Card, etc.

### 5. Estructura de Carpetas Implementada
```
src/
├── components/          # Componentes reutilizables
│   ├── ui/             # Componentes de shadcn/ui
│   ├── Layout/         # Componentes de diseño
│   ├── Comments/       # Componentes de comentarios
│   └── ...
├── pages/              # Páginas principales
├── contexts/           # Contextos de React
├── hooks/              # Hooks personalizados
├── lib/                # Utilidades y configuraciones
├── services/           # Servicios de API
├── types/              # Definiciones de tipos TypeScript
└── ...
```

### 6. Implementación de Contextos
- **AuthContext** - Gestión de autenticación de usuarios
- **ChatContext** - Manejo de chat en tiempo real
- **JobContext** - Gestión de trabajos y ofertas
- **DataContext** - Estado global de datos
- **ThemeContext** - Gestión de temas claro/oscuro

### 7. Configuración de Autenticación
- Implementación de login/registro
- Middleware de rutas protegidas
- Gestión de tokens JWT
- Persistencia de sesión

### 8. Implementación de Chat en Tiempo Real
```bash
# Instalación de Socket.io client
npm install socket.io-client
```
- Conexión WebSocket con el backend
- Gestión de salas de chat
- Mensajes en tiempo real
- Estados de lectura/no lectura

### 9. Sistema de Trabajos
- Creación y edición de trabajos
- Sistema de filtros y búsqueda
- Gestión de comentarios
- Sistema de likes y guardados

### 10. Interfaz de Usuario
- Diseño responsive con Tailwind
- Componentes reutilizables con shadcn/ui
- Tema oscuro/claro
- Animaciones y transiciones

### 11. Gestión de Estado
```bash
# Instalación de React Query
npm install @tanstack/react-query
```
- Cache inteligente de datos
- Sincronización con servidor
- Manejo de estados de carga y error

### 12. Funcionalidades Adicionales
```bash
# Instalación de librerías adicionales
npm install emoji-picker-react react-file-icon
npm install date-fns uuid
```
- Picker de emojis para chat
- Iconos de archivos
- Manejo de fechas
- Generación de IDs únicos

### 13. Configuración de Formularios
```bash
# Instalación de React Hook Form y validaciones
npm install react-hook-form @hookform/resolvers zod
```
- Validación de formularios
- Manejo de errores
- Tipos seguros con Zod

### 14. Comunicación con Backend
- Configuración de Axios con interceptores
- Manejo de tokens de autenticación
- Endpoints para todas las funcionalidades
- Manejo de errores HTTP

## Comandos de Desarrollo

```bash
# Instalar dependencias
npm install

# Ejecutar en modo desarrollo
npm run dev

# Construir para producción
npm run build

# Vista previa de producción
npm run preview
```

## Variables de Entorno
Crear un archivo `.env` en la raíz del proyecto:
```
VITE_API_URL=http://localhost:5000
VITE_SOCKET_URL=http://localhost:5000
```

## Arquitectura de Componentes

### Componentes Principales
- **MainLayout** - Layout principal con navegación
- **JobCard** - Tarjeta de trabajo individual
- **ChatComponents** - Sistema completo de chat
- **ProfileComponents** - Gestión de perfiles

### Hooks Personalizados
- **useAuth** - Hook de autenticación
- **useSocket** - Hook para Socket.io
- **useLocalStorage** - Persistencia local

### Servicios
- **api.ts** - Configuración de Axios y endpoints
- **jobService.ts** - Servicios específicos de trabajos

## Patrones de Desarrollo Utilizados
1. **Component Composition** - Composición de componentes
2. **Custom Hooks** - Lógica reutilizable
3. **Context Pattern** - Estado global
4. **Error Boundaries** - Manejo de errores
5. **Lazy Loading** - Carga perezosa de rutas

## Consideraciones de Rendimiento
- Memoización con React.memo
- Lazy loading de rutas
- Optimización de imágenes
- Cache con React Query
- Debounce en búsquedas

## Testing (Futuro)
```bash
# Instalación de testing (recomendado para el futuro)
npm install --save-dev @testing-library/react @testing-library/jest-dom
npm install --save-dev vitest jsdom
```
