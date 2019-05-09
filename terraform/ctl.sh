#!/bin/bash

set -e

BASE=`realpath \`dirname $0\``
CMD=$1

if [ "$CMD" == "help" ] || [ "$CMD" == "--help" ] || [ "$CMD" == "" ]; then

cat <<EOF
Usage: $0 <command> [args].

Available commands:
chpass         Change cluster's password
deps           Install required dependencies, like terraform
destroy        Destroy all cluster's resources
kubeconf       Download the cluster's kubeconf file
up             Provision the cluster
restart        Restart a previously "stopped" cluster
status         Shows information such as cluster IP and InstanceId
stop           Stop the cluster without destroying its resources
EOF

exit 0

fi

shift
cd $BASE ; ./bin/cmd/$CMD.sh $@