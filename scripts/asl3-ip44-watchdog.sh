#!/bin/bash
# ============================================================
# E25LVV V.3 — ASL3 AMPRNet IP44 Watchdog
# ============================================================


# ============================================================
# VARIABLES
# ============================================================

VPN_IFACE="ppp0"
VPN_CONN_NAME="amprnetvpn"

MY_IP44="44.xx.xx.xx"
RT_TABLE="200"
# ============================================================
# SERVICE BOOTSTRAP
# ============================================================

# Ensure VPN-related services are running
sudo systemctl start strongswan-starter xl2tpd

# Allow services time to initialize
sleep 8
# ============================================================
# CONTROL SOCKET VALIDATION
# ============================================================

# Validate xl2tpd control socket availability
if [ ! -p /var/run/xl2tpd/l2tp-control ]; then
    echo "xl2tpd control socket missing"
    exit 1
fi
# ============================================================
# VPN TRIGGER
# ============================================================

# Trigger VPN connection through xl2tpd control socket
echo "c $VPN_CONN_NAME" | sudo tee /var/run/xl2tpd/l2tp-control

# Allow tunnel negotiation time
sleep 10
# ============================================================
# INTERFACE VALIDATION
# ============================================================

# Verify VPN interface exists
if ip link show "$VPN_IFACE" > /dev/null 2>&1; then

    # ============================================================
    # CURRENT IP DETECTION
    # ============================================================

    # Read current IP address from VPN interface
    CURRENT_IP=$(ip -4 addr show "$VPN_IFACE" | grep inet | awk '{print $2}' | cut -d/ -f1)

    # Ensure IP was successfully detected
if [ -z "$CURRENT_IP" ]; then
    echo "VPN IP detection failed"
    exit 1
fi

fi

# =========================================================
# ROUTING ENGINE
# =========================================================

# Remove old duplicate rules before rebuilding
sudo ip rule del from "$MY_IP44" table "$RT_TABLE" 2>/dev/null

# Rebuild routing policy for IP44 traffic
sudo ip rule add from "$MY_IP44" table "$RT_TABLE"

# Flush old routes from routing table
sudo ip route flush table "$RT_TABLE"

# Install default route through VPN interface
sudo ip route add default dev "$VPN_IFACE" table "$RT_TABLE"

# =========================================================
# ROUTE VERIFICATION
# =========================================================

# Verify policy route installation
ip rule show | grep "$MY_IP44"

# Verify routing table contents
ip route show table "$RT_TABLE"

# Display active VPN interface address
ip addr show "$VPN_IFACE"

# =========================================================
# FINAL STATUS
# =========================================================

echo "==============================================="
echo "[+] ASL3 IP44 Watchdog Completed Successfully"
echo "[+] VPN Interface : $VPN_IFACE"
echo "[+] Current IP44  : $CURRENT_IP"
echo "[+] Routing Table : $RT_TABLE"
echo "==============================================="
