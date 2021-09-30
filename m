Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2061.outbound.protection.outlook.com [40.107.96.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBB62FAF
	for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 03:01:24 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QF2G3UgDuCm+oERN50W3AJk10Phusues4Lq2bz4q/LGgFV/2tPfEbXt+hJfY9UDD4ByD3AMlVa+P5Joy++0wEvRtttfSE1VH3TpyCaVjP0zvWwELDTJgJKC0HHt2GVbZRZZVgM6qn0+MyEMEUiUsEdO3CbKadQplSrODlZzz61qshHW4BY3h6OPPtp/1H/xSAV0j3mhO2M4b76YceudkwDxpUMvBZup4dcTe5esqXzDLsaQo0bY0r7cqSuBvxDhnb3ewmjgFTsbyVXPN0d64r4MBC8JcKRsXPHEysL4xqJiXUAgPiADotNh4vj5U1HWHDiz1XK4PhwhuWA+rRT71OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=wNiPONnEXzVJKLK6u2UnYyrsr5cgfRK20Ues+MJcPmE=;
 b=GOjIuWOw4WCs2WZ/kA1XkBPxtqZNQkVCmU17P6+CMlCV8a3YdkRn6AibZrkJOd6KziJvxrUX/M3f3gF+QA/Amx1xzZMxLLWuAUt3TmCKXaiocmh42fRO3IK2p7hGImKBtB0lfIppjpzA4bbrtxzSP1yBn3HDWplhlVK5g+dPQPX9EV/FcPfgMtpMqyThleBeM0v21kGz9yACO1KlcuTVewc3EUSSTZyKLR49v+A+Yt8NVBZFoVUHRq0KZ+YwOvQhSL+kROzMo/TopoGRjZYkw7N2WS9O2/p02L7bt3ekf7f78ntMzNotT5sFRwvasl4eOYZCV7jNXJj4sAe7qWjRaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNiPONnEXzVJKLK6u2UnYyrsr5cgfRK20Ues+MJcPmE=;
 b=pEDnfD/HW8fNf9UbuO0vzN1aaNSQQuXJsbIIuO/zqx5aC4Fpj1j/wj4T2Mu3HJyJnKdtxz8hNqVVaouipZydx0dVRzd+RvYurpa/ZW+JhzABZOxUcAWHXyRJArVj73qNpcv09BBEoT6mkI1f6jI3bUZbJtteA3zrf6L0LzCGZUeCowJt8gy4C5sP+Swdqz3LPElr4yHoQ1j1Db5H1bPhe6iSs/f/Ezsp+QNdmyTJC/J3hJ+soKyRs02/Hkj4cWaPdq90P9ZsigF0InJABvRXb7nn7w7fHRaFSbNXw0SZtrbbirmU3OUky49xyxzhpjdF95g1hO/eqcDgfV0bO+4g/g==
Received: from MW4PR03CA0083.namprd03.prod.outlook.com (2603:10b6:303:b6::28)
 by MN2PR12MB3038.namprd12.prod.outlook.com (2603:10b6:208:cb::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Thu, 30 Sep
 2021 03:01:21 +0000
Received: from CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::a5) by MW4PR03CA0083.outlook.office365.com
 (2603:10b6:303:b6::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend
 Transport; Thu, 30 Sep 2021 03:01:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT019.mail.protection.outlook.com (10.13.175.57) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Thu, 30 Sep 2021 03:01:20 +0000
Received: from nvdebian.localnet (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 30 Sep
 2021 03:01:17 +0000
From: Alistair Popple <apopple@nvidia.com>
To: Joao Martins <joao.m.martins@oracle.com>, Dan Williams
	<dan.j.williams@intel.com>, Felix Kuehling <Felix.Kuehling@amd.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>
CC: <linux-mm@kvack.org>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang
	<dave.jiang@intel.com>, Naoya Horiguchi <naoya.horiguchi@nec.com>, "Matthew
 Wilcox" <willy@infradead.org>, John Hubbard <jhubbard@nvidia.com>, Jane Chu
	<jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>, Mike Kravetz
	<mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
	<nvdimm@lists.linux.dev>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4 08/14] mm/gup: grab head page refcount once for group of subpages
Date: Thu, 30 Sep 2021 13:01:14 +1000
Message-ID: <31536278.clc0Zd3cv0@nvdebian>
In-Reply-To: <20210929193405.GZ3544071@ziepe.ca>
References: <20210827145819.16471-1-joao.m.martins@oracle.com> <3f35cc33-7012-5230-a771-432275e6a21e@oracle.com> <20210929193405.GZ3544071@ziepe.ca>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8a7de6d-a7a1-41cd-dca1-08d983be94c2
X-MS-TrafficTypeDiagnostic: MN2PR12MB3038:
X-Microsoft-Antispam-PRVS:
	<MN2PR12MB30387141EC65CD611739A633DFAA9@MN2PR12MB3038.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	P1C54hdnjLtu1SsNIUvQq9VBe+m5DLGleK2UHn4GtmQRLb6g0nKbCm5IEc4gRkOPBRrZJTIHMjN2xC6PnOwOwiTTK3u2gDEKyfFXtyamhSX8qcyeAQDmvx4EVLHyijtd0rhmhgl0dK/4bRDL2tWyMfqAvvO2tZyIz+yOlW98hv4maCvreAacxxTPTnRGOCK6I9AaBqpmpKeJGSSGclQ05YI3TzAxVbWcDh8bks7E7MhC8eUzs7BkC7UFq0xeCRUAroShmQaqbsEMxF58pyWZaGji7juuUeNq+T9bhVgvSydRZxcbXhLNQ+HUQ/0xAJo/8v5kvOBrUFLSktSOtqsY/ZY9jom18kD5FWXJ2bhuiIxqiIwFPr+QuMeJez2f7Y5aw9w5bmq8SdoqK4UCsux4OZl5RsrQKWm5SgTAUz8OzUeTTwPa3f37TmTCthXpFoLhSHVHcxj11e1aYzQjNs6N1AmCzOiG2UtybfnJsIkPdiaH4ZIjL2bwI+lYIMBs0Ch9V1ez7Z10Mb4rnbgpP7PIk8XG9g8b8a/LoxMHshn60Pg7XFXoFD6ml8nGUUVbfBsOjtJcCv01IzNNxVq/khsrjA06WZgyjYlovW5R9KD6jDYsr9tGTvOujBauUJ5FNWFsbQyjMlw3CfKSTzGOana2ZTshv5VkZ7hIjzTAHfGBq8k0t5nkj2e7oYRdVEwKu8tTd0GDL6HTYpJtrdDEL+YEldVLoxxIYWqaieJWGJ3Eioc=
X-Forefront-Antispam-Report:
	CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(5660300002)(16526019)(8936002)(36860700001)(336012)(6666004)(9686003)(26005)(7636003)(356005)(186003)(9576002)(508600001)(8676002)(7416002)(83380400001)(70586007)(70206006)(316002)(110136005)(47076005)(426003)(2906002)(82310400003)(4326008)(33716001)(86362001)(54906003)(39026012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 03:01:20.9201
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c8a7de6d-a7a1-41cd-dca1-08d983be94c2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3038

On Thursday, 30 September 2021 5:34:05 AM AEST Jason Gunthorpe wrote:
> On Wed, Sep 29, 2021 at 12:50:15PM +0100, Joao Martins wrote:
> 
> > > If the get_dev_pagemap has to remain then it just means we have to
> > > flush before changing pagemap pointers
> > Right -- I don't think we should need it as that discussion on the other
> > thread goes.
> > 
> > OTOH, using @pgmap might be useful to unblock gup-fast FOLL_LONGTERM
> > for certain devmap types[0] (like MEMORY_DEVICE_GENERIC [device-dax]
> > can support it but not MEMORY_DEVICE_FSDAX [fsdax]).
> 
> When looking at Logan's patches I think it is pretty clear to me that
> page->pgmap must never be a dangling pointer if the caller has a
> legitimate refcount on the page.
> 
> For instance the migrate and stuff all blindly calls
> is_device_private_page() on the struct page expecting a valid
> page->pgmap.
> 
> This also looks like it is happening, ie
> 
> void __put_page(struct page *page)
> {
> 	if (is_zone_device_page(page)) {
> 		put_dev_pagemap(page->pgmap);
> 
> Is indeed putting the pgmap ref back when the page becomes ungettable.
> 
> This properly happens when the page refcount goes to zero and so it
> should fully interlock with __page_cache_add_speculative():
> 
> 	if (unlikely(!page_ref_add_unless(page, count, 0))) {
> 
> Thus, in gup.c, if we succeed at try_grab_compound_head() then
> page->pgmap is a stable pointer with a valid refcount.
> 
> So, all the external pgmap stuff in gup.c is completely pointless.
> try_grab_compound_head() provides us with an equivalent protection at
> lower cost. Remember gup.c doesn't deref the pgmap at all.
> 
> Dan/Alistair/Felix do you see any hole in that argument??

As background note that device pages are currently considered free when
refcount == 1 but the pgmap reference is dropped when the refcount transitions
1->0. The final pgmap reference is typically dropped when a driver calls
memunmap_pages() and put_page() drops the last page reference:

void memunmap_pages(struct dev_pagemap *pgmap)
{
        unsigned long pfn;
        int i;

        dev_pagemap_kill(pgmap);
        for (i = 0; i < pgmap->nr_range; i++)
                for_each_device_pfn(pfn, pgmap, i)
                        put_page(pfn_to_page(pfn));
        dev_pagemap_cleanup(pgmap);

If there are still pgmap references dev_pagemap_cleanup(pgmap) will block until
the final reference is dropped. So I think your argument holds at least for
DEVICE_PRIVATE and DEVICE_GENERIC. DEVICE_FS_DAX defines it's own pagemap
cleanup but I can't see why the same argument wouldn't hold there - if a page
has a valid refcount it must have a reference on the pagemap too.

 - Alistair

> So lets just delete it!
> 
> Jason
> 




