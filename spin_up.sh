#!/bin/bash


kind create cluster --config ./kind-config.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml

kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

kubectl apply -f k8s/usage.yaml

sleep 60

# should output "foo"
curl localhost/foo
# should output "bar"
curl localhost/bar