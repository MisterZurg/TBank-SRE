########################################################################
### K8S Version										      			  ##
########################################################################
.PHONY: deploy destroy nms sva

deploy:
	minikube start --profile t-bank-sre-course

sva:
	kubectl create serviceaccount t-bank-sre-course

destroy:
	minikube delete --all
