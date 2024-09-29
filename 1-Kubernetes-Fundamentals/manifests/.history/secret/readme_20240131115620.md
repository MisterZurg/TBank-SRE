# Secret

1) Создаем секрет

Для этого выполним команду:

```bash
kubectl create secret generic test --from-literal=test1=asdf
kubectl get secret
kubectl get secret test -o yaml
```

2) Применим наш деплоймент

Для этого выполним команду:

```bash
kubectl apply -f .
```

3) Проверяем результат

Для этого выполним команду, подставив вместо < RANDOM > нужное значение(`автоподстановка по TAB`):

```bash
kubectl describe pod my-deployment-< RANDOM >
```

Результат должен содержать:

```bash
Environment:
      TEST:    foo
      TEST_1:  <set to the key 'test1' in secret 'test'>  Optional: false
```

