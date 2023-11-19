# EC2 and Cloudfront Setup using Terraform

<!-- vscode-markdown-toc -->

- 1. [AWS credential setup](#AWScredentialsetup)
- 2. [Terraform Installation](#TerraformInstallation)
  - 2.1. [Mac OS](#MacOS)
  - 2.2. [Ubuntu](#Ubuntu)
  - 2.3. [Verify the installation](#Verifytheinstallation)
- 3. [How to create EC2 instance and associate it with Cloudfront using Terraform?](#HowtocreateEC2instanceandassociateitwithCloudfrontusingTerraform)
  - 3.1. [Clone this repo to your local machine](#Clonethisrepotoyourlocalmachine)
  - 3.2. [Config settings](#Configsettings)
  - 3.3. [Set entry script](#Setentryscript)
  - 3.4. [Execution](#Execution)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## 1. <a name='AWScredentialsetup'></a>AWS credential setup

- Make sure you have installed AWS CLI. If not, run `pip install awscli` in your terminal
- Run `aws configure` and input your AWS `access_key_id`, `secret_access_key` and `region` accordingly

## 2. <a name='TerraformInstallation'></a>Terraform Installation

### 2.1. <a name='MacOS'></a>Mac OS

You need to have Homebrew installed

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

### 2.2. <a name='Ubuntu'></a>Ubuntu

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | \
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

### 2.3. <a name='Verifytheinstallation'></a>Verify the installation

```bash
terraform -help
```

## 3. <a name='HowtocreateEC2instanceandassociateitwithCloudfrontusingTerraform'></a>How to create EC2 instance and associate it with Cloudfront using Terraform?

### 3.1. <a name='Clonethisrepotoyourlocalmachine'></a>Clone this repo to your local machine

```bash
git clone git@gitlab.com:asiabots/nick/terraform-ec2-cloudfront-template.git
```

### 3.2. <a name='Configsettings'></a>Config settings

In `terraform.tfvars`, set the following variables.

| Name              | Description                                             | Example                 |
| ----------------- | ------------------------------------------------------- | ----------------------- |
| vpc_cidr_block    | IPv4 VPC CIDR blocks                                    | "10.0.0.0/16"           |
| subnet_cidr_block | IPv4 subnet CIDR blocks                                 | "10.0.10.0/24"          |
| avail_zone        | availability zone on AWS                                | "ap-southeast-1a"       |
| env_prefix        | indicate your environment like `dev` or `prod` or `uat` | "dev"                   |
| allowed_ip        | allowed ip address range to SSH into your server        | "210.5.168.222/32"      |
| instance_type     | ec2 instance type                                       | "t2.micro"              |
| image_id          | image id for creating ec2 instance                      | "ami-0df7a207adb9748c7" |

For example:

your `terraform.tfvars`

```
vpc_cidr_block    = "10.0.0.0/16"
subnet_cidr_block = "10.0.10.0/24"
avail_zone        = "ap-southeast-1a"
env_prefix        = "dev"
allowed_ip        = "210.5.168.222/32"
instance_type     = "t2.micro"
image_id          = "ami-0df7a207adb9748c7"
```

### 3.3. <a name='Setentryscript'></a>Set entry script

You don't need run this script yourself, Terraform will do it for you

`entry-script.sh` will be run inside the EC2 instance you created. (Equivalent to user data section when creating EC2 on AWS console)

You can edit this file to setup the instance at the time it created

### 3.4. <a name='Execution'></a>Execution

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

to actually create EC2 instance and cloudfront

After applying, the SSH key `prod-cathay-key.pem` will be downloaded to your current directory. Remember change the permission first (e.g. `chmod 400 server-key.pem`)

And you may expect the public DNS of EC2 and Cloudfront distribution you created will be displayed like this.

```
Outputs:

cloudfront_dns = "d1hfveh0xync7k.cloudfront.net"
ec2_public_dns = "ec2-13-215-183-237.ap-southeast-1.compute.amazonaws.com"
```

You can check out the full log in `full_log.txt`

Ultimately, this terraform setup will create

- one EC2 instance with allowed port (22, 5001-5003)
- one Cloudfront distribution with HTTP port 5001

All Cloudfront distributions are pointing to the same EC2 instance

```bash
terraform destroy
```

to clean up resources that you created using Terraform
