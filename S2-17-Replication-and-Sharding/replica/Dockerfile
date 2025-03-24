FROM postgres:13-alpine

# Копируем конфигурацию восстановления
COPY postgresql.conf /usr/local/share/postgresql/postgresql.conf.sample

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh