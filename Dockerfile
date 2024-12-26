# -----------------------------
# Stage 1: Build Angular (SPA)
# -----------------------------
FROM node:23.5-alpine AS build

WORKDIR /app

# (1) Copy dependencies
COPY frontend/package.json frontend/package-lock.json ./frontend/
RUN cd frontend && npm install

# (2) Copy project code (src/, scripts/, environment etc.)
COPY . .

# (3) Environment variables (for generate-env.js)
ARG SUPABASE_URL
ARG SUPABASE_ANON_KEY
ENV SUPABASE_URL=$SUPABASE_URL
ENV SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY

# (4) Build Angular files
WORKDIR /app/frontend
RUN npm run build:prod

# -----------------------------
# Stage 2: Serve the application using Node
# -----------------------------
FROM node:23.5-alpine

# Set working directory
WORKDIR /app/frontend

# (1) Copy the built output (dist/frontend) from stage 1
COPY --from=build /app/frontend/dist/frontend ./dist/frontend

# (2) Copy package*.json and install dependencies
COPY --from=build /app/frontend/package*.json ./
RUN npm install --omit=dev

# (3) Copy server.js from host to the container
# NOTE: if 'server.js' is in cat-management-public next to Dockerfile
# then in Dockerfile it's enough to use:
COPY server.js ./server.js

# Expose port 4000
EXPOSE 4000

# (4) Run Node with server.js
CMD ["node", "server.js"]