# -----------------------------
# Stage 1: Build Angular (SPA)
# -----------------------------
FROM node:23.5-alpine AS build

WORKDIR /app

# (1) Skopiuj zależności
COPY frontend/package.json frontend/package-lock.json ./frontend/
RUN cd frontend && npm install

# (2) Skopiuj kod projektu (src/, scripts/, environment itp.)
COPY . .

# (3) Zmienne środowiskowe (do generate-env.js)
ARG SUPABASE_URL
ARG SUPABASE_ANON_KEY
ENV SUPABASE_URL=$SUPABASE_URL
ENV SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY

# (4) Zbuduj pliki Angulara
WORKDIR /app/frontend
RUN npm run build:prod

# -----------------------------
# Stage 2: Serve the application using Node
# -----------------------------
FROM node:23.5-alpine

# Ustaw katalog roboczy
WORKDIR /app/frontend

# (1) Skopiuj gotowy build (dist/frontend) z etapu 1
COPY --from=build /app/frontend/dist/frontend ./dist/frontend

# (2) Skopiuj package*.json i zainstaluj dependencies
COPY --from=build /app/frontend/package*.json ./
RUN npm install --omit=dev

# (3) Skopiuj plik server.js z hosta do kontenera
# UWAGA: jeśli 'server.js' jest w cat-management-public obok Dockerfile
# to w Dockerfile wystarczy:
COPY server.js ./server.js

# Wystaw port 4000
EXPOSE 4000

# (4) Uruchom Node z server.js
CMD ["node", "server.js"]