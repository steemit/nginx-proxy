#!/bin/ash

BLOCKCHAIN_TIME=$(
    curl --silent --max-time 3 \
        --data '{"jsonrpc":"2.0","id":39,"method":"database_api.get_dynamic_global_properties"}' \
        http://steemd:8091 | jq -r .result.time
)

# this is a separate check because if the node is actually responding on the open port but
# isn't responding within the given amount of time
# curl will return a string set to null, which is different than
# if it's not responding at all and the variable is actually null
if [[ "${BLOCKCHAIN_TIME}" == "null" ]]; then
  echo Status: 502
  echo Content-type:text/plain
  echo
  echo The node is currently not responding.
  exit 0
fi

BLOCKCHAIN_TIME=`echo $BLOCKCHAIN_TIME | sed 's/T/\ /g'`

if [[ ! -z  "$BLOCKCHAIN_TIME" ]]; then
  BLOCKCHAIN_SECS=`date -d $BLOCKCHAIN_TIME +%s`
  CURRENT_SECS=`date +%s`

  # if we're within 60 seconds of current time, call it synced and report healthy
  BLOCK_AGE=$((${CURRENT_SECS} - ${BLOCKCHAIN_SECS}))
  if [[ ${BLOCK_AGE} -le 60 ]]; then
    echo Status: 200
    echo Content-type:text/plain
    echo
    echo Block age is less than 60 seconds old, this node is considered healthy.
  else
    echo Status: 503
    echo Content-type:text/plain
    echo
    echo The node is responding but block chain age is $BLOCK_AGE seconds old
  fi
else
  echo Status: 502
  echo Content-type:text/plain
  echo
  echo The node is currently not responding.
fi
