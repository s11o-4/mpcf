FROM node:18-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y tini && rm -rf /var/lib/apt/lists/*

COPY package*.json ./
RUN npm install

COPY . .

RUN npm run build

FROM node:18-slim

RUN useradd -m nuxtuser

RUN apt-get update && apt-get install -y tini && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /app/.output .output
COPY --from=builder /app/node_modules node_modules
COPY --from=builder /app/package.json .

ENTRYPOINT ["/usr/bin/tini", "--"]

ENV NODE_ENV=production
ENV NUXT_PORT=3000

EXPOSE 3000

USER nuxtuser

CMD ["node", ".output/server/index.mjs"]
