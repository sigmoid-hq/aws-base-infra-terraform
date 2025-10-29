locals {
  base_name = "${var.prefix}-${var.project_name}-${var.environment}"
}

data "aws_iam_policy_document" "ec2_trust" {
  statement {
    sid     = "EC2TrustRelationship"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

### --------------------------------------------------
### Poweruser
### --------------------------------------------------
resource "aws_iam_role" "poweruser" {
  name               = "${local.base_name}-poweruser-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_trust.json
  path               = "/"

  tags = {
    Name = "${local.base_name}-poweruser-role"
  }
}

resource "aws_iam_instance_profile" "poweruser" {
  name = "${local.base_name}-poweruser-profile"
  role = aws_iam_role.poweruser.name
  path = "/"

  tags = {
    Name = "${local.base_name}-poweruser-profile"
  }
}

resource "aws_iam_role_policy_attachment" "poweruser_access" {
  role       = aws_iam_role.poweruser.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_role_policy_attachment" "poweruser_ssm" {
  role       = aws_iam_role.poweruser.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "poweruser_cloudwatch" {
  role       = aws_iam_role.poweruser.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

### --------------------------------------------------
### ReadOnly
### --------------------------------------------------
resource "aws_iam_role" "readonly" {
  name               = "${local.base_name}-readonly-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_trust.json
  path               = "/"

  tags = {
    Name = "${local.base_name}-readonly-role"
  }
}

resource "aws_iam_instance_profile" "readonly" {
  name = "${local.base_name}-readonly-profile"
  role = aws_iam_role.readonly.name
  path = "/"

  tags = {
    Name = "${local.base_name}-readonly-profile"
  }
}

resource "aws_iam_role_policy_attachment" "readonly_access" {
  role       = aws_iam_role.readonly.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "readonly_ssm" {
  role       = aws_iam_role.readonly.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "readonly_cloudwatch" {
  role       = aws_iam_role.readonly.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

### --------------------------------------------------
### ECS Task Execution Role
### --------------------------------------------------
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${local.base_name}-ecs-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${local.base_name}-ecs-task-execution-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
