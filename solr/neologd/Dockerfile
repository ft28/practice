FROM openjdk:11-jdk

ARG user_id
ARG user_name
ARG group_id
ARG group_name

RUN  apt-get update \
     && apt-get install -y build-essential wget gcc g++ ant

RUN  groupadd -g ${group_id} ${group_name} \
     && useradd --gid ${group_id} --uid ${user_id} -m -d /home/${user_name} ${user_name} \
     && mkdir -p /opt/solr \
     && chown -R ${user_name}:${group_name} /opt 

RUN apt-get install -y file
USER ${user_name}
WORKDIR /opt

