a=$(nvidia-smi -i 0 --query-gpu=power.draw --format=csv,noheader,nounits);
b=$(nvidia-smi -i 0 --query-gpu=power.limit --format=csv,noheader,nounits);
a=${a/.*};
b=${b/.*};
usage=$((a*100/b));

# in MiB
mem_used=$(nvidia-smi -i 0 --query-gpu=memory.used --format=csv,noheader,nounits);
mem_total=$(nvidia-smi -i 0 --query-gpu=memory.total --format=csv,noheader,nounits);

mem_perc=$((mem_used*100/mem_total));

temp=$(nvidia-smi -i 0 --query-gpu=temperature.gpu --format=csv,noheader,nounits);

echo "{\"text\": \"GPU <span color='#00FF00'>${usage}</span><span color='#00FFFF'>%</span> / <span color='#00FF00'>${temp}</span><span color='#00FFFF'>°</span>   VRAM <span color='#00FF00'>${mem_perc}</span><span color='#00FFFF'>%</span> / <span color='#00FF00'>${mem_used}</span> <span color='#00FFFF'>MiB</span>\"}"

