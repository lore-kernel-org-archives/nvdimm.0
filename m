Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010050.outbound.protection.outlook.com [52.101.201.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B247623AB8D
	for <nvdimm@lists.linux.dev>; Tue,  9 Dec 2025 17:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765300546; cv=fail; b=qZl9skPTRYNmYvWznnQon7iNZyWWgwtGRh1JuIKyd6ftAKrei1ABymNOzZYU+ID3k+I2u4Y7oaXFptLuPeK3SKZfeepJqF68M59mEA/NeNPDn2SxyfbF9j3aiqfKMK6CelaHY1mC4eEvJZOSp/+ho/566av18XN6AUln/Rv3S0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765300546; c=relaxed/simple;
	bh=S/qgG8+Kb7oPFjRoPKyIyEKudVqK7EY3gtPnvI4Jqow=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R7J3f8aU9WLSnGbYWBgRV/sH7nktdObtZEWfXQ1e4Uf5tOo/YeDecAm4IR6xDes9BQBuaewnRhs1IpDsDBBxaBfTADgmmRhYbFSdsf7pWzU936e1JW+ZSz2Y16+JcaAqwNfWZTtSCqSqfvIwLHAfHx7ECplHisj2ZScdHkud0F0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ol4wMWBt; arc=fail smtp.client-ip=52.101.201.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ol4wMWBt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HjP2zgoXO7ZxEWX41R9Z5qEfEFa7ctoDyAAo1v+bgTEPKBucwYyo797t1eoFGmuTTjMergezYfuQ/x2Je+D63Cx8c0E2VR9GXnGkz5oIktKcSyFP/G/SPdUpMzffIGdFXIE7K2z40tgZglmNNwAQ0OHyYgEQEHXTNlcED8wJsM8TcJRrN1tMG9QzyOkyJ/6ocasxSXGndPWkIl/0nbMC9C068vu3qfSx9yR4Dtkpl2K1JDg6Ak00CdxSibg8sRuQuEbR6l6oEzVMjQtHPZ4OLig/FV/WsicWWojJDngeckR3yliAcOquc1fPgW1GDji/k8kJ7TDovLxTOUpwJhk0lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Zos/UEv+EfxGPa+ArILaC44LRFi5/dqsTlek11Cj+o=;
 b=p+3xrxkyp+RK0KjD21z5DVAYVnj7C5Qo59a7cj7b9gaDughmX0H2f2+zG1UEeS7CWyCFalt95/TLPnp8pdLg5UIamtuOiW/GpUya0Dw3tJdH4dxXGH0HyNF30t2UhOQI8asD0X5ABPZEA4FOST5J+urHbHfmWwURJVDop6Wz9kyIQm5ObXs06DQgZGOCyOVKm2hb629DZTlQgjrOLdJ8W7edxpcTY5mZa5tfdriubgLHJIW+FmZVUUNIUE7tOJPPGUasFemgXshaW6Xob+yGnvuqILCFRw55a7OLtT8CRGV9f4iIXf/Q2uDTrumf5Jz5XrvDVHU7oRHZh+Gxcm56ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Zos/UEv+EfxGPa+ArILaC44LRFi5/dqsTlek11Cj+o=;
 b=ol4wMWBtt1E/ULzyPELYW+381umML7JT0NPnxNpOf72rALeCwjfROUhupVzWmCSXQA4UNA9MSWzfqNTe8OqY9mhcOrGStq/XcjEk2Bj25j9UdboU8zr/qVoRtTIPq3DrQod0x70w2t0c3U31Amcv0YOPgZw4UnBA2RIlMgEiNgs=
Received: from MW4PR04CA0053.namprd04.prod.outlook.com (2603:10b6:303:6a::28)
 by BL1PR12MB5900.namprd12.prod.outlook.com (2603:10b6:208:398::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Tue, 9 Dec
 2025 17:15:38 +0000
Received: from CO1PEPF000042AA.namprd03.prod.outlook.com
 (2603:10b6:303:6a:cafe::76) by MW4PR04CA0053.outlook.office365.com
 (2603:10b6:303:6a::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.14 via Frontend Transport; Tue,
 9 Dec 2025 17:15:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000042AA.mail.protection.outlook.com (10.167.243.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Tue, 9 Dec 2025 17:15:37 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 9 Dec
 2025 11:15:35 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>, <benjamin.cheatham@amd.com>
Subject: [PATCH v4 6/7] cxl/list: Add injectable errors in output
Date: Tue, 9 Dec 2025 11:14:03 -0600
Message-ID: <20251209171404.64412-7-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AA:EE_|BL1PR12MB5900:EE_
X-MS-Office365-Filtering-Correlation-Id: 85fbdb88-db53-40cd-6013-08de3746928b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LatAapG4D6I+GEV5AeIZ7WXNg1YG2jHHrXIB6zMGrJVoiOqgS3on9KH+eLQX?=
 =?us-ascii?Q?j1AVOfl142sGix578ct3rfN+6PnL+hR0XatuEz97OI+muHRswj363EsprkLt?=
 =?us-ascii?Q?OtyZj2C0wjcDv6gz4pCSzFBUx7zJgFED1mocVPlYQXD7dUIK+VphV3j+lqpk?=
 =?us-ascii?Q?lHFlec+SCdQEDYIHx1X8LtZzhRChqHrqPstfyq5k3OdL1kjgJ/PKKOmLQl5q?=
 =?us-ascii?Q?sx4caL5eq3aL1YfVhVSvELBr9OOWUlaEtgGdWN4qatmJK69y4gKksHZA6+aH?=
 =?us-ascii?Q?T7wHYLLqKRVgcHPi1yfLzhe+fclbH3iIuBHDRlxRce2SLb+95W84HYZ49qjx?=
 =?us-ascii?Q?nj4GtbsFAlTLr8LATllc4qa+dfN+HVWgOPD6jjDdHuqfc4kb81zsqWjhccIo?=
 =?us-ascii?Q?KiR29GsGv3DtT803xgYbA+8iuzN2U1t19CCthbR5yXi6ATdCPoakYHlMIT2e?=
 =?us-ascii?Q?61W3xEJ7jKxEIyDp8Vgg8ke+Oueb192RGOtJdGN8MGD/uJUjKhSa9TP/iy+w?=
 =?us-ascii?Q?5zpP3LIzzfHVytHU6gVIjbM4Sm5G4D+gDPr3mLpT6+5daxCN9hyYfWJ7k8GU?=
 =?us-ascii?Q?EMHChanCsqS0Lc4t1L7iT5V10Hl+/KMzc+sAhE/HtsMtR30ihT4HGgigajuH?=
 =?us-ascii?Q?qcg8P8rGyqv/ql79ocwfFOQACF7PRGNp/pF6czdMh0BKnDIT/Q96gEKFPiu2?=
 =?us-ascii?Q?vA67HmwDgmG6dhxtG8PmZvXBEqpbOoobQi39qS+P+pW6o8d6MuVV47NDKwnt?=
 =?us-ascii?Q?sqV/+r2sEMNZTBhf/o7oShj7k3MCXLMgauxgJLah93Le0EHpr+Nkz/RLO3tC?=
 =?us-ascii?Q?FFr7dLx+KETOs0FuOIzw6wzKqJRPpvYf8hrVwzvNxxdRG7aD2a/YdSFB+a3A?=
 =?us-ascii?Q?5+OKroN21kETb89+gkxNh/vlsNcKpbtvuTCP+/csg2HrbJJCLi18IqWp1gze?=
 =?us-ascii?Q?XIrL9r45F8Wpx+aBl8B6eTdoNaw6aXqLJe0WsFh5Vvk4l29h0AqsI3Yirnj7?=
 =?us-ascii?Q?cLWWp2F77zcBpQWvDGEwhawq03+L3w2Fk6GNuCdi7MUSQAQWTsZme0SVq/BJ?=
 =?us-ascii?Q?l/TmgSWTucfdgOnrNSbIpE+MvHglohOqbUdZKenFpzMxX428r8CgDhFOI5Jx?=
 =?us-ascii?Q?YZ4Pe10xBqGN+me889RqNtegu0ZpMZ5byzqkp8MlYT4UrohhpuloE4F/lKIz?=
 =?us-ascii?Q?y+efTaV5+BJNSmlWcLq6jQpGuTcZ0TYJb2EryTMgCKUgwIWQjOQgkNJtf+l+?=
 =?us-ascii?Q?OXR5heNT3ebsQxEqzazI+jLSY2Yxakhvzy3yxURN5IpRwdt2+jE3OZ215K5V?=
 =?us-ascii?Q?f28RpLwIKGzUUpADAkqMF+qlVWwYXp1jrNrvPMgPIUtwjDdrspf502QfPLHS?=
 =?us-ascii?Q?33yNvTMxZzXS/EhuLM+sRCRMeL2hZPD6r81nBB6wYwCpDx4/dq9/YiCvGeD5?=
 =?us-ascii?Q?AN0Iuj3MUNlxFGeKyLqJamAOCtVBPjQsG/z+Eyf4XY/1g0+uZ7qBCS5hjBpi?=
 =?us-ascii?Q?5biv7QSpnagu/AvNUWT31knLHyjXbQ3OUPwouKVL9en13J5YROqSE2yUl1KW?=
 =?us-ascii?Q?JHNQ/Gv+y+QRvb3YOgk=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 17:15:37.7697
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 85fbdb88-db53-40cd-6013-08de3746928b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042AA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5900

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
index 70463c4..6c5fe68 100644
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
@@ -93,6 +94,8 @@ static inline unsigned long cxl_filter_to_flags(struct cxl_filter_params *param)
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
2.51.1

