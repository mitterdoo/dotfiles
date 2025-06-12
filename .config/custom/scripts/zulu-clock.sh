#!/bin/bash


result=$(TZ='Etc/UTC' date +"%H:%M:%S")

echo "<span color='#00FF00'>$result</span><span color='#00FFFF'>Z</span>"

