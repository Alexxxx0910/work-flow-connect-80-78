
// Script para resetear las tablas relacionadas con trabajos en la base de datos
const db = require('../config/database');

async function resetJobTables() {
  console.log('Iniciando el reseteo de las tablas de trabajos...');
  
  try {
    // Leer y ejecutar el script SQL
    const fs = require('fs');
    const path = require('path');
    const sqlScript = fs.readFileSync(path.join(__dirname, '../models/db.sql'), 'utf8');
    
    // Dividir por punto y coma y ejecutar cada declaración
    const statements = sqlScript.split(';').filter(stmt => stmt.trim().length > 0);
    
    for (const statement of statements) {
      if (statement.trim()) {
        try {
          console.log('Ejecutando:', statement.substring(0, 100) + '...');
          await db.query(statement);
        } catch (error) {
          // Registrar pero continuar - algunas declaraciones pueden fallar si los objetos no existen
          console.log('La declaración falló (esto podría ser normal):', error.message);
        }
      }
    }
    
    console.log('¡Reseteo de tablas de trabajos completado exitosamente!');
    
    // Verificar la estructura de la tabla Jobs
    const result = await db.query(`
      SELECT column_name, data_type, is_nullable 
      FROM information_schema.columns 
      WHERE table_name = 'Jobs' 
      ORDER BY ordinal_position
    `);
    
    console.log('Estructura de la tabla Jobs:');
    console.table(result.rows);
    
  } catch (error) {
    console.error('Error al resetear las tablas de trabajos:', error);
    throw error;
  }
}

// Si este script se ejecuta directamente
if (require.main === module) {
  resetJobTables()
    .then(() => {
      console.log('Script de reseteo completado exitosamente');
      process.exit(0);
    })
    .catch(error => {
      console.error('El script de reseteo falló:', error);
      process.exit(1);
    });
}

module.exports = { resetJobTables };
