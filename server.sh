#!/bin/bash
if [ ! -e "./server.pipe" ];then
    echo "No pipe, create one."
    mkfifo server.pipe
fi
while true; do 
    sleep 2
    read "clientId" "req" "user" "service" "mylogin" "mypassword" < server.pipe

    echo "Your client ID: $clientId"
    echo "Your request: $req"
    echo "Your user name: $user"
    echo "Your service name: $service"

    case "$req" in
        init)
            ./init.sh "$user" > $clientId.pipe &
            rm $clientId.pipe
            ;;
        insert)
            ./insert.sh "$user" "$service" "" "login: ${mylogin}\npassword: ${mypassword}" > $clientId.pipe &
            rm $clientId.pipe
            ;;
        show)
            ./show.sh "$user" "$service" > $clientId.pipe &
            rm $clientId.pipe
            ;;
        update)
            ./insert.sh "$user" "$service" f "login: ${mylogin}\npassword: ${mypassword}" > $clientId.pipe &
            rm $clientId.pipe
            ;;
        rm)
            ./rm.sh "$user" "$service" > $clientId.pipe &
            rm $clientId.pipe
            ;;
        ls)
            #No service need to input, so the position is for option argument folder
            folder="$service"
            ./ls.sh "$user" "$folder" > $clientId.pipe &
            rm $clientId.pipe
            ;;
        shutdown)
            rm -f server.pipe
            echo $!
            echo "Server closed!" > $clientId.pipe &
            rm $clientId.pipe
            exit 0 
            ;;
        *)
            echo "Error: bad request" > $clientId.pipe &
            rm ./$clientId.pipe
            exit 1
    esac
done
