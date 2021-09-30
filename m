Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940A272
	for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 17:57:34 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18UHM3hS001640;
	Thu, 30 Sep 2021 17:56:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Kj5WVfjqszb9pAlrzqgwSa9c01dELe9N2eba6aa2eqU=;
 b=pyTW6ZjlGekNEXAeBnIAZH6g6F/6aXHWaRyonuAQuNUlIAPMRMjV6GRaDivCst1Q0vgB
 VQJ1nA+bPo8jaBmyCBnM3nfVJR9zwG8fAODE5H8Kece0qqtDv0mzH+GgrbDpiga2hTso
 Ldne6Gpof/lUDsBWqs7ok8TGvkFidEWDk5uNrGCk0Jg1CdhCmJZVQJ3xootKOKiTJjoa
 LaC21G4uqSOGqWMCyfq1C91Zye3CYznLjgS4TkbTWALVYPbFo+WrUa+Jn5Xq5hXS6tLn
 pSQRkWsc+0ffKojqYlVs/G/p6iusnv3Sy9UGRePrPMnx12KvWhfF0egxJtrvaAmOFNJt dw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bdb2dkbwk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Sep 2021 17:56:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18UHuGgu042821;
	Thu, 30 Sep 2021 17:56:30 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
	by userp3020.oracle.com with ESMTP id 3bc3cg9ujn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Sep 2021 17:56:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kr6bC0CfDnuu+EPH8Y3XrHqCBsHuhExwOfdLZQuyWZoAvORikUeDLxo7NJkuIIxgEHGUmKDwEDVLoY89joJOIuHwrS44MSjf7DUzczwdH59g3xnvLtL9Pj7DaToG1T9AqmiVt0UEhaEBS+qmxCf0vSwTVf6ajkAUkJdxAtXcYvcp1SHFZh88/u9uKAnf9Tl60oCcX/PVtjBcSvk81tRZQG2oDv6ufgw0USR5ByaxXEqoPmhWQziSA8zfxJCWdDLN0dqz0m7rgJncQ5+9MoMWA0L5StZpB6kGlj8NPs+Gq+2U0HQ6mWIjwnTT/WpPJ6U6GN8WpywSPYtW0RT/nTD7YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Kj5WVfjqszb9pAlrzqgwSa9c01dELe9N2eba6aa2eqU=;
 b=L1HN2HMBFHLPH/AauUOkYkGz64d8QyJYe+DNfeKZOVLI3kUsR3zHzeRZ1yK68fWQqHr7FW6sKZyif92tUGq6khSjuXkjGp/OPXtnwoo2ggOBFoXfSgeGcT3ijqCvrSLF7GmyjRnqVBEpBewjRS7r9F9ORQHxN/k2qn2uJHUrtgT8SpNtlPnBzNMkyd1w6xnA0v5KDeKTxtRm7/Ok30KmTcZqtxiw8muP3FnDAGAyMfVBVcToJes3gslivdE+9dx7Pm+dO+6lcaYmpUA3ae6qMWMcRnkewa68tnrGJXUsgAE5QBrnSre9YuDXdlGrgrF85wpQbHYxHCnijrmPWPW1Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kj5WVfjqszb9pAlrzqgwSa9c01dELe9N2eba6aa2eqU=;
 b=v7H8l60C+7rt8Az3yfdyydpXX7CsnfysDB4FLZhk/dAYguJyHypfGJyzRy/Qe1rPqEOvAZ5zNDyltJjuQqGQXm9gswvHRTJsxMCigLsj4FLe0ETiTdpyYfEnCr5uyRjuuCGB0O5zuNJBoVI84GixxgG+/BuMHKp3zHUaz/4wmlc=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4127.namprd10.prod.outlook.com (2603:10b6:208:1d8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.16; Thu, 30 Sep
 2021 17:56:27 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%6]) with mapi id 15.20.4566.015; Thu, 30 Sep 2021
 17:56:27 +0000
Message-ID: <2ab374d1-4cc1-60a4-6663-81de7d59667b@oracle.com>
Date: Thu, 30 Sep 2021 18:54:05 +0100
Subject: Re: [PATCH v4 08/14] mm/gup: grab head page refcount once for group
 of subpages
Content-Language: en-US
To: Alistair Popple <apopple@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi
 <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        nvdimm@lists.linux.dev, linux-doc@vger.kernel.org
References: <20210827145819.16471-1-joao.m.martins@oracle.com>
 <3f35cc33-7012-5230-a771-432275e6a21e@oracle.com>
 <20210929193405.GZ3544071@ziepe.ca> <31536278.clc0Zd3cv0@nvdebian>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <31536278.clc0Zd3cv0@nvdebian>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR03CA0007.eurprd03.prod.outlook.com
 (2603:10a6:208:14::20) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.175.177.140] (138.3.204.12) by AM0PR03CA0007.eurprd03.prod.outlook.com (2603:10a6:208:14::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.16 via Frontend Transport; Thu, 30 Sep 2021 17:56:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d159bc41-907c-4372-8e29-08d9843ba047
X-MS-TrafficTypeDiagnostic: MN2PR10MB4127:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB4127B73012A5C0C5CF675AFEBBAA9@MN2PR10MB4127.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	5ESPVsma5sh6MvuLN8LW9SPZan3Gahh8eQBPeb6XuowC/m/H0DD5bOMACivRufSZeqZqZ6jGPpjeSQ56StRPejfMuvHPXk2MAh47VglVQ6ZBrkxC+c9acNJu+Wo4iUU6p2OIq9/wzZ/bvmb60wqXUsywkPcoewQnSz+WMunogGDMkP9y7lzx3WN2h9jsvkgZ5Dqv9TXaBiihtAaIEWfYcYQpIFekaXgel2YB1xEUgZn4sZqRG6VtkhDDmrUJzfxp6TmrwBdKQ55YTvGGh3jXs6bpyuekzVVgk/JOuuKymdlW0qbpRvCF7x0qDcWXinXOVarDDP4VHdf9/5NK6DPT8b98piRPBqt5PQwSYWJlVPzms14JJ4/+zOyvJQOv3lG5oJAvVhhWZv18DX1VyVM3XlMa+HdvhORvJjvf0k4GC4XS6I9qbIZf0c+3PIq5j42YbdFA1IJ7DMDhc230BKyMWd05csDEcdj8Dt923XtvBwmuYo2iq6zONbhMYejWZGUj5mjK4FzTDRS4PLy3mwZM6NIz9pHRbGe7UcB3ONb65HzasXiCr2M3KrNpUUkawoz2H5RcFuA90x0wErdZatMz/oVmVP9EdTH7CYa+euG8955FVpwxZcfcc/6IeoLnSkOtzPKjiD5qetRXY+2mGMulKjEY9jh7cHoIuogwpEomhXzHNwIWODASiRFtm1rUmoFdmYYBtn3KQ9Es4UQBbt7ROMhf0UA+BgR5qXiIssghk60+nwzAiDi9U9Ah8r6c7CKnHI4B0L8+dfRWxONSpjKvCsxfE63mdU9snLLDOpfcYEI=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31696002)(66946007)(4326008)(7416002)(38100700002)(2616005)(66476007)(31686004)(6666004)(66556008)(53546011)(26005)(83380400001)(956004)(8936002)(36756003)(86362001)(6486002)(186003)(2906002)(966005)(8676002)(508600001)(16576012)(110136005)(5660300002)(54906003)(316002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Q3JSVGcyMWZmenFWVkhxemFzSXBma3NhejJ0dHltWFNhZFJ0RWp2Mis5b09t?=
 =?utf-8?B?eElVNGw0RGM0aHVCN0tDYlJCR1MzMDNBbVIrRkthQUFyNFpjZzNTUWtoUkZW?=
 =?utf-8?B?TlUrcCtodXNCSkovMHozWnB6Z1luWTIzVEx5cmhNRm1xWVhjNnpTc3U3bEdW?=
 =?utf-8?B?SG8wVVZJN1JaOXpPRFVhMXl6V0lCWEJ2Tk9QWFNrTkRqdEhZVjlpY0RIMlZC?=
 =?utf-8?B?bzdtYXV3bXBGYk9PVnhoa3o5bHZQRzBabHNhOUI0YmcyTGFzbDZyMno2TWdn?=
 =?utf-8?B?MWFqNmRiQ1l2SHhDRHA3SE9RTU12M2pmd0JwVVB3Zk5HNjV0Vjl5am1WR2hp?=
 =?utf-8?B?S0hJRnVmRW41Y2lzRE9PenM4Q1gxT1pjaW9hQ3ZmYVY1Y3BNWE9YN3ZWVVNj?=
 =?utf-8?B?cFp3aGdMbTBzSEZITlYzbmFjTXpQVFlxM2FRZVdMUkZiU2ZNcXJsa3hjNWVN?=
 =?utf-8?B?RStlVTBoWWoxMm5KSzU3Nm0wZHl0NVY3dW1ibDRKQjNkV3pJUDRqb3crNkda?=
 =?utf-8?B?TWtLTTJBMVJPU0NUM1c0RCtIK1VpdVlpeXAxTDVKZ0VlYUtFK3Y4OFE0bGZY?=
 =?utf-8?B?YThzNHhkclduZE1lVFo4Q2V2VXJBODZqMDlpWXJBcFBPYy8zRUw1a3hlYzA5?=
 =?utf-8?B?Si9JU0FBdXJHdFlLTWNsc3AvQ2ZhWVFQVisybzRqeVhNbU5mcFM2cmN0R2Ru?=
 =?utf-8?B?SURqT3F6Wnlyck1jMHJ0dnZxRkd6NDROOU8vRVZ4SjJCWGlUZjlrMlIwQklz?=
 =?utf-8?B?QmN2U3dNUWxzTlFjVGlTOXRrbDdIN0pDT3NDeDkxMEpJTU5iV0wxNUZBQUY1?=
 =?utf-8?B?T2FUL1U5SkFqOU91YUg2M29DekpXY3BHbWRma0VjY0JzOFZKN0FKbzgvM1Jx?=
 =?utf-8?B?b3JCVkVwejZ5Uk1SWmFpYnVMaktiN3krTVZhL204NGdTRUEzZndpQW5uRGdr?=
 =?utf-8?B?Z2FneEkxR2pxbTFnQXZyOS9qR1dXcGZoNDZsK3VFQTV5TXRyb1d1aU5BSFR5?=
 =?utf-8?B?R3ZCZFI2M052czMzdUJ3LzdVaXZnc0RBajdKY2VoVEJOUTdjVFJqdXJYOGFo?=
 =?utf-8?B?V2R6VjJiZis0MXZjekpsb0dQcHhEUXdCOWdoMElLdWp1VDJHdVl0aFFWTDQx?=
 =?utf-8?B?cGFXM0hIU3lhUk5XRXBaTWxWOUxpMDFmV3dYQWEwbkxRM0swTERIeFpvNzVl?=
 =?utf-8?B?Vnp6Z1MwL3UrQnFDdlNjMVdlTmNOWDlTVGpEeFB6cWFxWmgwZEV4UWtsM2pW?=
 =?utf-8?B?c2R4WUxicllHWmo4djUyRkZmRmV1SjFUbGtsVVNiZ1pjS2x6d0wvWlRrdDBm?=
 =?utf-8?B?cmJOSFdDUnJJdjBJQVA4UVczMWNpNTY0Y3paa0VjcGdBa2llcGZqMEk2aG0v?=
 =?utf-8?B?L21SLzBpand6THBUaVpsbFVEWGdMVi8vcldsUGpNcGRJRmxlTUtlUHNLeTh3?=
 =?utf-8?B?OERsVzNVblR2R3oxWXJmdEw5YSsvZGs3L3NMUEpNNEhBOFJCd0swRmdHTTIv?=
 =?utf-8?B?NlpYVFdtTWo2ZDlkK1JVTHBZZ2RGb1EvUk5yT3pRMUxtWDROVHZyVTE3QnM3?=
 =?utf-8?B?Z2IxWGFBZVRUT1JzQjhiUXV5YnB6dXRROGV2aUFlZ2l4UEZhbXdCWTVrT05m?=
 =?utf-8?B?ZzI0OWcrcEErR3paUSt0bUtndnFKcGpsamY1VTRFT2hvSkNWeENmRDlZQ1pL?=
 =?utf-8?B?WU5VMkhVZjVhcUkzZndiRDVQSjVlV3N2Z3YzSkQ0TENKc0pSWVVtbmRuRzRS?=
 =?utf-8?Q?FY2fnKW6dh7P0m19LVEG8wuvrs/8GJrvHw0rjvK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d159bc41-907c-4372-8e29-08d9843ba047
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 17:56:27.8518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pvo2DjxkoyfR60JIXKEjV2uz/Gx441tOweGg+/lnD29JnSqcyvKGAw54W47PU0iqAoR3xh82XAD1OgV7tgXYyQoe0b+QmrGIlSd8kHPZsR8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4127
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10123 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=778
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109300109
X-Proofpoint-GUID: a0jhvLIe2vt16pK1xs3D3Gt8TVB7haJE
X-Proofpoint-ORIG-GUID: a0jhvLIe2vt16pK1xs3D3Gt8TVB7haJE

On 9/30/21 04:01, Alistair Popple wrote:
> On Thursday, 30 September 2021 5:34:05 AM AEST Jason Gunthorpe wrote:
>> On Wed, Sep 29, 2021 at 12:50:15PM +0100, Joao Martins wrote:
>>
>>>> If the get_dev_pagemap has to remain then it just means we have to
>>>> flush before changing pagemap pointers
>>> Right -- I don't think we should need it as that discussion on the other
>>> thread goes.
>>>
>>> OTOH, using @pgmap might be useful to unblock gup-fast FOLL_LONGTERM
>>> for certain devmap types[0] (like MEMORY_DEVICE_GENERIC [device-dax]
>>> can support it but not MEMORY_DEVICE_FSDAX [fsdax]).
>>
>> When looking at Logan's patches I think it is pretty clear to me that
>> page->pgmap must never be a dangling pointer if the caller has a
>> legitimate refcount on the page.
>>
>> For instance the migrate and stuff all blindly calls
>> is_device_private_page() on the struct page expecting a valid
>> page->pgmap.
>>
>> This also looks like it is happening, ie
>>
>> void __put_page(struct page *page)
>> {
>> 	if (is_zone_device_page(page)) {
>> 		put_dev_pagemap(page->pgmap);
>>
>> Is indeed putting the pgmap ref back when the page becomes ungettable.
>>
>> This properly happens when the page refcount goes to zero and so it
>> should fully interlock with __page_cache_add_speculative():
>>
>> 	if (unlikely(!page_ref_add_unless(page, count, 0))) {
>>
>> Thus, in gup.c, if we succeed at try_grab_compound_head() then
>> page->pgmap is a stable pointer with a valid refcount.
>>
>> So, all the external pgmap stuff in gup.c is completely pointless.
>> try_grab_compound_head() provides us with an equivalent protection at
>> lower cost. Remember gup.c doesn't deref the pgmap at all.
>>
>> Dan/Alistair/Felix do you see any hole in that argument??
> 
> As background note that device pages are currently considered free when
> refcount == 1 but the pgmap reference is dropped when the refcount transitions
> 1->0. The final pgmap reference is typically dropped when a driver calls
> memunmap_pages() and put_page() drops the last page reference:
> 
> void memunmap_pages(struct dev_pagemap *pgmap)
> {
>         unsigned long pfn;
>         int i;
> 
>         dev_pagemap_kill(pgmap);
>         for (i = 0; i < pgmap->nr_range; i++)
>                 for_each_device_pfn(pfn, pgmap, i)
>                         put_page(pfn_to_page(pfn));
>         dev_pagemap_cleanup(pgmap);
> 
> If there are still pgmap references dev_pagemap_cleanup(pgmap) will block until
> the final reference is dropped. So I think your argument holds at least for
> DEVICE_PRIVATE and DEVICE_GENERIC. DEVICE_FS_DAX defines it's own pagemap
> cleanup but I can't see why the same argument wouldn't hold there - if a page
> has a valid refcount it must have a reference on the pagemap too.

IIUC Dan's reasoning was that fsdax wasn't able to deal with surprise removal [1] so his
patches were to ensure fsdax (or the pmem block device) poisons/kills the pages as a way
to notify filesystem/dm that the page was to be kept unmapped:

[1]
https://lore.kernel.org/linux-mm/161604050314.1463742.14151665140035795571.stgit@dwillia2-desk3.amr.corp.intel.com/

But if fsdax doesn't wait for all the pgmap references[*] on its pagemap cleanup callback
then what's the pgmap ref in __gup_device_huge() pairs/protects us up against that is
specific to fsdax?

I am not sure I follow how both the fsdax specific issue ties in with this pgmap ref being
there above.

	Joao

[*] or at least fsdax_pagemap_ops doesn't suggest the contrary ... compared to
dev_pagemap_{kill,cleanup}
