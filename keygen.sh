#!/bin/bash
if [ $# -lt 1 ]; then
    echo "Usage: $0 <keystore name>"
    exit 1
fi

name="$1"
keypassword="123456"

echo "Generating keystore for $name"
keytool -genkeypair -keystore "$name.jks" -alias "$name" -storepass "$keypassword" -keypass "$keypassword" -keyalg RSA -keysize 2048 -validity 365 -dname "CN=., OU=., O=., L=., ST=., C=."  > /dev/null 2>&1
echo "Exporting public key for $name"
keytool -export -keystore "$name.jks" -alias "$name" -file "$name.cer" -storepass "$keypassword" > /dev/null 2>&1
exit 0
