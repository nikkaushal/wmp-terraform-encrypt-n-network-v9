dns_domain = "tek-nik.com."
env        = "dev"
vpc_id     = "vpc-82bd6eff"
subnets    = ["subnet-73f3732c", "subnet-7f830419"]
kms_key_id = "arn:aws:kms:us-east-1:293222827824:key/47ffb274-7647-4a7b-baf2-e61de86316a8"
databases = {
  postgres = {
    allocated_storage = 10
  }
}

apps = {

  frontend = {
    instance_type = "t3.small"
    ports = {
      frontend = 80
    }
    lb = {
      lb_internal = false
      port        = 80
    }
    asg = {
      min_size = 2
      max_size = 10
    }
  }

  auth-service = {
    instance_type = "t3.small"
    ports = {
      auth-service = 8081
    }
    lb = {
      lb_internal = true
      port        = 8081
    }
    asg = {
      min_size = 2
      max_size = 10
    }
  }

  portfolio-service = {
    instance_type = "t3.small"
    ports = {
      portfolio-service = 8080
    }
    lb = {
      lb_internal = true
      port        = 8080
    }
    asg = {
      min_size = 2
      max_size = 10
    }
  }

  analytics-service = {
    instance_type = "t3.small"
    ports = {
      analytics-service = 8000
    }
    lb = {
      lb_internal = true
      port        = 8000
    }
    asg = {
      min_size = 2
      max_size = 10
    }
  }

}

network = {
  dev = {
    vpc_cidr = "10.1.0.0/24"
    subnets= {
      s1 = {
        cidr = "10.1.0.0/25"
        az = "us-east-1a"
      }
      s2 = {
        cidr = "10.1.0.128/25"
        az = "us-east-1b"
      }
  }
}
}

default_vpc_id = "vpc-82bd6eff"
default_vpc_rt_id = "rtb-2fe5ba51"
default_vpc_cidr = "172.31.0.0/16"
cluster_sg_ingress_cidr = ["172.31.0.0/16","10.1.0.0/24"]