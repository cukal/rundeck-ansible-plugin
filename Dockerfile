FROM alpine
MAINTAINER David Kirstein <dak@batix.com>

# combining stuff from:
# https://github.com/colebrumley/docker-rundeck
# https://github.com/William-Yeh/docker-ansible

# install Ansible
RUN apk --no-cache add sudo python py-pip openssl ca-certificates && \
  apk --no-cache add --virtual build-deps python-dev libffi-dev openssl-dev build-base && \
  pip --no-cache-dir install --upgrade pip cffi && \
  pip --no-cache-dir install ansible==2.3.1.0 && \
  apk del build-deps && \
  mkdir -p /etc/ansible

# install Rundeck
ENV RDECK_BASE=/opt/rundeck
ENV RDECK_JAR=${RDECK_BASE}/rundeck-launcher.jar
ENV PATH=${PATH}:${RDECK_BASE}/tools/bin
ENV MANPATH=${MANPATH}:${RDECK_BASE}/docs/man
ENV RDECK_ADMIN_PASS=rdtest2017
RUN apk --no-cache add openjdk8-jre bash curl && \
  mkdir -p ${RDECK_BASE} && \
  mkdir ${RDECK_BASE}/libext && \
  curl -SLo ${RDECK_JAR} http://dl.bintray.com/rundeck/rundeck-maven/rundeck-launcher-2.8.2.jar
COPY docker/realm.properties ${RDECK_BASE}/server/config/
COPY docker/run.sh /

# install plugin from GitHub
RUN curl -SLo ${RDECK_BASE}/libext/ansible-plugin.jar https://github.com/Batix/rundeck-ansible-plugin/releases/download/2.0.2/ansible-plugin-2.0.2.jar

# install local plugin
#COPY build/libs/ansible-plugin-*.jar ${RDECK_BASE}/libext/

# create project
ENV PROJECT_BASE=${RDECK_BASE}/projects/Test-Project
RUN mkdir -p ${PROJECT_BASE}/acls && \
  mkdir -p ${PROJECT_BASE}/etc
COPY docker/project.properties ${PROJECT_BASE}/etc/

ENV ANSIBLE_HOST_KEY_CHECKING=false
ENV RDECK_HOST=localhost
ENV RDECK_PORT=4440

CMD /run.sh
