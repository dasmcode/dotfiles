#!/usr/bin/env bash

exec zscroll \
  --length 20 \
  --delay 0.3 \
  --update-check true \
  --eval-in-shell true \
  'playerctl metadata --format "{{title}} - {{artist}}"' 2>/dev/null
