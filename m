Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010017.outbound.protection.outlook.com [40.93.198.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C00B34D911
	for <nvdimm@lists.linux.dev>; Tue, 21 Oct 2025 18:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761071552; cv=fail; b=BvK9FNmJoUxkRqo5qZyBMbsunavh1dA66PPY5Hs9pBSxH0Y8fvpRzYz3OWAeySN9JHQDheybyif0q4Ua5OMp4MwOe8YKx6xOpNPkHZCFh1IF0i96X0lMc12jhKMsIxc4ISLdCPNrRL6uql6xpiggoLRuYVK7rYTdd0x2Yzt0iD4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761071552; c=relaxed/simple;
	bh=+FSfeNtiVe9zpsQtNfNRg0VzyeZCyp8Gflhi+XaQT9Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gfODCdWg+e0ZSLEciMjCpk5VcS/z7dVPBHhSIRdpfokvqXVhCZLlIvHmcsOQFszM2fhuvJFX8W4+qB94Jqi/wta5hr4kQ7WxVnpCcVLrhQo8dAlFrgJsgmVb+PQ3mZTBJaPLYD0AHDd/xJb4C5D0kVCoP0lSc7akGGVijenvIFE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3lBxmwbL; arc=fail smtp.client-ip=40.93.198.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3lBxmwbL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qsDDGbjzkg55Wm53DVFswqVxDLuLM5EwkWGOFlGjIAJ5UGzir3YmOHJ9Lja60xbzxGTIK51GqrXf+broFZwuN1xkcdvuBD2R0HMp7AL0uFt36T1Mx7eAPmyObbM9IMF6YILupWXxkqBIqBqj/FppoSBFWYnXcFsYbSFMDsaEWQJRMXLU5CPwKzBVVr6aORXFDujMnD4gHvqwdaI6fv6o2UDg6fgWajSIiy2DJ+XuyElJhJBhlE4bH5kdcdUAFV7u3qawTQ+VfY3+9+tDuzIjty7f0ayz61/gkNWodGtyLA94NMuTUCdZR7oxgL5JDdTNxXrLsf7YoP3r0Y8KtbnYhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TfC1e6H6/LpOtd0FDaeYpXmu4iw69hxKCl4c/bplGPk=;
 b=Z2LFnNZPrpcwlwaow47H6pejWX7lrCKJyQ/Mf+qJaQUOIIvRPLg5qOleCQr+03miyY1HZq3Xv53SRff8HVlZMDoqeWTNUueNxI1cRV1wRPcwZi0cX8qp6VPNtqb3RyjxburZJHmiaTlzkRrqNx0iXbDsIMie4d4X4rIfg19ZRowI80MB6cFqHf0n/E+Cd313wm167/W5rSmhvxx2nJaOhFSeQRc2reZ+HGj257OVO5rczdg63ZPILwXSKUxGOYazh408hdRRTiSknNVI4Kz3J+p/PX7n6uKMncO26kvoxrSJsoeNR56FvI/XdX/qjaRjDM6e36cyzyt4ZmelUekwaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TfC1e6H6/LpOtd0FDaeYpXmu4iw69hxKCl4c/bplGPk=;
 b=3lBxmwbLe8ONe6LLrRbDrfNlWZNFrbYrB2IxdKcOIAxVXGugh0/CCXY12BYGg4lUbfevlTPNNc1PoGN5XFqzwkz7PuvrNuFIaVm0AivCrQVkckfN2E8xExublNgGWOQuS7lsQK0FcsKo8ycLPSa0fv9pHMY7nA2PE9SEi3omFMA=
Received: from PH7P220CA0071.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:32c::33)
 by CYYPR12MB8939.namprd12.prod.outlook.com (2603:10b6:930:b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Tue, 21 Oct
 2025 18:32:27 +0000
Received: from CY4PEPF0000EE39.namprd03.prod.outlook.com
 (2603:10b6:510:32c:cafe::91) by PH7P220CA0071.outlook.office365.com
 (2603:10b6:510:32c::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.12 via Frontend Transport; Tue,
 21 Oct 2025 18:32:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EE39.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Tue, 21 Oct 2025 18:32:26 +0000
Received: from SCS-L-bcheatha.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 21 Oct
 2025 11:32:26 -0700
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>, Ben Cheatham
	<Benjamin.Cheatham@amd.com>
Subject: [ndctl PATCH v3 2/7] libcxl: Add CXL protocol errors
Date: Tue, 21 Oct 2025 13:31:19 -0500
Message-ID: <20251021183124.2311-3-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE39:EE_|CYYPR12MB8939:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fce3a2c-ebc7-4075-bdb6-08de10d02f8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5LfriKowpxOiY8v/M5bWIxXjTjX7DtRAmwt8ysfiqR1/ogpt71NABJx/bSjk?=
 =?us-ascii?Q?9Gchz7Luhu4joW+j7ERw21Ofy1saWmicEP7CQtc9E+jTVl4BphiB1Ui1jth1?=
 =?us-ascii?Q?BsOSzQ+ahXZKHC5sdOE4Wlw/xZe3xMfD8Tw4GPrwyBOMLpfjmb0cdjXW5IKf?=
 =?us-ascii?Q?oNhdwPtmFrPZsKVir22oicBg3DAKC96l/xlDvKklakpn2wR3CZn8/4zMxYdy?=
 =?us-ascii?Q?8qiHdk/+CQcQL4za04ixO0HXXfpk+0gcWz0jSHLSieHXloGebr8/Jt5WQpq4?=
 =?us-ascii?Q?JoCqIb251Pkjsk1up35bIlApY6yJb+sES8qZ+oFU7DrxI6Vn5Wnn0RoNNjMj?=
 =?us-ascii?Q?EGU0Y/i0HfAOfC6pILgPvGM0WktQdfIbP83vLFeFpmnHkJvXiJ4dWSqpq6Dw?=
 =?us-ascii?Q?ZM9wWvkByHjuURQZc9xKOR7hTBxZyNVCswBDTeksbVaz250ZVuDJ2UQFDzQA?=
 =?us-ascii?Q?pv+MmTquoyKCF9nia41xeShufdSNQrjU0M/nzDzRc+a2C5XGA7hEpcRFcirP?=
 =?us-ascii?Q?S1qpqRVFdKzpx0fl0zlw0ClpQdnHack6u0smlrtBE9XypoBDlY80q6ZZ4Hpy?=
 =?us-ascii?Q?BR1NzGt2C/DG6cxpALR3O2HCSm75hyZqUxM9+vMKgHLT/x/IZGttuHdS3Shj?=
 =?us-ascii?Q?I7SqVc2H5tMei9HThLUQn9nYh7XlP/huziXeMIRaqPTIOpq/OEShoYJPyJsP?=
 =?us-ascii?Q?KhebAbACweDzBDDDXSNaK8vqUV/UnGPIoX9adDCvYzXzHPs7hWYppe1N7w1a?=
 =?us-ascii?Q?QSuyvOTbsVsWxXuvVSn+DdpckxJtn6e4sjQ2yT+fH3zZ+ZjUMB9KyakNY7Ul?=
 =?us-ascii?Q?j8lXiS/nni+leGmXIs8jgUFlypXZZ+r7X0Qywsto8J0bjEwN75TMdA/fHIfg?=
 =?us-ascii?Q?kuZ8J8PYfFXHMDDarsRwitAp1HvgEyKH3e4dyFoqD3AnS6CnyHPjvusUNPYh?=
 =?us-ascii?Q?e/T6xlluaVVzzD09QYufnq6uvNaGvvkpLgSPekcgqhI1TZrd7H/TpzpXMlPO?=
 =?us-ascii?Q?u9aDkPUmPMI4APu4Mh4VBPiR8uNjtAAG59VHsIDTt6lLliHunBZrIZXbOk6x?=
 =?us-ascii?Q?5q909JHpQm4sJIa4ERBmeVhCuAiAQCjFNNXyJuGEOFYQ6Rs3v6c3ZN/z4pL1?=
 =?us-ascii?Q?IYzAEfdkShCIhVSX29O+X4n0NYzeHjIX3pSeQvJ+M5tAmaUyBSNxA9ChB+B4?=
 =?us-ascii?Q?2KaNna0U3libU58ijIP/1ekIcoS5XwK2BC1VD6HkrXIttTr9mCowXTnrzNeu?=
 =?us-ascii?Q?u17F0PWHvdnRO5TXp9YY/cC6sDhcoNh7KH0hbC1VbxMq7XNkGAdciISQDn4k?=
 =?us-ascii?Q?G2x5hPomG3hjL1vIQKNmOah8BbNM0Bdgc4JorTa4qRx7Q8LxHSjRSNkK2+XY?=
 =?us-ascii?Q?LrGId9s6jjIRB2/Au0MT437BtCVDy7rwhQPr8sORBp9AQIDYfRwEKohvV/t9?=
 =?us-ascii?Q?Z5ufmpSwxbulEHEUIh6qxXpEuG5zbgml3A/q/RRiFYagAwBWYJ2Kr85s+nDe?=
 =?us-ascii?Q?EdHaWZBSZqgZ/snsJKJrzWFC1/MBUYypQetq8IT7QWPs89EU//EVNe/UfUc9?=
 =?us-ascii?Q?72F/ghOUW6kM7CUj6KI=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 18:32:26.9243
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fce3a2c-ebc7-4075-bdb6-08de10d02f8c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE39.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8939

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
 cxl/lib/libcxl.c   | 174 +++++++++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym |   5 ++
 cxl/lib/private.h  |  14 ++++
 cxl/libcxl.h       |  13 ++++
 4 files changed, 206 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index ea5831f..9486b0f 100644
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
@@ -3416,6 +3431,165 @@ CXL_EXPORT int cxl_port_decoders_committed(struct cxl_port *port)
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
+	struct cxl_protocol_error *perror;
+	char *path, *num, *save;
+	unsigned long n;
+	size_t path_len;
+	char buf[512];
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
+	unsigned long path_len;
+	char buf[32] = { 0 };
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
index 7d5a1bc..4e881b6 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -108,6 +108,20 @@ struct cxl_port {
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
index 54bc025..9026e05 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -496,6 +496,19 @@ int cxl_cmd_alert_config_set_enable_alert_actions(struct cxl_cmd *cmd,
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

