Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013056.outbound.protection.outlook.com [40.93.201.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3E350095E
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 16:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767974855; cv=fail; b=oIVjJUe9i/TwcK9xGsSa9cFvr6kTCwgax7kXb0cS9m4cQP37hLQP/Fl0ws84m5QHZ4z4M4a/mw0qPG2YJ46uZ4huCQkmsv+YYzS7NidK+HSWlxESSLf4sYlgvEpzIMlEdEwhjUATo/HFzX5hT7nvGo1EUAiIaxv18EHbAA+AXLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767974855; c=relaxed/simple;
	bh=LuhJOPdRian/URR6TVRSmyArylESw4p4y97KRyX83uY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ik6mkYX/OaCvm3/1uOk+gq1icoJqH6RFA4xprpigjz+6w234pE2AabgQxtesyiUOcRIl/wpip0SotwEcCj5TP+Ktkh3UpTTEU1sdvtZA4ILijv/Vg/2BNq9F8TKv0yjFA4waBzG02/P648DuVLCABEW3kYrjhfZZD6YMKM6wlrY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2Rn5CWN0; arc=fail smtp.client-ip=40.93.201.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2Rn5CWN0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cNd0zGFs+/s3APieXXLUvsa/mKmc5WtwyJ5Fu1ug3XmNafoC38yLDln2darfyGW0iBfOLopwRU7q1fmwAGArLeNmwuOD3VvyezNvzTVfh/JdHqnLZZ18eLLs+1z9fJknzfwij4dB6BG5/MLpC7STZhML4r1474pCbBFreys3QbodUjPJXMnj0ByDoZBpv1KuMxkb3lmf2ki+dqLijLDo/dCHXCb1nxdAgzlwL6KkjgLMkyrvKeHTV9qJh6d1ZQIna41KJecjMl05opGr3UNcm164MNcysIu/Whzg1dAtMRq1R+PUHhM7BeAVdkmuTfvmuo8V0El6hH2sgsfi4J4CyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1k4oTT2aoHu++kQPplH0qpqYeIyFijN9QhVy4PNTdws=;
 b=NRIPjroMV/mJWPSspd1aKXmNTsCE57fZrzageZlgTM4b+yRj1PntDHSsJ3qQ02En9p03lIn2cVS/GqhF07lrmEnpjH24iUlB6OqEUyGG53oLu38vQT8BT46xavxYIxPTEiA/8AGk3Ey8lS5shqRVAJJotDlrUOb8R3a2RXu4tInGY7enyS4ZasDo74CbWXgAi72apJtfr4/GTQzsf7Dfh4+/yBiHWIrIlaWsx67C+BUYfVQMC5Nf++4VSws8Zk49OeozpdCxUrfZ1tD99pz0J5mRlXqMOyQJ32KWI7GL2/L5Vd4Wt8i+xcjsT7T2FQ6lUr9HsL3FC/yo6tyblcuXdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1k4oTT2aoHu++kQPplH0qpqYeIyFijN9QhVy4PNTdws=;
 b=2Rn5CWN01aDdWCs9Z+KVUFImaazpltjSYyO8GyroDqz8bPpyKiBQxrOyywaFEH7TsRaJYPILYnvDnvETrVhWpGffN8Xhaz2of764woauZU0eZ5KCwaKThkA9FJ9jS7vwnkbStFJgLDtI4GHrvvuQc5VKyMIOmrvUlEANvFNgoPk=
Received: from MN2PR13CA0017.namprd13.prod.outlook.com (2603:10b6:208:160::30)
 by BL1PR12MB5899.namprd12.prod.outlook.com (2603:10b6:208:397::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Fri, 9 Jan
 2026 16:07:28 +0000
Received: from BL6PEPF0002256F.namprd02.prod.outlook.com
 (2603:10b6:208:160:cafe::13) by MN2PR13CA0017.outlook.office365.com
 (2603:10b6:208:160::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1 via Frontend Transport; Fri, 9
 Jan 2026 16:07:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0002256F.mail.protection.outlook.com (10.167.249.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Fri, 9 Jan 2026 16:07:28 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 9 Jan
 2026 10:07:26 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>
Subject: [PATCH 1/7] libcxl: Add debugfs path to CXL context
Date: Fri, 9 Jan 2026 10:07:14 -0600
Message-ID: <20260109160720.1823-2-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109160720.1823-1-Benjamin.Cheatham@amd.com>
References: <20260109160720.1823-1-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256F:EE_|BL1PR12MB5899:EE_
X-MS-Office365-Filtering-Correlation-Id: 58899fef-3c7a-41a3-6ce8-08de4f992fa5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|30052699003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yWgF11T8mbXlInt6wv5L0eAD+Hdb4587NE+4LJzs0VSWZlcxkeiDXdEN9pnf?=
 =?us-ascii?Q?LUZWoheilTfFvkP86gYUs00A+SYSvqeQou30d6smM23KLNxWDafk6BmWA8x6?=
 =?us-ascii?Q?SPEYnDxmGhsU1x9cliGn5DHQaUfc/3XTcCJDzPTpXmO790ZtH8xbpSb6+AcC?=
 =?us-ascii?Q?9b7R0kkXPyZsp9egA1F7EUEBEXbVGd3uGwdKxHu+T9foVYizQ91rGDVcPImh?=
 =?us-ascii?Q?a5z7TcgH380E+1YxRq7ox5m6NCJYZHKc3A/VqG9ZIR4LDcyQX95d/qa4Rxn7?=
 =?us-ascii?Q?HVcFgJoCoeHdpCTTA2w1YaowPhDPU5IYSaQN0QYMhnHOg1snJ24cwhIhf/Ew?=
 =?us-ascii?Q?MQcyANqk039HBq6xXGydVWx+ICRv4ASnK5rKWF4bluac3bcopAZ6LaizfM04?=
 =?us-ascii?Q?XPx5cVVJLcDR1em00cSWOzb+mvFe4cRfCMHUzVwKeYLb1aQ/+iwNAIhw82dO?=
 =?us-ascii?Q?7TSD0zxaG0wbCUFMAFmXYJaViRZZGPtupB0EMdn6PMWgtpQDfnv0KVKPN3Cn?=
 =?us-ascii?Q?ULgDuPQU/Ybtp2ZBQJXjASJZu2EdG7lVVfBWOD0YAeB22jE0gFgtydoAy9Qe?=
 =?us-ascii?Q?hZYeQZSzlDx0vacskr64ZAhbQlI+CxkokuDT/WRob4it7vBoRFOrYql187ph?=
 =?us-ascii?Q?vXFdfqHHNOh3paRzmcrutU/XG5d82De/sRuX0xJVUsef1JNv2vTlwmpoIIaf?=
 =?us-ascii?Q?K4AbWxOHw8Y8gCA/XT6ORfKSkhLBIahaWOzrwtMINBSfH54e+2Sz8yxnu0DJ?=
 =?us-ascii?Q?aTZJBeEuKVxYmQOnAV06tsokLuS3Il+P4MWOeL7hlR6gaqwYsZWZphODQgSY?=
 =?us-ascii?Q?OZUGJ9C9lrS9/lzWC98xfMk+Iod0QwEHgcIEB+YnDyk5zXTcLut02Scx0Zmh?=
 =?us-ascii?Q?HCLAgqN0tYQ9hzsz4UmFXsUfW4/sfCIgBmUTpthCL/a2uJ600paIPsM4P0jb?=
 =?us-ascii?Q?km9F3cBPNal5G+xUYyaS+/JTDO40rwFp5pMhFxyZ9rXdMTrq2iSc5dylBgXp?=
 =?us-ascii?Q?KRsG1Cu5/qaO/qo7liLp81sKgDKOCtG0XFaNg97hYaWwv3sNg/nNL5P27pim?=
 =?us-ascii?Q?x+FU21lIk1t6rwXiHxSMFzG7+fE34OMPVdq9kJxRpPod93X/3vdvbLmPOOC+?=
 =?us-ascii?Q?BxwlnglwC+Ppgy6R5w5vASQq2mrJkmcpkdzy1VVVBx0SpC11M6nqvzOl6hRv?=
 =?us-ascii?Q?H1GZaXFep40DDRzmWFCE/nWk5UaJQz3fqIaolySyTXSAL9+Xjb2Ur+sfnhmt?=
 =?us-ascii?Q?yhosRHnYTfHth2EBVYTIrk8B4DTEPJnODpPzT1d7Clhrheoagx97PtaS3UQn?=
 =?us-ascii?Q?gQp/Gj4hkU7IALtGb564cJ3Tv8xGPord8pU4WXf2P4iY16uvKfVoHlv+d+c7?=
 =?us-ascii?Q?9B8/hs9TcTzSYOSDDR75vTMEkhh8L1/8T/1+HFURUoOXKhljgaDdBBVXUBMm?=
 =?us-ascii?Q?xhKM3EJ34Umt+L8cCXxGZcvTFesrC62BQxClKsxxbsu998ibQ5SZ/JIpY0+T?=
 =?us-ascii?Q?26WI4M3MFRpV1WZviSwp7zMjRsZnHchvg6uGLwjleaAkzX8BEknc/W7vyfua?=
 =?us-ascii?Q?dLH9OeePbFa3uYd7fsA=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(30052699003)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 16:07:28.0709
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 58899fef-3c7a-41a3-6ce8-08de4f992fa5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5899

Find the CXL debugfs mount point and add it to the CXL library context.
This will be used by poison and procotol error library functions to
access the information presented by the filesystem.

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

