#!/bin/bash

function diskfree() {
    while true
    do
        echo "==================================================================="
        df -h
        echo "-------------------------------------------------------------------"
        du -sh /workdir/openwrt/* |sort -h |tail -n 8
        echo "==================================================================="
        sleep 100
    done
}


function progress() {
    local _pct
    local _debut
    _debut=true
    while true
    do
        if [ -f $1 ];then
            if [ $_debut ];then
                cat $1  2>/dev/null |tr '\r' '\n' | head -n 3
                _debut=false
            fi
            _pct=$(cat $1  |tr '\r' '\n' | tail -n 1 |awk '{print $1}')
        fi
        sleep 5
        cat $1  2>/dev/null |tr '\r' '\n' | tail -n 1 |awk '{if ($1 > '${_pct:-0}') print $0}'
    done
}


if [ "$1" == "df" ]; then
    diskfree
    elif [ "$1" == "progress" ]; then
    progress $2
else
    echo "nothing to do!"
fi
