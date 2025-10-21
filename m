Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012051.outbound.protection.outlook.com [52.101.48.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619EB34D902
	for <nvdimm@lists.linux.dev>; Tue, 21 Oct 2025 18:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761071587; cv=fail; b=l7xtOXwX7GlUOUDw1yAiJvfiZ+v8poMmtKZz7ZxVA+YiRPTeRQxTTwMVWqULNqWmCiHMRV1MB7vMXwq1CpHN3M1IxqkdZ8JpojGKfDdAXMdooUzzm9HZ/mRB/JeLQhGf8QxLs1gayjk4T4w8sSttP6eVgoVjE4nGYtFeraD6s60=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761071587; c=relaxed/simple;
	bh=bbr8CXS1Qxd5LCoie9ltNleUurZvmePZX8dJ3AFx0+8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=beYwi7Q4ILVob3X/+rfGchShfaw1h4js+msfTxpvvfeKsnwIf45ZGijq3p7FVofX7W79LxWQiJKUwCf5H7nQuEOi5MUeoss0gEqN6g+tTgigg7tvGBFjZFvTzS8mlN5fkXCld9OVhV8u2mHNqv+UCi03aqNsHLQ0oQyK/ol1Cpk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DoiLeAK6; arc=fail smtp.client-ip=52.101.48.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DoiLeAK6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u2Gxv51m1thJSsXjDYUyiUyLRP0u3KyI7NoeZSlDwA+Bd8udYyUx1yxSYgLIhGOwcUD8G2CXc9pGGK1NyJM39M7DLMhz3bvrddR2TLQl9iCQAi50s5dpmH2ysfWM807G0iMDTv7Av+I7brq5Xak+apWeuxgG9qh2mGMI/EXoG3v8ytashU19Wje3WUm80nRxZzBdsKyHsjzYaQ5YlDYjp713t7eh4BD8SgsRmSrCT9oxy6EP/WiWrJP4VUG9pvBQ/NjZHVEY+0/WuCJpRo5mnY5gPwrEn9Uh0rRHVLE8eGc9MTHvNLswLm+L1GrVZfZDCBgeBjLKoXhWksfiDc8XOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NrezgD37hSNiXkMfXNF2uRneEyEmSP/dUYpaos9FYSU=;
 b=R1iz0SUQtp168uLMKwhBTayevc9ZQlJHp2GyCWDhL/Gpip+DegcTUkfH5fhDQ+6QsKjaoPIhGVQdjmTlfYvA5b/G81bcIAT6FmvDqc7S+Hqq7jgyekQzgPZedPikZLQTl5pcFYBJz/jTeAXt6xjW9/AqIfcGZ4BprsJFzXLvfyLe2OMzlA8F+PQBlyyJXQP66VUsJ2fK5GzTXT9zXYgf+sNtYggQhLWweVdoSoPPMafxBbsSURh0BEqwRqZEX3XHH5ghOSnRghfuGd4CxxTIXXFRePIMEEiPYxGhMMuMEBsKB8SkTNLwyTmT5fjju/WbPm2CSOGIbnxAK/YiShyCtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NrezgD37hSNiXkMfXNF2uRneEyEmSP/dUYpaos9FYSU=;
 b=DoiLeAK6J2JQ/kWt19EnKtDkTqrIyEId9xB7jFFsQZfRf1e/1WzPBImHa8udBmWQUTFS6iqvmYAiRUx+6uGb+svxLVrHoI4zlLegaBCkCbZq5lJteiZzZICk9NIhjjhUK2L/CKH8cm0E5dzLk6dkhIfvEXQ6iLn2iz+7ZZLIjbI=
Received: from PH8PR05CA0008.namprd05.prod.outlook.com (2603:10b6:510:2cc::19)
 by MW4PR12MB6778.namprd12.prod.outlook.com (2603:10b6:303:1e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.12; Tue, 21 Oct
 2025 18:33:01 +0000
Received: from CY4PEPF0000EE38.namprd03.prod.outlook.com
 (2603:10b6:510:2cc:cafe::c7) by PH8PR05CA0008.outlook.office365.com
 (2603:10b6:510:2cc::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.12 via Frontend Transport; Tue,
 21 Oct 2025 18:32:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EE38.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Tue, 21 Oct 2025 18:33:00 +0000
Received: from SCS-L-bcheatha.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 21 Oct
 2025 11:32:59 -0700
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>, Ben Cheatham
	<Benjamin.Cheatham@amd.com>
Subject: [ndctl PATCH v3 5/7] cxl: Add clear-error command
Date: Tue, 21 Oct 2025 13:31:22 -0500
Message-ID: <20251021183124.2311-6-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251021183124.2311-1-Benjamin.Cheatham@amd.com>
References: <20251021183124.2311-1-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE38:EE_|MW4PR12MB6778:EE_
X-MS-Office365-Filtering-Correlation-Id: c372c9af-a42b-4c0e-b6d5-08de10d0438f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yq11GABZe1cXCPfOm0QonAsKYQsQ/NQ8z6Ez1G0/HkRXw73fwb+5TO1MGHU0?=
 =?us-ascii?Q?DNp1Wm6MKJQqSNQW/4DZC6aVlmHi5T34OCbps3QXpj/o5AgPluXzxBwMbFZF?=
 =?us-ascii?Q?9P+omK1DQBaUmRDTeXceRp/0Vn1sovmi4A+PCQhRVWant3HSnm6KOUj1YAoQ?=
 =?us-ascii?Q?6iVNLAGkdAHmF4p27SUR9TKBNcsXkX3qPSaU+5DuJG43nSYSDSJu1CrcN5cG?=
 =?us-ascii?Q?wIOCtSyGRo4XcreiSzJdNRfQJO+pwxC1xNxxxLOVM3pO+pPmT+HA8jt2BqH9?=
 =?us-ascii?Q?2Dpzb9X8CnniKAYU9/kvHDVVwTOnHW+y7hj+CnB9sk8O86qAh0D26MTKzrVd?=
 =?us-ascii?Q?oCnAQJErV/ei36VqhRwvoF6WVyv5zpCDXpwt1kfgcmcNdxT3k3TpDQ1uKT7n?=
 =?us-ascii?Q?+KGbqyq43InZ4LiEy1O941yIAkR1p9QTccj7hvOoJCxVktPzaLBN8BMlaWQ2?=
 =?us-ascii?Q?d61Tfi5icflWWWP8DOMijOqXX04gnkqabTZHT6O3Sq0K6rMkcsHHsV782egd?=
 =?us-ascii?Q?nEC4sScUyo2CsXq1oqxyMlkvwoxjOtQMaLWkCVR92YvMeX+AUFA6MrfzgV3t?=
 =?us-ascii?Q?9XoHVwytH3d+RXx+jY9uVm9kDswtEL3FwrwXIjf7LQCfYbdpCjJBttz1TO7H?=
 =?us-ascii?Q?JsA36UG9RpHClS4Xg539HoqH6QvHWxVw1tQCKmohwhC0ZtOE4+vEBlWSdGQP?=
 =?us-ascii?Q?WmqmkgPxdpkj30lyj/SGXjbH4CP+xo/JOEJMmnbuVfwPkj+V5Bg+pV1yHn3M?=
 =?us-ascii?Q?1BI4GOm+T6D5ii9DpEr9HgLxAqbKQCt7opBXgN0hQXzCDeltbShivexWMB1+?=
 =?us-ascii?Q?jPZU+p9aVp1jOVZdB2+iiqhcf2H6wUokpgbESwzyAYK/lHTz04O6E8HJhWgo?=
 =?us-ascii?Q?iENf7pdraafKix+w692jPPp1mCsm0aG8mNJTGY4kUBsdmefjJsbQb0oo4r0p?=
 =?us-ascii?Q?IG82slm5jcEcG3irHmngxlAvvsT9h6ZeDWUfDnSiqcNly7RPSIfegPezg5l+?=
 =?us-ascii?Q?fTsoRei9FYayNuWfYw6OUplZAHTFwsIgx5lvW9DMq8dKegRv675vwlv28CXw?=
 =?us-ascii?Q?DSr2cuNP0l2Ev4Kvv8uLQJU02Yicb527Zpnq1pn0Fd8d7nyp34B3LRKvqwQB?=
 =?us-ascii?Q?lcxI5E8LCAIkjhmHx5kaagvOmjBinV6hiVAqLgCsIZfG+HhOXSoXi4DeIjPM?=
 =?us-ascii?Q?j2lJMg/gMvQjeP8iejYlE1xVhadoiXU4o59y80iKVcZIBweeYzHGhhywyHBK?=
 =?us-ascii?Q?HTHbxpKLEeNsXtE0UR0YlvKNk/pN2/22mcozaPoEPbHscr3hf7VfggGlme/m?=
 =?us-ascii?Q?z5dPQCBDlIxAHiDYlKjeufVsAVstNodUT2GG9J2i7v6CbXVprKxCGuaKOnWw?=
 =?us-ascii?Q?zU3YUt+MsU+zIUES4XHK2doxtpqdioatz7cZzVvXVDQWoKsY+RR71jeizGfX?=
 =?us-ascii?Q?cXSActhXY9GE67RLa0Uxc52w41ZHYiz3utC2DDpKeN0lcZihW1UO0CJWZqF8?=
 =?us-ascii?Q?IZ/pQHPLdSULkFEs+grzpGlowjdpOifsk9ac35CByIV6gUpeh5UiXBKCE8cK?=
 =?us-ascii?Q?u3Qfc0WYp3lUzPSt5tE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 18:33:00.5051
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c372c9af-a42b-4c0e-b6d5-08de10d0438f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE38.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6778

Add the 'cxl-clear-error' command. This command allows the user to clear
device poison from CXL memory devices.

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/builtin.h      |  1 +
 cxl/cxl.c          |  1 +
 cxl/inject-error.c | 68 ++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 65 insertions(+), 5 deletions(-)

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
index c48ea69..f8a9445 100644
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
 
@@ -193,3 +210,44 @@ int cmd_inject_error(int argc, const char **argv, struct cxl_ctx *ctx)
 
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
2.34.1

