#!/bin/bash

check_not_empty() {
  if [ -z "$2" ]
  then
        echo "\$$1 is empty"
	exit 1
  else
        echo "\$$1 is $2"
  fi
}

check_more(){
	if [ $2 -lt $3 ]
	then
		echo $1 current value $2 is less than target $3 
		exit 2
	fi
	if [ $2 -gt $3 ]
	then
		exit 0
	fi
}

check_more_or_equal(){
	if [ $2 -le $3 ]
	then
		echo $1 current value $2 is less than target or equal $3 
		exit 2
	fi
}


TARGET_BRANCH="${1:-master}"

check_not_empty TARGET_BRANCH "${TARGET_BRANCH}"

TARGET_VERSION=`git show origin/${TARGET_BRANCH}:./pubspec.yaml | grep '^version: [0-9]*\.[0-9]*\.[0-9]*+[0-9]*' | grep -o '[0-9]*\.[0-9]*\.[0-9]*+[0-9]*'`

check_not_empty TARGET_VERSION "${TARGET_VERSION}"

TARGET_VERSION_NUMBER=`cut -d'+' -f1 <<< ${TARGET_VERSION}`
TARGET_BUILD_NUMBER=`cut -d'+' -f2 <<< ${TARGET_VERSION}`

check_not_empty TARGET_BUILD_NUMBER "${TARGET_BUILD_NUMBER}"
check_not_empty TARGET_VERSION_NUMBER "${TARGET_VERSION_NUMBER}"

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

check_more_or_equal BUILD_NUMBER $CURRENT_BUILD_NUMBER $TARGET_BUILD_NUMBER

check_more VERSION_MAJOR $CURRENT_VERSION_MAJOR $TARGET_VERSION_MAJOR
check_more VERSION_MINOR $CURRENT_VERSION_MINOR $TARGET_VERSION_MINOR
check_more_or_equal VERSION_PATCH $CURRENT_VERSION_PATCH $TARGET_VERSION_PATCH



echo OK!
