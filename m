Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010054.outbound.protection.outlook.com [52.101.201.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8730B2DECCC;
	Wed, 22 Jul 2026 13:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784725270; cv=fail; b=tgjoZkwEboesfKcTQ0c0Rt+FedAM46bK9Iiw6GsoWmkWbhWR6GM5VrXVVmbGa58969yFE0B1IMqUVVrFG2LqlAe40Kg8R19ZxBXOToaedHYc40a5NwMtC3dsPT/1UcFXCCQnz3UqkIKT8AsamBz+r3A6obuQB568vGjST6ZVRKg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784725270; c=relaxed/simple;
	bh=pnTQ/h9Rn34GU5pFqWz4+K2odcfqixF8JaVqkmxT5fo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Fi1en48u1MmGeOEkiyRg7VpOxTMIfklwQSlQEN1TUSfi2wwlbBSoq+/T39FNI/YiETW+otjVfRpyvJYFJxWlSfbiptr8ycVyfP53MGTKueQgKwNHvK49zTzRGa0PUL5CS0j2r3Xr7yy7u76KYFxfLYMcZrRALs56YnsVfpPhr1w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NCr1Jisa; arc=fail smtp.client-ip=52.101.201.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NCr1Jisa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bmKGgpcgxs7mSUmzOoOdFDxqRRdbQtNqovH7fpPjWUqC4/hgBElm0iGEc7OisyqnxG5G8OPWkYzCWf2eUDQYYOniVxbslUG4+LqTfkQm384N9sY9yeUvX3te457DKe68kAUoPyRs8dUQgqHxwJUJUmZ/Ydm8lyOrRVT723ZChOmb3UNAL739eMGwxRapusmsmg2ou6dmWBZpG18k0KQfBprmxR47oEOOrAjMdu7FXwkfo8BX5HQ6yuTYKmNICzO0L2yC3PYbjhscp8GGLseW71Bgff5ZgARp3Sae1gb/urTWW6CuMcwRovmdY6hNQ6hZBp6j0NcT1UljEAg55566hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J22OGt754po96ILhiMAF8BemjRnwohYU6INaixLo0sU=;
 b=YNXXT4QtsM1OVThzLti8/RypUteCNWciAo9jIP5+i5vU1142ERjNEwSCJ36OXaYGE5GetjfQvdqCvQuj1mtDZYM0HTa8tXRdFsdRyEKmvHvp3m8TyXhg3exMeJwdOy6+CZx+OK2tja1JmiPiDLfCltfmbE+lWfEIV4Sw4lshk3lZfO0rBdZ89irKY4lC+xcTNtkCYnbG2lCNLJagIW8sJ7Q9A3dYsv8uLDxe08qowMr/vcjH0Qt38qzvf4I4OYo6X3K898412TJu5Lx2Y7xY1P7HFS5oHbNvUEGpWe+GpLdUpeAluzNg/lXrGXFZALHjkPIt5NPDpmUKmBS5YzU3yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J22OGt754po96ILhiMAF8BemjRnwohYU6INaixLo0sU=;
 b=NCr1JisavmE3bLwE54FCoz7OAUOCCuOHJVFqluuE1/E+0VJ2pt0Fk+G17H2Rbzca1g2+OqxarmVol8xRiMuyUvR42HhiekOqwz7DYPPEtUDW7sfdH1Gcxe+koJDyfyWiJ5j6o/TpfeK1NtppxtmuvyawdOBvyoin8p8wmbVPlTpqDFfHjzKOrdlSmXv0HfvmOwrvlUyTDaZ4KWr+0WuNj19MgiVDh3krBGSd7sJc/zY/++kc89dU/wDvt/Y+SmyyGXFwHixvWmhZ+g76oeVeI+IyXADVmFd6rTrm+ta0MzzLj4LC3veylNEg0Q8+eln1AZQdTJiF5VwCNdEyAQH3Xg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by IA0PR12MB7774.namprd12.prod.outlook.com (2603:10b6:208:430::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 13:00:58 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 13:00:58 +0000
Date: Wed, 22 Jul 2026 21:00:51 +0800
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
Subject: Re: [PATCH v5 05/36] mm: add ZONELIST_PRIVATE(_NOFALLBACK) for
 N_MEMORY_PRIVATE nodes.
Message-ID: <amC-b5SIkxUCKQ7H@MWDK4CY14F>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-6-gourry@gourry.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720193431.3841992-6-gourry@gourry.net>
X-ClientProxiedBy: TPYP295CA0048.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:8::14) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|IA0PR12MB7774:EE_
X-MS-Office365-Filtering-Correlation-Id: b4aeb79b-32af-4269-dec6-08dee7f145df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|22082099003|6133799003|11063799006|10067099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	NW2kWbQtCiIJjrUemaKUrOZP4DT4qZDnzMAxoHXb7kZ+x2YjYfwpTChOotdiT1WKTwkeWQ0Oml7RO0h3CBpoEmvT2/tu+TQl3/hzIbsdsyfEQImDQXxAcpQgZR12nLB5kTBjMvM9/mHz9lFf7B8cggIzWR1YQGQip8AokUhjwmnDpqgCAmg4QXI6VVFV0aqNRn0ACoVSBQO/9NOjWtHCVfASUexZ65APOD8c/vqOp1PUcIYIkjd076RlUKdTLL1rA67IzjzjffPRIBgE67W6xU3YKBNJ0bFrkCZq2693y+KZHnLZNJkZA22PUrbCkyByPjNZGpwFNKpaoc0OMWpndiopegBayEW9QGvODGC6WfIE8q4cIIonac0XONMKKZ4QRskWHatZFySyLb+1RxZqUWICViLNGPwpehGd2Z/GiS7++9CybkwyyVbzOjuSwpGnSjC2XOYIeAAlLKMGnBIA36HDJSZLbeKuV8+j5Jxwio2ISxUpmt4O2HCbymsabzfz70wy25CRWbkLpFyAvQVcqsXNUTMiBTh3DD11hUjK83wkFQ/OueE92U1D7Sd5/Sxb6A3rEL9f+chGmqZrcSB0rqXoQXwvglw4bECjLgaWmxwxDxnP1qXlgakvZXYDQtj/DvQxBd5CVF4NcC7lOyGKUxUit9/WnTI/VaH3uQK8578=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(22082099003)(6133799003)(11063799006)(10067099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U2I/CjEcoq5WYtyWZg3dlCxcxnYqJaUnpesyQDH6JqIVaoU+X1HFZFOPnXCz?=
 =?us-ascii?Q?JA8VrjhcGbLHzxqTSx/+it7yjH1+zgf/rt6mDazcZn84fKMSaYoxSM+xXohe?=
 =?us-ascii?Q?IvY5Vdwy4RI9a+BfqHG44uk7/u5z5jaETM07vSDwLrcnHHTQ/H7Trsfpwdrt?=
 =?us-ascii?Q?jDaFKZT+PQjAHdJOjok4fuEwB6eut6Dts5cNczXvY/TPf6xfUU5EhAdpeKdL?=
 =?us-ascii?Q?mX7iRNDUQhKN1KfBFHO3iv8FUO3ZzJ7QcVi5AF6ltvjm86RLIGYHKdcW8ImZ?=
 =?us-ascii?Q?6V93kJoYcLjZvN/tbZkKXuGGcN4cdH7tNIyuWxVSdzX67GPLB/sEj9yV1rAs?=
 =?us-ascii?Q?XzPTX4RYPmmVwd/g22TNnOAenmTvugO2NDasVEAHcDSKFBGdFGzd/n9tEQgI?=
 =?us-ascii?Q?Z0PA4fb5p1OoCYCj5Hm/LobQFLMdfKSZLZ1MN4UCfA78TEMISVv57NFDmVy6?=
 =?us-ascii?Q?gHdW3fZyXpd+PSaCfLARJO710BimXCSrqk6JVdzketi3GvF1l6viCT/3LqEM?=
 =?us-ascii?Q?jKAjXSCs5K1bCqMJBApHQZx42RDguoIlmw5N3huLSbKgzQzx9+DNMlsdgdFY?=
 =?us-ascii?Q?TZScRkauhBObCWaymQIk+AofwJuKnugDdDFAkzwIPDr9ltP3wwCsC9Z+qf9G?=
 =?us-ascii?Q?pxMgGb+kU6peOEpgu2sE6tsDxIl1U/ki05qVXbTH92/jji93vGozWttHMlzb?=
 =?us-ascii?Q?iBV335GIxnnONSWW07b2moQH5ldIQG8oT1o90XF0SLGUrrAfHEydHIpvEDRX?=
 =?us-ascii?Q?WIC9NzeYbaZEGWlnKafwv0Z8o79Y8d2S15QZkCWmOcbAjkv/7HlmPPQm+sly?=
 =?us-ascii?Q?06edKErSru8Ex4Ly3kknPs/o2Z3BiCkXf2kedparJMb3IKRDv/+WPqDzdrtO?=
 =?us-ascii?Q?PLpNKPrXhqjes0BORrqTElq0f3ImHUTF622rabeteHUWPeECf52FOIEndLdE?=
 =?us-ascii?Q?quRjjFvLOmymyiBhzIjAdWEziSxiS5wOCuwxNM2RaEFeKVfZ7xnUVgKmK89f?=
 =?us-ascii?Q?1L0d6yca5h8hlGB6x5tbCo8SEaw1r67rPumTMU0uFnH6A4rXZ4rh4AVGQHR0?=
 =?us-ascii?Q?ou34NQHUNDq3MMMfoEmB/9QvVaGNFdRmuRxOsMerR1Lx4IbmtqaoZ3QyHuyf?=
 =?us-ascii?Q?lV1MdKGSwozCnOLa6jnOIXEI4aZwZjbhnlxCC1j0nbr+lBijuImQDe0w0aDf?=
 =?us-ascii?Q?f6pAbbJC6XaQgEv5GIeEuWlyvMYQlGr47+V2/5Xol4honDIU2eU8hthXtT3x?=
 =?us-ascii?Q?D8f+fminyZOiMHMfRNiivXF19O+qROo+phnFh/gj/dr8TzZRUAN5tUVc8Hrh?=
 =?us-ascii?Q?fMVG8Orhng1g+J1VPnhP+SVH4KHNj3tpu/zBqt98Y/Vv0dhwvcW2N+tKHAX0?=
 =?us-ascii?Q?CQ/YSD5TWmzGKHdiU0X1ih/g2S7MfBpSWIOmHKM+RYvCTtzr+edAJ2D51Xl+?=
 =?us-ascii?Q?vp+oWu/esXG+Yabsd8OIlhefnGh3E+T9bPTH+Wgky3jcCYm4kHX3WCsYw8Kp?=
 =?us-ascii?Q?yIqnwMdsHzChoPdAnnuvo6m0CIFkLIFqnw2uReH2LqSPZOs4OUdCFpgLjwHg?=
 =?us-ascii?Q?41iIvW6yRStHY2Kq9WzirIX0SqNbWXo8hrMs+2Zw1KbGAE5BXAByuBhAIFcm?=
 =?us-ascii?Q?m+/gNcoo47zmp44N5QhL4vROIw5SDxb4DmeDffrJg4k1aRCpedyOYqn8EDam?=
 =?us-ascii?Q?ctXyYNH89edAPn2QkHES15IEHcH/Qc4fUtSCHRK4QNu3H7mjroEIk/Y8OEQ6?=
 =?us-ascii?Q?FJ0rG5EyCA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4aeb79b-32af-4269-dec6-08dee7f145df
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 13:00:58.2335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: djPtoZFCsyEANyckxBN7ZJih1vfbZWLcVU4gG0Dxx7JEViMWWsinekyhM4RKUIzsfUOHA/p8YyfbfSRnUPA5yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7774

On Mon, Jul 20, 2026 at 03:33:59PM +0800, Gregory Price wrote:
> N_MEMORY_PRIVATE nodes must be invisible to ordinary allocation,
> no allocations may reach one unless explicitly called for.
> 
> Make this isolation structural in the zonelists: N_MEMORY_PRIVATE
> nodes are excluded from FALLBACK and NOFALLBACK entirely, making
> them effectively invisible to all normal callers of page_alloc.
> 
> Add ZONELIST_PRIVATE, which spans (N_MEMORY | N_MEMORY_PRIVATE).
> When !CONFIG_NUMA, it aliases ZONELIST_FALLBACK and compiles out.
> 
> Add ZONELIST_PRIVATE_NOFALLBACK as the __GFP_THISNODE target for
> private node allocations.
> 
> Zonelist selection rides the allocator's alloc_flags.  Add
> ALLOC_ZONELIST_PRIVATE and resolve it in select_zonelist(), which
> prepare_alloc_pages() applies from ac->alloc_flags; the default
> (ALLOC_DEFAULT) keeps node_zonelist()'s gfp-based selection.
> 
> Add explicit private-node alloc() functions to prevent open-coding
> (both ride ALLOC_ZONELIST_PRIVATE through the alloc_flags-carrying
> entry points):
>    - alloc_pages_node_private_noprof()
>    - folio_alloc_node_private_noprof()
> 
> alloc_contig_range adds an explicit node_is_private() guard because
> it dervices its target zones from PFNs rather than zonelists. All
> in-tree callers use N_MEMORY ranges, but the check prevents future
> callers from violating node isolation.
> 
> Important note:  By design this zonelist isolates N_MEMORY_PRIVATE
> from unintentional allocations, but does NOT isolate private-node
> allocations from falling back to non-private nodes.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  include/linux/gfp.h    | 11 ++++++++
>  include/linux/mmzone.h | 11 +++++++-
>  mm/mm_init.c           |  2 +-
>  mm/page_alloc.c        | 64 ++++++++++++++++++++++++++++++++++++++++--
>  mm/page_alloc.h        | 26 +++++++++++++++++
>  5 files changed, 109 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index a327e58c313f8..f3e867de744f6 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -204,6 +204,17 @@ static inline void arch_free_page(struct page *page, int order) { }
>  static inline void arch_alloc_page(struct page *page, int order) { }
>  #endif
>  
> +/* Allocate from an N_MEMORY_PRIVATE node (selects the private zonelist). */
> +struct page *alloc_pages_node_private_noprof(gfp_t gfp, unsigned int order,
> +		int nid);
> +#define alloc_pages_node_private(...)				\
> +	alloc_hooks(alloc_pages_node_private_noprof(__VA_ARGS__))
> +
> +struct folio *folio_alloc_node_private_noprof(gfp_t gfp, unsigned int order,
> +		int nid);
> +#define folio_alloc_node_private(...)				\
> +	alloc_hooks(folio_alloc_node_private_noprof(__VA_ARGS__))
> +
>  unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  				nodemask_t *nodemask, int nr_pages,
>  				struct page **page_array);
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 9815e48c03b97..654c5111f7cec 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1392,13 +1392,22 @@ enum {
>  #ifdef CONFIG_NUMA
>  	/*
>  	 * The NUMA zonelists are doubled because we need zonelists that
> -	 * restrict the allocations to a single node for __GFP_THISNODE.
> +	 * restrict the allocations to a single node for __GFP_THISNODE
> +	 * and N_MEMORY_PRIVATE nodes (isolated from default lists).
>  	 */
>  	ZONELIST_NOFALLBACK,	/* zonelist without fallback (__GFP_THISNODE) */
> +	ZONELIST_PRIVATE,	/* N_MEMORY_PRIVATE access, falls back to DRAM */
> +	ZONELIST_PRIVATE_NOFALLBACK, /* N_MEMORY_PRIVATE access, __GFP_THISNODE */
>  #endif
>  	MAX_ZONELISTS
>  };
>  
> +#ifndef CONFIG_NUMA
> +/* Without NUMA only ZONELIST_FALLBACK exists so everything collapses there */
> +#define ZONELIST_PRIVATE		ZONELIST_FALLBACK
> +#define ZONELIST_PRIVATE_NOFALLBACK	ZONELIST_FALLBACK
> +#endif
> +
>  /*
>   * This struct contains information about a zone in a zonelist. It is stored
>   * here to avoid dereferences into large structures and lookups of tables
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 711f821f7b3c7..adb50647d29ca 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2701,7 +2701,7 @@ void __init mm_core_init(void)
>  	init_zero_page_pfn();
>  
>  	/* Initializations relying on SMP setup */
> -	BUILD_BUG_ON(MAX_ZONELISTS > 2);
> +	BUILD_BUG_ON(MAX_ZONELISTS > 4);
>  	build_all_zonelists(NULL);
>  	page_alloc_init_cpuhp();
>  	alloc_tag_sec_init();
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index aa35bbe5d4c3e..78755a55b1540 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5040,7 +5040,7 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
>  		unsigned int *alloc_flags)
>  {
>  	ac->highest_zoneidx = gfp_zone(gfp_mask);
> -	ac->zonelist = node_zonelist(preferred_nid, gfp_mask);
> +	ac->zonelist = select_zonelist(preferred_nid, gfp_mask, ac->alloc_flags);
>  	ac->nodemask = nodemask;
>  	ac->migratetype = gfp_migratetype(gfp_mask);
>  
> @@ -5346,7 +5346,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
>  	unsigned int fastpath_alloc_flags = alloc_flags;
>  
>  	/* Other flags could be supported later if needed. */
> -	if (WARN_ON(alloc_flags & ~(ALLOC_NOLOCK | ALLOC_NO_CODETAG)))
> +	if (WARN_ON(alloc_flags & ~(ALLOC_NOLOCK | ALLOC_NO_CODETAG | ALLOC_ZONELIST_PRIVATE)))
>  		return NULL;
>  
>  	if (!alloc_order_allowed(gfp, order, alloc_flags))
> @@ -5457,6 +5457,22 @@ struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
>  }
>  EXPORT_SYMBOL(__folio_alloc_node_noprof);
>  
> +struct page *alloc_pages_node_private_noprof(gfp_t gfp, unsigned int order,
> +		int nid)
> +{
> +	return __alloc_pages_noprof(gfp, order, nid, NULL,
> +				   ALLOC_ZONELIST_PRIVATE);
> +}
> +EXPORT_SYMBOL_GPL(alloc_pages_node_private_noprof);
> +
> +struct folio *folio_alloc_node_private_noprof(gfp_t gfp, unsigned int order,
> +		int nid)
> +{
> +	return __folio_alloc_noprof(gfp, order, nid, NULL,
> +				   ALLOC_ZONELIST_PRIVATE);
> +}
> +EXPORT_SYMBOL_GPL(folio_alloc_node_private_noprof);
> +
>  /*
>   * Common helper functions. Never use with __GFP_HIGHMEM because the returned
>   * address cannot represent highmem pages. Use alloc_pages and then kmap if
> @@ -5854,9 +5870,21 @@ static void build_zonelists_in_node_order(pg_data_t *pgdat, int *node_order,
>  static void build_thisnode_zonelists(pg_data_t *pgdat)
>  {
>  	struct zoneref *zonerefs;
> -	int nr_zones;
> +	int nr_zones = 0;
>  
> +	/*
> +	 * NOFALLBACK: the node's own zones. EMPTY for private nodes so a
> +	 * stray __GFP_THISNODE allocation can't violate isolation.
> +	 */
>  	zonerefs = pgdat->node_zonelists[ZONELIST_NOFALLBACK]._zonerefs;
> +	if (!node_is_private(pgdat->node_id))
> +		nr_zones = build_zonerefs_node(pgdat, zonerefs);
> +	zonerefs += nr_zones;
> +	zonerefs->zone = NULL;
> +	zonerefs->zone_idx = 0;
> +
> +	/* PRIVATE_NOFALLBACK: the node's own zones, private nodes included. */
> +	zonerefs = pgdat->node_zonelists[ZONELIST_PRIVATE_NOFALLBACK]._zonerefs;
>  	nr_zones = build_zonerefs_node(pgdat, zonerefs);
>  	zonerefs += nr_zones;
>  	zonerefs->zone = NULL;
> @@ -5899,11 +5927,28 @@ static void build_node_zonelist(pg_data_t *pgdat, const nodemask_t *candidates,
>  static void build_zonelists(pg_data_t *pgdat)
>  {
>  	static int node_order[MAX_NUMNODES];
> +	nodemask_t tier_nodes;
>  	int local_node = pgdat->node_id;
>  	int node, nr_nodes = 0;
>  
>  	memset(node_order, 0, sizeof(node_order));
>  
> +	/*
> +	 * Zonelists: FALLBACK, NOFALLBACK, PRIVATE
> +	 *
> +	 * FALLBACK:   Allocation order for all nodes.  Private nodes have lists
> +	 *             but never appear as an entry in any list. Allocations
> +	 *             targeting a private node w/ FALLBACK land on N_MEMORY.
> +	 *
> +	 * NOFALLBACK: A list for each node containing only itself.
> +	 *             Allocations targeting a private node w/ NOFALLBACK
> +	 *             will always fail (their NOFALLBACK is empty)
> +	 *
> +	 * PRIVATE:    (N_MEMORY | N_MEMORY_PRIVATE) - allows access to
> +	 *             private nodes, and falls back to normal memory unless
> +	 *             __GFP_THISNODE otherwise constrains it.
> +	 */
> +
>  	build_node_zonelist(pgdat, &node_states[N_MEMORY], ZONELIST_FALLBACK,
>  			    true, node_order, &nr_nodes);
>  	build_thisnode_zonelists(pgdat);
> @@ -5912,6 +5957,10 @@ static void build_zonelists(pg_data_t *pgdat)
>  	for (node = 0; node < nr_nodes; node++)
>  		pr_cont("%d ", node_order[node]);
>  	pr_cont("\n");
> +
> +	nodes_or(tier_nodes, node_states[N_MEMORY], node_states[N_MEMORY_PRIVATE]);

Hi Gregory,

A question about this part, if my understanding is right,
ZONELIST_PRIVATE contains all private nodes, should we use some explicit target
nodemask here to make sure only the targeting owner's private node can be touched?

Otherwise it might fall back into a different owner's private node.

--Richard

> +	build_node_zonelist(pgdat, &tier_nodes, ZONELIST_PRIVATE, false,
> +			    node_order, &nr_nodes);
>  }
>  
>  #ifdef CONFIG_HAVE_MEMORYLESS_NODES
> @@ -7282,6 +7331,15 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
>  	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
>  		return -EINVAL;
>  
> +	/*
> +	 * Private nodes are kept unreachable via the zonelists, but
> +	 * alloc_contig works directly on a zone derived from the caller's
> +	 * pfn range, bypassing that.  Reject this operation explicitly
> +	 * rather than silently carving memory out of an isolated node.
> +	 */
> +	if (unlikely(node_is_private(zone_to_nid(cc.zone))))
> +		return -EBUSY;
> +
>  	/*
>  	 * What we do here is we mark all pageblocks in range as
>  	 * MIGRATE_ISOLATE.  Because pageblock and max order pages may
> diff --git a/mm/page_alloc.h b/mm/page_alloc.h
> index 23fc79ce97b60..741448d83ce77 100644
> --- a/mm/page_alloc.h
> +++ b/mm/page_alloc.h
> @@ -57,6 +57,9 @@
>   */
>  #define ALLOC_NO_CODETAG       0x1000
>  
> +/* Select the N_MEMORY_PRIVATE zonelist family (see select_zonelist()). */
> +#define ALLOC_ZONELIST_PRIVATE 0x2000
> +
>  /* Flags that allow allocations below the min watermark. */
>  #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
>  
> @@ -95,6 +98,29 @@ struct alloc_context {
>  	unsigned int alloc_flags;
>  };
>  
> +#ifdef CONFIG_NUMA
> +static_assert(ZONELIST_PRIVATE + 1 == ZONELIST_PRIVATE_NOFALLBACK);
> +#endif
> +
> +/*
> + * select_zonelist - resolve the zonelist for an allocation
> + *
> + * The default matches node_zonelist(); ALLOC_ZONELIST_PRIVATE selects the
> + * private-node family so an allocation may reach an N_MEMORY_PRIVATE node.
> + */
> +static inline struct zonelist *
> +select_zonelist(int nid, gfp_t gfp, unsigned int alloc_flags)
> +{
> +#ifdef CONFIG_NUMA
> +	if (alloc_flags & ALLOC_ZONELIST_PRIVATE) {
> +		int idx = ZONELIST_PRIVATE + !!(gfp & __GFP_THISNODE);
> +
> +		return &NODE_DATA(nid)->node_zonelists[idx];
> +	}
> +#endif
> +	return node_zonelist(nid, gfp);
> +}
> +
>  /*
>   * This function returns the order of a free page in the buddy system. In
>   * general, page_zone(page)->lock must be held by the caller to prevent the
> -- 
> 2.53.0-Meta
> 
> 
