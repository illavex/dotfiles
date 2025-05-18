#!/bin/bash
# A simpler approach to audio switching that uses pactl instead of wpctl

LOG_FILE="/tmp/audio_switch_simple.log"
# echo "========================================" > $LOG_FILE
# echo "Simple audio switch script started at $(date)" >> $LOG_FILE

# Check if pactl exists
if ! command -v pactl &> /dev/null; then
    # echo "pactl command not found - need PulseAudio or PipeWire-Pulse" >> $LOG_FILE
    # echo '{"text": "🔊 Error: pactl not found"}'
    exit 1
fi

# Get the default sink
DEFAULT_SINK=$(pactl get-default-sink)
# echo "Current default sink: $DEFAULT_SINK" >> $LOG_FILE

# Get all available sinks
ALL_SINKS=$(pactl list short sinks | cut -f2)
# echo "All available sinks: $ALL_SINKS" >> $LOG_FILE

# Create an array from available sinks
readarray -t SINK_ARRAY <<< "$ALL_SINKS"
# echo "Number of sinks: ${#SINK_ARRAY[@]}" >> $LOG_FILE

# If there's only one sink, we can't switch
if [ ${#SINK_ARRAY[@]} -le 1 ]; then
    # echo "Only one sink available, cannot switch" >> $LOG_FILE
    # echo '{"text": "🔊 No alternative output"}'
    exit 0
fi

# Find the index of the current default sink
CURRENT_INDEX=-1
for i in "${!SINK_ARRAY[@]}"; do
    if [[ "${SINK_ARRAY[$i]}" == "$DEFAULT_SINK" ]]; then
        CURRENT_INDEX=$i
        break
    fi
done

# echo "Current sink index: $CURRENT_INDEX" >> $LOG_FILE

# If we couldn't find the current sink, use the first one
if [ $CURRENT_INDEX -eq -1 ]; then
    TARGET_INDEX=0
else
    # Select the next sink (wrap around if needed)
    TARGET_INDEX=$(( (CURRENT_INDEX + 1) % ${#SINK_ARRAY[@]} ))
fi

# echo "Target sink index: $TARGET_INDEX" >> $LOG_FILE
TARGET_SINK="${SINK_ARRAY[$TARGET_INDEX]}"
# echo "Target sink: $TARGET_SINK" >> $LOG_FILE

# Set the new default sink
pactl set-default-sink "$TARGET_SINK"
SWITCH_RESULT=$?
# echo "Switched to sink $TARGET_SINK with result: $SWITCH_RESULT" >> $LOG_FILE
if [ "$TARGET_SINK" = "alsa_output.pci-0000_12_00.6.analog-stereo" ]; then
    notify-send "Switched Audio-Output" "Now using: PC"
fi

if [ "$TARGET_SINK" = "alsa_output.pci-0000_03_00.1.hdmi-stereo" ]; then
    notify-send "Switched Audio-Output" "Now using: Monitor"
fi


if [ $SWITCH_RESULT -ne 0 ]; then
    # echo "Failed to switch to sink $TARGET_SINK" >> $LOG_FILE
    # echo '{"text": "🔊 Switch failed"}'
    exit 1
fi

# Move all input streams to the new sink
pactl list short sink-inputs | while read -r stream_id rest; do
    pactl move-sink-input "$stream_id" "$TARGET_SINK"
    # echo "Moved stream $stream_id to sink $TARGET_SINK" >> $LOG_FILE
done

# Get a prettier name for display
DISPLAY_NAME=$(pactl list sinks | grep -A1 "Name: $TARGET_SINK" | grep "Description" | sed 's/^.*Description: //')
if [ -z "$DISPLAY_NAME" ]; then
    DISPLAY_NAME="$TARGET_SINK"
fi

# echo "Display name: $DISPLAY_NAME" >> $LOG_FILE
# echo '{"text": "🔊 '"$DISPLAY_NAME"'"}'

# echo "Script completed successfully" >> $LOG_FILE
exit 0