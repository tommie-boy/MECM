# MECM

This repository contains scripts and SQL queries related to **Microsoft Endpoint Configuration Manager (MECM / SCCM)**.

The content is intended for **administrators and system engineers** who manage MECM environments and need practical tooling for reporting, inventory, and operational insight.

---

## Repository structure

### `/SQL`
Contains **SQL queries** for use against the MECM (ConfigMgr) site database.  
Typical use cases include:
- Hardware and firmware inventory reporting
- Security-related insights (e.g. UEFI, Secure Boot)
- Operational and compliance reporting

> ⚠️ SQL queries should always be executed against a **supported MECM database replica** (e.g. read-only replica) and never directly on production without validation.

---

## Usage

- Review each script or query before use.
- Test in a **non-production** environment first.
- Adjust table/view names if your MECM version or custom inventory differs.

---

### `/Powershell Scripts`


This folder contains **PowerShell scripts that can be used as script with Microsoft Endpoint Configuration Manager (MECM / SCCM)**.

The scripts are intended to support **administration, automation, and operational tasks** within MECM environments, such as inventory handling, configuration tasks, or supporting deployment and reporting activities. The provided scripts may work in other management platforms as well.



### Secure Boot – Hardware Inventory

This folder contains content related to **hardware inventory and reporting of Secure Boot status** in **Microsoft Endpoint Configuration Manager (MECM / SCCM)**.

The focus of this folder is to support **visibility and validation of Secure Boot configuration** across managed devices, typically for security, compliance, or hardening purposes. I'm assuming you're well aware of editing MECM's configuration.mof file as well as how to import classes for hardware inventory. 

---

## Scope

Content in this folder may be used to:
- Identify whether **Secure Boot** is enabled or disabled on devices
- Support **UEFI vs. Legacy BIOS** reporting
- Assist with **security baselines, audits, and compliance checks**
- Correlate Secure Boot status with other hardware inventory data

---

## Intended usage

- Use in conjunction with MECM **Hardware Inventory** data
- Intended for **reporting, auditing, and analysis**, not enforcement
- Suitable for environments with mixed:
  - Physical devices
  - Virtual machines
  - Legacy BIOS and UEFI systems

---

## Notes

- Secure Boot reporting depends on:
  - Correct hardware inventory classes being enabled in MECM
  - Client support for UEFI and Secure Boot reporting
- Results may vary between physical hardware and virtual platforms.


## License

This project is licensed under the **GNU General Public License v3.0 (GPL‑3.0)**.  
See the [LICENSE](LICENSE) file for details. [1](https://github.com/tommie-boy/MECM)

---

## Disclaimer

The contents are provided **as-is**, without warranty of any kind.  
Use at your own risk.
