#!/usr/bin/with-contenv bashio

CONFIG_PATH=/data/options.json
DEVICE="$(bashio::config 'device')"
BITRATE="$(bashio::config 'bitrate')"

echo "Config: DEVICE=$DEVICE BITRATE=$BITRATE"

# Print driver info
dmesg | grep -i '\(can\|spi\)'

# Print current status
ip link show "$DEVICE"

# If the device is already up, bring it down first.
if [ "$(cat "/sys/class/net/$DEVICE/operstate")" == "up" ]; then
  ip link set "$DEVICE" down
fi

ip link set "$DEVICE" up type can bitrate "$BITRATE"
ip link set txqueuelen 10000 dev "$DEVICE"
ip link set "$DEVICE" up

# Print current status
ip link show "$DEVICE"

# Print all links
echo "ip -c -h a:"
ip -c -h a
