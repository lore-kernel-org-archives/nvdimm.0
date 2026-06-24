Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010024.outbound.protection.outlook.com [52.101.46.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8120C3C6A38
	for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 14:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782313151; cv=fail; b=C1flf8k3fTpH5lEOOSKU4Iksl58rvPcCSOD7BRMdtI266DPJ/k/SN5vMY8xH9TOMEiL1hApIg+HAMUNf6isIWXIXnc5zsLhUN4gjO9QMXIIohQJspcxPhPfHrlmPl8Xa+Q5Hsc3SMunNcQ56UpLa76y2wicX2K3vY1scaIWQDEk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782313151; c=relaxed/simple;
	bh=0kSi2uR5NKwxTfKWwsIiyPnDPLp7kU0++PQI2/fD9+8=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=eIUQCAW7hZFWJmwC9urkH5g+Ld6paPcB7oCOct6Yx0d9fE0/wS2+9nXXqGvquhTomo/gRrh23P3ng9oXUcArUdtpZu272MlBYygb7KU7H/aEH6tNfligrCPAi4Lb+By3dEb33SzbiNJV28gLuaqIT8bGOTCk8JRCvmGACvHgJaI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fsmWY5xT; arc=fail smtp.client-ip=52.101.46.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fsmWY5xT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SQJyPQw3iJw/XVXORryeqb415P8iokkB+36yNPfIj1B4uEBE4ekZNwHc7XZtwh671QhhulKVDKlRuEUcksUNNviLDyJqMWcVg+e+zepIZuM/v9AZpn3FU1I7v2Cw7WWegdi/pzxbvSULKb6WaEgs5SzHDlTDs7Z6mf1Awg0S0BLPU16FarAVwIMQ3bxLYasAtrhuLoVwb0YYU2s1tJ2SR3LXU+TuN+gpSHwkXkrIXdfMldC3z7p+KDAkASTAPatsOxnqy2JNIrhSZPNIF2axLrPBuQSVubeXEsjO/tIFRYgbiO5za721ORqWj/XEezQfOIcPji3ZLD0T9Wqz7XqqGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0raGN+rtNL5z/BX5FRPM+DqnT+aIc6t2QejLXBPq4Is=;
 b=LDLbPZqdCb9v5VGj8ikXPrN+4V/IQpUazbBbgB73MsKG4UgFX/glyTjSiOcSS/SRz8sj8M8wok/rtYbgpLk4XGDMiiQWEcYyel4Wuv96poRH075uXw9ZH7VrlEv1GbvuqdqKemo3TOGrA3oaZ0RGvcBkNzh0sjS0qwdSc6nTuKg4yftQMvkg13/V23yaJObw5qo7tEHIZtLDsJiL7fk18G2uYU6wYs3p+J4VmstJCqnJ90ZkKIinru6R7NVGOECR4NrAEz0xDOOfP8p3Lfh5dn8V3K74G4uny4rDHW93nb96F0+Q4R/4IEUDWOb2t5UQaWrM849wS4YgFY1BBlVlYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0raGN+rtNL5z/BX5FRPM+DqnT+aIc6t2QejLXBPq4Is=;
 b=fsmWY5xTQsoVHj3AniIiW1z7u+xneenKPw0xi8Voee8bREqdQ9DKSEVLdWqnqpdrHioKPWrRki8fxfmHVsHfRV9w4fksEo9fJjLUrC8vbqvkPXtjO9CoNcUNeswEGKvaVOYFfO6uCwkZ05jbiRYQnuxmDrilcoRY2QV0RPrjT2Z/8yAq/GBvqI2FACHsYoHPmd94ERTjBL8AepWiKBOzzxcJtTXKn23YPrVhJRIktomlz3cEBef6rYZDE8FaCB79KtF1WL3/oG8VzwDg7EfkPHHlSqGtiKoawNkQ56T+fUq502FrhmVICVpQ819OTCenwLka1Jy5Jrec9RfRDRg4IQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW2PR12MB2380.namprd12.prod.outlook.com (2603:10b6:907:4::32)
 by BL3PR12MB6379.namprd12.prod.outlook.com (2603:10b6:208:3b2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.14; Wed, 24 Jun
 2026 14:59:01 +0000
Received: from MW2PR12MB2380.namprd12.prod.outlook.com
 ([fe80::90d:c5c:6a5e:94a5]) by MW2PR12MB2380.namprd12.prod.outlook.com
 ([fe80::90d:c5c:6a5e:94a5%6]) with mapi id 15.21.0159.013; Wed, 24 Jun 2026
 14:58:58 +0000
From: Richard Cheng <icheng@nvidia.com>
To: dave@stgolabs.net,
	jic23@kernel.org,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	djbw@kernel.org,
	danwilliams@nvidia.com,
	nvdimm@lists.linux.dev
Cc: iweiny@kernel.org,
	ming.li@zohomail.com,
	kobak@nvidia.com,
	kaihengf@nvidia.com,
	kees@kernel.org,
	newtonl@nvidia.com,
	kristinc@nvidia.com,
	mochs@nvidia.com,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Richard Cheng <icheng@nvidia.com>
Subject: [PATCH] test/cxl-mbox: Regression test for huge CXL_MEM_SEND_COMMAND out.size
Date: Wed, 24 Jun 2026 22:58:43 +0800
Message-ID: <20260624145843.55116-1-icheng@nvidia.com>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: KUZPR01CA0022.apcprd01.prod.exchangelabs.com
 (2603:1096:d10:26::16) To MW2PR12MB2380.namprd12.prod.outlook.com
 (2603:10b6:907:4::32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW2PR12MB2380:EE_|BL3PR12MB6379:EE_
X-MS-Office365-Filtering-Correlation-Id: 8747fb6c-5169-4438-2ef2-08ded2011c1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|23010399003|3023799007|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	Kw2Fb13h1Y2IiVhD1XKnTjEb9PzGS0B8gdyFyJB02BhydnmaD9WNJgl/wcpOir/U1mzwORzwfTjKQvP6ZBVZMymZ41/y/TCpBUBPDZAK1NN5KxjxRqziDBLMolizaHADitTxlFR0lzL3i5iHfKHY1QXz6fyTNFEP988nzyUt0aun/mTRyoaQ2BPeeYokwKxYA1FTtjrAjbgG4nZ+mj7ZBt9+/wOG6TuyV0fZtyOzYV2Slmh722bXBH6OgRe1Ut+iG19j91uLEizoNN/E+HUEGTTEQCARAPmoI0Ib4nFMR5pNUnMBdlUL5OfN850P0Ex+ZBoteI9jPP3uTIsev9IPUQ4IJNPlu8F0lAkRyOUQS0NcqNNLunnDAyPFqYjXeIatjlbOvZblzE1YRBEoqtQnZtdzWbdyn1YfygiHMZc3swDmwiODJg2nvIsvQbsglXiYB5KdPl2n9De8Oz3CVkxVmTvzGW9aFRa1R9216RsXC8S3mclbO5kJbfWjl/AIs4oZ66hbmAypmI4jooWp8TCHAwFDD1UKzPeZzop5+xSICN81nj0nAtYhm/N/YQQPlZZuDeMai0ayoyXUQdDCkqAHNmjVY4V4T6Q3+KdAzcUBiaKIt7X+JsKAybEHrPS3C5AI3WE7P7XNhaMGOHkqRJ/MftDyQ+f8hzXlrdCMYokf+2M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB2380.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(23010399003)(3023799007)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ELCDllORdbM+4dGLs5uCzrXbTKp+NzVg8sbKFPtAx+PwzuXFgr2symOKjLcc?=
 =?us-ascii?Q?/Yrd6hWZNItSplDTbrrxW/zvFhiA+S3k0w+rPgLAqT2czc63g/UuXNeo3sC+?=
 =?us-ascii?Q?9hLV9y0v3eXIF2Xshg59AU60tGlqB9p9g6ykErPuZa9YePn2ldUlWH3gwXFD?=
 =?us-ascii?Q?Sn9wxdbmz9yo2xNgcRbwJhSz/ss1pbECfgyEiBpBhd6s0GaUw+7Diw1GeSuI?=
 =?us-ascii?Q?bGN0hO76iJ+RZGmNUydlUlRelvI905OIxlNo9UxXgHIonmfMUtNuUZkOHuAg?=
 =?us-ascii?Q?ZyUzD4HCrkhEsu8pBwrMte3SHdEtSOOJ+B8NmFcQ2FlxY/CSG4MZnGQPIA0p?=
 =?us-ascii?Q?fcHn/DxVDgiFKp/Uw7Z5P8tQR/bkbCFyV+huOpOC6vqqUpTL26B0CQ27dhyN?=
 =?us-ascii?Q?35hh4X7tZp6DwtHDnciPD+wg0qUefGscsnPpLszyUMD6qukuTulxkJHpyeNZ?=
 =?us-ascii?Q?sqSoJxOZoO7yfkRsg0JpPb5K+AZ+LhsKxLphvbw4/qJN4nEw/PwfcJRuOC76?=
 =?us-ascii?Q?E2JvUZyrxrYnb+v8hz2oHYc1CaByLPVO5VCVrUWzJt2ZRu6TMMCAiPaiSwRt?=
 =?us-ascii?Q?09A7xFthuqWoDnlIMAd3T0ZzLKKaVRKXGyrFBa1T1J9O1b7eGrr+VhN5jYRY?=
 =?us-ascii?Q?zTtmt0nb982SbZpoykc9piQpICGm89cwOWIDNThRd7ldBtUodZvhigqBlSJq?=
 =?us-ascii?Q?8Ma04sCk//umSGaO6KrMCdm72dyxQcd0OCgiXi6PWwIzCH9UgsRhXjjyr2hL?=
 =?us-ascii?Q?EQIpwtGzfIAppO6Kc5lUwEfMTuPvhyBsqMc21/dj13g3WtcU0fSpMYKmA7PD?=
 =?us-ascii?Q?22HWDWqvR1QhnrTBjXM0pk1JPG6G7XmD1zSVt/HI1n9D0UAL2V5LNfD9RTdB?=
 =?us-ascii?Q?eq40xRC1+ADnuRUxcEJqfYS7BqGnhjbV0MGs+WBs9Ou0d9/89oRMKB8sBgpK?=
 =?us-ascii?Q?MmP68o2twHmsTnJ7ytt5ps2I02uZE+7Z/z+KuDjDsr+Ak6yEfJZ+SLH81mHe?=
 =?us-ascii?Q?NzyTBQGNdXxIvM0Fj2NZLrbUEPtz2ka7njeAl6kvXSdNg/lRGd+/MOYF2Kzx?=
 =?us-ascii?Q?Hrds+3E3oHrJa3ARTMB9OX+x4zFyBmfUUvTGwy9YitVOoa/UoJmJz/w2y6iC?=
 =?us-ascii?Q?v0XjqlqpEHPOP19PLkkiGqpUqSZJwsWZBOZx7IbYu2/j1nCQWQxgvj4hZHAc?=
 =?us-ascii?Q?bijF1vD+l0UKCcAlOkeXrps3DFIuLWAIB2ErDn7/sPoPAUC1O0a4O/LQjnLP?=
 =?us-ascii?Q?IXqZOwa1GK+0Lk5JyWCYneul22Ko+0mlPTMynxnCv40ZzpdImlA3RiRdYAUp?=
 =?us-ascii?Q?aFerlGnqvkpezWG/FrDhYT7PKngrfRxyPdhwQ2nKcLFvLvGudWxWcMxnjy4A?=
 =?us-ascii?Q?lAPhF7Nqwwe04mpEjeE/JrklIpFpz1I8ZwvblMy2r37zDdY5jtHRt8aorstl?=
 =?us-ascii?Q?eenWwlUoUgl811rrDtAANHQIq5JG0LUW8ZecK3z/HHs06V9cPW160lahtOHn?=
 =?us-ascii?Q?ySkj9LDzK3vDztTvoaGNYzKgQeLo4zXwQYMGKty0x0Dk7/Za0GiHAMGtyeCQ?=
 =?us-ascii?Q?Uc8Yohy1DcBdR1hJuGR/zsXUvZa0VvK4xk8xobxSnK4KXoo7c3WCVBn4Vw+q?=
 =?us-ascii?Q?97DxdvwpTekFL0hCIf1uLKdB8YTiWCk/rv7aVOjpBU2xkHg0fN0c9+MN19MT?=
 =?us-ascii?Q?1FCCslcuiL4WmwtZ519HZHbmPnIqZxESHXVJKe3S3c+YrjJXVaA6sulMZqv8?=
 =?us-ascii?Q?y1ZGFbCv3g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8747fb6c-5169-4438-2ef2-08ded2011c1d
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB2380.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2026 14:58:57.6627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9M5kY/RZ6AUvCjRYmDd6WUlwRIkw8ys9iW+ruj5i/N+x358jBS3Z5ZZUNVcbrom0t2bXv2EfdcCF9OaNUsd5MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6379

Implement a regression test for unbounded kvzalloc() in the kernel's
cxl_mbox_cmd_ctor(), which a CXL_MEM_SEND_COMMAND with an out.size
greater than INT_MAX could drive into a size > INT_MAX kvmalloc() WARN.

libcxl's cxl_cmd_set_output_payload() rejects an out.size larger than
the mailbox payload_max, so the test crafts a raw struct
cxl_send_command and issues the CXL_MEM_SEND_COMMAND ioctl directly
against the cxl_test mock memdev.

The test is for a kernel bug fix [1].

[1]: https://lore.kernel.org/all/20260624144147.53997-1-icheng@nvidia.com/
Signed-off-by: Richard Cheng <icheng@nvidia.com>
---
 test/cxl-mbox.c  | 129 +++++++++++++++++++++++++++++++++++++++++++++++
 test/cxl-mbox.sh |  48 ++++++++++++++++++
 2 files changed, 177 insertions(+)
 create mode 100644 test/cxl-mbox.c
 create mode 100755 test/cxl-mbox.sh

diff --git a/test/cxl-mbox.c b/test/cxl-mbox.c
new file mode 100644
index 0000000..d81327b
--- /dev/null
+++ b/test/cxl-mbox.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2026 Nvidia Corporation. All rights reserved.
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdint.h>
+#include <stddef.h>
+#include <stdlib.h>
+#include <syslog.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <cxl/libcxl.h>
+#include <cxl/cxl_mem.h>
+
+static const char provider[] = "cxl_test";
+
+/*
+ * The cxl_test mock advertises a 4 KiB (SZ_4K) mailbox payload_size and
+ * IDENTIFY returns a full struct cxl_mbox_identify. Post-fix the kernel
+ * clamps the output allocation to payload_size and copies that many bytes
+ * back into out.payload, so the buffer must be >= payload_size. 64 KiB is
+ * comfortably above the mock's 4 KiB payload.
+ */
+#define OUT_BUF_SIZE	(64 * 1024)
+
+/*
+ * Regression for the unbounded kvzalloc() in cxl_mbox_cmd_ctor() driven by a
+ * huge CXL_MEM_SEND_COMMAND out.size. The kernel fix CLAMPS the output
+ * allocation to the mailbox payload_size; it does not reject the request.
+ * Assert the ioctl SUCCEEDS (no -ENOMEM) -- do NOT assert -EINVAL.
+ */
+static int test_cxl_mbox_huge_out_size(struct cxl_memdev *memdev)
+{
+	struct cxl_send_command c = { 0 };
+	const char *devname;
+	char path[256];
+	void *buf;
+	int fd, rc;
+
+	devname = cxl_memdev_get_devname(memdev);
+	if (!devname)
+		return -ENODEV;
+
+	snprintf(path, sizeof(path), "/dev/cxl/%s", devname);
+
+	fd = open(path, O_RDWR);
+	if (fd < 0) {
+		if (errno == ENOENT || errno == ENODEV)
+			return -ENODEV;
+		fprintf(stderr, "failed to open %s: %s\n", path,
+			strerror(errno));
+		return -errno;
+	}
+
+	buf = calloc(1, OUT_BUF_SIZE);
+	if (!buf) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	c.id = CXL_MEM_COMMAND_ID_IDENTIFY;
+	/*
+	 * 0x80000000 (2^31, > INT_MAX) is the proven reproducer that trips the
+	 * size > INT_MAX kvmalloc() WARN. out.size is __s32 in this vendored
+	 * UAPI; cast to avoid -Woverflow, the kernel reads the same 4 bytes
+	 * (kernel UAPI declares it __u32).
+	 */
+	c.out.size = (typeof(c.out.size))0x80000000U;
+	c.out.payload = (__u64)(uintptr_t)buf;
+
+	rc = ioctl(fd, CXL_MEM_SEND_COMMAND, &c);
+
+	/* Pass iff the kernel clamped (success), not rejected. */
+	if (rc == 0 && c.retval == 0) {
+		rc = 0;
+		goto out;
+	}
+
+	fprintf(stderr,
+		"CXL_MEM_SEND_COMMAND huge out.size mishandled: rc=%d errno=%d retval=%u\n",
+		rc, errno, c.retval);
+	rc = -ENXIO;
+
+out:
+	free(buf);
+	close(fd);
+	return rc;
+}
+
+static int test_cxl_mbox(struct cxl_ctx *ctx, struct cxl_bus *bus)
+{
+	struct cxl_memdev *memdev;
+
+	cxl_memdev_foreach(ctx, memdev) {
+		if (cxl_memdev_get_bus(memdev) != bus)
+			continue;
+		return test_cxl_mbox_huge_out_size(memdev);
+	}
+
+	return -ENODEV;
+}
+
+int main(int argc, char *argv[])
+{
+	struct cxl_ctx *ctx;
+	struct cxl_bus *bus;
+	int rc;
+
+	rc = cxl_new(&ctx);
+	if (rc < 0)
+		return rc;
+
+	cxl_set_log_priority(ctx, LOG_DEBUG);
+
+	bus = cxl_bus_get_by_provider(ctx, provider);
+	if (!bus) {
+		fprintf(stderr, "%s: unable to find bus (%s)\n",
+			argv[0], provider);
+		rc = -ENODEV;
+		goto out;
+	}
+
+	rc = test_cxl_mbox(ctx, bus);
+
+out:
+	cxl_unref(ctx);
+	return rc;
+}
diff --git a/test/cxl-mbox.sh b/test/cxl-mbox.sh
new file mode 100755
index 0000000..67fecf5
--- /dev/null
+++ b/test/cxl-mbox.sh
@@ -0,0 +1,48 @@
+#!/bin/bash -Ex
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2026 Nvidia Corporation. All rights reserved.
+
+. $(dirname "$0")/common
+
+BIN="$TEST_PATH"/cxl-mbox
+rc=77
+# 237 is -ENODEV
+ERR_NODEV=237
+# TAINT_WARN is bit 9
+TAINT_WARN=512
+
+trap 'err $LINENO' ERR
+
+modprobe -r cxl_test 2>/dev/null
+modprobe cxl_test
+# cxl_test alone does not autoload the mock memdev module on this box
+modprobe cxl_mock_mem
+
+main()
+{
+	test -x "$BIN" || do_skip "no CXL mailbox test"
+
+	t0=$(cat /proc/sys/kernel/tainted)
+
+	rc=0
+	"$BIN" || rc=$?
+
+	t1=$(cat /proc/sys/kernel/tainted)
+
+	echo "status: $rc"
+	if [ "$rc" -eq "$ERR_NODEV" ]; then
+		do_skip "no cxl_test memdev"
+	elif [ "$rc" -ne 0 ]; then
+		echo "fail: $LINENO" && exit 1
+	fi
+
+	if (( (t1 & TAINT_WARN) && !(t0 & TAINT_WARN) )); then
+		echo "fail: $LINENO kernel WARN taint (bit 9) set" && exit 1
+	fi
+
+	_cxl_cleanup
+}
+
+{
+	main "$@"; exit "$?"
+}

base-commit: 8ad90e54f0ff4f7291e7f21d44d769d10f24e2b6
-- 
2.43.0

