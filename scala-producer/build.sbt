lazy val root = (project in file(".")).

  settings(
    inThisBuild(List(
      organization := "com.wizeline",
      scalaVersion := "2.11.8"
    )),
    name := "producer",
    version := "0.0.1",

    // TODO: check what are these options for
    javacOptions ++= Seq("-source", "1.8", "-target", "1.8"),
    javaOptions ++= Seq("-Xms512M", "-Xmx2048M", "-XX:MaxPermSize=2048M", "-XX:+CMSClassUnloadingEnabled"),
    scalacOptions ++= Seq("-deprecation", "-unchecked"),
    parallelExecution in Test := false,
    fork := true,

    coverageHighlighting := true,

    libraryDependencies ++= Seq(
      "com.amazonaws" % "aws-java-sdk-kinesis"  % "1.11.566",
      "com.amazonaws" % "amazon-kinesis-client" % "1.10.0",
      "me.tongfei"    % "progressbar"           % "0.8.1",
      "joda-time"     % "joda-time"             % "2.10.6",

      "org.scalatest"  %% "scalatest"  % "3.0.1"  % "test",
      "org.scalacheck" %% "scalacheck" % "1.13.4" % "test"
    ),

    // uses compile classpath for the run task, including "provided" jar (cf http://stackoverflow.com/a/21803413/3827)
    run in Compile := Defaults.runTask(fullClasspath in Compile, mainClass in (Compile, run), runner in (Compile, run)).evaluated,

    scalacOptions ++= Seq("-deprecation", "-unchecked"),
    pomIncludeRepository := { x => false },

    pomIncludeRepository := { x => false }
  )

assemblyJarName in assembly := "producer.jar"
