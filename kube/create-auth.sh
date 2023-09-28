echo $1
token_tm=$(kubectl create token terraform --duration=1250h)
ca_tm=$(cat  /etc/kubernetes/pki/ca.crt  | base64 -w 0)
cat <<EOF |  tee ./config
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: $ca_tm
    server: https://$1:6443
  name: $1
contexts:
- context:
    cluster:  $1
    user:  terraform
  name:  $1
current-context:  $1
kind: Config
preferences: {}
users:
- name:  terraform
  user:
    token: $token_tm
EOF

token_tm="null"
ca_tm="null"

cp /root/config /home/ubuntu/

