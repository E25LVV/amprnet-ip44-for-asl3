# ASL3 AMPRNet IP44 Watchdog Architecture

## Overview

This document describes the operational architecture of the ASL3 AMPRNet IP44 watchdog system used for:

- VPN bootstrap
- Tunnel validation
- Dynamic IP44 route injection
- Policy routing rebuild
- Route verification
- Production-safe recovery workflow

The watchdog script is designed for AllStarLink 3 environments running on Debian 12/13 with AMPRNet IP44 networking over L2TP/IPsec VPN transport.

---

## Objectives

The primary objectives of this watchdog system are:

- Maintain persistent AMPRNet VPN connectivity
- Rebuild routing policies automatically
- Prevent stale routing tables
- Validate active VPN interface state
- Recover routing logic after reboot or tunnel interruption
- Provide observable operational output

---

## Core Components

### VPN Stack

The watchdog operates with:

- strongSwan (IPsec)
- xl2tpd (L2TP tunnel)
- PPP interface (ppp0)

---

## Routing Architecture

The watchdog uses:

- Dedicated routing table
- Policy-based routing
- Interface-specific default route

Example:

```bash
ip rule add from 44.xx.xx.xx table 200
ip route add default dev ppp0 table 200
```
