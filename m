Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013024.outbound.protection.outlook.com [40.93.196.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0024B37F8A6
	for <nvdimm@lists.linux.dev>; Sun, 22 Mar 2026 19:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774209251; cv=fail; b=INDfsmvdsp+zhxBikKHsQv6uQ1SWaB90Oqjo8Kg/+REzoMkaz1Ow+Gz+kDdlCvAHoDbB2PXKQ3guyJ38RYwTRIMBVrOn1gbiVsMlgHNxtUtNvwgG7onAtex5IwOVY/8Fbk6Y/x0C/yRejzUlhu5393+Ro5Z9PVbZuT4oztHZ+u0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774209251; c=relaxed/simple;
	bh=4Pz8zuLPpAfB1mfqyilZgIDPPyJmXI7rO3tzaUJvq0M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GEy/A+deKu3A2xwCe+bUTQzN6Ro4K24shYW6rFfuTVwgztNLxyWP3LJHHi3l8arAeb9ISAJvGXmDGpZewR/kO6BVc4J1V/2z41HUH2ojD41iA3+NSAK3Ltmvx+NU7EewHdk17EN8a2khnZDxDGLGynOBJPj2E58fo2AMSV/FVao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=e/99mmOb; arc=fail smtp.client-ip=40.93.196.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="e/99mmOb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gLQwapgyhwcxqxr5OH4LYVPBS3LLcWs4mCkqyd9GtE+rXR/0NksYIX1+Tk8yDgRiu03DC+mkjMUigjntLVAIip+Sqail3idBxWLIPDnc9ysSHyx63TQPZIAMUuCWnC0o9cL8ISCjvEN/46zQ7xqiW2VLl/l6whRXrsh85BPs9lfwSUmksHc4f0WKs3731Kq2zlsNxoEI0HBxqfTgzkZZ/LkAq4+T3FW6oiWZnn6Sie17PASddN6RiAKPIhDWN3vLSMJS76QIajQR4JiXZn1ef/YD+GvaFypo8CluqU85x9dUgnxIFTSEHBirgxWeOZxHTnUD70arn1YffoCqpnAzTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8HMj2L+2i0e/npbp46MnVUz7w0yK6u/uXYdI0zE2rEA=;
 b=pitUpiql2D1XFIGf44t05jL9SSJ2L6Dg1RQcSUs1zSjkp+YsLnS/PdSaFzS1jbbKvFG4svV6AYPmbWqZFUAyhiuQGzAiSKnp1qIp8r8JlyNUvjOQCGDie75j2I58xssIsrb3ALKmI3cpmxZzXCV46p0M8M1KAdCJKqW1vk0evCUtURqgBzUDAnI6fGCMUpB10TJVM5NkSSY2WpGJRim6EdUplEFaDO/SXkWwPf5oPXGWFrnRbmrLaf3lc4+WV0182ZLn3rIA4SOanpzX0exdXSdooxLyVV9yu/0j5HprcX4ZCi2H4yQQcCb7BRey1s4JnUwNdpGS2IvKvzOAhZuvhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8HMj2L+2i0e/npbp46MnVUz7w0yK6u/uXYdI0zE2rEA=;
 b=e/99mmObGWbCJdxpWGpD7MVw8PzkbCV63Ja6EezBTSt6GDZCMmhKoXwrwlv2Z+8JCXco6Q7O94coPIUCVfpE7S8AsxOH82AHvfWInA4Ob0WzX8uBAngMEXuCC1hP2MbF6+yJZ6W9zix9l1hyeuswkESJBVRZbWexSpFQcw5EgAU=
Received: from CH0P221CA0002.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11c::10)
 by SJ1PR12MB6169.namprd12.prod.outlook.com (2603:10b6:a03:45c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.15; Sun, 22 Mar
 2026 19:54:01 +0000
Received: from DS3PEPF0000C37E.namprd04.prod.outlook.com
 (2603:10b6:610:11c:cafe::c9) by CH0P221CA0002.outlook.office365.com
 (2603:10b6:610:11c::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.29 via Frontend Transport; Sun,
 22 Mar 2026 19:53:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS3PEPF0000C37E.mail.protection.outlook.com (10.167.23.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Sun, 22 Mar 2026 19:54:00 +0000
Received: from ethanolx50f7host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 22 Mar
 2026 14:53:59 -0500
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
Subject: [PATCH v8 7/9] cxl/region: Add helper to check Soft Reserved containment by CXL regions
Date: Sun, 22 Mar 2026 19:53:40 +0000
Message-ID: <20260322195343.206900-8-Smita.KoralahalliChannabasappa@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37E:EE_|SJ1PR12MB6169:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c6aec79-4b45-4afe-1989-08de884cc362
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	6CHKQi3PdnzbWpbdzV6hV8/gkyfAWhxGTmkTSkLok71GusyMMUMyM/b5lq0D0iitqN0qjpvKP2dQCt2hmUENKREiDk/hJWxO0ZtFUEIi4TVNaPmxjphbMxZJjkFPVkKxHzBvxMRwsyck86TJaG0Ij9TLcb9FqpCMGbPFScFy5cmileHdVxf55h+RvfIc4xAwPJBYutBzjODkoPiCo6IJg8F8ksZ9Zh/fbV0LWhB8UnN+Ia1P01IUbKwJ6A1qdpjRlBkFan+QAD/IyuV0U17O1lcBoqK3Jj/Zar/8zjJC1CEB9qACrvfW4FBmIThytM+FiqT+IX4K4zGYAy24I66SZhr08g+MUXOzjIali8ubWjElEf09DCKjFOnbPgpkLfdJxK6jRbwDDbUoNiQ/fdCk8yf94qB0K3GfXhOPJKs11UwZZlZjMPczxql9wZojp81sPt9NK4v4EOYWQgydZ391M6vp3bLww0mptBoUDxzZvc1AnFf1CXOv8+Sr0GO8fomZiboEXT5hDxD+v0wlUKriyabJw+7QxX1u3iGIrD9/BViic3acfAf6ThAryNgJIkf00qINTPcVFUTqA3XM7dgZbmRW/3jL79ZEE+Uxgnj/n+HZHU8mpDYyHGJeRIojNsayGttvVpcaSlCkd9LDxl6u5v7bDipj+Imqt30BrWYqmuG3hG5GZp0MpOjsiqfhUY6p5Vyp4aXI6/tCPBGfVdVuhOQa/vWnRS7e1BIPofsfSwd0UoktTZh6EVDwSurm4Ygi2DNaZVS2a1QrZnpMDFkKYA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	iBwrrmZxEiThwsw+1xYv/iwsrjL/IqJXV88duGxcluWQQj0nd2I31TfLPdJKrmwHmgvyqvotl6HP3cmUer4zk1XccZFaeZTcchl/v4v1QJFXIYyj7lqVSvo1IamdxnJIhy7ILINLmaECSRsd3jBvPN/K3qu/nJg3FpwJPU/02svNreyCu1Qk/WGm8SJW/KYgVKn5rHvUqJbs4O8qn9/g2BrpXxtIjPo9h8K4rh9jyjO/1Gpkw8ZVRcNMODTkGwoPpAjEUTuCVPu9apXnDhNteZzWpNUEzd4nlOMlWwAgLn7zr2blyaJQwiEr7SbLS1sNW/uXKgkgZM3EgAWeFPuK0PWOFyWac5s+1v8a3W5kzsHx3/1mvKIQeD8r5Q9pcaSJP1YPD/9FduWb4KbDlgDoWH6E+VR1wd5bggaRCzIAtyXlVCZs0+rceFejQRUa/swe
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2026 19:54:00.9613
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c6aec79-4b45-4afe-1989-08de884cc362
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6169

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

