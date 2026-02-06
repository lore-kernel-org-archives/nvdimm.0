Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012034.outbound.protection.outlook.com [40.107.200.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57976312816
	for <nvdimm@lists.linux.dev>; Fri,  6 Feb 2026 21:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770414628; cv=fail; b=IRHNIaSi0ZWjvExHDiEDAJejGmxrQ3E8LVVWqLlEYwAJWWQtyQonYpcWcKXUSdsvsy9CvTIh2ckmpZjjSSIeTLtyiAjprf78esftJ5uTrXf143ZkTtuHa5mcgeDb8dI+1/bF1GIjLKTor0KdECD9wpl7D6m3pDjlp+d4n4QY0Po=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770414628; c=relaxed/simple;
	bh=omAJxLrxWID7cMlPHkwzt9JH70V/fAWT9qFicWSNDQw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tui7knU6UkLmaAYjOFtyfELHkt3qnf9WxlgYRx6uM2lZUtwczMrmTMesa5Dx+xaBrBMXB3BwJyweO0DHVujkmJcItgKA7qvR01dInrx0Gv6Vg2ZMeQrd9EtL47QNEWaoPSkWpNrLcrhx/d8xhl3SjSM3Z2hPlwvpqOkwBuBncn8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zM4r3A5y; arc=fail smtp.client-ip=40.107.200.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zM4r3A5y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GkFHw5WMtnxopnLK/fEhr/opyhqErmfGvt0tirWwDr22TjceCE5UJKeomOrZA7Bpip1S9gW8y+RX4rhH8kG4W+iwzFWV4Iwi3Ze/nHGy+KmAcz6jAFXQLrunPSe7+6QaPte/er4vYMZW7YeUAQCoaehIlTsJSmo3NA/MXgceDh3KvaPTY/1vpGGbAgSwk8/WbQXBknXgIf2QlrDmLy1A02+WDUjxtd87WAffJKOBYAyoc88aokRjKuTbY0hyP9I51ART4CiL+8qvuvlk8NzfsnFhDwGX5Z/eKjkdm+Pa3Tidj0iOzLGhRjC+F0IGDAAS+eL3E5+LFml2q3m+bcMxJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NbaVlehCzblFYGKMFVPU91xyYKv6pkhM7wQMMoOIuEg=;
 b=VEL7K81hvao8NCCnBHTcgktHsSnX822zBYrZMgiEq7/1SsSunMwSj4PCop/R8XHtTkM5EBJqTCab8jN3L7f4084Y/uI+TtAS8ILK40wue3Id9T4BdNFFFVMmmG5woR6wzvdHXai1ytb3IR4wp7jTcwh486ed0W2KqKX4LvTQb0uXB5+2uSKF3b83tA1mM1M1lJALASWIaOSOvrefeWd3OqXX3DqNxh8de3h14BO621igUtCXAbzpjYqgm9Ors83nZ0BD8tPxBr55yrJnYrKHe6Ll2ASanLo3H2zq0DE2kgXQEY7B9sg80n8uamHpUb2RfR/y04qMP453sfnMg6t9HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NbaVlehCzblFYGKMFVPU91xyYKv6pkhM7wQMMoOIuEg=;
 b=zM4r3A5y3pgU63KNNpG6KTtz44en4/EkCq0WmNsWbE0f8vvvu+XD//OS6XciFsDTzk6OL90URHSUwlGpP7XIz1kavHWHBlt0C6plhh0LkTT6U5g8Dzfq17w5907W3kNbipZKXQot1KGIFC8oFjilxLZ3uDignt5nsHAkC7OzwUs=
Received: from BLAPR03CA0176.namprd03.prod.outlook.com (2603:10b6:208:32f::26)
 by DS0PR12MB7947.namprd12.prod.outlook.com (2603:10b6:8:150::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Fri, 6 Feb
 2026 21:50:23 +0000
Received: from BL02EPF0002992D.namprd02.prod.outlook.com
 (2603:10b6:208:32f:cafe::79) by BLAPR03CA0176.outlook.office365.com
 (2603:10b6:208:32f::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.16 via Frontend Transport; Fri,
 6 Feb 2026 21:50:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0002992D.mail.protection.outlook.com (10.167.249.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Fri, 6 Feb 2026 21:50:23 +0000
Received: from ausbcheatha02.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 6 Feb
 2026 15:50:22 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>, <vishal.l.verma@intel.com>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>
Subject: [PATCH v8 2/7] libcxl: Add CXL protocol errors
Date: Fri, 6 Feb 2026 15:50:03 -0600
Message-ID: <20260206215008.8810-3-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992D:EE_|DS0PR12MB7947:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ce7cb0f-7b73-4d2d-e913-08de65c9bb21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/pPGlmXaG8W1sUweHJtp7G/jrDF2L4AonrxzT6iIkEVNS53DWtDlBOUX5Kqy?=
 =?us-ascii?Q?KP3DkPJYr5MiHqbI3nLJ2CNN2Zi6pcgDSxFoQXp6jGqFj97gchYHdBTVNs20?=
 =?us-ascii?Q?th+YCtfSsfzUlcnK7Wdo0MnuwS+54xwDi35YdCZZz21aSEyQRY6/rc0ML22X?=
 =?us-ascii?Q?Bd6KDV8vfOPXXwV/Un/AyOpOt8aUYzUhaDpV9Ev4DMZAJHxEM8gUK+/QbgpT?=
 =?us-ascii?Q?3d9+uREvzLUSzqU2hWad9UqBEosR3dc2Xqnx+4QfKwogsVB9Q5eVOTAuCOvV?=
 =?us-ascii?Q?V54SQxYm/7H4DQif/aLK+7DT1X006HWLcdy59peF5lNQrS2f9qSm3xjNgFkf?=
 =?us-ascii?Q?Tj2F4LvqeG/90t7oOvYckyPwCUAFSTSXvgTXaqeeo0wLcEYrG6JhLL/4b8YW?=
 =?us-ascii?Q?mX5jIDHSeSh87+ZCzdt4KnyStNZI8HLdoCHTg8cO/0WqF9KWdmNtm0hsbsQf?=
 =?us-ascii?Q?7zrjzemWVD7K9StDJp6yKGLGbG3voK3CzzXC4FFIcmKgm+GpaTQ7V/rLiBG7?=
 =?us-ascii?Q?82/t4ytYc7k/CZT4G+wkBoInEiaLJkLV+bh7/UWUBSWVOfLSYL3xWjpopalD?=
 =?us-ascii?Q?E6fw5EkhzTJ5MyvsxxHK7AMhhvgcBTk2AXwB0SaHWzzmqzN2dvEWIQ1Mrgm4?=
 =?us-ascii?Q?1F9IFqPS1LQFCEEbeE44p4NOFpD5am+Rjc8A8iJI1HKryifEw3Cdu2pfgeZz?=
 =?us-ascii?Q?Kuiirlb2HlfS8WD4M5jyDRECLtYXR0Rtprz7M6Ip6Xz4PyZxlSs3EhjPbbZ7?=
 =?us-ascii?Q?UOsBdJHMO+KCU0uRi5cZOTX8Flbb58s+qzCF4qeRxWRxIUSQ4TLDC2sSmY19?=
 =?us-ascii?Q?17y+X2tB+qsfUyUK96zgXVbEFxJY7XoDXCI8QAbMcs69dfPFPB1nIJPt39OR?=
 =?us-ascii?Q?1b+04XDewWrS78indm9R/YkbOerbRkiSfRNR8sGnyNdJvRA91BFRUEhLXHGU?=
 =?us-ascii?Q?yo6kagbXSRa3mG1ZuazwEjt8ZwT1QtkwwR2S4exq7k4ZEs/FY9zvBB8/DwIX?=
 =?us-ascii?Q?IJ5pZP+6T0noTI/W3nerbOYf/a7K05RKrI/4VMgROWvVf0BpZr03W7jbr1Do?=
 =?us-ascii?Q?SCk4CzSAsL8PzJ7wE+BLYpyAssTOfcAuBqGJe2MIjz6h3YODpfb6RkQy/LCl?=
 =?us-ascii?Q?PCID5gPvCAUle3dh32IX3Alg3kVmNVmLmJm3OpBkrSKc3cV2eei9HaoQX1bD?=
 =?us-ascii?Q?jI2PrU0wjwHHg7WKolrBEWUx33dTTw5vAK2psQv7lRHLK7C2a71XwwLorKOf?=
 =?us-ascii?Q?ZhInlL9Km5YN2fc/MnI8f0XaTIXUz0iKljGja4nccPdW+mTLW3660W9Zq8TM?=
 =?us-ascii?Q?t3OcnuhywgsFgmIL1zAUZsEPIJzbNrF3P3L+A1yQmyCWKfT3lsEsblxIVTQR?=
 =?us-ascii?Q?bmkQ+KkiljYjNZexzZr+n/kUi9dhh41BPivmoRdFwRzRCvihoUkP00jWCi1A?=
 =?us-ascii?Q?H+EzmxHxdm5k7UocIEartV+rZl9Gbh1mR3rJQdMnbDHA7TKltbP7MxLeR+qx?=
 =?us-ascii?Q?MSkzh6kkAB9QLLN+otfCYuBmcnN2R6qCP19yJC/4WFX7ssafAU9k1nfpGfIE?=
 =?us-ascii?Q?4951j7uKybPwFhedbSGFUP+RPzgZQ8mcKRjk4PF08F15A8tWa008rTV3UYbL?=
 =?us-ascii?Q?0PY9+mgkyXcQA98IIRCUgbJc3aNUgDTy1MlV98W2e4TklXizjiAq0fkyYizd?=
 =?us-ascii?Q?hRMdcQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CQxboYjubaITmj10Zxob5DR6TuaqZcMITmyo11cukez7MgcRB+o1tn/fNtetAooci1EEM4lYtkowbqRcrFyPlE/LOA8KhvAbGbRmsHKmAOyBhkCxdLjlETYy473FMMItuzqZ+7RywHwa84nPOHb1OrRkY8LwdYJ/brdLKMhYo+JqWkMScHDT76GwvLiQt9ciHItryq+0XvpMcJPeOZJiNngAnG7jggzChNrQyMBVMPrO4rUROdOeFHOerxGSP8UXXFNsKByloTIF7z4pXKzDuAlU51eqNRk74XPxQbgV5SLK4LhgIpLFvdluTq04I5QgCPUBgUQYCePE+0Cmdhisu9gC1tiIaqXV2eDLf2UAzMxY1vBtLY1PD4IC+K9IV02tjQKCq1cnKjdnxE+xLMywyVxbR4uHzcEzD6mEmVo2HE7/EPRBEkK4uNLscoWnMSff
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 21:50:23.5145
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ce7cb0f-7b73-4d2d-e913-08de65c9bb21
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7947

The v6.11 Linux kernel adds CXL protocl (CXL.cache & CXL.mem) error
injection for platforms that implement the error types as according to
the v6.5+ ACPI specification. The interface for injecting these errors
are provided by the kernel under the CXL debugfs. The relevant files in
the interface are the einj_types file, which provides the available CXL
error types for injection, and the einj_inject file, which injects the
error into a CXL VH root port or CXL RCH downstream port.

Add a library API to retrieve the CXL error types and inject them. This
API will be used in a later commit by the 'cxl-inject-protocol-error'
and 'cxl-list' commands.

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

