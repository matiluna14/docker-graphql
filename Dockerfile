



FROM node:19-alpine3.15 as developmentDependenciesStage
WORKDIR /app
COPY package.json .
# --frozen-lockfile sirve para congelar las versiones de las dependencias que estamos...
#...utilizando en este momento para evitar que en un futuro cuando se vuelva a ejecutar este...
#...comando se cargen versiones nuevas
RUN yarn install --frozen-lockfile




FROM node:19-alpine3.15 as builderStage
WORKDIR /app
COPY --from=developmentDependenciesStage /app/node_modules ./node_modules
COPY . .
#construye la carpeta "dist"
RUN yarn build




FROM node:19-alpine3.15 as productionDependenciesStage
WORKDIR /app
COPY package.json .
RUN yarn install --prod --frozen-lockfile





FROM node:19-alpine3.15 as prod
EXPOSE 3000
WORKDIR /app
ENV APP_VERSION=${APP_VERSION}
COPY --from=productionDependenciesStage /app/node_modules ./node_modules
COPY --from=builderStage /app/dist ./dist

CMD [ "node","dist/main.js"]









