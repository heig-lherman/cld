# Task 2 - Deploy the application in Kubernetes Engine

In this task you will deploy the application in the public cloud service Google Kubernetes Engine (GKE).

## Subtask 2.1 - Create Project

Log in to the Google Cloud console at <http://console.cloud.google.com/>, navigate to the __Resource Manager__ (<https://console.cloud.google.com/cloud-resource-manager>) and create a new project. 

## Subtask 2.2 - Create a cluster

Go to the Google Kubernetes Engine (GKE) console (<https://console.cloud.google.com/kubernetes/>). If necessary, enable the Kubernetes Engine API. Then create a cluster. 

* Choose a __GKE Standard__ cluster. (Please ensure that you are not using the Autopilot. The button to switch to Standard could be a bit tricky to find...)
* Give it a __name__ of the form _gke-cluster-1_
* Select a __region__ close to you.
* Set the __number of nodes__ to 2. 
* Set the __instance type__ to micro instances.
* Set the __boot disk size__ to 10 GB.
* Keep the other settings at their default values.

## Subtask 2.3 - Deploy the application on the cluster

Once the cluster is created, the GKE console will show a __Connect__ button next to the cluster in the cluster list. Click on it. A dialog will appear with a command-line command. Copy/paste the command and execute it on your local machine. This will download the configuration info of the cluster to your local machine (this is known as a _context_). It also changes the current context of your `kubectl` tool to the new cluster.

To see the available contexts, type :

```sh
$ kubectl config get-contexts
```

You should see two contexts, one for the Minikube cluster and one for the GKE cluster. The current context has a star `*` in front of it. The `kubectl` commands that you type from now on will go to the cluster of the current context.

With that you can use `kubectl` to manage your GKE cluster just as you did in task 1. Repeat the application deployment steps of task 1 on your GKE cluster.

Should you want to switch contexts, use :

```sh
$ kubectl config use-context <context>
```

## Subtask 2.4 - Deploy the ToDo-Frontend Service

On the Minikube cluster we did not have the possibility to expose a service on an external port, that is why we did not create a Service for the Frontend. Now, with the GKE cluster, we are able to do that.

Using the `redis-svc.yaml` file as an example, create the `frontend-svc.yaml` configuration file for the Frontend Service.

Unlike the Redis and API Services the Frontend needs to be accessible from outside the Kubernetes cluster as a regular web server on port 80.

  * We need to change a configuration parameter. Our cluster runs on the GKE cloud and we want to use a GKE load balancer to expose our service.
  * Read the section "Publishing Services - Service types" of the K8s documentation 
    <https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types>
  * Deploy the Service using `kubectl`.

This will trigger the creation of a load balancer on GKE. This might take some minutes. You can monitor the creation of the load balancer using `kubectl describe`.

### Verify the ToDo application

Now you can verify if the ToDo application is working correctly.

  * Find out the public URL of the Frontend Service load balancer using `kubectl describe`.
  * Access the public URL of the Service with a browser. You should be able to access the complete application and create a new ToDo.


## Deliverables

Document any difficulties you faced and how you overcame them. Copy the object descriptions into the lab report (if they are unchanged from the previous task just say so).

> The cluster creation was straightforward, though extremely slow. The objects were easily transferred to the cluster and the application was deployed with only one issue.
> The default docker registry for google cloud is `gcr.io` and not `docker.io`. We had to change the image names in the deployment files to reflect this.

```
> lhheigvd@cloudshell:~/files (heig-vd-cld)$ kubectl describe all

Name:             api
Namespace:        default
Priority:         0
Service Account:  default
Node:             gke-gke-cluster-1-default-pool-a6ea258a-7j3w/10.132.0.3
Start Time:       Thu, 02 May 2024 14:22:27 +0000
Labels:           app=todo
                  component=api
Annotations:      <none>
Status:           Running
IP:               10.92.0.8
IPs:
  IP:  10.92.0.8
Containers:
  api:
    Container ID:   containerd://89b958d07da4a006bb4b49e1cde8113a9449292a16bf49dc3837e858749dda3a
    Image:          docker.io/icclabcna/ccp2-k8s-todo-api
    Image ID:       docker.io/icclabcna/ccp2-k8s-todo-api@sha256:13cb50bc9e93fdf10b4608f04f2966e274470f00c0c9f60815ec8fc987cd6e03
    Port:           8081/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Thu, 02 May 2024 14:22:28 +0000
    Ready:          True
    Restart Count:  0
    Environment:
      REDIS_ENDPOINT:  redis-svc
      REDIS_PWD:       ccp2
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-sts6g (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  kube-api-access-sts6g:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  2m15s  default-scheduler  Successfully assigned default/api to gke-gke-cluster-1-default-pool-a6ea258a-7j3w
  Normal  Pulling    2m15s  kubelet            Pulling image "docker.io/icclabcna/ccp2-k8s-todo-api"
  Normal  Pulled     2m14s  kubelet            Successfully pulled image "docker.io/icclabcna/ccp2-k8s-todo-api" in 162ms (162ms including waiting)
  Normal  Created    2m14s  kubelet            Created container api
  Normal  Started    2m14s  kubelet            Started container api


Name:             frontend
Namespace:        default
Priority:         0
Service Account:  default
Node:             gke-gke-cluster-1-default-pool-a6ea258a-63k7/10.132.0.4
Start Time:       Thu, 02 May 2024 14:23:23 +0000
Labels:           app=todo
                  component=frontend
Annotations:      <none>
Status:           Running
IP:               10.92.1.10
IPs:
  IP:  10.92.1.10
Containers:
  api:
    Container ID:   containerd://ff0808704e62bc61d4237b3eb1fcb3f38b7b1f60f9c04c3e91f29cb6be2b2a19
    Image:          docker.io/icclabcna/ccp2-k8s-todo-frontend
    Image ID:       docker.io/icclabcna/ccp2-k8s-todo-frontend@sha256:5892b8f75a4dd3aa9d9cf527f8796a7638dba574ea8e6beef49360a3c67bbb44
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Thu, 02 May 2024 14:23:41 +0000
    Ready:          True
    Restart Count:  0
    Environment:
      API_ENDPOINT_URL:  http://api-svc:8081
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-kknwq (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  kube-api-access-kknwq:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  79s   default-scheduler  Successfully assigned default/frontend to gke-gke-cluster-1-default-pool-a6ea258a-63k7
  Normal  Pulling    68s   kubelet            Pulling image "docker.io/icclabcna/ccp2-k8s-todo-frontend"
  Normal  Pulled     64s   kubelet            Successfully pulled image "docker.io/icclabcna/ccp2-k8s-todo-frontend" in 4.248s (4.249s including waiting)
  Normal  Created    63s   kubelet            Created container api
  Normal  Started    61s   kubelet            Started container api


Name:             redis
Namespace:        default
Priority:         0
Service Account:  default
Node:             gke-gke-cluster-1-default-pool-a6ea258a-63k7/10.132.0.4
Start Time:       Thu, 02 May 2024 14:15:07 +0000
Labels:           app=todo
                  component=redis
Annotations:      <none>
Status:           Running
IP:               10.92.1.9
IPs:
  IP:  10.92.1.9
Containers:
  redis:
    Container ID:  containerd://92b9bd9e8269b7c198c54df03d2974907919571105c46977391ebe31399ffa41
    Image:         redis
    Image ID:      docker.io/library/redis@sha256:f14f42fc7e824b93c0e2fe3cdf42f68197ee0311c3d2e0235be37480b2e208e6
    Port:          6379/TCP
    Host Port:     0/TCP
    Args:
      redis-server
      --requirepass ccp2
      --appendonly yes
    State:          Running
      Started:      Thu, 02 May 2024 14:15:21 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-wr7nj (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  kube-api-access-wr7nj:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  9m35s  default-scheduler  Successfully assigned default/redis to gke-gke-cluster-1-default-pool-a6ea258a-63k7
  Normal  Pulling    9m34s  kubelet            Pulling image "redis"
  Normal  Pulled     9m22s  kubelet            Successfully pulled image "redis" in 12.349s (12.349s including waiting)
  Normal  Created    9m21s  kubelet            Created container redis
  Normal  Started    9m21s  kubelet            Started container redis


Name:              api-svc
Namespace:         default
Labels:            component=api
Annotations:       cloud.google.com/neg: {"ingress":true}
Selector:          app=todo,component=api
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.9.106.214
IPs:               10.9.106.214
Port:              http  8081/TCP
TargetPort:        8081/TCP
Endpoints:         10.92.0.8:8081
Session Affinity:  None
Events:            <none>


Name:                     frontend-svc
Namespace:                default
Labels:                   component=frontend
Annotations:              cloud.google.com/neg: {"ingress":true}
Selector:                 app=todo,component=frontend
Type:                     LoadBalancer
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.9.108.77
IPs:                      10.9.108.77
LoadBalancer Ingress:     34.38.173.212
Port:                     http  8080/TCP
TargetPort:               8080/TCP
NodePort:                 http  30782/TCP
Endpoints:                10.92.1.10:8080
Session Affinity:         None
External Traffic Policy:  Cluster
Events:
  Type    Reason                Age                    From                Message
  ----    ------                ----                   ----                -------
  Normal  EnsuringLoadBalancer  4m16s (x2 over 9m35s)  service-controller  Ensuring load balancer
  Normal  EnsuredLoadBalancer   4m11s (x2 over 8m57s)  service-controller  Ensured load balancer


Name:              kubernetes
Namespace:         default
Labels:            component=apiserver
                   provider=kubernetes
Annotations:       <none>
Selector:          <none>
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.9.96.1
IPs:               10.9.96.1
Port:              https  443/TCP
TargetPort:        443/TCP
Endpoints:         10.132.0.2:443
Session Affinity:  None
Events:            <none>


Name:              redis-svc
Namespace:         default
Labels:            component=redis
Annotations:       cloud.google.com/neg: {"ingress":true}
Selector:          app=todo,component=redis
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.9.102.244
IPs:               10.9.102.244
Port:              redis  6379/TCP
TargetPort:        6379/TCP
Endpoints:         10.92.1.9:6379
Session Affinity:  None
Events:            <none>
```````

```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    component: frontend
  name: frontend-svc
spec:
  ports:
  - port: 8080
    targetPort: 8080
    name: http
  selector:
    app: todo
    component: frontend
  type: LoadBalancer
```

Take a screenshot of the cluster details from the GKE console. Copy the output of the `kubectl describe` command to describe your load balancer once completely initialized.

![img](./img/gke-console.png)

```
lhheigvd@cloudshell:~/files (heig-vd-cld)$ kubectl describe svc/frontend-svc

Name:                     frontend-svc
Namespace:                default
Labels:                   component=frontend
Annotations:              cloud.google.com/neg: {"ingress":true}
Selector:                 app=todo,component=frontend
Type:                     LoadBalancer
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.9.108.77
IPs:                      10.9.108.77
LoadBalancer Ingress:     34.38.173.212
Port:                     http  8080/TCP
TargetPort:               8080/TCP
NodePort:                 http  30782/TCP
Endpoints:                10.92.1.10:8080
Session Affinity:         None
External Traffic Policy:  Cluster
Events:
  Type    Reason                Age                  From                Message
  ----    ------                ----                 ----                -------
  Normal  EnsuringLoadBalancer  5m28s (x2 over 10m)  service-controller  Ensuring load balancer
  Normal  EnsuredLoadBalancer   5m23s (x2 over 10m)  service-controller  Ensured load balancer
```