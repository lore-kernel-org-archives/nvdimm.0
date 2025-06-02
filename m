Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24B6196C7C
	for <nvdimm@lists.linux.dev>; Mon,  2 Jun 2025 20:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748897864; cv=fail; b=AeP+rIyW96HzGGUXN/lpqYMmRBKNggjZOOuU26qmBhnbfQz3zk23QbuaKjCHJURPjwo/NeB2E2Zo8keVUCwniysKUBaTWq+4Sfx73amJyzTwFdWSM3sT14JpyQlQULta6LCxQU239m9vBvLLZEGDcMS3+5KPfR6TVag1jwKtFhg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748897864; c=relaxed/simple;
	bh=n7l2XaFu8yWDfcmoSZ08T6mX/YUYgsD1CyBjbHblCsA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sgrf33P7wJ6TjAzuEqv20lkClWEtEfwVrhrtk3x0eAdI0hKwpuOdIlKXSristAKkgtMsMSEi8pToMiwg7JPSBW3g4mCk3KEDLDNNPaYrDBvDgmT6DdS9vs9Hyhz5s+kzasOOt8PbesyI7505e56TAudQoD4kJAksee8YkXS1sBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XWPays5n; arc=fail smtp.client-ip=40.107.223.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XWPays5n"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BNbvvpNsCxACF9MLGrLEGEBxMh6ynLYJh8Qm/wtUTH/w12XX3IoqeMTv7Fe1sgF4em5kI7N7ISYp3j3qYnTf/tjzL1nEluK600ywaGMnK2IT53zwg5fzJ7T8H5vnQ3UN/mnMEJwgHA0S27dErnK/lD2KF26Wo148Uj19omcJJdOWI42IFESX/jEwRnoVrD6pUyMmRN5Yz/VklWXOrbyXODUlA/kFjJmoLDw8s9i9/BMw2Y4YiDnN681Z10kcYc1uStxGc+V3j6AcAgAaTU2JYgABpJgIg5HD+OhkzTFrMofkiiII936QfVn7YpTI1sReH4gBuxQSmSiovwTK8eQ2aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n0MpSYIr5J1fRBtw+SGNTOLFgCBfLBPdkrT6vALQ8xU=;
 b=LPE4Co/aBt7pSbPOJjtye8FO+FL+7epNUs8sKGQfWEXrbizeEVbqA2ByTWRcMQgFM7IcN80DpYxItWXs/Q60XthRJqGkBK1HCm/XxfeePrCZty3SVoeJ1zV1LArQNjAqjcIApq7SovvdHEm++SejZmDZWhGLS7tTM+VcJWmuLtF30qhX1RdHOZHtcYcnsaRx044oG3X4trkQoVvsDZjRYaiUjCnENQbC7IaMYAJMcmt+fCNDaO6a0aO5wB7VSGZv2GXREwAlvJ2YsIUMDVq6oO7CLwEXaelxk7zg8R02Ddwzlsh3GjIgC8I6mTP0Jv3CDXKsL60RDhsGEu8vhwseXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n0MpSYIr5J1fRBtw+SGNTOLFgCBfLBPdkrT6vALQ8xU=;
 b=XWPays5nFA2H7KH1LQC0K4+ZE4kULZOtgvKbY2lMAy/Zl8ZFtN/yhUXA5/ec/RdS6rCsNZyYjansX09uUEDUmKkQVB5kWiOgnJ9HYCXgCgsvLLewMHFpJczcLTS011DzK+vroLEWY7VygJnqdD23BatFFaJtPu+1b65RXSpxqSU=
Received: from BLAPR03CA0102.namprd03.prod.outlook.com (2603:10b6:208:32a::17)
 by MW4PR12MB6756.namprd12.prod.outlook.com (2603:10b6:303:1e9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.34; Mon, 2 Jun
 2025 20:57:39 +0000
Received: from BN1PEPF0000468B.namprd05.prod.outlook.com
 (2603:10b6:208:32a:cafe::13) by BLAPR03CA0102.outlook.office365.com
 (2603:10b6:208:32a::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.19 via Frontend Transport; Mon,
 2 Jun 2025 20:57:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF0000468B.mail.protection.outlook.com (10.167.243.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8792.29 via Frontend Transport; Mon, 2 Jun 2025 20:57:38 +0000
Received: from SCS-L-bcheatha.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 2 Jun
 2025 15:57:37 -0500
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>,
	<alison.schofield@intel.com>, <junhyeok.im@samsung.com>
Subject: [ndctl PATCH v2 5/7] cxl: Add clear-error command
Date: Mon, 2 Jun 2025 15:56:31 -0500
Message-ID: <20250602205633.212-6-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468B:EE_|MW4PR12MB6756:EE_
X-MS-Office365-Filtering-Correlation-Id: b0c7d1b6-cba1-44c4-b28d-08dda2181b7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BWiS1rS6tiGUMp/TPCsvHih0iuxJhfVvc2mOkgTousLq22OPW2O91mezN46S?=
 =?us-ascii?Q?YLt90iiqp4Scb/BvR0mhFBzNDrXNwri6UN6sWWoZy/GbOoFmD8ZaJzJ1a7YT?=
 =?us-ascii?Q?L2Osfh21WKrUzWjJJ1wY4dDUxNfDT4I6SF3bv9RbBo77C2QOnFG9YHvjvzWJ?=
 =?us-ascii?Q?v2mgT+HpPEYruZlJY+5KFK5/DKXhkg3RCt7d5N7Z+WyXKdYvtc4g5JHZwYEh?=
 =?us-ascii?Q?oWyafm9cDN7Q4bCEYg6l5yZOG1Y1rE6XyoER3Yv7ndCfN8OnJazu/x6Ckvwg?=
 =?us-ascii?Q?PbriczxU22dNFndn7lX0YxbmcKjNeg/aTcaMbJa30u97S52fe6HSUKK5DfWy?=
 =?us-ascii?Q?umVgCoxjiJG4J42Q+J/SuUFezCLDtUwqyfOgdUrRVfIDmGXw5UHPU9es1NMZ?=
 =?us-ascii?Q?hhicU3ONqTgM56DIcB8eqafGRZcOc8Y4VWT9UNITlj5roLL0o3ZY5+nRH4Ti?=
 =?us-ascii?Q?Mn1oZISnCuCyAJw34v9cfhPnA99NgfB690z+PU3ME98otpkv2i9YYdS9H3Fj?=
 =?us-ascii?Q?5VL4FQ4ZrB5wwFJPjXIqDGbrVJkcXAi8dE4VV9qnPmtapnVRCc1P2bSWFLIQ?=
 =?us-ascii?Q?IBOqdNdQZNf3yUXRYO0xY+qrABYSfrVTv1Om2IDrzpPB5Pj/YjNZ58ftZmXz?=
 =?us-ascii?Q?fn+ZW/Q8ZkgOsqtrPCrAmMQ+wjrt0zRQqb79/FKl/c3RTZcwaUsMag9gt41E?=
 =?us-ascii?Q?DFfXmKSJ13Ny3Wul5+uY1Ja86zvBPmBl66xXbVvcMfhj7ROwYqKSBvCPwMHO?=
 =?us-ascii?Q?ezDXWtYbUH42YWBSrUHMlawXMXNKOxY3x6pawIUFXLWa5UtXTsCVYPTxELj1?=
 =?us-ascii?Q?rorpGeOnSygrA6I6Nk7lvEkJ1dW3DhZdcFNySWauskIbPsNGOfxg7dXDOr0N?=
 =?us-ascii?Q?1el2/Nnc49/hKzX4oT2F7YYkZPATqbseTJPuTSLkwKCbSgg+u8yHOQXoPfTy?=
 =?us-ascii?Q?0SQoyTlpHD+0iSajWyH45oSMqYNG/+5G/DraQbimQBQSQhpGiiNPn1ygzov4?=
 =?us-ascii?Q?eJx73Z0HdDX7+UuQ7sLok6oC2sYj57FVWa+gomIYYvHjaPQ2DUqz7Ienm6iL?=
 =?us-ascii?Q?QAIFa+GUym6gpy3sWv7n+SXkZ2K/eUstMGewoeNysF3TIasB3JR6E1R6lUb3?=
 =?us-ascii?Q?s8iS8AOdZGTeH8D9CRF0uaWniF/2DY+DMy5J5304rzfBWH+QybmMtwZaHCiI?=
 =?us-ascii?Q?xrDbbzKSLGInXWB8Aq8HWr1tNx7Mcx93+PJOFq/FBWisTXUCVMKW1X9I/USe?=
 =?us-ascii?Q?YkzhIUBOYgbobZO7agvFThfEzy9ZK/vJgcXOQmXx6b8tZUCwY5XUdAFKiclF?=
 =?us-ascii?Q?P+oj9kd1P6PbA4tvGQ5KltEvtiDcQzr8hYha6Kl9pcKsMBU+iqDQEBtP/lHF?=
 =?us-ascii?Q?FRDJndC3Q88EZQtO1jadF9mrkFkBMgT4jsdxELqJMI+T/J4ixTZqO79kkljo?=
 =?us-ascii?Q?ivRUGeJiGfTGoloXNeWLjl1fzbICmVswzL/th1goaugXC5WJWmQTxeaEtnPS?=
 =?us-ascii?Q?TEmLV9z7ucXCc+SEaqh2i6s4QKvgD+ffOsv8?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2025 20:57:38.0253
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b0c7d1b6-cba1-44c4-b28d-08dda2181b7e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468B.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6756

Add the 'cxl-clear-error' command. This command allows the user to clear
device poison from CXL memory devices.

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/builtin.h      |  1 +
 cxl/cxl.c          |  1 +
 cxl/inject-error.c | 67 ++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 64 insertions(+), 5 deletions(-)

diff --git a/cxl/builtin.h b/cxl/builtin.h
index e82fcb5..68ed1de 100644
--- a/cxl/builtin.h
+++ b/cxl/builtin.h
@@ -26,6 +26,7 @@ int cmd_enable_region(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_disable_region(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_destroy_region(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_inject_error(int argc, const char **argv, struct cxl_ctx *ctx);
+int cmd_clear_error(int argc, const char **argv, struct cxl_ctx *ctx);
 #ifdef ENABLE_LIBTRACEFS
 int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx);
 #else
diff --git a/cxl/cxl.c b/cxl/cxl.c
index a98bd6b..e1740b5 100644
--- a/cxl/cxl.c
+++ b/cxl/cxl.c
@@ -81,6 +81,7 @@ static struct cmd_struct commands[] = {
 	{ "destroy-region", .c_fn = cmd_destroy_region },
 	{ "monitor", .c_fn = cmd_monitor },
 	{ "inject-error", .c_fn = cmd_inject_error },
+	{ "clear-error", .c_fn = cmd_clear_error },
 };
 
 int main(int argc, const char **argv)
diff --git a/cxl/inject-error.c b/cxl/inject-error.c
index bc46f82..f8a9445 100644
--- a/cxl/inject-error.c
+++ b/cxl/inject-error.c
@@ -19,6 +19,10 @@ static struct inject_params {
 	const char *address;
 } inj_param;
 
+static struct clear_params {
+	const char *address;
+} clear_param;
+
 static const struct option inject_options[] = {
 	OPT_STRING('t', "type", &inj_param.type, "Error type",
 		   "Error type to inject into <device>"),
@@ -30,6 +34,15 @@ static const struct option inject_options[] = {
 	OPT_END(),
 };
 
+static const struct option clear_options[] = {
+	OPT_STRING('a', "address", &clear_param.address, "Address for poison clearing",
+		   "Device physical address to clear poison from in hex or decimal"),
+#ifdef ENABLE_DEBUG
+	OPT_BOOLEAN(0, "debug", &debug, "turn on debug output"),
+#endif
+	OPT_END(),
+};
+
 static struct log_ctx iel;
 
 static struct cxl_protocol_error *find_cxl_proto_err(struct cxl_ctx *ctx,
@@ -106,7 +119,7 @@ static int inject_proto_err(struct cxl_ctx *ctx, const char *devname,
 }
 
 static int poison_action(struct cxl_ctx *ctx, const char *filter,
-			 const char *addr)
+			 const char *addr, bool clear)
 {
 	struct cxl_memdev *memdev;
 	size_t a;
@@ -133,13 +146,17 @@ static int poison_action(struct cxl_ctx *ctx, const char *filter,
 		return -EINVAL;
 	}
 
-	rc = cxl_memdev_inject_poison(memdev, a);
+	if (clear)
+		rc = cxl_memdev_clear_poison(memdev, a);
+	else
+		rc = cxl_memdev_inject_poison(memdev, a);
 
 	if (rc)
-		log_err(&iel, "failed to inject poison at %s:%s: %s\n",
+		log_err(&iel, "failed to %s %s:%s: %s\n",
+			clear ? "clear poison at" : "inject point at",
 			cxl_memdev_get_devname(memdev), addr, strerror(-rc));
 	else
-		printf("poison injected at %s:%s\n",
+		printf("poison %s at %s:%s\n", clear ? "cleared" : "injected",
 		       cxl_memdev_get_devname(memdev), addr);
 
 	return rc;
@@ -171,7 +188,7 @@ static int inject_action(int argc, const char **argv, struct cxl_ctx *ctx,
 	}
 
 	if (strcmp(inj_param.type, "poison") == 0) {
-		rc = poison_action(ctx, argv[0], inj_param.address);
+		rc = poison_action(ctx, argv[0], inj_param.address, false);
 		return rc;
 	}
 
@@ -194,3 +211,43 @@ int cmd_inject_error(int argc, const char **argv, struct cxl_ctx *ctx)
 	return rc ? EXIT_FAILURE : EXIT_SUCCESS;
 }
 
+static int clear_action(int argc, const char **argv, struct cxl_ctx *ctx,
+			const struct option *options, const char *usage)
+{
+	const char * const u[] = {
+		usage,
+		NULL
+	};
+	int rc = -EINVAL;
+
+	log_init(&iel, "cxl clear-error", "CXL_CLEAR_LOG");
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
+	rc = poison_action(ctx, argv[0], clear_param.address, true);
+	if (rc) {
+		log_err(&iel, "Failed to inject poison into %s: %s\n",
+			argv[0], strerror(-rc));
+		return rc;
+	}
+
+	return rc;
+}
+
+int cmd_clear_error(int argc, const char **argv, struct cxl_ctx *ctx)
+{
+	int rc = clear_action(argc, argv, ctx, clear_options,
+			      "clear-error <device> [<options>]");
+	return rc ? EXIT_FAILURE : EXIT_SUCCESS;
+}
-- 
2.34.1

