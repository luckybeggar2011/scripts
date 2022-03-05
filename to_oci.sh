#!/bin/bash

PREFIX_NAME="${1}"
SOURCE_DIRECTORY="${2}"

URL="https://objectstorage.eu-frankfurt-1.oraclecloud.com/p/sQQoXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXNs6VS/n/XXXXXXXXXXXX/b/backup/o/"
BUCKER_NAME_PREFIX="${PREFIX_NAME}"

#MAXBODYSIZE=4831838208

CURL="curl"
LOGFILE="to_azure_$(date --iso-8601=seconds).log"

date

cd ${SOURCE_DIRECTORY}
for fname in $(ls); do
  fname_short=$(basename ${fname})
  file_size=$(find ${fname} -printf "%s")
  while true; do
    echo ${fname}
	echo $CURL --insecure -T ${fname} ${URL}${BUCKER_NAME_PREFIX}${f} >> ${LOGFILE}
	$CURL --insecure -T ${fname} ${URL}${BUCKER_NAME_PREFIX}${f}
    RES=$?
	echo $RES
	if [ "$RES" == "0" ]; then
      break
	fi
  done
done

date
