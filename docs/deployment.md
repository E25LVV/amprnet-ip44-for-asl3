# Deployment Guide

Production-oriented deployment workflow for ASL3 AMPRNet IP44 environments.

---

## Overview

This document describes the deployment process for:

- AllStarLink 3 (ASL3)
- Debian 12 / 13
- AMPRNet IP44 networking
- IPsec + L2TP VPN transport
- Dynamic policy routing
- Watchdog recovery automation

---

## Requirements

Recommended environment:

- Debian 12 / 13
- Root shell access
- Public internet connectivity
- AMPRNet IP44 allocation
- L2TP/IPsec VPN credentials

Recommended hardware:

- Raspberry Pi 4/5
- Mini PC
- Low-power x86 systems

---

## Required Packages

Install required packages:

```bash
apt update

apt install -y \
strongswan \
xl2tpd \
ppp \
iproute2 \
curl \
wget
nano \
git

```
## Deployment Steps

1. Configure VPN credentials
2. Install required packages
3. Deploy watchdog scripts
4. Configure routing policies
5. Verify AMPRNet connectivity
