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
PASSWD=$(awk -F: '$2 != "x"' /etc/passwd)
SHADOW=$(awk -F: '$2 == "" || $2 !~ /^(\$[2-9]+\$|!|\*)/' /etc/shadow)
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
##U-04: START
###################################################################### 
echo "===========================================================" | tee $RESULT_S $RESULT_F
{
        echo "<U-04>Check password files"                     
        echo "==========================================================="
} | tee -a $RESULT_S $RESULT_F


######################################################################
##U-04: CHECK /etc/passwd 
######################################################################
{
	echo "CHECK /etc/passwd"
	echo "==========================================================="
	if [ -n "$PASSWD" ]; then
		echo "Result: VULNERABLE"
		echo "Reason: Accounts not using the shadow password file were detected." 
	else
		echo "Result: SAFE"
		echo "Reason: Accounts not using the shadow password file were not detected."
	fi
	
echo $PASSWD
echo ""
} | tee -a $RESULT_S $RESULT_F


######################################################################
##U-04: CHECK /etc/shadow
######################################################################
{
	echo "==========================================================="
	echo "CHECK /etc/shadow"
	echo "==========================================================="
	if [ -n "$SHADOW" ]; then
		echo "Result: VULNERABLE"
		echo "Reason: Accounts not using the safe hash were detected."
	else
		echo "Result: SAFE"
		echo "Reason: Accounts not using the safe hash were not detected."
	fi

echo $SHADOW
echo ""
} | tee -a $RESULT_S $RESULT_F


######################################################################
##U-04: END
######################################################################
{
	echo "==========================================================="
	echo "END"
	echo "==========================================================="
        echo ""
} | tee -a $RESULT_S $RESULT_F
