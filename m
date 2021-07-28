Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1EC70
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 20:07:57 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SJmuCw014394;
	Wed, 28 Jul 2021 20:07:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=LCk1aosBMh9zHDxW19iXU+R9yQ/nU8lB2eCi1TXHxpU=;
 b=Yem0q7ebfcd96loNQNt/wawdUiZxw6jYaCEpY7egJqHC6FE3FHCsVLWC/W2NOl/sxaOm
 9eBgdLhDkfgpQffiCa1BWCk3itbvAOjNlDj1ZPqStHig57vfezQ+wwXW25kkw4D7P9Ju
 UY6HJScHAlLNux1x3FnIAgozN59Ua1km3T3NjAKt/zI7t/NXEVyvqpSBTakihj46/VBf
 5aNMhVguK+ahoZbw5jcYGn7On7xFrX3zc0xJy4Kc2213Yg7By4GO/XE7nAOnpks4LtIg
 dVPLwpbE6Y8SSpoD3uRs0PwCl70MsgB3emgiktj90ahZcyODN4bQFsnQ0Fk6w8tAfylb vw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=LCk1aosBMh9zHDxW19iXU+R9yQ/nU8lB2eCi1TXHxpU=;
 b=fVy1FBuwXUEBgz8lKy/oG1qSSMAxErbuOPcjHPttJCKdsQbt0duBkPNjnybPQe4S+F0w
 Z7sonj9L0NdloYrl9bUZhwwaw4waM7dKurrFgS+fWHqkQBQO+yQ/0xs/uzJZvHjMZ1Sr
 MhyJhtjGfyuLf8/G/XkZiMthngqdih3eKtVUMa+Ng55XZt1/N81CdkSCUyRP5fqrny5P
 mF7cusls0OkvfjY/z5WkZQ8Xf5dh1sOd8lcTSXiYWylFoG6ioIY/Hi/MkA9tOys6XP8U
 tbbT8kDbXqjHu0G1UA8s8i0st2LDWuBIpBymgqKsI1zVXloRdyLTnbTHNxvv/P/0bh44 rg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a2jkfbsfq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jul 2021 20:07:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16SJkoqK012989;
	Wed, 28 Jul 2021 20:07:50 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
	by userp3020.oracle.com with ESMTP id 3a234ye1sx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jul 2021 20:07:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c5iu6ADXN+BKJb+TlcH2ZgVRLkA3Mo9OWszf7GNedp5S/wLZfiau3MXoMXTh0zzV/LsuPbw2E3dQB/N06rnWtgH/a02w5zCuaHeT9XZoFhbRnFvEuppOs1cHGraxZdHegSvaPu+sii35Z/Q5Uv+13SM+zh9amVv5/WnpyihJQm4p+XbNTwJ8/Okb7ZKMJ9ghHGv9EiKzjD+0FkG6S9xNOOsrUDMEoOMxMA+APM5mE1I+69NzzyuBYUAvYIRo4pFxHVhk86Voq7g08UG0M0FI1GyuN5ZTk1pfhDqdMsmkp4q/R0Nl/8lklG2I+GL+X0envHS0+q+td97WF5xEq3Q7QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LCk1aosBMh9zHDxW19iXU+R9yQ/nU8lB2eCi1TXHxpU=;
 b=B4j3W53gr6i3U73GlzuKHi0Rmk7+bOL6u+HOeGA8hpUsSIB4JSH4tBve9NbzEbMigLXVtGOUz1q6+zWozQQnf56aq7R5DRNVPdK4Q5a5eKcOLlZ0tSGbTvqLhD9lfFQAUPjvbug6DtDiPhJ9CrCnRGwYVQqcIlOkNnmxZwAqUKSvFup9zduOQXYD4+wUFncDcWvGqAfhCNXPE884xmYU7R5un2Q6lxcpSK4Z3iUStJzmOj2FaIuHKQm9yQxlNOa4aEW5xMKhfmO9/c22GNDhfqlR0m/nUGe3NvHA/GhLST2VzgLNU6dO1XfsKI9XBlj5Vi12MRe5y5yJmFwxwHEjxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LCk1aosBMh9zHDxW19iXU+R9yQ/nU8lB2eCi1TXHxpU=;
 b=mpX/es0WJfEye+wVNIM68Ra/h6X+aBjjMSjhX+yXMxmlZ6rUWz1zUkf5iu+4zJYJZE6CrsVwoVjS6+yaP69hQ3q38fsYE69hkLFlZFTvrsEhO5nYNfnFq1ZHh9Lh7qeU3u7ZNYQiXc6GlsymwG9ZBoKDDEgz0x0BbECII15u4Mo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4287.namprd10.prod.outlook.com (2603:10b6:208:1da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Wed, 28 Jul
 2021 20:07:48 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4373.020; Wed, 28 Jul 2021
 20:07:48 +0000
Subject: Re: [PATCH v3 13/14] mm/gup: grab head page refcount once for group
 of subpages
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
 <20210714193542.21857-14-joao.m.martins@oracle.com>
 <CAPcyv4i_BbQn6WkgeNq5kLeQcMu=w4GBdrBZ=YbuYnGC5-Dbiw@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <861f03ee-f8c8-cc89-3fc2-884c062fea11@oracle.com>
Date: Wed, 28 Jul 2021 21:07:41 +0100
In-Reply-To: <CAPcyv4i_BbQn6WkgeNq5kLeQcMu=w4GBdrBZ=YbuYnGC5-Dbiw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P123CA0011.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:ba::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO3P123CA0011.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:ba::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 20:07:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11456cb1-35e4-475b-0ed9-08d952035eca
X-MS-TrafficTypeDiagnostic: MN2PR10MB4287:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB4287127DA05AE87111F695A2BBEA9@MN2PR10MB4287.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	yDpbvGVVpDj2CAsCEaSDu2MP8iYN5B8TGAxhU1I/BDmjVsn2i1z0JuMR6nFGsrd9IrBxDegKtdexusggz52IRHVkx6ujtlRbVpgaW8LUEp2YjHF+ajHt4DS+f9k1h+FXeJdCH5uB1+6nc3ZQQuKX+RriwDAdKf/4x7oDWfbCH63rotCUG0E1Wpv7Be44RcpKrxt0Q500SgvbYtCvqPy1JdSlpyesvcb2f3HCa74c9FeeSmlheJa4WfweZ+mmP6MoZWgOz0cyD51xYO3zR+fFi1T2u1edsYvlMuCRNd/iVBGIby0X9Dky5T+tBb0ygmUVNPFVzON5iSXEkpytTsiRaSIAYggTd3hmWb7lyRNTwJ9m7MR8xWB3khPvP2vAo9ANJGVIKJgK4qDgbFtxxIUhZF8eMhgmVPqNym27k6+ghAymQ6/yYOe+jlEY8Mxkv1MBqTlMKiJ1bcKkQk86XkXa1xve5skmz+30rzt48wdUp1mJfYgsAft0YX1aKVzAfE04THMiDDNyXpXZA9thLOO9JVxL8AD4XElyPtS6PqyHjUwwoCoFkA6B4HIf0y0FstvbGQzh1CRQZnE8vtIYL4QM3nAclDuimBihAco2POuhFDXerUD+vZL4AZNF8Ti3LKcw50Zzgt8YW/y3UBYpYgrpQnjdTsv6AX1BWx/g/Q4ChqLSZyWINmr6DdZWxJnwxvnlWqOBfQ+bcjSTel9KZUbY6Q==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(346002)(136003)(396003)(5660300002)(6486002)(16576012)(2906002)(316002)(38100700002)(36756003)(83380400001)(54906003)(7416002)(53546011)(8676002)(86362001)(2616005)(6916009)(956004)(8936002)(66946007)(186003)(31696002)(66476007)(26005)(66556008)(478600001)(6666004)(31686004)(4326008)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?eGp4RW1xMjRSVVJtVEZ6cWlRRUVHZHZwVEtOWGVBZGt0V1hkTC9xVmJlMm9o?=
 =?utf-8?B?aW1saDBTeDdiL1BRUkZxNis3VXlUOU9VZkliNHBSc0xHbGp3NkFnbVZHQWFu?=
 =?utf-8?B?THFPSVVqSDl6NDJyN0xNNzZtZnVNVVZYcUFlV2lGSDFmUzhjYkttcnVmSnc0?=
 =?utf-8?B?WExHeHdxY2RtNGV2N01vbGg5aXJQYzlOK1RINE9OSHUrYXhsUEFnSEd0TUI5?=
 =?utf-8?B?M09vc2V4TXM4c1UxVGRienYvL2lNdEcvc2tmdkwxNGJVZ2RtZ2JWckVUai9r?=
 =?utf-8?B?ZVBKZzZUZ29YS2ZUQjNSQzJiZFFJTGI0QkxHdmxZcGdWNkFYaE1OQ29KOWtF?=
 =?utf-8?B?UFczaUZLejVLRGx4UWZ1QzhEWHlzVEI0NUtjRXFkdTRlN1ZzSllQRTVRb1dh?=
 =?utf-8?B?K3lmdVdBVXZTb0lMd0V6UExZejJWM0NFWEFQNVVsMmYzTHpOa29YSER2T1BG?=
 =?utf-8?B?eHdCeW9Jb1krdE43UHUwZEVNMFYzSnpSQXI4OTFXS3M0M2tMbWNlWlk4dmk1?=
 =?utf-8?B?QkI4dTIwQVJrcFVtRDFiK2tFeld3Rm15Z0xodFhaN1VsbDRYLzNJOE5jbzJp?=
 =?utf-8?B?ekozdm8xQjVSakFUMzhBWlVnOVcyejZ0YVRHazRWRnpZcGRtdW1HMURJS2tq?=
 =?utf-8?B?OVliakpyL0ZpeEhzUGxxV1BUZWtmSCtwV1ZzVjJHbDJ2VVNVK1JreUFmYzYr?=
 =?utf-8?B?aEY1aEVEY3RkZ0F5TFNJQUlRSzlpSzc1K1IzZUVtSThUWXRWdGdYZW5RMkZK?=
 =?utf-8?B?TDlHakVQS3hSc1JuQXJwQWpxOWMybGtDUlBvWHowazA0QXZ4dXFnNGVhNlBw?=
 =?utf-8?B?RHAyL0dVemx0RG1mbkFPQllNWllMNWpvNDBMZExxaGI2WldNT1dZN0lyaWh5?=
 =?utf-8?B?VU9NWU8xeUczRVI0WFNUTWZvS2t1QVZZeEFJQnA0c1pueXM4c3FyRDhLcDg3?=
 =?utf-8?B?bHl4M3FhN3dGOEJaeWxiTVkwSDJZcXlhWkF2eVRXdG5LYW5WeEFDbFpWYnls?=
 =?utf-8?B?SFhmSVZPNHU0NDBreU5UMDhYQkE4SmUvaVNXdUNkbUhwWHV5R1VZRzYxaTlZ?=
 =?utf-8?B?TURYbnE5cG5VWDBqQWw5eDViN0kvK3dBT040TFlaYmtoRTdaZ2hQZEdKdEg3?=
 =?utf-8?B?RDJMZWw2RGJRSThTSWdqK1FSUGhucmV6UkVYR3p6eDVWVS8ycVN3VDBWc3ZL?=
 =?utf-8?B?cEpGaTh0L3RHaGFwMHl0TWd1MGZGV2FDN3Y2VGRHMHVnRVZoQW5qaVZKS0I5?=
 =?utf-8?B?T3JlRlBTc1hYMEtCQU5tWlhuQThQZ0gvZWJaTWtNRHFLellTejlsbnhXUFh2?=
 =?utf-8?B?OE4vNmY3NStEVEFDU1hSMzJZanZRSTdNVmxnaDU5akI0djNZaExYL3BwQUVK?=
 =?utf-8?B?WG9XOThOZEpXSTBVcGtlQUZZcGRWYmt0NTQ5MmdOSVp6L2xDNnBKK0hEcFFQ?=
 =?utf-8?B?REJGaExxalR4eVV2cXkreHZJN2J6Y2FiY3NlUlpwWWpNZWtyWUszNDNZeVJ5?=
 =?utf-8?B?b2tzR1ZwVDN2eUU4Wm9FZXhZTTBteStnNzNudjBZTytiOElaMU5SS1B4KzIy?=
 =?utf-8?B?bDNPVmp0Vk9pYmxSYmZvV2FPbXByL0NGZkR6QitBcld2Z0tEN2VEaUtqQVM2?=
 =?utf-8?B?QWo5ejhPOVJ5MjZvdkpRbnRwTU9ldUduWlV6WE5lVVlQb0IyeU9nbCtkVDN0?=
 =?utf-8?B?VkJlT2MzMSt4TzkyQ2FqK2ViRlYwV3JIRlF2cjJmTXpyWFFsdkM1eTB4VU5L?=
 =?utf-8?Q?JDU5TZE5zlq4JnGPzUpU8k094kHVssZ1AIxGa94?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11456cb1-35e4-475b-0ed9-08d952035eca
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 20:07:47.9739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AT35hXCQW7vX5jplD8pw3Lz6WiUpXc5xpUhxLAaAGu5gPm17KsQhZDgJ/ZLETBVxrXLvOeZWpZPqcM0C1i+VA0VECoxanDtQtfOurVtoAHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4287
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280113
X-Proofpoint-GUID: yaynU2qjdLj-iClHJ9-d252JV4vgval-
X-Proofpoint-ORIG-GUID: yaynU2qjdLj-iClHJ9-d252JV4vgval-



On 7/28/21 8:55 PM, Dan Williams wrote:
> On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> Use try_grab_compound_head() for device-dax GUP when configured with a
>> compound pagemap.
>>
>> Rather than incrementing the refcount for each page, do one atomic
>> addition for all the pages to be pinned.
>>
>> Performance measured by gup_benchmark improves considerably
>> get_user_pages_fast() and pin_user_pages_fast() with NVDIMMs:
>>
>>  $ gup_test -f /dev/dax1.0 -m 16384 -r 10 -S [-u,-a] -n 512 -w
>> (get_user_pages_fast 2M pages) ~59 ms -> ~6.1 ms
>> (pin_user_pages_fast 2M pages) ~87 ms -> ~6.2 ms
>> [altmap]
>> (get_user_pages_fast 2M pages) ~494 ms -> ~9 ms
>> (pin_user_pages_fast 2M pages) ~494 ms -> ~10 ms
>>
>>  $ gup_test -f /dev/dax1.0 -m 129022 -r 10 -S [-u,-a] -n 512 -w
>> (get_user_pages_fast 2M pages) ~492 ms -> ~49 ms
>> (pin_user_pages_fast 2M pages) ~493 ms -> ~50 ms
>> [altmap with -m 127004]
>> (get_user_pages_fast 2M pages) ~3.91 sec -> ~70 ms
>> (pin_user_pages_fast 2M pages) ~3.97 sec -> ~74 ms
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>  mm/gup.c | 53 +++++++++++++++++++++++++++++++++--------------------
>>  1 file changed, 33 insertions(+), 20 deletions(-)
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 42b8b1fa6521..9baaa1c0b7f3 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -2234,31 +2234,55 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
>>  }
>>  #endif /* CONFIG_ARCH_HAS_PTE_SPECIAL */
>>
>> +
>> +static int record_subpages(struct page *page, unsigned long addr,
>> +                          unsigned long end, struct page **pages)
>> +{
>> +       int nr;
>> +
>> +       for (nr = 0; addr != end; addr += PAGE_SIZE)
>> +               pages[nr++] = page++;
>> +
>> +       return nr;
>> +}
>> +
>>  #if defined(CONFIG_ARCH_HAS_PTE_DEVMAP) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
>>  static int __gup_device_huge(unsigned long pfn, unsigned long addr,
>>                              unsigned long end, unsigned int flags,
>>                              struct page **pages, int *nr)
>>  {
>> -       int nr_start = *nr;
>> +       int refs, nr_start = *nr;
>>         struct dev_pagemap *pgmap = NULL;
>>
>>         do {
>> -               struct page *page = pfn_to_page(pfn);
>> +               struct page *pinned_head, *head, *page = pfn_to_page(pfn);
>> +               unsigned long next;
>>
>>                 pgmap = get_dev_pagemap(pfn, pgmap);
>>                 if (unlikely(!pgmap)) {
>>                         undo_dev_pagemap(nr, nr_start, flags, pages);
>>                         return 0;
>>                 }
>> -               SetPageReferenced(page);
>> -               pages[*nr] = page;
>> -               if (unlikely(!try_grab_page(page, flags))) {
>> -                       undo_dev_pagemap(nr, nr_start, flags, pages);
>> +
>> +               head = compound_head(page);
>> +               /* @end is assumed to be limited at most one compound page */
>> +               next = PageCompound(head) ? end : addr + PAGE_SIZE;
> 
> Please no ternary operator for this check, but otherwise this patch
> looks good to me.
> 
OK. I take that you prefer this instead:

unsigned long next = addr + PAGE_SIZE;

[...]

/* @end is assumed to be limited at most one compound page */
if (PageCompound(head))
	next = end;

> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> 
Thanks!
