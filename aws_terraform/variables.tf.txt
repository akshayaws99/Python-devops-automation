variable "region" {
  default = "us-east-1"
}

variable "ami" {
  default = "ami-0abcdef1234567890"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "s3_bucket_name" {
  default = "devops-project-bucket-12345"
}


variable "eks_cluster_name" {
  type    = string
  default = "devops-eks-cluster"
}

variable "eks_k8s_version" {
  type    = string
  default = "1.26"
}

variable "private_subnet_ids" {
  type = list(string)
  description = "List of private subnet IDs for EKS"
  default = []
}

variable "node_instance_types" {
  type = list(string)
  default = ["t3.medium"]
}

variable "node_desired_capacity" {
  type = number
  default = 2
}

variable "node_min_size" {
  type = number
  default = 1
}

variable "node_max_size" {
  type = number
  default = 3
}

variable "node_capacity_type" {
  type = string
  default = "ON_DEMAND"
}

variable "ssh_key_name" {
  type = string
  default = ""
}

variable "irsa_namespace" {
  type = string
  default = "monitoring"
}

variable "irsa_service_account_name" {
  type = string
  default = "s3-access-sa"
}

variable "s3_bucket_name" {
  type = string
  default = "devops-project-bucket-12345"
}
