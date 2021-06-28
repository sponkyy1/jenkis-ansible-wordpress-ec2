resource "aws_launch_configuration" "my_backserver" {
  name_prefix                 = "webserver-launch-config"
  image_id                    = "ami-05f7491af5eef733a"
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.my_frontserver.id]
  key_name                    = "mykeypair-key"
  user_data                   = data.template_file.provision.rendered
  iam_instance_profile        = aws_iam_instance_profile.profile.id
}

resource "aws_autoscaling_group" "web" {
  name = "${aws_launch_configuration.my_backserver.name}-asg"

  min_size         = 1
  desired_capacity = 1
  max_size         = 1

  health_check_type = "ELB"
  load_balancers = [
    aws_elb.web_elb.id
  ]

  launch_configuration = aws_launch_configuration.my_backserver.name

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  vpc_zone_identifier = [
    aws_subnet.private-subnet.id
  ]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "web"
    propagate_at_launch = true
  }

}

resource "aws_security_group" "elb_http" {
  name        = "elb_http"
  description = "Allow HTTP traffic to instances through Elastic Load Balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow HTTP through ELB Security Group"
  }
}

resource "aws_elb" "web_elb" {
  name = "web-elb"
  security_groups = [aws_security_group.elb_http.id]
  subnets = [aws_subnet.public-subnet.id]

  cross_zone_load_balancing = true

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 3
    interval            = 30
    target              = "HTTP:80/"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "80"
    instance_protocol = "http"
  }

}

data "template_file" "provision" {
  template = file("${var.user_data_folder}/user_data.sh")

  vars = {
    s3_bucket_name    = var.s3_bucket_name
  }
}