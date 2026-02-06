Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012009.outbound.protection.outlook.com [40.93.195.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF052E5B32
	for <nvdimm@lists.linux.dev>; Fri,  6 Feb 2026 21:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770414634; cv=fail; b=ItM2LPzYJ0XlNVQq/xp5wHfbYQWDKoIUwMgKgK1RndYoaWuYVUBPjpWQsP2tDbnbvq0NZYdAU/HTzjvBYsWnPdP5vuG9zrey0t4gCP393e/stp+Wj24zJOsWPGZFq+5L54y7C+T/ig4NJHZGukLB9mHDj4fmI31jyHKyrILF+IY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770414634; c=relaxed/simple;
	bh=JbjTItvXsjOlWC3rn7bNKXKBGo1QEIfmoAF9mDYWhrU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TircQjAl63CS00og8TpGkGMsmoSIEKC6kp6Q2EUCmC2h/yIf2jSaA8CuMayccMKOSRx17adiZITvjjkixdDH1jjrL2ysS7+pcaKVQGxrYKZxz/rHIIbNOQYzhpq8eNdbEwXgDSol3+n+XFy6u3E3+mp85rwbd/Yekwpz/na1zW0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4Nur4sJx; arc=fail smtp.client-ip=40.93.195.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4Nur4sJx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l+vBmaHp+sbJrxID8IMGnIFHvstDSnarVxnzhNXR6P4TBUJ22+x9wlBzUiEZzYFjKorxndLvcBAzVVwXMVC70nA+OwvwXK3S5CKvYGnebYgRGvKMxxJe3lUOZbLiiFQWC53i4+Y+sIfy9h3kpbMW6WqqVHaCjEABUjKKkxbi6C30pMYu1fklSSWnyDu7Cykita1GA9iiz6KDBu6qpO61ougwYAtid5BYh4P7g8JuigOSwNZRf41vEcuKugM+AVn+vhaoopiab/k5bo3klGz9Rsd0Yv96J0gNDHNexxDYuSoMnFhRL9s9QDdeu2ILdtSRwyYoMYUqXBSf4Q0Lot/vTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Tpv4VXqHo+i8bFl7mKr/XV5PkU5L6uJzq5uFv0/NWo=;
 b=UjeBkk+pXYZAT9S6j7yggFgG4o96QoNv6CaNo21UOdpnzJLb12ZfbNE+lFpaRJzSZt05GeN1xZpyaYso50PHDgcVkEMftD9uv9BcEo2aF3WplmpmDJVgiE1tMoFDVx9zc/ulRG2j6E8JeRjYjdjU3kVMOvTlKJ/FMisYVz//J2rEHloD6f3hQ6mh6tIW7ZVN+Y5jj6awwZBg5d0ajeBHK9GmPh3g4ho4UPlSZkmsYcMbc82xlIFndKdLEr/WOZ5F7riN+e1s3Lec4YRIgazYTNaKSUKzjp8AtODmXI07x6mgrVQXeOgBAjKPi9No8pqmYQpGzSi5rm39uuPNCoLFgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Tpv4VXqHo+i8bFl7mKr/XV5PkU5L6uJzq5uFv0/NWo=;
 b=4Nur4sJxKj0VGdizFtrVpPSti8+o3QsS3I5fGBfgYZJjCh3jnGZt5vDvuIBsu6iFrM3UXCa+VymRmUPxNO3psg2vz1OaGxjOWhjGNOwQpt7nGh+XkM7DW6vMLua0PuJ/VLDiiNsx6VaEHgaV2H0E2XG1G6+Qgo7H3K20I2qGbm0=
Received: from BLAPR03CA0174.namprd03.prod.outlook.com (2603:10b6:208:32f::11)
 by DM4PR12MB5985.namprd12.prod.outlook.com (2603:10b6:8:68::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Fri, 6 Feb
 2026 21:50:30 +0000
Received: from BL02EPF0002992D.namprd02.prod.outlook.com
 (2603:10b6:208:32f:cafe::ab) by BLAPR03CA0174.outlook.office365.com
 (2603:10b6:208:32f::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.16 via Frontend Transport; Fri,
 6 Feb 2026 21:50:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0002992D.mail.protection.outlook.com (10.167.249.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Fri, 6 Feb 2026 21:50:30 +0000
Received: from ausbcheatha02.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 6 Feb
 2026 15:50:25 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>, <vishal.l.verma@intel.com>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>
Subject: [PATCH v8 6/7] cxl/list: Add injectable errors in output
Date: Fri, 6 Feb 2026 15:50:07 -0600
Message-ID: <20260206215008.8810-7-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260206215008.8810-1-Benjamin.Cheatham@amd.com>
References: <20260206215008.8810-1-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992D:EE_|DM4PR12MB5985:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d496ff0-0e08-489c-9459-08de65c9bf7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|30052699003|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A4FCyctG5op7MoUkbLWJKEpGFz47dzq8f2h6WaTjUy/syKvvHjbV4HNWyvPc?=
 =?us-ascii?Q?gWrEamKkTdj+kOSv2hnViYpLkfCdbkznVvqeEMxobmmMC5oiu1w3F3bwP2XZ?=
 =?us-ascii?Q?Z1+zkpd7n3CzgoLoQx1lTGFwSgM8A+CLw0jDe0//QFH/yRsgmF94vqu4nxuz?=
 =?us-ascii?Q?umyhL1IRpdOP6BsCCmF77CkZ7mI3JmKSt/huwTMoLQTBK9d4iIFH9wEwfXqd?=
 =?us-ascii?Q?BaS43oVjUXNanJCtnN7vxeLgSv/rggZbHvzb7xyrLjsm3SEwV7LZHGRFDwCF?=
 =?us-ascii?Q?lpgpK6TW9/eYr6Zap/DlEj+5/AqOTOqCLolutESk/4djtJSoAplKdX1psgXp?=
 =?us-ascii?Q?4JNxWnXPVwjTH47wK2mW9h+hEXvsIV39LyxeRBm9IFhMBaUWbLrUhO7dBKBh?=
 =?us-ascii?Q?5+TF62ZSuuyj1+b/D9SXItKueacsI0gMe2lBHG1lhwIx9xpvbvQGTk3dkj9W?=
 =?us-ascii?Q?j38cpe6MRfiZLdXcSA4FYq3b8SGFGVAMwGuNWZqftuqhdCn6KAOoBk9KTqa7?=
 =?us-ascii?Q?fiYwaednSJdoCD9FQmX82kmSRoOZlOuUI9DoFuK85okLckeZsj5X/5av6dA5?=
 =?us-ascii?Q?EnUQZWvirm1P9lIZiTAVJgAFAlybVsX8YqGVMvKRXB8UGKKiK4lHvfLQWK2Y?=
 =?us-ascii?Q?teokV3V9efB5arW2WMueRmzkq5/lIdbb+KIjJ4QxHEze/ZnLetXGxIKqKm6p?=
 =?us-ascii?Q?0WLne6MhqndyVukhPhMK6N7LAA+EoxzBdi3o/xWU4vGHT7sz4QhnHwHVyZ3z?=
 =?us-ascii?Q?3TAujzYj0BiaSvwH2i6nfjfL6zLOkPqYocTvFkvYWKQ2pDFdKr6kocilv0mi?=
 =?us-ascii?Q?5IsneZ2sCVhiL0W7JKW+8oR4qoxHDiYGpxVL3c664F5ul+BuLlH2V8ihSItq?=
 =?us-ascii?Q?Kmd6w/xnJ21LnfJoZ+nXoU5ZxODoZAZVS6tNEUPk5n+oTtwfGiHkIRPJjp4/?=
 =?us-ascii?Q?MVt3r7H98yK3lRI0PzoDp/UChEujyF4fUUnzZqPxOadpo/cLkQgdpV5F0CRz?=
 =?us-ascii?Q?y9G15atr2cZhgJ3q1zT2nULC0EI8Ij6Q4b215VK0kQ+nuZTMGrwsfUzR4PAj?=
 =?us-ascii?Q?cImwiPnep/FM9M4hF5otCQGSVY6GidIUFInmdCbol8W4p2jnX1msg3B1pKzi?=
 =?us-ascii?Q?SBywbUkOuYmZ+yrTAFwH3aPhnyfUArvkc7m6/2CRqfpNuCG6muRhwn4Hsk+X?=
 =?us-ascii?Q?0JDNV+GA0wb9BRKe+xsqjsuLVQ8bNimp7h2n5m9FkSQv2gsZpKh4vYzLN65e?=
 =?us-ascii?Q?Fbk4cT9y9f0fjt1xdiAb6BUmPTkT5l3wDbUqUWaL52HUz2l1bQIYaiGq7JHZ?=
 =?us-ascii?Q?FjpEMKr93I8T0Pi+Ah8trQPpo6KierA9xl4m84DGF0EM8IClhmN4QRsaSHHs?=
 =?us-ascii?Q?Er64ZvxYeMZJD854R/gfuAxmpJsAE4qUwukd1Z9hmb7bk1jGGxFTIhUqKwTB?=
 =?us-ascii?Q?gO/t/XfLV0BSfbFdxPS4NmUN0e6VN4wQGwfLuNZQkYQE36BU+sOYacFEJP0+?=
 =?us-ascii?Q?I4/TvslPVV0JlXFSGwWnyQvDc2n8B4zABcGQkhwvQAlgTOc7jVnvoThAXIUd?=
 =?us-ascii?Q?5Z0afgluNHVuBq5NlKxVh+zbaQiN7X6nqCRzmsJiEHSwVQGVGqMsAkLwISCB?=
 =?us-ascii?Q?lrzSnI7HIAdZxDGCJMUUv/NpztEg2/EGOIp1aTF1BZAOkvkqZjNrYf5PhwJ2?=
 =?us-ascii?Q?E7xbnw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(30052699003)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	iteFbNLJVpEOEthXJLNAd+qr51Hevi03SKe9tpZNAJkedGg6pxs8v4GVHmVFZoDcKdTIICS6irveUDLeC+XzuXva0c9ytc3yHC8dairavQcX1UjWGGrP4teyk0rnJ2jk4jORo+eQO9IJeHyd4ur75cUDvmYZrpY1fAuVLPA8c4O4+Zzwc7F6oBA6XioiVY9LRZOSby5m78oTCi0Iadb334mIhEBzN9EgRct24pFP/VBgebMmCBCnEsGF3qoj32ep1N1lQXNODlqK9jjm5/ZfGn4JulgjLyAgPbm8Mgt9/UfSIm6KucQYZx1jeXGrBSVCPpI8lqR9bI3iayuyNnpG19cse36CFC4QuAum4CLUZSa6LE2x6ITnn3Bj+v89Nzkg7wSX8DoWbhBZQ07ALe/nBfqubM9uOPgmzEHdYexe3BPP44vuhiSFPbRTQ9zL6rRT
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 21:50:30.8131
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d496ff0-0e08-489c-9459-08de65c9bf7b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5985

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

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/json.c         | 38 ++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.c   | 34 +++++++++++++++++++++++++---------
 cxl/lib/libcxl.sym |  2 ++
 cxl/libcxl.h       |  2 ++
 4 files changed, 67 insertions(+), 9 deletions(-)

diff --git a/cxl/json.c b/cxl/json.c
index e9cb88a..a0dc343 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -663,6 +663,12 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 			json_object_object_add(jdev, "state", jobj);
 	}
 
+	if (cxl_debugfs_exists(cxl_memdev_get_ctx(memdev))) {
+		jobj = json_object_new_boolean(cxl_memdev_has_poison_support(memdev, true));
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
index 308c123..d86884b 100644
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
index e52f7f1..797e398 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -308,8 +308,10 @@ global:
 	cxl_protocol_error_get_next;
 	cxl_protocol_error_get_num;
 	cxl_protocol_error_get_str;
+	cxl_dport_get_einj_path;
 	cxl_dport_protocol_error_inject;
 	cxl_memdev_has_poison_support;
 	cxl_memdev_inject_poison;
 	cxl_memdev_clear_poison;
+	cxl_debugfs_exists;
 } LIBCXL_10;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index aece822..a853ab6 100644
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

