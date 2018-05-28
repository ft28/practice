##! /bin/bash

echo "inserted sample01.tsv"
curl 'http://localhost:8983/solr/sample01/update/csv?commit=true&separator=%09' \
  -H 'Content-Type:application/csv' \
  --data-binary @sample01.tsv

echo "create sugegst dictionary"
curl 'http://localhost:8983/solr/sample01/suggest?suggest=true&suggest.build=true&&suggest.dictionary=default&suggest.dictionary=roman1&suggest.dictionary=roman2'

