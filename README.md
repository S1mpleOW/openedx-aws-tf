# Open edX on AWS

## Description

    This repository contains the necessary files to deploy an Open edX instance on AWS using Terraform.

## Requirements

- Terraform
- AWS account
- AWS CLI
- AWS credentials

## Usage

1. Clone the repository

```bash
    git clone https://github.com/S1mpleOW/openedx-aws-tf.git
```

2. Change directory to the repository

```bash
    cd openedx-aws-tf/environments/dev
```

3. Create a `terraform.tfvars` file with the following content:

```hcl
    doc_db_password = "<document_db_password>"
    mysql_password = "<mysql_password>"
    SMTP_HOST      = "<smtp_host>"
    SMTP_USERNAME  = "<smtp_username>"
    SMTP_PASSWORD  = "<smtp_password>"

```

4. Initialize Terraform

```bash
    terraform init
```

5. Create a Terraform plan

```bash
    terraform plan
```

6. Apply the Terraform plan

```bash
    terraform apply
```

7. Access the Open edX instance

```bash
    terraform output
```

## Authors

- [S1mpleOW](https://github.com/s1mpleow)
