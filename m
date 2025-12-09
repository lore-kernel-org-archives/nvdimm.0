Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010060.outbound.protection.outlook.com [52.101.193.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303EC329E67
	for <nvdimm@lists.linux.dev>; Tue,  9 Dec 2025 17:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765300487; cv=fail; b=GWXKyvzDHyGjvuBB8N5exR0FdqrItiNfSQKrXnBGvl3xaMbXtWx7dfngI3yC7u2bpfLLFVvvTc0WpiTUj/aAmD61MiyQy78CEaAqGWYUUhwS9Hfi0+isGkGHRJr7YFu+V6WSC8u+18/dSxLaoGjwOQCCo5hgX7ZdFPIlfc+7FNs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765300487; c=relaxed/simple;
	bh=jQ0WHe+csSFpMGqE1MKEBhoVhpeoPYSJ5ohyPbhnoyA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=urRDvjTCb94ROlj/8wOCyXQLGaBFZ64OF/tKa97Ul/i9wTVjuFTYPpEaMHEzdGxrnHBdHdz1zLeWQxXtGRF7NJyYjOv6MWy8AjMmYAZFr7IsT5Ven8sL2jHk9uVzraW3EF4M1LCeZhJ1SfEFeR+xZs+3wqX9QfK8EuWGFjl0exU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=chWq0yTQ; arc=fail smtp.client-ip=52.101.193.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="chWq0yTQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SIv06QhBxyGDoIuk8oPdO0SzYHex1lCwnE7COjSUpZ9+beKGGZMPUkrlCVUzos/UTMtvdVh8rpbPBdVycz6do4nElC3ByqoxDFQzCfbjnKJdX9+OCX1RaC1tU2J/g7fcys5WoIodLgSzD4wXoo+UWlBpI8ZCqBJJhoeeoprfPVpzikj/sNaUtgikt/heInPzgumwBD7pztUuLyt1omoh6SzrJPqqt3zLAoX9qcbLB2NIXrdHazVjCSgm0Umc1FRn9laA7S+skMTczqVC0JAkDTqW8RCo4i26k+30MrX0F7mPTEq/qLFOoQFrLOIRwGKwNMR4BK/CfClj2AmjAVc3SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B+ixQrghqF/RrvfUR+0n52hEKTQPS4U96klazyqSK40=;
 b=UDammQ0qPbeW+9UlOOLycS8jETnnsqxMHgv0BwF1VbmpK4txNfvi2IxGdIyIK2IRS9bnJ/hrWMxcSC+0cllqiw7M3AxolXZqpuTPG6H/JbYKyZhAhvMHUMRvDY+xfXjQoTosMsAKP9ATaqehYsYpeHseQMzbdYSmEbqeXFCvL0vuogOLQe2bw4btXWnVZUD6pOq+3uqEku/mkbOa/s/Pwletog1q7b7ZrzEtAFrGYNDcL/oLIdcQAhrxud72i5IdG27q0ilk74BGzrLRy4FIhKj01W5M7F++5DwjKfDisV9y+lAA/U5p7Dpf0nNNo+PYVnYIKvQYUyqhKP0CELMzDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+ixQrghqF/RrvfUR+0n52hEKTQPS4U96klazyqSK40=;
 b=chWq0yTQ8EXwfxBp1XDo1pN4FwiX6W9vt7tHUPJEYL3mRi1i4d1qYmrSVpp9nW0h9vooIjLLco0bRf5h9pKV5JFR+pBxa5PGlHU9qlQix1UF19er/Y+4LVm+hti05+ledTi8ao4KmoXhMGwHZMP0l3pkd40H7wo8OiTB5NfPiOA=
Received: from BYAPR07CA0042.namprd07.prod.outlook.com (2603:10b6:a03:60::19)
 by CH0PR12MB8550.namprd12.prod.outlook.com (2603:10b6:610:192::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Tue, 9 Dec
 2025 17:14:37 +0000
Received: from CO1PEPF000042A7.namprd03.prod.outlook.com
 (2603:10b6:a03:60:cafe::3a) by BYAPR07CA0042.outlook.office365.com
 (2603:10b6:a03:60::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.14 via Frontend Transport; Tue,
 9 Dec 2025 17:14:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000042A7.mail.protection.outlook.com (10.167.243.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Tue, 9 Dec 2025 17:14:36 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 9 Dec
 2025 11:14:30 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>, <benjamin.cheatham@amd.com>
Subject: [PATCH v4 1/7] libcxl: Add debugfs path to CXL context
Date: Tue, 9 Dec 2025 11:13:58 -0600
Message-ID: <20251209171404.64412-2-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251209171404.64412-1-Benjamin.Cheatham@amd.com>
References: <20251209171404.64412-1-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000042A7:EE_|CH0PR12MB8550:EE_
X-MS-Office365-Filtering-Correlation-Id: c8c7e5b7-3e87-4721-7b7c-08de37466ded
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|30052699003|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1M8Vt+Mei5xyUtGrtXHpmWwZ7xJTpkgdDt0LCK6cAYClfufeNM8pW6BumhTZ?=
 =?us-ascii?Q?/6uCNW/rfig1p9iOfpsJJTOOR1t0Ss2u1iKKhcHrIKgsSEU5Qs3UucJcafLV?=
 =?us-ascii?Q?hx6NEK1l1s8v9jE3cXfO1BDOaYAmAUfoD2LgWULt/aqkpiLqtq2haWBRlYaB?=
 =?us-ascii?Q?tmDLOileV4xKGbD8URZTOBkSiVBszf+Hcc9JRd6H4J8tNEGJzpB6F2ZAknRA?=
 =?us-ascii?Q?YGNnYU77VM6dnjwwYHjd8ZpnimAeLG6/BqbBerKnOyXOaOVVfB8ADxU4gXZ0?=
 =?us-ascii?Q?W8ROheWPY9B6pKTeZfWRjoy9ztlnTXjlsdum/0+4TGFAxCxAJcfDNExx3s21?=
 =?us-ascii?Q?re73SPbuM9WMxnG5lo9fUdNtuQLyjA1wcodtLt+tYY1bzt7rOLqv2aZYn0Uq?=
 =?us-ascii?Q?+4Nk3Ahqs78zunerAdEG1dXUJ6IKHIhl6kqQY/ehps9uNGvZXtIG85R9Ygi8?=
 =?us-ascii?Q?QUZtJe+9A7PP6TOBD3jhf6d+AQPWxinIZIacYlsqiSalC8hwCnALlHuH6WIX?=
 =?us-ascii?Q?QjH7g5/ETIswUJADHmS33B5vx9MtafgFCK2LFTnp+RofuOO7o03RphVQG2YL?=
 =?us-ascii?Q?tWgqzG51XDmwr1TfPihRckxgorarjehUB5Qpgob/4ASkrCO/JMtRc/d1IYrA?=
 =?us-ascii?Q?pCvftZp3PrskCkF0AKQ5B+nfCeXU5a7FvPUWpTt8zcuJzFVBy7zUjC3o3e4p?=
 =?us-ascii?Q?TG5AjjYwskl9yBv5sLaYo5Uv8ABHE+mPrar7MfCMcWhli1BHLtH6pQJ6fM4F?=
 =?us-ascii?Q?YvmAm9/qI4u3CwWbLgm1kHlm1Z8gTa7eDTwAr4kOkIhxGM5bnbI+5ovbq+cz?=
 =?us-ascii?Q?VJ/K44VvjJF2HBCOVgHOKucZRd3+FNpkRHUQmyt7KUlkkhNyyyq2b/GpDalC?=
 =?us-ascii?Q?lQlhYhqzZMag/IzOabH9yLHyqtTaNT0L/TtsqrS/G8BBXcnXpzfoKvAenlSL?=
 =?us-ascii?Q?ayhzukexLpxHHeFkx80Z/tMyZjG5mA9x5OMq7ONBaiIFdrIirOY0a6jeFcrS?=
 =?us-ascii?Q?7qqcl5HVt8g75Zu1v1JYG/T6J7XJKea25WsoKdeTS3yvhneBRTxYDjmmTX+u?=
 =?us-ascii?Q?aEi/+nftFQGAOmAf7gMyqxzWG29xUtQqDoUUEvJ7F8QiROfpilFzUQWcmJWI?=
 =?us-ascii?Q?5eCAuLpjMKraKe5AXpb8KpAWUg+nQ1cx+I6rvggsYcVjcKPyV2DDDghOzhhh?=
 =?us-ascii?Q?/OnrpywNqPClIoc3EWvNkp6bctH5fEaFdMj6/HGmUQ7zsYcaLT3ZgTdQcMup?=
 =?us-ascii?Q?BaCOZtrZw6RfO/46tOmkeDKI3qNYWfGKbG1YAYIu19cwwjOLYtNo3e7paspN?=
 =?us-ascii?Q?53y2v7CAfqfCibthbFpocPvDvI8Ko969wbP32OtVrkbDhqDDH2BDRNEFcZ/2?=
 =?us-ascii?Q?ofe317ylpMVJFn44DYL0s4o1hqX512V1TCoPKdUT27CfFii3RwudMyUlSmN2?=
 =?us-ascii?Q?0gRUPoTbyBFY2otaeDko0kq+Tq/cqn9zDebBBW9vBo08yPkp/ZH+Qn0HMkKP?=
 =?us-ascii?Q?Df0GCthqAT56FtIsUVHN5YJO4d/jyvZ+NNhatu2csqQdtOLhyKJ+dY7OyHEJ?=
 =?us-ascii?Q?UCbYYs3zeZZOdLy9ix4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(30052699003)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 17:14:36.3372
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c8c7e5b7-3e87-4721-7b7c-08de37466ded
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042A7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8550

Find the CXL debugfs mount point and add it to the CXL library context.
This will be used by poison and procotol error library functions to
access the information presented by the filesystem.

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/lib/libcxl.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index cafde1c..3718b76 100644
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
 
+static const char *get_debugfs_dir(void)
+{
+	char *dev, *dir, *type, *debugfs_dir = NULL;
+	char line[PATH_MAX + 256 + 1];
+	FILE *fp;
+
+	fp = fopen("/proc/mounts", "r");
+	if (!fp)
+		return debugfs_dir;
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
+			debugfs_dir = calloc(strlen(dir) + 1, 1);
+			if (!debugfs_dir)
+				break;
+
+			strcpy(debugfs_dir, dir);
+			break;
+		}
+	}
+
+	fclose(fp);
+	return debugfs_dir;
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
2.51.1

