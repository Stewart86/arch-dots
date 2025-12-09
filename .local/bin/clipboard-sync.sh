#!/bin/bash
# Enhanced clipboard sync for Electron apps compatibility

# Store for text clipboard
wl-paste --type text --watch bash -c 'cliphist store' &
TEXT_PID=$!

# Store for image clipboard  
wl-paste --type image --watch bash -c 'cliphist store' &
IMAGE_PID=$!

# Keep script running
wait $TEXT_PID $IMAGE_PID
