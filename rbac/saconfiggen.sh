# your server name goes here
server=https://192.168.64.10:6443
# the name of the secret containing the service account token goes here
# Token we can get from kubectl describe serviceaccount example-reader
name=example-reader-token-kvqdw
cluster_name=kubernetes
user=example-user
context=sa-exampleuser

ca=$(kubectl get secret/$name -o jsonpath='{.data.ca\.crt}')
token=$(kubectl get secret/$name -o jsonpath='{.data.token}' | base64 -d)
namespace=$(kubectl get secret/$name -o jsonpath='{.data.namespace}' | base64 -d)

echo "
apiVersion: v1
kind: Config
clusters:
- name: ${cluster_name}
  cluster:
    certificate-authority-data: ${ca}
    server: ${server}
contexts:
- name: ${context}
  context:
    cluster: ${cluster_name}
    namespace: ${namespace}
    user: ${user}
current-context: ${context}
users:
- name: ${user}
  user:
    token: ${token}
" > sa.kubeconfig