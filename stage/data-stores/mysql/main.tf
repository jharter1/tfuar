terraform {
  required_version = ">= 1.0.0, < 2.0.0"
}

provider "aws" {
  region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket = "state-bucket-122022"
    key = "stage/data-stores/mysql/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "terraform-locker-table"
    encrypt = true
  }
}

resource "aws_db_instance" "dby" {
  identifier_prefix = "santana-dby"
  engine = "mysql"
  allocated_storage = 10
  instance_class = "db.t2.micro"
  skip_final_snapshot = true

  db_name = "stage_db"
  username = "admin"
  password = "superSecretPass122022"
}