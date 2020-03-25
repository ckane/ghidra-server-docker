#!/bin/bash

if grep -q AWS server.conf; then
    if curl "http://checkip.amazonaws.com" > /dev/null; then
      curl "http://checkip.amazonaws.com" > /dev/stderr
      aws_ext_ip=`curl "http://checkip.amazonaws.com"`
      sed -i "s/AWS/${aws_ext_ip}/" ./server.conf
    else
      echo "Couldn't resolve AWS IP address" > /dev/stderr
      exit 1
    fi
fi

# Create initial /repositories layout
touch /repositories/server.log
touch /repositories/users
mkdir -p /repositories/\~admin
mkdir -p /repositories/\~ssh

exec ./ghidraSvr console
