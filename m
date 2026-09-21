Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010027.outbound.protection.outlook.com [52.101.193.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF8F3793CB
	for <nvdimm@lists.linux.dev>; Mon, 21 Sep 2026 06:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789973078; cv=fail; b=Ig+UZGRX6ibCk6mUvCrL9l5r3OGC/cMgPqaNDVFIskMcrsH9NycJBVQpGhF7BgZOTLUmOyms5BI9djPTMSr3s+S7dTBFTbLOfs1nCrzgH3xbkIwuwYxr396IS+dDvCntT2EelICLeeZ2tz66DVEEgOHm2MLxvkynd2173uUbB/g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789973078; c=relaxed/simple;
	bh=a2vC1mAjxwONjskG4q4+dF5ztNQKpY+mxAIa5OZVnAo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=auzSKR4Wbh+zTdInaEhqicoHHO6Lr0cBqtVuE6ZlByMdrLLH5oBfSIYMhXZyN15pmtNOtu3WL2GYCmzUn5bHtzbbNS5zCl3nVaydtNv06x6Pv8u3V5JuLckIk0DT41JMjZxE2vAHD3G1OQx8lvpbPz5QR98YA8w/qV1T4ZYu0c8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1s7rf+Tz; arc=fail smtp.client-ip=52.101.193.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1s7rf+Tz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nH3WGC1hCSjDrIafUVxYh5352DxFaJHrjvfVZnIuwxbGZ69XSyRceMue98psMDwRjfQXN/9pJqCX1uBgYZw1pNqJxnm+ge0tkhquSUF9xQdew5SDXoccae0gGbRkUaZGDdAFHkeSDoL9n1/Pz1IxxOgOvYNxZQ0QhgV3cSYAxGyOTV+humiY1D2nMStx+C/+qONoiNTGp98jINR9Tm8c39E2oS/t5/ljJiYh5AQLT9dBwcGA9VscloatCXvVPSClKv8Xy0hc7ETXuDc3o22MqaIOOxnMpE11gBOEKyoV76dyoRkYfG6J+nSLc6/e3/In07kuziO2GiNKd/XxQN2xOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PdpysiQkkF+ZDaHOZ8s3pxtlduJHt9g2tn7NQYH6TAc=;
 b=lU/jLytWEtPdoj5z5y1jSl1wgxlGVytBNoMu0/t/Hjz0sYAd2m9pMnqfYSetyxaE0SKZiplhoKAj605Pbb6dwzt+bIosO0229hEwvVFfOrCy7z6aI2ydx8fpH0tq+KB+qz+ghnBycY9SBVkSmhtc8Ci7dwcZmG3F8wZITGMv4iISr2jFwwEK0n7dHONI0beatwB/F0/B3om5/SrO/hWcw2iSBa5DI1cogawkEeBIOcJ+bOW7YNOTMs83OuDzO+qgfj0VnHPx5Ru3m3L85+P2fKtZ+X/lz8c1WlzWi21zTue/Bw2q8nJCje41TaMU5sIpg9TvF2gbxaxylyiJ5oSS/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PdpysiQkkF+ZDaHOZ8s3pxtlduJHt9g2tn7NQYH6TAc=;
 b=1s7rf+TzWVDCcZ6o9iuvsMNkRETFaZDaNPeCnp4RqU3h5uynf3Cas5jVoGoUzKY+KsxP+Xw1vH2srG6Tjj7qaS4HsGTF9b0KClQLdY9B6G9yrLfgRnbrEJu2+Wd8UqO6uhQD1ev56ajS74Baa3Srw+kxM2CB1I1o7B79xYt7niE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB7771.namprd12.prod.outlook.com (2603:10b6:8:138::6) by
 DS6PR12MB095541.namprd12.prod.outlook.com (2603:10b6:8:498::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 06:42:31 +0000
Received: from DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c]) by DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c%4]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 06:42:31 +0000
Message-ID: <4bc1f4de-40ad-46f0-8d37-4c4e0cad0ad6@amd.com>
Date: Mon, 21 Sep 2026 08:42:19 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm: add shared read-only vmemmap support for FS-DAX
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Dan Williams <djbw@kernel.org>,
 David Hildenbrand <david@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-cxl@vger.kernel.org,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Mike Rapoport <rppt@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Ira Weiny <iweiny@kernel.org>, Jan Kara <jack@suse.cz>,
 Matthew Wilcox <willy@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Qi Zheng <qi.zheng@linux.dev>, muchun.song@linux.dev
References: <20260903122128.12264-1-songmuchun@bytedance.com>
 <20260903122128.12264-4-songmuchun@bytedance.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20260903122128.12264-4-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0177.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1a9::15) To DS0PR12MB7771.namprd12.prod.outlook.com
 (2603:10b6:8:138::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7771:EE_|DS6PR12MB095541:EE_
X-MS-Office365-Filtering-Correlation-Id: 478a7231-060f-47cc-d549-08df17ab82ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|6133799003|11063799006|10067099003|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	X3j7rxwYapO06Foz3i+/Ogytv80OZhBxLX9sgKByL/uzUc64944fblT/+p/WYpCwXGHxGLiDKTTDF+UkuFdGUJKlai1n12f0Kbpy6K/lYjcb/95uG00EbFWHw3+HcKZ+Z2DdHS5rXYauzyXr12ZpPy3tSykIxFsLqJjcrfqWqxUu2zeXttyh0kzWVV70ZlbxwKOKOyPkDXGuiRsSozYlrek5uGGWMZqEX9NkZqNNfDriMhS/iFlhrbIQCOCeBIclZduGljuBPkHJSUWRSQ1fO2lWZJMjoL8JYoF0hxaXE0b6hRRog2lft/HYVIgnm2NR6MhV7qWU6ijx/PrkGTKWIFwNGT9IHCpkFpZX2pKIELCCczGl9tsjK+uahNFrv4YaCHjaoSta6d9Ry3hqyAcnFgVy0WGRmv8Jqptp6F62+Dfr8Zgoq09WpCcW5LIeArro/2T6ievrS8SPKLj7cbH54DULydV5UW5j5h1ZXt+aUCqsp3PKjKpOybbv37InsKZqLUyPehX65w1dyzZbP4JwN4V2B3dP89q/li4h8QvYgxbeDNvHh/K5fBipYEUsh6uykibS+YVSp/rZOs4Ch/n5jQ83y03SfbpirFAVdsQFZeaWEyjM/yR+iN0I88FbdmNs65cCLSTfEVPXy7hJR+kkVYCp/9t1x8cijFuasN8izbQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7771.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(6133799003)(11063799006)(10067099003)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VXJWempFUWJRQmdEcGxLUzkrZk5HK21JRHhpVjR1ZEMrczhWOG9wSUc3VjQw?=
 =?utf-8?B?dEJPUkFBbENTbWtFSGlBd0QyTzFNanpaSkpBK092Z0lCNWZjaFcxSUkrOHJV?=
 =?utf-8?B?N1Y4QVc4OXQrc2E1aTVWbWZZSFF0cit5dVA3OFNzaDhzNVpyTWZxT3BoRkR1?=
 =?utf-8?B?N2xQMHZ5VVFEMTQ3cXA4SXk5OTNEOE9BcmdWZC83SXVCajFSUy9wd243MVh3?=
 =?utf-8?B?OHdMMHpwNUxNblhOcHVjbFBkY0hPVkVwM2pyaWhYR1NrQThWUGxycVMxSDRZ?=
 =?utf-8?B?NHdZWUZHdjFkRXJYN0NxdlhzQ1dLbS9WcHJKZGNNRUgrSXJjUXlqd1ZjNEdi?=
 =?utf-8?B?SlNyeHJneEUzUFptUDZ5czc0Qk5lTC85UHZ3bWF1RFV3WjFwZ3dQdE1CVVdv?=
 =?utf-8?B?aG1YR29LWUVJOThOQnFZMVA5YlRaVExKT0hlSkJLQTh0K0FFbHdVRE42VW1U?=
 =?utf-8?B?Mkh3WHFLL3Z2ZFlQWVlWdnVNOTFJbndVT08vRUlLdzNDRmNFMi85bHl3V01V?=
 =?utf-8?B?eW5qMEZzcko1ZTdwaEJubURBWU01blcrY2E1Y2plSDJxS2FWbFd4a2tTY1Ur?=
 =?utf-8?B?V0tLWktIZ0hSWEN0U09yT3JaSE4vODJLeVZ4NDdOUUJVSEsyekJqcGpObzJw?=
 =?utf-8?B?bGlaUEVXRHorS3MyS0NLYnE0RTVrdXhRNGROZEtHL1I2NllRNkJxY3NwNFlJ?=
 =?utf-8?B?ZWtRUmVuRndraWV6LysvR1VXUEFSWFlJamNGb1pHSWFSOWlCVGtERmhBa3F2?=
 =?utf-8?B?TndZUVJWZ05lcTVHV05MMEw0b0tvTXBIZnR6eGFjUHo1T0RxYnJzMjEwdmFY?=
 =?utf-8?B?UkFEek85aEliNVVtVjVQcmx3NHYzam16K0lyaVc2dFlqdmtrOFhlb3crZk13?=
 =?utf-8?B?Y0JkMDBzUTlWSDllUk8zU250VG1ZNUxNU0hoa29obmxUdE44VmMxcGYrRVdi?=
 =?utf-8?B?WGU5ZGNvcGVTL0VwcGV3TEVFQXRiOGF3RzlZUGk3NjI1alV1OGY4akJVT2Uv?=
 =?utf-8?B?OUx4Q2ZZbjZvYWlDOFR6QktrL2wzbGVqVXgxTndLc2s5K0VDcXRLNFY1U2Ew?=
 =?utf-8?B?YVN0L2lXTFUwSUhIcEt3am5oRGlNbmZLWFhpTjRwbE9HYTNWUUZzV1dQUXRB?=
 =?utf-8?B?T2w4bHo5UkIxWXptdFdEM1JDZ1VIQVV0K0t1aCtXeDFMaGxvN29NbDNQNjAx?=
 =?utf-8?B?Y1p0NWNtaTVDUWFvYUp4WUROQzZzZGpWb3c1M0NZUTFRMk9hdVd4Q0IxdmJo?=
 =?utf-8?B?SVNLcTUxd0NCRVdxMUdacEV3S3VVNmFkWEpqTTlMdlkwNXNmWk9Sd1N3WlFa?=
 =?utf-8?B?Mk5QSXNQTy8zSVR0MjVaUUkwVENIWFBIRXBXeUR5L0p5OGJsbm9Ca3I2SDlM?=
 =?utf-8?B?TXBTaGNoTmY5SmVMOGptN09uV1JGYUtGbC8rSEYvc2t3WU1KYU5nLzREUUFx?=
 =?utf-8?B?T0dzcDJ0T0RUd3dlZzdWUEl1VStZNTQrZVlJUmZYOW1UcGhsMm8zSC8zZUFQ?=
 =?utf-8?B?WkZvdjBqeGJwUGtGajk4cWptSHlPdWR2cC80akJVY2lxRXFFK0EwZ0hGL2Ru?=
 =?utf-8?B?RjNYK0NZWFc3Q282VXhYQXZYR3E2VWEzeUZCb2dQbjc3Smlqa0pnNGRmSWFw?=
 =?utf-8?B?eU41QnFmN2Rjd0JXZFF6ZHZoSFg2emtpNTd3b2daMG5GYTdKS0FMNUlndFdX?=
 =?utf-8?B?RVFFbDF3MFVEZFNzajc0eEg3b2VzVytTMkR3allKbXRiaGhEK2w1YnNZNGIv?=
 =?utf-8?B?VkdEbVpGcHRhUXQwaEdHY1JjSFN3WHdQa24reThsajVyUmYrR3RPSWZ1OUo2?=
 =?utf-8?B?dUJ6bHlJT240SXFQdGw2L0V6Uzh3RVBrVWVlbkVDRDYvQXkra1BOMG9SQ1Jx?=
 =?utf-8?B?ZTRaR3BkN015ZzNGd21rMndDcllZaG8vUDdydU9ISHdWejBzMkF3UWY3a0xk?=
 =?utf-8?B?UDl4ZjJWb0VOZVltZUFtaW11ZzBhTC96MnlkR2w5N0lOL2hNWEdsdUNQdU5t?=
 =?utf-8?B?Vmc5anNpRkE4aWRSSEtqcnN6OWsyaFhkVkNyMTFYYmlOb0hObTQrbURjRkNh?=
 =?utf-8?B?T0RDK3hZU09VQU5PYzJXOXVZdjFkR1V2TEI0aWMrM3pwR0hMWFBPVXpRV2hG?=
 =?utf-8?B?Tk9DVzA4TVpuTEI2YlFVSG1tMk5NT1BKaWJtOC9uNUpkUEFSWXdLSzlnZGRS?=
 =?utf-8?B?dFJPbWhqUml3Nzk0WVVOaHE1V3FSNC8vQnA0UkN2WEE3UVU3YU45bWEzK1Yw?=
 =?utf-8?B?eVc0bDc0YzlRRnlEei9RYkhJSFJOZWw4b0I3TUdmRkhXaXQ2Zm1CLzZwODJm?=
 =?utf-8?B?UEQ4azNFYzBJZVhObVMwZkpSMDhPb284UmFDTHJIWUZWcDBtVVJhQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 478a7231-060f-47cc-d549-08df17ab82ba
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7771.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 06:42:31.3403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7xoEXi+jzNFtd3DZh5xrdlfha/ADW+KVWM1BJ44/zfW+3Jnl3O/E07RMXEMIDCYqf/3cGbdHR7Xf/6RFj3kUrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR12MB095541


> FS-DAX registers persistent-memory ranges as ZONE_DEVICE memory, and the
> kernel normally allocates and initializes vmemmap storage for every
> advertised PFN up front. Sparse pmem images and workloads that only use the
> DAX direct-access path may never need writable per-PFN state for most of
> that range, but still pay the memory and initialization cost.
>
> Add an opt-in dev_pagemap mode that populates FS-DAX vmemmap PTEs from a
> shared read-only metadata page. The shared page is initialized with the
> common ZONE_DEVICE and dev_pagemap state, so every PFN still has a valid
> struct page representation while private metadata allocation is deferred.
>
> This relies on sizeof(struct page) being a power of two, so each vmemmap
> page contains a naturally aligned and repeatable set of struct page slots.
> It also requires architecture support for runtime vmemmap remapping,
> because shared mappings must be replaced with private writable pages before
> a PFN can enter userspace mappings.
>
> The initial implementation is deliberately limited to a single
> memory-block-aligned range. That is not a fundamental requirement, but keeps
> the registration and teardown paths simple; support for multiple ranges or
> less strict alignment can be added later.
>
> Provide vmemmap_materialize_page() to replace shared mappings in the
> requested metadata range with private writable copies. A later patch will
> call it from the FS-DAX fault path.
>
> No caller enables the mode yet.
>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   include/linux/memremap.h | 11 ++++++-
>   mm/memremap.c            | 38 ++++++++++++++++++++++--
>   mm/mm_init.c             | 11 +++++++
>   mm/sparse-vmemmap.c      | 64 +++++++++++++++++++++++++++++++++++++---
>   4 files changed, 116 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> index e3c2ccf872a8..21c9b6aeef67 100644
> --- a/include/linux/memremap.h
> +++ b/include/linux/memremap.h
> @@ -9,6 +9,7 @@
>   
>   struct resource;
>   struct device;
> +struct page;
>   
>   /**
>    * struct vmem_altmap - pre-allocated storage for vmemmap_populate
> @@ -108,7 +109,8 @@ struct dev_pagemap_ops {
>   	void (*folio_split)(struct folio *head, struct folio *tail);
>   };
>   
> -#define PGMAP_ALTMAP_VALID	(1 << 0)
> +#define PGMAP_ALTMAP_VALID				BIT(0)
> +#define PGMAP_VMEMMAP_OPTIMIZATION			BIT(1)

I liked the overall idea.

Minor naming suggestion I have:

'PGMAP_VMEMMAP_OPTIMIZATION' feel too generic to me.

Maybe something on the lines to reflect the actual optimization:

|PGMAP_SHARED_VMEMMAP or PGMAP_VMEMMAP_ON_DEMAND or some_other_name?|

|Thanks,|

|Pankaj|

>   
>   /**
>    * struct dev_pagemap - metadata for ZONE_DEVICE mappings
> @@ -122,6 +124,7 @@ struct dev_pagemap_ops {
>    *	A zero value (default) uses base pages as the vmemmap metadata
>    *	representation. A bigger value will set up compound struct pages
>    *	of the requested order value.
> + * @vmemmap_shared_page: shared read-only vmemmap page for optimized FS-DAX
>    * @ops: method table
>    * @owner: an opaque pointer identifying the entity that manages this
>    *	instance.  Used by various helpers to make sure that no
> @@ -137,6 +140,7 @@ struct dev_pagemap {
>   	enum memory_type type;
>   	unsigned int flags;
>   	unsigned long vmemmap_shift;
> +	struct page *vmemmap_shared_page;
>   	const struct dev_pagemap_ops *ops;
>   	void *owner;
>   	int nr_range;
> @@ -232,6 +236,7 @@ void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
>   void devm_memunmap_pages(struct device *dev, struct dev_pagemap *pgmap);
>   struct dev_pagemap *get_dev_pagemap(unsigned long pfn);
>   bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn);
> +int vmemmap_materialize_page(struct page *page, unsigned int order);
>   
>   unsigned long memremap_compat_align(void);
>   
> @@ -307,4 +312,8 @@ static inline void put_dev_pagemap(struct dev_pagemap *pgmap)
>   		percpu_ref_put(&pgmap->ref);
>   }
>   
> +static inline bool pgmap_vmemmap_optimizable(struct dev_pagemap *pgmap)
> +{
> +	return pgmap && pgmap->vmemmap_shared_page != NULL;
> +}
>   #endif /* _LINUX_MEMREMAP_H_ */
> diff --git a/mm/memremap.c b/mm/memremap.c
> index accba23aef28..a53d09b84eaa 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -3,6 +3,7 @@
>   #include <linux/device.h>
>   #include <linux/io.h>
>   #include <linux/kasan.h>
> +#include <linux/memory.h>
>   #include <linux/memory_hotplug.h>
>   #include <linux/memremap.h>
>   #include <linux/swap.h>
> @@ -83,6 +84,30 @@ static unsigned long pfn_len(struct dev_pagemap *pgmap, unsigned long range_id)
>   		pfn_first(pgmap, range_id)) >> pgmap->vmemmap_shift;
>   }
>   
> +static int pgmap_vmemmap_shared_page_alloc(struct dev_pagemap *pgmap, int nid)
> +{
> +	const struct range *range = &pgmap->range;
> +
> +	if (!is_power_of_2(sizeof(struct page)) ||
> +	    !IS_ENABLED(CONFIG_ARCH_SUPPORTS_VMEMMAP_REMAP) ||
> +	    !(pgmap->flags & PGMAP_VMEMMAP_OPTIMIZATION))
> +		return 0;
> +
> +	if (pgmap->nr_range != 1 ||
> +	    !IS_ALIGNED(range->start | range_len(range), MIN_MEMORY_BLOCK_SIZE))
> +		return 0;
> +
> +	pgmap->vmemmap_shared_page = alloc_pages_node(nid, GFP_KERNEL, 0);
> +
> +	return pgmap->vmemmap_shared_page ? 0 : -ENOMEM;
> +}
> +
> +static inline void pgmap_vmemmap_shared_page_free(struct dev_pagemap *pgmap)
> +{
> +	if (pgmap->vmemmap_shared_page)
> +		put_page(pgmap->vmemmap_shared_page);
> +}
> +
>   static void pageunmap_range(struct dev_pagemap *pgmap, int range_id)
>   {
>   	struct range *range = &pgmap->ranges[range_id];
> @@ -93,8 +118,9 @@ static void pageunmap_range(struct dev_pagemap *pgmap, int range_id)
>   
>   	/* pages are dead and unused, undo the arch mapping */
>   	mem_hotplug_begin();
> -	remove_pfn_range_from_zone(page_zone(first_page), PHYS_PFN(range->start),
> -				   PHYS_PFN(range_len(range)));
> +	if (!pgmap_vmemmap_optimizable(pgmap))
> +		remove_pfn_range_from_zone(page_zone(first_page), PHYS_PFN(range->start),
> +					   PHYS_PFN(range_len(range)));
>   	if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
>   		__remove_pages(PHYS_PFN(range->start),
>   			       PHYS_PFN(range_len(range)), NULL, pgmap);
> @@ -123,6 +149,7 @@ void memunmap_pages(struct dev_pagemap *pgmap)
>   
>   	for (i = 0; i < pgmap->nr_range; i++)
>   		pageunmap_range(pgmap, i);
> +	pgmap_vmemmap_shared_page_free(pgmap);
>   	percpu_ref_exit(&pgmap->ref);
>   
>   	WARN_ONCE(pgmap->altmap.alloc, "failed to free all reserved pages\n");
> @@ -310,6 +337,9 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
>   		break;
>   	case MEMORY_DEVICE_FS_DAX:
>   		params.pgprot = pgprot_decrypted(params.pgprot);
> +		error = pgmap_vmemmap_shared_page_alloc(pgmap, nid);
> +		if (error)
> +			return ERR_PTR(error);
>   		break;
>   	case MEMORY_DEVICE_GENERIC:
>   		break;
> @@ -324,8 +354,10 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
>   	init_completion(&pgmap->done);
>   	error = percpu_ref_init(&pgmap->ref, dev_pagemap_percpu_release, 0,
>   				GFP_KERNEL);
> -	if (error)
> +	if (error) {
> +		pgmap_vmemmap_shared_page_free(pgmap);
>   		return ERR_PTR(error);
> +	}
>   
>   	/*
>   	 * Clear the pgmap nr_range as it will be incremented for each
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 2ed17cc707ed..7dd03b8a8d28 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -33,6 +33,7 @@
>   #include <linux/vmstat.h>
>   #include <linux/kexec_handover.h>
>   #include <linux/hugetlb.h>
> +#include <linux/memremap.h>
>   #include "internal.h"
>   #include "mm_init.h"
>   #include "page_alloc.h"
> @@ -1133,6 +1134,15 @@ void __ref memmap_init_zone_device(struct zone *zone,
>   	if (!nr_pages)
>   		return;
>   
> +	if (pgmap_vmemmap_optimizable(pgmap)) {
> +		struct page *page = page_address(pgmap->vmemmap_shared_page);
> +
> +		for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
> +			__init_zone_device_page(page + i, start_pfn + i,
> +						ZONE_DEVICE, nid, pgmap);
> +		goto pageblock_init;
> +	}
> +
>   	/*
>   	 * Seed the reusable head-page template from the first real struct
>   	 * page. The normal page-init and refcount helpers must operate on
> @@ -1164,6 +1174,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
>   				     compound_nr_pages(pfn, altmap, pgmap));
>   	}
>   
> +pageblock_init:
>   	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE,
>   					 /* isolate */ false, /* atomic */ false);
>   
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index e62e6aa07f12..4dc7f020ed10 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -37,6 +37,8 @@
>    */
>   /* Get a ref on the head page struct page, for ZONE_DEVICE compound pages */
>   #define VMEMMAP_POPULATE_PAGEREF	0x0001
> +/* Read-only shared vmemmap mappings for FS-DAX base pages */
> +#define VMEMMAP_POPULATE_FSDAX_SHARED	0x0002
>   
>   #include "internal.h"
>   #include "mm_init.h"
> @@ -262,10 +264,11 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
>   			 * and through vmemmap_populate_compound_pages() when
>   			 * slab is available.
>   			 */
> -			if (flags & VMEMMAP_POPULATE_PAGEREF)
> +			if (flags & (VMEMMAP_POPULATE_PAGEREF | VMEMMAP_POPULATE_FSDAX_SHARED))
>   				get_page(pfn_to_page(ptpfn));
>   		}
> -		entry = pfn_pte(ptpfn, PAGE_KERNEL);
> +		entry = pfn_pte(ptpfn, flags & VMEMMAP_POPULATE_FSDAX_SHARED ?
> +				PAGE_KERNEL_RO : PAGE_KERNEL);
>   		set_pte_at(&init_mm, addr, pte, entry);
>   	} else if (WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn)))
>   		return NULL;
> @@ -379,6 +382,54 @@ int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
>   	return vmemmap_populate_range(start, end, node, altmap, -1, 0);
>   }
>   
> +#ifdef CONFIG_ZONE_DEVICE
> +static int __vmemmap_materialize_page(struct page *page)
> +{
> +	unsigned long addr = PAGE_ALIGN_DOWN((unsigned long)page);
> +	struct dev_pagemap *pgmap = page_pgmap(page);
> +	struct page *candidate, *template = pgmap->vmemmap_shared_page;
> +	pte_t *pte = virt_to_kpte(addr);
> +
> +	if (pte_page(ptep_get(pte)) != template)
> +		return 0;
> +
> +	candidate = alloc_pages_node(page_to_nid(page), GFP_KERNEL, 0);
> +	if (!candidate)
> +		return -ENOMEM;
> +	copy_page(page_address(candidate), page_address(template));
> +
> +	spin_lock(&init_mm.page_table_lock);
> +	if (pte_page(ptep_get(pte)) != template) {
> +		__free_page(candidate);
> +		goto out;
> +	}
> +	/* Make the copied struct page contents visible before the PTE update. */
> +	smp_wmb();
> +	set_pte_at(&init_mm, addr, pte, mk_pte(candidate, PAGE_KERNEL));
> +	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
> +	put_page(template);
> +out:
> +	spin_unlock(&init_mm.page_table_lock);
> +
> +	return 0;
> +}
> +
> +int vmemmap_materialize_page(struct page *page, unsigned int order)
> +{
> +	struct dev_pagemap *pgmap = page_pgmap(page);
> +	unsigned long end = (unsigned long)(page + (1UL << order));
> +
> +	if (!pgmap_vmemmap_optimizable(pgmap))
> +		return 0;
> +
> +	for (unsigned long addr = (unsigned long)page; addr < end; addr += PAGE_SIZE)
> +		if (__vmemmap_materialize_page((struct page *)addr))
> +			return -ENOMEM;
> +
> +	return 0;
> +}
> +#endif /* CONFIG_ZONE_DEVICE */
> +
>   /*
>    * Write protect the mirrored tail page structs for HVO. This will be
>    * called from the hugetlb code when gathering and initializing the
> @@ -581,7 +632,11 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
>   		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
>   		return NULL;
>   
> -	if (vmemmap_can_optimize(altmap, pgmap))
> +	if (pgmap_vmemmap_optimizable(pgmap))
> +		r = vmemmap_populate_range(start, end, nid, NULL,
> +					   page_to_pfn(pgmap->vmemmap_shared_page),
> +					   VMEMMAP_POPULATE_FSDAX_SHARED);
> +	else if (vmemmap_can_optimize(altmap, pgmap))
>   		r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
>   	else
>   		r = vmemmap_populate(start, end, nid, altmap);
> @@ -887,7 +942,8 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
>   	 * Poison uninitialized struct pages in order to catch invalid flags
>   	 * combinations.
>   	 */
> -	page_init_poison(memmap, sizeof(struct page) * nr_pages);
> +	if (!pgmap_vmemmap_optimizable(pgmap))
> +		page_init_poison(memmap, sizeof(struct page) * nr_pages);
>   
>   	ms = __nr_to_section(section_nr);
>   	__section_mark_present(ms, section_nr);
