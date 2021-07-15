Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1DD072
	for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 13:18:09 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16FDBoii031148;
	Thu, 15 Jul 2021 13:18:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=stASEd4UPoD7xpZRSzXQ05U+QXf8bYdpaGwuW7OEVs8=;
 b=xWI2hrGDIM2mW6WOuNh+f/HSTDKcTcUoDnzhF+Vr64sEpVCAei2xEc0GURC0ZApeFMfx
 IHnuRA0cKjzvh6uKgiF5AFsqZWkUhQswf4P+zRq1tQQCBYvEhCvTVvel6Rx0kl3f8rF4
 1Kcxur1ntTzm3z+XkDyXkYjJvSOZ15QT2DZ070+6mc3DdbIOzXQtufrtykWk+39uqD5k
 A3ZpFa1ebvx4RfmYYooeeH0IbkjOXBXpaQrqMIVFOiLa3u+/7mYtUwpPstUigzhbzPrp
 YbewfFGVgT/IxZpcmspvBL1rK89OOe0JJON7dGJSagVHpwU9Z9v7X46viCHbdumkVw4l 1g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=stASEd4UPoD7xpZRSzXQ05U+QXf8bYdpaGwuW7OEVs8=;
 b=QQfU/ZXJoL765FLzjpJBZBFhAKgt0wvzTO4b44pVlrKO8brzVQo9E5zlXNtxIAePY0uH
 PpbIQKFDqrJe7zQSdMO+dM6REwjM9/IDDafq6lSq7FPDFgn+4ODh0dK8ljhnqhYE0k5T
 vpT1ArmDRkJokeFfcfCjqg8E83h3xImH9bjJmFHqTI+nyaj6yyKITHUUWgKObOEErTgJ
 qMusXmtLvJMzXFTmha4RfGcimIZ9JoHLZL7YGGlf2ScC+uEiV/sKaUvh1GqiE2IKO+Oc
 lSAS6x4b39bnqpShT3UQX/iDaJSKpHVmwY9lZhhB5s7RzBNmg+mtSDHRH6I+XP9oRhGq ew== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 39tg510pv1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jul 2021 13:18:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16FDB1OG119798;
	Thu, 15 Jul 2021 13:18:02 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
	by aserp3030.oracle.com with ESMTP id 39qyd2u2b0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jul 2021 13:18:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NzeVPd8qGBmnRw6D8jMnAXEkqhNCZBc+2ksvNoJF0Y8OQe7t8n74kmiEZGXAWuURaR/roAyOPcG0VxIqW6aGuwEy0+7KPaV+nhp7rkOtUEGR2mq8dq5YS40Q3V0s3c3pvsWJSaM3DL/IH25SB+9BwKnjK9QfrDoPSIVHSEUDr6lIDKYKEQo7SxRwIbm1qOnhtvzMCq9qCDmilZN+D6hzN6k5VF46Y3EgslQWpsV6cP/g2lNFs4fUGcFfceUbUOuLx2EfSkXoGkO3rRaFzS3DqcPQTXA28FKbiSwGC+Nql6vjvkyRRf8aCd78+HgWXybKja5LOqYAVyRUl+0lpH3rzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=stASEd4UPoD7xpZRSzXQ05U+QXf8bYdpaGwuW7OEVs8=;
 b=D6h9C2l83MxtKBV9tRzKai0cUy1m6jc7z/7BQFjHmWwQGJku2l29j+WlD8k9l4g20jXLOtlyk+cMtTZm94pU28lEBGgBjxmjEwgz6M7uZ+sPlhGvqtT1rwOpZB849ICkqa9wZXdWHg0t7VeY59vWGkdqgfs8XUXPMc+SUKP5cnBnLYA/Ij2Jyusf2pjK0By0iM4/86cYTWfM+ADgEUVLH/CGDJb0N2szksnq+wPHh5DAfHQgDJFli/RQsldyfVEWwP64eAfHyDUpxVbnQgv52aykAs4NgJSDyft+4jsmUqxWSgehBN77buDUTXUCqhOH4TIuaNnGsZ3YUFihDG5C6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=stASEd4UPoD7xpZRSzXQ05U+QXf8bYdpaGwuW7OEVs8=;
 b=zlJj54QsqMm+BuJGslam/6vjAZdySanTHwUqqzyJHQHoxxpchpyMIBDnqxcgMSc62bT7KUSR0/j7zK3hnh62IXZG5rE+M1I80XBc9SFDj9IB+DsTXWRs357difKr7jJ7TzRHqCJJS/t89d3gfpwC6h9IFaw/hmWxu8Vgnl4T514=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4142.namprd10.prod.outlook.com (2603:10b6:208:1d2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Thu, 15 Jul
 2021 13:18:01 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4331.024; Thu, 15 Jul 2021
 13:18:01 +0000
Subject: Re: [PATCH v3 01/14] memory-failure: fetch compound_head after
 pgmap_pfn_valid()
To: Muchun Song <songmuchun@bytedance.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, nvdimm@lists.linux.dev,
        linux-doc@vger.kernel.org
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714193542.21857-2-joao.m.martins@oracle.com>
 <CAMZfGtWhx71w0b4FM_t2LCK-q1+ePv6YQtQat+9FozLPnN4x3Q@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <b13ead05-3570-f722-028a-3485cd56ef00@oracle.com>
Date: Thu, 15 Jul 2021 14:17:54 +0100
In-Reply-To: <CAMZfGtWhx71w0b4FM_t2LCK-q1+ePv6YQtQat+9FozLPnN4x3Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM9P193CA0016.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::21) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by AM9P193CA0016.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Thu, 15 Jul 2021 13:17:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 381fec0d-9a2c-426d-2bb2-08d94792f892
X-MS-TrafficTypeDiagnostic: MN2PR10MB4142:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB4142ECA9F41361855496667EBB129@MN2PR10MB4142.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Qr/s2Dm1Z4BBR8GHry7NAyTPI1vZ5msODyOMGay+oAsxghW2FiQopXa6Sf7k9qp4E1eS8IQRE7NukMlFSxFdH8SIIShUPI0ElPUxo/xBkWGP4eoeaN4lMEVXD2MSQQTFkhvuaD5IWMQzDPHxYZKYSCBSUg+y9Z/As4uQq0qfR8Qf9Rms9Ij/NnjpaihL8d5WVD4gCh2Mx8puELE3OlhpSHos6ytOyxnmTZeCccOHeuxSd9msnBkJ7R9PDqOcl0aCE6EePuTuoolELVGcwgt64/RwDOUZSIsvnJ6oicaEJ5gK0pJ5q/o9slIyJdULRie2YEe/QMAlLeNA1f+CoNLgsPtYVMJh9wIES7M8A30XA0snhFYPWxRZDOYkoB+IUxIbAVqC3/w+jIh3LYoYGR4Gl090EDp6kSLtDwrL8QnAILJW+JtQAvn5ao1YVxwEv3nYTUQv2ot0RuSSog+Doorkhm8syhvx3ng+LrYX+j9hQfTZEZNqrMBhdn0YhNGDqmMcwA+xTIGnhSn/2bbMXpRU+BPBtojFzzbkkdcsoeVnEYrC/iryezWG3YqSh+8Ns+Fx738dU/X8dyRVM7eVa5WxJVmnD1Sh8V7B/c0TCYrwldUMorej8pWxGGK+aorkzH12F4XgQCOVcQSJH1cLd3n/dSBLa/HSiCgM4mAkKaLDugweC4eAKKfkJWATn1VBphs9pztz7BxgGQKh/g+YNo12bQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(376002)(39860400002)(136003)(86362001)(2906002)(26005)(8936002)(36756003)(31686004)(316002)(6486002)(66476007)(66556008)(4326008)(7416002)(54906003)(16576012)(478600001)(6666004)(31696002)(8676002)(5660300002)(956004)(66946007)(53546011)(2616005)(83380400001)(4744005)(186003)(6916009)(38100700002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MGRKWUIxSTJuWHlxdzZsOWI1SE1pUEZCelJsR3dVb3ZHOWk2RE04cGxQZHZ6?=
 =?utf-8?B?VE04UlR4Mmw5ZDRwVDJOeXgzTWI0L0ZLSm8vYytITHhHZGxsMzZOVldrd0kx?=
 =?utf-8?B?TzRUemlrM1p2ZkxZclRUWWd4VFFWRnRzYUYzYTFoYWxjRXl5MmNyT1hEK3hF?=
 =?utf-8?B?dXkraHE2S21aaWw1Snl1bE5RTFlUOFkxeld3ZkE5R0wwZDFzRTNBNU5aaFZI?=
 =?utf-8?B?WTBvVXNuNzRYckdjM09EZDNCaUpwVks0S2FibExEUmQrK1hjUmVlNm9TeGZV?=
 =?utf-8?B?K0FSNnBUNE8zMWVSUDg1am5tNEJleFFLbCszUURSaHEvWW56bDlIZGU3MHdJ?=
 =?utf-8?B?azRYV05kUXZFc0xRZnAvUkIrb3JyVUtyQ0lCYWMvY1lSMEtqQ1VjcUpSeDRV?=
 =?utf-8?B?Z05DV0lrUFlsSEliOFpyK1FYVmxCK3hxVTc1aFFFVEI3UEwwemM5T1M5OFE5?=
 =?utf-8?B?UVYyNStXOWVRMi8rUU1yUDl1QjMyT1ZwWnl2UTc2ZUg5R1BBa0hjRlJ0cits?=
 =?utf-8?B?UlNkb0l1amJDcGt2VG5PQ25iNVIrUHFwd3QyOTgrWSsvQ2VMYmlPR1BqVU5Z?=
 =?utf-8?B?dlJoQm4yc3pNOVYxSEtJVVMwd0p3bXR0UUZ0L1JPSVZpTFNHRDZZRzU2cDVH?=
 =?utf-8?B?Zk5HZ25Ec2FhQVIxcVJUdmp2MFFHM3FjRVFJZFVWQk45SU45MW8yemQ0ZnJx?=
 =?utf-8?B?aHNWM1h4Q1dpMk1maXQvR3RzSXk3aDNBTzEwNE5DRjFmSnU5Z1RBKzhsZ1VM?=
 =?utf-8?B?OFIvaEJFNGpjdUpGMnFic1FZTyt3UkJZZmh1ZXk1cjZJdys1SjNHN2k5RVgy?=
 =?utf-8?B?cXM5QS9DMnpEQWdvbTdYWURnQjJGU2plVUxYS0xSRXNSQ21vZFBNdmhaQ3hP?=
 =?utf-8?B?VkQ5RW50TXFmUnZ5L1Zua1NuUXpwQUM1VkhsYStNd3JYRlAwTDlQZUNiK2hY?=
 =?utf-8?B?dFRRSWFUcEs1MkVKZ0J0OE5RSlNpSUFwa3hRZG9xd0Y1dlhQVStvZW9RUVN2?=
 =?utf-8?B?QnZ2SGtwd05IcGhYTS9TUjROT0hNWDNmVXhLVm85bmlRa08yWHA0UDV3cFFw?=
 =?utf-8?B?K0JsMmc1VTAwbk4xbmltWDR6YmdLRDAvemxZZmxYbXplYUZyd1NwMEtEemJt?=
 =?utf-8?B?bE9PQld1ZzdEOHhtbit0SDRCTmgvVXVVSnorUjJlcVF1MUhnc2xpVkNBUG8v?=
 =?utf-8?B?K0NCVmtXSnlyc2lCeFBvT3k4dVRsaWl4cHVEQm9QaHFkYTEwQUZ6bld1Q1Js?=
 =?utf-8?B?Y3VvM1dhTjlXV29zQ3NBQTJLMnJaaGFxSSsvOUdSWk10Q2NRSzc2UEIzcGxX?=
 =?utf-8?B?ZVladTRRbW84YmRSZ2F5eERnRVFva3pJWlNNT291Unl1SGtYYitUNHhQZmxR?=
 =?utf-8?B?SkxsRnJIblRCTDFKUjhHenFJazRLbEgrRGMvWTVUVU9lMktJVkxZUVQxTGdn?=
 =?utf-8?B?bDJkdG9zRitBeFlTU1VQNUd0NjFSSUgrazBCUGhnRzllNEVKR2daK0N3T0RU?=
 =?utf-8?B?RjRMR1BObmZpdEFtUFRZdW9jcmV4YnNTS2VUVFhydmFQNzNia25XeVpSK2RK?=
 =?utf-8?B?Qk53UFYyMWFIMGRMN01OK0t6SUdueUpQUFliUWFic2UrUGlybDE3bXRnazZh?=
 =?utf-8?B?Y0ZpSzRUSytuR0hNZ01qdlFxOGRZTXIwTXdBaXVHQ3FnUlpSdHBDQTdEcERn?=
 =?utf-8?B?L09qc2h5NG5LUGFmRVkwQ3VsUXpLa2htQTYyNkhoZFlhTEJNb2lDRzVOL2Z2?=
 =?utf-8?Q?/3M+kIn3sjokIegeI02ZWrsw62ea/QNqSDG4GiU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 381fec0d-9a2c-426d-2bb2-08d94792f892
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 13:18:01.2046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R8te9HtEfBY7gsYXpvCkL45ijNk95Qjg5cHSLqQp60l5bBRYq4d2SBHlSqJShG4jBGpolrYIMAOYMVnUUULC41ItrmuclKBKrjwnv+sU35U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4142
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107150095
X-Proofpoint-GUID: MFpoCRFZwdlSc60YT06whRZ8jz97urrj
X-Proofpoint-ORIG-GUID: MFpoCRFZwdlSc60YT06whRZ8jz97urrj



On 7/15/21 3:51 AM, Muchun Song wrote:
> On Thu, Jul 15, 2021 at 3:36 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> memory_failure_dev_pagemap() at the moment assumes base pages (e.g.
>> dax_lock_page()).  For pagemap with compound pages fetch the
>> compound_head in case a tail page memory failure is being handled.
>>
>> Currently this is a nop, but in the advent of compound pages in
>> dev_pagemap it allows memory_failure_dev_pagemap() to keep working.
>>
>> Reported-by: Jane Chu <jane.chu@oracle.com>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
> 
> Reviewed-by: Muchun Song <songmuchun@bytedance.com>
> 
Thanks!
