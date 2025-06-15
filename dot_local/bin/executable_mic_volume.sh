#!/bin/bash

source ~/.local/bin/mic_common.sh

STEP_PERCENT="5%"
MAX_VOLUME="1.00"
MICROPHONE_ID=$(get_default_microphone_id)

if [ -z "$MICROPHONE_ID" ]; then
  exit 1
fi

case "$1" in
"up")
  wpctl set-volume "$MICROPHONE_ID" "$STEP_PERCENT"+
  # Opcional: Limitar el volumen máximo
  CURRENT_VOLUME=$(wpctl get-volume "$MICROPHONE_ID" | awk '{print $2}')
  if (($(echo "$CURRENT_VOLUME > $MAX_VOLUME" | bc -l))); then
    wpctl set-volume "$MICROPHONE_ID" "$MAX_VOLUME"
  fi
  ;;
"down")
  wpctl set-volume "$MICROPHONE_ID" "$STEP_PERCENT"-
  ;;
*)
  echo "Uso: mic_volume.sh [up|down]"
  exit 1
  ;;
esac
