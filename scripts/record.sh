#!/usr/bin/env bash

TARGET_DIR="$HOME/Videos/Screencasts"
mkdir -p "$TARGET_DIR"

PID_FILE="/tmp/hyprrecorder.pid"

# Stop recording if already running
if [ -f "$PID_FILE" ]; then
  PID=$(cat "$PID_FILE")
  if kill -0 "$PID" 2>/dev/null; then
    kill -INT "$PID"
    rm -f "$PID_FILE"
    notify-send -u normal -i media-playback-stop "Screen Recording" "Recording stopped and saved to $TARGET_DIR"
    exit 0
  fi
  rm -f "$PID_FILE"
fi

# Show config dialog
CHOICES=$(zenity --forms --title="Screen Recorder Setup" \
  --text="Configure capture options" \
  --add-combo="Mode" --combo-values="Fullscreen|Region" \
  --add-combo="Audio Capture" --combo-values="No Audio|Desktop|Microphone|Desktop + Mic" \
  --separator=";")

[ $? -ne 0 ] && exit 0

MODE=$(echo "$CHOICES" | cut -d ";" -f 1)
AUDIO_MODE=$(echo "$CHOICES" | cut -d ";" -f 2)

# TODO: make region based recording work
GEOMETRY_FLAG=""
if [ "$MODE" = "Region" ]; then
  GEOM=$(slurp)
  [ -z "$GEOM" ] && exit 0
  GEOMETRY_FLAG="-g $GEOM"
fi

# Audio targets (PipeWire / PulseAudio)
DEFAULT_SINK_MONITOR="$(pactl get-default-sink).monitor"
DEFAULT_SOURCE="$(pactl get-default-source)"

AUDIO_FLAGS=""
case "$AUDIO_MODE" in
  "Desktop")
    AUDIO_FLAGS="-a=$DEFAULT_SINK_MONITOR"
    ;;
  "Microphone")
    AUDIO_FLAGS="-a=$DEFAULT_SOURCE"
    ;;
  "Desktop + Mic")
    # TODO: support audio source mix
    AUDIO_FLAGS="-a=$DEFAULT_SOURCE"
    ;;
  *)
    AUDIO_FLAGS=""
    ;;
esac

# Launch recorder
FILENAME="$TARGET_DIR/Screencast From $(date +'%Y-%m-%d %H-%M-%S').mp4"

wf-recorder $GEOMETRY_FLAG $AUDIO_FLAGS -f "$FILENAME" &
REC_PID=$!
echo "$REC_PID" > "$PID_FILE"

notify-send -u normal -i media-record "Screen Recording" "Recording started: $(basename "$FILENAME")\nPress bind again to stop."
