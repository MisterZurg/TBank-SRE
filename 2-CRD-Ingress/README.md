# №2 CRD. Ingress

Проверяем настройку прокси:
```sh
export http_proxy='http://10.128.0.4:3128'
export https_proxy='http://10.128.0.4:3128'
export no_proxy='localhost,127.0.0.1,.1,.2,.3::1,.local'
```

1. Включаем ingress в minikube
```sh
minikube addons enable ingress
```

2. Проверяем запустился ли ingress controller
```sh
kubectl get pods -n ingress-nginx
```

```
NAME READY STATUS RESTARTS AGE
ingress-nginx-admission-create-g9g49 0/1 Completed 0 11m
ingress-nginx-admission-patch-rqp78 0/1 Completed 1 11m
ingress-nginx-controller-59b45fb494-26npt 1/1 Running 0 11m
```

3. Запускаем hello-world
```sh
kubectl create deployment web --image=gcr.io/google-samples/hello-app:1.0
```

4. Создаем сервис типа NodePort
```sh
kubectl expose deployment web --type=NodePort --port=8080
```

5. Создаем ingress-resource
```sh
kubectl apply -f example-ingress.yaml
example-ingress.yaml 0.38 КБ
```

6. Проверяем, что ingress-resource появился
```sh
kubectl get ingress

NAME CLASS HOSTS ADDRESS PORTS AGE
example-ingress <none> hello-world.local 172.17.0.15 80 38s
```

7.1 (для виртуальных машин) Делаем ingress доступным на внешнем интерфейсе виртуальной машины
```sh
MINIKUBE_IP=$(./minikube ip)
sudo iptables -P FORWARD ACCEPT
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to-destination $(echo $MINIKUBE_IP):80
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
# Правила iptables работают до перезагрузки виртуальной машины
```


7.2 (для всех остальных) Делаем ingress доступным на хостовой машине, это связано с особенностями minikube. Не закрываем данное окно!!!
```sh
minikube tunnel
```

8. Ingress на входе ожидает хост hello-world.local, поэтому нужно добавить мапинг на хостовой машине в файл vo для UNIX-based систем.
```sh
127.0.0.1 hello-world.local     # для варианта с minikube tunnel
<EXTERNAL_IP> hello-world.local # для варианта с виртуальными машинами
```

В качестве решения приложите видеозапись экрана, на которой демонстрируются:

вывод команды curl http://hello-world.local
процесс выполнения инструкций
