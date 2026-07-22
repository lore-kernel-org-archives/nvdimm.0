Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012017.outbound.protection.outlook.com [40.107.200.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F053B3112AB;
	Wed, 22 Jul 2026 13:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784726692; cv=fail; b=DrV6eH9eKMRFBlmgjY7lA1T65CYkdv1Gt8CYCkQf2z1ih+wffhe+Ar+Dlj926kvQQC6BnGh++WOCshc3FxDR3PVqFdk6ZvNfl7BvzDivbzAvS3FvyaLn3xepj1W29CK6vxj53czr3u9g3K+pZBd5rQd4Tt2aYDDHuBbENOMEKx8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784726692; c=relaxed/simple;
	bh=n66pvIYIwPiapEpY43eSqlNiwWhaNLXIIuJYd1JYitI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cz8zJcK95es4HFJUULW0T/xC2/ZEkohOX0mppT8pkR4t/3MoIw0HEOsLD7LYo48v0gLhWlfahmIm8M6UyirWQWc8JP509GCcm4PINBrBXvJ+nl2rAaEs3uVxe1gxGc1lJ5vF7TYlo4wc5NHp79D57KHCRxStEgHIltq/op7nOWA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IF76JjsG; arc=fail smtp.client-ip=40.107.200.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IF76JjsG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lDS0of01P2uJ18UUkeZ5jZ7glF7IL/5CssCBbWZG/gEEyU7j39S8YPYXIgbeIyF/RO05Drzv2kmTDXtCVRBjrVhfjPbJd8A3SkFrICK7/3hrMTi/W8YJQ+ystoBN8gJw289VksPLA/i13BLEw7+2JBbAs/pUUIGnoyCdu6+c9ThFsAI4Ora0hsYcsXKj91yjI2yfmlYSRvqPqJSiRo9Q4oOsXqDRdKBf6UqvYQ0Mc4RyXpekAGH4Dmr2eaXunaUyo7aTRvJlsqUowsU7g/tBCUm75uKQzJWsCFpdqHtO0SKxJZvf0uToPpM6nfxRJWkQXC0rYeSJ0PbnOILq1Ifn6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8oBPt/tU0QdicNiXvA9JANWmtUHLd/7jpv21uwVBW6g=;
 b=b71QKR+a2G90VSAC35j5rvwqBOdGAai+lSGiddHzxwabod3AW8ZB+NBbAUVjfEtpKI8iZ95JaGJdngfIlkZTuO49MwTYYo91kmi1m+8vY7vmuH67mcb0mBKuT68a6WZBEr6ObmosOM3Ox/5UsbiR+hS6iZcHTjiJRoZdZkOqF47/jLPaD0U0cn4qJ7KUCW1fqpNYZUEbLAZye4+cdBufBPiEmKFXAUb0w1H0q48jQi9zjYiCS5bZmwoNke1Obx0CqL80LyRXVoPu6GbbHHb5e4+ygy41LwEYWqSV4ShOWIO5V30a+gP3rFlikh1ufuqrRvFNAZGmEIya9N7v1IIxTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8oBPt/tU0QdicNiXvA9JANWmtUHLd/7jpv21uwVBW6g=;
 b=IF76JjsGP8QVdp44ChCj26E1BXsykOnuK3M+SRPJsAi6beXLO8bN2GsWFgItR+D+dJo8tv78mj31fgKmD4LBPYpWXPRdBdc1optX9PSnzfqeZ9fx/Ot6YyDdb82XzAhCB55bCr/S4RjVRI98MqkWVjaRKOGr6IgRcqvZ6RiCXzs42/0FeMgRzIR89hzyJoIkS7OCRLILsK9xCkeQOdKr6Qrm33e1aQ+jUsxEqht7zk3JJI4JcXM5k6Y7NJjogpyd1VQRFK8HWO+JMV2iMvZ+cKCZ/T6dswq9q+58v0DUeOEIRWCqI6QPh/tU5LBDemkLhcvd7NA7gCCD67aNumAmAA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by BL1PR12MB5730.namprd12.prod.outlook.com (2603:10b6:208:385::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 13:24:44 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 13:24:44 +0000
Date: Wed, 22 Jul 2026 21:24:37 +0800
From: Richard Cheng <icheng@nvidia.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, arun.george@samsung.com, 
	balbirs@nvidia.com, brendan.jackman@linux.dev, yuzenghui@huawei.com, 
	apopple@nvidia.com, alucerop@amd.com, matthew.brost@intel.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	corbet@lwn.net, skhan@linuxfoundation.org, gregkh@linuxfoundation.org, 
	rafael@kernel.org, dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com, 
	dave.jiang@intel.com, alison.schofield@intel.com, osandov@osandov.com, 
	jannh@google.com, pfalcato@suse.de, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com, 
	linux@rasmusvillemoes.dk, longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org, 
	mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com, 
	peterx@redhat.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, usama.arif@linux.dev, 
	xu.xin16@zte.com.cn, chengming.zhou@linux.dev, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 32/36] mm/khugepaged: base private node collapse
 eligiblity on actor/cap bits
Message-ID: <amDEEnTv0QumcDJn@MWDK4CY14F>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-33-gourry@gourry.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720193431.3841992-33-gourry@gourry.net>
X-ClientProxiedBy: SI1PR02CA0002.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::16) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|BL1PR12MB5730:EE_
X-MS-Office365-Filtering-Correlation-Id: d3796921-dcdc-4949-0f6a-08dee7f497b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|22082099003|18002099003|56012099006|11063799006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	Dny+F5zJ0HPJjmq9ojK6INmChnekLpDZPZfdsD2RR4AaepqWQbdOcxnRF2QiB/wIroSECr2gPf8gyDgD+ih0W+R4ytPRjg5zXkl5X2sFPgqXjVJ5bBk/hifgsIIYQMMhclfeQDPzTS0Zp9e6kLhP56IxyITH5RkluwdmM6Xfk3YYXs9d68+iktfIZ8prXpsx+c92HrCoL3MSPP3ziNzvdMRW5c7XXLUI98RiNb8/ldwHl6QFgRSpGY9L1BUlfb0ikCiPFJ477GdO8HK6v1b29VK2PqiB+hx578Fm6ZEVq+EMA2zEAZNsVExuetwv5nq64Sw9Ap9OZPCmIpRT9HCqZ1Ub9T4pQ8E2PzKe/i1ZAC+4Obpqh55fXlWUI1nP285B439w3U0tUBTB7GLS/YLIYbYsAMoESF5IeHm9/aer8vk/JqAPwDb3MgEV6e9MO/AKl/vaPdnGFFvuZlol+27U+WITzFbLHjA8k9AvzwRw7bs9Nmd8appMgDE8qQCjkT7jpPdmaqHT4bOgrto4qgqsKLmil7tmEA47Aw3N22rTN7m5c5mZ/SeI2gzWvrAuPXFuI6PUxldaoDi1P1mjaancAVMQ2HgdUaneUqjpNDL//MdOujPFKnwfTeGoBC50Qnd7qMrzjlWLM7FaFMVteEihPOyDy+cEwU/dTH3BCIaKe5M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?poBQBoF0NVw94nM7bQQGWDt6Ms96k2+mnOHoX4OgOTVGAOoJVlCAM/ovsTdZ?=
 =?us-ascii?Q?cUjCS4YzxhRzuEiCg1vfb1RjOiJkUgCgXXichlzG9YVOG9/SBYO6FSfFytsA?=
 =?us-ascii?Q?a8zxkgoiBqaMZViJJtPPKDjjUPdrNwmcuqNVEnFULqEsqJl3Rhu1dkBoYmIx?=
 =?us-ascii?Q?rT/7fCa+4PzdyRa45/O/KfCl5vumOU0WUiLtM7APMdp2EGR0okXebMH0116G?=
 =?us-ascii?Q?eAGwdH9RLU78+G2v1SWeZDPgz3Nw1sUvLWIFZm4BbcZZo8VaVgUjlzzK3t8G?=
 =?us-ascii?Q?cWR9vekXUpmXzDxmYQS1jTrOZG8px2Po2NDeM7l74GI9hv2xOFLOW01vN7iR?=
 =?us-ascii?Q?IE4PuWM9WohEjZtNXHcu9RSD5oDq2cRINYsRnk96Ld3tfLDZ09YWGjiwvWWT?=
 =?us-ascii?Q?t4Fr7veDqW/lK4wuUieoVCMYOPrIrStLB4lFCSlmhML2Nw6HMqpJQHaicGKv?=
 =?us-ascii?Q?idIWAafNx6pXZSnApoExG+qBo0v4zK7EIJPfkWIU94CBWCNaRMRR7pJn2PQ7?=
 =?us-ascii?Q?j7V+LmXuODLBr9/vVSmz/eo9ousFZNumVDRNBxbLMPHiVQ6YMDBh9N026bMu?=
 =?us-ascii?Q?3K9mH2UHqSQ07IJ5wYec5gUHyvP4/aWXr8apEj6DDMV8Ucy6jYq6zLhgAbQP?=
 =?us-ascii?Q?eZCB2C2O2JgkrqjLWMXlqHCSvtZlWS+Im26FQJiLcZQYRsSPNNGWsF/AJPZv?=
 =?us-ascii?Q?tZcauCnvN6TubAHb+TYl8fotgHCRQQ5Z8bQ9TpOHRHpkMV0MnaRSal7aj6sf?=
 =?us-ascii?Q?3SfMHHKlmYQeJ6x3p2uE2VuIY3yjVtlwtAuQD602yTD/2OFpmtCnFH0eEOPn?=
 =?us-ascii?Q?9Lt3dZzGemHe2jDKpBx2WTcmJdeanH9Fjf0C5yHnFP6tN2snifi2rlQQmPCM?=
 =?us-ascii?Q?7u9zcQ64g+buFwzKzQ7En/MSRa4zqx8Yy/JsH8f4mYnbSTZLQXO0funYRlIj?=
 =?us-ascii?Q?gBFq1Ah0j5DI+oQ0g7iNDiB2vvmGX+0BpeUwJyANqMsMPzRf5bafVrbjmXq7?=
 =?us-ascii?Q?JRpv1BmL++emM4OHH1ZHgmcJwgdaHBUn7zGqm0HeKtzGBfYCeex18FQg3HFd?=
 =?us-ascii?Q?3EezOYcIqzSUi5amcg6mUNilzxN+sYg9VQkA9Fj4WML109AgKqh5YG4Po1Tb?=
 =?us-ascii?Q?nWzImKjbX4GnI8fPDpFSPJ/w+LzE9kdaOLDlKZuTrvHiQXe2kmjsM96g2rEx?=
 =?us-ascii?Q?qC4riF+IRyOo9Pv73mLlh4mmHvLykuzv24sN4uAEYDjcsWJ11Zu+nqCmcDp2?=
 =?us-ascii?Q?9XN8o6bprh055CkDBGzL+PNFf5PL3zgTKgbQfV9ell1YdoxmYr8Fwc+3nan5?=
 =?us-ascii?Q?XsovGfv6OKUYbXdjGyW5hyZElFER08lSLztZAT5E+f9l61rB1dTnDRTRYvao?=
 =?us-ascii?Q?fCTfEDlG7KanzkNLzVSLgRvyGdswwVHktSSKXUSc38Dbg7kXpMAa5PNe4CU4?=
 =?us-ascii?Q?MLz7TMPH2eOEWWMRP8bNDEuU91Ehi1tVbYEeuppudlXLqd421AyxS29VjOJx?=
 =?us-ascii?Q?udzAg6HHCXsjqrfVj1m7T4OK+tuSZUFmMCJQP/fRmWdploO4edNMf+wn4bpH?=
 =?us-ascii?Q?rj7LWcPeZEJ1dextUNMRlqcuEElah/p87kyGfPr5pUIju2hVVqPlsdq4d7ej?=
 =?us-ascii?Q?JL/KTpc+RQ6nKBpCPk7E2OyrlmhDfA2jQYjm/TERZR9urTA17vc4gI4Y/y/V?=
 =?us-ascii?Q?qd0BC6BPRCMoSsmOQtvjNkH044/I75Q3bbVopMKU0hI6b2XS502Xi/h4yMne?=
 =?us-ascii?Q?q/HTabGt6w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3796921-dcdc-4949-0f6a-08dee7f497b6
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 13:24:44.0419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gke1vDWjGv3EFa50PTSCrsXKUD5INvzkrqCngxpRt+g9GtpIHACmFs+JPVwu9zigbDKfb29Ci+m7PXlBX08i/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5730

On Mon, Jul 20, 2026 at 03:34:26PM +0800, Gregory Price wrote:
> Collapse can move base pages across nodes.  The khugepaged daemon does
> this transparently, while MADV_COLLAPSE is a userland construct.
> 
> Isolate private nodes from khugepaged exactly like ZONE_DEVICE.
> Never collapse private node folios silently (the owner may not
> support migration).
> 
> MADV_COLLAPSE is user-initiated, so it is allowed on a private node
> opted into CAP_USER_NUMA, consistent with other userspace interfaces.
> 
> folio_allows_collapse() encodes this: false for khugepaged on a private
> node, CAP_USER_NUMA for MADV_COLLAPSE.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  mm/internal.h   | 26 ++++++++++++++++++++++++++
>  mm/khugepaged.c | 16 +++++++++++++---
>  2 files changed, 39 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 9621eb127c28c..9dbc5752cd3fe 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -136,6 +136,32 @@ static inline bool folio_allows_numa_balance(struct folio *folio)
>  	       node_allows_numa_balancing(folio_nid(folio));
>  }
>  
> +/*
> + * folio_allows_collapse() - may collapse fold this folio into a THP?
> + * @is_khugepaged: true for the khugepaged, false for MADV_COLLAPSE.
> + *
> + * Collapse is a residency operation gated by the actor calling it:
> + *   - khugepaged never operates on private-node folios (like ZONE_DEVICE)
> + *   - MADV_COLLAPSE is gated by CAP_USER_NUMA
> + *
> + * Never true for ZONE_DEVICE.
> + */
> +static inline bool folio_allows_collapse(struct folio *folio, bool is_khugepaged)
> +{
> +	int nid = folio_nid(folio);
> +
> +	if (folio_is_zone_device(folio))
> +		return false;
> +	if (is_khugepaged)
> +		return !node_is_private(nid);
> +	return node_allows_user_numa(nid);
> +}
> +
> +static inline bool page_allows_collapse(struct page *page, bool is_khugepaged)
> +{
> +	return folio_allows_collapse(page_folio(page), is_khugepaged);
> +}
> +
>  /*
>   * folio_allows_longterm_pin() - may this folio be long-term GUP-pinned?
>   *
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index fb4378cc17b10..5f20839857738 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -700,7 +700,8 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  			goto out;
>  		}
>  		page = vm_normal_page(vma, addr, pteval);
> -		if (unlikely(!page) || unlikely(page_is_private_managed(page))) {
> +		if (unlikely(!page) ||
> +		    unlikely(!page_allows_collapse(page, cc->is_khugepaged))) {
>  			result = SCAN_PAGE_NULL;
>  			goto out;
>  		}
> @@ -1241,9 +1242,17 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
>  	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
>  		     GFP_TRANSHUGE);
>  	int node = collapse_find_target_node(cc);
> +	unsigned int aflags;
>  	struct folio *folio;
> +	bool allow;
>  
> -	folio = __folio_alloc(gfp, order, node, &cc->alloc_nmask, ALLOC_DEFAULT);
> +	/* Private node access: khugepaged never, madvise with CAP_USER_NUMA */
> +	allow = cc->is_khugepaged ? !node_is_private(node)
> +				  : node_allows_user_numa(node);
> +	aflags = (allow && node_is_private(node)) ?
> +		ALLOC_ZONELIST_PRIVATE : ALLOC_DEFAULT;
> +
> +	folio = __folio_alloc(gfp, order, node, &cc->alloc_nmask, aflags);
>  	if (!folio) {
>  		*foliop = NULL;
>  		if (is_pmd_order(order))
> @@ -1687,7 +1696,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		}
>  
>  		page = vm_normal_page(vma, addr, pteval);
> -		if (unlikely(!page) || unlikely(page_is_private_managed(page))) {
> +		if (unlikely(!page) ||
> +		    unlikely(!page_allows_collapse(page, cc->is_khugepaged))) {

I think collapse_scan_file() need something like folio_allows_collapse() check as well.

--Richard

>  			result = SCAN_PAGE_NULL;
>  			goto out_unmap;
>  		}
> -- 
> 2.53.0-Meta
> 
> 
