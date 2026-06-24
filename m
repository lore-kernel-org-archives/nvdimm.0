Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010011.outbound.protection.outlook.com [52.101.85.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BECF3BED75
	for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 15:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782313319; cv=fail; b=GRElv5QUuLyOw4TT3xFlqLqgRtMGRwNc2AyW1MRV9CTk1m0jb8IdQ4TChuHh6Vf9vBokdS+LetEsJmBJ3PyyS1IwVwq4K8/pcgpdJExBY1tVupDM6DuOApKNJ/cg1Q378tPDCBkL+Uy96ne6W75Tzebr7t5TDh4y5yZ/nGr1RsQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782313319; c=relaxed/simple;
	bh=wTgqbhv9eTX2qmPUxqofgiHGmmRF/4egY4AA5KtUvHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=E2S8sblf16SFm8Iy+bE8DW/b0NRFwuPj/jRt3SouXU8LtDsJ+oFjVl1OTl458hkAtpObrl8iJNNu8oAvzurkz3pHDqWNto3uhOuxl+hwakxMC3j8C7DUjGYaSSZ6DcnWF3GWqtxOxXSAgTHUsTPA5z6W0RZXYA8NwDEBO1elze4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RRJr1irb; arc=fail smtp.client-ip=52.101.85.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RRJr1irb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JRu8YcSiU7Zcx2wRM++HOjNQaxYi08S/P4km+twzT86QC+U1w4Hcg1DfN/LWwH3qKsj2rTpelGdQegVlW4h9158wqrbEk+m8/QCT+dpQTayKt7cBZZOgfkeesXciZzQ7Fmg7Kl8fg/kqpcBbIHIfGeW2hjM5McOvDhjRj91xUjhkm5wwWmDmccJcCgxYwLUx3zpesQJYuU5pQ4WXuzJWIRcOhNf4V/ieBkRkPC5cmSL+MX9gbHJvhJRC8qb8g0AE3qUuYXAHVtulEt5Xttun/788KDTcTq3sYorvtoDxjWIg3LzYrtQ2XLkGQkjPOM+X02/BDGhAgkUzz+lM3LUrfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ummRMt62ewOqJH3XVRLpO9ntvRhYJMbubqAOIG83cg=;
 b=Rwv6hhTQke9wfSz2zA3gfqofuPl8gBjqvLrEbLvBGF/m1kFeSAUH18suhVN/TyKGHC/xsEJ0wFcX+pXLevLyuoLSsc4kfU+tRrl6zscLO0zD4l9Bu6y+Pkq9actXjhog0u8TlV9hG59poZfNRibMCm2SmkZMUgYOEdIlfYkxyHvVHxKWUwzEtnq4ruP/l1peot/x/LCiPp+H6h6QA3MDLhF5/wykslRCEnn08yflY6UW6kJ5oixaMOL+tOGtI0EWvg97utRPXC+Wu8wTXUuYxIOfob/bBu12etwS4jZKAMsCX6M2YunslOwvzW2vit6wM2icLBeXpSl5YvLtko+O5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ummRMt62ewOqJH3XVRLpO9ntvRhYJMbubqAOIG83cg=;
 b=RRJr1irbbfEFm9kUlI01v5BCe2RGdcmUvFbcGcGwvpQH9tGX4cl8Y5SWJlTmwZ5+AiNA6HzsCnbg4mvra225iX8aLL08bdWfC248pyG3kjdFmLZFEkoJ7KrVvB4KPYuLjjWve5phbnk1RbFWGuYjLG/W+Oj3FXZ49BF4yA1Ptrl+bZ1Wo3t2wAK6e/bVuz0VlrqXT/c2fsuliVAT5x1N+R4FYSi9CuG1mjVUjKapB/E4bBz0dzCMNlaVKLUqRKsJZC9vgrQVUck1sE4DgqRxZWILWb3kvQfA5mFIoln6zyd+bwYnD7VFhn/CKiikQC6CnsvlQrRAvTPejrUxaqFjpA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW2PR12MB2380.namprd12.prod.outlook.com (2603:10b6:907:4::32)
 by SA1PR12MB5637.namprd12.prod.outlook.com (2603:10b6:806:228::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.13; Wed, 24 Jun
 2026 15:01:53 +0000
Received: from MW2PR12MB2380.namprd12.prod.outlook.com
 ([fe80::90d:c5c:6a5e:94a5]) by MW2PR12MB2380.namprd12.prod.outlook.com
 ([fe80::90d:c5c:6a5e:94a5%6]) with mapi id 15.21.0159.013; Wed, 24 Jun 2026
 15:01:48 +0000
Date: Wed, 24 Jun 2026 23:01:29 +0800
From: Richard Cheng <icheng@nvidia.com>
To: dave@stgolabs.net, jic23@kernel.org, dave.jiang@intel.com, 
	alison.schofield@intel.com, vishal.l.verma@intel.com, djbw@kernel.org, 
	danwilliams@nvidia.com, nvdimm@lists.linux.dev
Cc: iweiny@kernel.org, ming.li@zohomail.com, kobak@nvidia.com, 
	kaihengf@nvidia.com, kees@kernel.org, newtonl@nvidia.com, kristinc@nvidia.com, 
	mochs@nvidia.com, linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] test/cxl-mbox: Regression test for huge
 CXL_MEM_SEND_COMMAND out.size
Message-ID: <ajvxHC9Qg2YWyDkl@MWDK4CY14F>
References: <20260624145843.55116-1-icheng@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624145843.55116-1-icheng@nvidia.com>
X-ClientProxiedBy: SI3PR03CA0004.apcprd03.prod.outlook.com
 (2603:1096:4:297::11) To MW2PR12MB2380.namprd12.prod.outlook.com
 (2603:10b6:907:4::32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW2PR12MB2380:EE_|SA1PR12MB5637:EE_
X-MS-Office365-Filtering-Correlation-Id: 995f22f1-cb32-4333-37e3-08ded2017f79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|7416014|56012099006|3023799007|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	M2o4++HQ2VIqbBnrWorUT7YZDZOdjBaHStfjRLDwE7D0wOVGBARtFHCTvRxukzyRxOYtszL+s0ibXTKASDfTouFvntz3FEye/hG3eoAIz0IDu2+sgwKguxsUM7SBR+UeAfexp6Xm+1GYT788VctCWg75iPzl38rHNTTfzoJSaY5bqtwa8K+O10zsChwFE9TWicS1KfcLHwTOjtMODdf/8DoAEzFCZkdbl4LWfiMZflDdjvJKe5NKHzogcZ50CL9CLpzcmqLVl+w685yPP2XjRuOr0XiYlaI9z++syfkXBxsxKEUmeKdd48DTqAyeJi7eiv9g4d8x94BUe3ggzDySQ7/P6Il3ysszXLEBZw3FYN1dBZvCLqdASA5c9v++ObgJIxwy3xBDyan8Bcb9cC9IuBrGyxZAKXw3yhIufOz+MEMnXQKQNx52cLRnSZfkSeJU/JDu0HrmZ63eg1SYRlqHCJdradjY8usd7skSg5/qXeaHsSIhOPBoX+4cDCmaiS93sRIhqIAkWTdQHojqu0jmcOd2BX+74ptGJq3tdJq1CCNt9JTHqiHaKPrKdOFH8LHaKaHIDHZXINdtVlGT6rlHFUpZhAnpGRCaUhzeeJqzHgB0W9fe+j3m/eGefvK9lut/K9O6L7k2V4sO8DGPWkP9FORUHjlJqEi1ROWwlwly2uw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB2380.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(7416014)(56012099006)(3023799007)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8DiK5eKZ/Af9u7Z4bGwyVZCXKpdeilr5DR64kDEuEf6lHosSonUUzlKB4dy+?=
 =?us-ascii?Q?E6lZMAVf3s9ZcBQYfgwk38GwWV9soR9wvh2/5kjI1u3B5ZrZKdzJKw8bOwiL?=
 =?us-ascii?Q?avPxMTxJBFRIok9v92cqpm2k2YnhjN6EGYMeWVMGxrsfFpyHYiB1m+n9N5XX?=
 =?us-ascii?Q?C3WZPXzmIZp2pObEKdb9eK13GYnCYwRYipB2YtuZhdU9u5iUXrxRVYcM1bs7?=
 =?us-ascii?Q?BsAwvDvBXtAIGn7n97cPlOlL/ERcI0q3HDDCoM5YrjpYn9Q6fQrEMFuf0KdR?=
 =?us-ascii?Q?InRaw11TRNHq8gYmyejCA0yBXkc5RVal2pEgcoesf3aqNeLpSbtaI08TYwNr?=
 =?us-ascii?Q?gAIGoRjjLDlGEg1z9kQnCI58ZIamAB85CtTpw1TJc4NNxROIFkE+LD8XYe9l?=
 =?us-ascii?Q?qCI0nnz9G4VdpTpkARc/KCzrL5Zx36QC5PHwRik1PXWHcEewJqMNY/6W9QQv?=
 =?us-ascii?Q?gP7OAjFr4JmkXa2irZEnUp/uuMXmcgybhgZfP0nEh411jcL6DCwns8adg8Dx?=
 =?us-ascii?Q?/culbW63erep5yj+6nQaq934qtnpKf1CREopR/ey0RMa0R3r73AKa7vwr3VG?=
 =?us-ascii?Q?Q7GBXi9+ACvfNk8a8VJf0aqJosh8NjVnx+PNJXCK9IZiWgoBJbGsYZkT44CU?=
 =?us-ascii?Q?lhpPnQRHQ3sQSBFZgZkWIccM+hSjAa7ALvgsNjOtPLfMpclwUmISl+EfSA1L?=
 =?us-ascii?Q?rexOJHGpDmk26k/MOw4ZZiuN442xem2eMKzUSewzcGhIe5W3He/pzTl7Dmt3?=
 =?us-ascii?Q?RddlTmVoh8bRoCEU5ghbUwavzn9vlLCaz83lpBbJijgQIbL9UK8h21tLCaMy?=
 =?us-ascii?Q?4NG7OrzzqMLC8lYIqhrjoSTV0zHICPfvQZgE/2Ug70kq0tuu699OGRDTwa1c?=
 =?us-ascii?Q?j+hrMRHq1oqaEdZs0tsbvVXJ3VmWxp0H2ZTnPXusTq8bgnXKs9JTIZ3mZUO4?=
 =?us-ascii?Q?Dj2IRNNByybLaHJ2AvoMlfiMFNx4YBL6I+Q15/VfUlooUHAD6Bkg6S+NN6yp?=
 =?us-ascii?Q?HMwtcOmhKvXeM3J3XKBONfOQzyrwL550Jd21rZq77F1z1YMzJ46YOoaiQmRU?=
 =?us-ascii?Q?X78Kbfce+/HkUg15gNVLdWctK7d1oIZpSWQLktNyQXaW2rALfiansEGwxcIi?=
 =?us-ascii?Q?Rb+CDwB1jn/H0PebuY/YdyYTE0oke16UvDhteMzDFYh6zAbTRJP4UQpf72nr?=
 =?us-ascii?Q?BnfKTlehzBMiX5FkRzvld37uSqfvxrxvrQpb7TyQFENKFhDXfBaIunnxEoXa?=
 =?us-ascii?Q?mDFpf6/Ri7r79CD82KD/qElOKyunLzW+Hc3oLnIthIzVBloTR0kL16HC4sFC?=
 =?us-ascii?Q?fwIbGYAfUcZtTNY3Yxd/wK6UZmUpPhturY4lFV1diM951uftrCaEWs34K4jZ?=
 =?us-ascii?Q?fVgsBpX8KHFpHDpSs2MNK8ghGwaYT9f5CaGPCP6hfFKsLLvEumBas87j9Bmv?=
 =?us-ascii?Q?5H7MnaIZ1oWX6lemXK3Qhw3SXzKhzPqBokGcndDvw8npnxzRHQpIHMTQCjA/?=
 =?us-ascii?Q?PQyFBhMti/0X4aJ1Y44UqPwnLGIhTbsFPSRqYA1+hPpBMg5Q95WOTfCM4oIH?=
 =?us-ascii?Q?T/p+1agpRsLv8Gpiqe9Y30oqNt633i/7H30AzGak78/lCbDaEssdQZqppf9M?=
 =?us-ascii?Q?uRAoOSpQeUG8TkvUxkmFgCZjemYRQNKJzLaVPoPaMwwP7wPTsWcu8p2BKqC8?=
 =?us-ascii?Q?Y6+1Gyp08MnNjzOf1+Q3vjTYR4RWtsfVi3xSjWlzgqDMuFdkrBUSn4x3SYWt?=
 =?us-ascii?Q?YD/kXpUX1g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 995f22f1-cb32-4333-37e3-08ded2017f79
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB2380.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2026 15:01:47.1093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DriSS4TPizYTl5xU4IcZAkvDaWlOnzuG1oawCSUwQPZn+pma47kTCSNfAEVCWsaZ8EjQU4EcDSFvAnDgUXYTOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5637

On Wed, Jun 24, 2026 at 10:58:43PM +0800, Richard Cheng wrote:
> Implement a regression test for unbounded kvzalloc() in the kernel's
> cxl_mbox_cmd_ctor(), which a CXL_MEM_SEND_COMMAND with an out.size
> greater than INT_MAX could drive into a size > INT_MAX kvmalloc() WARN.
> 
> libcxl's cxl_cmd_set_output_payload() rejects an out.size larger than
> the mailbox payload_max, so the test crafts a raw struct
> cxl_send_command and issues the CXL_MEM_SEND_COMMAND ioctl directly
> against the cxl_test mock memdev.
> 
> The test is for a kernel bug fix [1].
> 
> [1]: https://lore.kernel.org/all/20260624144147.53997-1-icheng@nvidia.com/
> Signed-off-by: Richard Cheng <icheng@nvidia.com>

Sorry, forgot to add the ndctl prefix, please ignore this one.
I'll resend it.

Best regards,
Richard Cheng.

> ---
>  test/cxl-mbox.c  | 129 +++++++++++++++++++++++++++++++++++++++++++++++
>  test/cxl-mbox.sh |  48 ++++++++++++++++++
>  2 files changed, 177 insertions(+)
>  create mode 100644 test/cxl-mbox.c
>  create mode 100755 test/cxl-mbox.sh
> 
> diff --git a/test/cxl-mbox.c b/test/cxl-mbox.c
> new file mode 100644
> index 0000000..d81327b
> --- /dev/null
> +++ b/test/cxl-mbox.c
> @@ -0,0 +1,129 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2026 Nvidia Corporation. All rights reserved.
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <stdint.h>
> +#include <stddef.h>
> +#include <stdlib.h>
> +#include <syslog.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <sys/ioctl.h>
> +#include <cxl/libcxl.h>
> +#include <cxl/cxl_mem.h>
> +
> +static const char provider[] = "cxl_test";
> +
> +/*
> + * The cxl_test mock advertises a 4 KiB (SZ_4K) mailbox payload_size and
> + * IDENTIFY returns a full struct cxl_mbox_identify. Post-fix the kernel
> + * clamps the output allocation to payload_size and copies that many bytes
> + * back into out.payload, so the buffer must be >= payload_size. 64 KiB is
> + * comfortably above the mock's 4 KiB payload.
> + */
> +#define OUT_BUF_SIZE	(64 * 1024)
> +
> +/*
> + * Regression for the unbounded kvzalloc() in cxl_mbox_cmd_ctor() driven by a
> + * huge CXL_MEM_SEND_COMMAND out.size. The kernel fix CLAMPS the output
> + * allocation to the mailbox payload_size; it does not reject the request.
> + * Assert the ioctl SUCCEEDS (no -ENOMEM) -- do NOT assert -EINVAL.
> + */
> +static int test_cxl_mbox_huge_out_size(struct cxl_memdev *memdev)
> +{
> +	struct cxl_send_command c = { 0 };
> +	const char *devname;
> +	char path[256];
> +	void *buf;
> +	int fd, rc;
> +
> +	devname = cxl_memdev_get_devname(memdev);
> +	if (!devname)
> +		return -ENODEV;
> +
> +	snprintf(path, sizeof(path), "/dev/cxl/%s", devname);
> +
> +	fd = open(path, O_RDWR);
> +	if (fd < 0) {
> +		if (errno == ENOENT || errno == ENODEV)
> +			return -ENODEV;
> +		fprintf(stderr, "failed to open %s: %s\n", path,
> +			strerror(errno));
> +		return -errno;
> +	}
> +
> +	buf = calloc(1, OUT_BUF_SIZE);
> +	if (!buf) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +
> +	c.id = CXL_MEM_COMMAND_ID_IDENTIFY;
> +	/*
> +	 * 0x80000000 (2^31, > INT_MAX) is the proven reproducer that trips the
> +	 * size > INT_MAX kvmalloc() WARN. out.size is __s32 in this vendored
> +	 * UAPI; cast to avoid -Woverflow, the kernel reads the same 4 bytes
> +	 * (kernel UAPI declares it __u32).
> +	 */
> +	c.out.size = (typeof(c.out.size))0x80000000U;
> +	c.out.payload = (__u64)(uintptr_t)buf;
> +
> +	rc = ioctl(fd, CXL_MEM_SEND_COMMAND, &c);
> +
> +	/* Pass iff the kernel clamped (success), not rejected. */
> +	if (rc == 0 && c.retval == 0) {
> +		rc = 0;
> +		goto out;
> +	}
> +
> +	fprintf(stderr,
> +		"CXL_MEM_SEND_COMMAND huge out.size mishandled: rc=%d errno=%d retval=%u\n",
> +		rc, errno, c.retval);
> +	rc = -ENXIO;
> +
> +out:
> +	free(buf);
> +	close(fd);
> +	return rc;
> +}
> +
> +static int test_cxl_mbox(struct cxl_ctx *ctx, struct cxl_bus *bus)
> +{
> +	struct cxl_memdev *memdev;
> +
> +	cxl_memdev_foreach(ctx, memdev) {
> +		if (cxl_memdev_get_bus(memdev) != bus)
> +			continue;
> +		return test_cxl_mbox_huge_out_size(memdev);
> +	}
> +
> +	return -ENODEV;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	struct cxl_ctx *ctx;
> +	struct cxl_bus *bus;
> +	int rc;
> +
> +	rc = cxl_new(&ctx);
> +	if (rc < 0)
> +		return rc;
> +
> +	cxl_set_log_priority(ctx, LOG_DEBUG);
> +
> +	bus = cxl_bus_get_by_provider(ctx, provider);
> +	if (!bus) {
> +		fprintf(stderr, "%s: unable to find bus (%s)\n",
> +			argv[0], provider);
> +		rc = -ENODEV;
> +		goto out;
> +	}
> +
> +	rc = test_cxl_mbox(ctx, bus);
> +
> +out:
> +	cxl_unref(ctx);
> +	return rc;
> +}
> diff --git a/test/cxl-mbox.sh b/test/cxl-mbox.sh
> new file mode 100755
> index 0000000..67fecf5
> --- /dev/null
> +++ b/test/cxl-mbox.sh
> @@ -0,0 +1,48 @@
> +#!/bin/bash -Ex
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2026 Nvidia Corporation. All rights reserved.
> +
> +. $(dirname "$0")/common
> +
> +BIN="$TEST_PATH"/cxl-mbox
> +rc=77
> +# 237 is -ENODEV
> +ERR_NODEV=237
> +# TAINT_WARN is bit 9
> +TAINT_WARN=512
> +
> +trap 'err $LINENO' ERR
> +
> +modprobe -r cxl_test 2>/dev/null
> +modprobe cxl_test
> +# cxl_test alone does not autoload the mock memdev module on this box
> +modprobe cxl_mock_mem
> +
> +main()
> +{
> +	test -x "$BIN" || do_skip "no CXL mailbox test"
> +
> +	t0=$(cat /proc/sys/kernel/tainted)
> +
> +	rc=0
> +	"$BIN" || rc=$?
> +
> +	t1=$(cat /proc/sys/kernel/tainted)
> +
> +	echo "status: $rc"
> +	if [ "$rc" -eq "$ERR_NODEV" ]; then
> +		do_skip "no cxl_test memdev"
> +	elif [ "$rc" -ne 0 ]; then
> +		echo "fail: $LINENO" && exit 1
> +	fi
> +
> +	if (( (t1 & TAINT_WARN) && !(t0 & TAINT_WARN) )); then
> +		echo "fail: $LINENO kernel WARN taint (bit 9) set" && exit 1
> +	fi
> +
> +	_cxl_cleanup
> +}
> +
> +{
> +	main "$@"; exit "$?"
> +}
> 
> base-commit: 8ad90e54f0ff4f7291e7f21d44d769d10f24e2b6
> -- 
> 2.43.0
> 
