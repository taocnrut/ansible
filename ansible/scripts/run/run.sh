#!/bin/bash
DATE=$(date +%Y/%m/%d)
mkdir -p logs/$DATE
LOG="logs/$DATE/run-script-$(date +%Y-%m-%d-%H%M%S).log"
echo "Logging to $LOG"
if [ "$1" != "" ]; then
	time ansible-playbook -l $1 -f 10 playbooks/05-run.yml 2>&1 | tee $LOG
else
	echo "You must specify on which hosts to run script. Exiting..."
	exit 1
fi

echo 
echo "Finished. "
b=$(grep changed= $LOG|grep -v ok=3 -c)
if [ $b -gt 0 ]; then
	echo "Failed hosts:"
	echo
	grep changed= $LOG|grep -v ok=3 
fi

echo
echo "Log file is $LOG"
