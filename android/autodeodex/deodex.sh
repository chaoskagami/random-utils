#!/bin/bash

# Remove previous.
rm -rf dex odex >> tmp.log 2>&1

echo -e $(tput setaf 2)$(tput bold)\(*\) $(tput setaf 7)Fetching /system/app and /system/framework. $(tput sgr 0)

bash pull-deodex.sh

echo -e $(tput setaf 2)$(tput bold)\(*\) $(tput setaf 7)Beginning deodex of framework and app dirs. $(tput sgr 0)

bash perf-deodex.sh

echo -e $(tput setaf 2)$(tput bold)\(*\) $(tput setaf 7)Installing deodexed files. $(tput sgr 0)

bash push-deodex.sh