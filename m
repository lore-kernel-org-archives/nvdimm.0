Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C987072
	for <nvdimm@lists.linux.dev>; Thu,  9 Sep 2021 09:39:25 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1899CKtK029664;
	Thu, 9 Sep 2021 09:39:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=rUEX/3dZbtgS5FwMi5oWlv43LsLd6iKCeggMUrjCJeo=;
 b=Hgj30exnBsPqtOIFrkuMFgeDxSdArKvTyhVczPmTp/ZmI7HcBSy12LLpaOBbEIaeuoX2
 xOdPHyeXuvXqaRifub8XEgsvxtKnFB0oM2UYEJ+zJrUcLikr2sDW4eNqIkjWgvAzmyYP
 dKosjsN22sETu8mMqR0JM70wYRJA5XUimfyjnC4OBWSlpklj9/jU7mCTpNlugko88p2L
 pEuGJ0lRj88s24fNswDboaZCLYhGWudsPM1DrHGFxYLz6qsFzn23ggOZuOUoauSUmCeZ
 usTpYn+L6rkCrmmu64RJ7WKvoujRI2BjOgu4xTE4/+UdtOpCHe7NG7gWwSUvYpdGgS/y rQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=rUEX/3dZbtgS5FwMi5oWlv43LsLd6iKCeggMUrjCJeo=;
 b=si9I7qNOuy6C7M3/xrCTpsR+q0XQrv4g4AcC4rMin8yMFOsdz/U5VuEUiiPiilJjmXH3
 YgMgMGNl4Zh1pchhG2hvBeXUBzsw6l1mhvb9tMXTOflCakAZR7hIy6Rq/1NThIOLWewt
 mn5HOqQ/fBmSqAZiFU7GQeiI1K3W5wnU77gFldYjgLadmNmBAvo6yssA0ZC/2ZKDUDZw
 SNmad7oE8ZHYqEl8/e/VdHiqaJ2eJqC5CEGvib+tmgOmkryUcWFA4E6b9U74gJzyelOo
 4GdFHmlm+1kz7Gy9wV86ZhKBhS3iPKJXdsZpCnRE6CX31fFAeJ9z7UPsBxAS/Vpfhi57 fw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ayfe9022v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Sep 2021 09:39:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1899aH69046998;
	Thu, 9 Sep 2021 09:39:02 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by aserp3030.oracle.com with ESMTP id 3axcppyn0g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Sep 2021 09:39:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4gdwSgVQ9DCETe8q0bappHGLjS3OCWbwnckzR/bK1XKl4QmSE4WAg8MkHQYWW4uOkmppXsHhSjeEbcww6efw7QJTA4HtZKwHsXG6ndGOMKgvta0D1F3Zw1392cRlnfOOiiR6InJBM2ouAl9yNCXcZKn1m27UN3wH1gZV41ObUsfG7j6tzrL1H+jsGo237+RgBtWF5+S91jR937LHk1fHRVMUdXJxoTvRi1D0G9+7lkhh9bKg3IhaedVtbfw7uCjpTKMwJkyOr+0YkXzNgeJYiNVvGhkOfnAozUZmVki/OcIonHZ3zcMBB5Pqz2aIdVvIKu2ugT0Vki0HCyobwY4nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=rUEX/3dZbtgS5FwMi5oWlv43LsLd6iKCeggMUrjCJeo=;
 b=ZMRivpW8hoSkpRBt0vKN+wFzuAoELJld71/vCM994CEmqFo/TmKMKp/dQ5HQrZmB8hHEGTLbeWijB4WImzfmJY+arhgw4h20AOajoO6knw+t99IPS12/NJUqV83V7S9K8Qf5WUijRv620dRy/G2gyA1Zw4qDJp/KthTJ4SxjGKoeFZQh9qbSwSlvLJVVoxQEVR8hrr1MTzGLiyDQqHy0iFmbqNMDyxZME8MldtDjxRG6bWhMSoNl9P+l32FGR4zQ7nW8SU6s2oSMaW9zWH/bYkUvBr7cJgHxEo+A+7cyXNJL2ZPKb6g7U/rX3Z//joS9O8IUv7lkSQUUWKb04zHahw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rUEX/3dZbtgS5FwMi5oWlv43LsLd6iKCeggMUrjCJeo=;
 b=Gqx750FXtEq6xMeOfghVAz43ywaAwoI91RNqNO3ZK43kndnjLP4rennr6b1n8ST3/fFOemX+dA6GPuqXVuJbsgKRd3xWmr2uxavfgYx2UGE8bt4RYZgN78X4A0O8AltiYjnQhvxavhsw4Cyk3XujzuNDhrUfN6KRAaeKszTaPsM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4979.namprd10.prod.outlook.com (2603:10b6:208:30d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15; Thu, 9 Sep
 2021 09:39:01 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::bd25:67f1:655a:a615]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::bd25:67f1:655a:a615%7]) with mapi id 15.20.4500.017; Thu, 9 Sep 2021
 09:39:01 +0000
From: Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [PATCH v4 04/14] mm/memremap: add ZONE_DEVICE support for
 compound pages
To: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-mm@kvack.org, Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi
 <naoya.horiguchi@nec.com>,
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
 <9ee23c67-e600-555a-85fc-d527b1484bcc@oracle.com>
 <20210901094446.GA29632@lst.de>
Message-ID: <f5a72a1e-7f1a-db47-4c31-512e86a749e3@oracle.com>
Date: Thu, 9 Sep 2021 10:38:52 +0100
In-Reply-To: <20210901094446.GA29632@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR06CA0140.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::45) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.175.191.221] (138.3.204.29) by AM0PR06CA0140.eurprd06.prod.outlook.com (2603:10a6:208:ab::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Thu, 9 Sep 2021 09:38:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aefcac57-3079-4736-5224-08d97375a772
X-MS-TrafficTypeDiagnostic: BLAPR10MB4979:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB49797B44E87DA4C2D42D7E09BBD59@BLAPR10MB4979.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	/wgD7LzHfvn1ru8BwQUT4NTbcjqlfz6s3YNCU68nc37UkxFmc2gIZ+t22F6ApI3fy3lEBhajySpq2QRvTw6QTHB0W7q0fmuUdVgBw14yYDSzcHqUY9tBvmcIc/ArOEbsd8qvaFLN68yCcxUh+Tg2yXFCq4b1l/DsepzxUSMC9Lr3qYf4JJlzDf1KabIGfJltnQl5QCbwggWZ9gExeO6clj76p99mDv0lApdXdtO01nC38xXZ+zkJS3l3+R3+Aq4Sf8+WI2+8u6XsDtY7Q+iquVLYWlACY/RSO/hkU8e6m/8NwDUF96t5lVUK/nmp1d5WytU4+fFLkodEgNKzgeGG5+SGk/cLqOJw3ILnCAHx7MPKux4LupdafZagL8+r9N8/QItW1Jw02cUb4rPfVYh7KXA4HtouTyFw//Zj0ngK4vz5G9EEAVyahzHUFxkm1bn7yGFlJ3ab/v1qxHc8Ws8GlKUCw2ILxW7TBf0LpyghyItowLXnk5ZNq1IE2foU/Zmxl5jCr2mKjMfFj7VnSm7rYEvWa1KItafuvLREfGW5ViuH9xiSvLNxhYfQpQGuU0zYnqcKYoFUUFAr8Em6KYJar/YC9qtfooonEWp5+8B/TgFiI7rMt3o+087BE/UB9BPOu0WyTIljP5TLqsmtTxLVzW5YCJJf+zHK0AbHTNyfWj3yuYPhqhyMWAEo+HSSHo0LF5HH6eYhfjxaXnjf5brnVQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(346002)(396003)(39860400002)(7416002)(26005)(186003)(478600001)(66946007)(31696002)(110136005)(2906002)(53546011)(54906003)(83380400001)(6666004)(66556008)(66476007)(8676002)(31686004)(8936002)(2616005)(956004)(38100700002)(5660300002)(316002)(16576012)(36756003)(6486002)(4326008)(86362001)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Z3FrNUdkWHl6WlpkVmJuQWNVMjJyRkxPSlpwUXZiTmNXNnVqazZkc0R5QlFm?=
 =?utf-8?B?OUE3RDN3blV1Yjk5aHNIVkRRMmlxU2pWcXM0Q3VvSm9SVXB6b1pTeEpmZ0dG?=
 =?utf-8?B?REphL0VoWkx6ZUJudmhrWjRyZ0c2YzJHdFB3MTE5b2pWY3BaV1ZPWThVU1hH?=
 =?utf-8?B?MndSOU1hRDFkS24wWm4wL0tKL0pteUJpM0xpczVqeUhaenJOSkprY2NHMFRs?=
 =?utf-8?B?RmQrK2pFczJHTm16MXhBZzRSTkZ0VktjSjZhb1NKZjdlQXJpQ3FrQXpVc3Ni?=
 =?utf-8?B?SkRSTi9EeHg0ZHRZcm9nZjE2eUkyM1Z2aWRrR3VYY3hGWFU4YkRPV0tWVFVE?=
 =?utf-8?B?cGRRRms4RHhSNjBMQ29WNFF2cWR1YVhNaDYyU0RHUmpsbEdJUWF2N3FGUC9L?=
 =?utf-8?B?RmxqRzFmVE13QmwvNzVCTWFuRHdjSnlCcWpMS3hhaUZ3d0I0eHo1Uk95SGRn?=
 =?utf-8?B?QUhPNVVXQ3FVYWtHQ2VoYmVzVU56dmR6MDhVeFNudERRT1R5NkV6cTdrdVk3?=
 =?utf-8?B?REd0dFZOV1d0aDV5amhTVHpUUm9mMEgrcS9RVkFCQUJ5c2k1TU50bGVFOUln?=
 =?utf-8?B?MFlZTmM3aFJobFdyL3hLeGRvWFY1ZkZRNUFpYWFrWGxlQ3FWWHBNMXQ0UmVn?=
 =?utf-8?B?Q0FSTnVSNXJpUE02UGlCcUNMY0xTMWx4L2J2RmllMTc0TzlUWnpML2FuOXpt?=
 =?utf-8?B?QlJSOTE0bG5MeTBMOW44dFJjQVVTZTdlL3dSK2dkSUpOOXprb2tKdGdlZkN2?=
 =?utf-8?B?S1UzbS93bjVGNUZQLy9xYmJXWEd0b25aQ2hYWWFtaHltekNpMVFXbkc2TVFF?=
 =?utf-8?B?V2JhVTg5WG9idnFTcGJoT1FLU2lWOThNQXg4YmZZWllvVkppRkttTlZaYy92?=
 =?utf-8?B?aUVCSERNUGVsbjViQkE0Q2F4Y3lsUXlwM21DU1lrakl4VmM2bEtaWTRRb3FP?=
 =?utf-8?B?cWQvNjB6RStWRXZXSkNucVQ5SWtJUkNXb09rY0FqQmhESmo4eVN1NXRrZVky?=
 =?utf-8?B?dVJrZUo0b2U5VjM3N3VHbnoxaXNvWnVFQnlCQTBueDJOcklBRXBUU0orbzc1?=
 =?utf-8?B?L3ZTRkJsY2hOcFFwMHhQUkJ1VW9iY0ZYTHhpcStKSFdzeGZSazZ5S25XRUNM?=
 =?utf-8?B?eEdtalRyUU84SkNlR1p3K2ZLazRYWUJUTEI1Q3NFOWIyQThqaUw0anU5dmZi?=
 =?utf-8?B?c0hwWmF5ZkMzWnBwS0V4U3MxNW5NcWVGbStXVzhrNk1vZUdETVZSaHcvWmZB?=
 =?utf-8?B?VGloeXdtZXA5L2lTWlFyQXhqUGR0SXJWWmtVdVp0TkgvZDBBQ0FKcUV1THVH?=
 =?utf-8?B?TU54c1AxMlZSR21ZY0RJZGN2bWNGR3JuQ1NucTUwSFowZHNtcUUvTGtjOHZB?=
 =?utf-8?B?MHZ2dVdTNE91MEFRTUZTUFEvNDR1S2ZSSGk3SnFkRkkya0hMYWU0c3g4ckk5?=
 =?utf-8?B?T3JRdHBSMTFzSXRSR2t4d2cydHMzQVZtK2huZEo5Wm4zamNZM0lHRlNPK3M2?=
 =?utf-8?B?d2MwUWNFUUxCQTBoUkZWT1JiNnh2Y1gwZFB1VDBsOVFwamdWYmUxUnNlamts?=
 =?utf-8?B?TmVyQ3VNTFpLUlBmbXRZZXBYRjNyZnFoZkFTU0R3SnFMVlBZekpFc3BVaytM?=
 =?utf-8?B?WlJEbWlva0hVM09vOXZCUTRublJJemxUdXJmM3FmS0ZVcll0bVRpSVNRVW5Q?=
 =?utf-8?B?bGpQSmtnSDdVdUdEb0VFSTZlaXlXV1YwdG84QXI3c29JZE55ODR4TUJtRjhF?=
 =?utf-8?Q?bRd5Eg2Bdxa/1bEYL0jsjp+SuCGBwHgoZqJ30z5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aefcac57-3079-4736-5224-08d97375a772
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2021 09:39:00.9660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e/SUBPR8ofPwcT/yE9X+ognlMetePz9udgl8lTSFmEFsd5koROC68YF+io64qSflfqcp6x/HEY5gJUHpjkzTRsj1WkNzCdyubqqBA1TECeQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4979
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10101 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109090057
X-Proofpoint-GUID: 5kitljgLI77z5pRY8lRv9LqJ2eZSoTCG
X-Proofpoint-ORIG-GUID: 5kitljgLI77z5pRY8lRv9LqJ2eZSoTCG

On 9/1/21 10:44 AM, Christoph Hellwig wrote:
> On Fri, Aug 27, 2021 at 05:00:11PM +0100, Joao Martins wrote:
>> So felt like doing it inline straight away inline when calling percpu_ref_get_many():
>> 	
>> 	(pfn_end(pgmap, range_id) - pfn_first(pgmap, range_id)) / pgmap_geometry(pgmap);
>>
>> I can switch to a shift if you prefer:
>>
>> 	(pfn_end(pgmap, range_id) - pfn_first(pgmap, range_id))
>> 		<< pgmap_geometry_order(pgmap);
> 
> Yes.  A shift is less overhead than a branch.
> 
OK.

But FWIW, the overhead of this shift or branch doesn't matter much
compared to the rest of memremap_pages().

>>> Also geometry sounds a bit strange, even if I can't really
>>> offer anything better offhand.
>>>
>> We started with @align (like in device dax core), and then we switched
>> to @geometry because these are slightly different things (one relates
>> to vmemmap metadata structure (number of pages) and the other is how
>> the mmap is aligned to a page size. I couldn't suggest anything else,
>> besides a more verbose name like vmemmap_align maybe.
> 
> It for sure isn't an alignment.  I think the term that comes closest
> is a granularity.  But something like vmemmap_shift if switching to
> a shift might be descriptive enough for the struct member name.
> 
Hmmm, it would be a 'shift related to vmemmap' in the literal sense but
while descriptive of the field it doesn't tell much otherwise. geometry
is probably used more widely for block device term when Dan suggested
the term. Alternatively, vmemmap_compound_nr / vmemmap_npages (if it
represents a nr of pages per compound page) or vmemmap_order (which is
more clear on what it is than vmemmap_shift?). Changing to a 'order'/'shift'
representation also gets the 'being a power of 2' enforcement for free.
And compound pages IIUC always represent a power-of-2 number of pages.

	Joao
