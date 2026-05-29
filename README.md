## amprnet-ip44-for-asl3

Production-oriented AMPRNet IP44 deployment guide for AllStarLink 3.

คู่มือนี้จัดทำขึ้นเพื่อเพื่อนๆนักวิทยุสมัครเล่นที่ต้องการใช้งาน AMPRNet IP44 บน AllStarLink 3 แบบใช้งานจริงต่อเนื่อง ไม่ใช่เพียงแค่ติดตั้งผ่านเท่านั้น

---

## Project Philosophy

Repository นี้ถูกออกแบบด้วยแนวคิด

* ใช้งานจริงได้
* reboot แล้วกลับมาทำงานเอง
* ลดการแก้ปัญหาด้วยมือ
* เหมาะสำหรับสถานีวิทยุสมัครเล่นที่เปิดใช้งานต่อเนื่อง
* ลดความซับซ้อนของ Linux ช่วยให้เพื่อนนักวิทยุสมัครเล่นเข้าใจง่ายขึ้น

แนวทางของโปรเจกต์นี้คือ


> "ไม่ใช่แค่ติดตั้งได้ แต่ต้องใช้งานจริงได้อย่างเสถียร"


---

## Why This Project Exists

เพื่อนนักวิทยุสมัครเล่นบางท่านอาจติดตั้ง AMPRNet ได้สำเร็จ
แต่หลัง reboot ระบบกลับไม่ทำงานเหมือนเดิม

ปัญหาที่พบบ่อย

* reboot แล้ว route หาย
* service ไม่เริ่มเอง
* VPN เชื่อมต่อไม่สมบูรณ์
* ต้องแก้ปัญหาด้วยมือทุกครั้ง
* ใช้งานระยะยาวแล้วระบบไม่เสถียร

Repository นี้จึงเน้น

* Production Persistence
* Reboot Validation
* Operational Stability
* Field-Tested Deployment
* Beginner-Friendly Workflow

---

## Designed For

ระบบนี้เหมาะสำหรับ

* AllStarLink 3 (ASL3)
* Debian 12 / Debian 13
* Raspberry Pi
* Mini PC
* Amateur Radio Node Operation
* 24/7 Continuous Operation

---

## Field-Tested Notes

คู่มือนี้ไม่ได้อ้างอิงเพียงเอกสารทฤษฎี

แต่ผ่านการเรียนรู้ ทดสอบจริงบนโหนดใช้งานจริง

รวมถึง

* reboot test
* route persistence test
* long-duration operation
* manual recovery testing
* production restart validation

โดยมีการทดสอบจริงบน ASL3 nodes เช่น

* Node 416005,602141
* HUB 64677
* HUB 416000

---


## Beginner-Friendly Workflow

แนวทางของ E25LVV ecosystem คือ

* อธิบายด้วยภาษาที่นักวิทยุสมัครเล่นเข้าใจ
* ลดศัพท์ Linux ที่ไม่จำเป็น
* มีคำอธิบายก่อนใช้คำสั่ง
* มีขั้นตอนตรวจสอบผลลัพธ์
* เน้น wget-ready workflow หากทำได้
* ลด human error ให้มากที่สุด

---

## Quick Start

หัวข้อนี้เหมาะสำหรับผู้ที่ต้องการเริ่มติดตั้ง AMPRNet IP44 บน AllStarLink 3 แบบพื้นฐาน

ก่อนเริ่ม ควรทราบว่า

* คู่มือนี้ทดสอบบน Debian 12 / Debian 13
* เหมาะสำหรับ AllStarLink 3 (ASL3)
* ควรมีสิทธิ์ sudo
* ควรเชื่อมต่ออินเทอร์เน็ตได้ปกติ
* ควร update ระบบก่อนเริ่มติดตั้ง

---

## Update System

เพื่อให้ package และส่วนประกอบที่ระบบต้องใช้เป็นเวอร์ชันล่าสุด

รันคำสั่ง

```bash
sudo apt update && sudo apt upgrade -y
```

หากระบบทำงานปกติ จะไม่พบ error สีแดงจำนวนมาก

---

## Download Repository

ปัจจุบันสามารถดาวน์โหลด repository ด้วย git clone ได้ก่อน

```bash
git clone https://github.com/E25LVV/amprnet-ip44-for-asl3.git
cd amprnet-ip44-for-asl3
```

ในอนาคต repository นี้จะเพิ่ม wget-ready installation workflow
เพื่อลดความผิดพลาดจากการ copy คำสั่งทีละบรรทัด

---

## Verify Internet Connectivity

ก่อนเริ่มติดตั้ง ควรตรวจสอบว่าเครื่องสามารถออกอินเทอร์เน็ตได้ปกติ

ทดสอบด้วยคำสั่ง

```bash
ping -c 4 google.com
```

หากระบบปกติ ควรเห็น reply กลับมา และไม่มี packet loss จำนวนมาก

---

## Recommended Before Installation

ก่อนติดตั้งจริง แนะนำให้

* reboot node ให้เรียบร้อยก่อนเริ่ม
* ปิด script เก่าที่อาจชนกัน
* ตรวจสอบว่าไม่มี AMPRNet workflow เดิมค้างอยู่
* backup ข้อมูลสำคัญก่อนเสมอ

แนวคิดของ repository นี้คือ

> "ลดการแก้ปัญหาภายหลัง ด้วยการเตรียมระบบให้เรียบร้อยก่อนเริ่ม"

---

## Manual Verification

ก่อน reboot หรือเริ่มใช้งานจริง ควรตรวจสอบก่อนว่าระบบหลักสามารถทำงานได้จริง

ขั้นตอนนี้สำคัญมาก เพราะช่วยแยกปัญหาได้ว่า

* ปัญหาเกิดจาก script หรือคำสั่งเริ่มระบบ
 
หากข้ามขั้นตอนนี้ไป อาจทำให้ troubleshooting ยากขึ้นมากในภายหลัง

---

## Verify Service Status

ตรวจสอบว่า service หลักยังทำงานปกติ

รันคำสั่ง

```bash
systemctl status ampr-ripd
```

หากระบบปกติ ควรเห็น

```text
active (running)
```

หากพบว่า service ไม่ทำงาน ควรแก้ปัญหาก่อน reboot

---

## Verify Interface and Routing

ตรวจสอบว่าช่องทางเครือข่ายของ AMPRNet ถูกสร้างขึ้นแล้ว

รันคำสั่ง

```bash
ip addr
ip route
```

หากระบบปกติ ควรเห็น IP44 route และ network path ของ 44Net

* AMPRNet IP44 interface
* route ของเครือข่าย 44Net
* network path ทำงานครบ

หาก route ยังไม่มา แสดงว่าระบบยังไม่พร้อมใช้งานจริง

---

## Manual Startup Test

ก่อน reboot ควรทดลองเรียก startup workflow ด้วยมือก่อน

ตัวอย่าง

```bash
sudo /usr/local/bin/amprnet-start.sh
```

จากนั้นตรวจสอบอีกครั้ง:

```bash
ip addr
ip route
```

เหตุผลของขั้นตอนนี้

ช่วยยืนยันว่า script สามารถทำงานได้จริง
ก่อนนำไปทดสอบตอน reboot จริง

---

## Recommended Mindset

Repository นี้เน้นแนวคิด

> "ตรวจสอบก่อน reboot ดีกว่า reboot แล้วค่อยเดาอาการ"

---

## Reboot Validation

หลังติดตั้งและการตรวจสอบแบบ manual ผ่านแล้ว
ยังไม่ควรสรุปว่าระบบพร้อมใช้งานจริงทันที

ขั้นตอนสำคัญต่อไปคือ

> "พิสูจน์ว่า reboot แล้วระบบยังกลับมาทำงานเองได้"

นี่คือหัวใจของ Production Persistence
หมายถึง reboot แล้วระบบยังกลับมาทำงานได้เอง โดยไม่ต้องแก้มือ

---

## Why Reboot Validation Matters

ปัญหาที่พบบ่อยในระบบ AMPRNet IP44

* reboot แล้ว route หาย
* service ไม่เริ่มเอง
* VPN เชื่อมต่อไม่สมบูรณ์
* ระบบเครือข่ายเริ่มทำงานไม่พร้อมกับ service
* ต้องแก้ปัญหาด้วยมือทุกครั้งหลังเปิดเครื่อง

ดังนั้น หากยังไม่ผ่าน reboot validation
ยังไม่ควรถือว่าระบบพร้อมใช้งานจริง

---

## First Reboot Test

หลัง manual verification ผ่านแล้ว

ให้ reboot ระบบ 1 ครั้ง

```bash id="fru53x"
sudo reboot
```

หลังเครื่องเปิดกลับมาปกติแล้ว
อย่าเพิ่งสรุปว่าปกติทันที

ควรตรวจสอบทุกส่วนอีกครั้ง

---

## Verify Service After Reboot

ตรวจสอบว่า service หลักกลับมาทำงานเอง

รันคำสั่ง

```bash id="d8gxpj"
systemctl status ampr-ripd
```

หากปกติ ควรเห็น

```text id="r6pnw6"
active (running)
```

หาก service ไม่เริ่มเอง
ควรแก้ปัญหาก่อนนำไปใช้งานจริง

---

## Verify Route After Reboot

ตรวจสอบว่า route ของ AMPRNet IP44 กลับมาครบ

รันคำสั่ง

```bash id="vf9y84"
ip route
```

หากระบบทำงานปกติ ควรเห็น

* route ของ 44Net
* network path กลับมาครบ
* routing ทำงานต่อเนื่อง

หาก reboot แล้ว route หาย
แสดงว่า Production Persistence ยังไม่สมบูรณ์

---

## Verify Interface After Reboot

ตรวจสอบว่า interface ของ AMPRNet ยังกลับมาปกติ

รันคำสั่ง

```bash id="jlwm2u"
ip addr
```

หากปกติ ควรเห็น

* IP44 address
* network interface ของ AMPRNet
* tunnel interface ทำงานปกติ

---

## Recommended Real-World Test

ไม่ควร reboot ทดสอบเพียงครั้งเดียว

แนะนำ

* reboot test ครั้งที่ 1
* reboot test ครั้งที่ 2
* reboot test ครั้งที่ 3

เพื่อพิสูจน์ว่า

* ระบบเสถียรจริง
* route กลับมาสม่ำเสมอ
* service recovery ทำงานจริง
* เหมาะสำหรับใช้งานต่อเนื่อง

---

## Field-Tested Notes

แนวทางนี้ผ่านการทดสอบจริงบน ASL3 nodes หลายระบบ

รวมถึง

* Node 416005,602141
* HUB 64677
* HUB 416000

โดยพบว่า

> "การติดตั้งสำเร็จ ไม่ได้หมายความว่า reboot แล้วจะกลับมาสมบูรณ์เสมอไป"

ดังนั้น reboot validation จึงเป็นขั้นตอนสำคัญมาก

---

## Recommended Operational Mindset

Repository นี้ยึดแนวคิด

> "ระบบที่ใช้งานจริง ต้องกลับมาทำงานเองได้หลัง reboot"

---

## Hardening-3

หลังจากระบบผ่านขั้นตอน

* Quick Start
* Manual Verification
* Reboot Validation

ขั้นตอนต่อไปคือการตรวจสอบว่าระบบพร้อมสำหรับใช้งานจริงต่อเนื่องหรือไม่

Hardening-3 คือการตรวจสอบว่า ระบบมีความเสถียรเพียงพอสำหรับใช้งานจริงหรือไม่

* ระบบเสถียรหรือไม่
* reboot แล้วกลับมาปกติหรือไม่
* route กลับมาสม่ำเสมอหรือไม่
* service recovery ทำงานจริงหรือไม่
* มีอาการผิดปกติระยะยาวหรือไม่

---

## Verify Multiple Reboots

ไม่ควร reboot ทดสอบเพียงครั้งเดียว

แนะนำ:

* reboot ครั้งที่ 1
* reboot ครั้งที่ 2
* reboot ครั้งที่ 3

หลัง reboot ทุกครั้ง ควรตรวจสอบว่า

```bash
systemctl status ampr-ripd
ip addr
ip route
```

หากทุกครั้งกลับมาปกติสม่ำเสมอ
จึงเริ่มถือได้ว่าระบบมีความเสถียรสำหรับใช้งานจริง

---

## Verify Service Recovery

ตรวจสอบว่า service สามารถกลับมาทำงานเองได้

รันคำสั่ง

```bash
systemctl status ampr-ripd
```

หากระบบปกติ ควรเห็น

```text
active (running)
```

หาก service หยุดเอง หรือไม่เริ่มหลัง reboot
ควรแก้ปัญหาก่อนใช้งานจริง

---

## Verify Route Persistence

ตรวจสอบว่า route ของ 44Net กลับมาครบทุกครั้ง

รันคำสั่ง:

```bash
ip route
```

หากระบบทำงานปกติ ควรเห็น

* route ของ 44Net
* network path กลับมาครบ
* routing ทำงานต่อเนื่อง

หาก reboot แล้ว route หายบางครั้ง
ยังไม่ควรนำไปใช้งานจริง

---

## Verify Long-Duration Stability

หลังระบบทำงานต่อเนื่องไประยะหนึ่ง
ควรตรวจสอบว่าไม่มีอาการผิดปกติเกิดขึ้น

แนะนำให้สังเกต

* CPU usage ผิดปกติ
* RAM usage เพิ่มขึ้นต่อเนื่องผิดปกติ
* service restart เองบ่อย
* route หายเป็นบางช่วง
* network ทำงานไม่สม่ำเสมอ

---

## Recommended Monitoring Tools

สามารถใช้เครื่องมือเหล่านี้เพื่อตรวจสอบระบบ

```bash
btop
htop
```

หรือใช้ระบบ monitoring เช่น

* Netdata
* Allmon3
* Supermon
* AllScan

เพื่อช่วยตรวจสอบ behavior ของระบบระยะยาว

---

## Operational Recovery Mindset

Repository นี้ยึดแนวคิด

> "ระบบที่พร้อมใช้งานจริง ต้องสามารถกลับมาทำงานเองได้ โดยไม่ต้องคอยแก้มือบ่อย ๆ"

---

## Field-Tested Notes

แนวทาง Hardening-3 นี้ ผ่านการทดสอบจริงบน

* Node 416005,602141
* HUB 64677
* HUB 416000

รวมถึงการทดสอบ

* reboot หลายรอบ
* route persistence
* service recovery
* long-duration operation
* production restart behavior

โดยพบว่า

> "ระบบที่ดูเหมือนปกติ อาจเริ่มเกิดปัญหาเมื่อใช้งานจริงต่อเนื่อง"

ดังนั้น Hardening-3 จึงเป็นขั้นตอนสำคัญมากก่อนนำไปใช้งานจริง


