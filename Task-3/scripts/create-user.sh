#!/bin/bash
# Step 3 (admin): create key + CSR, approve it, save the signed cert
set -e
kubectl config use-context minikube
openssl genrsa -out dev-user.key 2048
MSYS_NO_PATHCONV=1 openssl req -new -key dev-user.key -out dev-user.csr -subj "/CN=dev-user/O=webapp-devs"
REQ=$(base64 < dev-user.csr | tr -d '\n')
cat <<YAML | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: dev-user
spec:
  request: ${REQ}
  signerName: kubernetes.io/kube-apiserver-client
  usages: ["client auth"]
YAML
kubectl certificate approve dev-user
sleep 2
kubectl get csr dev-user -o jsonpath='{.status.certificate}' | base64 -d > dev-user.crt
kubectl get csr
