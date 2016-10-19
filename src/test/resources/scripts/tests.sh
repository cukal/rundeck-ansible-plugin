#!/usr/bin/env bash

service rundeckd start

echo waiting for rundeck to start...

while ! grep SelectChannelConnector /var/log/rundeck/service.log >/dev/null; do
  sleep 5
  echo -n .
done
sleep 5
echo ""

./rundecklogin.sh

echo checking system infos...
. ./include.sh
. ./test-system-info.sh

. ./test-project-creation.sh

echo running tests...
