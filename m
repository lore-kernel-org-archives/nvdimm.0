Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010021.outbound.protection.outlook.com [52.101.61.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17B93290B7
	for <nvdimm@lists.linux.dev>; Mon,  8 Jun 2026 10:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780916199; cv=fail; b=fKxBJhtlNwKHnbQaS4YFVD9uu7YxcsDo1qw880cJk4V9muEnC5ca0McrcYscDP+bVrQaFDF57Fiz/WGUoHVZ52uURVx+T0h9BuwnAVChHRERg9Yio4RtCMLJaXev/dOTIIV1ktq3PFe7wHz9jEEjLWvPYqlPKHRRMfzF6BlXzAM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780916199; c=relaxed/simple;
	bh=FTNsfrUgkLevEMfO/RlI0Z08NyBs9/38N+K4oA5c/+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QOTxAs6zQO+B1EyYYGF05V9cDlNPXXnR3g9/VSh0CK3AWtfU5dcoJtpiEc56BJDfqbMr5GFBg6O0swN8nqnJiMkoZdLtkYI2pmRP4fuqOhyQKyGXMqD7VKzVvaHMw5Kj0sw95L7RI0vpGic4TczNCk11J6nFznxqNB8sL6jczqM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=n1nvDegk; arc=fail smtp.client-ip=52.101.61.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="n1nvDegk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VV5St5tPDK2oZSVAffl5ApsY/7QadB3si4uMQ4u8CLBXhY6E3NzBF3rCuVLJ5tCoZShHfopspt250+YTZM/9CqkFBIQw3V/2zhimSB/yK5ScgurrEP9U5y0dUDi99yB3RBSrc7fl9KhJCWAgLaobLRpGklnfzsbzge4LvsGgUkXo15/8F+YR80Uw7uBcz/6QJzjVMhzpFLViSFegcf4e+bZkNcA7LwcVNtJSPJ1jrWDTZL9uh7tAGTFJm/o9PL4xbGK09R2zOBhMeva+RTNGATjBH59ZDsh6F3zDMI64EwAJsikvZpBxWqbaZkyt47NIkVoUM/IfQFwWO16iprpaTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N2uFqd+bGqO/YglAcStdoCd4qLo/H4LrDljVvDwTab8=;
 b=djifhFcbUnbSyL+FPrFWj+xYxESEMcW75hjvzPmDJBEAq9z4QWdJctA5Q5oUPAluQ8QUm1dBc4rNLWT4rV3HBp1N5EP3xDyC9G2BigZoauC0j1B3LRKaqNBGGPCfiAWjIhPw61ly2dnkjjal8hMOY3IJx76KJ98WiQlyBFXXwGtQrpuKVloCn6fTcQvX//Hdg8VuyP7l+1FSNkfCBoEl3vLkHZllqcHvwOquv3uHGwLnNI4HtELdc1+cBzBNhthlwXairFb3ANeMO5A0W2gw1smn/JkkaXwtoK9/+Q4Ep2hM/0WrcGeRtx6jTfVYR1nEBHsl7khBUBainaM3DJPJ6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N2uFqd+bGqO/YglAcStdoCd4qLo/H4LrDljVvDwTab8=;
 b=n1nvDegkZBICOADTQc85DhFJD2rBbFQp8LG2DW9HUHdOQFhpmy6MW0KA4V+TuPfkjxAjojEeBG+mkmOt+ZxpCmQuLxPkVon1r5xcQpoTjuuYC/S9u4Op7SQwz3nes7Jj1h0oytWNsL+S3v1zCb0Qvf1XUtZ8pwgX1yB9RUbzWGnIAEVe+E/yM5p/UCvXYSEMps18K9QDSwOAO8YkRqNXPEOJsRLr9nbexABe027wT0NQ5ddyR6zf53N0e2oNvh1wHksoUZAGjSEaN8rl9x0CXEaxGIdlka3TjBWNNXh11j2glvGfrSC4Mmw79BUHxkqdnkM6B/9Fq/AH1bUXFeSq1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by MN2PR12MB4376.namprd12.prod.outlook.com (2603:10b6:208:26c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Mon, 8 Jun 2026
 10:56:34 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 10:56:34 +0000
Date: Mon, 8 Jun 2026 18:56:28 +0800
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
Subject: Re: [PATCH V4 2/9] dax/fsdev: fix multi-range offset in
 memory_failure handler
Message-ID: <aiafDCGP0mI3IhrY@MWDK4CY14F>
References: <0100019ea3929225-a0f8e6f7-30ae-4f8e-ae6f-19129666c4c3-000000@email.amazonses.com>
 <20260607193314.94291-1-john@jagalactic.com>
 <0100019ea3934be1-ce7c2c13-b9fd-40b2-9284-14bc42d5cb08-000000@email.amazonses.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0100019ea3934be1-ce7c2c13-b9fd-40b2-9284-14bc42d5cb08-000000@email.amazonses.com>
X-ClientProxiedBy: TP0P295CA0008.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:2::20) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|MN2PR12MB4376:EE_
X-MS-Office365-Filtering-Correlation-Id: c41d5c07-d204-45d6-9e72-08dec54c9b2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|4143699003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	YEHrSJ0DnmWLmsC5YtRT121ZV3ZcFlzN42ukv8+vGKGfTFzENjN5NolojumYP/Npc2YDWUlOgMVpQGebIqS+PYDPUil6VavqPNo1lMsOcMqRQhnDf1KrvV2ZDOWlpWiTomcptMNNwwhYBl1kHCI8+CVimP+MgnLYyswFOQXaGj+fhKStpI1Qnm55XT7QqoFqrcl4c1gOihl/7bJCoSzq/wXMGYItCRsPTHIxdfeGZg/kFc9BcPeV3O1NuMrCqyr7eCru+hxSOUS+EqGhBkTEDqVPliIF/nkrdjZl3SzFo06YAycClhWmL55mpMuHmm/+WgFFnzn/4H0to43plgMLi6Mp644BmKzDl6a3iG6Y554Q8GJftmmFcRTf9gP1naNVlOsZ+wUalKjZMDMrOoR5//rxJFY4imU/5VYYDy2T1gY61fqiC4nx6xy/CGQ/13qrmbN5utshuA19WskAYX1z36rX9aMSiB3saG3+J/j1RxQ1wcuuROJhqhHX1sNOGngeYQja6okZe7hwPsaIdvZfU25VKcf5NazgQqempjhabJZK7HzDwlynSMtTb1GAhIMIEdtv2aRQswthRgBkpIn4nBsdOjjGtAiHYLhGKY9RNKJ0NjWykD6cDqvrR5oS5jE/C8aqUTNuY3kyEYYJZRWCYIAkaZB0dZFkilN8KPbenkHCD06ujPEWMTp89QekpTWt
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1RDTzkzWVaupHNiBuYTSAk0hdxgTAJVh84FkyFWk+RqvNFwogUMk5EGBeNO2?=
 =?us-ascii?Q?UosfSjlK9bYco4Cg+WdSV+28tjDiTRfwoch/YBAovPO9J37Mtsk7JjluVwOX?=
 =?us-ascii?Q?ejIacGxzHgePrbWX91VRyG4uI+p1U3qO3P6KpIaujZz+sfbhZ1z+6KcN0IN2?=
 =?us-ascii?Q?biwEfwE+b4lEwf9i8+mWPT1G1CO+PeUAPIFEAiv3vw2yb2v5IoV0ql9+pLe0?=
 =?us-ascii?Q?x1CFcHew82EcPbiRHO525BhXBz8LKRrjTv/xymFVGaQT3Elp9CzcpOG2od9y?=
 =?us-ascii?Q?bVB+Ej1OZ+4e2U29h+HSZlwIQXGeSdxyQtekL+zrgcXcWPK0Da950k+cRZdQ?=
 =?us-ascii?Q?byc2TMvrlkRVmWsUjxDKJd7U9J12SNlVZB/Hwwx8Ts8z+4g/VBmfX+7eNg/B?=
 =?us-ascii?Q?RtQ+ObOSoXHhUYPWFEhYmfcM1utELhqHqBG+f7NTWkurBAxU4GBa16YrrqpR?=
 =?us-ascii?Q?vqWFSerqmRlVtOpLYO19wZfOuwfVxBPo1/1Jvk8G6UzrYo/ZTNjbDnkIpHrh?=
 =?us-ascii?Q?vWhrf/6wBUH7tcsyQ/BZBwCXHVvgZUarD0EfmilPuoKJda+8Nl4+JxRQY3J6?=
 =?us-ascii?Q?u4KJ1k0UlQkkvg6g79ywOVzfEz9dVpH1kYI3cN+oorJsTICkpVW+QR47cwyJ?=
 =?us-ascii?Q?AJnnLRRI7spbd6SjOrpwxaM8MYxWgKF+xJjc2oAnak1XARSANyhBt9VuR8fj?=
 =?us-ascii?Q?0metKAGv9V65C+cBjCLspO04WC6zvORo60eIGoUDYDheSGmJT7oAo86H8Nxz?=
 =?us-ascii?Q?zAotQX8tZh2sSQ+FhbyEcemW2BkObVCZ4UKbN3/BXI3dZmNKuOG5nCp5bS0O?=
 =?us-ascii?Q?UsIyh4gLZ1EPQ+huh6pnRcvAnYSLjDM26oYfdfx5UBjfAEHhfNMlPVD4zH53?=
 =?us-ascii?Q?dne9kk82W6O/M0ywcTpEO34Rubtp1fee4xly76WRUqZyIx/w6h7KhvRC1XTA?=
 =?us-ascii?Q?LIeYA1/Fn8etDUJ9fKoF/+kgP7QvZW+BasNJtDrlfrKlc3XIxDWQTDqri521?=
 =?us-ascii?Q?h5tb4McfBUda1wvhmgDaIIumtd8nNXJGMdH/YZWIQYkLYMMbdFgfiBNIbuyi?=
 =?us-ascii?Q?C1utyGR2EzsjIX9GVtHsPHRgf3SEZHgHbdPZARUeMHgCsHL+sl48oxwBH5Hl?=
 =?us-ascii?Q?5ItQKcCyt59pKSy6j6NpjcRwhDtTEa3rOdWxGO1q8WED5+xxxwgfPPwQHCpP?=
 =?us-ascii?Q?/pP7vc2i9DsXAhVjgin5hUkaNvDuJ7AS2S1Dhar4NzC82FdJqcscaVDXOfKp?=
 =?us-ascii?Q?Gt/KkLRIPK3ywzM7bVa3DnHaiPrsWeYIHD7hNSCdvTaTpHb0vcHt0MqYRXpo?=
 =?us-ascii?Q?3X8KumEFsx+goIE2qjnJsgxRRF5Sfnqe8jxOPdTMGD1jRCEV/iz0bqxYivMu?=
 =?us-ascii?Q?9UF6ebP808LLZTtcyigvPpW7V/blcsGHnwNbzoT9zW4TuEoCSbvKCQtAbY+n?=
 =?us-ascii?Q?s9A+4ODcZXedyDeNk6tI3IgrAujcSznNZUNQ8udqKkXZlCQO5Q2Su7DyWHhj?=
 =?us-ascii?Q?CUAjZ7ySvYn7XaxGnQGLFhCbmYZIG9rXAvRNopy5OTk+j+C10OWQyThdscNQ?=
 =?us-ascii?Q?evPp1xI3cz4e2LaqBcWr9iQHPddBH9YbEGNQLw2USkBokLNfeHLoi//g3mR3?=
 =?us-ascii?Q?iPqG7jQ1OPGACyD8tSK4sF106QFTpsjQvV3bqOceI5g3eiXPQW99kiqI6/pv?=
 =?us-ascii?Q?fti8jN1R5ewEkWwJAMhKckmWDxOcQhW5aFtz6rkzvFslU/oyPPzKXjaV9580?=
 =?us-ascii?Q?HsjaTPuYwQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c41d5c07-d204-45d6-9e72-08dec54c9b2e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 10:56:34.8264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 02xw0Ey34t0hV/JB/dtslvAONfQ3r0P97vFRNaOBwX5E5ga5uMdAwaraGnxP8v9Pck1E/ky8frjmS34piB824w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4376

On Sun, Jun 07, 2026 at 07:33:19PM +0800, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Fix memory_failure offset calculation for multi-range devices. The old code
> subtracted ranges[0].range.start from the faulting PFN's physical address,
> which produces an incorrect (inflated) logical offset when the PFN falls in
> ranges[1] or beyond due to physical gaps between ranges. Add
> fsdev_pfn_to_offset() to walk the range list and compute the correct
> device-linear byte offset.
> 
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

IMHO, this walks dev_dax->ranges[] locklessly from the memory_failure callback.
mapping_store() can krealloc() that array via alloc_dev_dax_range() without
checking dev->driver, so a sysfs mapping write concurrent with a HW poison event
can move/free it under this walk.

We have pgmap->ranges[], the imuutable copy populated at probe and never mutated
afterwards, right here in the callback, and its accumulated range_len() is exactly
the device-linear offset.
Maybe walking that instread closes the race.

What do you think?

--Richard

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
