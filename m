Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2042.outbound.protection.outlook.com [40.107.212.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EC0196C7C
	for <nvdimm@lists.linux.dev>; Mon,  2 Jun 2025 20:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748897816; cv=fail; b=nEYftaLxnzpGjCmQGwwsyAZZlOgzTE+mcC/7aUAVgXbor3cgCjbR3z8Gr2o0vyQTNDMT1P1yTklexPRdZOnYJuPRv2IICnnODabjcuAXP2VeW/I6lmKgFvXKBEal2ugxZjXAimN00ap9XP9AbFZMv5gsfCeHcOgS0uhSdYN6W3o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748897816; c=relaxed/simple;
	bh=auux6vZaMMT9LDERL6mb53o8wlksAPRn2wotb5Mbo70=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CPupcvmhJIFTGXCD246rno0U/fxX1TyBDI79aRRioRBORWL4/5pFCiFmt5s0XTm/fKTtSnjUtyqpz7BMtM5qHuA1lI6IeSDKKxf9uO0Y2RCqAKcfl7uBCi3Y4RAfJVV1/ZvueztoKVfP+R2E+N+3gX4tzfzpFaIae3YBt0V1PSQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XgXSYz15; arc=fail smtp.client-ip=40.107.212.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XgXSYz15"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K9ftZIvXVaB6hXit23c8+L7X6lPF4VxEMi873lJ4osGN8C8ocEwRLVqr4MuXWcpUlLKDKIgqhHJKkYUe3OLVhMH1OIjkcN/pvDWGl3MT3ow/Fbv07EXogc796UzvpcrQlo7CrtwLwKQUrJBWZpys/dBnEyI29Gz9K/ybwp6YyqzWQvqTJA9B8IK6uLfp0X/bcXbHWq3LVK2Ylz3u7JPBUgloA65LFwAaMxjPPOvC/ZWwujVWQ/2r6doFvpND90eGMBhAyoJn9dhILZtA6mAXdRnQfvVkeUQD0tVEk7zh9OUSANVdO4g1L4fAqsklDIzLaksXY9TrC2fifSoLHq0qIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bQJM36l6iWi7zzqyWgI4vOEZYMGsBf73mhJbDL68mW8=;
 b=MDBA0tYaNGSd26NiI63nIFKy8AoOcyUWe3EQaT1jLcw7L1eIvqKYBfTMwCtwUxrXdFyAn7e0jPSocOx8qzEFVdC9/7DShcd5MoCI23NdlB5ZtEjXz9pR4ObCob9RXGEo2SL+8UUYnuOvlOPjB4gP165yNWw2lQlIffaBCwK1ovNu2B70oEi6oMsJi3NnhfOI1WUIhuyP4KhPbO5y+FdopwEk55kw4J7655dehX8jaIrJK5gBZs9dGYfVtPCxWVfx4u4bnNMTS+05H57BLU1Rbhn6tuIa81ucENCk86JO+T3UTS6EztpXEDJYLEa9eIXCeF4jfSOB6cS22uuJZ/V/yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQJM36l6iWi7zzqyWgI4vOEZYMGsBf73mhJbDL68mW8=;
 b=XgXSYz15ibyXeu2jylGBoFThCX0kBEv9oIBid8hQegLVOC6cumXYQjmIi3UPx5Ck1b+XQOfNp37qWWXCcKsfYslOVhJXFrQdekBIc65PA+4rseUrnqC/ye9PYetdJCRavG7IloL0Sio816hYHtsbZeXXJSP0oQfwRl3ZisyelRU=
Received: from BL0PR0102CA0005.prod.exchangelabs.com (2603:10b6:207:18::18) by
 LV3PR12MB9267.namprd12.prod.outlook.com (2603:10b6:408:211::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8792.34; Mon, 2 Jun 2025 20:56:52 +0000
Received: from BN1PEPF00004689.namprd05.prod.outlook.com
 (2603:10b6:207:18:cafe::fa) by BL0PR0102CA0005.outlook.office365.com
 (2603:10b6:207:18::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.19 via Frontend Transport; Mon,
 2 Jun 2025 20:56:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004689.mail.protection.outlook.com (10.167.243.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8792.29 via Frontend Transport; Mon, 2 Jun 2025 20:56:51 +0000
Received: from SCS-L-bcheatha.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 2 Jun
 2025 15:56:51 -0500
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>,
	<alison.schofield@intel.com>, <junhyeok.im@samsung.com>
Subject: [ndctl PATCH v2 1/7] libcxl: Add debugfs path to CXL context
Date: Mon, 2 Jun 2025 15:56:27 -0500
Message-ID: <20250602205633.212-2-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250602205633.212-1-Benjamin.Cheatham@amd.com>
References: <20250602205633.212-1-Benjamin.Cheatham@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004689:EE_|LV3PR12MB9267:EE_
X-MS-Office365-Filtering-Correlation-Id: a79db74f-5bc1-4860-14eb-08dda217fffa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Dmgj3X1fWhbUSPnPdrYE3HJvHblJmBebj3OT/t2bRzeIzb7SMbLGZn+Myekb?=
 =?us-ascii?Q?2zPo+deB6Bpp2QjvsvKGIpKTnF/tBXLqYm+zUnX3AM8XApycsx6+3U4ZxC2I?=
 =?us-ascii?Q?r1yV/KacqP/E3p3xzOOg0kRU0nOGYLTVMNQ0kvoknvDA3HemxAEHgJPnJPCx?=
 =?us-ascii?Q?c1U/qFL/UfC0GYO9lzwEfcKMUOp/X5xlZSIdtsZa+b30vXcFL/laxw6y6O+B?=
 =?us-ascii?Q?AxHHdAWIUXf3p00Dex6ipHYHns8F4bn1jIM80btyACPFLRTt4Y0K8VmCSirG?=
 =?us-ascii?Q?y8x9RCdchp3zfrjLEuyAfZKrl4xWUVi+d9XhrLfDEm7Sxlrep202KblOfND3?=
 =?us-ascii?Q?f5ynSYEGCU/oAJAmD8D9AYMjFR/X38DOl4XrZf073mTm2aKSsZ8sJXryfuDw?=
 =?us-ascii?Q?XPqNgtfc4E23b/op4SPzGisNJHQyoKhvXefAg9z+1bYNaI1W+za74pRJn1pd?=
 =?us-ascii?Q?vz9vRyGGoJIG7qGGHavzueayhG4naPMK2CcyASST6ObdgbWyhr8KuD/5C0Dz?=
 =?us-ascii?Q?YQW6Hh+ZuJWpUq5yMs8uyH0l3f9ZQzPnMC3+B1mibQFIVbA1Ihwa7mIEeiwK?=
 =?us-ascii?Q?fZFJLVT5NWlzJ0U85jpfkG+YvkeQGA9ThNnWX6zFdk2ezYIRCatRIiZXtefO?=
 =?us-ascii?Q?gZ0Cnukzdxtdl3k1R5avnmVXx0F3C0aVUlVv5eU1IXNOE7z+YaIg7JC0QkWi?=
 =?us-ascii?Q?brMh/hwTngb/TY1/ebQFp2zdv2hlBsnRUlJcCG0MXSWOd1ciTUl8DByb70QY?=
 =?us-ascii?Q?UkSYGwfhJm2WVbUkqV+SyvQHcjOo5rlGSHHbMkN5OsVYqKpvKHQ6YswXQVCd?=
 =?us-ascii?Q?gXcvOkgR3UevQ++fRBem+18MoZ+PmPZgYXHAO/byPTdCXS1LgURoy1F+ueSL?=
 =?us-ascii?Q?Z7WjFbp0xW5ANzKjljXHyAG/TyPv7KeYwKD304BsbSchjKpuHUdD57hU02pG?=
 =?us-ascii?Q?2KuSicVz+IHCJ/K+Y21eofFTEbjeK4qj5uTgDdK2y/2U8ccNk2F3xpQh2qPF?=
 =?us-ascii?Q?ra2lVW/5nJCbfHecJ9wKfB5zwfsoG4DO/3BP+mObk9+zihX/VCPHAKxPBib2?=
 =?us-ascii?Q?fvuiFpl/XqCnQWlb3c44nmiyuvCrojq1EuXa9pe0tv4p/8aYq2sOkLb/4ukL?=
 =?us-ascii?Q?olIMjUB/qW9xwj2P6l43H2yttOMQYaFG6+oTNmKYhit6qdblunc5g9WhF1e/?=
 =?us-ascii?Q?WHM398H76uZd6re/VgSPJ25+02LIMeOX54lhIoDuxpGENjDG0tdZZA+Q8MwK?=
 =?us-ascii?Q?PD5HVgg8OOaPp1xGKFUv1G5CkEhpWv1uHHqO00nsqF5RR1x9uesHORitLnxm?=
 =?us-ascii?Q?7x0zr8R5WmP+ye/8TXnIJT5mZrqKxKd5/a/HppHGirCb6c9NUBge6Wl8KPV9?=
 =?us-ascii?Q?hV8dRAvDRzD3QEOfUabCqPc68ftdMtdaZSxabI+sA3q0LWQHygzvstT+e/qm?=
 =?us-ascii?Q?gPyvSX8o7felcF64qP9S1ht1Pk2c2Pb4hZtYcPogKaH3xegyyLiGprzb+/OA?=
 =?us-ascii?Q?7RwTqP2Qh4uS0FwvhuTQT5z8R4qNsbEcTi0b?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2025 20:56:51.8571
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a79db74f-5bc1-4860-14eb-08dda217fffa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004689.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9267

Find the CXL debugfs mount point and add it to the CXL library context.
This will be used by poison and procotol error library functions to
access the information presented by the filesystem.

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/lib/libcxl.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 63aa4ef..3e0aa5c 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -54,6 +54,7 @@ struct cxl_ctx {
 	struct kmod_ctx *kmod_ctx;
 	struct daxctl_ctx *daxctl_ctx;
 	void *private_data;
+	const char *debugfs;
 };
 
 static void free_pmem(struct cxl_pmem *pmem)
@@ -239,6 +240,43 @@ CXL_EXPORT void *cxl_get_private_data(struct cxl_ctx *ctx)
 	return ctx->private_data;
 }
 
+static char *get_debugfs_dir(void)
+{
+	char *dev, *dir, *type, *ret = NULL;
+	char line[PATH_MAX + 256 + 1];
+	FILE *fp;
+
+	fp = fopen("/proc/mounts", "r");
+	if (!fp)
+		return ret;
+
+	while (fgets(line, sizeof(line), fp)) {
+		dev = strtok(line, " \t");
+		if (!dev)
+			break;
+
+		dir = strtok(NULL, " \t");
+		if (!dir)
+			break;
+
+		type = strtok(NULL, " \t");
+		if (!type)
+			break;
+
+		if (!strcmp(type, "debugfs")) {
+			ret = calloc(strlen(dir) + 1, 1);
+			if (!ret)
+				break;
+
+			strcpy(ret, dir);
+			break;
+		}
+	}
+
+	fclose(fp);
+	return ret;
+}
+
 /**
  * cxl_new - instantiate a new library context
  * @ctx: context to establish
@@ -294,6 +332,7 @@ CXL_EXPORT int cxl_new(struct cxl_ctx **ctx)
 	c->udev = udev;
 	c->udev_queue = udev_queue;
 	c->timeout = 5000;
+	c->debugfs = get_debugfs_dir();
 
 	return 0;
 
@@ -349,6 +388,7 @@ CXL_EXPORT void cxl_unref(struct cxl_ctx *ctx)
 	kmod_unref(ctx->kmod_ctx);
 	daxctl_unref(ctx->daxctl_ctx);
 	info(ctx, "context %p released\n", ctx);
+	free((void *)ctx->debugfs);
 	free(ctx);
 }
 
-- 
2.34.1

