Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797C22C86
	for <nvdimm@lists.linux.dev>; Fri, 19 Nov 2021 19:27:06 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJIUK0g031871;
	Fri, 19 Nov 2021 19:26:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8/dIR6MbQb4Tp3YmVSGooO+tzfh+oKsoo8tTukIaEro=;
 b=iydBI+19szv4gQWyAZLkJiPVWzHyb/rtwEFYvDTnYy+CGYcwF//huTGZvwEq682Fdo/X
 NPUoKK8qIheUkkiuukQu2fT2mRje9OSIf3IjQvPnU5JafSyeUthB33uNdkfO02zigsoO
 4acOnDzEYGSVlbvqdiily189hftT2s9WlxaSBS9XrUbtkOiVa59vJKjIt1xFd+1be3j+
 KQRldG0V4b4IoNa5juM9aQ+nm20KvY7HyrxAaByaSawUpKcJWdfZIdR8MA+VLYfIK4vV
 yacDGAb8LzdOWPtwgpQfl0tObCDeDnj913+E4KE+JHckCFHqfKmlGGzmFSCx7yJ6ksVF IQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3cd4r003y9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Nov 2021 19:26:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AJJAObN128749;
	Fri, 19 Nov 2021 19:26:55 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
	by userp3030.oracle.com with ESMTP id 3ca2g2qvef-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Nov 2021 19:26:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ftb5GR0ABaGr6/hsk9Vq9a2I4+6s5jveqMg0NpFWsSmbNm5lU0vq/JWH7aBq48vyPB7rYcFYOFWHWIP3eBuTkrGTS1Md4lQSOPjh8Qeuk3ltpV0/LSYMVMBRUYQoHzh6nwT1iRc/3LhVtznwSWjV7VjrllBsAly2+kUgUmZx6SBjNIgnDkP5dvczIZTHQpra6+gflRN1ESp12OUJ1MG8QzYA2RZyfarR2NP+JHBAqeRH/Sjn2HT56/K0H1oguxfuU+6sVXTeJ4Zl4P3Tmwoi15rcCKaSCn+UzbbZMv6j5Ij4SMhGCQuG2+/YkWLp6jyRS5vUMQkG0pQ1jlWU1jDBrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8/dIR6MbQb4Tp3YmVSGooO+tzfh+oKsoo8tTukIaEro=;
 b=CswEku0WcXm7rod5VAJ7MnmUsWXXaYs7N0lEAC5frF+B2BQFl3tkO/YbfoVcB6IeXtM9h+3KjlMeCvLXGn+z+n+BtefTLx5ukNw22RrzP+z5Aejxiv4nZOVJwuWLc23OuxMmoABJTrA7EasJDvhVQZFs0H5cwOSmPnOc1oixocOecXKC7XiY8E5P1zLV0sivn4bOgrddCDqN5/M3iZXC5Ynvqqr2kkORDh8YJpIFQkkrOWCoxvCmsgYym0LwfC18s0RY++6ma3nLWjJv6Vur5K9p7zgb31NWjUohTwzPSp9rET/yvNhaVVZq5iULXyr5X8O4smuL68+MBZv1sRV/Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/dIR6MbQb4Tp3YmVSGooO+tzfh+oKsoo8tTukIaEro=;
 b=FGr9YPGd4rptwbsP6L4q5O9ZSv9ovy89QnP4AH8tYurMPx+EQPyQ/GCwtVS/hVT5v6SJ9ar+scjJKI+L63458zdLnXx7xK1kLMX+gUa2L2reZf+Wg0r3/c63X+tMMxIO3xjHEMJrEYqh8bzDDomSTUv8aZ3rGGrww/FONZaGu74=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4207.namprd10.prod.outlook.com (2603:10b6:208:198::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Fri, 19 Nov
 2021 19:26:52 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%8]) with mapi id 15.20.4690.027; Fri, 19 Nov 2021
 19:26:52 +0000
Message-ID: <6925ff6e-2cd5-574c-7802-e436a9a2a938@oracle.com>
Date: Fri, 19 Nov 2021 19:26:44 +0000
Subject: Re: [PATCH v5 8/8] device-dax: compound devmap support
Content-Language: en-US
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-mm@kvack.org,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        nvdimm@lists.linux.dev, linux-doc@vger.kernel.org
References: <20211112150824.11028-1-joao.m.martins@oracle.com>
 <20211112150824.11028-9-joao.m.martins@oracle.com>
 <20211112153404.GD876299@ziepe.ca>
 <01f36268-4010-ecea-fee5-c128dd8bb179@oracle.com>
 <20211115164909.GF876299@ziepe.ca>
 <4d74bfb8-2cff-237b-321b-05aff34c1e5d@oracle.com>
 <3b7f9516-a35a-e46e-83d4-3059a959d221@oracle.com>
 <20211119165530.GJ876299@ziepe.ca>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20211119165530.GJ876299@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0391.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::18) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.175.193.46] (138.3.204.46) by LO4P123CA0391.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:18f::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend Transport; Fri, 19 Nov 2021 19:26:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9ea58f0-acdf-4be5-d36d-08d9ab928a6c
X-MS-TrafficTypeDiagnostic: MN2PR10MB4207:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB42074328FA5D54E9288BF4C6BB9C9@MN2PR10MB4207.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	uQtyi5hOb8zjg1v/3IfAlZfFM/5szsuHQUoijlbRJn9aGuztaWFDSrxcTjlNQgfn4LrvXOfsmvKkS9ujngv3tS6/y4b5pggaOtC5caSjekkK7hqOxoxfLatezX4geoZdeiRUaf3PDGperUGyvFlgBvhCxwtP8oM5Ar2HRXwEjSQV5KT9L2XI7HDEPBgpZ/KIU8MdDxRi5+z7kgGV4wXvqIDT9T2d9dMWsC8E5NoStwD0aRLgsSivt1hLZcPoGtJ6kaQG1NEE4CxDNNhw4/XP4yfI7dUI4VnMl0Fvv2j3/obspgTG1QBRssoDqXd7ba0c57QtKj8NH2FR5bTzfdFe3HJ6nsQW0qF1lRg2G2zQrQEzgJaF1+mG04IHZfJaW8qpcnsBWM+Q3mTWMH96rvRsMd4JdkF7x6Pxo/Cwk3fjObMnitWFo4VxORZaqIm0JiEGq1xTX1owwGnsvjeuV54Xhv4Tjxx5Pt7WALjLIPiKjhQsMN/amyqpyehZq9nfhn19BnedNwhuVb1KFZr5/WKxoD87IHAkVLiwryD2TNW14KiW6wHD02GE+Tk6oxHMXvaxNth4tU5xMOXNBOK37LWj+8mcWXFmFV8NLLa5LeMrhHfG+wjeh5CoNZ1dFGnxcnkP6qPbcrykkXQ5gR/O8NLPg9tYubZhHTjLWp7kkcIRjhCkYy14HK1/XuJYipxksEeeGSh+2Kxg/jHmo6mQe7LR1A==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(86362001)(508600001)(31686004)(7416002)(66946007)(6486002)(66476007)(4326008)(66556008)(38100700002)(186003)(83380400001)(31696002)(53546011)(16576012)(316002)(956004)(5660300002)(36756003)(6916009)(54906003)(8936002)(8676002)(26005)(2906002)(2616005)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZWphVitYeWxBbGsvb0lJOHhvSEhpZlRjbXg3RWs5cFlXdm4yanBsVUxaZVVv?=
 =?utf-8?B?R3luTm5xa3NEVElld0djcEh3Q3VFOEJzdDQyaEgxRWJib1V5eVRaRnk3SVor?=
 =?utf-8?B?aDVIZzFiYTVTQzVCdzRxeEJOTjQvdGgyaGVuQUVtMG1oYnVpZ2tGQitWN2JH?=
 =?utf-8?B?bmxLc3ZEZnBWWGR3OXc5MDVHNUVxUHNFNS9zV2FEdHhyTUFvalNreGpRU3Ex?=
 =?utf-8?B?OHBTL2REMGdGWi9TQXIvSU1ycElkaWYvczh6czQ5SHJEYlhpVTZFaG5Wdnl2?=
 =?utf-8?B?SXpwQjRtYUpEckgrS3N6cUtHSXBzUTgzTnFWZEdianpxUXpSTno2alVSL0Vt?=
 =?utf-8?B?dGZWenBxejJZYXdIZDh1cU1EcWJkelZZQzFOSGxWcFlzamFLTlpoSTFwMGhX?=
 =?utf-8?B?T0hQOGJqTDVzd3MwZmw4dU5MekVOSy82cDFPK0xtUlh5ZUNaekZYamZlUk5O?=
 =?utf-8?B?a3JMT09WOHpDSzQvN0FqS0JWcnpyQ0NzZlhCd29WT1gwWStNV2wxY1lvd2E1?=
 =?utf-8?B?RWxpNjlxREFwUjRDSnV0NVZNcUpPZmFhOEdMSks2ZGhIZElUK1h0Q25WbzMx?=
 =?utf-8?B?dXpmUTVRTzFZbWNMUTBsLzlIcUs0UmNxNHFzNExyYkd1WGh3Y1pqS3VuTkl4?=
 =?utf-8?B?ZEFBb2pBdmVweGIwT0JvOUVXOFJldHRsVE5QcDVSdS9LTktwKytQUG9uQS90?=
 =?utf-8?B?dmdOS1dpQTVNaWlqQTBla1J3TGJjK05ha1haMGdmdGN3djhuWHM2VnBJS1Jt?=
 =?utf-8?B?Q0djRlBXZnhzZ0p0QmJTV0tiWXJJN2IyOFFoZlRWejhhRVR0ek0xbHR4UlQ1?=
 =?utf-8?B?V0pIQTFSeGNJdzNnUmlMeHgzZlJBWjZLKzJ6OG4xNXd3UC9vQzRzN3gwaTE0?=
 =?utf-8?B?TnBaeUhCM1F6S0cyV0lTYndvQUtJVHcwRzB4RDd1VVh6TUo0c0Z2TVlNUG1Y?=
 =?utf-8?B?VHZ6VzZHWjhZK0VqTWhtUE9OaDl5TjVLdlBWRXAyNFZCYnVqSmEwS0h4bzR2?=
 =?utf-8?B?Q1NPQ3ZoWExuVjVtdUpUOUE2Lzl6U0paTSt0MHpLMUUydFdiRnZDVG93Zi9D?=
 =?utf-8?B?eFBxZm81Y21VTGd3MmtJMDFHT2RkRDJsaTN4QVphWmpLVzRzcnd1NGhxOFlR?=
 =?utf-8?B?YUtWVGx4VXMranVVcC9YMDF6T1RITlBQSEkyMk05cytiWWplSENJUlhudjgy?=
 =?utf-8?B?bTRzaDdGcGlvaEM5U1Vqcmh0UUhkSzd4emJHZTJYd1hNNE5LS1BnOGhXY3Ex?=
 =?utf-8?B?RmRtZkVCN3RnbkZwRGFFRURYNHFXZ2t2aVhtNDF5V1cxSEYzVVE1YVQzd1Mx?=
 =?utf-8?B?aG43VDN3azRKRGt6WmN4cE5UODkveGYxYldheU54YjJyZUlRQUxEL1o5NWk2?=
 =?utf-8?B?dDZyTnVJSTVZd2QvVFFVMnFuVGZlRUtGN3FTa2Y0U2RkV1Erakt5RTZ3VTRS?=
 =?utf-8?B?RDBVbjRpdmlSdmJQSW5kMjhURzVqNTFBUjZ4eW96Qnd0MnNrYkJlUHdVY2Zj?=
 =?utf-8?B?YlhnRUJUVkhnQ0VzdGI2UGViS2cyd1NxSGthNFBzVjVkbGUxbFkzbWtFWlo2?=
 =?utf-8?B?WU5nOGFsWnBOZ2ROeFl6Yk94YmtmSzRWN2dHQlhzRUwvd3lsK1N4dmw3YWcr?=
 =?utf-8?B?cjBVanR6K0pqazdWUFZCekRHT3FrcUl0WGpySjJKZjRadWhNWVo0eTdOdGQx?=
 =?utf-8?B?ZVE2M2JKSVU1Nk5IMk5Ba0xHaEU1SVlTYnd6OTlLV0JNM3dlK0RLaDFaanBu?=
 =?utf-8?B?bEk2cXpkcFp6aU1sMS9ZdVF2YmVJR3RxS1pINTU0ZFhmeTd5YWIwU0NZQW85?=
 =?utf-8?B?QjlCWHpPWFdZMXNYd0p1MnA1bFhVWEcyWUw4V2ZGQ2g0cERPcnk3b3I4aEQ1?=
 =?utf-8?B?T0dseUcyUnlVNmoyajZUd3dUd2pBaUgrbUlzYkthb0NLaEp1anVzQ2tlY1Rw?=
 =?utf-8?B?VE8yY3pobjVaalVrUDdsWGxOUHhTa0pxRTNWZ3c0dmRyNjZVbGpUVWlZOW93?=
 =?utf-8?B?bzgvcXdsVlg1MlZWU2F5OW5BelBZNTdzQ01mUGxyL09ydGRGQmRGQ0MrekhQ?=
 =?utf-8?B?N1FBN0dGN0ovejE2VnVOd3BtV0lFVTMvbk9xV1FFZ25hdDI3MngyV0FMdDJm?=
 =?utf-8?B?ZXY4MW54VGoxSDlXWlZMelFLVXMyWXdsTkQ2YktZU3IyTTZ4R0dET25OZjV1?=
 =?utf-8?B?MVNjU1RCby9aWWp4NHZnSnpUcnFVVmltOWZ4WUEvTlZGM3h3V1BWSmJCZ1lC?=
 =?utf-8?B?bTlRMmsrUjk1eUsvNDNhVFpGczJBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9ea58f0-acdf-4be5-d36d-08d9ab928a6c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 19:26:52.8864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VorW18dwf2FvtybbpXpZuS8D+FEV3s3fE4Wu7SgZefkKk6dUlrB+P7RezSgjfy6aP92HM8TU+JmuVoLsU5XF7P/JIPkKlyrA7+3UQK/o47Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4207
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10173 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111190104
X-Proofpoint-ORIG-GUID: xN3vGudbzs2VS2yaWxxYtUDNjBi5mzUl
X-Proofpoint-GUID: xN3vGudbzs2VS2yaWxxYtUDNjBi5mzUl

On 11/19/21 16:55, Jason Gunthorpe wrote:
> On Fri, Nov 19, 2021 at 04:12:18PM +0000, Joao Martins wrote:
> 
>>> Dan, any thoughts (see also below) ? You probably hold all that
>>> history since its inception on commit 2232c6382a4 ("device-dax: Enable page_mapping()")
>>> and commit 35de299547d1 ("device-dax: Set page->index").
>>>
>> Below is what I have staged so far as a percursor patch (see below scissors mark).
>>
>> It also lets me simplify compound page case for __dax_set_mapping() in this patch,
>> like below diff.
>>
>> But I still wonder whether this ordering adjustment of @mapping setting is best placed
>> as a percursor patch whenever pgmap/page refcount changes happen. Anyways it's just a
>> thought.
> 
> naively I would have thought you'd set the mapping on all pages when
> you create the address_space and allocate pages into it. 

Today in fsdax/device-dax (hugetlb too) this is set on fault and set once
only (as you say) on the mapped pages. fsdax WARN_ON() you when you clearing
a page mapping that was not set to the expected address_space (similar to
what I did here)

Similar to what I do in the previous snippet I pasted. Except that maybe
I should just clear the mapping rather than clearing if f_mapping is the
expected one.

> AFAIK devmap
> assigns all pages to a single address_space, so shouldn't the mapping
> just be done once?
Isn't it a bit more efficient that you set only when you try to map a page?

I take it that's why it is being done this way.

	Joao
