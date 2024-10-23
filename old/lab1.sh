#!/bin/bash
# Blah blah lab 1 script
used_ports=()   # array of used ports

get_input() {
    # $1 - Main/Federated
    # $2 - gui/container
    # $3 - name
    # $4 - host
    # $5 - port

    echo -e "\n--- $1 Container ---"

    read -p "Container name: " container_name
    read -p "Local host: " local_host
    read -p "Local port: " local_port

    command="java -cp jade.jar jade.Boot -$2"
    if [ -n "$3" ]; then
        command="$command -name $3"
    fi
    if [ -n "$4" ]; then
        command="$command -host $4"
    fi
    if [ -n "$5" ]; then
        command="$command -port $5"
        base_port="$5"
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
}

start_jade() {
    mode="$1"
    name="$2"
    host="$3"
    port="$4"

    if [ -z "$mode" ]; then         # all
        get_input "Main" "gui" "$name" "$host" "$port"
        command_gui="$command"
        get_input "Federated" "container" "$name" "$host" "$port"
        command_container="$command"

        gnome-terminal -- bash -c "$command_gui; exec bash"
        gnome-terminal -- bash -c "$command_container; exec bash"
    
    elif [ "$mode" == "0" ]; then   # main
        get_input "Main" "gui" "$name" "$host" "$port"
        command_gui="$command"

        gnome-terminal -- bash -c "$command_gui; exec bash"
    
    elif [ "$mode" == "1" ]; then   # federated
        get_input "Federated" "container" "$name" "$host" "$port"
        command_container="$command"

        gnome-terminal -- bash -c "$command_container; exec bash"
    fi
}

main() {
    if [ -n "$1" ] && [ "$1" -gt 1 ]; then
        echo "Unknown argument (none/0/1)"
        exit 1
    fi

    read -p "Platform name: " name
    read -p "Host: " host
    read -p "Port: " port

    start_jade "$1" "$name" "$host" "$port"
}

main "$1"
echo -e "\nElo Żelo"
exit 0