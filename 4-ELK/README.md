# Домашнее задание №4 "Логирование. Elasticsearch + Kibana"
> [!INFO]
> Делал на VM поэтому подробно опишу настройки

### Базовая настройка машин для студентов
Настроить системные прокси

Добавить строки в **/etc/environment**
```sh
sudo vim /etc/environmen
```
```sh
# Добавить строки
export http_proxy='http://10.128.0.4:3128'
export https_proxy='http://10.128.0.4:3128'
export no_proxy='localhost,127.0.0.1,.1,.2,.3::1'
```

Установить докер и дать пользователю права на работу с ним
```sh
sudo apt install docker.io
sudo usermod -aG docker $USER && newgrp docker
```

Minikube set-down
```sh
# 1 Installation
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
sudo install minikube-darwin-amd64 /usr/local/bin/minikube
# minikube addons enable ingress
```
и сделать релогин в систему

## Установить прокси для докера
```json
# Положить в /etc/docker/daemon.json
{
  "proxies": {
    "http-proxy": "http://10.128.0.4:3128",
    "https-proxy": "http://10.128.0.4:3128",
    "no-proxy": "localhost,127.0.0.0/8,192.168.0.0/16,10.0.0.0/8"
  }
}
```

Перезапустить докер
```sh
systemctl restart docker
```

## Установка minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube
./minikube start


!!! Обратите внимание, в настройках системного no_proxy задаётся список исключений, в этот список обязательно должны попасть endpoint'ы устанавливаемого MINIKUBE.


## 1 задание Установка Elasticsearch + kibana
### Установка Elasticsearch + kibana
> [!IMPORTANT]
> В данном случае мы рассматриваем установку ES + Kibana в stand-alone режиме, т.е. вне kubernetes.
> Также отключается *все средства безопасности* ES (так нельзя делать на проде, но у нас лаба, на лабе можно).

1. Выполните шаги из файла 01.step.sh
Желательно вдумчиво в ручном режиме, но скрипт тоже должен успешно отработать.
Запуск ES+Kibana может занять значительное время (около 5 минут), поэтому перед выполнением следующего шага необходимо подождать.

Если kibana в логах (/var/log/kibana/) будет писать об ошибках подключения к Elasticsearch, то проверьте, не использует ли она схему `https` в конфигурационном файле /etc/kibana/kibana.yml; `https://` необходимо заменить на `http://` и перезапустить кибану

**Обратите внимание**
> Elasticsearch может падать при запуске по причине таймаута, т.к. его запуск может занимать слишком много времени. В этом случае в systemd unit'е для ES необходимо увеличить таймаут ожидания, сделать
`systemd daemon-reload` и заново запустить elasticsearch.


2. Примените манифест с установкой fluentd - демона, который в режиме daemonset будет запускаться на всех хостах кластера
kubernetes, собирать и отправлять логи в elastcisearch.

3. Если у вас не настроены алиасы, но самое время их настроить.
Считаем, что файл `minikube` находится по пути `/home/ubuntu/minikube`, тогда в файле `/home/ubuntu/.bashrc` необходимо добавить строки:
```sh
alias minikube='/home/ubuntu/minikube'
alias kubectl='/home/ubuntu/minikube kubectl --'
alias k='/home/ubuntu/minikube kubectl --'
```
и сделать релогин.

## 3. Проверьте логи fluentd:
### 3.1. Определите название пода с fluentd и его статус:
```
k get pods -A
```
3.2. Посмотрите логи:
```
k logs fluentd-v22fk -n kube-system
```
пример вывода:
```
NAMESPACE       NAME                                       READY   STATUS      RESTARTS       AGE
ingress-nginx   ingress-nginx-admission-create-t9tcg       0/1     Completed   0              10h
ingress-nginx   ingress-nginx-admission-patch-jjlmx        0/1     Completed   0              10h
ingress-nginx   ingress-nginx-controller-bc57996ff-wtcxk   1/1     Running     0              10h
kube-system     coredns-6f6b679f8f-b8jvj                   1/1     Running     5 (11h ago)    3d12h
kube-system     etcd-minikube                              1/1     Running     5 (11h ago)    3d12h
kube-system     fluentd-v22fk                              1/1     Running     0              10h
kube-system     kube-apiserver-minikube                    1/1     Running     5 (10h ago)    3d12h
kube-system     kube-controller-manager-minikube           1/1     Running     5 (11h ago)    3d12h
kube-system     kube-proxy-jwj7m                           1/1     Running     5 (11h ago)    3d12h
kube-system     kube-scheduler-minikube                    1/1     Running     5 (11h ago)    3d12h
kube-system     storage-provisioner                        1/1     Running     15 (10h ago)   3d12h
```

В логах должно быть написано, что fluentd начал успешно читать логи контейнеров, к примеру вот так:
```
2024-10-12 22:26:27 +0000 [info]: #0 starting fluentd worker pid=243 ppid=7 worker=0
2024-10-12 22:26:27 +0000 [info]: #0 [in_tail_container_logs] following tail of /var/log/containers/coredns-6f6b679f8f-b8jvj_kube-system_coredns-331725919ccfad73acd0850f7ae8c392b38636af509f85543628433f88b27b45.log
2024-10-12 22:26:27 +0000 [info]: #0 [in_tail_container_logs] following tail of /var/log/containers/coredns-6f6b679f8f-b8jvj_kube-system_coredns-dfa90afc529a1a99fc176be5bdad7e1c44ac1fdcc2b274425b58d85eb002b211.log
2024-10-12 22:26:27 +0000 [info]: #0 [in_tail_container_logs] following tail of /var/log/containers/etcd-minikube_kube-system_etcd-59979934551ac656cea00aabb2b686d974ad213dc3fa400059c1aecfdfe6b833.log
2024-10-12 22:26:27 +0000 [info]: #0 [in_tail_container_logs] following tail of /var/log/containers/etcd-minikube_kube-system_etcd-929ca1059a436af3d95e8e9048ed503cb170f6fafdb27be7aea86769b2d1d4a0.log
2024-10-12 22:26:27 +0000 [info]: #0 [in_tail_container_logs] following tail of /var/log/containers/fluentd-v22fk_kube-system_fluentd-f1d4a1933cf28f44672df61d0e9c70a9ec930639ba29999706bc9eb5eacc17f7.log
2024-10-12 22:26:27 +0000 [info]: #0 [in_tail_container_logs] following tail of /var/log/containers/kube-apiserver-minikube_kube-system_kube-apiserver-4cf065e4d15dee1eafde4f1a7dd4043b4533f898e37e12aa95c3d22b8be24428.log
2024-10-12 22:26:27 +0000 [info]: #0 [in_tail_container_logs] following tail of /var/log/containers/kube-apiserver-minikube_kube-system_kube-apiserver-59e70596a72dec9880ec59b69f648fdd8543ab25700daf677a213674888f45ee.log
2024-10-12 22:26:27 +0000 [info]: #0 [in_tail_container_logs] following tail of /var/log/containers/kube-controller-manager-minikube_kube-system_kube-controller-manager-9fb6e69460d04ab4bc48dd2f1f506e51b60f48bfccab648f5209daa5a3b7a8e2.log
2024-10-12 22:26:27 +0000 [info]: #0 [in_tail_container_logs] following tail of /var/log/containers/kube-controller-manager-minikube_kube-system_kube-controller-manager-bc26df74d1bbdc412e0acaba8d77d6d65f34f87550c2f900a5edfa68c1f337a9.log
2024-10-12 22:26:27 +0000 [info]: #0 [in_tail_container_logs] following tail of /var/log/containers/kube-proxy-jwj7m_kube-system_kube-proxy-2f00ee44d3b3a7b18a7aef3031e73e81e4d2560643f86b0c861805ce929eeb0c.log
2024-10-12 22:26:27 +0000 [info]: #0 [in_tail_container_logs] following tail of /var/log/containers/kube-proxy-jwj7m_kube-system_kube-proxy-7d307fb1d0bcf004bf55f46473e781a4107820d268874736529fc3be35ad3789.log
```

4. Теперь пора настраивать kibana, для этого переходите по адресу вашей вирутальной машины: `http://VM_IP_ADDRESS:5601/app/management/kibana/dataViews` для создания DataView, в поле "name" укажите "logstash-*" и нажмите на "Create DataView"

http://10.128.0.105:5601/app/management/kibana/dataViews

5. После создания DataView вы можете создавать собственные дашборды или просто смотреть логи.
В разделе [menu] Discover будут доступны логи
