# EKS Worker Nodes Resources


resource "aws_iam_role" "test-node" {
  name = "terraform-eks-test-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "test-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.test-node.name
}

resource "aws_iam_role_policy_attachment" "test-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.test-node.name
}

resource "aws_iam_role_policy_attachment" "test-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.test-node.name
}

resource "aws_eks_node_group" "test" {
  cluster_name    = aws_eks_cluster.test.name
  node_group_name = "test"
  node_role_arn   = aws_iam_role.test-node.arn
  subnet_ids      = aws_subnet.test[*].id
  instance_types = ["t2.medium"]

  scaling_config {
    desired_size = 1
    max_size     = 4
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.test-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.test-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.test-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}
