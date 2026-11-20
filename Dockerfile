FROM node:22-bookworm-slim AS development

WORKDIR /usr/src/app

ENV MONGOMS_DISABLE_POSTINSTALL=1

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

FROM node:22-bookworm-slim AS production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}
ENV MONGOMS_DISABLE_POSTINSTALL=1

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --only=production

COPY . .

COPY --from=development /usr/src/app/dist ./dist

CMD ["node", "dist/main"]
