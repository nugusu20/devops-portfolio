terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"           # טווח גרסה לדוגמה, אפשר לעדכן בעתיד
    }
  }
}

provider "aws" {
  region = var.aws_region          # משתמש במשתנה מ-variables.tf
}

resource "aws_security_group" "dev_server_sg" {      # dev_server_sg – שם לבחירתנו
  name        = "dev-server-sg"                      # שם חופשי ב-AWS
  description = "Allow SSH from anywhere"            # תיאור לבחירתך
  vpc_id      = null                                 # VPC ברירת מחדל – פשוט ללימוד

  ingress {
    description = "SSH from anywhere"                # טקסט חופשי
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]                      # רק ללימוד – פתוח לכל העולם
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "dev_server" {
  ami           = "ami-015f3aa67b494b27e"            # זה ה-AMI שבחרת – תשאיר כמו שהוא
  instance_type = var.instance_type                  # מתוך variables.tf

  vpc_security_group_ids = [aws_security_group.dev_server_sg.id]

  tags = {
    Name = var.instance_name                         # שם השרת – משתנה, לבחירתך
  }
}

resource "aws_s3_bucket" "devops_logs" {   # devops_logs – שם לבחירתך
  bucket = "akalo-devops-logs-12345"      # חייב להיות UNIQUE בכל העולם | תבחר שם ייחודי (עם מספרים)
}

