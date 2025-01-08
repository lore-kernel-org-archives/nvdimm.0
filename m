Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2085.outbound.protection.outlook.com [40.107.236.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D3118A6A9
	for <nvdimm@lists.linux.dev>; Wed,  8 Jan 2025 21:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736373487; cv=fail; b=Jb0a0lO2FKAHZYM/YAps5LIouaZT1KcHJY3hXSuoRXRjdYaqKlNJfuYTRrLVquux9XQsYyDsLnd6X6ld0g1YdT9mygcS829uf7TTUypDmDWKkfnW2GB+AqxrsvLyUWgQEjjSbf9P5saD2LwCKbe8mPkk4706aYeSutWkpMGLLXM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736373487; c=relaxed/simple;
	bh=zOYTIe3SV57AGvXSCRX7fAoiElZ6NX0klFm2ZNThQHE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HrikslWPituCxKVrE0V3ppCBBGnKIwdAer5hESH8PA4Hzy++AO7A/MvY0UAGuudV6kdJOsfQ2cruBdVhgo/A9vGqOvW8elqV1QD5XELtu9NDSoa6KmvwTLjJdAIrbBGnIIxFgJYYO/XOoVrSgc7IikXxiytxxr9AqyqDhH48Rhc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=M3cAnAXI; arc=fail smtp.client-ip=40.107.236.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="M3cAnAXI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OPsDaKB3Jw4UPF4H7KdiuVE+eb98Ib6SUcF3LpHHIxKS2gNf/wvow18IQsI0CY+RLKopTRKFQI9Mx/6H+48LGLCfSFYqupJH0BhDJBsw71EjsBX3EGPXxzNyTOofq+7ApQPMTyOhaKuj555tNIt7/pK5yKvqWB5T52XJlWboMtX5jJYKbY4eD1LRHJNVZf5TGiU+XImRwXyOg/ToNTHKPd1OeGm1NPin5g5sXPmlQXrTQxiWXjR1y/W+hFng9boxFSjAiAIJA78nTCTTS4bCtgJIVEjAsudfzjQAijCMuahTlc4squb5wK9EEVZSoVpyno+ANagese/moN+44JjGuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ix9n0FNXnxWEHujGOqPl87shfTCX0+AhrTf/2DU18uM=;
 b=ikmyI3cXKtDbV/VF8/82T0A+kWTUUEXEZ2OKIeCbMU+tv9rqI+cKqGq0sseFkIJ6Lu3ErE7VSi6MG4p+aWyL7WtkKcDrD1ureIfZSc0Gpwdhe5kpVrgVsKz7u+Kfcaflu0dh6FZ6ZxLh9yIqTXVNLR9Z8CpfXZPfN2TZQ+uC8ZkZjquhLMJrc5kMhW9XitxOSGf/4RdkLzNIMi+rsR6Wu0YmWDBjQ3Yo3PcQzMeCPvWiPLVdN0i1G3RLxvxbSgEHAwPQ8yBeyyG/DX6cdZbybZZbCcoFaeKX55c2WcYnj6vjb1yqk8Nrfl4Mg2YP+Jwh7h/gtDnhZGOnmo4vdW2o7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ix9n0FNXnxWEHujGOqPl87shfTCX0+AhrTf/2DU18uM=;
 b=M3cAnAXIMNKjonKar6rmHjCG/rHqgCTLjp/xYImUK+g79wAkBn4t/vRXkcY7jBNpPeXzFPUlE678fn5X9nXZlOq3zCeFz84E88WOXamS0nWCGjyAPhMeAm8mAHccq0xAHiHgVlDnt6/FiTwPRezStB6NV/fOqR1M4BybU8gEovQ=
Received: from PH0P220CA0026.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:d3::7) by
 IA0PR12MB7556.namprd12.prod.outlook.com (2603:10b6:208:43c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.11; Wed, 8 Jan
 2025 21:57:59 +0000
Received: from SN1PEPF0002BA52.namprd03.prod.outlook.com
 (2603:10b6:510:d3:cafe::aa) by PH0P220CA0026.outlook.office365.com
 (2603:10b6:510:d3::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8335.11 via Frontend Transport; Wed,
 8 Jan 2025 21:57:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA52.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8335.7 via Frontend Transport; Wed, 8 Jan 2025 21:57:59 +0000
Received: from bcheatha-HP-EliteBook-845-G8-Notebook-PC.amd.com
 (10.180.168.240) by SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 8 Jan 2025 15:57:57 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, Ben Cheatham <Benjamin.Cheatham@amd.com>
Subject: [RFC ndctl PATCH] cxl: Add inject-error command
Date: Wed, 8 Jan 2025 15:57:49 -0600
Message-ID: <20250108215749.181852-1-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA52:EE_|IA0PR12MB7556:EE_
X-MS-Office365-Filtering-Correlation-Id: b2a448ce-d0c3-4422-ba8a-08dd302f83fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gLcsvjGqxBvjlsK5Kd1NX9/bEzFltcMveRuafBAeSWXw6HYruSlZ3ZTZGBIx?=
 =?us-ascii?Q?jT/zRcAcCT3Hg5a5tF+li1/ODR1xm96nKhV8CinbpB5XmPJAPsADIWgKA1Lc?=
 =?us-ascii?Q?NLS0+NRt0E0OSJRzGxJzgi4l5PWoTWFDu6fVziegiCDhZfN90xAlPGaTf5UD?=
 =?us-ascii?Q?9wzRqRsaamWCuvvIIzOE93ZWLvJSsF4Vtz+fbP1BStXSdw120KZ6fT0dCcTG?=
 =?us-ascii?Q?sAMCXjJ8pTQFuBiY+gM6X9Lb3d7m9nkPdDWIjfA9pwXx0AU7wOU4g3Jzwobe?=
 =?us-ascii?Q?6S08rgF7e4ZpzD1kd3qcCL4qdrxwOZgMdMb3950m3Pp0wiioXq0TXed4JMFp?=
 =?us-ascii?Q?3+BVIaF6+jL1fbhBkuguCCwT0Bc8WUx2nWkSjCgG8UIky+F9nMzbDUWvDzcB?=
 =?us-ascii?Q?dJvUiIvZUeg6DkbVRfu/sPPswNaR9fiwxys9/tr6pdDueGJDy9gZqpVvDNoU?=
 =?us-ascii?Q?0tObOwR3/yoCv9RNIko7s/zBBNWa6ugVpqUdXS/fyd3+EsJljL+TpjsdzqTO?=
 =?us-ascii?Q?ryaX692GhpC6eI/GOU/BKaCsimH/B0Gcjft+CQsmAU1X2iD/6w7SB2iL/4+U?=
 =?us-ascii?Q?bCI68D/tCF/SY4hL+g2e+nWmsPtqX/h6kry4Uq5R2TMuPLtzdUGQHgO7+VFO?=
 =?us-ascii?Q?CzVQqIrhY5oX2WVEowuX1F2wkYIx9uKe3Up6aBb/iiJFEziLuT8GOaclTpPd?=
 =?us-ascii?Q?EurnTUhUW8GOOtPwpYX6Q1sfH6DwmP0K4NNjjzPpv9fl6ui5djrKF7Rszebc?=
 =?us-ascii?Q?y0q+uaArDL44yI+BwWeYHB17dnlWH6kI3krOTPOTi+tZ/f6r70arTuTkydXX?=
 =?us-ascii?Q?wQOTpDDGX4jg6nX2jKsbXe3E2jOuq0EMHA5b0/NBAoCSmOpNc/szMDsca27P?=
 =?us-ascii?Q?O2gBGZVGCVseQNVRE0snJ40T0hKuPjxtlI3bo33g5HODiDlB8wIoyOxstmPs?=
 =?us-ascii?Q?V4vv8mwdUJEAIop3jYJuSXbd136J+LNoy5YjGlQmydIssmuPoRcuBxq2nCRd?=
 =?us-ascii?Q?f95w4EgNXXPx6Ja/KnZBBSA05zoZvd8gxuQV5zz1fii7k7JClyONs2fZJdgS?=
 =?us-ascii?Q?DuiWWgm4JlIX8KOjpdVDST7o4Yqwmn4AfTW//29pBohSpZ4ejBMSfFPzerS7?=
 =?us-ascii?Q?6ZQLKvpE9Bwy6VnSwduIkRWwfbkGrenn91hxlxO0sKVCNTXq+Mx/h3W41UTD?=
 =?us-ascii?Q?GFRNtW2WscfUCzzPZaQ/6qWxjjPrmiThT2Bcz0Nr6/lt7OcOvz9Z7sXjyto1?=
 =?us-ascii?Q?EfXVo4RsXKw8URGv0bflfSgfUnKOafT23jbZ/ufpfHkXhIr45P/VMh+Uq457?=
 =?us-ascii?Q?2ye/2ehzRWWnA2wr1StwZO3Byvak0Gzp6+Zh5CDPYuiXuclZSe3unk3QJR4p?=
 =?us-ascii?Q?CK84H3dYKEbxUrmHeg3mhQI8ZzZ5T1WWpeY8LWublHB9/tU7KDWlM5WS0a/1?=
 =?us-ascii?Q?T0Elp6Pda0cGh5a6NvDf8cUhfuFq9m8xnYF+2bmRTumbKB5En4LEPndYYCiU?=
 =?us-ascii?Q?sI8m8Ffup76LI2w=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 21:57:59.1639
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b2a448ce-d0c3-4422-ba8a-08dd302f83fe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA52.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7556

Add inject-error command for injecting CXL errors into CXL devices.
The command currently only has support for injecting CXL protocol
errors into CXL downstream ports via EINJ.

The command takes an error type and injects an error of that type into the
specified downstream port. Downstream ports can be specified using the
port's device name with the -d option. Available error types can be obtained
by running "cxl inject-error --list-errors".

This command requires the kernel to be built with CONFIG_DEBUGFS and
CONFIG_ACPI_APEI_EINJ_CXL enabled. It also requires root privileges to
run due to reading from <debugfs>/cxl/einj_types and writing to
<debugfs>/cxl/<dport>/einj_inject.

Example usage:
    # cxl inject-error --list-errors
    cxl.mem_correctable
    cxl.mem_fatal
    ...
    # cxl inject-error -d 0000:00:01.1 cxl.mem_correctable
    injected cxl.mem_correctable protocol error

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/builtin.h      |   1 +
 cxl/cxl.c          |   1 +
 cxl/inject-error.c | 188 +++++++++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.c   |  53 +++++++++++++
 cxl/lib/libcxl.sym |   2 +
 cxl/libcxl.h       |  13 ++++
 cxl/meson.build    |   1 +
 7 files changed, 259 insertions(+)
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
index 1643667..f808926 100644
--- a/cxl/cxl.c
+++ b/cxl/cxl.c
@@ -79,6 +79,7 @@ static struct cmd_struct commands[] = {
 	{ "enable-region", .c_fn = cmd_enable_region },
 	{ "disable-region", .c_fn = cmd_disable_region },
 	{ "destroy-region", .c_fn = cmd_destroy_region },
+	{ "inject-error", .c_fn = cmd_inject_error },
 	{ "monitor", .c_fn = cmd_monitor },
 };
 
diff --git a/cxl/inject-error.c b/cxl/inject-error.c
new file mode 100644
index 0000000..3645934
--- /dev/null
+++ b/cxl/inject-error.c
@@ -0,0 +1,188 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2025 AMD. All rights reserved. */
+#include <ccan/array_size/array_size.h>
+#include <util/parse-options.h>
+#include <cxl/libcxl.h>
+#include <util/log.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <errno.h>
+
+#define EINJ_TYPES_BUF_SIZE 512
+
+static struct inject_params {
+	const char *type;
+	const char *devname;
+	const char *debugfs;
+	bool debug;
+	bool list;
+} param;
+
+static struct cxl_proto_error {
+	enum cxl_proto_error_types err_type;
+	const char *err_str;
+} cxl_proto_errors[] = {
+	{ CXL_CACHE_CORRECTABLE, "cxl_cache_correctable", },
+	{ CXL_CACHE_UNCORRECTABLE, "cxl_cache_uncorrectable" },
+	{ CXL_CACHE_FATAL, "cxl_cache_fatal" },
+	{ CXL_MEM_CORRECTABLE, "cxl_mem_correctable" },
+	{ CXL_MEM_UNCORRECTABLE, "cxl_mem_uncorrectable" },
+	{ CXL_MEM_FATAL, "cxl_mem_fatal" }
+};
+
+#define BASE_OPTIONS() \
+OPT_BOOLEAN(0, "debug", &param.debug, "turn on debug output"), \
+OPT_BOOLEAN(0, "list-errors", &param.list, "list possible error types"), \
+OPT_STRING('m', "mount", &param.debugfs, "debugfs mount point", \
+	   "Mount point for debug file system, defaults to /sys/kernel/debug")
+
+#define INJECT_OPTIONS() \
+OPT_STRING('d', "device", &param.devname, "CXL device name", \
+	   "Device name of CXL device to inject error into. Protocol errors may only target downstream ports") \
+
+static const struct option inject_options[] = {
+	BASE_OPTIONS(),
+	INJECT_OPTIONS(),
+	OPT_END(),
+};
+
+static struct log_ctx iel;
+
+static struct cxl_proto_error *find_cxl_proto_err(const char *type)
+{
+	unsigned long i;
+
+	for (i = 0; i < ARRAY_SIZE(cxl_proto_errors); i++) {
+		if (!strcmp(type, cxl_proto_errors[i].err_str)) {
+			return &cxl_proto_errors[i];
+		}
+	}
+
+	log_err(&iel, "Invalid CXL protocol error type: %s\n", type);
+	return NULL;
+}
+
+static int list_cxl_proto_errors(struct cxl_ctx *ctx, const char *debugfs)
+{
+	unsigned long i, err_num;
+	char buf[EINJ_TYPES_BUF_SIZE];
+	char *line;
+	int rc;
+
+	rc = cxl_get_proto_errors(ctx, buf, debugfs);
+	if (rc) {
+		log_err(&iel, "Failed to get CXL protocol errors: %d\n", rc);
+		return rc;
+	}
+
+	line = strtok(buf, "\n");
+	while (line) {
+		err_num = strtoul(line, NULL, 16);
+		if (err_num < CXL_CACHE_CORRECTABLE || err_num > CXL_MEM_FATAL)
+			continue;
+
+		for (i = 0; i < ARRAY_SIZE(cxl_proto_errors); i++)
+			if (err_num == cxl_proto_errors[i].err_type)
+				printf("%s\n", cxl_proto_errors[i].err_str);
+
+		line = strtok(NULL, "\n");
+	}
+
+	return 0;
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
+static int inject_proto_err(struct cxl_ctx *ctx, const char *devname,
+			    struct cxl_proto_error *perr, const char *debugfs)
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
+	rc = cxl_dport_inject_proto_err(dport, perr->err_type, debugfs);
+	if (rc)
+		return rc;
+
+	log_info(&iel, "injected %s protocol error.\n", perr->err_str);
+	return 0;
+}
+
+static int inject_action(int argc, const char **argv, struct cxl_ctx *ctx,
+			 const struct option *options, const char *usage)
+{
+	struct cxl_proto_error *perr;
+	const char * const u[] = {
+		usage,
+		NULL
+	};
+	const char *debugfs;
+	int rc = -EINVAL;
+
+	log_init(&iel, "cxl inject-error", "CXL_INJECT_LOG");
+	argc = parse_options(argc, argv, options, u, 0);
+
+	if (param.debug) {
+		cxl_set_log_priority(ctx, LOG_DEBUG);
+		iel.log_priority = LOG_DEBUG;
+	} else {
+		iel.log_priority = LOG_INFO;
+	}
+
+	if (param.debugfs)
+		debugfs = param.debugfs;
+	else
+		debugfs = "/sys/kernel/debug";
+
+	if (param.list)
+		return list_cxl_proto_errors(ctx, debugfs);
+
+	if (argc != 1) {
+		usage_with_options(u, options);
+		return rc;
+	}
+
+	perr = find_cxl_proto_err(argv[0]);
+	if (perr) {
+		rc = inject_proto_err(ctx, param.devname, perr, debugfs);
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
+			       "inject-error [<options>] <error-type>");
+
+	return rc ? EXIT_FAILURE : EXIT_SUCCESS;
+}
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 91eedd1..8174c11 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -3179,6 +3179,59 @@ CXL_EXPORT int cxl_dport_get_id(struct cxl_dport *dport)
 	return dport->id;
 }
 
+CXL_EXPORT int cxl_dport_inject_proto_err(struct cxl_dport *dport,
+					  enum cxl_proto_error_types perr,
+					  const char *debugfs)
+{
+	struct cxl_port *port = cxl_dport_get_port(dport);
+	size_t path_len = strlen(debugfs) + 24;
+	struct cxl_ctx *ctx = port->ctx;
+	char buf[32];
+	char *path;
+	int rc;
+
+	if (!dport->dev_path) {
+		err(ctx, "no dev_path for dport\n");
+		return -EINVAL;
+	}
+
+	path_len += strlen(dport->dev_path);
+	path = calloc(1, path_len);
+	if (!path)
+		return -ENOMEM;
+
+	snprintf(path, path_len, "%s/cxl/%s/einj_inject", debugfs,
+		 cxl_dport_get_devname(dport));
+
+	snprintf(buf, sizeof(buf), "0x%lx\n", (u64) perr);
+	rc = sysfs_write_attr(ctx, path, buf);
+	if (rc)
+		err(ctx, "could not write to %s: %d\n", path, rc);
+
+	free(path);
+	return rc;
+}
+
+CXL_EXPORT int cxl_get_proto_errors(struct cxl_ctx *ctx, char *buf,
+				    const char *debugfs)
+{
+	size_t path_len = strlen(debugfs) + 16;
+	char *path;
+	int rc = 0;
+
+	path = calloc(1, path_len);
+	if (!path)
+		return -ENOMEM;
+
+	snprintf(path, path_len, "%s/cxl/einj_types", debugfs);
+	rc = sysfs_read_attr(ctx, path, buf);
+	if (rc)
+		err(ctx, "could not read from %s: %d\n", path, rc);
+
+	free(path);
+	return rc;
+}
+
 CXL_EXPORT struct cxl_port *cxl_dport_get_port(struct cxl_dport *dport)
 {
 	return dport->port;
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 304d7fa..d39a12d 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -281,4 +281,6 @@ global:
 	cxl_memdev_get_ram_qos_class;
 	cxl_region_qos_class_mismatch;
 	cxl_port_decoders_committed;
+	cxl_dport_inject_proto_err;
+	cxl_get_proto_errors;
 } LIBCXL_6;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index fc6dd00..867daa4 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -160,6 +160,15 @@ struct cxl_port *cxl_port_get_next_all(struct cxl_port *port,
 	for (port = cxl_port_get_first(top); port != NULL;                     \
 	     port = cxl_port_get_next_all(port, top))
 
+enum cxl_proto_error_types {
+	CXL_CACHE_CORRECTABLE = 1 << 12,
+	CXL_CACHE_UNCORRECTABLE = 1 << 13,
+	CXL_CACHE_FATAL = 1 << 14,
+	CXL_MEM_CORRECTABLE = 1 << 15,
+	CXL_MEM_UNCORRECTABLE = 1 << 16,
+	CXL_MEM_FATAL = 1 << 17,
+};
+
 struct cxl_dport;
 struct cxl_dport *cxl_dport_get_first(struct cxl_port *port);
 struct cxl_dport *cxl_dport_get_next(struct cxl_dport *dport);
@@ -168,6 +177,10 @@ const char *cxl_dport_get_physical_node(struct cxl_dport *dport);
 const char *cxl_dport_get_firmware_node(struct cxl_dport *dport);
 struct cxl_port *cxl_dport_get_port(struct cxl_dport *dport);
 int cxl_dport_get_id(struct cxl_dport *dport);
+int cxl_dport_inject_proto_err(struct cxl_dport *dport,
+			       enum cxl_proto_error_types err,
+			       const char *debugfs);
+int cxl_get_proto_errors(struct cxl_ctx *ctx, char *buf, const char *debugfs);
 bool cxl_dport_maps_memdev(struct cxl_dport *dport, struct cxl_memdev *memdev);
 struct cxl_dport *cxl_port_get_dport_by_memdev(struct cxl_port *port,
 					       struct cxl_memdev *memdev);
diff --git a/cxl/meson.build b/cxl/meson.build
index 61b4d87..79da4e6 100644
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

