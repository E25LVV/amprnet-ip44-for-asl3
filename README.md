# amprnet-ip44-for-asl3
Production-oriented AMPRNet IP44 deployment and operational guide for AllStarLink 3 on Debian 12/13.


---

## Overview

This repository contains production-oriented AMPRNet IP44 deployment,
routing, and watchdog automation for AllStarLink 3 environments.

The project focuses on:

- Stable AMPRNet VPN connectivity
- Dynamic IP44 route recovery
- Policy-based routing
- Production-safe watchdog operation
- Debian 12/13 compatibility
- Real-world operational deployment

---

## Repository Structure

```text
docs/
scripts/
README.md
LICENSE
```
---

## Documentation

- docs/introduction.md
  - Project introduction
  - Deployment philosophy
  - Operational overview

- docs/architecture.md
  - High-level AMPRNet system architecture
  - Routing concepts
  - Recovery design

- docs/watchdog-architecture.md
  - Watchdog routing engine
  - VPN recovery workflow
  - Policy routing rebuild process

---

## Design Philosophy

This repository is built around:

- Production-safe deployment
- Observable operational behavior
- Minimal manual recovery
- Reproducible infrastructure
- Debian 12/13 compatibility
- Amateur radio real-world operations

---

## Environment

Designed for:

- AllStarLink 3 (ASL3)
- Debian 12 / 13
- AMPRNet IP44 networking
- IPsec + L2TP VPN transport
- Policy-based routing
- Raspberry Pi / Mini PC deployment

---

## Quick Start

Clone repository:

```bash
git clone https://github.com/E25LVV/amprnet-ip44-for-asl3.git
cd amprnet-ip44-for-asl3
