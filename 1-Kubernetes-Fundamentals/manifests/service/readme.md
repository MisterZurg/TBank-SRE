# Service

1) Проверяем что лэйблы на наших подах совпадают с тем, что у нас указано в labelSelector в service.yaml

Для этого выполним команду:

```bash
kubectl get po --show-labels
```

Результат должен быть примерно следующим:

```bash
NAME                             READY     STATUS    RESTARTS   AGE       LABELS
my-deployment-5b47d48b58-dr9kk   1/1       Running   0          15s       app=my-app,pod-template-hash=1603804614
my-deployment-5b47d48b58-r95lt   1/1       Running   0          15s       app=my-app,pod-template-hash=1603804614
```

2) Создаем сервис

Для этого выполним команду:

```bash
kubectl apply -f .
```

3) Проверяем что сервис есть

Для этого выполним команду:

```bash
kubectl get service
```

Результат должен быть примерно следующим:

```bash
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
my-service   ClusterIP   10.108.197.224   <none>        80/TCP    2s
```

4) Смотрим, что сервис действительно увидел наши поды и собирается проксировать на них трафик

Для этого выполним команду:

```bash
kubectl get endpoints
```

Результат должен быть примерно следующим:

```
NAME         ENDPOINTS                     AGE
my-service   172.17.0.6:80,172.17.0.7:80   1m
```

5) Смотрим, что IP эндпоинтов сервиса это действительно IP наших подов

Для этого выполним команду:

```
kubectl get pod -o wide
```

Результат должен быть примерно следующим:

```bash
NAME                             READY     STATUS    RESTARTS   AGE       IP           NODE
my-deployment-5b47d48b58-dr9kk   1/1       Running   0          3m        172.17.0.7   node-1
my-deployment-5b47d48b58-r95lt   1/1       Running   0          3m        172.17.0.6   node-2
```

6) Запускаем тестовый под для проверки сервиса

Для этого выполним команду:

```bash
kubectl run -t -i --rm --image centosadmin/utils test bash
```

7) Дальше уже из этого пода выполняем

Для этого выполним команду:

```bash
curl -i my-service
```

Результат должен быть примерно следующим:

```bash
HTTP/1.1 200 OK
Server: nginx/1.12.2
Date: Sun, 27 Jan 2019 13:36:20 GMT
Content-Type: application/octet-stream
Content-Length: 31
Connection: keep-alive

my-deployment-5b47d48b58-r95lt

```

8) Выходим из тестового пода

Для этого выполним команду:

```bash
exit
```

