Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010061.outbound.protection.outlook.com [52.101.46.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748E8392B6F
	for <nvdimm@lists.linux.dev>; Thu, 22 Jan 2026 20:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769114267; cv=fail; b=skW5Znyw7k4f4KBbe/7yXFUKeq3qfPK7x3cp7JdKXIiRuB5ntsH+Td47osNhssSzoLI6bivcFZRorOl2w53F05SBDpuLUk1jzTnACkmL8gd9dKHnmU2s89Tsi1YGmMYigxGyXIcTp+ocZc6y2yp8bERMUAfPdtGHUCVy8kCzbQ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769114267; c=relaxed/simple;
	bh=T3knVmL6dOF9UoQQSVlJ1JPeakN1+Y6PBqfPP/HL9cA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sDllg8PaALS6nKCaB/PSH85oUKp77Gas4PX0JgC2gHVR1jTAHJo+D71DD9HspxV28O3q8/vqY0DaaNTzNNlHzapfEvZdhAnKCDcolPQS3aQ/odvYHfaGmfHzQS6I/QbP+MYwpjcLT7Yw1dgDD25P6B9aiaj4e1F+Yxv7sn5gHRo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=k4/YGnDx; arc=fail smtp.client-ip=52.101.46.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="k4/YGnDx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n0A/dxEr4AlClY8Lu7LmDM5XTODUwjZzC94QpCbKmd5D6vw0WLT5bFhNPdYLTayNqoPH++YmLJVDyZS/nZ3waFrxUgsWduos7E9Nwb9bT+ilRzfnia+Om47Bmb5brpcsbgy2wMeTPmB0o6oe1tKq5hhaOAfPfOQp1YLtZBlJ35NcpZtsX0rphhF/T1C6cZLWeU9MRuJy8dAsJiomAQwW6Hu+IHyRIQpBzuf7mWI4IskWvjj/g6sTwHhNRR7RMhIF6ewxJpxzESHUNWjSAD5OWd7kU3eoUYvstpS0Mgw3O8Csp5Buc09MqUCJaxOXx+p2+6DrIQXyS2vzt82tLEwlVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6BQM4jNZIjRBRiJd4lRyfOFGAl/DEbzBIa8qsZv/QDo=;
 b=Ut62/Zm/YtGlsVtHrC7hYzuSdh0I6WHhRe5vWMc+Uwjx8zVRl+H/UgOqBp+6r5prNg9TujUG6yBY3vfRzLsT1ba/yZCZAU27n4Az7zoX6AltWxsnz8vc7pFiMeXvhhoRpnXeNgaJExbuE9Z89aPzJiZH6w00FeZkORdwcFKZpPiB5vjRomQfwS/YRI3JujU1C5uWf7nfMVArSrPF5SceMdfep7XBphaswH1NoAFsW5Bq/I0oz1jtVTTISye+f7KIjjAsOMLowUC6toBIf431NI/2Xb1IFEnrTH4JVuce9ATO5Devsk/gbOwHVHF2qsG06Ot3kC0YqjyggtvUkXekSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6BQM4jNZIjRBRiJd4lRyfOFGAl/DEbzBIa8qsZv/QDo=;
 b=k4/YGnDxeeXXeQ8EMQPR5b2C41Up9FD0ZA+jLItP3cRS7BmQbsxejl7DWA8T0vj9MERfUq7BjYrRjRk7KB7bPSaaMsNBeakVmD181Csgg+E3jawUf7vBaPRqBrgG+ftMaIKhD2y+dvY6FutOGNHJm6qEfSjNWbkAZJpBwIDhWBw=
Received: from SA9PR13CA0041.namprd13.prod.outlook.com (2603:10b6:806:22::16)
 by DS0PR12MB8044.namprd12.prod.outlook.com (2603:10b6:8:148::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 20:37:36 +0000
Received: from SA2PEPF00001505.namprd04.prod.outlook.com
 (2603:10b6:806:22:cafe::56) by SA9PR13CA0041.outlook.office365.com
 (2603:10b6:806:22::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3 via Frontend Transport; Thu,
 22 Jan 2026 20:37:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00001505.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 22 Jan 2026 20:37:36 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 22 Jan
 2026 14:37:35 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>
Subject: [PATCH 2/7] libcxl: Add CXL protocol errors
Date: Thu, 22 Jan 2026 14:37:23 -0600
Message-ID: <20260122203728.622-3-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00001505:EE_|DS0PR12MB8044:EE_
X-MS-Office365-Filtering-Correlation-Id: b784dfb7-b7ce-408d-a829-08de59f61413
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CsZ1XgTkyOr0+l5aqYouYLFhuU/etByqKSjbdIsucq5N6iUgnUe55oXpC/Hb?=
 =?us-ascii?Q?js0wInYWTfqijVLENbdZQ8IoDsHpcEtRceY65PgOmH0HK530hKfE1DGfOwqA?=
 =?us-ascii?Q?nW0T28c+1JPPVGDkuIPPID8BXY7V1yfrSjx0gq8EZpkBXVf4DrIuoH+8xBsJ?=
 =?us-ascii?Q?ml+XpP9IxFbgRNBXPdP+ePvigCo0fnduNvecNitEhQr8b8zytOmJnadzL8JH?=
 =?us-ascii?Q?vlJIO4LlFDSyOR2SbF7XTm65J16SgPv04sACf3UdQmdYvO6GN/oyiGnrWKHv?=
 =?us-ascii?Q?VNXGvqrrZaifYKk+17YgwL/ejhWI9x4QqjfDj00nouOYxlH33DmXmpropc5J?=
 =?us-ascii?Q?UZFOraf+FzPlmGkVx+vga3621aQSdoRe9Clj37rOr65NJOFEsV9H4FP5wzHD?=
 =?us-ascii?Q?R8B3z/eC5eV6oBc24tMDKQsCOU2hkMfrsGxHYyZsoFe8FnH5kIKR2MBlovst?=
 =?us-ascii?Q?wWidKoM7SC5pZVvzbUM82ikM0RS4k4QNwCg6PTtJqBAikwCFCg3reSrCEMDc?=
 =?us-ascii?Q?VjTZsQu38wWOmxkthe8o2ZeGXxctBY0qpuA/9O1dcJZJTGIj6EwK5JSnNP50?=
 =?us-ascii?Q?ARJOyvjJRsmrvvrpAi7iAff9TINEo6YTSiK36cs46Hhp3bi9+S9SClLDlIaE?=
 =?us-ascii?Q?vtLUgCpzwWJoM6EX0f4QEgWg1KnB69GdsaBRI56YKReU53WAwKmT0AigK5G8?=
 =?us-ascii?Q?kzJ/bpCH9lVIasCoOhx//gz5qaXxzMAby1LjZ28IwTROD5Ihijv3nXKPqCM9?=
 =?us-ascii?Q?qWi0Gzwg6XjX7+GWOfS6hs7KeoA9uYHZylTSo9uk+zRPRNrZIrP59o2SVAeO?=
 =?us-ascii?Q?/IL5P34nGhF8+iAHJpUQRFyYHnoCJqb9IOuw4sm5JPfe/cX1P0fSKwyynvxy?=
 =?us-ascii?Q?iUgmcxihiJ3HgzZ22xWK91aP43YIdWdYgH+9yKUDRmYbVY4HraCnLrCWpfDk?=
 =?us-ascii?Q?gxbqeM4KWnCi4pyLQwWPNInBKM7JZgypc/eknDhB78f3iDHMqSsvhYqjdTWn?=
 =?us-ascii?Q?eeaAYmP+wjKXUo+fo6v8iS0NmuhCuLH0/41EVIfZQvUTHyt8NfMuOuZ7H5kT?=
 =?us-ascii?Q?Ze13z0ARMWq/3cDEDKMkG9FQv74RYCyXfXP+V9YaiVJJgjHOwERHFuRbL0gF?=
 =?us-ascii?Q?wezxHCDSSVBNltMSq+MGKLjjJgGbRaN7FBAkY7K17dyNK4WMnQBf50FCAnoO?=
 =?us-ascii?Q?hEaJdhYbpjqA7OeS/BvbDKO3kGhvc7u2sfATc0EM7FMklhF27X/3/cb1xScg?=
 =?us-ascii?Q?PpWHWaCt2uMJd8wTBPVVG59HR80rqE0Yl5mYxUtIaI7T/I1deoIhcGCF7UMr?=
 =?us-ascii?Q?PHKj/hE9SGdpi5JW5Cq+LJe/nHcwHZ0KTXDpEX4PI2H0YSdwhB1WBcIHvOaE?=
 =?us-ascii?Q?KcysWU+zB6pkH5f3MqdWuEj3letyWDXPiYsc/afI7f49Fk9sJ48eJ6Jqy49r?=
 =?us-ascii?Q?A/kZYgj0lMdEeDCsnTbu/o+u0biyBVcMbkNiCvSEQCYpMYNPE3gyfk41nxp4?=
 =?us-ascii?Q?8mEFisXPEmcEQbEwabDcKfVrxsoKc8qTRGyzveVEBlRVQQzM2Bibyy3ooeOr?=
 =?us-ascii?Q?GqaF9qgcDXr2ataiylTxx9awQ9h858vUJiMR6+1ccXNRpGRbobeqZxt2aVvX?=
 =?us-ascii?Q?+5ii3wqNbKEChqSpfumYMeB/kFsXiJMIux151KKiV2H83yK5c214HUFbdQwf?=
 =?us-ascii?Q?8a7RKw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 20:37:36.6247
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b784dfb7-b7ce-408d-a829-08de59f61413
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001505.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8044

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

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/lib/libcxl.c   | 193 +++++++++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym |   5 ++
 cxl/lib/private.h  |  14 ++++
 cxl/libcxl.h       |  13 +++
 4 files changed, 225 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 6b7e92c..be134a1 100644
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
@@ -3423,6 +3438,184 @@ CXL_EXPORT int cxl_port_decoders_committed(struct cxl_port *port)
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
+	unsigned long n;
+	size_t len;
+	int rc = 0;
+
+	if (!ctx->cxl_debugfs)
+		return;
+
+	path = calloc(1, PATH_MAX);
+	if (!path)
+		return;
+
+	len = snprintf(path, PATH_MAX, "%s/einj_types", ctx->cxl_debugfs);
+	if (len >= PATH_MAX) {
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

