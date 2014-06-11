#!/bin/bash
export BOOTCLASSPATH="am.jar:android.policy.jar:android.test.runner.jar:apache-xml.jar:bmgr.jar:bouncycastle.jar:bu.jar:com.android.location.provider.jar:com.google.android.maps.jar:com.google.android.media.effects.jar:com.google.widevine.software.drm.jar:com.motorola.android.addressingwidget.jar:com.motorola.android.camera.jar:com.motorola.android.customization.jar:com.motorola.android.drm1.jar:com.motorola.android.encryption.jar:com.motorola.android.frameworks.jar:com.motorola.android.settings.shared.jar:com.motorola.android.storage.jar:com.motorola.android.telephony.jar:com.motorola.android.widget.jar:com.motorola.android.xmp.jar:com.motorola.app.admin.jar:com.motorola.app.epm.jar:com.motorola.atcmd.base.jar:com.motorola.atcmd.pluginMgr.jar:com.motorola.blur.library.app.service.jar:com.motorola.blur.library.apputils.jar:com.motorola.blur.library.friendfeed.jar:com.motorola.blur.library.home.jar:com.motorola.blur.library.mother.service.jar:com.motorola.blur.library.serviceutils.jar:com.motorola.calendarcommon.jar:com.motorola.contextual.location.ils.jar:com.motorola.frameworks.core.addon.jar:com.motorola.frameworks.core.checkin.jar:com.motorola.MCDownloadLibrary.services_lib.jar:com.motorola.motosignature.jar:com.motorola.vpn.ext.jar:com.scalado.android.photoeditor.jar:com.scalado.caps.jar:com.softwareimaging.mot.jar:core.jar:core-junit.jar:ext.jar:filterfw.jar:framework-ext.jar:framework.jar:ime.jar:input.jar:javax.obex.jar:jcifs-1.3.16.jar:monkey.jar:pm.jar:services.jar:svc.jar"

# Deodex function.
ddex() {
	echo -e $(tput setaf 2)$(tput bold)\(*\) $(tput setaf 7)Beginning framework deodex. $(tput sgr 0)

	cd ./odex
	mkdir ../dex >> ../system.log 2>&1
	for od in *.jar
	do
		echo -e $(tput setaf 2)$(tput bold)\(D\) $(tput setaf 7) Deodex $od. $(tput sgr 0)
		if [ -e `basename $od .jar`.odex ]
		then
			java -Xmx1G -jar ../supl/baksmali-*.jar -a 14 -d . -x `basename $od .jar`.odex >> tmp.log 2>&1
			java -Xmx1G -jar ../supl/smali-*.jar out -a 14 -o classes.dex >> tmp.log 2>&1
			RESULT=$(grep 'EXCEPTION' tmp.log)
			if [ -z "$RESULT" ]
			then
				echo -e $(tput setaf 6)$(tput bold)\(-\) $(tput setaf 7) Merge classes.dex with jar. $(tput sgr 0)
				zip -g $od classes.dex >> tmp.log 2>&1
				cp $od ../dex/ >> tmp.log 2>&1
			else
				echo -e $(tput setaf 1)$(tput bold)\(\!\) $(tput setaf 7) Deodex failed on $od. Error Logged. $(tput sgr 0)
			fi
			
			cat tmp.log >> ../system.log
			rm -rf classes.dex out tmp.log >> ../system.log 2>&1
		else
			echo -e $(tput setaf 5)$(tput bold)\(?\) $(tput setaf 7) No odex for file $od. Skipping. $(tput sgr 0)
		fi
	done
	echo -e $(tput setaf 2)$(tput bold)\(*\) $(tput setaf 7)Beginning apk deodex. $(tput sgr 0)
	for od in *.apk
	do
		if [ -e `basename $od .apk`.odex ]
		then
			echo -e $(tput setaf 2)$(tput bold)\(D\) $(tput setaf 7) Deodex $od. $(tput sgr 0)
			java -Xmx1G -jar ../supl/baksmali-*.jar -a 14 -d . -x `basename $od .apk`.odex >> tmp.log 2>&1
			java -Xmx1G -jar ../supl/smali-*.jar out -a 14 -o classes.dex >> tmp.log 2>&1
			RESULT=`grep 'EXCEPTION' tmp.log`
			if [ -z "$RESULT" ]
			then
				echo -e $(tput setaf 6)$(tput bold)\(-\) $(tput setaf 7) Merge classes.dex with apk. $(tput sgr 0)
				zip -g $od classes.dex >> tmp.log 2>&1
				echo -e $(tput setaf 6)$(tput bold)\(-\) $(tput setaf 7) Zipalign $od. $(tput sgr 0)
				zipalign -v 4 $od >> tmp.log 2>&1
				cp $od ../dex/ >> tmp.log 2>&1
			else
				echo -e $(tput setaf 1)$(tput bold)\(\!\) $(tput setaf 1) Deodex failed on $od. Error Logged. $(tput sgr 0)
			fi

			cat tmp.log >> ../system.log
			rm -rf classes.dex out tmp.log >> ../system.log 2>&1
		else
			echo -e $(tput setaf 5)$(tput bold)\(?\) $(tput setaf 7) No odex for file $od. Skipping. $(tput sgr 0)
		fi
	done
	cd ..
	return $TRUE
}

ddex

echo $(tput setaf 2)$(tput bold)\(\~\) Done with deodex.$(tput sgr 0)
