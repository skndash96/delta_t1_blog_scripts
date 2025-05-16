
FROM ubuntu:22.04

# this is taken from official ubuntu image docs to setup lang
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

RUN apt-get update && apt-get install -y curl acl netcat

RUN curl -L https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -o /bin/yq \
	&& chmod +x /bin/yq

COPY . /scripts/

RUN /scripts/bin/populate \
	&& /scripts/bin/all_blogs_setup \
	&& /scripts/bin/mods_setup \
	&& /scripts/bin/nginx_perms_setup
	#&& /scripts/bin/notifs_server &

ENV LANG=en_US.utf8;
ENV PATH="/scripts/bin:${PATH}"

# TODO setup crons (for notif, report_gen)

CMD ["tail", "-f", "/dev/null"]
