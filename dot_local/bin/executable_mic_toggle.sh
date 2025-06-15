#!/bin/bash

source ~/.local/bin/mic_common.sh

get_mic_status_and_volume() {
  local status_output=$(wpctl get-volume "$MICROPHONE_ID" 2>/dev/null)
  if echo "$status_output" | grep -q "MUTED"; then
    echo "muted"
  else
    local volume_raw=$(echo "$status_output" | awk '{print $2}')
    local volume_percent=$(echo "scale=0; ($volume_raw * 100) / 1" | bc)
    echo "unmuted $volume_percent"
  fi
}

toggle_mic() {
  wpctl set-mute "$MICROPHONE_ID" toggle 2>/dev/null
}

MICROPHONE_ID=$(get_default_microphone_id)

if [ -z "$MICROPHONE_ID" ]; then
  echo "{\"text\": \" No Mic\", \"tooltip\": \"Error: Micrófono no detectado\", \"class\": \"error\"}"
  exit 0
fi

case "$1" in
"toggle")
  toggle_mic
  ;;
*)
  READ_STATUS=$(get_mic_status_and_volume)
  STATUS=$(echo "$READ_STATUS" | awk '{print $1}')
  VOLUME_PERCENT=$(echo "$READ_STATUS" | awk '{print $2}')

  ICON=""
  TEXT=""
  CLASS=""

  if [ "$STATUS" == "muted" ]; then
    ICON=""
    TEXT=""
    CLASS="muted"
  else
    ICON=""
    # Mostramos el volumen actual en el texto
    TEXT="$VOLUME_PERCENT%"
    CLASS="unmuted"
  fi
  echo "{\"text\": \"$ICON $TEXT\", \"tooltip\": \"Micrófono: $TEXT\", \"class\": \"$CLASS\"}"
  ;;
esac
