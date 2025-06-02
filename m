Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D711A76AE
	for <nvdimm@lists.linux.dev>; Mon,  2 Jun 2025 20:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748897878; cv=fail; b=kzEaJ9HNr1LCe5nKuFqg0AxYTbeaKeU36SQEmHYgEm/LcETegp4cb0T9n7UZE3Fhw5NxldWWm4EqMqxKYfLqJw3aVEHqOzmALM2lYDI5BygA+j660V6XgoSYdINxhiRoafE4RtwhaPXrr2FGlajwSiIYbNIULgrIvcJcTR24fAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748897878; c=relaxed/simple;
	bh=TY/FzpLi2Ze1F/UPKdiSIlvFsgPMDPuYEfgCU3dPZHA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bvSaUD0t57L0lVn0ljbBQMBNofeIGsefPhZI1qejO4QcHMQQzED6XQzZpa3LdYZIawsQailVL0rQWDoCiQOuPk7sbkbJ0/Wy4CJ77v/7jy3YNiAnJBpSUEMXOtnIyhC7GMxp6f673J/T3GE5M/ruv575xWLaPO5ox1nqmJBc/h8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TY4PGYpe; arc=fail smtp.client-ip=40.107.244.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TY4PGYpe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ym73xPFbmo0Nkgx3cD5dpghsKnJ7nE48fE2vM2BLpC7zXgSO+UoV0/6jm8b+oiCIXuL97KCjyftKn0lCxh5cFUCqburkKaitSPHxa4nXtjKwzp6Q/4uaDhIvNil8ttqXllJS8kOQR+SU8hu9LPXYUUUiFi9r3ugRyckBFnPY4i+H5eifgEfMDOEOsgODYxHAuJXbnuITOp4soipkE3YRrfIy3+sJ73BguBmuRQtVGWmWV2LycGK75ruNHEAn8qxNQkAm7HBz3GkkZ85DjxodxKtzKIliSTv6sc5TigB/qTtOt20CgrQG4T2+N61qKp7HxWaApPD9SW4GwKQ+4NC10Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WAJaqOb2L+lMhKwW6CdJPX3kF+7+LK2hW50T5kKE/Oo=;
 b=ukPnVTFhdCZhYZ5nT8JcZMNhD1ryfekwTP3ci2l+OHXyLzThAGnBYTJx44DOKmEcvjW9sCBTuTeWEbdqmDjb2tMNF2PbBjiAOGb8xlSVkbxl5N7ZknONsp4LbNg5xVlSFgS1+9rKnjKd8eMabD1VAtE+ooD3Yow40dxYm+lwAwEuuAUpOWkJnJY+xeP/a4LjpS0zVrfHM0lHmRcJdxNoLEbVpuzBBzPd6NCF5HcPCFNiwiP7tlOhyibYssENvCArH1L6lhhoUTW6j0PpBGoauLWabjbpsNVSTLZAPBaUPAjHlCJn50WZfDkeai3GrqpSSfqiPVXl2OUD1cQ1ffwSTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WAJaqOb2L+lMhKwW6CdJPX3kF+7+LK2hW50T5kKE/Oo=;
 b=TY4PGYpepXh3aK+RoYp/0SMFTkvZlbR0CrSYMgXousshQk8XlwsiYov69sOYIcSUaveBDfxsuaAxIdJW7GNcW0gwyu+E8Bd7uW0CH3Ev7+y131+gG+Ten6w92WsqRKprzPZYeIXz+EnH7wNZU7B+EjBgob1NnSMGaXXw/NxAmqU=
Received: from BLAPR03CA0119.namprd03.prod.outlook.com (2603:10b6:208:32a::34)
 by SA0PR12MB4429.namprd12.prod.outlook.com (2603:10b6:806:73::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.37; Mon, 2 Jun
 2025 20:57:50 +0000
Received: from BN1PEPF0000468B.namprd05.prod.outlook.com
 (2603:10b6:208:32a:cafe::64) by BLAPR03CA0119.outlook.office365.com
 (2603:10b6:208:32a::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.18 via Frontend Transport; Mon,
 2 Jun 2025 20:57:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF0000468B.mail.protection.outlook.com (10.167.243.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8792.29 via Frontend Transport; Mon, 2 Jun 2025 20:57:49 +0000
Received: from SCS-L-bcheatha.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 2 Jun
 2025 15:57:48 -0500
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>,
	<alison.schofield@intel.com>, <junhyeok.im@samsung.com>
Subject: [ndctl PATCH v2 6/7] cxl/list: Add injectable errors in output
Date: Mon, 2 Jun 2025 15:56:32 -0500
Message-ID: <20250602205633.212-7-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468B:EE_|SA0PR12MB4429:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f5d1f8c-cea4-4d85-5771-08dda2182276
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?G22zD9zXQKzUf8Mspow6BI1tOfglvZOTcLQtI4Q1KBPOKKgMDom77Ye0qeln?=
 =?us-ascii?Q?ZsVMJNzMGjz+EdtPX6BCP19KYF0BCOebONM+x9i/FCm9RjNl0wy7wdOWQtzF?=
 =?us-ascii?Q?jOPFl0XUt0abxcKNwJhTlAUlH38dqB8A1JOc9aL09kihEYP4sAtJG4m+NIxP?=
 =?us-ascii?Q?2URcCBTrHZHB+pHv7xv3m8Fdqy2eggjIi5Aw95D4ZUlj4V3Y8DEjFHeuNLB2?=
 =?us-ascii?Q?wXpU/svzbyZjCOST5gmnhtmjw9xMv1DrvyZvojLlqa2GKFpPtap2axwBLD4V?=
 =?us-ascii?Q?zI2OLPymbUHUiNEnl3QjkRDNQMU2g3r1B9oo2JvUJCgfjiJ9eeMUEh4ojx1a?=
 =?us-ascii?Q?kHjnFdV+f5gELhw1Bv1jQ1Yn9MJPylHV6WEHXKElr7s9sc6ulxgJu04EVilO?=
 =?us-ascii?Q?+ZSxDrkFoV30UmBaMwVz/POFoZfh3DcCr/mpRoQruJ1NmJphB/9XaaVAuMbK?=
 =?us-ascii?Q?1YeaDmDoqFXG3C51RydyGr/WU3T7U4Cfv+pdg1Jv7dlO0IkA7Rg3DiaJdDZl?=
 =?us-ascii?Q?vnfaLM3lgDjgje5REkxaUMtbtRBFuU02na6kUwgcJTT/eWKiL/5Bs0tSVdwT?=
 =?us-ascii?Q?sqIPB/tFDbHMqrhk6Cc9r6YwK7XzvsDGTf4f9PQijRi2khMzBjX1GdEqbmjZ?=
 =?us-ascii?Q?p1bkAISex/CWugbBTudu3QJftPQWJA7nqYVcHvXHpA+gsMlRzV9ZSv4ZvObF?=
 =?us-ascii?Q?5wxU4N5/wgBzrXql5tdJJb21zC2smOlnvpQ+CfkzXJNcsGaQaHr/a2R3UQ2F?=
 =?us-ascii?Q?FG4o6GktpLR3JQx4OXQeUu+3uf5fy6d3UL3v1ZwFBptfj5TMNan3ifwOnwrV?=
 =?us-ascii?Q?7gWU+sVz+K9r7rgovrUDoLPUCeG04mixDeXdispLtV4mttxiCLuPNovDyJcR?=
 =?us-ascii?Q?wVFquQy6Dyxu7ERaxIKMIlt9P60rlWBZSQxTsBL/nj8i4OkzWqz8sa30arKA?=
 =?us-ascii?Q?o1XhZN8+KIBwnYxkuEJUTUHqhlse8NZ3rC7VJzpA0AHUFGBDLh3pSX+pc71k?=
 =?us-ascii?Q?VxKrCbna2nMoGjfGe1R9UGKNoye+aSfHHpY6kunO1B8km9EiTPf+oIRetXRp?=
 =?us-ascii?Q?P/sTvgFt/pJRYHPYM+uztIl0rlG4w5PMETXALZeltN+iJgaIdvkhAdlF8Gu9?=
 =?us-ascii?Q?bbLnlXyPqk9Mm61W65xec/sdrTYOhqCFNm5oWylWeGkRGkuHhqSxAGscJSNG?=
 =?us-ascii?Q?S+vakhnKWt2YVN8DrxtrD/HOR1MviNSj4nGwIuXp3tJvAu9JqVBGEYoVIlhY?=
 =?us-ascii?Q?LfrEpCY8P87eSWlZKG+TtOojlMdHNXQHRLqP6YQ26OmRS9/k8NXd/jc+dAez?=
 =?us-ascii?Q?xu0YEr3A5xirJvcAD/E6hQb2JYcj6OuiqX2BDvKriN0t5yGG3/IMDQwjkU/P?=
 =?us-ascii?Q?lnKkiYJBL7HY25q4UiFeFl+lgx5xn32MQ6cRa7TGkdOx0vaUdtpZifjRHzMD?=
 =?us-ascii?Q?Y27ZXk6Vky+V6peEC4xsO1fANI4R/vhArY9i7FOaG20/JMVvJbQzC2mGxDQl?=
 =?us-ascii?Q?3s9ylpQ/S+JJSjSXlP0LiqGphASxgsXryYTz?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2025 20:57:49.7150
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f5d1f8c-cea4-4d85-5771-08dda2182276
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468B.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4429

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
index 9a9911e..358a64e 100644
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

