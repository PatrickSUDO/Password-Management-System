#!/bin/bash
if [ $# -ne 4 ]; then
    echo "Error: parameters problem"
elif [ ! -e "$1" ]; then
    echo "Error: user does not exist"
elif [ -f "./$1/$2" ]; then
    if [ -z "$3"  ]; then
        echo "Error: service already exists"
    elif [ "$3" == "f" ]; then
        user="$1"
        service_dir=`dirname "$2"`
        service_file=`basename "$2"`
        payload="$4"
        ./P.sh "$user"
        echo -e "$payload" > "$user"/"$service_dir"/"$service_file"
        echo "OK: service updated"
        ./V.sh "$user"
    else
        echo 'Error: please enter either "" or f. '
    fi
else
    user="$1"
    service_dir=`dirname "$2"`
    service_file=`basename "$2"`
    payload="$4"
    ./P.sh "$user"
    if [ ! -d "$user"/"$service_dir" ]; then
        `mkdir -p "$user"/"$service_dir"`
    fi
    echo -e "$payload" > "$user"/"$service_dir"/"$service_file"
    echo "OK: service created"
    ./V.sh "$user"
fi
