# COMANDOS USADOS EN LA DEMO

## Crear cluster de dos nodos (1 master + 1 worker)
 ```
sudo kubeadm init --apiserver-advertise-address=192.168.1.183 --pod-network-cidr=192.168.0.0/16
 ```
 ```
mkdir -p $HOME/.kube

  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

  sudo chown $(id -u):$(id -g) $HOME/.kube/config
 ```

Este comando debe dar el control-plane NotReady porque no hay CNI:
```
kubectl get nodes 
 ```

## Instalar CNI (red de comunicacion de pods)
 ```
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.30.2/manifests/calico.yaml
 ```
 
 ```
kubectl get pods -n kube-system
 ```

Si ponemos este comando ya si debe dar Ready:
 ```
kubectl get nodes
 ```

## Añadir el segundo nodo al cluster (1 master + 1 worker)
Debemos copiar en el worker1 el **join** que nos ha dado al final el comando **kubeadm init** (con el sudo delante)

Si ponemos este comando en el master nos debe aparecer el control-plane y el worker1:
 ```
kubectl get nodes
 ```

## Añadir un tercer nodo (1 master + 2 worker)
en el master ponemos:
 ```
sudo kubeadm token create --print-join-command
 ```

y copiamos el join en el worker2 (con el sudo delante)

Si ponemos en el master el siguiente comando veremos los 3 nodos listos:
 ```
 kubectl get nodes -o wide
 ```

Para etiquetar a los nodos workers ponemos:
 ```
kubectl label node k8s-worker1 node-role.kubernetes.io/worker=worker
kubectl label node k8s-worker2 node-role.kubernetes.io/worker=worker
 ```

## Desplegar la aplicacion
 ```
nano nginx-deploy.yaml
 ```

 ```
kubectl apply -f nginx-deploy.yaml
 ```

## Comprobar el estado del despliegue
 ```
k9s
 ```

 ```
kubectl get deploy
 ```

 ```
kubectl get pods -o wide
 ```

 ```
kubectl get svc
 ```



## Acceso al servicio
http://localhost:30080


## Eliminar despliegue
 ```
kubectl delete -f nginx-deploy.yaml
 ```

 ```
kubectl get svc
 ```

 ```
kubectl get pods
 ```

 ```
kubectl get deploy
 ```

## Eliminar cluster poner en el master y workers 
 ```
sudo kubeadm reset -f
 ```

 ```
sudo rm -rf ~/.kube
sudo rm -rf /etc/cni/net.d
sudo rm -rf /etc/kubernetes
 ```
