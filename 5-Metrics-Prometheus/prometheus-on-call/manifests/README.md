# Домашнее задание №5 "Метрики. Prometheus"

## 2 задание
Включить метрики Oncall и добавить их targetом в Prometheus.

Включить метрики в формате prometheus в приложении Oncall
В склонированном ранее
- для этого придется пересобрать Dockerfile с установкой prometheus_client
  ```dockerfile
  # Включить метрики в формате prometheus в приложении Oncall,
  # пересобираем Dockerfile с установкой prometheus_client
  RUN pip install prometheus_client
  ```
  В миникубе билдим новый образ
  ```sh
  eval $(minikube docker-env)
  #
  # cd ./oncall
  docker build --no-cache -t oncall:latest .
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
