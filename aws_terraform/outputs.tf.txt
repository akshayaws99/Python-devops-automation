output "vpc_id" {
  value = aws_vpc.main.id
}
output "instance_id" {
  value = aws_instance.demo.id
}


output "eks_cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "eks_cluster_certificate_authority" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}
