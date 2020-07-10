#!/bin/bash

# TODO: Add supervisor to base image

wget https://github.com/CesarManriqueH/amazon-kinesis-scaling-utils/releases/download/v.9.8.0/KinesisScalingUtils-.9.8.0-complete.jar \
  -O /home/ubuntu/kinesis-scaling-utils.jar

cat <<TPL > /home/ubuntu/config.json
${config}
TPL

nohup java -Dconfig-file-url=/home/ubuntu/config.json \
  -cp /home/ubuntu/kinesis-scaling-utils.jar \
  com.amazonaws.services.kinesis.scaling.auto.AutoscalingController \
  &> /home/ubuntu/logs.txt &
