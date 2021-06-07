Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546EC29CA
	for <nvdimm@lists.linux.dev>; Mon,  7 Jun 2021 13:49:12 +0000 (UTC)
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 157DiPRg125623;
	Mon, 7 Jun 2021 13:48:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=8Yv2Lb7PFLg/wBaFhbdBQPxkN/tulUZr5wanU+WR5/Y=;
 b=V96eGfTtd26A951HRIlKOid6+g3+tMz7RV238MQgWW3oIg7fj0N46v2r3xFNd0p2LRnB
 38vSp8dRV2PubrXd+pkiB18TPuQosEsK24XJ4/vJHEfGGft5sz3DCiNd5+AI+O4T+GGq
 8g48kVvcse3eQgP+Dg/cTwDK8H+RBdR0N9I4VHgxa4laafag9RIQA08/jZlpfmwBt9kC
 0xs562HsWT6mRC85zF6VpMKLAdPPVsZYQ1JV6ZFnl2a8xaDLOr4cG5avXQ3jj49Fd2fE
 LsDxsmmHUskf19ASbhOTuLTJTgM9JwB/LjQgH6kN5wObWpHGjXVx2oFFKFKziuJ6zNa5 BQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2120.oracle.com with ESMTP id 3914quhm28-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Jun 2021 13:48:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 157DkI7r191002;
	Mon, 7 Jun 2021 13:48:41 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2041.outbound.protection.outlook.com [104.47.73.41])
	by userp3030.oracle.com with ESMTP id 38yxctv738-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Jun 2021 13:48:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JXPd2lcYT8kCOjYQubCJLp9cicZOByfimxqhmp60Fa12qxNbWZJLUzLVvlpaGb6XDIEXiqVPi+/wvcl5y9z4kIxajK2+atRtns15+sRJ4HUmIWNmGLyKca+yRThhU6ivowjhUSyvs3iuVxcz5ZXfe0Lrq/p841FiqjAbfTaJsAZZgwAuA+JK5T3gwk8gRkr1R+K0HKPxXqF17rmiYz4JBhvnW45o5JyU82GP48idIUeTmWFCvy0u2mucnruj40biEUMlZoACzTT3d0Ox8I6x1TMfriOhJ0x4SzFuax/rAOdJH7HAvH2egTIqmDdCdYHe+vv4+jyb5uGzPZ/mbKOsBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Yv2Lb7PFLg/wBaFhbdBQPxkN/tulUZr5wanU+WR5/Y=;
 b=OJT37kTMK3Iqh0/EeceOuNAcVmNSopxvfTye9tiQjhFJLFJmD9/z5puEs0X8ThTxDJjmJFvvcGGxl5JFO80J7NW2opVNlIo2eO6+kQHhKBYcNu/80YLXQ2yATOxLQ2b9/miKuMWRATmTOqerpre5B4pnCDZGkQdESmTg8rUW8Ec33BCFfIRYXTv9NqR+bMd6DUNOfKu9wCG8giqq8OOoaTVdKgqAwkOvaJ8qz7wk279tWZ3vNVZhBWQNttx0aMTjirqJrrzlxp8n8jiooRvjaosaaIhq8iy0WGVsvs/SFguAiKPduJo8Ncx+kqADptplFUxjfAx7/nSEsMKap8K1Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Yv2Lb7PFLg/wBaFhbdBQPxkN/tulUZr5wanU+WR5/Y=;
 b=IkUYSRA07nC/G30KeFcDAFKgYQqotHcTk4MrXWc81dSreOhTn9DzkSYj9hqWz0L1fid2aOHkEZ1XVMmioZiSQ7phwmIBCX2sPR2ccvGINm+EYNrZN5UBIkilHmxwYaIeWRtIYw8W6PKeoFOfnwJTwc/83EGLWYc42OtfrN3vEog=
Authentication-Results: linux-foundation.org; dkim=none (message not signed)
 header.d=none;linux-foundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5137.namprd10.prod.outlook.com (2603:10b6:208:306::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Mon, 7 Jun
 2021 13:48:38 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::8cb1:7649:3a52:236a]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::8cb1:7649:3a52:236a%7]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 13:48:38 +0000
Subject: Re: [PATCH v1 09/11] mm/page_alloc: reuse tail struct pages for
 compound pagemaps
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux MM <linux-mm@kvack.org>, Linux NVDIMM <nvdimm@lists.linux.dev>,
        Ira Weiny <ira.weiny@intel.com>, Matthew Wilcox <willy@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20210325230938.30752-1-joao.m.martins@oracle.com>
 <20210325230938.30752-10-joao.m.martins@oracle.com>
 <CAPcyv4gtSqfmuAaX9cs63OvLkf-h4B_5fPiEnM9p9cqLZztXpg@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <840290bd-55cc-e77a-b13d-05c6fd361865@oracle.com>
Date: Mon, 7 Jun 2021 14:48:32 +0100
In-Reply-To: <CAPcyv4gtSqfmuAaX9cs63OvLkf-h4B_5fPiEnM9p9cqLZztXpg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [87.196.21.203]
X-ClientProxiedBy: LO2P265CA0030.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::18) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.125.214] (87.196.21.203) by LO2P265CA0030.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:61::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Mon, 7 Jun 2021 13:48:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ea72792-c825-433a-4b18-08d929baf41c
X-MS-TrafficTypeDiagnostic: BLAPR10MB5137:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB5137BCFA378BD2EC33CC9147BB389@BLAPR10MB5137.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	03wvfhNr8FJcWhqzEmxybklRzg7/JA1VSYx/9WjNsX3AalnkLs9YRh1Ewu6RZjlONuvl/okxL5fFMYFSZiD8qFhPeYURJDvYOK7EMkPUKFvtAUjp1rW/aqTdpEyrp5w2uatV3Xz7Wpfa53WcqSpFtWllBQZGwoixuwis9TOdlmd9IHRvzAu21zRcOiEZ41/E0mZ3azjeLYHAneqHHMo9cDWxfCRkcQCVBcloGH3fwIOmyb211lZGDUh3XDfwouvJ9EY+yB8Qr0SwgBbCj6X+hlCEYi+mFwYy/r/YjMmCMxdOIqySL+ImwIXxIs2eXyHs/QHFbOd6P+GvngeQWO7JaIi8IY/ClfsRoqaAfWe2xDoaFjsnbznpmJw+q1EUHUFB0wBSIee2tKfBlYNy1GP4nWNhyDQPdIt8LMfTfA409mfD23M0kPDCgIhpmd0YpEQav/NLRFg18/LlBMBMPV2BYHNizb2Xzh2jG+/sQ8O9axhWx6bImhikBu7JlLeyW5GJMtJxMbasqJ4xWi8lcK0/EAyQmxMbuhE4wQwI+Dh4aD2K49+DcMR7T7hP0p3aLo37uENNUu1g1Dibd4D3RGTqaMZF4Jgj3zozUC7d5WBynVHP0NjDdEu/psBE2IXphEhp+J67aFaFWO59y4lNNNjUeQ9Mr6eQWZM9AHPLOQEbemE=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(346002)(396003)(39860400002)(83380400001)(6666004)(316002)(16576012)(186003)(38100700002)(16526019)(4326008)(66946007)(5660300002)(956004)(2616005)(36756003)(54906003)(8936002)(6916009)(8676002)(53546011)(31696002)(2906002)(26005)(31686004)(478600001)(86362001)(66556008)(66476007)(6486002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 
	=?utf-8?B?QkJSUGNHbmVGQi9LVGpFYjd6Y0Q0dTVGVUdXbTZpelFrQnRUWU1xWlVaS1VU?=
 =?utf-8?B?UkM2VWIwbEM5bnZqTVl5dE1zdUtlV2VwT0Q5ZC90VTJBM0d2YjhtbktpaU1K?=
 =?utf-8?B?UFlRcCtzcDFZRW16N1hhUWNPZGJpTGpDa3FuMTRBN0RwRndlVlJrVU5BNWJ0?=
 =?utf-8?B?Zi9GRmtTMUxiSjEwOVVyMytTNW1vM0NYdWdCc2hiNWxQNjBkZVJpeGRXdXli?=
 =?utf-8?B?S1NoT0t4VTNnLzIzS0drS2lWbkJIakIyV2J3MWRLcWZmbTRvVHhYY1BmNCtN?=
 =?utf-8?B?MEp4VzBNUE1sQ2lxamFmOVp1QW9MSGlLMDdqU0J3TGRLODhFWTdVbHV5RkRl?=
 =?utf-8?B?R2w2bWdHclpkaVJSMXRsQ3pIZkRzTXBESFhVZ2VxWW1NSlNQUE54NExQdUNO?=
 =?utf-8?B?dDRwa0ZVMFRLaHJpREtPbVJUVjA0TTBJMXFkRlkzL29WUmtqWEwrVGM2Z2Z6?=
 =?utf-8?B?VklyRUc0QzMvQ2dqTmtJYmZ6em50Lyt3a1dpZGcrODVsclJtVFRNckRrTTUw?=
 =?utf-8?B?S0srNDZKdzQ4Y3luNSs4TkQyTVFtUlFSSzByV2o0dkVIb1VpRDA3OW1RSVNl?=
 =?utf-8?B?MEg5OFdBUXNaUFZVck9qeURycnB0RG9JelRRendsMXNMRHVaWGg0amxhMXdN?=
 =?utf-8?B?ZWFlaWs0Vm1WY05pblc1VHlVZXg0VHdYa2NaMzdRSnB1SU1aa3F2UnYvU2JZ?=
 =?utf-8?B?WXlwS1A5Q3RPRXF4UGZIdGtEZlp0ZnVqeE9KTmE3OXlqVHVINFdVQWYxc0dR?=
 =?utf-8?B?WnZzdkZQK0cvbkxhb2tLVXhNR3FxelBVamhnRTVNWlhLVmNXUXBnQjZ5eXhw?=
 =?utf-8?B?czBYakgvU1FiWjg5bDhyWXJwV1d6cVpMNGhWeHhIZmE2cktVN3pXRW0yTmMy?=
 =?utf-8?B?aUpCNmYzaUpYK3NyUXg0UFQ5MjdQcjcrSmNmYnMxZ1RBdXFVLzVwTjAvekJq?=
 =?utf-8?B?UVRIRXNLWk1ZSmtKY2lqdlA2WEw4d1dGQmt2My9LZFFYUmVPZGRoeVJqZ3Y1?=
 =?utf-8?B?YkRiTExjbUlWOUNIQnNRVVFaVWlmQi9PVTdraXh5WHBMTG9XVlRvUFpCZTF3?=
 =?utf-8?B?byswcnFNaHZWamYrQlJzRmFxdEVObERjTUNlK3Z0QWoxZWxJbXVLZWVPS2FM?=
 =?utf-8?B?QWM4K1BqZXBmaUlQY2RaRjkrT2JYK3lVMnNrMS9ERFZNZzMxYXh1ZTQrVFJx?=
 =?utf-8?B?UVozQlVWNm9qM2hva3gyc3FKdHJlcUwyMVJqa3RBaFEyRXBoRFFscTdjWTlt?=
 =?utf-8?B?NGNzbzRSRGtETmVWVHBETTgwNUJ4MjUybStUa3NVOVB1eVlmTHpMdm9nWDI0?=
 =?utf-8?B?SDlDNnVGeFQ1VzZ3cTRUM3M2R0oxY2VidFh6YkovT1NqamZuTEtGVkYxM1Z0?=
 =?utf-8?B?OXc1YzV5d2lLRGJMekJZT29PSTUzbi9BSXJqWUx3WS9pM1JDUk5xZWdTOVdZ?=
 =?utf-8?B?Qk9ReWZBdmZ6alhkUDJxNVdVc0prS1ozOTE2TS84K2dxZkpkQ3ZOaUlOQ2NF?=
 =?utf-8?B?cURNZFVxRHE2cUhWeWFoakFvcU5JVHhsOTFQUGhNaWE0UFJZUzV2bS8zR25M?=
 =?utf-8?B?R3Ywa0RLU2VvdVBnUTFhNVVrT2c0emxhRDRra3JkWEFWSlVKdEZTQWJaRDU4?=
 =?utf-8?B?dmZUMmJML2xXSllHb2VIMWtJZEZJeU5nOVV5SEpqd01aeXM3TW1CTlhkM001?=
 =?utf-8?B?WkRkM09uOWhoL3VmUy90akVTOWVsUm5xNFhIbjYzZVVoRk1oaC84Z05oU0Nx?=
 =?utf-8?Q?Xd7bHIr2oaMM7r+GFA+6vIzDc0Wq9W3pCEPD5yP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ea72792-c825-433a-4b18-08d929baf41c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 13:48:38.7738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kLxXkKuiTb83MHxmbCYAzA+FbkgmfUiWOoIaNoj1St6qa6JhNXgQh2czlh4HpQ4R0uq5qT6tXfBi5ctyXdvpJ0DkgnlNo3vfxQZyysFtusU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5137
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106070102
X-Proofpoint-ORIG-GUID: tI-GF2NBFFkDlIuf2CC1r3zjFGQbxHU3
X-Proofpoint-GUID: tI-GF2NBFFkDlIuf2CC1r3zjFGQbxHU3
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1011 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106070102



On 6/2/21 12:35 AM, Dan Williams wrote:
> Just like patch8 lets rename this "optimize memmap_init_zone_device()
> for compound page maps"
> 
> 
> On Thu, Mar 25, 2021 at 4:10 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> When a pgmap @align is set,
> 
> Rewrite this to talk about geometry rather than align per previous
> patch comments.
> 
OK.

>> all pages are mapped at a given huge page
>> alignment and thus uses compound pages to describe them as opposed to a
> 
> s/thus uses/use/
>
/me nods

>> struct per 4K.
>>
>> With @align > PAGE_SIZE and when struct pages are stored in ram
>> (!altmap) most tail pages are reused. Consequently, the amount of unique
>> struct pages is a lot smaller that the total amount of struct pages
>> being mapped.
>>
>> When struct pages are initialize in memmap_init_zone_device, make
>> sure that only unique struct pages are initialized i.e. the first 2
>> 4K pages per @align which means 128 struct pages, instead of 32768 for
>> 2M @align or 262144 for a 1G @align.
> 
> This is the important detail to put at the beginning and then follow
> with the detailed description, i.e. something like:
> 
> "Currently memmap_init_zone_device() ends up initializing 32768 pages
> when it only needs to initialize 128 given tail page reuse. That
> number is worse with 1GB compound page geometries, 262144 instead of
> 128. Update memmap_init_zone_device() to skip redundant
> initialization, details below:"
> 
/me nods

>> Keep old behaviour with altmap given that it doesn't support reusal
>> of tail vmemmap areas.
> 
> I think I like how you described this earlier as the (!altmap) path. So:
> 
> "The !altmap path is left alone since it does not support compound
> page map geometries."
> 
It's more accurate to say that "does not support memory savings with
compound page map geometries."

>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>  mm/page_alloc.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 3a77f9e43f3a..948dfad6754b 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -6277,6 +6277,8 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>>         }
>>  }
>>
>> +#define MEMMAP_NR_PAGES        (2 * (PAGE_SIZE/sizeof(struct page)))
> 
> This seems too generic a name for something that is specific to the
> compound page init case... more below.
> 
>> +
>>  void __ref memmap_init_zone_device(struct zone *zone,
>>                                    unsigned long start_pfn,
>>                                    unsigned long nr_pages,
>> @@ -6287,6 +6289,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
>>         struct vmem_altmap *altmap = pgmap_altmap(pgmap);
>>         unsigned int pfn_align = pgmap_pfn_align(pgmap);
>>         unsigned int order_align = order_base_2(pfn_align);
>> +       unsigned long ntails = min_t(unsigned long, pfn_align, MEMMAP_NR_PAGES);
> 
> I'd rather delay this to a specific "if (compound)" branch below
> because compound init is so different from the base page case.
> 
Perhaps this is not obvious, but both altmap *and* non-altmap case would use compound pages.

This ntails default value difference refers to the number of *unique* pages (...)

>>         unsigned long zone_idx = zone_idx(zone);
>>         unsigned long start = jiffies;
>>         int nid = pgdat->node_id;
>> @@ -6302,6 +6305,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
>>         if (altmap) {
>>                 start_pfn = altmap->base_pfn + vmem_altmap_offset(altmap);
>>                 nr_pages = end_pfn - start_pfn;
>> +               ntails = pfn_align;
> 
> Why would the altmap case need to init ntails, won't the inner loop of
> compound page setup be skipped?
> 
(...) Which means the answer here is no. The altmap case does initialize tail pages, but
contrary to the non-altmap, all tail struct pages are unique (no savings) and thus all
need to be initialized.

>>         }
> 
> Given all of the above I'm wondering if there should be a new
> "compound specific" flavor of this routine rather than trying to
> cleverly inter mingle the old path with the new. This is easier
> because you have already done the work in previous patches to break
> this into helpers. So just have memmap_init_zone_device() do it the
> "old" way and memmap_init_compound() handle all the tail page init +
> optimizations.
> 
I can separate it out, should be easier to follow.

Albeit just a note, I think memmap_init_compound() should be the new normal as metadata
more accurately represents what goes on the page tables. That's regardless of
vmemmap-based gains, and hence why my train of thought was to not separate it.

After this series, all devmap pages where @geometry matches @align will have compound
pages be used instead. And we enable that in device-dax as first user (in the next patch).
altmap or not so far just differentiates on the uniqueness of struct pages as the former
doesn't reuse base pages that only contain tail pages and consequently makes us initialize
all tail struct pages.
