Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46322C88
	for <nvdimm@lists.linux.dev>; Fri,  8 Oct 2021 11:54:51 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SYnMyFahAgwuNqwUUghSgTQ4U2rSmyOGBvJQF1kEyLdyGYleoFyZmoDwnpgIS2XdfN3gAhWsknMZ4BApCyQqXq3/a16x7fkZV0VFlr1DnqBiy5PA1RyY2g51C8kO27BYeipdMzVtx7Ad1bmxhq87wHC8mWA6KMSI4JeE8mLOKiz0udOLmUTfmHJ4lA7abi7sugwCh8xo8Wk9JKxW6skiTEAqq7SvbpQGGAFguvs4JBd88ira1zqSPHLd5pKDRqGhpBIliQOmn1J1xsPXuBubCPjtvnnyRHpeP8inlFTDVB9lj1LV30aY+XZ8Q5Me+uaG8WSqcj3HF8toobRWn6zFkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sZ4Hp50rO2X2zPOLOaVbQBRbV7JnnPkUXDACh3FufdA=;
 b=invNPfSbxbol75IEDuweCF2ytN7qC/n9ZyZcLbX/XnKt30mLnK00uv5GlblPhr4jITwETNORu1lmTCD6oY2o2B7PC7dpRHWat0j/qSFOAsnqMEexIdKepMPXhqVSqbF1xCY+zfLEEHolI9I4B7T2PdGYMoAUqhAS5snNB+YplwTUUHjFYbryfpkkBRfpmPsnDB6HOxdRs+2LlLiVkCvRvlZqRsDLIb0EZ3bXazH6bUyeDRIOSiNCY8CJtaUmiDH7n+1aC0GgbhSz+hUm2M1LOz0M91cUwyGYlCUl4PgTmc+qCybVK71S/dSHJ+Q9WRjGb5GxC0TB7sn0lrObtRY34A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZ4Hp50rO2X2zPOLOaVbQBRbV7JnnPkUXDACh3FufdA=;
 b=C8y0UAJMLyBKVgafDLjBfl0BMiuOrrB4LOPz1//GbOktG8bQFx8eKJD/Ca0TLjPNsre6HGvxObX2oJGPoUWnmpCzFeNFDdC6WmjQ+7sfmYaRg9Dn9icEiY5Wb3g+yfGXcWt/cUlXSDobzgI02qo9QYi+3Llcxmr5yCbWs0oOOmR5+OyZYbIcjLhKZy6C/CWKW1LCUPx4AXy7rGnRzoSBx5u682fYta3udq6QT+EkaogkWmyiyVZZGQLopdc5hAql/lNuCbsuHqmmngfAU+SrgBA7jh9w6EzIK5VFwA29bTtYmJq28Xmzx0nvpfC5agJFsiLpeSCpkpqvsNCjCHAvDw==
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5061.namprd12.prod.outlook.com (2603:10b6:208:310::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Fri, 8 Oct
 2021 11:54:49 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%7]) with mapi id 15.20.4587.022; Fri, 8 Oct 2021
 11:54:49 +0000
Date: Fri, 8 Oct 2021 08:54:48 -0300
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
Message-ID: <20211008115448.GA2976530@nvidia.com>
References: <20210827145819.16471-1-joao.m.martins@oracle.com>
 <20210827145819.16471-9-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827145819.16471-9-joao.m.martins@oracle.com>
X-ClientProxiedBy: MN2PR08CA0014.namprd08.prod.outlook.com
 (2603:10b6:208:239::19) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR08CA0014.namprd08.prod.outlook.com (2603:10b6:208:239::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Fri, 8 Oct 2021 11:54:49 +0000
Received: from jgg by mlx with local (Exim 4.94)	(envelope-from <jgg@nvidia.com>)	id 1mYoSe-00CUNf-2n; Fri, 08 Oct 2021 08:54:48 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25032739-e771-4478-1ae7-08d98a526e32
X-MS-TrafficTypeDiagnostic: BL1PR12MB5061:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS:
	<BL1PR12MB50611F6F0A4050187021B7F8C2B29@BL1PR12MB5061.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TizXLbM+FxmddaGEN/fMbMb4bzkLZIsKjmOy80rRY2JAnMTMU0ovkNz8FL0FCl9piz9/WV9ccEShrZgRoM+fVbhmNI2G64nTFuLUiGFsVyCNkh8MqrSuufwU8//yKoGobR2ZEd7+OKgxYYHDDKI4B/jK8x7lO2IXFahubdSBDYHlr31082mi56WiKZW3jIPCWCt/zr2r0oPrpuppOSHZlcQQ9JgbQFa3frSmQgiWBuS3rmup+CYf4y8BuzfGG8+SgzK1yCg502FpijVKHwwrylNIyJT4F8wFOfguUwKSA6Weg2HszwtQv9D9Cw904508Xmja+qxDRpjDwX+wMWWtlGxJK/iznL9LgLzYau6gTrW57FCfXnQABqAQev7rs78tcVpH0BgZtc2lKU9ejCFc5CNpUFu0WOKSeNvgCMWjS5gVkN9OzJsnightnlOjyGb1Uktz293h+xZtWeyh4LMOQmwdS/GoklLKj9HP52h5gImnC7YvU4XlsakE7chdneaVZfiUBYsWJzddgyfoqmP1E8ykKsCRgiDtpadv2dUnha2WjZxfjcC0J5s+FQcQMVSKZaPOmHgxL3QLLkMimS2+gtI9u2eWQxk565GHDR0baGEdFS7v1h3cSzijD5lFru8vvgiJ0n+8zhXYeMiZGnImSQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(186003)(86362001)(26005)(1076003)(36756003)(66476007)(38100700002)(66556008)(6916009)(33656002)(8676002)(2906002)(316002)(83380400001)(4326008)(2616005)(426003)(5660300002)(9746002)(7416002)(8936002)(9786002)(54906003)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qWxclkV4sUaHgixOif6tYCXMQLE0edwoH+Z+JjGdRf/pT+UP+GsByLNpjzT/?=
 =?us-ascii?Q?X/ss9gFGnv1BdEUeQ7g8fGEr/RRX9cnz8Numor7L61BBtfg5KMalpzlkIWcp?=
 =?us-ascii?Q?awWGc8ZF7R9dZmf9Tj+b3hJdkv5RfeEBgfQBXJNhtZ5SYJstJ7G3k57URYzT?=
 =?us-ascii?Q?rs0nnzQDVxYcFBI2bBflx8c0A3it52tuxst+pbHn1KY9Ni+VFjeXsi7CumbL?=
 =?us-ascii?Q?17GxtBwRQO+YY/YbPeZXN8Ayjj4e4bXxjVuluU6ytiKWk+hP6IsY/x67Gb38?=
 =?us-ascii?Q?84Pfiv4mh0nvPIQ4OLqP3PASv1nxYMABXxzl+MV5wq3DJaBOB1MlCObDAJyL?=
 =?us-ascii?Q?snSjyfefKrstJi/rkn0ONTHO94Y3MvbtfeGGuKBEzS9dofwqQseeWTiKFQl6?=
 =?us-ascii?Q?+J0wvPJqWqPOyrlp2fS8C3F8mSBeAL8zHTRehcIg3wYCeDgjFWsPeHjy5PnP?=
 =?us-ascii?Q?2LjvjUZWABotTCyZLNemw5sFEKquIVPq7A5X5l2FM6hDAKD1UOl4+SDss0+T?=
 =?us-ascii?Q?9YhqKEdiJ3phDzEAl4HZ8npC4wN7fN5KFG11hNJKBabBmjCZT6uizb/KO3H1?=
 =?us-ascii?Q?YuKlh3WFdGl1eUX3Mc2cw2MDyI57dQNRu6SJgby8SHpDi+2ckaXTWUO8IEQJ?=
 =?us-ascii?Q?V2rlJtNZyzdoiXcSeO5D5w017aUDBUXbwT+OrmwY6iqHifvOQhSuVIRGyt3D?=
 =?us-ascii?Q?o1q7yKprgT+oYN0qeqiwdTsT/mJ8lIXoXrd9Jln+NAiJtH9vkBubxDq6loW0?=
 =?us-ascii?Q?0E8tEWtMnCN/DwSkSwT0BR6OfOKEtTYP+3yzMKjES7KmVyYjiMxx9koP58Nd?=
 =?us-ascii?Q?KTBDHLsshBRrHt04Ydt+7R96u3Du8rOZUefr5xcnyjRyDI2z0znMSPiGsbeO?=
 =?us-ascii?Q?rTCDGCehpGiqeu/orHeJ3P6K6Ur0lHjVTuZvQzRl2sxSBsPa7KvnIyPhYAXv?=
 =?us-ascii?Q?xyV7Dvv0xlvqMwIuTeWoe/sfNeyqRQAESP5ymMBFu3sBXy2DanH5gxGZAY70?=
 =?us-ascii?Q?u+YIpznmzTCzFc0q9u2jxqLhdKylRx1uVEaRZmGIUt78TuL30IknpaoTF6Ga?=
 =?us-ascii?Q?o4QQb+6G2ncuD8lBgPlekbN0st/Mpr/k2dcS5sOTWdbDIsWiz5NwMeFQx+4u?=
 =?us-ascii?Q?CuhLcj6SG1vVuMNkq6Kb6U5jsoOtDBKXMh8bDSYfhucvWIl5qkh5p2I4k/bO?=
 =?us-ascii?Q?2gM2d2V+A+O9uQFuPQ9CLL/Lv3uyNf//HR758vm7xcmE35nuOavvWPX2JoQG?=
 =?us-ascii?Q?fzdTuyJjt7ux4N7QuYP5DXw2kzrAvoiYv4Me0WGdJRiB7yAOf05RaJZGri8a?=
 =?us-ascii?Q?T7kspTJzQ2ZV1zsDcBTr4WXc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25032739-e771-4478-1ae7-08d98a526e32
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 11:54:49.4098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YPkf/fDa6B+r7GDa2e3lrislVYPtu5yWuzB+wi1L8UOaDdUDrpzAYL0dXTXNyfPp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5061

On Fri, Aug 27, 2021 at 03:58:13PM +0100, Joao Martins wrote:
> @@ -2252,16 +2265,25 @@ static int __gup_device_huge(unsigned long pfn, unsigned long addr,
>  			ret = 0;
>  			break;
>  		}
> -		SetPageReferenced(page);
> -		pages[*nr] = page;
> -		if (unlikely(!try_grab_page(page, flags))) {
> -			undo_dev_pagemap(nr, nr_start, flags, pages);
> +
> +		head = compound_head(page);
> +		/* @end is assumed to be limited at most one compound page */
> +		if (PageHead(head))
> +			next = end;
> +		refs = record_subpages(page, addr, next, pages + *nr);
> +
> +		SetPageReferenced(head);
> +		if (unlikely(!try_grab_compound_head(head, refs, flags))) {

I was thinking about this some more, and this ordering doesn't seem
like a good idea. We shouldn't be looking at any part of the struct
page without holding the refcount, certainly not the compound_head()

The only optimization that might work here is to grab the head, then
compute the extent of tail pages and amalgamate them. Holding a ref on
the head also secures the tails.

Which also means most of what I was suggesting isn't going to work
anyhow.

Jason
