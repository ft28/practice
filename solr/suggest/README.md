# solr suggest 実験環境
solr のsuggest 実験用のコードとデータを保存しています。

## License
MIT

## 実験環境の作り方

### 1. リポジトリを取得
```
git clone https://github.com/ft28/practice
```
### 2. docker コンテナでマウントするディレクトリを作成
```
mkdir -p ~/mount_docker/data/solr/sample01
mkdir -p ~/mount_docker/log/solr
```
### 3.環境変数にsolr コンテナ用の環境変数を.bashrcに追加
```bash:.bashrc
...
# for docker
export USER_ID=`id -u`
export USER_NAME=`id -nu`
export GROUP_ID=`id -g`
export GROUP_NAME=`id -ng`
```
### 4.コンテナ作成＋起動
```
cd practice/solr/suggest
docker-compose build
docker-compose up
```

以下のようなエラーが発生場合は、設定ファイルのIPアドレスに関する部分を変更して、再度、docker-compose build を
実行してください。

```
Creating network "practicesolr_develop_nw" with the default driver
ERROR: cannot create network <省略> : conflicts with network <省略> : networks have overlapping IPv4
```

* docker-compose.yml

```yml:docker-compose.yml
networks:
  develop_nw:
    ipam:
      driver: default
      config:
        - subnet: 172.16.239.0/24
```

* docker/server/etc/jetty.xml

```xml:docker/server/etc/jetty.xml
<Call name="addWhite">
  <Arg>172.16.239.</Arg>
</Call>
```
### 5.solr 起動確認
ブラウザから http://localhost:8983/solr にアクセスしてsolrが起動していることを確認します。

## sample01 : suggester 実験

### 1.sample01用のデータ投入
```
cd sample01
./insert_data.sh
```

## 独自モジュールの導入方法


### コンパイル方法

```
# solr のリポジトリをローカルに作成します。
git clone https://github.com/apache/lucene-solr.git

# 取得したリポジトリのディレクトリに移動します。
cd lucene-solr

# 適当な名前でタグをチェックアウトします。
git checkout -b new_branch releases/lucene-solr/7.2.1

# パッチファイルをカレントディレクトリにコピーします
cp ../practice_solr/patches/ConcatenateJapaneseReadingFilter.patch .
cp ../practice_solr/patches/ReRankSamplePlugin.patch .

# パッチを実行します
patch -p1 < ConcatenateJapaneseReadingFilter.patch
patch -p1 < ReRankSamplePlugin.patch

# ConcatenateJapaneseReadingFilter をコンパイルします。
cd lucene/analysis/kuromoji
ant

cd solr/contrib/sample
ant
```

### 配置方法
コンパイルが成功すると、lucene-solr/lucene/build/analysis/kuromoji/lucene-analyzers-kuromoji-7.2.1-SNAPSHOT.jar
が作成されます。既存のkuromoji モジュールを無効化し、新しく作成したkuromojiモジュールを使うよう設定します。

```
mv solr/server/solr-webapp/webapp/WEB-INF/lib/lucene-analyzers-kuromoji-7.2.1.jar solr/server/solr-webapp/webapp/WEB-INF/lib/lucene-analyzers-kuromoji-7.2.1.jar.org
cp ./lucene/build/analysis/kuromoji/lucene-analyzers-kuromoji-7.2.1-SNAPSHOT.jar solr/server/solr-webapp/webapp/WEB-INF/lib
cp ./solr/build/contrib/solr-rerank-sample/solr-rerank-sample-7.2.1-SNAPSHOT.jar solr/server/solr-webapp/webapp/WEB-INF/lib/

```

### モジュールのテスト方法

```
ant test -Dtestcase=TestConcatenateJapaneseReadingFilter
ant test -Dtestcase=TestConcatenateJapaneseReadingFilterFactory
```

