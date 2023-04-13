FROM node:18-buster-slim as builder

ENV NODE_ENV=production

RUN mkdir /app && chown -R node:node /app

WORKDIR /app
USER node

COPY --chown=node:node package.json yarn.lock next-env.d.ts tsconfig.json next.config.js tailwind.config.js postcss.config.js ./
RUN yarn install --production --silent --network-timeout 1000000 && yarn cache clean --force

COPY --chown=node:node public/ ./public
COPY --chown=node:node src/ ./src

RUN env
RUN npx next telemetry disable && yarn build

EXPOSE 5000
CMD ["yarn", "start"]