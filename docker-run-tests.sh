#!/usr/bin/env bash
docker-compose -f dockercomposefile-debian8.yaml rm -fv
docker-compose -f dockercomposefile-debian8.yaml pull && \
docker-compose -f dockercomposefile-debian8.yaml build && \
docker-compose -f dockercomposefile-debian8.yaml run rundeck
exit $?
