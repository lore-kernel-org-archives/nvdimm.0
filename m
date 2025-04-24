Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00D6202C5C
	for <nvdimm@lists.linux.dev>; Thu, 24 Apr 2025 21:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745529891; cv=fail; b=XDFnztcjwni3Ysd4steQ0HwPC7WoPsFObOOqc9MJLIslOf8WQSK/etyFvy6eGIbpFL0LDcNa0Vx/wscLfQFDwj3jRQwz60MavpJa3BVnGVxYOYmJfE9x3zgMzStc9opnuEkOemVtaLmuJrlNEOuosZNYctTPLivhnDF4uVQo/fI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745529891; c=relaxed/simple;
	bh=y//nE5WmBdzAFcipu8XGvtjiP3jEm6vJKTxgPIyBrFc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TreOCETcc+Ll8O5num8vtuLMBqe9JIjPVABYlxoxpp6dknbW8giOgrPa/EtDGawyktPhA6pO/OvtfbtiXl+XsvcVlok29mJF4YUeg9Cl4koB9pcfQJGH07O7iRY1YtWXLZSu6ai1+7PU1O/ECjk/98tXBnGvUYz+Yw0mXlzaJHU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1h2RQVuW; arc=fail smtp.client-ip=40.107.94.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1h2RQVuW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aVxoK7qB2ZMLq6uLKA5j4ABklPhYqHnwLi6pJGeVMggqoqyx7X33P3uShuNFqjceXm1bsb4VL3m9KMXAyzXd+FNElZqi5iIzM+WxZJAepw2qBiRmwDY0tMPPS+2ZfIQ8XkakGh6+rJEOh758uveiIeuvT5RSZRJuV6RYjks1bgTzI6ak3EMdb4rumDCZdo17mlHCxqTLhlHCjKO/KltsH9Z8z4Cy6RWtEI9MYIE60Ft/ctQfyziRcBGZyeAk+QGBT8xF+hUAc7A6tsde/fdHQxKiGYlQWIwFnPchRuqoGYZzXimwoZ6Y+aZ/iziA2ZkU94orAe2derdmQwxSyAxWHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XhYH2GlW0d+J0XT+4fZZgWr4yFG/CJxp48wu8hHowB0=;
 b=RC/cs43z5i2DtOWgQFOHE+0Vv5SZ+4hbyJxXoy2rJVnhDpwDG38UdrKX5lo0D7SpWEOqBh4yBTdwA+bSjiEidldM/IkhyHznlteKqFtqkEtVE23HHtaYVPwBgHnCkC7L3yUx0CUPldN5t6OsuTi0cuNpDmLpdQpRJgjXo8Gyd6XGF03luQ6+iJ7Pkjpohobe/R0cUrwM/yjkoCyRNaUP1EKDj53nHCqOwC2ymA2oZnfSgllJ/bi8/gK4mw/A6LN4f7o1R0a6vvkGoWsmv/X9fapMp2HR+qSAgnj1Z7Q2ieQ0CCitNTXoe/gPopPWEDtonjpKijwqvXKNUo9UL1UreA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XhYH2GlW0d+J0XT+4fZZgWr4yFG/CJxp48wu8hHowB0=;
 b=1h2RQVuW5CJak3ddNxX3E5dW5q2Ie0x6b9V9ZTlO4KH9OZ7KVS3kjKUwYGi7o9z4UwNGQkQuISncEUp43+rMr6tg44CJ//Xl8X7JyoBKbNvHjBhMRDxPqfh29P6Mwq2VCToOD2zqB2eN/LN6dxt0/VK/rk1hQn+HHKlRo9PIkJQ=
Received: from BYAPR21CA0017.namprd21.prod.outlook.com (2603:10b6:a03:114::27)
 by SA0PR12MB4445.namprd12.prod.outlook.com (2603:10b6:806:95::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.27; Thu, 24 Apr
 2025 21:24:44 +0000
Received: from SJ5PEPF000001F3.namprd05.prod.outlook.com
 (2603:10b6:a03:114:cafe::f4) by BYAPR21CA0017.outlook.office365.com
 (2603:10b6:a03:114::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.12 via Frontend Transport; Thu,
 24 Apr 2025 21:24:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F3.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8655.12 via Frontend Transport; Thu, 24 Apr 2025 21:24:44 +0000
Received: from bcheatha-HP-EliteBook-845-G8-Notebook-PC.amd.com
 (10.180.168.240) by SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 24 Apr 2025 16:24:41 -0500
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>,
	<alison.schofield@intel.com>
Subject: [PATCH 2/6] libcxl: Add CXL protocol errors
Date: Thu, 24 Apr 2025 16:23:57 -0500
Message-ID: <20250424212401.14789-3-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F3:EE_|SA0PR12MB4445:EE_
X-MS-Office365-Filtering-Correlation-Id: afadfb13-7322-4433-1d1e-08dd83766ed3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Tk0HQg4DR82t02Ccuhua6NSL1GQU17KGUK8iJrAO+ZNhGilktA6mRMrPn8ZC?=
 =?us-ascii?Q?709dx5mH04OeytCNainFIEDyB1W6ZhIl1qBCmKCh4d1SPfbdjibh/XZmheer?=
 =?us-ascii?Q?vF/koMbclpUt1Ea0/RdwjTioLorkFS7Yr//5TTVvLFT+o4zlIOzl4hc+fDC+?=
 =?us-ascii?Q?mwHNAUxLra7Q93zyd5rbE2kCbmy8WcR3ok4JoPgksGeJRloWTBNX/ychgQWS?=
 =?us-ascii?Q?8FcqmqyoWY60AW8/IrD0z9QqVJoW1JwsBQ6ztjPbiyKqh2mxCGx8+Apk6/nN?=
 =?us-ascii?Q?fXHTQF4/PycV9NR1t9OW8JN1BrnHackG5DcQNcMmmJnnKOmLW/lqt+V6iwl5?=
 =?us-ascii?Q?x6tJ9s2QT2vOvBq6V9JgOwXKbrHc3UsnvApvGnBqn816YM9hZfJZkCVp9lvn?=
 =?us-ascii?Q?wCvIwVZ9z8FgFsnejUT/r2gcKxuPcQ7Own0ze7ioq4zevZ9jrjwmZ0ZEsHlk?=
 =?us-ascii?Q?/tOBenkQDOvZyPoUyE2a7jLQwieUNhb6sdM4ZUxR+jfmO0wPbGaltJiQ+NfD?=
 =?us-ascii?Q?ClWkQ8UqbJYW669b0Tjgvv8iX0/E3J/yrorp5yoNxIjsMjskRmFjIrGZtQbg?=
 =?us-ascii?Q?P6usPKY5+kMvJHWcK/wWGrIM5okmwlVYNJQOLQO/VzwxG92IsxA3p7+xsex9?=
 =?us-ascii?Q?nE+KPyyCmjNUMsnH8Tsaq8fgrqmlLWETscQKPcEbDksTdmXRBtN+ZkSwgFZZ?=
 =?us-ascii?Q?Ra/lZQEzffkHO8l2UdlO0VU9A/dDnQOyTWfNgZlO0eY8K56Ykhrh0dRyO6cO?=
 =?us-ascii?Q?MWjvsgqODikqoZ7l7FSp8YBQAQO0a7I9biCKfWeBkWXmBNcg19ChqoDRT1Fr?=
 =?us-ascii?Q?ui8cpNHRtZTaT4UWx/vwDWXP3grvHSyZ6TMa6shpDj8B3/n4eQ4d7BHaDO3n?=
 =?us-ascii?Q?7bnXVnyIuKMyg83zhUjQ0OhDnaHVc8luBwyJs0vwwDiPaJhLqL3VpOzbqGl5?=
 =?us-ascii?Q?TrFAJVQ/VhdyNahk0ckYx0li70ck9dHHdCoheHBWdtybhvk428t9bidSYyxI?=
 =?us-ascii?Q?TB128aFG3Q9xvzEeIbIEA0D2GLg2rSKFzN4TcfYD6dk5n0eKNfXkZ/dC78/V?=
 =?us-ascii?Q?KNwJZ6Pzvv9nnorWbFJrzKUk+/mf9z59tHEBDkkbKxM0VekxL022f0S5JwSZ?=
 =?us-ascii?Q?wMwAUPx8BnUZ8Gqyl74VGCbKMT1fyusdz2oAjOrE4QOQqts5WtebCYzQHA/q?=
 =?us-ascii?Q?/U6ur0ByuznpdB0i/ak6YeotXZZb5XRWiMRhaDm63GXlXw4ZEJGwVh3hjF0h?=
 =?us-ascii?Q?qCt72fztHrxF8iUBtDRNOHhvDmt6F5sa8Gl95HvUdVuKDuhCieWrUY+v9Jc4?=
 =?us-ascii?Q?ZTOi8nJWFr5GKMTNSmJdG9Cx9RcHp/8o8D3i5H6C+U4fVHI5fy8ilFCNizZf?=
 =?us-ascii?Q?vcLCj/1+/z/PnPaDVsvhALJwsbcq0VTqxpHn1pAgw5yTwblI5aRUiLxssrK7?=
 =?us-ascii?Q?5cUSMKu2YJJeoGlX5+O29mVUJgFyahMu7Ym1JQmAdwZPQqeTBwnCRg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2025 21:24:44.3781
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: afadfb13-7322-4433-1d1e-08dd83766ed3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4445

The v6.11 kernel adds CXL protocol (CXL.cache/CXL.mem) error injection
for platforms that implement the v6.5+ ACPI specification. These errors
are reported by the kernel through the einj_types file and injected
through the einj_inject file under the relevant CXL RCH dport or VH root
port.

Add a library API to retreive the CXL error types and inject them. This
API will be used in a later commit by the cxl inject-error and list
commands.

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/lib/libcxl.c   | 166 +++++++++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym |   5 ++
 cxl/lib/private.h  |  14 ++++
 cxl/libcxl.h       |  13 ++++
 4 files changed, 198 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index e86d00f..408b2a3 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -46,11 +46,13 @@ struct cxl_ctx {
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
@@ -204,6 +206,14 @@ static void free_bus(struct cxl_bus *bus, struct list_head *head)
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
@@ -290,6 +300,7 @@ CXL_EXPORT int cxl_new(struct cxl_ctx **ctx)
 	*ctx = c;
 	list_head_init(&c->memdevs);
 	list_head_init(&c->buses);
+	list_head_init(&c->perrors);
 	c->kmod_ctx = kmod_ctx;
 	c->daxctl_ctx = daxctl_ctx;
 	c->udev = udev;
@@ -331,6 +342,7 @@ CXL_EXPORT struct cxl_ctx *cxl_ref(struct cxl_ctx *ctx)
  */
 CXL_EXPORT void cxl_unref(struct cxl_ctx *ctx)
 {
+	struct cxl_protocol_error *perror, *_p;
 	struct cxl_memdev *memdev, *_d;
 	struct cxl_bus *bus, *_b;
 
@@ -346,6 +358,9 @@ CXL_EXPORT void cxl_unref(struct cxl_ctx *ctx)
 	list_for_each_safe(&ctx->buses, bus, _b, port.list)
 		free_bus(bus, &ctx->buses);
 
+	list_for_each_safe(&ctx->perrors, perror, _p, list)
+		free_protocol_error(perror, &ctx->perrors);
+
 	udev_queue_unref(ctx->udev_queue);
 	udev_unref(ctx->udev);
 	kmod_unref(ctx->kmod_ctx);
@@ -3272,6 +3287,157 @@ CXL_EXPORT void cxl_set_debugfs(struct cxl_ctx *ctx, const char *debugfs)
 	ctx->debugfs = debugfs;
 }
 
+const struct cxl_protocol_error cxl_protocol_errors[] = {
+	CXL_PROTOCOL_ERROR(12, "cache-correctable"),
+	CXL_PROTOCOL_ERROR(13, "cache-uncorrectable"),
+	CXL_PROTOCOL_ERROR(14, "cache-fatal"),
+	CXL_PROTOCOL_ERROR(15, "mem-correctable"),
+	CXL_PROTOCOL_ERROR(16, "mem-uncorrectable"),
+	CXL_PROTOCOL_ERROR(17, "mem-fatal")
+};
+
+static struct cxl_protocol_error *create_cxl_protocol_error(struct cxl_ctx *ctx,
+							    unsigned long n)
+{
+	struct cxl_protocol_error *perror;
+
+	for (unsigned long i = 0; i < ARRAY_SIZE(cxl_protocol_errors); i++) {
+		if (n != BIT(cxl_protocol_errors[i].num))
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
+	size_t path_len = strlen(ctx->debugfs) + 30;
+	struct cxl_protocol_error *perror;
+	char *path, *num, *save;
+	unsigned long n;
+	char buf[512];
+	int rc = 0;
+
+	path = calloc(1, path_len);
+	if (!path)
+		return;
+
+	snprintf(path, path_len, "%s/cxl/einj_types", ctx->debugfs);
+	rc = access(path, F_OK);
+	if (rc) {
+		err(ctx, "failed to access %s: %s\n", path, strerror(-rc));
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
+			list_add(&ctx->perrors, &perror->list);
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
+CXL_EXPORT unsigned long
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
+					       unsigned long error)
+{
+	struct cxl_ctx *ctx = dport->port->ctx;
+	unsigned long path_len = strlen(ctx->debugfs) + 100;
+	char buf[32] = { 0 };
+	char *path;
+	int rc;
+
+	path = calloc(path_len, sizeof(char));
+	if (!path)
+		return -ENOMEM;
+
+	snprintf(path, path_len, "%s/cxl/%s/einj_inject", ctx->debugfs,
+		 cxl_dport_get_devname(dport));
+	rc = access(path, F_OK);
+	if (rc) {
+		err(ctx, "failed to access %s: %s\n", path, strerror(-rc));
+		free(path);
+		return rc;
+	}
+
+	snprintf(buf, sizeof(buf), "0x%lx\n", error);
+	rc = sysfs_write_attr(ctx, path, buf);
+	if (rc)
+		err(ctx, "failed to write %s: %s\n", path, strerror(-rc));
+
+	free(path);
+	return rc;
+}
+
 static void *add_cxl_bus(void *parent, int id, const char *cxlbus_base)
 {
 	const char *devname = devpath_to_devname(cxlbus_base);
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 61553c0..a0ab86d 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -291,4 +291,9 @@ global:
 LIBCXL_9 {
 global:
 	cxl_set_debugfs;
+	cxl_protocol_error_get_first;
+	cxl_protocol_error_get_next;
+	cxl_protocol_error_get_num;
+	cxl_protocol_error_get_str;
+	cxl_dport_protocol_error_inject;
 } LIBECXL_8;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index b6cd910..85806ac 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -102,6 +102,20 @@ struct cxl_port {
 	struct list_head dports;
 };
 
+struct cxl_protocol_error {
+	unsigned long num;
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
index f3f11ad..f8b2aff 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -487,6 +487,19 @@ int cxl_cmd_alert_config_set_enable_alert_actions(struct cxl_cmd *cmd,
 						  int enable);
 struct cxl_cmd *cxl_cmd_new_set_alert_config(struct cxl_memdev *memdev);
 
+struct cxl_protocol_error;
+struct cxl_protocol_error *cxl_protocol_error_get_first(struct cxl_ctx *ctx);
+struct cxl_protocol_error *
+cxl_protocol_error_get_next(struct cxl_protocol_error *perror);
+unsigned long cxl_protocol_error_get_num(struct cxl_protocol_error *perror);
+const char *cxl_protocol_error_get_str(struct cxl_protocol_error *perror);
+int cxl_dport_protocol_error_inject(struct cxl_dport *dport,
+				    unsigned long error);
+
+#define cxl_protocol_error_foreach(ctx, perror)				       \
+	for (perror = cxl_protocol_error_get_first(ctx); perror != NULL;       \
+	     perror = cxl_protocol_error_get_next(perror))
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
-- 
2.34.1

