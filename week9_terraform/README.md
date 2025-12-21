# Terraform AWS Lab – EC2, Security Group & S3

Small Terraform lab project that provisions a minimal AWS environment using Terraform:

- 1 × EC2 instance (Amazon Linux, `t2.micro`)
- 1 × Security Group (SSH access)
- 1 × S3 Bucket (logs / backups demo)
- Support for **dev** and **prod** style configurations via `*.tfvars` files

> **Note:** This project is for learning/demo purposes only.  
> Always review the plan before applying changes to a real AWS account.

---

## Project Structure

```text
week9_terraform/
├── main.tf                  # Providers + resources (EC2, SG, S3)
├── variables.tf             # Input variables definitions
├── outputs.tf               # Useful outputs (instance_id, public_ip)
├── dev.tfvars.example       # Example values for a dev environment
├── prod.tfvars.example      # Example values for a prod environment
└── .gitignore               # Ignores state, .terraform, and real *.tfvars
```

---

## Step-by-Step Setup

<details>
<summary>🔧 Step 1 – Prerequisites</summary>

- Terraform CLI installed (`v1.4.0+` recommended)  
- AWS account with programmatic access  
- AWS credentials configured (for example via `aws configure`)  
- Git installed locally
</details>

<details>
<summary>📂 Step 2 – Clone and Enter the Project</summary>

```bash
git clone <your-repo-url>.git
cd <your-repo-root>/week9_terraform
```
</details>

<details>
<summary>🧩 Step 3 – Create Real tfvars from Examples</summary>

> Real `*.tfvars` files should **not** be committed to Git.

```bash
cp dev.tfvars.example  dev.tfvars
cp prod.tfvars.example prod.tfvars
```

Edit the files and adjust values if needed:

```bash
nano dev.tfvars
nano prod.tfvars
```

Typical content:

```hcl
aws_region    = "eu-central-1"
instance_type = "t2.micro"
instance_name = "devops-interview-lab"
```
</details>

<details>
<summary>🚀 Step 4 – Initialize Terraform</summary>

```bash
terraform init
```

This downloads the AWS provider and prepares the working directory.
</details>

<details>
<summary>🌱 Step 5 – Plan & Apply (Dev Example)</summary>

Plan:

```bash
terraform plan -var-file="dev.tfvars"
```

Apply:

```bash
terraform apply -var-file="dev.tfvars"
# type: yes
```

Terraform will create:

- EC2 instance
- Security Group
- S3 Bucket
</details>

---

## Deployment Manifest Highlights

<details>
<summary>🖥️ EC2 Instance & Provider (main.tf)</summary>

**Provider**

- Uses the AWS provider.
- Region is supplied via the `aws_region` variable:

```hcl
provider "aws" {
  region = var.aws_region
}
```

**EC2 Instance**

```hcl
resource "aws_instance" "dev_server" {
  ami           = "ami-015f3aa67b494b27e"   # Amazon Linux AMI (example)
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.dev_server_sg.id]

  tags = {
    Name = var.instance_name
  }
}
```

- `instance_type` and `Name` tag come from variables.
- Security Group is attached via `vpc_security_group_ids`.
</details>

<details>
<summary>🔐 Security Group (main.tf)</summary>

```hcl
resource "aws_security_group" "dev_server_sg" {
  name        = "dev-server-sg"
  description = "Allow SSH from anywhere"
  vpc_id      = null  # default VPC for lab/demo

  ingress {
    description = "SSH from anywhere (lab only)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

> In real environments, restrict SSH access to trusted IP ranges instead of `0.0.0.0/0`.
</details>

<details>
<summary>📦 S3 Bucket (main.tf)</summary>

```hcl
resource "aws_s3_bucket" "devops_logs" {
  bucket = "akalo-devops-logs-12345-xyz"  # must be globally unique
}
```

- Simple bucket used as a placeholder for logs/backups.
- Name must be globally unique across all AWS accounts.
</details>

<details>
<summary>⚙️ Variables (variables.tf)</summary>

```hcl
variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
}
```

These variables are supplied via `dev.tfvars` / `prod.tfvars` or other `-var` inputs.
</details>

<details>
<summary>📤 Outputs (outputs.tf)</summary>

Example outputs:

```hcl
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.dev_server.id
}

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.dev_server.public_ip
}
```

Usage:

```bash
terraform output
```

This prints the current EC2 instance ID and public IP address.
</details>

---

## Useful Commands

<details>
<summary>🚀 Deploy (Dev / Prod)</summary>

```bash
# Dev
terraform plan  -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"

# Prod-style configuration (example)
terraform plan  -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
```
</details>

<details>
<summary>🔍 Inspect State & Outputs</summary>

```bash
terraform show
terraform state list
terraform output
```
</details>

<details>
<summary>🧭 Detect Drift (Manual Changes in AWS)</summary>

```bash
terraform plan -var-file="dev.tfvars"
```

Terraform compares the real AWS resources with the configuration and shows any differences (drift) that would be corrected on the next `apply`.
</details>

<details>
<summary>🧹 Destroy All Resources (Clean Up)</summary>

Always destroy lab resources when you finish to avoid unnecessary costs:

```bash
terraform destroy -var-file="dev.tfvars"
# or
terraform destroy -var-file="prod.tfvars"
```
</details>

---

## Notes & Best Practices

- **State files** (`terraform.tfstate`, backups and `.terraform/`) are ignored via `.gitignore` and must not be committed.
- Real `*.tfvars` files should stay local or in a secure secrets store.  
  Commit only `*.tfvars.example` as documentation.
- The Security Group currently allows SSH from `0.0.0.0/0` for simplicity in a lab.  
  In real environments, always restrict access to specific IP ranges or VPN networks.
