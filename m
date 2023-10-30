Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D84E18E04
	for <nvdimm@lists.linux.dev>; Mon, 30 Oct 2023 16:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lqQJ3oUy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698683058; x=1730219058;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JwzzRr5L8M1313S0qnx/qibKWcEjnkl1R/TFedqtqEg=;
  b=lqQJ3oUyjNKFvhD0EnTync1uPivb7tdRtjArxDUcb9V2rNbvUMIcyGwq
   IcWO57I2SuC6sfgg6bMSXGEy32Mz9RnOgb4A0uKapfRD3uoE7eEvpak9A
   B/ZsNSCZ50V9vKU/HZBPCZjgAscB/7vDdr35vTT3PuAKh1b+8sDbXmmBS
   lcnXcaaR5J+N+lHCeHJsoZj+8g2Cc5hQ55s9lIvKV3eAdJrDBPEzDnPq/
   v+Ku8qlBItAGn49ZnnRlyzrzWZh1F5pOucaFqcJnyPpHH0eio6mgTUZaz
   gafElsNZ2AWVsUEmQRxuWgYlAD78sndkNayjmu2uaOh7PmIelVQ062Ue9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="454569995"
X-IronPort-AV: E=Sophos;i="6.03,263,1694761200"; 
   d="scan'208";a="454569995"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2023 09:24:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="795311306"
X-IronPort-AV: E=Sophos;i="6.03,263,1694761200"; 
   d="scan'208";a="795311306"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Oct 2023 09:24:17 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 30 Oct 2023 09:24:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 30 Oct 2023 09:24:16 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 30 Oct 2023 09:24:16 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 30 Oct 2023 09:24:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l5eWYDuezjlP5QeZbGU7Ldy9PwN67j8KN2xxu4iLa4BtCHOfvNxJ/OxP/oqhLjjKIUiSYxcVKosKVdK1wNB1JEIJXB7DxhtL7EqSwR1pqOXvwlo1dnGCirnda1N7EsJZdXPW6Y2i5nOG83WydpolM41+zwcvix37ZDM1xfxNJF+QkDFot+hG8Dtj2SrVFaFeoXVjYMszq/jmGxgoPXY4x8DjHGX81efyhZTRpxUdcCP+MP+rnefzNUiKDkp8oC92bs+W429IuOUXx1BnPS6DSISh9obDYc8xTWrGm+tzUyBWIpEb7VwVtXUfuqIvBCd78chlm3eAznDPv+HJpuBLHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o6T+tKzoOn//XkMNqZOnXfB9MVj2IyYTrYWGfe+oH0Q=;
 b=nYpDXwHrTBq0qz6Dijf/ZduiFIOvxMKepuQZSz78dn3KFLa2ODPN2q60phU5QIz8FrAb3brP6ctq765gKeh8myLjD7e7YHPgahpyA8l3Izu7mJtQEqXyfCBaQX27qbKBjE4fL2G+SPHsukzrS+chePh8m8V5o5PuuFE0oPvYQ9AGSr6z1EJpje9U9ekjrr0j/8nZvNFgR8MDUzayJWepNSK3nHi+v10Sw3tbO3bKpOC0V0mAk+j9Jx/vJ1TKvRYyfSD0IxRkK4L3I77P5LgPO5ZZGTTRLrXJv2NwtKgXBwXE40+glAYuBFPGDtbHUFAJpMXz+zLT0UcjlUlRwIv3Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by PH7PR11MB5960.namprd11.prod.outlook.com (2603:10b6:510:1e3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.26; Mon, 30 Oct
 2023 16:24:15 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::a353:a16f:7f8a:86aa]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::a353:a16f:7f8a:86aa%6]) with mapi id 15.20.6933.024; Mon, 30 Oct 2023
 16:24:15 +0000
Message-ID: <cae3112a-3cd4-4aa8-8b8a-7ca60fa1fa3e@intel.com>
Date: Mon, 30 Oct 2023 09:24:11 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [NDCTL PATCH v2] cxl/region: Add -f option for disable-region
To: Xiao Yang <yangx.jy@fujitsu.com>, <vishal.l.verma@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	"lizhijian@fujitsu.com" <lizhijian@fujitsu.com>, <caoqq@fujitsu.com>
References: <169525064907.3085225.2583864429793298106.stgit@djiang5-mobl3>
 <59e51baa-cd6f-7045-178f-c327a693f803@fujitsu.com>
 <7a01a5aa-678d-42ff-a877-8aaa8feb3fbd@intel.com>
 <c460ae5c-1685-9e41-5531-8b8016645f70@fujitsu.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <c460ae5c-1685-9e41-5531-8b8016645f70@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR05CA0059.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::34) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|PH7PR11MB5960:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c631f72-b254-4d57-5e21-08dbd964a870
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BQaqgotVF8cyHKZkqLFhnBpLZ9z/GDKmvGNYlZcv2zJZ+/HgFOcNgtRdFBjgwO4PjuGP3cYo4KPMuLve81l/ZcRQ5MMDzJKfWbtYJl9xROcppo5F8V6uawLsqkuiqMp5ZHtRUZX0TRbKQIwKqS097EYccM6u2qWi5aYvmYdbcW2jRMvwG1+pexd0bzuzPRRS/KbTO5U0cUD+u+Ghx2WttmKuVwOECkXPEMakuLoUKc15XXG6t1sxuY/cd8CNla823fCgeCxmd7HZtweI2jgVawLiKAkMB3JVwnXqTVjuNJ8bUdoWwoe5UcoLQWmVdY2b6CXzqPsUSgzXM9JvP8DTexgINNdNzmhxesapt9Ae29tKclNsLH8n9fRLgz/ih6GcQyqwqxPrBuzmK9TVUeKMbvxtD0eWLfE0iEx6zJnsA3XLjPQmFGfEjnsKYQqutiQTVxGPuCnvt3X/PjNsqzpLa8VJ7NBNevjvudPIHiu9UsYbe23uEFDYNjR1VEzejOlvyzHKtsKwVqDXem7t1xxQQZOudvmYgz5TZxTv5bQhd6AsI4A+xfAeqmXVqcVLxfrc9CpotYcVybn0yZqqkfs0M3mgZ1e8w7DYSFs6hRAsIQYO7kb5TKSveNcdc8Zxjcn6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(39860400002)(346002)(366004)(376002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(6512007)(36756003)(26005)(83380400001)(5660300002)(6666004)(6506007)(53546011)(2616005)(44832011)(82960400001)(8676002)(8936002)(66556008)(66476007)(316002)(41300700001)(6636002)(31686004)(66946007)(86362001)(31696002)(478600001)(38100700002)(6486002)(2906002)(4326008)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UVc3WHBXcHYwS2xsbk9vVmx0MTl2aTBFbGZLRHBjM09wN1pyeFhZck42QkZL?=
 =?utf-8?B?TS9sQ0IydWhJaWRLSDI0SnFxYVpFaWl3V1FxSzFKQW5CNGk1ZzZoTUhqU0Vx?=
 =?utf-8?B?d096dExYMk43S2xkT2szQS91RDZsWmV6Z3pqT0lZblZoQUtuY3dJbzVPS1A3?=
 =?utf-8?B?a1ZxQ3FTeDl0LzRUSlc0OHJtZVUwcUltWWg0VUNJRnBNcmxUOWRidmtTSDc5?=
 =?utf-8?B?UmxXbjVaNU54SzB2a2tBaHF3cXc1SnB3b0FjUGVlUktzcCtKbFhMcmRudy9q?=
 =?utf-8?B?ZUN3RGlCMlF3b0hPQitramNqY3dYaHJZZzhMalBwVGJnUk1RWnpnaUZ5Yjh1?=
 =?utf-8?B?VWpVV0NUanRTdWdUYU1lSHJnTlZtT2wwUktlS1cxVW5vanh5VWZwN2ZXSzNm?=
 =?utf-8?B?dk9ZeUt2WTlSQURIQ2dKVjZLRmljenFaWk5saHdsTEVKbHpjWnhUQnF2ak1s?=
 =?utf-8?B?T0hHNWZISkFWRW1DbzZiaUt2Z2xVZmVSaVVoeHJxdzlJNmpNaGtLTTFGWkF6?=
 =?utf-8?B?UU9kNEd1WmExMkwyTVVoeC9MNmlDQW1pcE1pRXlUZXd0WENvdW9FSkdwejhI?=
 =?utf-8?B?a1dmaU1zYm1Ua2FiTzRxRXdFQUxmTVphT25kNDFsMXRnVDR3QjI4TUVlQVZl?=
 =?utf-8?B?ZDIyY3VyMzFCWjdTTUpyc0Q0b3oxdlBiNTgvVVAyL1EwdEV2V1Fqb0NMdjJF?=
 =?utf-8?B?NElaZGcrVjZmSGZyNFVKRFhUTEJ6dVlXZlo2bFoyM2Z0OUxvZktsdFZDMFlw?=
 =?utf-8?B?V29ub00wOEtQVjhGVVVFYnVhbjdHaUpXYytlb05LNndHajhNS2VnTXNVNlRa?=
 =?utf-8?B?djRCdlA1NXI0WjVWdjE2SkVLc3RZM2kvUEpmY2c2UWlUUjliYlA3ejc5S2Ir?=
 =?utf-8?B?bnpSa3FtcXd6WlUydFlNZEN4eVY1L2JsVFU0UzZ2NWpEK1lCOE5IbHhPYm9k?=
 =?utf-8?B?Rm9hTy9TckxzQ3ozOUFScXJCQkhtZUhUd3RBZnlPTWxjRzVEdSt2ZS9TUS96?=
 =?utf-8?B?U2VyQnBaMGpqcHUycFFmZkQ5VmRneGpFaHpOTEtWRDcvVDM0bVFHY2t4a3Fx?=
 =?utf-8?B?VUxqQVQ4UjlVL1FsWXBHY2ljb0hwcUwwLzVGREhvOWdVVC9lclpoTWoxbE9I?=
 =?utf-8?B?aDN1dDI2SUZ2VnFURVJqN3IrdUQzcElHRFdrZWk3N3cranVjRHZQTFQ3UkE1?=
 =?utf-8?B?bjVvdlphK2JJSTQyVVdEaHZkYllMc2ZEMStZVEp4K1poT1ZLcXo0NkdKRzIv?=
 =?utf-8?B?ZkwyektuZmlGSGs1NmtwY1ZRYVkwZmhGMlRhQUZ4cFlLT04rcEdNQ0Q0bThr?=
 =?utf-8?B?YXcwMGZsaGIzelNnMmFnNnJQU0hEU3BkZWZhK1p1SHBmOUozMUV4NlBCSnRt?=
 =?utf-8?B?UmprcEhJK3U3MVFrRkF2UUVvRlBIdE90M1JQSEk3S1NTZ2J3ek9UMytiMzY4?=
 =?utf-8?B?REpadTBBZWlvTktyU2pEak5CTU83TW1EZlFFdGIxMkZtQkVSaHMwTDhJNnpP?=
 =?utf-8?B?czdLSTYrQTUrV1NtU05kZEs3MG9ITkVzeGFEcnhVYXBmUU1XcjdTMThTbzFo?=
 =?utf-8?B?SFBhbC9qa2FVclIzbHp6THRGV1UxdFZDeWkrWUd0eU5LMG9NSmFyYUkxZThI?=
 =?utf-8?B?R1ZXWjN5eGxUZjdQcy9aYlV4K3d5bzNGNm5obk8wNFlnODdEbVgzcG5JQnVi?=
 =?utf-8?B?R3Z1SFB6c3llMWF6SjcvbENBdUcwTEkvaUJib09OakI3VFZwU1FXcFIyRnZn?=
 =?utf-8?B?MnRCUkRReWtoZHMzbjlWQUg2Njk5clZqbklPaWVUUTU4WnQ5NHRwbXBsTzdX?=
 =?utf-8?B?aTZld2R6YWc3Y0w0dnVNbUFad3J6ZE9GV2NNM20zbmExSi80UFU2cWM3Slhs?=
 =?utf-8?B?WUxIdW9maFoybjRVY2RxU1c5ZHF1UVFEb3pFdmVZRTUreHJ1N0h4WXNBVHJZ?=
 =?utf-8?B?M2ZFYnU0aEVJSThTY1dPR3hKMHZtWTdxb0c4RC9vNmo4YTJib0c1Ui9ac1hy?=
 =?utf-8?B?TWc3SXBHcXhSaitMR3M5QlRoMWNZRmpUejFXMVhMTmJsc1ppVVNSQ01KeVYx?=
 =?utf-8?B?Y05NVzhRVVhaakNPZ0QzMVR4OXVaZU93dTFZblVsRzUvNmtQMTYvWGY3dkdr?=
 =?utf-8?Q?NF53nKCPyj6vL4aoBHlcp2rJL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c631f72-b254-4d57-5e21-08dbd964a870
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 16:24:15.1259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oro46vHZXyp0X60JuwYB3myDC5f6rj6cVZmZerLUfGIkPRPo3NyAheaktT+efRnfokbdfgboiX0E40Pg3pnPrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5960
X-OriginatorOrg: intel.com



On 10/29/23 21:33, Xiao Yang wrote:
> On 2023/10/14 6:38, Dave Jiang wrote:
>>
>> On 10/9/23 03:52, Xiao Yang wrote:
>>> On 2023/9/21 6:57, Dave Jiang wrote:
>>>> +        if (daxctl_memory_online_no_movable(mem)) {
>>>> +            log_err(&rl, "%s: memory unmovable for %s\n",
>>>> +                    devname,
>>>> +                    daxctl_dev_get_devname(dev));
>>>> +            return -EPERM;
>>>> +        }
>>> Hi Dave,
>>>
>>> It seems wrong to check if memory is unmovable by the return number of daxctl_memory_online_no_movable(mem) here. IIRC, the return number of daxctl_memory_online_no_movable(mem)/daxctl_memory_op(MEM_GET_ZONE) indicates how many memory blocks have the same memory zone. So I think you should check mem->zone and MEM_ZONE_NORMAL as daxctl_memory_is_movable() did.
>> Do you mean:
>> rc = daxctl_memory_online_no_movable(mem);
>> if (rc < 0)
>>     return rc;
>> if (rc > 0) {
>>     log_err(&rl, "%s memory unmovable for %s\n' ...);
>>     return -EPERM;
>> }
>>
> Hi Dave,
> 
> Sorry for the late reply.
> 
> Is it necessary to try to online the memory region to the MEM_ZONE_NORMAL by daxctl_memory_online_no_movable(mem)? If you just want to check if the onlined memory region is in the MEM_ZONE_NORMAL, the following code seems better:
>     mem->zone = 0;
>     rc = daxctl_memory_op(mem, MEM_GET_ZONE);
>     if (rc < 0)
>         return rc;
>     if (mem->zone == MEM_ZONE_NORMAL) {
>         log_err(&rl, "%s memory unmovable for %s\n' ...);
>     return -EPERM;
>     }
> 

Ah that was a mistake. I meant to call the query function and not the online op function. Do you have any objections to

if (!daxctl_memory_is_movable(mem))

> Best Regards,
> Xiao Yang
