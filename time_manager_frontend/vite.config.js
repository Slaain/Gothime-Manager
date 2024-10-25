import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';
import { fileURLToPath, URL } from 'url';

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url)),
    },
  },
  server: {
    host: '0.0.0.0',  // Serveur accessible depuis d'autres machines
    port: 5173,
  },
  build: {
    rollupOptions: {
      input: './index.html', // Assurez-vous que le chemin du fichier d'entrée est correct
    },
  },
});
