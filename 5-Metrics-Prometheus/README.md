# Домашнее задание №5 "Метрики. Prometheus"
>
> Домашнее задание по разворачиванию Prometheus:
- можно выполнить на локальном компьютере используя docker-compose, просто развернув prometheus из образа официальной документации https://prometheus.io/docs/prometheus/latest/installation/
- можно выполнив команды представленные ниже на виртуальной машине

## 1 задание
Домашнее задание по разворачиванию Prometheus:
Включить метрики в формате prometheus в приложении Oncall
- для этого придется пересобрать Dockerfile с установкой prometheus_client
  ```dockerfile
  # Включить метрики в формате prometheus в приложении Oncall,
  # пересобираем Dockerfile с установкой prometheus_client
  RUN pip install prometheus_client
  ```

  ```sh
  eval $(minikube docker-env)

  docker build -t oncall:latest .
  ```
  - вытащить дополнительные порты в Deployment и Service
  ```yml
  # deployment.yml
  # spec:
    containers:
    - name: oncall
      image: oncall:latest
      port: 8000
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


## 2 задание
Домашнее задание по разворачиванию Prometheus:
