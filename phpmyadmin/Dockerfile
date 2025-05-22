FROM phpmyadmin/phpmyadmin

COPY certs/ /etc/ssl/certs/
COPY apache-ssl.conf /etc/apache2/sites-enabled/000-default.conf

RUN a2enmod ssl
