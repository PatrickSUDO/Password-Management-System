#!/bin/bash
if [ $# -lt 2 ] || [ $# -gt 4 ]; then
    echo "Error: parameters problem"
fi
clientId="$1"
req="$2"
user="$3"
service="$4"
mkfifo "$clientId".pipe
case "$req" in
    init) 
        if [ -z "$clientId" ] || [ -z "$user" ]; then
            echo "clientId and user should be specified!"
        else
            echo "$clientId" "$req" "$user"  > server.pipe
            read response < "$clientId.pipe"
            echo "$response"            
        fi
        ;;
    insert)
        if [ -z "$clientId" ] || [ -z "$user" ] || [ -z "$service" ]; then
            echo "clientId, user and service should be specified!"
        else
            read -p "Please write login: " "mylogin"
            read -p "If you need a random password, please enter 'y' or 'enter' to pass" "random"
            if [ "$random" = "y" ]; then
                mypassword=`./random-pwd.sh`
                echo "You random password is: $mypassword"
            else
                read -p "Please write password: " "mypassword"
            fi
            login_enc=`./encrypt.sh "mylogin_key" "$mylogin"`
            echo "You login was encrypted!"
            pwd_enc=`./encrypt.sh "mypassword_key" "$mypassword"`
            echo "You password was enecrypted!"
            echo "$clientId" "$req" "$user" "$service" "$login_enc" "$pwd_enc" > server.pipe
            read response < "$clientId.pipe"
            echo "$response"
            
        fi
        ;;
    show)
        if [ -z "$clientId" ] || [ -z "$user" ] || [ -z "$service" ]; then
            echo "clientId, user and service should be specified!"
        else
            echo "$clientId" "$req" "$user" "$service" > server.pipe
            # read dummy mylogin dummy2 mypassword < "$clientId.pipe"
            read response < "$clientId.pipe"
            if [[ $response == Error:* ]]; then
                echo "$response"
            else
                service_file=`basename "$service"`
                mylogin=`echo "$response" | sed -e 's/login: \(.*\) password: \(.*\)/\1/'`
                mypassword=`echo "$response" | sed -e 's/login: \(.*\) password: \(.*\)/\2/'`
                login_dec=`./decrypt.sh "mylogin_key" "$mylogin"`
                password_dec=`./decrypt.sh "mypassword_key" "$mypassword"`
                echo "$user's login for $service_file is: $login_dec"
                echo "$user's password for $service_file is: $password_dec"
            fi
        fi
        ;;
    edit)
        if [ -z "$clientId" ] || [ -z "$user" ] || [ -z "$service" ]; then
            echo "clientId, user and service should be specified!"
        else 
            echo "$clientId" show "$user" "$service" > server.pipe
            read dummy mylogin dummy2 mypassword < "$clientId.pipe"
            login_dec=`./decrypt.sh "mylogin_key" "$mylogin"`
            password_dec=`./decrypt.sh "mypassword_key" "$mypassword"`
            temp=mktemp
            echo -e "login: ${login_dec}\npassword: ${password_dec}" > $temp            
            nano $temp
            login_tmp=`cat mktemp | sed -n '1p' | sed -e 's/login: \(.*\)/\1/'`
            echo $login_tmp
            password_tmp=`cat mktemp | sed -n '2,$p' | sed -e 's/password: \(.*\)/\1/'`
            echo $password_tmp
            rm $temp
            mkfifo $clientId.pipe 
            login_enc=`./encrypt.sh "mylogin_key" "$login_tmp"`
            echo "You login was encrypted!"
            pwd_enc=`./encrypt.sh "mypassword_key" "$password_tmp"`
            echo "You password was encrypted!"
            echo "$clientId" update "$user" "$service" "$login_enc" "$pwd_enc" > server.pipe
            read response < "$clientId.pipe"
            echo "$response"
        fi
        ;;
    rm)
        if [ -z "$clientId" ] || [ -z "$user" ] || [ -z "$service" ]; then
            echo "clientId, user and service should be specified!"
        else 
            echo "$clientId" "$req" "$user" "$service" > server.pipe
            read response < "$clientId.pipe"
            echo "$response"
        fi
        ;;
    ls)
        if [ -z $clientId ] || [ -z $user ]; then
            echo "clientId, user should be specified!"
        else 
            echo "$clientId" "$req" "$user" "$service" > server.pipe 
            cat "$clientId.pipe"
        fi
        ;;
    shutdown)
        echo "$clientId" "$req" > server.pipe
        read response < "$clientId.pipe"
        echo "$response"
        exit 0
        ;;
    *)
        echo "Error: bad request"
        exit 1
esac
