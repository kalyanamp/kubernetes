 #dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.4/aio/deploy/recommended.yaml
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOF


cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF

#Getting a Bearer Token

kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')

http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

#remove dashboad
kubectl -n kubernetes-dashboard delete serviceaccount admin-user
kubectl -n kubernetes-dashboard delete clusterrolebinding admin-user
kubectl delete -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.4/aio/deploy/recommended.yaml


#pod 
apiVersion:
kind: Pod
metadata:
spec: 

kubectl create -f pod.yaml 
kubectl get pods 
kubectl get pods -o wide

kubectl exec -it nginx-pod -- /bin/bash

#service
kubectl create -f sevice.yaml
kubectl get svc 


#################### Docker Node app#
cd nodeapp
# server.js
var http = require('http');

var handleRequest = function(request, response) {
  console.log('Received request for URL: ' + request.url);
  response.writeHead(200);
  response.end('Hello docker, sample kalyan demo app!');
};
var www = http.createServer(handleRequest);
www.listen(8000);


node server.js
http://localhost:8000/


#Dockerfile
FROM node:8
MAINTAINER kalyanachakravarthy
EXPOSE 8000
COPY server.js .
CMD node server.js


docker build -t hello-node:v1 .

kubectl apply -f node-pod.yaml 
kubectl apply -f node-service.yaml 

kubectl create -f deployment.yaml
kubectl describe pod name 
kubectl set image deployment/myapp myapp=demo-node

#command line service 
kubectl expose deployment myapp --type=NodePort --target-port=8000 -o yaml
#nginx
kubectl expose deployment nginx-deployment --type=NodePort --name=my-service

#deployment commad line
kubectl run hello-node --image=hello-node:v1 --port=8000
kubectl get deployments
kubectl edit deploy hello-node
kubectl get pods
kubectl get events
kubectl config view


kubectl expose deployment hello-node --type=LoadBalancer

kubectl logs podname
#Let's update our server.js file 
response.end('Hello Kubenetes!');
docker build -t hello-node:v2 .
#update the image of our Deployment:
kubectl set image deployment/hello-node hello-node=hello-node:v2

#delete deploy and service 
kubectl delete service hello-node
kubectl delete deployment hello-node
# Get all 
 kubectl get all


 #valume 
kubectl apply -f valume.yaml
echo "<h1>Hello from K8S</h1>" > /tmp/index.html

http://localhost/

echo "<h1>Hello from Demo</h1>" > /tmp/index.html
http://localhost/

#replicas
kubectl run hello-node --image=hello-node:v1 --port=8000
 kubectl scale deployment Name --replicas 10

#configmap.yaml
kubectl create -f configmap.yaml
kubectl create -f 
kubectl create -f config-pod.yaml 
## check the logs
kubectl logs test-pod-cmd

kubectl get configmap

kubectl get configmap -o yaml
#config-volume :
kubectl create -f config-vol.yaml 

# Access the shell
kubectl exec -it test-pod-vol /bin/sh
# Check the files
cd /etc/config
cat log.level
cat log.location
#delete 
 kubectl delete configmap log-config
 kubectl delete pod test-pod-cmd test-pod-vol

## secrets
 # Create base64 encoded username
echo admin | base64 # YWRtaW4=

# Create base64 encoded password
echo kalyana | base64 # UzBtZVBAc3N3MHJE

# Create a generic secret from YAML file
kubectl create -f secret.yaml

# Create the Pod
kubectl create -f secret-pod.yaml

# Access the Secret in the Pod
kubectl exec -it secret-env-pod /bin/sh
env 

# Clean up 
kubectl delete -f secret.yaml -f secret-pod.yaml


# Deploy Replicaset
kubectl create -f replicaset.yaml
kubectl get pods -o wide
kubectl scale --replicas=10 rs/nginx
kubectl delete rs nginx

# Deploy Daemonset-  one node it's not possible to put to text the Daemon s
kubectl create -f daemonset.yaml
kubectl get pods -o wide
kubectl scale --replicas=10 ds/nginx
kubectl delete ds nginx

#jobs  
kubectl create -f job.yaml

# Alternative form
kubectl run hello \
	--schedule="*/1 * * * *" \
	--restart=OnFailure \
	--image=busybox \
	-- /bin/sh -c "date; echo Hello from Kubernetes cluster"

# Get the Cron Job
kubectl get cronjob hello

# Get the Job details
kubectl logs hello-
kubectl get jobs --watch

# Clean up
kubectl delete cronjob hello

# HA
kubectl apply -f ha.yaml
kubectl get hpa

kubectl describe hpa vote

kubectl get pod,deploy

watch kubectl top pods

#helm
helm init
cd helm

cat <<'EOF' > ./Chart.yaml
name: node-app
version: 1.0.0%  
EOF
          
# copy all deploy and service to templates
#helm install RELATIVE_PATH_TO_CHART
helm install .
kubectl get po,svc
helm ls
helm status 
helm status #name#
#helm delete RELEASE_NAME to remove all Kubernetes resources
helm ls --deleted
#Use helm rollback RELEASE_NAME REVISION_NUMBER to restore a deleted
helm rollback RELEASE_NAME REVISION_NUMBER 
#Use helm delete --purge RELEASE_NAME to remove all Kubernetes resources associated with with the release and all records about the release from the store.
helm delete --purg RELEASE_NAME
helm ls --deleted

       


