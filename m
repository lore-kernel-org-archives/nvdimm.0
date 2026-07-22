Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011070.outbound.protection.outlook.com [52.101.52.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C6A3D6690;
	Wed, 22 Jul 2026 08:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784709035; cv=fail; b=g1dWrpbOhI3bebfw9nmbb+hMFabxUTcUfH7zbsuLUn5/wPYKlLKIvjBAKgrLV3Mfb6grAWG2OSMClhqt0ihsLP4Q4GXh8n7riD0VvfSZB93zeZWhsHTkUuyLXfHdk7aOAMAJnRu56IFDdUWCvo+HRxOw4yPktufEk+9NXykWqEM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784709035; c=relaxed/simple;
	bh=fvjWkNKESje9YQeLZLB59OQElYgqgIYJuttQYUEkyw4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UM8Vnohp/cx7kybWJbcCY3J6vRF3DHIbJL5+1Xy345rXGf6aoBRq/9IlklORrG+nFWIts98r+7qe6GSrhD0fLozFwY7mpwwAhF4186OyvQBJ4y+ZSA0yAm+pxooZ2+s3SUd3urH66MS05chtxBiz95zn1bm7HKiPMgvGKvRkjys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=T5FtHmml; arc=fail smtp.client-ip=52.101.52.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="T5FtHmml"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WJBuRrC7NTHJj6+F/4EhXHxrhg+qFNPREZsbDwhEpCuhLKAAhMp/UAph0M9tUqWTQX1Yz7spRG5HQ63sHOA3HRfVw0m+h+vqMfAtiRDc2FC4MboZugQtNX2ZlOxQCb/5p2+bD+Q7UHc8ScuPnDlNkLlSsPUSNoTkEzKw9Ro38IB0vb7tS9i7YkOH+Mo1dAy4GrJi0vPeLi+2D9iQ8INsNrvm6OJaEA8jHrfSwPpQriYIavhuAWL6kvalix8gEnw0+BfMxk+PM9v09LuyIicuqSzNL+MKb3biUwOfZweJ78CO2vYu/bd24xOZ3A7q4AbOETq9oaIb8xWQQYm2LqIAVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NOgl1m91rCfaTrJRtHwwbQnPxCIxDgsATs/KGuLzxaA=;
 b=Gx5F1uXutvRY1+rz8kxiO0xQ+texB53tuuZTwwZWYKlV6QtcxLP6U8p8bnC59AGit9yYz8bPRI5cjkQtaP3XhcMW+sS+b/ELUZXklFt0j9FWDKBnJhvRrjQywsNO1gkVK4lPjcGBvscq+LR6Q3NvCTiUBdV6FNwucVCwUwhW1MMgCJTCS1WQ0exLwhp5GOmxQ5Vo2raMw7py4n8iFzfzxEhCmVl9G6t3op5BQl3lH8+hmW/FfzEyxzRBpKqEBmz/c/QrZ5e8v7wWqKBNKLzDaq1nQdtaETXPsB7Ah7KJi+M6BuwNtTNKZWqOFUF1MbvGfMH0UL0OZiwMdfRBEyPYMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NOgl1m91rCfaTrJRtHwwbQnPxCIxDgsATs/KGuLzxaA=;
 b=T5FtHmmlGW5EfPmi61zpEnJM0oY3DE/hlYznLEcJ95DTyPXsK0/3KUoftpuvdlaIQGUAHVIh0FznKQj9lXCxBkzjiyB46CgfcJdlDTaXD+vpFYWYKMOAAocSD4ZLrlCddBjW9WMdbAvrskZsGlPUTY5lSk3RZMyZewLDP5ubDBhnEa91A7QncPpBfaoLSys4ie0JITdw0myyxXT3CVHTDAamXyIgG0QkxPgAbrQhNBb8iXAGbSrcU5gShl3KOA0R3++AzHDdIxweILwF4qsDRqoaBU/Bk+L8SZrK+JL6h5JU4LQGjcp+BAgWiMbgUAQ/sMvmaidRpGoG//5HBDUrIw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB5001.namprd12.prod.outlook.com (2603:10b6:610:61::18)
 by SA1PR12MB7410.namprd12.prod.outlook.com (2603:10b6:806:2b4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 08:30:20 +0000
Received: from CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe]) by CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe%3]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 08:30:20 +0000
Message-ID: <1d8b6857-de1e-4807-8201-4f6a49a3b8f7@nvidia.com>
Date: Wed, 22 Jul 2026 18:29:53 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, arun.george@samsung.com,
 brendan.jackman@linux.dev, yuzenghui@huawei.com, apopple@nvidia.com,
 alucerop@amd.com, matthew.brost@intel.com, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net,
 skhan@linuxfoundation.org, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, alison.schofield@intel.com, osandov@osandov.com,
 jannh@google.com, pfalcato@suse.de, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 ying.huang@linux.alibaba.com, kasong@tencent.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
 linux@rasmusvillemoes.dk, longman@redhat.com, ridong.chen@linux.dev,
 tj@kernel.org, mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca,
 jhubbard@nvidia.com, peterx@redhat.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 lance.yang@linux.dev, usama.arif@linux.dev, xu.xin16@zte.com.cn,
 chengming.zhou@linux.dev, roman.gushchin@linux.dev, muchun.song@linux.dev,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 driver-core@lists.linux.dev, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-debuggers@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, cgroups@vger.kernel.org,
 damon@lists.linux.dev, linux-kselftest@vger.kernel.org, kernel-team@meta.com
References: <20260720193431.3841992-1-gourry@gourry.net>
 <6a7aaac3-e70d-4063-9c84-e643db1488e0@nvidia.com>
 <al-2D_7NcwMxqmsM@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <al-2D_7NcwMxqmsM@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEWP282CA0082.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:1e1::16) To CH2PR12MB5001.namprd12.prod.outlook.com
 (2603:10b6:610:61::18)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB5001:EE_|SA1PR12MB7410:EE_
X-MS-Office365-Filtering-Correlation-Id: c1661963-f6d0-4ae8-619c-08dee7cb7786
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|11063799006|56012099006|4143699003|6133799003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	sUc07mWsimZBPGEp6bM3G+t1OqNj38TaG3c7T2SzOX0pCO/T7du+Y6yprg7l8vF3xOgZfNxp6BAX6FbNYEmLSkZyTJ0nPJoexw4clXLpdgQzpkDpFU3tiAr0WtUinyVqeAH8qnSTMpJ4v2cHsyh5Mlw0uhKm+ydazFWpHmPJrs0XJjpC5NsDHmaphKCH1KD29nKYFnmynl9j/s6JQuF14G3/ESLe8oEfAychvEwElVjFC03yUVobBfsT6PJ9YGP7x0M4Rojo4vc7gcM9BVa4br9ZvetCUDj7CW5a+agWfp4++47Ox+1dE4gq0Xxv40+Tlg0Laf4cy58BuSO6xqoNcm2Wi+0VABe8UIG2lc8DeKOYNFw7oogsf9lfoF17BVyzcDy+iIJZbL2gP7KENUvTEPkhx898iZoXnVgYipL48L5ffTg0qFBfHaoTCs9sKWycmW63dJVw7EJjlUrBwPwpyX5Jd77ZW6KdC7AVbvzrjv+IjY0qI8a5/Wd5nbbadl3pIe7XBjTJ2j+pFcloXn+6i8PHS+xmDueqxpXsm7DPuTP2yI2Kttr8bsX47hp5krA4KfFY0f8dDLdbgtuDz4tw7PRZaCLUqonN+M5wcVCRSvvs9gG7FotrMBTycmW9nieM7WTGeMJwGk17Mlbj94C5Ej0N+Hc6UGuoS94CxGUgEeY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB5001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(11063799006)(56012099006)(4143699003)(6133799003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L3ptUEIxYzBrUnpja3RQMG5qTXJJM3VETVRwUlI1blZiOS9VQitKVXVXMVJO?=
 =?utf-8?B?dU5RU2NSM0U3RExUZFVNbTFLNEx6YWJpVlBjS0g0ZldUeFkzbXBuVGg2d2ZL?=
 =?utf-8?B?Z1JtbUU5emRuTjB1RGlGVnVoTUhJVVgxQ3dIVkpOSGw0S0hKa3pKT3hmYlVP?=
 =?utf-8?B?QkJZazErdVFSWllvbGhiSEhDeWV5cjhxUTZtcFRnMzJ6OGFCUjFtVjUzS1BN?=
 =?utf-8?B?WnYyRjd1bTczTGNGNHBQUFJ4STBmY1JLWWFuQW5hR3o1QncwYkkvMnlyZFdG?=
 =?utf-8?B?cmdjOEs0Y1Q4aHhPVjdMQUE5R1N0UVo2TkdKV3JQRmdCRURxWEtFQ0pEOWpo?=
 =?utf-8?B?N3ZoUjJvYVo3LzJVcVNjNWsrT2VJY2orVW9kYTZRZkdqOUVlMHNVbCtaaXNi?=
 =?utf-8?B?N24wQjdILzJZZ0lTbm1paE9reEczTEErRlhFOGpKMlkzSkNvQ3k2YTJZYzMv?=
 =?utf-8?B?WHhuMkFpL2RXUXozaG9vRW9TYVNtNU9NV0MxT2NCUmFkWFJtNmt5dC9sSjRE?=
 =?utf-8?B?MUlwbHFDL29PcE1LdjMzMWsyOHh0UGpqNU1HbE5hL0Z6VjZIODZDSGxxdU9h?=
 =?utf-8?B?VGhHR041enVhNzJXWDRXT01jM0w3NjdCNFd4YU1iMlFMT3VaMk0zZzg3Y1ps?=
 =?utf-8?B?RElUNWRNL3NGRk8yNGR5L1ZJd0hjYXlPUVN3NlZhN3FzbUMzN0Q2cGNRby9o?=
 =?utf-8?B?bmZHYU5qbTRGSHhWcXVjWkd4WGFIU21HdHJDUEhKc1U1a29oMGwxV1pOWmZi?=
 =?utf-8?B?QlNKVEU2a1lSRmt1NFd5Wk5teEhhbHE1SkZUTVBWUUU2QXJTU1NHNWRISmFZ?=
 =?utf-8?B?RjlMczFDUC9wWUdDKy9NYjVEMWZCQ0syK3dxWHVINmFGc2I1NEJyMnkySzJm?=
 =?utf-8?B?TXFQR1Q5V0ZHSEZNMjNnSkZpTGhDU0VHV21QaDh0N0N4anBqRzR5aFJ0WFBH?=
 =?utf-8?B?OXJDdVRjYVhYSkZ4R2ZxeDlQWWo3Z29yRDl2WkxETy9BMlVZOTNYQVRRYStS?=
 =?utf-8?B?akFCWmRIbWYyTTNyeG96dXJFN3JPYzNOUzhpYXUzOXEwQVhXTmtLZWhYY2Ev?=
 =?utf-8?B?RjlzODdtTTVNcDB3T3VOV2lla2Rnd3c3RDFkSmZpNHNvUTQxdEdaSFIxZ0J6?=
 =?utf-8?B?MUNESUJlWFpnN3NuT21MM280SVUyVEhjYTBWaHJ5VXMvcUVjV3dIb2FDT2Fl?=
 =?utf-8?B?Z2haVjE1bktiN0wvLzZoZUZ3NzVqUDhtTmpsNnFnVlg5b1VweGFPbmlrSE93?=
 =?utf-8?B?a2dlLzVUcWt0S08wSTE1S3h2KzhxZTRuaHhHR3dJMWhFZGtBM2VvNmhNbFd0?=
 =?utf-8?B?RmlCejh6NWxQRkduMkNodlhaeEk1Y0doN1JuYXV2c2J5N29xQTRXRXEybHli?=
 =?utf-8?B?eUxRaTRQRmF4TStONVlBazhaaFpnTmFDU24xN0YxNjV2MFNxYXprc29oaWNB?=
 =?utf-8?B?TkpYTVErTUtVay9QL0xzUURvU2xBNENWYkpHbFdJZFFMeFl0amdETDZTY29I?=
 =?utf-8?B?dEJQTjlTazJNWFNnZzJJTlNzaEtkczZaRXk3ZFFCOG9kSDhXazVDR1JoWWN4?=
 =?utf-8?B?cXYxYmJsSXhkbi8vdFZlbk94OTdMSzROdTFyNEdGczhzZ1dGVjVFekxBTEgw?=
 =?utf-8?B?RDNTWlFUYW9KTTRpWXhRR3ArMldLYlAxZHU2bUs4dUlxdGVVTEh5Q0wwZVUx?=
 =?utf-8?B?YWxNZnBiVTJjOGhJZWZ5MjI1cDlQMVJvUzV0OUVSOXVkUFlxTkZEcFZTa2JC?=
 =?utf-8?B?Zmx1bXhybUhzQ3lSZWV6M1hPNVNySlpSd05aaEh2bnFOT3RZeFpZNkI1RU93?=
 =?utf-8?B?azFWaC80SlIyZnlhY0pPL1VENm8rcFVINk9rZDRpb2d5UGlmNysxWDc0SXBv?=
 =?utf-8?B?c2hVRGduOTg1SVFKVU1QY3NBYjZwaFQwR2NjSXpkbGl1Mm1LQkhmdXduU0s4?=
 =?utf-8?B?YlZhOWF0WHdWdkZZTlorVVBld0lrc2dxdWlzWTYxVm9nVkhRb1pNbU94dVN4?=
 =?utf-8?B?YlJta1VORFBTMXg5K1hzWU53Um0yVkdmUWJJVkI0QkJtOXlsTnZxamNBNytC?=
 =?utf-8?B?WS92eG1JS003cEl1SlROLy9nM2hFMGcyNCtRbGFCRjdQYXMrbVM5eTF0Kzlh?=
 =?utf-8?B?RXMyQUJuM0ZHZjNLZlhYcVNtenRzcFZvMXFkdUozTm5YKzNKWEhMblU1UkVG?=
 =?utf-8?B?bkpNRWp2Wlh6S0l0TEJWcWpETm52Sm1VWlNUUHE4MDlNNklUWmVtUlJ2RDVh?=
 =?utf-8?B?RGt3ZGJhSXhBTnRER2RlK0xEYkdKUWdZS1FlU0Jva3FjNmJ5cjNmV0c5Y0l1?=
 =?utf-8?B?WnZ0bm90RXhFOHc0c3R4UGpGaVhMTktoUEhqbTFESDd2MFlWYlFsUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1661963-f6d0-4ae8-619c-08dee7cb7786
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB5001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 08:30:20.4440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N6uTeyt0ee/c1gf3dPXOzvO9id4GEtPIHvHnC4CuCnyQWtIoPcJMIWvucDIP7aO4cSDQVqITFPagzUVEO0leXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7410

On 7/22/26 4:16 AM, Gregory Price wrote:
> On Tue, Jul 21, 2026 at 01:46:01PM +1000, Balbir Singh wrote:
>> On 7/21/26 5:33 AM, Gregory Price wrote:
>>>
>>> Patch Layout
>>> ============
>>> The series is broken into two sections:
>>>
>>> 1) N_MEMORY_PRIVATE Introduction.
>>>    Introduce the node state.
>>>    Opt those nodes out of mm/ services.
>>>
>>> 2) NODE_PRIVATE_CAP_* features
>>>    A set of mm/ service opt-in flags that augment private
>>>    nodes to make them more useful (i.e. reclaim = overcommit).
>>>
>>>    NODE_PRIVATE_CAP_LTPIN for private node folio pinning
>>>    NODE_PRIVATE_CAP_NUMA_BALANCING for private-node NUMA balancing
>>>    NODE_PRIVATE_CAP_DEMOTION for private-node tiering demotion
>>>    NODE_PRIVATE_CAP_HOTUNPLUG for opted-in private nodes
>>>    NODE_PRIVATE_CAP_USER_NUMA for userland numa controls
>>>    NODE_PRIVATE_CAP_RECLAIM for opted-in private node reclaim
>>>
>>
>> Looks reasonable, I wonder why USER_NUMA/HOTUNPUG is an opt-in?
>>
> 
> Ideologically: Private nodes default to fully isolated, why should any
> given feature be special?
> 
> Concretely: 
> 
> User-numa
> 
>    Some devices don't want the user to have control over placement.
>    I have been working on compressed memory, for example, which only
>    ever wants to be used as a reclaim-demotion target.
>    
>    (The reasoning for this is another thread, i plan on publishing
>     my research on this this year)
> 

I don't fully understand, how do we allocate memory on these devices then? Is
the driver expected to allocate and map via vm_insert_page()?

> Hot-unplug:
> 
>    Some devices can't necessarily handle unexpected migration, and
>    hot-unplug is fundamentally a migration.  So the HOTUNPLUG cap
>    actually means "hot-unplug can execute migrations".
> 
>    If the entire device has pre-drained the memory (all memory is free)
>    then unplug works - it's just not very hot (no migrations) :]
> 
>    Maybe a naming issue?
> 

Yes, I would prefer MIGRATION in the name, HOTUNPLUG made me wonder how these
devices come online and because it is a device, it can go offline while the
system is still online

> ~Gregory
> 

Balbir
