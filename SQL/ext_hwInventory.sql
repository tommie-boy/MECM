WITH Base AS (
    SELECT
        rs.ResourceID,
        rs.Name0                           AS ComputerName,
        rs.Is_Virtual_Machine0             AS IsVirtualMachineFlag
    FROM v_R_System AS rs
),

OsData AS (
    SELECT
        os.ResourceID,
        /* You can tweak this to show product name, version, build, releaseId, etc. */
        LTRIM(RTRIM(
            COALESCE(os.Caption0, '') + 
            CASE WHEN COALESCE(os.BuildNumber0, '') <> '' 
                 THEN ' (Build ' + os.BuildNumber0 + ')' 
                 ELSE '' END
        ))                                AS OperatingSystem
    FROM v_GS_OPERATING_SYSTEM AS os
),

HwScan AS (
    SELECT
        ws.ResourceID,
        ws.LastHWScan                     AS LastHardwareScan
    FROM v_GS_WORKSTATION_STATUS AS ws
),

/* If your environment doesn’t have v_GS_FIRMWARE, the CASE logic later will show 'Unknown'. */
Firmware AS (
    SELECT
        fw.ResourceID,
        /* Common column names seen in v_GS_FIRMWARE (may vary if you customized inventory) */
        fw.UEFI0                          AS UEFI_Raw,
        fw.SecureBoot0            AS SecureBoot_Raw
    FROM v_GS_FIRMWARE AS fw
),

Bios as (
	select 
	  bios.ResourceID
      ,bios.[SerialNumber0] as [deviceSerial] 
      ,bios.[SMBIOSBIOSVersion0] as BIOSVersion
	  ,bios.[ReleaseDate0]
	from [v_GS_PC_BIOS] as bios
),
/* Heuristic VM detection fallback using manufacturer/model when the built-in flag is NULL.
   This helps for odd cases (e.g., stale data, servers that haven’t posted R_System yet). */
VmHeuristic AS (
    SELECT
        cs.ResourceID,
        CASE
            WHEN cs.Manufacturer0 LIKE '%VMware%'          THEN 1
            WHEN cs.Manufacturer0 LIKE '%Microsoft%' AND cs.Model0 LIKE '%Virtual%' THEN 1
            WHEN cs.Manufacturer0 LIKE '%Xen%'             THEN 1
            WHEN cs.Manufacturer0 LIKE '%KVM%'             THEN 1
            WHEN cs.Manufacturer0 LIKE '%QEMU%'            THEN 1
            WHEN cs.Manufacturer0 LIKE '%innotek%' OR cs.Manufacturer0 LIKE '%VirtualBox%' THEN 1
            WHEN cs.Model0 LIKE '%Virtual Machine%'        THEN 1
            ELSE 0
        END AS VM_HeuristicFlag,
		CASE
            WHEN cs.Manufacturer0 LIKE '%VMware%'			THEN 'VMware'
            WHEN cs.Manufacturer0 LIKE '%Microsoft%' AND cs.Model0 LIKE '%Virtual%' THEN 'Hyper-v'
            WHEN cs.Manufacturer0 LIKE '%Xen%'				THEN 'Xenserver'
            WHEN cs.Manufacturer0 LIKE '%KVM%' or cs.Manufacturer0 LIKE '%QEMU%' THEN 'Proxmox'
            WHEN cs.Manufacturer0 LIKE '%innotek%'			THEN 'Innotek'
			WHEN cs.Manufacturer0 LIKE '%VirtualBox%'		THEN 'Virtualbox'
            WHEN cs.Model0 LIKE '%Virtual Machine%'			THEN 'Unknown Hypervisor'
        ELSE 
			cs.Manufacturer0
        END AS Manufacturer,
		cs.model0 as [Model]
    FROM v_GS_COMPUTER_SYSTEM AS cs
),
secureBoot as (
	SELECT [ResourceID]
		  ,[AvailableUpdates0] as [availableUpdates]
	FROM [dbo].[v_GS_ext_system_secureboot0]
),
secureBootServicing as (
	SELECT [ResourceID]
		  ,[ConfidenceLevel0] as [confidenceLevel]
		  ,[UEFICA2023Status0] as [UEFICA2023Status]
		  ,[WindowsUEFICA2023Capable0] as [WindowsUEFICA2023Capable]
	FROM [dbo].[v_GS_ext_system_secureboot_servicing0]
)

SELECT
    b.ComputerName,

    /* UEFI enabled */
    CASE
        /* Typical values: 1 = UEFI, 0 = Legacy/BIOS. Adjust if your schema stores differently. */
        WHEN f.UEFI_Raw = 1 THEN 'Yes'
        WHEN f.UEFI_Raw = 0 THEN 'No'
        WHEN f.UEFI_Raw IS NULL THEN 'Unknown'
        ELSE CAST(f.UEFI_Raw AS nvarchar(20)) /* if non-standard values appear */
    END                                       AS [UEFI enabled],

    /* Secure Boot enabled */
    CASE
        /* Typical values: 1 = Enabled, 0 = Disabled. Adjust if your schema stores differently. */
        WHEN f.SecureBoot_Raw = 1 THEN 'Yes'
        WHEN f.SecureBoot_Raw = 0 THEN 'No'
        WHEN f.SecureBoot_Raw IS NULL THEN 'Unknown'
        ELSE CAST(f.SecureBoot_Raw AS nvarchar(20))
    END											AS [Secure Boot enabled],
	sb.availableUpdates,
	sbs.WindowsUEFICA2023Capable,
	sbs.confidenceLevel,
	sbs.UEFICA2023Status,

    /* Virtual machine (prefer the native flag; fallback to heuristic if null) */
    CASE
        WHEN b.IsVirtualMachineFlag = 1 THEN 'Yes'
        WHEN b.IsVirtualMachineFlag = 0 THEN 'No'
        WHEN b.IsVirtualMachineFlag IS NULL AND vh.VM_HeuristicFlag = 1 THEN 'Likely'
        WHEN b.IsVirtualMachineFlag IS NULL AND vh.VM_HeuristicFlag = 0 THEN 'No'
        ELSE 'Unknown'
    END											AS [Virtual Machine],
	vh.manufacturer,
	vh.model,
	bi.BIOSVersion,
	FORMAT(bi.ReleaseDate0, 'yyyy-MM-dd')		AS [Bios Release date],
    os.OperatingSystem							AS [Operating system],
    FORMAT(hw.LastHardwareScan, 'yyyy-MM-dd')   AS [Last Hardware Scan]

FROM 
	Base AS b
	LEFT JOIN Firmware AS f ON f.ResourceID = b.ResourceID
	LEFT JOIN OsData AS os ON os.ResourceID = b.ResourceID
	LEFT JOIN HwScan AS hw ON hw.ResourceID = b.ResourceID
	LEFT JOIN VmHeuristic AS vh ON vh.ResourceID = b.ResourceID
	LEFT JOIN bios as bi ON bi.ResourceID = b.ResourceID 
	LEFT JOIN secureBoot as sb ON sb.ResourceID = b.ResourceID 
	LEFT JOIN secureBootServicing as sbs ON sbs.ResourceID = b.ResourceID 
WHERE 
	b.ResourceID IN (SELECT ResourceID FROM v_R_System_Valid)

ORDER BY
    b.ComputerName;
