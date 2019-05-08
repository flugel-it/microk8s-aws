#!/bin/bash

set -e

BASE=`realpath \`dirname $0\``
CMD=$1

if [ "$CMD" == "help" ] || [ "$CMD" == "--help" ] || [ "$CMD" == "" ]; then

cat <<EOF
Usage: $0 <command> [args].

Available commands:
deps           Install required dependencies, like terraform.
up             Provision the cluster
destroy        Destroy all cluster's resources
stop           Stop the cluster without destroying its resources
restart        Restart a previously "stopped" cluster

EOF

exit 0

fi

shift
cd $BASE ; ./bin/cmd/$CMD.sh $@