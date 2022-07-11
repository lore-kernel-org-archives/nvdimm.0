Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAE81104
	for <nvdimm@lists.linux.dev>; Mon, 11 Jul 2022 02:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657506693; x=1689042693;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5OUIwWYbRvMiH8oHOk0MbaZLpWLTOvMjb9siKOcTEVg=;
  b=J1H8VTJuwNVK/KvmNiG3XvDsjY8NTerksdjELOy9nWK7o9hSELx2dOiF
   Q+hOh3GdHEsc8SexoIBcjAMBTkKbq5nmZ0c1ifecnbTzoIBjQBsIvy9fi
   QuaTpxNynlAGOAnlDC+L10QaYjEG5ty1c91weoh+YC/ovZFtpQnxIZTh3
   91m4LcrBuz733APxgF4NWx+XMHXiR2pa5w4SehvdyPuQyutLHOH81KkX7
   r7Etp/fivwgep2PP+6IbqQ4xrV9q2FE9MZ7woQGg47hHZ/SfIQoIwsU1o
   N2h7gpX3yKKwIJMFCZoVHA35T07H3PYcw7+MTbhPjXSlq3OCYwbl9zYJA
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283315535"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283315535"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2022 19:31:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="721451609"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 10 Jul 2022 19:31:31 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sun, 10 Jul 2022 19:31:30 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Sun, 10 Jul 2022 19:31:30 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Sun, 10 Jul 2022 19:31:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZpnT5YxMerfEPU/ZMa9/gLqoFN8iQ0SvR9IAkUvG7EGVGhuXeeq3zaiX8yloowa1Rjmbzk1rNvA42QAeisGkLGPQnsjbowr4Vt6WpLMGqs7UaGJprvslXEfmQXi9rIHGrDA3xpq2W39E91dtsBaNt3EupGsFMErgIf2KxdPGW7pTc6aARPUPZolVh8cdUa0+DKPAbQWoRs4YM+5R08tevlWILwKgvcwCATd2X4nze4WLZK2DT5MtwxVlDYNTylycRG++n5ZX0ETw1GRLClNn1zZ0SHDSrbNZWrlZVX5zLH0fl8+dr624S7KUTxg6uwwcHltwv1tMREONkMgI+evKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nt9WYZiHtu5LCb3Wmtkmyda/5YVg2fpmvKvve1DY9nQ=;
 b=ZVvZq4m6LSqPG3BKyFynqDTVLIGJ2d+HE/fUhKLTS5L+aOursGwgZuUL/PHMruzhrdbFdvBhU0Dt67K31RUweQI2IlrY7aCTpy5jmx0naqZwXbshn0uW9Ea+0gd+KeZTfxEGpl3/WKQxyFDQya6+iIdUHt6GhGXMMFPHiTkm9evIxA9orlf1JR5oNbf60hACHPZZMG+2HaV2xP23tIwN2heENkV79Gz1zu5TpDDXnKDnziMfYOX2pK12nZ6VTixZdredGMtVFzlUb6cRSxjvgdPwL6gASEhNSkOry+7niDuOu1cCVN/6QZ0TKsW4zgSCil6dG7CjrdY+nk5cYcC9fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB2640.namprd11.prod.outlook.com (2603:10b6:805:56::11)
 by DM5PR1101MB2313.namprd11.prod.outlook.com (2603:10b6:4:51::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Mon, 11 Jul
 2022 02:31:28 +0000
Received: from SN6PR11MB2640.namprd11.prod.outlook.com
 ([fe80::e0cf:f32b:a48c:51cb]) by SN6PR11MB2640.namprd11.prod.outlook.com
 ([fe80::e0cf:f32b:a48c:51cb%5]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 02:31:28 +0000
Message-ID: <60ee6aef-3dd7-a2ce-1a04-c8f19e9efd59@intel.com>
Date: Mon, 11 Jul 2022 10:31:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] BTT: Use dram freelist and remove bflog to otpimize perf
Content-Language: en-US
To: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
CC: "Verma, Vishal L" <vishal.l.verma@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>
References: <20220630134244.685331-1-dennis.wu@intel.com>
From: dennis.wu <dennis.wu@intel.com>
In-Reply-To: <20220630134244.685331-1-dennis.wu@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0024.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::11)
 To SN6PR11MB2640.namprd11.prod.outlook.com (2603:10b6:805:56::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1566fde0-0576-4f87-7a46-08da62e57566
X-MS-TrafficTypeDiagnostic: DM5PR1101MB2313:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4BNVyEYEI42fsuxOPMQaHTslBn1M0Hh06iGE7a6hYLbY8PTURWImxe88zCl6FmhwqRMbjoF5LrGeBwogEv0OTABlZ2j5I1j5CtJAWAqceUrHKRm5/4BHYFU3QS5NieNjP1DpUUK0/xkGRkcmZ6i2rgF9AOw+/AT0NDhYkYgL5f6oa43RookrVRHi/k9+04j8jK67QwaohdivqozyMFWNJMdVSKPgQSn46s0xqkT8DbC7iwH45tVLOFRqlu4WXtaK8OSwSAVF5rLs/gjEPT56wqMY+zun5GEzJAW7dAOkQqa33twpqw93m7apC9CO3VSjwdqlN8AFltVoTtnLcujXG5CENtySRgWl9ODn1RgoZJdcfZ2yMUeyHZJgizQWZWgSQYgRztLF9WwD48k/bZPfUq/rT5GxmBnhbtulFYwkXlGhoa8wwLFyzCQqNbk8Y6f5lPD8UwnpKbgceZ0s3QUHiDnCWkg/sQFU2UJeXjIfPQUiXd1+uNBdv4XnslJOb366AoTSU9sy0e20TA3/GWnzxF0zTkjJ7sFXbC9SpnzaZxc+sgS0fht2kNbBNqKGlSVGTUZFpYufFVq3GBpHaEYsH6Z3g+CAsbg7yucjZpoZjgKoIXZ2IO44KIhqocb2v9vgxwR38DTfSJpbrKSAuoojoSEMIAvYiK5PYP3IVVC/oSPOntNTyyqUtQgevta8ANGkPyAQrpHPhci/4td+SsLBh5PsEfXedKcb9P8OKwE77fgEW4qeiw8AgQY8+LGYOEz22Dz2cR4KXTR2r7oPMHyRv6RCoeoQC4twCHpi2DUKW508venESAVyt1ObTC01NU1EdmwLWrfz8tv8tSaXtQn9iLgj1ZIfaQ1q6jU8zxQHxDE6K4Sy8Nj0EwbwJi7b5PeI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2640.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(396003)(376002)(366004)(39860400002)(84040400005)(36756003)(83380400001)(82960400001)(6486002)(966005)(478600001)(31686004)(2906002)(30864003)(186003)(86362001)(2616005)(66946007)(316002)(31696002)(5660300002)(6916009)(66476007)(107886003)(8676002)(8936002)(4326008)(66556008)(54906003)(53546011)(38100700002)(6666004)(41300700001)(6506007)(6512007)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Yzd6QklQVVhXcnR1bkpQMHNadFp0cXNzVXBHN3RWczU5R3pwYmREWVh2UjFn?=
 =?utf-8?B?cnV5QnFRTDBiNHpjWDFMWng3RnZkdE92cjVoSVl6OG1ubnZYTXdNMTZuZ05v?=
 =?utf-8?B?RmdnanlJZFdsVFZkVStkdldaRTY5bzh4MTc5QkZkN1M0dzhva2luYUFEYW5a?=
 =?utf-8?B?b2FaQzNVbE9Yc2Y2Si9HaERkcUY2S3lQenQyKzFaYXZXYW9hN0xEb3d4TUpF?=
 =?utf-8?B?bmcxb3N1UmFJYXdJZ0ZxNitESkdpVlFscXV1dWxoakppT0hMaXVXUUl4RW5k?=
 =?utf-8?B?T2xIc0VwNkg0Mnh1QzJTMkl5UFl1UzJLSUdYRE1MeTY3YmVEU1pKSksxSk9o?=
 =?utf-8?B?QS9xUThYNEZicGI3RkJiVUN2dDduWkhiRk9mRFhmS0NsZGkxT3Bqa2lzZDln?=
 =?utf-8?B?a0lJSDJqWG5PWWVUZVo2cForbFFyWng1WXBOc0Zxb1hRQ0kwNmFIbHoxeW8w?=
 =?utf-8?B?MllGZ3NNSmp1QVVQRWJrTTFCblI1aGFVV1Q2NVk0Y1lacmpSS0dCcHZqWlha?=
 =?utf-8?B?a2xZQUtZbzRCbzcyN3N0a3Q4YXN3NTNWWGhVT1lnek82WldLQ2NibmhYNlhs?=
 =?utf-8?B?ZVNoQ3cwM1NvM1JvejhUWjcrUjRGYnl4Q3p0U0pQUGRhck9kc3JteDV6S2Q1?=
 =?utf-8?B?K3RtY2RxZDF5SzQrS1V6QTZzNDF4dHY3SkplVzVjUnV4TmNDV3EyQlNCYmRn?=
 =?utf-8?B?c2RkY29zRmpjUFZDVnR1dXhZWDdlT1VyZWdtQkgyY1F3bHJCL21STWRkK2xS?=
 =?utf-8?B?WUFzQytjNUNkTVFXYzB0NTlubWVlcVlvenE1NlBFWTBiODVlRHliOGRZTDMr?=
 =?utf-8?B?SVJYbkR3cGFvdFpWU2doUXd4c3Q3eFdjNzFuNEpTV25nUWdEQ1VvaVRiSVdl?=
 =?utf-8?B?MDRTdWxnWEVVVXJ4N0pWcTl5OXpCZkxPKzljSEI1bitlbEs5eDBRSjh3Y016?=
 =?utf-8?B?SzJYYlpKRlZJSUR5cDZaQlZQZzM1b1VuRHZRcWdzRm1CUnhnbU9QLzNpTlFt?=
 =?utf-8?B?U3JER21rQ3NEWTBDVWUrQ1pBRzdreTFyQXplaHJLZlJuUlFrbzNsR1c2WGxP?=
 =?utf-8?B?ZXlwaFJ3V0xHK1QxcjRPNmIxMFhVZ2U3MUMrNDlZeFhpUjJWMTU3cDQ1LzFY?=
 =?utf-8?B?R0tuKzFVemdtM3p5TGNKOGJXR3d4RDlSN1ZOdkNJa1ZLT2xOSndTYUVqR1ly?=
 =?utf-8?B?eGhlNTJobG1ack41RmhRdTRkRVppVlUyZklXVW9DaFAxOWl3dm1COURMb0x0?=
 =?utf-8?B?Q0ZkcWhsUWpEdFc5UUhlSGdVc2NwbytobW5qS0NUMWE1L1pMWWRPU29tRVhG?=
 =?utf-8?B?R0YyTGl0QUFHY0dTS3VNK1NseWNzenF1dVBMcVdtYWdkcVM1RkhQMXorcFpF?=
 =?utf-8?B?RVRQb3F1OS9vYUk5UHQ4MXdBemVtb04vem5xOGhRc2x0dWVOQURtV2tUaCsr?=
 =?utf-8?B?UysvdE8rdTVGbXp3V3NSR0tOcnVTM1dnMnNsalNxeE5NaWZST29ORkxQeGht?=
 =?utf-8?B?L3J1djJqMzU2Ulc1bDdRL3ZlS2xCWEpsQVNkcUFjeWhDUlpMbEtpdUs5QWdS?=
 =?utf-8?B?czVIeklQZWpla2dKcllVYTczVEYzZDAvZXNzcTZqWFVnOVN6RmFuVXdWeE1z?=
 =?utf-8?B?Tzh6S3Jnd3lmSEMxZG10R1VDWlY2M0JwQVlsNWxaaTU1M2g5MTBDL0t5R0da?=
 =?utf-8?B?Q1lRRDd1V1kwTUF2UzRoZUNVSVg0YkVVOXQ4WHVCSzUzMWlOOXhHMjNVRDdC?=
 =?utf-8?B?bWFlbzg3Ym1PRExaOFFoUmJkK3lqSG5yTk9kQlNSMk54N2U4TVRjUERTRyt0?=
 =?utf-8?B?ZVZHeXlWTWpIbVZmM2VMZ1ZTbVJEOHlrZmdBRGsyeXMrTUNMaWRmZy9ERnUx?=
 =?utf-8?B?aGZQa0E5VTRMYndCa2N5eDh3aThEcExhMHczLzh5OGVoWThPMGFnQnhYNks1?=
 =?utf-8?B?Sm1CUnlSQSt2QlBoVUgxVGtDZlFuR1NiNVhmbUIybEpFbzdXakphWGdKWEVX?=
 =?utf-8?B?aUoxLzYxbmh6NVpGZy9NOHloOTgxQjhUUWNrNG9KVzVDNCtYOThZaWJ0ak9s?=
 =?utf-8?B?Tkd4emJxamExdTZGL1U1anBtTWFaWDRKTlA5ODU2VTAxdEF4RWkrd2x0UmFw?=
 =?utf-8?Q?qURVpQKvO2u/UcIiYT7L6Toig?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1566fde0-0576-4f87-7a46-08da62e57566
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2640.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 02:31:28.4591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZsH0TwSB8qjra/LtR7ypTTyxoFOQ18Ab7/DbGCyWuK/++oU2k5NbJEd+71f6HYje7LBjlyk9yWJXAODJo3J9rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2313
X-OriginatorOrg: intel.com

Vishal, Dan and Dave,

Can you help review the patch and give some comments?

BR,
Dennis Wu

On 6/30/22 21:42, Wu, Dennis wrote:
> Dependency:
> [PATCH] nvdimm: Add NVDIMM_NO_DEEPFLUSH flag to control btt
> data deepflush
> https://lore.kernel.org/nvdimm/20220629135801.192821-1-dennis.wu@intel.com/T/#u
>
> Reason:
> In BTT, each write will write sector data, update 4 bytes btt_map
> entry and update 16 bytes bflog (two 8 bytes atomic write),the
> meta data write overhead is big and we can optimize the algorithm
> and not use the bflog. Then each write, we will update the sector
> data and then 4 bytes btt_map entry.
>
> How:
> 1. scan the btt_map to generate the aba mapping bitmap, if one
> internal aba used, the bit will be set.
> 2. generate the in-memory freelist according the aba bitmap, the
> freelist is a array that records all the free ABAs like:
> | 340 | 422 | 578 |...
> that means ABA 340, 422, 578 are free. The last nfree(nlane)
> records in the array will be used for each lane at the beginning.
> 3. Get a free ABA of a lane, write data to the ABA. If the premap
> btt_map entry is initialization state (e_flag=0, z_flag=0), get
> an free ABA from the free ABA array for the lane. If the premap
> btt_map entry is not in initialization state, the ABA in the
> btt_map entry will be looked as the free ABA of the lane.Once
> the free ABAs = nfree that means the arena is fully written and
> we can free the whole freelist (not implimented yet).
> 4. In the code, "version_major ==2" is the new algorithm and
> the logic in else is the old algorithm.
>
> Result:
> 1. The write performance can improve ~50% and the latency also
> reduce to 60% of origial algorithm.
> 2. During initialization, scan btt_map and generate the freelist
> will take time and lead namespace enable longer. With 4K sector,
> 1TB namespace, the enable time less than 4s. This will only happen
> once during initalization.
> 3. Take 4 bytes per sector memory to store the freelist. But once
> the arena fully written, the freelist can be freed. As we know,in
> the storage case, the disk always be fully written for usage, then
> we don't have memory space overhead.
>
> Compatablity:
> 1. The new algorithm keep the layout of bflog, only ignore its
> logic, that means no update during new algorithm.
> 2. If a namespace create with old algorithm and layout, you can
> switch to the new algorithm seamless w/o any specific operation.
> 3. Since the bflog will not be updated if you move to the new
> algorithm. After you write data with the new algorithmyou, you
> can't switch back from the new algorithm to old algorithm.
>
> Signed-off-by: dennis.wu <dennis.wu@intel.com>
> ---
>   drivers/nvdimm/btt.c | 231 ++++++++++++++++++++++++++++++++++---------
>   drivers/nvdimm/btt.h |  15 +++
>   2 files changed, 199 insertions(+), 47 deletions(-)
>
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index c71ba7a1edd0..1d75e5f4d88e 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -70,10 +70,6 @@ static int btt_info_write(struct arena_info *arena, struct btt_sb *super)
>   	dev_WARN_ONCE(to_dev(arena), !IS_ALIGNED(arena->info2off, 512),
>   		"arena->info2off: %#llx is unaligned\n", arena->info2off);
>   
> -	/*
> -	 * btt_sb is critial information and need proper write
> -	 * nvdimm_flush will be called (deepflush)
> -	 */
>   	ret = arena_write_bytes(arena, arena->info2off, super,
>   			sizeof(struct btt_sb), 0);
>   	if (ret)
> @@ -194,6 +190,8 @@ static int btt_map_read(struct arena_info *arena, u32 lba, u32 *mapping,
>   		break;
>   	case 3:
>   		*mapping = postmap;
> +		z_flag = 1;
> +		e_flag = 1;
>   		break;
>   	default:
>   		return -EIO;
> @@ -507,6 +505,30 @@ static u64 to_namespace_offset(struct arena_info *arena, u64 lba)
>   	return arena->dataoff + ((u64)lba * arena->internal_lbasize);
>   }
>   
> +static int arena_clear_error(struct arena_info *arena, u32 lba)
> +{
> +	int ret = 0;
> +
> +	void *zero_page = page_address(ZERO_PAGE(0));
> +	u64 nsoff = to_namespace_offset(arena, lba);
> +	unsigned long len = arena->sector_size;
> +
> +	mutex_lock(&arena->err_lock);
> +	while (len) {
> +		unsigned long chunk = min(len, PAGE_SIZE);
> +
> +		ret = arena_write_bytes(arena, nsoff, zero_page,
> +			chunk, 0);
> +		if (ret)
> +			break;
> +		len -= chunk;
> +		nsoff += chunk;
> +	}
> +	mutex_unlock(&arena->err_lock);
> +
> +	return ret;
> +}
> +
>   static int arena_clear_freelist_error(struct arena_info *arena, u32 lane)
>   {
>   	int ret = 0;
> @@ -536,6 +558,82 @@ static int arena_clear_freelist_error(struct arena_info *arena, u32 lane)
>   	return ret;
>   }
>   
> +/*
> + * get_aba_in_a_lane - get a free block out of the freelist.
> + * @arena: arena handler
> + * @lane:	the block (postmap) will be put back to free array list
> + */
> +static inline void get_lane_aba(struct arena_info *arena,
> +		u32 lane, u32 *entry)
> +{
> +	uint32_t free_num;
> +
> +	spin_lock(&(arena->list_lock.lock));
> +	free_num = arena->freezone_array.free_num;
> +	arena->lane_free[lane] = arena->freezone_array.free_array[free_num - 1];
> +	arena->freezone_array.free_num = free_num - 1;
> +	spin_unlock(&(arena->list_lock.lock));
> +
> +	*entry = arena->lane_free[lane];
> +}
> +
> +static int btt_freezone_init(struct arena_info *arena)
> +{
> +	int ret = 0, trim, err;
> +	u32 i;
> +	u32 mapping;
> +	u8 *aba_map_byte, *aba_map;
> +	u32 *free_array;
> +	u32 free_num = 0;
> +	u32 aba_map_size = (arena->internal_nlba>>3) + 1;
> +
> +	aba_map = vzalloc(aba_map_size);
> +	if (!aba_map)
> +		return -ENOMEM;
> +
> +	/*
> +	 * prepare the aba_map, each aba will be in a bit, occupied bit=1, free bit=0
> +	 * the scan will take times, but it is only once execution during initialization.
> +	 */
> +	for (i = 0; i < arena->external_nlba; i++) {
> +		ret = btt_map_read(arena, i, &mapping, &trim, &err, 0);
> +		if (ret || (trim == 0 && err == 0))
> +			continue;
> +		if (mapping < arena->internal_nlba) {
> +			aba_map_byte = aba_map + (mapping>>3);
> +			*aba_map_byte |= (u8)(1<<(mapping % 8));
> +		}
> +	}
> +
> +	/*
> +	 * Scan the aba_bitmap , use the static array, that will take 1% memory.
> +	 */
> +	free_array = vmalloc(arena->internal_nlba*sizeof(u32));
> +	if (!free_array) {
> +		vfree(aba_map);
> +		return -ENOMEM;
> +	}
> +
> +	for (i = 0; i < arena->internal_nlba; i++) {
> +		aba_map_byte = aba_map + (i>>3);
> +		if (((*aba_map_byte) & (1<<(i%8))) == 0) {
> +			free_array[free_num] = i;
> +			free_num++;
> +		}
> +	}
> +	spin_lock_init(&(arena->list_lock.lock));
> +
> +	for (i = 0; i < arena->nfree; i++) {
> +		arena->lane_free[i] = free_array[free_num - 1];
> +		free_num--;
> +	}
> +	arena->freezone_array.free_array = free_array;
> +	arena->freezone_array.free_num = free_num;
> +
> +	vfree(aba_map);
> +	return ret;
> +}
> +
>   static int btt_freelist_init(struct arena_info *arena)
>   {
>   	int new, ret;
> @@ -597,8 +695,7 @@ static int btt_freelist_init(struct arena_info *arena)
>   			 * to complete the map write. So fix up the map.
>   			 */
>   			ret = btt_map_write(arena, le32_to_cpu(log_new.lba),
> -					le32_to_cpu(log_new.new_map), 0, 0,
> -					NVDIMM_NO_DEEPFLUSH);
> +					le32_to_cpu(log_new.new_map), 0, 0, NVDIMM_NO_DEEPFLUSH);
>   			if (ret)
>   				return ret;
>   		}
> @@ -813,7 +910,12 @@ static void free_arenas(struct btt *btt)
>   		list_del(&arena->list);
>   		kfree(arena->rtt);
>   		kfree(arena->map_locks);
> -		kfree(arena->freelist);
> +		if (arena->version_major == 2) {
> +			if (arena->freezone_array.free_array)
> +				vfree(arena->freezone_array.free_array);
> +		} else {
> +			kfree(arena->freelist);
> +		}
>   		debugfs_remove_recursive(arena->debugfs_dir);
>   		kfree(arena);
>   	}
> @@ -892,14 +994,18 @@ static int discover_arenas(struct btt *btt)
>   		arena->external_lba_start = cur_nlba;
>   		parse_arena_meta(arena, super, cur_off);
>   
> -		ret = log_set_indices(arena);
> -		if (ret) {
> -			dev_err(to_dev(arena),
> -				"Unable to deduce log/padding indices\n");
> -			goto out;
> -		}
> +		if (arena->version_major == 2) {
> +			ret = btt_freezone_init(arena);
> +		} else {
> +			ret = log_set_indices(arena);
> +			if (ret) {
> +				dev_err(to_dev(arena),
> +					"Unable to deduce log/padding indices\n");
> +				goto out;
> +			}
>   
> -		ret = btt_freelist_init(arena);
> +			ret = btt_freelist_init(arena);
> +		}
>   		if (ret)
>   			goto out;
>   
> @@ -984,9 +1090,11 @@ static int btt_arena_write_layout(struct arena_info *arena)
>   	if (ret)
>   		return ret;
>   
> -	ret = btt_log_init(arena);
> -	if (ret)
> -		return ret;
> +	if (arena->version_major != 2) {
> +		ret = btt_log_init(arena);
> +		if (ret)
> +			return ret;
> +	}
>   
>   	super = kzalloc(sizeof(struct btt_sb), GFP_NOIO);
>   	if (!super)
> @@ -1039,7 +1147,10 @@ static int btt_meta_init(struct btt *btt)
>   		if (ret)
>   			goto unlock;
>   
> -		ret = btt_freelist_init(arena);
> +		if (arena->version_major == 2)
> +			ret = btt_freezone_init(arena);
> +		else
> +			ret = btt_freelist_init(arena);
>   		if (ret)
>   			goto unlock;
>   
> @@ -1233,12 +1344,14 @@ static int btt_read_pg(struct btt *btt, struct bio_integrity_payload *bip,
>   			u32 new_map;
>   			int new_t, new_e;
>   
> -			if (t_flag) {
> +			/* t_flag = 1, e_flag = 0 or t_flag=0, e_flag=0 */
> +			if ((t_flag && e_flag == 0) || (t_flag == 0 && e_flag == 0)) {
>   				zero_fill_data(page, off, cur_len);
>   				goto out_lane;
>   			}
>   
> -			if (e_flag) {
> +			/* t_flag = 0, e_flag = 1*/
> +			if (e_flag && t_flag == 0) {
>   				ret = -EIO;
>   				goto out_lane;
>   			}
> @@ -1326,6 +1439,7 @@ static int btt_write_pg(struct btt *btt, struct bio_integrity_payload *bip,
>   	while (len) {
>   		u32 cur_len;
>   		int e_flag;
> +		int z_flag;
>   
>    retry:
>   		lane = nd_region_acquire_lane(btt->nd_region);
> @@ -1340,29 +1454,41 @@ static int btt_write_pg(struct btt *btt, struct bio_integrity_payload *bip,
>   			goto out_lane;
>   		}
>   
> -		if (btt_is_badblock(btt, arena, arena->freelist[lane].block))
> -			arena->freelist[lane].has_err = 1;
> +		if (arena->version_major == 2) {
> +			new_postmap = arena->lane_free[lane];
> +			if (btt_is_badblock(btt, arena, new_postmap)
> +				|| mutex_is_locked(&arena->err_lock)) {
> +				nd_region_release_lane(btt->nd_region, lane);
> +				ret = arena_clear_error(arena, new_postmap);
> +				if (ret)
> +					return ret;
> +				/* OK to acquire a different lane/free block */
> +				goto retry;
> +			}
> +		} else {
> +			if (btt_is_badblock(btt, arena, arena->freelist[lane].block))
> +				arena->freelist[lane].has_err = 1;
>   
> -		if (mutex_is_locked(&arena->err_lock)
> -				|| arena->freelist[lane].has_err) {
> -			nd_region_release_lane(btt->nd_region, lane);
> +			if (mutex_is_locked(&arena->err_lock)
> +					|| arena->freelist[lane].has_err) {
> +				nd_region_release_lane(btt->nd_region, lane);
>   
> -			ret = arena_clear_freelist_error(arena, lane);
> -			if (ret)
> -				return ret;
> +				ret = arena_clear_freelist_error(arena, lane);
> +				if (ret)
> +					return ret;
>   
> -			/* OK to acquire a different lane/free block */
> -			goto retry;
> -		}
> +				/* OK to acquire a different lane/free block */
> +				goto retry;
> +			}
>   
> -		new_postmap = arena->freelist[lane].block;
> +			new_postmap = arena->freelist[lane].block;
> +		}
>   
>   		/* Wait if the new block is being read from */
>   		for (i = 0; i < arena->nfree; i++)
>   			while (arena->rtt[i] == (RTT_VALID | new_postmap))
>   				cpu_relax();
>   
> -
>   		if (new_postmap >= arena->internal_nlba) {
>   			ret = -EIO;
>   			goto out_lane;
> @@ -1380,7 +1506,7 @@ static int btt_write_pg(struct btt *btt, struct bio_integrity_payload *bip,
>   		}
>   
>   		lock_map(arena, premap);
> -		ret = btt_map_read(arena, premap, &old_postmap, NULL, &e_flag,
> +		ret = btt_map_read(arena, premap, &old_postmap, &z_flag, &e_flag,
>   				NVDIMM_IO_ATOMIC);
>   		if (ret)
>   			goto out_map;
> @@ -1388,17 +1514,25 @@ static int btt_write_pg(struct btt *btt, struct bio_integrity_payload *bip,
>   			ret = -EIO;
>   			goto out_map;
>   		}
> -		if (e_flag)
> -			set_e_flag(old_postmap);
> -
> -		log.lba = cpu_to_le32(premap);
> -		log.old_map = cpu_to_le32(old_postmap);
> -		log.new_map = cpu_to_le32(new_postmap);
> -		log.seq = cpu_to_le32(arena->freelist[lane].seq);
> -		sub = arena->freelist[lane].sub;
> -		ret = btt_flog_write(arena, lane, sub, &log);
> -		if (ret)
> -			goto out_map;
> +
> +		if (arena->version_major == 2) {
> +			if (z_flag == 0 && e_flag == 0) /* initialization state (00)*/
> +				get_lane_aba(arena, lane, &old_postmap);
> +			else
> +				arena->lane_free[lane] = old_postmap;
> +		} else {
> +			if (e_flag && z_flag != 1) /* Error State (10) */
> +				set_e_flag(old_postmap);
> +
> +			log.lba = cpu_to_le32(premap);
> +			log.old_map = cpu_to_le32(old_postmap);
> +			log.new_map = cpu_to_le32(new_postmap);
> +			log.seq = cpu_to_le32(arena->freelist[lane].seq);
> +			sub = arena->freelist[lane].sub;
> +			ret = btt_flog_write(arena, lane, sub, &log);
> +			if (ret)
> +				goto out_map;
> +		}
>   
>   		ret = btt_map_write(arena, premap, new_postmap, 0, 0,
>   			NVDIMM_IO_ATOMIC|NVDIMM_NO_DEEPFLUSH);
> @@ -1408,8 +1542,11 @@ static int btt_write_pg(struct btt *btt, struct bio_integrity_payload *bip,
>   		unlock_map(arena, premap);
>   		nd_region_release_lane(btt->nd_region, lane);
>   
> -		if (e_flag) {
> -			ret = arena_clear_freelist_error(arena, lane);
> +		if (e_flag && z_flag != 1) {
> +			if (arena->version_major == 2)
> +				ret = arena_clear_error(arena, old_postmap);
> +			else
> +				ret = arena_clear_freelist_error(arena, lane);
>   			if (ret)
>   				return ret;
>   		}
> diff --git a/drivers/nvdimm/btt.h b/drivers/nvdimm/btt.h
> index 0c76c0333f6e..996af269f854 100644
> --- a/drivers/nvdimm/btt.h
> +++ b/drivers/nvdimm/btt.h
> @@ -8,6 +8,7 @@
>   #define _LINUX_BTT_H
>   
>   #include <linux/types.h>
> +#include "nd.h"
>   
>   #define BTT_SIG_LEN 16
>   #define BTT_SIG "BTT_ARENA_INFO\0"
> @@ -185,6 +186,20 @@ struct arena_info {
>   	u64 info2off;
>   	/* Pointers to other in-memory structures for this arena */
>   	struct free_entry *freelist;
> +
> +	/*divide the whole arena into #lanes zone. */
> +	struct zone_free {
> +		u32 free_num;
> +		u32 *free_array;
> +	} freezone_array;
> +	struct aligned_lock list_lock;
> +
> +	/*
> +	 * each lane, keep at least one free ABA
> +	 * if in the lane, no ABA, get one from freelist
> +	 */
> +	u32 lane_free[BTT_DEFAULT_NFREE];
> +
>   	u32 *rtt;
>   	struct aligned_lock *map_locks;
>   	struct nd_btt *nd_btt;
