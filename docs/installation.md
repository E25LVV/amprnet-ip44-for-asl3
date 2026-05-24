# AMPRNet IP44 Production Installation Guide

Field-tested workflow for:

- Debian 12
- AllStarLink 3
- Raspberry Pi
- Home NAT Internet
- AMPRNet IP44

---
## Overview

คู่มือฉบับนี้เป็น workflow ภาคสนามสำหรับติดตั้ง AMPRNet IP44
บนระบบ Debian 12 + AllStarLink 3 โดยเน้นการใช้งานจริง
กับ Raspberry Pi และ Home NAT Internet

แนวทางชุดนี้พัฒนาจากการทดลองใช้งานจริง
รวมถึงการแก้ปัญหาในสภาพแวดล้อมจริง เช่น

- one-way audio
- route พังหลัง reboot
- ppp0 ไม่ reconnect
- VPN ค้าง
- Allmon3 เข้าไม่ได้
- SSH หลุดหลังเชื่อมต่อ IP44

คู่มือชุดนี้ยังคง workflow เดิมที่เผยแพร่ก่อนหน้าไว้ให้มากที่สุด
เพื่อให้ผู้ที่เคยใช้งานสามารถต่อยอดและ troubleshooting ได้ต่อเนื่อง

ระบบนี้ออกแบบมาสำหรับ:

- Raspberry Pi
- Debian 12/13
- AllStarLink 3
- Home NAT Internet
- IPsec/L2TP AMPRNet topology

Known limitations:

- ยังไม่รองรับ Docker
- ยังไม่เหมาะกับ CGNAT ISP
- ยังไม่รองรับ Dual WAN
- Mikrotik FastTrack อาจทำให้ tunnel มีปัญหา
- OpenWRT policy routing ขั้นสูง อาจต้องปรับเพิ่มเติม



## 1. Prepare Required Information

ก่อนเริ่มติดตั้ง ให้เตรียมข้อมูลส่วนตัวของสถานีให้พร้อม

คู่มือชุดนี้ใช้ข้อมูลหลักเพียงไม่กี่รายการ
โดยค่ากลางของระบบ AMPRNet ถูกกำหนดไว้ให้แล้ว

กรุณาเตรียมข้อมูลดังนี้

```bash
VPN_USER="your-vpn-user"
VPN_PASSWORD="your-vpn-password"
YOUR_IP44="44.xx.xx.xx"
```

ตัวอย่าง:

```bash
VPN_USER="e25lvv-node"
VPN_PASSWORD="MySecretPass123"
YOUR_IP44="44.32.81.xx"
```

ข้อมูลส่วนกลางของระบบ:

```bash
GATEWAY_HOST="gw01.ham.in.th"
GATEWAY_IP="81.31.234.70"
IPSEC_KEY="dtdxa"
IP44_GATEWAY_INTERNAL="44.32.81.1"
```

หมายเหตุ:

- ควรตรวจสอบหมายเลข IP44 ให้ถูกต้องก่อนเริ่มติดตั้ง
- แนะนำให้บันทึกข้อมูลไว้ก่อน reboot หรือปรับแต่งระบบ
- หากกรอก IP44 ผิด อาจทำให้ routing ทำงานผิดพลาด

## 2. Enable IPsec Pass-through on Router

ก่อนเริ่มพิมพ์คำสั่งลงบน Raspberry Pi
ควรเปิดใช้งาน IPsec Pass-through บน Router อินเทอร์เน็ตบ้านก่อน

Router บางรุ่นอาจเรียกชื่อเมนูต่างกัน เช่น:

- VPN Pass-through
- IPsec Pass-through
- VPN Helper
- ALG Settings

ขั้นตอนทั่วไป:

1. เปิดเว็บเบราว์เซอร์ แล้วเข้าสู่หน้าตั้งค่าของ Router
2. ไปที่เมนู Security / Firewall / Advanced Settings
3. มองหาหัวข้อ VPN Pass-through หรือ ALG
4. เปิดใช้งาน:
   - IPsec Pass-through
   - L2TP Pass-through
5. กดบันทึก (Save) แล้ว reboot Router หากจำเป็น

หมายเหตุ:

- นักวิทยุสมัครเล่นหลายสถานีอาจเปิดใช้งานส่วนนี้ไว้อยู่แล้ว
- หากไม่ได้เปิด IPsec Pass-through อาจทำให้ tunnel เชื่อมต่อไม่สมบูรณ์
- บาง Router ต้อง reboot หลังเปลี่ยนค่า

## 3. Install Required Packages

เชื่อมต่อ SSH เข้าไปยัง Raspberry Pi หรือระบบ AllStarLink 3 ของท่าน
จากนั้นอัปเดตระบบและติดตั้ง package ที่จำเป็น

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install strongswan xl2tpd ppp ufw -y
```

Package ที่ใช้งานในคู่มือชุดนี้:

- strongSwan → ใช้สำหรับสร้าง IPsec tunnel
- xl2tpd → ใช้สำหรับเชื่อมต่อ L2TP
- ppp → ใช้สร้าง interface ppp0
- ufw → ใช้สำหรับจัดการ firewall เบื้องต้น

หมายเหตุ:

- แนะนำให้ reboot หลัง update package จำนวนมาก
- หากระบบกำลังใช้งาน node จริง ควรทำในช่วงที่ไม่มี QSO
- บางระบบอาจใช้เวลาติดตั้ง package หลายนาที

## 4. Create vpn_injector.sh

ขั้นตอนนี้จะเป็นการสร้าง script สำหรับ inject ค่า config หลักของระบบ IP44

เริ่มต้นด้วยการสร้างไฟล์:

```bash
nano vpn_injector.sh
```

จากนั้นคัดลอก script ด้านล่างไปวางในคราวเดียว

หมายเหตุ:

- แก้ไขเฉพาะ:
  - VPN_USER
  - VPN_PASSWORD
  - YOUR_IP44
- ไม่แนะนำให้แก้ parameter อื่น หากยังไม่เข้าใจหน้าที่ของแต่ละส่วน
- Script นี้จะ overwrite config เดิมบางไฟล์ ควรตรวจสอบระบบก่อนใช้งาน
- ```bash
#!/bin/bash

# ============================================================
# E25LVV — AMPRNet IP44 Production Workflow
# ============================================================

VPN_USER="your-vpn-user"
VPN_PASSWORD="your-vpn-password"
YOUR_IP44="44.xx.xx.xx"

# Backup existing configuration
sudo cp /etc/ipsec.conf /etc/ipsec.conf.bak 2>/dev/null
sudo cp /etc/ipsec.secrets /etc/ipsec.secrets.bak 2>/dev/null
sudo cp /etc/xl2tpd/xl2tpd.conf /etc/xl2tpd/xl2tpd.conf.bak 2>/dev/null
sudo cp /etc/ppp/options.xl2tpd.client /etc/ppp/options.xl2tpd.client.bak 2>/dev/null

# Inject /etc/ipsec.conf
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

# Inject /etc/ipsec.secrets
sudo tee /etc/ipsec.secrets > /dev/null <<EOF
: PSK "dtdxa"
EOF

# Inject /etc/xl2tpd/xl2tpd.conf
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
```

## 5. Configure Watchdog

## 6. Configure Systemd Timer

## 7. Verification

## 8. Recovery & Debugging

## 9. Final Testing


