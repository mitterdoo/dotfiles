#!/bin/bash
systemctl $(echo -e "poweroff\nreboot\nsleep" | fuzzel --dmenu)
