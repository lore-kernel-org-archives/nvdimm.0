Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011034.outbound.protection.outlook.com [40.93.194.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3089C38E13C
	for <nvdimm@lists.linux.dev>; Thu, 22 Jan 2026 20:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769114265; cv=fail; b=A4TxYtcl/RHmbmT7hIRIlbnTEw9l5XiFcG7QrKsTa8r5ZzeQ+ksd3PkSYe5kVnNKvMHSLC+OCsCOKRyb6b+VrJGItuZE34i5+h//JAWqM4kBjR5RgFHQ2zo4lj6rNsUwqU+bxPBADXgH+qOPSbgaJOkJska3lVal7hO66EwPyxs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769114265; c=relaxed/simple;
	bh=I+Bq4GTf+lfcotC9/g2N88AWvsalgE/SQ7nVkwheojo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sPROKJFh57TG+zCfYGQF18Pv89tQU/XiF4LbBydmZcxLL9TH/uQo4aaGaNAvcPV2nS+kZN1WhN6vxjKuZIUaNZGw899KjhtteZtjuO1NxUEb+jUi3l51a7QSXggQeTw+2CdywmOAVQ/XduKNfCevHlaABN3aC6I36QsW3W8+/vQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4QW5d81/; arc=fail smtp.client-ip=40.93.194.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4QW5d81/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KPjCRBETBVYK5yLExC+ziexORqxhmDxqD+Mj2JDqw3gyoMj58XQ4aM6c3A6s5SJ1UdC7fFpJMMENCVZ5aJyTxjc55MScHA5SKHQ2Yc1v7/awBOxOPaial0bFg5MKrEn9K5CYRnrG0R2GwNWOqJR2QYuERZHmpbJupsRr/aT38sGv89gUYrC26BK8mJ39hj12uLrsZ2QGCRR3Tosd3GWPbiAcAFT/5KztQN4GofyYWQWHsha1SBB+x6Pe1oqRitGS1XGFcOp6f2MLja4AyQ6fU0PfV4HunDhySlPJ72eOXUBJkUfIz6qFKlUgsrZsEb2uobTfYcl8QuMuxuRDWDwubg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VfSotVzkiHpkCZYaloOJnGHRm/332qc227ik42mOpIU=;
 b=d2xISLNJJYiCUOPPkjmqzQSx1nqr28RQ/twPjxgZPJTWrjtzrnRJku5zK6+a23Rr3MRlLXFOIBaobDx00tVVo2AU5ScTJqap2zFDioJeY/gPAlOYE0DHQtDDPFDuD0smaF+Gw8j6Rsvl8k+57GC7SEs68mmwRFl5pHoKKeCfsfMCVRAx2LkJwZdPAHGBs+mQpXNxJT0sdYf5LP4cKYkw0tL/nOB50PHv2GV0SkWokYs/u9OGlG0QQNNWNshr/zt4KHf85uJ3AP8HSMPfwWYiOwybqtFSrVSJJgiz4dWoVgfDAbUrZOdrbRMoiLt2kCtnwd4tzgFKBvUAj+Me3anF8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VfSotVzkiHpkCZYaloOJnGHRm/332qc227ik42mOpIU=;
 b=4QW5d81/aekIyNWLJtO3U6VJMa3t2oFg+cku/r0midlSKX5c6ou9ek8hJV+9EqTnHUKJSfEYIoL0m0gi+AK40DJjPcPI5wnm2pwchT9EEcI5knI8nS1B0EgS7pYba5W8AE7oB0UrdxKTm3/LZYoKDk0wQVL70Jfyx6cGj+Xnh6I=
Received: from SA9PR13CA0046.namprd13.prod.outlook.com (2603:10b6:806:22::21)
 by DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Thu, 22 Jan
 2026 20:37:37 +0000
Received: from SA2PEPF00001505.namprd04.prod.outlook.com
 (2603:10b6:806:22:cafe::a6) by SA9PR13CA0046.outlook.office365.com
 (2603:10b6:806:22::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3 via Frontend Transport; Thu,
 22 Jan 2026 20:37:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00001505.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 22 Jan 2026 20:37:37 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 22 Jan
 2026 14:37:36 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>
Subject: [PATCH 3/7] libcxl: Add poison injection support
Date: Thu, 22 Jan 2026 14:37:24 -0600
Message-ID: <20260122203728.622-4-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00001505:EE_|DS0PR12MB6583:EE_
X-MS-Office365-Filtering-Correlation-Id: f72a520e-c128-4cd1-76e5-08de59f6146d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Dpa9xdA3CiukbDL2/Dj/50QOd7vyAssf44xYWMvXUzBRkVltewbtzul/Wt/z?=
 =?us-ascii?Q?VkPrIjHjwaa/XFrUEpvKR2hkkk58hl40mKXopi2mFNKuCK8IYrPTHZuXhqo3?=
 =?us-ascii?Q?WkWt3qGOYFkBG2sP0H8uSpfUzKfI/NT/h3mQn9vZS8NCMNL2v8LqA0qG7VXv?=
 =?us-ascii?Q?K3PDEBdHkM6XS1IvoZbWkKatwgMSfXn9RNRMHO6QhuAdpoS+umO+w/0OnXQn?=
 =?us-ascii?Q?pErLiCenwJmMvk4l53nKOqM4wREomFt5B79d735nR9kEfyul420C/aTbwo5r?=
 =?us-ascii?Q?dJTAE/JsaV+VXnquL4mnWpK5ZrdHdXBQAuGXOKKZf7SP6SnclOCuxxzapUdZ?=
 =?us-ascii?Q?nKzMi4L19T3d7MOSR/xy1/HHvDzI43eJono5p0IDeILWGf8Xp0IuegvZGvB+?=
 =?us-ascii?Q?WakmHGedyYxM/g4R7JgOUqhDJxbcl3Xi86r7tKqMi4Ci8gn9FYRXtpF9Wdb0?=
 =?us-ascii?Q?1H894OZzV6EEHoHYhcwIFqQ/0Xc/nIgxRS++7yLdT2ZoD/mq06GaDHRLCTTj?=
 =?us-ascii?Q?4BtgD53dn8gLnIyrEPEPsMzZiOkfXfZRZFtEJmKzTPlnOsdehOULyERs7H1i?=
 =?us-ascii?Q?Ud4plP19zYomPCgWN+c9KbvEtbStQSJ00VnmXz7nmFAAx6Nzoj5ebuislm4P?=
 =?us-ascii?Q?ZJSsDWVofa8s1hq/ub9FV8CR9XXn4TCBflzAlPyA2l6VWbQ2lnsj79z921S9?=
 =?us-ascii?Q?KG3isuY2HcSvt0PdwOADrR/QVTPn3yqp2XRL/vrFUprA9V/hTkodveznxAaM?=
 =?us-ascii?Q?mltUADPLt1hhr5CsTF/HHloayxgJxQsiu+SvJ7N2wqzcREzwgYqU30sRfl1X?=
 =?us-ascii?Q?y3mRCxOMmS089qfbCNB9ZmvcG4WOUSuxe/s04u4axjdiYxyCkGMdX5SSlHSr?=
 =?us-ascii?Q?cPSQZd3pPHdxEEMdaZ8xg8kqkj9tqa37MaAb7DJoAV4Hd408Nkz4XdEKrtzm?=
 =?us-ascii?Q?AIY3jMF5B/+Wh5IxBzL5h5qG+oiluI8xPff5gUm1IH4K1YGPTllM4HAMAHAH?=
 =?us-ascii?Q?5OUweQSIZyhcIRruMCd/xVOiFQPFczOThAPKaol2dwmW2NrlHXXHVjVBUSwV?=
 =?us-ascii?Q?Ik+7wRXoQ0Wr6mIVu56yu4AC1Rwyu0TKbi6f72re1jLtHVkPC5qmt2c/RPIS?=
 =?us-ascii?Q?b/5wPo/6kFbuLXWmDVNGVZCH9elJWhdpMaBZi24Bnivk2D8OeK/5xj52z2Fl?=
 =?us-ascii?Q?lzlitYUqcnJRKID6R9gSZcvfM0naMaVnhaqwAyufPOtc356jt6j0U572PWaz?=
 =?us-ascii?Q?15ynEAfyZ64igQi2Rn+Z8vH/6AhAU94LjDr8wx9exzJBVKMIgLIkBx5bxEBR?=
 =?us-ascii?Q?NCtfBOQjpXKOvpKFvKGOjjDR2Hy0XhawhxV4B64KuFLdDHEsUL6A7MwufcI+?=
 =?us-ascii?Q?ovUzLRSlfDHdD1oQpszD9DagjlZbHtRYdRZxiBolDMf5K5k8gHBF7vrQqdtF?=
 =?us-ascii?Q?JtP21bo3vM6FcHJjsjlzDuy7Mw9TC9mb48bCcgXiUqvSl/vHJF17g/xX/2MX?=
 =?us-ascii?Q?4tXSdncOayW2ZeANaoUZ01jELtqEHUhIQIOMtPYcKqvYDfiEzHIt32MJ1pnT?=
 =?us-ascii?Q?R+t8uq+zoBzWPP1+H2h0H+T27pKE8r1+BzEu+ro8FfrW4TlpKAq8UdwOaS72?=
 =?us-ascii?Q?LKKDrtH6nFdzCb3UhOvIeOxj0OMgbDz2faaGi3svWdOD1TKUgAY+qmp7TG8O?=
 =?us-ascii?Q?DoGXZw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 20:37:37.2052
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f72a520e-c128-4cd1-76e5-08de59f6146d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001505.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6583

Add a library API for clearing and injecting poison into a CXL memory
device through the CXL debugfs.

This API will be used by the 'cxl-inject-error' and 'cxl-clear-error'
commands in later commits.

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/lib/libcxl.c   | 81 ++++++++++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym |  3 ++
 cxl/libcxl.h       |  3 ++
 3 files changed, 87 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index be134a1..3c3d2af 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -5045,3 +5045,84 @@ CXL_EXPORT struct cxl_cmd *cxl_cmd_new_set_alert_config(struct cxl_memdev *memde
 {
 	return cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_SET_ALERT_CONFIG);
 }
+
+CXL_EXPORT bool cxl_memdev_has_poison_injection(struct cxl_memdev *memdev)
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
+	len = snprintf(path, PATH_MAX, "%s/%s/inject_poison", ctx->cxl_debugfs,
+		       cxl_memdev_get_devname(memdev));
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
index c683b83..c636edb 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -309,4 +309,7 @@ global:
 	cxl_protocol_error_get_num;
 	cxl_protocol_error_get_str;
 	cxl_dport_protocol_error_inject;
+	cxl_memdev_has_poison_injection;
+	cxl_memdev_inject_poison;
+	cxl_memdev_clear_poison;
 } LIBCXL_10;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index faef62e..4d035f0 100644
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

