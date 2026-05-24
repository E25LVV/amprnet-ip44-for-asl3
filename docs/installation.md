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

## 4. Create vpn_injector.sh

## 5. Configure Watchdog

## 6. Configure Systemd Timer

## 7. Verification

## 8. Recovery & Debugging

## 9. Final Testing


