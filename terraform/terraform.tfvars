region          = "us-east-1"
cluster_name    = "production-eks"
vpc_cidr        = "10.100.0.0/16"
azs             = ["us-east-1a", "us-east-1b"]
public_subnets  = ["10.100.101.0/24", "10.100.102.0/24"]
private_subnets = ["10.100.1.0/24", "10.100.2.0/24"]
node_instance_types = ["t3.large"]
node_min        = 1
node_max        = 2
node_desired    = 2
