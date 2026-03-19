Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012016.outbound.protection.outlook.com [52.101.53.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0079C2C027C
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 01:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773882937; cv=fail; b=UtUYMjqisbxdVpfEW3RhvdjqnuLfbLaWYxKVxvOdyEXcZx+5aaKGTV5Kk3Na5WPMr0LgsytTJh18erJTguYnoN2ESoWKqtS6hK9a6g+zqlM1efLK44ruBv+9ddNpnTIxDd2U5qB0L0ik9uJaHdpxlfPOzaDz6Q6TeE4EN2HZ3tc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773882937; c=relaxed/simple;
	bh=4Pz8zuLPpAfB1mfqyilZgIDPPyJmXI7rO3tzaUJvq0M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rtr4mE2thvutuy7tCuqoLK3VlQNmbKKlt5U+f/oPAX58W6WQ//Ex8VYIOxb7Omet5rhsc42ULa0h2RHiVjQzJYsjbraxwUVlkk4lQj8DNiYxCw9DakN7NmQhwwTlsoaW/hVzPqXnRRAkhbEyrWLuUQnM8lEwzAoHaUudoxtfV+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FHjdK7+L; arc=fail smtp.client-ip=52.101.53.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FHjdK7+L"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Is02ymR2ssnfAwac5PQP7GgECCYSoYSChkjhH73Svq4hWpdfXhnoTyAl1Esk0/i7WsBgVDCbP9Up42SUH/wEa8KEnngkEUBi43/lVCdZhWogbY3jE4fgirr38K34CkgKKpB0dcLdO7LpfcNCcLtP6id3HLkAS066cLRc/6fj3nEmGM4I8/y+dAaVRnVsW80AXKlQkRsjipodufGuYXjD6pvTJkT/6kUgDvbRwN9EtJPLKNcU33IOjPIHNUhWIPHa3J+BlE/P/QP+fx7eRUX8SqHtdcN65s0JFiLD25BW+7JiFNG2F8+TsmMFjFn12i9f/eiAsZFQmcMwKFT9Kc9XSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8HMj2L+2i0e/npbp46MnVUz7w0yK6u/uXYdI0zE2rEA=;
 b=rBP1VFdSCC4wSHzRKpOsWnwOnSt7mv/M6Fzvc1P0mAsHkRUhq3q4iwblzsPJx32VgivqGZd5KsyxndC0myxz2k0YzyGsKuCxITAf7qDJYtSlFWee2y+vNhhsAO/agwGoOc6NgkVT67VK89a+7c/R5hPm3oaQWAxrFHLXX9WBbH7c6jVkspHGcXx2ObRAGOHjiPCTAOwF2jCiA89AyK7OfhaN7f5U6ISevtrJs11j2OsJVKxBknHsFfrHzTBll8Isif8L+il1DDHUoGohrnJhjbex1axpQxhyNJa6BewecYUmqwJm+jPD178XjIIdE+gbwVvLZzbP8yURd8kBzT5ywg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8HMj2L+2i0e/npbp46MnVUz7w0yK6u/uXYdI0zE2rEA=;
 b=FHjdK7+LPteljRoV1JrIEM/J0kFbtEhG3j5RXsH9MI0JNcRC/rdSnu9D0a9uMpCJY75O8O2DKMX1qcjnLEzpt6M8fUilHygWnQE3hM8VO20bp3ZR5Ia/ZBMMxT8Nh2b0K2RR+H/eMwEomAwPfKF1U9TzFjvE3snAp/nQ9f/DF7s=
Received: from SJ0PR03CA0376.namprd03.prod.outlook.com (2603:10b6:a03:3a1::21)
 by CH3PR12MB7617.namprd12.prod.outlook.com (2603:10b6:610:140::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 01:15:20 +0000
Received: from SJ5PEPF000001D1.namprd05.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::5e) by SJ0PR03CA0376.outlook.office365.com
 (2603:10b6:a03:3a1::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Thu,
 19 Mar 2026 01:15:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001D1.mail.protection.outlook.com (10.167.242.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Thu, 19 Mar 2026 01:15:20 +0000
Received: from ethanolx50f7host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 18 Mar
 2026 20:15:19 -0500
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
Subject: [PATCH v7 5/7] cxl/region: Add helper to check Soft Reserved containment by CXL regions
Date: Thu, 19 Mar 2026 01:14:58 +0000
Message-ID: <20260319011500.241426-6-Smita.KoralahalliChannabasappa@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D1:EE_|CH3PR12MB7617:EE_
X-MS-Office365-Filtering-Correlation-Id: 49d6f362-8f31-42bc-56fb-08de8554fd3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	E30iZnEFWhmfeBpyqdx3uQH8BbTckG2AxAlWNUDEl3lNFU4XbGgz3EnaGQuWC6ja/vTMn6o1+L9WST8bPRk1Lh1cgPZF/y0uT2poGjDa6s5CovxzqAMceavg6ypeH7ZH61TuPbIJf07vXYkx5ssXyTIZGqdkh9ELR5i0l5yuOp+EF6/Jf15rmUr54+eaWVWNKhKp5m+IL+NRIroI45C+z6+5rK4e6mwGgaWVTwcVonP/JB8rpsP0MaGMz4q9gmDkjFQAn6Clt7ADFl63+ntQeqsFb9bLlJCsfNUwFn9219TAZFWnRiP5G1i5spQv6QCNH0j5Axqj7YQCWyZ2vXjLVYUgJWwy2T5jgo1OW8wFX4PloPcFXoGlEJMi0NRGSGXyjW2M/g57Riwvslyg9g+xtORIhPgpWDYKxzHoxR9iTJyhZ24msk/RSjwDV+1c9ydnv8FLOpw8w7upJFD/Ky6HjczbbvAWxpdSTPvbHCk9yfzVflEdkNXJq64DjLlS2/N+qPw/fkt7eIm3nB4o+yciWVAolyOQTC8W+45O41EJU31BlkdLzMOQk/7HzynwYyqPrnfZirVOSdbXV1nF39PBOnj2pzpoi9wSG4JzfOS1mq1UR0/s5UYaBHuEakV4Ur4x008fDjstpflh/FtEPJB0GT2bCUWTlMze2Kk6W78A7gOIztVrs3ZNkxAkcqYYrORloCJnV/Pcd0OTzmPHELMMKfb/jRzUnfz3r1okI66Ol0mT1VRENNYFlAodO+3Vs9rcXdQHNEXLE6RwE8de2HvQ7g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dwTOgNqCmSsq9yJBjHy0tJmFXuWU9VxN0wdnhbCBsD63yIwqvqMUbyxJuI31P5ErbSsDLUpOgNWGNvvdYFfV7/fbObBzQJCnZ6OauusPyh5XQERGMRqzpUBz/43iqfxQ7GGBBDJK01wjad0SE3E9AAGqO/SJg3SzPAq64Ovbk3ZpskZQibJT/MvOzHME0/KRsPNHfddmfr8oReMNOKGWUwoSOSALtgzYY2QY9qXw0OtvPmA00wzi75Yz++FlyPnTqk/zOg9ElWgEeA6TAP/cBenygTIH6TvJKcINCgevcg7oB6UtJlztKHOrZQY2+VATdlzArYXd/D1gTxFbsl+sjvzM5XqnoTpZt0D3J/GPRl498fUT7KK7YPgw/DALodoKVotrvdU2e49+ND+yiZYbNlsEkHZezKFA1W5o9OQQK+7EanIKShBbPP/QrnFjl6x1
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 01:15:20.4624
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49d6f362-8f31-42bc-56fb-08de8554fd3f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7617

Add a helper to determine whether a given Soft Reserved memory range is
fully contained within the committed CXL region.

This helper provides a primitive for policy decisions in subsequent
patches such as co-ordination with dax_hmem to determine whether CXL has
fully claimed ownership of Soft Reserved memory ranges.

Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/region.c | 30 ++++++++++++++++++++++++++++++
 include/cxl/cxl.h         | 15 +++++++++++++++
 2 files changed, 45 insertions(+)
 create mode 100644 include/cxl/cxl.h

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 42874948b589..f7b20f60ac5c 100644
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
@@ -4173,6 +4174,35 @@ static int cxl_region_setup_poison(struct cxl_region *cxlr)
 	return devm_add_action_or_reset(dev, remove_debugfs, dentry);
 }
 
+static int region_contains_resource(struct device *dev, void *data)
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
+bool cxl_region_contains_resource(struct resource *res)
+{
+	guard(rwsem_read)(&cxl_rwsem.region);
+	return bus_for_each_dev(&cxl_bus_type, NULL, res,
+				region_contains_resource) != 0;
+}
+EXPORT_SYMBOL_GPL(cxl_region_contains_resource);
+
 static int cxl_region_can_probe(struct cxl_region *cxlr)
 {
 	struct cxl_region_params *p = &cxlr->params;
diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
new file mode 100644
index 000000000000..b12d3d0f6658
--- /dev/null
+++ b/include/cxl/cxl.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (c) 2026 Advanced Micro Devices, Inc. */
+#ifndef _CXL_H_
+#define _CXL_H_
+
+#ifdef CONFIG_CXL_REGION
+bool cxl_region_contains_resource(struct resource *res);
+#else
+static inline bool cxl_region_contains_resource(struct resource *res)
+{
+	return false;
+}
+#endif
+
+#endif /* _CXL_H_ */
-- 
2.17.1

