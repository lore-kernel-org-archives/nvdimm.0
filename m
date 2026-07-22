Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010023.outbound.protection.outlook.com [52.101.56.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CAB273D77;
	Wed, 22 Jul 2026 13:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784727392; cv=fail; b=Z7jK0cbkRcQRg5YrrZJ6yxVdhSsGafcTO2g5m9zZ1UOwOiEd/7UEpk3PVPLSR04vaMkFK2t9RbSC9H3y2zyD3uMlUqbl9ZcRS9YDorWVe9I/rxlHpwXaS3Bx8YCd+488UgxdENAhEcNGhKXT6cQ9OnT451YsbjOc0hRng/U4o1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784727392; c=relaxed/simple;
	bh=zrbC/xR2U9IEbAXnOGvMiLl8TcCIFWtws/tTmKF6NBo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=c8uFQRjSmJHOxOrpuzlYuS1uYwqwR2NLmfi1Rp0mO8WGiOGLoXf+HIHcAYUsm6aDjISN6pvyDeMbdGE313t1uovlXc5Q+yGmDIrNqjffo7Ch9U1so3eKW5G9pJepnEVpiKeJkmZ42Pck6m/5oXWsMvkBby7+QI5xVn/VOoZ+R2E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=m8aTjM95; arc=fail smtp.client-ip=52.101.56.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="m8aTjM95"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wxwcrxfVGhR1SkuBMzC2IyPw0lFFNA2keJG5uZjfuz9iVEDv7HlfHbJlX8qEbCzBONkNGtKEQuo8ncadwxsFbTL5u8AHVBofaIkhA4f8a53hS0HqOD9kHXdD7plteNlck2jkkybUpa7IRymYTWp+82pAjWnV2SNzupeZwUG3xuU+v8g0sdaKQRt5yiVdRl/Fb2xbmS3YLGNPJVtoDbWMS1D6bMpv/J3R/++ZPphc9/FqeE9HxNBsZ6RisuTidG3/D5LO8kY2PwkSILC44S7dIkUxIuEkbbysHRNkRPgv4f2+5Kc+/im9pUAaGiWxW1LvJs1GXq+/jtMH2ZUJYysNVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fRUrYgb8VYs7iMc4cdGBLzB5K5CS4S2zIISeJC5duUA=;
 b=U2l/X0tNZjxwCRzG3EbslDX5GLcbTK9jqMHGOPLF5UkF4twoo7ETG/5jADvKkw70w77P+1GzlosSG3PKk7IcJcyRtRKNver1kq/N7z/7SR/3xMhlv23ueEYIaQGkDi4mtBS0DAAf+es2ju18fBG7BD6GcZ713fEO4h8M7nrvTwkywhD45nD44h0L4f79k/dJP1umhjBLpc29ikpWnJC0u/eYoC3Dny4lP3x2RyJ/j3q/uh2VilBRh9gqzOZRrY8FGa92+CLADyp/2AanlsUYuI3V+Ik9v4s/pSBwwoasZBFhvcFSxiWYFEy5zq4Y0V8nYaKtlQ20DxnPi8xsqj5+gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fRUrYgb8VYs7iMc4cdGBLzB5K5CS4S2zIISeJC5duUA=;
 b=m8aTjM95G3Q2C89GsIxOlVcQyY2rmjPdkiv96r957fgHQ0G0l7ueuU9MMo97On5hTomBwwWA8HCn/ndyqUV+Pkv4BfECQ4u7dCfFbsPp7vm7X8nTT/1cn3htCOS+jwdh/F8fBvM7CuhS4ZE2brhaBhIKZ2xGrn3HUqxoGeNU7d9UzbHugSgPvgthmUkI9h/B1+aDSNCHuYR8buN5ycDkIC+vPWXM2taUMumpLk1cBJ9V7Ka1YQ4669GJsUGezZ96ZzuMkIBFtpW/5tXlTtRf+C+sIfbSjLg9Rk8ELlB5l+W8XOguQHrc/CYbugdRn+of2gA/QOD/XZGBkErdC5xxkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by LV8PR12MB9229.namprd12.prod.outlook.com (2603:10b6:408:191::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 13:36:20 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 13:36:20 +0000
Date: Wed, 22 Jul 2026 21:36:14 +0800
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
Subject: Re: [PATCH v5 26/36] mm: add NODE_PRIVATE_CAP_RECLAIM for opted-in
 private node reclaim
Message-ID: <amDGXU94trqlXUgR@MWDK4CY14F>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-27-gourry@gourry.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720193431.3841992-27-gourry@gourry.net>
X-ClientProxiedBy: TPYP295CA0009.TWNP295.PROD.OUTLOOK.COM (2603:1096:7d0:9::8)
 To BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|LV8PR12MB9229:EE_
X-MS-Office365-Filtering-Correlation-Id: dd6d9e10-abf1-45ad-6f9c-08dee7f6367e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|56012099006|11063799006|10067099003|4143699003|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	xMm+SBtK4TvRLYiK5lZ9uA8zUtf00ay9ltu6jixyHtqgWHzP2R2IBKyTsWn44D2IaxiZ9Ouky1cikrrbxdZxlSOIvh/eUkRhPT3o8H+KuWGWGiJcrebr4WizlcwYcWBqm07r+TWAeEx2QtC5IjQ8W/w3mxOojhSCfbPPjEMWuVrCawQljW80Mco3YJtf0gVOW2FkwzpVrzgJJ82on1slvslEKNuicp2HOC+qruz0beG4QQclP0u7N2ouxx5JOGVgAG2nn3UIMmqLYj+TnFiDY8SOIgYCydHQJYclbnE+8S3KNNnE98VoaYnabK9lbpDd85/uqFZfax65tNDCFmBjG+xxH55tHXcKN17NpDBXCsgmH2QH/7G5VV0DMw8VdbAs9VyjAbazR/csvaM7OVKoOLhHNBKbLD13dj5c77rI4cB1w+Y2wEgRhTZwOFR0Vq5fvEZGFwIKPca2hAAu+XIMJlT0zdlJvgA2TICfZ9gOgO1JDYzOF3kyDvj+W+vdqWIkTyJNljM+fboyH7Xt6Z7/j01l+BZC+lM2jUUjB/58dFcreU3wv3E/i7MMsWcIracMWVXuF2cjqvIGYETVuMipRdZGSzGnfRY4q9fhK/JnxZv0Tb+1Tpkc3Z5UNYbYubdBG+4Z1GiKCw1XixH08QhdPzCWt/XLSWb5CEZJpLjTwOw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(56012099006)(11063799006)(10067099003)(4143699003)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?R+fqMu6uoev+npYl8Y1XmmlbqdqazmGDuzcVIv+BIbowyNTlmPZs/r4etm0i?=
 =?us-ascii?Q?ZrSeJ8dK1792uXtWUgaIRukUhwVOiOJZDOl7EYI4syx9RdDxGHqlpiSRo79L?=
 =?us-ascii?Q?6905anhx7RwhNg+Uu8ebgSo/JRgW31M/TPhUGURgrHcA+liY5geJVbfcWao3?=
 =?us-ascii?Q?20wlgrYkOBxxLpk2vVmaoe+viUvKrIoJfOztdfRm8TTXtGsOLtIrhiUuM1Mg?=
 =?us-ascii?Q?4kRFtthCYez50DSFtsAqIwkkzYYJaZt7da2G/VBPBh9YY7sheRg3U/4egl8J?=
 =?us-ascii?Q?M42KmTnl4xu/Okz8Ms2nHTCxsV8Ihj9HnbgYgTQ0j79BMY6PQRlZdQ6St/Wz?=
 =?us-ascii?Q?M+jN/CComlGfNt+NSSrUdw3XpGLJjLeGbRStqZVeU/d3nCuWhjRLbd/aiZ/j?=
 =?us-ascii?Q?vRpeW9x5IronIeLn5BrO2rvMXDpCzM3vxpo+T8rpks0DOu+br6q9HHJD47t3?=
 =?us-ascii?Q?squwwKUyYAQXpjkoEAd1W/LW2wh1TP/NGzxbAT7uvyNwJuywRc3G1x8KYwfy?=
 =?us-ascii?Q?OBTJZcoBIDR4Fe3HIia47QHrYwyMe8cgCec/mPYXzZKJcB+7ewT6Y5yw/WUE?=
 =?us-ascii?Q?1KEviyQ/gBzdO95npWuT413k66k9xTdX+kRtvgWm+WeiWHWtQWXXVj6iJXhu?=
 =?us-ascii?Q?VdDUGlAusLgdpj2VpASOM9dB90T4Vv137Ipc6Pmbg/MJnnMw002wTzefY8tf?=
 =?us-ascii?Q?yVUv/+klT7sMe/cM2DGq2DTkAR/W/2WI2D+hnyXyk9d3LAXnmuAinziE/3sK?=
 =?us-ascii?Q?oB26bI6RXZQOsgO4sIfhl/UqjXwhICso2UTejhPx4Qiu6eYn/iC8OdoW03tE?=
 =?us-ascii?Q?JP1NXvx+jOrfdh69EgFTfWiO95oog0cf2VRqlFLGtYjKicFwWaUCvO7xeaNj?=
 =?us-ascii?Q?JMDHHOFGCNIX5D+SgfdgVy2vcA8KARPzpOFRrc4gYglhlMC/+nPB6/iN4Us7?=
 =?us-ascii?Q?bP35p6MUofGC1wXnGSdTQ0uKzJ9blcoeML8evh6pWehb9uHjVtbpSlfREBVt?=
 =?us-ascii?Q?c8vRxj291EsqRVZ/tXyuBkQPivnNz7ZU2QrdRZgu852Yhw1SOEhQ6JlHyM67?=
 =?us-ascii?Q?PxGOXnATgxPcw4s1x8aQ77re4kB+kZGdVEaPYernwF0gWLloIo22hXleK93U?=
 =?us-ascii?Q?NsFJgv85tIx/2TZNE8FGhGB4gicpREC+P5vmTm+RxORX3bz1JmNfTEg3rfyn?=
 =?us-ascii?Q?Mk0/DiHwNmd1lN+hkwWcx5yxxdEf/lt9oWDNYQcQ3s4e2vZWGbm7d9v4ca+u?=
 =?us-ascii?Q?ir/7+OoC5/lOQfzyEidrLyh85MYQ5+XsHbXbM8doox8Cvn7dWZLPS4JRJX1A?=
 =?us-ascii?Q?u+hHwm4veLRE0rIMcKdD4/lf34jVFT9RKb//RYjy8CSUNbt0JkT0j2Ah+zx/?=
 =?us-ascii?Q?BvLvlUIsIOIryKLbendUwBisO9u7vvzcaikaJtbAx+q16K7UTxRmabzBzO3n?=
 =?us-ascii?Q?NlkCy4HK1Og3gfCNd4mPRMXCkPz6TMbEnlLRWnOlc5Z/dwJC+0czyRI7zojm?=
 =?us-ascii?Q?quU/XfmFXFuTofw5C9+s79ZkG3GVs8FVpWExExAeXnQApKC2/ho3HGwpsu1N?=
 =?us-ascii?Q?kAs/WKhuze6dCe40/YqR85HYXfLrJVXvbGTiMoURMT99D77EqhLd8BFzg+xf?=
 =?us-ascii?Q?ur4TcIeZLIiGfO7Ws+rvTBTWQSwwOwnUSQWFae9irZ2HB1QPvC/fWw/kBKzL?=
 =?us-ascii?Q?fQ4WkclSTdJinw1D5+m0U6bFgtX/CPjTyJ/W22yP3LAcw4ebEl7Xmtbtmkcy?=
 =?us-ascii?Q?1ivcmchaAw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd6d9e10-abf1-45ad-6f9c-08dee7f6367e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 13:36:19.9085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e0fqRf3EjXwgqm7g6cu3cN1VCHuWkLss/2N61GVLnbHHvfSOBVLDTc/icm6cDJT5VZ8QD4wXU2DuNLoHuer3vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9229

On Mon, Jul 20, 2026 at 03:34:20PM +0800, Gregory Price wrote:
> Provide a mechanism to opt private nodes into the reclaim process.
> 
> Reclaim as a "singular service" is actually made up of:
> 
>    - kswapd reclaim
>    - direct reclaim
>    - kcompactd compaction
>    - direct compaction
>    - both mglru / lru paths
>    - madvise reclaim hints
>    - damon reclaim operations
> 
> CAP_RECLAIM gates whether the kernel may do inter-node placement
> (compaction) or swap for the folios on that private node.
> 
> node_allows_reclaim() encapsulates the policy as a whole.  Ordinary
> nodes are always reclaimable, private nodes only when opted in.
> 
> With the exception of madvise and DAMON, reclaim operations are
> highly integrated with one another, so they are opted in/out of
> together - otherwise reclaim becomes unpredictable.
> 
> To prevent bisect debugging failures, this stays in a single commit.
> 
> For example: reclaim without compaction will OOM on high-order
> allocation failure despite a large amount of free memory. Normally
> compaction would (potentially) resolve this issue.
> 
> If a private node opts into reclaim, we create normal watermarks for
> that node - otherwise pgdat_balanced() is always true and reclaim
> thinks there is no work to do.
> 
> Cross-node operations (demotion, promotion, khugepaged) are NOT
> included in CAP_RECLAIM because some workflows may desire different
> behaviors for this kind of operation:
> 
>    - prefer direct-to-swap, do not demote
>    - remain resident and OOM
>    - __GFP_THISNODE: fail and let the driver augment reclaim
> 
> Normal swap-out is allowed because there are clear userland controls
> (not registering swap, cgroup.swap, etc) to control that per-workload.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  include/linux/node_private.h | 33 +++++++++++++++++++++++++
>  mm/compaction.c              |  9 ++++---
>  mm/damon/paddr.c             |  4 +--
>  mm/huge_memory.c             |  2 +-
>  mm/internal.h                | 13 ++++++++++
>  mm/madvise.c                 |  6 ++---
>  mm/memory_hotplug.c          |  3 +--
>  mm/page_alloc.c              |  2 +-
>  mm/vmscan.c                  | 48 ++++++++++++++++++++++++++++++------
>  9 files changed, 100 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/node_private.h b/include/linux/node_private.h
> index 475496c84249f..f7cbae1309904 100644
> --- a/include/linux/node_private.h
> +++ b/include/linux/node_private.h
> @@ -7,6 +7,13 @@
>  
>  struct page;
>  
> +/*
> + * Per-node service opt-ins (node_private.caps).  A private node is isolated
> + * from all general mm services by default; the registering driver sets these
> + * to let specific services operate on its node.
> + */
> +#define NODE_PRIVATE_CAP_RECLAIM	(1UL << 0)	/* allow mm reclaim */
> +
>  /**
>   * struct node_private - Per-node container for N_MEMORY_PRIVATE nodes
>   *
> @@ -41,6 +48,27 @@ static inline bool node_is_private(int nid)
>  	return node_state(nid, N_MEMORY_PRIVATE);
>  }
>  
> +/**
> + * node_allows_reclaim - may the mm reclaim from this node?
> + * @nid: the node to test
> + *
> + * Only a private node is ever excluded.  Every other node can safely
> + * be operated on by reclaim.
> + */
> +static inline bool node_allows_reclaim(int nid)
> +{
> +	struct node_private *np;
> +	bool ret;
> +
> +	if (!node_state(nid, N_MEMORY_PRIVATE))
> +		return true;
> +	rcu_read_lock();
> +	np = rcu_dereference(NODE_DATA(nid)->node_private);
> +	ret = np && (np->caps & NODE_PRIVATE_CAP_RECLAIM);
> +	rcu_read_unlock();
> +	return ret;
> +}
> +
>  #else /* !CONFIG_NUMA */
>  
>  static inline bool folio_is_private_node(struct folio *folio)
> @@ -58,6 +86,11 @@ static inline bool node_is_private(int nid)
>  	return false;
>  }
>  
> +static inline bool node_allows_reclaim(int nid)
> +{
> +	return true;
> +}
> +
>  #endif /* CONFIG_NUMA */
>  
>  #if defined(CONFIG_NUMA) && defined(CONFIG_MEMORY_HOTPLUG)
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 8c1351cce7bcc..b9c25c599732f 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -25,6 +25,7 @@
>  #include <linux/psi.h>
>  #include <linux/cpuset.h>
>  #include "page_alloc.h"
> +#include <linux/node_private.h>
>  #include "internal.h"
>  
>  #ifdef CONFIG_COMPACTION
> @@ -2462,7 +2463,7 @@ bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
>  		    !__cpuset_zone_allowed(zone, gfp_mask))
>  			continue;
>  
> -		if (node_is_private(zone_to_nid(zone)))
> +		if (!node_allows_reclaim(zone_to_nid(zone)))
>  			continue;
>  
>  		/*
> @@ -2856,7 +2857,7 @@ enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
>  			!__cpuset_zone_allowed(zone, gfp_mask))
>  				continue;
>  
> -		if (node_is_private(zone_to_nid(zone)))
> +		if (!node_allows_reclaim(zone_to_nid(zone)))
>  			continue;
>  
>  		if (prio > MIN_COMPACT_PRIORITY
> @@ -2928,7 +2929,7 @@ static int compact_node(pg_data_t *pgdat, bool proactive)
>  		.proactive_compaction = proactive,
>  	};
>  
> -	if (node_is_private(pgdat->node_id))
> +	if (!node_allows_reclaim(pgdat->node_id))
>  		return 0;
>  
>  	for (zoneid = 0; zoneid < MAX_NR_ZONES; zoneid++) {
> @@ -3026,7 +3027,7 @@ static ssize_t compact_store(struct device *dev,
>  {
>  	int nid = dev->id;
>  
> -	if (node_is_private(nid))
> +	if (!node_allows_reclaim(nid))
>  		return -EINVAL;
>  
>  	if (nid >= 0 && nid < nr_node_ids && node_online(nid)) {
> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index c741a94319750..b668cf55d1b67 100644
> --- a/mm/damon/paddr.c
> +++ b/mm/damon/paddr.c
> @@ -251,8 +251,8 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
>  			continue;
>  		}
>  
> -		/* private node memory is not reclaimable by default */
> -		if (folio_is_private_node(folio))
> +		/* DAMOS pageout is reclaim; gate a private node on CAP_RECLAIM */
> +		if (!node_allows_reclaim(folio_nid(folio)))
>  			goto put_folio;
>  
>  		if (damos_pa_filter_out(s, folio))
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1df91b4e5c2bc..cebc89eb0541f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2340,7 +2340,7 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  
>  	folio = pmd_folio(orig_pmd);
>  
> -	if (folio_is_private_node(folio))
> +	if (!node_allows_reclaim(folio_nid(folio)))
>  		goto out;
>  
>  	/*
> diff --git a/mm/internal.h b/mm/internal.h
> index 85c460296cea1..8329034ae561f 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -110,6 +110,19 @@ static inline bool page_is_private_managed(struct page *page)
>  	return folio_is_private_managed(page_folio(page));
>  }
>  
> +/*
> + * folio_allows_madvise() - may madvise reclaim hints act on this folio?
> + *
> + * madvise reclaim hints (COLD/PAGEOUT/FREE) are userland-driven reclaim, so
> + * they follow reclaim opt-in: false for ZONE_DEVICE and for N_MEMORY_PRIVATE
> + * nodes without CAP_RECLAIM, true for all other normal folios.
> + */
> +static inline bool folio_allows_madvise(struct folio *folio)
> +{
> +	return !folio_is_zone_device(folio) &&
> +	       node_allows_reclaim(folio_nid(folio));
> +}
> +
>  /*
>   * folio_allows_longterm_pin() - may this folio be long-term GUP-pinned?
>   *
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 29f35a23919a0..56ca974542707 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -396,7 +396,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
>  
>  		folio = pmd_folio(orig_pmd);
>  
> -		if (folio_is_private_node(folio))
> +		if (!node_allows_reclaim(folio_nid(folio)))
>  			goto huge_unlock;
>  
>  		/* Do not interfere with other mappings of this folio */
> @@ -478,7 +478,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
>  			continue;
>  
>  		folio = vm_normal_folio(vma, addr, ptent);
> -		if (!folio || folio_is_private_managed(folio))
> +		if (!folio || !folio_allows_madvise(folio))
>  			continue;
>  
>  		/*
> @@ -707,7 +707,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
>  		}
>  
>  		folio = vm_normal_folio(vma, addr, ptent);
> -		if (!folio || folio_is_private_managed(folio))
> +		if (!folio || !folio_allows_madvise(folio))
>  			continue;
>  
>  		/*
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index be230ac9efe5a..1f42ed303366c 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1237,8 +1237,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
>  	/* reinitialise watermarks and update pcp limits */
>  	init_per_zone_wmark_min();
>  
> -	/* Private nodes opt-out of reclaim/compaction by default */
> -	if (!node_is_private(nid)) {
> +	if (node_allows_reclaim(nid)) {
>  		kswapd_run(nid);
>  		kcompactd_run(nid);
>  	}
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2b08bea2379a9..2667a4564b7ac 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6667,7 +6667,7 @@ static void __setup_per_zone_wmarks(void)
>  		u64 tmp;
>  
>  		spin_lock_irqsave(&zone->lock, flags);
> -		if (node_is_private(zone_to_nid(zone))) {
> +		if (!node_allows_reclaim(zone_to_nid(zone))) {
>  			zone->_watermark[WMARK_MIN] = 0;
>  			zone->_watermark[WMARK_LOW] = 0;
>  			zone->_watermark[WMARK_HIGH] = 0;
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 86b2334c23b98..f1722693ac2db 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5396,6 +5396,21 @@ static const struct attribute_group lru_gen_attr_group = {
>   *                          debugfs interface
>   ******************************************************************************/
>  
> +/*
> + * Nodes the lru_gen debugfs interface lists: ordinary memory nodes plus any
> + * N_MEMORY_PRIVATE nodes opted into reclaim.  run_cmd() already accepts the
> + * latter, so keep the listing in sync with what it accepts.
> + */
> +static void lru_gen_seq_nodes(nodemask_t *nodes)
> +{
> +	int nid;
> +
> +	*nodes = node_states[N_MEMORY];
> +	for_each_node_state(nid, N_MEMORY_PRIVATE)
> +		if (node_allows_reclaim(nid))
> +			node_set(nid, *nodes);
> +}
> +
>  static void *lru_gen_seq_start(struct seq_file *m, loff_t *pos)
>  {
>  	struct mem_cgroup *memcg;
> @@ -5407,9 +5422,11 @@ static void *lru_gen_seq_start(struct seq_file *m, loff_t *pos)
>  
>  	memcg = mem_cgroup_iter(NULL, NULL, NULL);
>  	do {
> +		nodemask_t nodes;
>  		int nid;
>  
> -		for_each_node_state(nid, N_MEMORY) {
> +		lru_gen_seq_nodes(&nodes);
> +		for_each_node_mask(nid, nodes) {
>  			if (!nr_to_skip--)
>  				return get_lruvec(memcg, nid);
>  		}
> @@ -5431,16 +5448,18 @@ static void *lru_gen_seq_next(struct seq_file *m, void *v, loff_t *pos)
>  {
>  	int nid = lruvec_pgdat(v)->node_id;
>  	struct mem_cgroup *memcg = lruvec_memcg(v);
> +	nodemask_t nodes;
>  
>  	++*pos;
>  
> -	nid = next_memory_node(nid);
> +	lru_gen_seq_nodes(&nodes);
> +	nid = next_node(nid, nodes);
>  	if (nid == MAX_NUMNODES) {
>  		memcg = mem_cgroup_iter(NULL, memcg, NULL);
>  		if (!memcg)
>  			return NULL;
>  
> -		nid = first_memory_node;
> +		nid = first_node(nodes);
>  	}
>  
>  	return get_lruvec(memcg, nid);
> @@ -5509,10 +5528,12 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
>  	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>  	int nid = lruvec_pgdat(lruvec)->node_id;
>  	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> +	nodemask_t nodes;
>  	DEFINE_MAX_SEQ(lruvec);
>  	DEFINE_MIN_SEQ(lruvec);
>  
> -	if (nid == first_memory_node) {
> +	lru_gen_seq_nodes(&nodes);
> +	if (nid == first_node(nodes)) {
>  		const char *path = memcg ? m->private : "";
>  
>  #ifdef CONFIG_MEMCG
> @@ -5612,7 +5633,9 @@ static int run_cmd(char cmd, u64 memcg_id, int nid, unsigned long seq,
>  	int err = -EINVAL;
>  	struct mem_cgroup *memcg = NULL;
>  
> -	if (nid < 0 || nid >= MAX_NUMNODES || !node_state(nid, N_MEMORY))
> +	if (nid < 0 || nid >= MAX_NUMNODES ||
> +	    !(node_state(nid, N_MEMORY) ||
> +	      (node_is_private(nid) && node_allows_reclaim(nid))))
>  		return -EINVAL;
>  
>  	if (!mem_cgroup_disabled()) {
> @@ -6145,7 +6168,7 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
>  	 * Private nodes do not support reclaim by default, filtering here
>  	 * captures all normal reclaim paths that may attempt eviction.
>  	 */
> -	if (node_is_private(pgdat->node_id))
> +	if (!node_allows_reclaim(pgdat->node_id))
>  		return;
>  
>  	if ((lru_gen_enabled() || lru_gen_switching()) && root_reclaim(sc)) {
> @@ -6758,6 +6781,16 @@ unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
>  	return sc.nr_reclaimed;
>  }
>  
> +static struct zonelist *memcg_reclaim_zonelist(int nid, gfp_t gfp_mask)
> +{
> +	unsigned int aflags = ALLOC_DEFAULT;
> +
> +	if (unlikely(!nodes_empty(node_states[N_MEMORY_PRIVATE])))
> +		aflags = ALLOC_ZONELIST_PRIVATE;
> +
> +	return select_zonelist(nid, gfp_mask, aflags);
> +}


I applied this code change and notice in mem_cgroup_shrink_node(), it calls
shrink_lruvec() directly and never passes through shrink_node().

This patch makes private nodes reachable through memcg reclaim zonelist, but
what prevents the direct per-node memcg path from reclaiming a private node
that has not set NODE_PRIVATE_CAP_RECLAIM ?

--Richard


> +
>  unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
>  					   unsigned long nr_pages,
>  					   gfp_t gfp_mask,
> @@ -6784,7 +6817,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
>  	 * equal pressure on all the nodes. This is based on the assumption that
>  	 * the reclaim does not bail out early.
>  	 */
> -	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
> +	struct zonelist *zonelist = memcg_reclaim_zonelist(numa_node_id(),
> +							   sc.gfp_mask);
>  
>  	set_task_reclaim_state(current, &sc.reclaim_state);
>  	trace_mm_vmscan_memcg_reclaim_begin(sc.gfp_mask, 0, memcg);
> -- 
> 2.53.0-Meta
> 
> 
