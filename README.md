# Docker Cloud Health

Run cloud health client in a docker containr in an ec2 instance, bonus points if you run it in kubernetes.


At docker boot the `cht_perfmon` is started with the 

## Run in docker

```
docker run -e CLOUD_HEALTH_SECRET="YOUR_SECRET" --rm quay.io/coveo/cloud-health
```

## Install in a Kubernetes clusters

```sh
K8S_NAMESPACE=<yourwantednamespace>
# Create the app secret
kubectl create secret -n $K8S_NAMESPACE generic cloud-health-perfmon --from-literal=cloud-health-secret="YOUR_SECRET"
# Deploy the app
kubectl apply -n $K8S_NAMESPACE -f k8s-cloud-health-perfmon-daemonset.yaml
```

Sadly there is a bug in `facter` that makes it impossible to run in a docker in a ec2 machine and still make `facter` know about ec2 stats. The `ec2_hack.rb` fixes that problem until cloud-health officially supports it.

It adds `docker` to the regex to match virtual container space.

```
      Facter.value(:virtual).match /^(xen|kvm|docker)/
```