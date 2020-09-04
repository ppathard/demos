#### Launch ubuntu 18.04 VM on mac 
multipass launch bionic --name demo --mem 4G --cpus 4 --disk 20G
multipass shell demo

#### As a requirement for your Linux Node's iptables to correctly see bridged traffic, you should ensure net.bridge.bridge-nf-call-iptables is set to 1 in your sysctl config

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system

#### Install docker
sudo apt-get update
sudo apt-get install docker.io
sudo docker version

sudo systemctl enable docker
sudo systemctl status docker

#### Install k8s
##### Add Signing Key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
##### Add Software Repository
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

##### install k8s tools
sudo apt-get install kubeadm kubelet kubectl
sudo apt-mark hold kubeadm kubelet kubectl
kubeadm version

##### kubernetes deployment
sudo swapoff –a
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml


kubectl taint nodes --all node-role.kubernetes.io/master-
