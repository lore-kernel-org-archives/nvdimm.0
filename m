Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010061.outbound.protection.outlook.com [40.93.198.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4433128B0
	for <nvdimm@lists.linux.dev>; Fri,  6 Feb 2026 21:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770414636; cv=fail; b=Xw1pfniyjRM2iId6sjPFQzwOwEOzbbQ+bZ4fx1vG+PIYxRWYJVt5LdpNtDD6FLLUkiSoAOYcBQje0d8pAjbcATjxsK8WVcfT8ksYGI2Q600pUwSZTrHBwt+uyFB7BU2Ldm6gL62LGUUT78cjmZQQn49E9+boaztg7vTYwjblhe8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770414636; c=relaxed/simple;
	bh=nWSEq/AEFJ40Ge/fdFqUsN8DApIAcjyYMRs0hcl8j+0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NJwc3LlDspp1R0AiB9wBQiK65CVMPvmlvBCO3YnaxpdwQirCMeQiUkfgLgpZnrOml5o2bCdEwYnjBsKXfp+t64LlZaWJHogzSN5viXI5o4IF1+y1vj8J86jNM4/SRj8UV97lKA0Yx5aKrDEhStEjyjZ0zegQaYm+cgGdZEqboTg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IpXqWo4A; arc=fail smtp.client-ip=40.93.198.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IpXqWo4A"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tuXTrTs3oufODhzqe5Ltatl4lN2uHTJiYIqPjBrGwdvKxMveiu0yWToCvNILdLjg6XoP53YWiTfXq0Og5ni5XTcsPZeYyK3gWpEWU0rQVBPWqNsVqEnEk3P4XSxnQIti/KC5B0weKhHbR2MXFbvn4qd9NmAWTwRbGlA/y0nBpkZ7Ef9qY/ues68uFbJbcJmFXVs+9Z6sMwx3ct9hoOKUCZqMAsLubLEpi5HTd2cHSyIwC9xVXm6bcmGZSsiCrkDY9vIKczzfITQr2yoAlOBj7ZzXsaPrzqUBxwCcoRI2tQxUZGZUjOIsmwlga33jK/KoUEhliGimoGWvPKA23/dEVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+/M3nHsIxhMpbBH7QtJZ+yiyPf494rlmsNNyzqe73VU=;
 b=FEHj9jnh7rQlSNSI8opPyvS7ILv+4ky8DZksc00g423HJQmXGxaHRmxLNRChtC5F9CUGzF/3I1cZK75f+t2DQ/Qjrx+nmzh5TZOymxVuQlGJNMW86wNmuOYGaLw2UgdYFPmyu2ZkeP1/urwmriUuA8zk4jJEmrdOJ6wn0OsaRTKtqXc1BSnJEqxiXB/0u2kRRqnazQ6ZbHPsQP+nwYU3nMtUeubeTZKRWx/fPGZXjScCAKegtwr0/7ab3niudK+wpKUJCZ8RLbR7OGvgLlmVlpofemShKYJb3UMFL2QF6ORtxYjz3FnzBw7Mg1eDvUXxEeKFB8aNlmzM/ZUWkaFj5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+/M3nHsIxhMpbBH7QtJZ+yiyPf494rlmsNNyzqe73VU=;
 b=IpXqWo4A0bLBBYkw3ADfod+dCD8XVmw+aVeYYTQrLDFSoY5qy7uI3GvwWuvrBIB74oE4FP71cOsWIIpMRPp3qs5LBEd0rFXy7GpxyuWXuXZUkoT/5Oj8mHStENDYtCdZDfKemvwECFO40pHuF4OLQHPkL4D+Nj9x8fSFz2QUrQk=
Received: from BLAPR03CA0153.namprd03.prod.outlook.com (2603:10b6:208:32f::19)
 by CH3PR12MB9195.namprd12.prod.outlook.com (2603:10b6:610:1a3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Fri, 6 Feb
 2026 21:50:25 +0000
Received: from BL02EPF0002992D.namprd02.prod.outlook.com
 (2603:10b6:208:32f:cafe::3a) by BLAPR03CA0153.outlook.office365.com
 (2603:10b6:208:32f::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.16 via Frontend Transport; Fri,
 6 Feb 2026 21:50:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0002992D.mail.protection.outlook.com (10.167.249.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Fri, 6 Feb 2026 21:50:25 +0000
Received: from ausbcheatha02.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 6 Feb
 2026 15:50:24 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>, <vishal.l.verma@intel.com>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>
Subject: [PATCH v8 4/7] cxl: Add inject-protocol-error command
Date: Fri, 6 Feb 2026 15:50:05 -0600
Message-ID: <20260206215008.8810-5-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992D:EE_|CH3PR12MB9195:EE_
X-MS-Office365-Filtering-Correlation-Id: f4db968e-ff42-46f3-c2c1-08de65c9bc85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OuujYXrZDhcDBidIv+RufaOoNqnAlvwkcI5NcmjzswWHyWwGMKu+9paYLigA?=
 =?us-ascii?Q?wNKKciHj2Itrt/PruRKIEH4Mxz9ZFrbg1pMcXxXsy6CPpWJ1RQVo2UXNrz9t?=
 =?us-ascii?Q?JKg5VMtQ/Tr6qRycmZnsZVSckW+8/2e4JCEl/CPAO3O1hh9eOmRMQrAMswYl?=
 =?us-ascii?Q?VBxe+NxwUCylKND8B7NHqKxrJc0j3Wl9kzsZeVMrP8sZGXk7Qrd3z31fT+YZ?=
 =?us-ascii?Q?Gx+uvsCHxBr/Qg4eOo3Bv6DpjeAHk6EdHwbd+OztJyVmuTcBqUuwu8+3Mitw?=
 =?us-ascii?Q?IxfO+oX+HsA0LjOclI4uYj5l/vb3maeEu06D2JCM8Nl49Q98CEaytupS98NY?=
 =?us-ascii?Q?tqOf1hbLN6cSJhK3DNv+fvu6W27SndU/6BOsOm1i32ckNxQzD71WUENFYLv8?=
 =?us-ascii?Q?r2ooK8KlrdOjAt/v5u660HMYKqYH+uhQ1dFrEq5FBE3z1RMiCmdnYTp+XxqJ?=
 =?us-ascii?Q?NyOflFaOoaAQUXnATYHUWewldpWGEKD2BNn41CdnW5O9phbobKGsdSZPzxhv?=
 =?us-ascii?Q?8MBvzTTDyZ4DBEpjjpV25Jfe9qDCOchL6iPO2K0yOY0KG6ifaFh1u9wgCagi?=
 =?us-ascii?Q?8m37Opo9lFF/t3tj6GyNlPmq9GaRxebPH7zhu8MS/aUVxwvz1ErGaw/LQpYZ?=
 =?us-ascii?Q?+aQ5lwhc1FbiQ5n7fho7j7vjhstzaD5kxHCh9FcTojdHSg5yZYmEKTvt2Dm6?=
 =?us-ascii?Q?/B+SaoocwIlNOHZjmqmZTTQgwitGhahH637DzcfQdYEiF280jAqeZDlqh4iw?=
 =?us-ascii?Q?84tBWA2oCf2pczrfcqZnNCzdJknkkjSxCWRxrAjgxKIviobaYYA41Pt6KJWL?=
 =?us-ascii?Q?sBkJZPUkVMMla1CHZZ8e0xuG/iLuIJA8OdD+ls+u8KNie63XaaNXvSF4c2U6?=
 =?us-ascii?Q?LD9S/zuIwaoXFX1e2oovBtd+8AsoB6W5ZdGyrxvOkKzd3ViLq0I6GbhEIajT?=
 =?us-ascii?Q?Qb+uC/niXz9Su/WTYFc/rRMmFtyl2L1SDcL2fH29PawvlM2T+IF65pWhgCY7?=
 =?us-ascii?Q?vWUcLUyU8TAPiguvxemdQEWdfCtJtyCqAG34wiMRG1+4VdVYyhYNqohBwF8j?=
 =?us-ascii?Q?GqnsyhIincKaC1i53r2GHwazdJ+zQ43dfwX60/3xF7INKNmBUUnQqocuMGdJ?=
 =?us-ascii?Q?MRFqT1PKEpqeGV0UX0vuWRIW034nYwZcNUXlCcE1SnQ/8mXBAU4CEBN92S2T?=
 =?us-ascii?Q?kmc8bziUoc16OO0CtGwtXCf4LVvsE7Nl+sPOVv/kbWZwcyL8cjd9wXvu5Puy?=
 =?us-ascii?Q?1aKHuTto3/cm/ZhlzbtHthol3w22DYpxjgAJI9oo27BWk5sEjIY9K3VAC0cm?=
 =?us-ascii?Q?kf9Ukwsp516SBMNRDfe8j/NSpZeQxgG/PVqP7Zy2hFpWuU1aB0Ne5RenziNj?=
 =?us-ascii?Q?ccBPCV4uwQJRduNjNLaDmdZ8PD8aA+4HKSAuPCQPaIujHJRwrlCxoTXPRVcN?=
 =?us-ascii?Q?Qnk04vVDTg7/FFzLW/wkcoDSaUI3k6mZKp6qN0MWFuUlqYIOgz2EcSxjKhJO?=
 =?us-ascii?Q?cpjhb707pqHzA5G6E1Bwg5y7NYbJpNSw6Cf+L7LTDR2f6AwwUK4DeWIiHAjP?=
 =?us-ascii?Q?2zRREKwgBWffHYrmMVOu772pJ/wbL8EqOACUp3stXPWH7gSbXnQlmr+JZd+z?=
 =?us-ascii?Q?78oU66g8/u3Y2sTSXgxHNdGSAbtrNevfUna7FajMR0zKB92aTwenHvXQJvi2?=
 =?us-ascii?Q?/yVQEA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	pPOZoN6WpBxDhCEHlmcvAbR4c8Crm0Y66U2WyNVUIWQH5of4XS/Ddk15waaPshQ4oAnt4rf3+eGaytx6XJI+xHHgA9u6QMXMYbD8qetCAB/XOZb3ZyFaYPpuz306ozo0T9wo0lKj1cdS41QxeBxkFoF11h7RF2KooRlyoIQ/cCPTANQPCcN2FGY19vMa6Mc6aNolee6vW1n+2zkWGXleIVxLHxod65o32UXol70Sj4BDzHNr/UIE0/rvft8snyFPQ6DFVaKtZuUhQjUZucqOslFmVp7NSV3tCFmr4OF1h744fYpQFUD++0yXknVFxi4RJPuFxX0eugDKTTlbElrR4miKSajy3ORV1oy4RWN7Gs8OpKaV83Kom3FsJzy5iWfY1cE91hLzbo6G+WuBbZ2JR/Lg7/XuKXgdZ1ZuQ7aYVI1/Jfm9QqZLHnUCxq8RfPno
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 21:50:25.8408
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f4db968e-ff42-46f3-c2c1-08de65c9bc85
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9195

Add the 'cxl-inject-protocol-error' command. This command provides CXL
protocol error injection for CXL VH root ports and CXL RCH downstream
ports.

Add util_cxl_dport_filter() to find downstream ports by device name.

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/builtin.h      |   1 +
 cxl/cxl.c          |   1 +
 cxl/filter.c       |  26 +++++++++
 cxl/filter.h       |   2 +
 cxl/inject-error.c | 143 +++++++++++++++++++++++++++++++++++++++++++++
 cxl/meson.build    |   1 +
 6 files changed, 174 insertions(+)
 create mode 100644 cxl/inject-error.c

diff --git a/cxl/builtin.h b/cxl/builtin.h
index c483f30..ca2e4d1 100644
--- a/cxl/builtin.h
+++ b/cxl/builtin.h
@@ -25,6 +25,7 @@ int cmd_create_region(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_enable_region(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_disable_region(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_destroy_region(int argc, const char **argv, struct cxl_ctx *ctx);
+int cmd_inject_protocol_error(int argc, const char **argv, struct cxl_ctx *ctx);
 #ifdef ENABLE_LIBTRACEFS
 int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx);
 #else
diff --git a/cxl/cxl.c b/cxl/cxl.c
index 1643667..00ecda0 100644
--- a/cxl/cxl.c
+++ b/cxl/cxl.c
@@ -80,6 +80,7 @@ static struct cmd_struct commands[] = {
 	{ "disable-region", .c_fn = cmd_disable_region },
 	{ "destroy-region", .c_fn = cmd_destroy_region },
 	{ "monitor", .c_fn = cmd_monitor },
+	{ "inject-protocol-error", .c_fn = cmd_inject_protocol_error },
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
index 0000000..ed6fb36
--- /dev/null
+++ b/cxl/inject-error.c
@@ -0,0 +1,143 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2025 AMD. All rights reserved. */
+#include <util/parse-options.h>
+#include <cxl/libcxl.h>
+#include <cxl/filter.h>
+#include <util/log.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <errno.h>
+#include <limits.h>
+
+static bool debug;
+
+static struct proto_inject_params {
+	const char *proto;
+	const char *severity;
+} proto_inj_param;
+
+static const struct option proto_inject_options[] = {
+	OPT_STRING('p', "protocol", &proto_inj_param.proto, "mem/cache",
+		   "Which CXL protocol error to inject into <dport>"),
+	OPT_STRING('s', "severity", &proto_inj_param.severity,
+		   "correctable/uncorrectable/fatal",
+		   "Severity of CXL protocol to inject into <dport>"),
+#ifdef ENABLE_DEBUG
+	OPT_BOOLEAN(0, "debug", &debug, "turn on debug output"),
+#endif
+	OPT_END(),
+};
+
+static struct log_ctx iel;
+
+static struct cxl_protocol_error *find_cxl_proto_err(struct cxl_ctx *ctx,
+						     const char *type,
+						     const char *severity)
+{
+	struct cxl_protocol_error *pe;
+	char perror[256] = { 0 };
+	size_t len;
+
+	len = snprintf(perror, sizeof(perror), "%s-%s", type,
+		       severity);
+	if (len >= sizeof(perror)) {
+		log_err(&iel, "Buffer too small\n");
+		return NULL;
+	}
+
+	cxl_protocol_error_foreach(ctx, pe) {
+		if (strcmp(perror, cxl_protocol_error_get_str(pe)) == 0)
+			return pe;
+	}
+
+	log_err(&iel, "Invalid CXL protocol error type: %s\n", perror);
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
+static int inject_protocol_action(int argc, const char **argv,
+				  struct cxl_ctx *ctx,
+				  const struct option *options,
+				  const char *usage)
+{
+	struct cxl_protocol_error *perr;
+	const char * const u[] = {
+		usage,
+		NULL
+	};
+	int rc = -EINVAL;
+
+	log_init(&iel, "cxl inject-protocol-error", "CXL_INJECT_LOG");
+	argc = parse_options(argc, argv, options, u, 0);
+
+	if (debug) {
+		cxl_set_log_priority(ctx, LOG_DEBUG);
+		iel.log_priority = LOG_DEBUG;
+	} else {
+		iel.log_priority = LOG_INFO;
+	}
+
+	if (argc != 1 || proto_inj_param.proto == NULL ||
+	    proto_inj_param.severity == NULL) {
+		usage_with_options(u, options);
+		return rc;
+	}
+
+	perr = find_cxl_proto_err(ctx, proto_inj_param.proto,
+				  proto_inj_param.severity);
+	if (perr) {
+		rc = inject_proto_err(ctx, argv[0], perr);
+		if (rc)
+			log_err(&iel, "Failed to inject error: %d\n", rc);
+	}
+
+	return rc;
+}
+
+int cmd_inject_protocol_error(int argc, const char **argv, struct cxl_ctx *ctx)
+{
+	int rc = inject_protocol_action(argc, argv, ctx, proto_inject_options,
+					"inject-protocol-error <dport> -p <protocol> -s <severity> [<options>]");
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

