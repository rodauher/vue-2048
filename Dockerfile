FROM nginx:latest
WORKDIR /usr/share/nginx/html/
COPY dist/ ./
#RUN yarn
#CMD yarn build
#CMD yarn dev
