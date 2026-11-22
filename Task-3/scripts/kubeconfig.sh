#!/bin/bash
# Step 5: add dev-user to kubeconfig (run from the folder with dev-user.crt/.key)
set -e
SERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
kubectl config set-cluster k8s-lab --server="$SERVER" --certificate-authority="$HOME/.minikube/ca.crt" --embed-certs=true
kubectl config set-credentials dev-user --client-certificate=dev-user.crt --client-key=dev-user.key --embed-certs=true
kubectl config set-context dev-user@k8s-lab --cluster=k8s-lab --user=dev-user --namespace=webapp-stack
kubectl config use-context dev-user@k8s-lab
kubectl config get-contexts
kubectl auth whoami
