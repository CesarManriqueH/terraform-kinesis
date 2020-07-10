package com.wizeline.Producer

import java.nio.ByteBuffer
import java.util.UUID

import scala.collection.JavaConverters._
import scala.concurrent.{Future}
import scala.concurrent.ExecutionContext.Implicits.global
import scala.math.max
import scala.io.Source

import com.amazonaws.auth._
import com.amazonaws.client.builder.AwsClientBuilder.EndpointConfiguration
import com.amazonaws.services.kinesis.{AmazonKinesis, AmazonKinesisClientBuilder}
import com.amazonaws.services.kinesis.model.{PutRecordsRequest, PutRecordsResult, PutRecordsRequestEntry}
import me.tongfei.progressbar.ProgressBar
import org.joda.time.{DateTime,DateTimeZone}

object Producer {
  def main(args: Array[String]) {
    if (args.length != 3) {
      System.err.println(
        """
          |Usage: KinesisWordCountASL <app-name> <stream-name> <endpoint-url>
          |
          |    <stream-name> is the name of the Kinesis stream
          |    <region-name> is the region of the Kinesis stream
          |    <records-per-second-file> number of records to send per second during 1 minutes on each line
          |
          |Generate input data for Kinesis stream using the AWS SDK
        """.stripMargin)
      System.exit(1)
    }

    val Array(streamName, region, recPerSecFile) = args

    val endpointConfiguration = new EndpointConfiguration(
      s"https://kinesis.$region.amazonaws.com",
      region
    )
    val client = AmazonKinesisClientBuilder
      .standard()
      .withCredentials(new DefaultAWSCredentialsProviderChain())
      .withEndpointConfiguration(endpointConfiguration)
      .build()

    val describeStreamResult = client.describeStream(streamName)
    val status = describeStreamResult.getStreamDescription.getStreamStatus

    if (status == "ACTIVE" || status == "UPDATING") {
      println(s"Great, $streamName is $status")
    }

    val recordsPerSecondToSendEveryMinute = Source.fromFile(recPerSecFile)
      .getLines
      .filter(v => v != "")
      .toList.map(v => v.toInt)

    for (recordsPerSecond <- recordsPerSecondToSendEveryMinute) {
      loadStream(client, streamName, recordsPerSecond, 1)
    }
  }

  private def loadStream(client: AmazonKinesis, streamName: String, recordsPerSecond: Int, timeFrameInMinutes: Int) {
    println(s"[ ${now} ] Next Batch => ${recordsPerSecond} records/sec for ${timeFrameInMinutes} minutes")

    val putRecordsCallsPerSecond = 10
    val records = (1 to recordsPerSecond / putRecordsCallsPerSecond).toList.map(_ => {
      val uuid = UUID.randomUUID.toString
      (ByteBuffer.wrap(uuid.getBytes), uuid)
    })

    // val pb = new ProgressBar("Sending Records to Stream", 100)
    val listOfFutures = List[Future[PutRecordsResult]]()
    val iterations = timeFrameInMinutes * 60 * 10
    for (i <- 1 to iterations) {
      val start = System.nanoTime()
      multiPutAsync(client, streamName, records) :: listOfFutures

      // pb.stepTo(i * 100 / iterations)

      val durationMs = (System.nanoTime() - start) / 1e6
      Thread.sleep(max((1000 / putRecordsCallsPerSecond) - durationMs.toInt, 0))
    }
    // pb.stop()

    Future.sequence(listOfFutures).onComplete {
      case i => None
    }
  }

  private def multiPutAsync(client: AmazonKinesis, streamName: String, batch: List[(ByteBuffer, String)]): Future[PutRecordsResult] =
    Future {
      val putRecordsRequest = {
        val prr = new PutRecordsRequest()
        prr.setStreamName(streamName)
        val putRecordsRequestEntryList = batch.map {
          case (b, s) =>
            val prre = new PutRecordsRequestEntry()
            prre.setPartitionKey(s)
            prre.setData(b)
            prre
        }
        prr.setRecords(putRecordsRequestEntryList.asJava)
        prr
      }
      client.putRecords(putRecordsRequest)
    }

  private def now() = new DateTime(DateTimeZone.UTC)
}
