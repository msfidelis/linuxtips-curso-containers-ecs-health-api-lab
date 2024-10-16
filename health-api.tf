module "health_api" {
  # source = "github.com/msfidelis/linuxtips-curso-containers-ecs-service-module?ref=v1.3.1"
  source       = "/Users/matheus/Workspace/linuxtips/linuxtips-curso-containers-ecs-service-module"
  region       = var.region
  cluster_name = var.cluster_name

  service_name   = "nutrition-health-api"
  service_port   = "8080"
  service_cpu    = 256
  service_memory = 512

  task_minimum       = 1
  task_maximum       = 3
  service_task_count = 1

  container_image = "fidelissauro/health-api:latest"

  // Service Connect
  use_service_connect  = false
  service_protocol     = "http"
  service_connect_name = data.aws_ssm_parameter.service_connect_name.value
  service_connect_arn  = data.aws_ssm_parameter.service_connect_arn.value

  service_listener = data.aws_ssm_parameter.listener_internal.value
  alb_arn          = data.aws_ssm_parameter.alb_internal.value

  service_task_execution_role = aws_iam_role.main.arn

  service_healthcheck = {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 10
    interval            = 60
    matcher             = "200-399"
    path                = "/healthcheck"
    port                = 8080
  }

  service_launch_type = [
    {
      capacity_provider = "FARGATE_SPOT"
      weight            = 100
    }
  ]

  deployment_controller = "CODE_DEPLOY"

  # codedeploy_strategy = "CodeDeployDefault.ECSLinear10PercentEvery1Minutes"

  service_hosts = [
    # "health.linuxtips.demo"
    "health.linuxtips-ecs-cluster.internal.com"
  ]

  service_discovery_namespace = data.aws_ssm_parameter.service_discovery_namespace.value

  environment_variables = [
    {
      name  = "ZIPKIN_COLLECTOR_ENDPOINT"
      value = "http://jaeger-collector.linuxtips-ecs-cluster.discovery.com:80"
    },
    {
      name  = "BMR_SERVICE_ENDPOINT",
      value = "nutrition-bmr.linuxtips-ecs-cluster.discovery.com:30000"
    },
    {
      name  = "IMC_SERVICE_ENDPOINT",
      value = "nutrition-imc.linuxtips-ecs-cluster.discovery.com:30000"
    },
    {
      name  = "RECOMMENDATIONS_SERVICE_ENDPOINT",
      value = "nutrition-recommendations.linuxtips-ecs-cluster.discovery.com:30000"
    },
    {
      name  = "version"
      value = timestamp()
    }

  ]

  vpc_id = data.aws_ssm_parameter.vpc.value

  private_subnets = [
    data.aws_ssm_parameter.private_subnet_1.value,
    data.aws_ssm_parameter.private_subnet_2.value,
    data.aws_ssm_parameter.private_subnet_3.value,
  ]

}