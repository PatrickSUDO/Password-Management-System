#!/bin/bash
if [ $# -gt 2 ] || [ $# -lt 1 ]; then
    echo "Error: parameters problem"
elif [ ! -e "$1" ]; then
    echo "Error:  user does not exist!"
elif [ ! -e "./$1/$2" ]; then
    echo "Error: folder does not exists"
else
    user="$1"
    folder="$2"
    ./P.sh "$user"
    tree --noreport $user/$folder
    ./V.sh "$user"
fi

