# Scala Producer

## What is this?

In order to test supporting component for kinesis streams (for example, an autocaler), it is necessary to simulate certain patterns of load so that we can confirm the new components are reacting appropiately to the load. 

This scala-producer is able to generate a steady "stream" of records with random values and send them to a kinesis stream in a controlled manner.

It accepts the following parameters:
- stream-name: is the name of the Kinesis stream
- region-name: is the region of the Kinesis stream
- records-per-second-file: location of a file with the load pattern. Each line contains the number of records to send per second during 1 minutes.

## Prereqs

- SBT: https://www.scala-sbt.org/1.x/docs/Installing-sbt-on-Mac.html

## Build

Run: `sbt assembly`

It will generate this jar file `target/scala-2.11/producer.jar`.

## Usage

```
java -jar producer.jar <stream-name> <region-name> <file-location>
```

For an example of `records-per-second-file` see: `infra/terraform/modules/kinesis-producer/templates/sample-req-per-sec.tpl`
