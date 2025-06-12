Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C521B770FE
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 01:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749693393; cv=fail; b=Y73ASUrQdoIpgvGo7aYiHZ6BCotVKZoPrNEi63QqtAHi7lhFRMlg0Dk3QXW9iMXLTb1Sslj8/CXIQLht0t4DNNyIw9NZ/CWn+YeaGGeExGOoh8mfipk4i1nkNG0Y5poA0oKzUmmkJSyWeaWGfGHESi3XimnvDrH4T1AA3foMJY4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749693393; c=relaxed/simple;
	bh=DYq6Qe4Kt2HnaxJJAiS/KpJouDvKZGm6mBdxougyaME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UJBNL+X1jeAttAYU4r2mw6QjAB6CYajbFRFQZwmF57Q4yvHrEYQr4ir/p0VLmBTqDg1uPETvWTlDUUuhGjCRBQpEzTUouDpoYfukFi+XK7Ym+d4eXgS3CwnJj82/ZrMGHd2lnVhDi6aG8QvODorxtIS4CSNZRh/N3uzyeLn5NxQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=r+fBJ4HG; arc=fail smtp.client-ip=40.107.223.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="r+fBJ4HG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uLOQzGvuykKVsdxmss3KNHCFMqFzjeGIWABlpRr2Ek/daOn/LtLEb11IN3vddNLNzEufRr0UUTHdtG7dMiAmT7WfRq0+kHXCL7y/7bICx4uGbKoC+ebE5iTxJwR6jfyQDBfF9K2d9GbOktjuzP8cdizx899Aae0mN7izFFPg1A8WRJcAgv9wwJ4tMKMFheeMYaAezLFqTsCe6a3DFUC+kUU6qW3cjg9KsYH0kF4YW5QpzSIvsY0rCbA1Go5AHRb/jq19x0uQURlJLxYbmtmMg4IG2CD5UI6Vofu5KFZEh6h25NvJ/x0mR1FRx4yXkEtD26GaAYMfJWwED78RL0tD4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f7VIgni/GEtOLbD9+JfTOJnktEwrhPDUk+z16ZpZXA4=;
 b=iIRCPrtKOOd9KPeJxPTyccyFbKc0xiakMHKjnJX5byKN8vCM0+2U2WHy0k+qfnX9JOpxw4o26n8RgMsSoTkb6VvcijSrzCASsJiLlgWjgAcovJ0xkSZvl0lCRtjMHYwHtvvVA+6J9+k6FCeRxGnAdNGZhlNe2sf2bHT7/p/v/neTYlBWZNg95GMSZ/3100Il0mzwA5Vck4EKD3JjTtDMzYCvRa4CfFcS+CtuZ58iuwZi5ydBt+ZPYYRUOqkyPjQ+DPY2t77lSlOaIOc9XKfvgsToaObFwroePngsFxPtTkoAfFtPqHgKSW8dyOuSM1hjhuWC045UEeJiLBMfseWVzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f7VIgni/GEtOLbD9+JfTOJnktEwrhPDUk+z16ZpZXA4=;
 b=r+fBJ4HGyAAddoHq4dUtl6wXFYcUiJwFQLGYbkyAEpFFZUPl839HM1qZEUuyaUIxBxFTlTS3KpM3syUEU/w45dRI76sMCxoepomssz2olMwxxucG1PL+3BMvWLlPhiucI5N7Z5bOSbgUNpisTdWeGHtye8hHBS220hVC8+sNaPcutqkATk4DjRbk+0BgdtejYhwnZynF6XqKWKelr2T+RNOBqXJguIKXaNL74XV1118H7EOdir37Hr1HntlQXkb2/sFSRW+IbcPi+UIUzHJGtYHjLx6kIPZkK718YSwOW3XwOHLkyDWRKc6jHk080hpNrUXQAxaEGCf1ybd3g3mapA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS0PR12MB7728.namprd12.prod.outlook.com (2603:10b6:8:13a::10)
 by BL4PR12MB9723.namprd12.prod.outlook.com (2603:10b6:208:4ed::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Thu, 12 Jun
 2025 01:56:28 +0000
Received: from DS0PR12MB7728.namprd12.prod.outlook.com
 ([fe80::f790:9057:1f2:6e67]) by DS0PR12MB7728.namprd12.prod.outlook.com
 ([fe80::f790:9057:1f2:6e67%5]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 01:56:27 +0000
Date: Thu, 12 Jun 2025 11:56:22 +1000
From: Alistair Popple <apopple@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Dan Williams <dan.j.williams@intel.com>, Oscar Salvador <osalvador@suse.de>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm/huge_memory: don't ignore queried cachemode in
 vmf_insert_pfn_pud()
Message-ID: <dvstixx4pey6euns6xttep5bbc4jhz6smtgheijviwkbawnqbm@tqhbg4hzeiog>
References: <20250611120654.545963-1-david@redhat.com>
 <20250611120654.545963-2-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611120654.545963-2-david@redhat.com>
X-ClientProxiedBy: SY6PR01CA0076.ausprd01.prod.outlook.com
 (2603:10c6:10:110::9) To DS0PR12MB7728.namprd12.prod.outlook.com
 (2603:10b6:8:13a::10)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7728:EE_|BL4PR12MB9723:EE_
X-MS-Office365-Filtering-Correlation-Id: 57163f23-b0ab-42e7-cb97-08dda95457c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kiICP6XMlJ86n5AJZNmgW6m0K7J1H/XjXlh+M3TxfGdO7JeSlGMOqBWzHr8t?=
 =?us-ascii?Q?ptFjyATNXQjmfyIGg2a03pPz9CwFhfpW8HZsT03ACXIKb1Jc1DAAk/ENGCbz?=
 =?us-ascii?Q?LLuSRWVgyvAPmEZ+ty0PRp9MgWbyZ+k5MESwAGSzYciARfceIgr0JuMNzO4u?=
 =?us-ascii?Q?MCKgGp7MeUk5NaDupLFunyqHZTN7YeIYn/nIW+z2kmKO54Dx6XA64fTkJL77?=
 =?us-ascii?Q?4AcZvbcivH1CsSR7vsOMh6KJPojSjNJtjkf4LcgQo3OBE9PAqQ+tqRg6vbdX?=
 =?us-ascii?Q?Sf6v2alO3uLpmkgGxADegIcKPNnb43x9oomMUlJhuVIWFvdIdkuProZh5wt5?=
 =?us-ascii?Q?OpUMdrzzLbKDoHEpfPyoFtuYKs0X+kwqxMAnCD0J4sIniklv/FkT+nFnn5wX?=
 =?us-ascii?Q?/IsHc4fM9CVlu/5zJN3yCL1ej0NBRT0JkQzoSj/2s4Xg0maczLF9kmSY62N3?=
 =?us-ascii?Q?RQUUT/4xcR/tysk2uhjCdjmOZWDmXb4/pIXNVUWbnoVWI2T8goBkA/8QYD77?=
 =?us-ascii?Q?qeJLCpvH8bHTNwtSKKB1MsFqZNPmOoJvBfGb6qrVsPV0lQ+BDEerosgD4KjA?=
 =?us-ascii?Q?5xZ77idQCtzldm+HF6mZHPuQDfMw11hGeqc+LoFW98tIfANa+sAcKb46poJb?=
 =?us-ascii?Q?6ybj0/bS9PbpTyHxGGTkZUB9TDMTzsjwnlu2V5dOqrxP7XpKiNxyEKlMS8kh?=
 =?us-ascii?Q?VZtL1JaOZ0v10dKt/vb3z/4m2vehxPO2qghZjXVvBGCaplwfSjneqrO+1jes?=
 =?us-ascii?Q?rDL8FUBVVKs/Fd3uQ1YB21elshgi9Ejn5PLo18+62SQXS0I1XtQghvbjXB2s?=
 =?us-ascii?Q?oqUwAPBjNpvD+wFVpSBMZUbC9kf1+8Q4u6pU+T675hDyaV0v5pxHnqOfALBb?=
 =?us-ascii?Q?y42q6bL7cQpPP6PDZI2y2yEszrNXzp/ayY5giRc9SLCbhGxjzJV7gU0oZRUC?=
 =?us-ascii?Q?fyerwqh5x4zydoKEGvDiK2AycVVNMjbjCh5JQvERjMmRoz8G7wkhzSAgus7h?=
 =?us-ascii?Q?G4HFhb4y9dWp/BHW6vIDzWygKBtEUyMgA0MWaNrpHCIbHAH/oVhZLlnwW4rn?=
 =?us-ascii?Q?fA87BpGK3ys8DiuuiTkEsAaIWJt8aEJICddDehZCgO+TLGc7sbAh4OmGbugU?=
 =?us-ascii?Q?BkSdjnts+njeATS0Q/068aYFBPkm/yXSf9RjzHYkXcHsL9VawBJVIl2PQq6w?=
 =?us-ascii?Q?+kac6GUb5Ii1FNjnRl6BF+QKh5gH+tsOOMytV9ijTz2Q1B82PTFl/tDgibDE?=
 =?us-ascii?Q?LDcAymSzx0Nz8uxD7zppUrmXHxXLdYn7jPDNvfj/RtdiNnrYLe/daFRQQaCY?=
 =?us-ascii?Q?tP53YD6dOr/ad7UdcKxSTO+hQ6SBwzCxgKYzlTdj3ShZ7CKIzxi9t9c9rQ11?=
 =?us-ascii?Q?txrC6a0mp/WG3hhftsDsnmt+hmrUhDosDsRXf9aShXzGSFGMDg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7728.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g8EqKwqPUbJ5Xb7mAoAKFfA/fc+mHUmKjhe8MXaAP0B4Sw8xLZjzabAG9c1U?=
 =?us-ascii?Q?Zr06yyqAuwEciBhpTEM4s7jjJIlgb9YvzXUQTtJAKmiCstm74+lQvxzvdgQc?=
 =?us-ascii?Q?Alky327I1ug7Ek9EK4s4i94fg23e1ySO0gqiEB1MAMDGFKdY23p5iK6eGMSb?=
 =?us-ascii?Q?4ADqPD9KkGTcrQsWlnBgnryLp15jp+hXWS3B4Kx0ZGYgntQdGnYUFocO4RpG?=
 =?us-ascii?Q?4zmCRAGkDwBvHYH8eXA9P2u7lcX2qyvLg2IsWk1FYu0cYHL8ET0wdmPU6KV8?=
 =?us-ascii?Q?2Ah8lC/d2K+8R4R+QrJnK3VwKwWcqOAgo8kJd3FjPSPTIOABasutlhkideTy?=
 =?us-ascii?Q?w8OsqqQn/Jj8MMCNvZgHP/ptUXiDG+AcRJ1HK02bkQjq9K2R/ccb0ELWo/Oi?=
 =?us-ascii?Q?Rt+qfi7U44NnLLT4NClGR/Lh1LVeYdO7u02GtgqHqxk62L2guR8nOw57eclT?=
 =?us-ascii?Q?HvegI8AJtNJG+zEdAAXxpkByZdvhopsU5BpGX5APSMicUqFvpPFJTgOdSKp5?=
 =?us-ascii?Q?TI00d2FElCmATC5IUanYgkbM5tVCuusJlVvr/61oDnDxDBJglPPYcePyw+0s?=
 =?us-ascii?Q?KFroDE2xngHIyIg/osOTGMwuZjkdLRhuOSvUmen/Qy2OrWBiDk7hGExLnEdt?=
 =?us-ascii?Q?/S6DKi4Y3kpx8bPOnALv7UC1JHe9TXnVLobb4hoAExyjotl4+8377i9MsWvX?=
 =?us-ascii?Q?aNwwf09V/NejlKbLFMEqClL78WY6magNxo7yx63E15RaULGqu/G0qyNx7YXa?=
 =?us-ascii?Q?/qTxuVKc/ocZEV5usA3TZOv2lqh+Zi/LHMgEQR+fQFlAxM/D/ZyAXF3aBEtz?=
 =?us-ascii?Q?cDv2xm1a2zJlJ5Q6nIr3+siK+MnlCdvuAFAd/IuiD+Q+zraenQOBR5QGgPi6?=
 =?us-ascii?Q?td9rrImFCkAJ+bHVT/bqFO2FCcKmBIJWQUBwLArydq+THf5VAU3EBMtGTfUz?=
 =?us-ascii?Q?EbuRFA+AIW1AqQ7BxoTRSu8f6ytqHYkqhfst9rbru11aNJHDLH30hUQ5qra/?=
 =?us-ascii?Q?CLqcTzRuJY+l6N4QalzNq9MtW6iY81jrtl//1U5Izyi84osD44Qg1bKSDYd3?=
 =?us-ascii?Q?+/88Nv2gwgG9TeGyxKAMasPPXBvLnFAoI9YuTzAZ351qxHGtmwyCfY1/mRfu?=
 =?us-ascii?Q?mlnvtAYEHMkV6O6hBgJFp8X0wIqM8aIM1oDCZ+7DxW2kwTuXuZQ7kKaqZ4VL?=
 =?us-ascii?Q?p5aCICy0vs7gd198CqXIUPR3ZqTlmBBEnLO53nv6wNYYrlbgGzV3nF7vxucp?=
 =?us-ascii?Q?afklgDTLsq6pancE66FvIt+u20wS79XLnLwKv/XidYTvIvbkyTAa8fAcn1li?=
 =?us-ascii?Q?qlCQ5sy6dRB7bzRASIg8TNDEx2DSQiofMV3JdBMA85y4DELxXnlCFYXlUZ7K?=
 =?us-ascii?Q?Nb5lsdvUeuwxYstKEFExUDctuRaJFh3sexp+gkpDmR5Zjvn6mpxoU+mi7FUD?=
 =?us-ascii?Q?o1SeyuLrv2em/ZLh7lxNMe/KRae+DJp2h206UXWbswJ3LVaXzBblrPHLQwaj?=
 =?us-ascii?Q?d97KZGJkPwsf2YWVQrje13z8SrRJtfTZ0zIS5dBcR/Q4jjDAka1NDwSvvWxX?=
 =?us-ascii?Q?KTBy990oG3HOTe9KfYo3bjVH04tEMnAdewGSFNeP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57163f23-b0ab-42e7-cb97-08dda95457c0
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7728.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 01:56:27.6587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GoDC9zUNlaWgOxc7t7FoR3wA8vrDSu+lRFiTYuN6vSBGhrX0h6jruFczQLdYn0215jXmze3celFm/6OmXzyvGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9723

On Wed, Jun 11, 2025 at 02:06:52PM +0200, David Hildenbrand wrote:
> We setup the cache mode but ... don't forward the updated pgprot to
> insert_pfn_pud().
> 
> Only a problem on x86-64 PAT when mapping PFNs using PUDs that
> require a special cachemode.
> 
> Fix it by using the proper pgprot where the cachemode was setup.
> 
> Identified by code inspection.
> 
> Fixes: 7b806d229ef1 ("mm: remove vmf_insert_pfn_xxx_prot() for huge page-table entries")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  mm/huge_memory.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index d3e66136e41a3..49b98082c5401 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1516,10 +1516,9 @@ static pud_t maybe_pud_mkwrite(pud_t pud, struct vm_area_struct *vma)
>  }
>  
>  static void insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
> -		pud_t *pud, pfn_t pfn, bool write)
> +		pud_t *pud, pfn_t pfn, pgprot_t prot, bool write)
>  {
>  	struct mm_struct *mm = vma->vm_mm;
> -	pgprot_t prot = vma->vm_page_prot;
>  	pud_t entry;
>  
>  	if (!pud_none(*pud)) {
> @@ -1581,7 +1580,7 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn, bool write)
>  	pfnmap_setup_cachemode_pfn(pfn_t_to_pfn(pfn), &pgprot);
>  
>  	ptl = pud_lock(vma->vm_mm, vmf->pud);
> -	insert_pfn_pud(vma, addr, vmf->pud, pfn, write);
> +	insert_pfn_pud(vma, addr, vmf->pud, pfn, pgprot, write);
>  	spin_unlock(ptl);
>  
>  	return VM_FAULT_NOPAGE;
> @@ -1625,7 +1624,7 @@ vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
>  		add_mm_counter(mm, mm_counter_file(folio), HPAGE_PUD_NR);
>  	}
>  	insert_pfn_pud(vma, addr, vmf->pud, pfn_to_pfn_t(folio_pfn(folio)),
> -		write);
> +		       vma->vm_page_prot, write);

Actually It's not immediately obvious to me why we don't call track_pfn_insert()
and forward the pgprot here as well. Prior to me adding vmf_insert_folio_pud()
device DAX would call vmf_insert_pfn_pud(), and the intent at least seems to
have been to change pgprot for that (and we did for the PTE/PMD versions).

However now that the ZONE_DEVICE folios are refcounted normally I switched
device dax to using vmf_insert_folio_*() which never changes pgprot based on x86
PAT. So I think we probably need to either add that to vmf_insert_folio_*() or
a new variant or make it the responsibility of callers to figure out the correct
pgprot.

>  	spin_unlock(ptl);
>  
>  	return VM_FAULT_NOPAGE;
> -- 
> 2.49.0
> 
