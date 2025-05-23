FROM nginx:latest

RUN apt-get update && apt-get install -y acl openssh-server

COPY nginx.conf /etc/nginx/nginx.conf
COPY blog.in.* /etc/nginx/
COPY index.html /var/www/blog/index.html

RUN mkdir /run/sshd

CMD ["/bin/sh", "-c", "/usr/sbin/sshd && nginx -g 'daemon off;'"]
