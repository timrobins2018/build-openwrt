#!/bin/bash

while true
do
    df -h
    du -sh /workdir/openwrt/* |sort -h
    sleep 60
    echo "==================================================================="
done
