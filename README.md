# terraform-isucon

## Overview

Terraform configuration files for building ISUCON environments.

## Usage

### AWS

```
git clone https://github.com/matsuu/terraform-isucon.git
cd terraform-isucon/aws/isucon4-qualifier
```

- https://console.aws.amazon.com/
  - Create IAM user
  - Generate Access Key

```
$EDITOR variables.tf
terraform plan
terraform apply
```

### Google Compute Engine

```
gcloud auth login
git clone https://github.com/matsuu/terraform-isucon.git
cd terraform-isucon/gcp/isucon4-qualifier
```

- https://console.developers.google.com/
  - APIs & auth - Credentials
  - Add Credentials - Service account
  - JSON - Create

```
$EDITOR variables.tf
terraform plan
terraform apply
```

## References

- [matsuu/ansible-isucon](https://github.com/matsuu/ansible-isucon)
- [matsuu/vagrant-isucon](https://github.com/matsuu/vagrant-isucon)

## Author

matsuu
