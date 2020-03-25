#!/bin/sh
#
# $0 <external_addr> <listen_addr> <base_port>
#
# If external_addr is "NONE", then don't force an external addr and just use -i 0.0.0.0
# If external_addr isn't "NONE", then specify the external addr in the server.conf using -ip a.b.c.d
#
# Special case, if external_addr is "AWS" then, at run time, it will be identified dynamically and
# coded into the server.conf before starting Ghidra up.
#
# It is recommended that you instead use a DNS name and specify that, however.
#

external_addr="$1"
listen_addr="$2"
base_port="$3"

echo "wrapper.app.parameter.1=-a0" >> /ghidra_9.1.2_PUBLIC/server/server.conf
echo "wrapper.app.parameter.2=-u" >> /ghidra_9.1.2_PUBLIC/server/server.conf

if [[ "${external_addr}" != "NONE" ]]; then
  echo "wrapper.app.parameter.3=-ip ${external_addr}" >> /ghidra_9.1.2_PUBLIC/server/server.conf
  echo "wrapper.app.parameter.4=-i ${listen_addr}" >> /ghidra_9.1.2_PUBLIC/server/server.conf
  echo "wrapper.app.parameter.5=-p${base_port}" >> /ghidra_9.1.2_PUBLIC/server/server.conf
  echo "wrapper.app.parameter.6=\${ghidra.repositories.dir}" >> /ghidra_9.1.2_PUBLIC/server/server.conf
else
  echo "wrapper.app.parameter.3=-i ${listen_addr}" >> /ghidra_9.1.2_PUBLIC/server/server.conf
  echo "wrapper.app.parameter.4=-p${base_port}" >> /ghidra_9.1.2_PUBLIC/server/server.conf
  echo "wrapper.app.parameter.5=\${ghidra.repositories.dir}" >> /ghidra_9.1.2_PUBLIC/server/server.conf
fi
