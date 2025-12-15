Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011038.outbound.protection.outlook.com [40.93.194.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFED2E36F8
	for <nvdimm@lists.linux.dev>; Mon, 15 Dec 2025 21:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765834637; cv=fail; b=ow1qz7Hb6oNm4P8uJV6oezb9WEWA0B20kthqk2ikluP5JChRWTBVYqyRnB5zJ2DUg0k3k7OSUy7z1Jg04JqIyWXR2TB56+ZRofrgyrIbw/UZfk/oP0w+zbG7PxMoww8KbDkZeOYzqcTDoj/4LYvg06UGdxFl1I34Pf1VH0YwLH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765834637; c=relaxed/simple;
	bh=NQYDtDnywwRAKACS4GmfyqutsG3VYXd/us5wG38FgEU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bT83eA3U0VBCf31zbx5oFQ2n7z+gSYs+VLC0ric/dbbnCZVKrRs/krkKbDtdUUYJ+/a+TzXcY7dTnD8cmNrBMQMbBtmiev492gSNxay7HhUQJIdtUXtGDyMobs/urb6odXdU39+ro52SqTTH4d/Rb7hcn+CAJQtbORLVvM9eUHg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YH0LXox9; arc=fail smtp.client-ip=40.93.194.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YH0LXox9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YAwlkJC05m3oLt2C/xHvWCfiGSf/JmG0Ef9R2hFf47yb6TVlZhJJN/ptMelpc5Z4UzfcCJmr5bC0gn5HqYFzDBLVTEfFcfqUQyOUhM274BzA6sOzULoEAzirgUzWLISVSCMOsfMuF4YCScau2bx6TcpEQPQf6Stiyruo3Ean+wZ/8JT7zM1NQTJV8MwcIJUIfzDd5Caz8tWnqPdlvXM6ch0zpEG2EojG0A3YjnWHyhcrej7e7c/Bznqyx8xiOsihyyscGnqaVWeaB4X6+xT7YFoHzYIslkDLRp6i0UpRSkxcfuAnMNGgajJK572ZqPaQoCfSPELNonscYcmZSYgs7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZkbaKqLLhKg8w6m7t5fr0TFDGCEC9rh2hs/qa6DSm+I=;
 b=sh+nkA82ofsEOW6UJa14hXJhWcgSQF/AhLAj18wt3F8yHw6HLHWvKQNDARonr5ocRCH67I23agIEAoZwMmM4wmUSg3HOtRWYZVIkIQGr01rJTlBja9H0CqxtmbkuKsa+gNMLRK1LEtav3/l7FKXvpbYGHlsomsen7QaG1cSIBWUlF4uP2gLZ/zG+qYSUn6eFvXvuEZB9kuTttWOPGkeCu1/S/7c6vrU7Mqr6UbYPRYmqnkbsVGr3YpMq8ThRD1rKmTkspUPwTLzxyBjmoXv/9AvegZTVy94tNT7xCaYVvJ0KmKsuipYv2E9xqybSiN+a+BvnarHe2BmCi2Hr2sYJMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZkbaKqLLhKg8w6m7t5fr0TFDGCEC9rh2hs/qa6DSm+I=;
 b=YH0LXox9g9Prd6a1O6J+6sFnzAnZnsN6H2DIKk5RuxVcZx5nCYh5k7p4bzQG0c2hZetNymOiW1SqrYy54a1gaOD3PqMTcGyrv7n+fX0uRv++5mqSDSqEnkUORVi2BEnRwGZcBX5Aq6j/jD2tmRhj0pSWLuSEjQ2UBSdujy9kgKI=
Received: from SJ0PR03CA0337.namprd03.prod.outlook.com (2603:10b6:a03:39c::12)
 by IA1PR12MB8309.namprd12.prod.outlook.com (2603:10b6:208:3fe::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 21:37:10 +0000
Received: from MWH0EPF000971E6.namprd02.prod.outlook.com
 (2603:10b6:a03:39c:cafe::e2) by SJ0PR03CA0337.outlook.office365.com
 (2603:10b6:a03:39c::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.13 via Frontend Transport; Mon,
 15 Dec 2025 21:37:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E6.mail.protection.outlook.com (10.167.243.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Mon, 15 Dec 2025 21:37:09 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Dec
 2025 15:37:08 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>, <benjamin.cheatham@amd.com>
Subject: [PATCH v5 3/7] libcxl: Add poison injection support
Date: Mon, 15 Dec 2025 15:36:26 -0600
Message-ID: <20251215213630.8983-4-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E6:EE_|IA1PR12MB8309:EE_
X-MS-Office365-Filtering-Correlation-Id: 60cb77b9-fa94-46ae-7e1b-08de3c2219d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IkFwFwl3JTYze1ByyzxeZo2PB+HwYCU8jqehYfOEhxtfm7/pU55LhIM5i6eh?=
 =?us-ascii?Q?UgarFEs7rMP2kUsi/QuyqMNj3ToBX6hhNJVU7oWnK0LXcjO6J4Nxfcrz9dEe?=
 =?us-ascii?Q?6yMaiZxHcYz/o1xDTrQ/fgYj2EAgLBXgfbXg6KqMpBSFaihBF/vp//kzk+l4?=
 =?us-ascii?Q?RAUW94GASmeISPc65keqFYl+xGQTmyYFMi2VRzOR7+2566Q8SoW7P/ofCEdR?=
 =?us-ascii?Q?0LqiwRuMS/KMRfDc9BXJYe+SuMfg/LTg3sFNwOjh+HyH6i/JdVPtomFkvyeP?=
 =?us-ascii?Q?vDX8CZJRMA6t1Sr8QXbUTCjb5QFZYgI4mkbb42usftHgLaG0ElmxSI2RXNvg?=
 =?us-ascii?Q?xRcMqDbcrCQqfQVcfYdfDPeRoj5ukIM9slmfUA2Pen83mb9Edr5dKsto6Qgf?=
 =?us-ascii?Q?0YWUp9UcyhoehULE/xfoWgwrHAuLGK1T2cvB2x0pQQbOfOy3NmmQTeWDiUW6?=
 =?us-ascii?Q?rcrpOENHoVs3wmUAjHrkDf3Z/Xr9ThktMjwLAaT+2FzbbquM9zqWVlyK0h0A?=
 =?us-ascii?Q?SAz+sNtCsVLg0geJcpoKOSdHlwt/85+38IdxruJ3f5lgtTyh1lodQ61cxrdG?=
 =?us-ascii?Q?0fLDal5Pv90aZAQ1Np5ARXhobQlOSNuAw3Bp6fA1J3P8ARgxc2xRca9OKeCe?=
 =?us-ascii?Q?U/y1R5re/Mis4cHr5/aXom1/SK30vgRN1Y3zzGhNaSs63PPrGWgcdj5W4QBB?=
 =?us-ascii?Q?cvNW9kF82qK5UoqM5V+27jfUuLw8lNuqT/iLNaBKElMD5LZsVjfHVjd9dnho?=
 =?us-ascii?Q?ctMj1UNCivWsOkKDT30D+WDDsHAlg7D/DD6dm4WlDrMrbbKlvlIx3nls3d3a?=
 =?us-ascii?Q?6W2mtBrMtOOkjyXQa6OQSaxBZuFibhvFphTHmciG/OTVHf8FCG5ek7i57g+5?=
 =?us-ascii?Q?oRqu3nal41YeOwmsXXxPSqIq/8+ZccItpmSGFXp+wpK5N4rD5+DcxXDN8phu?=
 =?us-ascii?Q?81PIDLGoiHTb75Xq6g3TbjIL1JX1r9ig0CzIK2+mNYqOxR/8F/nRn1Gh+tVZ?=
 =?us-ascii?Q?qF3VjsmTNyFVByyvOpXrOnbuIcXIsxPjHmn7OKzasQgItNyT3B6WbW97PJ+d?=
 =?us-ascii?Q?tcnLv8U5TvG1WBCDw7C2t14hmuFcfwwUkFwE9tXbssK+f7x1MkSHSGjTLxvG?=
 =?us-ascii?Q?iNRmyL3BZGjf0c/f05kw89kYmC5a+27u1ebKLnHt48OwpFDuLl9Mha4nVP12?=
 =?us-ascii?Q?jrEklPLZ8HfkJIma11Rv8oMggaiRtqqMfw0BX+vdK8BPXwqDEwZO55c3J2Eg?=
 =?us-ascii?Q?5VX9Vn8RoZQjD+6mk+wXyWW5D0Ih82cZdi5MJ3kiMDKe8ZzFFhO5v9jL9AB/?=
 =?us-ascii?Q?sfGXqubqwBkl6Yo1zYOePgPHeGKXSEK8Dx75hToQQt4PaXYzArxWEkXQxNzs?=
 =?us-ascii?Q?2M0K9Q3cQz3V7+ZelgIlIPCvs2UvVzgfst3ip2SMpaTn1FSRngga0r6YRnk7?=
 =?us-ascii?Q?cEtnmgxjJyiLKbuZhazB/fO4tZISBqmFEo7ukzvTebT125ERFfOe7+EkYT5D?=
 =?us-ascii?Q?gHiiSoMPPAhYs5L1RG2fyLBcXCHX3XwbX7k/pVhJfnjUjukn4K/RwSVn/oWi?=
 =?us-ascii?Q?enVxSRpMxyTjxnmeRFY=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 21:37:09.1919
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60cb77b9-fa94-46ae-7e1b-08de3c2219d6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8309

Add a library API for clearing and injecting poison into a CXL memory
device through the CXL debugfs.

This API will be used by the 'cxl-inject-error' and 'cxl-clear-error'
commands in later commits.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/lib/libcxl.c   | 83 ++++++++++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym |  3 ++
 cxl/libcxl.h       |  3 ++
 3 files changed, 89 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index af34db0..655eef0 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -5024,3 +5024,86 @@ CXL_EXPORT struct cxl_cmd *cxl_cmd_new_set_alert_config(struct cxl_memdev *memde
 {
 	return cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_SET_ALERT_CONFIG);
 }
+
+CXL_EXPORT bool cxl_memdev_has_poison_injection(struct cxl_memdev *memdev)
+{
+	struct cxl_ctx *ctx = memdev->ctx;
+	size_t path_len, len;
+	bool exists = true;
+	char *path;
+	int rc;
+
+	if (!ctx->debugfs)
+		return false;
+
+	path_len = strlen(ctx->debugfs) + 100;
+	path = calloc(path_len, sizeof(char));
+	if (!path)
+		return false;
+
+	len = snprintf(path, path_len, "%s/cxl/%s/inject_poison", ctx->debugfs,
+		       cxl_memdev_get_devname(memdev));
+	if (len >= path_len) {
+		err(ctx, "%s: buffer too small\n",
+		    cxl_memdev_get_devname(memdev));
+		free(path);
+		return false;
+	}
+
+	rc = access(path, F_OK);
+	if (rc)
+		exists = false;
+
+	free(path);
+	return exists;
+}
+
+static int cxl_memdev_poison_action(struct cxl_memdev *memdev, size_t dpa,
+				    bool clear)
+{
+	struct cxl_ctx *ctx = memdev->ctx;
+	size_t path_len, len;
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
+	len = snprintf(path, path_len, "%s/cxl/%s/%s", ctx->debugfs,
+		       cxl_memdev_get_devname(memdev),
+		       clear ? "clear_poison" : "inject_poison");
+	if (len >= path_len) {
+		err(ctx, "%s: buffer too small\n",
+		    cxl_memdev_get_devname(memdev));
+		free(path);
+		return -ENOMEM;
+	}
+
+	len = snprintf(addr, sizeof(addr), "0x%lx\n", dpa);
+	if (len >= sizeof(addr)) {
+		err(ctx, "%s: buffer too small\n",
+		    cxl_memdev_get_devname(memdev));
+		free(path);
+		return -ENOMEM;
+	}
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
index adb5716..56cba8f 100644
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
2.52.0

