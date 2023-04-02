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
    local _rowcnt
    _debut=true
    while true
    do
        if [ -f $1 ];then
            _pct=$(cat $1  |tr '\r' '\n' | tail -n 1 |awk '{print $1}')
            _rowcnt=$(cat $1 |tr '\r' '\n'|wc -l)
            echo $_rowcnt
            if [ "$_debut" == "true" -a "$_rowcnt" -ge "3" ];then
                cat $1  2>/dev/null |tr '\r' '\n' | head -n 3
                _debut=false
            fi
            sleep 5
            if [ "$_debut" == "false" ];then
                cat $1  2>/dev/null |tr '\r' '\n' | tail -n 1 |awk '{if ($1 > '${_pct:-0}') print $0}'
            fi
        fi
    done
}


if [ "$1" == "df" ]; then
    diskfree
    elif [ "$1" == "progress" ]; then
    progress $2
else
    echo "nothing to do!"
fi
