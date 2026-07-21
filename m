Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010053.outbound.protection.outlook.com [52.101.201.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C5D4071F8
	for <nvdimm@lists.linux.dev>; Tue, 21 Jul 2026 06:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784614899; cv=fail; b=VwgKIhcBqWBTm3AS69pT2t5Q3s2XWgC/9IIDPMIelBwZieDRtWjLg7aGowe8e7dcRctTCBhRoVCjK4/UKmcX1OZslPUajg7lesz0l0d2HVPtdNFe9iWkSk+H9Ri4ngwJtdz7JemNPBli8rCmipysotKD3o3WePvbBZWGpyR42FA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784614899; c=relaxed/simple;
	bh=o7bfzAV2EccWdHc7/Pb6qRdStsCHuA/+8Oz5g3SS8ew=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=TQlraCld4QSR/+WGTbMIg5WoNE4WlTwH4rvORs7QHSSQIJEQq/q5fhocbti43X/yzjoyYKtINAim53Uypqg2EzDHnocPIyoVNjKdp+LKmcYxqqmjngPBz266s/ofgzH6Qz2no3zGIX8b+HxItsXN9P8v0w8y0ytaR4K4/6T6nnw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=M7IMQP8C; arc=fail smtp.client-ip=52.101.201.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="M7IMQP8C"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dEUR1mHd8sr8dzEkhJVtPBvWLYRaK9n/bI2J3LcUyYX0eqzpI9vvBRtkmiZQhl/cP9SdFNKpASzmBUea9HSngRFMrOgxh59n5dWKlki3hVLq57uPIZnyTrOH/CDz1FVO+p4fAHKNCrUDQgJTM34TcvCjLFgk/LSw0+iIJgRRHXYd1paonK1aosUOr9dBxqQtM1IyFb85OUD+fKM69vmNdaUjv4mHNXif45FgZQii5bZ4wWE1wHh4xDRilTBddfuHZ3YcihbaxgniKQma4BlKXPldL2o7ajRAVXe8FWtKr0lmWd42shVYEXeJ6mhKTj4LJiyQn4V0EmrjVnAebpyIeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ptn//OXD1eCydjpZcTmqTpMhwgoy1aLwqU2o48k7GJU=;
 b=DQv5xJAdnPM59/w6KJhfCc1JXb9IDmLgG65ZynRLPEUOJUwq6Yk51VkNMRkTURR6pYM87at0MFfhAf8AKqWF0kkIYY5E2P2sr6rNxzkkF8qCTMpCm0ML4EtOULg1B0dB+bl+rUV/3aVL7h9+j6hp2YQB+0X9HJDy5k7MOzVc8rLA8pHd2Dv+4l+kq44ABlFUDg/yuZh3/YPNK6h4Kp+rOeLElPPAezG1OGqSzfBihtInCacpd4ebDQeOQIYyUyD99yfeaDfu6mhe3VIdXZpQn0iFiSCNfVS69iC1dpBcLQe/ZezA2vDffNopmUWzqj6fWnr5AZjx871UmAfiNl+dag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptn//OXD1eCydjpZcTmqTpMhwgoy1aLwqU2o48k7GJU=;
 b=M7IMQP8C0bxPE1ZF2CXHA6SJKAsQltK66ZOti+CUKmXEbpMX5DYEFQkeK1BdH7x6EqTNpQseKjNLHzFE3VJWDR6cg5iLwdRTxRvE7zJk6DkG3R8eDFevyQ+vE8KA2n6PyJygR9V3/GkTG08izEyB8qb5z6edblCCqgZhW1//J8Ztzj92vwYN8ibV0I/le5PmMh00sWF6meRh81rQJIR19xcXvD0bQL2yubI7ocZZkZiWMRt3z3Eyb3bUiqta6tn66k6LZSs86kndsSupJSpbxvsz5Pd5LBVvvPDhbHW4aHwGFRuV4ZZ9ITj7OtAzsd5V+6bcohVFuCOOiF0ILB2uEg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by IA0PPF7D094C5BF.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bd4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Tue, 21 Jul
 2026 06:21:33 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0223.017; Tue, 21 Jul 2026
 06:21:33 +0000
From: Richard Cheng <icheng@nvidia.com>
To: dave@stgolabs.net,
	jic23@kernel.org,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	djbw@kernel.org,
	nvdimm@lists.linux.dev
Cc: iweiny@kernel.org,
	ming.li@zohomail.com,
	gourry@gourry.net,
	rrichter@amd.com,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	newtonl@nvidia.com,
	kristinc@nvidia.com,
	kaihengf@nvidia.com,
	kobak@nvidia.com,
	mochs@nvidia.com,
	Richard Cheng <icheng@nvidia.com>
Subject: [ndctl PATCH v2] test/fwctl: Add Feature OOB rejection regression tests
Date: Tue, 21 Jul 2026 14:21:22 +0800
Message-ID: <20260721062122.24138-1-icheng@nvidia.com>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: KUZPR03CA0021.apcprd03.prod.outlook.com
 (2603:1096:d10:24::13) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|IA0PPF7D094C5BF:EE_
X-MS-Office365-Filtering-Correlation-Id: 90e11ce6-2009-4285-c8b1-08dee6f04f35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|23010399003|376014|18002099003|3023799007|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	dfOWKRyXbsCWlixnX64dhj8snh6FlHSRZtPGG0wwqbYHCFkwpkMIl4bTQoR3bapUTsf/Ncj533usgZxd2X6Y2Rr3t78It43TaQUSlxV+m5OIoX1yrtMAvnQuPo6Uzt8gXZnAI9WCAU7lT/rV1GfJ+m3C4dl5M5GeVuBN8d0EmkoQLqOXN3oA6+iLNX4gudruPigWKfhiqIybYPRuFQaW/FmBL1eNFhPJHijGPo2nzdmAzLYWgnjDbt4olFXz5V0tPYm2cv49xvzrEzLAbNUDL9ROIxx8JqmFcJugB9ZZy69ugw8/9+aDtpbGYSfjKfIbWMDQrb402mkKAFqyiIO+m0ZLUExYAdiae83KdbZC0/M24LYUKjO8Y2MkRvGh+Uwh1zi0V//5tfki0HwViFs9gTXRCFKET/450B/GLdW6c5T6mOSLvR2tigczF9pE2NwA0P0GrtvulfOk3BmStiKkCac6QBVlLZ1qPJ8KpcgQzHTDqWUnBkiW0pZYskGKMOjpQek9Er8oCXkhapp0IAknQxeZhhZfGctzfy8Zd0yCFm21NXfFRrDrCsVI6qchzfrDyAHofK7pD9R6c19yB1JkDAcm77rY8VOXChisV5p2ou4IfrgIx454/C27UjikRkdhdMCJ06pwC+zYqoZlVpCcsqxIgnLqsXLkydDd3/9Me/k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(23010399003)(376014)(18002099003)(3023799007)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VjKG54a/txPkEDFXenRn5tKtfGrJ7axlmoPI/LYyslca8Tf7Hl4ct6v+krgm?=
 =?us-ascii?Q?R70xAuZ16mTs1ptVV4sapTUlqR71OjGGnNeEVDHuOZ6sHOWm5yy3n0IhzYti?=
 =?us-ascii?Q?+vxtfkeJLqQHoN9fVYJ65Z1R3U5gsthdPIicz/IzxWH/1QyIzqGUNrsFNAqo?=
 =?us-ascii?Q?HPO6Tk3LeMBSgNhevACj5a2m2CBtXXxD4MnAZfLO9ojbRYc2p/c0NW01PkuU?=
 =?us-ascii?Q?ztoh7XUXbXuV4ZF3cn+UfqJaXPunnIlCZMTIvf8ENelCWDq7wHMxr0CS4Z5x?=
 =?us-ascii?Q?ehKPGS8KEUPiDZVs5tUacMhWvrAHz5Y6h7aZRA1Lrs/F2yWesW+hFLJD7BbV?=
 =?us-ascii?Q?Z8o7E9DtSw+RclS2Zk5CroCwuoimE0/896jK9tdGVreBPtqI5lLJ88aP1rLd?=
 =?us-ascii?Q?s5hdjjacfHj7h9GNDrlz/vbGPpFbt+TOwAesJWkyLNhTjvfs7qO+3sYUWygD?=
 =?us-ascii?Q?h4U+QDQbO5PcrHzKrIrvTL9zyrzntrwS3WaEny3llsAUYr1tnQI+kXVtBCy4?=
 =?us-ascii?Q?sXae7vj8mD/gV0eOTXErZGkabWiiDDuASvVmO0Ii0X5lesM4zQCH53CLhS2Z?=
 =?us-ascii?Q?LNsukz2ENwgsy57oOnRfc2kwWqE0UXB5B6rtmhK4wD9rSFWmC02CNkuB2/+v?=
 =?us-ascii?Q?pUrpdYHl0RQeL85VCW1k/aG570GjzSHOBH+9wrFAxmLZA7tbMxqY0zr0Ff+D?=
 =?us-ascii?Q?Ix3sJGyXeks9assvBIQDQ7/E6Is7NtRG/DROK8x+KEd1qkGpSDyJ3XoRSh0C?=
 =?us-ascii?Q?YCT6zY5Mrfkg6q6ydsMXXTmkcKKotyH73YlTXz8b5oqVK9mel29gZChVm7tQ?=
 =?us-ascii?Q?cDXe8W29KJanZqWj0t6Ou0KFl4ojXiJ9587lvBynKxudkQ3MocDqEIjUlBhG?=
 =?us-ascii?Q?uqp/PTAGndVQFekJMhnxV/8T58uBkjU5q0FQdJ8Ni6QyIKMSpKNW5HHjr8av?=
 =?us-ascii?Q?EoBkHxAYVFIurpI9aPtTAvhXPVx3WclQjstxA5U1MDZDdFuo5WwNOLIg+L5I?=
 =?us-ascii?Q?36BVL4C9WvjpRFAMz9+A+f3GRCZdIdGGWNIrVu0nCFcIRVlBpigEHr7+Onhc?=
 =?us-ascii?Q?3Nm4q69IVfxmH4Bsox9/BG2Pja8aeAWA7keHrGAMEAKH8gs/V7HVojSHfhEg?=
 =?us-ascii?Q?L2HpZifaDTl/dtaxKFckz+yZBCZf25M3qJ50y4HQjca8ecLY4MeJu2CgtDJu?=
 =?us-ascii?Q?Wr1F0k7r2z4apQyFozh3eJ2M6n2lZ8EgUbH6YlN8Tdd8qfMv//7qR+uZZVpI?=
 =?us-ascii?Q?Pin1kyn97u/5mWcO7WRpOTyumubU9xAhL07QHTw9Zkdo9etijnQ5ULOfRELl?=
 =?us-ascii?Q?WdpYcMgLe7oKbZH3lVX/cYAtIznnt7rZW8U47UVG7EtGVKcRG1c3XcTUU51M?=
 =?us-ascii?Q?RrH0zZPyUTLK47z3+VfDivTe9e8NwrvBwfNJIF+4M+cIWXJKns/ju5DVBOmO?=
 =?us-ascii?Q?n9hQxlJ7jd7NzkhLvAXPw1sc89+hsELEfi7Xj6NF/m2nQ5vNZOhDM0SNwvOh?=
 =?us-ascii?Q?Dcfad7EaiaeEMVVSKfMnpI4Z+yXb30Vg3rq51hqJ3ajwHjc2ej78o852eCHe?=
 =?us-ascii?Q?kY2ij1QQ4licYHjdlGjr7c/nbLAP2qsCigLVrFcf9iDxg9R1jciNMagFdFzK?=
 =?us-ascii?Q?FWCCoWr5rvoat1qdYMahgNFziAcGqI0Wq/Zbeh4il8rTAzgN2JYGgQT+q/km?=
 =?us-ascii?Q?KG1kqbDSNzeQjgcEGmVwukLIY25jnMYwK16zzMRlRjzMLj9Z+7mhBDvEnMUC?=
 =?us-ascii?Q?CEt+4kQ49w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90e11ce6-2009-4285-c8b1-08dee6f04f35
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2026 06:21:33.2053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y/z4kBNV2TM0NN8Q58cDFzXxv2onypYAsS4sc+mIxsa2sqrkfcm2ynbV5XKLZJxhD1f7IFQkCbUAoil4mZtm4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF7D094C5BF

Add negative cases for the CXL fwctl Get Feature and Set Feature output
buffer bounds checks.

For Get Feature, request a non-zero payload while providing room only
for the fwctl_rpc_cxl_out header. Verify that the kernel rejects the
request with -EINVAL instead of writing past the rpc_out buffer.

For Set Feature, build a valid request and set out_len to zero. Verify
that the kernel rejects it with -EINVAL. Without the bounds check,
kvzalloc(0) returns ZERO_SIZE_PTR and the output header write can oops
the kernel.

Both cases depend on fixes [1]. Gate the tests on the running kernel
version so older kernels skip the unsafe requests rather than failing
the fwctl test.

[1]: https://lore.kernel.org/all/20260624134737.49166-1-icheng@nvidia.com/
Signed-off-by: Richard Cheng <icheng@nvidia.com>
---
Changelog:

v1->v2:
    - Gate the fix-dependent regression cases on kernel v7.3
    - Add Set Feature out_len == 0 rejection coverage
    - Group both cases behind one local kernel-version check

Best regards,
Richard Cheng.
---
 test/fwctl.c | 144 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 144 insertions(+)

diff --git a/test/fwctl.c b/test/fwctl.c
index 979c1a6..fb0d1da 100644
--- a/test/fwctl.c
+++ b/test/fwctl.c
@@ -5,10 +5,13 @@
 #include <stdio.h>
 #include <endian.h>
 #include <stdint.h>
+#include <stddef.h>
+#include <stdbool.h>
 #include <stdlib.h>
 #include <syslog.h>
 #include <string.h>
 #include <unistd.h>
+#include <sys/utsname.h>
 #include <sys/ioctl.h>
 #include <cxl/libcxl.h>
 #include <linux/uuid.h>
@@ -20,6 +23,35 @@
 
 static const char provider[] = "cxl_test";
 
+/* Running kernel version parsed once in main(). */
+static unsigned int kver_major;
+static unsigned int kver_minor;
+
+/*
+ * kver_ge - Whether the running kernel at least major.minor
+ *
+ * Test cases for fixes tied to a specific kver gate here so that they quietly
+ * skip rather than fail on kernels that predate the fix.
+ */
+static bool kver_ge(unsigned int major, unsigned int minor)
+{
+	if (kver_major != major)
+		return kver_major > major;
+	return kver_minor >= minor;
+}
+
+static void parse_kver(void)
+{
+	struct utsname uts;
+
+	if (uname(&uts) == 0 &&
+	    sscanf(uts.release, "%u.%u", &kver_major, &kver_minor) == 2)
+		return;
+
+	kver_major = 0;
+	kver_minor = 0;
+}
+
 UUID_DEFINE(test_uuid,
 	    0xff, 0xff, 0xff, 0xff,
 	    0xff, 0xff,
@@ -207,6 +239,45 @@ out:
 	return rc;
 }
 
+static int cxl_fwctl_rpc_get_feature_oob(int fd, struct test_feature *feat_ctx)
+{
+	struct cxl_mbox_get_feat_in *feat_in;
+	struct fwctl_rpc_cxl_out *out;
+	size_t out_size, in_size;
+	struct fwctl_rpc_cxl *in;
+	struct fwctl_rpc *rpc;
+	int rc;
+
+	in_size = sizeof(*in) + sizeof(*feat_in);
+	/* header only => zero payload room */
+	out_size = offsetof(struct fwctl_rpc_cxl_out, payload);
+
+	rpc = get_prepped_command(in_size, out_size,
+				  CXL_MBOX_OPCODE_GET_FEATURE);
+	if (!rpc)
+		return -ENXIO;
+
+	in = (struct fwctl_rpc_cxl *)rpc->in;
+	out = (struct fwctl_rpc_cxl_out *)rpc->out;
+
+	feat_in = &in->get_feat_in;
+	uuid_copy(feat_in->uuid, feat_ctx->uuid);
+	/* non-zero count that exceeds the zero payload room */
+	feat_in->count = feat_ctx->get_size;
+
+	rc = send_command(fd, rpc, out);
+	free_rpc(rpc);
+
+	if (rc == -EINVAL)
+		return 0;
+	if (rc == 0) {
+		fprintf(stderr, "Get Feature with undersized out_len was not rejected\n");
+		return -ENXIO;
+	}
+	fprintf(stderr, "Get Feature OOB rejection test: unexpected rc %d\n", rc);
+	return rc;
+}
+
 static int cxl_fwctl_rpc_set_test_feature(int fd, struct test_feature *feat_ctx)
 {
 	struct cxl_mbox_set_feat_in *feat_in;
@@ -249,6 +320,73 @@ out:
 	return rc;
 }
 
+static int cxl_fwctl_rpc_set_feature_oob(int fd, struct test_feature *feat_ctx)
+{
+	struct cxl_mbox_set_feat_in *feat_in;
+	struct fwctl_rpc_cxl_out *out;
+	size_t in_size, out_size;
+	struct fwctl_rpc_cxl *in;
+	struct fwctl_rpc *rpc;
+	uint32_t val;
+	void *data;
+	int rc;
+
+	in_size = sizeof(*in) + sizeof(*feat_in) + sizeof(val);
+	out_size = sizeof(*out) + sizeof(val);
+	rpc = get_prepped_command(in_size, out_size,
+				  CXL_MBOX_OPCODE_SET_FEATURE);
+	if (!rpc)
+		return -ENXIO;
+
+	in = (struct fwctl_rpc_cxl *)rpc->in;
+	out = (struct fwctl_rpc_cxl_out *)rpc->out;
+	feat_in = &in->set_feat_in;
+	uuid_copy(feat_in->uuid, feat_ctx->uuid);
+	data = feat_in->feat_data;
+	val = DEFAULT_TEST_DATA2;
+	*(uint32_t *)data = htole32(val);
+	feat_in->flags = CXL_SET_FEAT_FLAG_FULL_DATA_TRANSFER;
+
+	/* A valid Set Feature request with no room for the output header */
+	rpc->out_len = 0;
+	rc = send_command(fd, rpc, out);
+	free_rpc(rpc);
+
+	if (rc == -EINVAL)
+		return 0;
+	if (rc == 0) {
+		fprintf(stderr,
+			"Set Feature with zero out_len was not rejected\n");
+		return -ENXIO;
+	}
+	fprintf(stderr,
+		"Set Feature OOB rejection test: unexpected rc %d\n", rc);
+	return rc;
+}
+
+static int cxl_fwctl_rpc_feature_oob_tests(int fd,
+					   struct test_feature *feat_ctx)
+{
+	int rc;
+
+	if (!kver_ge(7, 3)) {
+		fprintf(stderr,
+			"skip: Feature OOB rejection tests need kernel >= 7.3\n");
+		return 0;
+	}
+
+	rc = cxl_fwctl_rpc_get_feature_oob(fd, feat_ctx);
+	if (rc) {
+		fprintf(stderr, "Failed Get Feature OOB rejection test: %d\n", rc);
+		return rc;
+	}
+
+	rc = cxl_fwctl_rpc_set_feature_oob(fd, feat_ctx);
+	if (rc)
+		fprintf(stderr, "Failed Set Feature OOB rejection test: %d\n", rc);
+	return rc;
+}
+
 static int cxl_fwctl_rpc_get_supported_features(int fd, struct test_feature *feat_ctx)
 {
 	struct cxl_mbox_get_sup_feats_out *feat_out;
@@ -393,6 +531,10 @@ static int test_fwctl_features(struct cxl_memdev *memdev)
 		goto out;
 	}
 
+	rc = cxl_fwctl_rpc_feature_oob_tests(fd, &feat_ctx);
+	if (rc)
+		goto out;
+
 out:
 	close(fd);
 	return rc;
@@ -417,6 +559,8 @@ int main(int argc, char *argv[])
 	struct cxl_bus *bus;
 	int rc;
 
+	parse_kver();
+
 	rc = cxl_new(&ctx);
 	if (rc < 0)
 		return rc;
-- 
2.43.0

