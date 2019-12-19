#!/bin/bash
if [ $# -eq 0 ]; then
    echo "Error: parameters problem!"
elif [ -d "./$1" ]; then
    echo "Error: user already exists!"
elif [ $# -gt 1 ]; then
    echo "Error: too many parameter!"
else
    user="$1"
    ./P.sh "$user"
    `mkdir "$user"`
    ./V.sh "$user"
    echo "OK $user created!"
fi