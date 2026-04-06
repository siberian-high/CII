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
DIR_SCRIPT=$(cd "$(dirname "$0")" && pwd)
DIR_RESULT=${DIR_SCRIPT}/../Results
RESULT_F=${DIR_RESULT}/${DATE}_${HOSTNAME}_full_result.txt
RESULT_S=${DIR_RESULT}/${DATE}_${HOSTNAME}_simple_result.txt


######################################################################
##U-02: START
###################################################################### 
{
        echo "==========================================================="
        echo "<U-02>Password policy check"                     
        echo "==========================================================="
} | tee -a $RESULT_S $RESULT_F




######################################################################
##U-02: END
######################################################################
{
        echo ""
        echo ""
} | tee -a $RESULT_S $RESULT_F


