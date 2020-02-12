openssl genrsa -out user1.key 4096
openssl req -config csr.cnf -new -key user1.key -nodes -out user1.csr
export BASE64_CSR=$(cat user1.csr | base64 | tr -d '\n')
cat csr.yml | envsubst | kubectl apply -f -
kubectl get csr
kubectl certificate approve mycsr
kubectl get csr
kubectl get csr mycsr -o jsonpath='{.status.certificate}' \
  | base64 --decode > user1.crt
openssl x509 -in ./user1.crt -noout -text
kubectl create ns development
kubectl apply -f role.yml
kubectl apply -f role-binding.yml

# User identifier
$ export USER="user1"
# Cluster Name (get it from the current context)
$ export CLUSTER_NAME=$(kubectl config view --minify -o jsonpath={.current-context})
# Client certificate
$ export CLIENT_CERTIFICATE_DATA=$(kubectl get csr mycsr -o jsonpath='{.status.certificate}')
# Cluster Certificate Authority
$ export CLUSTER_CA=$(kubectl config view --raw -o json | jq -r '.clusters[] | select(.name == "'$(kubectl config current-context)'") | .cluster."certificate-authority-data"')
# API Server endpoint
$ export CLUSTER_ENDPOINT=$(kubectl config view --raw -o json | jq -r '.clusters[] | select(.name == "'$(kubectl config current-context)'") | .cluster."server"')

cat kubeconfig.tpl | envsubst > kubeconfig

export KUBECONFIG=$PWD/kubeconfig

kubectl config set-credentials user1 \
  --client-key=$PWD/user1.key \
  --embed-certs=true
