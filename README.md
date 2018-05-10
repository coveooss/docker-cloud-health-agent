# Docker Cloud Health

Run cloud health client in a docker containr in an ec2 instance, bonus points if you run it in kubernetes.

## Build

Unfortunately (as of version 19 of CloudHealth Agent) the build process itself requires a valid `CLOUD_HEALTH_SECRET` and version number in order to succeed.

No big deal! Just check out this repo in the cloud (e.g. AWS) where you are planning to run your CH agents in the future, and run `docker build` with the necessary bits of info:

```
docker build . --build-arg CLOUD_HEALTH_SECRET=your-cloud-health-secret --build-arg CLOUD_HEALTH_VERSION=19 --build-arg CLOUD=aws
```

This will download the CHT software (at the specified version), install it, and configure it for the specified cloud. The last step in the process wipes your `CLOUD_HEALTH_SECRET` from the docker image, but leaves the choices of `CLOUD` and `CLOUD_HEALTH_VERSION` intact.

Then `docker tag` and `docker push` to your favorite docker repo.

## Run in docker

```
docker run -e CLOUD_HEALTH_SECRET="YOUR_SECRET" --rm dockerhub.com/your-username/docker-cloud-health-agent
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
