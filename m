Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010003.outbound.protection.outlook.com [40.93.198.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6D926F29B
	for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 14:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782309626; cv=fail; b=a+v39KoTi2FAjl8xT3bXCEmrgEtGE7zwKRGDHNuBQiIXSJTjbeUhm4/8zFPLmqHJn/qEQapF6/W1c0hbiO6FsVh+cFx9+Q5OeyDSHmS5uBJ7TYY23JldFgAOR713c9NiJGoaQ41A42R/Ak4ioaNjfRwKA+isjE1QChPDcVhRI4c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782309626; c=relaxed/simple;
	bh=2nedhkD36ltOo2RtOADSWljo3UERee7d6Xe+JTFIKlU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=nqCVC6jeYs/IzspGltJiiDFyk15Jp492JXuiYatEcTCC32UlFT4CLxUVOnhcamQZp9tJmS+YhmqU7Kk5qSl+5EdrhPPZf3sbcmzGIludLUZzbVnLLtcjAwUTOdZE0zlg7FiHdAR2L46RbC7XF1336wJHfRkyO2E4R6ASJT2v2ok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Zc9EufqJ; arc=fail smtp.client-ip=40.93.198.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Zc9EufqJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DdCNVaI/sGQq8kmSwLIpyVQzfZgBV95fYsgVsC8UrDdDdBqDuF/avBwQdspFTT15ZBcNUP20/6zQ3I3+tN+TZmaWAepfDjJVpPJBTz5zKP6Okq180W7G8+oj0NHbmYQ/K7A/JcYFExEAXg/TNXeAuXMSeqEe4PW5UQ6Cb5FMKAeqeuSmNi9HsWK1siaLfCUtLsvI8OmeU5IlGxSUqr2XmSG9NU4ewSeU2u0tVqKpQyqCj6W0MqAvBlzpLC6WsfgKfF8iTkdCCL9lwr83YPelo9h2GkLTwMd0YJ1JqBl/4FbyrMKA1S0LyTw/iSbCCMri/0NRXJlCSzE57oHcnbewJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0FrJT+r+6CaZLaJKafdsRfcm+YA3M3XxcAu2LI3UxZE=;
 b=x/Tq080u8ASXhXFaTSaAJ2X1sHRenJk+03E4wBg7m0JTAuXFbImVlAsrWdgeCDYR046hSgoIkUwHEX2+Ok1k2wv2cffkJrCk/K+V+zyS3w8h9WECTnQtwgBI0EtFlk25frXLVXBRWq3As1ajMBd+TL0IKkA7aI1UypxM6iultUdBP9nmvLPhLiLxumxPvpdSaYG5pEiBtgumBKn/8sU1UUaxor6n4k56tfjMuuQo+sjdpVZCIbTBmdR8d1CyXXbvPf4BiwQMJ85gupXMlf0jnG53Ibj8aQLLGZVKzwyzuDZyX5WVCeb9tcAxttTgP+nGCm1B1JxX/H20Q4UDrhRu9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0FrJT+r+6CaZLaJKafdsRfcm+YA3M3XxcAu2LI3UxZE=;
 b=Zc9EufqJJicSFccLI6L1xJpxVFohjhhFyoEtq+FqgpBBCGSMLPcZ2YTPVetnRI4DjKWIS62jVwiRS3rQOEofsF592Mf8AR6AaItNK0c6Fo5L8LvQgkhKGPBuL9DlYSADbVCtriHXIfPnbH/PRNu6uz8d6pczNUZxn/G83HOJoVYBLsnEN7Pvl1NPfAUaWCFyi0XKqht48/aEloboUJrTuq7RU3Hny524ejBJj0YZzfu6kSRiMr+JqGXUHFrioq4hoHPe7q7h42lSMJikdGrOM07GkPnKB+rtXYYUkdQicTwrUa2LMGjP7HGagFK6jX48jK8tMghsflkL8yREhGwDiQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW2PR12MB2380.namprd12.prod.outlook.com (2603:10b6:907:4::32)
 by MW4PR12MB5667.namprd12.prod.outlook.com (2603:10b6:303:18a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.15; Wed, 24 Jun
 2026 14:00:17 +0000
Received: from MW2PR12MB2380.namprd12.prod.outlook.com
 ([fe80::90d:c5c:6a5e:94a5]) by MW2PR12MB2380.namprd12.prod.outlook.com
 ([fe80::90d:c5c:6a5e:94a5%6]) with mapi id 15.21.0159.013; Wed, 24 Jun 2026
 14:00:16 +0000
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
Subject: [ndctl PATCH] test/fwctl: Add Get Feature OOB rejection regression test
Date: Wed, 24 Jun 2026 22:00:06 +0800
Message-ID: <20260624140006.50773-1-icheng@nvidia.com>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI3PR03CA0013.apcprd03.prod.outlook.com
 (2603:1096:4:297::19) To MW2PR12MB2380.namprd12.prod.outlook.com
 (2603:10b6:907:4::32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW2PR12MB2380:EE_|MW4PR12MB5667:EE_
X-MS-Office365-Filtering-Correlation-Id: 756d9066-7b2a-4313-a9fa-08ded1f8ea22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|56012099006|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	Rtj6KV6E2lPAqhkOH4TnIK2Y4u7Sdbb8cLT+V/T/xvxMfQnvtzsEHE8cBuZnE2NtD2fkGIVPxCUKcBlFXEAfcTn03ijeSZ5AKAB08I6DHDaMz9k0q7o3maXpvpj1JBnvlJJMZmjN0LAbn71W+P/z93OZ3Hnnay6t5Uh0Spk7ajIl1E38UG8JtNiG9gw1zJJJfEc3Mj5/WPAc1tc+LoYCEoLDMcfNkTnsPodTiELH8SFTXbrkBSgsYcysQ8jDseB93/WwNq8Y2O8SKoGZxYtfLqf2XpKiO+XQ2c+TWPcWmzY6NXILFGh7XQIjTA0sWwC25F3vvFD8tJVAnAZT/Ld7CpUoEej3aop2t1gYbwSpjMIUrSI53OBxOtpl0inKumDw+EE9p+rdyL3dk49mYdTLkMHzTk+QIyLQk3gsTlS9G5I1OzUjW2VCQGwf/i0nGJ/VOvYD1PuCXzDVig8hp88LmVaFo09c3wxR2zAM5DwfhDhvfrmQnNQkleMTMTn/L98BHhtyLWpvqgKIp8fOxhQeFNXqcgjDxNmwrW1jVaW5WzVYnupGkooh6HT9CpoCB1eQ+dZNdzJGj8mwEbRr/jcKFNhFrG3YA17PWVCYfbRTJcrHjYlLtH6aNPxgjYNXI1CKirP4OYFyd3S+CtHS81wZtSTV6bulmDqXJhdWTdQQPnA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB2380.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(56012099006)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?30rOpAFtYL4FvTfqjrxC2uZtArj7aPCabqCvC7j58JUhUEgONL2JNhA0g6PM?=
 =?us-ascii?Q?gemoL/5FlEZwnuF91+KXeC9OrQqncJggyaqALCO3Rj0i9RiWEmrtaG+ntZa3?=
 =?us-ascii?Q?YulSdHIokpVpCUTVWCihV2rgQqDvKJGcCdE3x1YNSmtMA4mUUwWe5M2NiTG4?=
 =?us-ascii?Q?t9MV345UTck3fdndt/lR//QzQyKSI/LNbf3LyrNcvl0vzh0bXCR+EmBVAG6x?=
 =?us-ascii?Q?6d/2H1X+GRwqNIfC3hno9Hzi29vYOM3yuJve3X2GgmGH003OkqGDU+/lE4kg?=
 =?us-ascii?Q?ii0ycIVoAW102SpjWZ/o2ED+4JldhVBSfG7OnOf4iBaLro3jZxPn7Qb7cK/f?=
 =?us-ascii?Q?0OzBLNnYsUJirH7ODpAGAOAqyBuG0cmrU98P1O8H0XsCGqcmefHzer9GWyN/?=
 =?us-ascii?Q?C29Ei+dstmwWOPY+63pUpsj+zcZ8d5VRIOoI/ELjQAE602lwGCt6LZCs/3TM?=
 =?us-ascii?Q?N0eAwJu1PrKnYX+/JP/QABAf7vi41fTvy3CJRUERmHwRGcVg8wE7wXrgxEB2?=
 =?us-ascii?Q?JtZs9jZS1fFrZEuV/uQHfqJ5Nnf4w+3Buj7mpoOsFdGBMr7J8iajnDDPmwLA?=
 =?us-ascii?Q?I+jxByZEPfwugLUjP6BtAkj3eGh4/3X4XHPathzCbMKJJwj+xY6fQgY5oOkG?=
 =?us-ascii?Q?K9xam987+67OgJSxDk08Z9JaDSjwVuVlKRMtwzjzhKl85uZEgXS1GNCX74O6?=
 =?us-ascii?Q?4XTUOhVH479koUGzqfrroFD0iWMb1a041YQHmLBAy98JR5IzMPJDn3OLbzCs?=
 =?us-ascii?Q?QHQqBWbAq2GIJcdALWyfmc+IXvX4Oomc2urt9pQnPJWP31eoDa/FWixbsI9C?=
 =?us-ascii?Q?H2hcmbj2uYEIqaLQ0wZwrl6nbnT0sDWz4AqkGFPcCE5M/TeaIE05slC2FhjQ?=
 =?us-ascii?Q?X7b04uT8USGPBUg8gkoWU+6pZx2eficvpbDLPVHwzW/CyzPvVn6RZjfn0tSK?=
 =?us-ascii?Q?gtyQXZyj0tdqRfSMvp+sKf/KKAF2O80D93g9Qz3r5HE0F2OUAjlAddqb55RL?=
 =?us-ascii?Q?lAkeEmywUjOMcxqsQu/d7m4Xt+oaXMzwTdC0uUMfN9M/w6rpcEkIp5MeGGeZ?=
 =?us-ascii?Q?hc1HdnO+l4057UWKirU92PvDr3sy+Mq9gXDs8CYcIjwKT5qStwi6CGqMXdHe?=
 =?us-ascii?Q?pR0L69PaKXUFjb5c+IQx3uI7wg26sOcJcqSxwlcRNvk1aZsfZ+Fth6qA1Get?=
 =?us-ascii?Q?PLVNXIlIhHj0NGEVFr5iA5ueraj8BIPXV/bEcQdkeXeP5hiikhDzLdHTojHY?=
 =?us-ascii?Q?Oq/ubSjDVHwj5ocYfLc66wbJDsc1WmxzAXL2oIpoR+nsyGJM9i8PBbA8WUJy?=
 =?us-ascii?Q?YpK8cTse9SvlyvhYzf/jfeiGuKYAiAh/FFhP2fxXolmDF4OQvQ+y1t2Dhybx?=
 =?us-ascii?Q?vwE1sW1e29gV9jL/d9Z1auutSvcyAC/7zd9dNVyYbf+/JSs3Wo9mIFemVyau?=
 =?us-ascii?Q?2avTZpH4G6348vXqo4VfgAMebYekE47hPC8A9DRYotuWLj2mD5kHd4EdDjmB?=
 =?us-ascii?Q?mfxf7O8h5KBdR52Wo1SmLYmdN9ln2AJNsGAXuTxz8L+1GPcBjj09WQBPZunU?=
 =?us-ascii?Q?99XllOM3wR0WayFbp3EQS4JdlrnJCWJdibK2RiBufhWGtU56ooCVxOtwuvYj?=
 =?us-ascii?Q?P/xGqb2RRnfFg5maWLritnjx0g/0BLECS59EVLQ5LXxf2JDn8weOSiPUjEjE?=
 =?us-ascii?Q?1oj/eBOuIxohv3hQq+2XrEzExKLU2yi8bzhhnvE3nlxMNuoRGQi4Pm1sGKK/?=
 =?us-ascii?Q?BwHszuMK0g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 756d9066-7b2a-4313-a9fa-08ded1f8ea22
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB2380.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2026 14:00:16.0707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F80EK8aH250EPqtGPWHUcgsfyk0wWodeheCVMtxcM/BR7HfXbLW/VxNVtIstbiyVIzEgGGbtlZzFz3ee5fs49Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5667

Add a negative case to the CXL fwctl test that issues a Get Feature
FWCTL_RPC with out_len == offset(struct fwctl_rpc_cxl_out, payload) and
a non-zero count. The kernel must reject this with -EINVAL instead of
writing the feature payload past the rpc_out buffer.

This is the userspace regression test for corresponding kernel fix [1].

[1]: https://lore.kernel.org/all/20260624134737.49166-1-icheng@nvidia.com/
Signed-off-by: Richard Cheng <icheng@nvidia.com>
---
 test/fwctl.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/test/fwctl.c b/test/fwctl.c
index 979c1a6..69d0048 100644
--- a/test/fwctl.c
+++ b/test/fwctl.c
@@ -5,6 +5,7 @@
 #include <stdio.h>
 #include <endian.h>
 #include <stdint.h>
+#include <stddef.h>
 #include <stdlib.h>
 #include <syslog.h>
 #include <string.h>
@@ -207,6 +208,45 @@ out:
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
@@ -393,6 +433,12 @@ static int test_fwctl_features(struct cxl_memdev *memdev)
 		goto out;
 	}
 
+	rc = cxl_fwctl_rpc_get_feature_oob(fd, &feat_ctx);
+	if (rc) {
+		fprintf(stderr, "Failed Get Feature OOB rejection test: %d\n", rc);
+		goto out;
+	}
+
 out:
 	close(fd);
 	return rc;

base-commit: 8ad90e54f0ff4f7291e7f21d44d769d10f24e2b6
-- 
2.43.0

