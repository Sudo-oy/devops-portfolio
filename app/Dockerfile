# Stage 1: build
FROM node:18 AS builder
WORKDIR /app
# copy package files first to leverage cache for npm install
COPY package*.json ./
RUN npm ci           # cached unless package.json changes
COPY . .
RUN npm run build    # produce /app/dist or whatever

# Stage 2: runtime
FROM node:18-alpine
WORKDIR /app
ENV NODE_ENV=production
# copy artifacts only
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./
RUN npm ci --only=production
CMD ["node", "dist/index.js"]
