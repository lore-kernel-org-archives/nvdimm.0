Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012038.outbound.protection.outlook.com [40.107.209.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496602F8EA2
	for <nvdimm@lists.linux.dev>; Fri, 12 Jun 2026 03:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781233750; cv=fail; b=gZaSlwIIUDTgbWI2d6S6tq7q0XvK97Qe7IlNXoflcQ4qbwCHSXx5aNFVXYhf8gu9Bbt1io6LktYWmUkjU3SfSbkTfyUR+V4lZIryTU7nnHrGUafEhg1rFciPoQwkjwfWCingDKAqM2/3YCH5yE8MONo1wYiWH7z6dG5ZCK2EbB8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781233750; c=relaxed/simple;
	bh=iViS9PCsy2wNyIMAaZ5r1IxBY3JEFWGcU5afiieP0rQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=l19hd0xra6BBz/Ouamunk/3f0MST5TeNLHA04xTtinL3iw1PZvfAKFRE15q8MouUxl7ibVPjGVLkE1dYkEKjmVWV51JYhv2NKHjyw5LV0CMpMtZwPE4/ITrxkC4KpQAnA08x+ls/fcnYiC5NctPZMMXZr+WTU7xPDLYjTxZ5RHw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hc8sSgd3; arc=fail smtp.client-ip=40.107.209.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hc8sSgd3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lW2fdSDr+p2NByYm40MD18KTuweNAAM/z/Z+WKm8zkhHSeOeXaShM7NknF2COgAuDg/pL7l6K4eObQ9lvMLi8qa1EWv2GsPudkwcPkLU8CytDhJqgQemnUdzQF8tvVFHRjpSXJJLj7FPr/sNhVykjIzD9+AZHT2Gkuhr2hKDowSSCSAUXJUYiJiW3msKFw8mSfTGnm1KUdy/TlIi2Bft2KCxcfLlyQJp82xOPWwBq4Z4H0onzkflCi8Hxc13pPDXQpQGb7CoGPBm95m8QlnYR1dC0KglPz0WG//YVStb6LVuLGk+Mia0NrNiL/5f0xz0o5ZCj+2IEJkQUCxG1EPzUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DQd61/FHaL5kWjzsLfHAGVE9lA6bSPxObuPmiCl3ZZ4=;
 b=JGtnjGaFnZSZ/ia7Xvrtz6h6vauykkYZ9ahJvbs/JFeIcfe3XGUPNchzt9evY0RXPtas4TIqlKNkkC2tm80Mkyu+SxjtxakFBVLiTIwXqI61ETiRnssRq2AT/KwNegIgUrFSRAb8RVrUMd2h8OmoT8iTMqMniT/VkruiCjAG4aYw93PMTyjbQPTKSJX4ZKAnV9t5/lEJ4GYpLsuuoPmlcJaCyItpaexCD31nsCZJhEE+s9hss10sHawbDybDRlmPLOyH0VorDajmqMPjARIOWRppKFgFpq6CxO+Wf4zlwU75xhMYCBkMV9/2DfEWR5TMDPCz8dbSHqaSHjjaJJL+/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DQd61/FHaL5kWjzsLfHAGVE9lA6bSPxObuPmiCl3ZZ4=;
 b=hc8sSgd3EauwFs4F9K58BYikKxQHm9Mne8RfQKYNiLsY3IRVFDNzJAjloH/7T42ZdUtmcrVgjeG6EI47wG9hyIi2jgdzUOqY4myId22aZu0n0WMqj9VB6GQWyeM/wA9U8G3E4krFOU8wFbgbOOFNA9xTywOt3yyO2Z7ZWimqK/AEaUuVmEXRdYumrRMSY5xoQHVXgqKl9vt6UJxBDi0H0IV9d8w+9gZp0BZg7N3XNc/zxPmBfRqRyysPcKocpix/ERIiyzkhMRp7xKAu9GOJsCW8sYKZSypS93V6Wtgh8WvS8AkR2BCbSqVJUfdRUzw/itLylFTi7Q3INRKRE9PEJQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by MN2PR12MB4344.namprd12.prod.outlook.com (2603:10b6:208:26e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Fri, 12 Jun
 2026 03:09:05 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0113.013; Fri, 12 Jun 2026
 03:08:58 +0000
Date: Fri, 12 Jun 2026 11:08:51 +0800
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
Subject: Re: [PATCH V5 2/9] dax/fsdev: fix multi-range offset in
 memory_failure handler
Message-ID: <ait3Bg68J-NfOKhZ@MWDK4CY14F>
References: <0100019eb7bcda4b-3f8edae9-d7a4-4bfa-aaea-fcef77fdbbc3-000000@email.amazonses.com>
 <20260611173152.65905-1-john@jagalactic.com>
 <0100019eb7bda506-6ba24207-b1c0-4eeb-9b04-61940cf3f80c-000000@email.amazonses.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0100019eb7bda506-6ba24207-b1c0-4eeb-9b04-61940cf3f80c-000000@email.amazonses.com>
X-ClientProxiedBy: KU0P306CA0004.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:17::7) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|MN2PR12MB4344:EE_
X-MS-Office365-Filtering-Correlation-Id: 1daa7f04-00e5-4759-b0f2-08dec82ff1c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|18002099003|22082099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	mzEgOd6ZbxM254oVonTYL2LdFpZ/ahQQ2HV/mA/MaOETuGa9cB4JFfntQV5d/jYLxU+G3x7fVeCEnxAsPoHMcyiaXEkZ7ubEZoheumCXjpZElm17n+uE2brpSR7OX02oHBX1pWUII+ZU0YC5wA3IrrLrRfmylxsHTe/CRXGy4a12fjqd+j2mvQuCp3y+RRNCB43gIB7R2rpAEYB2EFE28bqLya0ilV3qifvXfzgexCyFILL0J80k29ODQHy32JaTh1TsNkTHcNDfKc8eOt/yMqS1zJZ+/d3Yd5Z8IUIv97PKPB5ug4bI3DJZD20Shop5LUqwlTwTWZS+o1JkSDvFYr0V2jmPWfnCZvNWhOCQY2GWEiBIYZISKvCVsDmCK8vj0wCVd5oSTQN10eWnuScN+pkKGgifIwa8NwryyGlbiEsEiaC3v7t3D9E0sy45yPkqEZGp8s9l79b4tKc0Oc+ioObAu7KdzoFej3gJoeEO4K95Xb4HSbs2iohyyU+ydXwxQ4ivdPAqY1am9UWVSMR2CrJlqToQ6Km7JnXo6XeIME19hG7ko42ukV2TkfgsCiuAvFmrFdTtKlIwXL3toOzbvMB0nsKl+ndbP28VEBpOymp1G0+7GHco1ZOcQ/CAE+XwHw719P+k64x51OfCdlCuDz2jxqd9x8M4PWeVuhJrv2yxZG1kWYF0l8Yt/AxvuStH
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MqjGvwh4HxlygeuIKHURvM/XKgwXCZLFtTQwW0mCI/BrtGyrK59/T6ottlWV?=
 =?us-ascii?Q?kzOOytWYL2S9qJR8L21CtCnz17heMLgC3mr8Gk5pWvA56ywb5vXhNn5VYCc6?=
 =?us-ascii?Q?+reWWTvwDNsb/NSyWlvPZ0osytPfS6bOyfsN3WWHpWZF/Ti7P/KR5FvS9KMM?=
 =?us-ascii?Q?WLWop+32+hXghiKtlJC42LxDObgjcshJEsqXMrRisCmZRBFN7SIvtqxLNdbH?=
 =?us-ascii?Q?CWLhskoISeoWXOr/gjbSvyMdRQIsnY8FJwrQ9QrqDvgd2rjztLnsEoh6xu1x?=
 =?us-ascii?Q?cOIpgsk/v65/EUdbyGnawpRyBxJyEePQisuA52r+pTJRTrFsxmAUmoKoKsPH?=
 =?us-ascii?Q?34JXHvC7SEAuEn5QgdW9/h93R8JVK8/N7kVSzbEHTmuHGPR+wUESrb3SfgMe?=
 =?us-ascii?Q?BNpIO7rs/STgjn6mR8MIWdwCDu14BR8/Dlc3H8vKfXyu/XSWmNQNbijAAyWd?=
 =?us-ascii?Q?PkNFej/J0EX7Zp7CZpF4wAyolPBffUCtutLH71mdZZvHvNAvUoXjx5M91GDU?=
 =?us-ascii?Q?pCzS0COduRU4XY66n78pXnMBsh8N2Ak3ipsTZhVWwwmIo+eEN5F+3oLBSxcw?=
 =?us-ascii?Q?X3ftVO3W21nd+ET9GfF6tlOpHtGiIFcMgTAu0eymxh4nVvahHJMqQv7uz/ZR?=
 =?us-ascii?Q?gjJekjUMkAjaTsmGK0MaF/XRivz3+L+1BykrPj9NkCOC/EL2djwG8tFv5zp5?=
 =?us-ascii?Q?94E46jOTtsiF+6jTfs736S31cnGo8KbQfYhZ8egnnhHfl2Y90wrymokgJFgb?=
 =?us-ascii?Q?np4QPptz3Aiq/4iTM6OPdYnZVOHa9KTa7b/0/LE1RdVjAADGk9y7bye/ey6L?=
 =?us-ascii?Q?Zwf47BlkvGJHQ11sO0W2tQSki5GClkXIPuP7IZzFwrVv1aWguxlfvrKlA2Nh?=
 =?us-ascii?Q?w6pkAA4WQMO9ppWzUX1XWrnAKKNL/2n046FC9ZvIGEorhlK2CODGEvlF1JcM?=
 =?us-ascii?Q?utu0NFZetFMgVelVVO3OAxBerrAozdeJMXAw5bvz82p1woejasQQt3HUsJ3l?=
 =?us-ascii?Q?hzmh0atlu3yORLFt4jgeko49p14AqyFkKrqfW7z7WWBA/1IrR99xqldPF4dX?=
 =?us-ascii?Q?xH7+KJV5R1iiGXhSipxsgmPqrr4ENJ50Kgvh6UgGzqT/O2C3FwzdyVl3LH8w?=
 =?us-ascii?Q?i+f3y6a24OM8K9fUudJN7W1CHCs/ATwo6NzRIuwXrP8oZGsoL3sxGhP0/s6a?=
 =?us-ascii?Q?0J1Gm6+TbC9c9kTG5+DpkLbo/aF83G0L+nRPi1d9/decJqALWMUIvYtNNkJR?=
 =?us-ascii?Q?dA0I7+PcABO/aGPt8Koj9fJ3lgIGE5L2p7TUf8pMDiKIBKPDdjvDQ8KlFe3G?=
 =?us-ascii?Q?+BSCVh8vO+VdZj5DbjfbmyOm22mFS+7b/rVAMdM8hxfhRGWwsBz831nNNUYd?=
 =?us-ascii?Q?xN9hA4njaTe6Q4eBffLIR+yiPwIiDt73U3/pFlRpKAbab4JWRhcoHF4DA9lk?=
 =?us-ascii?Q?Kn+K9z7OoETQt8WJzozVktS8WkcgoCMioZ9K2H7WjfrWDKYg4g9R26JcZHwj?=
 =?us-ascii?Q?e55Za9JfT+gRcfKgjbx/LU9w9UmNJhVI2J40hcwccbr0Pcrz+hXg86DPDxro?=
 =?us-ascii?Q?WSM+Dx57pn7MhqNN3AFp74lYUb3tqsDcFCxB9c41V91o9zx8WVRWu4oUCqfX?=
 =?us-ascii?Q?uICrP2A5HBFTEnhh96x0gVMoz2gyExY0Q3x6uUBLC11iwcbfc7sVy1MQQyUC?=
 =?us-ascii?Q?51Kt207TQdVWdcQnAf/ZtkwZdapHjz2SY8Eot8XqpgL4hFHtMDgoBGM3TzEM?=
 =?us-ascii?Q?91MXwyxohA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1daa7f04-00e5-4759-b0f2-08dec82ff1c4
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 03:08:58.1999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kEUq8np8a1X7rNUy0Ubs+ckY1H5u0e3F8Pqh7tTejmB7DZWN3mOfGInrt91eQ3uMiD1aX1sismYUl6KNSi5yBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4344

On Thu, Jun 11, 2026 at 05:31:59PM +0800, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Fix memory_failure offset calculation for multi-range devices. The old code
> subtracted ranges[0].range.start from the faulting PFN's physical address,
> which produces an incorrect (inflated) logical offset when the PFN falls in
> ranges[1] or beyond due to physical gaps between ranges. Add
> fsdev_pfn_to_offset() to walk the range list and compute the correct
> device-linear byte offset.
> 
> Walk the pagemap's own range array (pgmap->ranges[]) rather than
> dev_dax->ranges[]. The pgmap copy is the immutable snapshot populated at
> probe and is never mutated afterwards, whereas dev_dax->ranges[] can be
> krealloc()'d by a concurrent sysfs mapping_store() (under dax_region_rwsem,
> which this ->memory_failure callback does not hold). For dynamic devices the
> two arrays are identical, so the reported offset is unchanged for the
> multi-range case this targets.
> 
> Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")
> 
> Suggested-by: Richard Cheng <icheng@nvidia.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: John Groves <john@groves.net>
> ---
>  drivers/dax/fsdev.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> index 188b2526bee45..2c5de3d80a618 100644
> --- a/drivers/dax/fsdev.c
> +++ b/drivers/dax/fsdev.c
> @@ -135,11 +135,26 @@ static void fsdev_clear_ops(void *data)
>   * The core mm code in free_zone_device_folio() handles the wake_up_var()
>   * directly for this memory type.
>   */
> +static u64 fsdev_pfn_to_offset(struct dev_pagemap *pgmap, unsigned long pfn)
> +{
> +	phys_addr_t phys = PFN_PHYS(pfn);
> +	u64 offset = 0;
> +
> +	for (int i = 0; i < pgmap->nr_range; i++) {
> +		struct range *range = &pgmap->ranges[i];
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
> +	u64 offset = fsdev_pfn_to_offset(pgmap, pfn);

Hi John,

I think this regresses static devices. pgmap->ranges[0].start can sit
data_offset below it on a static device, so the new offset = old + data_offset,
and XFS poisons the wrong blocks.

The gap walk only helps dynamic devices where data_offset ==0 . Maybe walking pgmap->ranges and
substract the probe's data_offset.

--Richard

>  	u64 len = nr_pages << PAGE_SHIFT;
>  
>  	return dax_holder_notify_failure(dev_dax->dax_dev, offset,
> -- 
> 2.53.0
> 
