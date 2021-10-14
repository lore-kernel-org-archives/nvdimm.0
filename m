Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2051.outbound.protection.outlook.com [40.107.95.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADAF2C83
	for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 23:04:44 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oR3LLr/ku7WnG40FcOGo8N7SjYA2neNgXdfWFubg+rYTqQw/BFiAMjRoiOMWJEQBBdqMz6DY4FSlJuUUrDca49fCpTOa1lAkjeK0i8b8El3FF/diDVkVCj6yjOajuOLoHvySk0NlgFqbMVLTAs4BPhd50dh18KZtXhZ/1cO04428SBYlJemgyDawXzb0+kDriK04b18Oa8rgVKp9/9ziozAJb45sAhYJhHfq9r35w3r5afG2s3MujzOxOtw2J3sa31BtcdV+eFmc93Sh1kNfCwh42dr40eRvxZwQWU/yqFMgo81N+RKcCYT2ULnO2+qh+5CyOtSfJ74SMXJLNv+mpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PsRiEWe/d6d2z7ZLk193dD9GuSjtElrsts+h68rBERA=;
 b=BeIivjx+u60nMmWYZl8S9VMJcnazdPYEIvOqtWSzaFikcWCg1mG4pmRM5iiPf/L7jl5Zy3QOSkvwG7asJMl0eDS6z1eWNbs6N0Vo5bcPoUnzN49K9+nTfB8Oum1al55KF94fobSIoo4+AaBEnMQw00HII1eXOkZnpZNoDlSislpm0m1sRiAXSXUxE3Wk3nCoOwEF3+hS4ymh7fgFm+lgOsiBSTwprFjdyIygD5OGZFhMh6DlQ8TTVQIQDlPhcDQjCyKskETnPZ8hEOK/aoZQNe1gjXYaaAk295NbpVcPJ5SZAZi7aipVnL8ltt0RQ/wYSROZHMGD+A25aSSMJp8ESg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PsRiEWe/d6d2z7ZLk193dD9GuSjtElrsts+h68rBERA=;
 b=dScJviROFP4hUwdwXoozoRV/Az9J3rs5iQdOKeM/umv8sjv7Uoplfjg25H0a43QSIquoFmK66vFcuxHQ8oO/06ddj0io5S5HphFDbZkNcK2RafbdlzcLYkgW2W/9FpxCZki5QvWpHNgNqTDHfp72HVaV2BkFhdNLj2KOAbq9CECukt/dgfJFliA67LxuWTZWYyIdEp7ffJ9sJudbUhcfNAhx9ZVjwgva/yf1K7K2CKNGaS3jUduXlY16RvaCitUfxwiP/Petk+7CVqIMXieTC/IzFMM+T04mVLGrY6U3mby86RXYgdIlCbSMCZQzBk+Uu7MXiIZGAFi7r8mLhV39uQ==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5318.namprd12.prod.outlook.com (2603:10b6:208:31d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Thu, 14 Oct
 2021 23:04:42 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.017; Thu, 14 Oct 2021
 23:04:41 +0000
Date: Thu, 14 Oct 2021 20:04:39 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Joao Martins <joao.m.martins@oracle.com>,
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
Message-ID: <20211014230439.GA3592864@nvidia.com>
References: <20210820054340.GA28560@lst.de>
 <20210823160546.0bf243bf@thinkpad>
 <20210823214708.77979b3f@thinkpad>
 <CAPcyv4jijqrb1O5OOTd5ftQ2Q-5SVwNRM7XMQ+N3MAFxEfvxpA@mail.gmail.com>
 <e250feab-1873-c91d-5ea9-39ac6ef26458@oracle.com>
 <CAPcyv4jYXPWmT2EzroTa7RDz1Z68Qz8Uj4MeheQHPbBXdfS4pA@mail.gmail.com>
 <20210824202449.19d524b5@thinkpad>
 <CAPcyv4iFeVDVPn6uc=aKsyUvkiu3-fK-N16iJVZQ3N8oT00hWA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iFeVDVPn6uc=aKsyUvkiu3-fK-N16iJVZQ3N8oT00hWA@mail.gmail.com>
X-ClientProxiedBy: MN2PR17CA0033.namprd17.prod.outlook.com
 (2603:10b6:208:15e::46) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR17CA0033.namprd17.prod.outlook.com (2603:10b6:208:15e::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Thu, 14 Oct 2021 23:04:41 +0000
Received: from jgg by mlx with local (Exim 4.94)	(envelope-from <jgg@nvidia.com>)	id 1mb9mB-00F5Lu-Sg; Thu, 14 Oct 2021 20:04:39 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16b44d7c-f93e-4a1d-7e63-08d98f67010c
X-MS-TrafficTypeDiagnostic: BL1PR12MB5318:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS:
	<BL1PR12MB531897147AFF5B6B264C8DD3C2B89@BL1PR12MB5318.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rLBJbqwqwMh8wdtXzr+l85qjfzagUZajUGl5Pf9mkmRMmojzB3Gw8pD0KWmgRGPnJ/+HcjZyzAttiI+PVqstnnybt539lWdNh5n2KKOxe+IdgG+CpXgQPXqwbkH4RcFFjW8iC/OuzPK9SbzsSO/g4MfO9ss+oPg5gSpE70FCaZu2ycu8fgtJ177NNc36rMZDsLaczIs6Wp2A6j7RWwoJi+9vaTGQSlSM1PyhMbOFtxeHk80Tk7Cyd93DYtnMGG+rCm5Skn/F0jo5d67HdK66DV2nVVkSZg1MhFegVLMtGaIANfxjeUqmqsCPab5E4M2LyHvy+rS7WpQzwylYDn27Q/mmaa22hRWoxAeNpjfN0lVsv1Y4wKaFa0JFP+on5ylbEK7m6piAeOiVEa2sSZj4Ik9J6dxr5X27Ljeljxq2EVs0MHhEaRUkI0rufFcYh2LWfiAgYjjXvUFEa4H08X3dt+xEboxFGdjAyTrErZaYzcRcUXfMw9mOz9fbCew0wGQ0U+QEue28U3+j2s1gz4qZ+tbtVPbAe1lSnkemDeo3RifbmlWDHofpShjfzKacDnMzr7dRQz7lCCWxqvcVSKJh+wnk9XVj1Dc7V+HWpmgLxgtkhPfIcrKcw6zreEeCGawfgdQ6p8cCuHRhmH9mKG1E5CLwr8TsR92P+0IFJOIyXwazLN00G6O3UuRwbBxj1Uc9+pMlwwDoBP7vTEHSKCqqnanE/u9ftmCnisCKFFUOFXo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(966005)(54906003)(316002)(26005)(66946007)(38100700002)(6916009)(9786002)(5660300002)(4326008)(2906002)(9746002)(508600001)(83380400001)(33656002)(186003)(8676002)(2616005)(426003)(66556008)(8936002)(1076003)(86362001)(36756003)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?R/n3IeQxGS1+8lwtwU7sCfzx1txbBkvrxv0ONyDukGdhQwSluI/EisEDNYtJ?=
 =?us-ascii?Q?uQTOy4N4oBtF5EZvkIYNl/HICFxzEaixjIq3AQ9vJgg3N1CKx6Ki0SOBpNUG?=
 =?us-ascii?Q?ScyQFdBFecqS1NEe3ifRW5H+KwkqaYx9gx520lcNpIKb0KEjUlyUEUEgGPXY?=
 =?us-ascii?Q?nsAUXgP3FEzCcPZmFTRUdHGG92+ymZeo0OsGkqEO120Q4nMzh/SjbkNkLKUH?=
 =?us-ascii?Q?Tut1JbcqXsyPhL2BIOdw7e1yysiES0/Ngg6h/gNB12YYKjqH4Yk9cbaF6hMF?=
 =?us-ascii?Q?W+CPmFlvkCfR4UPNsNavxow12aLtGgejROMKoPcR77sKj/9gLPUIjd7pPNim?=
 =?us-ascii?Q?p1trtKEpFwXMBuW8gTRknYLPXujGQrT+3s8HkR9fDpgI3MuvGv0rcv2XbN+n?=
 =?us-ascii?Q?pk4MZT6xfVuGs2FsiGQqOco+Gw4kjvOjRpCm4pUdyY9KcgELEMIZjNhoCvQJ?=
 =?us-ascii?Q?SuEpom4ZygeA1LZIzwYPYwntpKkQYnMU0LmAe5rZr1OOcqba3rwquohm/dYM?=
 =?us-ascii?Q?aAQqpbJle4APeHJXW/S4AgUH9+LGiQjQAMqulY+P3/SsDGUtcPxKF7pkDhsV?=
 =?us-ascii?Q?aUtxD6cYWNnQeIh1x0bJA6xsDOORkpuMxHxrXOLT2xPXIZmLcDJS2h9bcIMZ?=
 =?us-ascii?Q?5+zVOpvgGuSRuBpV4uhuJpOpozPDzpqCoVZ0ZBDTULT9PNJTTAfzlh/IJ4ZY?=
 =?us-ascii?Q?pMpxYS4DMOfq2no22NpU9To3dKBe4Ocqzi2Typv6t8eo3h43+V+QVNMVzuxR?=
 =?us-ascii?Q?/ON1uOt9FZ4hzGSYCV3pTVPq3hOxHscLZ8LJ3jfmOpuhN0meUlw/CDcaEZPC?=
 =?us-ascii?Q?R+hOSylZBWB6+yEwo5TMQeZxpvigYZjBFNOjELy0wluOZuuQzypHNKlumG1N?=
 =?us-ascii?Q?FswBOVdMKVK80Zc3qgGe8ZC9qwjMlnUeaQCC2cp8WIm27utksbfpFI54WUDh?=
 =?us-ascii?Q?8oMLYWTZdXbggaT7skTdkt2uNF3VBtZRxptl32s28KPlAWi6Psz9Z02EHsPK?=
 =?us-ascii?Q?jRVNGsTaRJAS1GmGv8vr/B1y9Tve5NTHndXpy17PfhXXQZvrwpiIpXTqfzGB?=
 =?us-ascii?Q?0ADZRdjjivfqaJyuc2y68EeL0XG1h63I3vj5kEnNNDOeYp3WXxuM5zmaRVJD?=
 =?us-ascii?Q?Z9jZ+66JjkrSR/ux+74hqSP83LDiA0RMfWwGxgGamMzHPjvPqdnbp71yFUgx?=
 =?us-ascii?Q?w1Vhclk6teX36a/CEjVA34v5XPAQ+XDcSReLbgf2d8nwWdtrhyDUC8TCloVx?=
 =?us-ascii?Q?Q8VeYp5ndbr/Afpc14psU2wuV39J21mTSFRlT4F8tNHjcflYByATkdqkGGgR?=
 =?us-ascii?Q?txVl71PbaGqTs5voZr/sNN+x?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16b44d7c-f93e-4a1d-7e63-08d98f67010c
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 23:04:41.8933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lT6up6BjNsGLpIZKlPowb2S/Ky9PF3QrcElGOpniQPF/1WD/jooOTbICH/MOTDXT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5318

On Tue, Aug 24, 2021 at 11:44:20AM -0700, Dan Williams wrote:

> Yes, that's along the lines of what I'm thinking. I.e don't expect
> pte_devmap() to be there in the slow path, and use the vma to check
> for DAX.

I think we should delete pte_devmap completely from gup.c.

It is doing a few things that are better done in more general ways:

1) Doing the get_dev_pagemap() stuff which should be entirely deleted
   from gup.c in favour of proper use of struct page references.

2) Denying FOLL_LONGTERM
   Once GUP has grabbed the page we can call is_zone_device_page() on
   the struct page. If true we can check page->pgmap and read some
   DENY_FOLL_LONGTERM flag from there

3) Different refcounts for pud/pmd pages

   Ideally DAX cases would not do this (ie Joao is fixing device-dax)
   but in the interm we can just loop over the PUD/PMD in all
   cases. Looping is safe for THP AFAIK. I described how this can work
   here:

   https://lore.kernel.org/all/20211013174140.GJ2744544@nvidia.com/

After that there are only two remaining uses:

4) The pud/pmd_devmap() in vm_normal_page() should just go
   away. ZONE_DEVICE memory with struct pages SHOULD be a normal
   page. This also means dropping pte_special too.

5) dev_pagemap_mapping_shift() - I don't know what this does
   but why not use the is_zone_device_page() approach from 2?

In this way ZONE_DEVICE pages can be fully normal pages with no
requirements on PTE flags.

Where have I gone wrong? :)

pud/pmd_devmap() looks a little more involved to remove, but I wonder
if we can change logic like this:

	if (pmd_trans_huge(*vmf->pmd) || pmd_devmap(*vmf->pmd)) {

Into

  if (pmd_is_page(*pmd))

? And rely on struct page based stuff as above to discern THP vs devmap?

Thanks,
Jason
