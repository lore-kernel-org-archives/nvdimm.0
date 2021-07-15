Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFA829D6
	for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 13:07:04 +0000 (UTC)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16FD1jNP025400;
	Thu, 15 Jul 2021 13:06:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=9fDJTEjfPDsNpMIGrXwqVGiSa5e1U10sQ8OF5xgVqy0=;
 b=GtF24X20KpPs0g28oosn4Rfye5e1cCsowjey9Oa+jCjY8mGvWpeUqrwygIdEf/wSJMJ+
 lut0mfYvS6bDPeY4GpbmfcXsK/4SOUzXHKcQ3vxl4Omn7exRRmoeiLL0ICg/szjMkbq4
 h6QQosVycY43fb6a0qQB6nTrW+MVxDW/xrF7eTyI4SZH8TEzXtlFm3TKAl3gE3fhGgkA
 u5RAZ6jr59Uds4jogHI6vRtq8amFm2AtZKhqSukLpHgRn09UWivuJKaLLXqyhtwMXSwV
 mepcLgVGuZFwhZ2U8uoSQUe2sY4AG3dI7cCxntHd4M7PV0bUReH8rs8U+h58iGZFxMnv QQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=9fDJTEjfPDsNpMIGrXwqVGiSa5e1U10sQ8OF5xgVqy0=;
 b=mfDtN0L4Df3++DoBgeDf5WGmUJp95tLtGd+jd7m2Dv/0TppLDRFMyjfM2S4D8Dxz2TAZ
 lrXnalfOvnDRfRjOOiTxeJac7iD6aWbguhIW/0s5nQtvt0jc+csNMcKZY1OmQjUJmm+4
 /tRFLe03KcBZqvalbWGEVsnDORez/CFKdbg4z9x3PJIrVfj9Dfh1YJzt6NnJS5KpXScr
 gtJKde68t4M39jUVkhxXCAT5qMA5DXmijJwWXiiyMOIBiLKaBdkiViPhY7TUTXHQz0yQ
 LVRoMrXNtX+2cw3XMAI/S7arVjoY4RBdWJ4321YfNBzoIDiyGR03wFGmC4638400RoPj Ag== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 39suk8tvpr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jul 2021 13:06:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16FD0drO101729;
	Thu, 15 Jul 2021 13:06:53 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
	by userp3030.oracle.com with ESMTP id 39q0pat0ss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jul 2021 13:06:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lcREw0JKG3ELHVf4AtTxxysYls0xFhOuDfhNk6B3uqFgRwsffpdwn/DADLGxOsPZ0uY0NS6b4KfA/AwLrKg7E5lYceRA3tqzu1weCJSRlE9szO2BuLdG27ZUSSmaweI7xKQL+hUUZCq/dVfGf/dZBYam6wTLDLuOD2eolPTjOZiCS5eepweUU2ekFSEADExhD9K3dYyJou/I7bkN8M2EEUYqMKpWaRVLjtQWpN4O8kpsMwNx9/v1AHhibkRDohW4JPfIA/KnSRZNro9cOi/OlreJbD81WBFVqqBNK08N+R7PtQnGtKZwHaTxgGAYkqp9ECQV87Aw1Ankdo7CfzFbMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9fDJTEjfPDsNpMIGrXwqVGiSa5e1U10sQ8OF5xgVqy0=;
 b=CcoFMjQrr5bthx4KLgQTstNVJkh2QAN0E55qeK7BOS0BY8xc2NHQOkY7FhIHgq7RStPavJkQuGJmPRq15e82C7l4RKGy1pRQ0E8/dRWn7X4/iRSyW85OeGKRhd01Helha6Mosup9V3rkYgFMTduL7nTVeaP9YGkjR92fW46iim0sG6iY+jgSo4hV3qTLu7CJJoV6uOF1sPUfG1KtV//ZaTICKz+wKF7CmyOgLZaX+48/Gbw1A99C6yAnhK5GROlrO0xXIKqm4Em7LfUI4OjZphQ4RG0xozH5JLDbum3O/lBXkAC/n3HC9fuMTOFBhYzSHcMkqllYHZWxcYe0EdLoVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9fDJTEjfPDsNpMIGrXwqVGiSa5e1U10sQ8OF5xgVqy0=;
 b=h+oViANvVo0MV4cZL/viYx6/Zof4dlHcAA9+lZHpCM6D+0tq32pwZDGMIwgA0vkK+7+RA3BsUpuL3Uo1pXlKTzV//TQmLwi0QTgy7oCns0DJCNL/SYLkxr/Ii0DzxyzpoVEs+T1a4RaBgKVMlPcBn6n09WvQOBfdPy8vXMmQS0M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4013.namprd10.prod.outlook.com (2603:10b6:208:185::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22; Thu, 15 Jul
 2021 13:06:51 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4331.024; Thu, 15 Jul 2021
 13:06:51 +0000
Subject: Re: [PATCH v3 04/14] mm/memremap: add ZONE_DEVICE support for
 compound pages
From: Joao Martins <joao.m.martins@oracle.com>
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
Message-ID: <8a85d09a-be11-8016-0a59-bd622a98e335@oracle.com>
Date: Thu, 15 Jul 2021 14:06:44 +0100
In-Reply-To: <d73793a8-7540-c473-0e30-0880341c2baf@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0453.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::8) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO4P123CA0453.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1aa::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Thu, 15 Jul 2021 13:06:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4bffb9a5-64ac-45bc-8ba3-08d947916912
X-MS-TrafficTypeDiagnostic: MN2PR10MB4013:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB40136C62EF59163F350D4340BB129@MN2PR10MB4013.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	+3Z9FQrfoLFPZZBJO43oX7OG4F072YRn/Ig12Dt7/IEoN9sWYO31tI+c7g1JtcMGPkN4pgrF18xtIUBzfCjMapS1cBmMYwGeg66GjQYgRpW4BHwjvihrJcRBLC3XzZLpOz1+qx/BHqptCpBw2wDOP6/RJTgw5k3Nzk7Xn1QLwhUhqF8J4r7KWTKut3/KJqk8ncs4THuDHT995k9ZGl0IUW/JzJ3QXCz/+6dlwTgsWg0NsuY2hi/YQ9SEAZJds708xJaeelDn7IlqvJ/lBvIc9aun8jpNEg53uODEwBpd8FIcfaAPJ45kKeV5QuVp5NWMCXMy4iZNqfmJufKcBYsAi/eBBpsZEg0E/jT4eHyZkqoGRW2fPIJq7x66iBKJXvsh9a85w0v076OVzi/qfqN4QgGYWtj0YsB2d3XHgQ87J4R+mrLtmNYEgcENrMXgbftvTFn3YT9jJbALJjisx9sxZYzcAgojn+Ml4Bc0FHOh/kdgFJtQG2+Q4skgV+Qw6GJwXAIWJO63y+33A3sO0rkf5g9Ipa6h0NYgqAjZ3nLxMoNPtFvbY/m7PHjkuZ0lhjzXZpp1nwz1cbybbW6tbSGU/kVe7CWpMv8REnVaI+tgB07s1oPXOYfBynALtJhQbF7POA4wZBASN5q4EYf4ahWJAUcoW6x4MJVIj5gTMFleP9GloQSbVsNztQzAdWddIeCvX2hl/g7YZH70GTcyyEEzxA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(39860400002)(346002)(136003)(86362001)(31696002)(66556008)(316002)(54906003)(478600001)(31686004)(66476007)(36756003)(83380400001)(66946007)(2906002)(16576012)(6666004)(186003)(4326008)(6486002)(5660300002)(38100700002)(26005)(6916009)(7416002)(956004)(2616005)(53546011)(8936002)(8676002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?V0JVWGdaVWNlVGdhd3BjYTIwaS8rV2xWN2xGK3BrbTlDR0NXSnVPMlp3NUZ1?=
 =?utf-8?B?UGJHL0ZQb2NlTjZMMW0yMit4ZkNnQStOR3pmRjRnYnYvMFFaMVd5amNhSUlJ?=
 =?utf-8?B?QnN2YUtkLzZhaXE2NXQ5eFpzM1Uwa0h0NS9Ramtta2YzeENyTGxyWHVLWUV0?=
 =?utf-8?B?RFZXWUp2VkQ1Z3ZpM3llRjdsRWFBU1RvdFNVejErWDZ0NHhPbGJsRGZrTW5K?=
 =?utf-8?B?bGdDOWNCTGx4RnE1cWYxNHJVTUc1Zkl5bzlJZGFGT3RiblY3T1JGTmZ1dEdI?=
 =?utf-8?B?cCtuelRUay85Z3ZwMVNnalNMM1RBZGNkV2tud3lnZEhtYUNSS2lmeUhpUFRu?=
 =?utf-8?B?emxJUEZSbHRSZTRzZ011R1NoeXIvOExtM0xNRE9oM1NHZU1zS05PSUV5ei9w?=
 =?utf-8?B?OC9udlNZLzFTRDZ1NmR1U0lJYUtiYXRrZFc1YTE2NHBVVXhkbjhqTEduN0Yw?=
 =?utf-8?B?cm1MNFpoelpUWWtaMDlMSDhzZDllWjQ2VGVOYmRpdXdzeDBZUE16MFZSS2xH?=
 =?utf-8?B?MzIyRCtlT2pUYzByZ0NMMUpKVjAvZFdQTFVBc0s5SVZlWGRhbmN3bTdnUk9V?=
 =?utf-8?B?RGRRUThITGZxd2dJSnh5aEdJeVl3RlYrSTZmUmlXMnNkZy8yMkhoVU1mei80?=
 =?utf-8?B?UkFoRkpsTlRaN1JlNXFTYlQ2Y0Y4Qjl1RXdjVnhDd0tHdU9Ic2RRZVRTWFM3?=
 =?utf-8?B?a1dEVFFlWUZuVzhBQld1bzJxd1ozekxGT2VrZzNsc3JOWE9sckZmdkNEUExx?=
 =?utf-8?B?K1BSSDlsaFFtQ1VSUE5EYlpCdFduVVg4aEpGdzZ1bklEVnordUxEREhqdDVl?=
 =?utf-8?B?dkRVVlBXRC92UjlQWEQ5bjhCOGljY2h4eE11VUl0NitPT2t1VjhTTHNyTDFW?=
 =?utf-8?B?VmRmbXhWSU1yS1BSNnA1VDM0MC9pamdzTllObTZ6emMxM0lzWkNZWUloRkl3?=
 =?utf-8?B?b1N5RWtYSnpIRXluTFVmNDlkMTZSZWdQaDg0MXJZSGtlWGJuZGdMUm8ycmt5?=
 =?utf-8?B?SHlaODNERUpmMzF2ZDdkbFNpVzUzbjNxNjFPL0RmczREbElDeXVXckRhdmE2?=
 =?utf-8?B?L0JZTGt4OTFLbWJ0VmRDM1Mwa25WNm1QSldjNjlEbmh3cTBjVXI4UVJCcFk3?=
 =?utf-8?B?NFJyQ3dQS3JLTWVJMmtzQSt3bEhWUnRlMFk3UERCdUdwaWIzbWR2aWNWWjBp?=
 =?utf-8?B?dFpud1ZYZ2tjVGM5SGM5WEF3QlpCTXNXWStIUWk5NFlPTTdSNmNiTkZBaVRX?=
 =?utf-8?B?V2tzVEFTWnZOTkhTVTN6ZzhWWUFjR3lRS1MrVXY4WFZ0RVBORjZpRHFQRnVy?=
 =?utf-8?B?WHFuYXZZVi9TZVN2V21QcHdiWmVPL05Ia1lKYVlSQ3ZZZEJoS2FhL0k5ZDNp?=
 =?utf-8?B?V0drRHZWdlFIdlF6RlNBbzN1MGt5V214UFllNlBTNzlQTFdqT1h4ZGNQUjh6?=
 =?utf-8?B?M2J2bFoxckVMd0FtWTYzREU0SUs1WGE3a0tKL0g2dG0zRjVWcHFBQTlCS0du?=
 =?utf-8?B?bmpLZmdqc2M0azFFanJ5K0Jvd1lhTnEyaHdMQkpsc1M0dDZYMnpRaytDQW1Y?=
 =?utf-8?B?cTkxQlQvRU81UHpVUHpBY1JDWjFHazdCTFBSeXMvY0FJRVJaN3FId2M2SnQ4?=
 =?utf-8?B?VlJCN2NHZE5EMEhDdzUvRURzMTRnWjVqWElTUUZZZFc3bEM0Z2w4ZnRkbHFy?=
 =?utf-8?B?QWV3b044OWgzbk1BdmkyaU1aN2FqWkhaMzcwZFBRMFVzQkg0Y2pnSUtQM2hX?=
 =?utf-8?Q?3IOLi+GKPFKTxeIxSEnOSxzZ8Op5660vw/uOCAx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bffb9a5-64ac-45bc-8ba3-08d947916912
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 13:06:51.0041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pT1huZEByijdJvCPJq0ngFKoiKheCRHUKNb9npSRezXKDjCHnf6XfSGh80hGR85KmuAe2jDNruq5HbBRa4nbffkw8pW2DoJG9i7yaPi84m0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4013
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107150094
X-Proofpoint-ORIG-GUID: OCEBkRoINwd_T9UD7XFppo6updHhaWZu
X-Proofpoint-GUID: OCEBkRoINwd_T9UD7XFppo6updHhaWZu

On 7/15/21 1:52 PM, Joao Martins wrote:
> On 7/15/21 2:08 AM, Dan Williams wrote:
>> On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>>> instead of
>>> base pages. When a compound page geometry is requested, all but the first
>>> page are initialised as tail pages instead of order-0 pages.
>>>
>>> For certain ZONE_DEVICE users like device-dax which have a fixed page size,
>>> this creates an opportunity to optimize GUP and GUP-fast walkers, treating
>>> it the same way as THP or hugetlb pages.
>>>
>>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>>> ---
>>>  include/linux/memremap.h | 17 +++++++++++++++++
>>>  mm/memremap.c            |  8 ++++++--
>>>  mm/page_alloc.c          | 34 +++++++++++++++++++++++++++++++++-
>>>  3 files changed, 56 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
>>> index 119f130ef8f1..e5ab6d4525c1 100644
>>> --- a/include/linux/memremap.h
>>> +++ b/include/linux/memremap.h
>>> @@ -99,6 +99,10 @@ struct dev_pagemap_ops {
>>>   * @done: completion for @internal_ref
>>>   * @type: memory type: see MEMORY_* in memory_hotplug.h
>>>   * @flags: PGMAP_* flags to specify defailed behavior
>>> + * @geometry: structural definition of how the vmemmap metadata is populated.
>>> + *     A zero or PAGE_SIZE defaults to using base pages as the memmap metadata
>>> + *     representation. A bigger value but also multiple of PAGE_SIZE will set
>>> + *     up compound struct pages representative of the requested geometry size.
>>>   * @ops: method table
>>>   * @owner: an opaque pointer identifying the entity that manages this
>>>   *     instance.  Used by various helpers to make sure that no
>>> @@ -114,6 +118,7 @@ struct dev_pagemap {
>>>         struct completion done;
>>>         enum memory_type type;
>>>         unsigned int flags;
>>> +       unsigned long geometry;
>>>         const struct dev_pagemap_ops *ops;
>>>         void *owner;
>>>         int nr_range;
>>> @@ -130,6 +135,18 @@ static inline struct vmem_altmap *pgmap_altmap(struct dev_pagemap *pgmap)
>>>         return NULL;
>>>  }
>>>
>>> +static inline unsigned long pgmap_geometry(struct dev_pagemap *pgmap)
>>> +{
>>> +       if (!pgmap || !pgmap->geometry)
>>> +               return PAGE_SIZE;
>>> +       return pgmap->geometry;
>>> +}
>>> +
>>> +static inline unsigned long pgmap_pfn_geometry(struct dev_pagemap *pgmap)
>>> +{
>>> +       return PHYS_PFN(pgmap_geometry(pgmap));
>>> +}
>>
>> Are both needed? Maybe just have ->geometry natively be in nr_pages
>> units directly, because pgmap_pfn_geometry() makes it confusing
>> whether it's a geometry of the pfn or the geometry of the pgmap.
>>
> I use pgmap_geometry() largelly when we manipulate memmap in sparse-vmemmap code, as we
> deal with addresses/offsets/subsection-size. While using pgmap_pfn_geometry for code that
> deals with PFN initialization. For this patch I could remove the confusion.
> 
> And actually maybe I can just store the pgmap_geometry() value in bytes locally in
> vmemmap_populate_compound_pages() and we can remove this extra helper.
> 
But one nice property of pgmap_geometry() is the @pgmap check and not needing that the
driver initializes a pgmap->geometry property. So a zeroed value would still support pgmap
users on the old case where there's no @geometry (or the user doesn't care). So departing
from this helper might mean that either memremap_pages() sets the right @geometry if a
zeroed value is passed in. and __populate_section_memmap() makes sures pgmap is associated
when trying to figure out if there's a geometry to consider in the section mapping.
