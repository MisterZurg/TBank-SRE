# Problem 5.1
########################################################################
### Docker CumPose Version										      ##
########################################################################
.PHONY: up down
up:
	docker compose -f ./docker-compose.yml rm && \
	docker compose -f ./docker-compose.yml build --no-cache && \
	docker compose -f ./docker-compose.yml up --detach

down:
	docker-compose -f ./docker-compose.yml down


# Problem 5.2
.PHONY: deploy destroy metrics metrics-up
deploy:
	minikube start

helm-metrics:
	helm install -f ./prometheus-on-call/helm/prometheus-values.yml prometheus prometheus-community/prometheus

helm-down:
	helm uninstall prometheus

destroy:
	minikube delete --all


# prometheus-server-5f75d65fbc-8j84g
# kubectl port-forward prometheus-server 9090
F
