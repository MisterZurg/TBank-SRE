# Домашнее задание №5 "Метрики. Prometheus"

## 1 задание
Домашнее задание по разворачиванию Prometheus:
- можно выполнить на локальном компьютере используя docker-compose, просто развернув prometheus из образа официальной документации https://prometheus.io/docs/prometheus/latest/installation/
- можно выполнив команды представленные ниже на виртуальной машине

> [!INFO]
> Я просто скопипатил себя же [TBank URL-Shortener/prometheus](build/prometheus/prometheus.yml)

```sh
make up
```

```sh
make down
```
## 2 задание
Включить метрики Oncall и добавить их targetом в Prometheus.

### Пререквизиты
1. Включаем ingress в minikube
```sh
minikube addons enable ingress
```

2. Проверяем запустился ли ingress controller
```sh
kubectl get pods -n ingress-nginx
```

### Флоу задания

Включить метрики в формате prometheus в приложении Oncall
В склонированном ранее
- для этого придется пересобрать Dockerfile с установкой prometheus_client
  ```dockerfile
  # Включить метрики в формате prometheus в приложении Oncall,
  # пересобираем Dockerfile с установкой prometheus_client
  RUN chown -R oncall:oncall /home/oncall/source /var/log/nginx /var/lib/nginx \
      && sudo -Hu oncall mkdir -p /home/oncall/var/log/uwsgi /home/oncall/var/log/nginx /home/oncall/var/run /home/oncall/var/relay \
      && sudo -Hu oncall python3 -m venv /home/oncall/env \
      && sudo -Hu oncall /bin/bash -c 'source /home/oncall/env/bin/activate && cd /home/oncall/source && pip install wheel && pip install prometheus_client && pip install .'
      #                                                                                                                     !-------------------------------!
  ```
  В миникубе билдим новый образ
  ```sh
  eval $(minikube docker-env)
  # Переходим в склониную репу
  # cd ./oncall
  docker build --no-cache -t oncall:latest .
  # Check that image of oncall now in minikube
  docker images
  ```
  ```md
  REPOSITORY                                TAG        IMAGE ID       CREATED         SIZE
  oncall                                    latest     7e72879b6da6   2 minutes ago   717MB
  registry.k8s.io/kube-apiserver            v1.31.0    cd0f0ae0ec9e   3 months ago    91.5MB
  registry.k8s.io/kube-controller-manager   v1.31.0    fcb0683e6bdb   3 months ago    85.9MB
  registry.k8s.io/kube-scheduler            v1.31.0    fbbbd428abb4   3 months ago    66MB
  registry.k8s.io/kube-proxy                v1.31.0    71d55d66fd4e   3 months ago    94.7MB
  registry.k8s.io/etcd                      3.5.15-0   27e3830e1402   3 months ago    139MB
  registry.k8s.io/pause                     3.10       afb61768ce38   5 months ago    514kB
  registry.k8s.io/coredns/coredns           v1.11.1    2437cf762177   15 months ago   57.4MB
  gcr.io/k8s-minikube/storage-provisioner   v5         ba04bb24b957   3 years ago     29MB
  ```

  ```yml
  # config.yml
  oncall.conf: |
    ---
    metrics: prometheus
    # ...
    prometheus:
        oncall-notifier:
        server_port: 9091
  ```
  - вытащить дополнительные порты в Deployment и Service
  ```yml
  # deployment.yml
  ports:
    - containerPort: 8080
    - containerPort: 9091 # Вытаскиваем дополнительные порты в Deployment
  ```
  ```yml
  # service.yml
  ports:
    - protocol: TCP
      port: 8000
      targetPort: 8000
  ```
  - прописать новый path в Ingress
  ```yml
  # ingress.yml
  pathType: Prefix
  metrics:
    service:
      name: oncall
      port:
        number: 8080
  ```

- Добавить адрес с метриками в target Prometheus prometheus.yml
- Сделать запрос к метрикам Oncall

0 добавить адрес будущей локальной инсталляции OnCall в /etc/hosts
```sh
127.0.0.1 oncall.local
127.0.0.1 oncall.metrics.local
```

1. Включаем ingress в minikube
```sh
minikube addons enable ingress
```

2. Проверяем запустился ли ingress controller
```sh
kubectl get pods -n ingress-nginx
```

3. Применяем манифесты
```sh
kubectl apply -f <folder>
```


Делаем ingress доступным на хостовой машине, это связано с особенностями minikube. Не закрываем данное окно!!!
```
minikube tunnel
```

NB.
Обязательно нужно чекнуть что это гавно поднялось:
```sh
kubectl exec -it имя_пода_с_oncall -- bash
```
Для отвратительнейший шел, в котором нужно чекнуть типа:
```sh
# По этому пути лежат гавно логи
# ls /home/oncall/var/log/uwsgi
# в файлике error.log


# Все заебумба если он не падает
cat /home/oncall/var/log/uwsgi/error.log | grep notifier
```

```
2024-11-17 13:36:57,683 INFO root Setting metrics gauge message_blackhole_cnt to 0
2024-11-17 13:36:57,684 INFO root Setting metrics gauge message_sent_cnt to 0
2024-11-17 13:36:57,684 INFO root Setting metrics gauge message_fail_cnt to 0
```


## 2 задание
Включить метрики Oncall и добавить их targetом в Prometheus.

Включить метрики в формате prometheus в приложении Oncall
Меняем Dockerfile
```Dockerfile
```
Смтоим как метрики используются, для модификаций кофигмапа
```py
# linkedin src/oncall/metrics
config['prometheus'][appname]['server_port']
```

```yml
prometheus

    server_port
```





добавил CLUSTER-IP сервиса в етс хостс
10.106.81.214

Проверим что ингресс применился
```
kubectl get ingress
kubectl describe ingress
```


Увеличиваем скрейп интервалы и
--add-host=host.docker.internal:host-gateway
