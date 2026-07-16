Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012054.outbound.protection.outlook.com [52.101.43.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1718D3CCA12;
	Thu, 16 Jul 2026 10:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784196236; cv=fail; b=p4ssYqNtopJM+vQkYOJbC7e0XSc5nwOk7AZuSS5Vj4e0lytWjwbKKv4MdcIgYoADggnCGFAS1cRXz2qLM72IzIONMzqxUdNqFjsOAHyekzIfnHq/Io6vgXQJRu8opy9OB5eOR+aPexA8gI1w0aWMF6Pl9dP0OzMN5p44j5gugTs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784196236; c=relaxed/simple;
	bh=6KFjKDTkNO0RjnQ5GwkPLCkYDD+8AEN9SM++2A30JTI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=InPE9A9MYLp8ixyzN75SqLX8tGZ5IlSLTaYx6jpyQQCa/TYTySd7WKFLITVZ4hK79Ghh8MsZwNBsM9r4RRT7fU2Mr17Vg1pGDgTF+tPW5Agw8/D2pcfvUhY1/b7JflJW5K42tOWVHClw6x5YLN1GnFBCd3gNqUFhuFlC+c5Pfjo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jDSCaCWy; arc=fail smtp.client-ip=52.101.43.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jDSCaCWy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VpN4NCLE0Bf76ARLpvLivoRwpRHE5g105v/HVGUSjrD7QRi9OnRndZDYPjdR1X7q/tO3SyNg+d/YXEtjfaDDkOYd0P0cNYL130YX1EDDvec5A3Z8Akf95D9jjNN596mxa3N1FxeHQHsdQbWGSb3zMRh+Lybs7YWUe+Agh5UW+t9ZgrvWb9TuwFwBeVpBaNUq7thy29YBUC0+ebhXALOzfzGx/xAHJWZ4cKDp4crjQx5QucY0e8PYRqDgy04flzlqxUidUqYqMuJRh5lyKpXKRvw36zR3QkKMR2YGgmqySOLSV3F/BTmSxRD8MRu0YxibiucHI6iNpsl3mvKhsG5gkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rjp9sumM13JlTU1+NVyVPf8lq7tjvr55ytKH+Vxq264=;
 b=MZ6lXhUYbPDwWtLY4yedcjUG1eIJuno81/EofV772ShrHSNdhMXNaAP+5oqpy8m2KBRwjvpPJ2vvjYR0LXyIq8AfaOgIXLqhOTverzuwJlGKvlxTU+xvdodlZYDU3zlfEneAF/54OvtSzAoOxC0otELhInRsVXTQEJn6ZhncJPcxY8cwId12Rb88BVQbSz8t68WkhYnNHu5PlwRsAkfKJ2v7r1OkdgitaWhKzqpbCC7pbmkNumFV827nm4yreOiCGmFH7KJKw9cZP/M1ZfF6BAH1naS708ACS2Ir3W+nGNGEZ4VBC/WsG+oCUxZHrL9ZBya9mQXvAqasbJqGYuWuRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rjp9sumM13JlTU1+NVyVPf8lq7tjvr55ytKH+Vxq264=;
 b=jDSCaCWyrxluMbSqbU77nSMUzmwmFB5qPgGk7Vk+bTviSIBvwj6go4x484T2kYkj9hSbd8jGlHTzKSR57h1zOPq3mCnVDEi2EbY5HUuCZRy2TCOZnsKAlmyPd3O9zrYhIA6dNz9YSAOKRHiPfcX9YV0DL+QSCyHGq8vkdFanv5U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by LV2PR12MB5752.namprd12.prod.outlook.com (2603:10b6:408:177::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 10:03:48 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.21.0223.008; Thu, 16 Jul 2026
 10:03:48 +0000
Message-ID: <c2fd5114-74d0-4996-8035-311ba976b3eb@amd.com>
Date: Thu, 16 Jul 2026 12:03:41 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/33] mm: make VMA page offset handling more
 consistent
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 damon@lists.linux.dev, iommu@lists.linux.dev, kasan-dev@googlegroups.com,
 linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
 freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
 kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>,
 Ackerley Tng <ackerleytng@google.com>, Kai Huang <kai.huang@intel.com>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:bb::20) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|LV2PR12MB5752:EE_
X-MS-Office365-Filtering-Correlation-Id: a77f5939-fb15-4eab-ce76-08dee321876a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|23010399003|11063799006|5023799004|10067099003|3023799007|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	nAVrqTLZLAnkAs1ic4r25k/tDBTeRWD2/uIJZ96ATkValcDJexCWNp6/R6lKKQgYTzAMpe5GUnOmQdbGj7ejQE4GgebwxHbrwogU3usNdFBaRN7HhoogGRNP53kGK64/rJrNno3smPSCc6UPwrWH0qdODOyXLhtpECLKMtwgZlmtYMQV1XN+vBr7hVijLvzsjX2eVrXBI1vRcgYxyoSS5uSWChCIDOTBvV7/TvX29Vfpdb2DHb22lKwgygS0Y7U5AVu4ooC/xEJvQORY9tMiUDV1EXu3SFRi6R+exIPENh4sQewLlz6sLgshaefApBVlaZb/Y8AO1S8cxtzSVjIZ/zc7aFwXmP30gdCPceFTZnJE0GW6vS9WiiWkbgnBa2W0i7DY3SHSgLn9izmOTg0joy3QJF8kGJ2tvJxcEzPuADYyEWjB+dKRbkqVog6NGRJEHA5qmMnayuvNRozeELTcEHHvC08mT/JOP8mWbw9DHDnpsYbcJbRcawMvEEaiXyrIcb1KAMm/azNzyeKy2apfAUkZ8rcqa/zpRLe/PrIhaoI1vU+iaGLKS9dka6XA5WWM2FlFxSPhj5ptF3uyXrs7ypYXHVjePzu+xC7lG8CfdDffxv2Jk5ltbG0AjRVC23Ux
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(23010399003)(11063799006)(5023799004)(10067099003)(3023799007)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dkpXZ2JPL1J5VC9MQzc3M1p3eTR4emt4MWJjcGpTNHRaelVCSVhXVmJmdjdM?=
 =?utf-8?B?UkowVFQ1T1gxbmZBdnprZFZSTWpVR25GbDRucXVwZGtxMjRLNDhEQ044a3pN?=
 =?utf-8?B?aGIvSDR5UHlDeTAvNUJDN2V6b2NxangxMmc0amx4dTk1djQvVVBTSXZHVFhq?=
 =?utf-8?B?aTljRkx5eE9sNGI3ZUZoS0hlSFYrY2ZTUGJtTHZrdXhPdWRiMkdUa052OUhU?=
 =?utf-8?B?ZDB6WXRmb1VySGx2Q09Tc2l5cXc0dFVXbmFmaXZ1T2paMXdrUkxjS3REeGUr?=
 =?utf-8?B?RlJHRzhZSVhKRmdUa1lCVVNDWDJqMXpTSEdac3RvSVJwQ09FWmtybXNlQlRE?=
 =?utf-8?B?MjM2S052NEtpbVBRTHdYZG42c0lrN3E3dVM4NUtwOHg3NWs1TnE1VWdJMldN?=
 =?utf-8?B?RXFtaXNmb1c2Ri9qeE1CZHIyNm9RaUZpYTZQMktRN2NNa3hiYXlVck9sbWVL?=
 =?utf-8?B?MW1sV2hram9MQ25XQlluNGZQdTl3eUptTjM0MFNxLzEyamFiTSswZm5DYVFR?=
 =?utf-8?B?bHFMOUJiWGdNbXFwNXZEbmE4MGg3NHZuR3dsbVNNcWZSSTYvejlER005NTAw?=
 =?utf-8?B?TnFHdk5BMWJVUkxVQkRCcmRkL245NEtOTDRURWducjFxSk52aTB4ZGRvOVp2?=
 =?utf-8?B?bXpxOFo0ZnJEeFVkUi9lZnVaQ2lvT3dkakhnVk5LM05HN1ZESVdwNS84WWt4?=
 =?utf-8?B?bUxaQVNRTWVYemlRRnhnZzJqRlA0WXdhWVd6VXAzVXhkQ3QrRDFlTWQrRHdX?=
 =?utf-8?B?ZzBPVTB4YWlCblFRblFLdTJoMmY5VWRET3BoS3pyOGFQSDNCMnpLWTVub0ZW?=
 =?utf-8?B?SmVwbExjYVdOQTRGZHdsRllWcmxLTngwN0hFNTEvTVlHM05tSnBnNFN1ZWZB?=
 =?utf-8?B?aE04b2xHRGJYWjhFWjRZU1VXUXpDNC85SXBsREtUQVcrb1d1cEk1YnJMYitu?=
 =?utf-8?B?dUlQb20vRGs3ZUlzYXZMNC9aRmlsdkk2NnV1UmUrcUVOSTc0RE1pM3lrWGpu?=
 =?utf-8?B?QWkvaVBNSEpuN0FWUUhnRGhHVUJhdUIrZnF2ZDJZN0dkM2pkVG1lMDBMQ0ZG?=
 =?utf-8?B?akdoVE1LZUxVSkl2Tk1ERTlvdmphditUYVV3dHlIb0F6NlI1WFFPZm9oRG1Y?=
 =?utf-8?B?QXBVanh6dndMbUVyN3ZGK0xzMGtxZFk4Z3FKUXVEMHNOVmJ2dXFDNnZBUW1V?=
 =?utf-8?B?d09CVGpwcjJiR1dDU2dtKzcyVVM2VE1WSHhBdlB1eEpYbmUwd1lieGJudUgy?=
 =?utf-8?B?U2xXblVmM0FYU0RzTmpUTndKUjYrVHJDNzZ6aTJLWHJvdE5tMzQ2cC9oNUxh?=
 =?utf-8?B?OXZ1anNyajlGQTdNRjdqRFhJSTAvTTAxRVF6NjdLN3RLMS9UY1FDZUplM0x6?=
 =?utf-8?B?aGNNTGlpcEFmTU9PNWUwZmNHdFEvaU9JWlplMmYvSG1KVVJ6THRodk9FQTF6?=
 =?utf-8?B?MEtBZmlMMEQrQ21tS0dZTUpwM2pXU205dk8xQVBiRXJReEZkenNGYTJLVXFq?=
 =?utf-8?B?VllGeDVLR1JoMVVrbmdYMmlMcVJPOXRQTzNzbjFWRmpjZ0lwWmk2dzgwU1p5?=
 =?utf-8?B?clZWM3MxVUtyMFh0d21HV3ZKUUMyekRqWTNKSmJ3UTRvazFGOXlKMWFrV003?=
 =?utf-8?B?c1Z1eWU4RTd2RU9Cb0RlU0krazZNZmN1VzkrYkoyTTlhNUJoWXZwWVh6RytV?=
 =?utf-8?B?UElnZnpXQ05BZDZDSm0yaVpIc2tpcmZEQUhaNUtCSlhaeHJaT2o2OU1JM1NZ?=
 =?utf-8?B?Sy9nSThjTXo5QTJEL0pSeDRyaGRsZHhLczIzUmlRV2NZbHNZUkRZRWZkSGZr?=
 =?utf-8?B?RThlMkwzejB6QW03L3NzY1RkNDhCUlVPR3JXU0lzLzVoeHIwYlhSY1BaT1hE?=
 =?utf-8?B?OWtCemFJdndvZzJTclcwNGg5UjJ4Y2prSmEwNHVBZkhRUU1SREM0V3Bsbzcv?=
 =?utf-8?B?dkQvUkNiVjFuTy9idEFBVGZlZmNZM3pHRFc1My9ldFptMnlSWTBLaXgyUUlh?=
 =?utf-8?B?eXVhaXhPOXVlYVMySDhzTnlJbTFNS3l1ZVF6VWdwOVd1QVJPMGZFVjlaTVNk?=
 =?utf-8?B?TWpIZGhmcE9JU2E2YW9HeHVoa2g1MTVrYW81aWl3NG55Mi9MY2IwQWRwV1lM?=
 =?utf-8?B?S2llYi9XK0FrSU1pcTVpbGd6L0FhbjdrbU5aQWtMS1pCakE3NEJTS2ROYVZP?=
 =?utf-8?B?cHhGK01pc2FVdjJSTmpRQS9OWjNKRFhJNklDVUMrZ3YweWo4cjVBQkozWHBl?=
 =?utf-8?B?bW5SVi80L2ZDMThseHo4bFRJd3VqcmlXK1Q3U2ZqMVMzLzNUZWZvaGRwTGRn?=
 =?utf-8?Q?2YWNpWFmblcRgxHnsC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a77f5939-fb15-4eab-ce76-08dee321876a
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 10:03:47.9915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OMLdgyTFuNz2Mz15ysPWVzPUKnJLKfX+AEzZdCkoAROyiVHv1Jhoc7ncbRm31TaV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5752

On 7/10/26 22:16, Lorenzo Stoakes wrote:
> This series performs a series of cleanups and improvements around how the
> vma->vm_pgoff field is used.
> 
> Folios belonging to file-backed mappings are simply indexed by the page
> offset within the file they map (excepting pfnmap and driver mappings which
> sometimes do things different).
> 
> However, anonymous folios belonging to pure anonymous mappings are indexed
> by their "virtual" page offset, which is equal to addr >> PAGE_SHIFT at the
> time at which the VMA was first faulted in.
> 
> The page offset of a VMA is stored in vma->vm_pgoff and indicates the page
> offset of the start of the VMA range, whether it be file-backed or
> anonymous.
> 
> The work here both cleans up how we reference this field, as well as laying
> the foundations for a future series which addresses the inconsistency of
> CoW'd folios in MAP_PRIVATE-file backed mappings, which are indexed as if
> they were file-backed but behave as if they were anonymous.
> 
> This future series will make it such that all anonymous folios are indexed
> by virtual page offset whether belonging to VMAs who satisfy
> vma_is_anonymous() or MAP_PRIVATE-mapped file-backed mappings.
> 
> This series:
> 
> * Exposes vma_start_pgoff() and updates the kernel to use it consistently.
> * Adds and uses the useful vma_end_pgoff() helper.
> * Parameterises the file-backed mapping helpers vma_interval_tree_*()
>   by address_space rather than rb_root_cached.
> * Renames: the misleadingly-named vma_interval_tree_*() helpers to
>   mapping_rmap_tree_*() to be consistent with the renamed
>   anon_rmap_tree_*().
> * Parameterises anon_rmap_tree_*() by anon_vma.
> * Moves mm/interval_tree.c to the rmap section.
> * Adds vmg_*() helpers for page offset.
> * Clarifies the confusing vmg_adjust_set_range() function.
> * Introduces linear_page_delta() to provide relative pgoff within a VMA.
> * Replaces open-coded versions of linear_page_delta() and
>   linear_page_index() with invocations of these functions.
> * Introduces and uses vma_assert_can_modify() to account for whether a VMA
>   can be modified (detached or write locked).
> * Adds and uses vma_[add,sub]_pgoff() to adjust VMA page offset.
> * Moves __install_special_mapping() to vma.c.
> * Makes vma_set_range() static and internal to vma.c.
> * Introduces and makes use of vma_set_pgoff().
> * Fixes incorrect vma.h header inclusion.
> * Defaults VMA userland tests to 64-bit vma flags size.
> * Updates VMA userland tests to give better output on failure.
> * Various smaller cleanups.
> * Updated the vma_set_pgoff() assert to account for MAP_PRIVATE /dev/zero
>   correctly.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

I only skimmed over the set but should there be any changes required to DMA-buf, amdgpu or radeon driver feel free to add

Acked-by: Christian König <christian.koenig@amd.com>

and merge upstream through any branch you feel fit.

Regards,
Christian.

> ---
> v2:
> * Rebased on mm-unstable.
> * Updated tags (thanks to everyone and b4 trailers -F -u! ;)
> * Updated 1/30 to include the vma_start_pgoff() helper in VMA userland tests,
>   which was previously causing a bisection hazard on the VMA userland tests.
> * Updated 2/30 to reference the pfnmap vma->vm_pgoff PFN abomination as per
>   David.
> * Updated 4/30 to include vma_end_pgoff() helper in VMA userland tests at the
>   appropriate point.
> * Updated 8/30 from mapping_interval_tree_*() to mapping_rmap_tree_*() and add
>   commit to rename anon_vma_interval-tree_*() to anon_rmap_tree_*()  as per
>   Pedro.
> * Fixed issue in 8/30 where the internal helpers were still called
>   __vma_interval_tree_*() rather than __mapping_rmap_tree_*().
> * Updated 9/30 to separate out the rename and change of parameter type for
>   clarity as per Gregory.
> * Updated 17/30 to put perf_mmap_aux() variables in reverse Christmas tree order
>   as per Pedro.
> * Updated 19/30 to remove incorrectly placed vma_start_pgoff() invocation as per
>   Thomas/Gregory.
> * Updated 20/30, 21/30 to put the vma_assert_can_modify() VMA userland test stub
>   in the right place as per Pedro.
> * Confined the vma_set_pgoff() assert to CONFIG_MMU, as the ever helpful
>   nommu of course violates all assumptions in this regard.
> * Fixed issue in improved ASSERT_[TRUE, FALSE, EQ, NE] test runners with
>   re-evaluation of input expressions.
> * Updated the vma_start_pgoff() comment further to discuss the MAP_PRIVATE
>   /dev/zero edge case.
> * Update the vma_set_pgoff() assert to handle the mmap_region() newly
>   established file mapping case.
> * Updated the linear_page_index() comment to explicitly defer to
>   vma_start_pgoff() to avoid duplicate information and future bitrot.
> * Updated vma_shrink() to no longer accept the useless start parameter, as
>   it is invoked from relocate_vma_down() only, which has already expanded
>   the VMA to cover the range [new_start, old_end) thus always shrinks the
>   tail.
> * Moved sanity checks from vma_set_pgoff() to new helper
>   assert_sane_pgoff() and documented it clearly.
> * Fixed issue with nascent file-backed VMAs hitting vma_set_pgoff() assert
>   by checking for vma_is_anonymous().
> * Moved vma_set_anonymous() earlier so vma_set_pgoff() works with nascent
>   anonymous VMAs.
> * Updated the VMA userland tests so CONFIG_MMU, CONFIG_PER_VMA_LOCK work
>   with IS_ENABLED().
> 
> v1:
> https://patch.msgid.link/cover.1782735110.git.ljs@kernel.org
> 
> To: Andrew Morton <akpm@linux-foundation.org>
> To: David Hildenbrand <david@kernel.org>
> To: "Liam R. Howlett" <liam@infradead.org>
> To: Vlastimil Babka <vbabka@kernel.org>
> To: Mike Rapoport <rppt@kernel.org>
> To: Suren Baghdasaryan <surenb@google.com>
> To: Michal Hocko <mhocko@suse.com>
> To: Rik van Riel <riel@surriel.com>
> To: Harry Yoo <harry@kernel.org>
> To: Jann Horn <jannh@google.com>
> To: Lance Yang <lance.yang@linux.dev>
> To: Pedro Falcato <pfalcato@suse.de>
> To: Russell King <linux@armlinux.org.uk>
> To: Dinh Nguyen <dinguyen@kernel.org>
> To: Simon Schuster <schuster.simon@siemens-energy.com>
> To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> To: Helge Deller <deller@gmx.de>
> To: Alexander Viro <viro@zeniv.linux.org.uk>
> To: Christian Brauner <brauner@kernel.org>
> To: Jan Kara <jack@suse.cz>
> To: Dan Williams <djbw@kernel.org>
> To: Matthew Wilcox <willy@infradead.org>
> To: Muchun Song <muchun.song@linux.dev>
> To: Oscar Salvador <osalvador@suse.de>
> To: Masami Hiramatsu <mhiramat@kernel.org>
> To: Oleg Nesterov <oleg@redhat.com>
> To: Peter Zijlstra <peterz@infradead.org>
> To: Ingo Molnar <mingo@redhat.com>
> To: Arnaldo Carvalho de Melo <acme@kernel.org>
> To: Namhyung Kim <namhyung@kernel.org>
> To: Mark Rutland <mark.rutland@arm.com>
> To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> To: Jiri Olsa <jolsa@kernel.org>
> To: Ian Rogers <irogers@google.com>
> To: Adrian Hunter <adrian.hunter@intel.com>
> To: James Clark <james.clark@linaro.org>
> To: Zi Yan <ziy@nvidia.com>
> To: Baolin Wang <baolin.wang@linux.alibaba.com>
> To: Nico Pache <npache@redhat.com>
> To: Ryan Roberts <ryan.roberts@arm.com>
> To: Dev Jain <dev.jain@arm.com>
> To: Barry Song <baohua@kernel.org>
> To: Miaohe Lin <linmiaohe@huawei.com>
> To: Naoya Horiguchi <nao.horiguchi@gmail.com>
> To: Xu Xin <xu.xin16@zte.com.cn>
> To: Chengming Zhou <chengming.zhou@linux.dev>
> To: SJ Park <sj@kernel.org>
> To: Matthew Brost <matthew.brost@intel.com>
> To: Joshua Hahn <joshua.hahnjy@gmail.com>
> To: Rakie Kim <rakie.kim@sk.com>
> To: Byungchul Park <byungchul@sk.com>
> To: Gregory Price <gourry@gourry.net>
> To: Ying Huang <ying.huang@linux.alibaba.com>
> To: Alistair Popple <apopple@nvidia.com>
> To: Hugh Dickins <hughd@google.com>
> To: Peter Xu <peterx@redhat.com>
> To: Kees Cook <kees@kernel.org>
> To: Marek Szyprowski <m.szyprowski@samsung.com>
> To: Robin Murphy <robin.murphy@arm.com>
> To: Andrey Konovalov <andreyknvl@gmail.com>
> To: Alexander Potapenko <glider@google.com>
> To: Dmitry Vyukov <dvyukov@google.com>
> To: Steven Rostedt <rostedt@goodmis.org>
> To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> To: Jarkko Sakkinen <jarkko@kernel.org>
> To: Dave Hansen <dave.hansen@linux.intel.com>
> To: Thomas Gleixner <tglx@kernel.org>
> To: Borislav Petkov <bp@alien8.de>
> To: x86@kernel.org
> To: "H. Peter Anvin" <hpa@zytor.com>
> To: Ian Abbott <abbotti@mev.co.uk>
> To: H Hartley Sweeten <hsweeten@visionengravers.com>
> To: Lucas Stach <l.stach@pengutronix.de>
> To: Christian Gmeiner <christian.gmeiner@gmail.com>
> To: David Airlie <airlied@gmail.com>
> To: Simona Vetter <simona@ffwll.ch>
> To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
> To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> To: Maxime Ripard <mripard@kernel.org>
> To: Thomas Zimmermann <tzimmermann@suse.de>
> To: Rob Clark <robin.clark@oss.qualcomm.com>
> To: Dmitry Baryshkov <lumag@kernel.org>
> To: Abhinav Kumar <abhinav.kumar@linux.dev>
> To: Jessica Zhang <jesszhan0024@gmail.com>
> To: Sean Paul <sean@poorly.run>
> To: Marijn Suijten <marijn.suijten@somainline.org>
> To: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
> To: Thierry Reding <thierry.reding@kernel.org>
> To: Mikko Perttunen <mperttunen@nvidia.com>
> To: Jonathan Hunter <jonathanh@nvidia.com>
> To: Christian Koenig <christian.koenig@amd.com>
> To: Huang Rui <ray.huang@amd.com>
> To: Matthew Auld <matthew.auld@intel.com>
> To: Jason Gunthorpe <jgg@ziepe.ca>
> To: Yishai Hadas <yishaih@nvidia.com>
> To: Shameer Kolothum <skolothumtho@nvidia.com>
> To: Kevin Tian <kevin.tian@intel.com>
> To: Ankit Agrawal <ankita@nvidia.com>
> To: Alex Williamson <alex@shazbot.org>
> To: Paolo Bonzini <pbonzini@redhat.com>
> To: Shakeel Butt <shakeel.butt@linux.dev>
> To: Usama Arif <usama.arif@linux.dev>
> Cc: ljs@kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-parisc@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: nvdimm@lists.linux.dev
> Cc: linux-perf-users@vger.kernel.org
> Cc: linux-trace-kernel@vger.kernel.org
> Cc: damon@lists.linux.dev
> Cc: iommu@lists.linux.dev
> Cc: kasan-dev@googlegroups.com
> Cc: linux-sgx@vger.kernel.org
> Cc: etnaviv@lists.freedesktop.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-arm-msm@vger.kernel.org
> Cc: freedreno@lists.freedesktop.org
> Cc: linux-tegra@vger.kernel.org
> Cc: kvm@vger.kernel.org
> Cc: Russell King <linux+etnaviv@armlinux.org.uk>
> 
> ---
> Lorenzo Stoakes (33):
>       mm: move vma_start_pgoff() into mm.h and clean up
>       mm: add kdoc comments for vma_start/last_pgoff()
>       tools/testing/vma: use vma_start_pgoff() in merge tests
>       mm: introduce and use vma_end_pgoff()
>       mm/rmap: update mm/interval_tree.c comments
>       mm/rmap: parameterise vma_interval_tree_*() by address_space
>       mm/rmap: elide unnecessary static inline's in interval_tree.c
>       mm/rmap: rename vma_interval_tree_*() to mapping_rmap_tree_*()
>       mm/rmap: parameterise anon_vma_interval_tree_*() by anon_vma
>       mm/rmap: rename anon_vma_interval_tree_*() params and use pgoff_t
>       mm/rmap: rename anon_vma_interval_tree_*() to anon_rmap_tree_*()
>       MAINTAINERS: Move mm/interval_tree.c to rmap section
>       mm/vma: introduce and use vmg_pages(), vmg_[start, end]_pgoff()
>       mm/vma: clean up anon_vma_compatible()
>       mm/vma: refactor vmg_adjust_set_range() for clarity
>       mm/vma: minor cleanup of expand_[upwards, downwards]()
>       mm: introduce and use linear_page_delta()
>       mm/vma: use vma_start_pgoff(), linear_page_index() in mm code
>       mm: prefer vma_[start,end]_pgoff() to vma->vm_pgoff in kernel/
>       mm/vma: remove duplicative vma_pgoff_offset() helper
>       mm: use linear_page_[index, delta]() consistently
>       mm/vma: introduce vma_assert_can_modify()
>       mm/vma: add and use vma_[add/sub]_pgoff()
>       mm/vma: move __install_special_mapping() to vma.c
>       mm/vma: make vma_set_range() static, drop insert_vm_struct() decl
>       mm/vma: update vma_shrink() to not pass start, pgoff parameters
>       mm/vma: update vmg_adjust_set_range() to offset pgoff instead
>       mm/vma: slightly rework the anonymous check in __mmap_new_vma()
>       mm/vma: introduce and use vma_set_pgoff()
>       mm/vma: correct incorrect vma.h inclusion
>       mm/vma: use guard clauses in can_vma_merge_[before, after]()
>       tools/testing/vma: default VMA, mm flag bits to 64-bit
>       tools/testing/vma: output compared expression on ASSERT_[EQ, NE]()
> 
>  MAINTAINERS                           |   2 +-
>  arch/arm/mm/fault-armv.c              |   4 +-
>  arch/arm/mm/flush.c                   |   2 +-
>  arch/nios2/mm/cacheflush.c            |   2 +-
>  arch/parisc/kernel/cache.c            |   2 +-
>  arch/x86/kernel/cpu/sgx/virt.c        |   3 +-
>  drivers/gpu/drm/etnaviv/etnaviv_gem.c |   3 +-
>  drivers/gpu/drm/gma500/gem.c          |   2 +-
>  drivers/gpu/drm/msm/msm_gem.c         |   3 +-
>  drivers/gpu/drm/omapdrm/omap_gem.c    |   5 +-
>  drivers/gpu/drm/tegra/gem.c           |   3 +-
>  drivers/gpu/drm/ttm/ttm_bo_vm.c       |   7 +-
>  drivers/vfio/pci/nvgrace-gpu/main.c   |   3 +-
>  drivers/vfio/pci/vfio_pci_core.c      |   3 +-
>  fs/dax.c                              |   2 +-
>  fs/hugetlbfs/inode.c                  |  15 +-
>  include/linux/huge_mm.h               |   1 +
>  include/linux/hugetlb.h               |   3 +-
>  include/linux/mm.h                    | 118 ++++++++++----
>  include/linux/mmap_lock.h             |   8 +
>  include/linux/pagemap.h               |  35 +++-
>  kernel/dma/coherent.c                 |   7 +-
>  kernel/dma/direct.c                   |   6 +-
>  kernel/dma/mapping.c                  |   8 +-
>  kernel/dma/ops_helpers.c              |   4 +-
>  kernel/events/core.c                  |  20 +--
>  kernel/events/uprobes.c               |  13 +-
>  kernel/kcov.c                         |   2 +-
>  kernel/trace/ring_buffer.c            |   3 +-
>  mm/damon/vaddr.c                      |   5 +-
>  mm/debug.c                            |   2 +-
>  mm/filemap.c                          |   7 +-
>  mm/huge_memory.c                      |   2 +-
>  mm/hugetlb.c                          |  15 +-
>  mm/internal.h                         |  33 ++--
>  mm/interval_tree.c                    | 111 ++++++++-----
>  mm/khugepaged.c                       |   7 +-
>  mm/ksm.c                              |   7 +-
>  mm/madvise.c                          |   6 +-
>  mm/mapping_dirty_helpers.c            |   2 +-
>  mm/memory-failure.c                   |  10 +-
>  mm/memory.c                           |  33 ++--
>  mm/mempolicy.c                        |  13 +-
>  mm/mmap.c                             |  41 +----
>  mm/mmu_notifier.c                     |   2 +-
>  mm/mremap.c                           |  12 +-
>  mm/msync.c                            |   4 +-
>  mm/nommu.c                            |  22 +--
>  mm/pagewalk.c                         |   4 +-
>  mm/rmap.c                             |  14 +-
>  mm/shmem.c                            |   9 +-
>  mm/userfaultfd.c                      |   4 +-
>  mm/util.c                             |   4 +-
>  mm/vma.c                              | 293 ++++++++++++++++++++++------------
>  mm/vma.h                              |  80 ++++++++--
>  mm/vma_exec.c                         |  12 +-
>  mm/vma_init.c                         |   6 +-
>  mm/vma_internal.h                     |   4 +-
>  tools/testing/vma/Makefile            |   2 +-
>  tools/testing/vma/include/dup.h       |  41 ++++-
>  tools/testing/vma/include/stubs.h     |  16 +-
>  tools/testing/vma/shared.c            |   9 --
>  tools/testing/vma/shared.h            |  43 +++--
>  tools/testing/vma/tests/merge.c       |  40 ++---
>  tools/testing/vma/vma_internal.h      |   4 +-
>  virt/kvm/guest_memfd.c                |   2 +-
>  66 files changed, 751 insertions(+), 459 deletions(-)
> ---
> base-commit: 4a6c88e10a0791d9c3b0677ce984365815c2ab4f
> change-id: 20260710-b4-pre-scalable-cow-24309015dee4
> 
> Cheers,

