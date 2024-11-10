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
.PHONY: deploy destroy metrics
deploy:
	minikube start

metrics:
	docker run \
        -p 9090:9090 \
        -v ./prometheus-on-call/build/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml \
        prom/prometheus

destroy:
	minikube delete --all
