Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013070.outbound.protection.outlook.com [40.93.196.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF32C382F02
	for <nvdimm@lists.linux.dev>; Sun, 22 Mar 2026 19:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774209257; cv=fail; b=Q++vWKaf1dZbhxJBJFEx+B6JP+lcX9b9uyATF0SBNTopL9Ug2Imtjr6uYQ5VnSF2sd6bdm2mnZq06KCX3X2s2Awt3ERsOb7teOOMIsFuZ97wWpfDpus06Hs18ex+X3ORssoboT/iq3Nj4UZNb5HSkd+B2C0r8NflMkpsGokowPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774209257; c=relaxed/simple;
	bh=BUJ3WXCIsT0lN4OdMDMFPrLaCKREv9/V9oQcoeeCw/M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HwYvq5ff2/TBkjWx68qKZFeGfswuS7hJoO/wS5B285aikwoXWfE0EVzK54HRYmvr5H28XAvfjX5KdJF2FZjMdHZa9TBM4A+ErUHcDqCMkcJITcmR9hihmGZOQEJaD8QQsMPhzwOSmAyl4lHsXdZNx2Pf5N77k2c2ySdLd4El0+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vWRAXO1V; arc=fail smtp.client-ip=40.93.196.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vWRAXO1V"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vpBZI7mjrSNdYq6VArM8LNIrHWFgVkIlYIa4LM92I2usD92WHwJEDJ4V3FcfH5jOLna9BfzxXBvluQ+zNxBYiHDcvP5TCYSSTlUWGBjwk6mywVEIwlYc8Vez3oOfqkIrl5mFAIZUyJA0aPT4tIrrGr25zB26D9xrwiMnPiy8R6+xffWJtzX5/NZbgtn3JRE4V5vS9ZWVgZ/wyAOOYgAua3AFENZvgcT2m9jZXHZSx/OdJEU8dAomTWtBaqgyEtdOYVmtfWP7F5bnoFIjiN5CRgSikjHAaE1tisjKMjdHRXCMSQE5bl8VVEezRLEa+Yv5Kim/acQq5kS97duPBR757g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OcbuYMtLz5LFUvGDChYb1Ygz/3npVATzPjwNrtoxGLY=;
 b=bZEVIcldwVNEuUNNhDLbAWsRcdhGb+ZxRlIZ2Y2xdc45cdufq9p7+yhQpM4PZNWptoXYiPyt0iwgYXWaJmASCtfJ7xVyrVzzQGpF8HNteAdkiT8IQqIgb+xTnSc/xASd1GesdxLxLlXvZRy8QcW8sdYS45zGWuhRl2iNOOwFKavHKBvHwibs3WORctYDWXkXODOJQG9G/LwNIDVnCWpkQUAL4ch/88Iq0m1pdaesKoofcNAmKI7lhEfAIZxu/HFpxxF/vkyYKYKHYT9pJ0ZpmBpivXz5/6XUzXwSwt8JVTSEPkvdaAQjxQXH+UW+JTTVonrQZhd+RJRJAAhcFyetdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OcbuYMtLz5LFUvGDChYb1Ygz/3npVATzPjwNrtoxGLY=;
 b=vWRAXO1V0dchvAfUU34TR2MFg0Yu3ZZ8mJgMY4KcWiQq/CHYxKfwN/3Fijp3pbH7ZHSl3cJR8wBFWFvsHLJdEotC/doeDwp0kIm81O4CYKEcmQLMUFlOyiWVckx9mmNex1ipIFHHjZjGBBb64CoLiPnn+hoOB6HRJNEPADUyKYI=
Received: from DS7P220CA0057.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:224::9) by
 BN7PPFD91879A44.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6e5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.6; Sun, 22 Mar
 2026 19:54:03 +0000
Received: from DS3PEPF0000C37E.namprd04.prod.outlook.com
 (2603:10b6:8:224:cafe::c9) by DS7P220CA0057.outlook.office365.com
 (2603:10b6:8:224::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.25 via Frontend Transport; Sun,
 22 Mar 2026 19:53:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS3PEPF0000C37E.mail.protection.outlook.com (10.167.23.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Sun, 22 Mar 2026 19:54:03 +0000
Received: from ethanolx50f7host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 22 Mar
 2026 14:54:00 -0500
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
Subject: [PATCH v8 8/9] dax/hmem, cxl: Defer and resolve Soft Reserved ownership
Date: Sun, 22 Mar 2026 19:53:41 +0000
Message-ID: <20260322195343.206900-9-Smita.KoralahalliChannabasappa@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260322195343.206900-1-Smita.KoralahalliChannabasappa@amd.com>
References: <20260322195343.206900-1-Smita.KoralahalliChannabasappa@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37E:EE_|BN7PPFD91879A44:EE_
X-MS-Office365-Filtering-Correlation-Id: 794be9d7-0dbb-45d3-4e24-08de884cc501
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|7416014|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	I/arLQfNgJXpVWsVXbsTOJOnPlBhB12YVMMkPpf5lSixgp9ywIv3qZ8P0Zk3uSEZf1Bf9jvPdIVWUdGuisvTc73/SVqPApqoiFbUOJac3Vx2KZn3NGVtRvgXV6GecJtex7F63ZQ5Eg+clh99jk9bs3/7AZVEsKO03KCULOxFQfU8KW9Wg0HrdOIxaYivLnNv+lqOjv+DDsExl/zbAjZ1CJBzIXeRQWOBu/yWzWxEChozHAV4tJVGakOuc+NcjFhkeqvHnkK8m9X5CI2ShNbBd/RhIpr2I8a3aJx/OWSCOkw+I9YIGnp6AEyPnFpi4ii1KOlw141faWWfICbRhVVUWi28MqHEXMW1PJ26uFEnBN87V4TPyC5WEMYhi/12BXTEAOmEQ9MT9K2wFnU62tVSPkgVOZNkJ24/6Iu9jztQFiST8TbSK6hZgWvfMnI1mu8JcuH1yUFg0d8fQ3QM6d5zJnqOi9XX5y4li/Ezf/pE97AnE3SDktVAWfP2V+H5avJObw5M7r31jxs5h9xk0ZZWbaDniVZF8fjZ2jP8aV/39kp4Rqwrx7efM2f6nDYxuGQy7SgnmNB9jIExeA0tEQA5dtCzRKxkBVtewHub1DXZoIs5BO3N52L/4XvdjwfGvRIrwDn89kijel778feAmYDRlT3oI/j/UPHlKP+TRy6Nd/weG1qIitFSLKzldATCqp658eMwMCA5zwlVpdZA3GZrVJkoVh81u6Dtr6SUWvQ1WyTmzNksb8s27WSgpRLwSHjSZkzBb4zSUEhkGJ+zoDuxLA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(7416014)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2xvRTDvlhFa5Zc82W9ifdXUxYnOKB8FKsJ2X6rplnXe5Dia7REyNucD5Qgyhjw/FE6kNzjfIyBYUNeVHHgnKpTwOT1mh5HQfAwTPxjFTq5VcGKl9QIYBNQXnaHB4n7TZtoYX8BrqnfGTd0qqeKLlBR/he/Hl91jxF9pr4d2KfDIUtWPNd4t98WP9Qjk15iHpthM0YlzY2PxQi4xKTjfjwK7DecoBm6aHRTGyN1SRm6pU0h2LxHpYX4ecWeHL6cn6h6ggABxXwEI07aL69P3PRBNv0uh6kM6eAw+TMHKOYyksiF0rQzuCdbbSc7oqVgo1Q5X1J1r8H3wT1VXbXHKmSIWtj//K5gQPA2ZMRV2eHOOFYuScQtrX2ELbEGXHsutWx/J8tyvg+5NdzEnzZj937eToIylPijaWDebVDcQhoaoMksOtaM6g0hE3TXCgFgfu
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2026 19:54:03.6835
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 794be9d7-0dbb-45d3-4e24-08de884cc501
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPFD91879A44

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
 drivers/dax/bus.h         |  7 ++++
 drivers/dax/cxl.c         |  1 +
 drivers/dax/hmem/device.c |  3 ++
 drivers/dax/hmem/hmem.c   | 74 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 85 insertions(+)

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
index ca752db03201..9ceda6b5cadf 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -3,6 +3,7 @@
 #include <linux/memregion.h>
 #include <linux/module.h>
 #include <linux/dax.h>
+#include <cxl/cxl.h>
 #include "../bus.h"
 
 static bool region_idle;
@@ -58,6 +59,23 @@ static void release_hmem(void *pdev)
 	platform_device_unregister(pdev);
 }
 
+struct dax_defer_work {
+	struct platform_device *pdev;
+	struct work_struct work;
+};
+
+static void process_defer_work(struct work_struct *w);
+
+static struct dax_defer_work dax_hmem_work = {
+	.work = __WORK_INITIALIZER(dax_hmem_work.work, process_defer_work),
+};
+
+void dax_hmem_flush_work(void)
+{
+	flush_work(&dax_hmem_work.work);
+}
+EXPORT_SYMBOL_GPL(dax_hmem_flush_work);
+
 static int __hmem_register_device(struct device *host, int target_nid,
 				  const struct resource *res)
 {
@@ -122,6 +140,11 @@ static int hmem_register_device(struct device *host, int target_nid,
 	if (IS_ENABLED(CONFIG_DEV_DAX_CXL) &&
 	    region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
 			      IORES_DESC_CXL) != REGION_DISJOINT) {
+		if (!dax_hmem_initial_probe) {
+			dev_dbg(host, "await CXL initial probe: %pr\n", res);
+			queue_work(system_long_wq, &dax_hmem_work.work);
+			return 0;
+		}
 		dev_dbg(host, "deferring range to CXL: %pr\n", res);
 		return 0;
 	}
@@ -129,8 +152,54 @@ static int hmem_register_device(struct device *host, int target_nid,
 	return __hmem_register_device(host, target_nid, res);
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
+	return __hmem_register_device(host, target_nid, res);
+}
+
+static void process_defer_work(struct work_struct *w)
+{
+	struct dax_defer_work *work = container_of(w, typeof(*work), work);
+	struct platform_device *pdev;
+
+	if (!work->pdev)
+		return;
+
+	pdev = work->pdev;
+
+	/* Relies on cxl_acpi and cxl_pci having had a chance to load */
+	wait_for_device_probe();
+
+	guard(device)(&pdev->dev);
+	if (!pdev->dev.driver)
+		return;
+
+	if (!dax_hmem_initial_probe) {
+		dax_hmem_initial_probe = true;
+		walk_hmem_resources(&pdev->dev, hmem_register_cxl_device);
+	}
+}
+
 static int dax_hmem_platform_probe(struct platform_device *pdev)
 {
+	if (work_pending(&dax_hmem_work.work))
+		return -EBUSY;
+
+	if (!dax_hmem_work.pdev)
+		dax_hmem_work.pdev =
+			to_platform_device(get_device(&pdev->dev));
+
 	return walk_hmem_resources(&pdev->dev, hmem_register_device);
 }
 
@@ -168,6 +237,11 @@ static __init int dax_hmem_init(void)
 
 static __exit void dax_hmem_exit(void)
 {
+	if (dax_hmem_work.pdev) {
+		flush_work(&dax_hmem_work.work);
+		put_device(&dax_hmem_work.pdev->dev);
+	}
+
 	platform_driver_unregister(&dax_hmem_driver);
 	platform_driver_unregister(&dax_hmem_platform_driver);
 }
-- 
2.17.1

