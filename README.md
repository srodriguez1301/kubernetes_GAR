# DEMO

## Instalacion de docker, kubectl, kind y k9s
docker ps

kubectl version --client

kind --version

k9s version


## Crear cluster de dos nodos (1 master + 1 worker)
nano cluster-2nodos.yaml

kind create cluster --name mi-cluster --config cluster-2nodos.yaml

kubectl get nodes -o wide



## Crear cluster de tres nodos (1 master + 2 worker)
kind delete cluster --name mi-cluster

nano cluster-2nodos.yaml

kind create cluster --name mi-cluster --config cluster-3nodos.yaml

kubectl get nodes -o wide


## Desplegar la aplicacion
nano nginx-deploy.yaml

kubectl apply -f nginx-deploy.yaml


## Comprobar el estado del despliegue
k9s

kubectl get deploy web-nginx

kubectl get pods -o wide

kubectl get svc web-nginx-svc

kubectl describe deploy web-nginx

kubectl describe svc web-nginx-svc


## Acceso al servicio
kubectl port-forward svc/web-nginx-svc 30080:80

http://localhost:30080


## Eliminar el despliegue
kubectl delete -f nginx-deploy.yaml

kind delete cluster --name mi-cluster

kubectl get all
