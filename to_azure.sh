#!/bin/bash

PREFIX_NAME="${1}"
SOURCE_DIRECTORY="${2}"

SAS_TOKEN="sp=racwdli&st=2022-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-31T19:30:24Z&sv=2020-08-04&sr=c&sig=fWXXXXXXXXXXXXXXXXXXXX3D"
BUCKET="https://myblob.blob.core.windows.net/backup"

MAXBODYSIZE=4831838208

CURL="curl"
LOGFILE="to_azure_$(date --iso-8601=seconds).log"

date

cd ${SOURCE_DIRECTORY}

for fname in $(ls); do
  fname_short=$(basename ${fname})
  file_size=$(find ${fname} -printf "%s")
  if [[ ${file_size} -le ${MAXBODYSIZE} ]]; then
    while true; do
      echo ${fname}
      $CURL --insecure -X PUT -T ${fname} -H "x-ms-date: $(date -u)" -H "x-ms-blob-type: BlockBlob" "${BUCKET}/${PREFIX_NAME}_${fname_short}?${SAS_TOKEN}"
      RES=$?
	  echo $RES
	  if [ "$RES" == "0" ]; then
        break
	  fi
	done
  else
    echo ${fname_short}
    split -a6 -b${MAXBODYSIZE} ${fname_short} ${fname_short}____
    for fnamesplit in $(ls ${fname_short}____*); do
	  while true; do 
        echo $CURL --insecure -X PUT -T ${fnamesplit} -H "x-ms-date: $(date -u)" -H "x-ms-blob-type: BlockBlob" "${BUCKET}/${PREFIX_NAME}_${fnamesplit}?${SAS_TOKEN}" >> ${LOGFILE}
		echo ${fnamesplit}
        $CURL --insecure -X PUT -T ${fnamesplit} -H "x-ms-date: $(date -u)" -H "x-ms-blob-type: BlockBlob" "${BUCKET}/${PREFIX_NAME}_${fnamesplit}?${SAS_TOKEN}"
		RES=$?
        echo $RES
		if [ "$RES" == "0" ]; then
		  rm -f ${fnamesplit}
		  break
		fi
	  done
    done
  fi
done
date
