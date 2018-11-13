#!/usr/bin/env bash

ulimit -l 262144

POOL=
WALLET=
PASSWD=
CURR=monero

if [[ -f /etc/xmr-stak/config.txt && -f /etc/xmr-stak/pools.txt && -f /etc/xmr-stak/amd.txt ]]; then
  docker run -d --rm --name xmr-stak-amd --device /dev/dri -v /etc/xmr-stak:/etc/xmr-stak:ro merxnet/xmr-stak-amd \
    -c /etc/xmr-stak/config.txt \
    -C /etc/xmr-stak/pools.txt \
    --amd /etc/xmr-stak/amd.txt
else
  docker run -d --rm --name xmr-stak-amd --device /dev/dri merxnet/xmr-stak-amd \
    -o ${POOL}
    -u ${WALLET} \
    -p ${PASSWD} \
    --currency ${CURR}
fi
