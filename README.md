# 🏗️ EKS Infrastructure CI/CD Pipeline Using Jenkins & Terraform

## 📘 Summary

This project provisions a complete **Amazon EKS (Elastic Kubernetes Service)** cluster using **Terraform** and deploys it through a **Jenkins CI/CD pipeline**. It sets up a dedicated **VPC**, subnets, security groups, route tables, NAT gateway, and managed node groups using modular, secure, and scalable practices.

---

## 🎯 Purpose

To implement a reproducible, version-controlled, and automated Infrastructure-as-Code (IaC) CI/CD pipeline that provisions AWS EKS clusters using Jenkins and Terraform.

---

## 📁 Directory Structure

```
eks-infra-pipeline/
├── Jenkinsfile                # Jenkins declarative pipeline
└── terraform/
    ├── main.tf               # EKS + VPC provisioning logic
    ├── variables.tf          # Declares all configurable variables
    ├── terraform.tfvars      # User-defined variable values
    └── outputs.tf            # Output values post apply
```

---

## 🛠️ Pre-requisites

| Tool/Service                         | Version / Requirement                                             |
| ------------------------------------ | ----------------------------------------------------------------- |
| Jenkins (self-managed or controller) | Installed with internet access                                    |
| Terraform                            | >= 1.6.x                                                          |
| AWS CLI                              | v2.x                                                              |
| AWS Account                          | Full permissions to manage EKS, VPC                               |
| Jenkins Plugins                      | `Pipeline`, `Terraform`, `AWS Credentials`, `Credentials Binding` |
| GitHub Repository                    | Contains the pipeline and Terraform files                         |

---

## ✅ Jenkins & AWS Configuration

### 🔐 1. Add AWS Credentials to Jenkins

* Navigate to: `Jenkins → Manage Jenkins → Credentials → Global → Add Credentials`
* **Kind:** AWS Credentials
* **Access Key ID / Secret Key:** From IAM user
* **ID:** `aws-creds`

### 🧰 2. Install Jenkins Tools

Go to `Manage Jenkins → Global Tool Configuration`:

* **Terraform:** Add name `terraform-1.6.6`
* **Ensure AWS CLI** is available on Jenkins executor path

---

## 🗂️ Terraform Configuration: Modify `terraform.tfvars`

Update with your preferred configuration:

```hcl
region              = "us-east-1"
cluster_name        = "eks-devops-cluster"
vpc_cidr            = "10.100.0.0/16"
azs                 = ["us-east-1a", "us-east-1b"]
public_subnets      = ["10.100.101.0/24", "10.100.102.0/24"]
private_subnets     = ["10.100.1.0/24", "10.100.2.0/24"]
node_instance_types = ["t3.medium"]
node_min            = 1
node_max            = 3
node_desired        = 2
```

---

## 🚀 Step-by-Step Execution Plan

### 🔹 Step 1: Clone the Repository

```bash
git clone https://github.com/<your-org>/eks-infra-pipeline.git
cd eks-infra-pipeline/
```

### 🔹 Step 2: Configure Jenkins Pipeline Job

1. Go to **Jenkins → New Item**
2. Enter name: `eks-infra-pipeline`
3. Select: **Pipeline**
4. Under **Pipeline Definition**:

   * Choose: **Pipeline script from SCM**
   * SCM: **Git**
   * Repo URL: `https://github.com/<your-org>/eks-infra-pipeline.git`
   * Script Path: `Jenkinsfile`
5. Click **Save**

---

### 🔹 Step 3: Trigger Jenkins Job

1. Click **Build Now**
2. Jenkins will run the following stages:

| Stage                | Action                                                    |
| -------------------- | --------------------------------------------------------- |
| `Checkout`           | Pulls the latest code from GitHub                         |
| `Setup AWS Env`      | Loads AWS credentials securely from Jenkins credentials   |
| `Terraform Init`     | Initializes Terraform modules and backend (if configured) |
| `Terraform Validate` | Validates Terraform syntax and integrity                  |
| `Terraform Plan`     | Shows what changes will be made                           |
| `Terraform Apply`    | Deploys infra (only on `main` branch)                     |

---

### 🔹 Step 4: Verify Deployment

Once `apply` is successful:

```bash
aws eks update-kubeconfig \
  --region us-east-1 \
  --name eks-devops-cluster

kubectl get nodes
```

You should see the EKS cluster and nodes ready to use.

---

## 🧹 Optional: Destroy Cluster

To remove infrastructure manually:

```bash
cd terraform/
terraform destroy -auto-approve
```

> ⚠️ Always verify before destroying. In production, this should be controlled with manual approvals.

---

## 🧾 Outputs

After successful deployment, Terraform will output:

* Cluster name
* Endpoint URL
* VPC ID
* Subnet IDs

---






---

## 📚 References

* [Terraform EKS Module](https://github.com/terraform-aws-modules/terraform-aws-eks)
* [AWS EKS Documentation](https://docs.aws.amazon.com/eks/)
* [Terraform Docs](https://www.terraform.io/docs)
* [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)



