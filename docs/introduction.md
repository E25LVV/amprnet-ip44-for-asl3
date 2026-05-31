# Introduction

## What This Project Is

Production-oriented AMPRNet IPv4 deployment workflow for AllStarLink 3 on Debian 12/13.

Key focus
- stable reboot behavior
- long-term node operation
- beginner-friendly deployment
- real-world amateur radio operation

คู่มือสำหรับระบบ AllStarLink 3 ที่เน้นความเสถียรหลัง reboot และการใช้งานจริงระยะยาว

---

## Why This Project Exists

Many AMPRNet installation guides focus only on successful installation.

However, real-world amateur radio operation

* reboot issues
* unstable reconnect behavior
* broken routing after restart
* SSH access problems
* inconsistent startup sequences

This repository exists to reduce those operational problems using field-tested deployment methods.

หลายโหนดติดตั้งสำเร็จ เมื่อใช้งานจริงไม่เสถียรหลัง reboot
โปรเจกต์นี้จึงเน้น workflow ที่ใช้งานจริงได้ต่อเนื่อง

---

## Designed For

This repository is designed for

- Amateur radio operators using AllStarLink 3
- Raspberry Pi AllStarLink nodes
- Continuous node operation
- Beginner-friendly deployment workflows
- Nodes needing stable reboot recovery

เหมาะสำหรับ node ที่ต้องการความเสถียรหลัง reboot และใช้งานต่อเนื่องระยะยาว

---

## Project Philosophy

- Field-tested workflow  
  ผ่านการทดสอบใช้งานจริง

- Stable after reboot  
  reboot แล้วระบบกลับมาทำงานได้เอง

- Beginner-friendly deployment  
  มือใหม่ทำตามได้จริง

- Recovery-aware operation  
  ให้ความสำคัญการกู้ระบบเมื่อเกิดปัญหา

- Minimal human error  
  ลดความผิดพลาดจากการ copy

---

## Repository Structure

```text
assets/
configs/
docs/
scripts/
wget/
```

Each directory is separated by operational purpose to reduce workflow confusion and simplify long-term maintenance.

แยกโครงสร้างตามหน้าที่การใช้งาน
เพื่อให้ง่ายต่อการดูแลรักษาระยะยาว

---

## Tested Environment

Validated in real-world operation with:

* Debian 12 / 13
* AllStarLink 3
* Raspberry Pi 3 / 4
* Production node environments

ทดสอบใช้งานจริงกับระบบ AllStarLink 3 และ Raspberry Pi แล้ว

```

