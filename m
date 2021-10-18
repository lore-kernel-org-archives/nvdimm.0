Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2048.outbound.protection.outlook.com [40.107.94.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26D272
	for <nvdimm@lists.linux.dev>; Mon, 18 Oct 2021 23:30:48 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CO7CSp/fTuyZlbbezq4rW9Fi3lg/ybjxgeCc5kG6uCw3FKkSs18pLr/WrxritTgFab+lIKW9jxxzpBRjGWEB8rY+7KONHiXhgWNLc4/LXld7Boj7vPIxFkxMW7u+9QKJJrxSkY6gjEqpd0f6HQ+PLuw0Q0NLK15qFgzNz9kW5fVvyvqA4TVznPWcWNfYkk8nLNRhRgr8pXSNZfnaHabxpZ4DjwZ5TEeqZKw7TNlnQBFi5LdldWUcojSWXDeKlTx1WPk80gUE/aLfMbx1rZYWo8szT0NRUHgcgCf0dg2R7p9LddugqC5WdVvqL3o5PDLJye+eZBfhhRtlYBQg5YnTCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aUeJMA7+NtJWfXyuNc9nd+CpLWMbLIaR47v8fGrtKFg=;
 b=fSglTj4i3uHGtKzg3iHuaM3RFlE4Wn4O1mEbGV49+Sc637lDU9A+XmAljnduaOPDCGzn5gN9dB3uM5ITp2nnbdx7bEgoD10f0RyvW+U5+ujJL9keXuvjNBytAkBrmVo1ktzpArOp7ZhtClwR9fCcrVHQjZvipFmnuGqejsq5l6n/dSwapzz+dVkeSmAX7yylTkGxlb1f7EFwJmctcid4h/Xb3414oY2lPLuXRUrq0hIDxUjXH0BW6LtuDooTVcVGthD1BAdrvhEAYdIpYb9zXMV6fLV+gG2a7ZQY7fWX7FmM+3sU2JvUfQWtHH8Vhk+1YiRSSNBuWhkdizXOZiV3Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUeJMA7+NtJWfXyuNc9nd+CpLWMbLIaR47v8fGrtKFg=;
 b=ISsScjIA/KwhchlDgYNA7OM2DlfjYhBfVPzNjOSxCUHOd/fsH86Nn4JG3tFQ+NLUWr86ewPXp4fKRO8x7ru+2yP7Q4cNi6XA9enPA0NwBxqWlx/mm+HGb0JXqwgoGycuy/C2MFIU5L/Q4O40Ue16U2znL6WjU9o/2mk+NHRw6hesE8/NEIYWQf8VLNwaqTRxenhMnVcluaMr+t4/rzPckBtzI/PY3If5DXUFtZR4ZeBDDgrmF96AKc2Y3gno53ICKveHXNlafiNhX3eTpmlLu3Nje7bJLgYXAJHjPtudTp5buE7Kdl4OAylIf/dr+/f6seOE2/phT9Ius+/TyrfHHQ==
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5190.namprd12.prod.outlook.com (2603:10b6:208:31c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Mon, 18 Oct
 2021 23:30:46 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 23:30:46 +0000
Date: Mon, 18 Oct 2021 20:30:45 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
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
Message-ID: <20211018233045.GQ2744544@nvidia.com>
References: <20210820054340.GA28560@lst.de>
 <20210823160546.0bf243bf@thinkpad>
 <20210823214708.77979b3f@thinkpad>
 <CAPcyv4jijqrb1O5OOTd5ftQ2Q-5SVwNRM7XMQ+N3MAFxEfvxpA@mail.gmail.com>
 <e250feab-1873-c91d-5ea9-39ac6ef26458@oracle.com>
 <CAPcyv4jYXPWmT2EzroTa7RDz1Z68Qz8Uj4MeheQHPbBXdfS4pA@mail.gmail.com>
 <20210824202449.19d524b5@thinkpad>
 <CAPcyv4iFeVDVPn6uc=aKsyUvkiu3-fK-N16iJVZQ3N8oT00hWA@mail.gmail.com>
 <20211014230439.GA3592864@nvidia.com>
 <5ca908e3-b4ad-dfef-d75f-75073d4165f7@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ca908e3-b4ad-dfef-d75f-75073d4165f7@oracle.com>
X-ClientProxiedBy: BL1PR13CA0016.namprd13.prod.outlook.com
 (2603:10b6:208:256::21) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0016.namprd13.prod.outlook.com (2603:10b6:208:256::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.10 via Frontend Transport; Mon, 18 Oct 2021 23:30:46 +0000
Received: from jgg by mlx with local (Exim 4.94)	(envelope-from <jgg@nvidia.com>)	id 1mcc5d-00GXW8-J2; Mon, 18 Oct 2021 20:30:45 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b433061-d2e2-4c98-07fd-08d9928f4fa3
X-MS-TrafficTypeDiagnostic: BL1PR12MB5190:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS:
	<BL1PR12MB51903FB31F9F836861E2904EC2BC9@BL1PR12MB5190.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0l/nmuQoFdAaI7/IlaVIUMX7VqM7kzcmjeS4Bzqn9ELyl0En17OprVvSBWxF/nUG3McXht/2DgqiHx0AT7LzHMs9jo6ZfMPSfj8zXxUbC9KDp1CnwQn2AcINYRnh5oExnRaY2Ac9k6dzjx9Di5Wc74VCMw4I2f/7uV/paYMzRVAM5YGJficLUkM6Gi/5fWSjGBlcSfqZlg1ZKgayIJqgwMYpbaSbsONp0k2W+1MMQu+4ZTUuDV8Ee0aFz93N+4ULLkalVPpAOtu/3dU5in2NlbtnE4v/ho/+FRNETqTa4V5BnJQs6P+equ5Lb2OJ5SPh4xd5m4NgBKq1NsB1Il9S/eZyDQc/GfoEl0G5ldpzwdfTBGimyVbhIGbV/2Uj122KP3W/YecI2jCtRQ/8aKcbOXNDBRtNeN+uUOd2M6CdCauflmkYn2UxE9JE5Fb2b/0ECrlZyezMR40a2skRf9KvDzmJwLxzLNY5uDgrxjFxuDjwnbm8W20ziowqR+UeiQXh/Ov+BR3gjPp4ph+dUNXzyHlxrFZwEAHal2/y6zsgdYT+OMEqA1KzvdJBpe2q8Ni5eRVybJiSrEkcrAhutbfBPCv4toQ5LVQVkY2yxKKXfxXi21ZWSGD+sCOD1hs17nY8alhs/kOTLV64etBRDHlgKg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66946007)(66476007)(2616005)(426003)(83380400001)(7416002)(316002)(6916009)(8936002)(1076003)(86362001)(26005)(33656002)(508600001)(38100700002)(36756003)(186003)(54906003)(9786002)(9746002)(2906002)(4326008)(5660300002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kwtHPgORhYc9wlcoJZcUQBMgQOVVmOfjMMJ+ly/Ik1XErDruHKvoQzu+yq9Z?=
 =?us-ascii?Q?+X7byI1zeLYGwkWQBJ/ifVs+kQdjBB0t5JcgjcF7aUSWRaJfPcimUpSxfpTo?=
 =?us-ascii?Q?w+N+59XyGgqXm2ndc4tDX9+xQxBrg2JOVh3t8NLSEDKw0VcXqZwP2ASCkjoz?=
 =?us-ascii?Q?HNjvit1zptvL2aE+kAp4xyyELlo+nQI3LbS0tEIVSqdjhEqa4P+C3ScjqyhL?=
 =?us-ascii?Q?Q9B/D0zfoAlD9qntMELiGdbJ2QsqgMQvqFhLsKvi+nyph5X2FlISjrS3NCfv?=
 =?us-ascii?Q?nWXWuotF8Z07L80vnELWy3sB6hYtxW9qf3+/11UJMoyG0C3QA9eDcpiVONAD?=
 =?us-ascii?Q?pFxgHUlWeSIKswywkmQfMs/PTTlvkXAlCaqjdgUtAR3XGkyqXvb5s9fWvkKI?=
 =?us-ascii?Q?CWvTkddU76LbZzqkzwYkXItgN8cdwN57XV2sgeLaB72FGI8aHXAwqcu74bs8?=
 =?us-ascii?Q?hUamAL8I+29XPlnX51WzI6eIPpJuXKuIqB8pdMlafqHp/MEA8Yzcb59DK8CJ?=
 =?us-ascii?Q?sORTl5dYiyXTAOff/Z2syVoWyHqAMFXpxEMT5S+YrpJrOPiSqTj1bAU+xn1t?=
 =?us-ascii?Q?7KMz+24JAZPY62jT1pP//3Lj/EOU8R7z+k1rKD28b9LDDj1sAJisOf7IlrOK?=
 =?us-ascii?Q?szK+zpksNnDdcmykjmpN76muqnAjXrsGp6kQinJ0+t/S6ynRO/cegnO/NIrI?=
 =?us-ascii?Q?SedpvGIRBKJwY6DhwalpthAy7JFYomBtfnMShUZ8dsM3RrS6hlt6o8mUpb3g?=
 =?us-ascii?Q?kXoqc8dAlMZlT3WxDOtTLDBoF2P1zbbKoF7aj52xyRmCxHp6YXbd8dVl5snl?=
 =?us-ascii?Q?o2yFrDLXV3jZoyzcCJ2Yna1u7z7R4wSGVb9BevAK8upZOli2JWYTjqBna16H?=
 =?us-ascii?Q?RIaHKokgSNfPIc6xRWFc7iGhqBER4zCSf8IvXZaJXpMw2JqDWn+kfzUG3cvO?=
 =?us-ascii?Q?FZBXSRGU8Vite1WVeTh08S01263KJRS+Z2PI79WZUTpBSgUGgRmbfjykROMN?=
 =?us-ascii?Q?os9S4S0dT7jeCTEP6xh4y3OW5+Ktx9Cq21SJifu2aJSSi7VAe9V/joSo3mYI?=
 =?us-ascii?Q?wIm2F4NVMF1RchxgNKzfWq5s8wWagLpjAwrHz6aGmZlbqsTLNhPxwov5zyvl?=
 =?us-ascii?Q?0jftMG4wb6E6/Ish0CFF1l8eIdvsjU4TqyWuZmgEE6Mi8Jt0iX1OWK1GwVlX?=
 =?us-ascii?Q?m5xwCiNNa08FHtc7Y75RGOQVI1Lgy0TPHsyWuzzg8ky+PDdma9K/IwRBIpY3?=
 =?us-ascii?Q?Fz4oSSKMhXbvbobzVSGhVSOMnbq9fRxkflHTlme/zFwHAXfnn2hkB003uFYO?=
 =?us-ascii?Q?JAE0i6/eJBI5Lnz1UpuxMDx5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b433061-d2e2-4c98-07fd-08d9928f4fa3
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 23:30:46.6088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TML/lclX5CiMsFvx0gsz2TdoIBHamkci/FxJOsdQiTQYUhLRZsFUHFgfdUuX3HWU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5190

On Fri, Oct 15, 2021 at 01:22:41AM +0100, Joao Martins wrote:

> dev_pagemap_mapping_shift() does a lookup to figure out
> which order is the page table entry represents. is_zone_device_page()
> is already used to gate usage of dev_pagemap_mapping_shift(). I think
> this might be an artifact of the same issue as 3) in which PMDs/PUDs
> are represented with base pages and hence you can't do what the rest
> of the world does with:

This code is looks broken as written.

vma_address() relies on certain properties that I maybe DAX (maybe
even only FSDAX?) sets on its ZONE_DEVICE pages, and
dev_pagemap_mapping_shift() does not handle the -EFAULT return. It
will crash if a memory failure hits any other kind of ZONE_DEVICE
area.

I'm not sure the comment is correct anyhow:

		/*
		 * Unmap the largest mapping to avoid breaking up
		 * device-dax mappings which are constant size. The
		 * actual size of the mapping being torn down is
		 * communicated in siginfo, see kill_proc()
		 */
		unmap_mapping_range(page->mapping, start, size, 0);

Beacuse for non PageAnon unmap_mapping_range() does either
zap_huge_pud(), __split_huge_pmd(), or zap_huge_pmd().

Despite it's name __split_huge_pmd() does not actually split, it will
call __split_huge_pmd_locked:

	} else if (!(pmd_devmap(*pmd) || is_pmd_migration_entry(*pmd)))
		goto out;
	__split_huge_pmd_locked(vma, pmd, range.start, freeze);

Which does
	if (!vma_is_anonymous(vma)) {
		old_pmd = pmdp_huge_clear_flush_notify(vma, haddr, pmd);

Which is a zap, not split.

So I wonder if there is a reason to use anything other than 4k here
for DAX?

> 	tk->size_shift = page_shift(compound_head(p));
> 
> ... as page_shift() would just return PAGE_SHIFT (as compound_order() is 0).

And what would be so wrong with memory failure doing this as a 4k
page?

Jason
