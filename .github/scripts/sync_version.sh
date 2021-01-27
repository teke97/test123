#!/bin/bash

if [[ ! -d ios ]]
then
	echo 'Ensure you are in root of project'
	exit 1
fi

CURRENT_VERSION=`grep '^version: [0-9]*\.[0-9]*\.[0-9]*+[0-9]*' ./pubspec.yaml | grep -o '[0-9]*\.[0-9]*\.[0-9]*+[0-9]*'`

CURRENT_VERSION_NUMBER=`cut -d'+' -f1 <<< ${CURRENT_VERSION}`
CURRENT_BUILD_NUMBER=`cut -d'+' -f2 <<< ${CURRENT_VERSION}`

sed -i '' "s/CURRENT_PROJECT_VERSION *=.*/CURRENT_PROJECT_VERSION = ${CURRENT_BUILD_NUMBER};/" ios/Runner.xcodeproj/project.pbxproj
.github/scripts/sync_version_plist.sh ${CURRENT_VERSION_NUMBER} ${CURRENT_BUILD_NUMBER}

echo -e  '<?xml version="1.0" encoding="UTF-8"?>\n<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' | cat - ios/Runner/Info.plist > ios/Runner/Info.plist.temp && mv ios/Runner/Info.plist.temp ios/Runner/Info.plist
