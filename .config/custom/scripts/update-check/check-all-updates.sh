#!/bin/bash
DATAFILE_DIR="$HOME/.config/check-all-updates"
DATAFILE_TIME="last_checked"
DATAFILE_CACHE="cache"

# in seconds
CACHE_FREQUENCY=3600

function ensure_valid_folder {
	mkdir -p "$DATAFILE_DIR"
}

function check_updates_all {
	local err=0
	checkupdates
	err=$?
	if (( $err == 2 )); then
		err=0
	fi

	paru -Qum
	local paru_result=$?
	if (( $paru_result != 0 && $paru_result != 1 )); then
		err=1
	fi
	return $err
}

function try_read_file {
	if [[ ! -f "$1" ]]; then
		return 1
	fi
	cat "$1"
	return 0
}

function get_cached_updates {
	path=$DATAFILE_DIR/$DATAFILE_CACHE
	try_read_file "$path"
}

function set_cached_updates {
	ensure_valid_folder
	printf '%s' "$1" > "$DATAFILE_DIR/$DATAFILE_CACHE"
}

function countlines {
	printf '%s' "$1" | grep -c '^'
}
function json_escape {
	printf '%s' "$1" | jq -Rsa .
}

function get_the_fkn_time {
	date +%s
}

function get_last_check {
	path=$DATAFILE_DIR/$DATAFILE_TIME
	try_read_file "$path"
}

function set_last_check {
	ensure_valid_folder
	printf '%s' "$1" > "$DATAFILE_DIR/$DATAFILE_TIME"
}

function is_cache_current {
	cur_time=$(get_the_fkn_time)

	last_check=$(get_last_check)

	if (( $? != 0 )); then
		last_check=0
	fi
	
	((next_check = last_check + CACHE_FREQUENCY))
	((cur_time < next_check))
}

function update_cached_update_list {
	cur_time=$(get_the_fkn_time)
	temp_update_list=$(check_updates_all)
	if (( $? != 0 )); then
		return 1;
	fi
	set_last_check "$cur_time"
	set_cached_updates "$temp_update_list"
	printf '%s' "$temp_update_list"
	return 0;
}

function main {
	cached_updates=$(get_cached_updates)
	if (( $? != 0 )) then
		cached_updates=""
	fi
	if ! is_cache_current; then
		fetched_updates=$(update_cached_update_list)
		if (( $? != 0)); then
			printf '%s' "$cached_updates"
			return 1
		fi
		updates=$fetched_updates

	else
		updates=$cached_updates
	fi

	update_count=$(countlines "$updates")
	if ((update_count == 0)); then
		return 2
	fi
	printf '%s' "$updates"
	return 0
	
}

main

