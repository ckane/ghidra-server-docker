# Derive this from Alpine Linux, micro distribution
FROM alpine:3.11.3

# Need the JRE as well as the JDK
RUN apk add --no-cache openjdk11
RUN apk add --no-cache curl
RUN apk add --no-cache unzip
RUN apk add --no-cache bash

# Set workdir initially to /
WORKDIR /

# Create empty repositories directory
RUN mkdir -p /repositories

# Fetch the latest Ghidra distribution
RUN curl -O https://ghidra-sre.org/ghidra_9.1.2_PUBLIC_20200212.zip

# Unpack it
RUN unzip ghidra_9.1.2_PUBLIC_20200212.zip

# Remove archive to save space
RUN rm ghidra_9.1.2_PUBLIC_20200212.zip

# Install base server.conf and update it with config params
ARG listen_addr=0.0.0.0
ARG external_addr=NONE
ARG base_port=13100
COPY server.conf /ghidra_9.1.2_PUBLIC/server/server.conf
COPY upd_server_conf.sh /
RUN /bin/sh /upd_server_conf.sh "${external_addr}" "${listen_addr}" "${base_port}"
RUN rm /upd_server_conf.sh

# Set the workdir to where we will run from
WORKDIR /ghidra_9.1.2_PUBLIC/server

# Create initial user accounts (passwords all changeme)
ARG create_users=
COPY create_users.sh /create_users.sh
RUN /bin/sh /create_users.sh "${create_users}"
RUN rm /create_users.sh

# Install the bootstrap script
COPY run-ghidra.sh /run-ghidra.sh
CMD /bin/sh /run-ghidra.sh
