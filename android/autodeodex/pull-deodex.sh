#!/bin/bash

adb wait-for-device

mkdir odex >> system.log 2>&1
cd odex

echo -e $(tput setaf 2)$(tput bold)\(*\) $(tput setaf 7)Pulling odexed /system/app. $(tput sgr 0)

adb pull /system/app >> ../system.log 2>&1

echo -e $(tput setaf 2)$(tput bold)\(*\) $(tput setaf 7)Pulling odexed /system/framework. $(tput sgr 0)

adb pull /system/framework >> ../system.log 2>&1

cd ..
