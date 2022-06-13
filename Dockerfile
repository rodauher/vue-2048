FROM nginx:latest
WORKDIR /vue
COPY . ./
RUN yarn build

