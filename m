Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010023.outbound.protection.outlook.com [52.101.193.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A39311C09
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 16:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767974859; cv=fail; b=F+Sg0u7eFzeirAMjWpt3hmsUH6XdE5vzoGe23W0sf5YHIxhtLGsKsSgLC7NGM73P0SuU87NWvXSfORbsftyMv8LBn7yiKCEEaHFX1SnUiFdX2y2w3tj8xUtYodJVEcme9359b5MjEmgUPfUJsFhotpz6P0IMurc/mRdfHpXknzk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767974859; c=relaxed/simple;
	bh=kDGf3XUeboD0ZVI8Hr7exTMfUPkrQPJor38hMhah+Kk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E2tJx3/DdxSdGTKudZ567IVXYXnSD/mV7rQEcgb4HencuA5Uw0rwCP35UkV2gqwbO18yMLzd24h/fU1dKcD3KTtRBal98WhsFvhBUOH0ID9pDYKVsxN6vsZZW1erDyRKp5Bj2wdJRkl2dKD1WcdhhtxPkD2Tl9i0CwfYHV0ivjU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Obmfm/p8; arc=fail smtp.client-ip=52.101.193.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Obmfm/p8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZbN8mUqjn5pOucKlsNGP9nE4dH/u6ITDMQ+Q9g1gRM/3FVEXtNdu77fHMBEjk4wL1OaAS2Un/hw+LpBJ3sUlbY77D5c3WZ6SI6ksaeWGKwPEcW2S73MBZxBJqDnHzp0id1FineuVpSdw4zF9ywfGtST7pswNskWg8RJUL001IdWJ8zq1BL9taBOm2yvBFlD6oZvBZRQHS1D8lGbExU/m3wVo0wrySUvVdJZmTvWBlr+AQK2TAkTCN6n9jqkBgQ9txoMPI0NysAc2ohhJ5RXhANrkLOWIicZ6KYGJH8eqz55bfapd58yW5DczJMgl/nxg+x3/6t4LlnlyIAN1cp/ntQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=srTPKvMcJrE2C5sDNevqKxt7LkUFsVYyyof8jx2P6jY=;
 b=dxrOjYW2nXhgiFdvYeY1jOkfkgjsbvF+XcQUDM80uK/gVDQzyxdfucTQJioNO5Qec+obzRfFkddxpbT1H2WgHksXPdteO7HfVQo82s1VySODpA6XiUqO/HykHoUgrxpyfW0NJ4JzamQ/PBlI3opy6fXv11kHLvmG3Ir8+/gQu0y1uxGw2oPPbziFGzmajOU2pl5HmKuHNF8T/ilTSHS6Vfpl4BUn61I3SMfEFlWys89jkXzYlKDSaW0fyBXfAGgzjhKYwBdkHbrgSECvikbBqoiDstjv34gpqk3XGh8iwK4qf46RfDalmChFKw+3I9yAEJdExHaMCn5vHaVKbA4HRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=srTPKvMcJrE2C5sDNevqKxt7LkUFsVYyyof8jx2P6jY=;
 b=Obmfm/p82OKCdE6SBMkxcBOcBQDzIob/OWDUt8pFSCaNq3lTulEBPFUQqEr0veBGGy01tMofSd4o0QdeyTWZQQDjsLS16vLShZ6nlHWRc4VMeDyxApM0vd+Bxzn0QF58YcPbFR6imATHQIicSTBwQdyBR+GoZ4AJwxNxgQdHMZk=
Received: from MN2PR13CA0001.namprd13.prod.outlook.com (2603:10b6:208:160::14)
 by CYYPR12MB8964.namprd12.prod.outlook.com (2603:10b6:930:bc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 16:07:33 +0000
Received: from BL6PEPF0002256F.namprd02.prod.outlook.com
 (2603:10b6:208:160:cafe::17) by MN2PR13CA0001.outlook.office365.com
 (2603:10b6:208:160::14) with Microsoft SMTP Server (version=TLS1_3,
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
 15.20.9520.1 via Frontend Transport; Fri, 9 Jan 2026 16:07:32 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 9 Jan
 2026 10:07:29 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>
Subject: [PATCH 6/7] cxl/list: Add injectable errors in output
Date: Fri, 9 Jan 2026 10:07:19 -0600
Message-ID: <20260109160720.1823-7-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256F:EE_|CYYPR12MB8964:EE_
X-MS-Office365-Filtering-Correlation-Id: 64fd8bbb-9e1d-4a45-b79f-08de4f99324c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|30052699003|36860700013|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6uvydTkXoOrhu29Jtkv7u4gzD3EI1p9YDSAojHcmSNxzFUF1jO/Qd5ZRYDYu?=
 =?us-ascii?Q?SAwicQdSVyLdgrZRSILJYhDdnjCcgouGUyIwl//rUud79NGDiit5pHXW5oF+?=
 =?us-ascii?Q?QGzj981Pb524mTBtcjuEXmAhHM01r5hJWwpU8AMU3LecIAR7kNLa/hGH32w4?=
 =?us-ascii?Q?OsvnfPXPhyGPswqyJ6CACxAxWrTvzv5DYHJ3jaU1tTSYmrAE27/OVOcJUVCd?=
 =?us-ascii?Q?VSmTMqT+tznce8t8GynVup9XuEvkh/I4tr6iXOxG622Lt/5NeIz5C/O1v1bq?=
 =?us-ascii?Q?5+5UgodZJud2oioM2W74yN8vyvXm4mwACMT0bcAQS35JCcqcVyUMvFTYq0BQ?=
 =?us-ascii?Q?sGE1J5R3QKvbQN00GTREE0l5GHEhpW8sb1zywoLPHPkr+U/sgp8DNa6S6/eT?=
 =?us-ascii?Q?clnVnh2Nq4WqDi/I4HYFIHrRiXmfSAjFD6NZNf1Zlmr/FSfoFUnpqtF3HbLo?=
 =?us-ascii?Q?/FIMt1L36ScdDFq5CHiMpPmhjHBgNsnNmTaFE/QRnWAXfzGTUY3zLwDSvA0y?=
 =?us-ascii?Q?pWpZWKy3USEYe41iv9Vrv+9QahqQp84NkLxZHBcNtDISA6CdpRS+vUPTf5wO?=
 =?us-ascii?Q?NyXVeUV1SZhLq42sG+GUevVq9F27D2MwNreb0MxrGgDE8P3OgCx2Tx0AZM8+?=
 =?us-ascii?Q?ra/+8WF2dBxoBFiHtgjbWLPb+ixOFKpXvuB42uSbmAIevv4Nc6YSF5bSjF28?=
 =?us-ascii?Q?mYuXU7iXtrnky4DNSycxo+9VmVCRgQUFFJb3LMdFZsAPnBUnlq7JLdZRpG1Q?=
 =?us-ascii?Q?D6LTbi3dIYUyeWMfpyD493Axh6LEr0zsh4sHCFpxB/4B87nXWjryrCkauB2Y?=
 =?us-ascii?Q?IVGDY4lJbbIbR7/+25cLEzpRi8zJz/jp23w3PW3LRC0C7WEG/O9mpzAdQzQa?=
 =?us-ascii?Q?RF9NEKMrko/zFKBO08yL0X5AKUtJkT7PS+3khQxokmb54g8Ofh6+0i9cq7ab?=
 =?us-ascii?Q?5B1QVkCsGpSArlWXkcVfS8am4JzYjo34WDkX20AiVgOrF/HwqjBZbAYK9azF?=
 =?us-ascii?Q?ZijniUvVniIWr4Pg7QwjP2c8Nk3Owhf4+NdTXI3dK2687qngY72MsE5zUeFT?=
 =?us-ascii?Q?dx1H9sSxi+DTWvJi0ZGXEg91zCWv06V85A5jedpbQJsg2awHXm6roUtxstT7?=
 =?us-ascii?Q?z9Gyx0Rwz7XHtjtyCjHrZOWA1mNaHtbJAM3Nwr7h9SdSZz5+DvOrb+Ncc9ua?=
 =?us-ascii?Q?yjkgvJGyqrtXatNkYk/1JkxC7GDrL6irg7izNbGMOrFLh2I9Kricq/ytej/Z?=
 =?us-ascii?Q?U1TmumZbjc+Pf5zkdkRtHjZ68vSGcmuoLkHMRS1pMgzpmCzojpFzSFUvcnlO?=
 =?us-ascii?Q?vt6MQnlFvvQwuD7B+teasBVvMhTLRobjJ10ujKAygXVLMsYM8dXkdUw5k0Lp?=
 =?us-ascii?Q?UUKf5dV9T0ROndkESukU5ykm1YRp24u6w81Y6RVMiEsk38cuSl748snTZYqt?=
 =?us-ascii?Q?mx/kX0FKQxGAMj+eTA9LfYwbi7ave87ztBEXlMvwWKjHxfFEjfv0ZACRd8K4?=
 =?us-ascii?Q?5ghpFfUPNacihqfNXpPYZMHw2yPDGl/6sXt2nX/vk8T3lbB8MxljVEHa5Jh5?=
 =?us-ascii?Q?aVgNLVZJZfE1RacnTVg=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(30052699003)(36860700013)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 16:07:32.5227
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64fd8bbb-9e1d-4a45-b79f-08de4f99324c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8964

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
index deebf7f..f824701 100644
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
@@ -3567,38 +3572,49 @@ cxl_protocol_error_get_str(struct cxl_protocol_error *perror)
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

