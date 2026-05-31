# AMPRNet IP44 Production Installation Guide

Field-tested workflow for

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

ข้อมูลส่วนกลางของระบบ

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

ขั้นตอนทั่วไป

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

Package ที่ใช้งานในคู่มือชุดนี้

- strongSwan → ใช้สำหรับสร้าง IPsec tunnel
- xl2tpd → ใช้สำหรับเชื่อมต่อ L2TP
- ppp → ใช้สร้าง interface ppp0
- ufw → ใช้สำหรับจัดการ firewall เบื้องต้น

หมายเหตุ

- แนะนำให้ reboot หลัง update package จำนวนมาก
- หากระบบกำลังใช้งาน node จริง ควรทำในช่วงที่ไม่มี QSO
- บางระบบอาจใช้เวลาติดตั้ง package หลายนาที

## 4. Create vpn_injector.sh

ขั้นตอนนี้จะเป็นการสร้าง script สำหรับ inject ค่า config หลักของระบบ IP44

เริ่มต้นด้วยการสร้างไฟล์

```bash
nano vpn_injector.sh
```

จากนั้นคัดลอก script ด้านล่างไปวางในคราวเดียว

หมายเหตุ:

- แก้ไขเฉพาะ
  - VPN_USER
  - VPN_PASSWORD
  - YOUR_IP44
- ไม่แนะนำให้แก้ parameter อื่น หากยังไม่เข้าใจหน้าที่ของแต่ละส่วน
- Script นี้จะ overwrite config เดิมบางไฟล์ ควรตรวจสอบระบบก่อนใช้งาน

```bash
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
# Inject /etc/ppp/options.xl2tpd.client
sudo tee /etc/ppp/options.xl2tpd.client > /dev/null <<EOF
ipcp-accept-local
ipcp-accept-remote
refuse-eap
require-chap
noccp
noauth
mtu 1410
mru 1410
noipdefault
defaultroute
usepeerdns
connect-delay 5000
name "$VPN_USER"
password "$VPN_PASSWORD"
persist
maxfail 0
holdoff 5
EOF

# Restart services
sudo systemctl restart strongswan-starter
sudo systemctl restart xl2tpd

# Enable services at boot
sudo systemctl enable strongswan-starter
sudo systemctl enable xl2tpd

echo "=================================================="
echo "AMPRNet IP44 configuration injected successfully"
echo "=================================================="
```
```

## 5. Configure Watchdog

watchdog script ใช้สำหรับตรวจสอบว่า tunnel และ ppp0 ยังทำงานปกติหรือไม่

หากระบบตรวจพบว่า

- ppp0 หาย
- ping gateway ไม่ได้
- tunnel หลุด
- route พัง

ระบบจะพยายาม reconnect อัตโนมัติ

เริ่มต้นด้วยการดาวน์โหลด watchdog script

```bash
cd /usr/local/bin

sudo wget -O amprnet-watchdog.sh \
https://raw.githubusercontent.com/E25LVV/amprnet-ip44-for-asl3/main/scripts/amprnet-watchdog.sh
```

กำหนด permission

```bash
sudo chmod +x /usr/local/bin/amprnet-watchdog.sh
```

ทดสอบ run script ด้วยตนเอง

```bash
sudo /usr/local/bin/amprnet-watchdog.sh
```

หมายเหตุ

- script จะ reconnect tunnel อัตโนมัติเมื่อพบปัญหา
- หากใช้งานร่วมกับ EchoLink หรือ AllStarLink bridge แนะนำให้ monitor ช่วงแรกหลังติดตั้ง
- หาก Router reboot บ่อย อาจทำให้ tunnel reconnect ใช้เวลานานขึ้น

## 6. Configure Systemd Timer

systemd timer จะใช้สำหรับ run watchdog script เป็นระยะ
เพื่อช่วยตรวจสอบว่า tunnel และ ppp0 ยังทำงานปกติ

สร้าง service file:

```bash
sudo nano /etc/systemd/system/amprnet-watchdog.service
```

วางข้อมูลด้านล่าง

```ini
[Unit]
Description=AMPRNet IP44 Watchdog

[Service]
Type=oneshot
ExecStart=/usr/local/bin/amprnet-watchdog.sh
```

สร้าง timer file:

```bash
sudo nano /etc/systemd/system/amprnet-watchdog.timer
```

วางข้อมูลด้านล่าง:

```ini
[Unit]
Description=Run AMPRNet Watchdog Every 1 Minute

[Timer]
OnBootSec=30
OnUnitActiveSec=60
Unit=amprnet-watchdog.service

[Install]
WantedBy=timers.target
```

reload systemd:

```bash
sudo systemctl daemon-reload
```

enable timer:

```bash
sudo systemctl enable --now amprnet-watchdog.timer
```

ตรวจสอบสถานะ timer:

```bash
systemctl status amprnet-watchdog.timer
```

ดูรายการ timer ทั้งหมด

```bash
systemctl list-timers
```

หมายเหตุ

- watchdog จะทำงานทุก 60 วินาที
- หาก tunnel มีปัญหา ระบบจะพยายาม reconnect อัตโนมัติ
- ไม่แนะนำให้ตั้ง interval ต่ำเกินไป เพราะอาจทำให้ reconnect ถี่เกินจำเป็น

## 7. Verification

หลังติดตั้งเสร็จ ควรตรวจสอบว่า

- IPsec tunnel ทำงาน
- ppp0 ถูกสร้าง
- route ถูก inject
- watchdog ทำงานปกติ

---

## ตรวจสอบ IPsec status

```bash
sudo ipsec status
```

ควรเห็น:

```text
ESTABLISHED
```

---

## ตรวจสอบ interface ppp0

```bash
ip a
```

ควรเห็น interface:

```text
ppp0
```

---

## ตรวจสอบ routing table

```bash
ip route
```

ตรวจสอบว่า route ของ IP44 ถูกสร้างแล้ว

---

## ทดสอบ ping gateway

```bash
ping 44.32.81.1
```

หาก tunnel ปกติ ควร reply ได้

---

## ทดสอบ ping ออก Internet ผ่าน tunnel

```bash
ping 44.32.81.1
```

---

## ตรวจสอบ watchdog timer

```bash
systemctl status amprnet-watchdog.timer
```

ควรเห็น:

```text
active (waiting)
```

---

## ตรวจสอบ watchdog log

```bash
journalctl -u amprnet-watchdog.service -n 20
```

---

## ตรวจสอบ xl2tpd log

```bash
journalctl -u xl2tpd -n 50
```

---

## ตรวจสอบ strongSwan log

```bash
journalctl -u strongswan-starter -n 50
```

หมายเหตุ

- บางระบบอาจใช้เวลา 10-30 วินาที กว่า ppp0 จะขึ้น
- หาก reboot Router tunnel อาจ reconnect ช้าชั่วคราว
- ช่วงแรกหลังติดตั้ง แนะนำให้ monitor log ระยะหนึ่งก่อนใช้งานจริง
## 8. Recovery & Debugging

หาก tunnel ไม่ทำงาน หรือ ppp0 ไม่ขึ้น
สามารถตรวจสอบตามอาการด้านล่างนี้ได้

---

## กรณี ppp0 ไม่ถูกสร้าง

ตรวจสอบ service:

```bash
sudo systemctl status xl2tpd
```

ลอง restart:

```bash
sudo systemctl restart xl2tpd
```

จากนั้นตรวจสอบอีกครั้ง:

```bash
ip a
```

---

## กรณี tunnel ไม่ ESTABLISHED

ตรวจสอบ IPsec status:

```bash
sudo ipsec status
```

ลอง restart strongSwan:

```bash
sudo systemctl restart strongswan-starter
```

ตรวจสอบ log:

```bash
journalctl -u strongswan-starter -n 50
```

---

## กรณี ping gateway ไม่ได้

ตรวจสอบ:

```bash
ip route
```

และ:

```bash
ip a
```

หากไม่มี ppp0
แสดงว่า PPP tunnel ยังไม่เชื่อมต่อ

---

## กรณี watchdog reconnect ไม่ทำงาน

ทดสอบ run script ด้วยตนเอง:

```bash
sudo /usr/local/bin/amprnet-watchdog.sh
```

ตรวจสอบ timer:

```bash
systemctl status amprnet-watchdog.timer
```

ตรวจสอบ log:

```bash
journalctl -u amprnet-watchdog.service -n 20
```

---

## กรณี reboot แล้ว tunnel ไม่กลับมา

ลอง restart service:

```bash
sudo systemctl restart strongswan-starter
sudo systemctl restart xl2tpd
```

จากนั้นรอประมาณ 10-30 วินาที

---

## กรณี route พัง หรือ SSH หลุด

หลีกเลี่ยงการเปลี่ยน default route ของระบบ

คู่มือชุดนี้ออกแบบให้

- internet ปกติ วิ่งออก gateway เดิม
- traffic AMPRNet/IP44 วิ่งผ่าน ppp0

หากเปลี่ยน default route อาจทำให้

- SSH หลุด
- Allmon3 เข้าไม่ได้
- เกิด one-way audio
- tunnel reconnect ผิดเส้นทาง

---

## ดู log แบบ realtime

xl2tpd:

```bash
journalctl -fu xl2tpd
```

strongSwan:

```bash
journalctl -fu strongswan-starter
```

watchdog:

```bash
journalctl -fu amprnet-watchdog.service
```

หมายเหตุ

- บาง Router จะ reconnect tunnel ช้าหลัง reboot
- ISP บางรายอาจ block หรือ delay IPsec traffic
- หากใช้งาน CGNAT tunnel อาจไม่เสถียร
- หาก tunnel reconnect บ่อย ควรตรวจสอบ Router และ Internet stability ก่อน
  
## 9. Final Testing

หลังจากติดตั้งและตรวจสอบครบทุกขั้นตอนแล้ว
แนะนำให้ทดสอบการใช้งานจริงผ่านเครือข่าย IP44

---

## ทดสอบ SSH ผ่าน IP44

เปิดโปรแกรม SSH เช่น PuTTY
แล้วเชื่อมต่อไปยังหมายเลข IP44 ของ node

ตัวอย่าง

```text
44.xx.xx.xx
```

หากเชื่อมต่อได้
แสดงว่า tunnel และ routing ทำงานปกติ

---

## ทดสอบ Internet จากภายใน tunnel

หลัง login ผ่าน IP44 แล้ว
ลองทดสอบ

```bash
ping google.com
```

และ

```bash
curl ifconfig.me
```

---

## ทดสอบ Allmon3

เปิดเว็บเบราว์เซอร์ แล้วเข้า

```text
http://YOUR-IP44-ADDRESS
```

ตัวอย่าง

```text
http://44.xx.xx.xx
```

หากสามารถ login และดูสถานะ node ได้
แสดงว่า:

- routing ทำงานปกติ
- tunnel ทำงานสมบูรณ์
- web access ผ่าน IP44 ใช้งานได้

---

## ทดสอบ watchdog recovery

สามารถทดลอง

- restart Router
- restart xl2tpd
- disconnect Internet ชั่วคราว
หลัง reconnect อาจใช้เวลาประมาณ 10-30 วินาที
ขึ้นอยู่กับ Router และ ISP

จากนั้นตรวจสอบว่า

- ppp0 กลับมา
- tunnel reconnect ได้
- watchdog ทำงานปกติ

---

## สรุป

หากทุกขั้นตอนทำงานปกติ
ระบบ AMPRNet IP44 ของท่านก็พร้อมใช้งานร่วมกับ:

- AllStarLink 3
- EchoLink
- Allmon3
- remote maintenance ผ่าน IP44

คู่มือชุดนี้พัฒนาจาก workflow ภาคสนามที่ใช้งานจริง
โดยคงแนวทางเดิมไว้ให้มากที่สุด
และปรับเฉพาะจุดที่จำเป็นเพื่อให้ง่ายต่อการติดตั้งและดูแลระบบระยะยาว

ขอให้สนุกกับการพัฒนา node และระบบสื่อสารของท่าน

73
E25LVV

