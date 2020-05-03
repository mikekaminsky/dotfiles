#!/bin/sh -e -x
if [ $# -lt 1 ]; then
  echo 1>&2 "$0: not enough arguments"
  exit 2
elif [ $# -gt 2 ]; then
  echo 1>&2 "$0: too many arguments"
  exit 2
fi

PROG=${2-ssh} 
if [[ "$PROG" = "ssh" ]]; then 
  ssh -i ~/.ssh/mk-macbook-air.pem ubuntu@$1
elif [[ "$PROG" = "mosh" ]]; then 
  mosh --ssh="ssh -i ~/.ssh/mk-macbook-air.pem" ubuntu@$1
fi
