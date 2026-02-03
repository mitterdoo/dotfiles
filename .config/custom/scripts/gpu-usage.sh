# iterations=1;

# usage_sum=0;
# for (( i=1; i<=iterations; i++ )) do
# 	this_usage=$(amd-smi metric -u | grep -oP 'GFX_ACTIVITY: \K\d+' -m 1);
# 	usage_sum=$((usage_sum+this_usage));
# done
# usage=$((usage_sum/iterations));
usage=$(amd-smi metric -u | grep -oP 'GFX_ACTIVITY: \K\d+' -m 1);

# in MiB
mem_used=$(amd-smi metric -m | grep -oP 'USED_VRAM: \K\d+');
mem_total=$(amd-smi metric -m | grep -oP 'TOTAL_VRAM: \K\d+');

mem_perc=$((mem_used*100/mem_total));

temp=$(amd-smi metric -t | grep -oP 'MEM: \K\d+');

perc_color='00FF00';
perc_decorator_start='';
perc_decorator_end='';
if (( usage >= 99 )); then
	perc_color='00FFFF';
	perc_decorator_start='<b>';
	perc_decorator_end='</b>';
fi

temp_color='00FF00';
temp_decorator_start='';
temp_decorator_end='';
if (( temp >= 90 )); then
	temp_color='FF7F00';
	temp_decorator_start='<b>';
	temp_decorator_end='</b>';
fi
if (( temp >= 102 )); then
	temp_color='FF0000';
fi

mem_color='00FF00';
mem_decorator_start='';
mem_decorator_end='';
if (( mem_perc >= 95 )); then
	mem_color='FF7F00';
	mem_decorator_start='<b>';
	mem_decorator_end='</b>';
fi
usage=$(printf '%2d' $usage);
mem_perc=$(printf '%2d' $mem_perc);
echo "{\"text\": \"GPU ${perc_decorator_start}<span color='#${perc_color}'>${usage}</span><span color='#00AAFF'>%</span>${perc_decorator_end} / ${temp_decorator_start}<span color='#${temp_color}'>${temp}</span><span color='#00AAFF'>°</span>${temp_decorator_end}   VRAM ${mem_decorator_start}<span color='#${mem_color}'>${mem_perc}</span><span color='#00AAFF'>%</span>${mem_decorator_end} / ${mem_decorator_start}<span color='#${mem_color}'>${mem_used}</span> <span color='#00AAFF'>MiB</span>${mem_decorator_end}\"}"

