Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B82F3483
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 18:59:36 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SIpR6w016135;
	Wed, 28 Jul 2021 18:59:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=i7hEJBBP7VkakPlqVSK7NI4OzF48dJAYKMMyVepF2TM=;
 b=gVd5dO1G3OG3i2EWp7T96JZXXT6t/WoEiot1vjLByuwTrogUI/ZTvOHHoVLV9z5FwqEs
 xfXZBPIweAhZc92a+tvvj9UuUHfNtBOQELvrP4KqmhRdWUkWPT8bTF9dPShi6K7Uybae
 QbspG3nrpAPbn2ySg2rlsE17SDlIlpOVvGR2AWzIydmC11Kvp1cTTxLpOV4ks++aFuIZ
 ZGMv6NlN7LoU0AwMTjDucwrl9LuP8O0CzlVqDlpHVGwb4ZCdmRaDxXsGxbMpTJ+jFz4m
 hy6+Rc2G4MN8zmbVDYiNxKNJSsAqZ9qDsjagbeAUee3GnW1I+ov/FHglnAGZcjG1RlJi qQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=i7hEJBBP7VkakPlqVSK7NI4OzF48dJAYKMMyVepF2TM=;
 b=XanJRORD4CwgQfGEBk0YIrh4SAotbbBh0TmwpKcJikrRE5rLiv/EgPHwPUdSpPqIM5JA
 f4vYAWuLE2Zsz7CA+Cr22+2d2dF6uYARx7e5HscvYHdSa/xWvAMg0pn9SzRgIxLibHzD
 d0vi3ik0Ablsk8WkFpRBFC5GGho8XVqg+sE3mi6L+vYdXSGsnDhlpVM+7IflvfAc4HX0
 XlJWQqJnfAXkdMXUYhuwjzKSApRdJeGuY37+xVx4PaMrYReoCMUqfOrLv93FBq0Tswfd
 y1LwVGrvlc1Ue+eIS1t0IDbB/xy2uhembHq6D25ibYsLyuKK4hwmH/7hqV0tFXzwAJDG mw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a234w5gs4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jul 2021 18:59:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16SIuw62044100;
	Wed, 28 Jul 2021 18:59:27 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
	by userp3030.oracle.com with ESMTP id 3a2355u256-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jul 2021 18:59:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NByL77na94mVkHayScCOoD/Dj6cjx8xuYRJrHTkSjAjMCvWNvp42XaqHYA7fESgBf74vYHEbRyKGGcaaLWySv7AeJWuRzkiAIrbdRaDLDwGnf4SVi8Pcvw0ImWzk2Q8D6gT1mzJkZm8Bj6lqW24vmra9Ccrs8pX3DhRuewOPD9+cixGJA9gd7kIYr39KlRcA9/sWb1O2iPufoDjkt+SuEgcaZcTqtPnolrXc/d1/WMDMqbTDhzh+/CuiM684zmIiT+gXlYBDnE4Y16Zp3UeuGwDVbut1gpFo1fnh5WgfhWefUODzV0tkVl/gBRZP+gbcJ0K/hqI00qpIMY1EyKTqvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i7hEJBBP7VkakPlqVSK7NI4OzF48dJAYKMMyVepF2TM=;
 b=FxRy7fK4mwfQjF6YxzGaHudBqQCagfBBvVTrB/1JCfPPvCVj4c2xGdngP1+Te1qquATTv2rmcF9nzVq43dDOT3Dn/BHEJS9rgW1+rVIEnMxPzn1/k5WjPvVaZjueNjvstaNfHww1nE2k7P4clCUIhgPsmcO6527YI+Fgjdx+qr2HZyU+g9W7f/mSKVTld+LjMa+XTtVZlEfccs1TId9Jc+dqFqdjJLjnENYfcIEpkY0OhJXHTkOug15xj3NIMWzTsJb8D5IB1tAPDXwC1pUsx+Bk7JtoIiK5eivlcW4O+r4T7rIdfDcQ1KA2Cdt0EWWPz21Pla1XTm+9aJOLA3Q+bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i7hEJBBP7VkakPlqVSK7NI4OzF48dJAYKMMyVepF2TM=;
 b=Z0a3dccKKf9rE72S/zuV4RFoS6LvJNr7tZRS7tFF0WtyF5AssrgcDuRPfqR7mnkDthPjGyPv/aRvzPoSAXzAjdBbhnmkmv5YZ+vm+wawljpb61W87K/BT6c5hs+9AuIE7eh/mKAunwe+rkzeuQrMShoKQzPCknpveWBVGgEhrHs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3981.namprd10.prod.outlook.com (2603:10b6:208:183::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Wed, 28 Jul
 2021 18:59:24 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4373.020; Wed, 28 Jul 2021
 18:59:24 +0000
Subject: Re: [PATCH v3 12/14] device-dax: compound pagemap support
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
 <20210714193542.21857-13-joao.m.martins@oracle.com>
 <CAPcyv4h5c9afuxXy=UhrRr_tTwHB62RODyCKWNFU5TumXHc76A@mail.gmail.com>
 <f7217b61-c845-eaed-501e-c9e7067a6b87@oracle.com>
 <CAPcyv4hRQhG+0ika-wbxSFYrpmMJHxxX456qE64PMxDoxS+Fwg@mail.gmail.com>
 <156c4fb8-46c5-d8ae-b953-837b86516ded@oracle.com>
 <CAPcyv4hmoS8QSfBY6z07w9Ywjdq8WkROFVn3b_1bsE9i9_j3UA@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <e07e82d1-9310-6ee4-2336-79973cf460f7@oracle.com>
Date: Wed, 28 Jul 2021 19:59:17 +0100
In-Reply-To: <CAPcyv4hmoS8QSfBY6z07w9Ywjdq8WkROFVn3b_1bsE9i9_j3UA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0231.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::20) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO4P123CA0231.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a6::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 18:59:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b013188-616c-4856-7fdb-08d951f9d12a
X-MS-TrafficTypeDiagnostic: MN2PR10MB3981:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB398103CADA5C04DACCF18184BBEA9@MN2PR10MB3981.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	qYZcuR2cmxCm911xb9n4Nx57qqA/gzmfbkvtpEoz3Di+5Pg8n82aP04UxOgjwcU1vM+i8HLRQBlfO+NjLPXT5so45DxKHnM71JH63HugI3CewY3vPhumlDhGkG2LNyPLmf55r8/uyA5QkXXrerh83bv20x9NNotB6Scci7DBMd8B5MIWoo8VvaDTRQhMdREgT78xfxtXc1lxx1qYXQvaamyjPvTkS+TZJmbF9sJ6jJhRdEd7hrzBTmIHAlzKAgqFNZkeO7Fh8VypktVo6VlMRVx3f4qrKzmvPcX9PXNBHvbs2oKv6jKiSabyosmDP9KvNE/mPw4aUVEGPoq21Y21QhfclblEJJxqqeHtGsW4N4x2OxirU4urpe4v2xRQGGCdesB1BQ0P/ucWQ7eYgJqiqxT+3yRw2MthOEV7ucIPbGnpzLAto55ETLlcGfzNK3V8RU7+yCKuOnBfueP2/UDSwkunRls38Fe1ECmIAej/OvHEphJ0/KEwKHcoq5gjJEMvau0ZgsxKKlpYjqbmq0QkTwtG5kI1VKFcbErPAUC422jWGTS8p9iS8LuiX6ji9VKQ1Na4xIENY5EpwIe+xG6pkfqFxeRg6MlLrVokVCjovG1yexvOKdOwXdzb5Aetswuu2HKeMNrF2cYcFxldF531rSx5G+CEWvWWM88paZTtSrxoRo6FENcWr4uSjRm8zBfZxkKoacy5G8/6ngvUX/t1yiAN/OjE8w/tTyBePJJAzfBZ5RZY/mZfCDzy7EqPRP2ed8xoGcVpPQupBv2wBb8P+4B2EQmuJCqSEEYUhLknps38eiFC36Iek+eKP5JQPqNa9wlZECQJtausjfkJ0qE3wQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(376002)(346002)(136003)(956004)(7416002)(31696002)(31686004)(53546011)(2616005)(4326008)(5660300002)(8936002)(36756003)(6486002)(38100700002)(6916009)(54906003)(66946007)(83380400001)(316002)(86362001)(8676002)(26005)(186003)(66476007)(478600001)(16576012)(66556008)(6666004)(966005)(2906002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bmVpNmxONHFMT1pFaTErVnhsc2ExVnBXVTRyc0J5dWVVMEVyMm1ld0ZBamlN?=
 =?utf-8?B?YXBqYlhlUzdKQXBUdDVSWWZuem80SlNsa1ZzNHRYSEl5eFZRYWFITTh3Qzhr?=
 =?utf-8?B?Y3ZSWE04UnN0K2N3RFE5ZXlrWnRwV3ZGem5QamlQakthTVR5anIwdVl0aWhp?=
 =?utf-8?B?OTBEb2xXZXkvdGxhZ1dMZEkyNFV6VUVJaXM4dGVER1MzRUxpcFVpdmtkbzlO?=
 =?utf-8?B?TEdQd0x3ZVRoKzlTeEIycCsrNmhCYnh4TGFSZVMyaDIwTUFJWFBBVFJENCtR?=
 =?utf-8?B?Vlg1ZUU1VElOMW5rQ0VpWUxKY0ZrRHJ5Z1o1aTNmeEE0SEJWY1lKYVMvcjRQ?=
 =?utf-8?B?NEIwdXY0dHZJbHVoVllLM0tGWHM5eFAxZmlaT25EeTQ5VnoxNUliUUpzUHZl?=
 =?utf-8?B?blBtWWkwclNRekdRU0NldGJ2amlUSytYWmN4RldMcVQweDRDbGhINHkvdmF3?=
 =?utf-8?B?R3VZdXFjd1p0Nk5TeUxIQUNEcERuQ3NSQVVqeDhrRkkzOEt6UWd2NWM4a2g4?=
 =?utf-8?B?aUlxSUNNZFhDdTFqZTM4QjRZR25od1g4K2JLNUxwb1pOUEdVUUMvc1NSanYr?=
 =?utf-8?B?dlIwajhpRG13L2x1Z2JMbjhCNHp6VXlaWUJtSUhCNzlyQUMrZkllV2JvWTZP?=
 =?utf-8?B?Y05hOVJNOXhBM0tRMjJCWkk2UXJIZldRWVVuUXlnR2UyNy9Dd3E4Wmc0am9y?=
 =?utf-8?B?YTQwM0JRLzhqNXpvQXpqV1VqTnpaTzBqeE1FcVViaks2MlAzUHk3TzlPVUZs?=
 =?utf-8?B?YVBTS0owallJUVJzY05hL01QU1hldEtOTGZjUjBvc050L1VDSHdMdlpMQk8x?=
 =?utf-8?B?Q1pObitpQU1YeUZGZ1VZN0dqeHFvOCswc1FWT1pybXR6NzBxR3djT3pTZ3NV?=
 =?utf-8?B?NTA5MU40VGdOYm1hY3FDTE11UjlSdk1Qb0o0OXZ0RTM4WXZZSUV0V0lRcXp5?=
 =?utf-8?B?eFVzNDhpaW5aSWJSbmFJbUl1clFnWFBvUG44TE8zV1liS0E2TjNRYkdiWHlO?=
 =?utf-8?B?dnVaUW4vem1sSXZOa2JEU2FMbDNRZ1ZZOW44czdMdW9aeTI2RVlxdS9CQXhC?=
 =?utf-8?B?eFRmMXV5d3hIWXRjWlVmSHhqYW5POEVzNERCVVhaMGRoaVpiN2xjOHhSNlpC?=
 =?utf-8?B?VlZkNzRkNkJpRVBoZjlrc1ExeWhQZEYzVWtFeVJnYWtaTUJEd1BPUUM0cXVX?=
 =?utf-8?B?bmVOL2hDanNNck8xOVFCWjkzRWlPSzNwQjM4Vk5VcHNFd2pSb2JGYkU5c3Bj?=
 =?utf-8?B?bVQ2emxvZFlMQ2V1d25sZTBCVlVZSmRGRlc1UVlNRlRjUXQwb3BhbWpHUlR5?=
 =?utf-8?B?eFppZkhvTVlKb0poRVcva1Z0VEcvRWdORER6NE9DRmdkQjBmMVE2c2dyRzVv?=
 =?utf-8?B?ZTVnU0lZZlY2dU1FcGRkRmZUdERicy8yNGdVRFR3NmNxZ2tSdEtVb3B0RGhK?=
 =?utf-8?B?Ti9UUFlQRmVJdUVPd1JGL2M3L0JGVWhuMGhSUTZLTFJXMlVaWmlXWHZ0MUtI?=
 =?utf-8?B?UkxUbEVyTWYrc1NpZXRxUTZkRUtTY1RBaEx2aDRuc0wvQlNpRHZxUVNxQUll?=
 =?utf-8?B?dCtINFh2bHNPWGFNNzVTWnFENGdyUXNZaG1GSm9XTzlVeFJTZ0xjRS9XaDc1?=
 =?utf-8?B?VDNybWhrbXBqektOL3IrTjNyWCtRcDlTdlEyTTBHN1lVcEpHN3pqVTJHVlFq?=
 =?utf-8?B?dmxLTUk1OWpCUVlsRlhGSWpvWSs0dGNqb2QyRFBBRUQ0dWxvN2R5OVdRVlhm?=
 =?utf-8?Q?HgYcJmNCcCwZ1OSAiXLcI8plAQ6U9izkyWn39hP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b013188-616c-4856-7fdb-08d951f9d12a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 18:59:24.8870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8yY4Joy9ky6HyJ+HtaYt+wIGSW+9/I47FtKmirvDbOMXnK/xfuGAab26AqxcDhbUb6XWaM+vuPe8TM6xeTFmuz4Zk7LNBDUPW0M1hztAPn0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3981
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280108
X-Proofpoint-ORIG-GUID: UX8exm17dbYcmAX-PU1YBusHjUwaVHrZ
X-Proofpoint-GUID: UX8exm17dbYcmAX-PU1YBusHjUwaVHrZ



On 7/28/21 7:51 PM, Dan Williams wrote:
> On Wed, Jul 28, 2021 at 2:36 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> On 7/28/21 12:51 AM, Dan Williams wrote:
>>> On Thu, Jul 15, 2021 at 5:01 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>>>> On 7/15/21 12:36 AM, Dan Williams wrote:
>>>>> On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>>>> This patch is not the culprit, the flaw is early in the series, specifically the fourth patch.
>>>>
>>>> It needs this chunk below change on the fourth patch due to the existing elevated page ref
>>>> count at zone device memmap init. put_page() called here in memunmap_pages():
>>>>
>>>> for (i = 0; i < pgmap->nr_ranges; i++)
>>>>         for_each_device_pfn(pfn, pgmap, i)
>>>>                 put_page(pfn_to_page(pfn));
>>>>
>>>> ... on a zone_device compound memmap would otherwise always decrease head page refcount by
>>>> @geometry pfn amount (leading to the aforementioned splat you reported).
>>>>
>>>> diff --git a/mm/memremap.c b/mm/memremap.c
>>>> index b0e7b8cf3047..79a883af788e 100644
>>>> --- a/mm/memremap.c
>>>> +++ b/mm/memremap.c
>>>> @@ -102,15 +102,15 @@ static unsigned long pfn_end(struct dev_pagemap *pgmap, int range_id)
>>>>         return (range->start + range_len(range)) >> PAGE_SHIFT;
>>>>  }
>>>>
>>>> -static unsigned long pfn_next(unsigned long pfn)
>>>> +static unsigned long pfn_next(struct dev_pagemap *pgmap, unsigned long pfn)
>>>>  {
>>>>         if (pfn % 1024 == 0)
>>>>                 cond_resched();
>>>> -       return pfn + 1;
>>>> +       return pfn + pgmap_pfn_geometry(pgmap);
>>>
>>> The cond_resched() would need to be fixed up too to something like:
>>>
>>> if (pfn % (1024 << pgmap_geometry_order(pgmap)))
>>>     cond_resched();
>>>
>>> ...because the goal is to take a break every 1024 iterations, not
>>> every 1024 pfns.
>>>
>>
>> Ah, good point.
>>
>>>>  }
>>>>
>>>>  #define for_each_device_pfn(pfn, map, i) \
>>>> -       for (pfn = pfn_first(map, i); pfn < pfn_end(map, i); pfn = pfn_next(pfn))
>>>> +       for (pfn = pfn_first(map, i); pfn < pfn_end(map, i); pfn = pfn_next(map, pfn))
>>>>
>>>>  static void dev_pagemap_kill(struct dev_pagemap *pgmap)
>>>>  {
>>>>
>>>> It could also get this hunk below, but it is sort of redundant provided we won't touch
>>>> tail page refcount through out the devmap pages lifetime. This setting of tail pages
>>>> refcount to zero was in pre-v5.14 series, but it got removed under the assumption it comes
>>>> from the page allocator (where tail pages are already zeroed in refcount).
>>>
>>> Wait, devmap pages never see the page allocator?
>>>
>> "where tail pages are already zeroed in refcount" this actually meant 'freshly allocated
>> pages' and I was referring to commit 7118fc2906e2 ("hugetlb: address ref count racing in
>> prep_compound_gigantic_page") that removed set_page_count() because the setting of page
>> ref count to zero was redundant.
> 
> Ah, maybe include that reference in the changelog?
> 
Yeap, will do.

>>
>> Albeit devmap pages don't come from page allocator, you know separate zone and these pages
>> aren't part of the regular page pools (e.g. accessible via alloc_pages()), as you are
>> aware. Unless of course, we reassign them via dax_kmem, but then the way we map the struct
>> pages would be regular without any devmap stuff.
> 
> Got it. I think with the back reference to that commit (7118fc2906e2)
> it resolves my confusion.
> 
>>
>>>>
>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>> index 96975edac0a8..469a7aa5cf38 100644
>>>> --- a/mm/page_alloc.c
>>>> +++ b/mm/page_alloc.c
>>>> @@ -6623,6 +6623,7 @@ static void __ref memmap_init_compound(struct page *page, unsigned
>>>> long pfn,
>>>>                 __init_zone_device_page(page + i, pfn + i, zone_idx,
>>>>                                         nid, pgmap);
>>>>                 prep_compound_tail(page, i);
>>>> +               set_page_count(page + i, 0);
>>>
>>> Looks good to me and perhaps a for elevated tail page refcount at
>>> teardown as a sanity check that the tail pages was never pinned
>>> directly?
>>>
>> Sorry didn't follow completely.
>>
>> You meant to set tail page refcount back to 1 at teardown if it was kept to 0 (e.g.
>> memunmap_pages() after put_page()) or that the refcount is indeed kept to zero after the
>> put_page() in memunmap_pages() ?
> 
> The latter, i.e. would it be worth it to check that a tail page did
> not get accidentally pinned instead of a head page? I'm also ok to
> leave out that sanity checking for now.
> 
What makes me not worry too much about the sanity checking is that this put_page is
supposed to disappear here:

https://lore.kernel.org/linux-mm/20210717192135.9030-3-alex.sierra@amd.com/

.. in fact none the hunks here:

https://lore.kernel.org/linux-mm/f7217b61-c845-eaed-501e-c9e7067a6b87@oracle.com/

None of them would matter, as there would no longer exist an elevated page refcount to
deal with.
