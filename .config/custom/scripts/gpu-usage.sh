a=$(nvidia-smi -i 0 --query-gpu=power.draw --format=csv,noheader,nounits);
b=$(nvidia-smi -i 0 --query-gpu=power.limit --format=csv,noheader,nounits);
a=${a/.*};
b=${b/.*};
usage=$((a*100/b));
temp=$(nvidia-smi -i 0 --query-gpu=temperature.gpu --format=csv,noheader,nounits);

echo "{\"text\": \"GPU <span color='#00FF00'>${usage}</span><span color='#00FFFF'>%</span> / <span color='#00FF00'>${temp}</span><span color='#00FFFF'>°</span>\"}"

