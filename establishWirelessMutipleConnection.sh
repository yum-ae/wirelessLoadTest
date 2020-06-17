SSID="GL-AR750S-a6a-Guest"
# File descriptor may hit the ceiling.
# sudo nano /etc/systemd/system/dbus-fi.w1.wpa_supplicant1.service 
# [Service]
# LimitNOFILE=4096 <- add

# creating too many (more than 140) vif at once, may cause buffer overflow of wpa_supplicant
date
sudo systemctl stop NetworkManager
for i in $(seq -w 16 255); do
    echo "vwlan$i"
    hex=$(echo "obase=16; $i" | bc)
    echo "aa:bb:00:dd:ee:"$hex
    sudo iw phy0 interface add vwlan$i type managed addr aa:bb:00:dd:ee:$hex
done
# After interface activation, it requires about 9 seconds to connect to an AP
for i in $(seq -w 16 255); do
    date
    sudo wpa_supplicant -i vwlan$i -c ./wpa_supplicant.conf  &  # -dddt for debug -B for bg op, but no stdout
    sleep 10
    sudo dhclient vwlan$i &
    echo "dhcp on vwlan$i" &
done
# to delete interface `sudo iw dev vwlan0 del`
# write out csv to be used in JMeter
sleep 20
ip -4 a | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v "127.0.0.1" > ipaddr.csv