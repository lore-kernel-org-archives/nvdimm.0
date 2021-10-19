Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7245F2C80
	for <nvdimm@lists.linux.dev>; Tue, 19 Oct 2021 15:38:41 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jRDzYIFq5qoCPQ4vyetdvlICQ8h9MykL8/MBQS3qmRZMa3kF5EVyILy/GPPBbYBjea81MgGto9LIz00gSM8k1Zpuq93vF2PP/P96Wbq3pfLJX7nu9UY/NaOP4KISDEjV56YRbh7w2jSb37XWPz5yqGGIU5LmFA1q40Eg8Oxqci9RPn7b/T0cKQvbrvVs0tsEQaqM2Ox8bmmg+BcuLXr4ekiNXXbn4nqEDLRQ9P2IB72G8bYtyZAiQJsmvLQzi9y91IaCejGH9U+DGvvfb591SJ/PVDB0YoTGa5axg84rY0ZkLJXQbtYp/ynDQ3omE2teGUpoEQJjoXQRqScVhyKfYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DJEH1lhGPqWAhCW7rK7+jP+0CAeP1+7HZWhLGTWtWT8=;
 b=l0FgxMaxETU73o8e1Prtu6eMiSYR3q3OvPVL9rVQoJ9zVCIt5xvpUio0xBgvIbzXyi71upqAQbaXbn6Wx5wT/Fjz0t1QxDfQdnVtPJVljeftxV6KjqL1Rurdkgkc+djiYTrHgoh2ylvaHPosDGCs+7RdDeRRW3Krx7SbzW9+6UgvPWJkKT+vADiqy67fOo8WWxg+WuIHJY9bIr6+OJeEU2JbladQ6VU7i/mLMbDiHRWzZyx1dF0TY356QxZa+Sfji++wBCixd3bNAUPOfi5LyEOo/exnR9yHclZIKxmZUNHyszNsMllX2ysBWe38YogjslfG5lJoV2i8yQkgahJi+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJEH1lhGPqWAhCW7rK7+jP+0CAeP1+7HZWhLGTWtWT8=;
 b=ufuC+XdfliCcJH557x75cDX0R97MAo9lmvA7bWlv+4J0oFosf7amEJIvtNWL3/YTPCard4iL+3vGP0N6zGOemmIP39Q+5Nebig8oJRrjoKs1igKBr5JeZieuiVDPyEP9cEKAFA2FclU6Pay3EQsEAvjz7FeX/ejogzha/fZ/tzg=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR1201MB2491.namprd12.prod.outlook.com (2603:10b6:3:eb::23)
 by DM5PR12MB2485.namprd12.prod.outlook.com (2603:10b6:4:bb::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Tue, 19 Oct
 2021 15:38:38 +0000
Received: from DM5PR1201MB2491.namprd12.prod.outlook.com
 ([fe80::d153:3aa6:4677:e29]) by DM5PR1201MB2491.namprd12.prod.outlook.com
 ([fe80::d153:3aa6:4677:e29%7]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 15:38:38 +0000
Subject: Re: can we finally kill off CONFIG_FS_DAX_LIMITED
To: Jason Gunthorpe <jgg@nvidia.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Christoph Hellwig <hch@lst.de>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Linux NVDIMM <nvdimm@lists.linux.dev>,
 linux-s390 <linux-s390@vger.kernel.org>, Matthew Wilcox
 <willy@infradead.org>, Alex Sierra <alex.sierra@amd.com>,
 Linux MM <linux-mm@kvack.org>, Ralph Campbell <rcampbell@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, Vishal Verma
 <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 "Phillips, Daniel" <Daniel.Phillips@amd.com>
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
 <20211019142032.GT2744544@nvidia.com>
From: Felix Kuehling <felix.kuehling@amd.com>
Message-ID: <d5a7e72d-b366-4fb4-8c41-100e5d8ce020@amd.com>
Date: Tue, 19 Oct 2021 11:38:36 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211019142032.GT2744544@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: YTOPR0101CA0027.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:15::40) To DM5PR1201MB2491.namprd12.prod.outlook.com
 (2603:10b6:3:eb::23)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [192.168.2.100] (142.118.126.231) by YTOPR0101CA0027.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:15::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 15:38:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9457368b-ed04-4dfb-1e8e-08d99316855d
X-MS-TrafficTypeDiagnostic: DM5PR12MB2485:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS:
	<DM5PR12MB24856A05B64FDA143C6EAB2692BD9@DM5PR12MB2485.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	yyOwZywtvobXeAJSn1oRFVE595JqXWV9QR7DBTlfRds5wjSp8zMhr2P8DRk6v6TPNJoMTh6jnNIU8jb+QTSLaeEEI4KkRsBgd+ZmZ+1gVIIjCT4Iyd3PWh5zGrLrCTdj2pseRsmZcIGuC4rBsxgXI8JdVATo5BVNQCGz7zAlgI6ZkeGjxIN712TR2w/tGH0dRHHsYBQO6S6C5J+3ahiISLQGZKcL5/cXKfGABCar6RxSw3ZV6Xo2AI3+62Aou+KzlraqUjXGOLNnwfU8bmqM3DrWDZFoINkduCE7Y+k/frF53pauhPD6YFP/JrSaAjZC2ENAZOPx7S37iiq5vrzp/7YmhfCKpENTwIvI28FzaBfDsFvl7VKWpNe5y4j68gIxnd964IywGGzzhLzn3gIPWIdToz21amzabOp2F3BJEaSepvi8RJEKVZbYgPlxc7RjBqcZXz9fx7kyoQBR5eBcSToXSYRHuXsGvbDPc1wBjmDZWUqjD271+jBwrI2yR2Cp/zdy4IYYUM/3q9HVyVm3Rb/ptlFyu1eWWnKl8TJXyvNwj7F2gWWxoEXnPSrh/TeSpJUV4fbzQFL7LMheUMg3QXSZHKYte4lRA1GcncNSQxVI3i6fVv4MDSJ2dyxDD8TyjMNJev5J3ntS6e50jvMUyHwkfwcgu2KN+gegfRenMhwrC2ZmljKl8rxExffU7R9n5g6zkRVPSlcrNcRt5i2Ig0Kg8yKfUbZ9/QoJPXoSyaCCrOm9VjFbDWWxNaIv92L/
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB2491.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(31696002)(2906002)(7416002)(2616005)(316002)(44832011)(5660300002)(110136005)(31686004)(54906003)(16576012)(36756003)(956004)(83380400001)(86362001)(66556008)(508600001)(38100700002)(4001150100001)(8936002)(26005)(186003)(66946007)(66476007)(4326008)(8676002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Tkd2M3pIbDBNQjBJTmxRZkNPMDhhR0FPSkNZVEFEdlI5bWtYZTc2S09sTENW?=
 =?utf-8?B?a3BocWVkNFBqM0F5VjFmVE9QcFpRZUlLcjRDZHE1cDhsem01QTI1VTl0Q3dW?=
 =?utf-8?B?T1k1UHFzbjljTTZYdlU3VmI5cnFWTzlOcXh5TnlRTmhRK0J3TnFicTVWL2lh?=
 =?utf-8?B?OVBnSlJ3M255WjdFckNJcSsyUGFXL0VUNFByYnNvVU45WHArSzVFTWRIbnd1?=
 =?utf-8?B?NnQveDZvQXF3WnBkYXZrWjFEb3EvRUY5WHlIYWpvR2FIMTVGYzJHais1RXVD?=
 =?utf-8?B?UDN1ejdFYUcvYjY0azd1azlxaklYM05Xc1F1WVp3ZEtWc1VEN1NKejg1TE41?=
 =?utf-8?B?Qmc4RXFvNW5ZZ0JtWkxoK3FmMld1TFBkeG9hSHI5cDJ5eGlZUEFkTnVPOFox?=
 =?utf-8?B?L0pIdi9sbDR5a0VZRkZYUEJMbDVhZ2RaOUx6T3FPTzNhUXJRNytPTVZvb3kx?=
 =?utf-8?B?UEZmZWVCVjhSWW5kOEZTSkRiQXJyTGhNeXdLTjBKcEtnVkNVOVlSTWd0Mlor?=
 =?utf-8?B?NVArUXZKdVBIOGRCdDhQdDhQUjIybE9pdG43ODdWUGEydTR5aWt1aElNaHps?=
 =?utf-8?B?aGdJdHFRWVg1bnFFZnlZKzVvV2tGcE0zZDNBcnNQRjBKTmtBdmdzS0s5OU4y?=
 =?utf-8?B?ZGp6NkoxUkw1elNqVXpySDM1eUNjTWhFZzBaZlVzNXgrclErWDJwNzU2aXow?=
 =?utf-8?B?bTd6Q0tWUGR0ZGF5UndQVVE5eVZWOHgzTGszTktkSTVCOTIwc1pjNkpReWd6?=
 =?utf-8?B?L2tycGhnYy8zdmQ2WGM2MWpIUldOTzlkRnhLRDBkNnk1Uk9YdFhsb3JYSWF1?=
 =?utf-8?B?M0hFT1NjMTFZOUZNYktOLzhrQkVSbjdhOVlpZms4S3JFUlVzTTZ1M3lKeGZv?=
 =?utf-8?B?RHQ5Ly84N29iNnU3NERMRFBHRkZOdkNXbm1kdUZvRFNRWE1EY3NDYjV6SEx5?=
 =?utf-8?B?Q1hPamcwWHJ1aU9OT0RuZFBHekRxMmlqakpDeFYzSDlGN0t2d2JqemJ5THFv?=
 =?utf-8?B?OTlvS2ExNnUvNEd6dVhHai9Vak1vTzdmaDBXd1ZNSEpBRkR4aGord1hWem1B?=
 =?utf-8?B?T3FzUmt0TFpFcUQ0WEdkajB5ekRBZE1iY1hsNm8xSDNHM1R6YnRGaS9PUzNE?=
 =?utf-8?B?ckRyMGNWZlBrL0xVTDdvVWVVSmhqWEs0WUsxSGRPeUphYUxSdngvdzVSRmFy?=
 =?utf-8?B?QXFPbkkvTWlMYXUvaGcxOU50UnJIRXV2L2RJbHIzS1Y5UHFXSzNTUW5sd1Ew?=
 =?utf-8?B?VU1ZeDVZdENmb2d5UjBUeTZ1WVZMalovRytDMFIvdW5MRExBS2xXVXBZaXBh?=
 =?utf-8?B?UWRVYUNXSnlFYjdjM1hRNW1GenVKWjFybDhyamlXWk1POVVDU3pxSFQxSDNV?=
 =?utf-8?B?WFNta1IrRmo1NHBqNzN3ZnczVFRNWEZ0c0tKSE9lclpYaUZTbmh4VzlXbTZu?=
 =?utf-8?B?YnVTYW92elljWi9LajdrZGhGNWdwRkpUUlpkOGozaEhKekRHamxYT011T2lj?=
 =?utf-8?B?MWMzTHhSVjZWMWcycTFMMHNqemM5Nlptd1hONkhndnQ3TXQ4dGRzZlVCMEhH?=
 =?utf-8?B?cGZRQ3NxZnBzV1hVZUNBNVFmeHQyUm5uZGNTSThDSTAwc24zci9CNG1EWGpt?=
 =?utf-8?B?T1lhWWFTMCtiNnhRdTBQSmtGTzU3TlI4cFJXQ3FXMnc2Q21ZbnZsOFhNcisx?=
 =?utf-8?B?OCtWWFhwQ0IwV2RoR2NrOUtqYXBNSHllTm13eDJLMExOZUZTS1diekwvL3JP?=
 =?utf-8?B?a3A5SXY0Ykh1TEhCc1M1d2VQdmhZdUNQWHV0QXF5bUp6M3RYWG1QSUdyN3NZ?=
 =?utf-8?B?VmVRVXNEZEl6eTRBWHJZZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9457368b-ed04-4dfb-1e8e-08d99316855d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB2491.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 15:38:38.7830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wCsXS2JNGZvDJPTXY/KTS/+vk+Hp5+ddjuTjv0IqSvh4fK4j86BSXevUbbYHW6nPUaXgyfKgs8O5XgQs4oELrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2485

Am 2021-10-19 um 10:20 a.m. schrieb Jason Gunthorpe:
> On Mon, Oct 18, 2021 at 09:26:24PM -0700, Dan Williams wrote:
>> On Mon, Oct 18, 2021 at 4:31 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>>> On Fri, Oct 15, 2021 at 01:22:41AM +0100, Joao Martins wrote:
>>>
>>>> dev_pagemap_mapping_shift() does a lookup to figure out
>>>> which order is the page table entry represents. is_zone_device_page()
>>>> is already used to gate usage of dev_pagemap_mapping_shift(). I think
>>>> this might be an artifact of the same issue as 3) in which PMDs/PUDs
>>>> are represented with base pages and hence you can't do what the rest
>>>> of the world does with:
>>> This code is looks broken as written.
>>>
>>> vma_address() relies on certain properties that I maybe DAX (maybe
>>> even only FSDAX?) sets on its ZONE_DEVICE pages, and
>>> dev_pagemap_mapping_shift() does not handle the -EFAULT return. It
>>> will crash if a memory failure hits any other kind of ZONE_DEVICE
>>> area.
>> That case is gated with a TODO in memory_failure_dev_pagemap(). I
>> never got any response to queries about what to do about memory
>> failure vs HMM.
> Unfortunately neither Logan nor Felix noticed that TODO conditional
> when adding new types..

You mean this?

        if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
                /*
                 * TODO: Handle HMM pages which may need coordination
                 * with device-side memory.
                 */
                goto unlock;
        }

Yeah, I never looked at that. Alex, we'll need to add || pgmap->type ==
MEMORY_DEVICE_COHERENT here. Or should we change this into a test that
looks for the pgmap->types that are actually handled by
memory_failure_dev_pagemap? E.g.

        if (pgmap->type != MEMORY_DEVICE_FS_DAX)
                goto unlock;

I think in case of a real HW error, our driver should be calling
memory_failure. But then a callback from here back into the driver
wouldn't make sense.

For MADV_HWPOISON we may need a callback to the driver, if we want the
driver to treat it like an actual HW error and retire the page.


>
> But maybe it is dead code anyhow as it already has this:
>
> 	cookie = dax_lock_page(page);
> 	if (!cookie)
> 		goto out;
>
> Right before? Doesn't that already always fail for anything that isn't
> a DAX?

I guess the check for the pgmap->type should come before this.

Regards,
  Felix


>
>>> I'm not sure the comment is correct anyhow:
>>>
>>>                 /*
>>>                  * Unmap the largest mapping to avoid breaking up
>>>                  * device-dax mappings which are constant size. The
>>>                  * actual size of the mapping being torn down is
>>>                  * communicated in siginfo, see kill_proc()
>>>                  */
>>>                 unmap_mapping_range(page->mapping, start, size, 0);
>>>
>>> Beacuse for non PageAnon unmap_mapping_range() does either
>>> zap_huge_pud(), __split_huge_pmd(), or zap_huge_pmd().
>>>
>>> Despite it's name __split_huge_pmd() does not actually split, it will
>>> call __split_huge_pmd_locked:
>>>
>>>         } else if (!(pmd_devmap(*pmd) || is_pmd_migration_entry(*pmd)))
>>>                 goto out;
>>>         __split_huge_pmd_locked(vma, pmd, range.start, freeze);
>>>
>>> Which does
>>>         if (!vma_is_anonymous(vma)) {
>>>                 old_pmd = pmdp_huge_clear_flush_notify(vma, haddr, pmd);
>>>
>>> Which is a zap, not split.
>>>
>>> So I wonder if there is a reason to use anything other than 4k here
>>> for DAX?
>>>
>>>>       tk->size_shift = page_shift(compound_head(p));
>>>>
>>>> ... as page_shift() would just return PAGE_SHIFT (as compound_order() is 0).
>>> And what would be so wrong with memory failure doing this as a 4k
>>> page?
>> device-dax does not support misaligned mappings. It makes hard
>> guarantees for applications that can not afford the page table
>> allocation overhead of sub-1GB mappings.
> memory-failure is the wrong layer to enforce this anyhow - if someday
> unmap_mapping_range() did learn to break up the 1GB pages then we'd
> want to put the condition to preserve device-dax mappings there, not
> way up in memory-failure.
>
> So we can just delete the detection of the page size and rely on the
> zap code to wipe out the entire level, not split it. Which is what we
> have today already.
>
> Jason
