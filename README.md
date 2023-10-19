# Terraform modules

This repo contains terraform modules with pre-configured settings

<!-- vscode-markdown-toc -->

- 1. [Prerequisites](#Prerequisites)
  - 1.1. [AWS CLI Installation](#AWSCLIInstallation)
  - 1.2. [Terraform Installation](#TerraformInstallation)
    - 1.2.1. [Mac OS](#MacOS)
    - 1.2.2. [Ubuntu](#Ubuntu)
    - 1.2.3. [Windows](#Windows)
    - 1.2.4. [Verify the installation](#Verifytheinstallation)
- 2. [Modules](#Modules)
  - 2.1. [Self-created modules](#Self-createdmodules)
  - 2.2. [Existing module](#Existingmodule)
- 3. [Terraform setup for EC2 Creation](#TerraformsetupforEC2Creation)
  - 3.1. [Config settings](#Configsettings)
  - 3.2. [Set entry script](#Setentryscript)
  - 3.3. [Execution](#Execution)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## 1. <a name='Prerequisites'></a>Prerequisites

### 1.1. <a name='AWSCLIInstallation'></a>AWS CLI Installation

- Make sure you have installed AWS CLI. If not, run `pip install awscli` in your terminal
- Run `aws configure` and input your AWS `access_key_id`, `secret_access_key` and `region` accordingly

### 1.2. <a name='TerraformInstallation'></a>Terraform Installation

#### 1.2.1. <a name='MacOS'></a>Mac OS

You need to have Homebrew installed

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

#### 1.2.2. <a name='Ubuntu'></a>Ubuntu

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

wget -o- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update

sudo apt-get install terraform
```

#### 1.2.3. <a name='Windows'></a>Windows

Download binary from [https://developer.hashicorp.com/terraform/downloads](https://developer.hashicorp.com/terraform/downloads)

#### 1.2.4. <a name='Verifytheinstallation'></a>Verify the installation

```bash
terraform -help
```

## 2. <a name='Modules'></a>Modules

So far we have 1 self-created modules, 1 existing modules being used.

### 2.1. <a name='Self-createdmodules'></a>Self-created modules

- [AWS EC2](docs/ec2.md)

### 2.2. <a name='Existingmodule'></a>Existing module

- [AWS VPC](docs/vpc.md)

## 3. <a name='TerraformsetupforEC2Creation'></a>Terraform setup for EC2 Creation

### 3.1. <a name='Configsettings'></a>Config settings

In `terraform.tfvars`, set the following variables.

| Name       | Description                                             | Example |
| ---------- | ------------------------------------------------------- | ------- |
| env_prefix | indicate your environment like `dev` or `prod` or `uat` | "dev"   |

For example:

your `terraform.tfvars`

```
env_prefix        = "dev"
```

### 3.2. <a name='Setentryscript'></a>Set entry script

`entry-script.sh` will be run inside the EC2 instance you created.

You can edit this file to setup the instance at the time it created

### 3.3. <a name='Execution'></a>Execution

After the above configuration, run

```bash
terraform init
```

to download Terraform modules and dependencies

```bash
terraform plan
```

to check if there is any syntax error

```bash
terraform apply -auto-approve
```

to actually create EC2 instance and setup vpc

```bash
terraform destroy
```

to clean up resources that you created using Terraform
