variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "eu-central-1"    # ערך לדוגמה: האזור שאתה עובד בו עכשיו
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"        # ערך לדוגמה, מתאים ל-Free Tier
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "devops-terraform-lab"  # שם חופשי – לבחירתך
}

