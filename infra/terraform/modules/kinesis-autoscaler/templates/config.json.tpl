[
  {
    "streamName": "${in_stream}",
    "region": "${region}",
    "scaleOnOperation": ["PUT","GET"],
    "minShards": 1,
    "maxShards": 6,
    "refreshShardsNumberAfterMin": 10,
    "checkInterval": 300,
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
  }
]
