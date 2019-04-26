FROM node:8-alpine

ARG AXIOS_HOST
ARG AXIOS_PORT
ARG AXIOS_HTTPS

WORKDIR /usr/src/app

# タイムゾーンをAsia/Tokyoに
RUN apk add --update --no-cache tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    echo "Asia/Tokyo" > /etc/timezone && \
    apk del tzdata

RUN apk update && \
    apk add git && \
    apk add yarn

ENV PATH $HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH

# # Hotreload
# ENV CHOKIDAR_USEPOLLING=true
# RUN yarn global add @vue/cli

COPY . .
RUN yarn install
RUN yarn run build

EXPOSE 80

CMD ["yarn", "run", "start"]
