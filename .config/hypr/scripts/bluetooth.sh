sleep 3
while :; do
  sleep 1
  if [ "$(rfkill -n | rg "bluetooth" | awk '{print $4}')" == "unblocked" ]; then
    break
  fi
  notify-send "Bluetooth" "Unblocking Bluetooth"
  rfkill unblock bluetooth
done
