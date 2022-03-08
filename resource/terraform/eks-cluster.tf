# EKSClusterResources


resource "aws_iam_role" "testcluster" {
  name = "terraform-eks-testcluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "testcluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.testcluster.name
}

resource "aws_iam_role_policy_attachment" "testcluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.testcluster.name
}

resource "aws_security_group" "testcluster" {
  name        = "terraform-eks-testcluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.test.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks-test"
  }
}

resource "aws_security_group_rule" "testcluster-ingress-workstation-https" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.testcluster.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_eks_cluster" "test" {
  name     = var.cluster-name
  role_arn = aws_iam_role.testcluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.testcluster.id]
    subnet_ids         = aws_subnet.test[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.testcluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.testcluster-AmazonEKSServicePolicy,
  ]
}
