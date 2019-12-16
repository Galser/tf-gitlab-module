## Example usage 

This how-to demonstrates usage of "tf-gitlab-module" module (https:/github.com/Galser/tf-gitlab-module)

- Let's define sample main code, in file [main.tf](main.tf) :
    ```terraform
    # Example of usage of gitlab module
    resource "aws_key_pair" "sshkey" {
      key_name = "ag-test-key"
      public_key = file("~/.ssh/id_rsa.pub")
    }
    module "gitlab" {
      #source                = "github.com/Galser/tf-gitlab-module"
      source          = "../"
      name            = "test"
      ami             = var.amis[var.region]
      instance_type   = var.instance_type
      subnet_id       = var.subnet_ids[var.region]
      security_groups = [var.vpc_security_group_ids[var.region]]

      #proxy_port = "3128"
      external_url  = "test.example.com" # not used for now
      key_name   = aws_key_pair.sshkey.id
      key_path   = "~/.ssh/id_rsa"
    }
    ```
    > Note - first line is reference this repository, to be included as Terraform module.
    > it assumes some defaults :
    > - that you have SSH key located in files "~/.ssh/id_rsa" and "~/.ssh/id_rsa.pub"
    > - that you want to deploy 1 instance 

- We will need to specify those minimal set of the input parameters, here my values below for test :
    ```terraform
    variable "region" {
      default = "eu-central-1"
    }

    variable "subnet_ids" {
      type = "map"
      default = {
          "eu-central-1" = "subnet-7282ce1a"
      }
    }

    variable "amis" {
      type = "map"
      default = {
          "us-east-2"    = "ami-00f03cfdc90a7a4dd",
          "eu-central-1" = "ami-08a162fe1419adb2a"
      }
    }

    variable "vpc_security_group_ids" {
      type = "map"
      default = {
          "us-east-2"    = "sg-435345ce45e345343" # sg not tested 
          "eu-central-1" = "sg-04c059aea335d8f69" # sg tested
      }
    }

    variable "instance_type" {
      default = "t2.micro"
    }
    ```
- Now, we are going to use AWS provider, let's define, file [provider_aws.tf](provider_aws.tf) :
    ```terraform
    provider "aws" {
      profile    = "default"
      region     = "${var.region}"
    }
    ```
- And the last step - our outputs, if we want to see in a nice way, how to connect to our servers. Define them in [outputs.tf](outputs.tf) :
    ```terraform
    output "public_ips" {
      value = "${module.gitlab.public_ips}"
    }

    output "public_dns" {
      value = "${module.gitlab.public_dns}"
    }
    ```
- Before using `apply` for first time with above mentioned code we need to inform terraform about our module. Execute :
    ```
    terraform init
    ```
    Output :
    ```
    ...
    ```
- Now let's apply our code changes : 
    ```
    terraform apply
    ```
    Output :
    ```
    ...
    ```
    So, the module had created and provisioned 1 instance running GitLab on private IP address
- As the last step run `destroy` to clean:
    ```
    terraform destroy
    ```
    Output:
    ```
    ...
    ```
This concludes the "Example usage" section. Thank you.


