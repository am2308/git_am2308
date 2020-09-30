# Provisioning a Kubernetes Cluster on AWS using Terraform

A worked example to provision a Kubernetes cluster on AWS from scratch, using Terraform.

- AWS VPC
- 1 EC2 instances for HA Kubernetes Control Plane: Kubernetes API, Scheduler and Controller Manager
- 1 EC2 instances for *etcd* cluster
- 3 EC2 instances as Kubernetes Workers (aka Minions or Nodes)
- Kubenet Pod networking (using CNI)
- HTTPS between components and control API

## Requirements

Requirements on control machine:

- Terraform (tested with Terraform 0.7.0)
- Python (tested with Python 2.7.12)
- Python *netaddr* module
- Ansible (tested with Ansible 2.1.0.0)
- *cfssl* and *cfssljson*
- Kubernetes CLI
- SSH Agent
- AWS CLI


## AWS Credentials

### AWS KeyPair

You need a valid AWS Identity (`.pem`) file and the corresponding Public Key. Terraform imports the [KeyPair] in your AWS account.

Please read [AWS Documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#how-to-generate-your-own-key-and-import-it-to-aws) about supported formats.

### Terraform authentication

Both Terraform expect AWS credentials set in environment variables:
```
$ export AWS_ACCESS_KEY_ID=<access-key-id>
$ export AWS_SECRET_ACCESS_KEY="<secret-key>"
```

If you plan to use AWS CLI you have to set `AWS_DEFAULT_REGION`.
```
$ ssh-add <keypair-name>.pem
```

## Defining the environment

Terraform expects some variables to define your working environment:

- `control_cidr`: The CIDR of your IP. All instances will accept only traffic from this address only. Note this is a CIDR, not a single IP. e.g. `123.45.67.89/32` (mandatory)
- `default_keypair_public_key`: Valid public key corresponding to the Identity you will use to SSH into VMs. e.g. `"ssh-rsa AAA....xyz"` (mandatory)

**Note that Instances and Kubernetes API will be accessible only from the "control IP"**.

You may optionally redefine:

- `default_keypair_name`: AWS key-pair name for all instances.  (Default: "k8s-not-the-hardest-way")
- `vpc_name`: VPC Name. Must be unique in the AWS Account (Default: "kubernetes")
- `elb_name`: ELB Name for Kubernetes API. Can only contain characters valid for DNS names. Must be unique in the AWS Account (Default: "kubernetes")


### Changing AWS Region

By default, the project uses `eu-west-1`. To use a different AWS Region, set additional Terraform variables:

- `region`: AWS Region (default: "eu-west-1").
- `zone`: AWS Availability Zone (default: "eu-west-1a")
- `default_ami`: Pick the AMI for the new Region from https://cloud-images.ubuntu.com/locator/ec2/: Ubuntu 16.04 LTS (xenial), HVM:EBS-SSD

## Provision infrastructure, with Terraform

Run Terraform commands from `./terraform` subdirectory.

$ terraform plan
$ terraform apply
```

Terraform outputs public DNS name of Kubernetes API and Workers public IPs.
```
Apply complete! Resources: 24 added, 0 changed, 0 destroyed.
  ...
Outputs:

  kubernetes_api_dns_name = <>
  kubernetes_workers_public_ip = <node1,node2,node3>
```
