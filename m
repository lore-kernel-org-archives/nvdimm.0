Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61BB72
	for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 13:16:05 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16FDBej5007670;
	Thu, 15 Jul 2021 13:15:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=n+IKRoqqSdLcs49kBWAXEMri3cvw5TeuofQ4UpJnxQU=;
 b=lIelBq2vFQ2TEEUec3EXgVpbaMJ1Bg/TohpkcBQuqVbTv89EVOF6u1qHv+Guot9SeHpU
 3kk662oA99XcG+0vH/hB9I/8JYKSHFZFSzdBVXhcgB+FcgwQyj5IM8FX7YOahtyMO64K
 yKb5meUB4dhb5e9OKa/OVCfvd8k102maFck3kVPejSCJ0g5OBUb8ahPU/9gnxeLVLftl
 TgwGhw4NzgF5wT+gBxJ04+nR3DrdUPbwpetdWB2z18P4Tn91pP5r8InV6GoEmLFeI61+
 DqZGEVZm5A9Te93a3AjJpxXd5WwRbFZ8FE54U8HwgyPmz/+TI/d+TwJ97B+fJsAsK9zC dA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=n+IKRoqqSdLcs49kBWAXEMri3cvw5TeuofQ4UpJnxQU=;
 b=DQ1NhPNHT9hevZQUQCgpEQm7glGsZ2XAEu2VsaeSh5JJVt4vGpx1YeYSRBsVW0uS6No3
 fpPrsin44ItV5Mxl1Z63CQ8kmoBNseFnnkxyGKDub/VGTdK/6uQ+sIvtxpLkLvx2ctby
 q4cb/S6IFSdaIadLpdN1PlaHR8N0yNSuE9vlwYQ/X5+B/mlzWkn5RcquaSXA9Q3gof4n
 LGDClSF60K5CKa2DZA3ghOKMPDxhrZ7s1HqwBfbAG90NrEdtIlXfEtF0Z7BIqePHm1uN
 EYdp2k0Ui7syN2L3E7cx8EgZ9w/Dbk+kMlmUuMDlPeowqA0+puFOTLJrSYpoBKhvjLGu Mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 39t2fcj257-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jul 2021 13:15:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16FDB5je177989;
	Thu, 15 Jul 2021 13:15:52 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
	by userp3020.oracle.com with ESMTP id 39qnb5mdsa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jul 2021 13:15:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q8dygpJoY9vwVsiH4tzWzqPHE15Bp+KUg7rbXjGOQQ16Yt+4N2TVtXMCDtaZ5oXXcEKSqlh0POJ4E8sl0m+GGvqg3PAv5VDq40euHEYuXElo3i97prSqEaGeXyO3T3mRmgtNO+NhTLnEhTG5N/g6aYdw5d/x4RhbD0qI2sKManlfPZSliAr6DZQPUXbU9VRFylAwmLDxeBo5sKyT5AE+AigXVh8W3YmNuBkOcoLoGQHrbLKKpCs/it9YVY10Vzb5k74fmVcT44xleW+FkJ8N+g/fd4gDKVY/2JGyRr5PbEZswgaaIROHIe8XBYweqFV4vVDhh6vKqj0WBs1Hwk92xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+IKRoqqSdLcs49kBWAXEMri3cvw5TeuofQ4UpJnxQU=;
 b=eh+C28RY4i3PyXJODEY9Lwm4A36KTMLTYqQ+tk+zaab/vWgfvMVhPqVK6fOZvthMCSG95RTgTbvq4t8Su8CtOyFHNjYCz9l5OdZuAXBgBHxV9O9hXHGgDnYOSyszUoln07FX6nL+8lmyArNn9RQHm72yvIxkI8U90oxRKC4eO4Uya9pNJ91XyWKVOCXapsanfdHPFMVLA5dFySkrh+bZrz7XB0hH9/cZ84312bRWNlfTt2S8T/kzjvVFZIDdFSMTBI5t2Urwag6Yq/kvukarOh5rk0U8GICOsOIA8+hgqn2be4LZqwzPgaGAeKrnQRB+gqSqTa3R4f2fuQPKcOMo8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+IKRoqqSdLcs49kBWAXEMri3cvw5TeuofQ4UpJnxQU=;
 b=uWlIRSYIRHVO295YLDGa+3uhdFHMDyAq3Xd5pGma6TWF9OgFwWPn1sbfMjMUuWzx/rBVSxfrFl7py2K06KO1+P5UeO7PbsdKbbY9DiSOxSjXPl0k8tOySgVIXHrTNo0s45vsRgj1i4FHwPQ16Kjl2h7quO5JS3ULbtkFoFvNGuM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5092.namprd10.prod.outlook.com (2603:10b6:208:326::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Thu, 15 Jul
 2021 13:15:50 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4331.024; Thu, 15 Jul 2021
 13:15:50 +0000
Subject: Re: [PATCH v3 04/14] mm/memremap: add ZONE_DEVICE support for
 compound pages
To: Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>
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
 <YPAxGcVa9QkSd7E7@infradead.org>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <b489cc8a-6e5b-ae55-a4ac-753d24d498a1@oracle.com>
Date: Thu, 15 Jul 2021 14:15:32 +0100
In-Reply-To: <YPAxGcVa9QkSd7E7@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0081.apcprd02.prod.outlook.com
 (2603:1096:4:90::21) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by SG2PR02CA0081.apcprd02.prod.outlook.com (2603:1096:4:90::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23 via Frontend Transport; Thu, 15 Jul 2021 13:15:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c00fee94-c046-48ba-a199-08d94792aa81
X-MS-TrafficTypeDiagnostic: BLAPR10MB5092:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB50927EA216BD122FBE01CDD7BB129@BLAPR10MB5092.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	6cmo8LVgTqKiJJzA9OzJtX84pp4EoZfc5UQjrmSm2H9jxnS1k+V1djENXWU57cEdCut9rxHGsbTkiBf3C+4SqH54WKRMw6QG8BxU/x28kMUfVNyjsJJ+rTXOnKO+AUdu43iky8YO8oMC6nm1zz/YDL5Cs6w+gnR0/nd5V+A14YGMI5I+LxmeyycwuRmmmRRWpNROovAQb1Vw+MF+UA4ZaoXYqsBEBDqR6cCQ2A/NMtcTw8okaRqiW+kwyROLt2KA2ic7Fa/pc34RmzDbWQheFe/GuaDB8Li7pCU0USr279dpuH09YYMQ/ypG6QROqp9VfWbOmQC7sMA7PQRKg9Qe8zJNfKEPqIL14qHgbvVcz586LRkEUBrSSViDfNduMWR0WtE+i467BDOFSKWcCgICL92dRfboFKgAFpx5OMhk2H2IcSvMrUjbhb0HtCx7y2tRNkp6Xy6m1TyTDcNbXfA/NK8103w6ha6UPgCUtRjH16UfNnSKS6LTElvwy9zVJFvV+Dyzw8YO1L3oTM1q6kAzT9JyQ3SOsl2x7NsBE2vgOOV6HNpMMAVC8bEJNIRvILPycznfrKND/0VmHpqK7zKnth6YSj1dd5PeHqby6Y1UKpQyYwyQ8gbIngWCH0QzrMCGvRK0TzNfSjH7by3fsGRMZ2PFI/61kFcB717L1nRfaz/8V9Ib3nxfTrNvP1dwxFTX2h6wmZN5rIFCo6Zt8IYdjA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(376002)(39860400002)(396003)(66476007)(6486002)(66556008)(478600001)(110136005)(8936002)(53546011)(31696002)(4326008)(6666004)(8676002)(66946007)(26005)(316002)(31686004)(186003)(4744005)(5660300002)(956004)(2616005)(16576012)(36756003)(86362001)(2906002)(38100700002)(7416002)(54906003)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?eDlWbkdyVjZSYkVtMWdIWFZ2dm1DUWZWdGw5Z1k4WG1VMTV0WWNUbFF4cFUv?=
 =?utf-8?B?bU8wRU55R3BrbE5zeDBwT0hsSlk5VUZvdHAxSFZSRWFXeVliMElxejQwTUNx?=
 =?utf-8?B?VGQ4cjVTaDd6WnFYUUwrbDhaZnI4N2pGS29EUWxDUURQNmdwTUVIYmxNeEts?=
 =?utf-8?B?OWNaTURzOXhhTzkrQTdicS9adER1U09Nbk5CbkQ5OWdFcHR2ckI4VVNnN1pk?=
 =?utf-8?B?ZWFBMlZRV0hmdW0xQkZxV2Q5Y3JXUkZzSWlOOFJIb0dMQ0RGT3NMQ1l4dDA2?=
 =?utf-8?B?RUlZWXN4YVlkRWJxZXpXK3lFcmNxTVViT3lkdm9vamNlcFFCUG9XaDZRMHQy?=
 =?utf-8?B?cmVOSFpFUFRZK0VGSU5ObUdQUTRNZEFaMHloNFFSMEpOQS81OU00bW5lUnZI?=
 =?utf-8?B?YlRmZ0J4M1VvZVhmdzB6akdjVXVJUHVZVTNrOUN2bzB1bndUZDZlMnZCY2Yr?=
 =?utf-8?B?bEI4aHZVZEJQWDZLT1RTWkZhdjQ1VExYWUVhYVNUdzVpRTFUV1RkNWdUYWRk?=
 =?utf-8?B?dDFLTmhPK1RCQWNEYXpVMzJnS3I1TlNTWUVZQVJBS3VrUzdFdXlOWUhlTHR0?=
 =?utf-8?B?dEJOaUgvbFJGbjlmeVM5NlBSejBmUGtnRVFJNm1wcnNab0RBNXlta0xRTjI3?=
 =?utf-8?B?Wm81SkEwN2dkb2tvTUpBbkR2bWFvamFMU1ZIM2xHWm5Pd3owakJmNDlPR2ZX?=
 =?utf-8?B?U0hzTFpuL0hpQldMUVhEd1M4ZW1ZS2ZCdXNoMWFqMnRTSk9HRTlMU3lwK3NN?=
 =?utf-8?B?ZmxvSXhNUDFtazlEdWFvVUNCSmtiVFVSc0RiVTZhaVlWQWk0ZVM1RkUzdEhD?=
 =?utf-8?B?d0JORm9nTVc1d0thYUE3NlJ4QlVzTTBuSWExa3ovT2RBTHBoWndoc1lZVjdB?=
 =?utf-8?B?WUo1elcvc29Jc1ZuRnpEb1FXOU4wQ3gvaXl5M3pBangwelZ5SkJFVWlxTjdD?=
 =?utf-8?B?Ynl4Y013cC9ybmhwRU52V09YbE5WNUtuaFloS3F0aFcwVUs2RlluYTJLQ1Z5?=
 =?utf-8?B?UndxLzJuNVpVUHJtVGY0ZkVuUGd2b3RMaGhyU1RxYmpaaFR4WGIrVU9tRFRO?=
 =?utf-8?B?SE9sVTgvNXkyYjFhVEhSVFdud0U2bFRDZ0NsSGJ5c3cwRzJpRWphVjBHL3JO?=
 =?utf-8?B?RmRDMzJaK0h6c2VwTUVicVd6aWFwb2UxVjlrQnF6MDhDTG85OUY5dUlPMFo1?=
 =?utf-8?B?QzRtZTVNR1ZubG1YZkN4MnVyVmN5M1lxN2JjbVR1Vm9ZY3FvaG82eW9XSlVC?=
 =?utf-8?B?R1dyOWg0eTZtVHliYmViTlFQVmQ3SHdYUTM2MWI4dzBOd1VkRXlueUNrRGZz?=
 =?utf-8?B?MjcvTWV6U0dDRDRiVHBZSHZqcGZVZ0pBZlZxb2xEVHR3L296SG9RTzBYZzNk?=
 =?utf-8?B?YUZ5bTFUS0ZtbTRsQjVuclE2WkgreFZqNVVDU1BTQUZKbDJyNER0K0Y0K2Rq?=
 =?utf-8?B?WTlySW10RU5zS2dSemdTeG04cUdBWWRvTkU5cXluaUN2RGlmS0x2cWhDemdD?=
 =?utf-8?B?RmN3MmFNQjdENDZuVmlSUmFtWUdiVXo5dWZRL0pnekJ5RWMrczVwTEF5dnJH?=
 =?utf-8?B?NFNneUpBOHRqdlI2WU44MjBiL0Z2M2x3eERLODlCQktrVEFaenJEWWJUT1VS?=
 =?utf-8?B?b1BEMHVySFhraVdQTkZxcUV1emFhNGRpZVBmMTFKUEY5cVprT0dhdndnV3B5?=
 =?utf-8?B?cktSQUQrVTMrQmFPUXE4V1JOWU40MkkwWDdTRnVXVERrTFAydjliSTVtYm5K?=
 =?utf-8?Q?SHBtPHYF+s5NcjVCnddQm+1V1uVo5YbvlZpPsuT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c00fee94-c046-48ba-a199-08d94792aa81
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 13:15:50.2578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VCxeOYzA20ncpI//7VgE00GTGdz6zcUKgbVcO+LqGT9Rlh7oVzdCVdndg9onQ3GKfV1tm3XghPmgOGMrz1FPaKUyoRBtbHrxeSUrq2xqPW4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5092
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107150095
X-Proofpoint-GUID: Nsul1B8RkXvp-KeXHFqURmEGzu4MBQ5C
X-Proofpoint-ORIG-GUID: Nsul1B8RkXvp-KeXHFqURmEGzu4MBQ5C

On 7/15/21 1:59 PM, Christoph Hellwig wrote:
> On Wed, Jul 14, 2021 at 06:08:14PM -0700, Dan Williams wrote:
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
> 
> Actually - do we need non-power of two sizes here?  Otherwise a shift
> for the pfns would be really nice as that simplifies a lot of the
> calculations.
> 
AIUI, it's only powers-of-two: PAGE_SIZE (1 if nr of pages), PMD_SIZE (512) and PUD_SIZE (4K).
