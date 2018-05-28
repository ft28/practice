#! /bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
SOLR_VERSION=7.2.1

build_dir=$SCRIPT_DIR/build

if [ ! -e $build_dir ] ; then
  mkdir -p $build_dir
fi


cd $SCRIPT_DIR/build

dict_dir=${build_dir}/mecab-ipadic-neologd/build

if [ -e $dict_dir ]; then
  dict_name=`ls ${dict_dir} | grep -v tar.gz`
  if [ "$dict_name" != "" ]; then
    dict_path=${dict_dir}/${dict_name}
  fi
else
  dict_path=""
fi

if [ ! -e 'mecab' ]; then
  git clone https://github.com/taku910/mecab.git
fi

if [ ! -e mecab-ipadic-neologd ]; then
  git clone https://github.com/neologd/mecab-ipadic-neologd.git
fi

if [ ! -e 'lucene-solr' ]; then
  git clone https://github.com/apache/lucene-solr.git
fi

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/mecab/lib
export PATH=$PATH:/opt/mecab/bin

if [ "$dict_path" == "" ] || [ ! -e $dict_path ] ; then
  echo "build mecab"
  cd mecab/mecab
  ./configure --with-charset=utf8 --enable-utf8-only --prefix=/opt/mecab
  make
  make check
  make install

  echo "build mecab-ipadic"
  cd ../mecab-ipadic
  ./configure --with-charset=utf8 --prefix=/opt/mecab
  make
  make install

  echo "mecab-ipadic-neologd"
  cd ../../mecab-ipadic-neologd
  ./bin/install-mecab-ipadic-neologd -n -y \
  --max_baseform_length 15 
  --ignore_noun_ortho

  cd $build_dir

  dict_name=`ls ${dict_dir} | grep -v tar.gz`
  dict_path=${dict_dir}/${dict_name}
fi

echo "build lucene-analysis-kuromoji"
cd lucene-solr

mkdir -p lucene/build/analysis/kuromoji
  
echo dict_path = $dict_path
echo dict_name = $dict_name
export dict_name

cp -a $dict_path lucene/build/analysis/kuromoji

cd lucene/analysis/kuromoji

git branch | grep $SOLR_VERSION
if [ $? == "1" ] ; then
  git checkout -b $SOLR_VERSION releases/lucene-solr/$SOLR_VERSION
else
  git checkout .
fi

# change ipadic.version 
sed -i -e "s/value=\"mecab-ipadic-.*\"/value=\"${dict_name}\"/" build.xml
# change dict.encoding
sed -i  -e 's/euc-jp/utf-8/' build.xml
# change build-dict
sed -i -e 's/compile-tools, download-dict/compile-tools/' build.xml
# change maxmemory
sed -i -e 's/maxmemory="1g"/maxmemory="4g"/' build.xml

# build
ant ivy-bootstrap && ant regenerate && ant jar-core

cp $build_dir/lucene-solr/lucene/build/analysis/kuromoji/lucene-analyzers-kuromoji-7.2.1-SNAPSHOT.jar $SCRIPT_DIR

