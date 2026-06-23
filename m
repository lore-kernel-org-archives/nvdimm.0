Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010007.outbound.protection.outlook.com [52.101.61.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8541A3A1A56
	for <nvdimm@lists.linux.dev>; Tue, 23 Jun 2026 06:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782197768; cv=fail; b=Uk/ldmgW0zGAT643Do1KRZbF7bQJUglbah2muwfm+t9KPah5D3Nq/tV6RE399Sdf65grdUPHcq1mN6W04hkW5LiL2L9hsO4xzMgfvRzBWQGBLpog7WZ2+fU67R/UHrXn/a2dwZ9gpIAe/RQCY+T98l2GELQzmQanwe9K92sh2Mg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782197768; c=relaxed/simple;
	bh=IFvkaM8u7mkVPaCs4g2EaL49uiw80puYwmcW1hDE4NM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=icjS7xGu45vCtdZbixmcqH7UdXveUWKst8dqSm2ENi7Odnm+84KfyDArOaT8bdD2I7bLQJg4AkRQ78nsZIKLIhxjyKNZQjPD4bRfZMV4Sg3dO9zmcYFx+ye35q8O3KNksMpFLW6XlPIQDD8F1OUxQtO7f+bOVWqFisLqDLbFrx8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=C5lwKBTC; arc=fail smtp.client-ip=52.101.61.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="C5lwKBTC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pS/rZPTLelC1f41G/0/CzgJqg8N+0tsjdB2qKaEjnxS+U1AThpNWQHIMhnmjBhCgMx9Vp2P76Km6AzyhUndP6V6zhhCdyErxB1AL0/uUMrnwV5yYLqZL23qzm8Pd0iGx6YWAUoBw/PYQR9IVqo+TE9b0DVvOxyOTf3iSvq/A9CP2xJNKflsfOCud9Lrj85zA3vDt8TYFCCCabCz7P3b0fDO20378adheENr/FmMyTAhvzpBNurKd0VKSwJlytJBlCVuFKxgwsQh/Z6wLAm4L8NmW2iKO6e69Uxyy5nemKbW5gBNfYo+No4hazyNsr7jTa6urJ/5w4VmHwfLTHehlDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NkilLieKE9+DsK/l6CbQtrWWuGbfPrqca2FikuZuJRU=;
 b=RotdZSslcQ/d2QNodQbpXrW+UZdNq9Xq/PqP3Y98EQ3aX1GDY1pyiSD/2rfey7B/84g6T9mNgcgLHHYbfYGFwGbk+uLKqfEadGUhIU+cFLJjVy4+5z/cGRifRIHGyWFY85PD/VAXXNf28IqNmJKAe/DB4nq4FpgJilKVa7y3Z69Qkr6LApt/l107LBEuXV1rCeinQHKTqcb1G603ZDipYvn+mkXoX3jW0QdmvyzwVzac/b+f47BN+54GSzX4qSK+RsRXyTBWEd6Xou7dFZY3Ve3KaI595j4eBSFPZMTPtCE/nceLH/FtM+Dk5b1A93RpvxhyQ7F1qO43sHc/esj8Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NkilLieKE9+DsK/l6CbQtrWWuGbfPrqca2FikuZuJRU=;
 b=C5lwKBTCxHNYZjjnoHhZtlJr/kpkZU0BE8mO0gppR5nWCquBWZZOWVZH11bkysKCmRAhz5PUe7lJ52kuFl5ETOvTFZ4nYtHacwp7eV2hHc9muDBh513+wMVD8+pboQ+V7GDVxPWkeZam3i8HJUkD6k09MWh5oLRgMGrZuB82eMHOzBt5OAA6dZuDqnuBYpAwqrI+3/IneuPPYUlai6+Jh8mBCMYX0RZ6ZwZM2DQtkts2ju0Ayo6onZHkB4FYGH/rOyMYYVd3danjn6meWdLAF1Uzsomd3Dkp/8zT9iyhVonvsZPCbMS1hx4DQBtm07dkx/QIiSRWLOCQO8JPKajS5w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by IA1PR12MB9530.namprd12.prod.outlook.com (2603:10b6:208:593::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Tue, 23 Jun
 2026 06:56:03 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0139.009; Tue, 23 Jun 2026
 06:56:03 +0000
Date: Tue, 23 Jun 2026 14:55:54 +0800
From: Richard Cheng <icheng@nvidia.com>
To: John Groves <john@jagalactic.com>
Cc: John Groves <John@groves.net>, Dan Williams <djbw@kernel.org>, 
	John Groves <jgroves@micron.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V6 02/10] dax/fsdev: fix multi-range offset in
 memory_failure handler
Message-ID: <ajotQmNtiDm2c9Ap@MWDK4CY14F>
References: <0100019ecc080a68-8dc0c99f-ab17-4aa9-83d9-490e9c97ac2e-000000@email.amazonses.com>
 <20260615160626.17473-1-john@jagalactic.com>
 <0100019ecc08d74f-ec0d09b8-11e9-4e5b-af48-8c6d382af486-000000@email.amazonses.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0100019ecc08d74f-ec0d09b8-11e9-4e5b-af48-8c6d382af486-000000@email.amazonses.com>
X-ClientProxiedBy: SG2PR04CA0203.apcprd04.prod.outlook.com
 (2603:1096:4:187::22) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|IA1PR12MB9530:EE_
X-MS-Office365-Filtering-Correlation-Id: 707846d4-0fae-47e5-51a6-08ded0f47d99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|22082099003|18002099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	14vikLNHrv1fDPUAMNr8YoOhJExOd7DfMtP3qNvZ6ZOtQ2/XyuYhIEow6DTWBox/obJkaD93UonSWiTLJDQAgpw57JiQl6U8tzE0ajSZjftevatISaZtKJL7ZJR5EDogX2buM3gcIwvIyDs9O8ib96qV3STOWkxzGUL+7Qdi4g27+Yyd/mR6o1UbcRySWmWZKYvuKMS6//Ci7eKNdPgaee4XiUdXKZkWTNjAArC715fuqwLjAttx7JZeLhHOsDevyOJrStzxGn2gZZvtsIYKbO5qjzjj1yNle3NFHjZ68GyW5H6EW7/tCViuRjH2XNIwt6eQFc/epbq7UhLcEOuIMKz6q/iRv89k0XdABE1gU4WSerZGgzOqE/w1aDF8HSXnm2vtZe3f9Ic0pfSSzg+xCmZ0fxkMsJFh4E+3AwYqGaCvVPGe6AGZ/CxBBIXKaharJ4fPbmtvzrTvhT6yz9H4Gvv6u1nSHv0XzuGxQkE9hk9mKvnaiHQMoPuVDuXy4rjNCr5auisc80HG9PipnORdedaK9rOcA9lVLNIMpwjEjcY9xXJdaUVFoJKazSwXtb/+0YzUO9VqiH26TgG8UJxZkG68HnO+8VyvcrhfoZJlEqP8gmJOSOng4oN/NFqwRqPMWC4Yb9YbVxEFvVRONgGJemQ9qrniiaQ1h+PhRBGyK4Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?I5ctwO8ycVly086Bm0YZqiISzTlvpJthnwUoDxpM+2+bE9AX4W5gNt7tX4bt?=
 =?us-ascii?Q?GR6GKA46YopeK/guU2q2vsKORqKFuXxGLJedUwoIHbsMGe6iZ54ASQskxRqv?=
 =?us-ascii?Q?RlMhOXiV9TEk1SDCrqzjCGVGtUNT64gP1gXcutqdgJ40dkRn5L6QImZQDmZv?=
 =?us-ascii?Q?ttl6wiwsB9AwU7AceJEeRxcj5/T19SgjShKH1hi3Slfery+X16UwCE9yTzz7?=
 =?us-ascii?Q?5RXuhth/4PNFGVPCMDNP79urAtWpQdbnKr7tH1vBhmAdj2cnP10/M+STzCKl?=
 =?us-ascii?Q?rEMQHLyHGpmGwQ2+uNoSgGJJ9JSOp9CRUkEjcOm6GJY/SytWv3+fAPn1+WHq?=
 =?us-ascii?Q?zEmBgvbMmH9fp/3V3ZK1PgbrUmXm+AM+R9pZjM0wvCgTEVsrjBXTOP3kOXI5?=
 =?us-ascii?Q?ISxEp0aSmgiodPG1HuFz1zOJIVZR60+sGjc5EcG/u5f+07AkpGgxU/P9rNNH?=
 =?us-ascii?Q?RIdfHnpJop/ymjaWUJrfXFzH34aaHbQTrLPStYhVKuxrWEyu8aMNSx82eDQn?=
 =?us-ascii?Q?uvIOMycleyNy2VFtFoUJ2DsLdHNYyNcaQocTadGVeqPIYtK9DkocvlhnuOHc?=
 =?us-ascii?Q?0rECBrFEEyFc0GxqRduhJhJexU9jKHqhwkm0+O2Onm5vExngg3mBRRmqPUje?=
 =?us-ascii?Q?8VyO6sJZTBDB2ABnX/c59YybKVpkA1BJC1jO4dWH7lTw++/vSXBtubCxuQb2?=
 =?us-ascii?Q?AP5vn2nE3bMWgi9nwF7we3/9wuBn1khVkPcyfyQsQPwcRIWv9cOTqhVFFDKq?=
 =?us-ascii?Q?usdmEDcEAsSde/Qji7a0TKE5m85y5C8ycli3EDJxMyWIcBnEBXsbm+Y3mFLj?=
 =?us-ascii?Q?GhMutPRhGogl8m8yCWK9X7Z5L9ihdMUup2ZEJzMD3oKkkxDriw5PvPop2+or?=
 =?us-ascii?Q?C/PrYR8FNxPaPV0zySit57DBEBvyhQB2OXMmLDE0p+P7R4bt8Xjl5zOFvjuI?=
 =?us-ascii?Q?kWqYvJxZ6xHeXPwpmRr7HTTtmjXtoS0vr/BqU+ZbvNFfYEMN6jzTUR1cASCx?=
 =?us-ascii?Q?7f//DT51hjXVRmJfIDxKCenIxXD4gEaDBOM5DdgREjxIFGSPqFgHKRFZxRLP?=
 =?us-ascii?Q?5Ra2eZT5Yi68aI9+qE8KvGRdG+hepZ6qYX2gRGf2kGFXZUqTV05HH0ImHXF3?=
 =?us-ascii?Q?D2hFJfdtG/edl37Us1aX8oDJKr5my4Rexx7pqRQ+jH1eQJ+oGaTvuhj/JqH0?=
 =?us-ascii?Q?6rp0BNWhNPTQraa+rf4vMYabjqMFFY/kPiVMqI0FE5Ijkayt6NLNd1Xs52kh?=
 =?us-ascii?Q?Q4m2eZwMau2MKHDU9xRl+e/DeaghufiGILYoJSDn7WDVmKU3Nj6Gain9CA7r?=
 =?us-ascii?Q?zdUr6EhpbKpreTRSK/TKw3Ang9Lnw2Rb8Fj5j74YYzt45LUbJS198YSie28e?=
 =?us-ascii?Q?BdnHgLN4izecsO2ohWXBW3QH/pV5VPD8bKImPyE9dtlyREDFFLTJ7PvNHmtt?=
 =?us-ascii?Q?JrJl0FHvrQdg1sDzW9zoqK/L4+zN7TFbFwkml98wUP+R41bmaAus40R9XI36?=
 =?us-ascii?Q?V9of1t/qkTQ6mrpBcU3EGg2poFuYCDSfsefGaNuXpYIeH74FPpfJ4JKD4jgQ?=
 =?us-ascii?Q?08E3y33uGx7QtVrTN9MHvYNgKrSrLngDi/y8bGZcc+iTEKwt4itSrNB0hkQS?=
 =?us-ascii?Q?S86PKB0/ITsqY+A0mNGIuy0nPDK8FY2GtwpbWoxMqTUj0r9DOXDKewlNMLJc?=
 =?us-ascii?Q?pRkO9lRsWT1JxZ8LhXtPz5SXQYtrJFg5MF7xZID7WN0d/5dAM4TSBoeoh6LY?=
 =?us-ascii?Q?naN0g0y/AA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 707846d4-0fae-47e5-51a6-08ded0f47d99
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2026 06:56:03.7293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DHGBo0fhztL3hnlZqQ96eWMx9sqVI3kJUCQ0981Ht4XTrM/TdlnUH5sZgNeIb7ZqXE6rBM2LVCr6D+xdFLEMXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9530

On Mon, Jun 15, 2026 at 04:06:32PM +0800, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Fix memory_failure offset calculation for multi-range devices. The old
> code subtracted ranges[0].range.start from the faulting PFN's physical
> address, which produces an incorrect (inflated) logical offset when the
> PFN falls in ranges[1] or beyond due to physical gaps between ranges.
> Add fsdev_pfn_to_offset() to walk the range list and compute the correct
> device-linear byte offset relative to ranges[0].start (the device data
> start) -- the base the holder (xfs, famfs) maps from -- for both static
> and dynamic devices.
> 
> V5 walked the pagemap's immutable pgmap->ranges[] instead, to avoid
> reading the mutable dev_dax->ranges[] from this callback. That had a
> different problem: it regressed static devices, where pgmap->ranges[0].start
> can sit data_offset below the data start, so the reported offset came out
> data_offset too high and the holder would act on the wrong blocks. For
> dynamic devices the two arrays are identical, so pgmap->ranges[] only ever
> helped the dynamic case while breaking the static one. Walk
> dev_dax->ranges[] instead. (Richard Cheng spotted the static regression.)
> 
> Reading dev_dax->ranges[] here may race a concurrent krealloc() of the
> range array via sysfs (mapping_store(), under dax_region_rwsem, which
> this ->memory_failure callback does not hold). That exposure is
> pre-existing -- the original single-range code read dev_dax->ranges[0]
> locklessly as well -- so this patch does not make it worse; a proper fix
> (locking or snapshotting) belongs in a separate change.
>

Hi John,

LGTM, thanks for your work !

Reviewed-by: Richard Cheng <icheng@nvidia.com>

Best regards,
Richard Cheng.
 
> Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: John Groves <john@groves.net>
> ---
>  drivers/dax/fsdev.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> index 188b2526bee45..f315533b299e9 100644
> --- a/drivers/dax/fsdev.c
> +++ b/drivers/dax/fsdev.c
> @@ -135,11 +135,26 @@ static void fsdev_clear_ops(void *data)
>   * The core mm code in free_zone_device_folio() handles the wake_up_var()
>   * directly for this memory type.
>   */
> +static u64 fsdev_pfn_to_offset(struct dev_dax *dev_dax, unsigned long pfn)
> +{
> +	phys_addr_t phys = PFN_PHYS(pfn);
> +	u64 offset = 0;
> +
> +	for (int i = 0; i < dev_dax->nr_range; i++) {
> +		struct range *range = &dev_dax->ranges[i].range;
> +
> +		if (phys >= range->start && phys <= range->end)
> +			return offset + (phys - range->start);
> +		offset += range_len(range);
> +	}
> +	return -1ULL;
> +}
> +
>  static int fsdev_pagemap_memory_failure(struct dev_pagemap *pgmap,
>  		unsigned long pfn, unsigned long nr_pages, int mf_flags)
>  {
>  	struct dev_dax *dev_dax = pgmap->owner;
> -	u64 offset = PFN_PHYS(pfn) - dev_dax->ranges[0].range.start;
> +	u64 offset = fsdev_pfn_to_offset(dev_dax, pfn);
>  	u64 len = nr_pages << PAGE_SHIFT;
>  
>  	return dax_holder_notify_failure(dev_dax->dax_dev, offset,
> -- 
> 2.53.0
> 
> 
