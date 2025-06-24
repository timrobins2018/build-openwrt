#!/bin/bash

function diskfree() {
    while true
    do
        echo "==================================================================="
        df -h
        echo "-------------------------------------------------------------------"
        du -sh $GITHUB_WORKSPACE/* |sort -h |tail -n 8
        echo "==================================================================="
        sleep 100
    done
}


function progress() {
    local _pct
    local _debug
    local _rowcnt
    _debug=true
    while true
    do
        if [ -f $1 ];then
            _pct=$(cat $1  |tr '\r' '\n' | tail -n 1 |awk '{print $1}')
            _rowcnt=$(cat $1 |tr '\r' '\n'|wc -l)
            if [ "$_debug" == "true" -a "$_rowcnt" -ge "3" ];then
                cat $1  2>/dev/null |tr '\r' '\n' | head -n 3
                _debug=false
            fi
            sleep 1
            if [ "$_debug" == "false" ];then
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
