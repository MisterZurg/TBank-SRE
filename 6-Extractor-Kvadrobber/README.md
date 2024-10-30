#

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
