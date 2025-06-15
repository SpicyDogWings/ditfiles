#!/bin/bash

get_default_microphone_id() {
  wpctl status |
    sed -n '/^Audio/,/^Video/p' |
    sed -n '/^ *├─ Sources:/,/^ *├─ Filters:/p' |
    grep -E '\*\s*[0-9]+\.' |
    awk '{gsub(/\./, "", $3); print $3}' |
    head -n 1
}
