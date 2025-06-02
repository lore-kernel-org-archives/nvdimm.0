Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2079.outbound.protection.outlook.com [40.107.223.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8681993BD
	for <nvdimm@lists.linux.dev>; Mon,  2 Jun 2025 20:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748897842; cv=fail; b=bo8U4EItS/BaiIrohBG+YQ849ezxoAZQS/PvUBfYLe1Zsqy/5oHbhp4CxdkAtWHiYHFz+nvnyIbuewa1c+A2q14rTLEZiIk2XMDGdxXHGve0r3FlmNcu1jU91jXZMiauSBd9ESUy/lWMfmnvmSl+sQbVJTBOcZZUdkYlTA2MDec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748897842; c=relaxed/simple;
	bh=amYJkMRUoX1RhXK4UNKzCGEYr42XRUHHkJyvxCNyLB0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vEbhz9qcRaKMgHU8TRgP/tCOgm0yQJRDXLGsvF9DkvlZJQ6cQ9CYYBFo6kgpIqHH24n48fRp4ZvtcazPW6d3mY3mG4BcTg0+L54j4Jo6Q27+QEB661Y6RvMIrx9AjJt7t/T1TOlhM8IxFRW0HDOku1vt0levRfP2w4svVY+j1IE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MFuVpu9j; arc=fail smtp.client-ip=40.107.223.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MFuVpu9j"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jRnSa3SCyTGWc3L+eZIwt+py7sBc91P4NnkG+SL/t1v5u3Pcyv4Gxj3qj7XhGrQjOLScShFsEigvyPU8seiRz6kd18rskxBk3/0HbvIlcSJvC/tpaKXbfc9pq9s/+lWzTmVbXzJrRNWMyoGV8mSD4yoeVlBmKALdPuwyfMGzpG+9Q834DY8uEBBw2OFe5K/FODAELWnqYZ5eNtXDCNoFgtTUOOxycLBgYD5vGdMrCSEbK9CF3onKuj8cvDS9/HnphVVxBZCmYk21/YwJyS8uf2LYb2jhtDRwZbF9FBBZk8wENfyD5B/nL/HW/0zsLEGOM4gnbfZArTaXtU7X4JK0Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FBAsX1G457gVcjkfVHbwK03uN5eKzwV4tDYKpZIdeQs=;
 b=fO3ZM+36GeyFjOpRfCv0P4Sge/RXIk7j14GodELMyx7XVZu0hO5CaEG5+UKSVTM0WOYvl3VPD4KfmlZmt83T0I+AWZgUD0J5Qp2UrI0uGuE4MMlHrL/wU8o+ygkWxAMyq617qhstGhTAYP75K+7NwkmX5X12oEvpDwyCAMUq4LhNlMA56S2+C88/+9p8iLu1sVqNR9Eziewy82kCEL2ivYIobZ3IKleeH4QRGGnXlYkhFffdcJp2wK/ya2oAl4Fbxy1NusZ7rsRwt7CJjCmZg1JY5hdhUfqkoZqupCouucR9ADmvosXQ38b+W8cLXSRoHKB9ES9RLOb9w326wqoIAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FBAsX1G457gVcjkfVHbwK03uN5eKzwV4tDYKpZIdeQs=;
 b=MFuVpu9jldEFfx/vrFOBaZt5OFH77boDSdcud7Au46Hqn2XuwMmCvTuaGtu2P//syauT49r4gYhCs9nJ0zlFNrHYawH2xJ7RuAfNUW5XF33eIH2WXVLNiE6lgaJ9G/t5L0MRZfKlAZm02ireJK4pm2yxRNRoFBZQedH8pR+Vumk=
Received: from BL0PR0102CA0014.prod.exchangelabs.com (2603:10b6:207:18::27) by
 CYXPR12MB9318.namprd12.prod.outlook.com (2603:10b6:930:de::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8792.33; Mon, 2 Jun 2025 20:57:16 +0000
Received: from BN1PEPF00004689.namprd05.prod.outlook.com
 (2603:10b6:207:18:cafe::fb) by BL0PR0102CA0014.outlook.office365.com
 (2603:10b6:207:18::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.18 via Frontend Transport; Mon,
 2 Jun 2025 20:57:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004689.mail.protection.outlook.com (10.167.243.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8792.29 via Frontend Transport; Mon, 2 Jun 2025 20:57:15 +0000
Received: from SCS-L-bcheatha.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 2 Jun
 2025 15:57:14 -0500
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>,
	<alison.schofield@intel.com>, <junhyeok.im@samsung.com>
Subject: [ndctl PATCH v2 3/7] libcxl: Add poison injection support
Date: Mon, 2 Jun 2025 15:56:29 -0500
Message-ID: <20250602205633.212-4-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004689:EE_|CYXPR12MB9318:EE_
X-MS-Office365-Filtering-Correlation-Id: a673d897-7648-4b87-6111-08dda2180e4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0sNsL/o73uUuhdkNi7jpbST+X4pLiCPch2IjJiIN2HyON4paYieSUpxySO/I?=
 =?us-ascii?Q?Nkbmjwn7IH/zKpjyCYW5L0WPsgLPNkkcxqOn3u+9It6aRnBCJgxmOPHM4XpC?=
 =?us-ascii?Q?vT0POxNkrpi37Qn6Xr95EQm4oqnG/WCWJfw/PZb94PfUUQKFE7rLXSMnZx/D?=
 =?us-ascii?Q?f/ftqtEy4HyN2tjFDuqwsZimMMuNdV3VBExPLu5THu3ragHT88kpVpa5GtU+?=
 =?us-ascii?Q?ZFUMJpvcUSpoas1moBLGOh1BrtRHGDoh9fIsXCXv56R/4g/0MdUuJ2LimpFv?=
 =?us-ascii?Q?970N95OcYnUxJiSA7WILlpEsSS9wXYjm/ZybLsOz6JVpEQlYgoYkWJSmtJuo?=
 =?us-ascii?Q?2sSjJl2EkxYx4nkUA8MGs+UoZt93Q3z30KSUdwvLVQKU5aT2QlsciRLu9MIk?=
 =?us-ascii?Q?Wp0xmJ3/ddJ+OhaO+4c8HCVtJUnwSRQqlyNorn13VgKOUWBQhMgzZcmDFHa2?=
 =?us-ascii?Q?6mK6cV/8vE5+1xyHRvHgL+CFmVlE8JPKi6kVFWdqrQWUr9VSaF0ylCIRacoA?=
 =?us-ascii?Q?b1LX3z824WoYem0QuJHJqqzAEevVLk5kLjsfun/ElZYl5N3L05gWgQzCV60Z?=
 =?us-ascii?Q?cCdhyo74WvccNSUyt2OyoCfkcux4VR+J44uQ6il2EbXrCbEyZX5hDS/T6JYT?=
 =?us-ascii?Q?NffRkmxumf6l4ZcKzYGa6kso8ajzHOuzvLac3hlzefH45Iu1DQRHIwx30TjX?=
 =?us-ascii?Q?8fjWSkwS0zZwixPh2vn6avWb+2sbrxiwGh6EVz0AWot3+x/M0h3R5drsvYqK?=
 =?us-ascii?Q?uUqvRUH5vfaq6ftLQDn3QszUFjnDDK+h38VEnEnqmx9jXrv+3RrjD9Dw8i0Q?=
 =?us-ascii?Q?7UwMaBF6fcNbQapXhmlScoXTa2MG2hgoUufWxPdHb26ylcUzJOvA3ZSlPhd8?=
 =?us-ascii?Q?qJFr2N3tDJO4xotWLwRZrYj3Qbix8DZpx/3XgpQWkNRHzPP3r/0Wa7vdy21X?=
 =?us-ascii?Q?OW8zs1I0+bPHhylhL6oc51g82ABUVvORBpTKzrB6Z/0qylrg3XZm60dxs7qg?=
 =?us-ascii?Q?+Yjqn4FH3I/guNqcWPgKnH2g8GWv29CZB5RI64H40ZivDga/cBhax/PXRc5X?=
 =?us-ascii?Q?3cioZUv+CiTRFCUHbCjoEz0zRj9zEh9Z7LVapHbg4gC36CEhsGn8nUsZev6Q?=
 =?us-ascii?Q?RFwfyUqemwVVrZ3qsjMuwpsF7OCycWRWpD/0fNjY88cNeGVZ2DAWpZXCXqN+?=
 =?us-ascii?Q?UwQRTM1Dojc2iKe9+iduGSK7SQd9zzSnGThdBtHsEvfuKgMmtfQzuBLBXkhn?=
 =?us-ascii?Q?feZMOFuOdJXaMsWSOMTFu9GqfpSllA1XxBGBHscLN2o8qnC9b13LyvzL1nCR?=
 =?us-ascii?Q?6Q9R9XP9hzkMtT7lD/JJgiALcImr1uBEHv8CLZ+pyJOsRI+kDyJFzSVuc626?=
 =?us-ascii?Q?Amynlq+PSpY2sl29ioKaJdWERXvYrkj+Zj3lGlR5Rb9Vyec4zvWy8E7J2lcZ?=
 =?us-ascii?Q?Mo7a/2HF26qCSiXPAl14C7kgmgy/WR9aAuROh7iXXNepjfW2j8whfQC/aDgm?=
 =?us-ascii?Q?FBiZl3SRNYFc3gSL5XDBiEs3ExWwgkLoSLCn?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2025 20:57:15.8733
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a673d897-7648-4b87-6111-08dda2180e4a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004689.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9318

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
index 0403fa9..e1c9951 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -4897,3 +4897,63 @@ CXL_EXPORT struct cxl_cmd *cxl_cmd_new_set_alert_config(struct cxl_memdev *memde
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
index 61ed0db..012d344 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -295,4 +295,7 @@ global:
 	cxl_protocol_error_get_num;
 	cxl_protocol_error_get_str;
 	cxl_dport_protocol_error_inject;
+	cxl_memdev_has_poison_injection;
+	cxl_memdev_inject_poison;
+	cxl_memdev_clear_poison;
 } LIBECXL_8;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index afa076a..fa007d0 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -100,6 +100,9 @@ int cxl_memdev_read_label(struct cxl_memdev *memdev, void *buf, size_t length,
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

