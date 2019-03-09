FROM node:8-alpine

ARG AXIOS_HOST
ARG AXIOS_PORT

WORKDIR /usr/src/app

RUN apk update && \
    apk add git && \
    apk add --no-cache curl && \
    curl -o- -L https://yarnpkg.com/install.sh | sh

ENV PATH $HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH

# # Hotreload
# ENV CHOKIDAR_USEPOLLING=true
# RUN yarn global add @vue/cli

COPY . .
RUN yarn install
RUN yarn run build 

EXPOSE 80

CMD ["yarn", "run", "start"]
