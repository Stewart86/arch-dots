TOTAL_NUM_SNAPSHOTS=$(("$(sudo timeshift --list --snapshot-device /dev/nvme0n1p2 | wc -l)" - 11))
SNAPSHOTS_TO_KEEP=4
OLD_SNAPSHOT="$(sudo timeshift --list --snapshot-device /dev/nvme0n1p2 | tail -n $TOTAL_NUM_SNAPSHOTS | awk '{print $3}' | head -n $((TOTAL_NUM_SNAPSHOTS - SNAPSHOTS_TO_KEEP)))"

for i in $OLD_SNAPSHOT; do
  sudo timeshift --delete --snapshot-device /dev/nvme0n1p2 --snapshot "$i"
done

echo ":: Snapshots cleanup completed"
sudo timeshift --list --snapshot-device /dev/nvme0n1p2
