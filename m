Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011041.outbound.protection.outlook.com [52.101.62.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C304D39DB04
	for <nvdimm@lists.linux.dev>; Thu, 22 Jan 2026 20:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769114267; cv=fail; b=YjM7IoyT4kjEmNJjNs0vtOoM7uNGeIrwj/J2LS2zHGr3jCWk29/imVw2nEiqb1oAqIuHCX+8S7KZBiNFCSgjDWycpYmkfe2Q8Cs7KB72qyKQpl/E341OUEAWL9H+9vryPLh3OhAvw3MujP0Dz+Va10M9KWvQVbEzAi92u18WcPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769114267; c=relaxed/simple;
	bh=1eKUmtE+WpKOuwUNdm+utG8aR4F85W3B0EzH3i/SxfQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sQYj8qc9KogWRDT7CdOvBkc97qz+TVNhe0iLBltZO15TWkkKY96qhbpSCvtnlRIcg3aIgdapyF35udknLBilX7wag2IJQReJpXwpHFf8zgCIVOYono7hwQ7ejf+aETELUhrtptbo/dhAKkE3oQcoqUS/QS4hmazqJr5a8R47K8c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=M0txcpp1; arc=fail smtp.client-ip=52.101.62.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="M0txcpp1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ryLU7MxuOg4BzHSqq9Y4QhHFvOua0xvrtRL6A9RHwMQQ7V33La09aJqj4Iaw9NUCLoBFECGgL4r26EFZHaI4w5vHyiq4MimyGen7Bv/SrJ6CgoFUHYlzAVv05QFgOPgHJIYPgpQK/EcBVrbhsWTDTQqIxXFyoV00LBUTfq7jKEbK27FoXUWIc8Qqo96k9p7mMfOBneggXVqhoE2BTQFzW1Jr1x2z1YugNEHszkEiEqjewOij4UYjSRbW/ortnannQ7NUFNkT7xHt7x8z2CQdaBarh4UliyI9okjMbtdtP2MVhbJc4LHU2BFfPhC+lDjwLJPu7uD5l9/NExSjzi/1yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZC7cUFs4E0eOWfYYz6kb1kRWCK272Wz+D5DU06Ym7IM=;
 b=HkruqSv5HCpF3PfsskRJarWVe4Ly/69oDy/CyFe/tX3C3eBrvXbjRHkLW6QJ0RSMtaWw7aOLcoOcs+xtO7x/HiqNcU1SWdtoSfFbdeoYfP1dB/yzf0NPCJ6DnuZb5WH6NKjlmD0y2T7kHx9Ds72A3y/NcYk8PzWwO3UpcSoExFiKqecFGF5SzImheaA1nkhnLu09rqw/lgkeQ84qiZvHto09P1LY8j6AdisggTMM3lg2lL56SbBKaLDrY3kG2rI/t1gff9mkwFdJgR56zfutgjzCQZfHmjZuzshtmeebW1tNj9KTtI3aMv3ADFIWzjbJqd5jJflTvZpLDEjHIc4kDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZC7cUFs4E0eOWfYYz6kb1kRWCK272Wz+D5DU06Ym7IM=;
 b=M0txcpp1JEQyvuIw6wueUYVtT4zXzaNtIo5m+TunQ9kifcpkcUeJZ9a0GOL20eEO96EFCrCRNpXDCPjv6t5wGL/4Der1j4fKaDVwbMI+Yl112fio9iCvPR43yNHBZUX+AiiMeWhc+ELMZ8Apu7753QubHLROwroIIR29opb4n58=
Received: from SA9PR13CA0057.namprd13.prod.outlook.com (2603:10b6:806:22::32)
 by MW6PR12MB8898.namprd12.prod.outlook.com (2603:10b6:303:246::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 20:37:39 +0000
Received: from SA2PEPF00001505.namprd04.prod.outlook.com
 (2603:10b6:806:22:cafe::4b) by SA9PR13CA0057.outlook.office365.com
 (2603:10b6:806:22::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.9 via Frontend Transport; Thu,
 22 Jan 2026 20:37:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00001505.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 22 Jan 2026 20:37:38 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 22 Jan
 2026 14:37:38 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>
Subject: [PATCH 6/7] cxl/list: Add injectable errors in output
Date: Thu, 22 Jan 2026 14:37:27 -0600
Message-ID: <20260122203728.622-7-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00001505:EE_|MW6PR12MB8898:EE_
X-MS-Office365-Filtering-Correlation-Id: 97395c1d-6d99-4d4a-15d2-08de59f61576
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YO37nfQfcg4fnC61PSK1klWknrrwVjhfW1dNgcOdvKsCF8g58LY8RCmdOEoX?=
 =?us-ascii?Q?7y7+2NmEflKhmWhf6FjCJH3j4b7ASIP5tPhQq2hAz8h3L2RHWYFXssHKibDk?=
 =?us-ascii?Q?uJ68+LCKE8f0NZhgGCjgIcnykk9U9LLSBOarHXMlbG/FqnjYzX5lRvMNslne?=
 =?us-ascii?Q?Fo9pQC+DmExjU20zRMKSdL+VjYQ3o8arIhA2cUUyY+SW7Zvca43lzyNU2Vu4?=
 =?us-ascii?Q?MKwQXqjjNSeA1kN0Wt6OTt9Ve1alCRPcP/tkgmuHLjcfYAnEVIdbKjUk/NeF?=
 =?us-ascii?Q?moJSTlZIfOkIHe1ZJUIjupxHK/2aeraMAOqyI1h9CzjC9YZpQmR+Bf+rgKtJ?=
 =?us-ascii?Q?2f9sI5hOURigwKv5Q2aSX7nect1nwZWg91mvOgdKmqGvOFIDmkMInAv+L692?=
 =?us-ascii?Q?qv2Ae+w3C888F8O89CGO3XcNf1IkCUrz9sMTneRARLusWMaLWdyNsoze3o+v?=
 =?us-ascii?Q?RPqraP4KZvSsJe79YwWTKOpLPu06d6JHAK9YWaXZ9PUCYzsi1wstOKIynqQ0?=
 =?us-ascii?Q?VXlSARo0qyUsAZuogpM8YjwaPV700HOJkNt0HA1V0AHO25V3dBY3KnC5vsbI?=
 =?us-ascii?Q?KMBj7wMG0kKe3STG3BQriYqD3OX5s56n/becLqHfk3tmVBk6pBIR3OewN26n?=
 =?us-ascii?Q?mLDsEZE67ffDJMJVUuMOgNAvS49M+Pl3WQbOk8VIz2X3xFHcjDHBWCsTxEui?=
 =?us-ascii?Q?lRHvM2yQYAdvA6s3pJ4D2Gq9X5wpfNjmDrus66meW43kMsZgeUDIHA7XJ04Z?=
 =?us-ascii?Q?WBTVsAU3vkWAsz1AGV+LSBT4CI6zeHAJJohI21yK3mNenp0jBLoWlcSx9Js8?=
 =?us-ascii?Q?VST02iRO2CIMgPEc8tGbFh335oCdUpj/eTFob3BZY+GNWduijgizXM9gLBXk?=
 =?us-ascii?Q?lgDcX+QXJYma3AaLD02n0LPMYV6hXrAGEQTCHftIHN7I/dCe6/V5i393UMKi?=
 =?us-ascii?Q?mucx8/TEEKWDH9buBWZZjp/zT1nVuakDOcyX4E3DgyLZcgcO9QfmwHsh+Hgs?=
 =?us-ascii?Q?e+Vnq0HY9QkxEr2bKWc47J2+dRC4CJcq6QuX71uwOYyC1uyep+pk38FWaIWH?=
 =?us-ascii?Q?hLbwvbrpwjXBhdIRMKZOqCqI4GeXId7SPlu3rHLScfIb0mL0zG/Wg27kLA8j?=
 =?us-ascii?Q?BVDky7Qf2qX6kZfHvwm/5dr+hjE7iOA9VweCtOKb0XnY2DrrDMRNijrpvRiT?=
 =?us-ascii?Q?xLnESgYvZuu2/vISNB7hvhO+P+NIcqIck6Bx0zEepjnz/YYUeMmsd/PHIfGD?=
 =?us-ascii?Q?tkcYkDolceWf2tsiBRZGAc+eiILZ8y9TCWaOuI9SsvIhEBQ8La3JWKQsDQzl?=
 =?us-ascii?Q?HoMxNGGZxrhhQbcbqUj1jzUGy9Xj8xrwES5e6qmAYZS35BN4vG6ztph12bht?=
 =?us-ascii?Q?cg3s9VynWbvoMmfFRvIHTDJJhCLm3DA38NayOLDInmd46+mm61TlU7G7JXQM?=
 =?us-ascii?Q?8BmFyJzpc3bOWsBnWPLC9RilTpQzE+bEkUXU1E/I2CtDP0bEybLR9cCXSE99?=
 =?us-ascii?Q?0XLTspfhJHp4u6LPTY47Qa9UoauskZw3rOU9Jp3J6vvuVJx0Pg7grWgqehz+?=
 =?us-ascii?Q?ParBwz20puY0MmS7eZSOVE/zYkx5cE1/+yLXPfMvF/hhBUICNYo4IvkjKtEd?=
 =?us-ascii?Q?k1Qeul0/aMEhayDOCLKUzjaF+LxBDDZS7JnODyx+4+Kg/vvTEk48Mtgm0Wc7?=
 =?us-ascii?Q?4YyswQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 20:37:38.9438
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 97395c1d-6d99-4d4a-15d2-08de59f61576
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001505.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8898

Add injectable error information for CXL memory devices and busses.
This information is only shown when the CXL debugfs is accessible
(normally mounted at /sys/kernel/debug/cxl).

For CXL memory devices and dports this reports whether the device
supports poison injection. The "--media-errors"/"-L" option shows
injected poison for memory devices.

For CXL busses this shows injectable CXL protocol error types. The
information will be the same across busses because the error types are
system-wide. The information is presented under the bus for easier
filtering.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/json.c         | 38 ++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.c   | 34 +++++++++++++++++++++++++---------
 cxl/lib/libcxl.sym |  2 ++
 cxl/libcxl.h       |  2 ++
 4 files changed, 67 insertions(+), 9 deletions(-)

diff --git a/cxl/json.c b/cxl/json.c
index e9cb88a..6cdf513 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -663,6 +663,12 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 			json_object_object_add(jdev, "state", jobj);
 	}
 
+	if (cxl_debugfs_exists(cxl_memdev_get_ctx(memdev))) {
+		jobj = json_object_new_boolean(cxl_memdev_has_poison_injection(memdev));
+		if (jobj)
+			json_object_object_add(jdev, "poison_injectable", jobj);
+	}
+
 	if (flags & UTIL_JSON_PARTITION) {
 		jobj = util_cxl_memdev_partition_to_json(memdev, flags);
 		if (jobj)
@@ -691,6 +697,7 @@ void util_cxl_dports_append_json(struct json_object *jport,
 {
 	struct json_object *jobj, *jdports;
 	struct cxl_dport *dport;
+	char *einj_path;
 	int val;
 
 	val = cxl_port_get_nr_dports(port);
@@ -739,6 +746,13 @@ void util_cxl_dports_append_json(struct json_object *jport,
 		if (jobj)
 			json_object_object_add(jdport, "id", jobj);
 
+		einj_path = cxl_dport_get_einj_path(dport);
+		jobj = json_object_new_boolean(einj_path != NULL);
+		if (jobj)
+			json_object_object_add(jdport, "protocol_injectable",
+					       jobj);
+		free(einj_path);
+
 		json_object_array_add(jdports, jdport);
 		json_object_set_userdata(jdport, dport, NULL);
 	}
@@ -750,6 +764,8 @@ struct json_object *util_cxl_bus_to_json(struct cxl_bus *bus,
 					 unsigned long flags)
 {
 	const char *devname = cxl_bus_get_devname(bus);
+	struct cxl_ctx *ctx = cxl_bus_get_ctx(bus);
+	struct cxl_protocol_error *perror;
 	struct json_object *jbus, *jobj;
 
 	jbus = json_object_new_object();
@@ -765,6 +781,28 @@ struct json_object *util_cxl_bus_to_json(struct cxl_bus *bus,
 		json_object_object_add(jbus, "provider", jobj);
 
 	json_object_set_userdata(jbus, bus, NULL);
+
+	if (cxl_debugfs_exists(ctx)) {
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
 
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 3c3d2af..72d1f68 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -285,6 +285,11 @@ static char* get_cxl_debugfs_dir(void)
 	return debugfs_dir;
 }
 
+CXL_EXPORT bool cxl_debugfs_exists(struct cxl_ctx *ctx)
+{
+	return ctx->cxl_debugfs != NULL;
+}
+
 /**
  * cxl_new - instantiate a new library context
  * @ctx: context to establish
@@ -3566,38 +3571,49 @@ cxl_protocol_error_get_str(struct cxl_protocol_error *perror)
 	return perror->string;
 }
 
-CXL_EXPORT int cxl_dport_protocol_error_inject(struct cxl_dport *dport,
-					       unsigned int error)
+CXL_EXPORT char *cxl_dport_get_einj_path(struct cxl_dport *dport)
 {
 	struct cxl_ctx *ctx = dport->port->ctx;
-	char buf[32] = { 0 };
 	size_t path_len, len;
 	char *path;
 	int rc;
 
-	if (!ctx->cxl_debugfs)
-		return -ENOENT;
-
 	path_len = strlen(ctx->cxl_debugfs) + 100;
 	path = calloc(path_len, sizeof(char));
 	if (!path)
-		return -ENOMEM;
+		return NULL;
 
 	len = snprintf(path, path_len, "%s/%s/einj_inject", ctx->cxl_debugfs,
 		      cxl_dport_get_devname(dport));
 	if (len >= path_len) {
 		err(ctx, "%s: buffer too small\n", cxl_dport_get_devname(dport));
 		free(path);
-		return -ENOMEM;
+		return NULL;
 	}
 
 	rc = access(path, F_OK);
 	if (rc) {
 		err(ctx, "failed to access %s: %s\n", path, strerror(errno));
 		free(path);
-		return -errno;
+		return NULL;
 	}
 
+	return path;
+}
+
+CXL_EXPORT int cxl_dport_protocol_error_inject(struct cxl_dport *dport,
+					       unsigned int error)
+{
+	struct cxl_ctx *ctx = dport->port->ctx;
+	char buf[32] = { 0 };
+	char *path;
+	size_t len;
+	int rc;
+
+	path = cxl_dport_get_einj_path(dport);
+	if (!path)
+		return -ENOENT;
+
 	len = snprintf(buf, sizeof(buf), "0x%x\n", error);
 	if (len >= sizeof(buf)) {
 		err(ctx, "%s: buffer too small\n", cxl_dport_get_devname(dport));
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index c636edb..ebca543 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -308,8 +308,10 @@ global:
 	cxl_protocol_error_get_next;
 	cxl_protocol_error_get_num;
 	cxl_protocol_error_get_str;
+	cxl_dport_get_einj_path;
 	cxl_dport_protocol_error_inject;
 	cxl_memdev_has_poison_injection;
 	cxl_memdev_inject_poison;
 	cxl_memdev_clear_poison;
+	cxl_debugfs_exists;
 } LIBCXL_10;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 4d035f0..e390aca 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -32,6 +32,7 @@ void cxl_set_userdata(struct cxl_ctx *ctx, void *userdata);
 void *cxl_get_userdata(struct cxl_ctx *ctx);
 void cxl_set_private_data(struct cxl_ctx *ctx, void *data);
 void *cxl_get_private_data(struct cxl_ctx *ctx);
+bool cxl_debugfs_exists(struct cxl_ctx *ctx);
 
 enum cxl_fwl_status {
 	CXL_FWL_STATUS_UNKNOWN,
@@ -507,6 +508,7 @@ struct cxl_protocol_error *
 cxl_protocol_error_get_next(struct cxl_protocol_error *perror);
 unsigned int cxl_protocol_error_get_num(struct cxl_protocol_error *perror);
 const char *cxl_protocol_error_get_str(struct cxl_protocol_error *perror);
+char *cxl_dport_get_einj_path(struct cxl_dport *dport);
 int cxl_dport_protocol_error_inject(struct cxl_dport *dport,
 				    unsigned int error);
 
-- 
2.52.0

