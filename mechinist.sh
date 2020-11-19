#!/bin/bash

## CPU利用率を%単位で表示
CPU_USED=$(cat /proc/loadavg | awk '{print $1}')
CPU_USED_PER=$(echo "100 * ${CPU_USED}" | bc | sed -e "s/.00$//g")

## メモリ利用率を%単位で表示
MEM_USED=$(free -m | sed -n 2p | awk '{print $3}')
MEM_USED_PER=$(echo "${MEM_USED} * 0.0125" | bc)


curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer ${api_key}" https://gw.machinist.iij.jp/endpoint -d @- << EOS
{
  "agent": "Home",
  "metrics": [
    {
      "name": "cpu used",
      "namespace": "minecraft",
      "data_point": {
        "value": ${CPU_USED_PER}
      }
    },
    {
      "name": "mem used",
      "namespace": "minecraft",
      "data_point": {
        "value": ${MEM_USED_PER}
      }
    }
  ]
}
EOS
