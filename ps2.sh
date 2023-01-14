#!/bin/bash

PID_F(){
 echo $i
}

TTY_F(){
 tty=`awk '{print $7}' /proc/$i/stat`
 if [ $tty -eq 0 ]; then TTY='?'; else TTY=`ls -l /proc/$i/fd/ | grep -E 'tty|pts' | cut -d\/ -f3,4 | uniq`; fi
 echo $TTY 
}


#	<    high-priority (not nice to other users)
# 	N    low-priority (nice to other users)
#	L    has pages locked into memory (for real-time and custom IO)
#	s    is a session leader
#	l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
#	+    is in the foreground process group

STAT_F(){
 State=`awk '{ print $3 }' /proc/$i/stat`
 Nice=`awk '{ print $19 }' /proc/$i/stat`
 Lead=`awk '{ print $6 }' /proc/$i/stat`
 Thread=`awk '{ print $20 }' /proc/$i/stat`
 VPages=`grep VmFlags /proc/$i/smaps | grep lo`
 Foreground=`awk '{ print $8 }' /proc/$i/stat`

 if [ $Thread -gt 1 ]; then Thread='l'; else Thread=''; fi
 if [ $VPages ]; then VMLPages='L'; else VMLPages=''; fi
 if [ $Foreground -eq "-1" ]; then Foreground=''; else Foreground='+'; fi
 if [ $Lead -eq $i ]; then Lead='s'; else Lead=''; fi
 if [ $Nice -lt 0 ]; then Nice='<'; elif [ $Nice -gt 0 ]; then Nice='N'; else Nice=''; fi
 
 echo "$State$Nice$Lead$Thread$VMLPages$Foreground"
}

COMMAND_F(){
 Command=`awk '{ print $1 }' /proc/$i/cmdline`
 if [ -z "$Command" ]; then Command=`cat /proc/$i/stat | awk '{ print $2 }' | tr '(' '[' | tr ')' ']'`; fi
 echo $Command
}

PID=`ls /proc | grep [[:digit:]] | sort -n`
echo "  PID TTY    STAT    COMMAND"
for i in $PID
    do
    if [ -e /proc/$i/stat ]; then
    printf "%5d %-6s %-7s %s\n" $i $(TTY_F) $(STAT_F) $(COMMAND_F);
    
    fi
    done
