usage=$(amd-smi metric -u | grep -oP 'GFX_ACTIVITY: \K\d+' -m 1);

# in MiB
mem_used=$(amd-smi metric -m | grep -oP 'USED_VRAM: \K\d+');
mem_total=$(amd-smi metric -m | grep -oP 'TOTAL_VRAM: \K\d+');

mem_perc=$((mem_used*100/mem_total));

temp=$(amd-smi metric -t | grep -oP 'MEM: \K\d+');

echo "{\"text\": \"GPU <span color='#00FF00'>${usage}</span><span color='#00FFFF'>%</span> / <span color='#00FF00'>${temp}</span><span color='#00FFFF'>°</span>   VRAM <span color='#00FF00'>${mem_perc}</span><span color='#00FFFF'>%</span> / <span color='#00FF00'>${mem_used}</span> <span color='#00FFFF'>MiB</span>\"}"

