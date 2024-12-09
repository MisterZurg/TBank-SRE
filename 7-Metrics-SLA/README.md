# Домашнее задание №7 "Метрики. SLA."

TODO FIX lab 5

## 1,2 задания

Написать пробер на Oncall и настроить сбор метрик в Prometheus с пробера

Написать свой пробер Oncall
Создать Docker образ с пробером
Запустить контейнер из образа с пробером в minikube
Настроить сбор метрик с пробера в Prometheus

## 2 задание
Домашнее задание

Написать программу подсчета SLA Oncall

Написать программу для подсчета SLA Oncall
Создать Docker образ с пробером
Запустить контейнер из образа с пробером в minikube
Настроить сбор метрик с пробера в Prometheus


```
---
config:
  look: handDrawn
  theme: neutral
---
architecture-beta
    %% solar:crown-minimalistic-bold
    service sla_app(akar-icons:crown)[sla]
    service prober_app(akar-icons:crown)[prober]

    service sla_app_dockerfile(nonicons:docker-16)[Dockerfile]
    service prober_app_dockerfile(nonicons:docker-16)[Dockerfile]


    group api(nonicons:kubernetes-16)[minikube]

    service sla_app_pod(pajamas:pod)
    service prober_app_pod(pajamas:pod)
    service prometheus(simple-icons:prometheus)
```


prometheus
-->
pod SLA самописный
-->
pod Проббер самописный
-->
pod OnCall


## Dependencies
[nim-metrics](https://github.com/status-im/nim-metrics) — Nim metrics client library supporting the Prometheus monitoring toolkit, StatsD and Carbon


https://artifacthub.io/packages/helm/traefik/traefik/32.1.1?modal=values
