# build stage
FROM node:lts as build-stage


RUN npm install -g aurelia-cli@^1.2.0


WORKDIR /app

# install dependencies
COPY ./*.json  ./
RUN npm install

COPY aurelia_project  ./aurelia_project


# Copy files in the root folder
COPY *.* ./

# Copy source files
COPY src ./src







# build
FROM build-stage as publish-stage
RUN npm run build

# production stage
FROM nginx:alpine as production-stage
COPY nginx.conf /etc/nginx/nginx.conf
WORKDIR /usr/share/nginx/html




COPY --from=publish-stage /app/scripts/ ./scripts/
COPY --from=publish-stage /app/index.html/ .
COPY --from=publish-stage /app/@fortawesome/ ./@fortawesome/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
