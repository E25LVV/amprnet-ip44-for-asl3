```bash id="f3m8zc"
#!/bin/bash

echo "================================="
echo " E25LVV AMPRNet Tools"
echo " AMPRNet Status"
echo "================================="

echo
echo "================================="
echo " Service Status"
echo "================================="

systemctl --no-pager --full status amprnet-autostart.service

echo

systemctl --no-pager --full status amprnet-policy-routing.service

echo
echo "================================="
echo " Tunnel Interface"
echo "================================="

ip addr show ppp0

echo
echo "================================="
echo " IP Rule"
echo "================================="

ip rule

echo
echo "================================="
echo " Route"
echo "================================="

ip route

echo
echo "================================="
echo " Watchdog Timer"
echo "================================="

systemctl --no-pager --full status amprnet-watchdog.timer

echo
echo "================================="
echo " Status check completed"
echo " E25LVV"
echo "================================="
```
