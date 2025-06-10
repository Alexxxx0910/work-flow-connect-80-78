
// Shim para compatibilidad con Next.js
// Este archivo proporciona tipos y funciones básicas para mantener compatibilidad

declare global {
  interface Window {
    // Propiedades globales del navegador
    gtag?: (...args: any[]) => void;
  }
}

// Exportar un objeto vacío para que el módulo sea válido
export {};
