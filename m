Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010040.outbound.protection.outlook.com [52.101.61.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303B533120D
	for <nvdimm@lists.linux.dev>; Tue, 10 Feb 2026 06:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770705927; cv=fail; b=Qj0uRaQrS7ZeaCQgZNNWDTLoRxGkyxwIGJT0h4ekvwjjqGPdF/hnlh9d86CWNBpBiYurAB8Du3IAXUeTmpk3bhuL9JTJYKyfQXJfrOF4m7dNdUMvoByeMwRjC8iW34bOeUIqwxzQqHGndjKJeUyOLYW8Bwjl2Ey+nVN01G6JhP0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770705927; c=relaxed/simple;
	bh=fRZ7QVcTAMS4l6+0HwkIKv+Ei2+a7ve4i/WLEvjr9ls=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z4FMsL6+IjKnsask5c5PyebW30wSp6ub4soWjqOsTLs660OiU/qR85BmjpiP69Ny/d5Nvk1FG/H+pQTsu7xrvHJxQK8wAVKffDORkYBSNLK8CJquQ/2r8djbT00KuMCx5jaPQrcXJDdwgmwuovAPW4PjevkPMZ3xNsEL6vVaOIA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=An0Cv+ED; arc=fail smtp.client-ip=52.101.61.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="An0Cv+ED"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HbhtbYlbR149mB6xP3JZmoxp1ZhRV4Ro54hEszHjxJmtuJKdMWnuPlVIQ4UzWij/Vezqum36CTQkKP8eUXCQIUHHghfGp9BI9UpIN0nZ//Myf7w3N4MQu3AK0xTkR8C+YgeST0q3z4qqGmcO7XW32ccHS8/S4JDB5Viksg02Q5lBQYb7kZ1jfEOXsh2A8pv+1WaNdw2JO3hkXoPl7vDcVZEMUE2qsn+8FJODEwYdO4eO5n6/K+qNgFdymWoHtUU1IAcWr27Q7y1hDyOQthasiMG3F4Sr+it0cOYnvrb3SxKuQwYZyCkECCXQgg/KrbMyahlSpQ7hZPVHAvMXXFRATw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=581XufDmJdGtOhhMUTMJwlITyZ77bieibkZjhmIk97s=;
 b=hysDT7DJGpt6xbw7sLemeDvTwQTX9MzKTGBk9md+jJqKHNeytP4hudLx0+0h5z3m+2ZwJeVMq/QGcF+DoKQsJa1+g/VjjAZav+YniJM3wSLskq8SfBISn5nnIZpvBd9uB85Nbbytp+Z4A8Heu6abezKSqYhli8hgfsKzsPjCaecrv0wxtKiXT56wUF9cTBIPf1QKU+kKyQwmMnjnQbI3t35wo8rhWDylUuc6XGrPnfdGGym7ZjrlZDi/ftFM7ggBwz9sJ/WbNO6GEnzqSw/cFtqw/vQrsDdRkM7NR7GZCRhotl/GKQbXEvWkHNG720GSFUWrHE3hlfr80V843k5jsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=581XufDmJdGtOhhMUTMJwlITyZ77bieibkZjhmIk97s=;
 b=An0Cv+ED2sgc6Ws2ZeKuDCCgwUpqs6N7rY++QxV86Rjif/cUt8O6ThcneoypXvzPKpUwAYF4Nsc0ZLmDcaRZEmZFf1ezw4ku0HHGdEjQx1kV4DbJM1LN+I8K63jrpnEp0MZimvrtx8qUCYnvYwCRo3VL5zjHxkRnI8NGdn9Fof0=
Received: from SJ0PR03CA0005.namprd03.prod.outlook.com (2603:10b6:a03:33a::10)
 by IA1PR12MB7520.namprd12.prod.outlook.com (2603:10b6:208:42f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.17; Tue, 10 Feb
 2026 06:45:22 +0000
Received: from SJ1PEPF000026C5.namprd04.prod.outlook.com
 (2603:10b6:a03:33a:cafe::bb) by SJ0PR03CA0005.outlook.office365.com
 (2603:10b6:a03:33a::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.19 via Frontend Transport; Tue,
 10 Feb 2026 06:45:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF000026C5.mail.protection.outlook.com (10.167.244.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.8 via Frontend Transport; Tue, 10 Feb 2026 06:45:21 +0000
Received: from ethanolx50f7host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 10 Feb
 2026 00:45:19 -0600
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
Subject: [PATCH v6 6/9] cxl/region: Add helper to check Soft Reserved containment by CXL regions
Date: Tue, 10 Feb 2026 06:44:58 +0000
Message-ID: <20260210064501.157591-7-Smita.KoralahalliChannabasappa@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260210064501.157591-1-Smita.KoralahalliChannabasappa@amd.com>
References: <20260210064501.157591-1-Smita.KoralahalliChannabasappa@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026C5:EE_|IA1PR12MB7520:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d86ba1b-0e1b-4e81-4202-08de686ff63c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KofC2aJvw+4CD8kB6ibAlSUB7zNVfLm4+B4TH2revb5N/YgFcePfmBcy30WT?=
 =?us-ascii?Q?UznlH2+nmTEmZMTmgv8iamOUwaWfSTxkR80hCp3NibEFO+U1vriBdK0UgQJR?=
 =?us-ascii?Q?WG4kfDdW6T5xpLSZDlAOqIR0euPz01Ip4D2EIZz+l5qb33t0ixJWROXTTBhM?=
 =?us-ascii?Q?/TcSSbmsV73Nf6pLYdHrVZkSN0h6eXYE6cypTuTGNK529eyBeS0vPrPeKaju?=
 =?us-ascii?Q?AeAZOpC52wEXi/M+BSj4ZTBcryiIttkLv1n2KKMiXOc+oD4penDiq/TR2ZO2?=
 =?us-ascii?Q?B+qlBeDuei5xpje+b9O+nS+PrezJwdsKIWqtIm522oOlhC/ik4C2HtslzFts?=
 =?us-ascii?Q?oIyxxm981a1tk9Fx6n15QFFd6Ri2CF3pEy3VJHa++US+eQ/r2sDFDN6LK98N?=
 =?us-ascii?Q?LiYZr4VNi4eLxkmzo9BX0MQKG9GgtWAjpdzcuD71TMYS6d2VyNhC/y+4WUj7?=
 =?us-ascii?Q?Xk9BAtonNffdgGzXofA0FQ+xMq3Ok8bQ2EAfuXJsZZO2SSR1Srz34OJS1zNx?=
 =?us-ascii?Q?JcMiUtEW7YQAxT5QcIjE0PzRKGYLE7FMR2enSmXL3isnRbu16WN9gY8SmniK?=
 =?us-ascii?Q?WZFkY1/MNcNZW5xAGBTQqV04+zBoaS+OiTqgCOjUuVedy8NNOaNKwwAbf0hF?=
 =?us-ascii?Q?ip5jS9Ut8g/Vohql8mvwsj3HE6QLvoodA6631OGpPw3hRiz0pe6bm5c0qQc4?=
 =?us-ascii?Q?f11O1tDtiw4I/KtJA2g8LouFIXcKz7VUBeGkC+dp3vO/yyOeZARWlHO8yoLV?=
 =?us-ascii?Q?Djs49byFFscPORyaLvj2PcJlsXp0g3oTBgWfs1soGxHT+NgRdKxkLnEgiiqE?=
 =?us-ascii?Q?F0GwVjdGND8trV632647kxKLyGhHPFF1Bf3ndVA7jWFzz+q9X8q/KXmDly5H?=
 =?us-ascii?Q?pyy+6Q3e4h3vMhXt2zfoC/GNuNO385yyZ8lx5lK4MIbzq846vSs9uP+rpARw?=
 =?us-ascii?Q?a1pbIkau3ysYxiE235QTJ7R0+Fp7umjLby7hN5/x8pMnz0UlFp/dZc2A/wQS?=
 =?us-ascii?Q?Wm28CKUeXrWQcFBRzvA3W6e9yMkMuYTmA+qfdsg2VbaHZApeS0vMawmDcOOt?=
 =?us-ascii?Q?QtRUbAKA69hVchSTQeC628vrx5ZqSlJk2NxJ/oWiMepnQ/0D0AOB6A7gEVk5?=
 =?us-ascii?Q?CBpMLeH4Ub2janBW2HrRRJZbAlK2Ny9t1QSDVPXpfjwRgsZghxsb1/y7okjJ?=
 =?us-ascii?Q?0Mt5IgD0qfc/qjVUzuOv4KId3wxXnOrd2bwYRdI19oowuHF0DSqRtML95Bq+?=
 =?us-ascii?Q?GlLthjkVeGgf5XeOFzljeEbdXdhe31V2vArA3A8t0e77ilQpyTz2JpB5djnt?=
 =?us-ascii?Q?V9sLrZPYIGxMi0qiz0OoO7dq8cz9OWLSzvjVBbvoc4PMoyAY8MRIGN+jfp9c?=
 =?us-ascii?Q?Wg9kFaewzAaJkXXqiG3Xjgvq4KXuC5xjnTgXV09KjvhtUPYVIownV12sL5LR?=
 =?us-ascii?Q?39Q54hMlHPiAUIL/HDG4av5kIQCzZzjBhuBPUxfEo8UR7BkRTYeoyiJwjg1Z?=
 =?us-ascii?Q?M0hi/gweniaMivOefRcdBUog4GE0Z3OtncO/g2AGntXMwNI2RuK5R6BLuen2?=
 =?us-ascii?Q?zvTIMrm3ra0cGGGrD5VyrtdpcAka+7PpRlU9pnPEKIKzC6bEpJBTE0O9InBP?=
 =?us-ascii?Q?FyYzcT4cc59XxQUmJrtaXmS7PJGmWno5mqT6sla2SoAasWUkj6+zOdkOt+ep?=
 =?us-ascii?Q?2+l2rA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5oHdVau52b2Z63lHbe+g3hR4A3BMCO7prx6qxkErOzeL3WVUc0XlnFl70PpE5ZWsnW+IXb51rziBcxPO40WJb0NeL1lYciKTv9cF9gwqJDpASvgOYRgD4Bz63fTxp91aKoWFqEfI7yLQvJngzXfpIPZW6pjn6yRgYiUUASBO8rGikdFe6Z93Asc4DlqEdD4orZrdIWfb0POzpweUZ6I/8n3zLX/Q5JcFOs99wEtyFBPHGMOSzJhM16UN0U/oA9M5IshaCN+R+KUaxUyk67cI2Gr+YnsuWDfNXnZgHrc0lm55Zc7sBIgNBtCbUIOeST/PgH6C0lIK5r8gN44QQGU7MBuZ1bAyjrIfhYTv96k5SLJmdFTl2jMdjoW1hDBSiHDQQLHcfU0BqWvbwkw6wP6gC4N6R1tCqbDvcqoh+zKBDHREy9k6ObVY6HKLFrrCZMfc
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 06:45:21.3738
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d86ba1b-0e1b-4e81-4202-08de686ff63c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026C5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7520

Add a helper to determine whether a given Soft Reserved memory range is
fully contained within the committed CXL region.

This helper provides a primitive for policy decisions in subsequent
patches such as co-ordination with dax_hmem to determine whether CXL has
fully claimed ownership of Soft Reserved memory ranges.

Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/cxl/core/region.c | 30 ++++++++++++++++++++++++++++++
 include/cxl/cxl.h         | 15 +++++++++++++++
 2 files changed, 45 insertions(+)
 create mode 100644 include/cxl/cxl.h

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 45ee598daf95..96ed550bfd2e 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -12,6 +12,7 @@
 #include <linux/idr.h>
 #include <linux/memory-tiers.h>
 #include <linux/string_choices.h>
+#include <cxl/cxl.h>
 #include <cxlmem.h>
 #include <cxl.h>
 #include "core.h"
@@ -3875,6 +3876,35 @@ static int cxl_region_debugfs_poison_clear(void *data, u64 offset)
 DEFINE_DEBUGFS_ATTRIBUTE(cxl_poison_clear_fops, NULL,
 			 cxl_region_debugfs_poison_clear, "%llx\n");
 
+static int region_contains_soft_reserve(struct device *dev, void *data)
+{
+	struct resource *res = data;
+	struct cxl_region *cxlr;
+	struct cxl_region_params *p;
+
+	if (!is_cxl_region(dev))
+		return 0;
+
+	cxlr = to_cxl_region(dev);
+	p = &cxlr->params;
+
+	if (p->state != CXL_CONFIG_COMMIT)
+		return 0;
+
+	if (!p->res)
+		return 0;
+
+	return resource_contains(p->res, res) ? 1 : 0;
+}
+
+bool cxl_region_contains_soft_reserve(struct resource *res)
+{
+	guard(rwsem_read)(&cxl_rwsem.region);
+	return bus_for_each_dev(&cxl_bus_type, NULL, res,
+				region_contains_soft_reserve) != 0;
+}
+EXPORT_SYMBOL_GPL(cxl_region_contains_soft_reserve);
+
 static int cxl_region_can_probe(struct cxl_region *cxlr)
 {
 	struct cxl_region_params *p = &cxlr->params;
diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
new file mode 100644
index 000000000000..db1f588e106c
--- /dev/null
+++ b/include/cxl/cxl.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (c) 2026 Advanced Micro Devices, Inc. */
+#ifndef _CXL_H_
+#define _CXL_H_
+
+#ifdef CONFIG_CXL_REGION
+bool cxl_region_contains_soft_reserve(struct resource *res);
+#else
+static inline bool cxl_region_contains_soft_reserve(struct resource *res)
+{
+	return false;
+}
+#endif
+
+#endif /* _CXL_H_ */
-- 
2.17.1

