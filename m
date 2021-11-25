Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEE072
	for <nvdimm@lists.linux.dev>; Thu, 25 Nov 2021 11:36:13 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1APAX9Vx019246;
	Thu, 25 Nov 2021 11:36:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8wiFHw+Fcwe16Nr+JYLhixCJKz5WQ7Dw+po/BkgN2Mk=;
 b=sS5g/FwAeOF+J9a3OwKZHfV7YTEtazYq7yIFuMun/jBuAHvtiXdaY1ST5r7gPvOGcPF9
 i7d5RZFLEIr2DFd0agBSExpiW8QibISqlEcWOYdZdqK1AHMc5qGS/HYf3JEKFFriKUa2
 iPXKvhKRdZ1YhASajDvkAZEdDOoQpjtPawatkFo2WbM6sM236XuaPMVr7IpzyMzQHYcn
 kCBT7Phz6WmixfUbkrO/0xLfNm1QdwGUsTwJSk3yItl4R42GnyqpYGZCTxjCflNqRVLS
 YqcXP6AK5ARdw48iWMd2e2Kk+VgXduE00RNqNEpLUSDKbFBtpFYirN7MSw2aubCT4Du6 PA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3chmyyem0s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Nov 2021 11:36:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1APBVSis160778;
	Thu, 25 Nov 2021 11:36:04 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
	by aserp3020.oracle.com with ESMTP id 3ceru8jdrj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Nov 2021 11:36:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VFZE9odREU842rHXx6jyMYnALqZRh7LZlttxD9YgLfhPy/jvzeYXK8uv80UqS3I9DxQBSTxCjdmX3Xj2uhctC2XjF/c0NNOFyNpRQ7/aUQBRlH56jgW95x/sQLA34JV91xtEzofnctAq+cH3c24Gm2KUAwlv/L7mLtr6Kpk9FHBkr80ypkRto4WXY3vsftmb9EyHykBRUetbCI+MIpvhKLtUX+vmKfjmgUnOWrxG62RaiR/JQrsUh1n1+mIeaQWb12Y7xO38apHeGdYa76aqqorv0LmPd4bOrof+9Z85Je+WeU3qC0AsbBWgvEh9Lrucy29BWmSqkikfv0u7Vm72qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8wiFHw+Fcwe16Nr+JYLhixCJKz5WQ7Dw+po/BkgN2Mk=;
 b=CU0e4iqsBj7FRjNHq75WkLr6Wf1UqrbtoX3FJckrttBBortYb05jZ4t+lpMO1u82A8JCtDdLPC6HzfE0JrZh12MCyBjqozO7JP7Fj1oxUqQTVzF28mS3uOzIcqL8CrJaJKuH3b4L3bwket4/usf0tUx2FEJt+JCOsT1PYRE+Ptb2ToQtBxQdwsw3Qx7yACH6RzX4Rv2xb00Rp6rf0E0MK1u+0fkU6a16lNxN0wUNBc3hm+RfGjCER1xUSp66yipSJ5ZDMgz1MIiiRksDINSubUJRPQIYAdh8kLbNvn33jcGUQxUUGQhNx4UU31BYQD3Lv77F2vB4+9qZot+KWcNNug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8wiFHw+Fcwe16Nr+JYLhixCJKz5WQ7Dw+po/BkgN2Mk=;
 b=lSOuvUXogWtQm7R1KlqoeJnjQ7lx42gn9O87su1atIEYHYqP3E+QHHh002XOKYG0tdo7sqSf1MkfFhCmAsqoLcw6XzEacsXQHUhHAYwVSfRCV4VK69ramHkLG+8UG8sSTVDHjnXZdA+eVNq1W2sbe2mIfU2wua05H5Mn5IWfszQ=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3903.namprd10.prod.outlook.com (2603:10b6:208:181::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Thu, 25 Nov
 2021 11:36:02 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%7]) with mapi id 15.20.4734.022; Thu, 25 Nov 2021
 11:36:02 +0000
Message-ID: <5dba5bec-4c19-2a3c-3cb0-d232bbaa3dc3@oracle.com>
Date: Thu, 25 Nov 2021 11:35:54 +0000
Subject: Re: [PATCH v6 04/10] mm/memremap: add ZONE_DEVICE support for
 compound pages
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, nvdimm@lists.linux.dev,
        linux-doc@vger.kernel.org
References: <20211124191005.20783-1-joao.m.martins@oracle.com>
 <20211124191005.20783-5-joao.m.martins@oracle.com>
 <20211125061130.GA682@lst.de>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20211125061130.GA682@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0462.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::17) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.175.177.229] (138.3.204.37) by LO4P123CA0462.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1aa::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.19 via Frontend Transport; Thu, 25 Nov 2021 11:35:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cba22866-fbfb-4bc0-e1ec-08d9b007c217
X-MS-TrafficTypeDiagnostic: MN2PR10MB3903:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB390354322AF4118E8A552AD6BB629@MN2PR10MB3903.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	N9oFT8a6NfkHuo+7+X40GGxafsnlVD1+UxlgeXh0O2QSq2z3cqn2ThVsVXMEbRYoxcR93Rag9pPOQHUr7bKZ+i+O5smWqEyDsxeqXGrJ8c7pt81BtDNjCjhk+N0/d9OvEfc0dbc/1SS5F8sjyrwfFBxPrAomJPxyAKtyxZB1+NPdhoxpKwhKDhHlRcwWXmqGP5ltcDUzgxpXNYYB1D0cVOfqggKSWRWsJBdDbOdWwdvadV/FTp23aJNFzBrl8je7fORlIpDqqSMOf+EgydNjalqT3ys/O8tZ8Ae6X1QsNIUvNNQbpSGWrnA7FwH6VWSG6zJTKLtr6jzoMo8X6R4Pwpk1m6ia5DuRHIdGj0h6MiYdwmKJwYfn0OaZ+ypkpTMOvPX0xk3K/Y0HLeg5WT0F1zoPoTDNpljQzDyCAcR9skh0lI2iibGj72q61C94UNxz/rnzx/xbxn4n//GWoKJ/GSzY55FXlW7HnrbrLglN2LXy4DFx89Ws+LpQdbu6jVCVU/a7pQe1VbmIpbiGOzcOZHs2sTMoGQ1qA/Okk/GWNvoPqSkp2JPCMd3mA8DVAqR4kYaxSUnoeJj2xmUoC4+d/ZaYH0nQDOkOASgMGJkc3tL49h+1GlDsb5rdiRBzd7e8bP/k6FVkyHMuDbqvDxk1f7HXjBDgoU+PiHLkiJ2213HVhmxQhaKvjIHHRHN3Q71ZIleMsbyjelKczqaECUj0yw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(83380400001)(31696002)(7416002)(4326008)(38100700002)(2906002)(508600001)(26005)(6916009)(54906003)(5660300002)(316002)(53546011)(16576012)(66946007)(66556008)(66476007)(6666004)(186003)(36756003)(8936002)(86362001)(956004)(6486002)(31686004)(8676002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RXZ3K2JnT1lhc0FMR3V1cGpKMmJsNmhxMnMzZGdXNzJNV2ZDSmpHaTRnWE9J?=
 =?utf-8?B?K1VWQ2s2Q2Yvei9UMGJXaUFWN0dpdklGenphZnJKMDFOMk9iZ0Yyb1g1RkVl?=
 =?utf-8?B?Yk9oZ2tTNlY0aWtxQXY0RS81QU5Pa0tQdjFWY3ZTTlhHWTFjalhJVlBUZjlr?=
 =?utf-8?B?WWdhR3V0a3hUTXNTVVlYWGhuU1M0aGJVR1J6SnRPRmRaUW9HZ0RPSzhXU1dq?=
 =?utf-8?B?SU9xTHNXWHFQUmVaK043Nmx4L00yOTd1WFJvOFZIL0wxWVFxQ3JSUEJRcHN6?=
 =?utf-8?B?eFB4MjNYSmRJSGVVemFhenVCV0lycVM5RTlFcDA4R0JobXRNVGQwZDFOYkNO?=
 =?utf-8?B?NFFNbWRWZmYzQlRnSkNwTnhVWit3dGFrOFZ3UTB4TU1vRTlwZW9QVjhHQWtn?=
 =?utf-8?B?cjd4TTFzblNqTldhMTI0TWNnUHN2VTJubXhmbS93ZjBFQVFJTGxUVUgrUUJk?=
 =?utf-8?B?M0pZR2VSUnJQRWdqTXRUa3BqYnZxdkZiL0sxZXBBcjBodkdId2N5bVM0cnhL?=
 =?utf-8?B?NE1SNklkWHlVaVFoVjgrOUcvN3Ereit2WnhlVy9IOFMveEV1U3g1NjNUSElj?=
 =?utf-8?B?bTFrc3pKNFFMeU1ITE9LUXFyZmx1My93OTNxQythZ2IzdHRubVpEdmtURU1S?=
 =?utf-8?B?b3B0TDRMam9GVDFoVDhYdlJDVlpOenF0NU1rVDMyOG1kWWVEOTNBVFR1STUx?=
 =?utf-8?B?WUo5cHZvV0JiWVJwSEowc1VtbHI4ZXhRSDByNStoLy81NUVKcTBKTmJyQ2JV?=
 =?utf-8?B?a1g5eWFoNkhMNjd0VEdVNEg3UVE0V0NsS0MxWW9PbUJvK2tNaFlDcjMxNlhW?=
 =?utf-8?B?amVsVU1GaFVmdG5jV2hzQlY3MU56azVxbGJxWEpYMlYzd1FKMUJSM2pLYlBo?=
 =?utf-8?B?L1VSTEV6NnR3cXM2ZFBabjA3bm55OXpoVHdGS1AydFF2bVlsWStYTFl4a01k?=
 =?utf-8?B?elFQNXFpcFQ5czFUb01qMzNJb0hVTlkvUnQ2VmFaK0FZQmliOE1Wa1pONnlz?=
 =?utf-8?B?YXVhM2ZRSnJJWk1MWXZ0bzhraUNRWGw3OHpUMnNrRktIZ3d2NFlpZk0wUzlH?=
 =?utf-8?B?YUVEc0FJN0F0YVpZS05tYjREeUhJS1R3UU1oWlljRkhhcUI5OVdNV28ySlBv?=
 =?utf-8?B?NjZqZkZtM1RKZW12dlN4Vm9JaHovb1NOTHpyc3IrZTNNSEVXUTBEWTFub3c5?=
 =?utf-8?B?RnJvb1BiRi8vUFVhL2lKTllaVkFaeXZ1OWZld0RUTWVEc2dKb3RyK0tiRnJi?=
 =?utf-8?B?aHhBLzQxUjljSjg2aWtTbUJUaE81LzJRNlBZTG1DSDdhTjJRVllJaVVzam9K?=
 =?utf-8?B?QjNOYnRnNmRqK0xlY0hOMDV1ZnpMejRIQkVUWWxmS2FiOVdkWkFNYVpwK3Nr?=
 =?utf-8?B?YlhTbU9zblRkTFhMY3ZuR3Q5MHVQTHlaMmxRZkc1U3lOZkxuclYvL0NGLzBT?=
 =?utf-8?B?eFBJbDRKRVkwTUx1dUxHNTA5NjBmN1IvcnVvekFrOWxPVUVtTm1zMkx4YktB?=
 =?utf-8?B?cFBKaGlFeUpxOFZqTHhCQkk4UDZaOTAxTVJCYUVOaWJVV3NuQUE5YnFhazZF?=
 =?utf-8?B?Ym41eTZKeFFEZEdPYnFtcWFEeDZ0V0dKc2hrd1hmSzVrY0RGbXQ4aVEwUlRs?=
 =?utf-8?B?SzZZMndjOGNoS0ZGZzczY2NVYUJsVXVldUpSM0Z5RnR1QzRZTVJzcHAzVWV0?=
 =?utf-8?B?LzloZVJKSjZFcm5EWEdxSGpNWGVxTVRtWmpDWkdGeFpHdTMyZ3RRa1daazdY?=
 =?utf-8?B?eFRtaEtoNTAycmViRTF6VWM5YjRoV05walkzOTFFU0gyZmd1WWZRR0lSYjFH?=
 =?utf-8?B?VU1BdkhCQnRET25nY3J2M2MxWGxwNHFOWUc0TVZWcmdOeXcvL2FWNW90OC9z?=
 =?utf-8?B?aWdWbkpxbDdWaVNmNkNHYlpFb3RMdms1a29lRktXNnFPaEJOVUNNeDRkY1hl?=
 =?utf-8?B?WkhobG5wQVI5M3lhWDh4d2laTTRYTkhiZ25sL0RHdjl4Y3pmbjVzdlJJOXBU?=
 =?utf-8?B?dEYxbU8vSHUwV0xPNVE0cDN5UzVDSGNRSCs1L0dwS2xsN1BYTXgvREExWmJ2?=
 =?utf-8?B?ZElITTVwSkJNbk9oa3pJaVRsdGlRaE9sczVoQUNidmxLYmdTWDRHL3RpNkVn?=
 =?utf-8?B?cG5iUWxsMGl3VlBuNjlBcmpwSG44YVMrMmxkRmczUXFaU1l6YThoeE12bTR1?=
 =?utf-8?B?dXNXY3V3SUx1cjdLaVUxYWRDQzBCMitOa3FvY2N2bVVodVJpT0RmVVVHV2ZR?=
 =?utf-8?Q?mid8UQb9kZyjwgyoO1oLwyvDYpjUoC7eAVgRN1DsBo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cba22866-fbfb-4bc0-e1ec-08d9b007c217
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 11:36:01.9460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e1wDSIeMqJVSxxKmu7ZTUE9byC+Bz4ypkdGAAxL1xGMfI+L3Bp2SsO3gPZdJph/0R6ZufJh+WwUZB9pc1NFiRkJ8pB4MoTtyHcfC06UXTVw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3903
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10178 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111250063
X-Proofpoint-ORIG-GUID: zxv7ih9wFRpTJeEyt21ABeV-F93p_L-x
X-Proofpoint-GUID: zxv7ih9wFRpTJeEyt21ABeV-F93p_L-x

On 11/25/21 06:11, Christoph Hellwig wrote:
> On Wed, Nov 24, 2021 at 07:09:59PM +0000, Joao Martins wrote:
>> Add a new @vmemmap_shift property for struct dev_pagemap which specifies that a
>> devmap is composed of a set of compound pages of order @vmemmap_shift, instead of
>> base pages. When a compound page devmap is requested, all but the first
>> page are initialised as tail pages instead of order-0 pages.
> 
> Please wrap commit log lines after 73 characters.
> 
Fixed.

>>  #define for_each_device_pfn(pfn, map, i) \
>> -	for (pfn = pfn_first(map, i); pfn < pfn_end(map, i); pfn = pfn_next(pfn))
>> +	for (pfn = pfn_first(map, i); pfn < pfn_end(map, i); pfn = pfn_next(map, pfn))
> 
> It would be nice to fix up this long line while you're at it.
> 
OK -- I am gonna assume that it's enough to move pfn = pfn_next(...)
clause into the next line.

>>  static void dev_pagemap_kill(struct dev_pagemap *pgmap)
>>  {
>> @@ -315,8 +315,8 @@ static int pagemap_range(struct dev_pagemap *pgmap, struct mhp_params *params,
>>  	memmap_init_zone_device(&NODE_DATA(nid)->node_zones[ZONE_DEVICE],
>>  				PHYS_PFN(range->start),
>>  				PHYS_PFN(range_len(range)), pgmap);
>> -	percpu_ref_get_many(pgmap->ref, pfn_end(pgmap, range_id)
>> -			- pfn_first(pgmap, range_id));
>> +	percpu_ref_get_many(pgmap->ref, (pfn_end(pgmap, range_id)
>> +			- pfn_first(pgmap, range_id)) >> pgmap->vmemmap_shift);
> 
> In the Linux coding style the - goes ointo the first line.
> 
> But it would be really nice to clean this up with a helper ala pfn_len
> anyway:
> 
> 	percpu_ref_get_many(pgmap->ref,
> 			    pfn_len(pgmap, range_id) >> pgmap->vmemmap_shift);
> 
OK, I moved the computation to an helper.

I've staged your comments (see below diff for this patch), plus wrapping the commit
message to 73 columns (I've also double-checked and this one seems to be the only one
making that mistake).

I'll wait a couple days to follow up v7 should you have further comments
in other patches.

diff --git a/mm/memremap.c b/mm/memremap.c
index 3afa246eb1ab..d591f3aa8884 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -109,6 +109,12 @@ static unsigned long pfn_next(struct dev_pagemap *pgmap, unsigned
long pfn)
        return pfn + pgmap_vmemmap_nr(pgmap);
 }

+static unsigned long pfn_len(struct dev_pagemap *pgmap, unsigned long range_id)
+{
+       return (pfn_end(pgmap, range_id) -
+               pfn_first(pgmap, range_id)) >> pgmap->vmemmap_shift;
+}
+
 /*
  * This returns true if the page is reserved by ZONE_DEVICE driver.
  */
@@ -130,7 +136,8 @@ bool pfn_zone_device_reserved(unsigned long pfn)
 }

 #define for_each_device_pfn(pfn, map, i) \
-       for (pfn = pfn_first(map, i); pfn < pfn_end(map, i); pfn = pfn_next(map, pfn))
+       for (pfn = pfn_first(map, i); pfn < pfn_end(map, i); \
+            pfn = pfn_next(map, pfn))

 static void dev_pagemap_kill(struct dev_pagemap *pgmap)
 {
@@ -315,8 +322,7 @@ static int pagemap_range(struct dev_pagemap *pgmap, struct mhp_params
*params,
        memmap_init_zone_device(&NODE_DATA(nid)->node_zones[ZONE_DEVICE],
                                PHYS_PFN(range->start),
                                PHYS_PFN(range_len(range)), pgmap);
-       percpu_ref_get_many(pgmap->ref, (pfn_end(pgmap, range_id)
-                       - pfn_first(pgmap, range_id)) >> pgmap->vmemmap_shift);
+       percpu_ref_get_many(pgmap->ref, pfn_len(pgmap, range_id));
        return 0;

 err_add_memory:
