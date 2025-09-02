#!/bin/bash
echo "Running system upgrade"
echo ""
paru -Syu

result=$?
if ((result != 0)); then
	echo "There were errors. See above"
	read -p "Press enter to continue"
fi
rm /home/ranthos/.config/check-all-updates/cache
rm /home/ranthos/.config/check-all-updates/last_checked
pkill -RTMIN+13 waybar

