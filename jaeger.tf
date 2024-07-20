module "jaeger-collector" {
  # source                      = "github.com/msfidelis/linuxtips-curso-containers-ecs-service-module?ref=v1"
  source       = "/Users/matheus/Workspace/linuxtips/linuxtips-curso-containers-ecs-service-module"
  region       = var.region
  cluster_name = var.cluster_name

  service_name   = "nutrition-jaeger-collector"
  service_port   = "9411"
  service_cpu    = 512
  service_memory = 1024

  task_minimum       = 1
  task_maximum       = 1
  service_task_count = 1

  container_image = "jaegertracing/all-in-one:1.57"

  service_listener = data.aws_ssm_parameter.listener_internal.value
  alb_arn          = data.aws_ssm_parameter.alb_internal.value

  service_task_execution_role = aws_iam_role.main.arn

  service_healthcheck = {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 10
    interval            = 60
    matcher             = "200-399"
    path                = "/"
    port                = 14269
  }

  service_launch_type = [
    {
      capacity_provider = "FARGATE_SPOT"
      weight            = 100
    }
  ]

  service_hosts = [
    "jaeger-collector.linuxtips-ecs-cluster.internal.com"
  ]

  environment_variables = [
    {
      name  = "COLLECTOR_ZIPKIN_HOST_PORT"
      value = ":9411"
    }
  ]

  vpc_id = data.aws_ssm_parameter.vpc.value

  private_subnets = [
    data.aws_ssm_parameter.private_subnet_1.value,
    data.aws_ssm_parameter.private_subnet_2.value,
    data.aws_ssm_parameter.private_subnet_3.value,
  ]

  service_discovery_namespace = data.aws_ssm_parameter.service_discovery_namespace.value

}