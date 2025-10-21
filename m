Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010050.outbound.protection.outlook.com [52.101.193.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DF234D902
	for <nvdimm@lists.linux.dev>; Tue, 21 Oct 2025 18:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761071602; cv=fail; b=Ukv7LAdhYdgpo9A20Po2ZclrBpKm3s6+cb59i+0Vx8dDBMn/4+JWgQ0SwoCA6kO91SZlVf5RWz7DzXZcf98CKjRVsF6pLY3dOnuoeWQtnvytCvOa5qKuXqzzbocj2dNZBKxxJ2CVnrfA+qaNHb2DdwJUUoPRajpdWeW9zUBG8QU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761071602; c=relaxed/simple;
	bh=VF+K/HaHS+LPx8xDf3RcBCeY8ztMAUKYrXJu3SRl26o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TuIlugNeT4fQ4BoLrLTtIin//WHq6KZihf3DTI/2gp1Qhcrw3+eR6rydzP6u29tBvSdhskg+U7HdRS/hqh6Gb4FOLFje+zxKE+OAxlBX+YubmdbDHbyAvnlRn+IqSLumZzupYsVFZJd13SgPAOaDNBos6I1eoaxaQwDC0yKkJPA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rmJQrIOr; arc=fail smtp.client-ip=52.101.193.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rmJQrIOr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XSN6Q8bVkHh84P415x4PqfBcLXS7FXFcB86mXLNX5PDctBpc14ZSz+AZH5lm/tqV2r8M+v0zGnl8FLE0IU58cU+jkCN/uIkrx4MiRv659N4Te+djEwO15nPQ9XmyK0UzZGry7EuHWnm3ajKEtn+IiV4CY47fKo0cqHHMB1zxLGKSxX66rHKoQHAxY4jtT8BSXm/LqQfEb/p5hKHhs1TbcUV7zE7p4UkdmvA5wzzxjwxHPs/kEhqzgTjiLk2mXFev1lWG+bHc1qEWEgAKSwTewgR4rG9ztLlnGJ+5MWsp7cYIu5x9nXLqwjmX5FIUkFKWCfAi5PChQL57RiZBJYJ4zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Xo6QnHVDhu8rH69hVUiFtV0xnebuqvhh6JFW4WzyEM=;
 b=SNMh4kg9wKbO4XJ2yYwELmV8lxGXiQt9bsDi5aOegfFbPU6jIu8py/3Fp56Vfu4PmfZT5eComkgxApKTk0z8umKwnx+xmaH2AX2o0MG53oz+OA3lrrJeo2Pv39cWP9ijV//vZ6/AuZtBVF92jCuC0bqp1amAHeppBvE04YRG+bqh/AZbVZVdASDkjhKkLdr11NK43oSQG9C2keK6etRe3vczkK8oSq7s7SRv45BI+U4qMJbjQLeSVPxy/exbiStsNNF/ZmDylYhYGIeTP36/NN3w9LTIBNROKZIkOTklM+bPedKG2LrJRRmSIp5MIcgLNkDogbM5jivOosyy8GCboA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Xo6QnHVDhu8rH69hVUiFtV0xnebuqvhh6JFW4WzyEM=;
 b=rmJQrIOrBsVpFaOt2pb/fq+g36zJDVuI2e6nGuuet2i8CvLu0lv7bsuhdyok9OcOdgjmhjXEGb84/mDU264HWwsIyaYuYRRvXJdtsrttwwYyDIqlF4wwItFEFmfsYeXlP7Fzw3Tg0mlkI2HM/cZiJtz5VgAzcKunZbKiiA5bKD0=
Received: from PH8PR21CA0013.namprd21.prod.outlook.com (2603:10b6:510:2ce::22)
 by LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Tue, 21 Oct
 2025 18:33:12 +0000
Received: from CY4PEPF0000EE3C.namprd03.prod.outlook.com
 (2603:10b6:510:2ce:cafe::6b) by PH8PR21CA0013.outlook.office365.com
 (2603:10b6:510:2ce::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.4 via Frontend Transport; Tue,
 21 Oct 2025 18:33:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EE3C.mail.protection.outlook.com (10.167.242.13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Tue, 21 Oct 2025 18:33:11 +0000
Received: from SCS-L-bcheatha.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 21 Oct
 2025 11:33:10 -0700
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>, Ben Cheatham
	<Benjamin.Cheatham@amd.com>
Subject: [ndctl PATCH v3 6/7] cxl/list: Add injectable errors in output
Date: Tue, 21 Oct 2025 13:31:23 -0500
Message-ID: <20251021183124.2311-7-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3C:EE_|LV8PR12MB9620:EE_
X-MS-Office365-Filtering-Correlation-Id: 046bcb17-770a-42ea-a8fb-08de10d04a31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nl/zoCQfzpreWP3H8MxhDGp07MbudgnUNlZoEUW0PjO8IGHx76ZIZLw6Hc01?=
 =?us-ascii?Q?/bSvtWve6etZ/KX6+v9yAwt0W0+aaaau3gf2DRXgNlHrM/tfsx6K230qbjNk?=
 =?us-ascii?Q?qzwbxU5akAY30kHz/YNY8lyfN2QjDdqZe4Xv1bzi+OaG/uM68O3x+G/JRuUb?=
 =?us-ascii?Q?c7ErBS8rgCb21GKgtnBhG+eF05Ccf2t/CF2L5QJ52qocOVTud0jJh05rKBpM?=
 =?us-ascii?Q?4HflJ5O+9uwjwJYlyQVUJ3KVEkjF5CEB/V0JPWa+UH869uWUz37fvp3D/oOl?=
 =?us-ascii?Q?dAFszPyKj0InkEKkxtJBd53V+NKlkwXYyYGWJ5tIhzdmo0sxZCDHSEu5jhLq?=
 =?us-ascii?Q?FJsRyA1+6WBk8X7hKIVHazokd9IjclL1qWAVr3R5Pxj1xFyykTpdBRzLhBNP?=
 =?us-ascii?Q?dXZGlfhK9yIcj1J4XE9JAmjGg12ep1b5t2uuVGvnNREyd0klaDsKINRF8LZh?=
 =?us-ascii?Q?1Jh8fSXvfJI5jGGQUQT9LvSNmFw1WKnA8kXSzlgDJb/NI60R2zUpPHcSlSAY?=
 =?us-ascii?Q?MP5cEu6dPUwpl+ED4OtXT0GSc1XpMwAAqQqkCjgwjP1RrGLfo9M1CrK6JKce?=
 =?us-ascii?Q?CWjABFI0VnDQOyz9JEWid/LzpDd+joRBZcA+9dYS8qMweUwZt2p4s5Zl6wBD?=
 =?us-ascii?Q?gI7fnqZelblqiwE5DAu1CNRXCe8XJ2pq3LBPN0uiQsVRyPTiu/SNhMF08MxP?=
 =?us-ascii?Q?OmpMoqjImETGviIHRy5dD0/Eg2Cqjl0AmniD2LstIBnNscnMcEPzsqFcbDCH?=
 =?us-ascii?Q?Q8f6SWhz8MoIiIobpv78wE5mdryKiPFNMNCKMMIB9wxzOf5f38xNFPFkrkij?=
 =?us-ascii?Q?rP5pj/Kp4lhqwW5HDn4eqT7qEuircQVf9eLLYrciLMITQ05tIVUVKwbSYqAM?=
 =?us-ascii?Q?XKNZZkinI2QnDiKIMf56h1GY98A6LfjSDgBgswKDxJxm6JVuE2wlWvPNMNuH?=
 =?us-ascii?Q?rc0vJgxJGoQugUH5HE1F2ntccJG50UH1fMlZK3WFuMGOQjr47dtnnmDrJHIh?=
 =?us-ascii?Q?Jw1aiPpl63SL6fKLKuP5l6PLOwGuyRVhp0y5glAQQ/YjEE2Obz8HIU4MvCGk?=
 =?us-ascii?Q?+T5pHbM6U89l5UQR1FpLsyM15BTLWikV5PiHNTycHFhZcuAN75dLCx2m6YI4?=
 =?us-ascii?Q?tfesKSoXfdzjhsSy2Svp5dK91sqmVot5Fr/otGGAQZE2Zy6um9J9vkoLafDS?=
 =?us-ascii?Q?lkfHODQm6ZlzdC/9mVdlBKnCUxIX4UW3TNINnwTtI3TZ7ma1AlGq6vyIAGiI?=
 =?us-ascii?Q?+/4VYlJhvQBan8yN7l13cAwg60L99bcGKcYoDzVxDUQS1Rl6wlKdb9AwH/u5?=
 =?us-ascii?Q?RF1SPGiE95UVlOsw+CWz6fK2pyUGRfBjlW08Iup2noJ4y3vQP+kEkpxh6l4N?=
 =?us-ascii?Q?btnARXIS3BiE4efha6IA1ZV2SSorHbVe0xSoCFrjA1nCxdbnPQMr12cgpn5j?=
 =?us-ascii?Q?plAFt//5fuwhosBClsEEbH0AQ9vPjqblvRO7n2+Ko1qJpKL2Bdb5CiEgn+Ht?=
 =?us-ascii?Q?uYAhbuaGw62gPxiLGaElcZkle9TKA2A2e2misstF6EstlYI2tTksLXF49xHt?=
 =?us-ascii?Q?iVkqbU3j64a1uFfAscc=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 18:33:11.6248
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 046bcb17-770a-42ea-a8fb-08de10d04a31
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9620

Add the "--injectable-errors"/"-N" option to show injectable error
information for CXL devices. The applicable devices are CXL memory
devices and CXL busses.

For CXL memory devices the option reports whether the device supports
poison injection (the "--media-errors"/"-L" option shows injected
poison).

For CXL busses the option shows injectable CXL protocol error types. The
information will be the same across busses because the error types are
system-wide. The information is presented under the bus for easier
filtering.

Update the man page for 'cxl-list' to show the usage of the new option.

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 Documentation/cxl/cxl-list.txt | 35 +++++++++++++++++++++++++++++++++-
 cxl/filter.h                   |  3 +++
 cxl/json.c                     | 30 +++++++++++++++++++++++++++++
 cxl/list.c                     |  3 +++
 util/json.h                    |  1 +
 5 files changed, 71 insertions(+), 1 deletion(-)

diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
index 0595638..35ff542 100644
--- a/Documentation/cxl/cxl-list.txt
+++ b/Documentation/cxl/cxl-list.txt
@@ -471,6 +471,38 @@ The media-errors option is only available with '-Dlibtracefs=enabled'.
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
@@ -487,7 +519,8 @@ The media-errors option is only available with '-Dlibtracefs=enabled'.
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
index bde4589..2917477 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -675,6 +675,12 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
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
@@ -750,6 +756,8 @@ struct json_object *util_cxl_bus_to_json(struct cxl_bus *bus,
 					 unsigned long flags)
 {
 	const char *devname = cxl_bus_get_devname(bus);
+	struct cxl_ctx *ctx = cxl_bus_get_ctx(bus);
+	struct cxl_protocol_error *perror;
 	struct json_object *jbus, *jobj;
 
 	jbus = json_object_new_object();
@@ -765,6 +773,28 @@ struct json_object *util_cxl_bus_to_json(struct cxl_bus *bus,
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
index 0b25d78..a505ed6 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -59,6 +59,8 @@ static const struct option options[] = {
 		    "include alert configuration information"),
 	OPT_BOOLEAN('L', "media-errors", &param.media_errors,
 		    "include media-error information "),
+	OPT_BOOLEAN('N', "injectable-errors", &param.inj_errors,
+		    "include injectable error information"),
 	OPT_INCR('v', "verbose", &param.verbose, "increase output detail"),
 #ifdef ENABLE_DEBUG
 	OPT_BOOLEAN(0, "debug", &debug, "debug list walk"),
@@ -124,6 +126,7 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
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

