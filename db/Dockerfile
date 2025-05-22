FROM mysql

COPY ./migration.sql /docker-entrypoint-initdb.d/
# 			^ sql fles in this path are run by the img as per dox
