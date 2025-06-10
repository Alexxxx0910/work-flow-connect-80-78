
// Este archivo proporciona funcionalidad similar a Next.js para Vite
// Es una capa de compatibilidad para componentes que esperan APIs de Next.js

declare global {
  interface Window {
    __NEXT_DATA__: any;
  }
}

// Mock del router de Next.js para compatibilidad
export const useRouter = () => ({
  push: (url: string) => window.location.href = url,
  replace: (url: string) => window.location.replace(url),
  back: () => window.history.back(),
  forward: () => window.history.forward(),
  reload: () => window.location.reload(),
  pathname: window.location.pathname,
  query: {},
  asPath: window.location.pathname + window.location.search,
});

// Mock del componente Image de Next.js
export const Image = ({ src, alt, ...props }: any) => {
  return <img src={src} alt={alt} {...props} />;
};

// Mock del componente Link de Next.js  
export const Link = ({ href, children, ...props }: any) => {
  return <a href={href} {...props}>{children}</a>;
};

// Mock del componente Head de Next.js
export const Head = ({ children }: any) => {
  return null; // En una aplicación real, podrías querer usar react-helmet
};

export default {};
