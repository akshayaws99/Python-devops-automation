# Create IAM role for EC2
resource "aws_iam_role" "ec2_role" {
  name = "devops-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach existing AWS-managed policy to EC2 role (S3 Full Access)
resource "aws_iam_role_policy_attachment" "ec2_s3_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Create IAM policy for EC2 to read SSM parameters and CloudWatch logs
resource "aws_iam_policy" "ec2_custom_policy" {
  name        = "ec2-custom-policy"
  description = "Allow EC2 to read SSM & write to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Attach custom policy
resource "aws_iam_role_policy_attachment" "ec2_custom_policy_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_custom_policy.arn
}

# Create IAM Instance Profile for EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "devops-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

# ✅ Optional: IAM user for DevOps automation
resource "aws_iam_user" "devops_user" {
  name = "devops-user"
}

# ✅ Attach policy to user
resource "aws_iam_user_policy_attachment" "user_s3_attach" {
  user       = aws_iam_user.devops_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

output "ec2_iam_role" {
  value = aws_iam_role.ec2_role.name
}

output "iam_instance_profile" {
  value = aws_iam_instance_profile.ec2_profile.name
}
