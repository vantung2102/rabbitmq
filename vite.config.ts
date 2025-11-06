import { defineConfig, splitVendorChunkPlugin } from 'vite';
import { fileURLToPath, URL } from 'url';
import ViteRails from 'vite-plugin-rails';

export default defineConfig({
  plugins: [
    splitVendorChunkPlugin(),
    ViteRails({
      envVars: {},
      fullReload: {
        additionalPaths: [],
      },
    }),
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./app/frontend', import.meta.url)),
    },
  },
});
