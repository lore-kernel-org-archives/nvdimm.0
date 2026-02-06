Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012011.outbound.protection.outlook.com [52.101.43.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5063231280C
	for <nvdimm@lists.linux.dev>; Fri,  6 Feb 2026 21:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770414628; cv=fail; b=YnldzbbAzMN6PWiZ8CRXPbDf4RQyIpUcrVH0j0LObYbrJW0Yjif/yQ2eca6r2wJa5QSusAYViRwilh2HrigEYhaqYVf5Zf/cSNcB5zj8Tt0s4AO4GjzlCUZjN5zEgdUFgZ4aAHCjMFzPA5XmzZzeS++CqJWGbyRtzwWSSMUu1M4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770414628; c=relaxed/simple;
	bh=QMpTWT+BWtAIYsKf3H26i/3W1AWSBsZSQtSwgAW0UFc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TanRUQkZKkZ2RzmYdKjfnnBdtQBpbHzIARrFAflboXbDUhaaQMIUMy1J/34M8gnDmqhHkfgbZOI2K7gc6Xu2NB+G6K0NCiqY8kNt0xlYwi8WTlgB5IgzGGBBZ/ExlYXLpvQT8wTWhRrmsU6xjx/dHKSMmb/Qgrc9g2I3444QljE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oUaeHWWb; arc=fail smtp.client-ip=52.101.43.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oUaeHWWb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XLGxJcadXJn1iTif8MME6+GsbAcW1gW3hPgW9E5S+JjtIdcq5s7JfQUwnklf0k2NAo2UzARU2OU5ZJQwrjbNcpUJH3BGi5BkQ+4SBwvON/XUYGx0UvEoXvaik7bvVTHO/5Jl73c8Tq3KfvGeig9gYxdlKCEwtQwEcCcL78batkeCPQZb/jxx+8t29T3KW5zlyYry90A1XD0KXd6jxC2mx5e/3SQFwIIy4rN63qbzi8+mfKB3BLsSbJxkBtVVyE+GkXo8A+zE7ZLRzwHYVN6IB1fWgpr1Is1iiZDofWw873byOYJejR6A9ZQoqxOXZXEsin58wQAC3rYAYcI+BJtU4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/RCtya2Ut0o6tu3/JEW7mEMSAa9qTA35Ockdz2qzAIs=;
 b=SguIThaW8CbxXYrkIq6L2Y3enS50skxzEhCVBvd+0CuXiziixiwZm7vXyXNIooXHZfagoOwe3WK9QUbd98z7Mr8hJNhjOjxETc5K31+lbZT8++Ei0SSef4kGXnv8phGV921u+VCX8pmoO5GRPnl1uqDorPHTEZJth6NdL80wBLhEPocGj3nDVTrn82DAhkicGQ2EkLzpsepbRkmV29D60deRwoAqL0/XU1fEhnm8XSZwiRZ6XjTsidBwZH5n29r8kBnmczSaXZjKOhccMCDsX6xJdB3dzjGXGTHtzcBtLbv5M+rhkMBCnqMeesrZHgR9MsdoHoLcKUVadYLA41nycA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/RCtya2Ut0o6tu3/JEW7mEMSAa9qTA35Ockdz2qzAIs=;
 b=oUaeHWWbslF5H7E8WMzIDB+iTb64ktsBS1BdNEqHcPNtil2Yi2kQLuc+wzcQqNyfmlPgAyN8m6JCfet8bQCms3kY5hTy2c2PGaCkuQjxAP7gpyq52sCR9j3y0xsOL4o/BeqwNJ33TZfNqpD26cVBOrgmseaH024u72Tv2FuMx14=
Received: from BLAPR03CA0076.namprd03.prod.outlook.com (2603:10b6:208:329::21)
 by SN7PR12MB7252.namprd12.prod.outlook.com (2603:10b6:806:2ac::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Fri, 6 Feb
 2026 21:50:22 +0000
Received: from BL02EPF0002992E.namprd02.prod.outlook.com
 (2603:10b6:208:329:cafe::2f) by BLAPR03CA0076.outlook.office365.com
 (2603:10b6:208:329::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.15 via Frontend Transport; Fri,
 6 Feb 2026 21:50:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0002992E.mail.protection.outlook.com (10.167.249.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Fri, 6 Feb 2026 21:50:22 +0000
Received: from ausbcheatha02.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 6 Feb
 2026 15:50:21 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>, <vishal.l.verma@intel.com>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>
Subject: [PATCH v8 1/7] libcxl: Add debugfs path to CXL context
Date: Fri, 6 Feb 2026 15:50:02 -0600
Message-ID: <20260206215008.8810-2-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260206215008.8810-1-Benjamin.Cheatham@amd.com>
References: <20260206215008.8810-1-Benjamin.Cheatham@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992E:EE_|SN7PR12MB7252:EE_
X-MS-Office365-Filtering-Correlation-Id: cb95b9ad-c80d-45ae-e37e-08de65c9ba49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013|30052699003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9k3Q+2/QRnMicvpBsTjS0R6VfpGrFmMZ+T1YsIC1jJeeXlrIaU5KPSY6eIGJ?=
 =?us-ascii?Q?JhRUgi7AvfzQexvtOU6wi4r0JljQdotLvwuZ6YtaZizeJabDv8b/P0djE8gu?=
 =?us-ascii?Q?HKyqUa8qcVHp+tlxxnAENwXwtVLFvL7Dq8hWIhtJX1TvRgopELNrbzIGhEW+?=
 =?us-ascii?Q?oCvkHGcwmFT+E0b1PivLqyBFO0mO8dwFKetgpzkHGkXNa2Q5BS94GAPrMMP1?=
 =?us-ascii?Q?t8ufrkDaIfL1K3A2InpHl/9QkvZKCd6OvTKvC2K8fEcHjtaJaF1kGjUgGLq1?=
 =?us-ascii?Q?imGADZsgLoEhoc5lPjjs6fdmTDrrWLqcLVPnoRCUvxbyaMyu+CLSeOt42YhW?=
 =?us-ascii?Q?mPFR0CzZbGLcGG7+1TlDMgVzbOnw37wOSVI8yQd2pmcJZk/eSHUCB9/GXIfE?=
 =?us-ascii?Q?E8v6WyNYwEZidHIu97iY9SVEW2BidWmZMBSBinmMn+Fg15506eiX/TlRTGvg?=
 =?us-ascii?Q?EX1MJTcYvxAVDrAQWnjyPaHDoPWgXstJAHCdYsxPfTq0jeNimVg1GPql5URA?=
 =?us-ascii?Q?vpTzX5jq8ET+RgMs0NGK3TJhkR7u8EHnvEgifuEh6o2Fl3jsyOMaVD4ln25M?=
 =?us-ascii?Q?cCoPfUw3LWeo6+zdrlg0t7JTv3IxDvJVgdnJZTF7c5dkWb6Az0hJUb9Q1KUR?=
 =?us-ascii?Q?+jvZ+4pr6rYr1eWSUnSBygVw7KxAC6uDhAtuymBB3CCCLdFR0m15SZO28EWq?=
 =?us-ascii?Q?Z0fCODc16qQR8FbYisyypovLFs640UxPhZRD4V+6jGJGkmIgLbB/Xfemh7UH?=
 =?us-ascii?Q?Ubw/8hDintgkN1AkAsT7dnhuJDYL4yA9uBi1X99kdghI+GF4fDSdoyABqvcQ?=
 =?us-ascii?Q?oSx58Uh7+x73kSkCKNADttE+ZiNIXSU8b6DuHvRmyme7BRV/uQNMxjolZQP0?=
 =?us-ascii?Q?NyzDSR+MhyfBwZvjxwcFrqo1cZrJC90VzK8IFJvHjJtcBpcDhQKzDm7tlmUi?=
 =?us-ascii?Q?xTfzxb/KgFW8YUXdBsnUgSTt4VAbBE30qBMx/jY9s9mq5nZPOXcgw4Hr+5WO?=
 =?us-ascii?Q?NtrT4r/PA25zEFUeleUksRGlWHSNyljJVvArq6xH8E33SyesZCYSZQBX09OQ?=
 =?us-ascii?Q?jzKlKCXy3vbt48g4yp5bNbcrRGBSDs7y+g2kzXpKqwac/HWYmEEmYKT+amwD?=
 =?us-ascii?Q?bNkXbXa+SmCwg9LMqcIUwj6k21Lg1XzXYCFQCUhgbL0DXTR0T3fxnA7jjSIT?=
 =?us-ascii?Q?k7JOcIXYZseGDInVCpodgSfNKzNWZo1ONlxb2ldtBqTKyv7djSliBqvBogtZ?=
 =?us-ascii?Q?IXmDnmb7c7VL6hm2kFoYczlLKs4Wuct1vVM4H7emKCwLovaYfrKPcRVe81dG?=
 =?us-ascii?Q?ML7TFDx/G2ZQkV8mvxA3AIyjhCD3zc91NlRr7wgEOLQ/wYJUJ/4UzEjnepEs?=
 =?us-ascii?Q?951Z2AGrHq9JBm0cTcS1WkIO5zbfVVQNIUGClYugxjVKelComnVI/y5OU92Y?=
 =?us-ascii?Q?74ePwjpD4uuhYP3JqRZ3zKgA5Su6a7CXIdmnK6gP7cypyVPjt6VaWuC2H/U6?=
 =?us-ascii?Q?uvwJkJ1218uUtrDNVmI5gOej38sz3+1Csq7VFReoWjGNN0SXUFUR9/HxxY/8?=
 =?us-ascii?Q?IHIhdwnVH+DJY4Al4/14nBQdsHyFy67x/uBKB1ZJCud0bVLSw9xlTqQbC84d?=
 =?us-ascii?Q?1hac7G92nK7ZKgnZ/1t+O0DiUH6diGRYifoS7s+KYB6pxFpWAvD8jtzNSb6T?=
 =?us-ascii?Q?5+wIbQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013)(30052699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GEZXY9AUiCv7PvfkJbwx1VlliTGsU1HOrGZeVV5WUD1Ec1uW4IcGqPRN3BAacBqjm1ChMXM3skf6tos1xhxclckSTb1dAyiYSxgKmn6eJrZjNjnF6KUI3jeJCzCjLtnA2uPqEyHMu1bCJRsruSzBu9BOzuIeEXeaZwWig+65eZYVwjPdpzCBISThy4FyeV2oyspgVqDOZO1mFGd4feU27zhV7z/Yq2imAG6jjWCA1CrlPHqtlaPbIaURB62cdXcWnS232ehWR7bTiZSJAYbtZX7fotcvPzCMk8i/PAqiblBLQ3VPPMMEAjMOX+OyCce+2oq7MF5Ra2emHWb4LAUeGvEot43vGCr+EsO0xentdw0kNgelpJHzsj817qoq82+SugeXLOWpKU6KvPn13PLZeCsi4JJ1N/8cRG0dz7vqd+OAtoIxHBKsaGboNy5IMu+d
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 21:50:22.1063
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb95b9ad-c80d-45ae-e37e-08de65c9ba49
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7252

Find the CXL debugfs mount point and add it to the CXL library context.
This will be used by poison and procotol error library functions to
access the information presented by the filesystem.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/lib/libcxl.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 32728de..6b7e92c 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -8,6 +8,8 @@
 #include <stdlib.h>
 #include <dirent.h>
 #include <unistd.h>
+#include <mntent.h>
+#include <string.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/types.h>
@@ -54,6 +56,7 @@ struct cxl_ctx {
 	struct kmod_ctx *kmod_ctx;
 	struct daxctl_ctx *daxctl_ctx;
 	void *private_data;
+	char *cxl_debugfs;
 };
 
 static void free_pmem(struct cxl_pmem *pmem)
@@ -240,6 +243,38 @@ CXL_EXPORT void *cxl_get_private_data(struct cxl_ctx *ctx)
 	return ctx->private_data;
 }
 
+static char* get_cxl_debugfs_dir(void)
+{
+	char *debugfs_dir = NULL;
+	struct mntent *ent;
+	FILE *mntf;
+
+	mntf = setmntent("/proc/mounts", "r");
+	if (!mntf)
+		return NULL;
+
+	while ((ent = getmntent(mntf)) != NULL) {
+		if (!strcmp(ent->mnt_type, "debugfs")) {
+			/* Magic '5' here is length of "/cxl" + NULL terminator */
+			debugfs_dir = calloc(strlen(ent->mnt_dir) + 5, 1);
+			if (!debugfs_dir)
+				return NULL;
+
+			strcpy(debugfs_dir, ent->mnt_dir);
+			strcat(debugfs_dir, "/cxl");
+			if (access(debugfs_dir, F_OK) != 0) {
+				free(debugfs_dir);
+				debugfs_dir = NULL;
+			}
+
+			break;
+		}
+	}
+
+	endmntent(mntf);
+	return debugfs_dir;
+}
+
 /**
  * cxl_new - instantiate a new library context
  * @ctx: context to establish
@@ -295,6 +330,7 @@ CXL_EXPORT int cxl_new(struct cxl_ctx **ctx)
 	c->udev = udev;
 	c->udev_queue = udev_queue;
 	c->timeout = 5000;
+	c->cxl_debugfs = get_cxl_debugfs_dir();
 
 	return 0;
 
@@ -350,6 +386,7 @@ CXL_EXPORT void cxl_unref(struct cxl_ctx *ctx)
 	kmod_unref(ctx->kmod_ctx);
 	daxctl_unref(ctx->daxctl_ctx);
 	info(ctx, "context %p released\n", ctx);
+	free((void *)ctx->cxl_debugfs);
 	free(ctx);
 }
 
-- 
2.52.0

