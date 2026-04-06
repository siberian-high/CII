#!/bin/sh
#######################################################################
##Set language Settings
#######################################################################
lang_check=$(locale -a 2>/dev/null | grep "en_US" | grep -E "(utf8|utf-8)")
if [ "$lang_check" = "" ]; then
        lang_check="C"
fi

LANG="$lang_check"
LC_ALL="$lang_check"
LANGUAGE="$lang_check"
export LANG
export LC_ALL
export LANGUAGE


######################################################################
##Set variables
######################################################################
DATE=$(date +%Y%m%d)
HOSTNAME=$(hostname)
THRESHOLD=$(awk -F= '/^[[:space:]]*deny/ {gsub(/ /,"",$2); print $2}' /etc/security/faillock.conf)
DIR_SCRIPT=$(cd "$(dirname "$0")" && pwd)
DIR_RESULT=${DIR_SCRIPT}/../Results
RESULT_F=${DIR_RESULT}/${DATE}_${HOSTNAME}_full_result.txt
RESULT_S=${DIR_RESULT}/${DATE}_${HOSTNAME}_simple_result.txt


######################################################################
#Check root permission
######################################################################
echo "==========================================================="
echo "Check root permission"
echo "==========================================================="

if [ "$(id -u)" -ne 0 ]; then
        echo "This script is not running on root"
        exit
else
        echo "This script is running on root"
fi


######################################################################
##U-03: START
###################################################################### 
echo "===========================================================" | tee $RESULT_S $RESULT_F
{
        echo "<U-03>Check password threshold"                     
        echo "==========================================================="
} | tee -a $RESULT_S $RESULT_F



######################################################################
##U-03: Check /etc/security/faillock.conf
######################################################################
{
	if [ -z  $THRESHOLD ] || [ $THRESHOLD -gt 10 ]; then
		echo "Result: VULNERABLE"
		echo "Reason: There's no threshold or threshold is over 10"
	else
		echo "Result: SAFE"
		echo "Reason: Threshold is under 11"
	fi

echo "$(grep "deny =" /etc/security/faillock.conf)"
} | tee -a $RESULT_S $RESULT_F


######################################################################
##U-03: END
######################################################################
{
        echo "==========================================================="
        echo "END"
        echo "==========================================================="
        echo ""
} | tee -a $RESULT_S $RESULT_F

