Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2066.outbound.protection.outlook.com [40.107.223.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C8C202C5C
	for <nvdimm@lists.linux.dev>; Thu, 24 Apr 2025 21:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745529905; cv=fail; b=na8mmrM4x3T+FM5pXMvFrW/Kjenw2aTcnY8SvcvkO7uddTIDGyPyjAktMoT1TR+PGvYZljCT0Rim3gGDYFCgyJou9Onl+doQtY0fRsxTAumAJTVgYnEZoSQgrbs7v6r1bBs8gTF/ujKYsSl658Qh1HbEKVrJzKJFqBCFz7OQyeo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745529905; c=relaxed/simple;
	bh=wyGFj4t+9rgkI8nYgePRhCERgpeA229E0YayvgigkTI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sXc/BAqUifJX5cw2j9dAF+iMgsr5zhl7KtjtrbWwRUcRMLJE1jkW1AS/GujdJGBv2QiLv0Zww5IHD8Avzgrwtjkl3V8FXp8kzmEfGeT0uEo5WOhmk3SWxLE7gvqTUFdoZK9VbxunNzWf16w+ObQHYMFftnbcQJLIn78CEF/t2b0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GVpDT7kB; arc=fail smtp.client-ip=40.107.223.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GVpDT7kB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zKAIGT7qMTIe+jrym8kUD6RvqIYSeOQzFSe7nFMAkOU8u5yd9BaqAkaX6StwA++U05VbV4bMwxAjl5tl08GVEq/2KZDR+XBWfK2l+nR9o97DNQH8S5v6LTfIjJmpSrKzwtdlXrZf1kusGFMCcjQ5V47G1rWkc2j2mM8cwQ31LCynNCvQLTug/DvOm2hKUXuPsqnXFjlzR2NcMAWIy4tWyv/2YKCuFjctbpJB4GtlX2/CLeOYG8XynIHI/vOUdejAc9Na08Ns+jCgIs0BuUudt8aYOXI6h0BPHf4cdTjdFs2qAq3gbkL5wwck2Oa7felLg0jAGeF0fBexGgMeOJlyTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wRf+EaRbenTnD+jxzJuj06mnzdnq6LbUJ0msdFNyZe4=;
 b=YucedcEZYMFWln9BX2txVCh2iYbhEwyUzu1PFHC+Z6qbHgaaTlAJ2aqd9+UmqAx7YIeyHK8FM2Xj+HdlaYtgoZk3O7tITHXvCVj6XcenYeNp8dxM8wbwRrI1WXo4juuXtHQVqUvLnjzaTkhkIDA6kGlhNEa1+FFGCK3ndwCQ83ZseVlvItShmMjw55AWspnRD0DEgBbviEYuKE6hGCxqP5dUT2MMqyf2LBgubR+mSSP6dwTj+ugGZxIHI8t3ABSavf2nSad9oPxgvUHf0hui1vUqOhEML7UiuHhQfli0mGPkcqCupUIXzCaPiG7ebbT2vx8L+rmNYcPRbIRNpO/1AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wRf+EaRbenTnD+jxzJuj06mnzdnq6LbUJ0msdFNyZe4=;
 b=GVpDT7kBALvs0JSgu/pwvnHZRiKImQv2uzoknE0fKJ/U7V6vNn5MdQrSi9jxI4OiooNGIczkIlI1wgCTy/CqAD8ci+ol3JMhonGGSKIblpvO5Y9sKFzqzPo8UPSZ9oy8pITgaGmW3cBVQvdxDsn207FhNi11HowUJZ/hN7C/8IA=
Received: from SJ0PR05CA0164.namprd05.prod.outlook.com (2603:10b6:a03:339::19)
 by CY8PR12MB8267.namprd12.prod.outlook.com (2603:10b6:930:7c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.36; Thu, 24 Apr
 2025 21:25:00 +0000
Received: from SJ5PEPF000001F0.namprd05.prod.outlook.com
 (2603:10b6:a03:339:cafe::33) by SJ0PR05CA0164.outlook.office365.com
 (2603:10b6:a03:339::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.25 via Frontend Transport; Thu,
 24 Apr 2025 21:24:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F0.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8655.12 via Frontend Transport; Thu, 24 Apr 2025 21:24:59 +0000
Received: from bcheatha-HP-EliteBook-845-G8-Notebook-PC.amd.com
 (10.180.168.240) by SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 24 Apr 2025 16:24:56 -0500
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>,
	<alison.schofield@intel.com>
Subject: [PATCH 3/6] libcxl: Add poison injection functions
Date: Thu, 24 Apr 2025 16:23:58 -0500
Message-ID: <20250424212401.14789-4-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F0:EE_|CY8PR12MB8267:EE_
X-MS-Office365-Filtering-Correlation-Id: c353726e-9faa-4e02-6eb1-08dd83767797
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yVLMf7TsIE7fFTNFeHuiKc65bP+AmmeIH2D+NKvlIZjag3eNuwxUA+bljjBO?=
 =?us-ascii?Q?TNuDSZuxKhoSS+nyymLs6t/ku5qBAQ4sml3DNcJRv8bdIwa2zCIVj9njJ4hs?=
 =?us-ascii?Q?U4Vi889tcHoOhOYneL0FOVcuUUI+cTKKQbRl7cfg+YW1Fu/o9W/2uhgmVjol?=
 =?us-ascii?Q?ulPQj1yDIu5iRspbFHneyAcIvNarnUFQKiQl4pIgI3kNV7ONPRPX2kGgeooO?=
 =?us-ascii?Q?Ey3YQ0noVieO0f4q9sellgl1dnZjfRaYEE4OITCzC8WUU3e2BKThmRK3JkYo?=
 =?us-ascii?Q?I8V6c3XOFpuEDJqHyiPhJ1R1/HrhWTdQZCaW6MdR3AF2rUMAs0R80xxWEIGH?=
 =?us-ascii?Q?5AEacig+7qi0chNm0XgaZwII3+8W/Hs/Gi3D22WHRi1jglLmw80xAR2zGgui?=
 =?us-ascii?Q?mwHwlTOoCiENTCGuo3rWqQYQsGZPtj7sQv8Ux8UG1bS3LXY51BXfpxOGcABi?=
 =?us-ascii?Q?qa4TyMTgE977GS+7kNEZnZ/sEQ9lf9FwuXJIXgkWdLSRAw8ydFYO5tslV2Sz?=
 =?us-ascii?Q?oPYM4OId2SVzuZqKbN0WPraEKlTZOMKWsMcs9+GCmOiX0fW/TA7YnLs15XqP?=
 =?us-ascii?Q?jt6imfaJebD6FGyjqHTdXhwWtieveQljNghy8OuXcKC08Fqzv2EgYaFAU0O7?=
 =?us-ascii?Q?rzxcDUOU5Se97Yl4ARgiALphhveb0IM52hi5i89gw3JkhJm9+y5a+4qHqg2+?=
 =?us-ascii?Q?udsQGn6ZAK4gtjpg29TdBGP9LW6PpFNr3i22uDkNCw8jlnSdvgvnoubppsTr?=
 =?us-ascii?Q?Y21FrI2bR3JLdcp8pPrsS3t6igzUcUdXYQReWKmZKt4+fvgtcZGkQwYv4RGP?=
 =?us-ascii?Q?KwUmZmJRJJMdtX3BPCg52wD3J4X9VZfWNrTfeY+cURbeu1BN8KFcJ8ikl8UM?=
 =?us-ascii?Q?uoc4wIF07563EPt2PI/LO03q7gIijLRlOWO9V9OBlAkfBAgzoP90tQpjZYNq?=
 =?us-ascii?Q?qfJgouVvXtosT8bMK6PfGglEjQxXXnJN7EJodI6TB9a/ZuztnisEaO8qw90A?=
 =?us-ascii?Q?SC68+ABrBkFtt9R9i8sBuDaQQodVyeigzW6IIATDDPIO5rT60h4WvNgHrknC?=
 =?us-ascii?Q?fFWsyl92SDHVwcASmFUNVyb/APfubi+Tvmn23M/tf34mhkwW9d58ZLspjqmo?=
 =?us-ascii?Q?09btJ1Dbxu650w0qC5OPnrnZKekwFIlWxXGGEvO8NJDKTtW3USP1oWRBvK+f?=
 =?us-ascii?Q?LBahManAf5FsHcNGpWrcq66ypDe3iiKx7hLphwNMHF90o6DnJpYDsy+qP70C?=
 =?us-ascii?Q?6xbOPpZcMXmT8Sobyf/a6/SwElo1OdjsoZK+mpnH7W++iPDr8DOA5vQ9anBt?=
 =?us-ascii?Q?NZHZOfgjHCZ83xJWm1VfqM3oaRhe8pTQ4AHz2RyEKGARHSbTUM46yVIoVKfR?=
 =?us-ascii?Q?Ch9euM34cqr8g5nnrv2PLCh/83IyoOiTYSk7ky08rHRQh0LSa/UkdAVCOYGq?=
 =?us-ascii?Q?U6MZXzizz0D90gA9YQDDDaqNsbfxzLX6fcvLi+k90U1qoV4+5CONZWBdvP7b?=
 =?us-ascii?Q?oj1Dxqrb1xHZCkdGV4bWNdXYwldLGXpmqXUr?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2025 21:24:59.0708
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c353726e-9faa-4e02-6eb1-08dd83767797
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8267

Add a library API for clearing and injecting poison into a CXL memory
device through the kernel debugfs.

This API will be used by the cxl inject-error command to inject/clear
poison from a CXL memory device.

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/lib/libcxl.c   | 52 ++++++++++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym |  3 +++
 cxl/libcxl.h       |  3 +++
 3 files changed, 58 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 408b2a3..bc4b08c 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -4856,3 +4856,55 @@ CXL_EXPORT struct cxl_cmd *cxl_cmd_new_set_alert_config(struct cxl_memdev *memde
 {
 	return cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_SET_ALERT_CONFIG);
 }
+
+CXL_EXPORT bool cxl_memdev_has_poison_injection(struct cxl_memdev *memdev)
+{
+	struct cxl_ctx *ctx = memdev->ctx;
+	size_t path_len = strlen(ctx->debugfs) + 100;
+	bool exists;
+	char *path;
+
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
+	size_t path_len = strlen(ctx->debugfs) + 100;
+	char addr[32];
+	char *path;
+	int rc;
+
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
index a0ab86d..783a257 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -296,4 +296,7 @@ global:
 	cxl_protocol_error_get_num;
 	cxl_protocol_error_get_str;
 	cxl_dport_protocol_error_inject;
+	cxl_memdev_has_poison_injection;
+	cxl_memdev_inject_poison;
+	cxl_memdev_clear_poison;
 } LIBECXL_8;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index f8b2aff..6840d2a 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -101,6 +101,9 @@ int cxl_memdev_read_label(struct cxl_memdev *memdev, void *buf, size_t length,
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

