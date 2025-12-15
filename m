Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012058.outbound.protection.outlook.com [40.107.200.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AD013C3F2
	for <nvdimm@lists.linux.dev>; Mon, 15 Dec 2025 21:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765834667; cv=fail; b=EoFsnRqYXchv4P8nIbOQyrj6N16maNC7/NYJ3RjUGfvPeqpsGwREoBrxhwfqbgX2Cn4yGQM5ErEfatdNzu50kpLScmVDxXgsqRrGajyNwA8xDD4nYB+t+nz/EcYzGqqc4JG4K3hUkaNj4tyK7KFY3uyVp5Kh0E1QapK7mbv1BC0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765834667; c=relaxed/simple;
	bh=i6KP0a3L9ihJEqYvN5AlQkIyhsRKT/lV7Uofjeg4MG8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QBeTd52yGDgCwWQQx50EezxVW+MeOlNq5zu6vGxJ2aRY04jSTcNUuae52ZQDHhJDf8FPGNdULL8PGlB07A+RIVauUfwuz0OUmGK/GpPFsQ95582wDJHM628hg4jh/Xbr882c6CX8Mt5kI4g1OeJ/WDYHAUTKW6ApMm556DFkZlk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IVnXHpcu; arc=fail smtp.client-ip=40.107.200.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IVnXHpcu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sl/lu0foC/tVp8nGaAHzEkX9MDcjqHQbWvPNmjFhT516NCFDCLKfVLEZD7UsyhYjIbprfoWLeMaYQ/HUGhBVGTHuLEHRI++t9o9+M/s/YiknzwOzK9MckTcmQt/aT1Tu63+H1oOVkkYc7MqthUu2B3/yhb6nLbxMDuazgW145bQ17kjrY1HDqCZHnifDlzQcpydIUwEWhl+Yq7FUj6RL0SZyVro3LnssK2bjCrZY621Ln6c989/OjySC8vSgayivzGO8JahVQ3A4mOevVcBaiOgl926BLF6DMaTqFZwpGidVLR4I7FT7COg7T5y6SlPjnpZEwOGKVS4kzcbipIpoUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=83mUYVeQVTSifz/p0GuauoORU0JyZvXGNZc4i9pcBlA=;
 b=vNRY5dXc/SamKIarzENrampfApwO+bsacL/IFYes88tBqD8YXrs0tWofIgwTeLIuF3WqKdzQHHOOa06paMw11lcPN/4J5bx7N2txh8kmE5JMXGxDjUGXv7AYfEAcD73JBdNq1S8+yvX/Vv/c18++UPqH2/fsll51HLR0vSPUclHrYjVXnnIwA+MabaDH4i775TG60X4Sah6ji+1/gKkAstWMZiuSMDjhXFV1kS33bnyWk3OkklFEofvACcXDrypvlXTMI1tcn0aSlef+eikB+EqWC7U45SCfR7XFwWz8EiKj5R6zmAhqlnxwdSnCRZJ88c8FCUP8my0XkF9zZGuGrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=83mUYVeQVTSifz/p0GuauoORU0JyZvXGNZc4i9pcBlA=;
 b=IVnXHpcuujE/bfqFwLhrkKqkOb6YFGlErh0qFQQjKzNRe+antdFHTeNWQR67lbpH8dcHGVVNiFnv9mimmGAEj0Pcm6TW6JxM6f3sOJjJMYQMZmekjl+I6DvaCUL3mbWrGiR2Pa10bDOc/794syl3CSVrnbxr8Aef9DCK/LWbFlI=
Received: from SJ0PR13CA0125.namprd13.prod.outlook.com (2603:10b6:a03:2c6::10)
 by DS7PR12MB6261.namprd12.prod.outlook.com (2603:10b6:8:97::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 21:37:32 +0000
Received: from MWH0EPF000971E9.namprd02.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::97) by SJ0PR13CA0125.outlook.office365.com
 (2603:10b6:a03:2c6::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.8 via Frontend Transport; Mon,
 15 Dec 2025 21:37:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E9.mail.protection.outlook.com (10.167.243.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Mon, 15 Dec 2025 21:37:31 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Dec
 2025 15:37:30 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>, <benjamin.cheatham@amd.com>
Subject: [PATCH v5 5/7] cxl: Add clear-error command
Date: Mon, 15 Dec 2025 15:36:28 -0600
Message-ID: <20251215213630.8983-6-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E9:EE_|DS7PR12MB6261:EE_
X-MS-Office365-Filtering-Correlation-Id: 828e7126-8616-42b1-28ee-08de3c222705
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Jf77rh5tfaY7ge7jhKwWc+xwcD+tmYefw7ApygA03/YBYxIeDVO8ZU6zpCtj?=
 =?us-ascii?Q?9casJGvGmrZWfLdjjnppQBNnjp+/Ey4L1qvRgr++sFmbt/b6GMlAvtKDEWsM?=
 =?us-ascii?Q?Mn5g52NIQsMKM6U3/4qdirD2dsGV4s3Ja/KQo5VwU/XYP+iipRckASTy0+0f?=
 =?us-ascii?Q?z+1nd5/v+HUF6N1+CpxbSU3H1z3JobQpEKZJjTfsl0Ta1mIV0l2mC9cvHQeV?=
 =?us-ascii?Q?l5qdwOH1A1Q7HBp8ndf8X/CGuUZHYX1uzGrHk/Q38Rjl35erdrC5aqW/5GhH?=
 =?us-ascii?Q?6Eq+LceKVEQeeBD/bwUBCugfidmntm5n/tAGo9fnyZeMnTCTsSMBAOkO3dFO?=
 =?us-ascii?Q?WTIvld7sfSRNv4QSJKCfwc3FOXa+SBPNtjbqy2Pq7f62dVx8CFVUi3ChpwdT?=
 =?us-ascii?Q?6jWDSdBpEZSL7Gz0rqP7cZNH8FPG6/xXZXjxKXg7YzujsFJ9T5nFpyhEiSmP?=
 =?us-ascii?Q?zTXmfPuyZAEEK3bLqeLEVjOUksGB4NE+SNK7G9mxSd/qr5k9TkwY0n0JQxpZ?=
 =?us-ascii?Q?7L/p16lyZewG4h1PvRqZBsebBICAplZ5pRd0ysIXKjWti17mfUUwUK+t6XkM?=
 =?us-ascii?Q?nDAWxqVRfQkAPVk/6QxXqirpDIHvvWQvRO4dEzTc7Qu0kEPcpJMyVAvRPO12?=
 =?us-ascii?Q?8IIFEOtEEQl/Ft5oqJGATETAXAKkoMrahJ31J3q9Bt6TlZ17kkore0A+bW3X?=
 =?us-ascii?Q?vublosxQaaaHEyFlTphkkVcJcDIgh5auI5X7lsWt6Bol9pL/HHjyPxisqLep?=
 =?us-ascii?Q?bMKAhvfH3Q5Tdl7/bDqmbjnb+uRxbnvhDCmTwVJrBKY9o8anTQcnQOPcTQ/a?=
 =?us-ascii?Q?9EGxbTJmFsXYuHMYC4pKmc0IjpRHg2Ax+e1f6rT0smP3ymO7j5inF50gBT4l?=
 =?us-ascii?Q?U6geucVRDmPc/U752x4kNfS9QSguqqDyIDxSEURj+CA0snqIPFphhAoHNByQ?=
 =?us-ascii?Q?m9RVwEQ9Gt7Nzs7D7AlukUKF50amABn7Z0uuFXZBfl3s5NnaSXdO8BJZsO5w?=
 =?us-ascii?Q?drSo79/JfWiIgJWQe6dL4ZQsGBJbA26AqZ7XyM8RUPjS/E74fMQ6Q3GVmoRt?=
 =?us-ascii?Q?MpdXB/XOJgWqkkbAQJ6VGbs4zyvH7faXjmv6eSzmKAlSY9F/vVT7lkMVT7mv?=
 =?us-ascii?Q?AnhLPnlsADcvTWKSUQUbuoA46yIXzdJSSQIMN6RLyRc7Uv+yeGngkwyQAUHi?=
 =?us-ascii?Q?y+ouiZYdoComVf+Wkp0R1u+iePMNcIhFCyXHCeIW2vOW+8pWjJDKNMG6tgpZ?=
 =?us-ascii?Q?z+5bkKUF9+jTT2w9RyyxUhSFUk2XEyx5QgGmf5++Tvdo9t+i0upZVgpa+8pI?=
 =?us-ascii?Q?c05NEgieKX/OwiBv+Quq+NjPdDBCC7ov+z0arMTKkx9M9WOIbNQwF9biuMxa?=
 =?us-ascii?Q?U34hiixkyM0Q92zWLuZ3jFrl83bbFDsN7kVc3YuQcnTcrOhJos2nPi9+ftDc?=
 =?us-ascii?Q?nP3VVCBzEl1mC6E6jse2rdfCryeyZE/B1tJ2G3dO5/FAkV6SDxSNhGIjckue?=
 =?us-ascii?Q?fZBW97Iy8sEwghKeMKqV8pwgP2dppH64NUU3qZFzQC1GEnO1pQBj+RvFj4Da?=
 =?us-ascii?Q?aZhe60Qwm+9wFMCTm9c=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 21:37:31.3063
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 828e7126-8616-42b1-28ee-08de3c222705
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6261

Add the 'cxl-clear-error' command. This command allows the user to clear
device poison from CXL memory devices.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/builtin.h      |  1 +
 cxl/cxl.c          |  1 +
 cxl/inject-error.c | 70 ++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 67 insertions(+), 5 deletions(-)

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
index c0a9eeb..4ba3de0 100644
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
@@ -102,7 +115,7 @@ static int inject_proto_err(struct cxl_ctx *ctx, const char *devname,
 }
 
 static int poison_action(struct cxl_ctx *ctx, const char *filter,
-			 const char *addr_str)
+			 const char *addr_str, bool clear)
 {
 	struct cxl_memdev *memdev;
 	size_t addr;
@@ -129,12 +142,18 @@ static int poison_action(struct cxl_ctx *ctx, const char *filter,
 		return -EINVAL;
 	}
 
-	rc = cxl_memdev_inject_poison(memdev, addr);
+	if (clear)
+		rc = cxl_memdev_clear_poison(memdev, addr);
+	else
+		rc = cxl_memdev_inject_poison(memdev, addr);
+
 	if (rc)
-		log_err(&iel, "failed to inject poison at %s:%s: %s\n",
+		log_err(&iel, "failed to %s %s:%s: %s\n",
+			clear ? "clear poison at" : "inject point at",
 			cxl_memdev_get_devname(memdev), addr_str, strerror(-rc));
 	else
-		log_info(&iel, "poison injected at %s:%s\n",
+		log_info(&iel,
+			 "poison %s at %s:%s\n", clear ? "cleared" : "injected",
 			 cxl_memdev_get_devname(memdev), addr_str);
 
 	return rc;
@@ -166,7 +185,7 @@ static int inject_action(int argc, const char **argv, struct cxl_ctx *ctx,
 	}
 
 	if (strcmp(inj_param.type, "poison") == 0) {
-		rc = poison_action(ctx, argv[0], inj_param.address);
+		rc = poison_action(ctx, argv[0], inj_param.address, false);
 		return rc;
 	}
 
@@ -187,3 +206,44 @@ int cmd_inject_error(int argc, const char **argv, struct cxl_ctx *ctx)
 
 	return rc ? EXIT_FAILURE : EXIT_SUCCESS;
 }
+
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
2.52.0

