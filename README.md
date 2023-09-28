# Kubernetes-sandbox
This project will let you run Kubernetes sandbox in one EC2 instance as one master node using Terraform.

---
NOT FOR PRODUCTION USE
---

Requirements:
* The Terraform project
* AWS provider
* Domain name in Route53

To use:
1. Copy files to your existing Terraform project
2. Replace the SSH key you will use to login  ()
3. Specify the domain name you plan to use
4. terraform init
5. terraform plan
6. terraform apply
7. Run script to sync the key and add alias
8. Run command k_sk
9. Now you can add Kubernetes provider and helm to your Terraform project

Notes:

1

2


Also, you take a  look at the projects like:
minikube