Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012071.outbound.protection.outlook.com [40.107.209.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4CC3A89B4
	for <nvdimm@lists.linux.dev>; Thu, 22 Jan 2026 20:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769115172; cv=fail; b=WPo7XqG+N7uOr3Nr5NJOFFRTfSlPU292/jGEExJTjf/bn3mZI1sCI4K1wU0p/H4ZOlkocxL8/p1IXK4mCJ5kIo7V/ceULCMNQL0K1RJmbYqAHXLfk9J1fJhX6LbFgX5kxbIi/ZoR+pcXRBrwx68udskWsEaoAl92KLB+Wa6bWYA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769115172; c=relaxed/simple;
	bh=OC2Av0mF1xU0mioBP+bnx5IoUROi3XtfLuYZYmQ9ies=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cq9M08i8EHC2erxrHYybfd4GJWZL1/QQQx7ae57bRbqy1whD4zxad+fFMspxo/O1IZyhzrLDunuTQVYjfoDErm+hyqjP2uaQI8+DYlOU+yJPVJw2gFmM0FERf49Kwb/WgLop6CSaTR+AdQVpoUjojIdVGZ3B/h4fY0MdzE2CKjI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MnlrrQnR; arc=fail smtp.client-ip=40.107.209.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MnlrrQnR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AfBwbQZZHxK4HEgPgxmnMhGONovX+7nZQ0tVi4l5mFBIUgbrCGVL8XALkvchiQYSC95wNEFruVZcMY6D3kNyw/QRE+KIVIoNfuXs8JDtHsiQsThQsYEVaEM2gu940o3LT3tcXNLBkHskt+re23Fm8Qweap0EvkQVTNxt0Zur7mgXYjOeotctqcgz4OJPvq+4XIkdkl0gX5qc0oi3o21lXlfsfI7jyGNqSZpP6vt8rUHL86pKkBP8rJJL+kilfTpEJDnw/6h4s8jJ6BnVkCSuVrmdULf4Xgh1s78Epk9DUV3woDoWPI4glbF10oc0sn7wNCJh8L09ZNlaRsmjfuSA5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sEFl1U5vYEWbW9plsdaCIsZO1s5V1S0ToI/oYOe8KNw=;
 b=XDq61SiJbhvpO84mFWPQGviF2kyvQ0i8GLJDW1ZYFQvMOqj8GfTpVXnBl/1vCl+9Hm7BUv0Z1k1KXednkByIfnX3H0qTSnP2BzcmaoEi8++37pcKFvwsk3gcvpuKpjAEDDpGTWPo0zOwGPl4yN5RxvxMYpwOTqbEZhzT0GeWhCX2CC7uBZ9Hw6ZpKL1rEL0hmtYG4m3ZDokB+ak9FRRCAfvG69DWA51IpNJHEnTRokXCQwgcNAYT/LHMEs9UdNkAf4mrnhYaoZesGfj1MvgsdI1407OfDJ7mtiL0CazOB3tInvKCz6ai7ZZhPog17CRfcMbLpEgdJtWQcDFkBSc3tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sEFl1U5vYEWbW9plsdaCIsZO1s5V1S0ToI/oYOe8KNw=;
 b=MnlrrQnR7GAA/1XaZl49oTOlXlXqcrW0gK3My6o7bCSSzt72L2KUZwV06V9ufPA3z3jJgWx810DUm6NgY60oSOTqlbHsdmNWfj8+pzgLmUDZtZ0O9qWsbSDkMAhEd9N090+qhB9cy/HbW+/CYjA0mq/2CmWhIKs9XHoVIMAz+KI=
Received: from BL1PR13CA0407.namprd13.prod.outlook.com (2603:10b6:208:2c2::22)
 by IA0PR12MB8352.namprd12.prod.outlook.com (2603:10b6:208:3dd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Thu, 22 Jan
 2026 20:52:42 +0000
Received: from BL02EPF00029929.namprd02.prod.outlook.com
 (2603:10b6:208:2c2:cafe::c8) by BL1PR13CA0407.outlook.office365.com
 (2603:10b6:208:2c2::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3 via Frontend Transport; Thu,
 22 Jan 2026 20:52:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF00029929.mail.protection.outlook.com (10.167.249.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 22 Jan 2026 20:52:40 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 22 Jan
 2026 14:37:37 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>
Subject: [PATCH 4/7] cxl: Add inject-error command
Date: Thu, 22 Jan 2026 14:37:25 -0600
Message-ID: <20260122203728.622-5-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00029929:EE_|IA0PR12MB8352:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b5dbc8b-fa5e-44e0-c7ec-08de59f82e97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6m1L8RYORU6MrLM5mpIsarKQ4wLFVF9e9+xZiJ+PBHdBRTFu7frlWC2TJdPj?=
 =?us-ascii?Q?PzWKjSKNFBHUYsZFtxG1klbSDzc0BxXS+RmLr+6KNPpB9YkWxFQvnwakW72N?=
 =?us-ascii?Q?o8pwm7FJ/8IfMUjX+wj47COmRbliStgWcbaqfx0Q8Mq6TqBO/u6q4Scykbhd?=
 =?us-ascii?Q?X6MDrSf5hRyuXoCEgK8J4QmCMQrSevk4IwQzXLCQCvseKuG3ssbNCqc06jEv?=
 =?us-ascii?Q?vXrbpMIERSOE2G5kOj8vF2nI7eT0cu0tGamImO46jEc4itNuTSy9oWAwJBXD?=
 =?us-ascii?Q?xfIDRTUK1XHaAGk8M9DY6il/f+mT4RrlU6JH6rtM8fuoaCo5RN9A+ZJ9Wbh/?=
 =?us-ascii?Q?7QjdZvACYY3hYx1mRhivukp+NfzFZqPteoNOI1HkX26AmmSYj0Pa2VhDkNrl?=
 =?us-ascii?Q?FGDLOuYbPDPvncyGzlczoxYOkhTPfIN9ibGtUhMrZ0TZhCTerT2613JLGwmZ?=
 =?us-ascii?Q?fsF+tTFhxJGuW+9GlD8NJvrvjDbvmIbDWpMUKG10XqBNsuK/5vIfEirXHgi7?=
 =?us-ascii?Q?yR+wi2Wq7bHN4bAUsq6RZjGqG3OzSoiSIFYcTJH0WWvlJm0G16VbsJN+Sv4j?=
 =?us-ascii?Q?PkPI0jWzBqQO0R9zlHiCq0IkDGhTBwVqSKruuWPyLiV9b5TT0Ub9w6D+hHGu?=
 =?us-ascii?Q?SfKVNzD+Yx3prxbF4/bsDaEOnmSd3s/rrqfm5/zW1iXZo/v8WB9+lNOTzQWR?=
 =?us-ascii?Q?NmAvEYYZatFHyGRVESgSpNI/tJpKKrDikYk42iUIHOWZJXZdtyCP99Y9Cvlp?=
 =?us-ascii?Q?qpBX6lOedgrdI+YcDPfd+BLbooJE6QrwrF7u+Od+o+qXswgm02KjFRlfoZ+0?=
 =?us-ascii?Q?IjuN8dmM875BjU/ZLtN0Ue1s+cPzwAN+K4F2NJ5GGsBoo5BGeYSzp/P+mzVy?=
 =?us-ascii?Q?qe+KWcEdHdasT/lhr+UXQrUwMnQzhpsZri0xwVncZjPP3iEX8ozCwpcnRqXZ?=
 =?us-ascii?Q?Jnp3M8QnQ+Ijk0myAXeCFhUsrj9QQUGL8CV1g3mujngxRvjsrENZVSMIVmt2?=
 =?us-ascii?Q?Q1EfuAv8bBrM0AZbYjYFza/dyjGbQv43Rb/lgtqt/zObl847IKtoJukzTgTR?=
 =?us-ascii?Q?6Vq0eWq+BhS5QOGLV1yKXzL6+1897REOgZgN99lF4dk5NZ0N2RWUrc/FKRwE?=
 =?us-ascii?Q?I5iaQxV7f6Z6XDXSU1liJy7DS4hYnz9pCHbKZbQXbFhroNXANevH28wQmupQ?=
 =?us-ascii?Q?zqERozlG/q6X1+BAa7snM9i9LjI5+nm3/pW8CNi8bgAZFWvw7hPmRX2p9gv5?=
 =?us-ascii?Q?oWAQCsWFUWfKDzIJkWoK+DPKsci/69gFLN/cZh9Sm/ozq0u9Ey4+HAa1buRR?=
 =?us-ascii?Q?YhDnMVW+3B9Xl2xdApQiVQErAr+PJrJ2wWt8f6u7ulbqB34D4OePk2oe02hv?=
 =?us-ascii?Q?dXxfRiIeqV5TlV2siS/fLZLSc3C2+YFMBJuyt3qTW3klYT7whteSq45BBV/G?=
 =?us-ascii?Q?e6hhF4Vu37QBfNmuqCeQsZNolU+iIG6ReS6fYQjj+YamcaNtSs4YgOPOX76e?=
 =?us-ascii?Q?m39PMXtuyz1pJbAonNhOZIoFeP0nfmDjrWkpqThdfePFp1WQkf2l6cV+geIi?=
 =?us-ascii?Q?5uvt/CIcz5wNy+lA/DMqqnnDiOP+LtPrOEB3WVqKpi8nI7TrhQFgDNo/qmAi?=
 =?us-ascii?Q?geH0dRoFX+4C2DFqwUBpE6sprSj+bXSW84vf6YPTKknRx5zPO3oS0R+Foi1U?=
 =?us-ascii?Q?FPzKkA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 20:52:40.1294
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b5dbc8b-fa5e-44e0-c7ec-08de59f82e97
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00029929.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8352

Add the 'cxl-inject-error' command. This command will provide CXL
protocol error injection for CXL VH root ports and CXL RCH downstream
ports, as well as poison injection for CXL memory devices.

Add util_cxl_dport_filter() to find downstream ports by device name.

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/builtin.h      |   1 +
 cxl/cxl.c          |   1 +
 cxl/filter.c       |  26 +++++++
 cxl/filter.h       |   2 +
 cxl/inject-error.c | 188 +++++++++++++++++++++++++++++++++++++++++++++
 cxl/meson.build    |   1 +
 6 files changed, 219 insertions(+)
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
diff --git a/cxl/filter.c b/cxl/filter.c
index b135c04..8c7dc6e 100644
--- a/cxl/filter.c
+++ b/cxl/filter.c
@@ -171,6 +171,32 @@ util_cxl_endpoint_filter_by_port(struct cxl_endpoint *endpoint,
 	return NULL;
 }
 
+struct cxl_dport *util_cxl_dport_filter(struct cxl_dport *dport,
+					const char *__ident)
+{
+
+	char *ident, *save;
+	const char *arg;
+
+	if (!__ident)
+		return dport;
+
+	ident = strdup(__ident);
+	if (!ident)
+		return NULL;
+
+	for (arg = strtok_r(ident, which_sep(__ident), &save); arg;
+	     arg = strtok_r(NULL, which_sep(__ident), &save)) {
+		if (strcmp(arg, cxl_dport_get_devname(dport)) == 0)
+			break;
+	}
+
+	free(ident);
+	if (arg)
+		return dport;
+	return NULL;
+}
+
 static struct cxl_decoder *
 util_cxl_decoder_filter_by_port(struct cxl_decoder *decoder, const char *ident,
 				enum cxl_port_filter_mode mode)
diff --git a/cxl/filter.h b/cxl/filter.h
index 956a46e..70463c4 100644
--- a/cxl/filter.h
+++ b/cxl/filter.h
@@ -55,6 +55,8 @@ enum cxl_port_filter_mode {
 
 struct cxl_port *util_cxl_port_filter(struct cxl_port *port, const char *ident,
 				      enum cxl_port_filter_mode mode);
+struct cxl_dport *util_cxl_dport_filter(struct cxl_dport *dport,
+					const char *__ident);
 struct cxl_bus *util_cxl_bus_filter(struct cxl_bus *bus, const char *__ident);
 struct cxl_endpoint *util_cxl_endpoint_filter(struct cxl_endpoint *endpoint,
 					      const char *__ident);
diff --git a/cxl/inject-error.c b/cxl/inject-error.c
new file mode 100644
index 0000000..0ca2e6b
--- /dev/null
+++ b/cxl/inject-error.c
@@ -0,0 +1,188 @@
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
+	struct cxl_dport *dport;
+	struct cxl_port *port;
+	struct cxl_bus *bus;
+
+	cxl_bus_foreach(ctx, bus)
+		cxl_port_foreach_all(cxl_bus_get_port(bus), port)
+			cxl_dport_foreach(port, dport)
+				if (util_cxl_dport_filter(dport, devname))
+					return dport;
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
+	log_info(&iel, "injected %s protocol error.\n",
+		 cxl_protocol_error_get_str(perror));
+	return 0;
+}
+
+static int poison_action(struct cxl_ctx *ctx, const char *filter,
+			 const char *addr_str)
+{
+	struct cxl_memdev *memdev;
+	unsigned long long addr;
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
+	if (!addr_str) {
+		log_err(&iel, "no address provided\n");
+		return -EINVAL;
+	}
+
+	errno = 0;
+	addr = strtoull(addr_str, NULL, 0);
+	if (addr == ULLONG_MAX && errno == ERANGE) {
+		log_err(&iel, "invalid address %s", addr_str);
+		return -EINVAL;
+	}
+
+	rc = cxl_memdev_inject_poison(memdev, addr);
+	if (rc)
+		log_err(&iel, "failed to inject poison at %s:%s: %s\n",
+			cxl_memdev_get_devname(memdev), addr_str, strerror(-rc));
+	else
+		log_info(&iel, "poison injected at %s:%s\n",
+			 cxl_memdev_get_devname(memdev), addr_str);
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
+	if (argc != 1 || inj_param.type == NULL) {
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
+	return rc;
+}
+
+int cmd_inject_error(int argc, const char **argv, struct cxl_ctx *ctx)
+{
+	int rc = inject_action(argc, argv, ctx, inject_options,
+			       "inject-error <device> -t <type> [<options>]");
+
+	return rc ? EXIT_FAILURE : EXIT_SUCCESS;
+}
diff --git a/cxl/meson.build b/cxl/meson.build
index b9924ae..92031b5 100644
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
2.52.0

