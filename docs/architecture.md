# ASL3 AMPRNet IP44 System Architecture

## Overview

This document describes the high-level architecture of the AMPRNet IP44 environment used with:

- AllStarLink 3 (ASL3)
- Debian 12/13
- IPSec + L2TP VPN transport
- Dynamic IP44 policy routing
- Production watchdog recovery system

The architecture is designed to provide stable and production-safe AMPRNet connectivity for amateur radio infrastructure.

---

## Core Architecture Goals

The system architecture focuses on:

- Persistent AMPRNet VPN connectivity
- Automatic route recovery
- Policy-based traffic isolation
- Self-healing tunnel management
- Observable operational behavior
- Production-safe automation

---

## System Components

### ASL3 Node

Primary application environment:

- AllStarLink 3
- Asterisk services
- RF linking infrastructure
- Audio routing services

---

### VPN Transport Stack

The VPN transport layer consists of:

- strongSwan (IPSec)
- xl2tpd (L2TP)
- PPP interface (ppp0)

This stack establishes AMPRNet connectivity over encrypted VPN transport.

---

### Watchdog Engine

The watchdog subsystem is responsible for:

- Tunnel validation
- PPP interface detection
- Route rebuilding
- Policy routing recovery
- Operational verification
- Recovery automation

---

## Routing Architecture

The routing engine uses:

- Dedicated routing table
- Source-based policy routing
- Interface-specific default routes

Example routing model:

```bash
ip rule add from 44.xx.xx.xx table 200
ip route add default dev ppp0 table 200
```

---

## Traffic Flow

Typical traffic flow:

```text
ASL3 Services
      ↓
Policy Routing Engine
      ↓
PPP Interface (ppp0)
      ↓
L2TP Tunnel
      ↓
IPSec Transport
      ↓
AMPRNet Gateway
```

---

## Operational Philosophy

The architecture follows several operational principles:

- Self-healing design
- Minimal manual intervention
- Reproducible deployment
- Production-safe recovery
- Clear operational visibility

---

## Failure Recovery Model

The watchdog system is designed to recover from:

- VPN tunnel interruption
- PPP interface loss
- Stale routing tables
- Missing policy routes
- Incomplete route rebuilds

Recovery operations are performed automatically whenever possible.

---

## Related Components

See additional documentation:

- `introduction.md`
- `watchdog-architecture.md`
