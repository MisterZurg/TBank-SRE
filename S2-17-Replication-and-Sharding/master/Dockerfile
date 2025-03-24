FROM postgres:13-alpine

# Копируем скрипт инициализации
COPY init.sql /docker-entrypoint-initdb.d/

# Настройка PostgreSQL для репликации
RUN echo "wal_level = replica" >> /usr/local/share/postgresql/postgresql.conf.sample
RUN echo "max_wal_senders = 3" >> /usr/local/share/postgresql/postgresql.conf.sample
RUN echo "wal_keep_size = 512MB" >> /usr/local/share/postgresql/postgresql.conf.sample
RUN echo "listen_addresses = '*'" >> /usr/local/share/postgresql/postgresql.conf.sample

# Разрешаем подключение реплики
RUN echo "host replication replicator 0.0.0.0/0 md5" >> /usr/local/share/postgresql/pg_hba.conf.sample
# RUN echo "host all all" >> /usr/local/share/postgresql/pg_hba.conf.sample