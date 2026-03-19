Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013068.outbound.protection.outlook.com [40.107.201.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168452750E6
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 01:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773882926; cv=fail; b=TqF+ieVSsuOMiEA/YaReMbRmB2Cf16pvkr39kvUmftu9SuIMjd+Soq9RmYcZMKUVsFsNo9mtcEVAKNyDUStEIeigOzAYhobvJ41HQ5zIKsGAQy/Rz0eO7pAzQg6FlMYSEc6YrYeE2mSQwOp1xaa1lykIUEbyw+XqGWmqpsFVeAU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773882926; c=relaxed/simple;
	bh=jJvVv+ajD2nqtcz6Own2JWA4QmXo0R202ZdddfslfXQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=O5230UkIgFKgM+SqDDLfdVXSxkouYxqbDQ55uodHIYUkCbB8DplAEReanzBUiORjWfqb0JEqfK43tpL/NAwMa6tt5jBGJ1aYYce2rbMKDNmh49munjTzPuuKpfVf/VMT61F2hz36hVzVSdTAlfS6HG0ecu8kNJAP4vCzli1SKEI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WV71Y7fn; arc=fail smtp.client-ip=40.107.201.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WV71Y7fn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GbAB1lsynAmclEDyIsH76Jy7Hz2VdMQiRtQO3Vuf2gbYSGFaYkRkSWzXrlFyDBDbckyqJ5Guy2Ac/Z9pH7WFe07STlwI4ctmAy5Bm/hZxWe3A4rLC3SLu8T9FfSO2EPxgy2XB67vnV45rRdhERZaqNpJiPnIK1tEylA+Qa0MQiaN0fqFwQxUcZRJozZCIpxFUeysTddocp+0drE5aG1lWgK3M515+B/FxfHCILlR4I2R/z2zqSPM69HlL23jOZxxF1ga3iH/op4+Sv+jUXv84ndQBdGx2v9IT1+OKDC4TqdfJHsATDoLadful5cdQgn//0K1Kh0wCQdeFzZ35GufGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s45BokhjU1FRIXNRcYVs255rWZg6qdDQ3tPXcY8Oix0=;
 b=uv5uzJTlmA87QUvaZuazX5NaSdO+O5BxWxGcRhr7V1txIV5ciG0KKkS4I75yuDkntosCuAx4rN3WRGxGuirAG6gPBkCuSLbXCEgW2UyVJbikC3yyIiLIv+DfFjVqrjAQgevWahweN2TlNaO0u0PbMPHOVfeZ26Y7L+gG7nsMnEwWUOtYbH+Ap3b6FzjEyqojGC3iAO/mnLWW6gkVolIteyLrkKaK1KX2+tow2irHBTR+R3eyQVh4h9fAWdpRZ9Q3EottSvNbZ4ZPmeo27SrzF2me+ivFCycDQ93XeXxDqUi1EkelqoNL70+ixNDYTnG8/oySbNe8Fl1PEBmJ4WZuaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s45BokhjU1FRIXNRcYVs255rWZg6qdDQ3tPXcY8Oix0=;
 b=WV71Y7fnd20MQCLCjfZBKQhicd+vJoN0a638naV1PAY28IFoMjcmAKzrSaC2GsI5reM5Em0tpqcFYaFX80VsUC9OBG0Ywl8yU71mNke9xuY1bVEpng0Tn1mOx/8v6RfHl5LY9xhuZBB0rPqin4oda+uRXRGgVteVM5mSMfeTxgk=
Received: from SJ0PR05CA0140.namprd05.prod.outlook.com (2603:10b6:a03:33d::25)
 by IA1PR12MB8240.namprd12.prod.outlook.com (2603:10b6:208:3f2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Thu, 19 Mar
 2026 01:15:16 +0000
Received: from SJ5PEPF00000207.namprd05.prod.outlook.com
 (2603:10b6:a03:33d:cafe::6c) by SJ0PR05CA0140.outlook.office365.com
 (2603:10b6:a03:33d::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Thu,
 19 Mar 2026 01:14:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF00000207.mail.protection.outlook.com (10.167.244.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Thu, 19 Mar 2026 01:15:16 +0000
Received: from ethanolx50f7host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 18 Mar
 2026 20:15:14 -0500
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
Subject: [PATCH v7 0/7] dax/hmem, cxl: Coordinate Soft Reserved handling with CXL and HMEM
Date: Thu, 19 Mar 2026 01:14:53 +0000
Message-ID: <20260319011500.241426-1-Smita.KoralahalliChannabasappa@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000207:EE_|IA1PR12MB8240:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ab043cb-ed61-41d7-fb60-08de8554faeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700016|13003099007|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	NwRbLTs920ExV2nCn2yMcl6o9UmqmD5n2PjKG/fwNvVvIWFTV5G5Y1WtcuHdDjF9gS/+mkYbQ1I1p8BsaHQN45jwnIxJC1E7rN9lTeMw4pb0VCxVw0h5ptApdjmrb+EDfOg2ON3ESFudKTcU5iPwBJeioYZojQ+dhNuc402YPjmFdJ2bYYMD8sfrLxlN3niKstBHEIy0Lzpd809cGdjark1sNSLNjsLLYZ2kLqn2ZQpN3+wB8CUxUX41yL55rQQOnLwaD50KnoYAlaQFKWiH1F1VDhukngCir8bK8w8lLOLqL5dsBzMj4Qb9+QqjV/dYbqenQeb6Gp5J4Q+eCYeXCuExeB5f2vBZswF6CgMFuxchMdey4u82AyUkDVb5uhV2DYIqEVUi/ogWjm81w5jb+ZD8mWVB7bBfENfxR5DNUsVYPQvbmHeH5YZKNAY2FhLXOpMpdw3m4PaFkNV/k/GhMhSHBto+tu53wgahRecCoP8HrokV3ATztNSgf+s1nfRCK79C46QLIh5pvkBLuGTUZI1tZPqQVIKuwiCla8Kjerhwh0AL0QgsaUI5X9guSvkOtsh1hoqSRXz1EUgVJPiVPeK9Ff4hH0GNjk75aXtZuJesk+ow7vLDNe0z3RB4CO0ngw0Qj0uA/F85T2zbMqHdjTVcFcpW1gItasBy4YLrXQB86sAbnwzEoaf4rnHKb6GKpPQZSYddjwzAz6BUXmM2F7bZuT+VBglCHMTaq7d+gdp8PXFX6YpomX14q2F60TpYh/UKgc8RlaF26jZXYwE41ZsBnlj1WfIxN6ldqyYoiPE=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700016)(13003099007)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Sk8VBFICWulGGMV66DXULKHa+fYGcus9xDSTASxQGXjM7Guy+LuhhSHjJEFF4HvuH4lUlBIHo1RxEiYGqt235cL8/U7pXLJ01NAgT3Amuco+Q+fBlr5qXiot9qrN4TG6JTA86WKWk2wAD2pTwCNPp41YbtpfMhbhfkRXqElLmHucf2YUO6QJyiL+9iI7TlbH9PuuLuBt0Qm426PUOUcTMgcMoBsqD1FyPtNOQhMCbFbciF08+nDii5tIVoHDJC2MtxMKK8F/S4ReljOVqYw3j4mOQyF5t1W8wtfvNNlOJqvQdRxuH8nSXpGZVCeKCZa/eU6DDXdXz42msI/CJWX4IY9pEUfipJgwv5Uz5qh+SxBoCCQxNwSs1Z4BSo7qSQD7/1Nbmk9QyQoHF6oi8+IFh3kciL+PIm0IMdQQebNyaFIqTYHwiOUhx7O9IrATuWdL
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 01:15:16.5974
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ab043cb-ed61-41d7-fb60-08de8554faeb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000207.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8240

This series aims to address long-standing conflicts between HMEM and
CXL when handling Soft Reserved memory ranges.

Reworked from Dan's patch:
https://lore.kernel.org/all/68808fb4e4cbf_137e6b100cc@dwillia2-xfh.jf.intel.com.notmuch/

Previous work:
https://lore.kernel.org/all/20250715180407.47426-1-Smita.KoralahalliChannabasappa@amd.com/

Link to v6:
https://lore.kernel.org/all/20260210064501.157591-1-Smita.KoralahalliChannabasappa@amd.com/

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

Smita Koralahalli (4):
  dax: Track all dax_region allocations under a global resource tree
  cxl/region: Add helper to check Soft Reserved containment by CXL
    regions
  dax/hmem, cxl: Defer and resolve Soft Reserved ownership
  dax/hmem: Reintroduce Soft Reserved ranges back into the iomem tree

 drivers/cxl/core/region.c |  30 ++++++++++
 drivers/dax/Kconfig       |   2 +
 drivers/dax/Makefile      |   3 +-
 drivers/dax/bus.c         |  20 ++++++-
 drivers/dax/bus.h         |   7 +++
 drivers/dax/cxl.c         |  28 ++++++++-
 drivers/dax/hmem/device.c |   3 +
 drivers/dax/hmem/hmem.c   | 117 ++++++++++++++++++++++++++++++++++----
 include/cxl/cxl.h         |  15 +++++
 9 files changed, 208 insertions(+), 17 deletions(-)
 create mode 100644 include/cxl/cxl.h

base-commit: f338e77383789c0cae23ca3d48adcc5e9e137e3c
-- 
2.17.1
