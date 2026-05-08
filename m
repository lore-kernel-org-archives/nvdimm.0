Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010008.outbound.protection.outlook.com [52.101.61.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A76940B6E0
	for <nvdimm@lists.linux.dev>; Fri,  8 May 2026 16:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778258670; cv=fail; b=PvLmIHKwvGt1AJw3VjkdWeNUQIgMsao2rQuSU1sgbLgHrGbBg+kMVcdyNOe9kgfDExLs//1nZiXnK9pKdljFqKfSyi3R6q/KroGTXvcPDIB9NCdIjeJRxXurUo37qEPSt9k3AEefWg2zpgw6UOk05rtukY+HNaTv699z0G1BUkM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778258670; c=relaxed/simple;
	bh=EC88jfShMkaBPHaXeTMGSTVappROdKTj5C42uzps0m0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RgXACZIgBGcpEwhu+xsI5KGnkQ2aEdkGx6bWjarYt1cWNoKksXjuttyzeYrdS5Gg03hs3dYt5TU2MvTOvQe4MgWlruxqyXKwCNbkj9S4KTd250A6hxrIZQzdBdaroAA/UYz8nEDLDSh9hGOFJ1Bz+envrx6lIJb9ONNJdbAZkms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LRjbjRXY; arc=fail smtp.client-ip=52.101.61.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LRjbjRXY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JQ1ndRvTbUzxyuKHC7RD715/9dG595yKo77JVHFXgaj8gkL5RQVzhrT2mzMDdz5eLc9k9d46gr7BLE56fRs3ZRqabgPDYoroJWL/cKx2/ukMVb3vUdKyQvaB0+YBGbyn+D0W/m6QA9l0M3wn4ak7AvCLbVQzXxQ1Ur+QxT/t1nq/c2Hous7gmN1Dm5us4fKk4zeIUbq2gQKaOPq5wi/2J5syRqa2s36tkDnhZzHFsABHaAO8VQktUbcFjYTOXdM6FGHJ7MOee6PuOY40bS8nLGyC+yZG82xt22fFgejrrF9cRCzTFcZPowBDu3Oo24eV7kGMoHwKQft8lp/srUEYIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JVh+mJ/1nYCzawy+c7Ai9Nk2MN+bNm1fAl8GRPeZ248=;
 b=YQeWCvBzKsLyxWLXBPakgElEtB1Z5RsT1g75gKxQWaLlhn7dS7Dq0exe2gURGXFFE/8wr+Co38VIyGsh6d+vK3GCq5xaVJfPznHJfUfHU2miwz7gJWZ2cnxN0y7mB7kv8+SdMb/M2CbnYyQC9ok6hNpTwHUrKA/9QpfMm/263kFfocHAudRMVKB2TsTorkBTYfHLJQdLlLkRrNzvW7fqCqjc6Ris1laQ2TkSUVihnGZEvF3gTGJgkswfq2MmCNcb0d7dr9SdOXUkyj4b5+nRCa/X2YDug7fGVsvIwBE4ox6p4WrvJfq7om4nD7PTbXIhd9Bh1bgjYjfJDtbRGAu4jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JVh+mJ/1nYCzawy+c7Ai9Nk2MN+bNm1fAl8GRPeZ248=;
 b=LRjbjRXYj+hNgz1pZW6TX48j1ZANN/M03fd5EnNTGJhmaPqe+jDgfcllKkCcpsPj/PIRzaTl7n51ccbiphHLAxGtSrBl3bTj+bT38gpM4XGyPlch8NY1xfEUYnDpduRAx+x8dJKjXqm2Vb9TVtyKyUhWv8iS9uHK/CKPKFgrdso/L9QFdWuzRvUknT+6ZflJfwJPvR5i+R9xjrAy2KBOPCuGBrlOuKwKO3U0gJA0tAE1g+HA7XhanDFGF9njF/HAb6omM3uAr++TqR7Kph2Cjg4tikbdx54vz3W0oyHhbEs1nZnlSRUqWDugExxJkk85mqjTtea30FN6R9s7EIzhPw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 CY5PR12MB6528.namprd12.prod.outlook.com (2603:10b6:930:43::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.19; Fri, 8 May 2026 16:44:24 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.20.9891.008; Fri, 8 May 2026
 16:44:24 +0000
Date: Sat, 9 May 2026 02:44:14 +1000
From: Alistair Popple <apopple@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Souvik Banerjee <souvik@amlalabs.com>, dan.j.williams@intel.com, 
	willy@infradead.org, jack@suse.cz, linux-fsdevel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] fs/dax: check for empty/zero entries before calling
 pfn_to_page()
Message-ID: <af4SR5-QwUCAClR8@nvdebian.thelocal>
References: <20260501233933.2614302-1-souvik@amlalabs.com>
 <a708a295-9d80-4538-9d12-53c12820f9ed@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a708a295-9d80-4538-9d12-53c12820f9ed@kernel.org>
X-ClientProxiedBy: SY6PR01CA0006.ausprd01.prod.outlook.com
 (2603:10c6:10:e8::11) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|CY5PR12MB6528:EE_
X-MS-Office365-Filtering-Correlation-Id: ab7b36a0-3363-4dc1-cac2-08dead210fa4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	kmAd7uc5LmEOqL4eQB6Gps32pmXqPFbNZVyHRL8XfRIE8JNFsky1baTmojs7F8/djBButoXSzzuYPUr5gE0Kmy8zQB0mVNuSQjBidau9U1RClhQMPVbqFueBttsczBcqjmjyY1kMC03dG1BVswOLoNWmyUd9Ads6BKUWwWM6hklGSlhSOMygTnU9eqzmFrcTIayhw0pfg4qDWwRdv10DOG90lwl5OdmZv7Uolf6LCBdk32bS4I4RYCd6UCNxxeNKYk04xWfZl4K1P9DZ2GB1djZZkaXU47M6t/hXXnRc/P7s5qmUxVwhhdoSjst15Y1FJQTK9JzY/+GOhKw2KmIldAPfLYUNlEHwi12YrmT/IipnupjBMJGkCb+3uzVLqzKhhrlkiK2tJJQlxA0wbkXDJzz7KG2Gcv+Mii7xItUj9Nou4TCgQMP3yMFB9U4EX/rIbCnkJYGed2T/8ElTxhYRujumojpY0vA8sO5p7j44OZfpyA2wytub31ILFmrdYV51EFcA3SFWtXwMDloMNab0pjTdjLr/nQtwf1K0/cbUcYD6o3KhLmUTTtscPE8HZXJ789+fv6OZqvxm4RwQUlmheEc31i7fZibyI45bxrTwE/6MXFsTlt7660JYWFqZaa2v4JHt24uLIWNUfYe8ctSeZUJMewmwRjehQx4A0ObKxozHMZO0fUT257CrDbPjapXt
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bg+ovCIMOvPnQmErLf83WVuE+t2QKnysoZDcxh7nUkk5YTIHOggaUOeJVDcr?=
 =?us-ascii?Q?XfO7DRFkYWEBmyeCrK8A2JdiQXQx2wvDTVnxflzz6EwdP4N/A1gluH/v88q8?=
 =?us-ascii?Q?/ZETSStScNS0B+lN1OQ5o9t051SB0J7bEBgmkhrGW/OtZDk1ZWgN/8kmO3Eb?=
 =?us-ascii?Q?W4rU6F6oxS6cZ9J+mCc8NEOVSTuoRmZBbMwnsZXwOqNPGuH24X6n3qJ/Ui8m?=
 =?us-ascii?Q?mY8mLlZivaVSsptAtgaaSV8yz2hO9t9H5bPGmXnbXUMZCugF5N3KjRVSyQhO?=
 =?us-ascii?Q?psPyRHBcBXdooehWjDS3IpHyH3XtBKXT8/PB69yUZAtZDEi4RD2JKsEr7Ttd?=
 =?us-ascii?Q?cqXFWjdKRxh4+NeTiB/gWjaAeTUnsixT53iGdFa/6IwVMHTk41RpUj55OTBY?=
 =?us-ascii?Q?xtDbEl8VtprN0KpEazfoy54snykRfY6sa8SKRoCBYc7NEWm17o8iq5L0rGDF?=
 =?us-ascii?Q?BIa+EvhT8CyrIQjFcoBo5MT/VoY3gGWEn+wLMTgGwwZrvzw3ZcDKfdCafLnG?=
 =?us-ascii?Q?5KgbzuJ3h6PPLeNDv8hr1lLXBvKLgKxd0bgMTThbiVR1z8KYJexB8Ko2QvLj?=
 =?us-ascii?Q?fccEDkpQE2zEbVcijxHbDJHyrketYJtXfIsauoVD4TuWd9NkYqcnvBLDfzSk?=
 =?us-ascii?Q?UbVKcy81mRYFFhtBbr1g0kSCRqPcdTdm8CwOToR8GPDieuo7lZHu1uJueOQd?=
 =?us-ascii?Q?MUoXKsUT9YTUD+J+M3wDnfpaqydXZYdIAk68BQjOLnyt1dmUbbdonuPyFVDE?=
 =?us-ascii?Q?k+mvDESzemRnBPFT/T7b4kV2nRmPu+pTikkgdkIhgd8O7QnwlLBpIkEgnfiZ?=
 =?us-ascii?Q?fUp3tnbnq5xD8JVjo3Y3Z6qhkXW9E6V67K694QsBnpUnzNV5MJB3cNBCCq/k?=
 =?us-ascii?Q?dQ/H29cf61yk9nPrAKLo5qo/mn7z15rBJzH2gqT3XI10sCEDGPfKIdTprVrb?=
 =?us-ascii?Q?RLPfLvte/lgu71oYStdxD0RkxiWLBzm1bUKUEXTsXn9JbAuTv17mg3Ed8Kxf?=
 =?us-ascii?Q?Bv+m83YdtCMdfo31nplHHukuZhzBtG1xSRaSa9oOrI34WQIddbrofrqd0eWe?=
 =?us-ascii?Q?t5telK244pbJ90SxJV1L5uTM2ZM+YQvfIkF1vcsn9X1Ud2G0hhAW0wdAmYWM?=
 =?us-ascii?Q?/HEb2KJWTEfJ0h7a2UV1+NFPJClhFVHT1I1yZCJwRJnBtnN5Im8OulVeXJyY?=
 =?us-ascii?Q?bhxrdoXo9+7oXeDnXvAM1hatbsySwAjN6YecrLDmSrBErurYb8ZV+AOHpUfz?=
 =?us-ascii?Q?8B0ZdzfJLhuXvqY70lbimYafv4PzD2lYyHi1f0O6EPxRdC/MOVvzYJKTFALc?=
 =?us-ascii?Q?53kGgoi+8whEOrLYUndSbJcJetE8oweyQLJBh4r4PW7VrliEFbFeqwpaOiPX?=
 =?us-ascii?Q?Ibt5dTFB5DplIMUetq5KwQ3OrBSVEGwP0lVUxgaeIrwzJahKKZkDGPoLAkRC?=
 =?us-ascii?Q?MIKsSNrDPXsYuNX7TE6cd8JdQD2hJ5rVY1WBieOhAHFtR21voGKdDYjKGvFf?=
 =?us-ascii?Q?4UL3xfkIVikxAaKVF///QqjO7FhlCn8SjjjQu+wd/ufCtITXDQ4Rp/Wy+Thm?=
 =?us-ascii?Q?RCSfHzsK7Pv8s9kbYByB5+UbMzpgZEU6Sc8ZjN9AEznT3CiHj4ZQ2Fp23WCg?=
 =?us-ascii?Q?jD1jReywSxCofqV1EIjmNb+piC+DF+8vjO4ROIcBPtgWJm/YSCplR2V1hbR8?=
 =?us-ascii?Q?yWNdlQ2hgchSQ9baezoRPNqvuydb5z8+ZfQaUdZ6+OvmDw7amFde0NiTpWhl?=
 =?us-ascii?Q?XsyLRUvxLg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab7b36a0-3363-4dc1-cac2-08dead210fa4
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 16:44:24.5959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nMu8ocvQbyfH8hd/SUbBtU0jF1+o7VdxUKHaVs5yoFaMsYnyz0ISMaSRiWZ5HuF6MfnjkSS32LDVKfBQj7qo8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6528

On 2026-05-08 at 19:15 +1000, "David Hildenbrand (Arm)" <david@kernel.org> wrote...
> On 5/2/26 01:39, Souvik Banerjee wrote:
> > Commit 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
> > added zero/empty-entry early returns to dax_associate_entry() and
> > dax_disassociate_entry(), but placed them *after* the
> > `struct folio *folio = dax_to_folio(entry);` line.  dax_to_folio()
> > expands to page_folio(pfn_to_page(dax_to_pfn(entry))), and page_folio()
> > performs READ_ONCE(page->compound_head) -- a real dereference of the
> > struct page pointer derived from a bogus PFN extracted from the
> > empty/zero XA value.
> > 
> > On systems where vmemmap covers all of RAM that dereference reads
> > garbage and is harmless: the early return then discards the result.
> > On virtio-pmem with altmap (vmemmap stored inside the device), only
> > the real device PFN range is mapped, so the dereference triggers a
> > kernel paging fault from the truncate / invalidate path and from the
> > PMD-downgrade branch of dax_iomap_pte_fault when an entry is being
> > freed:
> > 
> >   Unable to handle kernel paging request at
> >   virtual address ffff_fdff_bf00_0008 (vmemmap region)
> >   Call trace:
> >    dax_disassociate_entry.isra.0+0x20/0x50
> >    dax_iomap_pte_fault
> >    dax_iomap_fault
> >    erofs_dax_fault
> > 
> > Close the residual gap by moving the dax_to_folio() call after the
> > zero/empty guard in dax_disassociate_entry().  Apply the same
> > treatment to dax_busy_page(), which has the identical pattern but
> > was not touched by the prior fix.
> > 
> > Fixes: 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
> > Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
> > Cc: stable@vger.kernel.org # v6.15+
> > Cc: Alistair Popple <apopple@nvidia.com>

Thanks for fixing this.

> > Signed-off-by: Souvik Banerjee <souvik@amlalabs.com>
> > ---
> >  fs/dax.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 6d175cd47a99..6878473265bb 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -505,21 +505,23 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
> >  static void dax_disassociate_entry(void *entry, struct address_space *mapping,
> >  				bool trunc)
> >  {
> > -	struct folio *folio = dax_to_folio(entry);
> > +	struct folio *folio;
> >  
> >  	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
> >  		return;
> >  
> > +	folio = dax_to_folio(entry);
> >  	dax_folio_put(folio);
> >  }
> >  
> >  static struct page *dax_busy_page(void *entry)
> >  {
> > -	struct folio *folio = dax_to_folio(entry);
> > +	struct folio *folio;
> >  
> >  	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
> >  		return NULL;
> >  
> > +	folio = dax_to_folio(entry);
> >  	if (folio_ref_count(folio) - folio_mapcount(folio))
> >  		return &folio->page;
> >  	else
> 
> Makes perfect sense to me.
> 
> 
> What about the usage in dax_associate_entry()?

Pretty sure the issue exists there as well given this code path implies we could
pass zero/empty entries there as well:

	if (shared || dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
		void *old;

		dax_disassociate_entry(entry, mapping, false);
		dax_associate_entry(new_entry, mapping, vmf->vma,
					vmf->address, shared);

 - Alistair

> -- 
> Cheers,
> 
> David
