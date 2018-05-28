FROM library/openjdk:10-jdk

RUN mkdir /opt/build && \
    cd /opt/build && \
    git  clone -b 6.2 https://github.com/elastic/elasticsearch.git


#RUN wget http://ftp.kddilabs.jp/infosystems/apache/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz && \
#    tar xvzf apache-maven-3.5.2-bin.tar.gz && \
#    cd apache-maven-3.5.2/bin && \
#    ./mvn install:install-file -Dfile=/lucene-analyzers-kuromoji-7.2.1-SNAPSHOT.jar -DgroupId=test -DartifactId=lucene-analyzers-kuromoji -Dversion=7.2.3 -Dpackaging=jar -DgeneratePom=true

WORKDIR /opt/build/elasticsearch

ADD src/lucene-analyzers-kuromoji-7.2.1-SNAPSHOT.jar         /opt/build/elasticsearch/plugins/analysis-kuromoji
ADD src/KuromojiConcatenateJapaneseReadingFilterFactory.java /opt/build/elasticsearch/plugins/analysis-kuromoji/src/main/java/org/elasticsearch/index/analysis
ADD src/AnalysisKuromojiPlugin.java                          /opt/build/elasticsearch/plugins/analysis-kuromoji/src/main/java/org/elasticsearch/plugin/analysis/kuromoji
ADD src/build.gradle                                         /opt/build/elasticsearch/plugins/analysis-kuromoji/build.gradle

RUN ./gradlew assemble


RUN cd /opt && \
    tar xvzf /opt/build/elasticsearch/distribution/tar/build/distributions/*.tar.gz && \
    mv elasticsearch-* elasticsearch

WORKDIR /opt/elasticsearch

RUN ./bin/elasticsearch-plugin install file:/opt/build/elasticsearch/plugins/analysis-kuromoji/build/distributions/analysis-kuromoji-6.2.5-SNAPSHOT.zip

RUN groupadd -g 1000 elasticsearch && \
    useradd -d /home/elasticsearch -m -s /bin/bash -u 1000 -g 1000 elasticsearch && \
    chown -R elasticsearch:elasticsearch /opt

USER elasticsearch
ADD elasticsearch.yml config
EXPOSE 9200 9300

CMD ["./bin/elasticsearch"]
