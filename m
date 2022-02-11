Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64692F43
	for <nvdimm@lists.linux.dev>; Fri, 11 Feb 2022 12:39:48 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BB6TdO027620;
	Fri, 11 Feb 2022 12:37:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=fAmaOAGhA4wNrekQO4HIl8poFRZKuVnyyI9Zxi7JM2A=;
 b=I9WUS6TyC3PMJCFbm8tpVN4PaSGXOoVSKV8CeGqu1P50TlXY0EFvPdwFc3tJsy37rZeP
 3OCahSyVqYnFOtk0XPX77h/xiL/W+LoPNM5IU1vHy05Eri8B6r8zo21vlLc1zrQWtxZE
 +s+eWGS1rvj4iIWwrHGI31vNXC7TxzpbPOIMgW06bh+6QWp3SQ7If/FA480QumIPeLoQ
 zMAHiz0VkQeWj42tFNLqfPdswR1/+RCKvoop+ctjNiIG7TfnOYpaZFlUEStVZqPUvW4H
 jsIj7i8So0/zeWu1J1Qq4OOhw4IujWVyPaxwBNPxPpd0uiTJFak51osVmdykw8ABQOT8 Zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3e3hdt2y24-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Feb 2022 12:37:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21BCaXJa097130;
	Fri, 11 Feb 2022 12:37:57 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
	by aserp3030.oracle.com with ESMTP id 3e51rv2kgu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Feb 2022 12:37:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AntIugu/5Iq6g+7E0xnsx2TdxHETRq2fDC7SUz9ZlLu++m7Cq/LQidJclJvppPyTGczJC4DykVK5D3g564oDocKAQxFwny21RFYDqK+kTuDmDxIr3GY13MBI3QoPuZcAbxl14Zdu8/imBi2cNmfgPzcyHybA6g2s/gPzXzqsqA5XdvsJaQ2PXiAkxwAguXMNy54sSSQd39MBGQgs09sPq63VspbqpE7TS5bVRg18z37G1JZD5cykKORfsSe5NwpGP/+t/M/78py4Y3H5rCoJnq24kVTe6InUpiiygAjGt8xKsd7AwV8MjJ4tTYPorrZSk4ReoMruiBvaPu/+25Cg9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fAmaOAGhA4wNrekQO4HIl8poFRZKuVnyyI9Zxi7JM2A=;
 b=AWV5Y/HXAyhFE9rAAlI8F3513U3XJ8KZT1xCS+9DvZl0e2Iv1FXz6ElRJSngpGb6XrYWnompn8JFtfRvqK1H3iGJfekePgRiVMCLsQruQIvgS90yjDcZZjWl/Oulre9SbkzVD8/3QUdpQNkYOeNPNvZnfniOCe9UTsLQ4SxBac7MmRhVRQ3uP7F6yoWXBMXzofmsIgQpP2LXyAABegM5t322/XKBAWLthqFxlhmWYzS6Ik4DMiv/DeLor/5PVvGR/JFHj5j26IgJ5TzlTg+4skB7eujNuLeCHoaPzY2o7MNgqFgJkWNRymZ97FogbfYzdvihJN1PI63BGdt/ldrYMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fAmaOAGhA4wNrekQO4HIl8poFRZKuVnyyI9Zxi7JM2A=;
 b=K6VNV4+aOT5bG4L/XkbfSCyK4eZUSAjDurg6NLcUAtQY0eMM3kuHjpvjWpsC9eA/ZSlUdPSDtvNzNSRcROqnTk+Z4jQoQhmGM34II5FGqDM2TL9BewFmIBpYatLhE5UoUVUnSJcU527rx+i76EOCt4hDf34pjiCrintbMIs8ovU=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH2PR10MB4311.namprd10.prod.outlook.com (2603:10b6:610:79::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Fri, 11 Feb
 2022 12:37:55 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a%5]) with mapi id 15.20.4975.011; Fri, 11 Feb 2022
 12:37:55 +0000
Message-ID: <d258c471-1291-e0c7-f1b3-a495b4d40bb9@oracle.com>
Date: Fri, 11 Feb 2022 12:37:49 +0000
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
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <CAMZfGtUEaFg=CGLRJomyumsZzcyn8O0JE1+De2Vd3a5remcH6w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0220.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4f69848-adcd-44ca-c642-08d9ed5b53b5
X-MS-TrafficTypeDiagnostic: CH2PR10MB4311:EE_
X-Microsoft-Antispam-PRVS: 
	<CH2PR10MB4311E8DC6D2F1C434D45FA22BB309@CH2PR10MB4311.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	qWBh507TzVFBXnjDKAfdhaSvli04C6LvHJKVFrqIJRqH4ZvsNCEfsIog2sQq9cfH4FGaeBOJU/uVMx82OgwibBxP5uckfkQ5grX8k91Qsdr9RizYtg13Ge+rjHigvEfCuMaJcZjClh2VP1c8xMVTHzmr9k+PrVt8U+Tgc1Pdn04vXEfwXg/z23ojFQ1PB0ncSrBVaPgjlaXwgyZIRLn58lPjBi9Sw/dfTKA5YjlH4i57lJbxv//y6iry/+JsEuhA7NKdIZ2kcINjy9KRwQrNxqDkxSitnuj5JVLh1I07Y8Ge7/zyVKj/0+78tEQiw6BTT9DnLo+yR+3Lcwycec3zLJ/VQZJIc+8Le5mw9hvL/3d9Yow35u59dlht8DFDWb6QxayC7asmD0IZSGrYw6AwuK6D1VnHZAqx3R8x+ztgBXectMC4RmGY40D7+vJkhElt7wyK2yqijWibLQrv11IzdO87OEqDfTsb70/RTCxliGRoGsD944LZ/Kw8UFEDqxWOIdKMrZoC1ygIS/zQL4ilHYAheqQ809z++V2rLzAv+LDs6uGwTwC+matSIs8FgSlsaBpaOmdlIAVTQ1BACFyZ/qymViqEcFtTk1Xu2FNB7kU5mNC/xNhrBwbM61M6WdqmtzTM1+9TwwumvZEJj5x+ME1+4TDfaK8STuYKtcoPxQk5GRUiz/QuHvEK9Nj/ZxUnpue3jcovaMLtKdrjyX2anGy3DuImlmP0CaGKUahIeVU=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7416002)(5660300002)(31686004)(2616005)(31696002)(508600001)(6512007)(8936002)(6486002)(36756003)(83380400001)(53546011)(186003)(26005)(6506007)(6666004)(2906002)(86362001)(38100700002)(6916009)(54906003)(316002)(4326008)(66946007)(66556008)(66476007)(8676002)(25903002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?KzAwWFF2MFllenNPL1BBcTBheVBsQkpjR0NNSHlnQStoMGRROUFlVGRyU1Bp?=
 =?utf-8?B?bGxDSFdmUHRHajV0VFRwSG9vRU9DR254R1V5eXZJK04rS09zMVVzZmtKMmIw?=
 =?utf-8?B?bjJZcXhFQS9IYUpiWjZmeUxYdW9XZ1NZRmlTNXBhL2UxV2Q1cGFKaUg3V1FY?=
 =?utf-8?B?OHlONVVjU2ZMRE5keDZWcUEvVEVrblFyb3IzOWdHaU5wWHhkdHFHSUMvRnlI?=
 =?utf-8?B?dGZ3U1NJdU1WZXZhMk9oLzFNdHRnR2lHZFAvbXBLZjJvUFR1VFhxQS82eVpC?=
 =?utf-8?B?YXlyc1pxRW41Zjc3N21PYk1IazUybE1CcDFVRW42NUg5a1ZuREdBOGhreWE5?=
 =?utf-8?B?ek83RnVPdWZhSFJmc0t2Um5DcVNuMTVWVmNudHNoSUUzNFVQZVZiWGJvNDJm?=
 =?utf-8?B?blRWUkJ5SDBpRVBvVWFSTUdtOWd2RWNtMnN3cFRQTzduRW9UUzg0NWlBV2Vs?=
 =?utf-8?B?dHJ5U3FPTi9uS0ZZRVRiOFJUcmtQandsUEJqMUhyQkowaG1lMk84YlhUR2Nj?=
 =?utf-8?B?SzRTdzFPTU9FOGlsMitWUTdQbjBHU2RpSmdxSU40bWhQa3ludklEU1phVTNI?=
 =?utf-8?B?WkY4NlB0U3JCZEpFZkQ1ZWk2aE5CeGRCWERuZ3R3ODRpS2ZBVDkyTU4xeGtC?=
 =?utf-8?B?VXYwVEZVak5YMGR5eTRDZ1dwWm1LMG55WHdXRituc1RVS2NCdzZaSlB3N2pD?=
 =?utf-8?B?K2F2TVU1UFZUNkVRMFdYY3lwVlNHYWMrWkxXeEhyK0hnS3IyRGVHYS9iTHVa?=
 =?utf-8?B?dFZFTHV1SVNudWc3cGx4QWxkSllEZlc3VTRYY0hPU3BOMnVLS0lwaDVDaVgx?=
 =?utf-8?B?STZxUGlsOVpkN2lZQXZJT0xnMURGcTdLYzFxTmxUY3lveXp6aDlZYzdTL0pI?=
 =?utf-8?B?cnJVNmdQRmlCT0dpdysvaWpQQTlFaG9HV29mZDZmYmpBK0xCVzJaZ1NSYUNt?=
 =?utf-8?B?Nlpyc0xDdnhXQ0FTd2J4VmhyU1pmZnVEb2VTTkEvck0xa1IzYmZNa21PUkov?=
 =?utf-8?B?MEt4dWozdHFUYUgxaE5KbnVCY2FMek5lcUZmTlBIR2ltc21ZOFFhUk5HSGFO?=
 =?utf-8?B?WUo0SllLRExmQld6OVo0RXR0dzJWNjJWakNWTXJwQTNWamFpTkgycSs3ZFVO?=
 =?utf-8?B?RXhkMUZRbkpiRC9nNmFDWmJabHVNRmxldFE3VGlZZHdyWnhic1JpWjYxWUJa?=
 =?utf-8?B?a2ROeTYwKzlWcXl5VFFQaSs3SjNLZjJpdjBjbkZrMnI2WW1jOVc1a29mNUpv?=
 =?utf-8?B?MHlhL2UrMkZ2Y3JtK3VaUWtOU01mWUFuYWVzQWpvYTdoaUNVc3BRZkxpMnZX?=
 =?utf-8?B?MXpONzVvUm5xMk9COGE0eTRORmM4NE5RSmVGQktsOHJpL3RwZXhKTW9IdGdY?=
 =?utf-8?B?eWdjaEFQTmltQXh0WmZBZHd5blRVZFYwUStXMjE3NElITXNzMjU2Z25hamJ6?=
 =?utf-8?B?K2I1Ylp6Ky91VEhLREtPQXFPL2lFRTNRNTdHWE1CN3RGK3JvcExqdWZzNDVZ?=
 =?utf-8?B?dDdSei9Xb3RIMGFUQVdaM09uT1FadVRHUHRIbkQzYmthQ0tJNVA2SmEvTzRY?=
 =?utf-8?B?d0lLczJWUnJFWnBra2hITGh5RTJxYTMrYkdYNG0rb0ZBWTFTdVVJYXV0aEYx?=
 =?utf-8?B?QnFzZTQvK2FGdmIwTTdQa2lMTnFPbkRGdDcza2JiakkvNVY2bzJnQXAwU2RP?=
 =?utf-8?B?aDRVZk8wemxMS0dFS0NYUng3UFAvZ1BhZXljVHNUdlhsRVlqOTI0bkQ1Mk9G?=
 =?utf-8?B?UjhHbnl0V0w5VVBiS1RBeml5MjU4TStnazBKZE9yUTAwUGVOS08raVZaKzJT?=
 =?utf-8?B?U3VHMnJUM3dkV3BLc0RmZWxFQU1RMlAvbTg4WjVyK25HTVMraXlNM1hXYUkx?=
 =?utf-8?B?YmxSdlZKQ3ljOEp3QUJSbVRGeXI4cGNxcktrWHkvREQ1dVVCL0lWQmw5Nzhx?=
 =?utf-8?B?WFU0djVaVFhCdk0wb2VydGxFd1lISnFIbUo0Qy8yUUdSWnE4RlNJdTVxZ3pC?=
 =?utf-8?B?S29UVjB1VnV2YnFZQWZLSm5DVU5UOGpGSEk0ZVFyRmRVSUJFYVV4aTR4UFpn?=
 =?utf-8?B?WmJIYVRFbjNFWndsN1BlWnI4Y0RLRTVyVlRsL0EyejdSalF1SXNFU291MERT?=
 =?utf-8?B?OGE3STY3anZyeHh3WmFpTXJlOFhXWWpCZ3BIWFFWeXA3bVphZi9GYzd5TkVn?=
 =?utf-8?B?elYxOVFLOFVQQUpvY3BQSXptaVc3b0ZEQTlMYVVOSmYzb05VMnFveGtXTVhS?=
 =?utf-8?B?VXdLYUR4eWxKbGhMci9XelRHQ1R3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4f69848-adcd-44ca-c642-08d9ed5b53b5
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 12:37:55.3113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qBb5xmsKpQT/j48qW1aHxk0zo6oiU799pQFjIXKpIJMeg8ydP5tp6OoAJQA/cbFtPar9nY9mRnJ23wD3skYmFcnu+QEmZCqUZgb+FQrWAcc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4311
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10254 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 adultscore=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202110072
X-Proofpoint-GUID: ImwRe16qtDz0CK-nAiaxel1WiNmKRCD1
X-Proofpoint-ORIG-GUID: ImwRe16qtDz0CK-nAiaxel1WiNmKRCD1

On 2/11/22 07:54, Muchun Song wrote:
> On Fri, Feb 11, 2022 at 3:34 AM Joao Martins <joao.m.martins@oracle.com> wrote:
> [...]
>>  pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
>> -                                      struct vmem_altmap *altmap)
>> +                                      struct vmem_altmap *altmap,
>> +                                      struct page *block)
> 
> Why not use the name of "reuse" instead of "block"?
> Seems like "reuse" is more clear.
> 
Good idea, let me rename that to @reuse.

>>  {
>>         pte_t *pte = pte_offset_kernel(pmd, addr);
>>         if (pte_none(*pte)) {
>>                 pte_t entry;
>>                 void *p;
>>
>> -               p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
>> -               if (!p)
>> -                       return NULL;
>> +               if (!block) {
>> +                       p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
>> +                       if (!p)
>> +                               return NULL;
>> +               } else {
>> +                       /*
>> +                        * When a PTE/PMD entry is freed from the init_mm
>> +                        * there's a a free_pages() call to this page allocated
>> +                        * above. Thus this get_page() is paired with the
>> +                        * put_page_testzero() on the freeing path.
>> +                        * This can only called by certain ZONE_DEVICE path,
>> +                        * and through vmemmap_populate_compound_pages() when
>> +                        * slab is available.
>> +                        */
>> +                       get_page(block);
>> +                       p = page_to_virt(block);
>> +               }
>>                 entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
>>                 set_pte_at(&init_mm, addr, pte, entry);
>>         }
>> @@ -609,7 +624,8 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
>>  }
>>
>>  static int __meminit vmemmap_populate_address(unsigned long addr, int node,
>> -                                             struct vmem_altmap *altmap)
>> +                                             struct vmem_altmap *altmap,
>> +                                             struct page *reuse, struct page **page)
> 
> We can remove the last argument (struct page **page) if we change
> the return type to "pte_t *".  More simple, don't you think?
> 

Hmmm, perhaps it is simpler, specially provided the only error code is ENOMEM.

Albeit perhaps what we want is a `struct page *` rather than a pte.

>>  {
>>         pgd_t *pgd;
>>         p4d_t *p4d;
>> @@ -629,11 +645,13 @@ static int __meminit vmemmap_populate_address(unsigned long addr, int node,
>>         pmd = vmemmap_pmd_populate(pud, addr, node);
>>         if (!pmd)
>>                 return -ENOMEM;
>> -       pte = vmemmap_pte_populate(pmd, addr, node, altmap);
>> +       pte = vmemmap_pte_populate(pmd, addr, node, altmap, reuse);
>>         if (!pte)
>>                 return -ENOMEM;
>>         vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
>>
>> +       if (page)
>> +               *page = pte_page(*pte);
>>         return 0;
>>  }
>>
>> @@ -644,10 +662,120 @@ int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
>>         int rc;
>>
>>         for (; addr < end; addr += PAGE_SIZE) {
>> -               rc = vmemmap_populate_address(addr, node, altmap);
>> +               rc = vmemmap_populate_address(addr, node, altmap, NULL, NULL);
>>                 if (rc)
>>                         return rc;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static int __meminit vmemmap_populate_range(unsigned long start,
>> +                                           unsigned long end,
>> +                                           int node, struct page *page)
>> +{
>> +       unsigned long addr = start;
>> +       int rc;
>>
>> +       for (; addr < end; addr += PAGE_SIZE) {
>> +               rc = vmemmap_populate_address(addr, node, NULL, page, NULL);
>> +               if (rc)
>> +                       return rc;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static inline int __meminit vmemmap_populate_page(unsigned long addr, int node,
>> +                                                 struct page **page)
>> +{
>> +       return vmemmap_populate_address(addr, node, NULL, NULL, page);
>> +}
>> +
>> +/*
>> + * For compound pages bigger than section size (e.g. x86 1G compound
>> + * pages with 2M subsection size) fill the rest of sections as tail
>> + * pages.
>> + *
>> + * Note that memremap_pages() resets @nr_range value and will increment
>> + * it after each range successful onlining. Thus the value or @nr_range
>> + * at section memmap populate corresponds to the in-progress range
>> + * being onlined here.
>> + */
>> +static bool __meminit reuse_compound_section(unsigned long start_pfn,
>> +                                            struct dev_pagemap *pgmap)
>> +{
>> +       unsigned long nr_pages = pgmap_vmemmap_nr(pgmap);
>> +       unsigned long offset = start_pfn -
>> +               PHYS_PFN(pgmap->ranges[pgmap->nr_range].start);
>> +
>> +       return !IS_ALIGNED(offset, nr_pages) && nr_pages > PAGES_PER_SUBSECTION;
>> +}
>> +
>> +static struct page * __meminit compound_section_tail_page(unsigned long addr)
>> +{
>> +       pte_t *ptep;
>> +
>> +       addr -= PAGE_SIZE;
>> +
>> +       /*
>> +        * Assuming sections are populated sequentially, the previous section's
>> +        * page data can be reused.
>> +        */
>> +       ptep = pte_offset_kernel(pmd_off_k(addr), addr);
>> +       if (!ptep)
>> +               return NULL;
>> +
>> +       return pte_page(*ptep);
>> +}
>> +
>> +static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>> +                                                    unsigned long start,
>> +                                                    unsigned long end, int node,
>> +                                                    struct dev_pagemap *pgmap)
>> +{
>> +       unsigned long size, addr;
>> +
>> +       if (reuse_compound_section(start_pfn, pgmap)) {
>> +               struct page *page;
>> +
>> +               page = compound_section_tail_page(start);
>> +               if (!page)
>> +                       return -ENOMEM;
>> +
>> +               /*
>> +                * Reuse the page that was populated in the prior iteration
>> +                * with just tail struct pages.
>> +                */
>> +               return vmemmap_populate_range(start, end, node, page);
>> +       }
>> +
>> +       size = min(end - start, pgmap_vmemmap_nr(pgmap) * sizeof(struct page));
>> +       for (addr = start; addr < end; addr += size) {
>> +               unsigned long next = addr, last = addr + size;
>> +               struct page *block;
>> +               int rc;
>> +
>> +               /* Populate the head page vmemmap page */
>> +               rc = vmemmap_populate_page(addr, node, NULL);
>> +               if (rc)
>> +                       return rc;
>> +
>> +               /* Populate the tail pages vmemmap page */
>> +               block = NULL;
>> +               next = addr + PAGE_SIZE;
>> +               rc = vmemmap_populate_page(next, node, &block);
>> +               if (rc)
>> +                       return rc;
>> +
>> +               /*
>> +                * Reuse the previous page for the rest of tail pages
>> +                * See layout diagram in Documentation/vm/vmemmap_dedup.rst
>> +                */
>> +               next += PAGE_SIZE;
>> +               rc = vmemmap_populate_range(next, last, node, block);
>> +               if (rc)
>> +                       return rc;
>>         }
>>
>>         return 0;
>> @@ -659,12 +787,18 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
>>  {
>>         unsigned long start = (unsigned long) pfn_to_page(pfn);
>>         unsigned long end = start + nr_pages * sizeof(struct page);
>> +       int r;
>>
>>         if (WARN_ON_ONCE(!IS_ALIGNED(pfn, PAGES_PER_SUBSECTION) ||
>>                 !IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
>>                 return NULL;
>>
>> -       if (vmemmap_populate(start, end, nid, altmap))
>> +       if (pgmap && pgmap_vmemmap_nr(pgmap) > 1 && !altmap)
> 
> Should we add a judgment like "is_power_of_2(sizeof(struct page))" since
> this optimization is only applied when the size of the struct page does not
> cross page boundaries?

Totally miss that -- let me make that adjustment.

Can I ask which architectures/conditions this happens?
