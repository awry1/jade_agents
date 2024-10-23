#!/bin/bash
if [ $# -lt 2 ]; then
    echo "Usage: $0 <keystore name> <key1> <key2> ..."
    exit 1
fi

name="$1"
keypassword="123456"

echo "Importing public keys for $name"
for ((i=2; i<=$#; i++)); do
    cer_file="${!i}.cer"
    if [ -f "$cer_file" ]; then
        echo "Importing $cer_file to ${name}-ca.jks"
        keytool -import -file "$cer_file" -alias "${!i}" -keystore "${name}-ca.jks" -storepass "$keypassword" -noprompt > /dev/null 2>&1
    else
        echo "File $cer_file not found"
    fi
done
exit 0
