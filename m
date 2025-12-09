Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013026.outbound.protection.outlook.com [40.107.201.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8090329E6C
	for <nvdimm@lists.linux.dev>; Tue,  9 Dec 2025 17:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765300497; cv=fail; b=QPtpPdBNRLpFfTMCDStPi4EzGZjq6qD+fgYWdi6B/IfXCpsmn5qxoVed5hykyrD/Ah9HhHWnGKu7HSFtVeE26RsZx5dT43Sf47Ze9jLTCmLBsPSsS/JQeIY+zwAalDfIFzuOlUcFoCLi2kH9ZLrvEK5Q359lr0YPo4dg7de0LwQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765300497; c=relaxed/simple;
	bh=Z/bme+AfNRh8FACA894mRCCr2kFVmK1ztWrnXAOD1B8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BPc9UylFj38fTxLqqeO8E7FKBd9XkFtAY9Eg6rBu+dmQbwWke5AhVbokUryCQeu6LVAJJpfWst+ecXUIL9v6ktP+Br8LvQvZnMlnmvGp0uBPq+F/6vel5Qc0Gc7PvOLqWFBumHohrR9Tk237H+TNUn5MD+JSkZyp3sLwMAmraIQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RZlBYsyH; arc=fail smtp.client-ip=40.107.201.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RZlBYsyH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lWyRzHWKQGinH3JouqY/61QLzRnhqpA4jH/ZRJNmosd5jaE365Rc5yrjd+hj2D6cOObpcMPHObkET5HF/1srD8YDBkidfDo/DmAStCJy3tnQC5mRJhwR64vVHhqWmeKGjSb5kFsDKzq8Q/xwKToPq69zi0RDzTAFl+vsc8oN2MxElsyCpqnvQbMtsWoZx9X5jjksvLf4HCuIGjU8+wFUDDVk+H32ktmagP5S5NohGyUHc34Lv8XHa1IKcgPK+5OMOG65czkDyubfBxH7GpPCWWBzH1IAW7rQRmUOmTi3pFy5cwMa/2GONSTIWMIZ9/1c/JbYCn3qwaVW6keVGBZ94g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nKFu9bjRE+Uv8vGriiHO3lzN+Zf/LnZh6nrkZDX3bGs=;
 b=Vcejb61aczptSclhky8X7Ijh0Uc+mIZNOskixidrpLk2q0SfDyj4jKmAu9d8nwJ9ON918PulMBJbPbF4ruN16fhuA7aBRnnuTexb4uktTcqq6z4hKG4G4DZWqUdnfgHNed39xv2JL65l8KRsLFXHp2Hqj6hZYaTJqVrsAIolcKcZAk4aYrghqMYEwZnI3bH0kSXlWdFuglHSj+hhA1FmpBKfllYoTKjosqSIVNQ26zO2SDFVE9pb+p07SbLVh+UawVQlC+Mvak1Dpa0FGi63OF8uosMurnPK5GSybnBPc8ZXBtP9srLcX5bEEDOC5EvGpUf3e2SF+vYylzswPYnWbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nKFu9bjRE+Uv8vGriiHO3lzN+Zf/LnZh6nrkZDX3bGs=;
 b=RZlBYsyHcbqZc7WAMpRK3a1OYWeuJyM58hg1/C5yymsXVMB0ei0RKl9Ih15wYeTctMD5Qb9l7iPlmwqnws6ol+gGt6rEEGtFqOqe4U6IzvGbTH7meRNn4h5fRWcnEgtiwrrlHglj3EHbpUi0EwT3L4wAm1oml/RuSr1grvRg5MI=
Received: from BYAPR07CA0044.namprd07.prod.outlook.com (2603:10b6:a03:60::21)
 by CY5PR12MB6299.namprd12.prod.outlook.com (2603:10b6:930:20::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Tue, 9 Dec
 2025 17:14:46 +0000
Received: from CO1PEPF000042A7.namprd03.prod.outlook.com
 (2603:10b6:a03:60:cafe::1) by BYAPR07CA0044.outlook.office365.com
 (2603:10b6:a03:60::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.14 via Frontend Transport; Tue,
 9 Dec 2025 17:14:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000042A7.mail.protection.outlook.com (10.167.243.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Tue, 9 Dec 2025 17:14:46 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 9 Dec
 2025 11:14:41 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>, <benjamin.cheatham@amd.com>
Subject: [PATCH v4 2/7] libcxl: Add CXL protocol errors
Date: Tue, 9 Dec 2025 11:13:59 -0600
Message-ID: <20251209171404.64412-3-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000042A7:EE_|CY5PR12MB6299:EE_
X-MS-Office365-Filtering-Correlation-Id: 93fb3632-d57a-4083-bdf9-08de374673e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WP+i6qb/a4G+dWSOVKGKV/mLfb1jaUw2TmBS59lwrH20qpOYyXsEX7GgXt9R?=
 =?us-ascii?Q?DNjNHKXIcHX7Yc+AyZtGJ+HFtr/VfOGbAqIV5aQaYXnp2PbCWne2iKq5ni5W?=
 =?us-ascii?Q?6NVg48P96q1ZsMbVG4Q+3BVUu93aZGg3xB/hJVHpys8zs0yMjSmWx5tXZCBi?=
 =?us-ascii?Q?OCxYwZTYZYC9CTdTFcYuvvJso/a1IbNjWsr9ZxnygVzsMkH0HOAPD5xI7tBZ?=
 =?us-ascii?Q?L/RthwyReJ3tWCZoveKAYnyRrBxB3thQ+Ue5iDS0csC0eYwPFbHN2PkZyhWl?=
 =?us-ascii?Q?gd0uJD9ZhlqL9KbKNBwSpCPy5SjkFbZVV431BEC35V1lI1sUHq3GoFB91+ob?=
 =?us-ascii?Q?sQvxERN1sAQZwBjQMEBcYypOPEPPF+wdK8GYtuD9sE8Ci0ZsP+jRk8Jrz5fR?=
 =?us-ascii?Q?twEIBTKJNI3HqgIQ7zDE60AtSuLzqPXiiZzSdRdxcZEthdjQFMIosoFnqIrV?=
 =?us-ascii?Q?wuvaTQpign3u+gWAZN9wSX330rmawT5LpyIOPjk/YA+tbjwByznQ4x6BYluy?=
 =?us-ascii?Q?L+kvEyWitumc6fzRiFCHrhHuYSjVJsT3BR6foOcJ5xLJF/6MVGbN3tezHXIO?=
 =?us-ascii?Q?u7DggJDgPnVVqwQO9ptcO2aeRlrY9nDhwCcI5ago9JriPzQ1mf4J2F0y3Izt?=
 =?us-ascii?Q?ZA7hQpzJEbpcyi8jAmPQGymMvqW0ZZerNtuw+9vTxjFIrhwFnbhM8N09S3na?=
 =?us-ascii?Q?kTZfdfWiYwS60scD7SLp2Df3PqLhkoUfeQ4egHyXP7pB/xoNhwsWIPzSPs47?=
 =?us-ascii?Q?XeHfmcTW4E5uTUzmjgjpHaXdfywpVKfXrzqMGrUeSlBgX8eidpwrqT74qM9H?=
 =?us-ascii?Q?OuDjE0HvG09L83webPlpj6BbqOI3wuucbME8+v0z/W2IyN9lTAziTL0AsHur?=
 =?us-ascii?Q?sWQKMJlQH8NTxGekI8u/aDyZWeTl44gI8pOorQUZMC6U2e7VozY10eRQkVvf?=
 =?us-ascii?Q?qkOD+JRcv1lt6juvdS6HoFYMPf7G5WQOevSlIAiXBvBOt52mnzdwmFPHB83y?=
 =?us-ascii?Q?c1WpbM1WZwzslNxeH6Id7WMBwaZs5xT+7AYGfqpXjIlmcXJ3opQZZZnEg7Z1?=
 =?us-ascii?Q?JbwRwemLDdzLugSPpi2rj+XMO66QAmtln5rvuys7rwNtAHarw7e7xGGf4Ku7?=
 =?us-ascii?Q?JBBZwCMPEht19iIDe8oi1GHq9nBnnCtqgVW6Lj/+oQ8Tz7rtPeUvQIEPgHcl?=
 =?us-ascii?Q?I4LuKqPl4QpT8YtAakPFDg1esFL7N4IA0h+9ohxm2LLXxQCPAlTe49KR2noA?=
 =?us-ascii?Q?DN1Xq6Tdfqra4bf0q3hLpZIBd5W8VPY8yOHDoNAPUSCxYZkFl8et5t3Btxna?=
 =?us-ascii?Q?PEfzgnjBPuO6r1hlVku4IXElFVI20pihAfpHiClkcJ/D4qU+M1mE2kL8LWMe?=
 =?us-ascii?Q?8fmeqO+KubpJiPX6nH7J8EoE7DBDVRhj5ywiyGbKYeIRdPMnkpDnonRpF5Tj?=
 =?us-ascii?Q?aB1+dCVTuFXOkKfJKBUA1Vlr87EM3ZVHwv0ZGchB+W5pl+UqLxgQsJENv6Wk?=
 =?us-ascii?Q?RiP5XuMcqem4jUx3vyHtAwA6aWWkeImY8ZdvNp8tedKwMoHB8Bh7E8kWWKPs?=
 =?us-ascii?Q?hGYHybLGtXMHU0pQ3Cw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 17:14:46.3548
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 93fb3632-d57a-4083-bdf9-08de374673e5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042A7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6299

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
 cxl/lib/libcxl.c   | 193 +++++++++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym |   5 ++
 cxl/lib/private.h  |  14 ++++
 cxl/libcxl.h       |  13 +++
 4 files changed, 225 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 3718b76..44d5ce2 100644
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
@@ -205,6 +207,14 @@ static void free_bus(struct cxl_bus *bus, struct list_head *head)
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
@@ -328,6 +338,7 @@ CXL_EXPORT int cxl_new(struct cxl_ctx **ctx)
 	*ctx = c;
 	list_head_init(&c->memdevs);
 	list_head_init(&c->buses);
+	list_head_init(&c->perrors);
 	c->kmod_ctx = kmod_ctx;
 	c->daxctl_ctx = daxctl_ctx;
 	c->udev = udev;
@@ -369,6 +380,7 @@ CXL_EXPORT struct cxl_ctx *cxl_ref(struct cxl_ctx *ctx)
  */
 CXL_EXPORT void cxl_unref(struct cxl_ctx *ctx)
 {
+	struct cxl_protocol_error *perror, *_p;
 	struct cxl_memdev *memdev, *_d;
 	struct cxl_bus *bus, *_b;
 
@@ -384,6 +396,9 @@ CXL_EXPORT void cxl_unref(struct cxl_ctx *ctx)
 	list_for_each_safe(&ctx->buses, bus, _b, port.list)
 		free_bus(bus, &ctx->buses);
 
+	list_for_each_safe(&ctx->perrors, perror, _p, list)
+		free_protocol_error(perror, &ctx->perrors);
+
 	udev_queue_unref(ctx->udev_queue);
 	udev_unref(ctx->udev);
 	kmod_unref(ctx->kmod_ctx);
@@ -3416,6 +3431,184 @@ CXL_EXPORT int cxl_port_decoders_committed(struct cxl_port *port)
 	return port->decoders_committed;
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
+							    unsigned int n)
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
+	struct cxl_protocol_error *perror;
+	char buf[SYSFS_ATTR_SIZE];
+	char *path, *num, *save;
+	size_t path_len, len;
+	unsigned long n;
+	int rc = 0;
+
+	if (!ctx->debugfs)
+		return;
+
+	path_len = strlen(ctx->debugfs) + 100;
+	path = calloc(1, path_len);
+	if (!path)
+		return;
+
+	len = snprintf(path, path_len, "%s/cxl/einj_types", ctx->debugfs);
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
+		err(ctx, "failed to read %s: %s\n", path, strerror(errno));
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
+	if (!ctx->debugfs)
+		return -ENOENT;
+
+	path_len = strlen(ctx->debugfs) + 100;
+	path = calloc(path_len, sizeof(char));
+	if (!path)
+		return -ENOMEM;
+
+	len = snprintf(path, path_len, "%s/cxl/%s/einj_inject", ctx->debugfs,
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
+	len = snprintf(buf, sizeof(buf), "0x%lx\n", BIT(error));
+	if (len >= sizeof(buf)) {
+		err(ctx, "%s: buffer too small\n", cxl_dport_get_devname(dport));
+		free(path);
+		return -ENOMEM;
+	}
+
+	rc = sysfs_write_attr(ctx, path, buf);
+	if (rc) {
+		err(ctx, "failed to write %s: %s\n", path, strerror(errno));
+		free(path);
+		return -errno;
+	}
+
+	return 0;
+}
+
 static void *add_cxl_bus(void *parent, int id, const char *cxlbus_base)
 {
 	const char *devname = devpath_to_devname(cxlbus_base);
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index e01a676..02d5119 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -299,4 +299,9 @@ global:
 LIBCXL_10 {
 global:
 	cxl_memdev_is_port_ancestor;
+	cxl_protocol_error_get_first;
+	cxl_protocol_error_get_next;
+	cxl_protocol_error_get_num;
+	cxl_protocol_error_get_str;
+	cxl_dport_protocol_error_inject;
 } LIBCXL_9;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 7d5a1bc..8860669 100644
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
index 54bc025..adb5716 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -496,6 +496,19 @@ int cxl_cmd_alert_config_set_enable_alert_actions(struct cxl_cmd *cmd,
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
2.51.1

