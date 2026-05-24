#!/bin/bash
# ============================================================
# E25LVV V.3 — AMPRNet IP44 Production Manual
# ============================================================

# 1. Inject /etc/ipsec.conf
sudo tee /etc/ipsec.conf > /dev/null <<EOF
config setup
    charondebug="ike 1, knl 1, cfg 0"

conn amprnetvpn
    auto=add
    keyexchange=ikev1
    authby=secret
    type=transport
    left=%defaultroute
    leftprotoport=17/1701
    right=gw01.ham.in.th
    rightid=81.31.234.70
    ike=aes128-sha1-modp1024!
    esp=aes128-sha1!
EOF

# 2. Inject /etc/ipsec.secrets
sudo tee /etc/ipsec.secrets > /dev/null <<EOF
: PSK "dtdxa"
EOF

# 3. Inject /etc/xl2tpd/xl2tpd.conf
sudo tee /etc/xl2tpd/xl2tpd.conf > /dev/null <<EOF

[global]
port = 1701
access control = no

[lac amprnetvpn]
lns = gw01.ham.in.th
ppp debug = yes
pppoptfile = /etc/ppp/options.xl2tpd.client
length bit = yes
EOF

# 4. Inject /etc/ppp/options.xl2tpd.client (Strict Original Parameters)
sudo tee /etc/ppp/options.xl2tpd.client > /dev/null <<EOF
ipcp-accept-local
ipcp-accept-remote
refuse-eap
refuse-pap
require-chap
noccp
noauth
mtu 1280
mru 1280
noipdefault
# defaultroute
usepeerdns
connect-delay 5000
user "YOUR_USER_HERE"
password "YOUR_PASSWORD_HERE"
name "amprnetvpn"
debug
logfile /var/log/ppp-debug.log
EOF

# 5. Refresh architecture permission and trigger clean startup
sudo chmod 600 /etc/ipsec.secrets /etc/ppp/options.xl2tpd.client
sudo systemctl enable --now strongswan-starter
sudo systemctl enable --now xl2tpd
sleep 5

# 6. Establish primary connection tunnel

sleep 2
echo "c amprnetvpn" | sudo tee /var/run/xl2tpd/l2tp-control
echo "[+] Standard IP44 Blueprint Injection Completed."
