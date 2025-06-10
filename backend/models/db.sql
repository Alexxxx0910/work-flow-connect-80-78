
-- Script completo de reseteo de base de datos para solucionar problemas de enum
-- Este script eliminará completamente y recreará todas las tablas relacionadas con trabajos

-- Primero, desconectar todas las conexiones activas para evitar bloqueos (opcional, ejecutar manualmente si es necesario)
-- SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'workflowconnect' AND pid <> pg_backend_pid();

-- Tabla de Usuarios (manteniendo la estructura existente)
CREATE TABLE IF NOT EXISTS "Users" (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  role VARCHAR(50) DEFAULT 'client',
  bio TEXT DEFAULT '',
  skills VARCHAR(255)[] DEFAULT ARRAY[]::VARCHAR(255)[],
  "photoURL" VARCHAR(255) DEFAULT '',
  "hourlyRate" FLOAT DEFAULT 0,
  "isOnline" BOOLEAN DEFAULT FALSE,
  "lastSeen" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Archivos (manteniendo la estructura existente)
CREATE TABLE IF NOT EXISTS "Files" (
  id SERIAL PRIMARY KEY,
  filename VARCHAR(255) NOT NULL,
  content_type VARCHAR(100) NOT NULL,
  size INTEGER NOT NULL,
  data BYTEA NOT NULL,
  uploaded_by UUID REFERENCES "Users"(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Chats (manteniendo la estructura existente)
CREATE TABLE IF NOT EXISTS "Chats" (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255),
  "isGroup" BOOLEAN DEFAULT FALSE,
  "lastMessageAt" TIMESTAMP,
  "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Participantes de Chat (manteniendo la estructura existente)
CREATE TABLE IF NOT EXISTS "ChatParticipants" (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  "userId" UUID REFERENCES "Users"(id) ON DELETE CASCADE,
  "chatId" UUID REFERENCES "Chats"(id) ON DELETE CASCADE,
  "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE("userId", "chatId")
);

-- Tabla de Mensajes (manteniendo la estructura existente)
CREATE TABLE IF NOT EXISTS "Messages" (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  content TEXT NOT NULL,
  read BOOLEAN DEFAULT FALSE,
  "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "chatId" UUID REFERENCES "Chats"(id) ON DELETE SET NULL,
  "userId" UUID REFERENCES "Users"(id) ON DELETE SET NULL
);

-- RESETEO COMPLETO DE TABLAS RELACIONADAS CON TRABAJOS
-- Eliminar primero todas las tablas dependientes
DROP TABLE IF EXISTS "JobLikes" CASCADE;
DROP TABLE IF EXISTS "SavedJobs" CASCADE;
DROP TABLE IF EXISTS "Replies" CASCADE;
DROP TABLE IF EXISTS "Comments" CASCADE;
DROP TABLE IF EXISTS "Jobs" CASCADE;

-- Eliminar TODOS los tipos enum posibles que puedan existir
DROP TYPE IF EXISTS job_status CASCADE;
DROP TYPE IF EXISTS enum_Jobs_status CASCADE;
DROP TYPE IF EXISTS "enum_Jobs_status" CASCADE;

-- Forzar eliminación de cualquier referencia enum restante
DO $$ 
BEGIN
    IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'job_status') THEN
        DROP TYPE job_status CASCADE;
    END IF;
    IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'enum_Jobs_status') THEN
        DROP TYPE enum_Jobs_status CASCADE;
    END IF;
    IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'enum_Jobs_status') THEN
        DROP TYPE "enum_Jobs_status" CASCADE;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        -- Ignorar errores si los tipos no existen
        NULL;
END $$;

-- Crear tabla Jobs con estado VARCHAR (SIN ENUM)
CREATE TABLE "Jobs" (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  budget FLOAT NOT NULL,
  category VARCHAR(255) NOT NULL,
  skills VARCHAR(255)[] DEFAULT ARRAY[]::VARCHAR(255)[],
  status VARCHAR(50) DEFAULT 'open',
  "userId" UUID NOT NULL REFERENCES "Users"(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT valid_status CHECK (status IN ('open', 'in_progress', 'completed', 'closed'))
);

-- Crear tabla de Comentarios
CREATE TABLE "Comments" (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  content TEXT NOT NULL,
  "jobId" UUID NOT NULL REFERENCES "Jobs"(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "userId" UUID NOT NULL REFERENCES "Users"(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear tabla de Respuestas
CREATE TABLE "Replies" (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  content TEXT NOT NULL,
  "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "userId" UUID REFERENCES "Users"(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "commentId" UUID REFERENCES "Comments"(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Crear tabla de Me Gusta de Trabajos
CREATE TABLE "JobLikes" (
  "JobId" UUID REFERENCES "Jobs"(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "UserId" UUID REFERENCES "Users"(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("JobId", "UserId")
);

-- Crear tabla de Trabajos Guardados
CREATE TABLE "SavedJobs" (
  "JobId" UUID REFERENCES "Jobs"(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "UserId" UUID REFERENCES "Users"(id) ON UPDATE CASCADE ON DELETE CASCADE,
  "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("JobId", "UserId")
);

-- Crear índices para mejor rendimiento
CREATE INDEX IF NOT EXISTS idx_jobs_user_id ON "Jobs"("userId");
CREATE INDEX IF NOT EXISTS idx_jobs_status ON "Jobs"(status);
CREATE INDEX IF NOT EXISTS idx_jobs_category ON "Jobs"(category);
CREATE INDEX IF NOT EXISTS idx_jobs_created_at ON "Jobs"("createdAt");
CREATE INDEX IF NOT EXISTS idx_comments_job_id ON "Comments"("jobId");
CREATE INDEX IF NOT EXISTS idx_replies_comment_id ON "Replies"("commentId");
