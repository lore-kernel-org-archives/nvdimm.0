Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88292C83
	for <nvdimm@lists.linux.dev>; Fri, 15 Oct 2021 00:23:24 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19ENEdUW022054;
	Fri, 15 Oct 2021 00:22:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=cYm4xLw6+FmE8naPleOhhP6ILcmjssiHd39AiDH6SJk=;
 b=t6WRmMXqpvIUkLj20TLcRsIuaO7/9NobVIq1p01DwgKRZ1xitNFuOPPy/1YMyInMo/sr
 90pV4MxokW2JA+ujEDanu8Jh9VAmmTskqyVCVl2BaeLZBFHmCZwupXzlQog1pPDncBxb
 3FYS5QQfZrR7KZQ9fXGQu7xtwdrI+aplkZNq5JjjbSKeynXw4uqLHPA74HROVquNIhrp
 F1Ttjl2D86VtFW4YvttpIwpjrI2oD/fhAtt4hBqBOTc810KIx+AIWi70XzhWuyZmk/Oz
 MKS0ktAgsI3q0+FdYEddQcHjKy13g+GyOyGLVdg1Ac/D5dD9BB8M+3N4DD9bKmlldzKm og== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bpfvedunf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Oct 2021 00:22:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19F0LG0o127894;
	Fri, 15 Oct 2021 00:22:51 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2047.outbound.protection.outlook.com [104.47.74.47])
	by userp3030.oracle.com with ESMTP id 3bkyvdmuw1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Oct 2021 00:22:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QLBeF5olg/N7R1GHqQD2E9u/ZktNfN6+W6c7nAirOMDGBcFU2UXK1nHpIQ8ztUuxRHcvwMKbYz1TrDaHOReYpGl2FMpnKVc97Dqp5JRyHrFm3fczSbPevXiaOCIC6eJ7QFcbb9T8MCKZd9i1ZSdDRj+86lV0TwAGN0puLT3FiSVrpl9pPyCGi2NqTJ7v5S2fjou1keeYmHOxeOiLHJAjwtfWpCtYoo3VMrsR7HnK5KZNjSZ1djuId9nFBXyXpCdbLTpxAYpIj8ExZYDorIPdk2tST5S2+AuevDPHbpJ3vnSq6oAHG5U/8+IrPzCQQ6JZXtGXlQVnSGECOvoyGafvVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cYm4xLw6+FmE8naPleOhhP6ILcmjssiHd39AiDH6SJk=;
 b=V+r4q37qQRMiqitFWdTB+136zQbCiEYsH3VcDDTsoPNn+jkEIKoL3f2TFTkZA6q+L1LP5vOQ3vPdjuFC+IHvw5AQNIxiSQXurw6nzsQ94wD8JEEV4h4u2Y8XE6MbSaDf6gY/JsLlKZDUR7yfqSuYhCbA4qwbpb66PGJe9aEMsU9tWivlvtcAkeZG9EYEaJp+duw4foPut1GwEv4P9fisz5EPxcpOjnmfMQ57DomUY1CYZO9ib3HkhZCmW3S6BK5oW4rH6PD7MInVCNEAm5koRpBe7fHGbl35VzH2S4VO2ihQvvSjdavqBirrcsDn8Ds5+sPCv1vNQeCetD7axmJVzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cYm4xLw6+FmE8naPleOhhP6ILcmjssiHd39AiDH6SJk=;
 b=n/TIYlDZcBPPtOeWb2L+Lo8iJvmCT5vrpD5sPhw2/OEr/YHQeerYIBvqHzleNp+/DvtGXUxfbsMuiTIzHv2/jOZWZjWMEN59QAnVBTWwBggboRzXYykKypfMHPpnlJ2qPdDS3i/Oclbc2t1V9mo6Dm05wrOhDT3vIao4HtW+OSo=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4110.namprd10.prod.outlook.com (2603:10b6:208:115::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Fri, 15 Oct
 2021 00:22:49 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%8]) with mapi id 15.20.4608.016; Fri, 15 Oct 2021
 00:22:49 +0000
Message-ID: <5ca908e3-b4ad-dfef-d75f-75073d4165f7@oracle.com>
Date: Fri, 15 Oct 2021 01:22:41 +0100
Subject: Re: can we finally kill off CONFIG_FS_DAX_LIMITED
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Matthew Wilcox
 <willy@infradead.org>,
        Alex Sierra <alex.sierra@amd.com>,
        "Kuehling, Felix" <Felix.Kuehling@amd.com>,
        Linux MM <linux-mm@kvack.org>, Ralph Campbell <rcampbell@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>
References: <20210820054340.GA28560@lst.de> <20210823160546.0bf243bf@thinkpad>
 <20210823214708.77979b3f@thinkpad>
 <CAPcyv4jijqrb1O5OOTd5ftQ2Q-5SVwNRM7XMQ+N3MAFxEfvxpA@mail.gmail.com>
 <e250feab-1873-c91d-5ea9-39ac6ef26458@oracle.com>
 <CAPcyv4jYXPWmT2EzroTa7RDz1Z68Qz8Uj4MeheQHPbBXdfS4pA@mail.gmail.com>
 <20210824202449.19d524b5@thinkpad>
 <CAPcyv4iFeVDVPn6uc=aKsyUvkiu3-fK-N16iJVZQ3N8oT00hWA@mail.gmail.com>
 <20211014230439.GA3592864@nvidia.com>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20211014230439.GA3592864@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P189CA0048.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::23) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [192.168.1.67] (94.61.1.144) by PR3P189CA0048.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:53::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Fri, 15 Oct 2021 00:22:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1aeac407-293e-4b81-b71a-08d98f71eb52
X-MS-TrafficTypeDiagnostic: MN2PR10MB4110:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB4110A38F5EE700FB456224DBBBB99@MN2PR10MB4110.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	JkTyjaN4/bmWxgr5H5DtbGRMrGghrQkgkf71qHHwEOadULr3QDNGLiyqe2sBscoWh77jOe22dwjzjfCqBvdB0xthIZnB373v4xLt2IAOPZqFTpP6PI9ZOl82BbwIfUTHQDveQL+fkgu7nKTEFZaQ+XwkVSGW8YWdZZe4TePk/9pyQViG9KGVxJfSSb+QvCMKTpmJVESU/idOeHxIx4crT/Kxvq7h1Orato4sFiZa65z9UFm0FzlrxiOwk6UPYF6bNxVzVtGxU4JOgOvjmwNYeCNk8Om3zF5QMpcLLMa6aIdRDXfRdp7bXCsTY6bUjjWkaNnupFrSaRBkdWjKqVprnsxEgktRet4MqryJUhiUvjpezzKSG5P2sjPmeB5ZofnDbMAOcIVvTmLLwGgAQhauEXGvJRdQK44uqN8zsXtVsU+V3QqX4RftTaoIZwpusBT6g/kqSJDAjEVw88pKTeFfUPSPwOHtwfL67KL60HDoTDJpZ2f/GvoSBTagFHlj5TQaNuwx3wBcgSJEtmxnfkkpzH5sAUN6arPEYFXJ5BHXfHRqhP3LJ/1tkZloo2HYWo19LnW7ahhUfQ/8xUD7lcZuRI6pIgz836pnpWv+DO3igu3bhGzz4dXwMVkyJy5sWMtapIqUhpFhMfv12oaVzQFHexM+z1gJLIFwGAqMZHb0QRYLxcY00dwewLeZNb6710NiKX/aIHCxvvnUurR8rEEzOMC2yNPf9fVErEoYSscSPkM2SSSwLEHv+XlQ1Dkeco3IyLTDwR5xKAsbGuTPWdEBqZV4TocPb00aIQmYUCLg6ToX8qAcS/rkE4rEazez/OZEHJc5bmjeimQoKGq2jtW8NA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(86362001)(54906003)(53546011)(316002)(966005)(38100700002)(7416002)(186003)(4326008)(2616005)(956004)(26005)(66556008)(6486002)(31696002)(66946007)(66476007)(6666004)(8676002)(110136005)(36756003)(2906002)(31686004)(83380400001)(508600001)(16576012)(5660300002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?UjZscEhrT3NoTnFTQ0tEUWFwNVl5S3VFQ3V1M0dHYitySlArOWdzRVpOLzRR?=
 =?utf-8?B?em9jeXRlNGlYR05XczQvVTU3WTdFdDJ3UUZyRUxNL2dvYzBsUkMzN1dlbFZy?=
 =?utf-8?B?YkQ4MXV5T0l0VHlUZEFYdGRkYWVBSTcybDg0a0lLdFlLZHlQbHFGM2R0L2ps?=
 =?utf-8?B?M1hnQkd3c1pVMUxyb2NHM2U1NXhhc0UvdXp3MmZjc21WUDJnMUdZdkRoMlJU?=
 =?utf-8?B?YWE4SXU1ZzJmSzlUV25IcTBVajlEUStMdU5zWVRDbThXSjlYL1ZQVW54STlZ?=
 =?utf-8?B?bzN2ZTVWR1dIZHlTRzhOSThJNXZmUURmYWtJblRRMWQzT3JWVjhvZkhZM0Qw?=
 =?utf-8?B?V1ovVjRDdUJRTmROdUw5UU53a0hObU5ybXc3TDRQQWs3MVlVTkJZYXhrOFdY?=
 =?utf-8?B?UURpVE5oQUtzQ2ZJOTc0cVdYcEJqWFR2NFlnQnJ6SzZuTmszaktqa3pKMFJL?=
 =?utf-8?B?MXJvdFl3bmhoOEtxQ1BMSVRDQXlJc2k1M0RUZTlzc3FPWnhZaHpibWtQT1JB?=
 =?utf-8?B?d2taOXBJcWd5RzNGZ0RIOW9CNTNuQ2g2WDI5NlRFVWtHY2ZBMGtzNktGdFZD?=
 =?utf-8?B?Vk1Zd0kvUDVlTjdrejc4RXozR3htMHNoUHduYW1RVnVvWklkNU5mUjY2MWNO?=
 =?utf-8?B?UTBVcjR2NmoxMkVkY1UzU1lBNTZsS1JLZDdVcDArRjlnMjRaTUNYYjRVNHBp?=
 =?utf-8?B?T0Y2bVkyMHR0R0xMQi9TY2pJQnVqVWhQL1R4WGMwdXd3M1JHWThjOU1TcWUw?=
 =?utf-8?B?WCtzVUQ3dVVKNmgzK1d2WmI0b01CWUY3YmFBZlYrSGRQcFRsU1pHUTNLZTVF?=
 =?utf-8?B?MU9qYXVFOVRxbkl0N3FFOU1NVXVlQnJvQlJoenJwMzBwbVlEVkRqS1F3Tm0z?=
 =?utf-8?B?R01zR2VOODBnWVhLR1R0c0lSUGswUUNjbTZwRlk1RHlFMXc2MzZxOU9sYVdk?=
 =?utf-8?B?QVFaM2EvU1RrL2NhODBxZXZialo1TlppRzZTQzRSaFBjNnR5a3ZMb0J6Rkx4?=
 =?utf-8?B?ZG11aU1KTmNPZGZ1OHVGRFMvM3NVQ0FyM1VzYlBjRS9heTdnbUg3ZVVpczVo?=
 =?utf-8?B?RWJJZytYd2ZkNnJISk42U0ZVbk1iVHNITW5ZT21OOGs5eFhUdnFaNytYVC9a?=
 =?utf-8?B?VTlRTTFPT1g4MlR5UWJFWkdSYWRXY1pOaERkU0JsZmswT0d3K09OUExXT0dB?=
 =?utf-8?B?Q210aW5mWGNKc29sQnl5Z0RNRCtJbU50d2FGelYwRExlUHBrY2R5WDdYYkNN?=
 =?utf-8?B?RnpJWFBzWWx5WGtEV2NGR3UwTHI0RGsrejdhVlY4RjgzaEIvOHc3YVNiWUNj?=
 =?utf-8?B?L3BuN040UVFhRFRBSmk5UWlnNVdDb0x1ZjFZT25CZUdsLzFzL2pmYitaNVMz?=
 =?utf-8?B?NUxoblI4cUdvU3RSZEV0Z3lpbWRtYWYxR1loK3VnQURaMFJpMEs2Ly9pQTFz?=
 =?utf-8?B?UEg0ZEtzb3oxRFRaaXF6VjRuY0FiblZCQ3kyRUF0aDV0SHQ4bjJBdUN4RW9I?=
 =?utf-8?B?dWY1WTVsQzk0eTZhTkZ3TXRyQW53QlU1MG9VTDZseVhaemZIeEkyK3ZSWDNp?=
 =?utf-8?B?UlFHbGZEeVh6RWhkaGliY1laNXZGWStuNG1YaWJ5ZDlLTmd3ZlIxWVZhNVh2?=
 =?utf-8?B?VHZvQXNjRTE5ZU5HbnJ4ZU1xUks5bno0N1FwTHZsQ0VjMGVKRXpRdjVJZTU1?=
 =?utf-8?B?TENBY2pSQUtJQlV2czgvNGFURmFWcjY0WkJQVUVDc0k2NUF0dFpTRDVzZndG?=
 =?utf-8?Q?1Op6YivIGQSFcY1xhhuh02OGDtRwfCbxrETAIk8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aeac407-293e-4b81-b71a-08d98f71eb52
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 00:22:49.4974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fL6sShKiv1oU4Uqys5oa4194DDxaEqAgPBUO848DWZPjI/SG32iMS+jpwuGNysHFAPSjoQ5+PEmO0AOgBgDtHTFXPuS82DNEP+9DrRWsh6M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4110
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10137 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110150000
X-Proofpoint-GUID: M0ZAd_WMmZo0gS_uJEXsLHaZGqnYTIUR
X-Proofpoint-ORIG-GUID: M0ZAd_WMmZo0gS_uJEXsLHaZGqnYTIUR

On 10/15/21 00:04, Jason Gunthorpe wrote:
> 2) Denying FOLL_LONGTERM
>    Once GUP has grabbed the page we can call is_zone_device_page() on
>    the struct page. If true we can check page->pgmap and read some
>    DENY_FOLL_LONGTERM flag from there
> 
I had proposed something similar to that:

https://lore.kernel.org/linux-mm/6a18179e-65f7-367d-89a9-d5162f10fef0@oracle.com/

Albeit I was using pgmap->type and was relying on get_dev_pagemap() ref
as opposed to after grabbing the page. I can ressurect that with some
adjustments to use pgmap flags to check DENY_LONGTERM flag (and set it
on fsdax[*]) and move the check to after try_grab_page(). That is provided
the other alternative with special page bit isn't an option anymore.

[*] which begs the question on whether fsdax is the *only* that needs the flag?

> 3) Different refcounts for pud/pmd pages
> 
>    Ideally DAX cases would not do this (ie Joao is fixing device-dax)
>    but in the interm we can just loop over the PUD/PMD in all
>    cases. Looping is safe for THP AFAIK. I described how this can work
>    here:
> 
>    https://lore.kernel.org/all/20211013174140.GJ2744544@nvidia.com/
> 
> After that there are only two remaining uses:
> 
> 4) The pud/pmd_devmap() in vm_normal_page() should just go
>    away. ZONE_DEVICE memory with struct pages SHOULD be a normal
>    page. This also means dropping pte_special too.
> 
> 5) dev_pagemap_mapping_shift() - I don't know what this does
>    but why not use the is_zone_device_page() approach from 2?
> 
dev_pagemap_mapping_shift() does a lookup to figure out
which order is the page table entry represents. is_zone_device_page()
is already used to gate usage of dev_pagemap_mapping_shift(). I think
this might be an artifact of the same issue as 3) in which PMDs/PUDs
are represented with base pages and hence you can't do what the rest
of the world does with:

	tk->size_shift = page_shift(compound_head(p));

... as page_shift() would just return PAGE_SHIFT (as compound_order() is 0).
