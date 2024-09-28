# Date and time
now=$(date "+ %d.%m.%Y   %H:%M")

battery=$(upower --show-info $(upower --enumerate | grep 'BAT') | awk ' /percentage/ {print $2}')
if [ $(upower --show-info $(upower --enumerate | grep 'BAT') | awk ' /state/ {print $2}') = "discharging" ]; then
  battery="🔋 $battery"
else
  battery=" $battery"
fi

bluetooth_headphones=$(upower --show-info $(upower --enumerate | grep 'headset_dev') | awk '/percentage/ {print $2}')
if ! [ -z $bluetooth_headphones ]; then
  model=$(upower --show-info $(upower --enumerate | grep 'headset_dev') | grep model | cut -d ':' -f 2- | xargs)
  bluetooth_headphones=" $bluetooth_headphones ($model)"
fi

wifi_essid=$(iw dev wlp1s0 link | awk '/SSID:/ { print $2 }')
if [ $wifi_essid ]; then
  network=" $wifi_essid"
else
  network="-"
fi

echo "$network   $bluetooth_headphones   $battery   $now  "
