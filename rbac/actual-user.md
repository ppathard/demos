# Declare the name of the Kubernetes user we're going to support by setting it to an environment variable
export MAGIC_USER=pavan
# Generate an RSA key using openssl
openssl genrsa -out pavan.key 2048
# Create the certificate signing request file, pavan.csr
# /CN=${MAGIC_USER} is the name of the user
# /O=devs/ declares a group, devs
# /O=tech-leads/ declares a group, tech-leads
openssl req -new -key pavan.key -out pavan.csr -subj "/CN=${MAGIC_USER}/O=devs/O=tech-leads"
# Create the .crt file
sudo openssl x509 -req -in pavan.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out pavan.crt -days 500
# Make a directory, $HOME/.certs and move the files, pavan.crt and pavan.key into the directory $HOME/.certs
mkdir -p $HOME/.certs && mv pavan.crt pavan.key $HOME/.certs
# Take a look to make sure the certificates got copied in:
ls -lh $HOME/.certs

# Set the security credentials of ${MAGIC_USER} (a.k.a pavan) to the Kubernetes configuration
kubectl config set-credentials ${MAGIC_USER}@kubernetes --client-certificate=$HOME/.certs/${MAGIC_USER}.crt --client-key=$HOME/.certs/${MAGIC_USER}.key --embed-certs=true

# Create a new Kubernetes context
kubectl config set-context ${MAGIC_USER}@kubernetes --cluster=kubernetes --user=${MAGIC_USER}@kubernetes

# Check COnfig View
kubectl config view

kubectl config use-context ${MAGIC_USER}@kubernetes