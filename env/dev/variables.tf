variable "env" {
  type    = string
  default = "env"
}

variable "name" {
  description = "Value of the Name tag for Resources"
  type        = string
  default     = "name"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnets" {
  type = map(any)
  default = {
    public_subnets = {
      public-1a = {
        name = "public-1a"
        cidr = "10.0.1.0/24"
        az   = "ap-northeast-1a"
      },
      public-1c = {
        name = "public-1c"
        cidr = "10.0.2.0/24"
        az   = "ap-northeast-1c"
      },
      public-1d = {
        name = "public-1d"
        cidr = "10.0.3.0/24"
        az   = "ap-northeast-1d"
      },
    },
    private_subnets = {
      private-1a = {
        name = "private-1a"
        cidr = "10.0.4.0/24",
        az   = "ap-northeast-1a"
      },
      private-1c = {
        name = "private-1c"
        cidr = "10.0.5.0/24",
        az   = "ap-northeast-1c"
      },
      private-1d = {
        name = "private-1d"
        cidr = "10.0.6.0/24",
        az   = "ap-northeast-1d"
      }
    }
  }
}

variable "ami" {
  type    = string
  default = "ami-08c84d37db8aafe00"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}


variable "health_check_path" {
  type    = string
  default = "/wp-includes/images/blank.gif"
}


variable "db_param_character" {
  type    = string
  default = "utf8"
}

variable "db_storage" {
  type    = string
  default = "20"
}

variable "db_storage_type" {
  type    = string
  default = "gp3"
}

variable "db_name" {
  type    = string
  default = "mydb"
}

variable "db_engine" {
  type    = string
  default = "mysql"
}

variable "db_engine_version" {
  type    = string
  default = "5.7"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_username" {
  type    = string
  default = "admin"
}

variable "db_password" {
  type    = string
  default = "abc12345"
}

variable "db_multi_az" {
  type    = string
  default = false
}

variable "db_snapshot_identifier" {
  type    = string
  default = ""
}

variable "load_balancer_type" {
  type    = string
  default = "application"
}

variable "my_domain" {
  type    = string
  default = "example.com"
}

