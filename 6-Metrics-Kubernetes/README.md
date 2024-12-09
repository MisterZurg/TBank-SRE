# 6 "Метрики. Kubernetes"
## 1 задание
Домашнее задание по добавлению наблюдаемости за Kubernetes в Prometheus:
- шаги приведенные ниже можно выолнить на логальной машите где есть установленный minikube
- можно выполнив команды представленные ниже на виртуальной машине с minikube
```sh
# Добавляем плагин для больего количества метрик
minikube addons enable metrics-server

# Для получения метрик k8s будем использовать kube-state-metrics
# https://github.com/kubernetes/kube-state-metrics/
# Отличная практика для разных сущностей в k8s создавать отдельный namespace
kubectl create namespace kube-state-metrics

# Создаем deployment используюя официальный YAML
kubectl apply -f kube-state-metrics-deployment.yaml

# применяем файл с сервисом kube-state-metrics-service.yaml
kubectl apply -f kube-state-metrics-service.yaml

# Добавляем публикацию на ingress
kubectl apply -f kube-state-metrics-ingress.yaml

# Добавляем IP адресс в /etc/hosts (Пример для Linux)
# echo "$(minikube ip) kube-state-metrics.local" | sudo tee -a /etc/hosts
echo "127.0.0.1 kube-state-metrics.local" | sudo tee -a /etc/hosts

```
Посмотрите полученные метрики
```sh
curl http://kube-state-metrics.local/
```

## 2 задание
Постоянное наблюдение за кластером
- Добавить метрики k8s в Prometheus.
- продемонстрировать метрики кластера в UI Prometheus
- Изучить получаемые от кластера метрики и поделиться теми которые вас заинтересовали.

> [!IMPORTANT]
> Я воспользовался готовым решением развернув [Prometheus Operator](https://prometheus-operator.dev/)

```sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install kps prometheus-community/kube-prometheus-stack

# Прокинем порт, на под с прометеем чтобы постучаться на localhost:9090
kubectl port-forward prometheus-kps-kube-prometheus-stack-prometheus-0 9090
```

Критерии оценки:
2 бала - метрики настроены и работают
2 бала - за раскрытие исследования метрик


TODO поднять kube-state-metrics/
- 1) Дать права сервис акку
- 2) Либо поднять версию
