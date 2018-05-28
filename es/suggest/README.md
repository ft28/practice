# elasticsearch 実験リポジトリ
Elasticsearch に関する実験用のコードとデータを保存しているリポジトリです。

## License
MIT


## 実験環境

    * サジェスト検索時のクエリをうまく処理できるように独自拡張した lucene-analyzers-kuromoji  をElasticsearch でも使えるようにします。
    * Elasticsearch の analysis-kuromoji plugin を改良して上記モジュールを呼び出すインターフェースを追加します。

## 実験環境の作り方

### 1. リポジトリを取得
```
git clone https://github.com/ft28/practice_es
```

### 2. docker コンテナでマウントするディレクトリを作成
```
mkdir -p ~/mount_docker/data/elasticsearch
mkdir -p ~/mount_docker/log/elasticsearch
```

### 3.コンテナ作成＋起動
```
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

## sample01 : suggester 実験

### 1.sample01用のデータ投入

```
cd sample01

# インデックス作成
curl -XPUT http://localhost:9200/suggest -d @mapping.json -H 'Content-Type: application/json'

# データ投入
curl -XPOST http://localhost:9200/suggest/keyword/_bulk?pretty --data-binary @blk.json -H 'Content-Type: application/json'
```
