Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010016.outbound.protection.outlook.com [52.101.201.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2942C242D79
	for <nvdimm@lists.linux.dev>; Tue,  9 Dec 2025 17:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765300511; cv=fail; b=t27s+MnslWTT4ikoHitmNkyNO0le2k6yr3TRR/xuEDYsJD+ymW/BlmHim/Yjmn9y/LhyTlK92a6vWleABTgQ5pI2dlTJTcnuoMQxOYsvWYC0BCH35hUPO0mtGUI8g3QYNrf75ypJN5K6/CEmzf0Cpg3K+VMrIWAmNddQeHOSBMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765300511; c=relaxed/simple;
	bh=2D7hR/AUagxqqFo9qAVAO82t8kZ21wErKAWffkSMhNM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RorZRL8UU+cwsZUjSeT6GWcRIdhyH/Wdfa5DM8ruvoBrTuC3IF2dg/L31Msvkw2LhzKMuPRh3NGH90FjM8j1uGUKql0HVtq57F3OFbQ/DFVJbXkMfGBxh7eUGP+1X05QxbS72UJZicwTC5c9p3NZLjZJ7wWv87KBT0lnOl35sA8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=isUpGugl; arc=fail smtp.client-ip=52.101.201.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="isUpGugl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YFb+HI2roCapk1pQ2b04m1IJWhLmJgBoAQasKkuiVsD12rlojfZwY2hz50UtE6gfoZRklwfIsiZnC8mYA8rjYi8+COIYGt8+DzzRbm4SOzAgKpwpKfzmvfCZoxfwLEA2bI88RYgZbC1iV9RyFg5nNk9A/FRnNalEnkwIJOXxeOn0L6cG+O+QEosdyStCkQzrdFogkDEmA00/OLQc4TQaskOlnQrVRYWXSvYmxNZQnbPDrNV9WJngWkm5Jpy5U6BWxDLCYx0Ozjo+tN/R+vhqSErL0PhRM5ojf6k78j6XLrksgSOLMHkskIk9xjbrUIOb1sA8L2/YJ/qrsAy8ICNyng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xa9qsvu2pvhT5Ncn5eIKjjJQn8RchXHsuSf4sh0znNk=;
 b=WIrCx5CDfO6YgheCeR1QR6EbBI2WBEGEy1hcbn+RF+iB6FnWjWhi6TCApzyG24cRpueBPZ/YIMRQHH25NufXud0VNW/r2f3LqigfiHI8N+PwhxlzJK50JomuYBMU1HjRP73LMNKJ0K9qdDiOGPMBSCnysufRlJzjTLCmCcpgyHjq4P4uL9B4hdcqsTXWQ2pVYGfC8EzmAYKWUs/DvI12+xN889Kq3BocO97Vw5Ip9QCjAm02HuvOlhRSud2wbyHxiSwM35DhWw5lP54DfwVU9Yb7bxe2M/PlmH1/V94nL/ShWOQ4VlpPMKCBUoA2qxF/azVosYrVZkrwKJMd+/T69A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xa9qsvu2pvhT5Ncn5eIKjjJQn8RchXHsuSf4sh0znNk=;
 b=isUpGuglu0sCW6IUxvOnPQmBym69jhpwmpNg0g7MBE9jk46wpaEpgXVqHOvDdGHNLfMXzNJUbrs8yrNDuXap9r7RI49AnJKWDgNxX94OE1/i4fygB7otD3NARxWuw/uaeIedULKP6KH6xm9121+HVHB6hIjnnD9WfM4cN9lI0Oo=
Received: from SJ0PR03CA0082.namprd03.prod.outlook.com (2603:10b6:a03:331::27)
 by PH8PR12MB6961.namprd12.prod.outlook.com (2603:10b6:510:1bc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Tue, 9 Dec
 2025 17:15:04 +0000
Received: from CO1PEPF000042AB.namprd03.prod.outlook.com
 (2603:10b6:a03:331:cafe::a9) by SJ0PR03CA0082.outlook.office365.com
 (2603:10b6:a03:331::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.14 via Frontend Transport; Tue,
 9 Dec 2025 17:14:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000042AB.mail.protection.outlook.com (10.167.243.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Tue, 9 Dec 2025 17:15:04 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 9 Dec
 2025 11:15:03 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>, <benjamin.cheatham@amd.com>
Subject: [PATCH v4 4/7] cxl: Add inject-error command
Date: Tue, 9 Dec 2025 11:14:01 -0600
Message-ID: <20251209171404.64412-5-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AB:EE_|PH8PR12MB6961:EE_
X-MS-Office365-Filtering-Correlation-Id: d4b550fb-cb42-436d-2b9f-08de37467e89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JqGiuo8W70u1/JRqCpG8HMRkXVf2OtY2h6NBIzamhmgVG1oHjBcLVW2JzYwp?=
 =?us-ascii?Q?F/zajMfhVddYSC2tGsnc5SnlLVL6Ux7hi+opsf92yNydNvvJ7ECgF9woT6PQ?=
 =?us-ascii?Q?ZDKEfS/K9hQxHQZecHo5h2RPiFmSttDUsmQdGO+UZj2OJE+tsgzFjtvxSJFB?=
 =?us-ascii?Q?4TkL8yqeSIjsC5aUFFfrrBrzK5B6LyKqOGCEHOrPfa/x9cHUCnQG8mS4xJHb?=
 =?us-ascii?Q?eHLPvabKGiRCDW63jlpiU0TXg8a2tmWAcITdEK6lUWcnzx1W25aoU1n2kL93?=
 =?us-ascii?Q?tIYiyIOKgOLwnVQUwO+h/dD3bUtGJz8fItuskpk4I+yk2TBp2/jdYeVFSdze?=
 =?us-ascii?Q?0P19hU22VyJdJgXvzQBtdLnooO+VmR/Elur+Gcp9y/EIZPD+cLQfflmPD/ki?=
 =?us-ascii?Q?NxPfQYkJW+6zPHAIR9Ob6HZlQb4qDUz9kQY0WZnfRG2gdaU1GfAijqtEGkZ7?=
 =?us-ascii?Q?ypnRjrd2a+eWm5wVp51+GWCDuis+W7G/CWRTjN6JuoryAB4olQnh+RRVUu5E?=
 =?us-ascii?Q?y9a/3hrAkfPhuw3r6QlHAiAjk1N2o6IaU0uJOPlP3Mkf3tRfpldwnQoINz5h?=
 =?us-ascii?Q?Bpc/b+m5Y+F5zasLLCyo9shwSl3KIwPhrrFDeXuo/+dft9BtFLw0tFtbljio?=
 =?us-ascii?Q?Y17BxYGJJC2NT7hR/ipn4R46ApCzTI4FEw3sGDGQyfX8PQ7/jOUhK+KM5r4k?=
 =?us-ascii?Q?SySnltcx04CmHWEDApIMyLTkOIt27AWug7YFexkkV1P3iGRRaqNCxox1ox+Q?=
 =?us-ascii?Q?l28GtBcbhDjTtYY1tpe9Qvnl3OHoUKkBQv6sPHX382mgXJwlZ6gSSCbwpOhh?=
 =?us-ascii?Q?b2RJ1JEyWaN17I+OrvszWh+xhRjTTUfdjLsZnKMWtYiNEpJKr6ZARK5Yh+f7?=
 =?us-ascii?Q?TApFzRy8zyg9Ew/MBocfn1e/7WVfFMr7+TmKVRh5c/FS9OYGW69DVJF9L3u5?=
 =?us-ascii?Q?JqnUI7/P2/B5Jzw8Xhm2uaRZ6a6uwI1ZDlsZUfDTIEdD+3OdQ7g+WQZm41Vh?=
 =?us-ascii?Q?6eeOK61O0yI1lkiGEdaxSKu53eVtWfpX3gJn1XZ/KlOkEaMGMgj2lbKiDaKg?=
 =?us-ascii?Q?EQqWHO4C46d3BLv328v1FRyjKCpcYMsHNOR+nuLDrVpjJxOSE7CInDKXuRLJ?=
 =?us-ascii?Q?bm+SYnzoejNvijJozNkstefn6AdoMinlST/Icp0bXRBo4Siiry8zdM5xlLe4?=
 =?us-ascii?Q?cBaH03Vii8HXqNE8hU1ebSg+ApfQ9Bh3dcAkXciNJbVkptoS37CCL+7rBdXP?=
 =?us-ascii?Q?M0CcYpKWJk0xBF4Fg9q3sp472kZD1wQoHNwrF8cU+zfzrzgOP51TMSxQCtnM?=
 =?us-ascii?Q?ErdljunwYHqQCgf4MWCiyZm+0PrLfuVihnhwtJ92Emiw6JgwC0zyMm1WdWer?=
 =?us-ascii?Q?6xSUZLYR1tfvKWZEwgedB0XVfj5cuFopwdaPeNcgS/vQjOg3MggIrG4F/DLe?=
 =?us-ascii?Q?9Fs6Bia7xJu1WZhT74ETIXfy3GDr+zmNxCd/ZbOS/UXJCty/5HZRPbEBJMSO?=
 =?us-ascii?Q?hyCeLfflQ8OLNgEsTIxCr2f6FasfPuc1Xc9EDprtkdjRulUPMGiK/bf7rWh8?=
 =?us-ascii?Q?oljfFIKj9JliBlvL/1U=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 17:15:04.2487
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d4b550fb-cb42-436d-2b9f-08de37467e89
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042AB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6961

Add the 'cxl-inject-error' command. This command will provide CXL
protocol error injection for CXL VH root ports and CXL RCH downstream
ports, as well as poison injection for CXL memory devices.

Add util_cxl_dport_filter() to find downstream ports by either dport id
or device name.

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
2.51.1

