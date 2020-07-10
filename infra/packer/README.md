# Packer Images

These are definitions for prebacked AMIs, which are used to speed up boot time of EC2s instances.

## What is Packer

Packer is a tool for building identical machine images for multiple platforms from a single source configuration.

Packer is lightweight, runs on every major operating system, and is highly performant, creating machine images for multiple platforms in parallel. Packer comes out of the box with support for many platforms, the full list of which can be found at https://www.packer.io/docs/builders/index.html.

## Prereqs

- Install Packer: https://learn.hashicorp.com/packer/getting-started/install#installing-packer
- Configure AWS credentials: https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/setup-credentials.html

## Usage

In order to create this custom image execute:
```
cd infra/packer
packer build -var "aws_region=${AWS_REGION}" custom-ami.json
```

As a result, you should be able to see your brand new AMI at AWS Console -> EC2 -> Images -> AMIs
