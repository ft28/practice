FROM openjdk:8-jre-alpine

ARG user_id
ARG user_name
ARG group_id
ARG group_name
ARG version=7.2.1

RUN apk --update add --no-cache procps curl bash lsof tar \
    && mkdir /opt

WORKDIR /opt

RUN  curl -L http://archive.apache.org/dist/lucene/solr/${version}/solr-${version}.tgz -o solr-${version}.tgz \
     && tar xvzf solr-${version}.tgz \
     && rm -rf   solr-${version}.tgz \
     && mv solr-${version} /opt/solr \
     && rm -rf /opt/solr/docs \
     && rm -rf /opt/solr/example \
     && rm -rf /opt/solr/server/solr/configsets \
     && rm -rf /opt/solr/server/solr/logs

RUN  rm /opt/solr/server/solr-webapp/webapp/WEB-INF/lib/lucene-analyzers-kuromoji-${version}.jar
COPY docker/solr/server /opt/solr/server

RUN  addgroup -g ${group_id} ${group_name} \
     && adduser -S -G ${group_name} -u ${user_id} ${user_name} \
     && chown -R ${user_name}:${gropu_name} /opt/solr 

WORKDIR /opt/solr

USER ${user_name}

CMD ["/opt/solr/bin/solr", "start", "-f"]

