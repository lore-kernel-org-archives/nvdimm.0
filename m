Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130AF3FC2
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 16:00:33 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17REC5uY025386;
	Fri, 27 Aug 2021 16:00:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=xeeYCGUtKGQob68gBUzTdh0CQM75m4e94M331yeb1Ow=;
 b=qc4KOZQUFelw4NYNllZ841eMxdoFvZZBrzZWcatLb2q5X8Z5JriOguAwAOECJnPZWEK3
 EzKs50N/79Nao/SQDM3N6wi9P+w0AC2YEdS8Ftq75hxtcflQudKb8Bszn0xzibJrRaSj
 iD3TBFSUQyTXxiqlE/7om7u/uBc4ArVkbw+6w12/ICOIbn36TrzZERgtNr2LwtK4Pi2/
 ZJCe6BSfWSRg46bLbquqWvNQFYFUn4JD3nedAu0QJVL8/XQ37caoB1IkyUdNaMk+86Y2
 6rF47VcqA9mbFP7Ay9f4LWr0PqzVGDb4Q48KcUGZ1oRN4DSnhBQD9sqPrhGffLXT+/s1 yw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=xeeYCGUtKGQob68gBUzTdh0CQM75m4e94M331yeb1Ow=;
 b=AfPgKG8uLwZMk/KRlP/s3ZV6/FaFSlNA8cFPVfMO9OE/MFYR7MQcHBZLUtCwdtlNblrn
 TOuQ76BfjEFUeDgY3fMk5VJASOJv0ZAZ0Py0wqSq+iMQOWOfqMvdUeYwoY/qSPtQXvHd
 b27bmkbQYddLTaquI5fccH6ISodq3uxh1uz//Xsgv1NBWkvVTBt8nZpoyciAc5XruioH
 b4RtRIizqalc5zhVdW7lJ8nQ1XlAMcANH9Hmnd/nkULWCiu3l9PlxQV/XRXE99ctsjSD
 ibh3FJEmcd6kb8LwPoiwrkaU6NBPONL5MqDAcvhiJ1YSsiL2K2K//aBUYvgqMGcHrTXE oQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3aq1kvg9ey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 16:00:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17RFtnVr062615;
	Fri, 27 Aug 2021 16:00:24 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2041.outbound.protection.outlook.com [104.47.73.41])
	by userp3030.oracle.com with ESMTP id 3ajpm4x065-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 16:00:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i7t+PPVcoJW8bYBjTfCZV8Aye/ZeJ4wJPWrxfd81SfktDe5PnAKz8BXhLfJ2CR9WvxJynOIsouKIwUbCocALxSrHrRhGVdB1WZFotysjK1s97QkXDUjeQNAuD0m0pfAvk62fF7lMQuyGrxK4USxY6QJBmPjkAIxvetMyktT9DHR830WfrHN7b/qmaaiw5R6aNmBiIKXuzao6emRckx6ezUcowvLxkn06AP2PSmVMml+1HjV3x3OJH3hk9eJ4Ndx8ZfDQPc2sTmwJlq1kijMsoTldE9kGZLUtfz5kBImNS7M2rtrK54RTDeYmG9nU4VQm9Fw7eJQW3A5U8BdR04lqjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xeeYCGUtKGQob68gBUzTdh0CQM75m4e94M331yeb1Ow=;
 b=BMPNlPh0CsCaJ8BGt4D2qy7TyCzuZHAbEY/qSkiVRZRYOp8Y1hjBRGp+FRY1xYYlw26POLgkbye2oUY+o+m74gCH+q0Xi1UBToNO3uebeMPwm9TDEkRQfaZLOiAdcYVxiuT1wJea8ktF5DEnpw+kJtmTOb0Jrw2DTWB3ikHO4RyyYzwVleJv2okVSUHr4UFTjcm1+/j6ReMNQnnbNbxj3atx7XT0YrkOkdIFrVBiP5ftitp7O2pLP45a639bgozsB+KftrC4+YgmEecMyK31hvqxxUKrtFjzhV5HcdwvgEJ25IkV9Mo+GPDfP/cC1E9j0Um4iDT6qOfBH6np6N6VBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xeeYCGUtKGQob68gBUzTdh0CQM75m4e94M331yeb1Ow=;
 b=XyYgaGNV1E5Uwa0OhkLKJEtyiGFq303y72qnBtGC0J9uaEXPnDkMTdH1opplPNu3LbUNJetG2W7u4AEz62lp/oxQBLJhJIpE0BlpYWAb8zTCGmQ3qmyxrP4oB8tx/4PjkPUPmr5vafOtqGnRCFeU7hf8ngb+gz/qmylh/VJCXuE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4078.namprd10.prod.outlook.com (2603:10b6:208:180::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Fri, 27 Aug
 2021 16:00:19 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198%5]) with mapi id 15.20.4457.020; Fri, 27 Aug 2021
 16:00:18 +0000
Subject: Re: [PATCH v4 04/14] mm/memremap: add ZONE_DEVICE support for
 compound pages
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
References: <20210827145819.16471-1-joao.m.martins@oracle.com>
 <20210827145819.16471-5-joao.m.martins@oracle.com>
 <20210827153308.GA20687@lst.de>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <9ee23c67-e600-555a-85fc-d527b1484bcc@oracle.com>
Date: Fri, 27 Aug 2021 17:00:11 +0100
In-Reply-To: <20210827153308.GA20687@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0230.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::19) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.175.210.136] (138.3.204.8) by LO4P123CA0230.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a6::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Fri, 27 Aug 2021 16:00:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4037919-02ab-45a6-589c-08d96973c453
X-MS-TrafficTypeDiagnostic: MN2PR10MB4078:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB407821FC171EB4BC31453C0FBBC89@MN2PR10MB4078.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	duK0/EvopV7uJRTmL5ViMub8dFOw6Qz4hcXfgk8A/RT0GS5dsJ6ZX5rs//Cm6f5xnx6S2Md7NYVtvP9eSvkIb8xIhdPLQGkmSBZl1JnaxuLfEfp+Ib1DTciaMMhvP3U04Ri9SLibCYq+9Wu6l422C3SoHntlemB+qaydpiQR8mwXNxogeh73LKiwv3hCuikt+orjmCcjgW1SRfSLWb5B+EEd81mVnpoiGKnCC5JVFAQjwX0zZMoW/WC9x+8do0Wz2IcJb9gs1Xb0mhS01Q9gn+Se5SjnJVZsffxHC54kzHrEqTPL5tV7GL7znl8zOv9pwuT9icVOAzxtLNQssfxwk2Jj3Kx3dbGqtirazOGUuMRMqoJrTzWRBX3YTfi9y52iMWgoeBnBS5uhM5aGw9OaqIqVSiEtL12/6KSxQG5cf5YdUD/wf4gsbqNg/6qZ8LLl/CkwfIZi5imAgQxCzekEwVfGm2923LWKkhlB7RkzpoCf0Bf/b3TRgRIrVBODT3ibAPpnXHY3usvTMptSMEMZQDNDLTa8H7pITEJfuJtc6ynyzAumqsplum/R4+YWRdPs7n2aWop1jQNJIqDafe801pYwSKmwdJqdnAMLsxsQuIgcIsWx6UrAZ8AtLkmN1vS0f8IR8s1slCQctzTCeMGsL6IwSVgHyGrrhQT3LP4WdDc96Nb0X4fyeA36Fj8YG4Bz6AAE5egY2zRFXpZjMUWgnQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(316002)(5660300002)(508600001)(66476007)(66556008)(4326008)(6666004)(26005)(36756003)(53546011)(86362001)(6486002)(31696002)(7416002)(54906003)(16576012)(8936002)(6916009)(38100700002)(8676002)(66946007)(186003)(2906002)(956004)(31686004)(2616005)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?alQyR0lseVpWZHVpQ3J1eTBmb2ZNWWFMM1ZGTE9rcDBlQUxYdDNmVHBGWjRj?=
 =?utf-8?B?aHFtbm8vd2hNRUZ3eHdjeHVsdjllK1U2dGZWdnhScExHVCtWVFZ0THN3UEh3?=
 =?utf-8?B?OEx4ZVVNZExPb1kyejRZc2h1T0NhMEE5akVCMmdPYnd1cStxWEYrZDRjOVJR?=
 =?utf-8?B?aklHbENCb2tmS1I2NVp4MFFiQ2h2K1hpQ2tXQmcvUG9aMzdxMXc0dEhPUTY2?=
 =?utf-8?B?aHNBdWRVdzJMamhnN1VRTVJJN2lBSzJMU0ptMm1VbFZPc3B2cFV0QkMxemZW?=
 =?utf-8?B?MVlHcDZLMXFpKzF6TmFMdXFQa1BzdWJmRDVBOFRRaVd1ZGJMZzRkU1F1Mjhy?=
 =?utf-8?B?ZFBpUy9iUG5kOStxTTdGQU1CRnFKUFV6TXBkbDNnQTYyTjB4TExmUFlNL1JN?=
 =?utf-8?B?a1V1YzlvdEF3eUdXcUdJUmhlaEhiUXpzUW1QZTRaSEJ4MmJWU2gzay9xdnBr?=
 =?utf-8?B?N2t0ZWR5VzludWtuZ0dYMTM2cFpPNDNySFljZXJQVTZrZFNWVDZQQ0FuYUdu?=
 =?utf-8?B?SmFRRU9WZzc1SEdBcW1helpzdHBSMDVJQXRiU1BXTlczMDArQU05OE9yZDA2?=
 =?utf-8?B?cWZwZ3lZWmE1K2d3QUxlc0VTYS83K1oxTS9QaE54TVlITFNRbnEwSkhJR2dT?=
 =?utf-8?B?dk40S2RGZHpXeTdGbmZqdWMrVHhYcWRraFlsWDQzdkczWUFKRUJQTFk3UVRK?=
 =?utf-8?B?eVdac0dlSVdmRW1xRVpCSERseG05TE9vYm83YWg4OFNmc0lTQ043cnJVMERH?=
 =?utf-8?B?Ri9PZnZQTFhrL2huWGh3c3JmYnBSNHFtZEw5TElBYzNFOWJENXlVazY5N0RP?=
 =?utf-8?B?VmpuOVJIKzZlVUhrSGRQelBqc3RsaUV6MmE1TkpEL0xhdFpzK2tPV3lrbnpq?=
 =?utf-8?B?VG9qemxDSVZwQUxaZXl4R3VKSllFeVZseHJyR2E1UytsNHNaVnFjbzBkNlcw?=
 =?utf-8?B?MVZmRXBQLythZWN6eTFXcXg5c05JM2RKbDVHLzNvanFLUnBvdzl2bUd1U3Bt?=
 =?utf-8?B?RTcyN29ZOEtxUlFOcFg4RFE0UmtrdnZjY0hpY05IT0VKeUdVV1Y3dTQ5Y2ta?=
 =?utf-8?B?RDFCRnRMMXJhWFluek5aem5CaW1uWSt4dFdVc0lVRi9sY3ltK3p2Ty96MVdZ?=
 =?utf-8?B?blMyeU9ZUDZCWWVSUmY1Y0ZoeldSWFhPckFRemZ3RnJWaGV2bCtqUFJRY2RZ?=
 =?utf-8?B?clZnYTlnTlRQVW1uRkp2eVArZnFzWVd5ajlVcVZoYXo5Mm1QbWtlMGprMmJU?=
 =?utf-8?B?RHZiWk5QemZOK3NQOXNUNW9VUkNsVTBIVzREWTNPdmE5d3Avdm80amRZWlRz?=
 =?utf-8?B?b3VUQkg2eUhMRExkZnhOQlovTjBlZ2lYZkl6R0VQTmYrNlBrYy9aczk1ZUZM?=
 =?utf-8?B?UGxzS3ZJajBqV1VCNXB1SEE0K1Y0dTB6QUVhL1VOK0Q3WkpxaWp6OGwwL1kz?=
 =?utf-8?B?T3dVV0NtQ01tMXMrR1pLdzNneVdSSDdYcVMrR2EvMmNBQTF6d1AzelNDc2Nm?=
 =?utf-8?B?SzdWdUhpeS9LUU9pT0xrK2dselJJdnRFRnN6OWRTb1BjOWN3NG9PVzBaY3ow?=
 =?utf-8?B?Qm5vbTZ0MEQ5ZURRS2JZcEtkWjQzVmJJcE8wQmZIUmEybUNHNEJRL0FIUDVk?=
 =?utf-8?B?eVdtNzQ4a0x1dERmUDdZb0FFeTJLbTBnR0g3bm5EcW1sZS9zNGZucHltZHAy?=
 =?utf-8?B?OHArdXRHZzNNaHl3WTc2SklDSDNITkpoT2Z2bmlJazlCMEprMUxFY2poZWVm?=
 =?utf-8?Q?/LRcbL18hbdqbpNNHQxP3XtLiFPq5PkwBFMwTFq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4037919-02ab-45a6-589c-08d96973c453
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 16:00:18.8286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JiJu6ZdBJAuEuV+79dXHGG53VDJrlyCJmtVkTB+sjvCpoHpczn2GZNTvPiLAfglVT8QcRBViFioCNcgEVTlM/RJE6PNckf1NZyp8vyXVJow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4078
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270095
X-Proofpoint-GUID: lT6q5dUO-aODRkrioTGgC2vsF0z-ua5f
X-Proofpoint-ORIG-GUID: lT6q5dUO-aODRkrioTGgC2vsF0z-ua5f

On 8/27/21 4:33 PM, Christoph Hellwig wrote:
> On Fri, Aug 27, 2021 at 03:58:09PM +0100, Joao Martins wrote:
>> + * @geometry: structural definition of how the vmemmap metadata is populated.
>> + *	A zero or 1 defaults to using base pages as the memmap metadata
>> + *	representation. A bigger value will set up compound struct pages
>> + *	representative of the requested geometry size.
>>   * @ops: method table
>>   * @owner: an opaque pointer identifying the entity that manages this
>>   *	instance.  Used by various helpers to make sure that no
>> @@ -114,6 +118,7 @@ struct dev_pagemap {
>>  	struct completion done;
>>  	enum memory_type type;
>>  	unsigned int flags;
>> +	unsigned long geometry;
> 
> So why not make this a shift as I suggested somewhere deep in the
> last thread? 

So the previous you suggested had the check for pgmap_geometry() > PAGE_SIZE,
but because pgmap_geometry() return 1 by default, then the pfn_end() - pfn
computation wouldn't change for those that don't request a geometry.

So rather than this that you initially suggested:

	refs = pfn_end(pgmap, range_id) - pfn_first(pgmap, range_id);
	if (pgmap_geometry(pgmap) > 1)
		refs /= pgmap_geometry(pgmap);

I would turn into this, because now for users which don't select geometry it's always a
division by 1:

	refs = pfn_end(pgmap, range_id) - pfn_first(pgmap, range_id);
	refs /= pgmap_geometry(pgmap);

So felt like doing it inline straight away inline when calling percpu_ref_get_many():
	
	(pfn_end(pgmap, range_id) - pfn_first(pgmap, range_id)) / pgmap_geometry(pgmap);

I can switch to a shift if you prefer:

	(pfn_end(pgmap, range_id) - pfn_first(pgmap, range_id))
		<< pgmap_geometry_order(pgmap);

> Also geometry sounds a bit strange, even if I can't really
> offer anything better offhand.
> 
We started with @align (like in device dax core), and then we switched
to @geometry because these are slightly different things (one relates
to vmemmap metadata structure (number of pages) and the other is how
the mmap is aligned to a page size. I couldn't suggest anything else,
besides a more verbose name like vmemmap_align maybe.

>> +static inline unsigned long pgmap_geometry(struct dev_pagemap *pgmap)
>> +{
>> +	if (pgmap && pgmap->geometry)
>> +		return pgmap->geometry;
> 
> Why does this need to support a NULL pgmap?
> 
This was mainly a defensive choice, similar to put_dev_pagemap(). There's
only one caller, which is populate_section_memmap with an altmap but without
pgmap.

>> +static void __ref memmap_init_compound(struct page *head, unsigned long head_pfn,
> 
> Overly long line.
> 
Fixed.

Interesting that checkpatch doesn't complain with one character past 80 lines.
