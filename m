Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010014.outbound.protection.outlook.com [52.101.61.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C28231065B
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 16:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767974859; cv=fail; b=JcRnuGl0FQU3QyNGJIkKWus8u7Ghb8HECjBJcEHYgYtG3EdciIDRVwnLz5m1ytnA0LS2DE44FZuGUoJMYZf+oTuL748TEGwaitH8up9DiNlw1utwCkuOKuRpp5WN8WU5E+ohxzr6sWEx1DPDRR6kT1lDY3hSjOnHTFm4uLt2t68=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767974859; c=relaxed/simple;
	bh=iEidynuAiTTD/iI2WYhKLY9D5rm2N3JoM7ujoDyw7Wc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JUPW572utwFSoD+OpEt81iKYVDe1VCXUGQRDvRtpKJmSJQIqVxGnKXOZh7mtb76wwVeX5H5yuFOBCiKSnY0OJTKZg/hkttaQYW1WLa6qo6Wp9M7Gf5HHbOvCxanA/0dpp0t5FZAMVZ1L8Bk6nsxgGH1edqLy+nRGXVe1IHxJkSQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=w8qleita; arc=fail smtp.client-ip=52.101.61.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="w8qleita"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SfYbmVIq+cxAjQILkmXySAeDY6RtzVmixQbTTl7Em09oS6qyLoXEJvye3x+am4XwFggunLmzpUsPkXr0zV3mSrMpgWBBNk88en0gLPHl+dKelt/lzoYVzyAfAb2sAMpQbXI0mzsk66LByYznAVLXKLyqCFL+UGZ4e8HTPKrBW09N8IsjP+7VfDd910fBiGdbxbP0p8DJbm84yoqENRgdyJyyK9ShRXsqdAGvyzM3h5/IapB/O+4nPlnGZhXCAz0Bsuh+3HiSwLPeU6qv02dU/GtFj4/sZTjvOWf9UeIG+OD3bkKllaGR0WyhE3tGBophxeGf2dqZjJZRrsvyYBG39w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/WMaQwMCkd+DFRd7FkkSxfTI/3zABDJ3V3etK3/vdxU=;
 b=lKyN5i6hEcp623HhqwqpJq6E1647xIURWs360GuUHP6MUunSxouHeFwX6tSGQtzGU3D0tQKPU97SzL+1Rpep6omS+uaLCiPs6beRPCcstvaF64hqhYwfDA6qdzj/DVHRmUmVpwcRPt8xsJbNZW8akI1rA3VxH8aUydYqBBK0JVOp+8KFoe2zMSg/WOcK8PE0FwPW1nwl9yvsSBjqWZSIX9hXgbjWOMAggmeCWuBqAsoMyc3jtY7wyVGMFr33Cc4AHJ9woUYzHYjg9q1v89BTPmkey6V10ErQh4NnTGEXAFXh3f7d7UY8fKl7MPnkSzPcoiOxwHYylkB8C6nPo7BwUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/WMaQwMCkd+DFRd7FkkSxfTI/3zABDJ3V3etK3/vdxU=;
 b=w8qleitagG3Zxq0UixLVNWQd2H6jfVL0BDqvdx+o21+sPo2fFQ52VXOajj7kOd+YHbDbALpt4kCRfd4vITYpo6Sw3fW+YyDI8FM39lDBF/G6f87XWh96VmE6r5I8c87eH2R7yd9yEZpFjqvTpSZ56YAVOOqG8QKkdp6X+J3JxBw=
Received: from MN2PR13CA0031.namprd13.prod.outlook.com (2603:10b6:208:160::44)
 by CY8PR12MB7124.namprd12.prod.outlook.com (2603:10b6:930:5f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 16:07:30 +0000
Received: from BL6PEPF0002256F.namprd02.prod.outlook.com
 (2603:10b6:208:160:cafe::f1) by MN2PR13CA0031.outlook.office365.com
 (2603:10b6:208:160::44) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.2 via Frontend Transport; Fri, 9
 Jan 2026 16:07:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0002256F.mail.protection.outlook.com (10.167.249.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Fri, 9 Jan 2026 16:07:29 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 9 Jan
 2026 10:07:27 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>
Subject: [PATCH 3/7] libcxl: Add poison injection support
Date: Fri, 9 Jan 2026 10:07:16 -0600
Message-ID: <20260109160720.1823-4-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256F:EE_|CY8PR12MB7124:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e3e06ee-45a8-435e-6d68-08de4f993092
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W4BWpqzI4z/pDVwj7vJvptTexLb3iwwwIz/k8ELmW5rCsQUUeN2djc5dl7Pr?=
 =?us-ascii?Q?CktOr/uY14+LlXpATdBELNCQ93SsoQFMi/kg2uyVvkiQpASH48JbjSII4YXW?=
 =?us-ascii?Q?2nS5UkimRxxBpYy38hLRHs7YSaPC+cVvcUh33WAmKdn5icRdgmY6EPGF6eF1?=
 =?us-ascii?Q?jRQ0Rz08EnKQjdy5/+otqxsDr/F4oh1A+Ein1UaVhg5bqGivTlYgvJkKjgEx?=
 =?us-ascii?Q?/d2NF0AT2DqevkmGA+/AwoTzp6XcBhSHkiQqgQPQs8O5lc4Mjcj7/LxIFqSj?=
 =?us-ascii?Q?V/e+SzD3FyCgfLUuoUdG8PyQX4QN4ZSOEjnrWlJzc7z4I7MAcxcUbaPyPzKC?=
 =?us-ascii?Q?vQRzQKWR0/fbgVtz0OU4kHtExFLycTxfsHyex/N+9ZxVLjmSG0VHriyyLrRv?=
 =?us-ascii?Q?aJxxjsCB4yYr3FxX2YuQa+USITUZaIHg5ijgvmiN3pJcQCd1RlGIGSlhK5AA?=
 =?us-ascii?Q?0Xmz7WlWYJzVL4+umdcWi9t77Hc6ciBzEk4AxybUka3kboYo4N9vsOc3NGIG?=
 =?us-ascii?Q?iLAE4gZVMrTuj4fkKpZEnbMYkJrkwoQ7RtBM70kWVvm3vbNoOsXebOR05VF9?=
 =?us-ascii?Q?9GhgBZKhP6dDmGtkqpIbWdGWZ5jv6Sx2B7kq3aCfxpE1kehTad66KHVvGiA5?=
 =?us-ascii?Q?QV3O+6Q8JvSQP3zY9E6x90h24p4pB71DkVikiufvEuYOZYKB2X7gAngLHX+9?=
 =?us-ascii?Q?66/GXnpBYgRD9ragfb0Y2lFs8YMMLal4xvz1xgzh4VV83uWPSoILOx9Z/oX4?=
 =?us-ascii?Q?+73Cko8LeGiuaI6+gl8foiOR6PHkTJbV9cpwF8J2T3hvrHTc2p/KOaq4umpC?=
 =?us-ascii?Q?C2cG5hze1iiP9Xl++puvEyoPfxpvCLLR6nwpRUAwwRHjqAMSYIokLztrYN6x?=
 =?us-ascii?Q?5LTp2EyPCQXjLsErbEMp2sQ3LNErpXLix0HzUkzDZhRJggWXeqaTY3eLOO9t?=
 =?us-ascii?Q?nFzh4AY0ckVVTSZeYbNGv+G6QacxTjMepfXRV1Vj2c1xCmekDkFpJhLHoyWR?=
 =?us-ascii?Q?PS+v7vUFG9cr7rKRTV9LUXxwbUdAeLzugS13bJsUDhUcHYyvY1bCxjK7jcut?=
 =?us-ascii?Q?Qjmqe0XgBpcz0UvW+YY5qMT0AGxF9xaQTaFQToMOIZnhtJ5G6ZyuPigXHj39?=
 =?us-ascii?Q?i8uW0OLG8LMsq6Up6IFo/UVPBbHY4H8K2m6vdhcDH/wkimm6eyk/qXTqDm+o?=
 =?us-ascii?Q?mCrRaH/FQMPjASne9wug5y8mE4ADCOf1m3D3YYm2EoWiDWU1z1pA0PWKMHH4?=
 =?us-ascii?Q?WieMAYUC3OmUqBELw7+vWzOymAsfqqCqdYMIfEI7+RXsWIXCdc7Q4sqduqXC?=
 =?us-ascii?Q?Q16YARvpjo8a5Z3fOiXRa6+xMOIiG3J23NMJC6d2cO9HTjpPpnFqvgwZKlgW?=
 =?us-ascii?Q?5J3De8HFsx6rVRXHaXxCkUEL9EVBxa/i7gR9ch51ZZDp5tIbD8rWK6kT8IiV?=
 =?us-ascii?Q?Sh51FU0OSRVHk7u25fYMj3Tdh51Vjo+OeG2FwGUcjYUuUV08v8aOzcu5FVBe?=
 =?us-ascii?Q?u5y7J9uuWTWmxQCGUJ8JUxUFgYcu/2tun+DpZdD5I0hX9oFHF4lVbPwenmhk?=
 =?us-ascii?Q?YIl319ssSqEXaNRohKs=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 16:07:29.6237
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e3e06ee-45a8-435e-6d68-08de4f993092
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7124

Add a library API for clearing and injecting poison into a CXL memory
device through the CXL debugfs.

This API will be used by the 'cxl-inject-error' and 'cxl-clear-error'
commands in later commits.

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 cxl/lib/libcxl.c   | 83 ++++++++++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym |  3 ++
 cxl/libcxl.h       |  3 ++
 3 files changed, 89 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 27ff037..deebf7f 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -5046,3 +5046,86 @@ CXL_EXPORT struct cxl_cmd *cxl_cmd_new_set_alert_config(struct cxl_memdev *memde
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
+	if (!ctx->cxl_debugfs)
+		return false;
+
+	path_len = strlen(ctx->cxl_debugfs) + 100;
+	path = calloc(path_len, sizeof(char));
+	if (!path)
+		return false;
+
+	len = snprintf(path, path_len, "%s/%s/inject_poison", ctx->cxl_debugfs,
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
+	if (!ctx->cxl_debugfs)
+		return -ENOENT;
+
+	path_len = strlen(ctx->cxl_debugfs) + 100;
+	path = calloc(path_len, sizeof(char));
+	if (!path)
+		return -ENOMEM;
+
+	len = snprintf(path, path_len, "%s/%s/%s", ctx->cxl_debugfs,
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

