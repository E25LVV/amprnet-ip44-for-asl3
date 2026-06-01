## amprnet-ip44-for-asl3

Production-oriented AMPRNet IP44 deployment guide for AllStarLink 3.

คู่มือสำหรับเพื่อนนักวิทยุสมัครเล่นที่ต้องการใช้งาน AMPRNet IP44 บน AllStarLink 3

---

## Project Philosophy

- Field-tested workflow  
  ผ่านการทดสอบใช้งานจริง
- Stable after reboot  
  reboot แล้วระบบกลับมาทำงานได้เอง
- Beginner-friendly deployment  
  มือใหม่ทำตามได้จริง
- Recovery-aware operation    
  ให้ความสำคัญกับการกู้ระบบเมื่อเกิดปัญหา
- Minimal human error    
  ลดความผิดพลาดจากการตั้งค่าด้วยมือ

---
## Validation Environment

This project has been tested on:

* ASL3 Debian 12
* ASL3 Debian 13
* Real-world validation on Node 602141
* Production-style deployment testing completed

คู่มือนี้ผ่านการทดสอบใช้งานจริงบนระบบ AllStarLink 3 ทั้ง Debian 12 และ Debian 13
รวมถึงมีการ validate workflow จริงบน Node 602141 ในสภาพแวดล้อมการใช้งานจริง

แนวทางทั้งหมดใน repository นี้พัฒนาจากประสบการณ์ใช้งานจริง การเรียนรู้ และการทดลองในระบบจริง 
เพื่อช่วยให้เพื่อนๆนักวิทยุสมัครเล่นสามารถติดตั้งและเรียนรู้ได้ง่ายขึ้น 
ลดความสับสนและสามารถตรวจสอบหรือย้อนกลับการแก้ไขได้ในกรณีที่เกิดปัญหา

## Why This Project Exists

This project provides a practical and field-tested AMPRNet IP44 workflow for AllStarLink 3 focused on stable reboot behavior and long-term operation.

---

## Designed For

ระบบนี้เหมาะสำหรับ

- เพื่อนนักวิทยุสมัครเล่นที่เริ่มใช้งาน AMPRNet
- ต้องการให้ reboot แล้วระบบกลับมาทำงานเอง
- Node ที่ต้องการใช้งานต่อเนื่อง
- เพื่อนๆที่ต้องการ workflow แบบเรียบง่าย ไม่ซับซ้อน


## Tested Environment

ทดสอบใช้งานจริงแล้วกับ

- Debian 12/13
- AllStarLink 3
- Raspberry Pi 3 / 4

ทดสอบ reboot และ reconnect แล้วกลับมาทำงานได้ปกติ

---

## Installation

ก่อนเริ่ม แนะนำให้ตรวจดังนี้

- เครื่องยังออกเน็ตได้ปกติ
- ยัง SSH เข้าเครื่องได้ปกติ


ดาวน์โหลดคู่มือ

Repository
https://github.com/E25LVV/amprnet-ip44-for-asl3

Clone repository

```bash
git clone https://github.com/E25LVV/amprnet-ip44-for-asl3.git
```


Enter project directory

```bash
cd amprnet-ip44-for-asl3
```

ใช้สำหรับเปิดดูไฟล์คู่มือและ workflow ต่างๆใน repo นี้




# Operational Workflow

ลำดับการใช้งานแบบปลอดภัย

## 1. Start AMPRNet

เริ่มต้น AMPRNet tunnel และ policy routing

```bash
/usr/local/bin/amprnet-start.sh
```

---

## 2. Check Status

ตรวจสอบสถานะระบบ

```bash
/usr/local/bin/amprnet-status.sh
```

---

## 3. Stop AMPRNet

ใช้เมื่อต้องการ shutdown AMPRNet workflow

```bash
/usr/local/bin/amprnet-stop.sh
```

---

## แนวทางนี้ช่วยให้

* start/stop ระบบเป็นลำดับเดียวกันทุกครั้ง
* ลดปัญหา route ค้าง
* ตรวจสอบระบบได้ง่ายขึ้น
* debug ระบบได้ง่ายขึ้น


# Operational Tools

## amprnet-start.sh

ใช้สำหรับเริ่มต้น AMPRNet workflow แบบมาตรฐาน

Download

```bash id="f6m2xp"
wget -O /usr/local/bin/amprnet-start.sh https://raw.githubusercontent.com/E25LVV/amprnet-ip44-for-asl3/main/tools/amprnet-start.sh
```

กำหนดสิทธิ์ execute

```bash id="q7v4mk"
chmod +x /usr/local/bin/amprnet-start.sh
```

วิธีใช้งาน

```bash id="m3x8vr"
/usr/local/bin/amprnet-start.sh
```
## amprnet-stop.sh

ใช้สำหรับ shutdown AMPRNet workflow แบบมาตรฐาน

Download

```bash id="w7v2pk"
wget -O /usr/local/bin/amprnet-stop.sh https://raw.githubusercontent.com/E25LVV/amprnet-ip44-for-asl3/main/tools/amprnet-stop.sh
```

กำหนดสิทธิ์ execute

```bash id="x5m8vr"
chmod +x /usr/local/bin/amprnet-stop.sh
```

วิธีใช้งาน

```bash id="q3n7xc"
/usr/local/bin/amprnet-stop.sh
```

---

## amprnet-status.sh

ใช้ตรวจสอบสถานะ AMPRNet แบบรวมในจุดเดียว

Download

```bash id="n8v4mk"
wget -O /usr/local/bin/amprnet-status.sh https://raw.githubusercontent.com/E25LVV/amprnet-ip44-for-asl3/main/tools/amprnet-status.sh
```

กำหนดสิทธิ์ execute

```bash id="m2x5vp"
chmod +x /usr/local/bin/amprnet-status.sh
```

วิธีใช้งาน

```bash id="p6v8zr"
/usr/local/bin/amprnet-status.sh
```
---

## E25LVV Philosophy

ไม่ใช่กูรู เรียนรู้ ทดลอง แล้วแบ่งปัน

Not a guru. Learning, experimenting, and sharing.


