#!/bin/bash -x


check_not_empty() {
  if [ -z "$2" ]
  then
        echo "\$$1 is empty"
	exit 1
  else
        echo "\$$1 is $2"
  fi
}


check_equal(){
	if [ $2 -ne $3 ]
	then
		echo $1 current value $2 is not equal to $3 
		exit 2
	fi
}


TARGET_VERSION_NUMBER=`.github/scripts/print_version_ios.py`

check_not_empty TARGET_VERSION_NUMBER "${TARGET_VERSION_NUMBER}"


TARGET_BUILD_NUMBER_ARRAY=`grep -o 'CURRENT_PROJECT_VERSION *= *[^;]*' ios/Runner.xcodeproj/project.pbxproj | sed -e 's/[^0-9]*\([0-9]*\).*/\1/'`
if [ `echo "${TARGET_BUILD_NUMBER_ARRAY}" | wc -l` -ne 6 ]
then
	echo TARGET_BUILD_NUMBER_ARRAY is not equal 6, CURRENT_PROJECT_VERSION should be mentioned 6 times in ios/Runner.xcodeproj/project.pbxproj
	exit 3
fi
TARGET_BUILD_NUMBER=`echo "${TARGET_BUILD_NUMBER_ARRAY}" | head -n1`
while IFS= read -r line; do
    if [ "$line" -ne "$TARGET_BUILD_NUMBER" ]
    then
            echo TARGET_BUILD_NUMBER_ARRAY contain different versions, check CURRENT_PROJECT_VERSION in ios/Runner.xcodeproj/project.pbxproj are the same
            exit 4
    fi
done <<< "$TARGET_BUILD_NUMBER_ARRAY"

check_not_empty TARGET_BUILD_NUMBER "${TARGET_BUILD_NUMBER}"

if [ `.github/scripts/print_build_number_ios.py` -ne $TARGET_BUILD_NUMBER ]
then
	echo TARGET_BUILD_NUMBER $TARGET_BUILD_NUMBER is not equal in ios/Runner.xcodeproj/project.pbxproj and ios/Runner/Info.plist
	exit 5
fi

TARGET_VERSION_MAJOR=`cut -d'.' -f1 <<< ${TARGET_VERSION_NUMBER}`
TARGET_VERSION_MINOR=`cut -d'.' -f2 <<< ${TARGET_VERSION_NUMBER}`
TARGET_VERSION_PATCH=`cut -d'.' -f3 <<< ${TARGET_VERSION_NUMBER}`

check_not_empty TARGET_VERSION_MAJOR "${TARGET_VERSION_MAJOR}"
check_not_empty TARGET_VERSION_MINOR "${TARGET_VERSION_MINOR}"
check_not_empty TARGET_VERSION_PATCH "${TARGET_VERSION_PATCH}"

CURRENT_VERSION=`grep '^version: [0-9]*\.[0-9]*\.[0-9]*+[0-9]*' ./pubspec.yaml | grep -o '[0-9]*\.[0-9]*\.[0-9]*+[0-9]*'`

check_not_empty CURRENT_VERSION "${CURRENT_VERSION}"

CURRENT_VERSION_NUMBER=`cut -d'+' -f1 <<< ${CURRENT_VERSION}`
CURRENT_BUILD_NUMBER=`cut -d'+' -f2 <<< ${CURRENT_VERSION}`

check_not_empty CURRENT_BUILD_NUMBER "${CURRENT_BUILD_NUMBER}"
check_not_empty CURRENT_VERSION_NUMBER "${CURRENT_VERSION_NUMBER}"

CURRENT_VERSION_MAJOR=`cut -d'.' -f1 <<< ${CURRENT_VERSION_NUMBER}`
CURRENT_VERSION_MINOR=`cut -d'.' -f2 <<< ${CURRENT_VERSION_NUMBER}`
CURRENT_VERSION_PATCH=`cut -d'.' -f3 <<< ${CURRENT_VERSION_NUMBER}`

check_not_empty CURRENT_VERSION_MAJOR "${CURRENT_VERSION_MAJOR}"
check_not_empty CURRENT_VERSION_MINOR "${CURRENT_VERSION_MINOR}"
check_not_empty CURRENT_VERSION_PATCH "${CURRENT_VERSION_PATCH}"

check_equal BUILD_NUMBER $CURRENT_BUILD_NUMBER $TARGET_BUILD_NUMBER

check_equal VERSION_MAJOR $CURRENT_VERSION_MAJOR $TARGET_VERSION_MAJOR
check_equal VERSION_MINOR $CURRENT_VERSION_MINOR $TARGET_VERSION_MINOR
check_equal VERSION_PATCH $CURRENT_VERSION_PATCH $TARGET_VERSION_PATCH



echo OK!
