#!/bin/bash
echo "Add your current machine ssh. See ssh-keygen command"
echo -e "<YOUR-KEY>" >> /home/ubuntu/.ssh/authorized_keys
#replace -^^^^^^^^^
cd /root
git clone https://github.com/unanimity/kubernetes-sandbox.git
chmod 700 ./kubernetes-sandbox/kube/install-k8s.sh
./kubernetes-sandbox/kube/install-k8s.sh sandbox.example.com
# replace -------------------------------^^^^^^^^^^^^^^^^^^^