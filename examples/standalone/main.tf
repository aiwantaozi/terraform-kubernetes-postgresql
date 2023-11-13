terraform {
  required_version = ">= 1.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.11.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "kubernetes_namespace_v1" "example" {
  metadata {
    name = "standalone-svc"
  }
}

module "this" {
  source = "../.."

  infrastructure = {
    namespace = kubernetes_namespace_v1.example.metadata[0].name
  }

  deployment = {
    resources = {
      requests = {
        cpu    = 1
        memory = 1024
      }
      limits = {
        cpu    = 2
        memory = 2024
      }
    }
  }

  seeding = {
    type = "text"
    text = {
      content = <<-EOF
-- company table
DROP TABLE IF EXISTS company;
CREATE TABLE company
(
    id      SERIAL PRIMARY KEY,
    name    TEXT NOT NULL,
    age     INT  NOT NULL,
    address CHAR(50),
    salary  REAL
);


-- company data
INSERT INTO company (name, age, address, salary)
VALUES ('Paul', 32, 'California', 20000.00);
INSERT INTO company (name, age, address, salary)
VALUES ('Allen', 25, 'Texas', 15000.00);
INSERT INTO company (name, age, address, salary)
VALUES ('Teddy', 23, 'Norway', 20000.00);
INSERT INTO company (name, age, address, salary)
VALUES ('Mark', 25, 'Rich-Mond ', 65000.00);
INSERT INTO company (name, age, address, salary)
VALUES ('David', 27, 'Texas', 85000.00);
INSERT INTO company (name, age, address, salary)
VALUES ('Kim', 22, 'South-Hall', 45000.00);
INSERT INTO company (name, age, address, salary)
VALUES ('James', 24, 'Houston', 10000.00);
EOF
    }
  }
}

output "context" {
  value = module.this.context
}

output "selector" {
  value = module.this.selector
}

output "endpoint_internal" {
  value = module.this.endpoint_internal
}

output "endpoint_internal_readonly" {
  value = module.this.endpoint_internal_readonly
}

output "database" {
  value = module.this.database
}

output "username" {
  value = module.this.username
}

output "password" {
  value = nonsensitive(module.this.password)
}
