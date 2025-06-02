Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9392B1993BD
	for <nvdimm@lists.linux.dev>; Mon,  2 Jun 2025 20:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748897852; cv=fail; b=a024TD9gz2v/UEnedXoSI/YPZ/5/Vc8MQkR3865sjmx2tUykosfNdVa0ZJtUJf1TaiYJMV2bQUvz2Yig2KR3TLZnj1XT55enmTkU/mvTkrQZiPgM0fXhcdJ4kouOQaUD/N9Nk63KMj9eFMe09Hjyy+zl/Saxu3EBeSwmjLihnRs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748897852; c=relaxed/simple;
	bh=NVOUS78IqT4SMj63+uiW6GH7dixLhEm6dR0zq1BT09s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TJkXlNwXhSbu3fuTqPjvkPxDf3hHQVMrS9TR0w+ieXsHWUOLAMltPPYCFZJQp4RLSDLvg/zx6O2esHkvEM1awtsmD8B8G8QZcmooU2y07zmrEpbUwnZLV7C13CaUMpu5YpqTWIVYvLTH4HYXSYhVHy0v36ISuI54y9x1XN4+6XM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=A+u5b+Pi; arc=fail smtp.client-ip=40.107.93.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="A+u5b+Pi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QvwtGlGz9A+33co9AIa9v+NaZVTo20xgH19n1iWUMWEW+Kq1lrpWm4gRwj/2OIwXSpPsqbwOk75yUnzu44tQ3g0NGBkUMzPANzqzfsjm/YIR6NhBo3DAyso4fsabym1xKQ8hEjsCJlFD6uqPj4ftIu3UEMTUqyir+sT6bmCuTmR98M3lRIWJ2mmd4rHaNM8pPLcAMl46K/HK4ay+7/shrcDihHORMrw4bYzEmUBdOLQm+a/I4KaYZMkIDv7F7igIR/uIqoZZXsfjpbjJbf73C6ulxi0ht76jlp/gE6caKFyQLOaVM10NbCXMZ0ZRmtfPB83KP3JwuHx6K5Rbxb+jaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XNYHmR+D5kzBt0G4WurAr4s0W+rKvFGy/z35Cjzi0jc=;
 b=NQzCdhICx6jHTdDOS4U6BqMq1xgKLRboaqGPZd7aQEkxnksxO5PjvUbCMdPcjYIj5N3ZwVRjOTrmkwdNJ2ARdiqV7ALbukKm2UljIqKE4c00B+QjGFLMP7FE8LamY6uhbhVBdw4T8qlLjkjLLuXqlup9g9YWPZcywTgV5ShvE0k4NVuMyuphHzKSGDFn2UHb2Vl0IMJKjk3f4a9zpbPVKeZjUOaqqkrQKJSzxPo1mbveW4sauyZSA/2hUqEn7Fo+AptWfXe3XqDOGlAdgVxxgxyKTHNb2ATVjI+XzZl6xItVulj2Y5uzt8TaR1G3YM4HnHXREHSK7LISUyU0RJkvog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNYHmR+D5kzBt0G4WurAr4s0W+rKvFGy/z35Cjzi0jc=;
 b=A+u5b+PiiOif8B/fBbivQ9X/IgNEZfYCASmKRUjiJ9KUcIGtb0npnz75mdHoY+tk5YHkjjEC084pDLXMZUL0H9b4Lan2xVzVtZBFTGFuPaAvLjRSWRqN8KEc42bPRAZymGcUiQUE91vYxZa6YAi8uhDjY2EKeVnIs42MQBpa3Eo=
Received: from BN9PR03CA0078.namprd03.prod.outlook.com (2603:10b6:408:fc::23)
 by MN6PR12MB8469.namprd12.prod.outlook.com (2603:10b6:208:46e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.33; Mon, 2 Jun
 2025 20:57:26 +0000
Received: from BN1PEPF00004688.namprd05.prod.outlook.com
 (2603:10b6:408:fc:cafe::89) by BN9PR03CA0078.outlook.office365.com
 (2603:10b6:408:fc::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.29 via Frontend Transport; Mon,
 2 Jun 2025 20:57:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004688.mail.protection.outlook.com (10.167.243.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8792.29 via Frontend Transport; Mon, 2 Jun 2025 20:57:26 +0000
Received: from SCS-L-bcheatha.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 2 Jun
 2025 15:57:25 -0500
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>,
	<alison.schofield@intel.com>, <junhyeok.im@samsung.com>
Subject: [ndctl PATCH v2 4/7] cxl: Add inject-error command
Date: Mon, 2 Jun 2025 15:56:30 -0500
Message-ID: <20250602205633.212-5-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250602205633.212-1-Benjamin.Cheatham@amd.com>
References: <20250602205633.212-1-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004688:EE_|MN6PR12MB8469:EE_
X-MS-Office365-Filtering-Correlation-Id: a88d1483-2561-4399-6004-08dda21814a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mlL5KLFOJB2g4W/CLq7dnuUhpiSwKlh/Hp/ghZQoWEYzfPkOTrkzvt1vDwUl?=
 =?us-ascii?Q?McEJHJHwcASkffyR45QSUi7xcGfs0YM82rORSyAZYOuP1adeqwbw77Imukti?=
 =?us-ascii?Q?JHLbp2iJLdyW5z2zkpA7kY4n5Lpfu7GIdCPO6es3St8GfGNfK2yrxYB9LsXS?=
 =?us-ascii?Q?qmz/ghv4jGxET003kE96oS4wNZ5CSNBOJB6nIwIEh4hOaaWQorzJ+6BQWgFG?=
 =?us-ascii?Q?TFp+sacxjwbXn+/4oIW5DhOl+Xzt15B6Yxkdg0h5c6nOUuLitl2Ej9/JA0CJ?=
 =?us-ascii?Q?4vv8jSGZXJvUE+IN/q+rQtNIYFdQ2WaUgePjqBeZohsdALgVlojkIF9rbHjZ?=
 =?us-ascii?Q?ckUiMFJKBDLVGakLcT21kFkPLyvgBqpemIcyg35LoGlG8CdznzNakKGVVC4X?=
 =?us-ascii?Q?/SgFQ47bXKW1YVK0zdZV6m3A0wno4o7StmE0IeJ5bFTh9wlBgxTSwn+cGAJC?=
 =?us-ascii?Q?0Z+w++2ccFGctItxWeT73LERx5MsWydADR74Ao/+N2TNJNEmn9eXlZMgAJ4a?=
 =?us-ascii?Q?fnzvYgkJgML6GfYTEEanq0eUDKaXp6p90N5QdeYumzHYy2ExosMDkcECBrdz?=
 =?us-ascii?Q?awieDgkNBvSxR/BmZvG0fvueU8CyW5ofZOJWzpfQMSvRBNWKoRp2wX/nMVeH?=
 =?us-ascii?Q?15UwRJ3FUyJAgoixV35TTpOGocufZ2GV9WOgsGfpIrDU2gL1pAn5ZexxLd99?=
 =?us-ascii?Q?H7G8YRZeN4XUz9YcquaFjlXdEjB31ojs0ypMlxCN8Idsk+wKSPgDeVhPtcWc?=
 =?us-ascii?Q?gqUaKqFxzeQ2y4mFMCQfb0fRwFqjwgEfATWXV2lDQ1cDMc+nqsbUlus3aqk3?=
 =?us-ascii?Q?4fuNUTdWyu5mXyy8yVgFMg9y5WDavtb9zNeTbm1jMjT9HmV1HOHITs1kfK8j?=
 =?us-ascii?Q?ipyMLL6LsYmtX+tbPlwTrRJQEoP1++FjKSSny9sSP9edjGltSKbLbLj10GmC?=
 =?us-ascii?Q?ROVJeHOG30JrnY74rd96vhJSz7rbGZdDDSTfzbgt32UCPluQQZUniPovmn9/?=
 =?us-ascii?Q?Z3AydKPn1CPEvV2dqMo/GaVgFmmICy49kkGc3TDDlEYThW3+K/rOKaqG9PlJ?=
 =?us-ascii?Q?6PPcQTRUtCneSnt5SO7Sj1ue+rS6/S8ernPQSGzGnTvcz7PG/DlREhysb7jP?=
 =?us-ascii?Q?GKT9IoPS9+nWkr5MwcLSQHgatRiJ9/2g98m0OVzRLuphAHvduUPhMltD8oYg?=
 =?us-ascii?Q?ZYW42J6hTem7zccLYavu0WRUUEe+Xo8QiCVMGMoIQeac6iXp3oEZzhew4rWD?=
 =?us-ascii?Q?5p/nhRc4cUDuLH6waFnAr+fbbPxu5QudpxrdOijPQ3+EYTBJy8h1WF9+AHGs?=
 =?us-ascii?Q?lzrElISfXvDSl8wpgtp528EBPZu17PeztPue/0PFyCu4qttZ18BHk+DaXcjN?=
 =?us-ascii?Q?8KV1/InIZ17JPsfUKYiyMS0nz9YJEYK88gFqGWjMTrPEnoxceN3ErCeR/w/P?=
 =?us-ascii?Q?gDiNRTHJqW4p8f2eqbEJZ+EoQNo2VQocPDijjC1EjWnfjjqoBPuaaF4oekCE?=
 =?us-ascii?Q?fHOOI8fdgIPU5vMQ5YdJkjKAMMaNO5tg8JrQ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2025 20:57:26.5153
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a88d1483-2561-4399-6004-08dda21814a2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004688.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8469

Add the 'cxl-inject-error' command. This command will provide CXL
protocol error injection for CXL VH root ports and CXL RCH downstream
ports, as well as poison injection for CXL memory devices.

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/builtin.h      |   1 +
 cxl/cxl.c          |   1 +
 cxl/inject-error.c | 196 +++++++++++++++++++++++++++++++++++++++++++++
 cxl/meson.build    |   1 +
 4 files changed, 199 insertions(+)
 create mode 100644 cxl/inject-error.c

diff --git a/cxl/builtin.h b/cxl/builtin.h
index c483f30..e82fcb5 100644
--- a/cxl/builtin.h
+++ b/cxl/builtin.h
@@ -25,6 +25,7 @@ int cmd_create_region(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_enable_region(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_disable_region(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_destroy_region(int argc, const char **argv, struct cxl_ctx *ctx);
+int cmd_inject_error(int argc, const char **argv, struct cxl_ctx *ctx);
 #ifdef ENABLE_LIBTRACEFS
 int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx);
 #else
diff --git a/cxl/cxl.c b/cxl/cxl.c
index 1643667..a98bd6b 100644
--- a/cxl/cxl.c
+++ b/cxl/cxl.c
@@ -80,6 +80,7 @@ static struct cmd_struct commands[] = {
 	{ "disable-region", .c_fn = cmd_disable_region },
 	{ "destroy-region", .c_fn = cmd_destroy_region },
 	{ "monitor", .c_fn = cmd_monitor },
+	{ "inject-error", .c_fn = cmd_inject_error },
 };
 
 int main(int argc, const char **argv)
diff --git a/cxl/inject-error.c b/cxl/inject-error.c
new file mode 100644
index 0000000..bc46f82
--- /dev/null
+++ b/cxl/inject-error.c
@@ -0,0 +1,196 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2025 AMD. All rights reserved. */
+#include <util/parse-options.h>
+#include <cxl/libcxl.h>
+#include <cxl/filter.h>
+#include <util/log.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <errno.h>
+#include <limits.h>
+
+#define EINJ_TYPES_BUF_SIZE 512
+
+static bool debug;
+
+static struct inject_params {
+	const char *type;
+	const char *address;
+} inj_param;
+
+static const struct option inject_options[] = {
+	OPT_STRING('t', "type", &inj_param.type, "Error type",
+		   "Error type to inject into <device>"),
+	OPT_STRING('a', "address", &inj_param.address, "Address for poison injection",
+		   "Device physical address for poison injection in hex or decimal"),
+#ifdef ENABLE_DEBUG
+	OPT_BOOLEAN(0, "debug", &debug, "turn on debug output"),
+#endif
+	OPT_END(),
+};
+
+static struct log_ctx iel;
+
+static struct cxl_protocol_error *find_cxl_proto_err(struct cxl_ctx *ctx,
+						     const char *type)
+{
+	struct cxl_protocol_error *perror;
+
+	cxl_protocol_error_foreach(ctx, perror) {
+		if (strcmp(type, cxl_protocol_error_get_str(perror)) == 0)
+			return perror;
+	}
+
+	log_err(&iel, "Invalid CXL protocol error type: %s\n", type);
+	return NULL;
+}
+
+static struct cxl_dport *find_cxl_dport(struct cxl_ctx *ctx, const char *devname)
+{
+	struct cxl_port *port, *top;
+	struct cxl_dport *dport;
+	struct cxl_bus *bus;
+
+	cxl_bus_foreach(ctx, bus) {
+		top = cxl_bus_get_port(bus);
+
+		cxl_port_foreach_all(top, port)
+			cxl_dport_foreach(port, dport)
+				if (!strcmp(devname,
+					    cxl_dport_get_devname(dport)))
+					return dport;
+	}
+
+	log_err(&iel, "Downstream port \"%s\" not found\n", devname);
+	return NULL;
+}
+
+static struct cxl_memdev *find_cxl_memdev(struct cxl_ctx *ctx,
+					  const char *filter)
+{
+	struct cxl_memdev *memdev;
+
+	cxl_memdev_foreach(ctx, memdev) {
+		if (util_cxl_memdev_filter(memdev, filter, NULL))
+			return memdev;
+	}
+
+	log_err(&iel, "Memdev \"%s\" not found\n", filter);
+	return NULL;
+}
+
+static int inject_proto_err(struct cxl_ctx *ctx, const char *devname,
+			    struct cxl_protocol_error *perror)
+{
+	struct cxl_dport *dport;
+	int rc;
+
+	if (!devname) {
+		log_err(&iel, "No downstream port specified for injection\n");
+		return -EINVAL;
+	}
+
+	dport = find_cxl_dport(ctx, devname);
+	if (!dport)
+		return -ENODEV;
+
+	rc = cxl_dport_protocol_error_inject(dport,
+					     cxl_protocol_error_get_num(perror));
+	if (rc)
+		return rc;
+
+	printf("injected %s protocol error.\n",
+	       cxl_protocol_error_get_str(perror));
+	return 0;
+}
+
+static int poison_action(struct cxl_ctx *ctx, const char *filter,
+			 const char *addr)
+{
+	struct cxl_memdev *memdev;
+	size_t a;
+	int rc;
+
+	memdev = find_cxl_memdev(ctx, filter);
+	if (!memdev)
+		return -ENODEV;
+
+	if (!cxl_memdev_has_poison_injection(memdev)) {
+		log_err(&iel, "%s does not support error injection\n",
+			cxl_memdev_get_devname(memdev));
+		return -EINVAL;
+	}
+
+	if (!addr) {
+		log_err(&iel, "no address provided\n");
+		return -EINVAL;
+	}
+
+	a = strtoull(addr, NULL, 0);
+	if (a == ULLONG_MAX && errno == ERANGE) {
+		log_err(&iel, "invalid address %s", addr);
+		return -EINVAL;
+	}
+
+	rc = cxl_memdev_inject_poison(memdev, a);
+
+	if (rc)
+		log_err(&iel, "failed to inject poison at %s:%s: %s\n",
+			cxl_memdev_get_devname(memdev), addr, strerror(-rc));
+	else
+		printf("poison injected at %s:%s\n",
+		       cxl_memdev_get_devname(memdev), addr);
+
+	return rc;
+}
+
+static int inject_action(int argc, const char **argv, struct cxl_ctx *ctx,
+			 const struct option *options, const char *usage)
+{
+	struct cxl_protocol_error *perr;
+	const char * const u[] = {
+		usage,
+		NULL
+	};
+	int rc = -EINVAL;
+
+	log_init(&iel, "cxl inject-error", "CXL_INJECT_LOG");
+	argc = parse_options(argc, argv, options, u, 0);
+
+	if (debug) {
+		cxl_set_log_priority(ctx, LOG_DEBUG);
+		iel.log_priority = LOG_DEBUG;
+	} else {
+		iel.log_priority = LOG_INFO;
+	}
+
+	if (argc != 1) {
+		usage_with_options(u, options);
+		return rc;
+	}
+
+	if (strcmp(inj_param.type, "poison") == 0) {
+		rc = poison_action(ctx, argv[0], inj_param.address);
+		return rc;
+	}
+
+	perr = find_cxl_proto_err(ctx, inj_param.type);
+	if (perr) {
+		rc = inject_proto_err(ctx, argv[0], perr);
+		if (rc)
+			log_err(&iel, "Failed to inject error: %d\n", rc);
+	}
+
+	log_err(&iel, "Invalid error type %s", inj_param.type);
+	return rc;
+}
+
+int cmd_inject_error(int argc, const char **argv, struct cxl_ctx *ctx)
+{
+	int rc = inject_action(argc, argv, ctx, inject_options,
+			       "inject-error <device> [<options>]");
+
+	return rc ? EXIT_FAILURE : EXIT_SUCCESS;
+}
+
diff --git a/cxl/meson.build b/cxl/meson.build
index e4d1683..29918e4 100644
--- a/cxl/meson.build
+++ b/cxl/meson.build
@@ -7,6 +7,7 @@ cxl_src = [
   'memdev.c',
   'json.c',
   'filter.c',
+  'inject-error.c',
   '../daxctl/json.c',
   '../daxctl/filter.c',
 ]
-- 
2.34.1

