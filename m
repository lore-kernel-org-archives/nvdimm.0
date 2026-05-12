Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010024.outbound.protection.outlook.com [52.101.85.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FA4306755
	for <nvdimm@lists.linux.dev>; Tue, 12 May 2026 12:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778590212; cv=fail; b=g3Wj8ABRzXNZDAHsissyVu0ebtev4BQFm0Th6NvaTc7p0WiTV/MnlIPTOQbVnyWCUbNc1YXkq3gn8Pvw159D5F1XldN94tNDGoE3gp2SWyDuaIcggY2stdYctqc57dCgn6fItXDaVpu0nC6KPXmsCIdeqlwQpChkHHhvME6H8PQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778590212; c=relaxed/simple;
	bh=tTTmOAIlATXMtbDyfioCPANUFmIc1Fdkk3jA92Ic3mQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=B3bbR8c7IFdAeNV8IGVbH+iqoczE43JiSE5SUiP1lWwKAT3xyQV9PuNifjVHbUJHVSjltobhVUKMBrOvWEOBk/XJFyw2RXzXtt9z0ZX24iyvxxg9zhoyM8XftjUQl6fSdSSkxF1x+893olMPrfLWkhPC+D+1ZUO5IWJ5WVSUNSU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bOhuXdqc; arc=fail smtp.client-ip=52.101.85.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bOhuXdqc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VWMKOt/BNBgT16LjpBRehxyjz2s5qrVveK3JEFGlWzvmaIYQmFbvg/aBjEERp8PaGpL2Oc0NUkiLrgGYEsgVn16wun6T9qI+jl8Jfg1XPEph0Vz3Ut/ziNGgyBK/ahz4TBqMKdgjf/q/NfQINYTBp8hCooe9Xb2JO+w4FYeTxSvax8SZ39OxfteiNPSdJBkuqBrPOMNcryePfIiUjTNcrrlJ2IXZ+ublf+eoyb6LyQC5+B3edwln4/Gh8BhptCdSV2UlmjldkQgVrSw97Nmx32rM/pmXSwywzW4Q5hLlYmp4SgqC0ZR8hIxFJFltZjp6eyBEXWlg2o0BQQqaF9BOzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wq4x7RB6aHUqOaBfTxJFL1AbLNVxnuKlzmBIKXgZPs8=;
 b=UpXTwFzCx/AyZJA/Dz+qvUuj/KFSjDDleEFseJwNYEtvtYlSYtitn9Zj9go2maMICf7DxlGu9ti8z2BawA8xgJeSQQBkuCgvz+aXaV2P82wgal3iphe04hgMDxWEKDqx0zR26ZNACgGAP8F68P105diRvKopshgjXaHC6caZGZSkNcoEsWh5HZUOpWGcQ3UBz2IeO6GD/dBjdgCy7wp8B8IJl9ppzgoR8J3O8xMHyq0nDANBUWbTCU/IcQ5Z4jXrfQLX1atWMN0jO/8Ju4T9vcklJnh00Pth1TH1mGUNb8PCZgY0KOxpeVkNw2OCFHJf0H8fBIiTYN6gOI1M2DzU2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wq4x7RB6aHUqOaBfTxJFL1AbLNVxnuKlzmBIKXgZPs8=;
 b=bOhuXdqc/ZEkNSdvooGuqMPwQVU3Facu6jRu3KfacvDBylRHg3N9kqhYjcykyi6brfjOquMW94vO2TDsd37PQo3DV32SaXjH9atZRGWg/qK6niSDeyuZ8M1S+SEYMO+Fl/xwhSt9VJlbLYjYbH/picPSmNxSZ1Vq4H3DQclXh9Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY8PR12MB7433.namprd12.prod.outlook.com (2603:10b6:930:53::22)
 by DS7PR12MB8370.namprd12.prod.outlook.com (2603:10b6:8:eb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Tue, 12 May
 2026 12:50:04 +0000
Received: from CY8PR12MB7433.namprd12.prod.outlook.com
 ([fe80::faae:d638:bdc9:4bf6]) by CY8PR12MB7433.namprd12.prod.outlook.com
 ([fe80::faae:d638:bdc9:4bf6%3]) with mapi id 15.20.9891.021; Tue, 12 May 2026
 12:50:04 +0000
Message-ID: <14a803f0-4872-4e5b-a2b4-4a26cc4cb27b@amd.com>
Date: Tue, 12 May 2026 14:49:47 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] fs/dax: check for empty/zero entries before calling
 pfn_to_page()
To: Souvik Banerjee <souvik@amlalabs.com>, djbw@kernel.org
Cc: david@kernel.org, willy@infradead.org, jack@suse.cz, apopple@nvidia.com,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260511214020.208939-1-souvik@amlalabs.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20260511214020.208939-1-souvik@amlalabs.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0139.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:95::13) To CY8PR12MB7433.namprd12.prod.outlook.com
 (2603:10b6:930:53::22)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB7433:EE_|DS7PR12MB8370:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b9d06a4-ba4e-41e2-6259-08deb024fc50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|22082099003|18002099003|56012099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	VmaHznCpfd9OrceSzWBBrXOZTklv9Wo2dJ3BIwo2isBF/A0E65w/AuUKPRVjQtIWrb1mLBeFUaI8eHJWKY7vCivrZFHFnLVQ79AQQmzhCVMPZiftx3/yvLdtysHW9epyTO2Ll+n4bTja4VZqcMQgZeH4OOq5B4WofIZ+HxQC2QICTM6fv4pGc7frPmQjGYwHdRsyKX4ShuzsZS/iydzff83r6p36cK/pg9gIDgGUS1TNQqo14Y4zoOeI0AXUshq83eOO8dH5jiOD09cN2940CS6kWkeUKNJlWiwzRd8gqPMYKLlvOm5Yrrsp7NRhAsrIs6mXt9jE9zDYvscWVl4IRg0wrdI5fwW9+oFRtRJEuh/Nq3AP9zfpJkbzoRrAvwodX4xitBLQvlYoruyYeYwmavwN3GG8LSSV4KF4lWaR7wm3ePOByKWPwY09ZNZ+vqH/J4SlpwoepJcyz+l5a+4teZJSCFvva82Tr5g4g3+4oMQjCzJt8k1rqkfCVPvg3SP3DqK+1rsJq429P/JwaUSTqUT3v8zVn0/hpiFnDCFF9n935zdep+8hcPL7MWR05sdBwPQjntL+sh+RksIsTI8VByCgvnjMbv0NJSpPlHdP7T88obPNB4ZMD+/rmgTDFDVc/Ot9DTUnSSOXjdmNEvehCJEYAc8x8pqfWNUFs2HXuVeE3Sw36PGCA39tcccb2pF1uemgIKk97jyctv/DjiE2Ag==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB7433.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bWdta1NQZHY0WnFTeko2TDY3SzNZc2R0QjNlSk90L00ybWdHQmMrNkdqaGxv?=
 =?utf-8?B?UmVKcU9BTjJ1WE9lSmphSGhBYWlzRFpjWkxLN0FwSlFhSnRuZ1FqUzkyRmtQ?=
 =?utf-8?B?NXJ2RkpRMENlUkVlZXR6aWlTQktCOHZZWmlZMnJsbmJpTkl4TlRDajJYT3Rr?=
 =?utf-8?B?d1dYbnhtZEk4TnJza3RrSjRlakdXSDI5TU95ZFNtaXZra2duSlYyaFJ2Qlhx?=
 =?utf-8?B?Qm50aW5NeWZEVmxGNm9ldFdJWWRQSWh3Tk1QbG5oSjhYVTJLajUrSlhWK2tI?=
 =?utf-8?B?SWVnQVhqV2d6Z2h2RFZYNElidFJKRmVVeUdJVExZc0hodHk4Q01RN3JQa2JI?=
 =?utf-8?B?S0dJbnlnYkxzVDZyL1hGWDJaUXQ5UlNpRm42QmZVSUZHcGVlZldDZVVlOEU5?=
 =?utf-8?B?MUtCTXdmR05EMXNoWXV5elJtSFh6MkxOR3VlQ01SN2FNeFpKcnZvMDNRMUpT?=
 =?utf-8?B?V0IxcWpvQTdFZlZZRTZ4Wkx6MzlLRkRXRy83TXR0SzIwaGtiQVBFNURNeTZP?=
 =?utf-8?B?WG9nOUw4MWk3M1hpYjA1NHdmUGc3Zk56RllaQncweTFLb1dxejdDaGdIRC9S?=
 =?utf-8?B?TDJRNE9nanhLU0k0SGJaczJqb2hkdmlvNWN0MzF2OW5LRWc3VDl6eE95S1NF?=
 =?utf-8?B?MXNLK1ZabkNaZlorbnBaTjY5ZEdLME5pTHJ5bng5cWpPdVBJTFZQUzJ1aXY2?=
 =?utf-8?B?QlhicEx1cER5Tjl2NmpMYm9xOUd1c2xaOVNqMUtjaEN1NVNSS3hGL1hjWFg1?=
 =?utf-8?B?T2NnN2RwM2Fvc1VNdFZiSUQ4UklNelRUK0ZzbktGckNJUSszUjQyUEpJVVVy?=
 =?utf-8?B?WXN6UVp3Z0lpaS9GM2tjM2hYSDZIY3d3cFZIM2pSYmpCbm4xOXZJNmN3bzBh?=
 =?utf-8?B?SENzVnIvUVN5R2tVZXFvYStINGdwaHV5NGN1Z1VqditTQm5LZ0ZxZStXVmFQ?=
 =?utf-8?B?bU1Db1lGTlpUcHdKSWgvbUdLK3VoVU1ncXpGWU8rc1JFanhNQStneWVTNXcw?=
 =?utf-8?B?dmlpbW5yUk11bFhua2wyOHRMQnZiZXRQZjZGMlIvRytVOE95ZXZFRGhTTWVs?=
 =?utf-8?B?Y0NMeHBKOHduYXpQOEpHNStvbGNQNHZMSm82MCtqRVVJdmZCRUJiWkNKUWdN?=
 =?utf-8?B?RmJkRERzSHI2eUV6MHY2V0RsRGFHaC9yTlFhZEY4dEk0K0FRQ3o2WDBCQ1lw?=
 =?utf-8?B?Wk9vbnFmT2NKbWJNeXJ2cXo1SXEzZXIzRmhYcVdYZG5yOUtKdTQxbjE1OHN5?=
 =?utf-8?B?cTZwOFlOcitBanRkZ1RvWGR0WGxkQnE5T1RqUTI2WCt1UlQ3ZGpDaHhTdjhO?=
 =?utf-8?B?WUVTZUVsb0NFa0g4OERQbEc3eHJmNFFQU2p0YjJUc3FUOXNDZ1RyMHM5SFov?=
 =?utf-8?B?UGF5NFJscDJ2eEVRLzBUQkFERlJjbUFSUW93UTFhYzNJUEpYbis3VnFkbkln?=
 =?utf-8?B?aXBmR083cTdqbkNkb21tK0RaMklVVm5FOS85SFJMZ2w3WUVXblBqZ2U2NXZ5?=
 =?utf-8?B?Nm1iR0xBWkpaK2x0UmtSY21mZ1VoTTZYQWdtZitMaVZ4RlN1cEI4ekZsT0Ji?=
 =?utf-8?B?LzNOU0Z4MHdNTm5yRDFBQ1FTdXlVbDdDRENFYjNzeUxpd0x5NER5NzJDQStx?=
 =?utf-8?B?TEVTZFFvSVJuRnB3eDFWT0t2R29hM01HL0ZzenRXbkhHM1grZXF4TytMWGp1?=
 =?utf-8?B?WDhWelJ5T1FweDAvQVRNQUIzYjByZEJYNDgzQnllbzE1dWQ0R0dnT1NzVWRv?=
 =?utf-8?B?UTN0Uzd0RDM2NjM0c0wwY0xiTmd6bzgzTjBnamxNTjBiL0tZT244bXQ1MmpD?=
 =?utf-8?B?eXppaWhtbzlOU293cVFIbWJEcS83aHdkTVA5eUhjR0F4L1g5em1aSTltNU1k?=
 =?utf-8?B?d3JMckhRSnQzUXZkcFZpZUkxdU43TUZGbjBXN1BVL1JkR0V5bDZGMS90VThJ?=
 =?utf-8?B?SFF5Uno5dDBGOXpnYyt1amFKc1FXa0hnQVphWk1YZGd1d3J0eXVNQlZvcXBS?=
 =?utf-8?B?czM3WDdwWEdhVzIyMnlCVlcvNUxXV1cramkxalIvTlRrdmpBMUNhUllzMFBz?=
 =?utf-8?B?WDQzeTFVMkJEaTlvV25oMWVWMVVNUCtNYXZDRkdaaG9OZWZKaUk3RVB0TjVV?=
 =?utf-8?B?eDdQY2grQUZ1SjhZQW1oZnhpVDRLTEwyYTNPNFlBZllJdkk4Z2FSaW11c0Uv?=
 =?utf-8?B?bjB1YWRiaU1oQkxWTWpvQU5ISGN4Tk5ObHRrSmRLYlUvcTdvclNOcURZdC9R?=
 =?utf-8?B?UjhGeU9FSy9xRUh0RTAyS2ZYZ3lveU1VUWg0RDE1a0I5R3d3aWJaME1BbWNM?=
 =?utf-8?Q?Bby1m/cfqfNy84KbmW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b9d06a4-ba4e-41e2-6259-08deb024fc50
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB7433.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2026 12:50:03.6157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /bJcj3ngvpOFhEiooPPJEnqTXeMYPw1QcABhpXw/6CrT5VWohCTspkLdjf0OHCWLyTQfa1OZ8F7K4SXZl6rgpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8370

> Commit 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
> added zero/empty-entry early returns to dax_associate_entry() and
> dax_disassociate_entry(), but placed them *after* the
> `struct folio *folio = dax_to_folio(entry);` line.  dax_to_folio()
> expands to page_folio(pfn_to_page(dax_to_pfn(entry))), which calls
> _compound_head() and performs READ_ONCE(page->compound_info) -- a real
> dereference of the struct page pointer derived from a bogus PFN
> extracted from the empty/zero XA value.
>
> On systems where vmemmap covers all of RAM that dereference reads
> garbage and is harmless: the early return then discards the result.
> On virtio-pmem with altmap (vmemmap stored inside the device), only
> the real device PFN range is mapped, so the dereference triggers a
> kernel paging fault from the truncate / invalidate path and from the
> PMD-downgrade branch of dax_iomap_pte_fault when an entry is being
> freed:
>
>    Unable to handle kernel paging request at
>    virtual address ffff_fdff_bf00_0008 (vmemmap region)
>    Call trace:
>     dax_disassociate_entry.isra.0+0x20/0x50
>     dax_iomap_pte_fault
>     dax_iomap_fault
>     erofs_dax_fault
>
> Close the residual gap by moving the dax_to_folio() call after the
> zero/empty guard in both dax_associate_entry() and
> dax_disassociate_entry().  Apply the same treatment to dax_busy_page(),
> which has the identical pattern but was not touched by the prior fix.
> dax_associate_entry() is reachable with a zero entry via
> dax_insert_entry() -> dax_associate_entry(new_entry, ...), where
> new_entry can carry DAX_ZERO_PAGE (built by dax_make_entry() in
> dax_load_hole() / dax_pmd_load_hole()).  dax_disassociate_entry() and
> dax_busy_page() additionally see DAX_EMPTY entries created by
> grab_mapping_entry().
>
> The remaining users of dax_to_folio() / dax_to_pfn() in fs/dax.c are
> either guarded or only reachable on real-PFN entries, so this exhausts
> the anti-pattern.
>
> Fixes: 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
> Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
> Cc: stable@vger.kernel.org # v6.15+
> Cc: Alistair Popple <apopple@nvidia.com>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Souvik Banerjee <souvik@amlalabs.com>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
> Changes in v2:
>    - Also fix dax_associate_entry() (Suggested-by: David Hildenbrand,
>      confirmed by Alistair Popple).  The same anti-pattern existed there:
>      dax_to_folio(entry) ran before the zero/empty guard.  new_entry on
>      that path can carry DAX_ZERO_PAGE via dax_load_hole() /
>      dax_pmd_load_hole(), so the dereference reads a struct page derived
>      from the zero-page PFN before the early return discards it.
>    - Audited remaining dax_to_folio() / dax_to_pfn() call sites in fs/dax.c;
>      no further instances of the pattern.
>    - Updated the page_folio() expansion in the commit message to refer to
>      the current field name (page->compound_info via _compound_head()).
>
> v1: https://lore.kernel.org/all/20260501233933.2614302-1-souvik@amlalabs.com/
>
>   fs/dax.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/fs/dax.c b/fs/dax.c
> index 6d175cd47a99..4bca6e2bc342 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -480,11 +480,12 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
>                                  unsigned long address, bool shared)
>   {
>          unsigned long size = dax_entry_size(entry), index;
> -       struct folio *folio = dax_to_folio(entry);
> +       struct folio *folio;
>
>          if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
>                  return;
>
> +       folio = dax_to_folio(entry);
>          index = linear_page_index(vma, address & ~(size - 1));
>          if (shared && (folio->mapping || dax_folio_is_shared(folio))) {
>                  if (folio->mapping)
> @@ -505,21 +506,23 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
>   static void dax_disassociate_entry(void *entry, struct address_space *mapping,
>                                  bool trunc)
>   {
> -       struct folio *folio = dax_to_folio(entry);
> +       struct folio *folio;
>
>          if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
>                  return;
>
> +       folio = dax_to_folio(entry);
>          dax_folio_put(folio);
>   }
>
>   static struct page *dax_busy_page(void *entry)
>   {
> -       struct folio *folio = dax_to_folio(entry);
> +       struct folio *folio;
>
>          if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
>                  return NULL;
>
> +       folio = dax_to_folio(entry);
>          if (folio_ref_count(folio) - folio_mapcount(folio))
>                  return &folio->page;
>          else
> --
> 2.51.1
>
>
