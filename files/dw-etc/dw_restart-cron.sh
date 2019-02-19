#!/bin/bash
. $HOME/.bash_profile
LOGFILE=/opt/log/dw/dw_restart-cron.log
echo "$0: Stopping DW at `date`" >> $LOGFILE
#/opt/dw/dw-1.0/bin/dw_restart stopnow >>$LOGFILE 2>&1
/opt/dw/dw/bin/dw_restart stopnow >>$LOGFILE 2>&1
echo "$0: Sleeping 30 seconds" >> $LOGFILE
sleep 30
echo "$0: Starting DW at `date`" >> $LOGFILE
#/opt/dw/dw-1.0/bin/dw_restart >>$LOGFILE 2>&1
/opt/dw/dw/bin/dw_restart >>$LOGFILE 2>&1
echo -e "$0: Done at `date`\n" >> $LOGFILE

