FROM node:alpine3.18 as build

# Declare build time environment variables
ARG REACT_APP_NODE_ENV
ARG NEXT_APP_SEVER_BASE_URL

# Set default values for environment variables
ENV REACT_APP_NODE_ENV=$REACT_APP_NODE_ENV
ENV NEXT_APP_SEVER_BASE_URL=$NEXT_APP_SEVER_BASE_URL

# Build App
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

# Serve with Nginx
FROM nginx:1.23-alpine
WORKDIR /usr/share/nginx/html
RUN rm -rf *
COPY --from=build /app/build .
EXPOSE 80
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]