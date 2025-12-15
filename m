Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010057.outbound.protection.outlook.com [40.93.198.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE5B2236F2
	for <nvdimm@lists.linux.dev>; Mon, 15 Dec 2025 21:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765834651; cv=fail; b=WNRr9IzeAupKB+jfYtlmXaFi/EXisTG5BfdAGFA6vfKaqCLVmgkEl+o7Ecf+eXFSyLWC88H0aRTYQmI2jpnpGYjEObbmcbZ8lwn4bmwsrhZueAUVVh9XxM/TG50TSxIgX0BIaj9RZga6cS9w07++BMXsWGmUr7OmmHPrS09Iszs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765834651; c=relaxed/simple;
	bh=hnyOTRwjO/m+Zp2TB44qzZc5VmbvukAze0G86CTyzpU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m8NKAbfl/oiNGM3swIZQjYRAHqkvyYCfsExdNowFjpjONwQd5ghM/l8thOTGN5NIC36F/B7dRs99izUNg2ZhMQvh/d9G9LWBD8/SqsvV46yP/OYem+DRXek7KWSe4bvejFyReWWI8cdaZYR4o8ucowxJOa15JijS0eI7DHSkZkc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=I6LaaFsI; arc=fail smtp.client-ip=40.93.198.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="I6LaaFsI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lHkL1uzvD847bSFgTkCmz+5Ya9Unsgsqynmr1gdONdKaP84vASzC+fUg/B0gxPxSpDc4/etNEds3eo7dYmh3OdEeRKKoVJLClzF2gXdv5Xd9pG2NkK2xMjL2sg4gMFJ2NKAJJYNaHHQa7DEKF8EU7KxlOpLtNDbRs6EWDNMXFhsoNUossmZE1M2WvWoV2e6ZgYLgIQyOnu6Hx8nQ4ROfsH8ey0uw/KBGlaDBH7xoFrvh7snwysl43nWupewt1lVtTV+/FAn/9bOuWAU9lisLnCIVEECm9g8DdbcDixyazHRCq5l6C0WTrbqZ0hER5hiUDiNw2eJO9TGNBPaXtYtb3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hNeI/yq4VJ5wfDepC7HvkJa2riByAE7tFtgCcaRTqAE=;
 b=l+BApWB8Myo8NTGbHICXyq8q58C2EeilEzAaUxUdJbcdyOlJuCSHeLRBtDtJb9GA9p9e6Igdq0gZO2mceVIcIQmvsZP3W3NZlYfn1tJxDc5pBx9VO9eCntjWgVsJ1UQanJKr3pMrCUae/P8OfBx2OYEuUUQP9jeo9xCxti5op3vkX9MNC+hiMeZvh8Oee8jpP1fSkes/XDd1apP7u8L8aBVV4COJCnmXafWNb35R23vd27j04gJzDRQkoLBHjk5s8ZtgR733IL4BNGk7uapXRz7YQNYmFUMGhwsfzQI7wYIxxmZ2OH6FfR67qvscabJGHSJ67LZlTp2FCoJOL0HIZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hNeI/yq4VJ5wfDepC7HvkJa2riByAE7tFtgCcaRTqAE=;
 b=I6LaaFsIUlYZkkI71zEdcbm9ZrF25oRbNCRsq/Ow+l9UDGpN970RCbBebiU1FXnHac+dRlecaY2Yq5xWWNocFjJZnZLJI9ULEwZOPS8x9kW6Dr9MOrFk4XRGzbeDe0s6VCR15JguytMD1a4E6WbgsfLo6zCE5EQEsmUll7J5qPg=
Received: from BY5PR13CA0001.namprd13.prod.outlook.com (2603:10b6:a03:180::14)
 by DS0PR12MB9423.namprd12.prod.outlook.com (2603:10b6:8:192::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 21:37:21 +0000
Received: from MWH0EPF000971E2.namprd02.prod.outlook.com
 (2603:10b6:a03:180:cafe::a2) by BY5PR13CA0001.outlook.office365.com
 (2603:10b6:a03:180::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6 via Frontend Transport; Mon,
 15 Dec 2025 21:37:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E2.mail.protection.outlook.com (10.167.243.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.4 via Frontend Transport; Mon, 15 Dec 2025 21:37:20 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Dec
 2025 15:37:19 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>, <benjamin.cheatham@amd.com>
Subject: [PATCH v5 4/7] cxl: Add inject-error command
Date: Mon, 15 Dec 2025 15:36:27 -0600
Message-ID: <20251215213630.8983-5-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E2:EE_|DS0PR12MB9423:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d56106b-2c32-4150-7872-08de3c222088
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9L49VHmfwFQKqY4LohztuzDHjpmKQc1x+9xXxIgth4GmrVs2R/q89dlzxeZ3?=
 =?us-ascii?Q?EEerJMG3r18Em0y9dPWhcCGGy4TyilW9yTfWh51eFC7VTZZGe0BLu0Y973Or?=
 =?us-ascii?Q?8lMtQ298V0dhgOCeSjSwAsl3WkHCaN0dzuNwledOv48W8yC2m4w+e1uH34fa?=
 =?us-ascii?Q?91DLRJM7gpJWjpTO02gRK8oejEPWvgfJOVMp+UjCMkkH9C4i9EftgOvI+bDN?=
 =?us-ascii?Q?q62JYDh3wXscbwLKmO823NnzPJ1kmEF4U2D2OeLAH0bVytO2RJ8I7CRVEgJF?=
 =?us-ascii?Q?eCeJcmTGEjvfq7Y1ukv6+SpxY5Vup8yPo/wEwIPWqvdYKbk6qU9Pl64keSRA?=
 =?us-ascii?Q?wSgkSBnu0Ljhk7i64JP8vLQoDscAePkE0/km0CGU9L1GhLn2k0qHweOJ7bXb?=
 =?us-ascii?Q?sME0R18ULYffcfGzEnnqs5kTvjEBEHP93pF1OmchxdrljhThBnMMT6K9jZzn?=
 =?us-ascii?Q?H0k7DV2EfDlluPrVpFVbp0k72kVMnpOhvICyzhiOhhgfHNavSbCj3TkRdsBB?=
 =?us-ascii?Q?c1OkPh6Y11K6og2iAqFdS5k6bq2g9OG3QljGPsS1TsrUH0FlegYQI4nYgKlN?=
 =?us-ascii?Q?WzEji9r3PsGasOSkzT9XLW4LSqlRVzojsdoggug7CQ/yRdbZFaZeiZDr1F/o?=
 =?us-ascii?Q?5ILKlqnraxXazwCzDI/OPQzhz4NSkodKYDTRKopfw+z+RebuMENu57yuWPXN?=
 =?us-ascii?Q?63eAkh3hVXI+t+EkmsPBtgJmtZ8zVb63w4zNINJVhoYGeWu2JIuukk1p/jrN?=
 =?us-ascii?Q?hc8HTb2d10OytVjL7zsOT9C+x7YfZ3+V9ATg1XMh6akiP7rkgGRGwhNdH43g?=
 =?us-ascii?Q?3n5umLldav4DzKrPptJUq1y5adsHRXM42iJrg0IdeqbttZ8NYonNHhH/u+Ew?=
 =?us-ascii?Q?XlyLnRBxTwU/UsKrAlfJakcEfejwBBqQ7T7RMZbWPCU61TO8HAWvG022UwNI?=
 =?us-ascii?Q?EwEzB7e1t3ZGGHEQ3xFbIE6zYTctxVGkwYH7lnMMkoKL68YSycqtM2ApEh7c?=
 =?us-ascii?Q?VI84Ey8cjxiukwoaZ6MtLJJGe+9T4KXEwXsf7KmaOa3apnawd3EIcj4pJcs6?=
 =?us-ascii?Q?qkUhymBa44IAXwX8dickx9q6kxvEb+aUmUVSwPhamkUtTsdRLW+Mt5Z8fp/P?=
 =?us-ascii?Q?2ACq7sNuH7Ce2qW/yndgPSYNr/WGiWkoGBRdoQnnyQlXWum/GkaHUEXWXEVa?=
 =?us-ascii?Q?ahstQwkHDUfPnAzZj11yoIsXzEek/cTMgi9FKb8J6TLuH5e0YkL3p+Cyzc6X?=
 =?us-ascii?Q?n+RpbPa97RtdMdZw31ospnvma0kGwaDVu0JrSDT1TE8i9H+zihRNAjQB3oKH?=
 =?us-ascii?Q?Tjms9ChcYFa6Fx6Be4WqZbW1eyAlmm6zmtMaNQcDwrLfyYaGVQZQ8YmuUvKW?=
 =?us-ascii?Q?MgwlY+YzRXNeZ6WE6qyDFi4ymgXrloITWXUdDWJyNoTmJiJGBrqZVMYzRMwD?=
 =?us-ascii?Q?U0VVPI0MPa60rP4JU4W1xG4it7Re1xMolGC9/5/5lWcrl2XKs4Chrk+OeJil?=
 =?us-ascii?Q?s5BmsDnkPxZZ1OSv0sz3B1CvM4fnpXOhlFAndrj6sfNQuh22zkWiwHUIkdUB?=
 =?us-ascii?Q?bx1WjGj9zrXO8Jx3u/8=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 21:37:20.4222
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d56106b-2c32-4150-7872-08de3c222088
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9423

Add the 'cxl-inject-error' command. This command will provide CXL
protocol error injection for CXL VH root ports and CXL RCH downstream
ports, as well as poison injection for CXL memory devices.

Add util_cxl_dport_filter() to find downstream ports by either dport id
or device name.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/builtin.h      |   1 +
 cxl/cxl.c          |   1 +
 cxl/filter.c       |  26 +++++++
 cxl/filter.h       |   2 +
 cxl/inject-error.c | 189 +++++++++++++++++++++++++++++++++++++++++++++
 cxl/meson.build    |   1 +
 6 files changed, 220 insertions(+)
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
index 0000000..c0a9eeb
--- /dev/null
+++ b/cxl/inject-error.c
@@ -0,0 +1,189 @@
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
+	size_t addr;
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

