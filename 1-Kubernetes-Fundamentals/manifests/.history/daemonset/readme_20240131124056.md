# DaemonSet

1) Создаем демонсет

```bash
kubectl apply -f daemonset.yml
```

В ответ должны увидеть

```bash
daemonset.apps/node-exporter created
```

2) Смотрим на поды

```bash
kubectl get pod -o wide
```

Видим
```bash
NAME                             READY   STATUS    RESTARTS   AGE
node-exporter-2ch5q              1/1     Running   0          18s
```

