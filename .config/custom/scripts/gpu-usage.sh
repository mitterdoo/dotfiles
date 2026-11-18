# iterations=1;

# usage_sum=0;
# for (( i=1; i<=iterations; i++ )) do
# 	this_usage=$(amd-smi metric -u | grep -oP 'GFX_ACTIVITY: \K\d+' -m 1);
# 	usage_sum=$((usage_sum+this_usage));
# done
# usage=$((usage_sum/iterations));
usage=$(cat /sys/class/drm/card1/device/gpu_busy_percent);

# in MiB


vram_used=$(cat /sys/class/drm/card1/device/mem_info_vram_used);
vram_used_display=$((vram_used/1000000));
vram_total=$(cat /sys/class/drm/card1/device/mem_info_vram_total);
vram_total_display=$((vram_total/1000000));
vram_perc=$((vram_used*100/vram_total));

gtt_used=$(cat /sys/class/drm/card1/device/mem_info_gtt_used);
gtt_used_display=$((gtt_used/1000000));
gtt_total=$(cat /sys/class/drm/card1/device/mem_info_gtt_total);
gtt_total_display=$((gtt_total/1000000));
gtt_perc=$((gtt_used*100/gtt_total));

mem_used=$((vram_used+gtt_used));
mem_used_display=$((mem_used/1000000));
mem_total=$((vram_total+gtt_total));

# mem_perc=$((mem_used*100/mem_total));
mem_perc=$((mem_used*100/vram_total));
# for now i only want an alert if we go over the actual VRAM available in the card. GTT is in physical RAM if i understand correctly

temp_raw=$(cat /sys/class/drm/card1/device/hwmon/hwmon4/temp3_input);
temp=$((temp_raw/1000));

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

if (( gtt_perc >= 75 )); then
	mem_color='FF0000';
	mem_decorator_start='<b>';
	mem_decorator_end='</b>';
fi
usage=$(printf '%2d' $usage);
mem_perc=$(printf '%2d' $mem_perc);
echo "{\"text\": \"GPU ${perc_decorator_start}<span color='#${perc_color}'>${usage}</span><span color='#00AAFF'>%</span>${perc_decorator_end} / ${temp_decorator_start}<span color='#${temp_color}'>${temp}</span><span color='#00AAFF'>°</span>${temp_decorator_end}   VRAM ${mem_decorator_start}<span color='#${mem_color}'>${mem_perc}</span><span color='#00AAFF'>%</span>${mem_decorator_end} / ${mem_decorator_start}<span color='#${mem_color}'>${mem_used_display}</span> <span color='#00AAFF'>MiB</span>${mem_decorator_end}\", \"tooltip\": \"VRAM: ${vram_perc}%    ${vram_used_display} / ${vram_total_display} MiB\nGTT: ${gtt_perc}%    ${gtt_used_display} / ${gtt_total_display} MiB\"}"

