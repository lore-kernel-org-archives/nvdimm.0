Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012026.outbound.protection.outlook.com [40.93.195.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8847119E97B
	for <nvdimm@lists.linux.dev>; Tue,  9 Dec 2025 17:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765300529; cv=fail; b=u+wO68mlTTohEg2AvJgOiGdDdoNTbE0Q7JTpVNTkO7g6AZsQqXKET4D1rfbDrcw0glYRdvG0rBCgYaZhBYJO8KHjrFVnNtoWCrYhPhZaSnr8x+mExQXcMvBDLwZM1xuJFEArifKL6X1Yemck/vKKuvuRImgyIxkPWz4RBXRs9AA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765300529; c=relaxed/simple;
	bh=sSCWMY4eOzPoF2mDIEFQ2oSNQZhU65fEALrAGnTULfM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KIrfLs3qCm6GXmGYUZQH8ZuQsoRCPedeJeVlpz34vtnbcMBcm0bDcicVwNmIgPzXSno7snsQfFQByMdObQj9F+Ya0eTq1o/z4/J3Pl78braBOw5ADurNP+akLv3YCiTz4eV+p3P5Gfk2RussZC938PWVoQ5uwGyO9PDLs1Vec/k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tyLKCQVZ; arc=fail smtp.client-ip=40.93.195.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tyLKCQVZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qD8RetVmgcdCnxjXj3oiUreZUnZm+u1m5ovWtNNtMW5KVUgEO57d7l6CoXLOrUfmMMSdSdIibSV5Z71DsjSbMoDTwidZI1hwZF0aQJ1cnajeBNj6nr3E2hduYYY1DPyF4iB2JbpamxgFfnJ6qjjeCHKBWcpij1xhRFRDsjWFGjGhcyNsXfoDPSGyBpWfW/Lnd8Xhbmf1SRcTUycNwE9rC4ETPvFrXMO2EK1puDtUhsz7uH41EAGjKAlISEjj3CDEp6pEl4XovVlaa93kMRTiiFZB6g/P8IMFWPRll3beCkIreOJM5JFBg8ipoTqjykrLROi1Kcv8mtGlMolTmJJJQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zFvVND/6GXGXAQFNED2waVIzWSZmf/HyqojyqeCVSn4=;
 b=vLEqe52qSgEYpUVAkxkQ0xlaIVle2eHW7q1Q4De9yR2msvjpphdmy0jOoFbJ/pTldbG2yoOzAJpOPIZMVHgXBKnn4WKF/njhX89fLzTc4FUY0U2/CGTibSW8tHx9RlsiPa0Vznyoz9+gxXqA0lpr8qJRp8yqP6dj6LVGPrLsu3ZNO+AA0uU+rdJMOE6/2uSr2vLxKjgA511xJBp4B8lxT0uoRIjiZ48Cl9lGVd9RxVJrqyv5g6IAsHZToqZgBPROWIwWP2PcpaSPrNPRQOhan0seVTx2F0hP8eYEGRxskFFatbD2dyqYc61BdUeHaHe2dOllUlo9UGRxQxlxkI9spw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zFvVND/6GXGXAQFNED2waVIzWSZmf/HyqojyqeCVSn4=;
 b=tyLKCQVZ/4/xTVYV8knbXw+56IOJtLY1P02TLJOL6ibvYjvxiMH38q0f2J+CefMrXsZe3Lcrgyio9uHCqXKSj9Zdg1j5NCLUIcC2nRiIdAToEsZI0hbQz2nVfspvi9ZW8avlfb8ryV4sgnfMjm4+MKDmyb9kjh2WvUXnbz8TbL8=
Received: from PH8P221CA0031.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:346::7)
 by PH0PR12MB7472.namprd12.prod.outlook.com (2603:10b6:510:1e9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.6; Tue, 9 Dec
 2025 17:15:21 +0000
Received: from CY4PEPF0000EDD0.namprd03.prod.outlook.com
 (2603:10b6:510:346:cafe::6d) by PH8P221CA0031.outlook.office365.com
 (2603:10b6:510:346::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.14 via Frontend Transport; Tue,
 9 Dec 2025 17:15:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EDD0.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Tue, 9 Dec 2025 17:15:21 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 9 Dec
 2025 11:15:19 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>, <benjamin.cheatham@amd.com>
Subject: [PATCH v4 5/7] cxl: Add clear-error command
Date: Tue, 9 Dec 2025 11:14:02 -0600
Message-ID: <20251209171404.64412-6-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD0:EE_|PH0PR12MB7472:EE_
X-MS-Office365-Filtering-Correlation-Id: 68087a12-a66f-464c-7ee3-08de3746889e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JXb+6oFbCh2g98G6qeut4SC9v/YfCyfSlUDOheyJjNPqtzmU5X6jhSXjtzSe?=
 =?us-ascii?Q?GKqDDeVPpQ4QwxrIdvzyR6r3r4RThLjaun9aAaO7U8eKwSfXZjkmWT8cJXCN?=
 =?us-ascii?Q?fIdm30VbA0g4LYsncCcC4ZJudMY8cLv5ZdMjVVyDn8Xx8f0ENTcqL4yj8427?=
 =?us-ascii?Q?t3tIOilV2K/6T33Kood5bOpbuRpl8VN7q34veh+L4bMbfHr2trzVYcVKsw+2?=
 =?us-ascii?Q?u2MyGIALJP46paJ3Ajck7cn+gTZ4GP11fyfN6nTuMLoGEMSEVMS6osPU/mnj?=
 =?us-ascii?Q?CGRw/F7t6JLnjCqQcsf0x06qex4L7b3NUoU3NQh+QPfJw9rITsTSi5zHWG/G?=
 =?us-ascii?Q?VPv4L+FmzHwOnt2ku/z43AHt0LHi869AQ+bvG3wna4APVu2aTjkUrlBRTBU7?=
 =?us-ascii?Q?ik2AepiavwohiJIIRvoh/DwFaVGKca25N2EepAoyiq11mONNiTf0AoGjtfRj?=
 =?us-ascii?Q?d1fu7cU2D+B4nRv+7ZnRprYQnvmB9yXy3daTAMvVY7X2VpM22X0MqqJnv2lU?=
 =?us-ascii?Q?cyXMFpEGgOy64zdWBhXGO3jFvT4ErF4hQbwW4QQF2fiXE6SiIvP0nUNnbknK?=
 =?us-ascii?Q?J2aXwVz5WTWn2P49eiLurnOmaAQs7j602t/wI7jK/vXNwZFPz4kz6ABAT9nI?=
 =?us-ascii?Q?e8r4+srP1Vil0OvOoXD+/+0anASopNqPBhoA1GK5JTPgWuitQZw9ZlOsBIE3?=
 =?us-ascii?Q?awFd6tDUeuIw0hU61fkC9fqdHtEJyMPRt1PgfMqX9iomEzRq0aO2Lq2SLpJ3?=
 =?us-ascii?Q?tgOdXGbU6X1fWaeeVZlUVJmGCjKKM3GEYRmgpGU+sSFjGuqSUhp9BlYKGVmM?=
 =?us-ascii?Q?MHiFybxVUu3wrpyhKRttLMgbWgRaxXEVE2K1RfI0hUuO2zxwP8nwDBcqD+jO?=
 =?us-ascii?Q?0Dq84NbvENRv0gUM3ytTFXV+0geAdbz9gKa+k9gV7hLbfP2aXAGsmUchyMgT?=
 =?us-ascii?Q?yjL2iDO3Z5P2mnoZ9nkF8NqRBtFSk2gfNBy7HOAlFbpHm+7AekeElokPIg+Z?=
 =?us-ascii?Q?SrQhawpM/aXvI9F4S+4lRd05tmjhOS44lFkmBu6DwOKeTJTJ/k+lSu/rdCe9?=
 =?us-ascii?Q?FVR8oJsTtRDO6QNrCCvqKgqBQ/hqM7sZOpbBW3MHng24/JGnJ46qDKACGHng?=
 =?us-ascii?Q?Z3BMgt7mRt0OMSwYhtltmbtj7HKZiDZ3PnURZ8mfcVG40ojb+KeD3mRRmVA0?=
 =?us-ascii?Q?89sHI6grttgHkdlQya53grBwLwuznuGILwizW+j5aEgaYw0r2Inrj1p0SRre?=
 =?us-ascii?Q?vTvjVlPA/gfcna4dirLIcfNVpkvBguvR375rJCilzKbYPxIVjv16ZwU+NW+F?=
 =?us-ascii?Q?NE1M/83qO/9L/6z3zRLSYUxvVNwCmIYXGIl9Zs+RLW6dNR1p7IpkinJSDjty?=
 =?us-ascii?Q?AeeAjgo3Eq+G87Tjb4INT36dA+/QMtbf1T6FNRWQnOMtwPZeIQZ35Fgw6OB/?=
 =?us-ascii?Q?P+NJhJVXeJShxRBelCsPtBEr2nZG9tJ/kwHmzlHCOAGENXVcZyjIte1DfmmN?=
 =?us-ascii?Q?D6XjfsuYesAFcOh41MQ+8uIGbsSXi1CjNxqQTvwOScyHKrDXDGtWc+hF1YYq?=
 =?us-ascii?Q?OV1jIXG+pirHdQK6Z1M=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 17:15:21.1635
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 68087a12-a66f-464c-7ee3-08de3746889e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7472

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
2.51.1

