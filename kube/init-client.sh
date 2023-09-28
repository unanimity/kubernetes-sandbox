#!/bin/bash

echo "Init kube creds"
scp ubuntu@sandbox.sk-project.link:/home/ubuntu/config $(dirname "$(realpath $0)")/config
alias k_sk="kubectl --kubeconfig $(dirname "$(realpath $0)")/config"
k_sk get pod -A