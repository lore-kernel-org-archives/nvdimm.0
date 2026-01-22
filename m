Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010026.outbound.protection.outlook.com [52.101.56.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AC43A901C
	for <nvdimm@lists.linux.dev>; Thu, 22 Jan 2026 20:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769115476; cv=fail; b=Zt+2Z4E3AQZtwrockKlLQj3ISQEqKKBDfPB4+/0EKqNVI9XjqSNpiKkc65vCtKwz/iYBDivRT/B4LVCj4K/1YvgMqAOukQRNYpPn7WWSf5oDgCEPyMxEVCo4tmKDDyWT8SdZKBgQ/Jl38CqhHgJpUoD9Jap5ce2DYvc2ahtgb5U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769115476; c=relaxed/simple;
	bh=QMpTWT+BWtAIYsKf3H26i/3W1AWSBsZSQtSwgAW0UFc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kZxafBBubV/DGCVntwYArIPMH0exb0v8DnSYi97OC11/8dJOtupPuEuDHLjTEXeG5EdiBE9XsJ1Rl8jekM0cQzVgRmkl15hH53VK/ClwUQOWnPc79ohEzeQKTpNJAiFiuZUqWcCJXUaR/R7h8DoO2xUyN5MpwGcSQpQCp0Gg0SY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=p37h6+DX; arc=fail smtp.client-ip=52.101.56.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="p37h6+DX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ibmYna6EU2ad5iEdeWL+m12bbpReDZjWKeTHdzsTk3QoUi2rX6HmIJyLTU54YW7tjc5qgtIY8EdJuk7A+a53b/ksYv0PTjf4TQHdX+CzkEFJ/TTcUFUjomFuBAw6KLajPQQQjsp3iJaYc0M5UimS4PCM2V3U2li+3ZRwrowbsO7kMXMsaOwEKwWXks6hZRemSkvV6at1fbGD3h9FX4DLHjvvv297eTWQObaZt59ElZBLhuqbQkUT7aw1UWnSDfjDuPtmYoolLvhxb/Iuq64cFQRFrxFOWsQJcb+3u5k+oxER8dlclJwN5FN3Tr52+aa7Zlvki4NSc4dsFTsYAwRx3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/RCtya2Ut0o6tu3/JEW7mEMSAa9qTA35Ockdz2qzAIs=;
 b=l3gc5CztY2LlupqP77kEuNOk8k5MEHPx6DftRE0Rc+7htDYNO8Ojh7EgQ+4NGoEC+uQU/Y0ucPf2Ai6mZs+2U3NEIBJYxzF+n2j8u4i3dOcsXOFms35HMSsEkZ7dwvppX+KizE29rTgFGwheyg5rXkR2J1MT0KpHMk1a8Ll9lApvZuxvqbcOmV1x7p9D+vx64G3b5RTYss4q24NfwhlhrdsO8gH6F9robhpL3bX9Gd3phi4DtEzVkKKNKxc7VeekTx3inKxWg9BhwOO7Ai4FjLs03JulqFoxy8GbnnSelzUJoKIWJMJrUS3lnQqmJR+qVsddmIcmoXL0YFTpwApDyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/RCtya2Ut0o6tu3/JEW7mEMSAa9qTA35Ockdz2qzAIs=;
 b=p37h6+DX6CZhB6MU6JaGhLSHgy2v3nYZno2SEFtPEGB07fvci9rfKA7LCWQRIBb6O0292/yt/8ijWXUUkf5pWusCfaSB9dppx5HrNIq6pP0Hh/FfZaDnwlL8agTWkvfWtc4X/uU9wssilC7jrCBMdrZiy0bO4vR+ILpRLHwhG5k=
Received: from MN2PR22CA0026.namprd22.prod.outlook.com (2603:10b6:208:238::31)
 by DM4PR12MB5794.namprd12.prod.outlook.com (2603:10b6:8:61::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 20:57:37 +0000
Received: from BL02EPF0001A0FB.namprd03.prod.outlook.com
 (2603:10b6:208:238:cafe::8d) by MN2PR22CA0026.outlook.office365.com
 (2603:10b6:208:238::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.10 via Frontend Transport; Thu,
 22 Jan 2026 20:57:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0001A0FB.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 22 Jan 2026 20:57:37 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 22 Jan
 2026 14:37:35 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>
Subject: [PATCH 1/7] libcxl: Add debugfs path to CXL context
Date: Thu, 22 Jan 2026 14:37:22 -0600
Message-ID: <20260122203728.622-2-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260122203728.622-1-Benjamin.Cheatham@amd.com>
References: <20260122203728.622-1-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FB:EE_|DM4PR12MB5794:EE_
X-MS-Office365-Filtering-Correlation-Id: 93dba2ce-6530-41eb-dc74-08de59f8dfcd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jSLIMMizcAyTJs24ohRBXlHbnOJ6NGdVEsw6jIo6rnSQnBJN4mJgmOnF+zCw?=
 =?us-ascii?Q?sTHQI+nlpGcV2JIzfGPE7QgIT4lulq88GnJhHuO9l2yLjtxZ3yHT8c0m5nAY?=
 =?us-ascii?Q?xIJsEyjIFqhselhihYnb6dDaO2YWDqPfLkAju3ZWKbA79H3gZcxQheNiWHJN?=
 =?us-ascii?Q?R8yVYfvWz3MPO+2PUWFyBmIrneLHSzoA/2OFvgaytPCAn6DqaA37qPBb4CNP?=
 =?us-ascii?Q?vgUHgkB87Kn3o2iMK2ezNxTQCg1LxmYBIlRgYribVlH435vXePBvTdWdoZ2t?=
 =?us-ascii?Q?J0Pi2EJvjc/sitLboTUw6z2TydRprPZv4TXXiMjPUQv1yy+NG78EovvEuHTt?=
 =?us-ascii?Q?bheb/yO3AFngTVWjkwZZFs5TTTuo67DX5VOb1bNmrYmE5EQgHUZ+Zv1jYARN?=
 =?us-ascii?Q?t+oiTRVprIomOWp3JfvPQGR3dL46u87ZiND7QdlsExoVmA96S9bZMzaHba2T?=
 =?us-ascii?Q?gYyS5G2IQjpCMqr6mJ4Xi0dMJIfHSwDAz9aMNYRIeKr1LbVoSUDN6xaUcwK0?=
 =?us-ascii?Q?vG9qY120fslRsK2W7vIxd3ovXMpc3l71mGkIXoWVXsElah4sl4IlsrrsugiB?=
 =?us-ascii?Q?3H4Hds/awOlMn+KQhEjcRWoeLo39cM25r3SCayY8ah8gARiiB0GEy1Ckr/Ki?=
 =?us-ascii?Q?9019rE2EaZ1SMzfUj056+cDiFOUddgWjh2HzjKOAPW5Sd5jtuYdqjFK6o5iX?=
 =?us-ascii?Q?TiYl9BrzdaomlC2Ln/+kQd/hq008firiQNsB3RZVbVgodkFhofxwb2Vl+bAP?=
 =?us-ascii?Q?7DguRmOq07a+sXNFlzhFv3shNSPX0JqxU0NkqC18b/gzUkpgWiMiFEsnVaWe?=
 =?us-ascii?Q?BVY1OcJ6qNJpCGbLnX9+9LiBMklRoV91fmfBHW2WUuVDuyFpy3VwAC7z1XJi?=
 =?us-ascii?Q?BWyx7YZaCdpK63mk2zJSnlxyWYjJI1JGT1KsGwKrHatwSZ+NAsg8bflwieJV?=
 =?us-ascii?Q?/ysNCy5LaFPlJpcHbNhNcbfVcg8K2iBnbZad5q41MdzVsfdKKWV6zXw+cV6s?=
 =?us-ascii?Q?ydzLvtKSk1dg6b2GUA0S/94s2wFu2QPcSgCXjvIoBZL7dS/iuMntC2eMWOHf?=
 =?us-ascii?Q?2zXHZtNSHT53sFREIGRSc9oEv8TfANg3Bdevde0AqcIaTZEh0Z/PYlbVOt22?=
 =?us-ascii?Q?oQO9BW/shxBhOSGNLmmmHJBgis1TBWJyY7/fBxvKbkDqINQZCKOn2umt80Ys?=
 =?us-ascii?Q?V0IvbS8+UfAb0jkRcDde8l7E2Uu01GmuheJ3ypZYwe3tt15wC7v+d8IXCIPC?=
 =?us-ascii?Q?DGJw4hlPfhDNxpdhoBQ3WzDY9bRwOj5tLjR4ZxLY68BkArJ35nV7JxRhsjTW?=
 =?us-ascii?Q?pZxTJMLJZS0KJm438si5RE69ZtulQ58TZnjtFrjKw4avBrkJbQrsbnS2cO5f?=
 =?us-ascii?Q?U3LxBSZc/XnlwTaBtKjUCmEyUVf2CL6jGbru9xm2B7KvGh/vbaPieebFi6mg?=
 =?us-ascii?Q?1/QBhmf2mIYU3xEulD6Wgo9K04g0aZor9cT+H+ZCz1Ci+15/fCYYizZLjX/D?=
 =?us-ascii?Q?3XqpqaBcoAJpQIGI9YFc1NcyPx6Tqx8geegy7v8lMTGzLRxIzjyKWaZL0bo4?=
 =?us-ascii?Q?HS75bn8Togtj1ZgmmeEFnzGwmiCsHjtOYADoWvuysZkYoB2uCnHZOi+ZpeVL?=
 =?us-ascii?Q?K4G81vF0YODHbZtdWM6fJrhXt7sgzIUfWXXKJiFDXOUTaS4g8VOX04/ANLQu?=
 =?us-ascii?Q?a9/4lg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 20:57:37.4403
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 93dba2ce-6530-41eb-dc74-08de59f8dfcd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5794

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

