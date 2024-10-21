#!/bin/bash
# This scripts starts a JADE platform main container with gui
# To start a federated container instead, change the command variable

name=$1
container_name=$2
host=$3
port=$4
local_host=$5
local_port=$6
command="java -cp jade.jar jade.Boot -gui"
# command="java -cp jade.jar jade.Boot -container"

if [ $# -eq 0 ]; then
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
fi

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

$command
read
