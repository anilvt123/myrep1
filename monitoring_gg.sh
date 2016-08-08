#!/bin/ksh
# Script      : monitoring_gg.sh

# Version     : 1.0
# Purpose     : To monitor Goldengate processes and latency
# Usage       : monitoring_gg.sh ORACLE_SID GOLDENGATE_HOME LAG_THRESHOLD
# Example     : monitoring_gg.sh DBNAME /u01/app/goldengate/11.2.1.0.17 30
# Example     : monitoring_gg.sh SOAUAT2 /u01/app/goldengate/gg12c 10



function show_usage {
    echo " "
    echo "Usage: $PWD/monitoring_gg.sh ORACLE_SID OGG_HOME LAG_THRESHOLD"
    echo "   ORACLE_SID  : Name of the Database instance that is configured for Goldengate replication. "
    echo "   OGG_HOME : Directory where Goldengate is installed. "
    echo "   LAG_THRESHOLD   : Lag threshold in minutes"
    echo "Example: $PWD/monitoring_gg.sh DBNAME /u01/app/goldengate/11.2.1.0.17 30"
    echo " "
    exit 1
}

# **************************************
# Input parameter validation
# **************************************

if [ "$1" ]
then
   ORACLE_SID=`echo $1 | tr "[a-z]" "[A-Z]" `; export ORACLE_SID
else
   show_usage
fi
if [ "$2" ]
then
   OGG_HOME=`echo $2`; export OGG_HOME
else
   show_usage
fi
if [ "$3" ]
then
   LAG_THRESHOLD=`echo $3`; export LAG_THRESHOLD
else
   show_usage
fi

# **************************************
# Setting up the environment
# **************************************

ORAENV_ASK=NO; export ORAENV_ASK
. /usr/local/bin/oraenv
ORAENV_ASK= ; export ORAENV_ASK
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$OGG_HOME
export PATH=$OGG_HOME:$PATH
export MAIL_LIST="ategginahalli@wmata.com" 

# **************************************
# Gather Goldengate information
# **************************************

cd $OGG_HOME
$OGG_HOME/ggsci -s << EOF > /tmp/monitoring_gg.log
info all
exit
EOF

# ********************************************
# Monitoring Godlengate processes and lag time
# ********************************************

cat /tmp/monitoring_gg.log | egrep 'MANAGER|EXTRACT|REPLICAT'| tr ":" " " | while read LINE
do
  case $LINE in
    *)
    PROCESS_TYPE=`echo $LINE | awk -F" " '{print $1}'`
    PROCESS_STATUS=`echo $LINE | awk -F" " '{print $2}'`
    if [ "$PROCESS_TYPE" == "MANAGER" ]
    then
       if [ "$PROCESS_STATUS" != "RUNNING" ]
       then
           SUBJECT="ALERT ... Goldengate process \"$PROCESS_TYPE\" is $PROCESS_STATUS on `uname -n`($ORACLE_SID)"
           mailx -s "$SUBJECT" $MAIL_LIST < $OGG_HOME/dirrpt/MGR.rpt
           exit 1
       else
           continue
       fi
    elif [ "$PROCESS_TYPE" == "JAGENT" ]
    then
       if [ "$PROCESS_STATUS" != "RUNNING" ]
       then
           SUBJECT="WARNING ... Goldengate process \"$PROCESS_TYPE\" is $PROCESS_STATUS on `uname -n`"
           mailx -s "$SUBJECT" $MAIL_LIST < $OGG_HOME/dirrpt/JAGENT.rpt
       fi
    else
       PROCESS_NAME=`echo $LINE | awk -F" " '{print $3}'`
       LAG_HH=`echo $LINE | awk -F" " '{print $4}'`
       LAG_MM=`echo $LINE | awk -F" " '{print $5}'`
       LAG_SS=`echo $LINE | awk -F" " '{print $6}'`
       CKPT_HH=`echo $LINE | awk -F" " '{print $7}'`
       CKPT_MM=`echo $LINE | awk -F" " '{print $8}'`
       CKPT_SS=`echo $LINE | awk -F" " '{print $9}'`
       if [ "$PROCESS_STATUS" != "RUNNING" ]
       then
           SUBJECT="ALERT ... Goldengate process \"$PROCESS_TYPE($PROCESS_NAME)\" is $PROCESS_STATUS on `uname -n`($ORACLE_SID)"
           mailx -s "$SUBJECT" $MAIL_LIST < $OGG_HOME/dirrpt/${PROCESS_NAME}.rpt
       else
           if [ $LAG_HH -gt 00 -o $LAG_MM -ge $LAG_THRESHOLD ];
           then
              SUBJECT="ALERT ... Goldengate process \"$PROCESS_TYPE($PROCESS_NAME)\" has a lag of "$LAG_HH" hour "$LAG_MM" min on `uname -n`($ORACLE_SID)"
              mailx -s "$SUBJECT" $MAIL_LIST < $OGG_HOME/dirrpt/${PROCESS_NAME}.rpt
           fi 
      fi
    fi
  esac
done


# **************************************
# Monitoring Godlengate Error log
# **************************************


GG_ERROR_FILE=$OGG_HOME/ggserr.log
GG_ERROR_MNTR=$OGG_HOME/ggserr.monitor
GG_ERROR_DIFF=$OGG_HOME/ggserr.diff

touch $GG_ERROR_DIFF

if [[ -r ${GG_ERROR_FILE} ]]
then
    touch $GG_ERROR_MNTR
    cp $GG_ERROR_MNTR $GG_ERROR_MNTR".old"
    egrep "ERROR|WARNING" $GG_ERROR_FILE > $GG_ERROR_MNTR
    CUR_CNT=`cat $GG_ERROR_MNTR |wc -l`
    PRV_CNT=`cat $GG_ERROR_MNTR".old" |wc -l`
    if [[ $CUR_CNT -lt $PRV_CNT ]]
    then
        # This means that ggserr.log is purged, so let's clear out the previous monitor results
        PRV_CNT=0
    fi
    if [[ $CUR_CNT -gt $PRV_CNT ]]
    then
        diff $GG_ERROR_MNTR $GG_ERROR_MNTR".old" | grep "^<" | sed -e 's/^< //' > ${GG_ERROR_DIFF}
        # send a mail..
        if test `cat ${GG_ERROR_DIFF} | wc -l` -gt 1
        then
            # multipl errors found. process only the last ten.
            tail -10 $GG_ERROR_DIFF > $GG_ERROR_DIFF".1"
        else
            # single error found.
            cp $GG_ERROR_DIFF $GG_ERROR_DIFF".1"
        fi
        SUBJECT="WARNING .. Errors encountered in Goldengate replication on `uname -n`($ORACLE_SID)"
        mailx -s "$SUBJECT" $MAIL_LIST < $GG_ERROR_DIFF".1"
    fi
    rm $GG_ERROR_DIFF*
fi