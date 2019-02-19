#!/bin/bash
. $HOME/.bash_profile
echo "$0: Stopping DW" >&2
#/opt/dw/dw-1.0/bin/dw_restart stopnow
/opt/dw/dw/bin/dw_restart stopnow
echo "$0: Sleeping 10 seconds" >&2
sleep 10
echo "$0: Starting DW" >&2
#/opt/dw/dw-1.0/bin/dw_restart
/opt/dw/dw/bin/dw_restart
echo "$0: Done" >&2

