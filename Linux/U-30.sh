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
PROFILE=$(awk '/^[[:space:]]*UMASK/ {print $2}' /etc/profile)
LOGIN=$(awk '/^[[:space:]]*UMASK/ {print $2}' /etc/login.defs)
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
##U-30: START
###################################################################### 
echo "===========================================================" | tee "$RESULT_S" "$RESULT_F"
{
        echo "<U-30>Check Umask"                     
        echo "==========================================================="
} | tee -a "$RESULT_S" "$RESULT_F"


######################################################################
##U-30: Check /etc/profile & /etc/login.defs
######################################################################
{
	if [ -n "$PROFILE" ]; then
		{
			if [ "$PROFILE" != 022 ]; then
				echo "Result: VULNERABLE"
				echo "Reason: UMASK is not 022"
			else
				echo "Result: SAFE"
				echo "Result: UMASK is appropriate"
			fi
		}
	elif [ -z "$PROFILE" ]; then
		{
			if [ -z "$LOGIN" ] || [ "$LOGIN" != 022 ]; then
                		echo "Result: VULNERABLE"
                		echo "Reason: UMASK is not 022"
        		else
                		echo "Result: SAFE"
                		echo "Reason: UMASK is appropriate"
        		fi
		}
	else
		echo "Result: SAFE"
		echo "Reason: UMASK is appropriate"
	fi
} | tee -a "$RESULT_S" "$RESULT_F"


######################################################################
##U-30: END
######################################################################
{
	echo "==========================================================="
	echo "END"
	echo "==========================================================="
        echo ""
} | tee -a "$RESULT_S" "$RESULT_F"
