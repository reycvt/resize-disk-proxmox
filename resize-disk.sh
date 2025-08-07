#!/bin/bash

set -e

echo "[+] Checking partition and disk..."

# Resize partition
DEVICE="/dev/sda"
PART_NUM=3
PART="${DEVICE}${PART_NUM}"

echo "[+] Resizing partition $PART using parted..."
parted $DEVICE ---pretend-input-tty <<EOF
resizepart $PART_NUM 100%
Yes
EOF

# Resize physical volume
echo "[+] Resizing PV on $PART..."
pvresize $PART

# Extend LV to use all free space and resize FS
LV_PATH=$(lvdisplay | grep "LV Path" | awk '{print $3}')
echo "[+] Logical volume path detected: $LV_PATH"

echo "[+] Extending LV to use all available space..."
lvextend -r -l +100%FREE "$LV_PATH"

echo "[✓] Done resizing disk and filesystem!"
df -hT "$LV_PATH"
