#!/bin/bash
# Blah blah star topology or sum sheit script

problem() {
    echo "⠀⣞⢽⢪⢣⢣⢣⢫⡺⡵⣝⡮⣗⢷⢽⢽⢽⣮⡷⡽⣜⣜⢮⢺⣜⢷⢽⢝⡽⣝"
    echo "⠸⡸⠜⠕⠕⠁⢁⢇⢏⢽⢺⣪⡳⡝⣎⣏⢯⢞⡿⣟⣷⣳⢯⡷⣽⢽⢯⣳⣫⠇"
    echo "⠀⠀⢀⢀⢄⢬⢪⡪⡎⣆⡈⠚⠜⠕⠇⠗⠝⢕⢯⢫⣞⣯⣿⣻⡽⣏⢗⣗⠏⠀"
    echo "⠀⠪⡪⡪⣪⢪⢺⢸⢢⢓⢆⢤⢀⠀⠀⠀⠀⠈⢊⢞⡾⣿⡯⣏⢮⠷⠁⠀⠀⠀"
    echo "⠀⠀⠀⠈⠊⠆⡃⠕⢕⢇⢇⢇⢇⢇⢏⢎⢎⢆⢄⠀⢑⣽⣿⢝⠲⠉⠀⠀⠀⠀"
    echo "⠀⠀⠀⠀⠀⡿⠂⠠⠀⡇⢇⠕⢈⣀⠀⠁⠡⠣⡣⡫⣂⣿⠯⢪⠰⠂⠀⠀⠀⠀"
    echo "⠀⠀⠀⠀⡦⡙⡂⢀⢤⢣⠣⡈⣾⡃⠠⠄⠀⡄⢱⣌⣶⢏⢊⠂⠀⠀⠀⠀⠀⠀"
    echo "⠀⠀⠀⠀⢝⡲⣜⡮⡏⢎⢌⢂⠙⠢⠐⢀⢘⢵⣽⣿⡿⠁⠁⠀⠀⠀⠀⠀⠀⠀"
    echo "⠀⠀⠀⠀⠨⣺⡺⡕⡕⡱⡑⡆⡕⡅⡕⡜⡼⢽⡻⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
    echo "⠀⠀⠀⠀⣼⣳⣫⣾⣵⣗⡵⡱⡡⢣⢑⢕⢜⢕⡝⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
    echo "⠀⠀⠀⣴⣿⣾⣿⣿⣿⡿⡽⡑⢌⠪⡢⡣⣣⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
    echo "⠀⠀⠀⡟⡾⣿⢿⢿⢵⣽⣾⣼⣘⢸⢸⣞⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
    echo "⠀⠀⠀⠀⠁⠇⠡⠩⡫⢿⣝⡻⡮⣒⢽⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
    echo "No $1?"
    exit 0
}

get_input() {
    # $1 - Main/Backup/Federated
    # $2 - star (y/n)
    # $3 - encr (y/n)
    # $4 - auth (y/n)
    # $5 - gui/container

    echo -e "\n--- $1 Container ---"

    echo -n "Platform name: "
    read name
    echo -n  "Container name: "
    read container_name
    echo -n  "Host: "
    read host
    echo -n  "Port: "
    read port
    echo -n  "Local host: "
    read local_host
    echo -n  "Local port: "
    read local_port

    command="java"
    if [ "$4" == "y" ]; then  # encr
        echo -n "Keystore name: "
        read keystore
        if [ -z "$keystore" ]; then
            problem "keystore"
        fi
        echo -n "Keystore password: "
        read password
        if [ -z "$password" ]; then
            problem "password"
        fi
        echo -n "Keystore2 name: "
        read keystore2
        if [ -z "$keystore2" ]; then
            problem "keystore2"
        fi

        # Generate pair of keys
        keytool -genkeypair -keystore "$keystore".jks -alias "$keystore"
        # Export public key
        keytool -export -keystore "$keystore".jks -alias "$keystore" -file "$keystore".cer
        # Import public key
        keytool -import -file "$keystore".cer -alias "$keystore" -keystore "$keystore2"-ca.jks

        command="$command -Djavax.net.ssl.keyStore=${keystore}.jks\
        -Djavax.net.ssl.keyStorePassword=${password}\
        -Djavax.net.ssl.trustStore=${keystore}-ca.jks"
    fi
    command="$command -cp jade.jar jade.Boot -$5"
    if [ -n "$name" ]; then
        command="$command -name $name"
    fi
    if [ -n "$container_name" ]; then
        command="$command -container-name $container_name"
    fi
    if [ -n "$host" ]; then
        command="$command -host $host"
    fi
    if [ -n "$port" ]; then
        command="$command -port $port"
    fi
    if [ -n "$local_host" ]; then
        command="$command -local-host $local_host"
    fi
    if [ -n "$local_port" ]; then
        command="$command -local-port $local_port"
    fi
    if [ "$2" == "y" ]; then  # star
        command="$command -services"
        if [ "$1" == "Main" ]; then
            command="$command jade.core.replication.MainReplicationService\;\
            jade.core.replication.AddressNotificationService"
        elif [ "$1" == "Backup" ]; then
            command="$command jade.core.replication.MainReplicationService\;\
            jade.core.replication.AddressNotificationService"
        elif [ "$1" == "Federated" ]; then
            command="$command jade.core.replication.AddressNotificationService"
        fi
    fi
    if [ "$3" == "y" ]; then  # auth
        command="$command -nomtp -icps jade.imtp.leap.JICP.JICPSPeer"
    fi
}

start_jade() {
    type="$1"
    star="$2"
    encr="$3"
    auth="$4"

    if [ -z "$type" ]; then        # all
        get_input "Main" "$star" "$encr" "$auth" "gui"
        command_gui=$command
        if [ "$star" == "y" ]; then
            get_input "Backup" "$star" "$encr" "$auth" "container"
            command_backup=$command
        fi
        get_input "Federated" "$star" "$encr" "$auth" "container"
        command_container=$command

        gnome-terminal -- bash -c "$command_gui; exec bash"
        if [ "$star" == "y" ]; then
            gnome-terminal -- bash -c "$command_backup; exec bash"
        fi
        gnome-terminal -- bash -c "$command_container; exec bash"
    
    elif [ "$type" == "0" ]; then  # main
        get_input "Main" "$star" "$encr" "$auth" "gui"
        command_gui=$command

        gnome-terminal -- bash -c "$command_gui; exec bash"
    
    elif [ "$type" == "1" ]; then  # backup
        if [ "$star" == "y" ]; then
            get_input "Backup" "$star" "$encr" "$auth" "backupmain"
            command_backup=$command

            gnome-terminal -- bash -c "$command_backup; exec bash"
        else
            echo "No star topology, no backup"
            exit 1
        fi
    
    elif [ "$type" == "2" ]; then  # federated
        get_input "Federated" "$star" "$encr" "$auth" "container"
        command_container=$command

        gnome-terminal -- bash -c "$command_container; exec bash"
    fi
}

# Main
if [ -n "$1" ] && [ "$1" -gt 2 ]; then
    echo "Unknown argument (none/0/1/2)"
    exit 1
fi

echo -n "Star topology (y/n): "
read star
if [ -z "$star" ]; then
    star="n"
fi
echo -n "Encryption (y/n): "
read encr
if [ -z "$encr" ]; then
    encr="n"
fi
echo -n "Authentication (y/n): "
read auth
if [ -z "$auth" ]; then
    auth="n"
fi

start_jade "$1" "$star" "$encr" "$auth"

echo -e "\nElo Żelo"
exit 0
