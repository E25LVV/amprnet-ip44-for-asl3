# AMPRNet IP44 Production Installation Guide

Field-tested workflow for:

- Debian 12
- AllStarLink 3
- Raspberry Pi
- Home NAT Internet
- AMPRNet IP44

---

## 1. Prepare Required Information

## 2. Enable IPsec Pass-through on Router

## 3. Install Required Packages

## 4. Create vpn_injector.sh

## 5. Configure Watchdog

## 6. Configure Systemd Timer

## 7. Verification

## 8. Recovery & Debugging

## 9. Final Testing

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
