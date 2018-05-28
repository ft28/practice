#! /bin/bash

echo "test q=%E6%96%B0(=新)"
curl 'http://localhost:8983/solr/sample01/suggest?suggest=true&suggest.count=3&suggest.q=%E6%96%B0'

echo "test q=%E6%96%B0(=新)"
curl 'http://localhost:8983/solr/sample01/suggest?suggest=true&suggest.dictionary=default&suggest.dictionary=roman1&suggest.count=3&suggest.q=%E6%96%B0'

echo "test q=s"
curl 'http://localhost:8983/solr/sample01/suggest?suggest=true&suggest.dictionary=default&suggest.dictionary=roman1&suggest.count=3&suggest.q=s'

echo "test q=s(=新)&cfq=1(1=山手線id)"
curl 'http://localhost:8983/solr/sample01/suggest?suggest=true&suggest.dictionary=default&suggest.dictionary=roman1&suggest.count=3&suggest.q=s&suggest.cfq=1'
