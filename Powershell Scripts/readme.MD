# Secure Boot & UEFI Certificate Readiness Assessment

This repository contains a PowerShell script that inventories **Secure Boot configuration, UEFI firmware state, BitLocker status, and Secure Boot certificate readiness** on Windows systems.

The script outputs a **single, normalized result object**, making it suitable for use in CI/CD pipelines, compliance reporting, or centralized inventory tooling.

It is primarily designed to support **enterprise readiness assessments for the Microsoft Secure Boot certificate transition (2011 → 2023)** across physical systems, VMware environments, and Azure virtual machines.

---

## Background

Several Microsoft Secure Boot certificates issued in 2011 begin expiring in 2026.  
Systems that rely on Secure Boot but have not successfully transitioned to the **2023 certificate chain** may experience:

- Reduced Secure Boot security posture
- Inability to receive future boot component updates
- Platform‑specific boot or validation issues

This script provides **clear, machine‑readable insight** into whether a system is prepared for this transition.

---

## What the script collects

### System & platform identification
- Computer name
- Manufacturer and model
- Operating system
- Firmware type (UEFI or legacy BIOS)
- Virtual machine generation detection (Gen1 / Gen2 for Microsoft VMs)

### Security posture
- Secure Boot enabled / disabled state
- BitLocker protection status (when supported)

### Secure Boot certificate inspection
- Reads and decodes Secure Boot UEFI variables:
  - **KEK** (Key Exchange Key)
  - **DB** (Active signature database)
  - **DBDefault** (Default database, when exposed by the platform)
- Detects whether the system contains:
  - Microsoft 2011 certificates
  - Microsoft 2023 certificates (e.g. *Windows UEFI CA 2023*, *Microsoft Corporation KEK 2K CA 2023*)

> Note: `DBDefault` is conditionally skipped on Microsoft virtual machines to avoid known platform limitations.

### Secure Boot servicing & readiness
- Reads Secure Boot servicing registry keys to determine:
  - Whether Secure Boot updates are available
  - Whether the system is capable of installing the Windows UEFI CA 2023 update
  - Current servicing status and error indicators

### Event log correlation
- Queries the System event log for Secure Boot–related events:
  - **Event ID 1801**
  - **Event ID 1808**
- Captures the most recent timestamp and severity to correlate OS‑level behavior with firmware state.

---

## Output

The script produces a **single PowerShell object** with flattened properties, suitable for:

- JSON or CSV export
- CI/CD pipeline variable ingestion
- Secure Boot compliance dashboards
- Fleet‑wide readiness and risk reporting

Unavailable or unsupported values are reported as `N/a` to ensure a consistent schema across platforms.

---

## Intended use cases

- Secure Boot certificate transition readiness assessments
- Pre‑upgrade or pre‑remediation validation
- Cross‑platform Secure Boot inventory (physical, VMware, Azure)
- Automated reporting in CI/CD pipelines

---

## Requirements

- Administrative privileges
- Windows PowerShell
- Secure Boot–capable systems (script degrades gracefully when features are unavailable)

---

## Notes & limitations

- Some Secure Boot UEFI variables (such as `DBDefault`) are not exposed in certain virtualized environments.
- Secure Boot must be enabled in firmware to retrieve certificate details.
