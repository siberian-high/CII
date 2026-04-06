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
OWNER=$(stat -c '%U' /etc/passwd)
AUTH=$(stat -c '%a' /etc/passwd)
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
##U-16: START
###################################################################### 
echo "===========================================================" | tee "$RESULT_S" "$RESULT_F"
{
        echo "<U-16>Check /ect/passwd auth"
        echo "==========================================================="
} | tee -a "$RESULT_S" "$RESULT_F"

######################################################################
##U-16: Check /etc/passwd
######################################################################
{
	if [ "$OWNER" = "root" ] && [ "$AUTH" -eq 644 ]; then
		echo "Result: SAFE"
		echo "Reason: root & 644"
		echo "$OWNER" "$AUTH"
	else
		echo "Result: VULNERABLE"
		echo "Reason: Not root or not 644"
	fi
		
} | tee -a "$RESULT_S" "$RESULT_F"

######################################################################
##U-16: END
######################################################################
{
	echo "==========================================================="
	echo "END"
	echo "==========================================================="
        echo ""
} | tee -a "$RESULT_S" "$RESULT_F"
