Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D412D299
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 02:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749694689; cv=fail; b=dpNi7Q0RIV5+Pb3T3PoBPmZYymg/yhIw4Xdy5Z6vH3lsMawnvh89Ire18Yjte2AsUtdWXmB7Cq42t5EaF9Iz71W4ZV8Tgd9GuQcfVKGtgV2/6UZFmpW4G9oHoNbN9V6nD8P843Sl+khzmaSe+0dZ4eFTWtGWGaDDS6aQqhwYgNk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749694689; c=relaxed/simple;
	bh=GA3MANkeMnv47jd/IN0e2AOZhTi3HX4lIYNLum8y4gU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WrRQAtIGG+r+L61MFQuRTNjpooDv98XF1PzzBVObx7+HtD+DMXEV7qCTnb6DY/faFk1xaND3JbARM1YvBP1qKkKBAXSWweMkIWkqlZQ1G7h0vzt87d4Lsg5L5x1ldbvxC8xUAiTl02E96KV1DHdcXUvXMPwpqLhIVkghcFQPAd8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ef+a6+96; arc=fail smtp.client-ip=40.107.237.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ef+a6+96"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p4zyEp/VBO6Jl2d7aFt6mqGQ52cBv3/U6eqo/X0fVXZlhXO5fq7owuHnvmkZ+VBB60t+6qDj4yK202h3CsnWrQ7qLQz9O4PjoHSaQc/YQ0s1IXVZXKY0tHCz5jsisZa+pl61MerhbLBWHpCva7aEpxTAbP1kOHMIqWafuEpsUPKk9ALB+jDDZLOi4F7QsMhw9jhAGHp+6w7gWoegAisd+rMJecYKbv7yZ37uQ1Nvpqy5hWix2JqQHbGyW16aHMb5iDImEq7+F86KQ65nLwBdfpSEYdREy+p2GoruGpWoxuFH0v+amXanvCgLVW0rIsF7G/ApO4c+tXdBHLvueE5eFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H/rLOIIU5BYemEnyVaYUun7CBjcvU0TEkTGlJp0mqfs=;
 b=SJJ2vxwvT5wXmulpgEpykRcXOcuInTa7415yyp5OCelBOKMTiAqVIKyjpzrSOCvJF8IAEy7CBeVWdInYVBnM17jE9spwBcexhf7IMBO6MkOsMcOz11P2gHnNPjhqX+3oJf3DinRe2GdgH2tOucGujzl8mBo09IDiazfVkAn/E0Vs6Sq9IGNb33Ri3BcJC3PrOeeyX0kNJL/em1H4hJ5LKqpCMKcyM+nidaW4LIctBuSRyGzOsO+wlmXG9Jt68+JYUAMQoHRxV6B5AqvKSN/keVafHAkAHH/9DPyDFyb23l7qj2ryC3cnkHTSufJNCrdKQKiXH6HaMrbT6EG/Bqi09g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H/rLOIIU5BYemEnyVaYUun7CBjcvU0TEkTGlJp0mqfs=;
 b=ef+a6+96XZJpWlnaEB5lBQstITa8ZHAHUWy651rKWEjJWD6BosIkZQQqOz0cNXl98uObGql66kI1fMpLTjP5qjYsDN9/rVQlEC1SjMC98n/cOSdhiiZyzMHxVdshn6TRShaJTrtxgrXf6b8F/LtsMtFaWeSNZDuNoKBvDH+UhSWM+YGV4D8kun0WQVbF/TsE5j/05qp8UUkDA7mkQB4IYr0SVqRUWh/vPi6qp2AJvwbUUJg623SKpS+qL5zFXB3f9PZEsW3LGJEsBpPbK/HP3ZqdZI2Nh+VS1RWoVtY67FkXYV99ZeMO2+eMxO76PBboH6So/lqpo3Z76sCGf5ZCUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS0PR12MB7728.namprd12.prod.outlook.com (2603:10b6:8:13a::10)
 by CY8PR12MB7609.namprd12.prod.outlook.com (2603:10b6:930:99::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Thu, 12 Jun
 2025 02:18:03 +0000
Received: from DS0PR12MB7728.namprd12.prod.outlook.com
 ([fe80::f790:9057:1f2:6e67]) by DS0PR12MB7728.namprd12.prod.outlook.com
 ([fe80::f790:9057:1f2:6e67%5]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 02:18:02 +0000
Date: Thu, 12 Jun 2025 12:17:58 +1000
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
	Dan Williams <dan.j.williams@intel.com>, Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH v2 2/3] mm/huge_memory: don't mark refcounted folios
 special in vmf_insert_folio_pmd()
Message-ID: <xdkrref3md2rfc3sou6lta2vcevz6e4ckjd6q67znpipkvxbmw@gftpxkrtlqnx>
References: <20250611120654.545963-1-david@redhat.com>
 <20250611120654.545963-3-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611120654.545963-3-david@redhat.com>
X-ClientProxiedBy: SY5P300CA0027.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:1ff::17) To DS0PR12MB7728.namprd12.prod.outlook.com
 (2603:10b6:8:13a::10)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7728:EE_|CY8PR12MB7609:EE_
X-MS-Office365-Filtering-Correlation-Id: 747694ce-34d6-4ed5-8d4e-08dda9575bcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007|27256017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cES7TEmgcz0X22F0JzTPyfdsWKWarXPuyBiLSwb/Joql6UukrC3f/6O0T2EU?=
 =?us-ascii?Q?aJhRoW3q8v9oeNo0arr2xf3fUfT0bkTaj9CHGTcYZ8oh4nx6ADwf+kv1MkRG?=
 =?us-ascii?Q?Fyvh4evuryO0fW+qdteHEjOEoSVH3cmf+YpNZy0XIfUgoOCGSmY+rmfkB5L/?=
 =?us-ascii?Q?6eb8DVZk0ZKc1+Sp923IJXgRt5yejFCO4uDB8/8jyMRj+ZMEpzK1GMBOOmQF?=
 =?us-ascii?Q?gnAOzggGmYudkeAxDs3gzRYmPs2kRKB5Q1ZRU6q5fS0wxZbsOj+KC7vA4uBj?=
 =?us-ascii?Q?lRkiOP3AnnRdJko3o4s7U6IKt68FvYks6ALnQ2OFueHWHH/Oi1f2ob13JMzG?=
 =?us-ascii?Q?4rKDXiF9+rr4PWi+c8889aWz0XfgE0J1677GWQaggNnxaVQ78BzfPPTrhrvA?=
 =?us-ascii?Q?bRZEEA6hL4u+6poPzcIzjxdLBEntd/M3ZS6dGbPBLA6W7UAWSTqEsLq3EGzu?=
 =?us-ascii?Q?1pSR07lMrYB1KywERUa8ByJk/i9ObyoRug+r1SMf97FeBMcjTdzCRZA7z+XM?=
 =?us-ascii?Q?QeWFQR5w5rUlgGL312maExqx06/Erg14sfSsbCwmKHzjoUL2YbP9h2wmFdWq?=
 =?us-ascii?Q?ArTghgad/0j54y1chi2OXRdlFAyi5pLRyau1LZTMxVPvNAavyHjNLw6qBZ5K?=
 =?us-ascii?Q?qXkTfNb1VhlRXclo+8nYzczOvbZTiQySlgqN5pnjfw5BD8eGYWBRVhXIQy01?=
 =?us-ascii?Q?LtYFLjJd97DqROunJXTq+Pgg0PuZc4tgX+7vonG6u0gEpYxRitXKj2h3cJxH?=
 =?us-ascii?Q?DPulAkdY3UU94n8IwEUyAr2sGK12QkIuX/UM08a+lTxuVQC201nWIaz49eZ1?=
 =?us-ascii?Q?5qXrePGG+FpS4L+MJNKGhZnT9Yja7hFQaRZlryobU1Kv8LQtyu/8jmI8zX54?=
 =?us-ascii?Q?T1aOx6HI1FEYZihdthHrcAZrVhQXYcpb8xtK1L6r68krlvnrmrHJ0n8VFEdW?=
 =?us-ascii?Q?Yoq1+grrPtj7K14wCF7roVVFfZlzuIRCnj62DwKvuXwy6Nn5BAOeKy+V0IOV?=
 =?us-ascii?Q?XgUqjyzfTL7g6OzJ/1+yCRS1a9xaSnCMgyCrDEm4B4+exwt1tljEwy4btcX9?=
 =?us-ascii?Q?tRjooywQkVTAmUJQbeRBMd2kB6o1v/zMWhRoJFcp4QV8wIK/d7PVLCN+xJdl?=
 =?us-ascii?Q?q1EQrJTJnHkiZ0CHLYoaTdDnCrJxoQw+dja7oBJ4QrrpzjpFFa2oQSn4GBbg?=
 =?us-ascii?Q?ZkQ3hmpcOJ5AoNLr6yxkW4xJHez6tjWqyK/4P6OrJOWxbeuwJ3u2h8wqBgO6?=
 =?us-ascii?Q?XF+kXnflX498ZCThdi3hdFqnhRts2MdeA560CkqW5KmOHN891PJRcuNLTSqf?=
 =?us-ascii?Q?GKmEZ2P2AMGuesDmwFe+gkvkFm6UbArNR/VtirvkaytkKpemd8Ap8Ssg4w+a?=
 =?us-ascii?Q?Hpo1NB83EBUD9LTODWa98Y/7Faie1n0cskEsqIfH07EanjO8RK7SMm380MxR?=
 =?us-ascii?Q?aZ89NtxpYOQj3lRof+ojUWG+TN0lMFGzTnpC3WaW1or2kOGmpgxHVw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7728.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007)(27256017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zOZPWcxcTg5AKVrKQu2yNHp3ts81coul7kLvrxPGVQTkQvR5F+0RjSXg+LvS?=
 =?us-ascii?Q?E0CPflhcdXZmztRE6sYRarElXE6pNzJWr7oC+gfJxePiJw0T4ocdtSiU66Vp?=
 =?us-ascii?Q?7W5nR2UDdd1SLSN4qMQXpYjE+0WYJP6VWsOpxgmIcZdmsDFU4Np1lbD5gCe/?=
 =?us-ascii?Q?bS/mI+w1YRaenAzc8sgdWXCyCmZNScoB1TGy8bLE5s1g+gSoiGAz+jhebWHh?=
 =?us-ascii?Q?PV1CrCxjlTnlP1MLPjmuS3QDOTH9nFzc4eCZsA2E6B+FSID+EAoZOUVXHzBT?=
 =?us-ascii?Q?FWB/KIPybIjeLkzTLFLCH1oRA9CRnDQiRxtOzdz3+nWIoqyTMw5c3XEt22yd?=
 =?us-ascii?Q?GLQ6YDNgy9aGSos1CSTpuB8x/Eut+gVQLiHtGMGzpNZZHXvA6Fdn++Vi1hXo?=
 =?us-ascii?Q?/UwyMNRMTQRpAUu3Y1EUyR6Xtkz3gmcbIMEBEHIjv/JpJ+0ivd0Ky7HS0qYD?=
 =?us-ascii?Q?ADeTC+6dhMZTdB18fj+ptc1o3SWfCqESQ6NqK79SKxTk3RKbnFpWv3Ih6Qsg?=
 =?us-ascii?Q?4QsBIJnKmRFeR7/1LrW3elu43RGvRx8012ZqGMxxZD9nP5vSHDOqy4rqjPIM?=
 =?us-ascii?Q?D3I2zjr7470kCT5W/s48L7Whxxnc45bWFWuNqBkpDiQ7E8Tgl/MLfdUKfQ8T?=
 =?us-ascii?Q?6XPgisxZPnDzyHdSqEQy4La16LRclpKHh13oWKjlVGael9bThS2fMOkbXfPM?=
 =?us-ascii?Q?TM6IawnhYc0uIHAMBtLIFdI1OaFTt3RFeP+/XTi2psz/9bCZTevUIFY1lECd?=
 =?us-ascii?Q?pdfpohdOdCEuZdUHBhJB73t55oXmueftUrVa3qNDgUS/EmX/+fEEPy3cBIZu?=
 =?us-ascii?Q?9aD7D7KtDspsyeXy3im2cIn3OUwr/2G0cgwC73fX9IeYfI+ucdRN7/5TqFjA?=
 =?us-ascii?Q?H2o+wRlbxH2Sa8fK7TihJmgqcAxg4gW/7ue7KBYVp5rs0wcxH5JxiOFWL8lf?=
 =?us-ascii?Q?ltnzLXxY9jDrflcNn+1mviOBgh/R+3kvxsWJoLPBvdTRvM8MXjvYMBNQOy6W?=
 =?us-ascii?Q?X80E8MgEtu1aIQIFu2FE3mv2qPp3ofZs0ahTw8GevLu6K+F+w+auZNlVasSy?=
 =?us-ascii?Q?ghvMKoQWlx30zAm3WX1adlSn4sz2x7+0QvEYWeesEfWuLMQ83FuoybSCQ6Yj?=
 =?us-ascii?Q?V1EnOdbmVPR7Zx2EFljQWiDyFe7P53nNzy/2GroJDQYeZ1AuA8YWr6hFMs2l?=
 =?us-ascii?Q?78/WVxAEkVM3m0Y9VAhhB4i3x+JPWt8lfQI9OsF+t4DvgwVz3eSZMIXb5hBa?=
 =?us-ascii?Q?cSZf831mvzpmpzzk3W206QsyYchq5+KxtN/5lEmEjMsQbYAWoRnaIX3kUFb1?=
 =?us-ascii?Q?RyFHut3FSLSmaWjQVaGggBgKRXbmS7Pc4a/Hyx1I9cB8MEUmszm//8Jm+6kQ?=
 =?us-ascii?Q?yWeXQiNA7bAg/aA5aD5gyqBX5bgddMEkDNoyexYhe2HzLuzVGX9tZNHbTsdw?=
 =?us-ascii?Q?N7+Z/pFD4vMDwQ2GL7QCg+Zs9O1MnPFgj3I+htfEpKzV+BbpHLPJTjJevs9L?=
 =?us-ascii?Q?VMuMTM8V0p6jh4jDxEckoBIzAZDfzsMMEigjvUfaUJ2a2jdxOepe/7Z4v4ec?=
 =?us-ascii?Q?G7yTQDYF6b7NhT0MNLrBb3qRder4TwLPGcl3fztN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 747694ce-34d6-4ed5-8d4e-08dda9575bcc
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7728.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 02:18:02.7012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bc6fJXfiPmqlzLhSOFdsB1R6xO8ZtxbxDjsR4wzgex/0xOoCuS3yGB0+JFdEqV9PtyExYD9N9IsJse9H8Y+rcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7609

On Wed, Jun 11, 2025 at 02:06:53PM +0200, David Hildenbrand wrote:
> Marking PMDs that map a "normal" refcounted folios as special is
> against our rules documented for vm_normal_page().
> 
> Fortunately, there are not that many pmd_special() check that can be
> mislead, and most vm_normal_page_pmd()/vm_normal_folio_pmd() users that
> would get this wrong right now are rather harmless: e.g., none so far
> bases decisions whether to grab a folio reference on that decision.
> 
> Well, and GUP-fast will fallback to GUP-slow. All in all, so far no big
> implications as it seems.
> 
> Getting this right will get more important as we use
> folio_normal_page_pmd() in more places.
> 
> Fix it by teaching insert_pfn_pmd() to properly handle folios and
> pfns -- moving refcount/mapcount/etc handling in there, renaming it to
> insert_pmd(), and distinguishing between both cases using a new simple
> "struct folio_or_pfn" structure.
> 
> Use folio_mk_pmd() to create a pmd for a folio cleanly.
> 
> Fixes: 6c88f72691f8 ("mm/huge_memory: add vmf_insert_folio_pmd()")
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  mm/huge_memory.c | 58 ++++++++++++++++++++++++++++++++----------------
>  1 file changed, 39 insertions(+), 19 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 49b98082c5401..7e3e9028873e5 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1372,9 +1372,17 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>  	return __do_huge_pmd_anonymous_page(vmf);
>  }
>  
> -static int insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
> -		pmd_t *pmd, pfn_t pfn, pgprot_t prot, bool write,
> -		pgtable_t pgtable)
> +struct folio_or_pfn {
> +	union {
> +		struct folio *folio;
> +		pfn_t pfn;
> +	};
> +	bool is_folio;
> +};

I know it's simple, but I'm still not a fan particularly as these types of
patterns tend to proliferate once introduced. See below for a suggestion.

> +static int insert_pmd(struct vm_area_struct *vma, unsigned long addr,
> +		pmd_t *pmd, struct folio_or_pfn fop, pgprot_t prot,
> +		bool write, pgtable_t pgtable)
>  {
>  	struct mm_struct *mm = vma->vm_mm;
>  	pmd_t entry;
> @@ -1382,8 +1390,11 @@ static int insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
>  	lockdep_assert_held(pmd_lockptr(mm, pmd));
>  
>  	if (!pmd_none(*pmd)) {
> +		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
> +					  pfn_t_to_pfn(fop.pfn);
> +
>  		if (write) {
> -			if (pmd_pfn(*pmd) != pfn_t_to_pfn(pfn)) {
> +			if (pmd_pfn(*pmd) != pfn) {
>  				WARN_ON_ONCE(!is_huge_zero_pmd(*pmd));
>  				return -EEXIST;
>  			}
> @@ -1396,11 +1407,19 @@ static int insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
>  		return -EEXIST;
>  	}
>  
> -	entry = pmd_mkhuge(pfn_t_pmd(pfn, prot));
> -	if (pfn_t_devmap(pfn))
> -		entry = pmd_mkdevmap(entry);
> -	else
> -		entry = pmd_mkspecial(entry);
> +	if (fop.is_folio) {
> +		entry = folio_mk_pmd(fop.folio, vma->vm_page_prot);
> +
> +		folio_get(fop.folio);
> +		folio_add_file_rmap_pmd(fop.folio, &fop.folio->page, vma);
> +		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
> +	} else {
> +		entry = pmd_mkhuge(pfn_t_pmd(fop.pfn, prot));
> +		if (pfn_t_devmap(fop.pfn))
> +			entry = pmd_mkdevmap(entry);
> +		else
> +			entry = pmd_mkspecial(entry);
> +	}

Could we change insert_pfn_pmd() to insert_pmd_entry() and have callers call
something like pfn_to_pmd_entry() or folio_to_pmd_entry() to create the pmd_t
entry as appropriate, which is then passed to insert_pmd_entry() to do the bits
common to both?

>  	if (write) {
>  		entry = pmd_mkyoung(pmd_mkdirty(entry));
>  		entry = maybe_pmd_mkwrite(entry, vma);
> @@ -1431,6 +1450,9 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn, bool write)
>  	unsigned long addr = vmf->address & PMD_MASK;
>  	struct vm_area_struct *vma = vmf->vma;
>  	pgprot_t pgprot = vma->vm_page_prot;
> +	struct folio_or_pfn fop = {
> +		.pfn = pfn,
> +	};
>  	pgtable_t pgtable = NULL;
>  	spinlock_t *ptl;
>  	int error;
> @@ -1458,8 +1480,8 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn, bool write)
>  	pfnmap_setup_cachemode_pfn(pfn_t_to_pfn(pfn), &pgprot);
>  
>  	ptl = pmd_lock(vma->vm_mm, vmf->pmd);
> -	error = insert_pfn_pmd(vma, addr, vmf->pmd, pfn, pgprot, write,
> -			pgtable);
> +	error = insert_pmd(vma, addr, vmf->pmd, fop, pgprot, write,
> +			   pgtable);
>  	spin_unlock(ptl);
>  	if (error && pgtable)
>  		pte_free(vma->vm_mm, pgtable);
> @@ -1474,6 +1496,10 @@ vm_fault_t vmf_insert_folio_pmd(struct vm_fault *vmf, struct folio *folio,
>  	struct vm_area_struct *vma = vmf->vma;
>  	unsigned long addr = vmf->address & PMD_MASK;
>  	struct mm_struct *mm = vma->vm_mm;
> +	struct folio_or_pfn fop = {
> +		.folio = folio,
> +		.is_folio = true,
> +	};
>  	spinlock_t *ptl;
>  	pgtable_t pgtable = NULL;
>  	int error;
> @@ -1491,14 +1517,8 @@ vm_fault_t vmf_insert_folio_pmd(struct vm_fault *vmf, struct folio *folio,
>  	}
>  
>  	ptl = pmd_lock(mm, vmf->pmd);
> -	if (pmd_none(*vmf->pmd)) {
> -		folio_get(folio);
> -		folio_add_file_rmap_pmd(folio, &folio->page, vma);
> -		add_mm_counter(mm, mm_counter_file(folio), HPAGE_PMD_NR);
> -	}
> -	error = insert_pfn_pmd(vma, addr, vmf->pmd,
> -			pfn_to_pfn_t(folio_pfn(folio)), vma->vm_page_prot,
> -			write, pgtable);
> +	error = insert_pmd(vma, addr, vmf->pmd, fop, vma->vm_page_prot,
> +			   write, pgtable);
>  	spin_unlock(ptl);
>  	if (error && pgtable)
>  		pte_free(mm, pgtable);
> -- 
> 2.49.0
> 
