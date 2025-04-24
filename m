Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2049.outbound.protection.outlook.com [40.107.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D64B1FDA82
	for <nvdimm@lists.linux.dev>; Thu, 24 Apr 2025 21:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745529927; cv=fail; b=E+0vpb5Z4wUH52T4JpBHH3Mnsaf7xHP+pustb78wUhKjN9gQDX7xN9qlWnsasEixqvS0xnT8O4suvMKpoRwZok15SiAEWb7OhKc3igA7YQkaaNX9RkkdomQ/lLWqduBbtdrKi7AwlD8KIh7UQslb3naquHvbU4k1/yFhzSB2sMc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745529927; c=relaxed/simple;
	bh=D/HH9/K7CmsVS67q/vXXoJrWza/bszgXUKnNQe+O8OA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DZiywLSmADQLaJoBUaI07tI2Cdx9CHLmZvaxFgJ3qn1qqaJ9VQJpFR5XrpjRyRbeKi42LrVF5DszYqOWT1QNdL+dO/KAtB2zSU4PIYhztiMYzq1qkccJXkFYftBYQnoLmg7xqtBcHrVpGXJk94yoQ4dbUBpT4/uKHg4wW6zeFkc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=igfhfveG; arc=fail smtp.client-ip=40.107.220.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="igfhfveG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=exB24bJvepEskFKnSuuMunzROFZ8lXmj2prupNVM9LT9xoMj3t65u21rzEJJnQL8biS4K12TtRwFbtgRNk6BvPT5ioTZ/9I8MJ4jGby919pTmAhEaYiHLKJ1ORv1J/LFTymawTm/6R+ahEjcqGSAk5DaZ/Y/GfRMAktZTfFl/rxgVDIBLlnUKS2VNvQ/WFN5Quuyw8pF5lXQvR2qCA/aJ2vO37w3UNCFjt92L7cdjTh0MGeO7Hn00owcSdLmNZokw4IZyJL3l4AtJtj2347mGNPsTh/4KWD5ybCUqODgv94WjQu1GOF1bo8JLdOERgRG9MSVeOTjs/Cx/kiF6q/fzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dIcPViuAFjdsPtDsHasQ1luWnk0JVnCu/hzWH7dQ6io=;
 b=tXaM9FkIKk30V5ezsYol/Ivo2lYzMXbvPVHabZFzl203O6TUb9tmloZWIMPU69uoUXOqZnEqgX8/ms74RDKHEvr/al/M/V5rRn44SNJaV1gwHRlPr4O7JAdTrnSq1tNfJeavYUP51Ceu0Gm3o/V5b/3x0YzBjdxNhzOWg8fDFKhNQREz7EHAEgL6Bor/wYX37J2SWIhf/DlgGTAFyg3w42q5ihJWCdZgjHeFItQZTvDJ1ObO9UNrZQcO3TApgAz9NiKLkDiGlzAQBpGB2ZkDnbyrY2LQ2tSODYAxEEb0CVt8VasEcMdP1l+slXRKjOGjYhhj/F5BGTlZVzTyIAwp8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dIcPViuAFjdsPtDsHasQ1luWnk0JVnCu/hzWH7dQ6io=;
 b=igfhfveGJTKCimm7QV9NdJP1eP1QxTzLSBaztYW4Tr6GlulsuoLiU/8Kw/+2u2I9kXeAZykzoa/gPn8dqi8McjXn5VKf1Pwwpgv5xtwa87Qrz6u/PpQvKRhfXhHg8lZH/JtAGuw3HP33wPyzJAOB+DdkRf1sDoJFHm2sq9GyamY=
Received: from SJ0PR05CA0175.namprd05.prod.outlook.com (2603:10b6:a03:339::30)
 by DM6PR12MB4467.namprd12.prod.outlook.com (2603:10b6:5:2a8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.26; Thu, 24 Apr
 2025 21:25:19 +0000
Received: from SJ5PEPF000001F0.namprd05.prod.outlook.com
 (2603:10b6:a03:339:cafe::ef) by SJ0PR05CA0175.outlook.office365.com
 (2603:10b6:a03:339::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.23 via Frontend Transport; Thu,
 24 Apr 2025 21:25:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F0.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8655.12 via Frontend Transport; Thu, 24 Apr 2025 21:25:18 +0000
Received: from bcheatha-HP-EliteBook-845-G8-Notebook-PC.amd.com
 (10.180.168.240) by SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 24 Apr 2025 16:25:16 -0500
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>,
	<alison.schofield@intel.com>
Subject: [PATCH 4/6] cxl/list: Add debugfs option
Date: Thu, 24 Apr 2025 16:23:59 -0500
Message-ID: <20250424212401.14789-5-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250424212401.14789-1-Benjamin.Cheatham@amd.com>
References: <20250424212401.14789-1-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F0:EE_|DM6PR12MB4467:EE_
X-MS-Office365-Filtering-Correlation-Id: af054eb4-9066-4fac-238c-08dd83768332
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?C1xS4MjSEmjEOtZeRJhRzgqO56csmtMokH2Q9dTHdtvYgWl9WZqXnlAF3YHv?=
 =?us-ascii?Q?KGfT2GoLJGbKqUl6gZDEIyGNlT47tDp/zzNMhOzg5pmaSg92u74DJYGyOPlQ?=
 =?us-ascii?Q?JOQPkuTokE9HKqXfWbL/8R7KvaBxrIsvHbNHAMJc6vtMLZB8bB6cTM2lFfhw?=
 =?us-ascii?Q?se2iYhusQ0rtI6m5hziFSlMTovTgS9FC1SYmZgIX8O/NhK7tvJS0LtRMVLIk?=
 =?us-ascii?Q?XEjzEPettx6M9ehhmHf580/QOKLXqez0QP7FEXEsgbJo2dGEMAQ7zMBPXFhE?=
 =?us-ascii?Q?sZR3Ogmg08WzbQyG7H5uNTyQc/CL2EdgkhkKeTxjA+jDwducV/c4jIF1obf2?=
 =?us-ascii?Q?cIvnz6mOhKTT66qiHI5mzh9HZK4582K78xNT+Ws9Wcu7f7SS341h6xavEwCc?=
 =?us-ascii?Q?RDWUOU9PRgsefjsJHN67EofnSfylrgJ4STXqCLj7oeayYkROW3c4x357f3qr?=
 =?us-ascii?Q?NK6+MqHIFrQUeIkSD00uNJfjvuOihZtcqQ/XTa0y1lVhxhwGVDRnKQWO8cYN?=
 =?us-ascii?Q?zKoHP3c0xnLEeCVSTcfzYLysVfVwZcGcFjcplNvEARKU4w58UhA8HqyXJrjS?=
 =?us-ascii?Q?BmhcP8VxDb/vZsK7s86eiFCFEOJjw6SCwuaT7N9wWAYxizET8QzvpTZoA31y?=
 =?us-ascii?Q?zLtQwkHoOowyjdHZhzV59qS75nRl7nGQDy8VL3DdhZDEBpQKhXiUZ4X6cg//?=
 =?us-ascii?Q?T1v9n4UXKHOYRehN4Ruu4St5rM/y36ZPV6Nqye9YBC7qs3ZiOD94DCfOONlc?=
 =?us-ascii?Q?YtYHhmgjam4+ihevMtPrPgrKRLWvr+onOxXhzjuiNQ77Q2umgKkR0XlGiV0j?=
 =?us-ascii?Q?6/eT1VnIxSxaK6CiozKirN9RsNVKA5/9Mm8Fv0TL8FE/oXpZqyoIFRb9QisG?=
 =?us-ascii?Q?Iwm3T8Juzm/WF1CSH+69huj9qgPpIo/Il0vnq3n3PtyO2TMSTup5evlbAjDR?=
 =?us-ascii?Q?6/HHxk/ddo4E48sXeV0V+CIxlZAdKut7uF8Oi+aP0CGA37G9ePWvRhXp7ydH?=
 =?us-ascii?Q?o2sSXvQP8+39brg+53mIrQjmiKmHmLpEMrbpE7WgKH8I4oRrpUR9wqOhBrOq?=
 =?us-ascii?Q?fnlnfEwV9+FYE6QnYG24Eb3dOLVugny1X5WLnUb8opbuRik8AqMvpOeB6ZZT?=
 =?us-ascii?Q?8iD1+5b42ecvQ3kpsoqGYdAsbEGqz1G8JXXcdg1bupS2MHqke49t+tVUxQUz?=
 =?us-ascii?Q?6c9sHLHQMHqVX6/vxFWbBWkbdE6rv/PLvM+aqUcKBDXN9By+VApmpAQbzyrX?=
 =?us-ascii?Q?Uhy2ydKjaYK9iDVK52S+FInyoQTlb08Xr3ppPvEEYvuX9wmTXyIU7SWt2bbj?=
 =?us-ascii?Q?AfabMMzxR5lz4XTjEYQoowRyjnX6ufG8BdOeSIVSXDAWpS3Qoi1+maaRfA6L?=
 =?us-ascii?Q?kQ1F+9n8smpvaYlvyzLi0Qs7Fu/NNUg40xC983R5snnF/vAK/qVBwqII0cwC?=
 =?us-ascii?Q?9mfGwQI0o+eTqHO5eUYLOBeLyhBQwxxVlHxY4lMedQCZWMaWy6683x44eIBP?=
 =?us-ascii?Q?fjWbXJdZLh/vSrNl3jnezAxob2rJEcXYxJvw?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2025 21:25:18.5552
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af054eb4-9066-4fac-238c-08dd83768332
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4467

Add "--debugfs" option to specify the path to the kernel debugfs.
Defaults to "/sys/kernel/debug" if left unspecified.

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 Documentation/cxl/cxl-list.txt | 4 ++++
 cxl/list.c                     | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
index 9a9911e..56eb516 100644
--- a/Documentation/cxl/cxl-list.txt
+++ b/Documentation/cxl/cxl-list.txt
@@ -491,6 +491,10 @@ OPTIONS
 	If the cxl tool was built with debug enabled, turn on debug
 	messages.
 
+--debugfs::
+	Specifies the path to the kernel debug filesystem. If not specified,
+	to "/sys/kernel/debug".
+
 include::human-option.txt[]
 
 include::../copyright.txt[]
diff --git a/cxl/list.c b/cxl/list.c
index 0b25d78..5f77d87 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -13,6 +13,7 @@
 #include "filter.h"
 
 static struct cxl_filter_params param;
+static const char *debugfs;
 static bool debug;
 
 static const struct option options[] = {
@@ -60,6 +61,8 @@ static const struct option options[] = {
 	OPT_BOOLEAN('L', "media-errors", &param.media_errors,
 		    "include media-error information "),
 	OPT_INCR('v', "verbose", &param.verbose, "increase output detail"),
+	OPT_STRING(0, "debugfs", &debugfs, "debugfs mount point",
+		   "mount point of kernel debugfs (defaults to '/sys/kernel/debug')"),
 #ifdef ENABLE_DEBUG
 	OPT_BOOLEAN(0, "debug", &debug, "debug list walk"),
 #endif
@@ -146,6 +149,9 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
 		param.ctx.log_priority = LOG_DEBUG;
 	}
 
+	if (debugfs)
+		cxl_set_debugfs(ctx, debugfs);
+
 	if (cxl_filter_has(param.port_filter, "root") && param.ports)
 		param.buses = true;
 
-- 
2.34.1

