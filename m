Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010022.outbound.protection.outlook.com [40.93.198.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C261D35E551
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 16:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767974862; cv=fail; b=eRlQmHB/wcpvJvQSYZTO3jhAnLOODtWA4GMqQfte/Gktw7WLgWR9YHeDs9QwPUPBfOh0oxquVU/o5SBTe65EQh5ud6fj4ZVj4pkQVH00nb4kfsTqYJggasdgDtBwhDzW4UKfLnSmVb64J42FkkdTCe0/ghRAxk84JNVSRh8IvCw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767974862; c=relaxed/simple;
	bh=Mo7mznKccL5u8ndf392Hf3sglRugGNuX7YxDC/tBMos=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nSigw4rJSoq0XUF/wnMbjyUgowXWEO8IeU49M5E1tFHKMQUBErlqxvGAsQVf/rQBn5IiIXVStpLL6A+LyqgZC2N4YRcpbNv58YXMO+iuW1/DDaqopycThKu/bW5KLO8ZW1PmWKOE41gxu6+4JJuABPXmcLB9vxCOtgvW8VkAdbw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2kDqgaD8; arc=fail smtp.client-ip=40.93.198.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2kDqgaD8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rptd2nK1W9nXQDPmTRTa8EfpBaogfQQDH5GykWZ1bmkjY/xcZ8YdTe4ODtpNjKJ3fTYgIBdQpYD0q/SFkaQw7SFIq71CoYZDVctNixCz/N6ZndtwgrDF4XRuH3pqWQraB0aPevWGHKBclDQN/XvJSkYQjGAjelG9CFnjEiPoenI9h/qfi3Lpt1GdYEf2xSFMR3UM1hXx6uGSmwEXCEWF7W4V0/Ul5CH/2fDwwBYQ0Raj1JKUGPOYFxiT5un12IUQFVS8mKAxh9bHcKxe+isiYrN3LkKLlYwXn3fCw3YlSfsYVJFzichLG66itx6ac+/FiTLp4FOsxgmc+W/l0alJsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RuqYm6KVsX73VbmrdnBTbbhnPpH/zf9VMDVCppMJWYM=;
 b=HpbDuhTmFndsLdbkBcpYhJRw1IHQfPCeMdZzNzhAidp7dn9rMYx7LJojco/JqoVxEFBdF4nFNd02yS43ti2+6XW1Rf8S6nuQt9ApU2AyzyyJe1PDyL2gRm1TLT8YuN8rttGNOMUkD1GLfNoZmwwIzX/52CzL9xykUDjZkJdewA5su434f1Nbea/TQVC6bbrfxZGOfrYxfoXPIM1cvxskJu4EYmmYxH+HSVbO4Qq2hNPWT2L7PCdXp6I/mustRRudHbNIbqGQ5eRzCJe+Ml1mfVq0Z6hViYsodw0rjOKV3LTvMY69oJRbm+hiNaT1J61V2RfBBl8wLSAHxQvdppckTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RuqYm6KVsX73VbmrdnBTbbhnPpH/zf9VMDVCppMJWYM=;
 b=2kDqgaD81ri4jlXC2PwqXa5IZAYa4B29NIxNDE7N3ARNLx6AMqeavjwqgd9yFq/ySQW23si7d1vLHRdqHla167xPmkcfsK9wUFMeA8sO8GOn23ifWrtTM9TPZCANOJPgSchSrsES5mw68xE/R3RBOyOe+g+iMAdn9W0ikhoaTgQ=
Received: from MN2PR13CA0019.namprd13.prod.outlook.com (2603:10b6:208:160::32)
 by PH7PR12MB6905.namprd12.prod.outlook.com (2603:10b6:510:1b7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 16:07:32 +0000
Received: from BL6PEPF0002256F.namprd02.prod.outlook.com
 (2603:10b6:208:160:cafe::c2) by MN2PR13CA0019.outlook.office365.com
 (2603:10b6:208:160::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1 via Frontend Transport; Fri, 9
 Jan 2026 16:07:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0002256F.mail.protection.outlook.com (10.167.249.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Fri, 9 Jan 2026 16:07:31 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 9 Jan
 2026 10:07:28 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>
Subject: [PATCH 5/7] cxl: Add clear-error command
Date: Fri, 9 Jan 2026 10:07:18 -0600
Message-ID: <20260109160720.1823-6-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256F:EE_|PH7PR12MB6905:EE_
X-MS-Office365-Filtering-Correlation-Id: ec3025df-404f-446f-856a-08de4f9931c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?znidFP5Z7m/2Fn/JrGFVkBVojng8DizeoAu6hOESCXa904/bTnDsk2iG0eVx?=
 =?us-ascii?Q?2tFiYblrOhZSBUZBprpv+lNA9U453/RxDxMeKGMgQja1nU3174wnCmU7I11m?=
 =?us-ascii?Q?qvxwoYXPMI/WbU+usrCnQS+P3mTCF5vccB+n3eh1KhV/eHdGbBTlgnjmh6q8?=
 =?us-ascii?Q?P1r2AKF+9APwGGsm1RLwDUuvzmAUZdvM/6LSIPpycstljYBAgaLKrwLaSIlX?=
 =?us-ascii?Q?srHibolR0CmzppCpVRFqI7WDAmrrntNQDVosJNqPbQT2uK12/tprSTRhsXnt?=
 =?us-ascii?Q?txdxlhOEd961eUVHnIFY/YoGHHnLGb6Jd+Be+m0PCaPz2C1kUVmB8x6+Dfpw?=
 =?us-ascii?Q?hc04heHf6lB/Be2NvcCd4SL5EN11sdQenNbBbNRDF9/IgGhHWpXkkBsKE5Pl?=
 =?us-ascii?Q?o36Z2079bHvB37bDc3UoyRT5Q/X6v1ac+Aja8jpvHyfRaAtDEjTmZuBwRVLh?=
 =?us-ascii?Q?jFO9MHSjnoDWJSSKUGW3JSw+/yNF04la/3XkACPw+9ITN3Ja39uTCLL2wyQI?=
 =?us-ascii?Q?GcRr0r+RoQAWdiMehAy1FtUKUsGxHWRUlEvCInzW/nTP/m0KqFQsHp3xmeho?=
 =?us-ascii?Q?TM6DS5SdGuEaP4xu3ObJPP+UuoVJfnp/sL8rXI8BNHlJgoHeImtR0XVLMIOe?=
 =?us-ascii?Q?ZjIK+Y3FGSLZHEtumSUo8grBzxp0IEYWADGalLc76jbuumtUq/NyKIbV811E?=
 =?us-ascii?Q?9hC77kW+ySfWCfevxDGJezuUnBFe/RrM4Omp8o/Bv0B9VtgS5NBY39lZCa1s?=
 =?us-ascii?Q?cItjoytpNlrGEvvSGfU+AboQfJ+LPRLxJEqUF6pkhu7HKcMPE9Az4wEKHbYe?=
 =?us-ascii?Q?UuF5HUiO3ARcOMDjgBtMyn1roHOl6AI2xyuRT2FULNJllXKlxQR7A2Kbt2bn?=
 =?us-ascii?Q?1jVGp8EwHxUkp46Twk8A5YWeVzOXX6sL8iqLpX0N/48JH/FqBUJDA2sViwgI?=
 =?us-ascii?Q?NYfSWIuc4yvKHqUiz9AJaAfTtQrev76MYgy59uG8F7X4xyjH9jNSaB4E58p4?=
 =?us-ascii?Q?r0S4i0wZAJlQvXitdbylX+CD0tIjqjCvi2arXNNUYH8x1zi86k3slft21/zx?=
 =?us-ascii?Q?96CmC8WD7oYVdl2NTAANOLxoYREqL/7ku2w2SYetRTa1/Au46oN2CxK5QsI2?=
 =?us-ascii?Q?k+XUyv9N97lGlQMpiOpnh5TTCL9g0AP62zHhK/XxHY7O8sdM+uNqPsr7o+As?=
 =?us-ascii?Q?EG+8wMtwVhkoQcTaFGqlDxYlL9nUhucUVuEg2h4D4TtTqCwsac0y+WmLN3RJ?=
 =?us-ascii?Q?4KItfTtK21eVab2YMbZDK7aTlIGxGrpcFD4BpS//tgSq/CwHHB/WZnfSIDfz?=
 =?us-ascii?Q?XZzePCz5uK3/VFcaCfR5wf8h6KmrCvv83lhrnVyNVt5T/nIt0+463SbZO1i2?=
 =?us-ascii?Q?fKn7eRVEj64tboWsX2kFzCCZtkzKq1skDxVcSwAvacqkfQVxclwd6I16rUkM?=
 =?us-ascii?Q?5w12imeaEEWwxCS/68Dhu8lAa/h48EP8Mm5oE3KfnbQ1ywLdU/O4KlqiRFd0?=
 =?us-ascii?Q?tphwbYZ7jZ7QeMUPibGr3+hYOXi6nFIfeN+WkYS1UNm+FZH4y+8EuOKTTou9?=
 =?us-ascii?Q?aB09np1Rp/PESA3XUUw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 16:07:31.6311
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec3025df-404f-446f-856a-08de4f9931c4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6905

Add the 'cxl-clear-error' command. This command allows the user to clear
device poison from CXL memory devices.

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

