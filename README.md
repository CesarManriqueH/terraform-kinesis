# Terraform Kinesis

This repository hosts several components that can be used together to test the behavior of [amazon-kinesis-scaling-utils](https://github.com/awslabs/amazon-kinesis-scaling-utils).

- Scala Producer: Send random records to a kinesis stream to simulate the level of activity required to trigger autoscaling actions.
- Infra/Terraform: Provision all the necessary resources to support the experiments, such as, a stream, a bucket and 2 ec2 instances.
- Infra/Packer: Creates a custom AMI to run both the amazon-kinesis-scaling-utils and scala-producer.

amazon-kinesis-scaling-utils will run in one of the ec2 instances mentioned above, the other ec2 is for the scala-producer.

## Tools

- Terraform
- Packer
- Scala/SBT

## Results

Autoscaling configuration

```
"scaleUp": {
  "scaleThresholdPct": 80,
  "scaleAfterMins": 5,
  "scaleCount": 1,
  "coolOffMins": 10
},
"scaleDown": {
  "scaleThresholdPct": 30,
  "scaleAfterMins": 5,
  "scaleCount": 1,
  "coolOffMins": 10
}
```

The changes on the number of shards are represented by the black line on the following picture:
![Put Records](https://github.com/CesarManriqueH/terraform-kinesis/blob/master/results/PutRecordsWithStreamCapacity.png)

More details, like execution logs, can be found within `/results` folder.
