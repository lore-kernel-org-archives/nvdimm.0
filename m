Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010048.outbound.protection.outlook.com [52.101.46.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507B432571F
	for <nvdimm@lists.linux.dev>; Mon, 15 Dec 2025 21:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765834631; cv=fail; b=AJGbN+LMCmVEnLQrTf27pY2q96ohaL5CWLJm2hYqBVxN90Pl34r6drPp7e5HHzt4qt67vE2cN5a+yVIuvzzVBJilkLOjLX5qbQ5MZDXH3I45ZygNMVQlFJI3YAFP+bXkAEbFRLTqAa6q8WxZ9u4ahH2XlTRjbkBI2J1NWkrhvdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765834631; c=relaxed/simple;
	bh=I3/qTXtivTXdMwQUsuGWHhCbt3ih3DUtKpZR5ZYAnSc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OHoK4QxjKERW9QDpL2ecrhFs9jOxQM/kZwqXxJ1+LVVezp6x0ymRjs8D6IDmoGrw/AAb+z9fItA1mq1cYC0o+hftsPjB3Zl2HHFFmsmbKhFdfZ27pdCWQZrlBQCq2/4Amsis5uw/xm7y3yVJEzsr3ZZzN/698+C8zunhdrTeqHg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LE+t5Dwb; arc=fail smtp.client-ip=52.101.46.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LE+t5Dwb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ei/PT/jA/F9px+vh6FW46+9AuILC0AfolfpT/crk2DEo6m2Zl7iXyz1swQAMhoT8cevCRfhy7XratwwxXcyWYX2jJ+RKqu03h4nW+BvZh7rWNRuTK1ag/hfB33DskVVCdtkH3OCKVIINZ+DVV2IO9+8rww4G3ykXSQ0odJnY1x6Sjy1yD5sVpdPDbyPF+CgdI3+xhxkTuzJGX1RCoXs4WkQ8i3ptjEEwNJSq65CLNw+HOqBT63tNOwazjd3tNs4kyn04Au14Tp6+4G2QeGmpFgMFaJ4NGumhmZv7vDV88d975jSY4wN8ofWNwKjUVXFED5hPmRRaBcCKicVIKGuS4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IWDj5fIqHcn0jZQOl0TZxUX9d4wKedgSwODuXpHYQd4=;
 b=x0Fz+JYjW2OkICkZ9JKF45VMlDy2D8lSfAKqpaqv3r+7jipfZOlBB2FgNcVcIUzT17ervKaydC/hml7Xj07/O9aPBUsPyZPAzyVd5ugJ1WX2ehj/l3DzVCcTt5vB174cySR7zbO0an6hLizJftwNqMRHNXNrlOaveal8cSmRaCKANPJ1amAkcuR29RUWlOQAjZst2l4LLPv9Kl/q3y2T1cHcBLkRF7lNwI7NVJBJrRVKeYRgxjClAVT302l0La9uOQr6jvIk1OQQANTHqn5r57gbmdJEq+lNBJnBCFj677x2S7FxwihSABVm4zep08VkLXBZgdM7hqgtepMPO51JcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IWDj5fIqHcn0jZQOl0TZxUX9d4wKedgSwODuXpHYQd4=;
 b=LE+t5Dwb3lNZfppWp13D57PslzDSUkvdVRuuDgBNSkmMjmS16g1llJ6xXAVg093z+PdVbccstG0s67eUS85CWHP/HyJPU5+CfgOU8sVYlWUsC8zuTQfIIHYmcGYIq7kZRBOdebiBISagxlQSF8MdE9euGprPMOOulib6nB9nD4k=
Received: from MW4PR03CA0356.namprd03.prod.outlook.com (2603:10b6:303:dc::31)
 by CH3PR12MB7545.namprd12.prod.outlook.com (2603:10b6:610:146::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 21:36:59 +0000
Received: from MWH0EPF000971E5.namprd02.prod.outlook.com
 (2603:10b6:303:dc:cafe::dd) by MW4PR03CA0356.outlook.office365.com
 (2603:10b6:303:dc::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.13 via Frontend Transport; Mon,
 15 Dec 2025 21:36:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E5.mail.protection.outlook.com (10.167.243.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Mon, 15 Dec 2025 21:36:58 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Dec
 2025 15:36:57 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>, <benjamin.cheatham@amd.com>
Subject: [PATCH v5 2/7] libcxl: Add CXL protocol errors
Date: Mon, 15 Dec 2025 15:36:25 -0600
Message-ID: <20251215213630.8983-3-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E5:EE_|CH3PR12MB7545:EE_
X-MS-Office365-Filtering-Correlation-Id: 202b897a-6ca1-4e2a-5ada-08de3c22138c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?34MI3X0PQwtET71THAdUltDXDkWdPwzT+FCRgOeA7+v5UxQyi9Yrsn/NzvKy?=
 =?us-ascii?Q?w6/oaH25gHoywsnZJ7+zikVLhyKOUQR5ISj0Im9rl+hAG2Z9Axrqgj4JGAMG?=
 =?us-ascii?Q?cfKHWf+ohaABYYLrYWNKQC50vS7WZ2Q8ipmFtw+aBgRJRD7oaPufRjC0F6Hb?=
 =?us-ascii?Q?kZ0x5NzF1aIdGE2FYVkNu8mXo5L1UGonZODpKpbV0WEaBOr12sX5H6rBKpgW?=
 =?us-ascii?Q?RXvBXiXg5tPqCcmE/9ZUFenvVGvDLtSh7aEEdZSXpbRXwUiNRdUboeIteah1?=
 =?us-ascii?Q?6nmOZPEUpaO3zYl0ywzVXFvAL9FHJsUR2JwbKRf+Yr9wdGxOvsVcjx3RWtyM?=
 =?us-ascii?Q?n3PiFPhwnRqkQXj96hAgN0Rb3r416P1gnkifsgA03ULXjswDCeSOXovJvbj0?=
 =?us-ascii?Q?9Q1iW+SvbZ8CNAXmxbllnolBRt5usZK8WkrEbrRFDN1n1kHQxnIvHnTEC92S?=
 =?us-ascii?Q?/jfuFJh+q8iSATgGnAEb7ThNeTuJzKlaN5rx5xLvkrn/FG40rsnWN2c0aoVC?=
 =?us-ascii?Q?4viNZu/s8r12xr9Gu1b7v+v2NGw8t6tg1egMwe6S0yParu7cO908J/XJcrFf?=
 =?us-ascii?Q?GFaVkNvnium3o+/zKsV7FumCumjkszxdDNxf9YRxLB91FLJ4FaK5BzL5QE+9?=
 =?us-ascii?Q?Tb2cglRa3nSxnPMvlpE60xtNO8U120y868AyNNbRkxhO0RjkBSL+5LHh/q5W?=
 =?us-ascii?Q?vdtlqOFYKoO4Q+ciFjbMAHgQdsyYxgdX7RHMicGtzhKtTBMpCaOGxFNJ2AHD?=
 =?us-ascii?Q?VYEJDszbaIZ8EjdO1G93quB5yFkEwrzpe0YLppsy3xuPPR9bxXaix613KPCK?=
 =?us-ascii?Q?tU6dkoFdoUdpNgGQYGNF7a4ZW30gy1pP6F5jIZ4vLboL7sEMeV83DhNIq9Ay?=
 =?us-ascii?Q?GRhA24b/nZhebsNo0BYjBNxV3LmUaMltwK5V/AaVN2uU89eU91xbETbjPHYV?=
 =?us-ascii?Q?I4GQwTOR6RZXnPWgAHjz/KM8dnQXdqNaUXSm4Dxu8dECoe7TwMT0niyt83AX?=
 =?us-ascii?Q?SHYNJBjfoqi2NgPDTVp+gbFnGts6o8fMAiTjJBRCpIyzx8hxZoBbxaFZCPLP?=
 =?us-ascii?Q?qg8FHGdR0HY83YXl8eyUzgZ1mYpMoQ62W3xssc0u3Ft6oxEEQPOaAQ+H60nE?=
 =?us-ascii?Q?7oeTVFYGjiLDKnEQdfX+3LuwjzkgnPBnR4xTSQR3TOt5Jqg0xB3txCgL5+wI?=
 =?us-ascii?Q?PVpzkZzTE/pgjfp8XaL6RDkgwFCXqY7yGMs6/42/Rea3Cct6JTtopsOlwFYS?=
 =?us-ascii?Q?+66q2YlIyAhUKvJMX2KT9PBfLEFUVEHxsQTLSlyuTcfQsFFHkU0wcZ2lme/O?=
 =?us-ascii?Q?EIej3eGeR24jdx2hw/Jnd/zpGFyL2nLYt6DQrQdf6YZPWY9CNJ7S6ViaFFmX?=
 =?us-ascii?Q?GVbnGwuDkyvAboWF3GRljw80enAh4S7yqEInCjseL4Xjxw9iZUkuFAiUxHIQ?=
 =?us-ascii?Q?MHL0zhM3mQxMxkqbCG90rGKWXtfUBDpzuInQMpcMCHwFviub9ExeJyIEmk8D?=
 =?us-ascii?Q?ZbJFtzAPnS0ZMVoannHoLm2IzzHERdoVOtrZfg2AAMWt4Vp51mAz+TYe+EGj?=
 =?us-ascii?Q?7TEZ0DLEtZilGWTV2D0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 21:36:58.6364
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 202b897a-6ca1-4e2a-5ada-08de3c22138c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7545

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
index 71eff6d..af34db0 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -47,11 +47,13 @@ struct cxl_ctx {
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
@@ -206,6 +208,14 @@ static void free_bus(struct cxl_bus *bus, struct list_head *head)
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
@@ -314,6 +324,7 @@ CXL_EXPORT int cxl_new(struct cxl_ctx **ctx)
 	*ctx = c;
 	list_head_init(&c->memdevs);
 	list_head_init(&c->buses);
+	list_head_init(&c->perrors);
 	c->kmod_ctx = kmod_ctx;
 	c->daxctl_ctx = daxctl_ctx;
 	c->udev = udev;
@@ -355,6 +366,7 @@ CXL_EXPORT struct cxl_ctx *cxl_ref(struct cxl_ctx *ctx)
  */
 CXL_EXPORT void cxl_unref(struct cxl_ctx *ctx)
 {
+	struct cxl_protocol_error *perror, *_p;
 	struct cxl_memdev *memdev, *_d;
 	struct cxl_bus *bus, *_b;
 
@@ -370,6 +382,9 @@ CXL_EXPORT void cxl_unref(struct cxl_ctx *ctx)
 	list_for_each_safe(&ctx->buses, bus, _b, port.list)
 		free_bus(bus, &ctx->buses);
 
+	list_for_each_safe(&ctx->perrors, perror, _p, list)
+		free_protocol_error(perror, &ctx->perrors);
+
 	udev_queue_unref(ctx->udev_queue);
 	udev_unref(ctx->udev);
 	kmod_unref(ctx->kmod_ctx);
@@ -3402,6 +3417,184 @@ CXL_EXPORT int cxl_port_decoders_committed(struct cxl_port *port)
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
+		err(ctx, "failed to write %s: %s\n", path, strerror(-rc));
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
2.52.0

