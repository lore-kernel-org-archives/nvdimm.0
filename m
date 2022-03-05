Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FF07C
	for <nvdimm@lists.linux.dev>; Sat,  5 Mar 2022 14:22:01 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 225A9XKc028756;
	Sat, 5 Mar 2022 14:21:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=obcA9Hnhd0/RSdtGQdv1XG4XUFQd7WTPMaJJ+2PbAvE=;
 b=OZpM5BIPjpuqhPfOGlwVHvzJjZOTwSAIuz1gvcEL4KB/BkubHavDKKf/mJWs16JPbo4w
 z98vVgxmxA5opSoMW6okS2u/M+GIbQjSK0CMmjX6rP8p6uVH6Od/lepqBX21IjSBRLUG
 2cjxehHfAYPOTSYYkT1qAon8NbPFxmyyFLCO1BtfTJ56HsLqII4hV1aEQBvqTVuBa6rF
 E2JL4IOAPSdqmZJ1AYJTIcMc7YkwzxYjQL+OBAIV3HSsYT5iTd2T4pQcrCB5jyHlZhng
 64tP9j5KP0f2Wdj2bg3YrQOFEi1PMbuDwYH4K/2LsysVpE12XEHt0ZgcizcO7y4geBjx RQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ekyfs8qcw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 05 Mar 2022 14:21:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 225EBNmi032911;
	Sat, 5 Mar 2022 14:21:33 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
	by aserp3020.oracle.com with ESMTP id 3ekynysap1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 05 Mar 2022 14:21:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B2PJ0BZKHKdqsBi5fngo9yEU+Q8PdlvcrqTYbsz8M9Ih1MgRWfIKDhQ8D+NLkiDUyG8jDbaBJO4iyH6QXA4x9huCXJhNhpsLz5/mCb4zTZ9b9TwTlzVJPvQFAIrasDak5WFsjgBcJkC0Nb6yfpGHYhRQg49pQ67E5kWsjkr+sNkmQR3KCjXPlqKc1PV5hIk68xtr3GOA1ouKiC3Xh/prCjuYdqBGnizliK3R1t7c0I3ByNY0siQmTLTnAF921iSo5Taye/K/tKtWl27RydugCUZo1Erz2omsl/ckuIgjwOxZwV3UKSXl7t6rXK9tAW4cJslgVr4SlW6T9ldAWaEhhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=obcA9Hnhd0/RSdtGQdv1XG4XUFQd7WTPMaJJ+2PbAvE=;
 b=M5yNe32lpu6CgmWuLuF9mu0vDdMY53B+chR2oxFKMB6NfUlaqQzrd81KgzC0ozUTyLsMQqksI+TqJkLnV8AmU4t+4rzezQUQC9R5Z6lGMul+st6o/KfI7lzGosRuNO8iQL8UZnkEGyRfvJsmmkIyNljjkzaYj57Sgzps+KQug93F0LfuvlsBelQ45V/B6Cnz/pJel/cwA65OEEgYfL/p0XylrG+VqArPzMA73EQXzdBQ/otM4jpBLrXHStuTmJK04DSDtEWF8Zv+vaDeoBwm2As/BE2fh3ZLMufjp1XwpEJgt+IZN1xDhbU6vYFqMECO9E812tzyWRRXysn/VOv+Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=obcA9Hnhd0/RSdtGQdv1XG4XUFQd7WTPMaJJ+2PbAvE=;
 b=EFomkiOGT9guE83slV5EAoLdF84j0g438OmHk1v8sN9DoSOEGCuF2qxzEv2RWg2Vue8LFQ5Tu9PVpA3QkpEWI+jwaj2nlGLXCFgt4nt4MRt7xqgyVWO6L0wMwjX45y+dVZMI+e7C9laR1W1je1fl1167Hg7Dm9WNQvMVYOE9KPI=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM5PR1001MB2377.namprd10.prod.outlook.com (2603:10b6:4:36::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.18; Sat, 5 Mar
 2022 14:21:31 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%5]) with mapi id 15.20.5038.023; Sat, 5 Mar 2022
 14:21:30 +0000
Message-ID: <9928f476-baa7-68b8-ed82-2b37d48a10a6@oracle.com>
Date: Sat, 5 Mar 2022 14:21:22 +0000
Subject: Re: [PATCH v7 3/5] mm/hugetlb_vmemmap: move comment block to
 Documentation/vm
Content-Language: en-US
To: Jonathan Corbet <corbet@lwn.net>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Matthew Wilcox
 <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, nvdimm@lists.linux.dev,
        linux-doc@vger.kernel.org, linux-mm@kvack.org
References: <20220303213252.28593-1-joao.m.martins@oracle.com>
 <20220303213252.28593-4-joao.m.martins@oracle.com>
 <87r17hhhfr.fsf@meer.lwn.net>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <87r17hhhfr.fsf@meer.lwn.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0125.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::22) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37f849fc-0837-49a1-b727-08d9feb37166
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2377:EE_
X-Microsoft-Antispam-PRVS: 
	<DM5PR1001MB237716A8B45FC78CC41AC4A7BB069@DM5PR1001MB2377.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	cQM99lHGTZ2SMhrdHtf+vYVoVzPNHoMmFsOqjvf7XR7GOItY1azQ6/nGg86iN0Od18ynHLF+FP78tMrEI6AlO9ECoStcTxuqW3+qSa/NKe1AHQCvq2FzH9OHTrWFD9HtbkdIpBVlfd1L2Y1OvRAwtnIG4l7ZYollqORzvPmeERpLfXtSjT+sDWBAZN/C93f8/u2WwDcSzKodLs3QM1Wymtn8pBsJUOWExjO6rzjqVkBEQvmZgxXqoY6otoXHh4LkjRjWtGsa3sxj3SqhEBg9Vp+TuIIFsHsHt8iqY2TcQBZ0TaXufYQLXZaOCo+QJcIid1NOL2PfsDJM/31Ez/42wffcW/25oixFpfDn474BKYSKNTVolZcnAUHzNx5LN5rxZbIW68YpBTVoumpJ6AY3XDrGQ3GrNOX5t/2eBVjuLmpPaJWtskczAzOz0w8bo5kg0evrvvX1/84xoxHYn3QcSagoBsX9v9pDvDIJ2zTua72Is+HCavju5ydunoSx0Nf0jlWIibNuZRyAyjf7Uv7krJKmeV2mZDcc52I2z6Wwo4BPzKLvHXxlbmROvK882cDRs41K5oAzW4j5EndFRxM3EqgBs6/1/VSSghC+IuVI1wkSFGUTN4SpqmaOnZoz4gYZFkhDNVNrVOHVqgknyyTRPu0pe8c+crExwpkbBtHMxXViW7vY6a99gbGpWne5mDTz2/uEvW8RqzLkI+VmO6zMAQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(6486002)(2616005)(186003)(8936002)(36756003)(7416002)(31686004)(53546011)(2906002)(54906003)(6916009)(316002)(38100700002)(66476007)(66556008)(5660300002)(8676002)(66946007)(4326008)(31696002)(86362001)(83380400001)(508600001)(6506007)(6512007)(6666004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TXpRNmhMQ1ZwY2RkK2x5aWJCWldhR1ROM0VzTXc4aDZwbTRSR1dhY3d5V1pr?=
 =?utf-8?B?djB5OHBWdlZKUnp6RHBWVitJZ1ZMMUV6blFoMHBPRG1vdkhTTzAxVXdZbzRn?=
 =?utf-8?B?WkVkS1E5MEY4ZjRtV0lMam92YklrcTZXTC9TakdlbktxZFpudmUwWFpkUDA2?=
 =?utf-8?B?Ym5HVXZNZHV1V1J5QlJOOWVoV05Udm1CUkwxd0VQd1pyUzZZQ2RDR3E1Sld1?=
 =?utf-8?B?VXgzMVlOdVRzV3dQNXZkelJLeklSWGJPSXROb0UxKzF4c0pSdm5Nc1FSL0hN?=
 =?utf-8?B?TzROWGVHT3FQdUFhcXBMMlBDVkhGSjFwMFFUZmNOSVFpNXVBOUtRY1VRQWRy?=
 =?utf-8?B?Q2FDc2VTQmQ3RTdBaC9IM2ZYcCtRT2lBOTZ2bjZyYTRMTDlpaEJJdkg4MHh4?=
 =?utf-8?B?WndhUCt3UjFBSmdlOVNUZEVaQVFyYnZ6UlM1OXgwb3hiOU1EaGNrZGFNOUE2?=
 =?utf-8?B?Q3R6NjVQVVI2SGN1eSsrZ2Mrb3BSaGF1NHdlUGR0Tk9oTHpUS3EzMmdmQXZp?=
 =?utf-8?B?dHFvUHhIKzdhamgrWmRic0VlN0lLTnk4Nnp4aHZ1bHlxaHFWSHRmZUdBZmg4?=
 =?utf-8?B?NUFEdFVtc3h5ODhJc1lEeUdvNVIrdHZLY2J0RUV3VXc4V1E3SVVRblpEMmZh?=
 =?utf-8?B?WldFUy9JbnovUWoxd0FpNGJyVmJpZTJBRlo2Z0Iwek5WMFJMZW9kcUw2b0Vp?=
 =?utf-8?B?RUtzQmxMRHlWaDBIb09UZGFLRFo1djU1aE0xOVdnNFBUVDM5RHZsWDdpSE9L?=
 =?utf-8?B?RlJSQkdWalpEMWVoYXdsYWIrNzdBMjJxMWJPQ3ZRTmVpdC9CdmphTGM0VHFS?=
 =?utf-8?B?TldibVNaQnRyVzF0bEhxcjd2dkcxU2licm55V3pXaDE5TnNaVUJ1UUc3SitZ?=
 =?utf-8?B?a084TFM1NmIxOGE2N1VadmVqalgxeGFYUmJXLzA3OU0zNnpsSHg4NFJEVkZE?=
 =?utf-8?B?QWUxcmlQTGlKNmlhV3UyWWJsUDNNWjdYVTVOcGg1cjVoSVNzSG4reThXckM4?=
 =?utf-8?B?Q29EZmJweTNMVmI3VjZsWVF6UEZCMEFWY0hjUEI3RXpQb1pUdlBJeTROVWxZ?=
 =?utf-8?B?VkJicVliNGx4a0hzYnQxQU9BY3hoU0plQ1JxTUMzQkk0SlJlOEJ0ZmhJZElq?=
 =?utf-8?B?bzcxUURBRHFnWkVmYjRhMTlMbXlMTmIwSllNbmhzUTFVQU82ZmFCRzBEQ1Bi?=
 =?utf-8?B?UURQc0JtU0I1QUltd3NiclBPRUxOWkp0QW5Xb2k0bys3Wm83YXZyWFNTcjNS?=
 =?utf-8?B?QW1RblZSdms3T2ppUUpIYU9ES0FKYW1RZmNqbS9JWktZZ1RsaytWUnovMjZC?=
 =?utf-8?B?UjFvT3hNNmFYV09EclRHc20wdWZrbGVuQXdaWWRnNXc3cmg5UkdHNENCdngx?=
 =?utf-8?B?b1RTVjc0RjR1d0JKckc5ZkdZa09vbVUwK3BTeEZjRWUyNkViSFJjMnNUeGZo?=
 =?utf-8?B?eFluOVU2aGxQalZhT1VpS2dqT3EveFpEY0ViSlJDZkhhWnRDYlR4NlNFQ0My?=
 =?utf-8?B?cXJ3MUtvVWhaOC83bjkvQmo3VlUraEFubWUzZU8yemxHaGk3TmpXQzNiNlF1?=
 =?utf-8?B?aUlOckk3aHo2bG4vMGU1WkZ3d3RLSDBCVGthNTVlNWozMkxqR3I4Q0dGQy80?=
 =?utf-8?B?alJWeGd2NU9sWmMwWlpMNDBNa0hiOVkzakdMayswdFZsUk1qZGtPOHNxL3c3?=
 =?utf-8?B?Q2JIM2t3d1lRdmh6cXNRMEdXVjVzQ2o3TGZhZHJvb2pQYituTGdLMGV0d0Vo?=
 =?utf-8?B?Y3ZTTTB1enV3bndUZFBZTFlKMWxQdmdDN2pjWjQ4UUhLUjAvNkN6cjcyS2NW?=
 =?utf-8?B?VWhocWx5UkRnbGZkaEgxODVqWWowc1RuRDgyeHFiSlRRRG9rYjRmMkFCQXlZ?=
 =?utf-8?B?SlZ0V0NQdlBWdkZXa3NxdE5ZV0VKcG4vRGJ3Ump6R2JzazFkY01lYnRlbVpi?=
 =?utf-8?B?Rmd4NFg4aDFqMUxtaFFCR3dCZW9LTnpwMndnWGdDbTFBdno2WmM1emRZWnUv?=
 =?utf-8?B?RWNFbExvZmJHS1ovSkVZRmZZOWhPcGpkUktrTlFtZkppb1laTFRsb2h4b0x0?=
 =?utf-8?B?Z25nODUxYUxJdE81alh3S1cvNk94Z2JJS1Zkb0dMTmpXdzdsL1hWSG5Hdk0r?=
 =?utf-8?B?OGpOZ1NpTmxmYTlYcElHQkFaeW4xWXBUeVlJUjZkM2drQWRBa3M3N1puMWJW?=
 =?utf-8?B?N0hIb2VXVGFpTlJ5MnRXbTdLNmp0amRzU2IvQy9UV3dNWENLRjc4UzdsUTRP?=
 =?utf-8?B?YVhlem9neTV5amJ0NFp1ZWJxWUZ3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37f849fc-0837-49a1-b727-08d9feb37166
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 14:21:30.8230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2pslZW7q6nYTfBoDMtrYIFMp//khBV7oqgLZ5tpn1ryUtIubQZapm5DRNinF/0RSsfy4eoQ1Vq51qomkPFraVpZuVhdfNyjSOViYSijs4Mw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2377
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10276 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203050081
X-Proofpoint-GUID: Dcet6Ctfzl2pSeAe9ZqaRaY9V3lhlOa6
X-Proofpoint-ORIG-GUID: Dcet6Ctfzl2pSeAe9ZqaRaY9V3lhlOa6

On 3/4/22 15:21, Jonathan Corbet wrote:
> Joao Martins <joao.m.martins@oracle.com> writes:
> 
>> In preparation for device-dax for using hugetlbfs compound page tail
>> deduplication technique, move the comment block explanation into a
>> common place in Documentation/vm.
>>
>> Cc: Muchun Song <songmuchun@bytedance.com>
>> Cc: Mike Kravetz <mike.kravetz@oracle.com>
>> Suggested-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> Reviewed-by: Muchun Song <songmuchun@bytedance.com>
>> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  Documentation/vm/index.rst         |   1 +
>>  Documentation/vm/vmemmap_dedup.rst | 175 +++++++++++++++++++++++++++++
>>  mm/hugetlb_vmemmap.c               | 168 +--------------------------
>>  3 files changed, 177 insertions(+), 167 deletions(-)
>>  create mode 100644 Documentation/vm/vmemmap_dedup.rst
> 
> Thanks for remembering to add this to the index.rst file!  That said, I
> get the impression you didn't actually build the docs afterward and look
> at the result; there are a number of things here that won't render the
> way you might like.
> 
Had some environment struggles to render the end result. I had no errors, though,
only two warnings on the diagrams part. I've this properly now and I see the
rendering issues you mention.

>> diff --git a/Documentation/vm/vmemmap_dedup.rst b/Documentation/vm/vmemmap_dedup.rst
>> new file mode 100644
>> index 000000000000..8143b2ce414d
>> --- /dev/null
>> +++ b/Documentation/vm/vmemmap_dedup.rst
>> @@ -0,0 +1,175 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +
>> +.. _vmemmap_dedup:
> 
> This label isn't needed, I'd take it out.
> 
I've removed it.

>> +==================================
>> +Free some vmemmap pages of HugeTLB
>> +==================================
>> +
>> +The struct page structures (page structs) are used to describe a physical
>> +page frame. By default, there is a one-to-one mapping from a page frame to
>> +it's corresponding page struct.
>> +
>> +HugeTLB pages consist of multiple base page size pages and is supported by
>> +many architectures. See hugetlbpage.rst in the Documentation directory for

While at it, I'll replace hugetlbpage.rst in the Documentation directory to be:

See :ref:`Documentation/vm/hugetlbpage.rst <hugetlbpage>` for more details.

>> +When the system boot up, every HugeTLB page has more than one struct page
>> +structs which size is (unit: pages):
>> +
>> +   struct_size = HugeTLB_Size / PAGE_SIZE * sizeof(struct page) / PAGE_SIZE
> 
> This, for example, needs to be in a literal block or you won't get what
> you expect; that's true of all of the code samples and ascii-art
> sections.  Easiest way to do that is to end the preceding text line with
> :: instead of :

I've added :: prior to code blocks, and also had some issues with the page table
diagrams in this patch and (the one after this). I also added '::' for the diagrams
to be able to render it properly.

I'll respin with the proper docs fixed. Below what I have staged for this patch.

diff --git a/Documentation/vm/vmemmap_dedup.rst b/Documentation/vm/vmemmap_dedup.rst
index de958bbbf78c..aad48ab713c1 100644
--- a/Documentation/vm/vmemmap_dedup.rst
+++ b/Documentation/vm/vmemmap_dedup.rst
@@ -1,7 +1,5 @@
 .. SPDX-License-Identifier: GPL-2.0

-.. _vmemmap_dedup:
-
 =========================================
 A vmemmap diet for HugeTLB and Device DAX
 =========================================
@@ -13,12 +11,13 @@ The struct page structures (page structs) are used to describe a physical
 page frame. By default, there is a one-to-one mapping from a page frame to
 it's corresponding page struct.

-HugeTLB pages consist of multiple base page size pages and is supported by
-many architectures. See hugetlbpage.rst in the Documentation directory for
-more details. On the x86-64 architecture, HugeTLB pages of size 2MB and 1GB
-are currently supported. Since the base page size on x86 is 4KB, a 2MB
-HugeTLB page consists of 512 base pages and a 1GB HugeTLB page consists of
-4096 base pages. For each base page, there is a corresponding page struct.
+HugeTLB pages consist of multiple base page size pages and is supported by many
+architectures. See :ref:`Documentation/admin-guide/mm/hugetlbpage.rst
+<hugetlbpage>` for more details. On the x86-64 architecture, HugeTLB pages of
+size 2MB and 1GB are currently supported. Since the base page size on x86 is
+4KB, a 2MB HugeTLB page consists of 512 base pages and a 1GB HugeTLB page
+consists of 4096 base pages. For each base page, there is a corresponding page
+struct.

 Within the HugeTLB subsystem, only the first 4 page structs are used to
 contain unique information about a HugeTLB page. __NR_USED_SUBPAGE provides
@@ -47,24 +46,24 @@ page.
 +--------------+-----------+-----------+-----------+-----------+-----------+

 When the system boot up, every HugeTLB page has more than one struct page
-structs which size is (unit: pages):
+structs which size is (unit: pages)::

    struct_size = HugeTLB_Size / PAGE_SIZE * sizeof(struct page) / PAGE_SIZE

 Where HugeTLB_Size is the size of the HugeTLB page. We know that the size
 of the HugeTLB page is always n times PAGE_SIZE. So we can get the following
-relationship.
+relationship::

    HugeTLB_Size = n * PAGE_SIZE

-Then,
+Then::

    struct_size = n * PAGE_SIZE / PAGE_SIZE * sizeof(struct page) / PAGE_SIZE
                = n * sizeof(struct page) / PAGE_SIZE

 We can use huge mapping at the pud/pmd level for the HugeTLB page.

-For the HugeTLB page of the pmd level mapping, then
+For the HugeTLB page of the pmd level mapping, then::

    struct_size = n * sizeof(struct page) / PAGE_SIZE
                = PAGE_SIZE / sizeof(pte_t) * sizeof(struct page) / PAGE_SIZE
@@ -82,7 +81,7 @@ x86-64 and arm64). So if we use pmd level mapping for a HugeTLB page, the
 size of struct page structs of it is 8 page frames which size depends on the
 size of the base page.

-For the HugeTLB page of the pud level mapping, then
+For the HugeTLB page of the pud level mapping, then::

    struct_size = PAGE_SIZE / sizeof(pmd_t) * struct_size(pmd)
                = PAGE_SIZE / 8 * 8 (pages)
@@ -98,7 +97,7 @@ Next, we take the pmd level mapping of the HugeTLB page as an example to
 show the internal implementation of this optimization. There are 8 pages
 struct page structs associated with a HugeTLB page which is pmd mapped.

-Here is how things look before optimization.
+Here is how things look before optimization::

     HugeTLB                  struct pages(8 pages)         page frame(8 pages)
  +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
@@ -131,7 +130,7 @@ Therefore, we can remap pages 1 to 7 to page 0. Only 1 page of page
structs
 will be used for each HugeTLB page. This will allow us to free the remaining
 7 pages to the buddy allocator.

-Here is how things look after remapping.
+Here is how things look after remapping::

     HugeTLB                  struct pages(8 pages)         page frame(8 pages)
  +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
