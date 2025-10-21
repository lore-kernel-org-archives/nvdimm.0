Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011051.outbound.protection.outlook.com [52.101.57.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042D934D90F
	for <nvdimm@lists.linux.dev>; Tue, 21 Oct 2025 18:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761071543; cv=fail; b=TT96X/y7dHpPQOjbHAgwnO8F1QK6agefqVf07CteZ23DF+pRTeb5aQ0z6RTBok0cz8ZEEOIN8+n2pqskb+OyO9NgxaAkubk9Ci2QZ+DoW5wiqTts/QL7hp6P2R0q1IdVatSoXgvWIBaprwVx8aXh/EPqbg5o6/8ETdi9+VGWYD8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761071543; c=relaxed/simple;
	bh=xIDUTTeQJteU2dNxJd1bXNYD0nC5MTxpqf8lJM9+Pew=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pJMCBS5htpJDg78di4m6VLcWKf4CN55XmwQVCKy8tHpZ5Am6KPntVWQVDCHeI7NvKQ4VmowMrHxEMLQR6yABvWVvXFcBlrvyRnOBgzebqfyjw8vgEzeoCkcH6MDoSa35ieAtDeYVoHRlP6z4D1xocBdF3B6IdxNcT+pq51ESngk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=z7FSta1j; arc=fail smtp.client-ip=52.101.57.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="z7FSta1j"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YqSyNMcDjXbjTe9wOdIyb7TlFDGr3D7IFBhPOckLseHr7pkWxPrEcm2C5RTLpwxlJKnHzt254zZNG1lNWdCqn+ya97LCU3xJSzbDR/LZqvSXZ/rOdPUK/rG/N4m2ucUTXKZvRRVPnApXslOhCcTR6w8ZBT1oHKltMUH+XIAIl7dhUbPn3S9SHf3T/zLej6Zj6jgiw+5lLEednaT8U4G5YTAV5UBNSloB+bPBXd5dMa7Vm1BWdrQs8DUVXjH91lKeg0A7jiJU0XOJk+ar+w5xthKXWE7tafF1vf4SC/+QmtG6PXI5yjZSh7fb20lvcnYFCePSgjvCCrPVIt1fn5UM5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iGF1h5E65/t12ldBkS0sGf8s8Gnt34TPqSFZKyEnbNo=;
 b=ezrQCgk/D73bNIeqfNYrGqzgxh76iaJdlHtfzG2xqe+k6DfDgQQmUzL1s7JigLpReclKIZacGvJTAqE4udoB3Naka5DQ09RDkQSB1DRmDLxY3v6Z/w3h7fRC6VO18cOZqBdgusljDA+RVLa2CR92yt5fbDNPPkaB4MdJjNTcXvQiNcKwRhrdbnUspB39h8rHvhmT+qo36b73EJB7rYylunzURU1bck68rVPec0a30+FdCr5Z3gTwlRuDSXgT0dD8InCTTDwvO7gxHflAsZ+Ee278Ai5z56tdwLbGZCOk6HCO51HAheBWpLBhFRrBwagschlmEqArDv4muW02p6vb3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iGF1h5E65/t12ldBkS0sGf8s8Gnt34TPqSFZKyEnbNo=;
 b=z7FSta1j54kPbSGXSPps2VdwLdH+0aIwZeRhlM17KrOXXItZAqwgwAYeWuDOicxUWendqtMm0nEk/1FooN3yRs1+7VsLWDPWl/0LroDw+genBkLdhDE/Ryk8s+ilNNAEC+eswtpfhtmy+7OAWI7r+drmJhLS3QiRZDjE1SJ5b0c=
Received: from PH0PR07CA0004.namprd07.prod.outlook.com (2603:10b6:510:5::9) by
 SJ2PR12MB9212.namprd12.prod.outlook.com (2603:10b6:a03:563::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Tue, 21 Oct
 2025 18:32:19 +0000
Received: from CY4PEPF0000EE3B.namprd03.prod.outlook.com
 (2603:10b6:510:5:cafe::ed) by PH0PR07CA0004.outlook.office365.com
 (2603:10b6:510:5::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.12 via Frontend Transport; Tue,
 21 Oct 2025 18:32:18 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EE3B.mail.protection.outlook.com (10.167.242.14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Tue, 21 Oct 2025 18:32:17 +0000
Received: from SCS-L-bcheatha.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 21 Oct
 2025 11:32:15 -0700
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>, Ben Cheatham
	<Benjamin.Cheatham@amd.com>
Subject: [ndctl PATCH v3 1/7] libcxl: Add debugfs path to CXL context
Date: Tue, 21 Oct 2025 13:31:18 -0500
Message-ID: <20251021183124.2311-2-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251021183124.2311-1-Benjamin.Cheatham@amd.com>
References: <20251021183124.2311-1-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3B:EE_|SJ2PR12MB9212:EE_
X-MS-Office365-Filtering-Correlation-Id: 688e9438-662d-48ab-7a11-08de10d029d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?18xI946QxC+i00YfgRTXHHqxHa0+Vv4uxsbBps/jQCAE7i1Q0UC3wPzXiWHH?=
 =?us-ascii?Q?89vwuMYgkuz1cJ2fpZF2yPMM/QSBEOdQFTwZbbtZNmJM9IU3Hlu5T/pHjzD+?=
 =?us-ascii?Q?yAwsZ7dlFuA5d5zuUILg7+Y2LJgQphkzyiblswuORmlrtVqrbon3lJxyjh36?=
 =?us-ascii?Q?nvoPL9bjuzZVMKWo13sW9H3z98+1qbv9OguiyMkXYnIAX9NsWGNadHeomSLc?=
 =?us-ascii?Q?Iq19Hdzc8JsVTgtlL+44yDr2vRQiY64QZfD8b+doM4H9ucvxRON5WElytjFr?=
 =?us-ascii?Q?tu9kM6BxLfJkzE6LYhlHzhboOX2J0c9t0Lam14x+VmTeKtOWxK0O9qiOSfMx?=
 =?us-ascii?Q?BqPFji8wgOqm0hUhL7e6e8Pvh9msMg6im/8th4qNHF8EJvAfkFtvglV+YLc9?=
 =?us-ascii?Q?CUH7Q2sZvSWqRf9VQxfVz6/Im9icvDVNAWK6TTvjXtgImD1YtxxvM/+GpVPJ?=
 =?us-ascii?Q?CDELWSAJueSNzkslPb9dydOVwH42ScS1o/OqluQPSMmuAWrIlS2VZufXzt4C?=
 =?us-ascii?Q?k4l/X7TnHKFmUR6bqcCXxkIxq6Jpfvxyz6Ckqfv++jWLiHvEp7LHehWHrzLN?=
 =?us-ascii?Q?keB315rJJBDSY7ibqFrQotF2rutuYVlTNK2JkjbbM8OQN+W7Qxu/Yp2RdT7g?=
 =?us-ascii?Q?G6hEeTjlSSwGdGTqUUexIHbFg1uOIRXk15B6JHSVeRXYnnZUKW6Ym3MO4BP3?=
 =?us-ascii?Q?+zReNMlCNQVKn3lZv6Aw8+d8Wql6bn6cBCCrvgSWgQp3q2MvVv7JXf7KOG37?=
 =?us-ascii?Q?rAKgOrHkl4iF/61jOcTS83ugHzOSvASN+yEgtZuHbLQ5BIzfw6bH7gVUCRhB?=
 =?us-ascii?Q?H2GrKW2Y6f5aGXAe//PNS8Ljz9bj0Bcr+QhpU8Cf81w+2jwu4RWTgrNdpBqV?=
 =?us-ascii?Q?3l/FMCeCo72UQKv7wZkeZy8l4XM7TrCETjt9e6REisN+bza6ZFCJMmghGAP0?=
 =?us-ascii?Q?9IPO6NG+1TDpU10d15i+wwfbS2VkokUR+6q7MoQEA4SkMMY5LIKjSYi9m/uW?=
 =?us-ascii?Q?Ii5gNWCGPsAGhGoQh/OTW8j9EGRK2gkK6yqa5B2zpREVlEqaVyY7S7Z4ZJMB?=
 =?us-ascii?Q?LyUyx48ncPNL396QVaQVIO6mKikHnxxYQ8azGfp9cLXs8KEFAN48UTDwbekA?=
 =?us-ascii?Q?6n8ZrGBxM7lxDSVguJ8+gJr6oR7EJUZ8erekgzIhFddAIhqcCG07GC9s6I3r?=
 =?us-ascii?Q?O3uiuwA2OGMvzrbqThdhMgvXzKhxCTaKHjcukVuyhGqyv+dU6MWKKOamnzSj?=
 =?us-ascii?Q?9zyW0i8iSxb04p/2E7IUG89mdM4Ja+KGyrDkue7u71mz+LvGT/QzYSCKl3T7?=
 =?us-ascii?Q?OkpzBjfHWXAF7ay04QUNwKFWz/e1peXaGPZ08uS0VfHcRI9dRJ1u66KmqBQg?=
 =?us-ascii?Q?zH/mGTiKdeIN7wdcSWPhi1CqA6xH5s3ZFrTPhMaFGITo9Ci3EfRDzbptK83g?=
 =?us-ascii?Q?eVycLK/CaBoIZ1vrl4pMl6wnZmwA8Dzf328M43MTSVD4hosGOeZoG6VVu2i5?=
 =?us-ascii?Q?K8KRIDIb6Fvdk7/j9vTQ0HWUfk0ZcWPEIYY4DvcUHIIdgVERBQPk/5a8nE4e?=
 =?us-ascii?Q?vs0fBBaGNenNp7pFcVM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 18:32:17.3147
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 688e9438-662d-48ab-7a11-08de10d029d1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9212

Find the CXL debugfs mount point and add it to the CXL library context.
This will be used by poison and procotol error library functions to
access the information presented by the filesystem.

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/lib/libcxl.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index cafde1c..ea5831f 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -54,6 +54,7 @@ struct cxl_ctx {
 	struct kmod_ctx *kmod_ctx;
 	struct daxctl_ctx *daxctl_ctx;
 	void *private_data;
+	const char *debugfs;
 };
 
 static void free_pmem(struct cxl_pmem *pmem)
@@ -240,6 +241,43 @@ CXL_EXPORT void *cxl_get_private_data(struct cxl_ctx *ctx)
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
@@ -295,6 +333,7 @@ CXL_EXPORT int cxl_new(struct cxl_ctx **ctx)
 	c->udev = udev;
 	c->udev_queue = udev_queue;
 	c->timeout = 5000;
+	c->debugfs = get_debugfs_dir();
 
 	return 0;
 
@@ -350,6 +389,7 @@ CXL_EXPORT void cxl_unref(struct cxl_ctx *ctx)
 	kmod_unref(ctx->kmod_ctx);
 	daxctl_unref(ctx->daxctl_ctx);
 	info(ctx, "context %p released\n", ctx);
+	free((void *)ctx->debugfs);
 	free(ctx);
 }
 
-- 
2.34.1

