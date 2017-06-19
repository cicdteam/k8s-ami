# AWS AMI for Kubernetes cluster

This repository contain specification and script to create AWS AMI images used to run Kubernete nodes (master and workes).
Images based on latest [Ubuntu 16.04 Xenial server cloud image](https://cloud-images.ubuntu.com/locator/ec2/).

### Content of resulting AMI

- useful utils as `curl`, `awscli`, `jq`
- docker engine (version 1.12)
- nvidia gpu drivers (version 375)
- k8s tools as `kubelet`, `kubeadm`, `kubectl`, `kubernetes-cni` (version 1.6)

### AMI availability

Script create's public accessible AMI's for next regions:

 - us-east-1
 - us-east-2
 - us-west-1
 - us-west-2
 - eu-west-1
 - eu-west-2
 - eu-central-1

### Example ho to use AMI in **[Terraform](https://www.terraform.io/)**

use data `aws_ami` resourse to find AMI

```
provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "image" {
  most_recent = true
  filter {
    name = "name"
    values = ["k8s-1.6-gpu-ubuntu-xenial-amd64-hvm-ebs"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["551387705498"] # pureclouds
}

resource "aws_instance" "node" {
  ami           = "${data.aws_ami.image.id}"
  instance_type = "t2.medium"

  tags = [
    { Name = "k8s-node" },
    { KubernetesCluster = "MyDevCluster" }
  ]
  root_block_device {
    volume_type   = "gp2"
    volume_size   = "30"
  }
}
```

### Tools used

- **[Packer](https://www.packer.io/)**

### Creating AMI's

```
$ ./create_amis.sh
amazon-ebs output will be in this color.

==> amazon-ebs: Force Deregister flag found, skipping prevalidating AMI Name
    amazon-ebs: Found Image ID: ami-bfa98fda
==> amazon-ebs: Creating temporary keypair: packer_594759c6-3019-ca25-9e6c-eafd8978e438
==> amazon-ebs: Creating temporary security group for this instance...
==> amazon-ebs: Authorizing access to port 22 the temporary security group...
==> amazon-ebs: Launching a source AWS instance...
    amazon-ebs: Instance ID: i-0af41f72c4f8bf4e6
==> amazon-ebs: Waiting for instance (i-0af41f72c4f8bf4e6) to become ready...
==> amazon-ebs: Adding tags to source instance
    amazon-ebs: Adding tag: "Name": "Packer Builder"
==> amazon-ebs: Waiting for SSH to become available...
==> amazon-ebs: Connected to SSH!
==> amazon-ebs: Provisioning with shell script: k8s-1.6-gpu-xenial-init.sh
    amazon-ebs: INSTALL UTILS

    <<...skipped...>>

    amazon-ebs: 0 upgraded, 24 newly installed, 0 to remove and 7 not upgraded.
    amazon-ebs: Need to get 3,871 kB of archives.
    amazon-ebs: After this operation, 30.7 MB of additional disk space will be used.

    <<...skipped...>>

    amazon-ebs: INSTALL DOCKER

    <<...skipped...>>

    amazon-ebs: The following NEW packages will be installed:
    amazon-ebs: bridge-utils cgroupfs-mount containerd docker.io runc ubuntu-fan
    amazon-ebs: 0 upgraded, 6 newly installed, 0 to remove and 7 not upgraded.
    amazon-ebs: Need to get 16.4 MB of archives.
    amazon-ebs: After this operation, 83.6 MB of additional disk space will be used.

    <<...skipped...>>

    amazon-ebs: Server Version: 1.12.6

    <<...skipped...>>

    amazon-ebs: INSTALL NVIDIA DRIVERS
    amazon-ebs: 0 upgraded, 69 newly installed, 0 to remove and 7 not upgraded.
    amazon-ebs: Need to get 118 MB of archives.
    amazon-ebs: After this operation, 591 MB of additional disk space will be used.

    <<...skipped...>>

    amazon-ebs: Setting up nvidia-375 (375.66-0ubuntu0.16.04.1) ...

    <<...skipped...>>

    amazon-ebs: Loading new nvidia-375-375.66 DKMS files...
    amazon-ebs: First Installation: checking all kernels...
    amazon-ebs: Building only for 4.4.0-1018-aws
    amazon-ebs: Building for architecture x86_64
    amazon-ebs: Building initial module for 4.4.0-1018-aws
    amazon-ebs: Done.

    <<...skipped...>>

    amazon-ebs: DKMS: install completed.
    amazon-ebs: Setting up libcuda1-375 (375.66-0ubuntu0.16.04.1) ...
    amazon-ebs: Setting up nvidia-modprobe (375.51-0ubuntu1) ...

    <<...skipped...>>

    amazon-ebs: CHECK NVIDIA DRIVERS WORKING
    amazon-ebs: Mon Jun 19 05:00:30 2017
    amazon-ebs: +-----------------------------------------------------------------------------+
    amazon-ebs: | NVIDIA-SMI 375.66                 Driver Version: 375.66                    |
    amazon-ebs: |-------------------------------+----------------------+----------------------+
    amazon-ebs: | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
    amazon-ebs: | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
    amazon-ebs: |===============================+======================+======================|
    amazon-ebs: |   0  Tesla K80           Off  | 0000:00:1E.0     Off |                    0 |
    amazon-ebs: | N/A   52C    P0    62W / 149W |      0MiB / 11439MiB |     91%      Default |
    amazon-ebs: +-------------------------------+----------------------+----------------------+
    amazon-ebs:
    amazon-ebs: +-----------------------------------------------------------------------------+
    amazon-ebs: | Processes:                                                       GPU Memory |
    amazon-ebs: |  GPU       PID  Type  Process name                               Usage      |
    amazon-ebs: |=============================================================================|
    amazon-ebs: |  No running processes found                                                 |
    amazon-ebs: +-----------------------------------------------------------------------------+

    <<...skipped...>>

    amazon-ebs: INSTALL KUBERNETES COMPONENTS

    <<...skipped...>>

    amazon-ebs: 0 upgraded, 6 newly installed, 0 to remove and 7 not upgraded.
    amazon-ebs: Need to get 43.2 MB of archives.
    amazon-ebs: After this operation, 323 MB of additional disk space will be used.

    <<...skipped...>>

    amazon-ebs: DONE
==> amazon-ebs: Stopping the source instance...
==> amazon-ebs: Waiting for the instance to stop...
==> amazon-ebs: Creating the AMI: k8s-1.6-gpu-ubuntu-xenial-amd64-hvm-ebs
    amazon-ebs: AMI: ami-7b8aac1e
==> amazon-ebs: Waiting for AMI to become ready...
==> amazon-ebs: Copying AMI (ami-7b8aac1e) to other regions...
    amazon-ebs: Copying to: us-east-1
    amazon-ebs: Avoiding copying AMI to duplicate region us-east-2
    amazon-ebs: Copying to: us-west-1
    amazon-ebs: Copying to: us-west-2
    amazon-ebs: Copying to: eu-west-1
    amazon-ebs: Copying to: eu-west-2
    amazon-ebs: Copying to: eu-central-1
    amazon-ebs: Waiting for all copies to complete...
==> amazon-ebs: Modifying attributes on AMI (ami-b7173ad7)...
    amazon-ebs: Modifying: description
    amazon-ebs: Modifying: groups
==> amazon-ebs: Modifying attributes on AMI (ami-e1485e85)...
    amazon-ebs: Modifying: description
    amazon-ebs: Modifying: groups
==> amazon-ebs: Modifying attributes on AMI (ami-7b8aac1e)...
    amazon-ebs: Modifying: description
    amazon-ebs: Modifying: groups
==> amazon-ebs: Modifying attributes on AMI (ami-f7efe58e)...
    amazon-ebs: Modifying: description
    amazon-ebs: Modifying: groups
==> amazon-ebs: Modifying attributes on AMI (ami-dac2dbbc)...
    amazon-ebs: Modifying: description
    amazon-ebs: Modifying: groups
==> amazon-ebs: Modifying attributes on AMI (ami-4696bb50)...
    amazon-ebs: Modifying: description
    amazon-ebs: Modifying: groups
==> amazon-ebs: Modifying attributes on AMI (ami-fe943391)...
    amazon-ebs: Modifying: description
    amazon-ebs: Modifying: groups
==> amazon-ebs: Modifying attributes on snapshot (snap-0f6d67cb98b8aeca5)...
==> amazon-ebs: Modifying attributes on snapshot (snap-05a78f5ac7eeb30b6)...
==> amazon-ebs: Modifying attributes on snapshot (snap-0ed235d642453892a)...
==> amazon-ebs: Modifying attributes on snapshot (snap-0dbfa9a6089885955)...
==> amazon-ebs: Modifying attributes on snapshot (snap-0274d34efa39b17df)...
==> amazon-ebs: Modifying attributes on snapshot (snap-0dceb2aa988df7f7d)...
==> amazon-ebs: Modifying attributes on snapshot (snap-053cf732a96067740)...
==> amazon-ebs: Adding tags to AMI (ami-7b8aac1e)...
==> amazon-ebs: Tagging snapshot: snap-0ed235d642453892a
==> amazon-ebs: Creating AMI tags
    amazon-ebs: Adding tag: "Name": "Kubernetes 1.6 node with GPU support"
==> amazon-ebs: Creating snapshot tags
==> amazon-ebs: Adding tags to AMI (ami-f7efe58e)...
==> amazon-ebs: Tagging snapshot: snap-0dbfa9a6089885955
==> amazon-ebs: Creating AMI tags
    amazon-ebs: Adding tag: "Name": "Kubernetes 1.6 node with GPU support"
==> amazon-ebs: Creating snapshot tags
==> amazon-ebs: Adding tags to AMI (ami-dac2dbbc)...
==> amazon-ebs: Tagging snapshot: snap-0274d34efa39b17df
==> amazon-ebs: Creating AMI tags
    amazon-ebs: Adding tag: "Name": "Kubernetes 1.6 node with GPU support"
==> amazon-ebs: Creating snapshot tags
==> amazon-ebs: Adding tags to AMI (ami-4696bb50)...
==> amazon-ebs: Tagging snapshot: snap-0dceb2aa988df7f7d
==> amazon-ebs: Creating AMI tags
    amazon-ebs: Adding tag: "Name": "Kubernetes 1.6 node with GPU support"
==> amazon-ebs: Creating snapshot tags
==> amazon-ebs: Adding tags to AMI (ami-fe943391)...
==> amazon-ebs: Tagging snapshot: snap-053cf732a96067740
==> amazon-ebs: Creating AMI tags
    amazon-ebs: Adding tag: "Name": "Kubernetes 1.6 node with GPU support"
==> amazon-ebs: Creating snapshot tags
==> amazon-ebs: Adding tags to AMI (ami-b7173ad7)...
==> amazon-ebs: Tagging snapshot: snap-0f6d67cb98b8aeca5
==> amazon-ebs: Creating AMI tags
    amazon-ebs: Adding tag: "Name": "Kubernetes 1.6 node with GPU support"
==> amazon-ebs: Creating snapshot tags
==> amazon-ebs: Adding tags to AMI (ami-e1485e85)...
==> amazon-ebs: Tagging snapshot: snap-05a78f5ac7eeb30b6
==> amazon-ebs: Creating AMI tags
    amazon-ebs: Adding tag: "Name": "Kubernetes 1.6 node with GPU support"
==> amazon-ebs: Creating snapshot tags
==> amazon-ebs: Terminating the source AWS instance...
==> amazon-ebs: Cleaning up any extra volumes...
==> amazon-ebs: No volumes to clean up, skipping
==> amazon-ebs: Deleting temporary security group...
==> amazon-ebs: Deleting temporary keypair...
Build 'amazon-ebs' finished.

==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs: AMIs were created:

eu-central-1: ami-fe943391
eu-west-1: ami-dac2dbbc
eu-west-2: ami-e1485e85
us-east-1: ami-4696bb50
us-east-2: ami-7b8aac1e
us-west-1: ami-b7173ad7
us-west-2: ami-f7efe58e

```
