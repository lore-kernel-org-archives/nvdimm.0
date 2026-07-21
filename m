Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010048.outbound.protection.outlook.com [52.101.46.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60EA23B0AE8;
	Tue, 21 Jul 2026 05:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784612853; cv=fail; b=T+D9+tJlEAGcAAjcAMxYpZzj9gW92kRlKCYAQgX7OiZjBQfj8gdMByo2dAg7MtFtSy2+a0s7r/L0A2ZDuscNGuI4T6MhBcsBQC2snPM3+QrZ/ai+myssZM367DFlv9IT6YdkcWEbAI/OloS3GIHDQo5cSZNNqbIYkUfTWetdmmw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784612853; c=relaxed/simple;
	bh=axxdhhsWmoHysIXLB33YAr/kI65B4J9svzETuROOAHk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NY9kQWC+MNfOZpRzXIM7CihBP7AmfUxoM98TxC0XA22w/qByPoL6+eE3yyiQQXGGtmTG7VzlzKFVu8CqrF6+2/FNJAqisU1lY0wOOcsO6Kr1AEZisKXoICARPv25knpHKYwQIDJaRtt/IDp2tdbadwRXotTGlR8XD6IZMYf8muU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Dg3RbDMe; arc=fail smtp.client-ip=52.101.46.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Dg3RbDMe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w+9vkb6P082UNKB/2IpcqfU2qha2momJShcEuDH8phfbfiJ/UOPsz3F2oX/9hhcaz9ouvz2Zwq9LH78RtWrD9wLFjTtLbfW1FsYEGjif0sZZGpnEbETKJ0qrt5XzXlslgAXEMVBqpcqyRCas64kQUASlu3xHUmNJ0loHXZDc4FddASWKdtQAdP6DSqTgMo6I8zBAgzrNqUWwRCFzA4j+uK10iLaG6mJEdlkRZfOHhNSmaV7IB1kPoMyb8jypwXgeAZ/SO5i6vyjCaB8OBxLspM1maNSiLoR44n4fnWoxSwaw2riIm6WecStx6FX5uzr72oDrvu8XqhelRT2njk8UWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XX8cfeen7j81/+xnErTyWQVyuaKqlCLvSRfssHbei6w=;
 b=DScdoggeO3Bm0u6YNR4lbWhPpvSz6OVtb7yfy5GvP5nrRX4Q3NgumzU20matCe2g23SkkEE9nnJUw8U2+U9ih8PYO/mMLmx8qQRtfMabA5F59O1BoH0FPvoLkbbc/hUNpsHKXNXyMYqZ/KlKDO8nQ21/YeNDDAIO7uXnb05w4APuyPyEHFzgNazWv7ImHr2o3YcRwYOitzuS2mApB7L7f1OeqKnQA9QzJxYR8kag2aVjQC2hf0iZFAvmbmEHpluT70dtFFCsaPYxUjkUir9iWxqqm+//ErvC2MBOrKdE4XnjRqTuqFS/X/LYMVyXUsvLUxsUwgEOQtvfsfY2DrlGMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XX8cfeen7j81/+xnErTyWQVyuaKqlCLvSRfssHbei6w=;
 b=Dg3RbDMeFnApOREHRnXHnJm+SDuJ+7PP6ObrqyHlDfU6vAcj+enFpphBDABTqSA1g0FoWYH7NQKXJL6f6eqFwi1KUbD9+9V2y3kqnk4jRj4XIwkycFsdr/9BOTP25MVz5hRIyDGkxT7+cWmgd+2fkjltXfWVS4PUe/jaPmaK64NXHgVP92+cfxkbRcaVBa1Q3jmmKenB9Awc2jlhjjT20W2+u8y5DapO1cTB8ArLqDB9myVnVP6BjvZ8swOfXm39FhELhzTvWCTXd5fU2DiXhwMRKrn1KqgnbzF3aOkk8zRtOkr7q2B8q1pAHxSz9jh3+lXNwiZ3AkttKDHUnnZPdQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB4995.namprd12.prod.outlook.com (2603:10b6:208:1c7::23)
 by CH3PR12MB7593.namprd12.prod.outlook.com (2603:10b6:610:141::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Tue, 21 Jul
 2026 05:47:20 +0000
Received: from BL0PR12MB4995.namprd12.prod.outlook.com
 ([fe80::dde:9068:4b1a:53e2]) by BL0PR12MB4995.namprd12.prod.outlook.com
 ([fe80::dde:9068:4b1a:53e2%4]) with mapi id 15.21.0245.009; Tue, 21 Jul 2026
 05:47:20 +0000
Message-ID: <62bf02dc-dab1-41bf-8204-eb3566628b93@nvidia.com>
Date: Tue, 21 Jul 2026 15:46:53 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/36] mm: refactor find_next_best_node to
 find_next_best_node_in
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com, arun.george@samsung.com, brendan.jackman@linux.dev,
 yuzenghui@huawei.com, apopple@nvidia.com, alucerop@amd.com,
 matthew.brost@intel.com, akpm@linux-foundation.org, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, corbet@lwn.net,
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
 <20260720193431.3841992-2-gourry@gourry.net>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260720193431.3841992-2-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ME3P282CA0170.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:1cb::6) To DM6PR12MB5006.namprd12.prod.outlook.com
 (2603:10b6:5:1b8::23)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB4995:EE_|CH3PR12MB7593:EE_
X-MS-Office365-Filtering-Correlation-Id: bfd89711-05a5-43b5-9f7f-08dee6eb873e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|18002099003|22082099003|56012099006|4143699003|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	qNF1SrVAHfoLNltaNSJshYDOpjMghk1P+vnaCtM776iiQdZOGEuh4VVAgcKlJcmqZyQzs9yo83QOp4bSfqif/Ip6EFHmZ4Ap8LHTKoTiHnkXjrbt+S4DTzTOLh2iPPlpLR+s+JPmhHKK0g4Rjpy1KnDdUgRhN6gr4BbLBek4tvS1O0Z8fERqAvvVDtrUuSe4zhQEhVrZdJWk+ZVm84APcY7ABVa2JH/plKmaek8NwPCdey+KwDeyPmTrvZJyZp5nAuqBaBbBPzq/+FASMGjSwvk19+RV1PV9pDnape9M7BiniXPq3alnFCUDKxpgTEEr2wmTvvNOj704V+ZC4/lmGsgIA0P0MwraJXlHNXZLtSLS3LcjIJ46CZ3Lc/0FoJ+q9rBIlpOa16IdkKESbra/LML7XCpWMIdzG57ZVjWTwJmHtfIIHfg9sdzKngmHaW3B1QTt18nAGXXdEAPpb7xus8msZRqkfLnKhpOIb4ye4oXjEOntE8F0imAEqHnmFbv67Qux9Qykf0dPs5OoXsmgJrv0gbSVgdwAf4xNjaGHBu3DrhWlfK1v+bAyjwzhSLZBr/v+l12uPttR4ZJI2oqAAURyMqNd9im6gcE4PPK65o+BPDKV5AtRWrTASr14LuvWuvVQ24CKVKQY4pnwbXFR3ZLbAsepw4j0R9gxSM2doKk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB4995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SWhMUDZPZjQvVURoTlFVYUtTRmlweWpUWForUkZjZGxKR0p5NERRMlJ2ZEs4?=
 =?utf-8?B?cG1peHNIWUpVMTV6N2tsNUxHSzFjRTB3MEdHZ1hDZkRsZ0ZMa2lqWGZNT3ZD?=
 =?utf-8?B?TThOWnV2Y0N0dnpUTEszR1VaTndzSVdHbVZVZTJaMGlSOU10T1VYMEQ1RHVl?=
 =?utf-8?B?aWZXZ09CdW53NlNUZk5DbEg4MmRuY1FGemF5YmFlMEltdTVzbnBYd2FNZE05?=
 =?utf-8?B?THplaU4zUSs3citnMDhhaGdGTzR3NUh5a0NWUnloUEZ2S2ltZWVVanZsNUts?=
 =?utf-8?B?TmdpbklqTHpvNXVFbVUxamtmRE0xQzZqK3BhQXBGd293Z3BhLzdpbEsxU2h0?=
 =?utf-8?B?YUdObE1rcktzYjZiRnJDcXl3ckl3MEZOazhyeVZlYmxLOWY3aU9lNy9Oc3d0?=
 =?utf-8?B?QWsrSUNzN0JmUE1uWml0WHY1SFZWbVNkS0hicHZFckIrNjdkTWtpMWJpV0ZH?=
 =?utf-8?B?QUlLSDRRcHNuS0VkTW10Q3BrSXNOUjZuU3p5UXZKRlA3REt0Ymx6aXZwR250?=
 =?utf-8?B?S00vd0xZaXJmd2h0aEVFVkcwaEhLTUJCajBUcko1Mks5WUpVc1hNeDhNc2Iv?=
 =?utf-8?B?bmZudndjT2xBTThvNS9vN3dtWm5ob2NUbGpnUHV0TDJVUUVXV1BzZVh0OXdQ?=
 =?utf-8?B?RStNbGRLZWdLdUVNY216YlJjZHU4S1MyNThGTGcwMnFaVWUrd1VSMVZBMXNG?=
 =?utf-8?B?czJqWWRjd0I5bm9nWktoNDEwZVRxaHZSb1htN2J0aXJxS1AwckxvblJGTmkz?=
 =?utf-8?B?VFVyVlAwbmZtWkptY2FZNU1nT1p6d2pEL3g0ZmZyZHlYWEl3YjJoaVVDeGdj?=
 =?utf-8?B?aWpXNEk0UUhGTkk1QmNGWE53eEYyOWVtMWVRZjBBRG04L2wvNVZEZWhXbHJY?=
 =?utf-8?B?ZEsyd2FTelMyL29VSlZiRW9ESjBWUVBBUTAxUHYrZHhQSkYwQ2U4cUpGcCtN?=
 =?utf-8?B?Slp0ZThPNDZ5enhDNDZyWXUvbGtqRldMZVdVSDcwNlZqNENQQ2M0WVk1d0Nh?=
 =?utf-8?B?aVVNQVZNcG5Lb0s4bmpmNW9IaU1WRjVUSXB3NXYwUGZYTVcrek5aQkt5WGor?=
 =?utf-8?B?a1VLS3pJTHN2SVR3Wnp5N0RUTTYrVDZQN3orRklmbVNKaXhRaFVHVllqbGZY?=
 =?utf-8?B?dWRBdzN2RDFvek13ZmhRclM1LzNoZk1lNitJZXlyRGgzSExrbXFKS09xbnE2?=
 =?utf-8?B?aGFUc1R5ZFhBeTVBdzZqYXJ0TnB4cnRDeVhYN2NQQUFBR2syRk5qSFdEZlpp?=
 =?utf-8?B?ajlUcjRIQ0dQdDlaWlA4TFhoTzg4UzFiTndxNHFOQ3FpeHJkSDlpYmtMVCtM?=
 =?utf-8?B?RGtkbVZqaC9ER2xJN3ZRdjFYREdhS1BaRVlqVFVTSmRReVEwc29zUXRXeFRG?=
 =?utf-8?B?ekxTVU56YjkzQitvQjNibmJNY2RRZE1DNFliek1zZm15cWRXajZZQUd5SHds?=
 =?utf-8?B?MmdYWWN4VFZ2eHkxVkoyMkJ2Y29yWGhyQllsdnQvSzJnVjJRVTMyY3BIY2dQ?=
 =?utf-8?B?dTlaS1F6azhrOFlZUXk4UFViaHdSYXd4cU5XVlZ0ZUdTamVxVUdQWnA0WlEr?=
 =?utf-8?B?TUJPUnZObFpzczFFbkZBVmRUN2F2NmpwR3I4MVZHZXFBdlA4Q01qNGNUMDhJ?=
 =?utf-8?B?aGk2ZERia1hLaE1CKzZJZUpFU1hscFhNMUJzdm5Scng5akNSUzM3eFkzYTlr?=
 =?utf-8?B?Q0VVV0RXZjYrRDhGcU9pbUpUTG9KWWVqcGRPQWNVQVk3QUVJTmVlckgrODZp?=
 =?utf-8?B?OWtsQXBsMHpKTjhhaGVuRHFlaDhKL09FUWtreFNibEpHR3kvTTRxWjNZVDlJ?=
 =?utf-8?B?SW5wOFkxb1hmaCtTUWxzaXhRQzJnTEJGRUlSUHB3Wjg0YStwSTQ1KzZqM1lt?=
 =?utf-8?B?K0ljZGRqVjVYd0ZFcVQyYVRhUU52Rmx1am9GckFGaklrUFFyUmpWemlNWTZN?=
 =?utf-8?B?ckkzdkxQbTBoaGhYSnJCeFFsZCtDR1h1MkpqaXNPcy9NczBqTGZvWXBRRlZB?=
 =?utf-8?B?c2RUOVBtaHJIUGNrT0FzVS9PU1BiRFliT2wrTndhMGI3dE9IT2hpVDFSZUxy?=
 =?utf-8?B?ZUl4VjlybGM0cGREWGFXVFBLTkI0Uk4rcnd4VERvWkJucm8rNDZpWjB5UXc3?=
 =?utf-8?B?Sm11ZWN2d3pHbkNPUjF6M0sxVUZadlhiVVdveElIN2tjOGxLUGtkamZseUt6?=
 =?utf-8?B?ZU9XSE42L2xSSzlTVmtBUll3Rkk4OWdvTHpCbWY4NjRRQVhzT2Z3TDVEL0ta?=
 =?utf-8?B?QlhQR1ptN3V2MGY0WWc2dTk1SlVMdzFSalNOcGo2cDRHZ1hvRkp5UmNiN04z?=
 =?utf-8?B?QVprTnJNZ1hjSUsza203dnRBcHo2ZFBsTTJwelFmT0lqYmtzcEFoQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfd89711-05a5-43b5-9f7f-08dee6eb873e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5006.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2026 05:47:20.6074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8PGwhnfB0RIaHawaLx4M7opjvQ2pmcilEVZIhdDlwi+kzJ7KWPdWTjvxr6d2kECqGzVuieNEjGufCxVX6CIA0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7593

On 7/21/26 5:33 AM, Gregory Price wrote:
> find_next_best_node() picks the next-closest node for a fallback list
> from the full N_MEMORY set. Refactor it into find_next_best_node_in(),
> which takes an explicit candidates nodemask.
> 
> This enables building fallback lists with non-N_MEMORY candidates.
> 
> No functional change: every caller still selects from N_MEMORY.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  mm/internal.h     |  6 ++++--
>  mm/memory-tiers.c |  7 ++++---
>  mm/page_alloc.c   | 13 ++++++++-----
>  3 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index f26423de4ca28..96d78a7778e88 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1103,7 +1103,8 @@ extern int node_reclaim_mode;
>  
>  extern unsigned long node_reclaim(struct pglist_data *pgdat,
>  				  gfp_t gfp_mask, unsigned int order);
> -extern int find_next_best_node(int node, nodemask_t *used_node_mask);
> +extern int find_next_best_node_in(int node, nodemask_t *used_node_mask,
> +				  const nodemask_t *candidates);
>  #else
>  #define node_reclaim_mode 0
>  
> @@ -1112,7 +1113,8 @@ static inline unsigned long node_reclaim(struct pglist_data *pgdat,
>  {
>  	return 0;
>  }
> -static inline int find_next_best_node(int node, nodemask_t *used_node_mask)
> +static inline int find_next_best_node_in(int node, nodemask_t *used_node_mask,
> +					 const nodemask_t *candidates)
>  {
>  	return NUMA_NO_NODE;
>  }
> diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
> index 54851d8a195b0..25e121851b586 100644
> --- a/mm/memory-tiers.c
> +++ b/mm/memory-tiers.c
> @@ -370,7 +370,7 @@ int next_demotion_node(int node, const nodemask_t *allowed_mask)
>  	 * closest demotion target.
>  	 */
>  	nodes_complement(mask, *allowed_mask);
> -	return find_next_best_node(node, &mask);
> +	return find_next_best_node_in(node, &mask, &node_states[N_MEMORY]);
>  }
>  
>  static void disable_all_demotion_targets(void)
> @@ -450,7 +450,7 @@ static void establish_demotion_targets(void)
>  		memtier = list_next_entry(memtier, list);
>  		tier_nodes = get_memtier_nodemask(memtier);
>  		/*
> -		 * find_next_best_node, use 'used' nodemask as a skip list.
> +		 * find_next_best_node_in, use 'used' nodemask as a skip list.
>  		 * Add all memory nodes except the selected memory tier
>  		 * nodelist to skip list so that we find the best node from the
>  		 * memtier nodelist.
> @@ -463,7 +463,8 @@ static void establish_demotion_targets(void)
>  		 * in the preferred mask when allocating pages during demotion.
>  		 */
>  		do {
> -			target = find_next_best_node(node, &tier_nodes);
> +			target = find_next_best_node_in(node, &tier_nodes,
> +							&node_states[N_MEMORY]);
>  			if (target == NUMA_NO_NODE)
>  				break;
>  
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index f93a6bb9a872d..acf096f525f49 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5743,9 +5743,10 @@ static int numa_zonelist_order_handler(const struct ctl_table *table, int write,
>  static int node_load[MAX_NUMNODES];
>  
>  /**
> - * find_next_best_node - find the next node that should appear in a given node's fallback list
> + * find_next_best_node_in - find the next node that should appear in a given node's fallback list
>   * @node: node whose fallback list we're appending
>   * @used_node_mask: nodemask_t of already used nodes
> + * @candidates: nodemask_t of nodes eligible for selection
>   *
>   * We use a number of factors to determine which is the next node that should
>   * appear on a given node's fallback list.  The node should not have appeared
> @@ -5757,7 +5758,8 @@ static int node_load[MAX_NUMNODES];
>   *
>   * Return: node id of the found node or %NUMA_NO_NODE if no node is found.
>   */
> -int find_next_best_node(int node, nodemask_t *used_node_mask)
> +int find_next_best_node_in(int node, nodemask_t *used_node_mask,
> +			   const nodemask_t *candidates)
>  {
>  	int n, val;
>  	int min_val = INT_MAX;
> @@ -5767,12 +5769,12 @@ int find_next_best_node(int node, nodemask_t *used_node_mask)
>  	 * Use the local node if we haven't already, but for memoryless local
>  	 * node, we should skip it and fall back to other nodes.
>  	 */
> -	if (!node_isset(node, *used_node_mask) && node_state(node, N_MEMORY)) {
> +	if (!node_isset(node, *used_node_mask) && node_isset(node, *candidates)) {
>  		node_set(node, *used_node_mask);
>  		return node;
>  	}
>  
> -	for_each_node_state(n, N_MEMORY) {
> +	for_each_node_mask(n, *candidates) {
>  
>  		/* Don't want a node to appear more than once */
>  		if (node_isset(n, *used_node_mask))
> @@ -5857,7 +5859,8 @@ static void build_zonelists(pg_data_t *pgdat)
>  	prev_node = local_node;
>  
>  	memset(node_order, 0, sizeof(node_order));
> -	while ((node = find_next_best_node(local_node, &used_mask)) >= 0) {
> +	while ((node = find_next_best_node_in(local_node, &used_mask,
> +					      &node_states[N_MEMORY])) >= 0) {
>  		/*
>  		 * We don't want to pressure a particular node.
>  		 * So adding penalty to the first node in same


Looks good!

Acked-by: Balbir Singh <balbirs@nvidia.com>
