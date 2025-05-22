
FROM ubuntu:22.04

# this is taken from official ubuntu image docs to setup lang
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

RUN apt-get update && apt-get install -y curl acl netcat default-mysql-client openssh-server

RUN curl -L https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -o /bin/yq \
	&& chmod +x /bin/yq

COPY . /scripts/

ENV LANG=en_US.utf8;

CMD ["/bin/bash", "-c", "/scripts/bin/init_setup_container"]
