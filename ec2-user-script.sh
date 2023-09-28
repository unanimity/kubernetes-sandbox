#!/bin/bash
echo "Add your current machine ssh. See ssh-keygen command"
echo -e "<YOUR-KEY>" >> /home/ubuntu/.ssh/authorized_keys
#replace -^^^^^^^^^

git clone https://github.com/unanimity/kubernetes-sandbox.git

./kubernetes-sandbox/kube/install-k8s.sh sandbox.example.com
# replace -------------------------------^^^^^^^^^^^^^^^^^^^