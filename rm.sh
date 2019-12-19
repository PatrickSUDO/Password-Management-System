#!/bin/bash
if [ $# -ne 2 ]; then
    echo "Error: parameters problem"
elif [ ! -e "$1" ]; then
    echo "Error: user does not exist"
elif [ ! -e "./$1/$2" ]; then
    echo "Error: service does not exists"
else
    user="$1"
    service="$2"
    ./P.sh "$user"
    rm -rf $user/$service
    ./V.sh "$user"
    echo "OK: service removed"
fi 