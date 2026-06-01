## amprnet-ip44-for-asl3

Production-oriented AMPRNet IP44 deployment guide for AllStarLink 3.

คู่มือสำหรับเพื่อนนักวิทยุสมัครเล่นที่ต้องการใช้งาน AMPRNet IP44 บน AllStarLink 3 แบบใช้งานจริง

---

## Project Philosophy

- Field-tested workflow  
  ผ่านการทดสอบใช้งานจริง
- Stable after reboot  
  reboot แล้วระบบกลับมาทำงานได้เอง
- Beginner-friendly deployment  
  มือใหม่ทำตามได้จริง
- Recovery-aware operation    
  คำนึงถึงการกู้ระบบเมื่อเกิดปัญหา
- Minimal human error    
  ลดความผิดพลาดจากการตั้งค่าด้วยมือ

---

## Why This Project Exists

This project provides a practical and field-tested AMPRNet IP44 workflow for AllStarLink 3 focused on stable reboot behavior and long-term operation.

---

## Designed For

ระบบนี้เหมาะสำหรับ

- เพื่อนนักวิทยุสมัครเล่นที่เริ่มใช้งาน AMPRNet
- คนที่ต้องการให้ reboot แล้วระบบกลับมาทำงานเอง
- Node ที่ต้องการใช้งานต่อเนื่อง
- คนที่ต้องการ workflow แบบเรียบง่าย ไม่ซับซ้อน


## Tested Environment

ทดสอบใช้งานจริงแล้วกับ

- Debian 12/13
- AllStarLink 3
- Raspberry Pi 3 / 4

ทดสอบ reboot และ reconnect แล้วกลับมาทำงานได้ปกติ

---

## Installation

ก่อนเริ่ม แนะนำให้ตรวจดังนี้:

- เครื่องยังออกเน็ตได้ปกติ
- ยัง SSH เข้าเครื่องได้ปกติ

ดาวน์โหลด repository:

```bash
git clone https://github.com/E25LVV/amprnet-ip44-for-asl3.git
cd amprnet-ip44-for-asl3


---

```
# Operational Tools

## amprnet-start.sh

ใช้สำหรับเริ่มต้น AMPRNet workflow แบบมาตรฐาน

Download:

```bash id="f6m2xp"
wget -O /usr/local/bin/amprnet-start.sh https://raw.githubusercontent.com/E25LVV/amprnet-ip44-for-asl3/main/tools/amprnet-start.sh
```

กำหนดสิทธิ์ execute:

```bash id="q7v4mk"
chmod +x /usr/local/bin/amprnet-start.sh
```

วิธีใช้งาน:

```bash id="m3x8vr"
/usr/local/bin/amprnet-start.sh
```
