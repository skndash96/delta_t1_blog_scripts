FROM nginx:latest

RUN apt-get update && apt-get install -y acl

COPY nginx.conf /etc/nginx/nginx.conf
COPY blog.in.* /etc/nginx/
