Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013054.outbound.protection.outlook.com [40.93.201.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0981A840A
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 16:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767974856; cv=fail; b=HhmRAVaFdeZ/OoxuGpXMWAFnjaoEZ4/XS7JVMTMxvLU50eWc0gxLq9S7xbEVDv7+Sr0SrXWkiOadXFNesqn/GVNpV0Z/llx7zzid2T/8mxCJnG5FT1Sspy9qw3usJnlAl7uaDQHPcFbCw0Bl3wNMOmdDEoO/ewFX2OXw0l/TSdk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767974856; c=relaxed/simple;
	bh=OC2Av0mF1xU0mioBP+bnx5IoUROi3XtfLuYZYmQ9ies=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Iehi3HY6ldURLLczhijgy2L0wmFQ2Kg/qTZDKJ6jw4jOFcMzICh39Polg2Wdxj+OwA4R2gf3ekFIq22Rfa9YC9pylBbRsKp7inRKPno6+7tZzMZ4QUMcr1LsV6MeHsit2y1AYSXrswtLPN3sYGUfIJLRPwp67XluMiufDGMhsBc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=V1bnI11T; arc=fail smtp.client-ip=40.93.201.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="V1bnI11T"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ld7FCFxQSD1LGCFtjH2wVXrjWqDjgbGxXG17O3LMTbN9yGuVkKJFGNHYerPrYiHH48Lb1li7V9zY0uXgtoc99H7zh6oICUGQLSm9Fl6y6uwje4dMhUlDsayrZVqtQMheqhmKpf9jSxBf56cYGCMLLENzf8hrm7PvUQdoxW3HLu8czHTS3JDfy8EOT/5vdcqRE1+VIVRCRvjRROENT5CcZY3XgaJrWOm5FRL0NoPRkOWPjJyErVW6HUNEnbuZ0BY+uAsrfeW75yxpoBwBIndeRkIPmb1uybpFs4PHiLytdqwGgw7cuhradN/R3i0Od5Mp2koX8iJ+u+IJWUqASO30eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sEFl1U5vYEWbW9plsdaCIsZO1s5V1S0ToI/oYOe8KNw=;
 b=Lih1y1+Iekcpt+Wo4yQwhL2BgZClNy8T5CJXpRX9vkSKskyvIk3wZIDRIPDi+8T1AuFmWcOua8tZRc59xWXSZdPuRgjQFwI0+DRurHRK7Mzk6UQZvgiGJ77TRObl0UqjhkqX9O/AFqoQGewVZN2KVAN9LGskvZN6GuMEokjh3WC+n++EOQRaMadMl3a+R0LZ7PkLbBGBX0aOGrLbgiT0fraswYcVkf4wGDLR9vZbzfnfBHfHdpvVRDjnFJ1irb6YQ7UpvvMoHaos0Dp9oj/QmC+88OwthzUQ+Ut0w3gjM3jte9p4FcxzHxWUEzt9KYvlyG8HUMHUXVdBTK5jRfdQYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sEFl1U5vYEWbW9plsdaCIsZO1s5V1S0ToI/oYOe8KNw=;
 b=V1bnI11Tc4bJ9ed0HEFN5vq19vHDJtohmI5HoXHdzuY/D4EmwpX6GWKMATt/OaKvAUtuQcIMzEgdLsAx9YNF3/L+/wPn4aBOBZhRVNGb1JXkbrued0GaclidvzHa2+5/YHzWbcxoyqGOx2TfKQwjm/eiM6zuyfoIt50iRNLnJbs=
Received: from MN2PR13CA0004.namprd13.prod.outlook.com (2603:10b6:208:160::17)
 by CYXPR12MB9278.namprd12.prod.outlook.com (2603:10b6:930:e5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 16:07:31 +0000
Received: from BL6PEPF0002256F.namprd02.prod.outlook.com
 (2603:10b6:208:160:cafe::55) by MN2PR13CA0004.outlook.office365.com
 (2603:10b6:208:160::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.0 via Frontend Transport; Fri, 9
 Jan 2026 16:07:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0002256F.mail.protection.outlook.com (10.167.249.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Fri, 9 Jan 2026 16:07:30 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 9 Jan
 2026 10:07:27 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>
Subject: [PATCH 4/7] cxl: Add inject-error command
Date: Fri, 9 Jan 2026 10:07:17 -0600
Message-ID: <20260109160720.1823-5-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109160720.1823-1-Benjamin.Cheatham@amd.com>
References: <20260109160720.1823-1-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256F:EE_|CYXPR12MB9278:EE_
X-MS-Office365-Filtering-Correlation-Id: 134fc214-1c34-4cbd-b4b6-08de4f993143
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9qTJW9ecBJKIEdJ8sGCFosVl8XiS8ZpeKhRHBLO79b9YWzVW792XdH4GTd64?=
 =?us-ascii?Q?4ULxWNMc7RN/mjV+8A6eMynGXVVss5kG42F/mPMym1VIm0x5MN4E5091OEwL?=
 =?us-ascii?Q?3utVd/oy0SZM0eJCKQHitcCNPknwrckRptD2/fNodlgrIsdQ8vh2YWTZtFnQ?=
 =?us-ascii?Q?9G+AscSf81A0obbmD1WcVVP2g+j6dkHbfJB/LdD+gPgTLjiJD8pe/g4ugGMT?=
 =?us-ascii?Q?gJze+cwZJyPITFWLAOd5EctIZYHNHz4cT5bD2pNOvtBg4vBP0QE0eXxr6Ngi?=
 =?us-ascii?Q?fXtxDXtgyqJ2DczIA5KuzcauWE3DJRGxRKgLzY9sdRZGSBWKD3xR4SippRuf?=
 =?us-ascii?Q?5mAZjf9Yigyrxla20OL4cJRMsl47blf+3t6jxTQOWjzMSr4Xb1X2VFSn4GdL?=
 =?us-ascii?Q?hwTdPv4L9lsn1POPcWb653J0tZk0xcqby4BzKOnyMe10CVtvTwwt60L1CWsZ?=
 =?us-ascii?Q?KwDAbrXdkrFB4JCy8lMW/H8oDO3cw9ElbTqP6YA4kTr5GN0GKfMgFEThJGFa?=
 =?us-ascii?Q?i2LgwhNbtl2zUmgOcs/Gj4iOILCaRq0FL7neyshdy+2Qo0Dnajxuh5peSoPe?=
 =?us-ascii?Q?VLd4zJ1M5b6chzIfHwu3Qt1wS7aUqEiUeQlPfebFH+8OULuA65Ez4g4muZvj?=
 =?us-ascii?Q?scDV/8vhriHqxTpA7WPOywoLDmHpzFV/QFTlhU2o2IGmC2Dt9p8kSAexSqsO?=
 =?us-ascii?Q?J9y6MbboZ1v5eeUAiV0kW47YAtTiu39ZynI6zJlWdEhqoyLJNJXQTnzWZfeC?=
 =?us-ascii?Q?BCJiTxhXd/phtYP3SsmBAcGOpPEKFg69pcbnRxv4jeHxYQFXU7/Q488bSq2V?=
 =?us-ascii?Q?V1oOCeEsFhKN8emNdWNpQELgY1He36Ke7lWu7hxMGeBLYQ2bYYa/NZHsh5tN?=
 =?us-ascii?Q?moMSPO0iezIFDsoOH2+f3HG4kQYOEqNXeizBGwXCrG4xq9e0k+/VVjNuVNkf?=
 =?us-ascii?Q?kI+WWeou/ys8G2RefqpbZ4wFiiq+EXCvy0t84H/DJQMUPV9Tf2v6m7rrLpoh?=
 =?us-ascii?Q?LZhHxwqKsBJEdKa0XymZN+j/IzM70ccKV0A0K0Akq5xwxFkUA8YJhkLkqMwM?=
 =?us-ascii?Q?3M77MNsHs7Pyze2ng0RNa5SaKyRtkWfmAGVcH/RHQYA6G0OL2EnLtLNgIWpm?=
 =?us-ascii?Q?NpvwelSlZJY0KiHSu5g4RNZswis8I8Z9oXopUmpJCLroAzvW9kekXDkQgR9f?=
 =?us-ascii?Q?LJNVHSL76lA4IT+JX8ETR5XT5MM5CNvlhT12qfVUd3FSuKfQBtHo16xOSH+g?=
 =?us-ascii?Q?m6higWK3mTKxscF36c0KbLx2L0utVAWlfM1PfhN6jRxbEINKyPpq7cbH7s6L?=
 =?us-ascii?Q?4fSKvFsRFSF3+osAXVTSH2ebRtfmISlfqHi8A4O7ZQOR8U6SQ84RRZ6mIvAb?=
 =?us-ascii?Q?tfyw6d3uHBFw73ZdGOx1vsTzV9McYT3tnU5chJ+3RJnQAq9MHaKlah5EBd2R?=
 =?us-ascii?Q?VyOSfhu5iLHLPPGa/ZvfJ622LqTUGBoPwO3VxgXzKxt9xxntBJW6MZGGVt67?=
 =?us-ascii?Q?h15Wqu3uw5Aw0N4vYnSB95E8+eoWlRxnlnacnhBaXjopYGCCmpBa6UxSM69E?=
 =?us-ascii?Q?3Jxp5lzazfQpcYi6uUc=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 16:07:30.7858
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 134fc214-1c34-4cbd-b4b6-08de4f993143
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9278

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

