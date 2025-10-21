Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011032.outbound.protection.outlook.com [52.101.62.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397C734D916
	for <nvdimm@lists.linux.dev>; Tue, 21 Oct 2025 18:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761071562; cv=fail; b=o0Y/wbitzldsECUh+hIFQqLItVvbjfdFfKbH6Qc/5Tz5ZZM9nR1/q/9P/r15glit7RPGVmLhi0BnCY0cHeCQ3gyVmDiWsgAjede1bszaC7pmFxcMgEj+DAMFvTahrCyKIqQhB1oRFB/4TFRBSUjhGNsGqiZKnJ45dc7DROvqlcI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761071562; c=relaxed/simple;
	bh=4TkZDq0Tb3fSEXCwBQCai2y52qaCr4TXGNspJZyaZa8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NIQukSNgjPW8RuIigvatTdjwTUMKgYI1DCQ4IE8dccX3Z4l41h0FSEXq11O+a1j9eOVGPsyfh1qSwJltCGPWax+Ryjk8XAB4kHqWOyNxdoI3+v7Omrduc8Q7LJpcaCSeK9UR+Q1ZjW5NEjJG1UAzfsMYRAZW2RJmwDM3sTuwkhc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KHwW6XiZ; arc=fail smtp.client-ip=52.101.62.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KHwW6XiZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D1Jo3BQej5WwbH7fGIGehE2dQ2VAhFGpQlFXtmASXUgZtxQ6q4e2Ms3K4pEnwouZUZjF1pPsYk8EzHmvkYcKrFutBl1vzHy3dRHR1ZrU/s3Klrn4LQZDWGTJuk367+xJAQ26YDf1FK0BjPunjnAwBf9v5gGyS8DJ5ToaHf+LXRISXguSmVc7jIsCl5WkdBAwYtkUgV+FwDZMaEoLfILF3g1YXUhsTSuZyezYNtXXM2GOxqs9ypdaERoqWzk3X4Y3o3qwbM+aotkkKb1dNw6kiLlirnw+78YkL73Z61ZM/v3yvhsQFp6mFCQx/clh6snGCBIbDUkEpuRMtYVABqcpnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jeiMP0c3DNwXQ4ck9bh4llQb9921zHO5+eXu9Q6c89o=;
 b=STwNl7LfA5nikro16q7HbqQwgsx0CiAlsb45By1jq2uTSDpy0LlU5EXP9oS214u2xyM0ksC4EtvR+7FS+2e0DrWcHxY2LRsvgSdaX2vDb+Rtuue0v3WKRw00BATfZBFAlc4+RPIg/UME/Z13t/Y0mHyzDsy0/I5EAeMqSmByKqHCvGT5kr2r8OklRH373UWUqRLx0UzpofFkXUqnC0v59yISHBHlIG4v6UVpOLNp9KZ6Yu/MgyCLfRXQcUtAgI4KlhY9a6BgtdYpcnbjQc6kdK+3aBy5GXJFnsYS/loHR2CHZwdG703k+lTSwglTEO8w4/GlH1WAqN1+SbzofQsOnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jeiMP0c3DNwXQ4ck9bh4llQb9921zHO5+eXu9Q6c89o=;
 b=KHwW6XiZct50/u+CdMwP+8PsBeNY3mmnocTJHPYHOBc3PJWOyJf1cJgMGy/tyh5+4G5+aE0t5cvh88/1H+qy4Z8JPN19i7H/AQn/FtxNRv+H9hyMd/+SRnPuvTGklb24pDYy48fMeOssSOVAYG3jnY0CAwFI8FkIR9q6pDgabw0=
Received: from SJ0PR05CA0033.namprd05.prod.outlook.com (2603:10b6:a03:33f::8)
 by SJ2PR12MB9211.namprd12.prod.outlook.com (2603:10b6:a03:55e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Tue, 21 Oct
 2025 18:32:38 +0000
Received: from CY4PEPF0000EE3A.namprd03.prod.outlook.com
 (2603:10b6:a03:33f:cafe::21) by SJ0PR05CA0033.outlook.office365.com
 (2603:10b6:a03:33f::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.5 via Frontend Transport; Tue,
 21 Oct 2025 18:32:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EE3A.mail.protection.outlook.com (10.167.242.12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Tue, 21 Oct 2025 18:32:38 +0000
Received: from SCS-L-bcheatha.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 21 Oct
 2025 11:32:37 -0700
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>, Ben Cheatham
	<Benjamin.Cheatham@amd.com>
Subject: [ndctl PATCH v3 3/7] libcxl: Add poison injection support
Date: Tue, 21 Oct 2025 13:31:20 -0500
Message-ID: <20251021183124.2311-4-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3A:EE_|SJ2PR12MB9211:EE_
X-MS-Office365-Filtering-Correlation-Id: fad91bae-16b5-4443-5f16-08de10d03630
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KX11W9g649h4COtdJ1CO3fCQI5qbI+TbZKRkEytbWz9kLnK03msUecsKrMOW?=
 =?us-ascii?Q?+fRqipX/xwrqEjyR/Xq/Yv1oqcjs/371801SDUV1e+aZ0aNnjbbTFLmf9j9J?=
 =?us-ascii?Q?0NgbwnnCBtRs05EX9ZT1lFByCoHC2Cbjc1BkJJl9ua09+xDakxWzAGpHWi4r?=
 =?us-ascii?Q?+plZ0tQBdeHctsAYTVaTmnxzuDBifp7E1CBmNtJ2q97/RyDKj/BJGjuYQ3iy?=
 =?us-ascii?Q?f7j4sR0aRu0OqiFc/kXqprgIv1/8zHzcepn2C7GGLoIvwKZcJLn+ZA2M8cdT?=
 =?us-ascii?Q?GE0jUeoyTwo2TQmlR/JKs/dMa379l+QHoJ6h++MtKzeo2+IIloPVOaPyHVLw?=
 =?us-ascii?Q?ixaVZu3JY60SvvtvMHRVS6sdiZgmEoEE02u5AZiMKS7WoxRFpmWK35By9Lvd?=
 =?us-ascii?Q?DbwLv3Qxfnwwae0DBx2M0VQEJ8+qWsT1S7n2n4Maxw2ecZI/WrkyMG9XX7Bp?=
 =?us-ascii?Q?ScTdYuf9dH61Gibj2WD/9/JhFLNTpl4b4B4zxhHZfbYFprIVnkl3Nk6EHKFb?=
 =?us-ascii?Q?0l0M2O/+RzBC0HQTiJelxQMH9nkui821hA30A2jQQblPqrXXlDIkGxxH2fRb?=
 =?us-ascii?Q?cWNESDqgl2aANhmOU2Vs2KAvIQoEjW8UNlWfMw0UneJXeeKNYZE70u30+P66?=
 =?us-ascii?Q?XtTS0d9SntIaeTsNM54Oigt2QRet1R/L4z2+6ZJhxSFjLZXWiritwMd5Lcjs?=
 =?us-ascii?Q?ZnYooAHAdl1BBQ7LWnnjAbxpeC8ktjt1TwDTi2MfU/P3GlPd2fxPsAS6xVYx?=
 =?us-ascii?Q?S0yM4PDoouhVfECcIBTxCkSogx7tC5eNmEGkS75T2G7WpSnRC7iTsQ5JZ7Cp?=
 =?us-ascii?Q?FuUKNz5H2dDelpe4uhcodBxrsXVH6hx8ZQSY4bOloHuTexStAIA+0pL7Arzg?=
 =?us-ascii?Q?HzCVKM9nUSfLMhV5Cq9xMf5nD8b/0QHofaRvUpkHXuGnmCtlXlTvFUgCIhH/?=
 =?us-ascii?Q?RE1mTovRsnV5szCC2umMHkysDsrMKj/qwkaTz8QFEfIU4pDiIJNdz0D6Njah?=
 =?us-ascii?Q?oDc0ah/PDj3tx0FGYsFwfKQbQ3gyw2pFwb+ZWBIrZll3xe4hY+ucPWQV0+kq?=
 =?us-ascii?Q?rMJayu9vu1iU+CEZdOsWL4oo/kc40YWfaKXCoCjD8goQM5txeQreHBsRUkoN?=
 =?us-ascii?Q?EEiJAuNd7WtpmT+2QS0vNIC4Rmpic1ivROMuE9tB5Ep9iONYii7QPSw7OWzH?=
 =?us-ascii?Q?hG3O9yaekJlQs1p7MWJXTgTgXzeRihrNv33hWSviFP8s8TmIU4aql+Xhf/VO?=
 =?us-ascii?Q?reBuOuZXS2gRt017LduAqDsAT0zwr7vqR+tNpAsTg/sGebSCVRulm9JHmBkE?=
 =?us-ascii?Q?vz81DgEE8ly6F+0VICg7BgOEEHbQ2kuczIITJJMCj4UP+ju54+1ehOh8UTvc?=
 =?us-ascii?Q?qlrTgnjJpnCwgBcMNXAuEkQGA7CWtNOrmxy0j+1kvQ4o2h8qB7KBiq6Rdmlc?=
 =?us-ascii?Q?I/IFaY77rajg0US7s+2l5R9YpPiaTFlncz49DMZ5mF/YcrMFY95Pcc1bPe67?=
 =?us-ascii?Q?gPreSNF9XfVTwkL6zOQcRN/6Kog/l/OxOr5CDf+1r3jaaKi5znAYvYQ9EaUw?=
 =?us-ascii?Q?/Xue8eseCvv3Ch1Do50=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 18:32:38.0685
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fad91bae-16b5-4443-5f16-08de10d03630
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3A.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9211

Add a library API for clearing and injecting poison into a CXL memory
device through the CXL debugfs.

This API will be used by the 'cxl-inject-error' and 'cxl-clear-error'
commands in later commits.

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/lib/libcxl.c   | 60 ++++++++++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym |  3 +++
 cxl/libcxl.h       |  3 +++
 3 files changed, 66 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 9486b0f..9d4bd80 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -5019,3 +5019,63 @@ CXL_EXPORT struct cxl_cmd *cxl_cmd_new_set_alert_config(struct cxl_memdev *memde
 {
 	return cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_SET_ALERT_CONFIG);
 }
+
+CXL_EXPORT bool cxl_memdev_has_poison_injection(struct cxl_memdev *memdev)
+{
+	struct cxl_ctx *ctx = memdev->ctx;
+	size_t path_len;
+	bool exists;
+	char *path;
+
+	if (!ctx->debugfs)
+		return false;
+
+	path_len = strlen(ctx->debugfs) + 100;
+	path = calloc(path_len, sizeof(char));
+	if (!path)
+		return false;
+
+	snprintf(path, path_len, "%s/cxl/%s/inject_poison", ctx->debugfs,
+		 cxl_memdev_get_devname(memdev));
+	exists = access(path, F_OK) == 0;
+
+	free(path);
+	return exists;
+}
+
+static int cxl_memdev_poison_action(struct cxl_memdev *memdev, size_t dpa,
+				    bool clear)
+{
+	struct cxl_ctx *ctx = memdev->ctx;
+	size_t path_len;
+	char addr[32];
+	char *path;
+	int rc;
+
+	if (!ctx->debugfs)
+		return -ENOENT;
+
+	path_len = strlen(ctx->debugfs) + 100;
+	path = calloc(path_len, sizeof(char));
+	if (!path)
+		return -ENOMEM;
+
+	snprintf(path, path_len, "%s/cxl/%s/%s", ctx->debugfs,
+		 cxl_memdev_get_devname(memdev),
+		 clear ? "clear_poison" : "inject_poison");
+	snprintf(addr, 32, "0x%lx\n", dpa);
+
+	rc = sysfs_write_attr(ctx, path, addr);
+	free(path);
+	return rc;
+}
+
+CXL_EXPORT int cxl_memdev_inject_poison(struct cxl_memdev *memdev, size_t addr)
+{
+	return cxl_memdev_poison_action(memdev, addr, false);
+}
+
+CXL_EXPORT int cxl_memdev_clear_poison(struct cxl_memdev *memdev, size_t addr)
+{
+	return cxl_memdev_poison_action(memdev, addr, true);
+}
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 02d5119..3bce60d 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -304,4 +304,7 @@ global:
 	cxl_protocol_error_get_num;
 	cxl_protocol_error_get_str;
 	cxl_dport_protocol_error_inject;
+	cxl_memdev_has_poison_injection;
+	cxl_memdev_inject_poison;
+	cxl_memdev_clear_poison;
 } LIBCXL_9;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 9026e05..3b51d61 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -105,6 +105,9 @@ int cxl_memdev_read_label(struct cxl_memdev *memdev, void *buf, size_t length,
 		size_t offset);
 int cxl_memdev_write_label(struct cxl_memdev *memdev, void *buf, size_t length,
 		size_t offset);
+bool cxl_memdev_has_poison_injection(struct cxl_memdev *memdev);
+int cxl_memdev_inject_poison(struct cxl_memdev *memdev, size_t dpa);
+int cxl_memdev_clear_poison(struct cxl_memdev *memdev, size_t dpa);
 struct cxl_cmd *cxl_cmd_new_get_fw_info(struct cxl_memdev *memdev);
 unsigned int cxl_cmd_fw_info_get_num_slots(struct cxl_cmd *cmd);
 unsigned int cxl_cmd_fw_info_get_active_slot(struct cxl_cmd *cmd);
-- 
2.34.1

