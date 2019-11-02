FROM node:lts-alpine as debug


# カレントワーキングディレクトリとして 'app' フォルダを指定する
WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 8080
CMD ["npm", "run", "serve"]


# ビルド環境
FROM node:lts-alpine as build
WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY . .
RUN npm run build

# 本番環境
FROM nginx:stable-alpine as production
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]