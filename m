Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010004.outbound.protection.outlook.com [40.93.198.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C9A3C4562
	for <nvdimm@lists.linux.dev>; Mon,  3 Aug 2026 14:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785767623; cv=fail; b=oYT23/C0pCFM2hy59N39F/xIEWfIx4upoUeLXKqGRLCMCw+UkhGIJaZsmRLWQrH1bItt09YVOEyUS1KEbrlV7juAjSOL/qBLRUT2b3A0se0SFVGGxaHuxNR8sA/kzAlj/g2FfmLmzbdIEapZjX/KeasoAxmRsxZQPV6UVzFbg7k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785767623; c=relaxed/simple;
	bh=cbYBdgswQjVgCFnhIgwPO2Ddf5on9FQlBUMM8TSyef4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=N6ElmpYjQo7N/2mA2dXlPF6g1P19QQQFcJvcy4hSTsGpi/4Eqqsp3CHj2FYNaRUK6Iyr/45jlKPaqkfQWWh2KocYtZxhOeYvZ4HyX5vsr+aZT2QTy77DA9PL9LHzY+0YxHnDX+0aQNohLsA+GOBBmeFg4f+hfsBIT73syJRio7E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BIs6XOVR; arc=fail smtp.client-ip=40.93.198.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BIs6XOVR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pYMfSKx96CiL4ctXVamIm8oX54aO4kIwHYkOzppW538Un8RAfqdWp0idzHyl1u2qQsABDtU9moKBEb+svaHQqBUVzX0FhSB91ZD0XNnkf3Xqu0ljYDr0ZqvbKSGwurz/498gtr6oh1twEMYCElW+DFmomtgcSOU/nE9IxGld+Fw6D8MYKJpQrAbTq6L0KuPF+lpHhV4pNDV0MWk5Iz+vBhXnqZlwZbq728odcnmOFFazrsrUtwdPzkA0+StjLVmbMeCj0ZNKXjPctYi4uf60l0upklL0CCISSiRA/fHAP8T+Dvqe268Feny3tDF1pY39RPHvZ07nfSStmClMVVX1kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0PyWcGt6W47tHLroAvc9ebdOmDf4jINESfjQhmO2E6Y=;
 b=ZtHaxwfimNin9pLDEJcJ+EjyCkdIlcnL8hdcu+hWBDpgPHSdk/SsV9Rtuvm/uWg2xvKrDs7FzcobPPkcZPe4KQX6cFXqMcVt5CdDJBG5HFiBj4Q5wWC5iOfgkWtR8dXwdofIdpubbfZsIWSfM2c/Fwz21jHg2OCH65JHHkru/6uvNXn/KyXDA7WRyFgxVDqqZSazoigSnxYrMR88rnsrAtgfxY07o3tddb1lv7SSWgv1V2/54KnGLg9rKrS3ZUU2NaJgTQCBrscnIy7RVMXgZrq94FgryxKgWkBrGqNHKVAbJhTob7/JuiBdCev7ck+d3TItKCa0529gCpt+gQ0Nog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0PyWcGt6W47tHLroAvc9ebdOmDf4jINESfjQhmO2E6Y=;
 b=BIs6XOVRPBuet/3wu42X1/2+eLtZBUfMFG3DXE7QCSyZACYSEEQ7zmuW89x/yqU2chJZknYS6j6y15d/M8qUUf5lg8+fs+U36rZBLR2NoELJ6Hs00skxJM3bdLiOe3wXHICFt4lbd2jTocM3URcC81K46kcMM8Vyn0VWLSqCwx8hbBH16pTj2gcRYSSSXJcHnECXge77PU/MwERTENmy8brqt1bBXtVWP3bKwKYQaLRHwyzMRqfyzcakRewYUwfV6v5UuVC/tYZ1W71PfS+ggSwrNTIw3mS7Bz3E2t4XZWXKmQzNMle1p4vQgs5uNUvkMphSsF5WreeOdcLLZMFcqA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by CY5PR12MB6130.namprd12.prod.outlook.com (2603:10b6:930:26::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Mon, 3 Aug
 2026 14:33:35 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0270.017; Mon, 3 Aug 2026
 14:33:35 +0000
Date: Mon, 3 Aug 2026 22:33:27 +0800
From: Richard Cheng <icheng@nvidia.com>
To: Anisa Su <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, Jonathan Cameron <jic23@kernel.org>, 
	Fan Ni <nifan.cxl@gmail.com>, Li Ming <ming.li@zohomail.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, 
	Ira Weiny <iweiny@kernel.org>, Benjamin Cheatham <benjamin.cheatham@amd.com>, 
	Wonjae Lee <wj28.lee@samsung.com>, Junhee Park <jh9934.park@samsung.com>, 
	Heesoo Kim <habil.kim@samsung.com>, Anisa Su <anisa.su@samsung.com>
Subject: Re: [PATCH v12 2/8] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <anBkfosW9jKyOIr1@MWDK4CY14F>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
 <20260731084901.1512819-3-anisa.su@samsung.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731084901.1512819-3-anisa.su@samsung.com>
X-ClientProxiedBy: SI1PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::16) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|CY5PR12MB6130:EE_
X-MS-Office365-Filtering-Correlation-Id: a56e5acc-8300-47a0-81f6-08def16c32fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|4143699003|56012099006|10067099003|11063799006|6133799003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	9zasMeg/46i61A1+BBxe1f2ZvrhLOGdWoCNs3On72EapC8/MfQmjhElHkVUvlVF19wrXpNhMU1XlMh6ICGthOtkd0tJoaO/Oov5So2z3my3CLPfuTcB6TQaq6UdJVgqqwzS+h7WO0l1ROsEZr/YxFE3edhe7eHSA2Cb6FgvBxUPOzOqHKG0wChrvJf/yLjgoNq7YjrjEocCdtcIwBjtHObydJmCX2RmT8Fk5DCGuQMAb/WFMks4SzA8IWj8dm0OiVGpcTiFIXiY/X3TVxQqV7fDYnw8+dtocw8dpoXEjDaKL6AZdsrJLT0VkKBavbj5adK2JWZJ2XLw9Rcr26ySI7lDgoE9yqlq9h6+yVwvRMKXuwu5DjeZU43ZSWQL6v5NnTiDihyx1ykyalo6FB0mS/500TkfkJgL0co69Usvq+m/t+slaOHKJ+Ha8VbjFNX3bjaSmT7V8KucdgDeHDivHL528I82sH+sPLq5IXepfzAF/RlHhgFujfQJ9f37FFX9+XHAUsFgjilPygHzlorwS4ezZoAltQyyYsOyo7jjjJYUvCht628dpngNErJi3N2n6t+FMoiUgDTyhxcyankaPKk7swaghv5Tp7P6rjJhd3mc9+e1E3pzftnuM/Ze3P8rYzzQEPf2RaIV9hjT223z36uV6NS3bx6mWVgc318Y4cYo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(4143699003)(56012099006)(10067099003)(11063799006)(6133799003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C/H04mM594gaCRnGlv1hW5a0ebholKd7vt1dpLLx9OAsKUuK+aSEkhXiHv8d?=
 =?us-ascii?Q?g0iMpWN2H8Xhpsz7gsp2HxB5Fo/tR8fIVF8kGSrbRcG2sQQEfm8OaNFw8xSx?=
 =?us-ascii?Q?KqgW0kKWSigf34HyuhzOKcNfpiyAo6fzuO77+HpV5/M9ihpH7/NwQBBc35rw?=
 =?us-ascii?Q?7h19lTkGENDkCacPxx8fw5WJDqM1V6zFhFhyuCJ6vrlKvk9ftErodjFnzmFp?=
 =?us-ascii?Q?kOD4TAjyAhvQqI7b+OE1n05aksgDck/Sd198cH5jIht2Pij3lqLiJ5oBAKP+?=
 =?us-ascii?Q?lTl956ZbJ7GAAPYSCt6+RW4BI1tmJjY98RESVn6NLdTHdtyff9wpRt9F74G/?=
 =?us-ascii?Q?Pk9pexC3f40OCqQD9zvvA+/cO6EHST8cACF5zeH86g6bQtL+5FHUr4FIDL7K?=
 =?us-ascii?Q?Lcubqeltgg1kOQeoqJNTQQLbwors+QoVaCEhB3OTJqqLFNyKgx0KdCKl0QFG?=
 =?us-ascii?Q?0MMCbEUYY8J1bOMc7kqkYPUOe13+6fce0dYiLPbZqJen5YrTzoPpIHoh0+LK?=
 =?us-ascii?Q?DEGXIN+QAtqwJ0JYTpKmoeH9EVRBrlTI0W+MnOi2+7FG5/HsKahcYQrtKAXp?=
 =?us-ascii?Q?bxfakmTpz16RRyM8Ww0Am7rNEeam66E8V4gyQRDrM0pqOESN5dIYNbwvYpPT?=
 =?us-ascii?Q?VjFjCyGBTnyUuGKmOLl8V9u8tAPCeUODYC2+tjYeWiW7/V6PC226QvslCVQ8?=
 =?us-ascii?Q?+r+OnIFO2RDsEn15hM3QEjXCkFkfNjm8jF8UzQMbq8S+2p7E/y4RkXzwMzwV?=
 =?us-ascii?Q?Uyvfz9/DTIcHOwe8zJo4yNzJmfCSyu+8TVr6PVwgO+QfQ5Drr7ZpM+8v7r+E?=
 =?us-ascii?Q?UgVywmw+2zvG59jcgci1jRR6c1LA55JdwDrxNDK440KeEmK9opT6rBvpb0C/?=
 =?us-ascii?Q?YCsezWTxosLnc6e5+dh677+mqRpp17eF9hb6/k5Gn3u/BzhqgoCOsQDies3b?=
 =?us-ascii?Q?TD1Z/2UO9R5X8VfWfYz9ucs1qoG5lxcvSCeZpOQDKvHh0jMqLbSfiUxJmeFh?=
 =?us-ascii?Q?wWrvrcRkEp1JROF2WLl7eY+L2KhMbwEvAHWJ9AgotukQ5rRryEFzLHcT92jw?=
 =?us-ascii?Q?6trQulf4FcAwFX7XFj1wSy0y+vMnlRidIPPmenWv7g2Kdc/nsjjGnadjN35B?=
 =?us-ascii?Q?Vj0YTwOjJQBbbh+z1/DhjTKpFJ2YB6l1BwXXQT+pMkfr9dRK2MN6JnNECRGQ?=
 =?us-ascii?Q?CgD6xIJMoxip/5GM8NTFw/BMC7kGW8DzsD/p+MGsR2R6Y56fy3EY+tq9uyDL?=
 =?us-ascii?Q?pNWYtw/M3RA22T8dL83XZQiX1BhOCa8T5nCibakhoCoJGt9dhNP5yObzGiMs?=
 =?us-ascii?Q?SEJV4awjcqieqUhB8Iy5PuIMCcOV3pK7Y98GaKmm9nEjMZ2YVqrVHuQF/aa5?=
 =?us-ascii?Q?1N0xesStADBQhZcvL6wKisZoUOk0hbvpcjxbAUVNniHzWirxgs0aXrx2KQgT?=
 =?us-ascii?Q?UHeFHpUQeZXkOp5xlLmrl9CeMhKzgWpewF3rM+AMFUXaQE++ZUEy5m9ar5SL?=
 =?us-ascii?Q?zZ+xwZsTEgR0pJ/UQ+0XJ/tK3YQirKIxPjSSrD0tCDVfm3BUf9H+ngSMbkY7?=
 =?us-ascii?Q?E2kbSwfiXjXLGveAhmKP77HI2TMUtF2TijXfwkhfkh0WDpGX0LDEbAScBRWP?=
 =?us-ascii?Q?V/2BqfFwskPkeI14JP8MLlCGstyQIjy+dLkUW683UtwSM9RYXpginSquBE+t?=
 =?us-ascii?Q?cXalSvmBFSeVpZvPTL3eMML3XrtmBO9Gr2/TtCemD5GitDP5yq4s9V8qY7i2?=
 =?us-ascii?Q?Rqo89Ff0Ng=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a56e5acc-8300-47a0-81f6-08def16c32fb
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 14:33:35.0258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T4dJ9+CWhArJgu91sF94LnqjBsHB9zEu5D+uNyr7EZp3pR+08vgPdgkaQ7+ZU6Hh1hg0W9a0zzUzh8to3jhzkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6130

On Fri, Jul 31, 2026 at 01:48:07AM +0800, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> Devices which optionally support Dynamic Capacity (DC) are configured
> via mailbox commands.  CXL r4.0 section 9.13.3 requires the host to issue
> the Get DC Configuration command in order to properly configure DCDs.
> Without the Get DC Configuration command DCD can't be supported.
> 
> Implement the DC mailbox commands as specified in CXL 4.0 section
> 8.2.10.9.9 (opcodes 48XXh) to read and store the DCD configuration
> information.  Disable DCD if an invalid configuration is found.
> 
> Linux has no support for more than one dynamic capacity partition.  Read
> and validate all the partitions but configure only the first partition
> as 'dynamic ram 1'.  Additional partitions can be added in the future if
> such a device ever materializes.  Additionally it is anticipated that no
> skips will be present from the end of the pmem partition.  Check for and
> disallow this configuration as well.
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> Tested-by: Wonjae Lee <wj28.lee@samsung.com>
> Tested-by: Junhee Park <jh9934.park@samsung.com>
> Tested-by: Heesoo Kim <habil.kim@samsung.com>
> 
> ---
> Changes:
> 1. mbox.c: bound the Get DC Config request by the negotiated mailbox
>    payload. Requesting all CXL_MAX_DC_PARTITIONS (8) needs a 328-byte
>    response, which exceeds a spec-minimum 256-byte mailbox and fails
>    -E2BIG, disabling DCD. Cap partition_count per call to what the
>    payload holds and read the rest via the existing start_partition
>    loop.
> ---
>  drivers/cxl/core/hdm.c  |   2 +
>  drivers/cxl/core/mbox.c | 220 ++++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/cxlmem.h    |  55 ++++++++++
>  drivers/cxl/pci.c       |   3 +
>  include/cxl/cxl.h       |   3 +-
>  5 files changed, 282 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> index 0c80b76a5f9b..0ef076c08ed2 100644
> --- a/drivers/cxl/core/hdm.c
> +++ b/drivers/cxl/core/hdm.c
> @@ -446,6 +446,8 @@ static const char *cxl_mode_name(enum cxl_partition_mode mode)
>  		return "ram";
>  	case CXL_PARTMODE_PMEM:
>  		return "pmem";
> +	case CXL_PARTMODE_DYNAMIC_RAM_1:
> +		return "dynamic_ram_1";
>  	default:
>  		return "";
>  	};
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 4790524c32a7..d79019fbd790 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -1352,6 +1352,197 @@ int cxl_mem_sanitize(struct cxl_memdev *cxlmd, u16 cmd)
>  	return -EBUSY;
>  }
>  
> +static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part_array,
> +			u8 index, struct cxl_dc_partition *dev_part)
> +{
> +	u64 blk_size = le64_to_cpu(dev_part->block_size);
> +	u64 len = le64_to_cpu(dev_part->length);
> +
> +	part_array[index].start = le64_to_cpu(dev_part->base);
> +	part_array[index].size = le64_to_cpu(dev_part->decode_length);
> +	part_array[index].size *= CXL_CAPACITY_MULTIPLIER;
> +
> +	/* Check partitions are in increasing DPA order */
> +	if (index > 0) {
> +		struct cxl_dc_partition_info *prev_part = &part_array[index - 1];
> +
> +		if ((prev_part->start + prev_part->size) >
> +		     part_array[index].start) {
> +			dev_err(dev,
> +				"DPA ordering violation for DC partition %d and %d\n",
> +				index - 1, index);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	if (part_array[index].size == 0 || len == 0 ||
> +	    part_array[index].size < len || !IS_ALIGNED(len, blk_size)) {
> +		dev_err(dev, "DC partition %d invalid length; size %llu len %llu blk size %llu\n",
> +			index, part_array[index].size, len, blk_size);
> +		return -EINVAL;
> +	}
> +

Hi Anisa,

I think here , 0s are legal, according to spec CXL 4.0 8.2.10.9.9.1 "Get Dynamic Capacity Configuration",
Table 8-347 "DC Region Configuration". It says "Report 0 if the region is unavailable for Dynamici Capacity"

Imagine if we have a device ports 8 regions and only region 0 is configured, regions 1~7 come back with 0s.
cxl_dc_check() will check them all, so the first zero region fails and cxl_configure_dcd() ends up disabling
DCD on a device that is perfectly fine.

Maybe we should skip the all-zero regions instead of rejecting them ?

Best regards,
Richard Cheng.

> +	if (blk_size == 0 || blk_size % CXL_DCD_BLOCK_LINE_SIZE ||
> +	    !is_power_of_2(blk_size)) {
> +		dev_err(dev, "DC partition %d invalid block size %llu\n",
> +			index, blk_size);
> +		return -EINVAL;
> +	}
> +
> +	if (!IS_ALIGNED(part_array[index].start, SZ_256M) ||
> +	    !IS_ALIGNED(part_array[index].start, blk_size)) {
> +		dev_err(dev, "DC partition %d invalid start %llu blk size %llu\n",
> +			index, part_array[index].start, blk_size);
> +		return -EINVAL;
> +	}
> +
> +	dev_dbg(dev, "DC partition %d start %llu size %llu blk_size: %llu\n",
> +		index, part_array[index].start, part_array[index].size,
> +		blk_size);
> +
> +	return 0;
> +}
> +
> +/* Returns the number of partitions in dc_resp or -ERRNO */
> +static int cxl_get_dc_config(struct cxl_mailbox *mbox, u8 start_partition,
> +			     u8 partition_count,
> +			     struct cxl_mbox_get_dc_config_out *dc_resp,
> +			     size_t dc_resp_size)
> +{
> +	struct cxl_mbox_get_dc_config_in get_dc = (struct cxl_mbox_get_dc_config_in) {
> +		.partition_count = partition_count,
> +		.start_partition_index = start_partition,
> +	};
> +	struct cxl_mbox_cmd mbox_cmd = (struct cxl_mbox_cmd) {
> +		.opcode = CXL_MBOX_OP_GET_DC_CONFIG,
> +		.payload_in = &get_dc,
> +		.size_in = sizeof(get_dc),
> +		.size_out = dc_resp_size,
> +		.payload_out = dc_resp,
> +		.min_out = 8,
> +	};
> +	size_t expected_sz;
> +	int rc;
> +
> +	rc = cxl_internal_send_cmd(mbox, &mbox_cmd);
> +	if (rc < 0)
> +		return rc;
> +
> +	if (dc_resp->partitions_returned > partition_count) {
> +		dev_err(mbox->host, "Device returned %u partitions, requested %u\n",
> +			dc_resp->partitions_returned, partition_count);
> +		return -EIO;
> +	}
> +
> +	/*
> +	 * The payload carries trailing extent/tag count fields after the
> +	 * partition array (CXL r4.0 Table 8-179) which the driver ignores, so
> +	 * the response is at least, not exactly, expected_sz.
> +	 */
> +	expected_sz = struct_size(dc_resp, partition,
> +				  dc_resp->partitions_returned);
> +
> +	if (mbox_cmd.size_out < expected_sz) {
> +		dev_err(mbox->host,
> +			"Payload size %zu less than expected %zu for %u partitions\n",
> +			mbox_cmd.size_out,
> +			expected_sz,
> +			dc_resp->partitions_returned);
> +		return -EIO;
> +	}
> +
> +	dev_dbg(mbox->host, "Read %d/%d DC partitions\n",
> +		dc_resp->partitions_returned, dc_resp->avail_partition_count);
> +	return dc_resp->partitions_returned;
> +}
> +
> +/**
> + * cxl_dev_dc_identify() - Reads the dynamic capacity information from the
> + *                         device.
> + * @mbox: Mailbox to query
> + * @dc_info: The dynamic partition information to return
> + *
> + * Read Dynamic Capacity information from the device and return the partition
> + * information.
> + *
> + * Return: 0 if identify was executed successfully, -ERRNO on error.
> + *         on error only dc_info is left unchanged.
> + */
> +int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> +			struct cxl_dc_partition_info *dc_info)
> +{
> +	struct cxl_dc_partition_info partitions[CXL_MAX_DC_PARTITIONS];
> +	struct cxl_mbox_get_dc_config_out *dc_resp __free(kfree) = NULL;
> +	struct device *dev = mbox->host;
> +	u8 start_partition;
> +	u8 num_partitions;
> +	u8 partition_count;
> +	size_t dc_resp_size;
> +
> +	/* Bound requested number of partitions by mailbox payload size */
> +	partition_count = min_t(size_t, CXL_MAX_DC_PARTITIONS,
> +				(mbox->payload_size - sizeof(*dc_resp) -
> +				 sizeof(struct cxl_mbox_get_dc_config_tail)) /
> +				sizeof(struct cxl_dc_partition));
> +	dc_resp_size = struct_size(dc_resp, partition, partition_count) +
> +		       sizeof(struct cxl_mbox_get_dc_config_tail);
> +
> +	dc_resp = kmalloc(dc_resp_size, GFP_KERNEL);
> +	if (!dc_resp)
> +		return -ENOMEM;
> +
> +	/*
> +	 * Read and check all partition information for validity and potential
> +	 * debugging; see debug output in cxl_dc_check()
> +	 */
> +	start_partition = 0;
> +	num_partitions = 0;
> +	do {
> +		int rc, i, j;
> +
> +		rc = cxl_get_dc_config(mbox, start_partition, partition_count,
> +				       dc_resp, dc_resp_size);
> +		if (rc < 0) {
> +			dev_err(dev, "Failed to get DC config: %d\n", rc);
> +			return rc;
> +		}
> +
> +		if (rc == 0) {
> +			dev_err(dev,
> +				"Device reported %u partitions available but returned none at index %u\n",
> +				dc_resp->avail_partition_count, start_partition);
> +			return -EIO;
> +		}
> +
> +		num_partitions += rc;
> +
> +		if (num_partitions < 1 || num_partitions > CXL_MAX_DC_PARTITIONS) {
> +			dev_err(dev, "Invalid num of dynamic capacity partitions %d\n",
> +				num_partitions);
> +			return -EINVAL;
> +		}
> +
> +		for (i = start_partition, j = 0; i < num_partitions; i++, j++) {
> +			rc = cxl_dc_check(dev, partitions, i,
> +					  &dc_resp->partition[j]);
> +			if (rc)
> +				return rc;
> +		}
> +
> +		start_partition = num_partitions;
> +
> +	} while (num_partitions < dc_resp->avail_partition_count);
> +
> +	/* Return 1st partition */
> +	dc_info->start = partitions[0].start;
> +	dc_info->size = partitions[0].size;
> +	dev_dbg(dev, "Returning partition 0 %llu size %llu\n",
> +		dc_info->start, dc_info->size);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
> +
>  static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_partition_mode mode)
>  {
>  	int i = info->nr_partitions;
> @@ -1422,6 +1613,35 @@ int cxl_get_dirty_count(struct cxl_memdev_state *mds, u32 *count)
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_get_dirty_count, "CXL");
>  
> +void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
> +{
> +	struct cxl_dc_partition_info dc_info = { 0 };
> +	struct device *dev = mds->cxlds.dev;
> +	int rc;
> +
> +	rc = cxl_dev_dc_identify(&mds->cxlds.cxl_mbox, &dc_info);
> +	if (rc) {
> +		dev_warn(dev,
> +			 "Failed to read Dynamic Capacity config: %d\n", rc);
> +		cxl_disable_dcd(mds);
> +		return;
> +	}
> +
> +	/* Skips between pmem and the dynamic partition are not supported */
> +	if (dc_info.start != info->size) {
> +		dev_warn(dev,
> +			 "Dynamic Capacity skip from pmem not supported\n");
> +		cxl_disable_dcd(mds);
> +		return;
> +	}
> +
> +	info->size += dc_info.size;
> +	dev_dbg(dev, "Adding dynamic ram partition 1; %llu size %llu\n",
> +		dc_info.start, dc_info.size);
> +	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM_1);
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_configure_dcd, "CXL");
> +
>  int cxl_arm_dirty_shutdown(struct cxl_memdev_state *mds)
>  {
>  	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 616eeaeee5b9..a9782939d82b 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -407,6 +407,8 @@ struct cxl_security_state {
>  	struct kernfs_node *sanitize_node;
>  };
>  
> +#define CXL_MAX_DC_PARTITIONS 8
> +
>  static inline resource_size_t cxl_pmem_size(struct cxl_dev_state *cxlds)
>  {
>  	/*
> @@ -691,6 +693,39 @@ struct cxl_mbox_set_shutdown_state_in {
>  	u8 state;
>  } __packed;
>  
> +/* See CXL r4.0 Table 8-178 get dynamic capacity config Input Payload */
> +struct cxl_mbox_get_dc_config_in {
> +	u8 partition_count;
> +	u8 start_partition_index;
> +} __packed;
> +
> +/* See CXL r4.0 Table 8-179 get dynamic capacity config Output Payload */
> +struct cxl_mbox_get_dc_config_out {
> +	u8 avail_partition_count;
> +	u8 partitions_returned;
> +	u8 rsvd[6];
> +	/* See CXL r4.0 Table 8-180 */
> +	struct cxl_dc_partition {
> +		__le64 base;
> +		__le64 decode_length;
> +		__le64 length;
> +		__le64 block_size;
> +		__le32 dsmad_handle;
> +		u8 flags;
> +		u8 rsvd[3];
> +	} __packed partition[] __counted_by(partitions_returned);
> +	/* Trailing extent/tag count fields unused */
> +} __packed;
> +
> +/* Trailing counts; cannot be a member after the flex array above */
> +struct cxl_mbox_get_dc_config_tail {
> +	__le32 num_extents_supported;
> +	__le32 num_extents_available;
> +	__le32 num_tags_supported;
> +	__le32 num_tags_available;
> +} __packed;
> +#define CXL_DCD_BLOCK_LINE_SIZE 0x40
> +
>  /* Set Timestamp CXL 3.0 Spec 8.2.9.4.2 */
>  struct cxl_mbox_set_timestamp_in {
>  	__le64 timestamp;
> @@ -814,9 +849,18 @@ enum {
>  int cxl_internal_send_cmd(struct cxl_mailbox *cxl_mbox,
>  			  struct cxl_mbox_cmd *cmd);
>  int cxl_dev_state_identify(struct cxl_memdev_state *mds);
> +
> +struct cxl_dc_partition_info {
> +	u64 start;
> +	u64 size;
> +};
> +
> +int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> +			struct cxl_dc_partition_info *dc_info);
>  int cxl_await_media_ready(struct cxl_dev_state *cxlds);
>  int cxl_enumerate_cmds(struct cxl_memdev_state *mds);
>  int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info);
> +void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info);
>  struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev, u64 serial,
>  						 u16 dvsec);
>  void set_exclusive_cxl_commands(struct cxl_memdev_state *mds,
> @@ -830,6 +874,17 @@ void cxl_event_trace_record(struct cxl_memdev *cxlmd,
>  			    const uuid_t *uuid, union cxl_event *evt);
>  int cxl_get_dirty_count(struct cxl_memdev_state *mds, u32 *count);
>  int cxl_arm_dirty_shutdown(struct cxl_memdev_state *mds);
> +
> +static inline bool cxl_dcd_supported(struct cxl_memdev_state *mds)
> +{
> +	return mds->dcd_supported;
> +}
> +
> +static inline void cxl_disable_dcd(struct cxl_memdev_state *mds)
> +{
> +	mds->dcd_supported = false;
> +}
> +
>  int cxl_set_timestamp(struct cxl_memdev_state *mds);
>  int cxl_poison_state_init(struct cxl_memdev_state *mds);
>  int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index 267c679b0b3c..9b320a2b6fe0 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -870,6 +870,9 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	if (rc)
>  		return rc;
>  
> +	if (cxl_dcd_supported(mds))
> +		cxl_configure_dcd(mds, &range_info);
> +
>  	rc = cxl_dpa_setup(cxlds, &range_info);
>  	if (rc)
>  		return rc;
> diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
> index 016c74fb747c..87c2bd73df21 100644
> --- a/include/cxl/cxl.h
> +++ b/include/cxl/cxl.h
> @@ -133,6 +133,7 @@ struct cxl_dpa_perf {
>  enum cxl_partition_mode {
>  	CXL_PARTMODE_RAM,
>  	CXL_PARTMODE_PMEM,
> +	CXL_PARTMODE_DYNAMIC_RAM_1,
>  };
>  
>  /**
> @@ -147,7 +148,7 @@ struct cxl_dpa_partition {
>  	enum cxl_partition_mode mode;
>  };
>  
> -#define CXL_NR_PARTITIONS_MAX 2
> +#define CXL_NR_PARTITIONS_MAX 3
>  
>  /**
>   * struct cxl_dev_state - The driver device state
> -- 
> 2.43.0
> 
> 
