Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F141FDA82
	for <nvdimm@lists.linux.dev>; Thu, 24 Apr 2025 21:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745529938; cv=fail; b=aZPaQa850VujyLxXLtohhe/PsBMJKPEhz/dmIsAFByssvDGNY5HbTH6891ycUK1PVxtCFWelR4MCPBaLK8BfcvRnKPXx5FeWhtBu004igtG/zUfVPGw+J6NmN5H8oUk+BCFna+FnyO2cxbNnGbMV1s37fBzj/xJ6Dpq98A+YX/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745529938; c=relaxed/simple;
	bh=LVcLmRqsv8V4/O6S+ZdlPgxXMzhdXV7BIK9rvR0AnAU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KKDCCs8BmqNsbi/cHvAmv3JFsyqxiecWE7AiLDYE13udtSK3m4q15NuSwFKzqKeol1QgCZk4/Tj01BH+hMHjaIOxhca2eSaczcFwcbj17AG5x9T4ZwOYqaf6U/ETdELRRcLhq8A514P6TEfdhlbOSVY+NtAdcY4JXx8+1RAf+2w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iPzxm+SV; arc=fail smtp.client-ip=40.107.244.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iPzxm+SV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HlmAasUeSDbEk+MadWug2dlffsiHJ3muxGrVtj2OnSlvPb7a8LCz6hVeiQCaucYrlmX1la5MD4DMZ3nyauz8n0uaFBr2efKeg8nxuhz1kHK1uSxQGZJBeghuvSgvf7bUbF4i9RBI0u1G0SRU2eexdd1/hXFS4ygj5hrEmXUIb6twJezu4cytx+VbviDwG/dmrfgu6xvlupI/NtuudAAOAyXL/oO+TXo4K6vmeAV3RGBriD1UBo1iregBjxR2tpcPshYFV0rXM/IL2/oixgRsBygczHZxHJAhMAUVOR8hfbsgCW8Xm0PjkMXrN95vOowxFFB9eR7cXK+igajrZEnwAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iO1xrd3yj6pF+Rbz7Ep/jO4IdA7jBAsZjGciM7SHhss=;
 b=zWTJuw6LjfSTNm0WnM0mXfVwMwyfgvB0PKPOSRWe48J9WJqJJeVWHxPsCBXqoRTbqYSMKSgBRgCsBCZZ2UNK2B26VMQLsV8kade7BOC+ovKogAStJpmzibcq58+KMhrwlZvzJHdL+a4i/UX3ehvq06lhwxhc/TGz1i+zqUVFy9AuLhoUuZaGaINqY1kqZOOMXHqNJ2GF5AcYzUs4V1nuEUKrE07Kx/KWJfQDk86AxJyt57xOQyitalXqCdmTHiKAjVyCX80Dg3o8+vlzZwocqL09WTahvKEB5WYGYCAjaY086lT6JvCIefqHt6Or98txZzP2WIoVYXK5iGXymKZAkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iO1xrd3yj6pF+Rbz7Ep/jO4IdA7jBAsZjGciM7SHhss=;
 b=iPzxm+SVuGV5BnnRhOvcna/PJbTyckXXi+y/oclfLVvlCHGtGvDStqulBw2jpOpC22k+YkYzwtbaxaRY8wchM4vMaYE+zIGlWPiVk0QAyEN3fvxIlJR9AGlrLWFC14dbmzGcbpSa4aHskW50WdBT38eLbkgB0T4e0X3yj1csypM=
Received: from BYAPR04CA0005.namprd04.prod.outlook.com (2603:10b6:a03:40::18)
 by SJ2PR12MB8112.namprd12.prod.outlook.com (2603:10b6:a03:4f8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.23; Thu, 24 Apr
 2025 21:25:33 +0000
Received: from SJ5PEPF000001F2.namprd05.prod.outlook.com
 (2603:10b6:a03:40:cafe::3b) by BYAPR04CA0005.outlook.office365.com
 (2603:10b6:a03:40::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.35 via Frontend Transport; Thu,
 24 Apr 2025 21:25:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F2.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8655.12 via Frontend Transport; Thu, 24 Apr 2025 21:25:33 +0000
Received: from bcheatha-HP-EliteBook-845-G8-Notebook-PC.amd.com
 (10.180.168.240) by SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 24 Apr 2025 16:25:31 -0500
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>,
	<alison.schofield@intel.com>
Subject: [PATCH 5/6] cxl/list: Add injectable-errors option
Date: Thu, 24 Apr 2025 16:24:00 -0500
Message-ID: <20250424212401.14789-6-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250424212401.14789-1-Benjamin.Cheatham@amd.com>
References: <20250424212401.14789-1-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F2:EE_|SJ2PR12MB8112:EE_
X-MS-Office365-Filtering-Correlation-Id: c0ea37a0-fe32-4d07-34f9-08dd83768bdf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?q/fsrCTxbq2MVcb2NMNofPeRZrDqGpl/iQCnHScJ6N6TwbbPhiF9F0ddxJ15?=
 =?us-ascii?Q?AxneK0U/6e6sHTyolQSNtvM8VIDfrfpoTzRqe+UYOuZsRlNWEi0xbXkhCHNl?=
 =?us-ascii?Q?HZUdUuJto6XP/pyNP1wb5WBjAoqVlXjArHLFFwHUlBDeI9/JhV7k+M1snMxo?=
 =?us-ascii?Q?KmLykS5TF7EyLmn+PbFYRCAe0aILza7FsGySvzYOeAd910auSp2Zfkc911Za?=
 =?us-ascii?Q?n1v7YAnMAsh/CtwCGT48Jvarh/lrzrljjSRiK3q3qpX9sAoco3ABZMMOak3m?=
 =?us-ascii?Q?YeJiqmxUArJhDQCf8UuEeTr/BHRzVWRHe4AtnxpoxdDVki8GvDSHCvUellqV?=
 =?us-ascii?Q?RcNtdQxchfJ7/kEPmh+LadCJjFsNPUTGs3aqARLdieACP7EM0Y6VLsT4EKqY?=
 =?us-ascii?Q?mxopvWhlALwoqa1gzGGSB5PSfwFzbbevl4im8y7yzsVFWYl/zD/S3Pke54EZ?=
 =?us-ascii?Q?Jrr4tgD2sFypE280VBLaEuj/w2kse/jI3CvGixWy6wrnvrHQPHn+vI1GJtvu?=
 =?us-ascii?Q?beMT/TKB8ZLNjEFjaTKSlgwEhWVrKeARofCgIYAgfCtnYpjAuUcZehpqgDMc?=
 =?us-ascii?Q?Hl3fn6c6w+bxEo6yHKmniyLqlvV9FK8oJnJ8uRyTFT8tOzDtNHbsdofrVKoB?=
 =?us-ascii?Q?DH8Jg8moLe2rdCo4AdaqEWKMGVLskZtXSKBqSsTGHQ6Q94IMQazEztWcJjC4?=
 =?us-ascii?Q?qQ+Qrr1IxCWWWXdRt63e65UCI2GvFfEawPdHX3ng71ESkPQdZUre/4yuCTtD?=
 =?us-ascii?Q?USAAM7nfVed19Ks0QUlFsl5XOhX8Z80OadEVOraXYLi4Ro3EoeDXIAVSHHhp?=
 =?us-ascii?Q?slHn19pAvjGNgZtEBo6M89cDQMP8VWESkqM05eMRT1f5OectCtO50vQ5SQ0n?=
 =?us-ascii?Q?vzuMTo0RmRvRRw+UKS/NyZ54mRWHDfadK7uLem1P1HU0sCXgojzp+Np5WZkX?=
 =?us-ascii?Q?S4t1SEwT1MNYV4LiOifME41qTuA06ZPTmV6PW0xEz0sEjrT+djCSdl1CTvhU?=
 =?us-ascii?Q?AlKDIsmUiS+jW6DvI5dd5Fc785J9w+uInl2EkKWuPiNnNWv61zM/4FAqWiZn?=
 =?us-ascii?Q?b7XkI0h1TseE7usrg+lPvB40cS2EZaD/t9aGqkmpp4BGVkKGbqaLD18xBhfl?=
 =?us-ascii?Q?206tqelnAUkAUceY2X/yAzX0gaXY5kvaLunUYOWHQhbMXoZKBaeUuQXZBKxC?=
 =?us-ascii?Q?MbfoP98Mcv1bD4jV3eO4IcfRCiEjEvMIVW+flgQTA4va5BuiELIWZY1UZqzd?=
 =?us-ascii?Q?+ZFEGP2d2Fl8ODVzUhZhvGJ8eTmeQJYRCkpcIcvZQZwUcD9KRLpW5vi53RCo?=
 =?us-ascii?Q?ZGKxfuby1jdNiPmUoho7m89+rd7XDjwfg2jodOPY01+b7x+ZM9L+LhoNODGG?=
 =?us-ascii?Q?tag+RGFma8qcuwgQJ//Xqp56nIXutsH1JGdQZK2hH9XZ7cqlbszKuxW6hlcb?=
 =?us-ascii?Q?72yf/dMXi5QMn8sDQVJjTq1GvCNh51DjxvA3pdq6WVWXAK+jDYwhJCAXryzb?=
 =?us-ascii?Q?0/iY9FGKtW1JvtKgtJZnqm8vDQGXZU6J8l2h?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2025 21:25:33.1112
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0ea37a0-fe32-4d07-34f9-08dd83768bdf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8112

Add "--injectable-errors"/"-N" option to show injectable error
information for CXL objects. Applicable CXL objects are CXL memory
devices, where the information reported is whether poison is injectable,
and CXL busses, which list the CXL protocol error types available for
injection.

The CXL protocol error types will be the same across busses because the
information comes from the ACPI EINJ error types table (ACPI v6.5 18.6),
but are presented under the bus for easier filtering.

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 Documentation/cxl/cxl-list.txt | 35 +++++++++++++++++++++++++++++++++-
 cxl/filter.h                   |  3 +++
 cxl/json.c                     | 30 +++++++++++++++++++++++++++++
 cxl/list.c                     |  3 +++
 util/json.h                    |  1 +
 5 files changed, 71 insertions(+), 1 deletion(-)

diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
index 56eb516..6d65947 100644
--- a/Documentation/cxl/cxl-list.txt
+++ b/Documentation/cxl/cxl-list.txt
@@ -469,6 +469,38 @@ OPTIONS
 }
 ----
 
+-N::
+--injectable-errors::
+	Include injectable error information in the output. For CXL memory devices
+	this includes whether poison is injectable through the kernel debug filesystem.
+	The types of CXL protocol errors available for injection into downstream ports
+	are listed as part of a CXL bus object.
+
+----
+# cxl list -NB
+[
+  {
+	"bus":"root0",
+	"provider":"ACPI.CXL",
+	"injectable_protocol_errors":[
+	  "mem-correctable",
+	  "mem-fatal",
+	]
+  }
+]
+
+# cxl list -N
+[
+  {
+    "memdev":"mem0",
+    "pmem_size":268435456,
+    "ram_size":268435456,
+    "serial":2,
+	"poison_injectable":true
+  }
+]
+
+----
 -v::
 --verbose::
 	Increase verbosity of the output. This can be specified
@@ -485,7 +517,8 @@ OPTIONS
 	  devices with --idle.
 	- *-vvv*
 	  Everything *-vv* provides, plus enable
-	  --health, --partition, and --media-errors.
+	  --health, --partition, --media-errors, and
+	  --injectable-errors.
 
 --debug::
 	If the cxl tool was built with debug enabled, turn on debug
diff --git a/cxl/filter.h b/cxl/filter.h
index 956a46e..34f8387 100644
--- a/cxl/filter.h
+++ b/cxl/filter.h
@@ -31,6 +31,7 @@ struct cxl_filter_params {
 	bool alert_config;
 	bool dax;
 	bool media_errors;
+	bool inj_errors;
 	int verbose;
 	struct log_ctx ctx;
 };
@@ -91,6 +92,8 @@ static inline unsigned long cxl_filter_to_flags(struct cxl_filter_params *param)
 		flags |= UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
 	if (param->media_errors)
 		flags |= UTIL_JSON_MEDIA_ERRORS;
+	if (param->inj_errors)
+		flags |= UTIL_JSON_INJ_ERRORS;
 	return flags;
 }
 
diff --git a/cxl/json.c b/cxl/json.c
index e65bd80..6f1a7cf 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -855,6 +855,12 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 			json_object_object_add(jdev, "firmware", jobj);
 	}
 
+	if (flags & UTIL_JSON_INJ_ERRORS) {
+		jobj = json_object_new_boolean(cxl_memdev_has_poison_injection(memdev));
+		if (jobj)
+			json_object_object_add(jdev, "poison_injectable", jobj);
+	}
+
 	if (flags & UTIL_JSON_MEDIA_ERRORS) {
 		jobj = util_cxl_poison_list_to_json(NULL, memdev, flags);
 		if (jobj)
@@ -930,6 +936,8 @@ struct json_object *util_cxl_bus_to_json(struct cxl_bus *bus,
 					 unsigned long flags)
 {
 	const char *devname = cxl_bus_get_devname(bus);
+	struct cxl_ctx *ctx = cxl_bus_get_ctx(bus);
+	struct cxl_protocol_error *perror;
 	struct json_object *jbus, *jobj;
 
 	jbus = json_object_new_object();
@@ -945,6 +953,28 @@ struct json_object *util_cxl_bus_to_json(struct cxl_bus *bus,
 		json_object_object_add(jbus, "provider", jobj);
 
 	json_object_set_userdata(jbus, bus, NULL);
+
+	if (flags & UTIL_JSON_INJ_ERRORS) {
+		jobj = json_object_new_array();
+		if (!jobj)
+			return jbus;
+
+		cxl_protocol_error_foreach(ctx, perror)
+		{
+			struct json_object *jerr_str;
+			const char *perror_str;
+
+			perror_str = cxl_protocol_error_get_str(perror);
+
+			jerr_str = json_object_new_string(perror_str);
+			if (jerr_str)
+				json_object_array_add(jobj, jerr_str);
+		}
+
+		json_object_object_add(jbus, "injectable_protocol_errors",
+				       jobj);
+	}
+
 	return jbus;
 }
 
diff --git a/cxl/list.c b/cxl/list.c
index 5f77d87..d43b47e 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -60,6 +60,8 @@ static const struct option options[] = {
 		    "include alert configuration information"),
 	OPT_BOOLEAN('L', "media-errors", &param.media_errors,
 		    "include media-error information "),
+	OPT_BOOLEAN('N', "injectable-errors", &param.inj_errors,
+		    "include injectable error information"),
 	OPT_INCR('v', "verbose", &param.verbose, "increase output detail"),
 	OPT_STRING(0, "debugfs", &debugfs, "debugfs mount point",
 		   "mount point of kernel debugfs (defaults to '/sys/kernel/debug')"),
@@ -127,6 +129,7 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
 		param.alert_config = true;
 		param.dax = true;
 		param.media_errors = true;
+		param.inj_errors = true;
 		/* fallthrough */
 	case 2:
 		param.idle = true;
diff --git a/util/json.h b/util/json.h
index 560f845..57278cb 100644
--- a/util/json.h
+++ b/util/json.h
@@ -21,6 +21,7 @@ enum util_json_flags {
 	UTIL_JSON_TARGETS	= (1 << 11),
 	UTIL_JSON_PARTITION	= (1 << 12),
 	UTIL_JSON_ALERT_CONFIG	= (1 << 13),
+	UTIL_JSON_INJ_ERRORS	= (1 << 14),
 };
 
 void util_display_json_array(FILE *f_out, struct json_object *jarray,
-- 
2.34.1

