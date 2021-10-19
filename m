Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B03B2C88
	for <nvdimm@lists.linux.dev>; Tue, 19 Oct 2021 14:20:35 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=apoCP1dV7lOvEzEQ406VUMX4mI2/uX4+B19QsQVlmWsC6HxWR5PaDYuuz/t/fiH3hEfzBqg+iqkPKjFlfOa5Lm9kw/CQag6Eh1oMBXgxermO/evPasJdksbjH0XLbwnoT5/vQujglKNlKXF+Hnua5tyY1dK9zihNBfZjG+U7ewWg+aJHlESH012dheRT1QP7A4Xmd46ZZOAVFzETuNjeleZSdeC/eXaDhd9QQmQd0mJMnFfFP0/qqmRhma8wy51/HQSdWs97KwIZ3jnpSQSOqTH7flxx5xijJLp9TlWPc7nHr1c8OGKU9s/vNTIfbR3YtXczprjhXRg8p05HFPW8tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/e9wu5F4y7wSsfpF+hkzHe6ZC8Rkdj6ZH/TEliBZZ20=;
 b=jJQZ6kAPfWr94NfTGVAHVkOdqGlwg1szymklWCi7o0Yrii2vN/E4wavgIf4wLObxW8TTwa31ENHR7QVdrGO0mlbBN/XUBIW0ZEKH2tSO9K9nQDGHD/HYMEVKx13dNlC2btRc3B/ByauYzJBHL5aAMyCT2c6qnSRcYh7hp3kAhXBRKDY9erC8j3B6hf8pTQJUTifU54ixJzGjYf3rBtM1zIrbsnNXrWnnpe9CyT/A8S/p0aEwnnuQgc7ORZom1vr0ZTM29mYEVWLzX7b0t6HX/il5FiShAiPcmm20qU5ZD4SJDKuJvm7az/eBOgP9Sq3K1UgmzKehHrjmasYwvCTucA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/e9wu5F4y7wSsfpF+hkzHe6ZC8Rkdj6ZH/TEliBZZ20=;
 b=mfw2gpl7iwr/w3s/usM3ZTjHN84jehzK0Fia8d0TbS7azTkrjD4vQdpHPxcVeUxZhPDW5RD7WafB+Fyql4LKdsiCKaiMY7lJNS4jk0h7Gfp2SXOc9TX5/UlCjod1vf80lthgxk+LRkQKpsrw9hR9ldVhPGiDUXryQnS8HrrZJmhf79qSJKyrzq/lWvQIkZpYFNJ0XqwphOEBBSR9kQiISdnfVJdlLgLGIsGcaOtfS7SvN9Ros8DohTGF1ZAcWUXWDBVglZzyJYn0xcZVD7kiJfEYBawOaYnuQi7s1GGzufLBz+GadL5IlFGHcfRmjossVJFSzAgafEAEGwre3EIRaA==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5380.namprd12.prod.outlook.com (2603:10b6:208:314::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Tue, 19 Oct
 2021 14:20:34 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4628.015; Tue, 19 Oct 2021
 14:20:33 +0000
Date: Tue, 19 Oct 2021 11:20:32 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Christoph Hellwig <hch@lst.de>, Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Alex Sierra <alex.sierra@amd.com>,
	"Kuehling, Felix" <Felix.Kuehling@amd.com>,
	Linux MM <linux-mm@kvack.org>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: Re: can we finally kill off CONFIG_FS_DAX_LIMITED
Message-ID: <20211019142032.GT2744544@nvidia.com>
References: <20210823214708.77979b3f@thinkpad>
 <CAPcyv4jijqrb1O5OOTd5ftQ2Q-5SVwNRM7XMQ+N3MAFxEfvxpA@mail.gmail.com>
 <e250feab-1873-c91d-5ea9-39ac6ef26458@oracle.com>
 <CAPcyv4jYXPWmT2EzroTa7RDz1Z68Qz8Uj4MeheQHPbBXdfS4pA@mail.gmail.com>
 <20210824202449.19d524b5@thinkpad>
 <CAPcyv4iFeVDVPn6uc=aKsyUvkiu3-fK-N16iJVZQ3N8oT00hWA@mail.gmail.com>
 <20211014230439.GA3592864@nvidia.com>
 <5ca908e3-b4ad-dfef-d75f-75073d4165f7@oracle.com>
 <20211018233045.GQ2744544@nvidia.com>
 <CAPcyv4i=Rsv3nNTH9LTc2BwCoMyDU639vdd9kVEzZXvuSY+dWA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4i=Rsv3nNTH9LTc2BwCoMyDU639vdd9kVEzZXvuSY+dWA@mail.gmail.com>
X-ClientProxiedBy: BLAPR03CA0111.namprd03.prod.outlook.com
 (2603:10b6:208:32a::26) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BLAPR03CA0111.namprd03.prod.outlook.com (2603:10b6:208:32a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17 via Frontend Transport; Tue, 19 Oct 2021 14:20:33 +0000
Received: from jgg by mlx with local (Exim 4.94)	(envelope-from <jgg@nvidia.com>)	id 1mcpyi-00GiBW-RW; Tue, 19 Oct 2021 11:20:32 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4bea0c85-3098-4130-10aa-08d9930b9ce4
X-MS-TrafficTypeDiagnostic: BL1PR12MB5380:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS:
	<BL1PR12MB53802340DA7A6332DACC6414C2BD9@BL1PR12MB5380.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	drrfouxs/ouf/DTH0pUwWN484goBVKKGw44OQiOojD7afQK24r1l/edMIQJNfX94ofhpD/nYwpzFUgzgndsOe8vlXFuVAwdn26zabIUvczIdMUZX4TxTsYiq8MCH3kCr5Rvp2+JLATSY0bR51X4rkQPMGPtLtkbqpmUOcSUsC+TP23gs09pxMYn6vBSKpAU0HAvhVgFsuqseUBvfJ2EvQ8EExAWzWTUjIJNLGtvRwvZBi+QB4il6D0VUdrnIwNsFcFUc+5PTMLAWCTHOrh/TiV57v3q5pgwAkDHmmlwrKeAmOryLZUU4rvAzgBzvyEuffiFXupmraewmwVuQw7ozXW4/8j7SIbUlUj1veF72zt5sKB2OyMLoIzWisLKXO5zBHU1AeVOF535vkmtBzrtqZgn4k4DPthMh/1gV6PI16f3lbj4scnwElWZExKHS+i92jLWYec/Qa3hsO5ysQoyI4CtuPjG9zFCWXzJSbg/8WUES05/kf9MQwPXdy3zdZJipPbshLvb2jl0Y9rkwHIhpujZ+mO1GkVC3o7ZABn2WUcYXuudZPQ+XGAJ+8gaj5L/bfkg5EuKUYD0iLgSYJqLPbccPFapZej8IcckbsT+Zf+OV0ai8E0qsAb3fjgGxKzFOV8H+Sdq8t/4jIGM9cwWpEA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(5660300002)(186003)(83380400001)(4326008)(316002)(8936002)(36756003)(9746002)(1076003)(508600001)(9786002)(53546011)(26005)(8676002)(66476007)(66556008)(2616005)(54906003)(66946007)(7416002)(6916009)(33656002)(86362001)(426003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mu9G2vdsuC1nsJSUE3ekq/s+IcUFHGofirJmF6K+uyxnyBdx9nxLji/cFJND?=
 =?us-ascii?Q?VUyUEPXM0R9vMu/fz4BdHDgyz07wKWJmftI0hHma9MVQubXF5L93UkvHivTZ?=
 =?us-ascii?Q?GayVl8sjhscwGNyhYZ30c4CkmnGYoNHjemWj3BuXvQExq/je5xr+U/1OD5XC?=
 =?us-ascii?Q?E5+jkRRtRuH9Lb1wLugEHUXhdvGy9+JAcHdaFCCLUScXVjOee9if2NMqptvG?=
 =?us-ascii?Q?YfQcQylpM2tXLGFOGw8gpkE9KV1HxsV4t5g3B+bW6dxBJe+CeTeBfAr5pisg?=
 =?us-ascii?Q?USo2yX6CGUGPXZ4xR/6ZxoMscGHvyeNjva5ntN3MF7dNnSt13whbSzf8T3ao?=
 =?us-ascii?Q?5/2TAayas8Z+Rkqmg0fd4OiMv8RYUSiXYMBwapQWfL7Wz14Z8jF68S7dOcM7?=
 =?us-ascii?Q?XYjeq/CiccnpNhH8fJ89XTaEp1O3bV9kpWYB7LSj6roPLqVpi4sCLuyCSk6W?=
 =?us-ascii?Q?w32cmGzX6UJXWfP1YL14VFfHcHG1HQFEbCu44A3tvBMFuWPpSBj35GEN5GOq?=
 =?us-ascii?Q?l/3rErP1As3r93Q3Mmz5xXc037b3Mm9nP+ZTFEZ/T/gzBvKfuw5rqz4esz6F?=
 =?us-ascii?Q?5jqqxyntapdQ9jnJ7TF6vsfW1TIebUpH1Us5FbkVLwIjlAmyWS0OO8Ox/Wnb?=
 =?us-ascii?Q?ZgRwZlB/GYxj1xf+WJ34qk3GYuly81YtZfTGZ9roTMqgp7QC83qRt4UWu3zF?=
 =?us-ascii?Q?ZOBQcjm9V00A2dh1LRG2Kov6uSlU7M9wbiaGdBs8omoZBrlgQRQEHr+E8yE5?=
 =?us-ascii?Q?itUdwxr8yYAkOBJ+w7vrZm1t8DN3Chst2I9LSNmlF/HSK8b8Kaosd7PoILMk?=
 =?us-ascii?Q?c3ZoP8U0VAsbQQ8g4ugD851JlQDKe3COPsvKFTuTPb8H8SjSWK2cDLRaerxs?=
 =?us-ascii?Q?o4RNk+iOeqHygwYvLgGxnsAEuZSVafm1yFjgT3RTEwk1uNoFsE8MQiSl3RIO?=
 =?us-ascii?Q?4kxSidyUXOi5S0ioa7cQtNGHzyj1Q6SwDfAFbvbvLT9VTtqMWY+Dhsp3xshA?=
 =?us-ascii?Q?09eopLGhOJRAiOE5ERmLn6gc2XydL+246/t3Us7YqDPAflhyJ9qc69JX2PfU?=
 =?us-ascii?Q?f3UW/sktdiM+gxk0nzkxZSHj3qbnxOJ9FXIqpCe4caqHbvJWM8OrAXH45Rry?=
 =?us-ascii?Q?OjNyH+nwMxJKnraXX6FXoTtt37uysrMVYUZ76wO4E/Ea0lkFeI+IHudLvcnA?=
 =?us-ascii?Q?XZAZdqZ58lwsP9FWDemcokb4KhYhH5OEwnwH8blriqDXfpq6BXgniGaAHkMG?=
 =?us-ascii?Q?2knY/jNAc6MmNGeuinq1eP40Pu1xKmYZUdmBWNHHgVpkJcruSOnAz1wKf/at?=
 =?us-ascii?Q?ozkIpINpCw1UoJ02diG7uqSG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bea0c85-3098-4130-10aa-08d9930b9ce4
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 14:20:33.7483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wozdlSEEcDsTD7AxHYrp96bHb2V+BMMHFWVQpn6cHxFTHLr9M3etyPO9nwFD4vyd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5380

On Mon, Oct 18, 2021 at 09:26:24PM -0700, Dan Williams wrote:
> On Mon, Oct 18, 2021 at 4:31 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Fri, Oct 15, 2021 at 01:22:41AM +0100, Joao Martins wrote:
> >
> > > dev_pagemap_mapping_shift() does a lookup to figure out
> > > which order is the page table entry represents. is_zone_device_page()
> > > is already used to gate usage of dev_pagemap_mapping_shift(). I think
> > > this might be an artifact of the same issue as 3) in which PMDs/PUDs
> > > are represented with base pages and hence you can't do what the rest
> > > of the world does with:
> >
> > This code is looks broken as written.
> >
> > vma_address() relies on certain properties that I maybe DAX (maybe
> > even only FSDAX?) sets on its ZONE_DEVICE pages, and
> > dev_pagemap_mapping_shift() does not handle the -EFAULT return. It
> > will crash if a memory failure hits any other kind of ZONE_DEVICE
> > area.
> 
> That case is gated with a TODO in memory_failure_dev_pagemap(). I
> never got any response to queries about what to do about memory
> failure vs HMM.

Unfortunately neither Logan nor Felix noticed that TODO conditional
when adding new types..

But maybe it is dead code anyhow as it already has this:

	cookie = dax_lock_page(page);
	if (!cookie)
		goto out;

Right before? Doesn't that already always fail for anything that isn't
a DAX?

> > I'm not sure the comment is correct anyhow:
> >
> >                 /*
> >                  * Unmap the largest mapping to avoid breaking up
> >                  * device-dax mappings which are constant size. The
> >                  * actual size of the mapping being torn down is
> >                  * communicated in siginfo, see kill_proc()
> >                  */
> >                 unmap_mapping_range(page->mapping, start, size, 0);
> >
> > Beacuse for non PageAnon unmap_mapping_range() does either
> > zap_huge_pud(), __split_huge_pmd(), or zap_huge_pmd().
> >
> > Despite it's name __split_huge_pmd() does not actually split, it will
> > call __split_huge_pmd_locked:
> >
> >         } else if (!(pmd_devmap(*pmd) || is_pmd_migration_entry(*pmd)))
> >                 goto out;
> >         __split_huge_pmd_locked(vma, pmd, range.start, freeze);
> >
> > Which does
> >         if (!vma_is_anonymous(vma)) {
> >                 old_pmd = pmdp_huge_clear_flush_notify(vma, haddr, pmd);
> >
> > Which is a zap, not split.
> >
> > So I wonder if there is a reason to use anything other than 4k here
> > for DAX?
> >
> > >       tk->size_shift = page_shift(compound_head(p));
> > >
> > > ... as page_shift() would just return PAGE_SHIFT (as compound_order() is 0).
> >
> > And what would be so wrong with memory failure doing this as a 4k
> > page?
> 
> device-dax does not support misaligned mappings. It makes hard
> guarantees for applications that can not afford the page table
> allocation overhead of sub-1GB mappings.

memory-failure is the wrong layer to enforce this anyhow - if someday
unmap_mapping_range() did learn to break up the 1GB pages then we'd
want to put the condition to preserve device-dax mappings there, not
way up in memory-failure.

So we can just delete the detection of the page size and rely on the
zap code to wipe out the entire level, not split it. Which is what we
have today already.

Jason
