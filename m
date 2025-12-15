Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011061.outbound.protection.outlook.com [40.93.194.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8532236F2
	for <nvdimm@lists.linux.dev>; Mon, 15 Dec 2025 21:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765834613; cv=fail; b=d3LGi/i588n9a6S1kdGqRPeC3skJOakuJr8op7EMPs1ITd5FmK0y4QqAcwyRjbpbQhTy+x9uyqQ+cLdrI3HFNlDn7b3AGq1TEVGqnCeHLpqGWQMXB4eQ58Lf5RQpfwSRdKan+voRUBdESzHqcLlr69jtd/Zb9bRNbCF/ruO7hDE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765834613; c=relaxed/simple;
	bh=QZ1py0o//y357EkPiUr38pS6HtQpAw5IE/CxrxMHFAE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=omUK6tWgJ7z2BkYiG2lsZHFIqHFdCpMsjkQSxHxoHvadoYfza5+UBoP1FnLWRV2RxR9b+3JBb0qVnw05jhcwLgCflxxwL47ivAHUfJWVMq7JvZG6udZUw7qPM7PdHhqfx/rvYtrULm/Z5A4i5Km1WH57Nx/3FdOGKzzVEU/BP2A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=A8exGD34; arc=fail smtp.client-ip=40.93.194.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="A8exGD34"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=APCElFAgHpF6GTEL6IekRpQHdvF3JVZTDtmwR2K/3Xrt+6MG4b1tIdBcENeXKAE4atg+qgczUh66EALYOjjqEg4/NW1s/7W+F/G4LZSiaWlH/dRx2qJHxS51NwEs51IIih8ZMYgr7Xj/oYB6RiqMus/DhlzyuxUzSA9w3BrRvmQ3ByzY0JGOVuGo/jv0mIf0zkLWsRd1Z6Vvjfh2EII9r64rGbK43BGddO4sMqWJECWzM2wLlsCvIVBODRomQl70ZVSZ4MY2+WXf5SXBw92+ixlKDubyoCIJFfUoQ5HAmRyYIaJFh4biar79yyKYAF/UcxjxpM2TGifJvZrZziINHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vKKIIA7ESSFph4qRJXl9Z+paT7NLKvqHoF97OAauXME=;
 b=L46XVKtpgLd1ml48pBWvQd25wEuq9Z0K0nrYj/pY4xaT+0IG3DmnoOI/rZmqxFl4hWYqFOOhFD3n2zXDaJA4SF9r753BsAVrqLQsRx/fUpPhlgEVLwjZXx4OdosiGywtuBSABzyUIuptpS7FniuzuXHBPDagnKP4lMQeE1/BbMYr4Pc3jbdq3I7h+sztRjoDmwy3gYels32PRF7cTs1dZ5gdsTUVeL6rnJhLKAYt66wvR5kSL7OaTtG4ijEwMfO0Oo32OVjcx5w3S1o3fOtaCOmZgDIydXbrRgWruBT86NRYIcGdhcIP6GPdpwrRHE6SVZ7cGtiILIHDhTFMJhKyrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vKKIIA7ESSFph4qRJXl9Z+paT7NLKvqHoF97OAauXME=;
 b=A8exGD34/im6gzgq9vAaKEp/8vPRaORf6N45py2/FnYAO9SNkWL2JMO3I0J2x/lBvWYp55Gv/JWRYIjjKy2jh7FyKAf2ZdTYRuTIN4t/qEn68w4lQC+8vT0BAplUv9p4DBiHRMBj/XutAFGWXBEgVy/YFoYM4m5B1D0rIrFyhdw=
Received: from SJ0PR13CA0144.namprd13.prod.outlook.com (2603:10b6:a03:2c6::29)
 by PH7PR12MB8105.namprd12.prod.outlook.com (2603:10b6:510:2b7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.8; Mon, 15 Dec
 2025 21:36:48 +0000
Received: from MWH0EPF000971E9.namprd02.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::7e) by SJ0PR13CA0144.outlook.office365.com
 (2603:10b6:a03:2c6::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6 via Frontend Transport; Mon,
 15 Dec 2025 21:36:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E9.mail.protection.outlook.com (10.167.243.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Mon, 15 Dec 2025 21:36:47 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Dec
 2025 15:36:46 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>, <benjamin.cheatham@amd.com>
Subject: [PATCH v5 1/7] libcxl: Add debugfs path to CXL context
Date: Mon, 15 Dec 2025 15:36:24 -0600
Message-ID: <20251215213630.8983-2-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251215213630.8983-1-Benjamin.Cheatham@amd.com>
References: <20251215213630.8983-1-Benjamin.Cheatham@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E9:EE_|PH7PR12MB8105:EE_
X-MS-Office365-Filtering-Correlation-Id: 3252e3dc-85c8-4f3d-d5ef-08de3c220ce6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|30052699003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fexwIEJ4bBUBQ938zgd7w8KzSy4uIEtdCD+twJbVARrhoJlDsSc4tdNi6hEr?=
 =?us-ascii?Q?RnJj6wsWQbqlvHb0DmaAgjWjfHeq4K6JyrLK+ctXbVEoEvpwmvKwFzcxMWe4?=
 =?us-ascii?Q?cboeq2EdR70CzIhSRMFRTJdYCRGy05DRPm3VUvcAXQPHIXZV/KAeQAhGhzH3?=
 =?us-ascii?Q?44nYH4rirE6u4j2cMdPQ+DiBC2tMzOEkx2tN2gIKANc8gqcQrkvARJUYUxIB?=
 =?us-ascii?Q?ao2RRG/uMnNEILhjBpx+0xddT24/C0WNsdt2A113YU+73K0GJfnBesey1i1U?=
 =?us-ascii?Q?o2nHNLPHJGp8JwqOMl4c9ksl15jytftmPvFkMycxGH/EAEJSmXoO6tHz/NFX?=
 =?us-ascii?Q?NggLhyaebmjubfhBrdMOYl66HrE2DZD6HFpdY6lCjSpj31Np0p+tdeWQa3Xa?=
 =?us-ascii?Q?m6n3wH0y1enZu50qBMZ67sNsLPbpdHOtVx8G246ajv/1TIfaOCYr3Kh4FTQy?=
 =?us-ascii?Q?z9LYc8/fbbaxnKVYhFpw5lTRTOwjifPkvO1rXa+C5ySgJUCfF4gvuVh5zpkG?=
 =?us-ascii?Q?DdC/L1SyXWmq0iW9F/vPNL0accEReAi6OHSc40i2aTZ3F+ngutVMmKIrBmo0?=
 =?us-ascii?Q?y6o6VfHKhBjIVhHH4nwwNhsbKit4ir6aNKBIYIY15CDntBMnHrprhHIUc+OZ?=
 =?us-ascii?Q?uL9elqmCG30hm6lkfdf8fhsAgID41KYDLE9q4NKL4I9+M7W5keX/mq9n78kE?=
 =?us-ascii?Q?v5DsBetzGBj2I15LMp/4G7feAY2WwQq9WsxlTLOg6zO/2uHizBQUbSnriylK?=
 =?us-ascii?Q?Cl+Zb2wre0NIDsnL1lNbkkjOawlqKOUk7skLWzMz7qKiH59d+U5Gw2KvQQ1D?=
 =?us-ascii?Q?0FhM4CFZ7qvL3QsqX4Ad9yqeXp+d9YYtwvW3GnwbU0Kektcd7KVsD8PXuN/Q?=
 =?us-ascii?Q?+5Qz+cdA4lH1l3V+nXfTL1nUrdXacdUQMH/s9tXYz2X1RHUIAeFMijNMmYJD?=
 =?us-ascii?Q?B9QZf098WVClIWo8S1SG1kdWjbWbWd2uDYZ9W1Flwe0BvJDhnX2JsrIXY2Zc?=
 =?us-ascii?Q?aRwO+h8J/RtjlMF33MAQubLX41F4XfhTv3ozChJOYwZ6lEOb1Gea0TWy2oTu?=
 =?us-ascii?Q?1V+WcnK9YFv/TAIWGjR7sODglR2jQvNqnin0BqTMN+Hyqoq/WqiMjMtw846I?=
 =?us-ascii?Q?zZGLFEMydMN88K+gA09+yWtzHkxQcOpFctbqEehrfC7+0X4w/qeWkixtEhmI?=
 =?us-ascii?Q?o8iwIs26P+3UY2IJQ01MJwFFSGZLtmUYwy/as7hJMkJ7zuE8E1ztqqiID6qW?=
 =?us-ascii?Q?6TC8ySejWN+rNlw9l1QF+ZUua1LcH3VQn3BhG6DiliE5p1SH9rfqNwTaNSIf?=
 =?us-ascii?Q?2/GkdNgnn4ezMyyS2gDxY9M1eGhXp7IFzxWPHxJrv50XCo57+QBTYkMkMHZW?=
 =?us-ascii?Q?FLobtjrnZDtg9iTahSHUjx7lr8qKYze4VwyzU6/kXpFq76zVEyEa1X9JK9Pm?=
 =?us-ascii?Q?64zqTwoYaMngJNOlcptsibXtge82sYDBkA5QfBWXux04e1etQNpJYKFwVbhl?=
 =?us-ascii?Q?MhnBXFRT3rlkeVmJISMXbkBJpSh4wX5rMzGUA1VBzW+L5GliswkvZsUajWsk?=
 =?us-ascii?Q?NkAjjod5ZP0QlmZMANM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(30052699003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 21:36:47.5335
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3252e3dc-85c8-4f3d-d5ef-08de3c220ce6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8105

Find the CXL debugfs mount point and add it to the CXL library context.
This will be used by poison and procotol error library functions to
access the information presented by the filesystem.

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/lib/libcxl.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index cafde1c..71eff6d 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -8,6 +8,7 @@
 #include <stdlib.h>
 #include <dirent.h>
 #include <unistd.h>
+#include <mntent.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/types.h>
@@ -54,6 +55,7 @@ struct cxl_ctx {
 	struct kmod_ctx *kmod_ctx;
 	struct daxctl_ctx *daxctl_ctx;
 	void *private_data;
+	const char *debugfs;
 };
 
 static void free_pmem(struct cxl_pmem *pmem)
@@ -240,6 +242,28 @@ CXL_EXPORT void *cxl_get_private_data(struct cxl_ctx *ctx)
 	return ctx->private_data;
 }
 
+static const char* get_debugfs_dir(void)
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
+			debugfs_dir = calloc(strlen(ent->mnt_dir) + 1, 1);
+			strcpy(debugfs_dir, ent->mnt_dir);
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
@@ -295,6 +319,7 @@ CXL_EXPORT int cxl_new(struct cxl_ctx **ctx)
 	c->udev = udev;
 	c->udev_queue = udev_queue;
 	c->timeout = 5000;
+	c->debugfs = get_debugfs_dir();
 
 	return 0;
 
@@ -350,6 +375,7 @@ CXL_EXPORT void cxl_unref(struct cxl_ctx *ctx)
 	kmod_unref(ctx->kmod_ctx);
 	daxctl_unref(ctx->daxctl_ctx);
 	info(ctx, "context %p released\n", ctx);
+	free((void *)ctx->debugfs);
 	free(ctx);
 }
 
-- 
2.52.0

