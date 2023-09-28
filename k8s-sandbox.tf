# EC2 instance
resource "aws_instance" "k8s-sandbox-medium" {
  ami                         = "ami-053b0d53c279acc90"
  instance_type               = "t2.medium"
  vpc_security_group_ids      = [aws_security_group.public-sk-sandbox.id]
  availability_zone           = "us-east-1a"

  ebs_block_device {
    device_name           = "/dev/sda1"
    volume_size           = "30"
    volume_type           = "gp2"
    #encrypted             = true
    #kms_key_id            = aws_kms_alias.shared_key.id
    delete_on_termination = true
  }

  user_data = file("${path.module}/ec2-user-script.sh")

  tags      = {
    terraform = "true",
    Name      = "SK Sandbox"
  }
}

# EC2 instance Security Group
resource "aws_security_group" "public-sk-sandbox" {
  name        = "public_sk_sandbox_security_group"
  description = "Allow SSH inbound traffic and web traffic"

  # Allow SSH inbound for allowed IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # TCP port 80 for HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # TCP port 443 for HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # k8s
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound HTTP to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound HTTPS to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "sk-sandbox-ip" {
  domain   = "vpc"
  instance = aws_instance.k8s-sandbox-medium.id
}

resource "aws_cloudwatch_metric_alarm" "auto-turn-off-ec2" {
  alarm_name          = "auto-turn-off-ec2"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 3600
  statistic           = "Average"
  threshold           = 0.01
  alarm_description   = "auto-turn-off-sk-sandbox-medium CPO >=0.01"
  #alarm_actions       = ["arn:aws:automate:${var.default_region}:ec2:stop"]

  dimensions = {
    InstanceId = aws_instance.k8s-sandbox-medium.id
  }
}

/*resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.sk_project_link.zone_id
  name    = "sandbox.${data.aws_route53_zone.sk_project_link.name}"
  type    = "A"
  ttl     = 300
  records = [aws_eip.sk-sandbox-ip.public_ip]
}*/
