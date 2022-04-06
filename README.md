Scheduling Demo
===============
![demo page](./public/demo-page.png)
start local server
------------------

1) `bundle install`

2) create `.env` file
```
DB_USERNAME={username}
DB_PASSWORD={password}
```

3) database setting
```
mysql.server start

rails db:create
rails db:migrate
rails db:seed
```

4) `rails s`

5) visit `http://localhost:3000/schedule`


cluster test
------------
로컬 클러스터에 실제로 스케줄링 앱을 배포 해서, pod가 여러개 띄워져 있을 때 CronJob 이 중복 되지는 않는지, pod를 죽였을 때 어떻게 동작하는지와 같은 것들을 테스트 해봅시다.
1) create new local cluster
```
minikube start
```

2) build and push docker image
```
docker build -t jjmmyyou111/schedule-app .
docker push jjmmyyou111/schedule-app:latest
``` 

3) deploy resources
```
kubectl apply -f ./cluster/redis.yaml
kubectl apply -f ./cluster/mysql.yaml
kubectl apply -f ./cluster/app.yaml
```

4) db setting
```
kubectl get pods
kubectl exec -it po/<schedule-app pod> -c schedule-app -- sh

rails db:create
rails db:migrate
rails db:seed
```
5) 포트 포워딩으로 app에 접속하기  
  
[kubernetes port-forward doc](https://kubernetes.io/ko/docs/tasks/access-application-cluster/port-forward-access-application-cluster/)  

```
kubectl port-forward service/schedule-service 3000:3000
```
6) visit `localhost:3000` !

<br>

디버깅

```
kubectl logs -f <pod> -c schedule-app

apk add --update curl
curl -X GET -H "Content-Type: application/json" localhost:3000/schedule/2022-04-05
```

-------------------------
(참고) app에 접속하는 다른 방법  
-> 안됨.. 🤬

```
minikube dashboard
minikube tunnel
```
  
[minikube - Accessing apps](https://minikube.sigs.k8s.io/docs/handbook/accessing/)  
- NodePort  
  opens a specific port, and any traffic that is sent to this port is forwarded to the service.
  ```
  minikube service --url <service-name>
  ```
- LoadBalancer  
  standard way to expose a service to the internet. With this method, each service gets its own IP address.  
  `minikube tunnel` runs as a process, creating a **network route on the host to the service CIDR** of the cluster using the cluster’s IP address as a gateway.
  ```
  minikube tunnel
  ```




ingress  
[minikube-ingerss](https://kubernetes.io/ko/docs/tasks/access-application-cluster/ingress-minikube/)  
