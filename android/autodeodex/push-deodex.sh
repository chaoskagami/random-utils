#!/bin/bash
cd dex

adb shell su -c 'mount -o remount,rw /system'

echo $(tput setaf 2)$(tput bold)\(I\) $(tput setaf 7)Installing freshly deodexed files...$(tput sgr 0)

# Push deodexed goods to system.

for file in *.jar; do
	echo -e $(tput bold)$(tput setaf 2)\(*\) Install framework $file.$(tput sgr 0)
	adb push $file /data/tmp/
	echo -e cp /data/tmp/$file /system/framework/ >> scp.sh
done

echo $(tput setaf 2)$(tput bold)\(+\) $(tput setaf 7)Cleaning up framwork odex.$(tput sgr 0)
for file in *.apk; do
	echo -e $(tput bold)$(tput setaf 2)\(*\) Install framework $file.$(tput sgr 0)
	adb push $file /data/tmp/
	echo -e cp /data/tmp/$file /system/app/ >> scp.sh
done

adb push scp.sh /data/tmp/

# Flush cache.
adb shell su -c 'rm -rf /data/dalvik-cache/*'
# Install deodexed.
adb shell su -c 'cd /data/tmp && sh scp.sh'

echo $(tput setaf 2)$(tput bold)\(+\) $(tput setaf 7)Cleaning up app odex.$(tput sgr 0)

# Clean up remnants.
adb shell su -c 'rm /system/app/*.odex && rm /system/framework/*.odex'

adb shell  su -c 'mount -o remount,ro /system'

cd ..

