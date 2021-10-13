Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2068.outbound.protection.outlook.com [40.107.220.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E3272
	for <nvdimm@lists.linux.dev>; Wed, 13 Oct 2021 17:41:42 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eTZtcIZIRS0orBXDMQio6+TtEZGEh5HAxqzCm+dI714wgM5YH/Zwy+8p8cpQ61PjhayCjWnVLa6RkSrD7zuUBYoC3dsvFk1kn5TbPdvvhk8kMGvSlmIWe/MHNRnjJQ0BY4g/2k6ywgjBoHv3ALV+gTKonP6jjEFAuhy3P2QJwEIS1vCECFpBKD7EssphTabL4VJX2ikK/KSNOQ1RmwnrYhqM7rq8Hl0ZIVGA/JtmqpUysIHoCbP2r87dm0gqDy6elZl3p+vxvYT6JPNmBh5B2s/Zexvd4ht+AdIU4XUmtEkG4pBUKEzm7Kw+3HOsGxr5gr1wESeLk5kKe9ZYUDI3Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RWZQSM4Gde3i0KssnsEh1cC+82h68mvlXzgMFhZkFoI=;
 b=JT+OO+nJkzOKVvXCPCPh8DPe7yRT60FldhoTqt8H+w+7NvcCiEHx9OnsbxrWbCIx4s+UMh1V/4L28Cn0BSzlxflGVEcLeSmErsl1T4iRG0F6GdQ3ViQVgbvTDuxpOCSi8iAzFDFUMpeKqVoeJRdBVx+NtKscC0BO/su0GOo1q2fJGowMB1VQUYeaRmIFaR4yAL3ebA2HdjaMavZPH8d6+CgZoa6zWHx1UmBPM8FQW28RAnmNAHrLlCrnRxDOUKpYtElT7ekL7rFsI715sYXCRG8JArS7689J6xQE2p7aZ939zEncUoQ/moSRo/sIuIY/fONDfb5R8utNXZ5bJXxWxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RWZQSM4Gde3i0KssnsEh1cC+82h68mvlXzgMFhZkFoI=;
 b=oLUBSxkn286nqbLZLPEzhCjkJ2pZYLMZ9g5oxUueG7i7RZ1UeFdIfGh3hTpcDFxn+asvla72XqpiAeejLD7p3jiroqUI5URUwfBO1ezH9NlntM+RHepnoIc/9zyV62KahPS17g1kabUDcw1Qyw2rhEsOiipKXbo4NjlAfcE4kSU61enm1q0bOatT0VhJD+EWgJcumxCbbnLTXeLw3Bf05eYsPpw0WjWYbizvhw1PQ8iNP5UU37jJ7ssT7qtuhbWxcZwqyseFeIxtl42KY6tSBCvgHTlbTblB7z1eqSLRKhYlDNfzSewrgiDweGMEP0Qm/ofpmIT0FjLegDKpIV+VvQ==
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5032.namprd12.prod.outlook.com (2603:10b6:208:30a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Wed, 13 Oct
 2021 17:41:41 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.016; Wed, 13 Oct 2021
 17:41:41 +0000
Date: Wed, 13 Oct 2021 14:41:40 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Joao Martins <joao.m.martins@oracle.com>
Cc: linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
	nvdimm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 08/14] mm/gup: grab head page refcount once for group
 of subpages
Message-ID: <20211013174140.GJ2744544@nvidia.com>
References: <20210827145819.16471-1-joao.m.martins@oracle.com>
 <20210827145819.16471-9-joao.m.martins@oracle.com>
 <20211008115448.GA2976530@nvidia.com>
 <01bf81a4-04f0-2ca3-0391-fceb1e557174@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01bf81a4-04f0-2ca3-0391-fceb1e557174@oracle.com>
X-ClientProxiedBy: BL1PR13CA0229.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::24) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0229.namprd13.prod.outlook.com (2603:10b6:208:2bf::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Wed, 13 Oct 2021 17:41:40 +0000
Received: from jgg by mlx with local (Exim 4.94)	(envelope-from <jgg@nvidia.com>)	id 1maiG4-00Ec9y-0i; Wed, 13 Oct 2021 14:41:40 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41bf529d-e4b1-4d7e-a002-08d98e70b701
X-MS-TrafficTypeDiagnostic: BL1PR12MB5032:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS:
	<BL1PR12MB50323A6DD2502457144132E6C2B79@BL1PR12MB5032.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fLyT0gIHaVpJMEcQrDPmsHCkaBPSkxSlaUTwGcxz+fMnXMr1tl+xkPwfZ+nm6rmTkzplMo6sVjikl0W7Sgs1PgBZzGkYUxaRZhtDekvA/6q6oE9KVOyvTYg9EgjuT+b4mVVMwaqknSlyjvkC6HKNaSCz+BjygogPLPtXMnN/Z2gBlVFvS7ublY3l/ayL7u9K6y52SCFr7pTXJWl1A5ISDGt5ii6nJUCUunU0z0/TfM8RAyOdcpMCmx0VAfk+6M0aXUiK0PAYKMS50M2pPsDeqZngl5iWKq7b1Zwr6LXMIiz4KNlT45wjMSRjSVkytrVVttH2b5JAJQNJEFFMTqZNEepjQGqqgzoX3fS06r3F0J2BqecOkT3JDB80Fda/R3xOkBGSiIyTmVKN/07ejmD2hl9z+36XENNjDKKxGHzB1R2/lw5BMWhwccZ1LDIUxUrXWNaOOx3ug8ATl+yqdWRUFj3e7ievrJbna/COLt4QW7z8mKPTwVoi8bWduyjB0FTx5qMt6fhp0MZa3MzeTDWw4+TDMOMEyERnjHnF0aCAjq2stIuBHj/yUEAgufuSHZfSQxVFvhIC2wgmVMaO1A7V1cxiWo6URP2/4vTaHLc5I2C9G3AQBC6SdXmT5AXjyMf/0ZxA+uAmggwjkyTRGe1Zrw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(83380400001)(38100700002)(36756003)(2906002)(2616005)(6916009)(9786002)(9746002)(4326008)(86362001)(186003)(54906003)(7416002)(1076003)(426003)(316002)(8936002)(5660300002)(66476007)(66946007)(8676002)(66556008)(53546011)(508600001)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xXuMSI6c9tLPPoJS6MZeW3oI55qOXUQNny9+0LFIfgqoHB/JFdRhJqbJHL+s?=
 =?us-ascii?Q?K++jlO2WJSEHZ8gI+XPK560Yop97aVNsEity7xoyoIswPGnLXG0Lb61qE5H1?=
 =?us-ascii?Q?sBbe2qvC9lscW0nht6B5SDBXA1m6knwzNVhq4vMZJF1PR/HZxT0IEfyT9LOz?=
 =?us-ascii?Q?ro5bvv9SQHgaE5r5bRhplW89k+gautclRJCPzeVUnqRbP08H3dNXtGstEZLV?=
 =?us-ascii?Q?ODnbtLv/TkKFbQ32oSwvUD1df2aQrNdUcFOaS6pFliRIKUuyxAXsASaJBPBl?=
 =?us-ascii?Q?dNVW87UDpj0PvS6KPnzdwSLh2uJenEMNkwN8WvPb7AUSkq+8y+2i0foTqq30?=
 =?us-ascii?Q?VTCtrHqF3MIGPHXopAjqiVQ0ilHaMi4YgEKYjBU0A3itXJJoxytQBpvoTwvu?=
 =?us-ascii?Q?hzFYW3OOfPAxRKyyxWnP5H8BDLk02HsGXDvFtI7ij2k5/zYZhQI9FfNpwskH?=
 =?us-ascii?Q?wvjWxb2COaYOp+9zU/vFGF3Y1AV/Bm7SoknKRlXQ5Hsb0GYqoPLSkjeo+dGI?=
 =?us-ascii?Q?tldx2RsNgumfrZdFa++Tyh+pcpgDBoGhzZ+5zVoy+PqFuHLWsgasVZnonAHP?=
 =?us-ascii?Q?FdAdf2fwsEbHLNtmIpcst9IAB6QyCLisDrugf/BlEkJyXRuPaLV+iEVSUb/b?=
 =?us-ascii?Q?XQBdGL52d/34lZfQz+dj7M4WxE3IlKUz53gIFRx/mmwYoU+hDSPYPSwNoMv3?=
 =?us-ascii?Q?J8zxTQQ5O2r0zF1WV+oeLxFm2MrqCZoRZNwV/ZtgM46bvQPYee5/YZePnerz?=
 =?us-ascii?Q?3xdKfg5tFqAN98Sv6Ev+pWRxKgYBOci+1wD61hfZnuhPLqbmRGRQ8jKvMuhj?=
 =?us-ascii?Q?uYEm8LdkI5uqO3Q3xIzOctIk7/WN/uSH1Fan+6F4kNUyCEt55TDeouz6IZTk?=
 =?us-ascii?Q?Yo31/Z97UvNHAd37aenAbzLrL/scTAt9N+nvTWHDqaatKrUjubTAhz4FPdlO?=
 =?us-ascii?Q?9kdMJCtOMOqLkLCLpUoQXFhv47lPlII89RotwSFD7bXjVXW4Z2X1ooaM+MmS?=
 =?us-ascii?Q?izZD8IWXfiBStgLfLx5Yeh5XLrW8ErePFDcSA69MY8XeqBfaANzkh7+0WD1o?=
 =?us-ascii?Q?CfVbAptSmsmO5BKNuUKO6RtSJVegavvu56ykQ2iWGN1H3axZkFzwzgqK5NNi?=
 =?us-ascii?Q?X21LMHWxNvCuq0GH8FIV59XVBVQy+etHNNeVHdw5capMOnH6ZqqavY5G+FOk?=
 =?us-ascii?Q?D9dcqhs7C4FP1VzSuecLUDtSj8h9Kzli3Yw1nGHff/+Y7RVvWU+5FtD/gOby?=
 =?us-ascii?Q?sgYn6eqpfvGDVOm54YDkUXW7eF7NhPfSI/vTaernFHZVIAN/4aghhD9hgnhd?=
 =?us-ascii?Q?DS6kFe/0Q51lZTxQnBHTqu2c?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41bf529d-e4b1-4d7e-a002-08d98e70b701
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 17:41:40.9186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: anjyiQhdsWoodaaOz8zddGWl3f0Kw7O9IqFo64jFLT5CfF55fDC6zt5y08Dfo38p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5032

On Mon, Oct 11, 2021 at 04:53:29PM +0100, Joao Martins wrote:
> On 10/8/21 12:54, Jason Gunthorpe wrote:

> > The only optimization that might work here is to grab the head, then
> > compute the extent of tail pages and amalgamate them. Holding a ref on
> > the head also secures the tails.
> 
> How about pmd_page(orig) / pud_page(orig) like what the rest of hugetlb/thp
> checks do? i.e. we would pass pmd_page(orig)/pud_page(orig) to __gup_device_huge()
> as an added @head argument. While keeping the same structure of counting tail pages
> between @addr .. @end if we have a head page.

The right logic is what everything else does:

	page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
	refs = record_subpages(page, addr, end, pages + *nr);
	head = try_grab_compound_head(pud_page(orig), refs, flags);

If you can use this, or not, depends entirely on answering the
question of why does  __gup_device_huge() exist at all.

This I don't fully know:

1) As discussed quite a few times now, the entire get_dev_pagemap
   stuff looks usless and should just be deleted. If you care about
   optimizing this I would persue doing that as it will give the
   biggest single win.

2) It breaks up the PUD/PMD into tail pages and scans them all
   Why? Can devmap combine multiple compound_head's into the same PTE?
   Does devmap guarentee that the PUD/PMD points to the head page? (I
   assume no)

But I'm looking at this some more and I see try_get_compound_head() is
reading the compound_head with no locking, just READ_ONCE, so that
must be OK under GUP.

It still seems to me the same generic algorithm should work
everywhere, once we get rid of the get_dev_pagemap

  start_pfn = pud/pmd_pfn() + pud/pmd_page_offset(addr)
  end_pfn = start_pfn + (end - addr) // fixme
  if (THP)
     refs = end_pfn - start_pfn
  if (devmap)
     refs = 1

  do {
     page = pfn_to_page(start_pfn)
     head_page = try_grab_compound_head(page, refs, flags)
     if (pud/pmd_val() != orig)
        err

     npages = 1 << compound_order(head_page)
     npages = min(npages, end_pfn - start_pfn)
     for (i = 0, iter = page; i != npages) {
     	 *pages++ = iter;
         mem_map_next(iter, page, i)
     }

     if (devmap && npages > 2)
         grab_compound_head(head_page, npages - 1, flags)
     start_pfn += npages;
  } while (start_pfn != end_pfn)

Above needs to be cleaned up quite a bit, but is the general idea.

There is an further optimization we can put in where we can know that
'page' is still in a currently grab'd compound (eg last_page+1 = page,
not past compound_order) and defer the refcount work.

> It's interesting how THP (in gup_huge_pmd()) unilaterally computes
> tails assuming pmd_page(orig) is the head page.

I think this is an integral property of THP, probably not devmap/dax
though?

Jason
