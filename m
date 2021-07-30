Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F401672
	for <nvdimm@lists.linux.dev>; Fri, 30 Jul 2021 16:13:47 +0000 (UTC)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16UG8NV1012054;
	Fri, 30 Jul 2021 16:13:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=bb7Z7YcRtrO/KJm7L96CyLbxNQmzlBPd0r/lzpI5Ws0=;
 b=eN4iIAO2Wj6WUr9/7tkZspA0ZBUhPosN5VRjA8FlbthNvC1AJggzvWhPs2KredCHSnwN
 cpbxqgO1dnWheguPlUkjm7JdQxIF6rmLihykT8qoFjzu95xI205WnrDOpBE1xq7nvv7K
 u5hhMfD9grxSGtj1Fs+NZPyNskYdcLmdkfEYTRZok8u6KipUemJRBWJy11oYLTh2HdGc
 Sjezz9RfhLHQz7bF1tH5Z/kNjkHL+FYpF5QqkzEajP3wtO4Lkq5ArWhl6hTyOWydw2DK
 utWRFyMt27IGcOPns4YpvxJrLlxT4awF+9Ifirm6v3/ur2ypkvluzg3geTwGxodnkTtC cg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=bb7Z7YcRtrO/KJm7L96CyLbxNQmzlBPd0r/lzpI5Ws0=;
 b=Y7Kb/WV/XJHgXx178VAzbyEssSaTbCsO3+Dm2phlHGXlK7hH/JJXHbT82wSFoGu2HjJ0
 Zyk4UykdVfIpNIiellaBLVEQiquQbEw/nCpOoyGGY3kFvhARznsBzURgj4f9Th1aD2ck
 t03m3WBDKMknGBn0ZU5lAZ3+bPXKLMcwNd4QqYw2RhQ6DgtZRQXpVmJyZcgxy7tjHqhy
 ZGzbV8w0DDUkRvDNik1Ml9Hocrz6a/nZPHPLp8QyIxCKXkQRQxAuvaRlM1cFTIOsNxHs
 h0Jp67ZgyBTNsvGC8CoTUmrFZZ4zt6lD4M2A7zzBa96Trd7HkvMe8FTfHIvHKb+hbcHW hA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a3jpd42cr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jul 2021 16:13:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16UG78wG194938;
	Fri, 30 Jul 2021 16:13:20 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
	by userp3030.oracle.com with ESMTP id 3a2359t77a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jul 2021 16:13:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JzFKXRoSKizu/TvPkxHfMawD+DrFI5Xv3DxbXO/4bppbcyymA2Mp5Bld87YeLIGhO4Ze8SYUcAFJmaCIM0GgZOvULF9rNW7CLeGeug366/n7gGcP7z+JAeZoujlQMxDyZRU1RnrWSPL1YA+phI6f2aVNW+H8cCBJ7FT3FRCjW9MuidkS/PORnGt2v8JyiqVxhJKhArN74jfuEy+i3beshfi+FWP4kWu5S2xclNXvWs4hhJorJ/llWA+0yQe99wEFiZnS/8SggEvdq2mANNLCHhTNyZDp6/hRKEEseUG1DT9TmJuJjGGDlSBPrJtngRJbFFzM3IZgeIjob6MwfZGkcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bb7Z7YcRtrO/KJm7L96CyLbxNQmzlBPd0r/lzpI5Ws0=;
 b=l6Q4EZOBsF86Tp/OtXDqkJkW+k8u5OlPblWbVybbVDRIibHehm6ZXbQHfdG9AMQcedDLd9nFoqnleX1XMnasS4amdZTlws45d0IXfK/k8GHSIPBZR048h15xDT72OZwdFvVQ+zupr8jNtIIVmnkixUCPaLgWgFNvnJRjXUNAwEaHtqOBk2UqmOvuPyDIU3bp6RQnEp3sdMJ9uTuzBZtjDN0Bo4jPTaV5Frpy3dg9HMhZXuDHht2UoZK6UbAvmOGLpzR5ymD0fLr/3zPHY9LYPxF3nlMb7C0bx/IWuZGB07C6p5wJpbfR8/XjQYYV70KDZtI/J4yqk9P67vtaMmzPmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bb7Z7YcRtrO/KJm7L96CyLbxNQmzlBPd0r/lzpI5Ws0=;
 b=pFbl+uk0IaHS92xtXwNhY3aCKs8/ZUgKQVw0z7tGldxcQEGl0UQZC0Bj0S+c7gYNYDAf9ZJin71AnEYrA1ESM0+wybMipA3k0qU1wdsys8LIEYk/eAz7ulIzMH6vg2Ko97KruaivSTzG6eo+BWX/x+Q4xWKrTt+NhkmqNQkZ1ww=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4365.namprd10.prod.outlook.com (2603:10b6:208:199::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20; Fri, 30 Jul
 2021 16:13:15 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4373.025; Fri, 30 Jul 2021
 16:13:15 +0000
Subject: Re: [PATCH v3 04/14] mm/memremap: add ZONE_DEVICE support for
 compound pages
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux MM <linux-mm@kvack.org>, Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi
 <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714193542.21857-5-joao.m.martins@oracle.com>
 <CAPcyv4jwd_dzTH1H+cbiKqfK5=Xaa9JY=EVKHhPbjicVZA-URQ@mail.gmail.com>
 <d73793a8-7540-c473-0e30-0880341c2baf@oracle.com>
 <CAPcyv4igDypf04H2bK0G3cR=4ZrND2VL4UoSUN5zeLVa_vbfiA@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <0746bc85-b4e9-0cc1-1dcb-2a3333df6f0d@oracle.com>
Date: Fri, 30 Jul 2021 17:13:08 +0100
In-Reply-To: <CAPcyv4igDypf04H2bK0G3cR=4ZrND2VL4UoSUN5zeLVa_vbfiA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0044.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::32) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO2P265CA0044.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:61::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Fri, 30 Jul 2021 16:13:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33dc6de1-1f36-4e56-00a6-08d95374efa6
X-MS-TrafficTypeDiagnostic: MN2PR10MB4365:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB4365271E777BD817BCECFEB2BBEC9@MN2PR10MB4365.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	sIUd0q92ulsdwpCjYWXeHYO3bNH7XlL29A/6UXJmpthecWqdjgjVbSVfIn6DhsiyeObSQSx/ij6+3wvYhLHdRizUf415mMR/KRCxKZ/mE7WsEYemieV71QhUBV5EK9UQauJM2QlIrwa5HRCz5Fy4QGS/38YoXWwvyk7Pw2tV71VdRsusGIZ7RtwxKYYvx8lZWKgcPNjjgDxB+d5FPQ1oqc1t1gvQ+ew8sFxUcAxscW9kOrWhRASZhkb4RJ3j8DuWw53lIYYdJe43AEaA+u1AAh6hwtKWoS2vdcAeRZBmSxXjSF1u7M5N8NSRo0FOQy4F+Sfy//u7sjyX2yKCsDVWwxUQwOxQ6Zjx+Ydrcr+YlsWDxpWLDWxka7Uo68bfEEis1xeXhqBlwwjbDZzeJqiOqVANeK8ZzD5U3NHeK/r0rsV9eikC3o2nqP3JHaLTW8iD8FI6EHfPDSoCgvj5hh2+PpnePWT4bVXthhSAM8koP8jGKV+XySm20e1ySGhHnOo57IhygYqc2QgrLJiMhWwFd+MhXIUEcxttC6YswY/BiWqeUw+uZ0TLlVB6oKPa7vqcStxB8SrL5d65szdHmqcfV8UwBmj4S2i2eCdZGSaFYrPxfpk5ND4wiSA81DALytRXa92YFq5vCm3R7HokbzCO8xH9Uhe5kYil6U/FRr90felccf5TbOBpNsCmyGQHJTiTQzM+/HTKD5daFMJ6XNERLQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(396003)(366004)(136003)(376002)(4326008)(83380400001)(2616005)(5660300002)(7416002)(38100700002)(8936002)(2906002)(956004)(66556008)(316002)(66476007)(6666004)(16576012)(31686004)(54906003)(6486002)(53546011)(478600001)(26005)(186003)(6916009)(8676002)(31696002)(36756003)(66946007)(86362001)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?dzZjaUttb2NoVzJxZHVudVFDRnJZSTJsa0xybnFnWXUwcUo3bE1HY2ExWFpH?=
 =?utf-8?B?Y3c0MmNJb2x4VDV1WWJzVFpLc3ZBZ284dHp6Y001NWUwL3NPeXMwR2d0czQ0?=
 =?utf-8?B?MUV2Y2h3K2t6WjVQaTFrOFFmWVZZUVBsQVdDelRUME1JNkhRMHVORkRPcUE5?=
 =?utf-8?B?YU9pSDRhbVRUVldzSmpscFpack51L1ZkZm82YjgwQTZLZzFyOTc5K25zZjRQ?=
 =?utf-8?B?aEdHSXhwZjg0bUh6L3FmbEIvVUpwSDRuRWNjM05iVnpoS3FnS2RGUERPUHZG?=
 =?utf-8?B?a1IwRVNTZWEwN0l0NlBxSnhjejN4RkRlY2NTT3dYZU8vbXVGQjlRejJJRlM2?=
 =?utf-8?B?c0lUMmVHb2c5OHBzM1NHNEs3RnlySERMSDJVc3NEdU5ZaDdwVkpnNjY1NlZI?=
 =?utf-8?B?SFNmQ3VPRVduMjkxMVpVTG9ubnBpcFZiUzdZRnRqaWlPOXZUYTA0YjZUMzJt?=
 =?utf-8?B?MFBmQWNXc2o3NGxKeUNoSDFONjRVRG9BV1h0L2UvTTNhanZSeGFBZDhDMXVr?=
 =?utf-8?B?NW8zTFMxRkRaclhmQWYwMjEzeHB5ZktpekdIUHFKSFFtSC9Ga3FOL1Y3UW01?=
 =?utf-8?B?eDZKdW0vNE5uaFI4MCtpQXc5VFNhU0pxUzdlb2kzNFZYTnpvTjB1NWNMOXNQ?=
 =?utf-8?B?a2Irbmd3YmtCN2xLb051RWlaUTJiOUdkR2lCVy9PM0FVUHlLaGovc2JlaGpJ?=
 =?utf-8?B?MGF1aCtmeGw5b3htbnZmMyt4NUtJbXhabW9CU3lLSVEvYmF1N1R1eVE4K2pv?=
 =?utf-8?B?dVVwZk84ZG15aEpZN2dHUVg4NitKV1JURWNBY0poU0g4M1hsdmJsVmZsZEhM?=
 =?utf-8?B?OVJiTnB5R016V3ZiWExyZHZvNzRueUVjT0dFR0sxRGhDUGJHVzUwblRZZkVI?=
 =?utf-8?B?bDNpcTdZY2xsV1MwVVJ4WUtmbi8wTWl5VkZxd1k4aDZLU01Nb1ErZlBaajBW?=
 =?utf-8?B?a1JPaVcyR2EzdVVaZHRObWVDR1dlN1JDNVlSNFdoRFdJTDhER2dYVkc1dUt4?=
 =?utf-8?B?ZnkyeTgrTmMrVmJlNis2WFgyc3UvL2hZUityd1hGdno1eU95Q3ZqUmd1UGZB?=
 =?utf-8?B?N0gwR1laMDN5VVZ0cDhKU1hPZzFKdWxyWVdUWlFGRWxJcDFqd3EyOTFjdndh?=
 =?utf-8?B?WHBiUldSTFdYQ2lMS2JUcHI1WjRSRGhWVEtwS01XSTJHT0t4Wjh1TGlmWVZr?=
 =?utf-8?B?Ris0c0RzT2F3MDR1L0ovOEdhc1ZxWGZyWm9RNkJCVHNLODI1RDdDU29NMDI1?=
 =?utf-8?B?c3NDbE1yTG1UbHhuL2IyM012ZzVkUXpmWFUwcEY1dDhoQWtXZHYwMW84Uysw?=
 =?utf-8?B?NXNvUHN0QUtvakU2YVVFeWRkeTRvWUIwYUhjRTZ0THlVS1FFZ1U1NkxkeXBs?=
 =?utf-8?B?aGRhTURWZmM4Y1NtdTYxRnpGWTFGcHU5RGlqUFVMNW5MckUyRFk3ZC9ub2Fu?=
 =?utf-8?B?ZE0rYnJHOWs3WU1zZmRud0ZoWTRueTd4SnJaZ2lhNFBKQ0JvRzlENmhRalZ6?=
 =?utf-8?B?UDZ2ZTUyN1pFeTVPS1dvTjJjT1ZqWjJvUTJCZ0lCS3ZxRUhqdDlKbU9FbXNQ?=
 =?utf-8?B?OG1DbGh0c000WnI1eDdndWZya2ZwMXdVL1RycnovcG4xbTZTZUc3clc2ZWhJ?=
 =?utf-8?B?bVQ2QTYxK1U5VzlMNDljZlAyQ2ZHYWlUR3M2NkRKR1p3Z3B5RktlQXZNZzg4?=
 =?utf-8?B?UzN6R0NxMEM0ckJxUDYvandwYkxyT3VSYXFpTDBqSEVKNzFWTWtHZjM5Skhs?=
 =?utf-8?Q?0gxdJi2ZW/J8YNfbwcvgkjl0LDlwe6CKN4E4Tq1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33dc6de1-1f36-4e56-00a6-08d95374efa6
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 16:13:15.4189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xf1F98CsVJABBJkgtaav3uPg0lbWCbwlcNe2Wxgzaa2ulclM7Zvl26CHfO3TEKAVw9xnuk9Dzp337rsutBlwHNcCbAkRQ3QdGanQj1e0/Ms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4365
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10061 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107300108
X-Proofpoint-ORIG-GUID: erLT-852GOPNAjhr-gpssDPueesof1c2
X-Proofpoint-GUID: erLT-852GOPNAjhr-gpssDPueesof1c2

On 7/15/21 8:48 PM, Dan Williams wrote:
> On Thu, Jul 15, 2021 at 5:52 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>> On 7/15/21 2:08 AM, Dan Williams wrote:
>>> On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>>>> +                                       unsigned long zone_idx, int nid,
>>>> +                                       struct dev_pagemap *pgmap,
>>>> +                                       unsigned long nr_pages)
>>>> +{
>>>> +       unsigned int order_align = order_base_2(nr_pages);
>>>> +       unsigned long i;
>>>> +
>>>> +       __SetPageHead(page);
>>>> +
>>>> +       for (i = 1; i < nr_pages; i++) {
>>>
>>> The switch of loop styles is jarring. I.e. the switch from
>>> memmap_init_zone_device() that is using pfn, end_pfn, and a local
>>> 'struct page *' variable to this helper using pfn + i and a mix of
>>> helpers (__init_zone_device_page,  prep_compound_tail) that have
>>> different expectations of head page + tail_idx and current page.
>>>
>>> I.e. this reads more obviously correct to me, but maybe I'm just in
>>> the wrong headspace:
>>>
>>>         for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
>>>                 struct page *page = pfn_to_page(pfn);
>>>
>>>                 __init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
>>>                 prep_compound_tail(head, pfn - head_pfn);
>>>
>> Personally -- and I am dubious given I have been staring at this code -- I find that what
>> I wrote a little better as it follows more what compound page initialization does. Like
>> it's easier for me to read that I am initializing a number of tail pages and a head page
>> (for a known geometry size).
>>
>> Additionally, it's unnecessary (and a tiny ineficient?) to keep doing pfn_to_page(pfn)
>> provided ZONE_DEVICE requires SPARSEMEM_VMEMMAP and so your page pointers are all
>> contiguous and so for any given PFN we can avoid having deref vmemmap vaddrs back and
>> forth. Which is the second reason I pass a page, and iterate over its tails based on a
>> head page pointer. But I was at too minds when writing this, so if the there's no added
>> inefficiency I can rewrite like the above.
> 
> I mainly just don't want 2 different styles between
> memmap_init_zone_device() and this helper. So if the argument is that
> "it's inefficient to use pfn_to_page() here" then why does the caller
> use pfn_to_page()? I won't argue too much for one way or the other,
> I'm still biased towards my rewrite, but whatever you pick just make
> the style consistent.
> 

Meanwhile, turns out my concerns didn't materialize. I am not seeing a
visible difference compared to old numbers. So I switched to the style
you suggested above.
