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

kube-state-metrics-deployment.yaml 0.82 КБ
# применяем файл с сервисом kube-state-metrics-service.yaml
kubectl apply -f kube-state-metrics-service.yaml
kube-state-metrics-service.yaml 0.28 КБ
# Добавляем публикацию на ingress
kubectl apply -f kube-state-metrics-ingress.yaml
kube-state-metrics-ingress.yaml 0.44 КБ
# Добавляем IP адресс в /etc/hosts (Пример для Linux)
echo "$(minikube ip) kube-state-metrics.local" | sudo tee -a /etc/hosts
Посмотрите полученные метрики

curl http://kube-state-metrics.local/
```

## 2 задание
Постоянное наблюдение за кластером
- Добавить метрики k8s в Prometheus.
- продемонстрировать метрики кластера в UI Prometheus
- Изучить получаемые от кластера метрики и поделиться теми которые вас заинтересовали.


Предоставить видеоматериалы или скриншоты результата.



Критерии оценки:

2 бала - метрики настроены и работают
2 бала - за раскрытие исследования метрик
