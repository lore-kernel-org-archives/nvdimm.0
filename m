Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D763481
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 16:13:05 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SG6mIk014207;
	Wed, 28 Jul 2021 16:12:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=q6lyXB+9jPjCS3Viw1jud7WX4KWx6FTj6NYndrK2AKI=;
 b=MaJUo9drAYdxtlrYPhEz3EB+bRalqHPmiqtbDpBFWFVgBkJ1MTFrQWqjazj4Nn6MfnuE
 wLPeJW2/g8cSAlnR1iLeDjnFWKqKZ1NCSs6T8abk/y5tLUSfN9vIVzZRvq0B9Ta0Qt3w
 bvUirvCzt1Y22TKvnTdHp8PLFa6yMYdPtW2CAyG44j5epwiMZDZgqdXYWNnfIh70s2Zq
 9I2LVBhc8jbssyNsh9SxGEqGvfZxZ/p22pVPpyCP3Wdk8USaAx7EJ/3eradm7XhvX/Iy
 +AzIyu7WNVTqNdYdU388Ab/0UiauQXTzDxxRTp9FYTcLO479sc3xI2mQCkn8xw8g38b3 1w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=q6lyXB+9jPjCS3Viw1jud7WX4KWx6FTj6NYndrK2AKI=;
 b=F7Iup52vMLazJkAjwxWa9fvGLhgq+trw3XDXrArXJFyCzLC9q6vvRVVzJ7O3wgnyETvv
 uhra9y1McwuktOA50H0x/d3QDKAgetzpxcPBpdveycOjEqG7xToySOTxlZfdxRB6gv8K
 llsqv1Ng9LcUBnl+a8OZQ3hdH4ORzpEKG93Ch+OPxPJVuO3HOT6Rdc79fNdY70FAqS2W
 oHbFdBQAvxdk0Vx2aof0egsdNTKfZ+ccslAFpnf33kn21SaXtS2S6DApTd3ypOQvtPM4
 rw+19KV0V35Nuin12OUygRoOW/qVR9S/NS0SZ8awNuEM3UC96sEh/6xonwwYS5ncCfLn 3w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a2353cwjq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jul 2021 16:12:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16SGAw1k060284;
	Wed, 28 Jul 2021 16:12:57 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
	by userp3030.oracle.com with ESMTP id 3a2355j4er-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jul 2021 16:12:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ye28rSionHSco0lb/jbPXGDbxFIUjRr+JF2dZbuNUCCs6K/EZ/WqQaJ9nZQ40S0rCevmYdLRkxKk04+SUMj8LdTJLnYeLBQB2u6N9tNDAac/pK1A9cGQjAkDqjKsmyPXLi410DkEb+js0zKBjIKROHlprRCxmAKVUbM69TdhYshcSV2I63bjcbLRAVRjHTwykSuLzr6vcyKqKAqwCn+NbeLkb5noBGokjX/7OJlsHJmAFhi/mh6EPI3cCBxnatr+1aNQ+M1URL+NXI0uGJF/y6FMkiXnIV4IjxZnn2wp79+6bQy2mUiB4UFCkZamAOX0qdIgNmv9EWJuE8FIoJQdyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6lyXB+9jPjCS3Viw1jud7WX4KWx6FTj6NYndrK2AKI=;
 b=Gw5z/PINQ09IHUcnz0DQjcviMKFFvIkz/yRJHZnERdk26+F6mkm/KKVpmIq10cVxL+y8Wg5vIc3tFJSigaX0+KLgb0cWRpTnM4XjTKWeg84dVaQLQdF9k6uOv6jg8BEXBrFp22m7LalQgQg5mEjv/N9pvVAzR/LoJn1vWNeBeyEtBCJxzPB6WQPOuMW3cCDliOgvNe96grZG60ZFgb/zr7eOD3M0QULACg/dH4dRjfn0kCRW7bGaompPE5jL6KaaAxV7bq7gpk19cIK6Wmcjf2ns77cW2uwQtWdFn0sXVMcD9Xzb5FaaMXNqlLJ7yEkMyNnas1mwynUyyI57YBFi6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6lyXB+9jPjCS3Viw1jud7WX4KWx6FTj6NYndrK2AKI=;
 b=IcJ2bAGiaBnWONPwegSSE6VJUEQfcGi3IKZ+MzdZVMydXO1CTwbdFPbCE7Xsmmdt+PD9U5vSioFn/X1qmtb1UzSCwrqrmExV6QebQU7+v3QwM+dWnuA0yn+CM8CaiTay+5NHXnMe58Lv+yFjmbXTbXBl5vGhybwnJ/U6I7/1cq0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL0PR10MB3059.namprd10.prod.outlook.com (2603:10b6:208:74::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Wed, 28 Jul
 2021 16:12:54 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4373.020; Wed, 28 Jul 2021
 16:12:54 +0000
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
 <dd8f9a7a-1036-bda9-73a0-a2c6bcad5a56@oracle.com>
 <CAPcyv4iROoeKcVTKpVyUr+hrmKJxj7QnCS5pGPAnhLDvChHXJw@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <6969bf47-2405-a3bc-59c6-5dd665bfb70e@oracle.com>
Date: Wed, 28 Jul 2021 17:12:46 +0100
In-Reply-To: <CAPcyv4iROoeKcVTKpVyUr+hrmKJxj7QnCS5pGPAnhLDvChHXJw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0247.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::18) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO4P123CA0247.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a7::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 16:12:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef2a0a6f-e450-465a-f537-08d951e28e28
X-MS-TrafficTypeDiagnostic: BL0PR10MB3059:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BL0PR10MB305909261DC522E73AE73ADABBEA9@BL0PR10MB3059.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	knmfxUZGL/VgMiYrImQ3x+hhunB4DLvXL0uTYdogcsO0TzE7udZwyEGVWine1OjciMkxUa+5oNXbjJtKeYupw8HSC5kdAgeJFQ2sfV/iVgvX2YAEa81cp72Y64pTBTnsCMdM5P8AVO1Y4ER4RzZfy3kFZgJg/BeU7tF6/lCaAQ69wBXJ4XSyIKY8bjGWKfIa1RjuMR+L9IOfDWhsTcpRe+RhJLvn/46j4V+2FYpDE6665HIqAVL6u6aKouDIIl/l6b8A5IS1SnJQ3Cuef9zX2EA6PfrqoFUMLNp4wzAui48wbgmesWA0qKvemg/8AMYOW6cJMbfdCZ+sA4CCdDsUWjgrQPZAzSzSyOxHvFp9uFzgyT493S0lVWjOiOZK2lKyAX4buUfpYYDK46MJ+uOxVR13YbBMmtaENpkxvlbzcmk/iby/ehXp9IYr56MI5kMfGejS6VcnJ5hEEDZq2KDwyxDDDCJAjcsRGP9wc3pszvyEdnYLcn2ghsT03rqAQVkvwFr7hxvICaIwpFr+xJn47zRY8t4PcdMRCJN7sI/hJxPL/IS9euqCoEFGILpRwmIQA4lj8e6p36mc8GLMayxul4qVXsqtj5aLBOx6m20Qe1xJpECOKSj/QP+JE7qQ+0p+Hl0scN50rQ3GanYAEbUAi9xoNU6d5hyj/N51Z63zAAVIY8yWMtwtA9IFeWj6deomMRweo3Cg//BaZ9NOjzejP64CEoliSkV5cYjND2LtuWs9zYTgX+yoCvPa04i9MYKnmQg2vx39MQU6oz8oOWpUEugTETO/quaq/lgqJbqii2g=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(376002)(346002)(39860400002)(83380400001)(53546011)(5660300002)(2616005)(2906002)(956004)(8676002)(7416002)(316002)(16576012)(26005)(478600001)(6916009)(54906003)(6666004)(66946007)(86362001)(66556008)(6486002)(31686004)(36756003)(186003)(966005)(8936002)(31696002)(38100700002)(66476007)(4326008)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bjlTMkdNL0Q1MjhSTVdpajhLeElPZUNmRktacnZFeE1jN1FxTDRVZGRYV0RI?=
 =?utf-8?B?YlhSdFc1cVNEWUVHOWxvdEMyV2xCTkhKT2R6REZxaTRxdXNobWVlVU9hRGcz?=
 =?utf-8?B?SjVEZG1xa1RyNG5YL3FncnhKRkdVRDdjOTljdXMxREVYYWozbXhPWEx0ZTEw?=
 =?utf-8?B?MmNoZUg5S2dHMnk0b2NSNGFpSUptOGJLRnRGa2FRWVlHRW4rMzVxTkNkUWdw?=
 =?utf-8?B?T2M3N0RmaFNnVCsrc0V5V2lxSHRuN3c1b3BNdTVZOFQ2ekp2SVBibHdBTUE2?=
 =?utf-8?B?b0VrL3NhckVYa3UzbUY4QTJNSHdFNXlKdFlYWC9IakxEQ2RTSmNlekt2NmJI?=
 =?utf-8?B?R1BNU1RSK0JRT0RLMVdDSjR6aXBUU1Fpbk1Cem1Wd3hoNXhTTzFnUG5Mc0Ju?=
 =?utf-8?B?TERaeVVpQjMwOVViWEIrVEhPcXFtTEJ5WXRUR0ZDMGRUWkFzd0JlTXRadHRV?=
 =?utf-8?B?cW1HK0hNemhFcTVzQmtlVzN3NzEzRnQ3MkdVaWt1Tk5FYU1CVWFNUlhpVW1Y?=
 =?utf-8?B?aFI5MHhyRHFGRUtJVFRwMm5mOFhDazEzdHFxbkc5ZDlmRjNhVGdoZXFjaW5T?=
 =?utf-8?B?QkJaYVQvUzdDRVlMYmxlMmtxWDRhNlFwU2dwdEJTUjRMcGMyRHlWOXM1Q045?=
 =?utf-8?B?Wi8yWDBYRzg2Ym4wR0pNWDViY3FnM0twUDZNSUJzUmg5ejFMWWhacS8xWlJ2?=
 =?utf-8?B?ZDRXZk9nakU1cnBBV0ordGVDYzNwVDQwU3JlQ3FmdWZHdXpaaHVjSUxmKytt?=
 =?utf-8?B?djdqL1Q5d2k0WEpjZkJicGpFUG5CUi9zVTByZ1cxWmU2TFQrMWVMckVDL3g4?=
 =?utf-8?B?RURqTmxkOEo5cmxzamFONVRlaVhMQzRKMll3OGZmbzB3N1QwVnZJRFd2SDhF?=
 =?utf-8?B?amcweUtGdlNaN3N5bFFhajBQbTI2SFNEU2RYMkZNbFVTSHFuL3JNRnpjZ2sy?=
 =?utf-8?B?NW9SYXhYU045QmFkMytYOTFrMTlWdGtybGkxa1cyS0J5dEdmSlcxRS9NMnMy?=
 =?utf-8?B?OGJFQ3pKSStSNWRiZjhadEhPelJWSnFNeVh5SjNTMURCYWJBTmgyL1ZJZ0R0?=
 =?utf-8?B?bDUrbDhDQ2VTQ2F1U2NpU2xsM0tEWCsybTc2VkdLaHdoTXhDdjBUNC9Ra0VK?=
 =?utf-8?B?dWlBSUFKeEhsemFsYmF1WHFBaGNhUnJqdUVRQWx4VE9BeWtJYVh0U3BaNXBR?=
 =?utf-8?B?QXM0SHRCWVNLNllpMjdjOEQ0dnRMQml0cC9VVlEyVWVPQ3BJYUdlV3g3Y3Ri?=
 =?utf-8?B?dnd3ZE9WM0Q3RnhBL1NpSWFENlU2aFFrRG9ERG1qQndvQ1dXZlRYZEV0d3FZ?=
 =?utf-8?B?QVVrb01Sb1RwV01rVjNWVDZFY3VQM0kvazQ3eWwxV1pjRVAvbDFJWWlLeW9y?=
 =?utf-8?B?OW1pOVlueUpjV09WLzBoVHZjMnMwLzYrb2JldU1FaHlSMDg4RXQxcjQzZ01P?=
 =?utf-8?B?YVJjZjRWTmsxbWc5OGpwZnZ5RnQwNmJ3cnhNRDVXazNQNUtIS2haR3pra1Vk?=
 =?utf-8?B?L1A5V3Azdk1PdVVKZ2NqN3Z3djExaGJMZWtJb2JoVVZJcDF2OVd3UzBKdUJ6?=
 =?utf-8?B?VlMrWkV5WW9WNllKVElwRFdDMlZaeWY4V0VHRWVrSVFGL0ROZWNPdUZDWDR0?=
 =?utf-8?B?THBkYzNIUmpIYTdKeHAvMTZIT3hiWllGcGp5S09JakNvTGYrRlNQckFIamRU?=
 =?utf-8?B?d1cwUXF6QzZWQm9IZFdRWnhWeTB5YW56UVh1Y2dBR2JKTVZpajBWTDVKZEZr?=
 =?utf-8?Q?RQpmMznzwdbg1VzoNZcFf9ThmDwRM1DBT1Bq9TL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef2a0a6f-e450-465a-f537-08d951e28e28
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 16:12:54.0368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UAWFzwPcKTAi8yTNYziKqe1S3RejAk51Ks3RcxMUBWS0BpE2eyQLIDwsZHFGvdmXIQw9BNXqAS9GiZIxvFNmiAQ0KyyatY0zyw0tKMXLYDw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB3059
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280091
X-Proofpoint-GUID: QGz54-xczF-jWZS3HF-lt6Y1hwsLPo3D
X-Proofpoint-ORIG-GUID: QGz54-xczF-jWZS3HF-lt6Y1hwsLPo3D



On 7/28/21 5:08 PM, Dan Williams wrote:
> On Wed, Jul 28, 2021 at 8:56 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> On 7/28/21 8:28 AM, Dan Williams wrote:
>>> On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>>>>
>>>> +       /*
>>>> +        * With compound page geometry and when struct pages are stored in ram
>>>> +        * (!altmap) most tail pages are reused. Consequently, the amount of
>>>> +        * unique struct pages to initialize is a lot smaller that the total
>>>> +        * amount of struct pages being mapped.
>>>> +        * See vmemmap_populate_compound_pages().
>>>> +        */
>>>> +       if (!altmap)
>>>> +               nr_pages = min_t(unsigned long, nr_pages,
>>>
>>> What's the scenario where nr_pages is < 128? Shouldn't alignment
>>> already be guaranteed?
>>>
>> Oh yeah, that's right.
>>
>>>> +                                2 * (PAGE_SIZE/sizeof(struct page)));
>>>
>>>
>>>> +
>>>>         __SetPageHead(page);
>>>>
>>>>         for (i = 1; i < nr_pages; i++) {
>>>> @@ -6657,7 +6669,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
>>>>                         continue;
>>>>
>>>>                 memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
>>>> -                                    pfns_per_compound);
>>>> +                                    altmap, pfns_per_compound);
>>>
>>> This feels odd, memmap_init_compound() doesn't really care about
>>> altmap, what do you think about explicitly calculating the parameters
>>> that memmap_init_compound() needs and passing them in?
>>>
>>> Not a strong requirement to change, but take another look at let me know.
>>>
>>
>> Yeah, memmap_init_compound() indeed doesn't care about @altmap itself -- but a previous
>> comment was to abstract this away in memmap_init_compound() given the mix of complexity in
>> memmap_init_zone_device() PAGE_SIZE geometry case and the compound case:
>>
>> https://lore.kernel.org/linux-mm/CAPcyv4gtSqfmuAaX9cs63OvLkf-h4B_5fPiEnM9p9cqLZztXpg@mail.gmail.com/
>>
>> Before this was called @ntails above and I hide that calculation in memmap_init_compound().
>>
>> But I can move this back to the caller:
>>
>> memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
>>         (!altmap ? 2 * (PAGE_SIZE/sizeof(struct page))) : pfns_per_compound);
>>
>> Or with another helper like:
>>
>> #define compound_nr_pages(__altmap, __nr_pages) \
>>                 (!__altmap ? 2 * (PAGE_SIZE/sizeof(struct page))) : __nr_pages);
>>
>> memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
>>                      compound_nr_pages(altmap, pfns_per_compound));
> 
> I like the helper, but I'd go further to make it a function with a
> comment that it is a paired / mild layering violation with explicit
> knowledge of how the sparse_vmemmap() internals handle compound pages
> in the presence of an altmap. I.e. if someone later goes to add altmap
> support, leave them a breadcrumb that they need to update both
> locations.
> 
OK, got it.
