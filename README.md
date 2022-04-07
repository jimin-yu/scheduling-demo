Scheduling Demo
===============
![scheduling](public/scheduling.jpg)
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

4) start server
```
rails s

redis-server
bundle exec sidekiq
```

5) visit `http://localhost:3000/schedule`


cluster test
------------
로컬 클러스터에 실제로 스케줄링 앱을 배포 해서, pod가 여러개 띄워져 있을 때 CronJob 이 중복 되지는 않는지, pod를 죽였을 때 어떻게 동작하는지와 같은 것들을 테스트 해봅시다.

### 환경 구성
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


### 테스트하기
1) 3개의 pod가 띄워진 상태에서 1분 마다 30초 뒤에 PurchaseJob을 실행하도록 하는 ScheduleJob 이라는 CronJob이 실행되고 있는 상태일 때 `localhost:3000/log` 를 방문해서 해당 CronJob이 pod 개수 만큼 중복 실행되고 있지는 않은지 확인한다.
![job execution log](./public/job-execution-log.png)

> Sidekiq-Cron is safe to use with multiple sidekiq processes or nodes. It uses a **Redis sorted set** to determine that only the first process who asks can enqueue scheduled jobs into the queue.

2) schedule-app deployment에 환경 변수 추가해서 전체 pod를 terminating 하고 recreate 했을 때. 어떻게 동작하는지
![job-execution-log2](public/job-execution-log2.png)
15:05 경에 PurchaseJob이 실행안되긴 했는데, 다른 조작 없이 pod Running 시 CronJob이 알아서 재가동 했다. 실제 사입 스케줄링 CronJob은 하루 주기일 테니까 상관 없을 것 같다.


다른 스케줄링 방법과 비교
-------------------
### whenever
시작하기
```ruby
gem 'whenever'
```
```ruby
bundle exec wheneverize .
#=> config/schedule.rb 파일 생성됨
```

스케줄링
```ruby
# config/scheduler.rb

set :output, "log/cron.log"

every 1.minute do 
    command "echo 'hello~'"
end
```
```
whenever --update-crontab
whenever --clear-crontab
crontab -l
```

job_type
```
# default
runner : Rails Console 명령어
rake : lib/tasks 파일 실행 명령어
command : bash 명령어
```

루비 문법을 `리눅스 crontab`으로 변환해주는 편리함이 있다.   
그렇지만 각 dealibird container마다 crontab 프로세스를 각자 중복 실행할 우려.  
사용성도 ActiveJob을 활용하는 방식보다 불편한 것 같다.

### rufus-scheduler
```ruby
# config/initializers/scheduler.rb

require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

s.every '1s' do
  Rails.logger.info "hello, it's #{Time.now}"
end
```
루비 프로세스 내에서 스케줄링 스레드를 띄우는 방식.
>It does not persist your schedules. When the process is gone and the scheduler instance with it, the schedules are gone.  
A rufus-scheduler instance will go on scheduling while it is present among the objects in a Ruby process.

간단하지만 whenever 과 마찬가지로 중복 문제가 있고 ( 각 rails 프로세스의 rufus 스케줄링 스레드마다 cronJob 실행 ),   
sidekiq-cron이나 sidekiq-scheduler 처럼 ui로 편하게 모니터링 할 수 있는 기눙도 없다.  
`whenever` -> os system cron  
`rufus` -> app scheduling thread

### sidekiq-scheduler
채택한 sidekiq-cron 과 비슷.  
두가지를 비교하는 잘 정리 된 글이 있는데 [ruby schedulers](https://medium.com/serpapi/ruby-schedulers-whenever-vs-sidekiq-cron-vs-sidekiq-scheduler-b229d7ca5256)  
1) polling interval  
   sidekiq-cron : 30s (default. 바꿀 수 있음)  
   sidekiq-scheduler : 1s
2) dashboard  
   sidekiq-cron 대시보드가 더 디테일하다.  
   기존 사이드킥 대시보드 페이지의 cron 탭에서 확인할 수 있음.
   ![sidekiq-cron dashboard](public/sidekiq-cron-dashboard.png)

정도가 차이점인 것 같다.

### kubernetes cronJob


### lambda
