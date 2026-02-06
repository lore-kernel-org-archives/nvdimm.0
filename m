Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011040.outbound.protection.outlook.com [52.101.62.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C8228D8DB
	for <nvdimm@lists.linux.dev>; Fri,  6 Feb 2026 21:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770414630; cv=fail; b=a8pYIlez5f9qlS5UmEK2/7msudrELwAMg1zwmTt6cYiNNOo1OOaFe7zuNYr7tRIEGvAUwG2kDy1GVrubcBa70LQvcKMpxUb04ixpxFa6TTVNbtU/4YkyHxkEgv6ZOpSc6KpMOvaTThMzQYHtjoySUcvzZ4y8EV1wN9Dlpz33ugQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770414630; c=relaxed/simple;
	bh=MExMl5y03r/NoYkpwv3m4TyAGCujSsKDthsfTsr03ng=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R3zrApHsxFpPOtlWQpmZiHuZ81R9VpbaysiBeaOKDOvMvOWbgRmoUweyMPSJbpbBg/P0VAIdJqg4TgLf29lbBGfp43UnKMWrySat3L+hysWRJ+XFx941A9SXTNUs9FQe1VnmcT7nl0AtT0OS68/LJfdDhz2C0NRun+5bymkhlWQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NdjMaUK1; arc=fail smtp.client-ip=52.101.62.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NdjMaUK1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qnrlp1nlpeX6vRXF/bnCJpzjbVKjPA2/D1VP/nj7Bb73UuaYKqgnN21lA+xN+EwgcDDt94vorBvs1qrKMEi4VCdoTNCvNOIi8zgIe+H4Y5C8vyRd5fI6ocVf1NTdxGMD2RFgD5aW8MFko7TSY0QSGPvQ0iwJaJ9mK1f8meEdD8bCq4dzLp2NbrbD0zbpY1HT8KLL2Kwu2kwXwEMNFS2VuXlwlRXzIR0gU6jC4urMoOyFUwLw377cqBMsGez4DIiYtQmmZn3iLOKoEswFNyeLwe9iXWxoZnZj3U+b7eY84UdG2cV2loa/sjPObqqAg1LH1rsHFJKDxVz6sdyzjni2FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YQNHPwyGH19dajy8KH10IY3OYXoWewAlCJDjyRwRraU=;
 b=jGINErKREyyjDU5viXPcVU6SttHiOa/LPagpBY4JkE9gxFoFqLf3PePKD8XNi9f7uiBCWm5WO1pc9FIaVEAS+BvuhLGHIj30WzLZZVUq8MF1siXOQ+39Dd1Jpk+tPJTbYGHRx11p3yjlK7rbCwap2oZPoDRYc077zAyx+lfbx9r/lnUjPCMqnRurJvPMG7wa/T+PpBSLNfA1KpyhvoUuESbJ1s8MJPusibWFvwZFIf/PNe0x75uRZCT3yESqHgBt76lsTJLlaL6TEqJ53+VPonm1sSYnEHibpZ/y4H1nMNZWqFyQzE6NUn8lTIdPIjyW1huw32LFHqQliRC8YxiPCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQNHPwyGH19dajy8KH10IY3OYXoWewAlCJDjyRwRraU=;
 b=NdjMaUK1X6PsewgPa/rJBAC/m26mO9CReM5D1bTpisd2qjM2ryBE5HAw7XL92zE25noEuqObLZJjs2yU+dsvoD+L2UguTFh0hwLt61Qxu6APFE6wWrdwRBq5GLNKCKV/0psoAHwVNY+oyLGaAkg+3AVOmwUs6tiuZjJ0Qu6Vahk=
Received: from BLAPR03CA0158.namprd03.prod.outlook.com (2603:10b6:208:32f::24)
 by CH3PR12MB9453.namprd12.prod.outlook.com (2603:10b6:610:1c9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 21:50:25 +0000
Received: from BL02EPF0002992D.namprd02.prod.outlook.com
 (2603:10b6:208:32f:cafe::8f) by BLAPR03CA0158.outlook.office365.com
 (2603:10b6:208:32f::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.16 via Frontend Transport; Fri,
 6 Feb 2026 21:50:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0002992D.mail.protection.outlook.com (10.167.249.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Fri, 6 Feb 2026 21:50:24 +0000
Received: from ausbcheatha02.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 6 Feb
 2026 15:50:23 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>, <vishal.l.verma@intel.com>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>
Subject: [PATCH v8 3/7] libcxl: Add poison injection support
Date: Fri, 6 Feb 2026 15:50:04 -0600
Message-ID: <20260206215008.8810-4-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992D:EE_|CH3PR12MB9453:EE_
X-MS-Office365-Filtering-Correlation-Id: 27f70e62-12a3-4144-3a51-08de65c9bb89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GRZn/+I5H5ZFlO8+Zz0z36zT9g8PkfDM/qaBWWIs3WGBswcQgLX0VvhzjWki?=
 =?us-ascii?Q?k90SK3e8gFG8zfEQvnXXbiDBuI7CzCHmwpqbcZ+MLpyOHAJZ/ha7e6B/MfNA?=
 =?us-ascii?Q?xGbdhGe3PI4dr0T0w83Zlj7J07mNL0WYn9hIE7ZvDAeRn8NYCqYJ3csQsLPr?=
 =?us-ascii?Q?wBbkH1Mjk+CU966eNFlbmdVIFS4YK/hik+jBlS5uJnxrrjIEO7fnT2t6GlEu?=
 =?us-ascii?Q?6e1vyB3X0gRUllnzcFxVePvkbT6xbtkdt+vfY15SPOpuXx5YziQvnMz4EbwJ?=
 =?us-ascii?Q?nAbscTd/QmmEwUC3j3hsSH9r9oB86cOsEHCT+3xeNLllne+pjDjT6CeOwC+7?=
 =?us-ascii?Q?vtzit1LgMe8QAAgWN1SJOMXVqQH34gCodlfS+9ZH0vkqPX+tR/Cc4PGXUJQW?=
 =?us-ascii?Q?s+Eq8UKRAuSLal99uDxPjydADFb4IRSXBIrAXfw8Te1Y23no975yikehhaqu?=
 =?us-ascii?Q?jfoqDo2VrnF81WbP9aOp9Q+ELuXmPQ4Bxkl9eAPoeOiwXxu33Eqqi245cetO?=
 =?us-ascii?Q?C7bJhZGWHe7DZr8Tg4JIfN5JRLJncTkjG4/yhlvvDC6VInBdn43BtpSexROe?=
 =?us-ascii?Q?e2nSstWi5f0C3thD+M0FGgITi6BDXCqmHbn818kOAR0KHy2NcBhs9nDGPFZC?=
 =?us-ascii?Q?AxS9wSqPVcgEILKiutoL4mE8FJZgtxrfH8KWXa+sdqs4kujRlrQIOWxopFV8?=
 =?us-ascii?Q?mNMV6Pq4kSogoziLm3SFMVGSK2GYgU54ckcmhxMn+RCE7w8EjIOp96KZWJih?=
 =?us-ascii?Q?L1KS/+rWydRfTEKS0+ASRy4iiK0lUmB6Spbd4AyPx4bTTY815zqkAA9F1NCt?=
 =?us-ascii?Q?/LZHWMtrGsLcVlGac4hWiQFKgPhw6U7spXpMKT0MyclFse21foB2dmR9rs0L?=
 =?us-ascii?Q?7KSrDhZnyTWMJJiS/5oNbEPww+UVRfQYCe6Hb2ZIMg+fQ++FIiRFLqcwcW49?=
 =?us-ascii?Q?sbxOfGVlK9NYtj23qSGvH5G6JTSuLYYqL/oSLSoUsfv4JeL6dsBpSnFuQpzZ?=
 =?us-ascii?Q?/cUkE0XByli2JFloT3r8NwyDzV/kH4ACSILG8KRjpfis1LguTYWEICcPwNTx?=
 =?us-ascii?Q?zflhIDO/oqtsoVyLxLeKVVI/d7bEZCnTLpcFd0YfRVUFEyqYCTLsrEl+FNzg?=
 =?us-ascii?Q?kXFZBkoyxcWWHrG5sdk7frpbMO/GYTAdPj5/nJSnRPi90VttvsYuJmkGmIbL?=
 =?us-ascii?Q?omWOIwtN4wGHagvmuFy8cKiO/LRKyOHoZBO/PUD8CEvW8iffKlSBE3ypVA7M?=
 =?us-ascii?Q?4aShCfbOv2WvaIr+iw6fxrHX0BRvACntoVLv1uW0GRAdQoE+N/T4p/uPbYxF?=
 =?us-ascii?Q?mrha9AGJaHnhObNtrZzMvDmeRwaxI4H8bFdMhuUxmKHgQksEuX8rWMmt/zAx?=
 =?us-ascii?Q?kZb+NSJ2fRLEewfsML2H0z4T1M5rvTWRF3KwUZO1qhBCQS+ApX3Gho0NgTLU?=
 =?us-ascii?Q?nVlfo602GPzUcqHKXNWF6rkoKJ9jxNB/yKiP9UeLSvn/z2Oy49ByvHRnwoBg?=
 =?us-ascii?Q?5otPGrynwZZUIJlU3Shb6IT+x9vI/B/+TdT69+CcU2Tn+jwBEulTUx/Pf2cA?=
 =?us-ascii?Q?V4J7FfEaXgnYW7dbeCNHh3Mw+xXx2Un0lbYvPm6WKCdJzDMzM6A7lknjnNcX?=
 =?us-ascii?Q?KUyO2qZdf8LQ+B4/yMbuZX23osrZ21HvaK+/ZSBtS9YKP9XNoKyy6U8jmlAb?=
 =?us-ascii?Q?70bmIg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rtlXLMtlEezv6wbkXUvPGZRwDgODGhFIJKRkQWNbX+XJCF/WOohnCb5ZFSWz3Vrx3r1W0Bmity6gAGxME8AGvRT9ION/hUdBKO0994ecylx+s9dpss/q6/PnaAglLZFstXjyXI6hzKetTCYhanafXn6zYgDCHRnps/6Ssdp0YmTSltj4YQZTIxfoIpTzfLc4Jd0i/hWgJkRuL/efIqgFkOnzv+uP3Bbb9Rzv19Li6S+q2roO+tmrsnjS2BqSDTaNXqcTTtUgZMuBJ9eoweqAI7Gygw66Fhp/EQUefTjtKdYW285V+ev20a/kUpdGznhf0CQVp4SMfUqjdLNPR+ix0GcGx4Z2BObXOiQTBkrAUYosyacbhiLph+iFhZ2W9giFxb/JI1+kg5Z9WMw9LClwmoAtT6E9tuGMpJziZqLNcMfRarvwM4sa93+2l7Vxwrjm
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 21:50:24.1905
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27f70e62-12a3-4144-3a51-08de65c9bb89
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9453

Add a library API for clearing and injecting poison into a CXL memory
device through the CXL debugfs.

This API will be used by the 'cxl-inject-media-poison' and
'cxl-clear-media-poison' commands in later commits.

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/lib/libcxl.c   | 83 ++++++++++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym |  3 ++
 cxl/libcxl.h       |  3 ++
 3 files changed, 89 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index be134a1..308c123 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -5045,3 +5045,86 @@ CXL_EXPORT struct cxl_cmd *cxl_cmd_new_set_alert_config(struct cxl_memdev *memde
 {
 	return cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_SET_ALERT_CONFIG);
 }
+
+CXL_EXPORT bool cxl_memdev_has_poison_support(struct cxl_memdev *memdev,
+					      bool inj)
+{
+	struct cxl_ctx *ctx = memdev->ctx;
+	bool exists = false;
+	size_t len;
+	char *path;
+
+	if (!ctx->cxl_debugfs)
+		return false;
+
+	path = calloc(PATH_MAX, sizeof(char));
+	if (!path)
+		return false;
+
+	len = snprintf(path, PATH_MAX, "%s/%s/%s", ctx->cxl_debugfs,
+		       cxl_memdev_get_devname(memdev),
+		       inj ? "inject_poison" : "clear_poison");
+	if (len >= PATH_MAX) {
+		err(ctx, "%s: buffer too small\n",
+		    cxl_memdev_get_devname(memdev));
+		goto out;
+	}
+
+	if (!access(path, F_OK))
+		exists = true;
+
+out:
+	free(path);
+	return exists;
+}
+
+static int cxl_memdev_poison_action(struct cxl_memdev *memdev, size_t dpa,
+				    bool clear)
+{
+	struct cxl_ctx *ctx = memdev->ctx;
+	char addr[32];
+	size_t len;
+	char *path;
+	int rc;
+
+	if (!ctx->cxl_debugfs)
+		return -ENOENT;
+
+	path = calloc(PATH_MAX, sizeof(char));
+	if (!path)
+		return -ENOMEM;
+
+	len = snprintf(path, PATH_MAX, "%s/%s/%s", ctx->cxl_debugfs,
+		       cxl_memdev_get_devname(memdev),
+		       clear ? "clear_poison" : "inject_poison");
+	if (len >= PATH_MAX) {
+		err(ctx, "%s: buffer too small\n",
+		    cxl_memdev_get_devname(memdev));
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	len = snprintf(addr, sizeof(addr), "0x%lx\n", dpa);
+	if (len >= sizeof(addr)) {
+		err(ctx, "%s: buffer too small\n",
+		    cxl_memdev_get_devname(memdev));
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	rc = sysfs_write_attr(ctx, path, addr);
+
+out:
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
index c683b83..e52f7f1 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -309,4 +309,7 @@ global:
 	cxl_protocol_error_get_num;
 	cxl_protocol_error_get_str;
 	cxl_dport_protocol_error_inject;
+	cxl_memdev_has_poison_support;
+	cxl_memdev_inject_poison;
+	cxl_memdev_clear_poison;
 } LIBCXL_10;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index faef62e..aece822 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -105,6 +105,9 @@ int cxl_memdev_read_label(struct cxl_memdev *memdev, void *buf, size_t length,
 		size_t offset);
 int cxl_memdev_write_label(struct cxl_memdev *memdev, void *buf, size_t length,
 		size_t offset);
+bool cxl_memdev_has_poison_support(struct cxl_memdev *memdev, bool inj);
+int cxl_memdev_inject_poison(struct cxl_memdev *memdev, size_t dpa);
+int cxl_memdev_clear_poison(struct cxl_memdev *memdev, size_t dpa);
 struct cxl_cmd *cxl_cmd_new_get_fw_info(struct cxl_memdev *memdev);
 unsigned int cxl_cmd_fw_info_get_num_slots(struct cxl_cmd *cmd);
 unsigned int cxl_cmd_fw_info_get_active_slot(struct cxl_cmd *cmd);
-- 
2.52.0

