Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011033.outbound.protection.outlook.com [40.107.208.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E79D2798F8
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 16:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767974854; cv=fail; b=uDMQTSHVeWpjhI4Vp5q77v9VLWkWlGbIuxM0uyctmU6da6erLLUeo1TN+8SuLn0TSyYaIEGturj0pSW6lyHLOZ2pLH0CNxgx1Uholjzt2dx649OWdXn6PMUsR4lsdPHy5iZOo/+7HgAt1YIDUFnkclLFvc0Y8jgX3CXQHgiyGyM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767974854; c=relaxed/simple;
	bh=yQxYm1qFbZx0TVYxno371onqyYTc6pXcn2r1rjFDZi0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IJ6cuzfRR/JTFTDvM3NpR72lAD8z4VXhB1DdQ+td8zEe/YvqbjkLLIVUhGKKD8sKmp1JN8fbYp3mjw4mmJhTf6RB/JGD30FTJj5XK9jxsUBRq3vqjDWFU+TR3cp9Wrcc4R9rzexNd20SddghLnAOAiD2tO0Rc58n5IWaO7DQfRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=johuJk/n; arc=fail smtp.client-ip=40.107.208.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="johuJk/n"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mIJ6q+lMjP/EFWw1Ed220uvDTVK0BjLoKjqyPKoCYSqq6rvKiW8+kn4zBMNBKKu1lup/vyrEMxzSyHPoae1kivn5WT7rJJOvy754fJ9OZ1WRa5JeaSdnoT9h1BwfW9hQyJtdltY55OGET0tZllL0bzOcy6pLps2kr7KZL4uracEmUXaPVdV+rPOOyNp3Y2lr3tRDW1FPEnXVSRSg7lbBvaeVn8uTo4OmTu12z+PeYMZWBcsHp989lAoXxEb8RL75EJkN0lzTSVZLNy2nXI8D6k+sL5pcIslfYqjBHAze2m4lJfhs+bH5xn4jkwl0dbIHgeyXA+hy8mHL5yNe0kujmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nIpX/gp7flQxNSEWZbf1vzfKEQ5ZXL+WeKsa2DTyVA4=;
 b=qLWSx4OEdKx5/ihmk8ide6xfr5Hw36Y6O8kKBOqgAkTfFxVSgiqv5vh8cETs3S9/1BLVSNTCdFTEIjqr7U5ZOD6VxfhjPggg++ecaqzONPZBy0iEU1nEyVUOZMLAnLYGL+oQWM909+Hb2Oh7YGitW4IQzPdlS1ZuddscKXD1/mb2uTb5U19xZ+dbaYsdKCEgajMuiFbDR6DFNi3l4uK4BZTBSBjfl5a9CTnBcGrENQbuZFBW5pXgqyStyapO0rX9xQEWhBnoGvoLsu1Krvi9qIHe5wYzxIDPHzNaGLUrwzQ/MMUrXY5EEzGrUufnc47u9ICNr5Nexqqsk68ZJPRgNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nIpX/gp7flQxNSEWZbf1vzfKEQ5ZXL+WeKsa2DTyVA4=;
 b=johuJk/nprDnD6c9a2AVtoE0Se+AJOGgsUahOaq3i3H8JDETYJEnO6SysfJx+0XWrewH4Y8XOxCwivdBmisYIFvgZLW5d6kjYhRzM0TI3TmtU+W1aq+TT0UUXPMR9qQER2Yu/RBgA915gQW04jxWAlvK1L1SW6j53KqGjNIQivo=
Received: from MN2PR13CA0030.namprd13.prod.outlook.com (2603:10b6:208:160::43)
 by CH0PR12MB8580.namprd12.prod.outlook.com (2603:10b6:610:192::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 16:07:28 +0000
Received: from BL6PEPF0002256F.namprd02.prod.outlook.com
 (2603:10b6:208:160:cafe::b7) by MN2PR13CA0030.outlook.office365.com
 (2603:10b6:208:160::43) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1 via Frontend Transport; Fri, 9
 Jan 2026 16:07:28 +0000
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
Subject: [PATCH 2/7] libcxl: Add CXL protocol errors
Date: Fri, 9 Jan 2026 10:07:15 -0600
Message-ID: <20260109160720.1823-3-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256F:EE_|CH0PR12MB8580:EE_
X-MS-Office365-Filtering-Correlation-Id: 591c9511-1593-4bf9-6598-08de4f992fdf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IivTSI+RmSvsgYnxIvuFj/NZcm69i0hSLYq6oet1KRYYl7G4jIgZwVDNTFfV?=
 =?us-ascii?Q?ccVK18xtmFxki2YxOoWT8b+nWqJlifkxF2w9bkZDGVh85Wy6EOl8RLulZCUf?=
 =?us-ascii?Q?J8aCvo1adgoPmHV29yBZSkQ4hmaltIM9MfEEXgKAxhlQ78ZqTKuR8pfsycGL?=
 =?us-ascii?Q?mVYzkPgz0ieCwrZx1SVdlX9ZSXpIsIqQnrVzBX/AHzsalwOlUQtbzCdwhdtD?=
 =?us-ascii?Q?pPn6dmU9UmpZ0EzXwjlWyFYTqDc7JYkUR62CGTLLZk7ipRa0lF9klxxa3yXj?=
 =?us-ascii?Q?ur1pc5nxUAsdbFctRbwWygN6cGM6wvaSa+O02bPW5PwYJNZfic7PLSMHl8YD?=
 =?us-ascii?Q?lIYADYxm1F3G+MuUK2ky0JB6wG3kvVuKiKfuUG4wLrzRlVME9D03m/fROQ7q?=
 =?us-ascii?Q?J+5jmUasl8B+UPIZfNRFmFGNTSXOuPFfrDH4eRImXfXmHAjA0iehkpK25WMo?=
 =?us-ascii?Q?FvcQ5uaSu+GxacSfihdgE+NDoB5yPUYWYxZXg+EPBYeyI79MqwFezPIdOtzG?=
 =?us-ascii?Q?hGT9X4UCxP4Uj5WsDbFA6eFlo1t1bYwVpgwoPIt5BPm+ibjLa77v8aKB0AbM?=
 =?us-ascii?Q?F6YkTFGgTP8gjT37ns1a034Gw7Yulf3A+WTf3L0xxuSnu623UvqPuFeJtLFj?=
 =?us-ascii?Q?zOSYBtJkItwMr17CgCTLxm0ezOLAzbcm+GlQNgp7ORjaAQJoZg+KHGxl1xiM?=
 =?us-ascii?Q?lZE131sLVCDaHFh5zWkNVfha2VHYBkWkZYEoB/owfzymoNNW+z6/gKZ2PU9h?=
 =?us-ascii?Q?Tg8EVj/lUOvUgS5OUnJPx0KCQXvoe3hh2Hs+PBQL2jYVFkcF2B0TTQhq9Ylh?=
 =?us-ascii?Q?KYP0ZoNHLrVBD7OnfUN7jht2kqlm7lbwS5KEAWy8NtMjWz5tOkA2awBifrZ/?=
 =?us-ascii?Q?/JOTa+LE0+rQW1Aatn0z8H6dPPtp0bt/VvsWQbW1mHH2/lwt8hqqYNoI6DYB?=
 =?us-ascii?Q?TJ6dp8DCndUjeWP1/mCu5WC9x6+ZrOHPyHnfSmwGP7cYNh2gufqMTQYrDIbr?=
 =?us-ascii?Q?OQzcOJsgMpx29d7B8kdmMdhKzrSAUb/qT0Q8hpJ2LKHRR66qcb2VvKjQt6L+?=
 =?us-ascii?Q?KEUcqbWzBxMErK9P84bOY4mEDE29fS10XSu+tqOC9a7poCXpZDjplN+Ytn/z?=
 =?us-ascii?Q?bl67+uf/BHH30cX7S1XtQCjr8/z5Q/qgXL3hJ437o6tPVDmbLPSLOVxAe7ww?=
 =?us-ascii?Q?lG+SEX8Su2Ulm430TIY0zhMhS+e+TDfaXHYPUiRwHWfUMDsgJjr1VhOmNSn4?=
 =?us-ascii?Q?oKwihqec4wFw1Czgn4voHBmrBKfcXE+NsbEfcLGOjgsNrSaw7hjhKBvJfAbI?=
 =?us-ascii?Q?5wQY/h9L/NCNsv8MMSRWHwdeQq3HrbJTVMyJM/2YK9ujgzNHu8f15BNXHcZj?=
 =?us-ascii?Q?IWMlrbU14cjobz2mrNHnYeB52Vb8t9mQr3ZxisxyngdEEqeNwCQ8J4JkWNpi?=
 =?us-ascii?Q?gA1wDbXgwm/76eKP9k+L5hOCVQgukVWX2pFsXWcdwhqUWRPiYh3VTXSMRddW?=
 =?us-ascii?Q?I96sRGNhiFko7GhN4YrjwJo3+jjIBcU3tPeYWFV+UxarFe49rjeR76dd8byd?=
 =?us-ascii?Q?AY+uGs79KYveBCvnCcM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 16:07:28.4504
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 591c9511-1593-4bf9-6598-08de4f992fdf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8580

The v6.11 Linux kernel adds CXL protocl (CXL.cache & CXL.mem) error
injection for platforms that implement the error types as according to
the v6.5+ ACPI specification. The interface for injecting these errors
are provided by the kernel under the CXL debugfs. The relevant files in
the interface are the einj_types file, which provides the available CXL
error types for injection, and the einj_inject file, which injects the
error into a CXL VH root port or CXL RCH downstream port.

Add a library API to retrieve the CXL error types and inject them. This
API will be used in a later commit by the 'cxl-inject-error' and
'cxl-list' commands.

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/lib/libcxl.c   | 194 +++++++++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym |   5 ++
 cxl/lib/private.h  |  14 ++++
 cxl/libcxl.h       |  13 +++
 4 files changed, 226 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 6b7e92c..27ff037 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -48,11 +48,13 @@ struct cxl_ctx {
 	void *userdata;
 	int memdevs_init;
 	int buses_init;
+	int perrors_init;
 	unsigned long timeout;
 	struct udev *udev;
 	struct udev_queue *udev_queue;
 	struct list_head memdevs;
 	struct list_head buses;
+	struct list_head perrors;
 	struct kmod_ctx *kmod_ctx;
 	struct daxctl_ctx *daxctl_ctx;
 	void *private_data;
@@ -207,6 +209,14 @@ static void free_bus(struct cxl_bus *bus, struct list_head *head)
 	free(bus);
 }
 
+static void free_protocol_error(struct cxl_protocol_error *perror,
+				struct list_head *head)
+{
+	if (head)
+		list_del_from(head, &perror->list);
+	free(perror);
+}
+
 /**
  * cxl_get_userdata - retrieve stored data pointer from library context
  * @ctx: cxl library context
@@ -325,6 +335,7 @@ CXL_EXPORT int cxl_new(struct cxl_ctx **ctx)
 	*ctx = c;
 	list_head_init(&c->memdevs);
 	list_head_init(&c->buses);
+	list_head_init(&c->perrors);
 	c->kmod_ctx = kmod_ctx;
 	c->daxctl_ctx = daxctl_ctx;
 	c->udev = udev;
@@ -366,6 +377,7 @@ CXL_EXPORT struct cxl_ctx *cxl_ref(struct cxl_ctx *ctx)
  */
 CXL_EXPORT void cxl_unref(struct cxl_ctx *ctx)
 {
+	struct cxl_protocol_error *perror, *_p;
 	struct cxl_memdev *memdev, *_d;
 	struct cxl_bus *bus, *_b;
 
@@ -381,6 +393,9 @@ CXL_EXPORT void cxl_unref(struct cxl_ctx *ctx)
 	list_for_each_safe(&ctx->buses, bus, _b, port.list)
 		free_bus(bus, &ctx->buses);
 
+	list_for_each_safe(&ctx->perrors, perror, _p, list)
+		free_protocol_error(perror, &ctx->perrors);
+
 	udev_queue_unref(ctx->udev_queue);
 	udev_unref(ctx->udev);
 	kmod_unref(ctx->kmod_ctx);
@@ -3423,6 +3438,185 @@ CXL_EXPORT int cxl_port_decoders_committed(struct cxl_port *port)
 	return port->decoders_committed;
 }
 
+const struct cxl_protocol_error cxl_protocol_errors[] = {
+	CXL_PROTOCOL_ERROR(0x1000, "cache-correctable"),
+	CXL_PROTOCOL_ERROR(0x2000, "cache-uncorrectable"),
+	CXL_PROTOCOL_ERROR(0x4000, "cache-fatal"),
+	CXL_PROTOCOL_ERROR(0x8000, "mem-correctable"),
+	CXL_PROTOCOL_ERROR(0x10000, "mem-uncorrectable"),
+	CXL_PROTOCOL_ERROR(0x20000, "mem-fatal")
+};
+
+static struct cxl_protocol_error *create_cxl_protocol_error(struct cxl_ctx *ctx,
+							    unsigned int n)
+{
+	struct cxl_protocol_error *perror;
+
+	for (unsigned long i = 0; i < ARRAY_SIZE(cxl_protocol_errors); i++) {
+		if (n != cxl_protocol_errors[i].num)
+			continue;
+
+		perror = calloc(1, sizeof(*perror));
+		if (!perror)
+			return NULL;
+
+		*perror = cxl_protocol_errors[i];
+		perror->ctx = ctx;
+		return perror;
+	}
+
+	return NULL;
+}
+
+static void cxl_add_protocol_errors(struct cxl_ctx *ctx)
+{
+	struct cxl_protocol_error *perror;
+	char buf[SYSFS_ATTR_SIZE];
+	char *path, *num, *save;
+	size_t path_len, len;
+	unsigned long n;
+	int rc = 0;
+
+	if (!ctx->cxl_debugfs)
+		return;
+
+	path_len = strlen(ctx->cxl_debugfs) + 100;
+	path = calloc(1, path_len);
+	if (!path)
+		return;
+
+	len = snprintf(path, path_len, "%s/einj_types", ctx->cxl_debugfs);
+	if (len >= path_len) {
+		err(ctx, "Buffer too small\n");
+		goto err;
+	}
+
+	rc = access(path, F_OK);
+	if (rc) {
+		err(ctx, "failed to access %s: %s\n", path, strerror(errno));
+		goto err;
+	}
+
+	rc = sysfs_read_attr(ctx, path, buf);
+	if (rc) {
+		err(ctx, "failed to read %s: %s\n", path, strerror(-rc));
+		goto err;
+	}
+
+	/*
+	 * The format of the output of the einj_types attr is:
+	 * <Error number in hex 1> <Error name 1>
+	 * <Error number in hex 2> <Error name 2>
+	 * ...
+	 *
+	 * We only need the number, so parse that and skip the rest of
+	 * the line.
+	 */
+	num = strtok_r(buf, " \n", &save);
+	while (num) {
+		n = strtoul(num, NULL, 16);
+		perror = create_cxl_protocol_error(ctx, n);
+		if (perror)
+			list_add_tail(&ctx->perrors, &perror->list);
+
+		num = strtok_r(NULL, "\n", &save);
+		if (!num)
+			break;
+
+		num = strtok_r(NULL, " \n", &save);
+	}
+
+err:
+	free(path);
+}
+
+static void cxl_protocol_errors_init(struct cxl_ctx *ctx)
+{
+	if (ctx->perrors_init)
+		return;
+
+	ctx->perrors_init = 1;
+	cxl_add_protocol_errors(ctx);
+}
+
+CXL_EXPORT struct cxl_protocol_error *
+cxl_protocol_error_get_first(struct cxl_ctx *ctx)
+{
+	cxl_protocol_errors_init(ctx);
+
+	return list_top(&ctx->perrors, struct cxl_protocol_error, list);
+}
+
+CXL_EXPORT struct cxl_protocol_error *
+cxl_protocol_error_get_next(struct cxl_protocol_error *perror)
+{
+	struct cxl_ctx *ctx = perror->ctx;
+
+	return list_next(&ctx->perrors, perror, list);
+}
+
+CXL_EXPORT unsigned int
+cxl_protocol_error_get_num(struct cxl_protocol_error *perror)
+{
+	return perror->num;
+}
+
+CXL_EXPORT const char *
+cxl_protocol_error_get_str(struct cxl_protocol_error *perror)
+{
+	return perror->string;
+}
+
+CXL_EXPORT int cxl_dport_protocol_error_inject(struct cxl_dport *dport,
+					       unsigned int error)
+{
+	struct cxl_ctx *ctx = dport->port->ctx;
+	char buf[32] = { 0 };
+	size_t path_len, len;
+	char *path;
+	int rc;
+
+	if (!ctx->cxl_debugfs)
+		return -ENOENT;
+
+	path_len = strlen(ctx->cxl_debugfs) + 100;
+	path = calloc(path_len, sizeof(char));
+	if (!path)
+		return -ENOMEM;
+
+	len = snprintf(path, path_len, "%s/%s/einj_inject", ctx->cxl_debugfs,
+		      cxl_dport_get_devname(dport));
+	if (len >= path_len) {
+		err(ctx, "%s: buffer too small\n", cxl_dport_get_devname(dport));
+		free(path);
+		return -ENOMEM;
+	}
+
+	rc = access(path, F_OK);
+	if (rc) {
+		err(ctx, "failed to access %s: %s\n", path, strerror(errno));
+		free(path);
+		return -errno;
+	}
+
+	len = snprintf(buf, sizeof(buf), "0x%x\n", error);
+	if (len >= sizeof(buf)) {
+		err(ctx, "%s: buffer too small\n", cxl_dport_get_devname(dport));
+		free(path);
+		return -ENOMEM;
+	}
+
+	rc = sysfs_write_attr(ctx, path, buf);
+	if (rc) {
+		err(ctx, "failed to write %s: %s\n", path, strerror(-rc));
+		free(path);
+		return -errno;
+	}
+
+	free(path);
+	return 0;
+}
+
 static void *add_cxl_bus(void *parent, int id, const char *cxlbus_base)
 {
 	const char *devname = devpath_to_devname(cxlbus_base);
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 36a93c3..c683b83 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -304,4 +304,9 @@ global:
 LIBCXL_11 {
 global:
 	cxl_region_get_extended_linear_cache_size;
+	cxl_protocol_error_get_first;
+	cxl_protocol_error_get_next;
+	cxl_protocol_error_get_num;
+	cxl_protocol_error_get_str;
+	cxl_dport_protocol_error_inject;
 } LIBCXL_10;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 542cdb7..582eebf 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -108,6 +108,20 @@ struct cxl_port {
 	struct list_head dports;
 };
 
+struct cxl_protocol_error {
+	unsigned int num;
+	const char *string;
+	struct cxl_ctx *ctx;
+	struct list_node list;
+};
+
+#define CXL_PROTOCOL_ERROR(n, str)	\
+	((struct cxl_protocol_error){	\
+		.num = (n),		\
+		.string = (str),	\
+		.ctx = NULL,		\
+	})
+
 struct cxl_bus {
 	struct cxl_port port;
 };
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 9371aac..faef62e 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -498,6 +498,19 @@ int cxl_cmd_alert_config_set_enable_alert_actions(struct cxl_cmd *cmd,
 						  int enable);
 struct cxl_cmd *cxl_cmd_new_set_alert_config(struct cxl_memdev *memdev);
 
+struct cxl_protocol_error;
+struct cxl_protocol_error *cxl_protocol_error_get_first(struct cxl_ctx *ctx);
+struct cxl_protocol_error *
+cxl_protocol_error_get_next(struct cxl_protocol_error *perror);
+unsigned int cxl_protocol_error_get_num(struct cxl_protocol_error *perror);
+const char *cxl_protocol_error_get_str(struct cxl_protocol_error *perror);
+int cxl_dport_protocol_error_inject(struct cxl_dport *dport,
+				    unsigned int error);
+
+#define cxl_protocol_error_foreach(ctx, perror)				       \
+	for (perror = cxl_protocol_error_get_first(ctx); perror != NULL;       \
+	     perror = cxl_protocol_error_get_next(perror))
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
-- 
2.52.0

