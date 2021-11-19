Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E474D2C86
	for <nvdimm@lists.linux.dev>; Fri, 19 Nov 2021 20:13:44 +0000 (UTC)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJJASc2006421;
	Fri, 19 Nov 2021 20:13:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=P0cdD8jZlOEcRP9f2AgPz3caCtHn4sPZ2keLyGhAlYQ=;
 b=klLXUGyF4+IFg4KZ0KnZIW3DuYqm7DP+KlvG8OHvsje6IysO4OlIQ4L23Zzl5eSwUnlQ
 CL4SafxaGOb/KLCjB3IGKaUrhKU85aS0qwEhmKg9XaqNnA8Taw6LQWRyWqfBCXhL2LkI
 OVbKy4PxFNo/UIq1Pc68i8J0tYskbWhzfFmFcyGzJI3PLtuV121hPCZnlKWWM+orIZKz
 Oi9598VQJvnkDKUFf2w8URxZQ1HCmI0XTkn4epRLoH6QhOggJXCAeyubR/LICZl/hdRs
 BZQKRQR5juU7AT+QANgJFfruTXEf/jC0g+Lvjiq9LOb3INu9YuGgCzyUp1AtV75A3AQQ MQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3cehun0aa7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Nov 2021 20:13:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AJK6oOp047630;
	Fri, 19 Nov 2021 20:13:22 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
	by aserp3020.oracle.com with ESMTP id 3ca56as6j3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Nov 2021 20:13:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xq+8F1p1XnH3liwiUM7RQB1tFR+2J1nsA3Z9Cm2WZ3BzQnPUT7SAxy7sJMm1lUmnkMXJtfoTCiMWvX7j/hni+IUHW0yuAcXIeeuIjC4Jy50YxmmLD+8YktCaV7YNwdf6dZQbIBqL2lm5GCifPf8za5g7Qhy/98OIHJBVXwN2LqNcMFV+M09F2742ylNTEA0zpXGllCSjogvOgw7EzNJnwU0vuvmB6QGs5XwrK75bTC7IUjQCkw9mRCBwg16SKmbrBU3WlZ+2Kw1Rly7Sp31wqpNpbeo0Q1+2qIxT+us8nO9zTBhk+Ko4XAtFia0disiboRanvM7qG0H+zMzjb3hRGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P0cdD8jZlOEcRP9f2AgPz3caCtHn4sPZ2keLyGhAlYQ=;
 b=b8kZzg5N2wFDPWm3w2SFsXgogIrWnlsAGU2mWchEoy/9RuBJ5B4SX9dDWYw0baWHl4tl21qbYadrpPnLD85Q5Vo9V9kNS7eeIInvQ7ZkfoW3rbZWJfkra20cLQ5+01x2KVLiipbGKCMyhTi+2bzjZt/jZytSPdEB8rmqeEFDFRU8oXijYTGk6vVALh1t61MV3sQ4kjR51BjHs0li2qWBToS2npGMKqyXludAzXP+3DmRjzVaQAbCnHzniP+SOb6zPNND2DookoOFsZb3zYwf4a0R2rxMAcwqVQxWBDTANEz8fc1PZsEbFHoH6zXHS4zU+c8ijQ0jeceNSxKNknF1Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P0cdD8jZlOEcRP9f2AgPz3caCtHn4sPZ2keLyGhAlYQ=;
 b=YTXQ4wuyw8PXukTH0eSXHg/kU3T43gVggPDhqVSiClXNrpuSn93W2xF8ODdJjGn3+RzrGVCJgviGu0QeEYdRtpzGMhX2nFwvtQy5bZUSzonAERZU717i7z5IpwOaP9ozfMymOjpSgo4teqwMzswx4eVVDBJqKRo4GXkxmvlPIkc=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4317.namprd10.prod.outlook.com (2603:10b6:208:199::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Fri, 19 Nov
 2021 20:13:21 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%8]) with mapi id 15.20.4690.027; Fri, 19 Nov 2021
 20:13:21 +0000
Message-ID: <fff81eaf-1890-600e-bffe-f720aefb036c@oracle.com>
Date: Fri, 19 Nov 2021 20:13:08 +0000
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
 <6925ff6e-2cd5-574c-7802-e436a9a2a938@oracle.com>
 <20211119195322.GN876299@ziepe.ca>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20211119195322.GN876299@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P190CA0028.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::33) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.175.193.46] (138.3.204.46) by AM8P190CA0028.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Fri, 19 Nov 2021 20:13:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e893d0d4-0509-4213-93d6-08d9ab99085a
X-MS-TrafficTypeDiagnostic: MN2PR10MB4317:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB4317A4D58A2B9EA1A119EFD6BB9C9@MN2PR10MB4317.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	xfgOoLZarCEhAWR020cHzQhAcCRr+rIzCf46Xi52ndcrQPbLXUXjhDtvfJw+TAhilSUM1vpjwqNmI7zhWz7u6cCkakPnAS1rwI4X3vtyO8iNHJe2PBqwOJTdtstf7lHAINBdCNPY2UXo3PQ2K4TD/lNA4o3yntDu+OMegKOsP77rL6xc17ZDZB4BvnzXIcUnaPsJQqRCXxyDJWxjfMWySw5jJln/j53Q54mAaxlz0gWgvJOlhUeQ2n0EkjYyFY5fGCzBCMoqFqwVeOXsS22O8UykTRUJf8ZM0keOfbpe6qwnOqTSzAz+IqDsVVJKTfN4eNLx+g+5iEyVmGFv3mQYk5YpcyeiNr8VA9K+m0Kl6GlxmOKNKegPOeUxFk7v1NXfJlEw96keWWuAzEqYfqriieUfZ9CXU9tbc4TV9wLK0CybWJhjYuKANLzFDtk7G2HMjXp5ra5N4tBlC8EqKv+smVA4POHLem18MwBeWp61emd2ibctfhWPUlaxj/O7espKJDuMKSKeAmoLDSs43vpSs/ugVEhSnW3hXKO9qSkM5I70nkygRff+ck5V9DFZqFIxUJGAZRM/xINGRjrjAo3pR31a8KV6pPxRoMTNF+CfgLuTzoa4M1Espk04KF8V5sJJVVOl9OAL25i2SMW+wQP4HmHy7vM696Biv5nMdXtVX9Nro9FMK5DTH4qnCxDwpzaSb0sSQYF50cM/VkNSxYV7OQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(54906003)(7416002)(508600001)(16576012)(956004)(53546011)(31686004)(36756003)(6666004)(31696002)(83380400001)(316002)(2616005)(66556008)(186003)(6486002)(6916009)(4326008)(38100700002)(8676002)(66946007)(26005)(8936002)(5660300002)(86362001)(66476007)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?T3dtd0dTMDdRSkVMU2dKcnZTZEZyMXhONFFTZzd3dmIvWWJ2T0hNdUtKMWlP?=
 =?utf-8?B?NjA0Y0VUbXcyb3UySHk5Qkp2eHRDNFF3WUMrcldJVitETjY4dk8zRzB1amNi?=
 =?utf-8?B?V0g0UEFXRm03SExNSldkS3I1UXQzUXdnanV1SGs5cDg3bHNUdHFxdm54eVhL?=
 =?utf-8?B?aFVjeDQvSGpLc2IrS242ZDQzQXpNTDUvUWJFOE05ZGlDWDNoc3ErVGlLNkp5?=
 =?utf-8?B?bmc2czRmbHU2cDRSK3Rrd2ZOZDNCaDNFaDg3TnBraDhCMXZ4VGpmRFh3aU9k?=
 =?utf-8?B?WC9adjJyb0h5c0k4dldYenlmOUtBNy81UU5neE41bTBZN01Wd29mMUVQbE8v?=
 =?utf-8?B?b2paalgycXJXNnAvRDhZQ3B4dDAvcXA0U09pWlN5bDhjKzkwZ2lRTTZVL29O?=
 =?utf-8?B?MU9BbVNLNDJEeU9aTmV5KzE3VWZuY2dFTzd4MG02WkdxOUV2c05WeXlGRW1D?=
 =?utf-8?B?TTJScTYreDB3NWduSmdZRnUzbDhOcnZ0UTViNlZKRXFGMGpjOWh1V1oybVl0?=
 =?utf-8?B?Q0ZrZ3pVKy9iL1JoQkhYVmIrU0wrWnk2dHMxNHUyK3FvWXU0NDBvTGZzNEVX?=
 =?utf-8?B?Z1c4ZWFzcTh4WDR2MkxOTWc3Ri9XbGdYMnRkN2cvcTFwYkY1QkdoRVUwTmVa?=
 =?utf-8?B?TS9rS09kUytCR1ZWRmRWZU44THJvZk00TDdueEExRmlldE15TzZiV0xlZFp5?=
 =?utf-8?B?VFBhU3BzUjF3MTV5TVZTTkJtNWpLekorWUN6NnJTTGtaQmF4QlljSFF0Uy9L?=
 =?utf-8?B?Q2NSaUs4TERmeHczOGpCcHdlVnJ0Q3pOc1BTTitORWNWTi8rbVRNQjY5b2pP?=
 =?utf-8?B?Zmxna3NTa2lIRXgwWEpPQW9hcEJIeFIrcGkrZUtNY2Y3TmNCUXdkRE9wcWhE?=
 =?utf-8?B?SmFHeUY3K3JuVE1ybXlnS3ZMM1pIM0l0OVoyNjRwWVJBd1FHYXZLSHhReEpM?=
 =?utf-8?B?UFJlUE9vVWlZNFFEK1RkVm5xSGlheExVZGlqT3BJbmcyU1FKTG9hdUpmdmMv?=
 =?utf-8?B?UmNZU2t5SVlGMG1rWXNpWmZuNjNndHFvRmI0eDVNaGJRU2d6eVkvNC9oNXBP?=
 =?utf-8?B?VVBNRHYvS3NNRXlWdmJxMUJhdWE5RGgzeHNqVHd6NEwwRG4vZVZzdWpRd0NK?=
 =?utf-8?B?SGdRNVY5MFhmbWRPZHFLRjhmTmE3VWgwQW5FbC9yRHpzNm5pVDh5UnNES1dI?=
 =?utf-8?B?MWVoWWY2OTROMkkyTURIN2RjblZjT3FBRVRVdDh3QUJjSHVzMUdIejh4QmdM?=
 =?utf-8?B?c21PV2JrNjJBcjhBQ3ovWmlhWkZEMDdmaU11ZDZibFBDWkIwNFZub1BnRmFt?=
 =?utf-8?B?WVJTU3V2RGY1cXQ0NW1sNysva2x5OWF6cHpVVjdaNDJXdmlaUW5KTDVpaFl4?=
 =?utf-8?B?MERJWG44MmtjK3ZkM2pobXp6YU5jWDlnYlVnbWUxWEhEVE5GMmxrNWpHcGVm?=
 =?utf-8?B?K1ZCeFp6T1B1Wm5OS3duakJjQlBtRXVhajJkaytGV3lRb1pFdU5kVjh6ajcv?=
 =?utf-8?B?dU94MnVJdDZ4T00yUkJvSEtLbytSdHczNWJUdWQ4MUJlVlZQMjhsZmdwUEFv?=
 =?utf-8?B?ZnFoNEFXNkdnZkdlb3pxK2lFVGgvbFRneXJsTEZEL01LcEpwREpkbU1vencv?=
 =?utf-8?B?MnlqcWcwWnNJN2Npb3p6NG9UR09laWwyR2dMZnJNUTVOYnlwTWp1RUZGeWJH?=
 =?utf-8?B?V0hBTGFydHdLSjJXcnZTUjQxNnBWb0lMRUlmQ0dHVUZrQVdIZ1k5by9VTUFL?=
 =?utf-8?B?cCt0U2RQYmlEMWhnWDVuY2U4eUV0d2ZmcWhpZnM1Zll5ZUVheVNDRDRrMGxn?=
 =?utf-8?B?R3ppM1hrMHk0eWU5NWc1L0YrQ1p5MTg0aXlZTUtOZUp2RGM3ejlHMWZXbW1F?=
 =?utf-8?B?em1jK3VEVlQ3ZHY3OUxwS3NQaEVzYTREQSt5bnBoUVFEUENJV2krZXovckk3?=
 =?utf-8?B?N0FuVHRDaG5adE8wNzUvbGF6NjhwSm1ucVBDcXQ0Y21wY3p1a2RtTWx3Qnkz?=
 =?utf-8?B?d2piUHRBdkNXMjcybFRyOHJ6UVFocytreDYwTW1LalNBOFBsS2puRkQzRDBT?=
 =?utf-8?B?dkY1Yk5Oa3dWYUcxTjFFM2h3b1lVSDE2amZ2OXNuVlcxa0lnUDNXZkRmQ0J4?=
 =?utf-8?B?VFhFTE5tTlYxUUlVTHhnNWdwMm5VQ0hMbGhZeTNLZlY3WklIWnNmV1dKNDd1?=
 =?utf-8?B?bmkzdFM5Z3Q5NXIydXJQb0Z2Snl4K1R2ZlM5eUZKYnk2Y2IwbWF6TVdWYnlI?=
 =?utf-8?B?ek94TDcrc2JtdkU2aC95K0xtdEZ3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e893d0d4-0509-4213-93d6-08d9ab99085a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 20:13:21.0614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /IiobS8r2TPS/Z/OljE7WYaiA+00HZ6n18ikphUmck9lSAmEysNKwmozhGSySdaPsiOJIeDENy0yuY+15VPUlMMwLX3NgG3r6yukOo/OFgc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4317
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10173 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111190108
X-Proofpoint-GUID: vy1ayd9j00TbXVFwwa6WEKhCo1pD1NdM
X-Proofpoint-ORIG-GUID: vy1ayd9j00TbXVFwwa6WEKhCo1pD1NdM

On 11/19/21 19:53, Jason Gunthorpe wrote:
> On Fri, Nov 19, 2021 at 07:26:44PM +0000, Joao Martins wrote:
>> On 11/19/21 16:55, Jason Gunthorpe wrote:
>>> On Fri, Nov 19, 2021 at 04:12:18PM +0000, Joao Martins wrote:
>>>
>>>>> Dan, any thoughts (see also below) ? You probably hold all that
>>>>> history since its inception on commit 2232c6382a4 ("device-dax: Enable page_mapping()")
>>>>> and commit 35de299547d1 ("device-dax: Set page->index").
>>>>>
>>>> Below is what I have staged so far as a percursor patch (see below scissors mark).
>>>>
>>>> It also lets me simplify compound page case for __dax_set_mapping() in this patch,
>>>> like below diff.
>>>>
>>>> But I still wonder whether this ordering adjustment of @mapping setting is best placed
>>>> as a percursor patch whenever pgmap/page refcount changes happen. Anyways it's just a
>>>> thought.
>>>
>>> naively I would have thought you'd set the mapping on all pages when
>>> you create the address_space and allocate pages into it. 
>>
>> Today in fsdax/device-dax (hugetlb too) this is set on fault and set once
>> only (as you say) on the mapped pages. fsdax WARN_ON() you when you clearing
>> a page mapping that was not set to the expected address_space (similar to
>> what I did here)
> 
> I would imagine that a normal FS case is to allocate some new memory
> and then join it to the address_space and set mapping, so that makes
> sense.
> 
> For fsdax, logically the DAX pages on the medium with struct pages
> could be in the address_space as soon as the inode is created. That
> would improve fault performance at the cost of making address_space
> creation a lot slower, so I can see why not to do that.
> 
>>> AFAIK devmap
>>> assigns all pages to a single address_space, so shouldn't the mapping
>>> just be done once?
>> Isn't it a bit more efficient that you set only when you try to map a page?
> 
> For devdax if you can set the address space as part of initializing
> each struct page and setting the compounds it would probably be a net
> win?
> 

Provided that we only set in the head yes, it would have a neligible cost
over region bringup as it only touches the head mapping.

Now with the base pages on device-dax the zone init would probably
jump considerably.

> Anyhow, I think what you did here is OK? 
Yeah, I wanted to hear Dan thoughts over -- or maybe I should just respin
the series with the added cleanup.

	Joao
