#!/bin/bash
systemctl $(echo -e "poweroff\nreboot" | fuzzel --dmenu)
