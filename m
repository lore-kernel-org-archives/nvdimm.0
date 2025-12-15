Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011027.outbound.protection.outlook.com [40.93.194.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5610832C321
	for <nvdimm@lists.linux.dev>; Mon, 15 Dec 2025 21:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765834672; cv=fail; b=q4HHRkuOZvXi8AxxrapUFfeCDGH6b/ZFb9rFSUuxPALY8GRGPCZSTpQe3rspN5meBGbxtoT33IO+m8YATxHeJk4hEpEb7wcxnxuAZhgvFAUVbYTc6RTH6NQT8xjW5BLRHYPTwwZVm+ojIMEoW9F2IsELaNYAhEvwbGprNj2fW0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765834672; c=relaxed/simple;
	bh=ckF1qRP8obXhXpENaX0vLxen2bZepiiMvf7EFjJbmRc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h91AqG4xdszM4ocvMlDU3q3jRmLvCDOWN64+rIF5RooF83K4JdQ+kmC/f0VXMbfMiacVo93JAMikviYkelZ+OBrr4T1rU1RpX5F70cwZrB30QJW1aOveLv6dR61uyn+xy+C1H2PIPGl6eR/exPBbamrwYQEHu/sFw1rTteVqSyw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2/KUlkbn; arc=fail smtp.client-ip=40.93.194.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2/KUlkbn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O8RuiGHeekgPkIkFMWM1jOhAEKSLQJGUBi/Ljs+NehReIcSZNv7ZZKgdW7VcetMh1lKpgHts5mJPlw7B29zZF7kV7E1g0gMtk9eaOVbiCxt5dOl2d6oqT6iOBCADrfNS1UGjvEgYoVNUL76v7EhDMbh9TWGobitEoyaYCU/GcKoTd3pfIJ91WfSeiQHgzz9BJS4DoY8zmJ+lI0ytEISBYuEAr2tR0Ri9pBfU8z2L8AJHt/c0eXVVYqAaoXQsyvO01kzxmPgyjD2ALdywk0AwsJiG2zmou2PwvKfQZkWRuTmPlljfkwJEZyNMrXLUIgB/2B4DRQJqOtimbE1rd6gQYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=axgDmKXHVje68+w+v2vusD8N+xa1iEg9Q8ezN1XRS5c=;
 b=iT7iIcBlBBfISw+18Ay0Wg1/ohu111HIpszKVzQaRZLfhGjWDLvCXRz2dB4GtTrQBcBfn4DmUXkC8cRdJUtWq5F2kZvrID8BnKExByjOXIl8M4Is9Drp8MXG95arS68Q+UpaXUhls+R3SAfnmNFTPU05zAzHTMCJzkdg2d1dgPwiA5oh37Zo/g8N1SEyIBBNBGT3rf69Of1DchDwNCyz+DTtw+ZXsb03Dw0QlZudvR3VJccE15zhOwgqsijETuI96MEQvabNYa2TRBxWgt4SjVzRtITy2KJRMZXrlB7/bfwKBmlD+34n20qu7nD1vIKOx7KlIxTf6+Pw4fhdREAYEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axgDmKXHVje68+w+v2vusD8N+xa1iEg9Q8ezN1XRS5c=;
 b=2/KUlkbnI0VexP94bbHU1zJ9FNJfXQpf+uxSx0uhk9uQ5LAojFuUc+mkVONaAaTXvY+cd4PS4DYJWrmnE4tWT1lKXi8M7FTg568G/sypuAro0YfB4/vsZdRCBJJIbUAl0+WUyGHLN4M+h7qriLv+HqtKsn5n3opuW4IfVHkLWso=
Received: from SJ0PR13CA0145.namprd13.prod.outlook.com (2603:10b6:a03:2c6::30)
 by SJ0PR12MB7033.namprd12.prod.outlook.com (2603:10b6:a03:448::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 21:37:42 +0000
Received: from MWH0EPF000971E9.namprd02.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::bc) by SJ0PR13CA0145.outlook.office365.com
 (2603:10b6:a03:2c6::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6 via Frontend Transport; Mon,
 15 Dec 2025 21:37:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E9.mail.protection.outlook.com (10.167.243.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Mon, 15 Dec 2025 21:37:42 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Dec
 2025 15:37:41 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>, <benjamin.cheatham@amd.com>
Subject: [PATCH v5 6/7] cxl/list: Add injectable errors in output
Date: Mon, 15 Dec 2025 15:36:29 -0600
Message-ID: <20251215213630.8983-7-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E9:EE_|SJ0PR12MB7033:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f221983-7b6f-4088-1b2c-08de3c222d8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?J37kCbUCGnkj4vcuidiOA+RFBRTjDFRq7jbqfywh/LB0IfxLpFy6m009nVxW?=
 =?us-ascii?Q?8flwkb3xHeu6eka1dIgGk0E8LkO/UMOgAgm2IudVdbBG8ubGLNzluFKFLoEK?=
 =?us-ascii?Q?Mxe+RrfTODD8U5prF82OuJJFXsJt4lcZpC3GIzDu4KNQmcsslRRWUWBx6P0g?=
 =?us-ascii?Q?/tqHFOlCzIV0Oxcz4U0RBdD76eU3pih1vfFTUvhErTp/mSWRnsQqvZUFfDPF?=
 =?us-ascii?Q?uNw1RPHwtjqL6ZihivMbryB8Jy/n97ppl5faNRgV+CCquCuclznWZd3Qb7VQ?=
 =?us-ascii?Q?SSQGSeE8mu/bqHsFpBgPjXOGutIiwkThkbmDqofiGWoQKtRfnPTI3ek03ZBk?=
 =?us-ascii?Q?q2zQWF7ag1nHJRwbPRivu2dZZlOMWC9U/HBUmjk7SU+ycfiOreDjlSkon1eU?=
 =?us-ascii?Q?Olka8ZhPjVw/9+UYWP1LSQ9hMV44WGWhR1BQrjw7q2nIyFZ/DfWXRZYw2N0J?=
 =?us-ascii?Q?RGv1cCWpNOlg6cBDFYDkAEoi8VtyeECMHsDnx3rNY/CfturO4jWqIV/UqZrl?=
 =?us-ascii?Q?OI/eE02KjmL6x/6FE4qv4IiEauTSGiqCUUgRm+mrTMSV/DpCVJwQ3KUQDWtB?=
 =?us-ascii?Q?t/oq0fHXDzDxa7nbYRrZAWp73+n7V+XZsFurFdVk0k4ZD8hmQ/PK5xMpOtK9?=
 =?us-ascii?Q?N4o2hDkCVMeCJk+uoNNllgC/7NYZdRIph+4ME3h5DWvp0o4GIEowsZAy1Iu3?=
 =?us-ascii?Q?OyQdOTSd7VbRMDyvcb2eYR+9wQftI7tsEy4anS5bdDKEHHOKsw+MsF95eIuu?=
 =?us-ascii?Q?/zHu+nwfVKDHXZ5mG3I7lrseuHZiy+YAxe0P2RPh1pxHmGhoQ+MlsJ8cEGau?=
 =?us-ascii?Q?cfDQim/ssYT+lWqwoRWmF/gl4vDw5LazqWvbgD/x7vLx/WalxiyQp3l0UMM8?=
 =?us-ascii?Q?x89RnCwstrUke9PgVxrU2oHqcnmnlAG+Y40sQfsTMOOjy2JOmMbUEWd7OppO?=
 =?us-ascii?Q?GCZMWOGMK8/uJzaz1kOyNgLklCHNeHFiqpztvxEtT0OCudgGn2vLORrti/Uf?=
 =?us-ascii?Q?wsn3hIQCo34VNVSPS+irzo63JOo28YxF6tijBr4H5gMXA13hGPrSwlhYT5+H?=
 =?us-ascii?Q?uttTvuv7epVy6lu8er8m5tvKQKNYbL3sYCeMzqFgWUx2lvK4HIv9CR3g6wl6?=
 =?us-ascii?Q?kL9ufJnaU8nFvIKP0iyHeOcZXfYV8l8dKYoLiuJ4Npx5Uq3Phl+/7W6/Xfct?=
 =?us-ascii?Q?Y0DF8/X848DdiifkDMTbbSC3EuP6E1lh1+On6m2AVkqKHoZUG2Frrq8oql8w?=
 =?us-ascii?Q?BtauL1B82HXiiW8YKV6JRwSrarxbyYE5doADErPLuDWyR93EcgnkiWCx6V9c?=
 =?us-ascii?Q?w19y+flQ3JEawbS1Gu8U2vGagM+o3vxnp5RNl+bb/veN0ee3hu83DHxg+q8q?=
 =?us-ascii?Q?LRYiltkSIo0HO9SuQH+CrqtinQtph5jb3UImgH14ETZAg3sC5lcC9DlfmqWI?=
 =?us-ascii?Q?HTIy+42Bigxl3sf8BsiqXCMJrQegchw572raS0So8lvJcBd+XSn8YZ5mcNiV?=
 =?us-ascii?Q?IT2wzQAsZt0lZiXIb1ejM4WFyVC4qic0n/qi2iYLcOf7egBAw6sW7hHvaE9l?=
 =?us-ascii?Q?VH08FyyG9mbJvl4g0ZA=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 21:37:42.2423
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f221983-7b6f-4088-1b2c-08de3c222d8a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7033

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

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
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
2.52.0

