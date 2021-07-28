Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F2D3481
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 15:56:21 +0000 (UTC)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SFu8p3025323;
	Wed, 28 Jul 2021 15:56:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=61/q3A/c/NyfXZlZoZlbOK2gwXdHfJfOkx8DX6q9I88=;
 b=Smwql1wEra44EXWSCV+9zl9t/DU8pMeIomEdk72nIkEH39xepdEg1c6KJg8azeNylxQx
 8WYxFuFRy+0lbhDcbQvWZ+rkJ4mk45wcBKNv9QraBBQewTpUympzJkBs/UkQI1x4sJ9P
 0lRAEm0tjRlVzLsLOlQtUp+YDI+gg1Fow2lS1LVE93QIEB43yaVmUpXLQbodLtpnT1Wu
 fuuLc07PFh4qSWO10jHWwK5mJjtXIHFjrEkb1ixTzW2oySEq4PCIXniP9x+95fimYz2V
 hfYAFqT6CMpRmqYCbvbSN8iyTsLu0wwnRELRZnBMVBbrcGYlZe1cvWj8LvlfnPkWF8AC oA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=61/q3A/c/NyfXZlZoZlbOK2gwXdHfJfOkx8DX6q9I88=;
 b=OFagvvAnxdHl+X+qbLYSa8pff7NfgRIhs+VX5ZgbAAibsis8kRIQWY+4KtEv2kqJg54P
 ySWNQ5cCPFJ43ZCuTyeA8xWwLZYVSaMg8OqXvrnnNW3Oe4XpgYlpBulMbLtp+0Tog1E6
 I2Snu63tuB0R/mzPQ6d99euCDJ2Kx54R8GNMYw/WvKMBGPx1XH2oCIQEjXIEIr2jE50A
 RyPPCRl2fBnH8N5fVo/AB7p2GSoEUhpfcti2B+wXFguk12iet/OcUbUGKF0ue+7dskJK
 eTFiS3yYt0JuyCsy+wakOZdiheovTvqOsFW/UIyXA0wkM2IEENe9mH9XxAe/DZ6G43me aA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a2356mv21-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jul 2021 15:56:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16SFtkGw180219;
	Wed, 28 Jul 2021 15:56:14 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
	by aserp3030.oracle.com with ESMTP id 3a234cr6ks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jul 2021 15:56:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JR3hxHYCG3T437qUFa3MNbmWsJneo6agvN2nMfW3c6R1qdwaILDzhUeB86Q0XFuRhMYmVQqhvCfErjNPK5GYUim8k9CTweHCdG891ceTVd+VOmFBP3jorxWU5CHin69aJif59b9pNCks2hqPBVndrHYeqZ2sYCMFYXEJhYKFDbE2TwuChnl4ktJDC5RGVmywFYRfwIId62YvbQibG+vE8QlJpqPIZglUsqmW2KNVSlsBeToRptWj/2gAZMMjbRxYfYFEx2+4f/rv627Sx5oqZwNGBz4LnrQ/NS+l/K8z5kxqQ99dndpYn2Univ4NAvGk2M3gytR2TqAQ27skX5L5pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61/q3A/c/NyfXZlZoZlbOK2gwXdHfJfOkx8DX6q9I88=;
 b=eojB8RmWxrI6/I2ZnYsPq49okxYkHzh0bra1TNcDKzI86rugFLlFzWU9YH8qKMIblbNnPJP6u+hXzo0OYXHz6tAbOvkapmoJp37lJFL+SYReKh3vZj2/4no2a/CjsCGx2e2igIRQYuJEaOh6dKaPhqUDMJGHJSPVCqx6M1OWL1NF7NgVMIDdtJqk39WzBV27joRMhNejriWwcvMs85zkyZzWlZzvJNKNd6oRIr3yKJUoUv25sg9G5xSfLb+Wuzy+IP/EoONLQNb0cWunpUfO3Yu6QNDhT/WJJjKfM4CBF+7KBZViPfAFEMPAi4+libLON1+GpSBOAx0wuHPghAfpPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61/q3A/c/NyfXZlZoZlbOK2gwXdHfJfOkx8DX6q9I88=;
 b=GFWJmqmdBVPPvWWXr4larcRDFMovRM7oAIeCJ8tM068SV/dzlxtXqAjkXerAju64VKIlFybpTI2EL2So2ozByudftOlobTaUdxxHxghPauaExEQq5VeUbLbBa9VPqfid45iU5RdpGLLvHem418PB3+/KZWRZK9N3WKPq4qTHrIQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3965.namprd10.prod.outlook.com (2603:10b6:208:1b8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Wed, 28 Jul
 2021 15:56:11 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4373.020; Wed, 28 Jul 2021
 15:56:11 +0000
Subject: Re: [PATCH v3 09/14] mm/page_alloc: reuse tail struct pages for
 compound pagemaps
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
 <20210714193542.21857-10-joao.m.martins@oracle.com>
 <CAPcyv4gDndA612+1BKZcR518K_Rt3Q1gWpqK24KOqvoFp_PNGg@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <dd8f9a7a-1036-bda9-73a0-a2c6bcad5a56@oracle.com>
Date: Wed, 28 Jul 2021 16:56:04 +0100
In-Reply-To: <CAPcyv4gDndA612+1BKZcR518K_Rt3Q1gWpqK24KOqvoFp_PNGg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0136.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::15) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO4P123CA0136.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:193::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Wed, 28 Jul 2021 15:56:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2f57039-0dd8-4091-dbc2-08d951e03854
X-MS-TrafficTypeDiagnostic: MN2PR10MB3965:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB396559FBE030638F2AA715AEBBEA9@MN2PR10MB3965.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	LQAQ1vGucefjqTYGTBnb1U0nBaL1x7ZIlWRu9cLtPsGZiH23D7wK2dJfJyW9gd/dhYryqB26b/bJLFD3QhYoedWeWxgjrNRqG0gy1YHR54FKAdDMKG4gXvaVO9AboGfktL4mozbeKXY+t8KyZE62iYnxTeZWVMRj4RRQ5V8E7fTG2NQ+7jo7NJU9CN2M6GluAoT888nx/rsb8ne1RYXGWjJ7YMgqZSzzkt73eYBiZhTYMuSjbRI5Kw6B6/boTpgTud+3VsaKAy9TB88PYRwtwDtR41FwI0PGsEM6UrIts434s9gQBdBZdhUbAWC2Ql7n6wPwsfQakODTauXEOwvMfhK1Jyj94uwcW4CV6U1jdQkOwfCq2JnKs/dppxbNO44koZHxZXjq8kAbmWTdGvSxKbpv9sCkPbBUS7ujRDgwUw86y1jd0ZIZXhvqgvwUAIoKJ0kWa/oYOjkDJLg1soUTfxiFKzDFzT5qUfirHmDAJQNc8xytzVru2xslKPjjwx4W+w1CsYnMWNn87Aoljt5pkm0/5LlB6cbwPZmMHTAZgNADDNqrrff+APGONhZm3AqRULHDO8WGnnwJCEr9QTEFAk8JeLUxi2xayk2RrcN2XuQtkQ8qwE0y2dR4/m8y5ckmHz5Ndpg3TNIZyMDPRgYOJ7MHWTQnSjz/WTvTtohvkrYnHDL/eJOM5DtVTGcKvKP/XakPPLCxFGMqZF+YDJKgd9ImcIdPOUyAJ//LCqwxyglOr60wgdFTJjI/AnBfeukgiUlC17yC4f1l64JFU4nztItO3cu+Mo9gXb8et/v0Dwk=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(39860400002)(396003)(346002)(366004)(186003)(66946007)(6666004)(53546011)(7416002)(26005)(36756003)(38100700002)(66556008)(6486002)(31686004)(4326008)(66476007)(966005)(6916009)(8936002)(8676002)(478600001)(16576012)(316002)(54906003)(2616005)(956004)(5660300002)(31696002)(2906002)(86362001)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Rm1zd08vR1RLUHBGUEZ5Z0dVRFBxdElLaFphalhic1c1ZnZLR2JUazVaby8x?=
 =?utf-8?B?V0tsbVhQSitwbk9QRUZWZk5PbVQ3WTh3Ym4wa1Z1Szh6bGdMQXUveHlmR1hu?=
 =?utf-8?B?Wk5EUGJFTFNDT0ZUbHMxR3BNQlBENno4Mkt0S1NIemE1MG84Z0Vhb1g0YU1C?=
 =?utf-8?B?R2t2alFmVUJkVUp6RVpYQnl1enduQWhCc0E5d0R5UmJyRHlVVHlLdTJ6RzIv?=
 =?utf-8?B?SjAzOHF2aWFRZ1hhOWlqcGg5dDUycW5lWkczZ3UvVlJWRWtxaU9WQnl1Wnoy?=
 =?utf-8?B?OGttY0hSMTl1Zndadzc3U2V6VUlqZUdBVjhuOUR4YTlzTlg2UHJKaXdhUU5K?=
 =?utf-8?B?bjZjMGhhbnR0Y1RKZ0tORGhOa3c1NzVFWktvbFlpYVF3TDJmemVIcnVwdVg1?=
 =?utf-8?B?d2EzTWgrbzYvQklCai9qdFgvMEFGV0dDWTR6OFJXZ2xnemlWdnBTK2tjUnFn?=
 =?utf-8?B?OUk3Z1FLNUR3V0VpZkx6MmR2OXRZVVhnTHJwSEc1SCtMcDFnZHliS0x1bG1P?=
 =?utf-8?B?dlVNSUhEd0dVM2tyMGlQUFFXY1pmOWdtOE9va1N2Ly9aaXdPOWxIL1pwR2ZL?=
 =?utf-8?B?VDlaTzg2eHB2cGppTmtsMVJXM2pJUHltRTVyaTgwRFJhMTB3SjNpcmtsYjdx?=
 =?utf-8?B?M3BJYU1zQmdIeW1GU1M3VE5HRG1HaWJ3M0RhT0ttbnE2NXNsZUlzMDRQVkVW?=
 =?utf-8?B?TXdwWHRueVpDdmF4OEZHcFhmWXd6QWJKb2cyVkRscDd2K2JDSzc2bW1qSlJk?=
 =?utf-8?B?MjVxQ1JpNWVoNWJ6aHBTTnltZWIyZzBzMFJXaEt1TzhzMU9MSGMyc0cvZXhP?=
 =?utf-8?B?Mmd5UzkzQ3pWRzNBbUR0MWFoVGl3T0ZXL203R2ViWnlJUmZjQVV2eHJYYXVJ?=
 =?utf-8?B?Vm9CWTJSZkd3RW9pRXdzUXRjUkFjUVFJMW5zRGdTRkJPZVEvV1JZRjlRekFo?=
 =?utf-8?B?MnVKdS9DOVFwYWhGRVNmejdJNmhmbk90NzJ5VGdQZjhwcjlSVGJKWG0xcWFq?=
 =?utf-8?B?b25QZjN5dHFPYkNFQURmM3M1TTZ2MFdnY0lzRXovaUttTHNCaXpqZzBrVGZR?=
 =?utf-8?B?ancvaFNIWUJFWHRtTklmQnBuN2JxU2ZkcDBXcVdyTEcxZEN5ZUFXNWlBN3Jw?=
 =?utf-8?B?c1dBalorcTBxbWQwc2Q0ZEdCOWhPYm9NRG9BSDhOZVdNSFhwcU9RUHEwWk8r?=
 =?utf-8?B?OERVZkQrUCtyZFVPTzlOVW1iZmcwWXY5RUo5T2R2WlAwSndkZEdBeVdvV3Ru?=
 =?utf-8?B?bVBXMWh6YlNUMWo1OE4wVDAybGZTNm1Hc0xNYU1IM3FmZ2tiVDh3N1NrRXVZ?=
 =?utf-8?B?SlArNkxtcUVESmc3OFlNZC9KaXFUK1FDWjJBY0JXZ2VuYVJSZEVxSHFWOXM0?=
 =?utf-8?B?Y0h5YUlyWUZlL2dCTTFsZzExa3FwNENCbWY0Nlh2ZnI2Qitick83MW5sMldH?=
 =?utf-8?B?N3VLOTRDSjhiQXB0MUQ0REVjL3dsdHg0YWZ4WGNiaVJiMWE1ekM0NG04VGNR?=
 =?utf-8?B?aS9KenZQeDZVR0xQb3g0blFudVliV09UYWtCN09TWkJqNnI0blJjanpwR1Zu?=
 =?utf-8?B?Y090dytPWXdYaXAxL0Zra1AzbXBUeHZPZnBvcjVsdTJERDNtWHozL2xtSlBy?=
 =?utf-8?B?Rk8rUzdqbEI4cUY1NXlYQUgvRjdBNzNQQStGYndlVUY0RFgyT3RWdWlmV0NZ?=
 =?utf-8?B?dDZqY3pneTMvcXhHd2Q5NE5lcWIwVm1NTXNFWXVJbS9GKzJkbVhDb2NLY29k?=
 =?utf-8?Q?Y0i1npeGsSYRWmrU+6DEm/dNW660iUfU3p6XP/f?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2f57039-0dd8-4091-dbc2-08d951e03854
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 15:56:11.2849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fP7yCkEpwmTVAQMsURYnUhT8PD2NHBHSDn43dFnzR6+5wgTnkKuTbTgjn6bjkR5IrfD34G9OgPogy5UYG80fX9hVMCobrwnV5dAp4ER/xXw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3965
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280089
X-Proofpoint-ORIG-GUID: 7d4FCnUaugU4-cJOGohCU5EYnMkGc2jW
X-Proofpoint-GUID: 7d4FCnUaugU4-cJOGohCU5EYnMkGc2jW

On 7/28/21 8:28 AM, Dan Williams wrote:
> On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> +       /*
>> +        * With compound page geometry and when struct pages are stored in ram
>> +        * (!altmap) most tail pages are reused. Consequently, the amount of
>> +        * unique struct pages to initialize is a lot smaller that the total
>> +        * amount of struct pages being mapped.
>> +        * See vmemmap_populate_compound_pages().
>> +        */
>> +       if (!altmap)
>> +               nr_pages = min_t(unsigned long, nr_pages,
> 
> What's the scenario where nr_pages is < 128? Shouldn't alignment
> already be guaranteed?
> 
Oh yeah, that's right.

>> +                                2 * (PAGE_SIZE/sizeof(struct page)));
> 
> 
>> +
>>         __SetPageHead(page);
>>
>>         for (i = 1; i < nr_pages; i++) {
>> @@ -6657,7 +6669,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
>>                         continue;
>>
>>                 memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
>> -                                    pfns_per_compound);
>> +                                    altmap, pfns_per_compound);
> 
> This feels odd, memmap_init_compound() doesn't really care about
> altmap, what do you think about explicitly calculating the parameters
> that memmap_init_compound() needs and passing them in?
> 
> Not a strong requirement to change, but take another look at let me know.
> 

Yeah, memmap_init_compound() indeed doesn't care about @altmap itself -- but a previous
comment was to abstract this away in memmap_init_compound() given the mix of complexity in
memmap_init_zone_device() PAGE_SIZE geometry case and the compound case:

https://lore.kernel.org/linux-mm/CAPcyv4gtSqfmuAaX9cs63OvLkf-h4B_5fPiEnM9p9cqLZztXpg@mail.gmail.com/

Before this was called @ntails above and I hide that calculation in memmap_init_compound().

But I can move this back to the caller:

memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
	(!altmap ? 2 * (PAGE_SIZE/sizeof(struct page))) : pfns_per_compound);

Or with another helper like:

#define compound_nr_pages(__altmap, __nr_pages) \
		(!__altmap ? 2 * (PAGE_SIZE/sizeof(struct page))) : __nr_pages);
			
memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
		     compound_nr_pages(altmap, pfns_per_compound));
