#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Error: parameters problem"
elif [ ! -e "$1" ]; then
    echo "Error:  user does not exist!"
elif [ ! -e "./$1/$2" ]; then
    echo "Error: service does not exists"
else
    user="$1"
    service_dir=`dirname "$2"`
    service_file=`basename "$2"`
    ./P.sh "$user"
    echo $(cat "$user"/"$service_dir"/"$service_file")
    ./V.sh "$user"
fi

