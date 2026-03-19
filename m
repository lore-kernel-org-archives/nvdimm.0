Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012058.outbound.protection.outlook.com [40.93.195.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABA9285CA4
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 01:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773882943; cv=fail; b=EBs56YjQUAJ1NvM9bIBsPhFQGeq1wZRKdEqqspQqRO6KPaG5aK7RM7Glq+7TG6Mxo42smyO2FpkXeLToNXp6uP95PCB7AHDz+vC+GC4pw2KelWAGq0bw0icdKMRtswswKH3uVSXo7Fo6TyptcgzQpABsc/VvE7uelpHPXsmPIaI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773882943; c=relaxed/simple;
	bh=zcP5+M3q0f/2FReTWVz3B4EJySMB08JxkmNaNcDwRV0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bN0NhHiKKLdhmJvqI7SwpgLWWoB2PiHgd5Cufgxai/7U5A1URyLakwmPRy0/VfkIUflElU5TTKTKZtI8TmqLbSGvLuBfddaNvD5lMRehbLT435nwBhdZjL1khAyMPKU5GlppnKdmO0YrCWlfzkPV+0oKPYfF1HFwxX23+eGcSdY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=m66ckwFu; arc=fail smtp.client-ip=40.93.195.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="m66ckwFu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SGRmMNt9Z6EKu9rhRhPmPmtpSSUEJYmjmfw69VofhE98d/1IVg64EDbtnd6cVMp0j7e7JvVpdfLjvExrICZXy3a+wd7p57sZT1YTVOJjghjU7HdkqkMsUmNt50bZL8PpgN5T+wPWUdYnbjRKDC5KeRshMMc80wZG70N8sz+SVtsi1lnhfVJki/ZA5HZgC+ayxYsmyPJucrI58lP6tOUVdiqIOwQocDpCTGUDtDKetr41EveX33IsOh7QanZ4xzjzGAb0G7QfjAa0j2VetcDsDGSBVKA7odd/YCB94/XbMAzoh2STJjwB+DJCYQfnf87q7fdkOu3Aswp5tAcW+ZATFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lS3UEvS45rBwpHt3Sbd7Rl2T+LONac44wmN+WIRyB2A=;
 b=aoa/Hanes6kuP2Y/D1FtmG26uaTwz9MvRrf0mIQhOwLwtxmAgUJWu6IABb7eU3qD5sQBxZB4XgA0MCvTX8kXJxkI2sAHSsvHdh+SkcY1xy0V0qa790vfHCYmIoGTs9h3Lnw8GQqpDzVgnt8jWUlnP7qbifXfH882+tTKmEFv4rHIzXTo5fjtwvdIRhPKjeK0CDvjO5Rn/cEvOwt8UoKb+zcmP0nA23QRxn6SfMpi/yA7W2gwxMPsfqeyW8ZfvHWYgTAA9UNjy+fd6r2UEq5D8QQmd+KdNaLIE1z/lIW9zzYbgG14a2smLs2x5kUoivUkwgK+1beKqsnG8NQuTzdQJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lS3UEvS45rBwpHt3Sbd7Rl2T+LONac44wmN+WIRyB2A=;
 b=m66ckwFuMVbjXMXIqCYtYP/9GYgSUYh9SuZRmqfC+nEkMOV49Z2wARrBOMQ9RBfY9if8vf4kIOMVtuXccLLsoozQqeLGfph2drXBmKHaClBHCAH4eqjJ76W8C0oYimrHDibAwt00g24uFJqELjpMR2gt0z9bGKIz1Io4OYr7BoE=
Received: from SJ0PR13CA0222.namprd13.prod.outlook.com (2603:10b6:a03:2c1::17)
 by BY5PR12MB4146.namprd12.prod.outlook.com (2603:10b6:a03:20d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Thu, 19 Mar
 2026 01:15:28 +0000
Received: from SJ5PEPF00000204.namprd05.prod.outlook.com
 (2603:10b6:a03:2c1:cafe::f8) by SJ0PR13CA0222.outlook.office365.com
 (2603:10b6:a03:2c1::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 01:15:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF00000204.mail.protection.outlook.com (10.167.244.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Thu, 19 Mar 2026 01:15:21 +0000
Received: from ethanolx50f7host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 18 Mar
 2026 20:15:20 -0500
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
Subject: [PATCH v7 6/7] dax/hmem, cxl: Defer and resolve Soft Reserved ownership
Date: Thu, 19 Mar 2026 01:14:59 +0000
Message-ID: <20260319011500.241426-7-Smita.KoralahalliChannabasappa@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260319011500.241426-1-Smita.KoralahalliChannabasappa@amd.com>
References: <20260319011500.241426-1-Smita.KoralahalliChannabasappa@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000204:EE_|BY5PR12MB4146:EE_
X-MS-Office365-Filtering-Correlation-Id: 73902048-fe87-4f1b-695f-08de8554fdd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|7416014|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	BHB+HV6bnLwnoZ/7SxS5QToA7OwmJ4kfyiymq0s4lfju+Hk2hyHSAF0ya11gc2TKIe1Q+iioLAudR6EWmHSuivrkhiY/bdTUoiryoxQLeYyaRM01A8xjq+dxrSBT9nJ8Ft4dSa8cUuQQadWS22y7L7iZAk5/7UcPqM06U+u1nWjIn560IOwTeFvNSWcNTkKeSEOXTn3gPszIZU0V/KlUPGgeX/Wg9AAgnwn2vui+I0pJV6SHWJh/lMjCRGYfj1faVhU1NcOerCRmYqXDlhqbvb8khAxXpPliIrCrbF3OV6EhIlxWmrSbXy5D3ymefGF27/3mFD8LFX+9hQOVrTUrmTilLKnMN4jm1D8wEKjRlcnaRRRTsqNKLgpCtnvJITeQqV32LBIzS4VfOzi81xJRSwE07B7u3lUrx0lNPXv/TdFv6EKu8yYwiu2lAPbXcJDhBiOfcx6JzCQ/pGdo2sDMPEZAfZZIgyanJdpKIDT2cVT0EfNtKabWy9KVID3AgA1xJN7MjKSCU1K+xjNX4Z4DBIfQXEjn3dZJP8LXZf8z8U/Et+jXumX6XLA3fyvOmtz0+kcpOve7jF5k+47hOqQtSZg4klKoL4i6CwiazPMueHHYuGIUSLmeULdSh9mT8Fy5U86yO86k24hTIyGf49OGCI9dLXzveGnwspz5gbTFR5GjSAQMyCPMT8P0cM+DFFoAawMwc6AzWWQsIrJUZhOYVA83AlBZgQZhtY4lDkka08N5HPYmodrMFT5mAV8ah4ZdXk5WkN8jRB4beFM9c8wovA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(7416014)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	FRjdYW2jQj+skuTcQKC/s0jTKpJZ9+wiuuTZxwHVmcCyDFKBG6okZshiO7aOJbBz4uRqXarDK/FgilTpr7wwFitYsrjH5LjFHahoFAKFlAK6NTbcNNHWqzDIlIjtrYVlTWJgHbd5g0wQCGEktrBpmXz4X6MbIlj/VR3cJcfap7sMLWyppyzpgxNQz58lPClRNkDm43nePEzB7//dG7NT21AZb6/3sp1GP0RX9VwuhgO36GL23LWhHhBgkO8JRcvr5Q4+2DilPLN7nTrYcAmPLZZdroIHNh2NOOyIiHiFckyriKBwGGa5Imwh1/jeb5hrD3OJCY6CO7avCaBWI7XpBrDOhISKuwVTYZkwf/OAq/65VYbwjp3TSuch7xzXiYteHcY+hO3ceQY/xKy+zCV0Dd6gbCiZFTw2RIvl9ZIXKr2FirSP4sKsctts4wiPqcx6
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 01:15:21.4631
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 73902048-fe87-4f1b-695f-08de8554fdd3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000204.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4146

The current probe time ownership check for Soft Reserved memory based
solely on CXL window intersection is insufficient. dax_hmem probing is not
always guaranteed to run after CXL enumeration and region assembly, which
can lead to incorrect ownership decisions before the CXL stack has
finished publishing windows and assembling committed regions.

Introduce deferred ownership handling for Soft Reserved ranges that
intersect CXL windows. When such a range is encountered during the
initial dax_hmem probe, schedule deferred work to wait for the CXL stack
to complete enumeration and region assembly before deciding ownership.

Once the deferred work runs, evaluate each Soft Reserved range
individually: if a CXL region fully contains the range, skip it and let
dax_cxl bind. Otherwise, register it with dax_hmem. This per-range
ownership model avoids the need for CXL region teardown and
alloc_dax_region() resource exclusion prevents double claiming.

Introduce a boolean flag dax_hmem_initial_probe to live inside device.c
so it survives module reload. Ensure dax_cxl defers driver registration
until dax_hmem has completed ownership resolution. dax_cxl calls
dax_hmem_flush_work() before cxl_driver_register(), which both waits for
the deferred work to complete and creates a module symbol dependency that
forces dax_hmem.ko to load before dax_cxl.

Co-developed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
---
 drivers/dax/bus.h         |  7 +++++
 drivers/dax/cxl.c         |  1 +
 drivers/dax/hmem/device.c |  3 ++
 drivers/dax/hmem/hmem.c   | 66 +++++++++++++++++++++++++++++++++++++--
 4 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
index cbbf64443098..ebbfe2d6da14 100644
--- a/drivers/dax/bus.h
+++ b/drivers/dax/bus.h
@@ -49,6 +49,13 @@ void dax_driver_unregister(struct dax_device_driver *dax_drv);
 void kill_dev_dax(struct dev_dax *dev_dax);
 bool static_dev_dax(struct dev_dax *dev_dax);
 
+#if IS_ENABLED(CONFIG_DEV_DAX_HMEM)
+extern bool dax_hmem_initial_probe;
+void dax_hmem_flush_work(void);
+#else
+static inline void dax_hmem_flush_work(void) { }
+#endif
+
 #define MODULE_ALIAS_DAX_DEVICE(type) \
 	MODULE_ALIAS("dax:t" __stringify(type) "*")
 #define DAX_DEVICE_MODALIAS_FMT "dax:t%d"
diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index a2136adfa186..3ab39b77843d 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -44,6 +44,7 @@ static struct cxl_driver cxl_dax_region_driver = {
 
 static void cxl_dax_region_driver_register(struct work_struct *work)
 {
+	dax_hmem_flush_work();
 	cxl_driver_register(&cxl_dax_region_driver);
 }
 
diff --git a/drivers/dax/hmem/device.c b/drivers/dax/hmem/device.c
index 56e3cbd181b5..991a4bf7d969 100644
--- a/drivers/dax/hmem/device.c
+++ b/drivers/dax/hmem/device.c
@@ -8,6 +8,9 @@
 static bool nohmem;
 module_param_named(disable, nohmem, bool, 0444);
 
+bool dax_hmem_initial_probe;
+EXPORT_SYMBOL_GPL(dax_hmem_initial_probe);
+
 static bool platform_initialized;
 static DEFINE_MUTEX(hmem_resource_lock);
 static struct resource hmem_active = {
diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
index 1e3424358490..8c574123bd3b 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -3,6 +3,7 @@
 #include <linux/memregion.h>
 #include <linux/module.h>
 #include <linux/dax.h>
+#include <cxl/cxl.h>
 #include "../bus.h"
 
 static bool region_idle;
@@ -58,6 +59,19 @@ static void release_hmem(void *pdev)
 	platform_device_unregister(pdev);
 }
 
+struct dax_defer_work {
+	struct platform_device *pdev;
+	struct work_struct work;
+};
+
+static struct dax_defer_work dax_hmem_work;
+
+void dax_hmem_flush_work(void)
+{
+	flush_work(&dax_hmem_work.work);
+}
+EXPORT_SYMBOL_GPL(dax_hmem_flush_work);
+
 static int hmem_register_device(struct device *host, int target_nid,
 				const struct resource *res)
 {
@@ -69,8 +83,11 @@ static int hmem_register_device(struct device *host, int target_nid,
 	if (IS_ENABLED(CONFIG_DEV_DAX_CXL) &&
 	    region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
 			      IORES_DESC_CXL) != REGION_DISJOINT) {
-		dev_dbg(host, "deferring range to CXL: %pr\n", res);
-		return 0;
+		if (!dax_hmem_initial_probe) {
+			dev_dbg(host, "deferring range to CXL: %pr\n", res);
+			queue_work(system_long_wq, &dax_hmem_work.work);
+			return 0;
+		}
 	}
 
 	rc = region_intersects_soft_reserve(res->start, resource_size(res));
@@ -123,8 +140,48 @@ static int hmem_register_device(struct device *host, int target_nid,
 	return rc;
 }
 
+static int hmem_register_cxl_device(struct device *host, int target_nid,
+				    const struct resource *res)
+{
+	if (region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
+			      IORES_DESC_CXL) == REGION_DISJOINT)
+		return 0;
+
+	if (cxl_region_contains_resource((struct resource *)res)) {
+		dev_dbg(host, "CXL claims resource, dropping: %pr\n", res);
+		return 0;
+	}
+
+	dev_dbg(host, "CXL did not claim resource, registering: %pr\n", res);
+	return hmem_register_device(host, target_nid, res);
+}
+
+static void process_defer_work(struct work_struct *w)
+{
+	struct dax_defer_work *work = container_of(w, typeof(*work), work);
+	struct platform_device *pdev = work->pdev;
+
+	wait_for_device_probe();
+
+	guard(device)(&pdev->dev);
+	if (!pdev->dev.driver)
+		return;
+
+	dax_hmem_initial_probe = true;
+	walk_hmem_resources(&pdev->dev, hmem_register_cxl_device);
+}
+
 static int dax_hmem_platform_probe(struct platform_device *pdev)
 {
+	if (work_pending(&dax_hmem_work.work))
+		return -EBUSY;
+
+	if (!dax_hmem_work.pdev) {
+		get_device(&pdev->dev);
+		dax_hmem_work.pdev = pdev;
+		INIT_WORK(&dax_hmem_work.work, process_defer_work);
+	}
+
 	return walk_hmem_resources(&pdev->dev, hmem_register_device);
 }
 
@@ -162,6 +219,11 @@ static __init int dax_hmem_init(void)
 
 static __exit void dax_hmem_exit(void)
 {
+	flush_work(&dax_hmem_work.work);
+
+	if (dax_hmem_work.pdev)
+		put_device(&dax_hmem_work.pdev->dev);
+
 	platform_driver_unregister(&dax_hmem_driver);
 	platform_driver_unregister(&dax_hmem_platform_driver);
 }
-- 
2.17.1

