variable "cluster_name" {
  default = "linuxtips-ecs-cluster"
}

variable "region" {
  default = "us-east-1"
}

variable "ssm_alb" {
  default = "/linuxtips/ecs/lb/id"
}

variable "ssm_listener" {
  default = "/linuxtips/ecs/lb/listerner"
}

variable "ssm_alb_internal" {
  default = "/linuxtips/ecs/lb/internal/id"
}

variable "ssm_listener_internal" {
  default = "/linuxtips/ecs/lb/internal/listerner"
}

variable "ssm_vpc_id" {
  default = "/linuxtips-vpc/vpc/vpc_id"
}

variable "ssm_private_subnet_1" {
  default = "/linuxtips-vpc/vpc/subnet_private_1a"
}

variable "ssm_private_subnet_2" {
  default = "/linuxtips-vpc/vpc/subnet_private_1b"
}

variable "ssm_private_subnet_3" {
  default = "/linuxtips-vpc/vpc/subnet_private_1c"
}

variable "ssm_service_discovery_namespace" {
  default = "/linuxtips/ecs/cloudmap/namespace"
}

### Service Connect
variable "ssm_service_connect_arn" {
  default = "/linuxtips/ecs/service-connect/namespace"
}

variable "ssm_service_connect_name" {
  default = "/linuxtips/ecs/service-connect/name"
}