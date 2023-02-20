#!/bin/bash

declare ver
declare target
declare chip
declare model

ver=$(grep 'DESTVER=' $1 | cut -d = -f 2)

target=$(grep '^CONFIG_TARGET.*DEVICE.*=y' $1 | sed -r 's/.*DEVICE_(.*)=y/\1/')

chip=$(grep '^CONFIG_TARGET.*DEVICE.*=y' $1 | cut -d _ -f 3)

model=$(grep '^CONFIG_TARGET.*DEVICE.*=y' $1 | cut -d _ -f 4)

if [ "$target" == "generic" ]; then
    if [ "$model" == "generic" ]; then
        target="x86"
    else
        target="x64"
    fi
fi

echo "TARGET=$target"

echo "TARGET=$target" >> $GITHUB_ENV

echo "ZIPNAME=openwrt-$chip-$model-$target-v${ver}.zip" >> $GITHUB_ENV

if [ "$ver" == "" ]; then
    echo -en "\e[1;49;91m wrong ver !!! \n\e[0m"
    exit 1
fi

if [ "$target" == "" ]; then
    echo -en "\e[1;49;91m wrong target !!! \n\e[0m"
    exit 1
fi

if [ "${#chip}" == "0" ] || [ "${#model}" == "0" ]; then
    echo -en "\e[1;49;91m wrong chipmodel !!! \e[0m"
    exit 1
fi

# vermagicUrl="https://downloads.openwrt.org/releases/$ver/targets/$chip/$model/packages/Packages.gz"

# echo "vermagicUrl=$vermagicUrl"

# wget ${vermagicUrl}

# zgrep -m 1 "Depends: kernel (=.*)$" Packages.gz | sed -e 's/.*-\(.*\))/\1/' >stock_vermagic && rm Packages.gz

# sed -i "s/grep '=\[ym\]' \$(LINUX_DIR)\/.config.set | LC_ALL=C sort | \$(MKHASH) md5 > \$(LINUX_DIR)\/.vermagic/cp \$(TOPDIR)\/stock_vermagic \$(LINUX_DIR)\/.vermagic/g" ./include/kernel-defaults.mk
