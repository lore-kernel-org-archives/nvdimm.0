Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011035.outbound.protection.outlook.com [52.101.52.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FF1329E7C
	for <nvdimm@lists.linux.dev>; Tue,  9 Dec 2025 17:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765300502; cv=fail; b=ijR6X4GKqJEfqTOtAdtbvh3wDqYJpaRuBodApKQW8lM5KRnJW9R33E6I59rlanWY2yhfqA2rtnN0i9nGUCEbM4YnkaC/wDBlF/sPgu9qanCTzJ71WJJHeGiihIzCD03XHoHwQIHNSCb16/ldWmyzBPycS4ZM9tBETJlMegsQZJo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765300502; c=relaxed/simple;
	bh=nNQ/vepcm2RKZO2g31aYQ8pS9EmFx87ygRrSzVmiGqo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o2eVp9HM4c2hfRgp9Ge9k57fcIyOQeJ4tbrRh3L6x5+FCiYFN3iZ1U0JvtDMITZKimqRx31/JLwqQmzv6OqMnvfGDpyzIoAb2pXiaO6DHztGREM7hV9A9C+2wL3DWqWzzKq5uApVwC2n8F9wjFQiFEfJpBQmPNk50UxzvTiWbbc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1Kjfka45; arc=fail smtp.client-ip=52.101.52.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1Kjfka45"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WnHi52FyqrDrqi9l39Xp8zutAwHuHUZBu27E/wFjbRxq2wn/QzGBnW49nwg2+K/thkhXSP8lxz61x8YGAVTlQ5MoYgjHnv/T+9qF8ehBZDb4Oa1susAzkziPn2wLcIpeAUELEWk/Mmx+cpanyR6KiAFpMnLmIqbyh7Gl58GsMVxf0TCbnWc4dUJEp70T84FTR6YTANh/pm3kx29NDoC2VIPJU1zr14cHF8ucqflITuH4T1D7KCXLGKfDbqDBxJM5Wi+HUp+82E40YZxZMKRd1VNsJbj3625IpCdA4HWvaKuAmmGP2qfiQ6dzgcujtp5t1w6nNZamOj+s6AvkQ0NYtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tdUdabpVj1owKqSEAb0fRuACmQZRXEqqUbvOH1Rkbno=;
 b=sI1AV1vxoBNk8mSxFG768PuZ1NJFpw9kTv7ZNqG5dOiWNUpwzh/rjnQzY0yluweYii3hdZ1c4okpivOKlcq410eiYvt8NNyZpLjUlego0IBt5JWMYYYJ/bW7lZbStrUJLgIPBaLPbaBZBqVNPFxx5uXSjgx9Mmc6Mt7d+NWsDFMld2OcujsmIjVDlvdplMiD/Fad2WZfDOt2HGCQEBZt+oi0q3DxR+oKPROhT5BfXcFuNdjNBzMuuWRBRqfuJJp1StUzUNClZtO1t05VCaNPr9p98bekMI16T98tLUv9d666N+ihuQZXcQMzUVSsyWTH2huSTadUGvC40nRkiMQa4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tdUdabpVj1owKqSEAb0fRuACmQZRXEqqUbvOH1Rkbno=;
 b=1Kjfka45iARg5Zfn9hbvvF5JPfnGRxzKmCxye+b/q17uAfT3hlZED/O3MCd8qn5f1OaUBeE9V8zOSydUr2Pr8tH8C8aUdZeHY0RJgDnd+gD7f/AvQtV6Qk8D/VDYpC+1yPVxhVVJmkqb+pbqr0g2dDudbQXRT9Lbr3T5v+nI380=
Received: from BY1P220CA0012.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59d::8)
 by DS5PPF6BCF148B6.namprd12.prod.outlook.com (2603:10b6:f:fc00::652) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.12; Tue, 9 Dec
 2025 17:14:53 +0000
Received: from CO1PEPF000042A7.namprd03.prod.outlook.com
 (2603:10b6:a03:59d:cafe::42) by BY1P220CA0012.outlook.office365.com
 (2603:10b6:a03:59d::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.7 via Frontend Transport; Tue, 9
 Dec 2025 17:14:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000042A7.mail.protection.outlook.com (10.167.243.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Tue, 9 Dec 2025 17:14:53 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 9 Dec
 2025 11:14:52 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>, <benjamin.cheatham@amd.com>
Subject: [PATCH v4 3/7] libcxl: Add poison injection support
Date: Tue, 9 Dec 2025 11:14:00 -0600
Message-ID: <20251209171404.64412-4-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251209171404.64412-1-Benjamin.Cheatham@amd.com>
References: <20251209171404.64412-1-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000042A7:EE_|DS5PPF6BCF148B6:EE_
X-MS-Office365-Filtering-Correlation-Id: ec31930d-cead-4075-b037-08de374677e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zlwBCBPBZA7iYc7ZE+k3SVdlYqWLQB+4SSwcitQ/CDZ2uSfObq2snb1XI+A3?=
 =?us-ascii?Q?fK5E18MeG3gDJbI85hI+tRKwnIGCxykGaKHEQwiumoKqwJEYld53jcZJkv7u?=
 =?us-ascii?Q?vlyzM9YER1RmV5XANZq85EmQwEnC+FVinZlbECbsS2Jhc/gy5EemxeaOVHdu?=
 =?us-ascii?Q?sDAwWw9gzLZlsWneppBbT0RoZQ08SxQct6q068gu46Eqk1P04+iy6HUa/RXb?=
 =?us-ascii?Q?ZIonSICpZcx189cANj6c7ZapBuRJnUYIR5bWKdbmeoRluR2Va6gw8sOhZGVv?=
 =?us-ascii?Q?AXwEkPZlPRV29E/lEOLrSmYBdH9uIt8TKtjkFIkV1pZ8PeODxBjMb3CYLkYM?=
 =?us-ascii?Q?16mTp7Vo/URVKRH3taxgpYz9afXa3hXACDu0k7AvA8tKzdhge0gdMbm3VJcx?=
 =?us-ascii?Q?JFJaM0NqXUY6NIB5z0qP4EaYLTxSqB0HzEswfUSQzcMkaCCq8OnqmroXestZ?=
 =?us-ascii?Q?7Kk1ezTa9P7WCBVRYHEamVS/sgx4ngEdGj2pl2phgtc7fEbl182hSSLU4Auk?=
 =?us-ascii?Q?W1jgCCKUdVmlQdj6nNLjzO/XpqPgKb0to+6S6YwBbxZMKT2NLu0tp8OXLkaJ?=
 =?us-ascii?Q?R6WCCq6XcIuV+lL8wedz7VA3+rrbkiOMPgfBSKqwQIrcwjqRxrMinfF7ysKb?=
 =?us-ascii?Q?7lAGylcrI9Btynaxmo/FU+1fWv+qdlBTC2XPA7iJwyvLX0K2pLdGGmV0RVUO?=
 =?us-ascii?Q?MPcqqo2h74zv63C610o4/W3Tau8OPf7P7Wuwznf5d6QK1V0SEOiOnK5EFdsh?=
 =?us-ascii?Q?iWl9AUaZ0FUOHIJdGY8uZdiuEN+Ay2/9xni8sKNYQ7gBC+iCKIIv2RGt9dM6?=
 =?us-ascii?Q?kAauzhcmBZp/WIbMOOVpcD/rjpfrH8EsPOescF0/0/gwK3yY9yC/hL2qW0Z3?=
 =?us-ascii?Q?7zi0cQpllPBx6ANfDVAc5ExNUPnSbbugMyAaDmdmoRm+H78uQ9VChQNtqpBW?=
 =?us-ascii?Q?aTDgPcbOCYDYC+xz8bB9wZLRpZws7ZVZyFEXYfyMqYt+jtg7G6GClcyT6RPo?=
 =?us-ascii?Q?Kusm8Ol+GUrkMHVcay6AbLuxMQkIctqFLEL5T12YVluyG5DYgrnX/ndq5WAQ?=
 =?us-ascii?Q?Q2uSx+meQV2J4F5dLLIiwyAIStEstG7u64y14nwl3wCYNPmVoqoRt85toGdE?=
 =?us-ascii?Q?WdCZCtvIFhAUVSsfeujpIrWBJcikgb0aZIxF9pxJDaVBawfNwHwj/hIheEZq?=
 =?us-ascii?Q?0MNpsMI4ROk+/LuqfIrhtvnEIQuw4fqnVaMRvlNBxTXxHrpcgiVbMmYd+slC?=
 =?us-ascii?Q?c2W1M0BCvVRtsc7q3T+Fv1bLEUVDsHFNEzB8cdSjDzBsM3K0tVwyN267ung2?=
 =?us-ascii?Q?CxQdUfQQP8aJKFSeXZBR0RD84v2emPAYXJ9+9IeSgZI6sqk1NOqgRWiOChB9?=
 =?us-ascii?Q?lujbEKPZD9+FjQyTSm+ftXMTpI4R7W29nNUrxw7HAANJl0j07jQ8F/4wQQzb?=
 =?us-ascii?Q?azqamTQfCLSmNk2c7hQRhA7BU5A11o1Y67K0qUKb1YNxEIoiIkv1GiMyuVjz?=
 =?us-ascii?Q?RRZthhmBmXPX6ihHWveGFBTtvf5ZyexiLUFzxcsc2HSE+JJ/KZBpVcj9haZq?=
 =?us-ascii?Q?xFgrndRYv5YHGpsbQl0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 17:14:53.0570
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec31930d-cead-4075-b037-08de374677e4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042A7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF6BCF148B6

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
index 44d5ce2..34147b9 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -5038,3 +5038,86 @@ CXL_EXPORT struct cxl_cmd *cxl_cmd_new_set_alert_config(struct cxl_memdev *memde
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
2.51.1

