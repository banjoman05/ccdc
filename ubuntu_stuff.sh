#!/bin/bash

# Backup the old repo lists
/bin/mv /etc/apt/sources.list /etc/apt/sources.list.old

# Create new repo lists with archived location
echo "deb http://old-releases.ubuntu.com/ubuntu/ hardy main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://old-releases.ubuntu.com/ubuntu/ hardy-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://old-releases.ubuntu.com/ubuntu/ hardy-security main restricted universe multiverse" >> /etc/apt/sources.list
