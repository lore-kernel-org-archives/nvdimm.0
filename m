Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012065.outbound.protection.outlook.com [40.93.195.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7C737DE9F
	for <nvdimm@lists.linux.dev>; Sun, 22 Mar 2026 19:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774209245; cv=fail; b=rqSEa7JnhjuhaM5KF6uXfHvNIif3XBmYRqG1D9mmMYuBBLAnyc3VFgvh9FAp34QDpukMhZgcsB09dqlxx+KvV/hWxSlxd6w1POPxD8P1QNTPLJmdVqOmpMpyc4S+V3as8pfxo2fdQdWLTUPPzdA6ueVIFkVyT8z6SRs7z8tta7Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774209245; c=relaxed/simple;
	bh=NzWqH++a1EftmNs0klRVc4YVjEKNf7AaPJNa/oVL870=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DcfGAUNVszKFZu1/6CCnbppgCMuseFsh/JwoSVtdbjwq0O63baIw/mu6ka9/cNzpQSX8eV72Xis/3GsLa1TAIhdV6ui1TVdehg7skwpsnUt2X6wbL0Yky1ben7ShCQ12aGUfEZPtQLfmH/V4RfwX5qmELMYJbHABmVS97olIBlc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3M4Ux2lE; arc=fail smtp.client-ip=40.93.195.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3M4Ux2lE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=msGdWkYtTazHfMzdY19uoutCxHs8/8Aq1plyw004Rqiv/9iPMOJoBeOi+aD7YcrNe8LErMaf1jN1PoXeTml1L9xG9dTTaokA8C3OQpA97Iriufmac9rWmXDChFnAY6rSew7J73xpmxQy0u3TaoWe+JLZlLCys2pQB4kygKVKoqTbSOIXNLnpitmXpsI2B26y96bN9b2foWC/8GIxFekyw8dC/dvpf2z4Vq5l70QAQE7+fLk7u0GpvtJzDa0qJOJnGFO/2Q9jOZhSTxzf2/K7eT0kd3RYiOucfbhfCtv6cSJKeqYZGZuarnuim379tq18kga9TYXyuepuXygaR9Y3fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6zNE+lJgqN19jbUAXAKD/+JmM+1i3g9k0sPrE3NNhXI=;
 b=jK7FI+IbVkmX6uyDmOonK5AqAzDf7AYF8E4e7GtDgC2jmvtQksqoIv/MP74zYJ46TO79fgLAX+vLClWugX1nqgL5cTPbrU2atRftCW8KENJ9RZWI2Q2LFKKCT3A9fvf8qSs/5Db7PJF6Ywsb+LsdYQPnGqwcw+H0IFdR6BTFWgO9YRAfbK3dKEarcG0Hu8vup+IeAcOQxvMck5O8KdcPj/qqhy/ExU3xpJfbDOCzMqOgvKwnsTCSt7NnmPT0uUmdDJj91/wbYMulGBAgxUZR1seDKGbzzRw3CJ6cLCQXYZEZwrhjftjaRelUsJ6cKkMSZxvWAR9zGBnmGFpY5oUHSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zNE+lJgqN19jbUAXAKD/+JmM+1i3g9k0sPrE3NNhXI=;
 b=3M4Ux2lEXmA5ciW+Edx0eSpbCQpDhgYz+aJ5we/oNC5HQ6+LCZ2IbqgVCxTewutAXVvx1743D6zt7Cv6xOEBvJsg6JbCVrLipIoY9XUsP3uB8kC/Cp5Qkiz6ccyE/s9HTMidmzpXfK/lycs63w82o0VP/aKSKJQklS+wh5ikGfo=
Received: from CH2PR17CA0002.namprd17.prod.outlook.com (2603:10b6:610:53::12)
 by IA1PR12MB8467.namprd12.prod.outlook.com (2603:10b6:208:448::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.15; Sun, 22 Mar
 2026 19:53:54 +0000
Received: from DS3PEPF0000C381.namprd04.prod.outlook.com
 (2603:10b6:610:53:cafe::e3) by CH2PR17CA0002.outlook.office365.com
 (2603:10b6:610:53::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.25 via Frontend Transport; Sun,
 22 Mar 2026 19:53:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS3PEPF0000C381.mail.protection.outlook.com (10.167.23.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Sun, 22 Mar 2026 19:53:54 +0000
Received: from ethanolx50f7host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 22 Mar
 2026 14:53:53 -0500
From: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
To: <linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-pm@vger.kernel.org>
CC: Ard Biesheuvel <ardb@kernel.org>, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>, Yazen Ghannam
	<yazen.ghannam@amd.com>, Dave Jiang <dave.jiang@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Matthew Wilcox <willy@infradead.org>, Jan Kara
	<jack@suse.cz>, "Rafael J . Wysocki" <rafael@kernel.org>, Len Brown
	<len.brown@intel.com>, Pavel Machek <pavel@kernel.org>, Li Ming
	<ming.li@zohomail.com>, Jeff Johnson <jeff.johnson@oss.qualcomm.com>, "Ying
 Huang" <huang.ying.caritas@gmail.com>, Yao Xingtao <yaoxt.fnst@fujitsu.com>,
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Nathan Fontenot <nathan.fontenot@amd.com>,
	Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>, Zhijian Li
	<lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>, Smita Koralahalli
	<Smita.KoralahalliChannabasappa@amd.com>, Tomasz Wolski
	<tomasz.wolski@fujitsu.com>
Subject: [PATCH v8 0/9] dax/hmem, cxl: Coordinate Soft Reserved handling with CXL and HMEM
Date: Sun, 22 Mar 2026 19:53:33 +0000
Message-ID: <20260322195343.206900-1-Smita.KoralahalliChannabasappa@amd.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C381:EE_|IA1PR12MB8467:EE_
X-MS-Office365-Filtering-Correlation-Id: 0af34430-7428-4e25-73cd-08de884cbf78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700016|1800799024|82310400026|13003099007|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Ssbu8AnuPH8lFl5Gt7C60W2YHv/5T5cWMMyvXb+qHMf0S8L4vAnpuUU3FGxL6WvsZxhGbXdo8a53IRh8WVSyqIbxillyCCjVjhjuePGoxUoiAO3ZyH+2ZCtv7AjEcPPEVL/uOqRT/pChDkd8DBrYAUCoBEk5T31V/uhtJUi4Bjd5xgaj+JWbgD1fzQqeTo2yG8GdCGkRB8+90MlTGkMyETkrvh6W7gLPCgONYO3KdFSWl3iOWmPYJ+mZkjHnuOsxjFOtnVtt+HdqbLiNg8eBdcMKb4DtvEIR/XYhW9g8ERlWfTLc9jfob5CRBlVy78miauPOUmT5ZTsNxw+r1Shz8upEXgk6RiFKke20Vb+gOWpfFFEyIYdEVxO1JlGNawJZOk+7aElgn/3Xh1Fm4gcASocWKzukMjwOu2DLkdxZa3cnGJESQB3jfCXfJnWAkd9ySjh+g1X+eiMlajxzyQzLVbzkeBp7NGO3ysQfFNmsO4ykVBDYpLmYqxylUGQrDApXZa6LbKIJoJU4OfIG1XC6SD10ihYqL0S3Nefs7hHfwpt/d8pxGY4sbR9Qz28BdLWlZco6TEhmwtIPpBMJFjAyTiJlPKvZrHLwxFvUVtvKnD0K/WHz5VM8NmgCkYwTyJIQAVpE0FSyu+lbWrzbYBmYJG/x9MIErJhgCFLB5Hfvejcf82lzQqjA0UbOoSIjyNQglU5yVC2korPTtRgKVZMnqfn2lbXEFRk/mz+VJGuR2LFKHw5VAQ6m8A3aqnQCnFbicfpw5ftkxrQjUxpA8/7ap859bnaZcI64GX8dk82mMAA=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700016)(1800799024)(82310400026)(13003099007)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	c1OD8J1V6OEsantv87tM2pCUfES7V3PpHhWdK6kf/6Mibbdyd8ZCxcOHvZJmGVKJfiIGAIlgYT3a6QC7wvK2iGzfkDDRIXJzaX2hhJkuF8kZX5BrVOKNqIwSFQSrIFT5jRiqoj64Ce2/HJtl1mxjyeifU3KFozD5i+CFLC5LoPvEGY3i7zg4g0RpEaCM0a7//hXm+PHqgndXvWenTAhx1iULblI+8frczhPWgxsBdb+R4ZI6Ydkh0SpvGrLCe//epePI+LT9fyRVkrrDLXaV4AwzeOWaAqUZMgsB5y9PL/+fX5JYbjzt4i0wh//sjdUaIlY4FaPO6EMQ6sE6tr7ZPtt6/mQbv/ZxEGKPOLxzFU1qu/s8FmUvCCZyQs7spwdVdCIwL2tHmJshD1xLH4prkDuc/o+8sC2NdpneG8VVwVncg1Q2h17PppP4Yl4QTxAV
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2026 19:53:54.3623
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0af34430-7428-4e25-73cd-08de884cbf78
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C381.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8467

This series aims to address long-standing conflicts between HMEM and
CXL when handling Soft Reserved memory ranges.

Reworked from Dan's patch:
https://lore.kernel.org/all/68808fb4e4cbf_137e6b100cc@dwillia2-xfh.jf.intel.com.notmuch/

Previous work:
https://lore.kernel.org/all/20250715180407.47426-1-Smita.KoralahalliChannabasappa@amd.com/

Link to v7:
https://lore.kernel.org/all/20260319011500.241426-1-Smita.KoralahalliChannabasappa@amd.com

The series is based on Linux 7.0-rc4 and base-commit is
base-commit: f338e77383789c0cae23ca3d48adcc5e9e137e3c

[1] After offlining the memory I can tear down the regions and recreate
them back. dax_cxl creates dax devices and onlines memory.
850000000-284fffffff : CXL Window 0
  850000000-284fffffff : region0
    850000000-284fffffff : dax0.0
      850000000-284fffffff : System RAM (kmem)

[2] With CONFIG_CXL_REGION disabled, all the resources are handled by
HMEM. Soft Reserved range shows up in /proc/iomem, no regions come up
and dax devices are created from HMEM.
850000000-284fffffff : CXL Window 0
  850000000-284fffffff : Soft Reserved
    850000000-284fffffff : dax0.0
      850000000-284fffffff : System RAM (kmem)

[3] Region assembly failure: Soft Reserved range shows up in /proc/iomem
and dax devices are handled by HMEM.
850000000-284fffffff : Soft Reserved
  850000000-284fffffff : CXL Window 0
    850000000-284fffffff : region0
      850000000-284fffffff : dax6.0
        850000000-284fffffff : System RAM (kmem)

[4] REGISTER path:
The results are as expected with both CXL_BUS = y and CXL_BUS = m.
To validate the REGISTER path, I forced REGISTER even in cases where SR
completely overlaps the CXL region as I did not have access to a system
where the CXL region range is smaller than the SR range.

850000000-284fffffff : Soft Reserved
  850000000-284fffffff : CXL Window 0
    850000000-280fffffff : region0
      850000000-284fffffff : dax6.0
        850000000-284fffffff : System RAM (kmem)

kreview complained on the deadlock for taking pdev->dev.mutex before
wait_for_device_probe(). Hence, I moved it.

From kreview:
The guard(device) takes pdev->dev.mutex and holds it across
wait_for_device_probe(). If any probe function in the system tries to
access this device (directly or indirectly), it would need the same
mutex:

process_defer_work()
  guard(device)(&pdev->dev)     <- Takes pdev->dev.mutex
  wait_for_device_probe()       <- Waits for all probes globally
    wait_event(probe_count == 0)

Meanwhile, if another driver's probe:

  some_driver_probe()
    device_lock(&pdev->dev)     <- Blocks waiting for mutex

The probe can't complete while waiting for the mutex, and
wait_for_device_probe() won't return while the probe is pending..

v8 updates:
- New patch to handle kref lifecycle correctly.
- New patch to factor hmem registration.
- Reversed teardown order in dax_region_unregister().
- Replaced INIT_WORK() with __WORK_INITIALIZER.
- Added forward declaration for process_defer_work().
- Added if !work->pdev return in process_defer_work() as a
  defensive check.
- One liner pdev assignment using to_platform_device(get_device()).
- Module reload handling: Reload fix to return 0 if dax_hmem_initial_probe
  is set.
- Enforced CXL to always win irrespective of whether SR covers cxl
  regions. If userspace wants HMEM to own, unload cxl_acpi.
- hmem_register_cxl_device() calls __hmem_register_device() instead of
  hmem_register_Device() to properly register resources through HMEM
  during deferred walk bypassing cxl check at boot.
- Gated flush_work() and put_device() under if dax_hmem_work.pdev in
  dax_hmem_exit().
- kmalloc -> kmalloc_obj.
- Added if (!dax_hmem_initial_probe) guard in process_defer_work() to
  skip the walk entirely. Without !dax_hmem_initial_probe guard I could
  see below on region assembly failure testings at boot..

  hmem_register_device: hmem_platform hmem_platform.0: await CXL initial probe: ..
  hmem_register_cxl_device: hmem_platform hmem_platform.0: CXL did not claim resource ..
  alloc_dev_dax_range:  dax6.0: alloc range[0]: ..
  hmem_register_cxl_device: hmem_platform hmem_platform.0: CXL did not claim resource ..
  alloc_dax_region: hmem hmem.9: dax_region resource conflict for ..
  hmem hmem.9: probe with driver hmem failed with error -12 .. 

v7 updates:
- Added Reviewed-by tags.
- co-developed-by -> Suggested-by for Patch 4.
- Dropped "cxl/region: Skip decoder reset for auto-discovered regions"
  patch.
- cxl_region_contains_soft_reserve() -> cxl_region_contains_resource()
- Dropped scoped_guard around request_resource() and release_resource().
- Dropped patch 7. All deferred work infrastructure moved from bus.c into
  hmem.c
- Dropped enum dax_cxl_mode (DEFER/REGISTER/DROP) and replaced with bool
  dax_hmem_initial_probe in device.c (built-in, survives module reload).
- Changed from all-or-nothing to per-range ownership decisions. Each range
  decided individually — CXL keeps what it covers, HMEM gets the rest.
- Replaces single pass walk instead of 2 passes to exercise per range
  ownership.
- Moved wait_for_device_probe() before guard(device) to avoid lockdep
  warning (kreview, Gregory).
- Added guard(device) + driver bound check.
- Added get_device()/put_device() for pdev refcount.
- Added flush_work() in dax_hmem_exit() to ensure work completes before
  module unload.
- dax_hmem_flush_work() exported from dax_hmem.ko — symbol dependency
  forces dax_hmem to load before dax_cxl (Dan requirement 2).
- Added static inline no-op stub in bus.h for CONFIG_DEV_DAX_HMEM = n.
- Added work_pending() check (Dan requirement 3).
- pdev and work_struct initialized together on first probe, making
  singleton nature explicit. static struct and INIT_WORK once.
- Reverted back to container_of() in work function instead of global
  variables.
- No kill_defer_work() with the struct being static.

v6 updates:
- Patch 1-3 no changes.
- New Patches 4-5.
- (void *)res -> res.
- cxl_region_contains_soft_reserve -> region_contains_soft_reserve.
- New file include/cxl/cxl.h
- Introduced singleton workqueue.
- hmem to queue the work and cxl to flush.
- cxl_contains_soft_reserve() -> soft_reserve_has_cxl_match().
- Included descriptions for dax_cxl_mode.
- kzalloc -> kmalloc in add_soft_reserve_into_iomem()
- dax_cxl_mode is exported to CXL.
- Introduced hmem_register_cxl_device() for walking only CXL
  intersected SR ranges the second time.

v5 updates:
- Patch 1 dropped as its been merged for-7.0/cxl-init.
- Added Reviewed-by tags.
- Shared dax_cxl_mode between dax/cxl.c and dax/hmem.c and used
  -EPROBE_DEFER to defer dax_cxl.
- CXL_REGION_F_AUTO check for resetting decoders.
- Teardown all CXL regions if any one CXL region doesn't fully contain
  the Soft Reserved range.
- Added helper cxl_region_contains_sr() to determine Soft Reserved
  ownership.
- bus_rescan_devices() to retry dax_cxl.
- Added guard(rwsem_read)(&cxl_rwsem.region).

v4 updates:
- No changes patches 1-3.
- New patches 4-7.
- handle_deferred_cxl() has been enhanced to handle case where CXL
  regions do not contiguously and fully cover Soft Reserved ranges.
- Support added to defer cxl_dax registration.
- Support added to teardown cxl regions.

v3 updates:
- Fixed two "From".

v2 updates:
- Removed conditional check on CONFIG_EFI_SOFT_RESERVE as dax_hmem
  depends on CONFIG_EFI_SOFT_RESERVE. (Zhijian)
- Added TODO note. (Zhijian)
- Included region_intersects_soft_reserve() inside CONFIG_EFI_SOFT_RESERVE
  conditional check. (Zhijian)
- insert_resource_late() -> insert_resource_expand_to_fit() and
  __insert_resource_expand_to_fit() replacement. (Boris)
- Fixed Co-developed and Signed-off by. (Dan)
- Combined 2/6 and 3/6 into a single patch. (Zhijian).
- Skip local variable in remove_soft_reserved. (Jonathan)
- Drop kfree with __free(). (Jonathan)
- return 0 -> return dev_add_action_or_reset(host...) (Jonathan)
- Dropped 6/6.
- Reviewed-by tags (Dave, Jonathan)

Dan Williams (3):
  dax/hmem: Request cxl_acpi and cxl_pci before walking Soft Reserved
    ranges
  dax/hmem: Gate Soft Reserved deferral on DEV_DAX_CXL
  dax/cxl, hmem: Initialize hmem early and defer dax_cxl binding

Smita Koralahalli (6):
  dax/bus: Use dax_region_put() in alloc_dax_region() error path
  dax/hmem: Factor HMEM registration into __hmem_register_device()
  dax: Track all dax_region allocations under a global resource tree
  cxl/region: Add helper to check Soft Reserved containment by CXL
    regions
  dax/hmem, cxl: Defer and resolve Soft Reserved ownership
  dax/hmem: Reintroduce Soft Reserved ranges back into the iomem tree

 drivers/cxl/core/region.c |  30 ++++++++
 drivers/dax/Kconfig       |   2 +
 drivers/dax/Makefile      |   3 +-
 drivers/dax/bus.c         |  20 +++++-
 drivers/dax/bus.h         |   7 ++
 drivers/dax/cxl.c         |  28 +++++++-
 drivers/dax/hmem/device.c |   3 +
 drivers/dax/hmem/hmem.c   | 146 +++++++++++++++++++++++++++++++++-----
 include/cxl/cxl.h         |  15 ++++
 9 files changed, 231 insertions(+), 23 deletions(-)
 create mode 100644 include/cxl/cxl.h

-- 
2.17.1

