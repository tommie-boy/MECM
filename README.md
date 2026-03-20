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

## License

This project is licensed under the **GNU General Public License v3.0 (GPL‑3.0)**.  
See the [LICENSE](LICENSE) file for details. [1](https://github.com/tommie-boy/MECM)

---

## Disclaimer

The contents are provided **as-is**, without warranty of any kind.  
Use at your own risk.
