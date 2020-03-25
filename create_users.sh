#!/bin/sh
users_list="$1"

# Instead of running Ghidra to pre-populate the repositories folder, we
# manually populate the data files that will need to exist for svrAdmin
touch /repositories/server.log
touch /repositories/users
mkdir -p /repositories/\~admin
mkdir -p /repositories/\~ssh

# If no users, then do nothing
if [[ "${users_list}" = "" ]]; then
  echo No users
  exit 0
fi

# Users are a list of usernames separated by comma
IFS=","
for user in ${users_list}; do
  echo Creating account for ${user}...
  ./svrAdmin -add "${user}"
done
