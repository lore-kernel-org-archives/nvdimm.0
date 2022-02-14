Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA227C
	for <nvdimm@lists.linux.dev>; Mon, 14 Feb 2022 10:57:44 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21E83hJt003911;
	Mon, 14 Feb 2022 10:55:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=3gUtJZThcGNizdm0rvNEyS1Mdz0dxeAuA1ZZd70c8ds=;
 b=nWxLtCPkOKalfMt7ey0NpOY2r2XlQp2zXWPy6nwScpanyr1nEt5EXe1k39BzFCa9fyE+
 JrvAK57IG7xPB5/MjtrPT9ocbcWX0xCNpJmxTyVAYJkGmcYGDQN3CsHy1mTXN7qgVzrv
 JHHVQmFeY+Hv5a0Wn9zaZ30TZObz5HdOw6u6Y5WEzGdpT2ctTstSRdgEC3UzdziLJK2Q
 Di45iRm+A1qakt1PG6mmvnDu8QPKYNgBY1DJHvATe+mqyFbi+CN2iZNqxyNF/T4TAzwN
 244Poub6VrDnGyltJdhQuVKZPv5wr7MnNTyvfj5b1uS/f/ovKmAfGrVY2Ox3rp1J8Dc1 QA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3e63ad4385-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Feb 2022 10:55:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21EAoOt3139519;
	Mon, 14 Feb 2022 10:55:24 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
	by aserp3030.oracle.com with ESMTP id 3e62xcwatx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Feb 2022 10:55:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SnlgJbYPLMcwd8v3JDZ7/U1ehyP/BKaAtGDnSFvQv21n9a7U7pHo5r4VXghWgFNrot/0oNMB0vacPWPiFekfyz96jkNiBiVFGIZrEt7TNbJy2Mt3D8Ep1f2OoobXoISW6XQnq6hWkI09GfakHu7C0fAWVEtJEzyMzCoRrUFOj55G+NXoA3ovEZqXBEuCmRH9zkmZkDyG4hYcj3iSO7ew+BhErduugaf29tfqi1TNpii0YhlG88m/UWsAR2JumSknTIzsQnYnzZ0ta9GpVc2wIXPbl3wQOvRFmKP2+bgo2dqxrnWVmemPWeb2jLjVGgQ/8f+Q2jXQ+Slepcva0TsWnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3gUtJZThcGNizdm0rvNEyS1Mdz0dxeAuA1ZZd70c8ds=;
 b=HVhdb5LZXf02fFzP57YdHAQqMmKa3cZEEbzM8Prec5yP0edK3qmiCLlNiiuE+xPW/MIlw2pspjRqEJbtH0/NAby9aa1QOfY3OJ/+ZsMa0XBDilt7O3KV019CteyVcuaH1uOX2WxuJRB4aBBaqqmRoAZXNIrKuhxJs5SIjk8DKE7R9yx+vkQEObetpXsRPfpe3q6qCec/0iRdQZehl3GcQ+eL+BsrOERipFhhm9m1H7PQ80fc+t7HF27OFnNhcoyxpdLLCKVss/3w9T0cb0fffavhjAmVRp52/KmmQ9L1gft7ZD1dbOCRncDM5/gU3AncqTmcMUwicuwk8USRC8eR6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3gUtJZThcGNizdm0rvNEyS1Mdz0dxeAuA1ZZd70c8ds=;
 b=i+CDX72v1l9537nAXfZv0iIW5j9L96xXF1y+LG8IoFbzLIGYDG4cJz+Nl+wZLSOOXJ66in605c057qN9o+lliraWtlIh3WrX9IzzeqjxIX6Qekg8KR/zRDjIMgjSPx9GvVR/yP/8s15+dmpzxHrTt6l4iVyoaDkV23eNG7GwQEU=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CY4PR1001MB2374.namprd10.prod.outlook.com (2603:10b6:910:42::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17; Mon, 14 Feb
 2022 10:55:22 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a%5]) with mapi id 15.20.4975.019; Mon, 14 Feb 2022
 10:55:22 +0000
Message-ID: <39700078-2b8c-3650-b31c-9e1be4ff216c@oracle.com>
Date: Mon, 14 Feb 2022 10:55:16 +0000
Subject: Re: [PATCH v5 4/5] mm/sparse-vmemmap: improve memory savings for
 compound devmaps
Content-Language: en-US
To: Muchun Song <songmuchun@bytedance.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Matthew Wilcox
 <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jane Chu <jane.chu@oracle.com>, Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        nvdimm@lists.linux.dev,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <20220210193345.23628-1-joao.m.martins@oracle.com>
 <20220210193345.23628-5-joao.m.martins@oracle.com>
 <CAMZfGtUEaFg=CGLRJomyumsZzcyn8O0JE1+De2Vd3a5remcH6w@mail.gmail.com>
 <d258c471-1291-e0c7-f1b3-a495b4d40bb9@oracle.com>
 <CAMZfGtWUHRRfowwPf1o-SycKZMDzMdeGdahaR2OEJZzLhLioNg@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <CAMZfGtWUHRRfowwPf1o-SycKZMDzMdeGdahaR2OEJZzLhLioNg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P265CA0005.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::10) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a9afa25-27e9-407a-e0aa-08d9efa87f79
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2374:EE_
X-Microsoft-Antispam-PRVS: 
	<CY4PR1001MB23746EEDA5F1667CA415AE0ABB339@CY4PR1001MB2374.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	7IiOz5hRAHFilH94CVCNX69aZBbPlfrdNY6c8gAQ8i7dQQHUf/LbQ5LF8DqmXcpt72rwPx4h855icuiGGKPZ6nd0m2FcsUQNN/mYoir9v4mrhYr8XGtBOczg0mGrmFvTzjxaR7VlNq4Ur8upui88w79F9qpXmUxAP8PBsF4hZmOKxmUQmU1aJdIPznU0YRIjeVPYqjOsEYlsz88hHftY9z/rB/fkN88tv/JALGbvoPeQ7q1/vETos9yi9wXUtqyaz+ZHNFPstLnnnle/4Licpul75JzTbVtN7bPOo+kz9xYpJTgM7R9cegrqcmbdVB7fKclYFqip3d4wznH/UnWUHTIAKWTrSpwvbpx4LgyPG2dAXejtvpqPGbWKIOg3H5xWPDWTApcuUzeb8cvjxGoVXkAy6QrciWBmq01e7DuYP6qx6ObChSmuuinalUDzCGjeMRWi2ukRnbLc/quPbMbm5ysfxbSsLBAa4I/XGIBj8Xt1+39FKwX3HlqVUM8Vswr5jeDx6oA/QWSaSW/uGWQKKsJ8gx0RDEsh2HtsWdFHswjspeOUgE1Xwp3QFwPXHCGbAd4UTqSn7gql0F50ts/hQcBLYq9oGWK5wgA9gor8wJNMLttNXWz98CSLYghwsHkKvhJoNELI9H5GF5Q8sQ4qh43hJJgy1JVSPhuITBkRb5IVEEz/G2Gb3rNHFoqQhi3e1+ncC6EMmeQZSI3njRV1tzgdcdw+c0+NhyeorAnFJoE=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31686004)(6512007)(6486002)(86362001)(66476007)(6506007)(8936002)(66556008)(4326008)(66946007)(8676002)(508600001)(31696002)(53546011)(54906003)(316002)(36756003)(2906002)(5660300002)(2616005)(6916009)(6666004)(26005)(7416002)(186003)(38100700002)(25903002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TFk5WEhBK3JXdHo4NmIyRE5MWHJEZjFyZGExWXBBTWI5YW5tdXhieTJnN1NM?=
 =?utf-8?B?STVhY1VjK3JYblV5NFNnMXgzazNBM0ZHU09aWUhxZUZJMi9tbTVWOEhQRlNK?=
 =?utf-8?B?YmVhNFZOSFlURHpKVUxqRHUzMFpMZjNoUFRFUzAyOGRpMThNWWgwSVlJNk9G?=
 =?utf-8?B?YWltYUhnK1VIR3dEcTFYd0J6cFRnSXpxMG1OM3BWM25rcSs2Si95dWllMHNl?=
 =?utf-8?B?eFV6bFpjbE1Cc0gyMEk3RHFIc2syd3Fic04vK1pTTVRIRzByRmpZS0tUVVVj?=
 =?utf-8?B?aUFYTlYyc1gvTjNMblRjUndleHJtMldGd3BobHRGMnUzNzFuVFF5cm1VSzh1?=
 =?utf-8?B?aTI0bkhZSU5uUER0dHIzc2IwbEtONmJESHI3b2pJS3lEQ05Sa2ViZnNlaVdq?=
 =?utf-8?B?V3NxdFlqTTJHd2FPVkRTMU42b0EzNFBxVllZcTZRWkI3M3F4RG0ydGZSMEUw?=
 =?utf-8?B?VnNVVEpzamhJbkJYMmE2QVFjbjJFaEdEeEV0d3RkMVM2dzZZcHFqUXYvZnpV?=
 =?utf-8?B?Z3VnK1NoS3FGYW01SmRiUm1wRWxXMlJjdkxqNUNpWG44OE9BU0lCdVhZQ3hz?=
 =?utf-8?B?d01ISnRSWEFLQ0xBLzUxbEN1c0J6WThNNERCZHluQUhOV3FoU0ZkdDV3UXVp?=
 =?utf-8?B?cHlzMHIvWk9LcGZlWkZIWmxzbmJNK2ZpRW91UjU3RUo1Qys5OWVuMytPQ20v?=
 =?utf-8?B?S1M3RE1ZOXpLS1ZSN05VdndpZG5kRVBzSG92MmxBcU5Ib1JpamVxWWhBUkxM?=
 =?utf-8?B?RmRPTmpCNVZQMC9Zd0ttbDRQVDcrRUpwcHYzSFFBb1pmVUFyUUllRnFGL1pY?=
 =?utf-8?B?Um5JZHpHVUhLVWFpZWpVK1Iydy92K013eWhGM1lvN0txR2JoZUNSZTNlZFps?=
 =?utf-8?B?aEM2SG5tOE0wSGhsQjc5aVA5Y1lhSFlzajAzcDVsRVdidkdJeHBaMEx2alZS?=
 =?utf-8?B?b01RaUNibXVZeUZ2ek1OM05lSTZ2VUVUam0xd1NNby9lZ3BMcGJibGhoVnF1?=
 =?utf-8?B?U044NjF1aUxVcjJaaDI5YWp2b0t2UVZRRkdPRmNxbnVXa3psZGZpZEZjZFhy?=
 =?utf-8?B?cHh2bmx4Vm1uL3prczEyb2duTjBnNG1JYmtJczRDbGRoOTFnOS8yb2VQVXJ0?=
 =?utf-8?B?UkpEcHFWTmpadE8wbEFsY1ZlVnNlUm0zTE9TbFI1ZFFsR3ZUNjNLSWFteGN4?=
 =?utf-8?B?T1NTTjZqMDNLcDZDOTg0ak0rKzlWTi9oODBjdnBjQzhnVlRzREM5MFJpVlNS?=
 =?utf-8?B?OEMySElZZEpKZDBYRTAxdHUzbUVIMjJucFQwNlI1aUZESi8ydlQ1dkxrdHhl?=
 =?utf-8?B?VjZvbDZERXEwanJ4SlZxRGZNZDBQZk9KTUNlQkhQUXgzeDQ4dEJRSEVjcnlw?=
 =?utf-8?B?dy9ydGt2clZsUWtPR0FwSXNCeUlCYmFGcmtqNVJCVnJMYi9MQkFTbVRiZytu?=
 =?utf-8?B?cVZaY3dkMjRMMS9Lc3hOUnZiT21IYlhLQU5CWWJWMytadFFQY1pENlVjUkVu?=
 =?utf-8?B?MHUzM2xRTFNIOG50eUVMYkErZHd0ZS8zbE9xVmhWVkhsdkE1Mm10MjVQK0JM?=
 =?utf-8?B?SnhhRFA3QnFENmZRQkkvaWNYY01MbDJnZ2lqM3ZiRTlicFR4QmlUOTBIbGlo?=
 =?utf-8?B?SzZaeC83VHh6U3Y3cXBjdUNmZ2w3K25SWGVqd2tGcjN3YnpzRURocVZTcVND?=
 =?utf-8?B?Y3F3RDNqbithT0crSmtaTEZYYWl5NmQ0NzJsZHhoc1EyemVzN0FQV3RiYjFQ?=
 =?utf-8?B?akFWWjF6cW9kSkRBWi80OWxIWW9pWVVIck8vcTJNZTF2UTNMNGg2SldWb3pJ?=
 =?utf-8?B?Y2ZYS1ZTekJJSEdnV1NreVZQNUxpSlZweSsrWHFxUUlHMzkrWXhWdUNaMVdV?=
 =?utf-8?B?aVgxMTBHN0hRZlIxNUc0TnQwYzZicmVkdFhLUFVLcTlTMnBNVnJLb0k1VTVT?=
 =?utf-8?B?T0E4b0ZuUHJVTlllOFJzMGhaazlZUXVOMlBURG9OdDZncmNpbWtQTDRWOUxx?=
 =?utf-8?B?NnNtbnV1c1VnRXlVaTgrLzFPNDN6QXJLemlHdm9SWVFpNzhCSThocHlIb0hO?=
 =?utf-8?B?djN0ejZiZTZEN2RGOTdQZlgvZmk0TXJZT0xnOVRGNGNMQUhFaWNLUFB0eEZt?=
 =?utf-8?B?TVFpTkx6ZE1NSG1jSndPdlAxck9zc0Q3MmVRMlVHbFZzYUc1WHhJQ1NlWlNH?=
 =?utf-8?B?Y09hK25jQ2oyNWNlWXJETWQ0OWQ1MTFwUkt0TTNXVzhGQzhPWnNJY2VjSVR3?=
 =?utf-8?B?YmFVZGNiTFAzWVIxOGJndjl2c1l3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a9afa25-27e9-407a-e0aa-08d9efa87f79
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 10:55:22.5935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QXyS/Q7Xqo8V+Qud6lhC57tfVZggGY5Id3TRG8EDV8RFWuuHxdMkG0jL60zj70iRoeHGHwYAjzSbIU0CeltFfQKHuON6NjcLJXAhCOclJ94=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2374
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10257 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=980 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202140066
X-Proofpoint-GUID: c_15_KpnzZ9ZsVWE1v2ptEIF-CvS6zgX
X-Proofpoint-ORIG-GUID: c_15_KpnzZ9ZsVWE1v2ptEIF-CvS6zgX

On 2/12/22 10:08, Muchun Song wrote:
> On Fri, Feb 11, 2022 at 8:37 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>> On 2/11/22 07:54, Muchun Song wrote:
>>> On Fri, Feb 11, 2022 at 3:34 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>>>> @@ -609,7 +624,8 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
>>>>  }
>>>>
>>>>  static int __meminit vmemmap_populate_address(unsigned long addr, int node,
>>>> -                                             struct vmem_altmap *altmap)
>>>> +                                             struct vmem_altmap *altmap,
>>>> +                                             struct page *reuse, struct page **page)
>>>
>>> We can remove the last argument (struct page **page) if we change
>>> the return type to "pte_t *".  More simple, don't you think?
>>
>> Hmmm, perhaps it is simpler, specially provided the only error code is ENOMEM.
>>
>> Albeit perhaps what we want is a `struct page *` rather than a pte.
> 
> The caller can extract `struct page` from a pte.
> 

Yeap, we do that here already. Anyway, I can try switching to the style you suggest
and see how it looks.
