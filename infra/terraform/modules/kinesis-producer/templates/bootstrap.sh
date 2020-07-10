#!/bin/bash

apt-get update
apt-get install -y openjdk-8-jdk

wget https://${artifact_store_bucket}.s3.amazonaws.com/producer.jar -O /home/ubuntu/producer.jar

cat <<TPL > /home/ubuntu/req-per-sec
${req_per_sec}
TPL

nohup java -jar /home/ubuntu/producer.jar ${stream_name} ${region} '/home/ubuntu/req-per-sec' &> /home/ubuntu/logs.txt &
