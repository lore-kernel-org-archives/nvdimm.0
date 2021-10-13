Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2047.outbound.protection.outlook.com [40.107.96.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CC62C87
	for <nvdimm@lists.linux.dev>; Wed, 13 Oct 2021 19:43:48 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MX3I94X42kxGdLJgpcdI2VrBIvaqj1OHbd85S59v5UcfB7qfuehFk5gVcKQckwefFb+Rt+allXn9KNbYRRhD3M62fCJQgsgyi4K8mZz3kRZY1iyo/bC67+6wRwx4DBTNECbhXOqRwqwwocKOyzk6taDU/mX8aNi7WfeGAN/yj78vyqNYziOeR5L9iW7cShdMKFsL+ZAP6XiVVQoWJdO6N1ORpKCiLrhsmiHZkgSpw0pHU1L/hVY3I9Fk81psGRmhl45q4IFNmf5lI+1GilON2sSzW/NLGKJPSOw6vaQfV0VCiqm81AWLPrnFRcP15BgMv0ZyefkJVeXEA++rUDqFvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bjryOAxVIzZDb6ixwQowtNR1k9c16c/ZJn96zLoFu4I=;
 b=BRB+dgvOzZSiKz+u8ookRSeBJ5wRmWBLiZwk1FxddfxWJxUTLcnOgWmZSMu0OloOIUxJQjT7ejlz4YV7xFoJSdqe6flvEPDGL56aGghj42i37URwlX3AYoI3Q4Bffc9oeOVyicOjAl5dMOEhb6n5z0JniK5Riol5ipihONJC0YSU3hZASbpyIGuM05eBLAziIaErJYcbCSdxePuG077B1ddPlzmYaaRG/pcvj8Ml5QgR3ocSOVrh5cruNqozxssW1RDsEI1FSMg8riuSZLBfQ7hsGGJyWlV1yXlEqqop7YjK3XWkf0zhhnbNsRIjlEKI/XDUOPNeUyxemy18I7Kt+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bjryOAxVIzZDb6ixwQowtNR1k9c16c/ZJn96zLoFu4I=;
 b=c+q5ct6Htg9A7emeP3bFJqaij0XDX06vDF29CZxYuN7lzQJ6Ww9RZCSGNc7PSp+mQvWJpSbSFQm2KrysjmDTtu+A9BBwte8f0aFECei0d4z/uYCGJyH0Le9tf+kgLYzbgC4AsrSzH7S0sy/34d2qbtBslioEw6rD28NUqgxFKXFclqcZIMyghdB6Lx2pgo70V/j/3OLpYJO9MmOF57FKusG9uBRCpudXn17hSoAJd7GZdy23U5Jis+JCqg5tF4xj/bC6RycNL3YPRQtBpw2OPmuJR7NfNTY9w1ZXPMIpctbLGD09b6Lh1lQ+/SvxeYQaJMAaTlK/TtJa3591NJO4eA==
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5254.namprd12.prod.outlook.com (2603:10b6:208:31e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Wed, 13 Oct
 2021 19:43:46 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.016; Wed, 13 Oct 2021
 19:43:46 +0000
Date: Wed, 13 Oct 2021 16:43:45 -0300
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
Message-ID: <20211013194345.GO2744544@nvidia.com>
References: <20210827145819.16471-1-joao.m.martins@oracle.com>
 <20210827145819.16471-9-joao.m.martins@oracle.com>
 <20211008115448.GA2976530@nvidia.com>
 <01bf81a4-04f0-2ca3-0391-fceb1e557174@oracle.com>
 <20211013174140.GJ2744544@nvidia.com>
 <20e2472f-736a-be3a-6f3a-5dfcb85f4cfb@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20e2472f-736a-be3a-6f3a-5dfcb85f4cfb@oracle.com>
X-ClientProxiedBy: BL1PR13CA0250.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::15) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0250.namprd13.prod.outlook.com (2603:10b6:208:2ba::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Wed, 13 Oct 2021 19:43:46 +0000
Received: from jgg by mlx with local (Exim 4.94)	(envelope-from <jgg@nvidia.com>)	id 1makAD-00Ef7w-Fy; Wed, 13 Oct 2021 16:43:45 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 853934ed-c8aa-40a2-b8cd-08d98e81c560
X-MS-TrafficTypeDiagnostic: BL1PR12MB5254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS:
	<BL1PR12MB5254A40A25777F5CBE18B685C2B79@BL1PR12MB5254.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	d7rH0bxDASZG1hIX+qz7Qhs2s/tZ/4FFCJyJon5x7zxdkXfGFcSHPdxYVOAg/SxjlhRZjvUbn7tTJvlPWhKSR+1che3ZDyinhC4zhI7p2scJ6VCX9tn9emaP2e+i4+d00zTP67eH9zBe5TE8WLU/WsLut2Hh9XiExTI0N1ULHG5AEfy7pH16RQnW5oLKkBSrFUYcWewl18v7GiIUqS8fkLPTY18ySQMsALDyWKlG4j+b3WvEOB+wm+C9aVY6Qdl7Qjw4TjxCuysh1AcvMoeLZ5zMCxUnSfLM+lKJtVqLpgzQ88QXUX3Iy1jqFAEH5R7UvYAqPbWPy4Ig0rtfNclgt8MfptL/n5tiOgM95pPBzVLC2+tq5hpTIL8mCMXdu9SHDHH3liG1RCyQkJhNoIzSqTlGir8hApLDIn59j8sWGmaS/e5wxsBSnU6vNmNVFzZYQZcmskIIKMLxhIXfL6LWoGwoSEL5EQZLQl5q/gDbGfKmNARx3ZUt/3B90je2uJuD0u9l0ENn0fLTx/nJHL305DEaMY4sjk5zPSLdsMqxSzbLGjllpNXpLplKcmB83xCTbdY6bCaWpe4NTDYx1dSowosg87kt5M+cxS37oGeAynqwt9ZdGw23OXk6Dh7qMzt/ec1G1UaFltQlDSewD2rFog==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(53546011)(66476007)(66946007)(66556008)(4326008)(8676002)(316002)(9786002)(2616005)(7416002)(508600001)(5660300002)(9746002)(426003)(186003)(38100700002)(8936002)(26005)(2906002)(1076003)(54906003)(86362001)(83380400001)(6916009)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aBqMgzNCczio8gcSstAhc6lZXsxJZVtjoUuPR0NXc3u95lceVU6u3vT55eIF?=
 =?us-ascii?Q?LKmocaqABVSAclLWo2cYw9jUVgHuF3AOsmkUgczDCoeLitC2M5aJU3MZradz?=
 =?us-ascii?Q?UVx/mrUOvNvtwXxHvSdb7s06OxBKLfKE7LSN1zRgsgl1hX+dT91H3fog4lx9?=
 =?us-ascii?Q?0Ql7/qwF0G7uF14j6zMvspSGT9AFJCdBIhq2mv/y2U5UcV3XDtQ2RJOk2lsN?=
 =?us-ascii?Q?venNk87dP9YRbS0uFfADJ9nBRffSatfHAsMIDeHFtcIoNFTnsUwaY/MhumDX?=
 =?us-ascii?Q?tCxauiZWY5kbQ6gffct1A1OyDVETh8A+j4qOMMnZXd8GRQWpixvuuuenESpX?=
 =?us-ascii?Q?BgWDZEkmcPm6kW0S/2C6rVu/sRa9aN2y1UZsbW8FfYyaVBt6vX/m/j7doKo2?=
 =?us-ascii?Q?j5XpnWZJFDYWWi7JLL36MKrSsvbGFCGsvDuRnOuxdrC80/qi8OqHN7zSp0Gs?=
 =?us-ascii?Q?MavxQW2fWiwEVSHFdkBH76BWfvmTlL0PLBLe8DdmLOlJoy+E3WrcovakLndN?=
 =?us-ascii?Q?J/B1vVmP2ySbN7ck9fygjzOAsTVPpbLCYsAbYDhaqFy8+blRvfMrAwD+sIKS?=
 =?us-ascii?Q?8ZHxl1mRuZjy+jBAqJG0gLYcP9DX/4VVDPFnqVO6Mni+HGCIa7KjdANEggqc?=
 =?us-ascii?Q?9JoIAF6jBKzkUtkebmjsB/Cvk6U9e9bvYhh+HjDtlb4ZmxHAtWzldFO6kDF3?=
 =?us-ascii?Q?vq5dOPBUJ+ktysihrHwYILVP8efbITKQZqzGMU6+bWSstdBbbzdTgj75/20q?=
 =?us-ascii?Q?FWsZazcle1DyHwMHFwse+9HoowdXIbxpoVXehkK2mUP0TwmYC/x17KxvpTwM?=
 =?us-ascii?Q?mrumoGjsaeQCsSFW1rJ7cMbqlC6lcWSe53SvTs6lh4oDXaaIPbm9QGX5QB1w?=
 =?us-ascii?Q?9/Eu5EF5tKsjHnTtC4rjMJPrWTAtYTXSD0npPO/ik/s5HGRkmQL+Hy0tvjs9?=
 =?us-ascii?Q?+4Fc3tLZwwUtdAyhDYG0y0BrUR+4dUIo68JW8lquA6s9NDm5heXw0YIgjYbu?=
 =?us-ascii?Q?5qZMTeKuKOKI56EOPJ+vp2wvtylwM0oLKOUfVcXuUmt7oIKT1YPimKdjwg1P?=
 =?us-ascii?Q?2uuRpB9v90F5qOakWXtvl7CsKSu7qGayf2RU99XoGMxz1dXTspkNfZfSU1sI?=
 =?us-ascii?Q?vL+K/awVGTBOWdGkANK/JpZCZjd3pE1SazAh7d7EThGiPS3AztU0mELcbRH1?=
 =?us-ascii?Q?jLKDqL8xH7V8NjraLbOGlJifyRcCE0GNfn6N4c7MlM4XPDHDs3dbXuFa1y9k?=
 =?us-ascii?Q?ChOZTYimaOEinX+mJlAp+WrpRl41PjMqSaKUkepodLpeqTMxC+270lRLk5xR?=
 =?us-ascii?Q?gWRyhKVH9ePCzcXb8GSl2uG+MemGl8YpYIgcXxVWxGToaA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 853934ed-c8aa-40a2-b8cd-08d98e81c560
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 19:43:46.5172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2zv7Mb52a7G9caPe1/bJ+ulTSAx2Bh/7IPUMm4pGVO2RbVjSxUPC7tlSpYloaErR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5254

On Wed, Oct 13, 2021 at 08:18:08PM +0100, Joao Martins wrote:
> On 10/13/21 18:41, Jason Gunthorpe wrote:
> > On Mon, Oct 11, 2021 at 04:53:29PM +0100, Joao Martins wrote:
> >> On 10/8/21 12:54, Jason Gunthorpe wrote:
> > 
> >>> The only optimization that might work here is to grab the head, then
> >>> compute the extent of tail pages and amalgamate them. Holding a ref on
> >>> the head also secures the tails.
> >>
> >> How about pmd_page(orig) / pud_page(orig) like what the rest of hugetlb/thp
> >> checks do? i.e. we would pass pmd_page(orig)/pud_page(orig) to __gup_device_huge()
> >> as an added @head argument. While keeping the same structure of counting tail pages
> >> between @addr .. @end if we have a head page.
> > 
> > The right logic is what everything else does:
> > 
> > 	page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
> > 	refs = record_subpages(page, addr, end, pages + *nr);
> > 	head = try_grab_compound_head(pud_page(orig), refs, flags);
> > 
> > If you can use this, or not, depends entirely on answering the
> > question of why does  __gup_device_huge() exist at all.
> > 
> So for device-dax it seems to be an untackled oversight[*], probably
> inherited from when fsdax devmap was introduced. What I don't know
> is the other devmap users :(

devmap generic infrastructure waits until all page refcounts go to
zero, and it should wait until any fast GUP is serialized as part of
the TLB shootdown - otherwise it is leaking access to the memory it
controls beyond it's shutdown

So, I don't think the different devmap users can break this?

> > This I don't fully know:
> > 
> > 1) As discussed quite a few times now, the entire get_dev_pagemap
> >    stuff looks usless and should just be deleted. If you care about
> >    optimizing this I would persue doing that as it will give the
> >    biggest single win.
> 
> I am not questioning the well-deserved improvement -- but from a pure
> optimization perspective the get_dev_pagemap() cost is not
> visible and quite negligeble.

You are doing large enough GUPs then that the expensive xarray seach
is small compared to the rest?

> > 2) It breaks up the PUD/PMD into tail pages and scans them all
> >    Why? Can devmap combine multiple compound_head's into the same PTE?
> 
> I am not aware of any other usage of compound pages for devmap struct pages
> than this series. At least I haven't seen device-dax or fsdax using
> this.

Let me ask this question differently, is this assertion OK?

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -808,8 +808,13 @@ static void insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
        }
 
        entry = pmd_mkhuge(pfn_t_pmd(pfn, prot));
-       if (pfn_t_devmap(pfn))
+       if (pfn_t_devmap(pfn)) {
+               struct page *pfn_to_page(pfn);
+
+               WARN_ON(compound_head(page) != page);
+               WARN_ON(compound_order(page) != PMD_SHIFT);
                entry = pmd_mkdevmap(entry);
+       }
        if (write) {
                entry = pmd_mkyoung(pmd_mkdirty(entry));
                entry = maybe_pmd_mkwrite(entry, vma);

(and same for insert_pfn_pud)

You said it is OK for device/dax/device.c?

And not for fs/dax.c?


> Unless HMM does this stuff, or some sort of devmap page migration? P2PDMA
> doesn't seem to be (yet?) caught by any of the GUP path at least before
> Logan's series lands. Or am I misunderstanding things here?

Of the places that call the insert_pfn_pmd/pud call chains I only see
device/dax/device.c and fs/dax.c as being linked to devmap. So other
devmap users don't use this stuff.

> I was changing __gup_device_huge() with similar to the above, but yeah
> it follows that algorithm as inside your do { } while() (thanks!). I can
> turn __gup_device_huge() into another (renamed to like try_grab_pages())
> helper and replace the callsites of gup_huge_{pud,pmd} for the THP/hugetlbfs
> equivalent handling.

I suppose it should be some #define because the (pmd_val != orig) logic
is not sharable

But, yes, a general call that the walker should make at any level to
record a pfn -> npages range efficiently.

> I think the right answer is "depends on the devmap" type. device-dax with
> PMD/PUDs (i.e. 2m pagesize PMEM or 1G pagesize pmem) works with the same
> rules as hugetlbfs. fsdax not so much (as you say above) but it would
> follow up changes to perhaps adhere to similar scheme (not exactly sure
> how do deal with holes). HMM I am not sure what the rules are there.
> P2PDMA seems not applicable?

I would say, not "depends on the devmap", but what are the rules for
calling insert_pfn_pmd in the first place.

If users are allowed the create pmds that span many compound_head's
then we need logic as I showed. Otherwise we do not.

And I would document this relationship in the GUP side "This do/while
is required because insert_pfn_pmd/pud() is used with compound pages
smaller than the PUD/PMD size" so it isn't so confused with just
"devmap"

Jason
