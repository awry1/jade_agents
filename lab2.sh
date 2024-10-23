#!/bin/bash
# Blah blah lab 2 script
used_ports=()   # array of used ports
keypassword="123456"

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
    # $5 - gui/backupmain/container
    # $6 - name
    # $7 - host
    # $8 - port

    echo -e "\n--- $1 Container ---"

    read -p "Container name: " container_name
    read -p "Local host: " local_host
    read -p "Local port: " local_port

    command="java"
    if [ "$4" == "y" ]; then  # auth
        if [ "$1" == "Main" ]; then
            keystore="main"
        elif [ "$1" == "Backup" ]; then
            keystore="backup"
        elif [ "$1" == "Federated" ]; then
            keystore="federated"
        fi
        command="$command -Djavax.net.ssl.keyStore=${keystore}.jks"
        command="$command -Djavax.net.ssl.keyStorePassword=${keypassword}"
        command="$command -Djavax.net.ssl.trustStore=${keystore}-ca.jks"
    fi
    command="$command -cp jade.jar jade.Boot -$5"
    if [ -n "$6" ]; then
        command="$command -name $6"
    fi
    if [ -n "$7" ]; then
        command="$command -host $7"
    fi
    if [ -n "$8" ]; then
        command="$command -port $8"
        base_port="$8"
    else
        base_port=1099
    fi
    if [ -n "$container_name" ]; then
        command="$command -container-name $container_name"
    fi
    if [ -n "$local_host" ]; then
        command="$command -local-host $local_host"
    fi
    if [ -n "$local_port" ]; then
        command="$command -local-port $local_port"
        used_ports+=("$local_port")
        base_port=$((local_port+1))
    else
        while [[ " ${used_ports[@]} " =~ " ${base_port} " ]]; do
            base_port=$((base_port+1))
        done
        command="$command -local-port $base_port"
        used_ports+=("$base_port")
        base_port=$((base_port+1))
    fi
    if [ "$2" == "y" ]; then  # star
        command="$command -services"
        if [ "$1" == "Main" ]; then
            command="$command jade.core.replication.MainReplicationService\;"
            command="$command jade.core.replication.AddressNotificationService"
        elif [ "$1" == "Backup" ]; then
            command="$command jade.core.replication.MainReplicationService\;"
            command="$command jade.core.replication.AddressNotificationService"
        elif [ "$1" == "Federated" ]; then
            command="$command jade.core.replication.AddressNotificationService"
        fi
    fi
    if [ "$3" == "y" ]; then  # encr
        command="$command -nomtp -icps jade.imtp.leap.JICP.JICPSPeer"
    fi
}

start_jade() {
    mode="$1"
    star="$2"
    encr="$3"
    auth="$4"
    name="$5"
    host="$6"
    port="$7"

    if [ -z "$mode" ]; then        # all
        get_input "Main" "$star" "$encr" "$auth" "gui" "$name" "$host" "$port"
        command_gui="$command"
        if [ "$star" == "y" ]; then
            get_input "Backup" "$star" "$encr" "$auth" "backupmain" "$name" "$host" "$port"
            command_backup="$command"
        fi
        get_input "Federated" "$star" "$encr" "$auth" "container" "$name" "$host" "$port"
        command_container="$command"

        loop_var=(main backup federated)
        # Loop through all containers and generate keystore and truststore for each
        for i in "${loop_var[@]}"; do
            if [ "$star" == "n" ] && [ "$i" == "backup" ]; then
                continue
            fi
            # Generate keystore
            echo -e "\nGenerating keystore for $i"
            keytool -genkeypair -keystore "${i}.jks" -alias "${i}" -storepass "$keypassword" -keypass "$keypassword" -keyalg RSA -dname "CN=., OU=., O=., L=., ST=., C=."  > /dev/null 2>&1 # -keysize 2048 -validity 365
            # Export public key
            echo -e "\nExporting public key for $i"
            keytool -export -keystore "${i}.jks" -alias "${i}" -file "${i}.cer" -storepass "$keypassword" > /dev/null 2>&1
            # Import public key
            echo -e "\nImporting public key for $i"
            keytool -import -file "${i}.cer" -alias "${i}" -keystore "${i}-ca.jks" -storepass "$keypassword" -noprompt > /dev/null 2>&1
        done

        # echo "Starting containers"
        # echo "$command_gui"
        # echo "$command_backup"
        # echo "$command_container"

        gnome-terminal -- bash -c "$command_gui; exec bash"
        if [ "$star" == "y" ]; then
            gnome-terminal -- bash -c "$command_backup; exec bash"
        fi
        gnome-terminal -- bash -c "$command_container; exec bash"
    
    elif [ "$mode" == "0" ]; then  # main
        get_input "Main" "$star" "$encr" "$auth" "gui" "$name" "$host" "$port"
        command_gui="$command"

        # Generate keystore
        echo -e "\nGenerating keystore for main"
        keytool -genkeypair -keystore "main.jks" -alias "main" -storepass "$keypassword" -keypass "$keypassword" -keyalg RSA -dname "CN=., OU=., O=., L=., ST=., C=."  > /dev/null 2>&1 # -keysize 2048 -validity 365
        # Export public key
        echo -e "\nExporting public key for main"
        keytool -export -keystore "main.jks" -alias "main" -file "main.cer" -storepass "$keypassword" > dev/null 2>&1
        # Import public key
        echo -e "\nImporting public key for main"
        keytool -import -file "main.cer" -alias "main" -keystore "main-ca.jks" -storepass "$keypassword" -noprompt > /dev/null 2>&1

        gnome-terminal -- bash -c "$command_gui; exec bash"
    
    elif [ "$mode" == "1" ]; then  # backup
        if [ "$star" == "y" ]; then
            get_input "Backup" "$star" "$encr" "$auth" "backupmain" "$name" "$host" "$port"
            command_backup="$command"

            # Generate keystore
            echo -e "\nGenerating keystore for backup"
            keytool -genkeypair -keystore "backup.jks" -alias "backup" -storepass "$keypassword" -keypass "$keypassword" -keyalg RSA -dname "CN=., OU=., O=., L=., ST=., C=."  > /dev/null 2>&1 # -keysize 2048 -validity 365
            # Export public key
            echo -e "\nExporting public key for backup"
            keytool -export -keystore "backup.jks" -alias "backup" -file "backup.cer" -storepass "$keypassword" > dev/null 2>&1
            # Import public key
            echo -e "\nImporting public key for backup"
            keytool -import -file "backup.cer" -alias "backup" -keystore "backup-ca.jks" -storepass "$keypassword" -noprompt > /dev/null 2>&1

            gnome-terminal -- bash -c "$command_backup; exec bash"
        else
            echo "No star topology, no backup"
            exit 1
        fi
    
    elif [ "$mode" == "2" ]; then  # federated
        get_input "Federated" "$star" "$encr" "$auth" "container" "$name" "$host" "$port"
        command_container="$command"

        # Generate keystore
        echo -e "\nGenerating keystore for federated"
        keytool -genkeypair -keystore "federated.jks" -alias "federated" -storepass "$keypassword" -keypass "$keypassword" -keyalg RSA -dname "CN=., OU=., O=., L=., ST=., C=."  > /dev/null 2>&1 # -keysize 2048 -validity 365
        # Export public key
        echo -e "\nExporting public key for federated"
        keytool -export -keystore "federated.jks" -alias "federated" -file "federated.cer" -storepass "$keypassword" > dev/null 2>&1
        # Import public key
        echo -e "\nImporting public key for federated"
        keytool -import -file "federated.cer" -alias "federated" -keystore "federated-ca.jks" -storepass "$keypassword" -noprompt > /dev/null 2>&1

        gnome-terminal -- bash -c "$command_container; exec bash"
    fi
}

main() {
    if [ -n "$1" ] && [ "$1" -gt 2 ]; then
        echo "Unknown argument (none/0/1/2)"
        exit 1
    fi

    read -p "Platform name: " name
    read -p "Host: " host
    read -p "Port: " port
    read -p "Star topology (y/n): " star
    if [ -z "$star" ]; then
        star="n"
        echo -e "\033[1A\033[2K\rStar topology (y/n): n"    # Such wow, much magic
    fi
    read -p "Encryption (y/n): " encr
    if [ -z "$encr" ]; then
        encr="n"
        echo -e "\033[1A\033[2K\rEncryption (y/n): n"
    fi
    read -p "Authentication (y/n): " auth
    if [ -z "$auth" ]; then
        auth="n"
        echo -e "\033[1A\033[2K\rAuthentication (y/n): n"
    fi

    start_jade "$1" "$star" "$encr" "$auth" "$name" "$host" "$port"
}

main "$1"
echo -e "\nElo Żelo"
exit 0