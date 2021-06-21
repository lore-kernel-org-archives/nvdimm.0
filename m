Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8522A71
	for <nvdimm@lists.linux.dev>; Mon, 21 Jun 2021 13:43:46 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15LDbNhC014758;
	Mon, 21 Jun 2021 13:43:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=lRf18/vVl9ITuqA65VA/AvkgNsD/p/9UAnWGq2RbiaM=;
 b=vCWoJLnIbCM+nmUFDoFv2oDBWZcOh+zYyx26DCitNvXngTOb+ALqvv+NugYbV6HAt01x
 qNrxeVyIrHkXbyyj2KYYpo1v9X04DVBK9W8P8/BmJAQtoVtWLUujNDao7/pH6P1tCfbX
 OS4uBOqQTG5ScudcFopZQCvOmmpwEFrJRZwqNQIKMZDk45+GiFMEB89T/rVrjlevNNy7
 uw4pgffDsk7qLxoXwEeUTnbvw9hGTBuEfhlkL1wT+VInb8Fcf9m1kIWuB++8LeSg+E7s
 MVqG5DEwQYz3+YqgdSt6eQ7cK6uTb4aY6uIO5Qc/6vpBKugft9stzbLo45O1gS5XMYGP Qg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 39ap66gsnb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Jun 2021 13:43:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15LDZaib116520;
	Mon, 21 Jun 2021 13:43:10 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
	by aserp3030.oracle.com with ESMTP id 3996mbxt1p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Jun 2021 13:43:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kKt+XDZP7QUQ4jL7Y3coMk1ZZc2C1/yi7i1NiJ1NsdS2fgBBXu0LMLKyNSyCQa9E8mIwquIIAt9AnoXZ0uT2RmU0EZL9OOOXvo98aSBPrmUly0UD/b++i/IiWHEkk/sihGcH67Gxe+YdCWhJ6Ir3Nl+fx48KrJC/gvFJCgDQlqQTVSxBK2XXJptE82U0X23Ba295RMJECSiV7K3i6Pwdq7UEYthO+6gBVK2nlKw6qe5ZG2LBpWtJZ8PJ/rsqLef94EDjWec3wkoa4rxsUJ4o6It8aen0P7SBkdbJx10SIz1MD7levuFOoni5NU8KAmpSVM9xGLJoedpFEaAXRqvHNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lRf18/vVl9ITuqA65VA/AvkgNsD/p/9UAnWGq2RbiaM=;
 b=O56qPzMHG2dYFdgan4csJStiR8tNobNzmi0kTRQbizm/FYIH7je+Vj7ZzDbCrbh1TgaV8CGR1HHYPhgLCgz1UqOYgJE6xcIqYmPLJOPBzgzQlLLOohNFXjBknI5IaktE3zUwlIgy8iZ/+Kv+xG5rriMP9pjE39/O+i4ZFobbCjN6+s1+Df2bBwo7qx9AaH/RgwUf8XPANiW2HfBvqKBGr2cD9hZf+0FCJqWKm4kncorXIIvjIyU2OijOG6mQvyC9A606yrdmCUPqizLQUHuQc/pdY5sd55smhBTFg+nDuoAK+QyuMLRryMgM8G8WM4en2U7OGdEJN15o2ujmpbA2jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lRf18/vVl9ITuqA65VA/AvkgNsD/p/9UAnWGq2RbiaM=;
 b=kVZzJQ+5R7MjT6Mb/im7Z9Qomk3L4M/RizOFg9YgovZjPyRFGLfHdJByns/YPUj4UfJdI6xbus/nWO0wH6KUczNDldeXw/8ciuTAfjlnY+4KOATXUOFLD0G6XpXO7i4Ls+o8FSWLo+HHAvX93yLxcZSj7z66qsylyg5twRzUuZM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4285.namprd10.prod.outlook.com (2603:10b6:208:198::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18; Mon, 21 Jun
 2021 13:43:07 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582%7]) with mapi id 15.20.4242.023; Mon, 21 Jun 2021
 13:43:07 +0000
Subject: Re: [External] [PATCH v2 07/14] mm/hugetlb_vmemmap: move comment
 block to Documentation/vm
To: Muchun Song <songmuchun@bytedance.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, nvdimm@lists.linux.dev,
        linux-doc@vger.kernel.org
References: <20210617184507.3662-1-joao.m.martins@oracle.com>
 <20210617184507.3662-8-joao.m.martins@oracle.com>
 <CAMZfGtXSJE2ZsSOBW7Ef0VtP=+Q=cULSw9urqZGSG_WbGTiaSA@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <7f7313c6-f101-1726-f049-61091567f9c3@oracle.com>
Date: Mon, 21 Jun 2021 14:42:57 +0100
In-Reply-To: <CAMZfGtXSJE2ZsSOBW7Ef0VtP=+Q=cULSw9urqZGSG_WbGTiaSA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [94.61.1.144]
X-ClientProxiedBy: LO2P265CA0238.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::34) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO2P265CA0238.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:b::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Mon, 21 Jun 2021 13:43:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a1cf902-fae0-4bec-d179-08d934ba8011
X-MS-TrafficTypeDiagnostic: MN2PR10MB4285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB4285319D62C17D44839AE095BB0A9@MN2PR10MB4285.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	hy+k+fecwHEx9UQqI05sAkQbUXgAQ+VrJwcwlCh9zxqdMKoWalRhBhLmfppmc38L/tXl8xumdArJWm+kOg9oRnBAPP5w+iu9czHrrnc90pBbDvb2yUeH9EiRphh8Nbp1jj5XREIlUqwJtEVv1Zj2Q7NpJmHPmmK06ugy3katJii57Bzn7EIBEBoIOsM0iifFUJlaP3EF26LVqaqbAlfkf5ksB4SNzti4LFkHaaVTw7oV6ngga66TMvAqtGVrFHRu+b3LkDms5hrqEDLyjJHcReBB6HRtisEXnbo5xemFYyYoB90vFpD9DiwFT5BF1oOGo1B5voHEG+M1N5S7og8gXci0dtJwQjJGQFsOV3VS+uBxFKqUZ5HoPMK4FCcs3Q2XgD2ymCKORDDphhF8VVd2aDycRcfCv3FFSengKA9y2mRfP8BDs8an3ij5g4HZtAEhpfrf8KPiWTPuslVItM2X6AJjvb9qlEyjyyMBzNQu8AzoB3kZx8toq+tE7EktSCHbUoj+m5jLpn6Qbn69JPbNVnmCGc8viAA96Sq60mL3dVTS3WMtEIpFu19EWTpLyczVAhd45YvncxQZmJS0MBy6TH/tTM9X9Aowx1B1L2ExGrDutOA+5TXHdg/LZgTwTGbwlILAXA+eNx6/ogtIyQZUIw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39860400002)(136003)(376002)(346002)(186003)(16526019)(86362001)(83380400001)(31686004)(30864003)(8676002)(38100700002)(4326008)(6486002)(7416002)(36756003)(8936002)(26005)(956004)(316002)(2906002)(2616005)(16576012)(66476007)(66556008)(6666004)(54906003)(478600001)(53546011)(31696002)(5660300002)(6916009)(66946007)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?aDBPZXR0VXVpNTVHWVBPeEprdTVYdlYzRjkvenAyUTRHT1l0V25HOHdPWVhT?=
 =?utf-8?B?TTdyWThjQnNHYVRKVEIvb0EzYmF3cngxOVNIQTFLN0lHU0xGNE9pR2M3YWlp?=
 =?utf-8?B?R0NNUmVQek1sVVY0anV3WXhjQi9QN2kxbzFERjVLZTVqZFJDRUFYb0xLQ2oz?=
 =?utf-8?B?OThUQVZDNVhwbFE3V1A3UVFBSDI1MkZtWE9LalZxYWlDeU53bEZraDA0QUFM?=
 =?utf-8?B?TzRnNGsyVnh1b3E0QS9SL3lhTzFmU3lHRnl0bEhxZ3dUUmNlbWlPc081NHkx?=
 =?utf-8?B?V0svdjlXRHZ0V2d3Tk15VFJXYjF4MnB0dW44bGlWVVJ2c29rNTdCblN0WUFh?=
 =?utf-8?B?R1BZbmVzVGVSYktVS2luSVhVaVF3NzZpeFhncWhobGI5alhabU4rZ0tBelRp?=
 =?utf-8?B?aWw3WVRWeFYyNG5BRXVVbjdTR3hlODNTeUdDSWduNWRnMUpiZ21URDllcjNY?=
 =?utf-8?B?UmVXSitBT0ZKcDAzaHZEcDJyTzNMd3JwK0l5OEtKaldCMFNhNjF6M1hva09u?=
 =?utf-8?B?UjdmZHBkRkFpaTZ0RTBUYm54RWF2UnV5M2dSVSt4TXVndXRJeFhSSnNHME9F?=
 =?utf-8?B?VmJ5ck94eE4xS2VmWGRjbGJZaUVmQkRnaWpqUW1LYUV2aiszOEpTUG9PMVUy?=
 =?utf-8?B?WFNVcTVJOVJRa3J3WnRzWDl0QzQvd0FPbXVzNzd2VmVMeDFXZk9ReDZRRjVo?=
 =?utf-8?B?eUVnbVZvTzVVMlpveEczNmVXRnZDa21oTzQ1bUllck4yc2JZSWxrOHRqM0RS?=
 =?utf-8?B?YjRYZTdNYi8vR3ZZNXZBZE5GSmJLUlpXTmE1a3ZBZXUzZ1UwZVgrbFh5VVRZ?=
 =?utf-8?B?Rks2eUdKK2NEangvaUhHY2lxTlNzYVZSTmpDdzVWOUM3MW5xZFovWmxEQkpH?=
 =?utf-8?B?Q1FDdXRBdy9zMUhYNTY4ZS9OWEVFdWhFZ0hlR3NudG9tbmp5SzF6bXlpMFFm?=
 =?utf-8?B?K2FEQ3dNTWxSMlc2YmI0dkRWVStpTTZxUFI3QWZzdW53QjNVbCtYK1NNVFpY?=
 =?utf-8?B?WUliaEQrdk84WUpmdWRtcERucVlMNjlUWFp4aHhLaUFGQ2pMOTg3eGdleFdL?=
 =?utf-8?B?azJJRHhvNUlCSTdGOVpsZG5CaC9PWHFybHh2RkIvd1hGbW1nUHNCYktFbHBh?=
 =?utf-8?B?RGtIb1NjOFlNcjV1SVhRMS9Zek9ha2xveFRSbFdBWmgvenpIeFR0VGhZWXB5?=
 =?utf-8?B?b3FKMkJrdFNnNnBGeHhXZnF1d1F5VHhVQ25GSUhiM285SEN5bnN6REU3YTlQ?=
 =?utf-8?B?ZWNrcm5jbWt3MFVkbW4yOFB5NzI2ejdtVlJ5Yk1sSFozSC9IczVkamtwMWdm?=
 =?utf-8?B?L25LOEgxbjZwblpSL1VaNUNEYk42bDE4bllwVUQ4M2g1ZzkvUlNmanEwa3lw?=
 =?utf-8?B?TW1HSVkvSjdiUnhTUFBwcHE1aEhWMHlMejRpLytiaWkrS0xjeEVUY054ekVl?=
 =?utf-8?B?cXN6dmhIeC9mUk5vdDlMRlRYci9LVGo3SS9IUDkyVWFZQk5vbVk4YnpjUFQ5?=
 =?utf-8?B?UDRWdHNEbFE1dVUvWTZwT3A0NDVYYzBoUWIrcXFyS1BaS2NkOUI2Q0JXdHBY?=
 =?utf-8?B?RmFLNTBoOUxMK3VhM0FsUEJmT0JQQ0VZRDF5Mytxb25ieSswR0N3RTZsMVVr?=
 =?utf-8?B?UXlPT21zMU5CeE5qelRXcXRwTk5XOEdGQ3hVNHBlNS9TNDhwaHNSYmpMNCtj?=
 =?utf-8?B?d3lPbjhuWk45dzIxUEI0L3RoR3RNNm5acWoyZGRPbExuSDhhSDNsb0pUVDl2?=
 =?utf-8?Q?7TizdbrsnLfwn3ipBmovrsFziMG/uhQwBDwKFNv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a1cf902-fae0-4bec-d179-08d934ba8011
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2021 13:43:07.0114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EXK+kzRWp3Ljq7xQISrdyflPZBKo8gJSV10wAU89hgJDTu4db86jYW0cAQEgFUWipdcAa+HvXPveQNVejurs/hV7MHv7bIM/B+c+5n6sHN8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4285
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10021 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106210081
X-Proofpoint-ORIG-GUID: PX_wvBkI0TLLXk-nGFfgXNePsbzlHmuJ
X-Proofpoint-GUID: PX_wvBkI0TLLXk-nGFfgXNePsbzlHmuJ

On 6/21/21 2:12 PM, Muchun Song wrote:
> On Fri, Jun 18, 2021 at 2:46 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> In preparation for device-dax for using hugetlbfs compound page tail
>> deduplication technique, move the comment block explanation into a
>> common place in Documentation/vm.
>>
>> Cc: Muchun Song <songmuchun@bytedance.com>
>> Cc: Mike Kravetz <mike.kravetz@oracle.com>
>> Suggested-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>  Documentation/vm/compound_pagemaps.rst | 170 +++++++++++++++++++++++++
>>  Documentation/vm/index.rst             |   1 +
>>  mm/hugetlb_vmemmap.c                   | 162 +----------------------
>>  3 files changed, 172 insertions(+), 161 deletions(-)
>>  create mode 100644 Documentation/vm/compound_pagemaps.rst
> 
> IMHO, how about the name of vmemmap_remap.rst? page_frags.rst seems
> to tell people it's about the page mapping not its vmemmap mapping.
> 

Good point.

FWIW, I wanted to avoid the use of the word 'remap' solely because that might be
implementation specific e.g. hugetlbfs remaps struct pages, whereas device-dax will
populate struct pages already with the tail dedup.

Me using 'compound_pagemaps' was short of 'compound struct page map' or 'compound vmemmap'.

Maybe one other alternative is 'tail_dedup.rst' or 'metadata_dedup.rst' ? That's probably
more generic to what really is being done.

Regardless, I am also good with 'vmemmap_remap.rst' if that's what folks prefer.


>>
>> diff --git a/Documentation/vm/compound_pagemaps.rst b/Documentation/vm/compound_pagemaps.rst
>> new file mode 100644
>> index 000000000000..6b1af50e8201
>> --- /dev/null
>> +++ b/Documentation/vm/compound_pagemaps.rst
>> @@ -0,0 +1,170 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +
>> +.. _commpound_pagemaps:
>> +
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
>> +more details. On the x86-64 architecture, HugeTLB pages of size 2MB and 1GB
>> +are currently supported. Since the base page size on x86 is 4KB, a 2MB
>> +HugeTLB page consists of 512 base pages and a 1GB HugeTLB page consists of
>> +4096 base pages. For each base page, there is a corresponding page struct.
>> +
>> +Within the HugeTLB subsystem, only the first 4 page structs are used to
>> +contain unique information about a HugeTLB page. __NR_USED_SUBPAGE provides
>> +this upper limit. The only 'useful' information in the remaining page structs
>> +is the compound_head field, and this field is the same for all tail pages.
>> +
>> +By removing redundant page structs for HugeTLB pages, memory can be returned
>> +to the buddy allocator for other uses.
>> +
>> +Different architectures support different HugeTLB pages. For example, the
>> +following table is the HugeTLB page size supported by x86 and arm64
>> +architectures. Because arm64 supports 4k, 16k, and 64k base pages and
>> +supports contiguous entries, so it supports many kinds of sizes of HugeTLB
>> +page.
>> +
>> ++--------------+-----------+-----------------------------------------------+
>> +| Architecture | Page Size |                HugeTLB Page Size              |
>> ++--------------+-----------+-----------+-----------+-----------+-----------+
>> +|    x86-64    |    4KB    |    2MB    |    1GB    |           |           |
>> ++--------------+-----------+-----------+-----------+-----------+-----------+
>> +|              |    4KB    |   64KB    |    2MB    |    32MB   |    1GB    |
>> +|              +-----------+-----------+-----------+-----------+-----------+
>> +|    arm64     |   16KB    |    2MB    |   32MB    |     1GB   |           |
>> +|              +-----------+-----------+-----------+-----------+-----------+
>> +|              |   64KB    |    2MB    |  512MB    |    16GB   |           |
>> ++--------------+-----------+-----------+-----------+-----------+-----------+
>> +
>> +When the system boot up, every HugeTLB page has more than one struct page
>> +structs which size is (unit: pages):
>> +
>> +   struct_size = HugeTLB_Size / PAGE_SIZE * sizeof(struct page) / PAGE_SIZE
>> +
>> +Where HugeTLB_Size is the size of the HugeTLB page. We know that the size
>> +of the HugeTLB page is always n times PAGE_SIZE. So we can get the following
>> +relationship.
>> +
>> +   HugeTLB_Size = n * PAGE_SIZE
>> +
>> +Then,
>> +
>> +   struct_size = n * PAGE_SIZE / PAGE_SIZE * sizeof(struct page) / PAGE_SIZE
>> +               = n * sizeof(struct page) / PAGE_SIZE
>> +
>> +We can use huge mapping at the pud/pmd level for the HugeTLB page.
>> +
>> +For the HugeTLB page of the pmd level mapping, then
>> +
>> +   struct_size = n * sizeof(struct page) / PAGE_SIZE
>> +               = PAGE_SIZE / sizeof(pte_t) * sizeof(struct page) / PAGE_SIZE
>> +               = sizeof(struct page) / sizeof(pte_t)
>> +               = 64 / 8
>> +               = 8 (pages)
>> +
>> +Where n is how many pte entries which one page can contains. So the value of
>> +n is (PAGE_SIZE / sizeof(pte_t)).
>> +
>> +This optimization only supports 64-bit system, so the value of sizeof(pte_t)
>> +is 8. And this optimization also applicable only when the size of struct page
>> +is a power of two. In most cases, the size of struct page is 64 bytes (e.g.
>> +x86-64 and arm64). So if we use pmd level mapping for a HugeTLB page, the
>> +size of struct page structs of it is 8 page frames which size depends on the
>> +size of the base page.
>> +
>> +For the HugeTLB page of the pud level mapping, then
>> +
>> +   struct_size = PAGE_SIZE / sizeof(pmd_t) * struct_size(pmd)
>> +               = PAGE_SIZE / 8 * 8 (pages)
>> +               = PAGE_SIZE (pages)
>> +
>> +Where the struct_size(pmd) is the size of the struct page structs of a
>> +HugeTLB page of the pmd level mapping.
>> +
>> +E.g.: A 2MB HugeTLB page on x86_64 consists in 8 page frames while 1GB
>> +HugeTLB page consists in 4096.
>> +
>> +Next, we take the pmd level mapping of the HugeTLB page as an example to
>> +show the internal implementation of this optimization. There are 8 pages
>> +struct page structs associated with a HugeTLB page which is pmd mapped.
>> +
>> +Here is how things look before optimization.
>> +
>> +    HugeTLB                  struct pages(8 pages)         page frame(8 pages)
>> + +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
>> + |           |                     |     0     | -------------> |     0     |
>> + |           |                     +-----------+                +-----------+
>> + |           |                     |     1     | -------------> |     1     |
>> + |           |                     +-----------+                +-----------+
>> + |           |                     |     2     | -------------> |     2     |
>> + |           |                     +-----------+                +-----------+
>> + |           |                     |     3     | -------------> |     3     |
>> + |           |                     +-----------+                +-----------+
>> + |           |                     |     4     | -------------> |     4     |
>> + |    PMD    |                     +-----------+                +-----------+
>> + |   level   |                     |     5     | -------------> |     5     |
>> + |  mapping  |                     +-----------+                +-----------+
>> + |           |                     |     6     | -------------> |     6     |
>> + |           |                     +-----------+                +-----------+
>> + |           |                     |     7     | -------------> |     7     |
>> + |           |                     +-----------+                +-----------+
>> + |           |
>> + |           |
>> + |           |
>> + +-----------+
>> +
>> +The value of page->compound_head is the same for all tail pages. The first
>> +page of page structs (page 0) associated with the HugeTLB page contains the 4
>> +page structs necessary to describe the HugeTLB. The only use of the remaining
>> +pages of page structs (page 1 to page 7) is to point to page->compound_head.
>> +Therefore, we can remap pages 2 to 7 to page 1. Only 2 pages of page structs
>> +will be used for each HugeTLB page. This will allow us to free the remaining
>> +6 pages to the buddy allocator.
>> +
>> +Here is how things look after remapping.
>> +
>> +    HugeTLB                  struct pages(8 pages)         page frame(8 pages)
>> + +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
>> + |           |                     |     0     | -------------> |     0     |
>> + |           |                     +-----------+                +-----------+
>> + |           |                     |     1     | -------------> |     1     |
>> + |           |                     +-----------+                +-----------+
>> + |           |                     |     2     | ----------------^ ^ ^ ^ ^ ^
>> + |           |                     +-----------+                   | | | | |
>> + |           |                     |     3     | ------------------+ | | | |
>> + |           |                     +-----------+                     | | | |
>> + |           |                     |     4     | --------------------+ | | |
>> + |    PMD    |                     +-----------+                       | | |
>> + |   level   |                     |     5     | ----------------------+ | |
>> + |  mapping  |                     +-----------+                         | |
>> + |           |                     |     6     | ------------------------+ |
>> + |           |                     +-----------+                           |
>> + |           |                     |     7     | --------------------------+
>> + |           |                     +-----------+
>> + |           |
>> + |           |
>> + |           |
>> + +-----------+
>> +
>> +When a HugeTLB is freed to the buddy system, we should allocate 6 pages for
>> +vmemmap pages and restore the previous mapping relationship.
>> +
>> +For the HugeTLB page of the pud level mapping. It is similar to the former.
>> +We also can use this approach to free (PAGE_SIZE - 2) vmemmap pages.
>> +
>> +Apart from the HugeTLB page of the pmd/pud level mapping, some architectures
>> +(e.g. aarch64) provides a contiguous bit in the translation table entries
>> +that hints to the MMU to indicate that it is one of a contiguous set of
>> +entries that can be cached in a single TLB entry.
>> +
>> +The contiguous bit is used to increase the mapping size at the pmd and pte
>> +(last) level. So this type of HugeTLB page can be optimized only when its
>> +size of the struct page structs is greater than 2 pages.
>> +
>> diff --git a/Documentation/vm/index.rst b/Documentation/vm/index.rst
>> index eff5fbd492d0..19f981a73a54 100644
>> --- a/Documentation/vm/index.rst
>> +++ b/Documentation/vm/index.rst
>> @@ -31,6 +31,7 @@ descriptions of data structures and algorithms.
>>     active_mm
>>     arch_pgtable_helpers
>>     balance
>> +   commpound_pagemaps
>>     cleancache
>>     free_page_reporting
>>     frontswap
>> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>> index c540c21e26f5..69d1f0a90e02 100644
>> --- a/mm/hugetlb_vmemmap.c
>> +++ b/mm/hugetlb_vmemmap.c
>> @@ -6,167 +6,7 @@
>>   *
>>   *     Author: Muchun Song <songmuchun@bytedance.com>
>>   *
>> - * The struct page structures (page structs) are used to describe a physical
>> - * page frame. By default, there is a one-to-one mapping from a page frame to
>> - * it's corresponding page struct.
>> - *
>> - * HugeTLB pages consist of multiple base page size pages and is supported by
>> - * many architectures. See hugetlbpage.rst in the Documentation directory for
>> - * more details. On the x86-64 architecture, HugeTLB pages of size 2MB and 1GB
>> - * are currently supported. Since the base page size on x86 is 4KB, a 2MB
>> - * HugeTLB page consists of 512 base pages and a 1GB HugeTLB page consists of
>> - * 4096 base pages. For each base page, there is a corresponding page struct.
>> - *
>> - * Within the HugeTLB subsystem, only the first 4 page structs are used to
>> - * contain unique information about a HugeTLB page. __NR_USED_SUBPAGE provides
>> - * this upper limit. The only 'useful' information in the remaining page structs
>> - * is the compound_head field, and this field is the same for all tail pages.
>> - *
>> - * By removing redundant page structs for HugeTLB pages, memory can be returned
>> - * to the buddy allocator for other uses.
>> - *
>> - * Different architectures support different HugeTLB pages. For example, the
>> - * following table is the HugeTLB page size supported by x86 and arm64
>> - * architectures. Because arm64 supports 4k, 16k, and 64k base pages and
>> - * supports contiguous entries, so it supports many kinds of sizes of HugeTLB
>> - * page.
>> - *
>> - * +--------------+-----------+-----------------------------------------------+
>> - * | Architecture | Page Size |                HugeTLB Page Size              |
>> - * +--------------+-----------+-----------+-----------+-----------+-----------+
>> - * |    x86-64    |    4KB    |    2MB    |    1GB    |           |           |
>> - * +--------------+-----------+-----------+-----------+-----------+-----------+
>> - * |              |    4KB    |   64KB    |    2MB    |    32MB   |    1GB    |
>> - * |              +-----------+-----------+-----------+-----------+-----------+
>> - * |    arm64     |   16KB    |    2MB    |   32MB    |     1GB   |           |
>> - * |              +-----------+-----------+-----------+-----------+-----------+
>> - * |              |   64KB    |    2MB    |  512MB    |    16GB   |           |
>> - * +--------------+-----------+-----------+-----------+-----------+-----------+
>> - *
>> - * When the system boot up, every HugeTLB page has more than one struct page
>> - * structs which size is (unit: pages):
>> - *
>> - *    struct_size = HugeTLB_Size / PAGE_SIZE * sizeof(struct page) / PAGE_SIZE
>> - *
>> - * Where HugeTLB_Size is the size of the HugeTLB page. We know that the size
>> - * of the HugeTLB page is always n times PAGE_SIZE. So we can get the following
>> - * relationship.
>> - *
>> - *    HugeTLB_Size = n * PAGE_SIZE
>> - *
>> - * Then,
>> - *
>> - *    struct_size = n * PAGE_SIZE / PAGE_SIZE * sizeof(struct page) / PAGE_SIZE
>> - *                = n * sizeof(struct page) / PAGE_SIZE
>> - *
>> - * We can use huge mapping at the pud/pmd level for the HugeTLB page.
>> - *
>> - * For the HugeTLB page of the pmd level mapping, then
>> - *
>> - *    struct_size = n * sizeof(struct page) / PAGE_SIZE
>> - *                = PAGE_SIZE / sizeof(pte_t) * sizeof(struct page) / PAGE_SIZE
>> - *                = sizeof(struct page) / sizeof(pte_t)
>> - *                = 64 / 8
>> - *                = 8 (pages)
>> - *
>> - * Where n is how many pte entries which one page can contains. So the value of
>> - * n is (PAGE_SIZE / sizeof(pte_t)).
>> - *
>> - * This optimization only supports 64-bit system, so the value of sizeof(pte_t)
>> - * is 8. And this optimization also applicable only when the size of struct page
>> - * is a power of two. In most cases, the size of struct page is 64 bytes (e.g.
>> - * x86-64 and arm64). So if we use pmd level mapping for a HugeTLB page, the
>> - * size of struct page structs of it is 8 page frames which size depends on the
>> - * size of the base page.
>> - *
>> - * For the HugeTLB page of the pud level mapping, then
>> - *
>> - *    struct_size = PAGE_SIZE / sizeof(pmd_t) * struct_size(pmd)
>> - *                = PAGE_SIZE / 8 * 8 (pages)
>> - *                = PAGE_SIZE (pages)
>> - *
>> - * Where the struct_size(pmd) is the size of the struct page structs of a
>> - * HugeTLB page of the pmd level mapping.
>> - *
>> - * E.g.: A 2MB HugeTLB page on x86_64 consists in 8 page frames while 1GB
>> - * HugeTLB page consists in 4096.
>> - *
>> - * Next, we take the pmd level mapping of the HugeTLB page as an example to
>> - * show the internal implementation of this optimization. There are 8 pages
>> - * struct page structs associated with a HugeTLB page which is pmd mapped.
>> - *
>> - * Here is how things look before optimization.
>> - *
>> - *    HugeTLB                  struct pages(8 pages)         page frame(8 pages)
>> - * +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
>> - * |           |                     |     0     | -------------> |     0     |
>> - * |           |                     +-----------+                +-----------+
>> - * |           |                     |     1     | -------------> |     1     |
>> - * |           |                     +-----------+                +-----------+
>> - * |           |                     |     2     | -------------> |     2     |
>> - * |           |                     +-----------+                +-----------+
>> - * |           |                     |     3     | -------------> |     3     |
>> - * |           |                     +-----------+                +-----------+
>> - * |           |                     |     4     | -------------> |     4     |
>> - * |    PMD    |                     +-----------+                +-----------+
>> - * |   level   |                     |     5     | -------------> |     5     |
>> - * |  mapping  |                     +-----------+                +-----------+
>> - * |           |                     |     6     | -------------> |     6     |
>> - * |           |                     +-----------+                +-----------+
>> - * |           |                     |     7     | -------------> |     7     |
>> - * |           |                     +-----------+                +-----------+
>> - * |           |
>> - * |           |
>> - * |           |
>> - * +-----------+
>> - *
>> - * The value of page->compound_head is the same for all tail pages. The first
>> - * page of page structs (page 0) associated with the HugeTLB page contains the 4
>> - * page structs necessary to describe the HugeTLB. The only use of the remaining
>> - * pages of page structs (page 1 to page 7) is to point to page->compound_head.
>> - * Therefore, we can remap pages 2 to 7 to page 1. Only 2 pages of page structs
>> - * will be used for each HugeTLB page. This will allow us to free the remaining
>> - * 6 pages to the buddy allocator.
>> - *
>> - * Here is how things look after remapping.
>> - *
>> - *    HugeTLB                  struct pages(8 pages)         page frame(8 pages)
>> - * +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
>> - * |           |                     |     0     | -------------> |     0     |
>> - * |           |                     +-----------+                +-----------+
>> - * |           |                     |     1     | -------------> |     1     |
>> - * |           |                     +-----------+                +-----------+
>> - * |           |                     |     2     | ----------------^ ^ ^ ^ ^ ^
>> - * |           |                     +-----------+                   | | | | |
>> - * |           |                     |     3     | ------------------+ | | | |
>> - * |           |                     +-----------+                     | | | |
>> - * |           |                     |     4     | --------------------+ | | |
>> - * |    PMD    |                     +-----------+                       | | |
>> - * |   level   |                     |     5     | ----------------------+ | |
>> - * |  mapping  |                     +-----------+                         | |
>> - * |           |                     |     6     | ------------------------+ |
>> - * |           |                     +-----------+                           |
>> - * |           |                     |     7     | --------------------------+
>> - * |           |                     +-----------+
>> - * |           |
>> - * |           |
>> - * |           |
>> - * +-----------+
>> - *
>> - * When a HugeTLB is freed to the buddy system, we should allocate 6 pages for
>> - * vmemmap pages and restore the previous mapping relationship.
>> - *
>> - * For the HugeTLB page of the pud level mapping. It is similar to the former.
>> - * We also can use this approach to free (PAGE_SIZE - 2) vmemmap pages.
>> - *
>> - * Apart from the HugeTLB page of the pmd/pud level mapping, some architectures
>> - * (e.g. aarch64) provides a contiguous bit in the translation table entries
>> - * that hints to the MMU to indicate that it is one of a contiguous set of
>> - * entries that can be cached in a single TLB entry.
>> - *
>> - * The contiguous bit is used to increase the mapping size at the pmd and pte
>> - * (last) level. So this type of HugeTLB page can be optimized only when its
>> - * size of the struct page structs is greater than 2 pages.
>> + * See Documentation/vm/compound_pagemaps.rst
>>   */
>>  #define pr_fmt(fmt)    "HugeTLB: " fmt
>>
>> --
>> 2.17.1
>>
> 
