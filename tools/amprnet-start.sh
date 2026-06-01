```bash
#!/bin/bash

echo "================================="
echo " E25LVV AMPRNet Tools"
echo " Starting AMPRNet Lifecycle"
echo "================================="

echo
echo "[1/2] Starting AMPRNet tunnel..."
systemctl start amprnet-autostart.service

echo
echo "[2/2] Applying policy routing..."
systemctl start amprnet-policy-routing.service

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
echo " AMPRNet startup completed"
echo " E25LVV"
echo "================================="
```
