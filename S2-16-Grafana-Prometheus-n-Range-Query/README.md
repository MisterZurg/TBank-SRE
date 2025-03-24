# Grafana, Prometheus и Range Query

У нас есть сервис, на который жалуются пользователи, но мы не видим проблем по метрикам в панелях.
Твоя задача:
- развернуть инфраструктуру по ниже стоящей инструкции - 2 балла
- изучить дешборд и найти проблему - 2 балла
- прислать исправленный вариант(export Dashboard) и расписать проблемы, которые нашли - 6 баллов

Инструкция:
1. Запуск инфраструктуры
```sh
docker compose -f ./initial_infra/docker-compose-3da6681e-d000-4317-a48b-c19e0e906a47.yml up
```

2. Загрузить тестовые данные
```sh
docker compose exec -it prometheus sh
promtool tsdb create-blocks-from openmetrics test-series.txt /tmp/backfill_data
cp -r /tmp/backfill_data/* /prometheus
```
3. Добавить Data Source
4. Загрузить дешборд


prometheus
