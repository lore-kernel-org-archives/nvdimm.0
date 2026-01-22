Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012012.outbound.protection.outlook.com [40.107.209.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FBB24503F
	for <nvdimm@lists.linux.dev>; Thu, 22 Jan 2026 22:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769120081; cv=fail; b=BGQI+5dCBLco2Wu162TrVOiSl51yX1CaFygmQDilwf8gatNPFOLcM4nZFm40Nc/neH4bboCpWgq88IdmrUMBhPn6+ynNOtYlLuOmHNy2Pn9IryDbEfR13YT3rDOPVmtjaJXvvsCXLLnBOO2k/UeoRCuJ2m2gCXQDVa0I6rNJTws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769120081; c=relaxed/simple;
	bh=IIDwwEOac05Ogkwm/3oIN7KZnCfzjump9c3rTssj6p8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aQn2l26zLo0g7hS3Lj/u2FWqCCBhSJOqkB4pSUd/GFwVxX0SEprtQwsUaI532J9DUHTZRwaGQcc0d7Opfil8rzxD6Hl4P5KtrpkQ4wUC14WiqOv0QOyS/j1EDTzLlNRX1/Bp74NciS8sGOA+rPHrF4PNMZwDn2eFmSWau8esA/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hc1S+lHI; arc=fail smtp.client-ip=40.107.209.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hc1S+lHI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sHMJUbyni+Y0oWEc8LIaDWxrkhQBFsvzUK4+dO0Q8/HP8ShCBAKNpSXhXUY44pX6bOGB15lVTeVDdUNMgIU2BInnKZG3xvaDi+qLnA37PRDIZR607cVsUo63pM05KTjKSEj637eBuE0Z3WvRVraC76lcVbfKmfwy9+M9tbR1YHW8dVkn7Ex2u6tkf4VJRBmQQKRGZIrcaReUV+T/W4G0oCwSjJgBpaqyLJ4N+iBQ/gYH4m7XT9mmLp40sLt/m06YAcWKWf1JD6JuE0gKlp2xP2f3rbaZDD7/yPIErwh06nj7PsRxC08c+lAkxuXkS3Mc/MxVgfltVdEvRixfKM1EOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cj4hWY7XKTtdHnKbGaMu57lxL0a4kACDUJEt4/Gf2GQ=;
 b=OSZ2ShbcctmbW2yl1cLQjNr0l6qIl5OTpUdSRexjx1N5WrFqRLB3aqg6KjAHXdUa1JweoLqueFVRJPE/+pjsR6Pq8VHj2uF2bhn7mfb6vz8s6AH8eF2ySF3QeOvBgcFNOWjpyQxI5tzwGTFbaVdCLdtCCiIWhhIl+QzACgikU7nR9R+AOHFQ77D6j3OXCFU32jGeOdkZjJLN5rhTseuhDW48Wg7KDY6nM7lu/HB3IZQ5+TjEIanzLweZ2+WJEgsfUf4N4VhvqzHlYrVdIIvzGW9Uf+a9Lzr69sTsZb8flK6kKiGjoDnrm/jJqflRJndKbOobpKo8JYHYoXWfGuB+QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cj4hWY7XKTtdHnKbGaMu57lxL0a4kACDUJEt4/Gf2GQ=;
 b=hc1S+lHIDYL7sqXEjSH13AwoQoqQUWEePu5lBiX5Zj2Tp16iIxSLPkJdwg+3G1r7nSFz0ahSoMWQ6+Ca/hORP7os++J+wVAwbPXZINAxOYOmqGl/DtMJu8sLDm4jbMgfWh0SG/OcB0cxBHvKISGI7wudyvHDNqXPwCKFpHe34K0=
Received: from SJ0PR05CA0012.namprd05.prod.outlook.com (2603:10b6:a03:33b::17)
 by BY5PR12MB4067.namprd12.prod.outlook.com (2603:10b6:a03:212::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Thu, 22 Jan
 2026 22:14:27 +0000
Received: from CO1PEPF000066E8.namprd05.prod.outlook.com
 (2603:10b6:a03:33b:cafe::f3) by SJ0PR05CA0012.outlook.office365.com
 (2603:10b6:a03:33b::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3 via Frontend Transport; Thu,
 22 Jan 2026 22:14:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000066E8.mail.protection.outlook.com (10.167.249.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 22 Jan 2026 22:14:26 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 22 Jan
 2026 14:37:37 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>
Subject: [PATCH 5/7] cxl: Add clear-error command
Date: Thu, 22 Jan 2026 14:37:26 -0600
Message-ID: <20260122203728.622-6-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000066E8:EE_|BY5PR12MB4067:EE_
X-MS-Office365-Filtering-Correlation-Id: bd112cd0-c0e2-4f18-0b02-08de5a039aff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5GHs2lAMoNYqib7fbv+B/Dti7G9RirfROIc+x5eMnwdvFZCbrIEkWdCHIUr4?=
 =?us-ascii?Q?doMf4cw79Rr3HDhh+DKScBG03qjOaUAIP+5s4wEAvMJEZLXhim31ThidAY8M?=
 =?us-ascii?Q?DzylXtL896nHdjrDTzvIFSE3mHQVv4Q3ZjknEgEBZB9pdGHCAk30XmBZkxYG?=
 =?us-ascii?Q?ia5lY7F7Lfsb58aJ8wNIDHif4qTdD28TXNG/Q+rUBJ3c/or8hNEONDK/A3yh?=
 =?us-ascii?Q?yBzxmNN+zeVVa0MpoJgERkZgBLI4WqAjeTa8uXTzZkLVNWl3RatrVJuts+/T?=
 =?us-ascii?Q?mqVHxY64+1QaCz58PaImbhxEOq8YMnyiKGab1GkfHJ2Tnq8Vavyzqi69bDdf?=
 =?us-ascii?Q?7A1fHnwx+xCIlw3xR8BqjOcowQrV/b58RZiDaw/eX64um1qzNa8X2T6YFaFj?=
 =?us-ascii?Q?bWMcXGiwvMevcugwyBwh9VYmX1mG4Li9BDDTL7ys9/hatiDBvgEIymEaqi89?=
 =?us-ascii?Q?6KmoQXR7RhvO+oSXkZ1/zzw9XE6REIUqt/hg0IYIeg8AKn9rZM790PcsfLgT?=
 =?us-ascii?Q?zBokqLHe635lGMfVu94WrIkSwrDAqKMpZuOxVbIYNd4j8CpAMx1eo5/glLt1?=
 =?us-ascii?Q?RfR9hD+KAN3vjT7Zk6eIQJSwAFmU6OauD+/OmF42sEk82BIBOXrkqYrWsIhH?=
 =?us-ascii?Q?n/2Zu3jOAxXb+82IaVx4dN3UhV2oh2J6FNrLQ30XRxK5zJ4XcKj6NnexMjhn?=
 =?us-ascii?Q?3hpulodXInXFNAXqNybvWVbXYFzuVSkiV2yhc5Cin/Rof5qHHiYuVRn26sLL?=
 =?us-ascii?Q?HZfoPPPnrkZ4kRqBULj0MrXxeODa+CcalN7uJEoRsX4CQd4G49GNYeznPJgT?=
 =?us-ascii?Q?jRvBCeiluHhQ/yDmPvBF5XNrem9gAP42qGwlPlGYNCHHrDCOvcVl2Ae6qFtF?=
 =?us-ascii?Q?pgvmWMVWTW+srvagERZO0BfeJrgPXjf9PQv+cxW8EYmleyGa4Ij5j378abFY?=
 =?us-ascii?Q?bzA04F0kRns7YvTLgwYAEbhInlkwKGWSiNIdpdBHFUarr2ojbuOp9oUmyAs3?=
 =?us-ascii?Q?b5pMh5Q7YGUKZX9rhM0VtuLIE1oobJDyd2SOvdZqzrDnH8K90iEMFaN1vJT/?=
 =?us-ascii?Q?AwM/yfTAebNHQSUKIHkMV2FSyZr+cUuNUpOiAJGndaGw//GB1KqlWYEbV8nC?=
 =?us-ascii?Q?LMcSEvmriVjIIo0uUOmisdMbAKkGVHjN3ShVXjT/pXxFScCoaLedVEtP02Wl?=
 =?us-ascii?Q?miaqWTtBrSLKh6BXv9aZ2n9esoVHEkjdY/VQn2+M+lEfjroB8jUyVAlkjere?=
 =?us-ascii?Q?JKpZqrZPgX1JIfttuzkw+Vvgw7+e4WU2kY6uSG7LDKD/ZBpzCW0laPGfMc0q?=
 =?us-ascii?Q?0vaV5Iy5G03cRjdG3oQM2X+1Y05vAs9bRWEtSwGLuCTnk+NbZ1bJrQJg2J2U?=
 =?us-ascii?Q?MPFFO6VdfvkU1pyPmb0Z138bThX+s6rdTCVlP3LQYN5l19GK1Wephin1v4NF?=
 =?us-ascii?Q?LurmV63NWmw4PqecepTv090uI9U6CBKLGufgGNn0zc3cndo5ybRjQZQSHSSu?=
 =?us-ascii?Q?OWqjXSNS3hL0m3e1y9RkdwX0pUw4WlYFbPfkSAsfz1RDhj8/hcWhMceYo0kH?=
 =?us-ascii?Q?iVcBJOOm3QZtJIR8fNFNjgzyMvUORY2ZFYAlIHXkPgNwnbGoKWXa+B3ANYHd?=
 =?us-ascii?Q?w/DPEiGVWkFeUioq7jZjnOcnp4KH2bKQpyv6+l+z3r73gfsoqZYXb77uKMYs?=
 =?us-ascii?Q?giVTOw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 22:14:26.3651
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd112cd0-c0e2-4f18-0b02-08de5a039aff
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066E8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4067

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
index 0ca2e6b..76f9fa9 100644
--- a/cxl/inject-error.c
+++ b/cxl/inject-error.c
@@ -17,6 +17,10 @@ static struct inject_params {
 	const char *address;
 } inj_param;
 
+static struct clear_params {
+	const char *address;
+} clear_param;
+
 static const struct option inject_options[] = {
 	OPT_STRING('t', "type", &inj_param.type, "Error type",
 		   "Error type to inject into <device>"),
@@ -28,6 +32,15 @@ static const struct option inject_options[] = {
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
@@ -100,7 +113,7 @@ static int inject_proto_err(struct cxl_ctx *ctx, const char *devname,
 }
 
 static int poison_action(struct cxl_ctx *ctx, const char *filter,
-			 const char *addr_str)
+			 const char *addr_str, bool clear)
 {
 	struct cxl_memdev *memdev;
 	unsigned long long addr;
@@ -128,12 +141,18 @@ static int poison_action(struct cxl_ctx *ctx, const char *filter,
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
+			clear ? "clear poison at" : "inject poison at",
 			cxl_memdev_get_devname(memdev), addr_str, strerror(-rc));
 	else
-		log_info(&iel, "poison injected at %s:%s\n",
+		log_info(&iel,
+			 "poison %s at %s:%s\n", clear ? "cleared" : "injected",
 			 cxl_memdev_get_devname(memdev), addr_str);
 
 	return rc;
@@ -165,7 +184,7 @@ static int inject_action(int argc, const char **argv, struct cxl_ctx *ctx,
 	}
 
 	if (strcmp(inj_param.type, "poison") == 0) {
-		rc = poison_action(ctx, argv[0], inj_param.address);
+		rc = poison_action(ctx, argv[0], inj_param.address, false);
 		return rc;
 	}
 
@@ -186,3 +205,44 @@ int cmd_inject_error(int argc, const char **argv, struct cxl_ctx *ctx)
 
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
+		log_err(&iel, "Failed to clear poison on %s at: %s\n",
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

