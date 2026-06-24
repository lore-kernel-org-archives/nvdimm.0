Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011020.outbound.protection.outlook.com [40.93.194.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248683DA7D9
	for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 15:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782313350; cv=fail; b=o7UqHkWVYdvph8K4Tg9Qd7s4a3waHiZsJxiL8SkkJFNNK4ev/84PlwuHRRg686+0siPRg1adDNosoFAYgfgVhBRrI9zREcw/AI2CfFhetK0NeAfIDgL44D4oFaVE5g7CrArPTdDDlqdgCzskcNMXvS++7K5NpmmhfqvN+Rdntkk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782313350; c=relaxed/simple;
	bh=0kSi2uR5NKwxTfKWwsIiyPnDPLp7kU0++PQI2/fD9+8=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=eO3ql/zeeXpiJYMCd7t9gaYFlli0AINfi16fZdcS3iqUiP9jvHfR4rwHb5PBBTlCuhocsPf3ClRU0c7E/fj9RwJkg7aCD3Yu5jNl/MDN2wN9Vs1o96td0CHLnfGosucZqnyUEuIasmE+Hx8L3ZEX1F/o9E9t2arANDWXqoTZ0qs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=b9KuhS6c; arc=fail smtp.client-ip=40.93.194.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="b9KuhS6c"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XmQw2HMipy42hAPuA5tIBdJhnUK5s2nbKcLYAKO9aMTuCyfD4bdkaCtR8BCM+bz+avXFmlXOqTOlGMEO1MoIP34K6yWr2ozSlOcFq7laC266B+4nWqRuEv5e2TotTGkLMuTQyIACeIM3A6bvsKufN6UvdOD8bTrwCkHPLv9q12J/RMQej0drkDPDbH1vZ3Cpb/e1kinLjDjbZRRzszA8l6ltS4u5KRmEOHKuHLVfKD1TGlkLzML1IYi1IzON/HNsbChi/h30RzcLFswr1Zi7GCZgdmFj6q73OjMpLtM6n6y/oFYdiT8mYL4/wX7NQ8O5yK+YtBDjYO0//5gB5Kf3kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0raGN+rtNL5z/BX5FRPM+DqnT+aIc6t2QejLXBPq4Is=;
 b=Tug7ZErEeG7tDGJpE+T5cL6yJxm5ZtqZOTqswFZXHOyWe+/Q7v6MjeMPEfci1DjFaUXtF6hDab64rjUZBPrxmptY+SvAVoMwl1Qpc4vIYeS92FE667CEaRwfmqe7rF7wFCddd5e3shpfiex7EavCmF/2ElSWnzm0bDuJ4E84LkycEhRUHIeHf3SK2GZfMdvXE56SkmiXQZlWqlJ0aOllIfkccq3aymBkfkiVzPel8RpKNGzCh1iSbf0L2t+eFUDRTPwFSwGkrdi5JzuYTsewgAswsURixVQa7vFrOnaa3Yn0Uk5JWfuGJXEF79HTukrlzMVXZxAE6W3rxiTFDacDXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0raGN+rtNL5z/BX5FRPM+DqnT+aIc6t2QejLXBPq4Is=;
 b=b9KuhS6c6lqzxvjID/mShe4aSXdvWWfccO9rqJ6WFKyXMezbMdWoQ15b9FGeMh/cLOuZVnePt/Ev4DtgsuZ5KJ049GB3rn9YkT/DjhoxGfMgBzZIvoxiUqIQ3v5m+mbdFquj0/a+nKC9UFNJrYQOJHntBMxxilsUcZw9IWTrv8K1OEJa1Gae7HFMrPqNL1R9JFZvaDaGgsh0MvuzG2cs1wymC7cxe1CwQY/QTLyfii3TwbUqmd/21iZ1pRkaUUjSAwLwpz7X+4uR3cYffwkQ+9sB87ItrpDFOc26r9JPTC1sCN44543deJR1yVJU9XqK4qvJkp6a/LBBGGKEYDvXew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW2PR12MB2380.namprd12.prod.outlook.com (2603:10b6:907:4::32)
 by SA1PR12MB5637.namprd12.prod.outlook.com (2603:10b6:806:228::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.13; Wed, 24 Jun
 2026 15:02:22 +0000
Received: from MW2PR12MB2380.namprd12.prod.outlook.com
 ([fe80::90d:c5c:6a5e:94a5]) by MW2PR12MB2380.namprd12.prod.outlook.com
 ([fe80::90d:c5c:6a5e:94a5%6]) with mapi id 15.21.0159.013; Wed, 24 Jun 2026
 15:02:21 +0000
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
Subject: [ndctl PATCH RESEND] test/cxl-mbox: Regression test for huge CXL_MEM_SEND_COMMAND out.size
Date: Wed, 24 Jun 2026 23:01:58 +0800
Message-ID: <20260624150158.55264-1-icheng@nvidia.com>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: KL1PR01CA0149.apcprd01.prod.exchangelabs.com
 (2603:1096:820:149::15) To MW2PR12MB2380.namprd12.prod.outlook.com
 (2603:10b6:907:4::32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW2PR12MB2380:EE_|SA1PR12MB5637:EE_
X-MS-Office365-Filtering-Correlation-Id: ecae767a-2869-48d6-a047-08ded2019531
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|7416014|56012099006|3023799007|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	q34Nb6I64aCASPBHPR5yUJNWTCU62piIJo9yDH8nyuf9uTX6K/bu4GWvrOb7K4HM8t/df0RZHUTeIAX6KDne6dOXwoseeVpDoMGE0otKCxUrxYjyevoitJt+nmabKQueNsylTYlHaGxpUjKS6RoLRWHi5C9hQmhvWNJWplN2GGBt/YGAy4TKSFOnvLxvN5yQDLBgBcAZmhhzzhyMbc2twOmXRLwcb0ULrojuxCLG31dROLsm+/HiSXLFaf2sC2nMC6adPHUvwDm7Ck0Fe9NJibSqHx67AKJKJtgTSDjhnqhs29HrdEn7TustWwyCcMm4XAJwmsgkD1JXwZGLbascXQ/11ZqpNLfYTH65KIdECmims6/2iYq8rVtd5iaiWpWvFgr9obDaumNLU+CzArLAbYinyDy4VDilzhenQXQOSHIVJuPNdyoTRlojPOtkY2+Y4ENcrEcudo7yJIhSApN/DeOiYUvx/MReifWk/tWRfranPvgSvfokipMnY0D/7HOcqAAf0MVDSZlyWaDnuTPrYQig/5Xo2hrFj5iwYNHE72uLXZ42+rWlMMNg8ILigFS17R46Eb461vzXaIDHJx3sMCeaGDWL+TQP2vaA70hyHoCx2b9niunKN5blahl6hzFB1HSxxv8X3obT7zXB+P5ZeXZZq/f1lP+L2ezzndnmE6U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB2380.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(7416014)(56012099006)(3023799007)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XmV512o3r35T4a6FLLIVqQ8a6J7MsTyZJv0Bm+FkOUO3FYdEkUhU2O2YQvog?=
 =?us-ascii?Q?fhCxozYp1yXWkUQxC6/E+xfP6eJigY3bo+2x3VMoTFK7/r4PoRgyYbbUdsGF?=
 =?us-ascii?Q?DN2Yh7xgXA9yn/1/TEPjw6fqRsnTsky8PVNCjzAP4e8it88IRFdT7OUE1wue?=
 =?us-ascii?Q?ieK5Ahp82nYV/BpIArj4A00/pNsxDcLhEYuTgjfKl2ZPoGCgPIHDRGg3DFmS?=
 =?us-ascii?Q?hYMC4MdfuteGVkO40TSgabFi+9L+O9UJZKGoqnZuTHQmCxXx0rMynEysLug0?=
 =?us-ascii?Q?ExVF+Yi+0hi0OFTh3OdC/IE2cwAR0gmI9S3yaCV3IIxYMl3YH261Dfu4YMsY?=
 =?us-ascii?Q?jrQt8f0lD+LTHIsmNRW1nLgUtB7X5kfWOxTeurCiYq4nnxavNdoyX37TMh/s?=
 =?us-ascii?Q?7toFLfBqm78KkQmY1/vnHMeCuSaiR9EBMQV99/5cJLKKrz7yOjoaW+A1Ipmr?=
 =?us-ascii?Q?wrY1nlxkBwkT4/bKB7eQAMf313yJAAZk1UXEHns+AU31jU4tzit+kyrMEZKJ?=
 =?us-ascii?Q?r1277tdraymPKS1uc1v34Zr0I5Iw/0ybQNVmzizC8BkuIOUip8JaKK1XcvVu?=
 =?us-ascii?Q?NPlKiz0b7+KDXbLay5+wf1v4hfC6/NKIjfM6sLJnmv913+wszhwE8Bkzjy8D?=
 =?us-ascii?Q?Z9HYdq3NK/8otXaYkRO6ln7LgF3btaohdZOBIIYOUHnfmiSCczN0TJtEF5k2?=
 =?us-ascii?Q?Qpa2IMyTX2AjVEK6X8NU9zCnfCTbNOLxc0JstYq3YG1O+qRmeT8JDwmJ/Sxp?=
 =?us-ascii?Q?eqnsv1b6MDGFfbdJfvwcZZ75R1tmDLYwGHw+4W8KOiRwYTiS2eEFl8dofCYW?=
 =?us-ascii?Q?sA+46QWLqjqvyJ2NoiN54pV2FlRd5xu4BJSWLXkFGNige6pVUJoWDKboHW15?=
 =?us-ascii?Q?xa4E/9d+mTyJluWEJpKHrSCEYS7qKYmdx723N3XTy7XlMJw2dAHnMbpEUuR8?=
 =?us-ascii?Q?qmrqxpbJA4T/yllIYfbtYLCJBai9J+raCwNaWc5Bd0gRikeQfRH0/+v999kK?=
 =?us-ascii?Q?XnPHh6i+Dkzm1p5lGBUNL44a+jUuBbzxZ7PW+3LpIsrYDe5SSZLlux9TjTeS?=
 =?us-ascii?Q?psmBgonxY7sv++xYAjiB+wlAHyhTaeCa9TFNnZDOn7ZOdU6SVrpz56PBGh+N?=
 =?us-ascii?Q?lpJxL1HBPBSsXjCix6nIm3RTcFOFrqVNQRkOiDGVzHhHsCwukNZP0xNqI677?=
 =?us-ascii?Q?VQxWAIjEsvmnKwH8mq8MdY+LGnsf+hHbbdDjiXgInLjKlYc/5g6uqJ6t5pe8?=
 =?us-ascii?Q?Ju50peS8MyUTrr2EnWIdG792axmAcZKvIw/nbflLflkeHu3KkjVjKl8zTLdm?=
 =?us-ascii?Q?EYLlKSYrF3DS9daVCBBXZqkQpe1L1KaUJgCJY3e903PkJ/fPgTeX/7HU0XmF?=
 =?us-ascii?Q?gOFZgK0K/U0KQAfLj5HcKgeZmdQbmivLGAT48UnV4ffhVf0oebqkIyDm7Nwp?=
 =?us-ascii?Q?2z/IzSIIAF/KPn5Ck6OlwHxXI3ZGTrFhucrynnb/9yX2thHpofuwFH2fUlta?=
 =?us-ascii?Q?pVjUDT+I/8RlVpzyquRXkAstdemCaF5m+yRaYBVfkHRy+qezNcphbQEyxN33?=
 =?us-ascii?Q?VseWSqKBu2BXIMJ++p6oXJijTJmZSIaXyctuRtneIIUjgxPjNMtavwEZ0ZZB?=
 =?us-ascii?Q?okcvdzu5c6KSYOmzBbgPg2afvgtXzoGG5w8cKuqQDCDrqHvzsjrIai6Tg0jZ?=
 =?us-ascii?Q?MPWUDa7xqDRuZOmr5IpHb1hm08Jn8ymXO/xiAD8AVT4rKPbP54XhcGLp0gWR?=
 =?us-ascii?Q?09kVYSHjSg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecae767a-2869-48d6-a047-08ded2019531
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB2380.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2026 15:02:20.3389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nkimHBy56UkVFTYQ47MFbTXQ4+O+c0fYrvE0/Hhxw4Au/T5FHH7JjETKCYxTDMhaqmurVzoeTFjjosWP+GiwdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5637

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

