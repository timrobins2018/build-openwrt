#!/bin/bash

while true
do
    df -h
    du -sh /workdir/openwrt/*
    sleep 60
    echo "==================================================================="
done
