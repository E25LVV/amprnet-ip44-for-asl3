```bash id="z5m2vc"
#!/bin/bash

echo "================================="
echo " E25LVV AMPRNet Tools"
echo " Stopping AMPRNet Lifecycle"
echo "================================="

echo
echo "[1/2] Stopping policy routing..."
systemctl stop amprnet-policy-routing.service

echo
echo "[2/2] Stopping AMPRNet tunnel..."
systemctl stop amprnet-autostart.service

echo
echo "================================="
echo " Service Status"
echo "================================="

systemctl --no-pager --full status amprnet-policy-routing.service

echo

systemctl --no-pager --full status amprnet-autostart.service

echo
echo "================================="
echo " Current IP Rule"
echo "================================="

ip rule

echo
echo "================================="
echo " Current Route"
echo "================================="

ip route

echo
echo "================================="
echo " AMPRNet shutdown completed"
echo " E25LVV"
echo "================================="
```
