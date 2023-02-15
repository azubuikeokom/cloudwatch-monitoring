resource "aws_iam_role" "yace-task-role" {
  name = "${var.name}-task-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
           Service="ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    name = "yace-task-role"
  }
}

resource "aws_iam_policy" "yace-policy" {
  name        = "${var.name}-policy"
  path        = "/"
  description = "This policy allows yace container to filter and collect metrics from cloudwatch"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1674249227793",
      "Action": [
        "tag:GetResources",
        "cloudwatch:GetMetricData",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:ListMetrics",
        "ec2:DescribeTags",
        "ec2:DescribeInstances",
        "ec2:DescribeRegions",
        "ec2:DescribeTransitGateway*",
        "apigateway:GET",
        "dms:DescribeReplicationInstances",
        "dms:DescribeReplicationTasks"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
     {
            "Sid": "",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchGetImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:PutImage"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Action": [
                "logs:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "yace-policy-attach" {
  name       = "${var.name}-policy-attachment"
  roles      = [aws_iam_role.yace-task-role.name]
  policy_arn = aws_iam_policy.yace-policy.arn
}