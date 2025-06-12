#!/bin/bash
echo "Running system upgrade"
echo ""
paru -Syu

result=$?
if ((result != 0)); then
	echo "There were errors. See above"
	read -p "Press enter to continue"
fi
pkill -RTMIN+13 waybar

