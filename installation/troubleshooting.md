# Have an understanding about 
Master, Nodes,  Pods, Services, Replication Controllers, Deployment, Daemonset, Networking(flanneld)

# Have a good understanding of cli tools
kubectl, systemctl, journalctl and etcdctl

# When you submit an application to Kubernetes, here’s generally what happens:

- Your kubectl command line is sent to the kube-apiserver (on the master) where it is validated.
- The kube-scheduler process (on the master) reads your yaml or json file and assigns pods to nodes (nodes are systems running the kubelet service).
- The kublet service (on a node) converts the pod manifest into one or more docker run calls.
- The docker run command tries to start up the identified containers on available nodes.

# So, to debug a kubernetes deployed app, you need to confirm that:

- The Kubernetes service daemon (systemd) processes are running.
- The yaml or json submission is valid.
- The kubelet service is receiving a work order from the kube-scheduler.
- The kubelet service on each node is able to successfully launch each container with docker.


# Check if services are running and enabled
for SERVICES in flanneld docker kube-proxy.service kubelet.service; \
do echo --- $SERVICES --- ; systemctl is-active $SERVICES ; \
systemctl is-enabled $SERVICES ; echo "";  done

# Check the logs of kubelet and kube-apiserver
journalctl -l -u kubelet
journalctl -l -u kube-apiserver
journalctl -f -u docker

# Directly check from docker logs
docker ps
docker logs -f <container id>

# Pods debugging
kubectl describe pod
kubectl get events
