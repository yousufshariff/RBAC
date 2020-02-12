# User identifier
$ export USER="dave"
# Cluster Name (get it from the current context)
$ export CLUSTER_NAME=$(kubectl config view --minify -o jsonpath={.current-context})
# Client certificate
$ export CLIENT_CERTIFICATE_DATA=$(kubectl get csr mycsr -o jsonpath='{.status.certificate}')
# Cluster Certificate Authority
$ export CLUSTER_CA=$(kubectl config view --raw -o json | jq -r '.clusters[] | select(.name == "'$(kubectl config current-context)'") | .cluster."certificate-authority-data"')
# API Server endpoint
$ export CLUSTER_ENDPOINT=$(kubectl config view --raw -o json | jq -r '.clusters[] | select(.name == "'$(kubectl config current-context)'") | .cluster."server"')
