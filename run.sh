#!/bin/bash
while :
do
	echo "Controleren op updates..."
	git pull
	echo "Opstarten..."
	python monitor.py*
	echo "Node afgesloten. Druk op CTRL+C om af te sluiten.";
	for i in {5..1}
	do
		echo "Herstarten in $i..."
		sleep 1
	done
done