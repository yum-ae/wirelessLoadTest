SSID="GL-AR750S-a6a-Guest"
# File descriptor may hit the ceiling.
# sudo nano /etc/systemd/system/dbus-fi.w1.wpa_supplicant1.service 
# [Service]
# LimitNOFILE=4096 <- add

# creating too many (more than 140) vif at once, may cause buffer overflow of wpa_supplicant

for i in $(seq -w 16 150); do
    echo "vwlan$i"
    hex=$(echo "obase=16; $i" | bc)
    echo "aa:bb:cc:dd:ee:"$hex
    sudo iw phy0 interface add vwlan$i type managed addr aa:bb:cc:dd:ee:$hex
done
# After interface activation, it requires about 9 seconds to connect to an AP
sleep 10
for i in $(seq -w 16 150); do
    sudo nmcli device wifi connect $SSID ifname vwlan$i & 
    echo "exit with "$?
    sleep 5
done
for i in $(seq -w 16 150); do
    sudo wpa_cli reassociate -i vwlan$i
done
