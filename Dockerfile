FROM postgres:17

ADD template-names/ /var/lib/postgresql/template-names/

COPY postgresql.conf /etc/postgresql/
COPY docker-entrypoint.sh /docker-entrypoint-initdb.d/

ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
