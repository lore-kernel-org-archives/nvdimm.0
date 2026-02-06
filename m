Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012006.outbound.protection.outlook.com [52.101.43.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E30D312816
	for <nvdimm@lists.linux.dev>; Fri,  6 Feb 2026 21:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770414636; cv=fail; b=GZqNrGSPltRCDA5cN/tLMNW5fdxq8G2HBmgIe0EvNQCNSwTNmpri1PfsdkoSs8L67ToVbioL1bKumt+MPv9nNAa0U403URnFpRic/fVzSJN6GP/lfNwkkXqkZjD4aQocSwTsURgUvA926FB8NQXhtDWxhoGHXZYVqb4IHkicgUk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770414636; c=relaxed/simple;
	bh=jcNxUSu0/5/3rnFGkENKgAj9MsBKpBt2kPU9rjmm6GQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q9eHu4FR5D+ma5JPbjGb0j4s5gTRB3jwnAiB+YM2tS0e3ubphYO0Jqucva5G9WdHKPb654gDvPOko/6p+2N6wgTlxLV1wBGPuozf1xPZFGdbs6QBRIUzSqafHwIYTvj277BnP1nbTsp+0dpCrE7MdXu5QK0UshuDtmv6qH5Lp9A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2B9+paV2; arc=fail smtp.client-ip=52.101.43.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2B9+paV2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sdybTCbyJn9phc6TzXv18xuWGi5FLUFUsEC2mLKZ6Jy5vIjU/SpJTGTf8B4aY9iSmt1emx023vyUb6WX5gpKCFR53qg00OXE239uJlqVqPjD6rmUvIsHnKPM29Ao8sK1ZLJGRnw0l9peF0pVIPdLHnzPi046mxlxSd52RuVfi2euTzrAupSXSqlMT/et6vGorM6gAccy/ToxoexlBwIRWoci21kgMwWft5Y1jh56hav9+kHtTjGXXHAuFPOGhEMpONafnpfDOtiC9yJAmUgy2l28q+z2qzf1zLo0V9LOco1DcwzKk7clapnlfbvNYuHFK+QRfNV4pP3PI6f+hIpVOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sirw6tKNB9yyTeQvzMlUmLzdnXGdmzhhxofKi0lJMiw=;
 b=jrl66KQ5vGUB7kwgzFv0cjItQj5yrqNgQEmyznumnOKdS9L37zcZeTLCLwlkPgrWAuQ0PvIvraOKLVGt0GDuVaWOdiwsnivgWbeo84y6OsxHUIOuiaBLnQgyqLZHKzBzPtUjNSKHg2FwVDLZmThnt0FM0/+GU0uaErQ7+KDQc+NjXZLNsJ75r5Rj2GdweEgc4wcFtGFkcH6aAg/CL6ZBrukO5217kDgHHzxUO09gdo3EnwjfwVrchPpugLEDlmKoQHUySmhNsOO+hOXBPyGHFOuXqOyl1gtC8Jvt0QIQCsJeMQk7xZueRMUF/mdJM2eZfRdfgny+zIfjmcLqUsjw8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sirw6tKNB9yyTeQvzMlUmLzdnXGdmzhhxofKi0lJMiw=;
 b=2B9+paV23fYMncPjFWlc9OxVwJ6dA3tWJVskVlKtCwNZLfnwB5wVrgm6Z3B4pH94BSgfoDQFHbpMukO+qXGUcVLYqDl4wY5CT+Z82b9Y01f2qZI8p0b0YjYbVulHSBYsjn/2A97MxH6w7R3vvP50wi8KdHMtlTnbf7mILS64E08=
Received: from BLAPR03CA0168.namprd03.prod.outlook.com (2603:10b6:208:32f::6)
 by PH8PR12MB7133.namprd12.prod.outlook.com (2603:10b6:510:22e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.13; Fri, 6 Feb
 2026 21:50:30 +0000
Received: from BL02EPF0002992D.namprd02.prod.outlook.com
 (2603:10b6:208:32f:cafe::86) by BLAPR03CA0168.outlook.office365.com
 (2603:10b6:208:32f::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.16 via Frontend Transport; Fri,
 6 Feb 2026 21:50:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0002992D.mail.protection.outlook.com (10.167.249.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Fri, 6 Feb 2026 21:50:29 +0000
Received: from ausbcheatha02.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 6 Feb
 2026 15:50:24 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>, <vishal.l.verma@intel.com>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>
Subject: [PATCH v8 5/7] cxl: Add poison injection/clear commands
Date: Fri, 6 Feb 2026 15:50:06 -0600
Message-ID: <20260206215008.8810-6-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992D:EE_|PH8PR12MB7133:EE_
X-MS-Office365-Filtering-Correlation-Id: fa0f9bd8-4851-416c-f550-08de65c9bef2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NE76MKV6yD709RljNwcQ7oHR8Kc1lR8DIBOaFjRq0bHFsP4K1BlQatL730bL?=
 =?us-ascii?Q?d2CYmPEYimELEiQUMko3fBjQAf/m1J9lT7eRb4frwcVI300wiX6oSKGqE4p1?=
 =?us-ascii?Q?TzPXFDAwJ0v4AKyXP0Fgzi9DD+mfW4P9BvILjmxYCcAnXESSC3ue9B1UojAz?=
 =?us-ascii?Q?gn65/pYElMxOUdgxpp7O30cAapek1HqBtD2m3GIK9yn+XLMA64Fk3CblrLq5?=
 =?us-ascii?Q?drvEZX6WBTAXgUqvmoy0SyJyc+BEUZGDRPCz3KU7fYqGRNTirQ071cnzjzDZ?=
 =?us-ascii?Q?u7xplVXSNAyaROlc2HSFfPHxrg2KCbqIVL7n6VmSNpWaPoZTlwKoR95CMn5B?=
 =?us-ascii?Q?HQBjJ7x2ef4ur2j2XkkYPUpya5naHUTYbXLLkmmeMRF6Nzsc47BSBiFC2fFZ?=
 =?us-ascii?Q?lfvyQssVoHwYZubmbZiUvGIMr9tjqI3uZWdfmFDNnPkdTCwPzp6kzUaOWGAx?=
 =?us-ascii?Q?oei1A/ATkutYHWSti5tI+8n0+GPCKLafIQwyzHG32vpzhUCLtwfTUKz3/X7G?=
 =?us-ascii?Q?/3GAx0Ps+C1AHH6VdcaJ1wruUgxPsyBfzQH3VZFd34FI4mi6QLGj9SnPAewq?=
 =?us-ascii?Q?mTxcMmy4P29eh9EwZY93KzpdEeOHVzagh2thGHJOyqNqPkAoEdDEGIEKj2KU?=
 =?us-ascii?Q?b/wpu8nLvk28d00UsKJn9hEPAp73pYrKMMGnoFzxDpNEjfU2kv6nN+7s/GMq?=
 =?us-ascii?Q?Z/Slg/puRDDWuMZBY5HX0GF0MlEKCagJK9YkLTWuopZwc0mgeQnukOANqe82?=
 =?us-ascii?Q?76GZkd4ggOf8kMnOMTfbss3btLD7m+Y5P/PcuWhYMeBql+1ZQ2sNkj1MSJsD?=
 =?us-ascii?Q?ptz2byqwUj3j9ZMSa1qH8K86+NzvI0wsepbcqNL1uc+VB3zk77DCoFRcRqzh?=
 =?us-ascii?Q?AbqJKg7iVSFlAgmywtx4fnxzZRlf26+N1ZFil7Ssin/2vNyYsiTYEGt6fr9Q?=
 =?us-ascii?Q?eCLoMdCkYhyZfCRDQL2IArcHzHbeMcIdVYzautNWowxrANXGwWBqwyJhxaU7?=
 =?us-ascii?Q?p5sKkiI3jq2QDtDM5XEE2UeL/GbQ+jAKwVHRWVMwNlBiTay/cigyr1sLlSiO?=
 =?us-ascii?Q?VRHxMw2x1b4tuwMLf3nldC6zbwBKjtlR8JOKEFV05CqzoZquAM9yugPQ4F/s?=
 =?us-ascii?Q?B/yUBFSzG6btw/ezBDs/4ITJcEa8hc/BtM1o0qF1j2/wQLcqNg83DDZvlu7O?=
 =?us-ascii?Q?F9LIIH3UJIpo4NFwK2mWax7axFQSHBY4EP7pMaMvzz9LR2EBhyHohXRNJNN4?=
 =?us-ascii?Q?u8BbEkJciRjKiv/2+yFlBkSeh2fdKozWjstKNhBdSkNtvBaKkwSGLgM0yXmu?=
 =?us-ascii?Q?lGxTjQefyjvJ2pfOx54V3i8Oa/HdYH5Ku2l+8QQtayRb0hKGVuPzgHFsyVt1?=
 =?us-ascii?Q?0yshYqrrL59fEujt1ZTNBUkpDLoXvlJCyZJ2pHo0pGBHamxcW1/fTSQEp0Fc?=
 =?us-ascii?Q?LaGeRRTb/+Rd5M/pDHZ5XFvQ5dOk78kJrJWVcnGzmXKwFXlAbqvP2KEsJv2N?=
 =?us-ascii?Q?yhaOwp84lbq7EzmtY+0XtYR4571o+ZhKe/7d/KNpzj0WK2GcoDhkooYjJwWy?=
 =?us-ascii?Q?9Fnu6kbFzwf8ZL3Pjeah3E/VOAUhLojKV/dwgEYrANtA60I7LtPycVbVNMwk?=
 =?us-ascii?Q?s0aJFfOvd0W2cwRr5OLmo+Zkp/zCkekphjPcqDrLN1khI1m8sh1VJo1YPtW0?=
 =?us-ascii?Q?45ZnZQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XsLPskOrJeRG8O+ZQeu5zhex2NNNEZ53FAfrjz1ZgNVRQQETIUWmyrmaafaH2ipO1Yxfp2VjJL8/TAx85aERDeyg5JiJFWuVU4ORTc8hrBjBQwpubrWebKSWczVnHxCpEjTKnqVwSwli/enesdHhV4jVuIro6UYBeeF+KUv3eGzHmRjvRFeaKAkBemX10kJnrQVpGdrMjzjMNBRpRTA/yEHP9GGTQmcsJQzC2hkylMD3lCc8CZXlcOz7w3otL6DWpo2LE8yQ6feaq8pjrNB6GgvuN4wCiBDOCEgBkM4fzPR3PwDyjyHrSPeR68/AOudq4GfQpQVvoxG2PmsA3eo2LF2LVpn8X4rt8C/J0SZ4TJuQklNazw1WFeEYkkKlE8K0mL1DjkjKQjkN9Vok5FPEtAKmI49evxPPL7XQoiIVnm44ePpWjEsGd3bxIlWAmRPP
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 21:50:29.9180
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa0f9bd8-4851-416c-f550-08de65c9bef2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7133

Add the 'cxl-inject-media-poison' and 'cxl-clear-media-poison' commands.
These commands allow the user to inject and clear device poison from CXL
memory devices at a given device physical address.

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/builtin.h      |   2 +
 cxl/cxl.c          |   2 +
 cxl/inject-error.c | 169 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 173 insertions(+)

diff --git a/cxl/builtin.h b/cxl/builtin.h
index ca2e4d1..578f33b 100644
--- a/cxl/builtin.h
+++ b/cxl/builtin.h
@@ -26,6 +26,8 @@ int cmd_enable_region(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_disable_region(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_destroy_region(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_inject_protocol_error(int argc, const char **argv, struct cxl_ctx *ctx);
+int cmd_inject_media_poison(int argc, const char **argv, struct cxl_ctx *ctx);
+int cmd_clear_media_poison(int argc, const char **argv, struct cxl_ctx *ctx);
 #ifdef ENABLE_LIBTRACEFS
 int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx);
 #else
diff --git a/cxl/cxl.c b/cxl/cxl.c
index 00ecda0..8dd86ca 100644
--- a/cxl/cxl.c
+++ b/cxl/cxl.c
@@ -81,6 +81,8 @@ static struct cmd_struct commands[] = {
 	{ "destroy-region", .c_fn = cmd_destroy_region },
 	{ "monitor", .c_fn = cmd_monitor },
 	{ "inject-protocol-error", .c_fn = cmd_inject_protocol_error },
+	{ "inject-media-poison", .c_fn = cmd_inject_media_poison },
+	{ "clear-media-poison", .c_fn = cmd_clear_media_poison },
 };
 
 int main(int argc, const char **argv)
diff --git a/cxl/inject-error.c b/cxl/inject-error.c
index ed6fb36..aa15eb6 100644
--- a/cxl/inject-error.c
+++ b/cxl/inject-error.c
@@ -28,6 +28,34 @@ static const struct option proto_inject_options[] = {
 	OPT_END(),
 };
 
+static struct inject_poison_params {
+	const char *address;
+} poison_inj_param;
+
+static struct clear_params {
+	const char *address;
+} poison_clear_param;
+
+static const struct option poison_inject_options[] = {
+	OPT_STRING('a', "address", &poison_inj_param.address,
+		   "Address for poison injection",
+		   "Device physical address for poison injection in hex or decimal"),
+#ifdef ENABLE_DEBUG
+	OPT_BOOLEAN(0, "debug", &debug, "turn on debug output"),
+#endif
+	OPT_END(),
+};
+
+static const struct option poison_clear_options[] = {
+	OPT_STRING('a', "address", &poison_clear_param.address,
+		   "Address for poison clearing",
+		   "Device physical address to clear poison from in hex or decimal"),
+#ifdef ENABLE_DEBUG
+	OPT_BOOLEAN(0, "debug", &debug, "turn on debug output"),
+#endif
+	OPT_END(),
+};
+
 static struct log_ctx iel;
 
 static struct cxl_protocol_error *find_cxl_proto_err(struct cxl_ctx *ctx,
@@ -70,6 +98,20 @@ static struct cxl_dport *find_cxl_dport(struct cxl_ctx *ctx, const char *devname
 	return NULL;
 }
 
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
 static int inject_proto_err(struct cxl_ctx *ctx, const char *devname,
 			    struct cxl_protocol_error *perror)
 {
@@ -141,3 +183,130 @@ int cmd_inject_protocol_error(int argc, const char **argv, struct cxl_ctx *ctx)
 
 	return rc ? EXIT_FAILURE : EXIT_SUCCESS;
 }
+
+static int poison_action(struct cxl_ctx *ctx, const char *filter,
+			 const char *addr_str, bool inj)
+{
+	struct cxl_memdev *memdev;
+	unsigned long long addr;
+	int rc;
+
+	memdev = find_cxl_memdev(ctx, filter);
+	if (!memdev)
+		return -ENODEV;
+
+	if (!cxl_memdev_has_poison_support(memdev, inj)) {
+		log_err(&iel, "%s does not support %s\n",
+			cxl_memdev_get_devname(memdev),
+			inj ? "poison injection" : "clearing poison");
+		return -EINVAL;
+	}
+
+	errno = 0;
+	addr = strtoull(addr_str, NULL, 0);
+	if (addr == ULLONG_MAX && errno == ERANGE) {
+		log_err(&iel, "invalid address: %s", addr_str);
+		return -EINVAL;
+	}
+
+	if (inj)
+		rc = cxl_memdev_inject_poison(memdev, addr);
+	else
+		rc = cxl_memdev_clear_poison(memdev, addr);
+
+	if (rc)
+		log_err(&iel, "failed to %s %s:%s: %s\n",
+			inj ? "inject poison at" : "clear poison at",
+			cxl_memdev_get_devname(memdev), addr_str, strerror(-rc));
+	else
+		log_info(&iel,
+			 "poison %s at %s:%s\n", inj ? "injected" : "cleared",
+			 cxl_memdev_get_devname(memdev), addr_str);
+
+	return rc;
+}
+
+static int inject_poison_action(int argc, const char **argv,
+				struct cxl_ctx *ctx,
+				const struct option *options, const char *usage)
+{
+	const char * const u[] = {
+		usage,
+		NULL
+	};
+	int rc = -EINVAL;
+
+	log_init(&iel, "cxl inject-media-poison", "CXL_CLEAR_LOG");
+	argc = parse_options(argc, argv, options, u, 0);
+
+	if (debug) {
+		cxl_set_log_priority(ctx, LOG_DEBUG);
+		iel.log_priority = LOG_DEBUG;
+	} else {
+		iel.log_priority = LOG_INFO;
+	}
+
+	if (argc != 1 || !poison_inj_param.address) {
+		usage_with_options(u, options);
+		return rc;
+	}
+
+	rc = poison_action(ctx, argv[0], poison_inj_param.address, true);
+	if (rc) {
+		log_err(&iel, "Failed to inject poison on %s: %s\n", argv[0],
+			strerror(-rc));
+		return rc;
+	}
+
+	return rc;
+}
+
+int cmd_inject_media_poison(int argc, const char **argv, struct cxl_ctx *ctx)
+{
+	int rc = inject_poison_action(argc, argv, ctx, poison_inject_options,
+				      "inject-media-poison <memdev> -a <address> [<options>]");
+
+	return rc ? EXIT_FAILURE : EXIT_SUCCESS;
+}
+
+static int clear_poison_action(int argc, const char **argv, struct cxl_ctx *ctx,
+			       const struct option *options, const char *usage)
+{
+	const char * const u[] = {
+		usage,
+		NULL
+	};
+	int rc = -EINVAL;
+
+	log_init(&iel, "cxl clear-media-poison", "CXL_CLEAR_LOG");
+	argc = parse_options(argc, argv, options, u, 0);
+
+	if (debug) {
+		cxl_set_log_priority(ctx, LOG_DEBUG);
+		iel.log_priority = LOG_DEBUG;
+	} else {
+		iel.log_priority = LOG_INFO;
+	}
+
+	if (argc != 1 || !poison_clear_param.address) {
+		usage_with_options(u, options);
+		return rc;
+	}
+
+	rc = poison_action(ctx, argv[0], poison_clear_param.address, false);
+	if (rc) {
+		log_err(&iel, "Failed to clear poison on %s: %s\n", argv[0],
+			strerror(-rc));
+		return rc;
+	}
+
+	return rc;
+}
+
+int cmd_clear_media_poison(int argc, const char **argv, struct cxl_ctx *ctx)
+{
+	int rc = clear_poison_action(argc, argv, ctx, poison_clear_options,
+				     "clear-error <memdev> -a <address> [<options>]");
+
+	return rc ? EXIT_FAILURE : EXIT_SUCCESS;
+}
-- 
2.52.0

