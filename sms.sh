#!/bin/bash

log_dir="/var/log/sms"

if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

if [ $# -lt 2 ]; then
    echo "Usage: $0 <event_type> <input_file>"
    exit 1
fi

event_type="$1"
input_file="$2"

function runHandler() {
    case "$1" in
        RECEIVED)
            timestamp=$(date +"%Y%m%d%H%M%S")  
            log_file="$log_dir/received_$timestamp.txt" 
            echo "Timestamp: $timestamp" >> "$log_file"
            head -5 "$input_file" | grep -e "^From: " -e "^Received: " >> "$log_file"
            if grep "Alphabet: UCS2" "$input_file" > /dev/null; then
                sed -e '1,/^$/ d' "$input_file" | recode UCS-2..utf8 >> "$log_file"
            else
                sed -e '1,/^$/ d' "$input_file" >> "$log_file"
            fi
            echo "========================================" >> "$log_file"
            ;;
        SENT)
            timestamp=$(date +"%Y%m%d%H%M%S")
            log_file="$log_dir/send_$timestamp.txt"
            echo "Timestamp: $timestamp" >> "$log_file"
            if grep "Alphabet: UCS" "$input_file" > /dev/null; then
                sed -e '1,/^$/ d' "$input_file" | recode UCS-2..utf8 >> "$log_file"
            else
                sed -e '1,/^$/ d' "$input_file" >> "$log_file"
            fi
            echo "========================================" >> "$log_file"
            ;;
        *)
            echo "Unknown event type: $event_type"
            exit 1
            ;;
    esac
}

function Run() {
    if [ $# -lt 2 ]; then
        echo "Usage: $0 <event_type> <input_file>"
        exit 1
    fi
    runHandler "$1" "$2"
}

Run "$event_type" "$input_file"
