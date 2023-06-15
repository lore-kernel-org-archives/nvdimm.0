Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82362E0C2
	for <nvdimm@lists.linux.dev>; Thu, 15 Jun 2023 17:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686850489; x=1718386489;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YYyvsETzeYDLklmMsYuEztVQz3hGu7gVxGK0wt1cbeE=;
  b=JyDk3MtSXu8lP5KdyuQ3vjGLKbcbGjnWcVni1Z/hZyXk1RxyxmqKZ10i
   +/fUtQaJsqaE1VX96oyvCr3uTNWqkUVq2ktTZ9HfYmzwlBG71cTfto9Ji
   KV7PDSdVGgupQDrzCf5oIjXopMwVHGpBAdSQtwvRkBIQdhSNPChgo3d5e
   wXI7Oa8nHhmDmHPrh2TwpHXJvW5FbofAMsVqvuwXvHEQP1KNQKSd69YWG
   tbK7gDjwQPG6kcbWLDZPdm1B+pHL1EmywnCg8q1mr+R4IPKJmuiotpldH
   ZTWjfZYeYCTk6Sb+uIetgFwwFDBHJNjfQXYXgnPS4ckX0qBTp6FZTCfQN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="357866112"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="357866112"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 10:34:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="1042781022"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="1042781022"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 15 Jun 2023 10:34:10 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 10:34:00 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 10:33:59 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 15 Jun 2023 10:33:59 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 15 Jun 2023 10:33:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z3UnkKHNktvr81PG1exY4FLf6DjXA3H3Wjlo6ctvYPZQB3fiQUowVi1q7ZJzvKfCUQDTa2Uryl0R/FMgnUtAaTS9Oh+ANh+GK1Wq/dDF7GSBb7UsrMp2lOtvL2aWX9Io3eB0L2AxSLIUCkNK45WtnIe1afmgM5siyJs7baNc2UTS6aDHIu8KKhRYvL04nODS/U21mJmupk13YkDVX6YMom0fGFQPP5kZ47z4XdW3kPJLKAYv0q3JXLQwqWxZpmvOLvHSDl7CZPHEgmg82CquXjQCHnK2wXWi6UCNTi9tYTsJMHBJIZYMNNQfskemWJUdsQhi0kpi8twpxa9WRhDw9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dTeZqHA3ok1M6HLv8MCd08AAWPovq6+fzx9KFvT+2Dk=;
 b=KYfpAOu5aEW99Dd2a52DZpiCqVWYLAglKVjynjaPP0Wb5mtP92ydRTVIArMEt3IyLC3Y/kHLWtW4AQSWCSNB7gRxPRqCNQOCYcK0v94IFPYT5MeDBCdmE/p/7baVF1WNdkXTtGN9ZSw1ZfpQXnj508ZzReq7i1fxwOvK5DcjA7HOjG5Js++zvALVHcg1s36m9xyjI1EQgzbeREOFbQNyC0MSKpLgdaYpES0bVxjjDi6q2vFQO53JY2dVh8l8BDRkqnY6XbbmH1GHe/dzNaEd9Vg2nJzZHvQ+u4GrekzKmrgKL3wcNkjk3s8EZYe5RA+hjk+F+zLAlm4Q0IisIOkH0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by PH0PR11MB5031.namprd11.prod.outlook.com (2603:10b6:510:33::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Thu, 15 Jun
 2023 17:33:54 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::ef38:9181:fb78:b528]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::ef38:9181:fb78:b528%7]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 17:33:54 +0000
Message-ID: <b05b81bb-ed3d-ed95-71c9-4d2e30aa017f@intel.com>
Date: Thu, 15 Jun 2023 10:33:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Betterbird/102.11.1
Subject: Re: [PATCH 1/4] dax: Fix dax_mapping_release() use after free
To: Dan Williams <dan.j.williams@intel.com>, <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>
References: <168577282846.1672036.13848242151310480001.stgit@dwillia2-xfh.jf.intel.com>
 <168577283412.1672036.16111545266174261446.stgit@dwillia2-xfh.jf.intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <168577283412.1672036.16111545266174261446.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0040.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::15) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|PH0PR11MB5031:EE_
X-MS-Office365-Filtering-Correlation-Id: d74aa4ea-3066-498e-1318-08db6dc6b070
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1moYIYkoKj0DUxPlzgs44vomX/cpQ+66jaqWGHBEnAo1bdwBEDHtjlkaH3/lxrIMcnN+nMi3pMV/RV1XyTugPfFEcDeeHIrNk9FVR8sOzPMA1D4u3Su5C0qExejqBKchimPAd0jc7Z3XqEXnaJz4KybGrngPLuJb4EP5F5BWAJB7lLvSwXF7/Qup9ktOaMfNAFkCBeUujzSxPb32adiNKoO2bnK+u3Lli9fCeQprmKV0lI89NTG+6X1NGNWaOxI6dN4lpGGLiO04diOH/i3GOQkd2MYwv1rxu1JtPA8idtI2bAEgZSj+UcDapbLflGelLvKOVqMF5RuNCh+o0ZAH7Dgvp8x9R33Xq/9vBNH9jUqGIPObK0ElpV1hdUbhIAlWDKuFDdQh7xiLgqLWgoj3kZ6gwM0AmH17uj0iHW2XpQH4d110EYD0xD/B0f4JdYlmu/TOEFKunu2lmi2xSmKLNZR7eT+th+3B6AoAWxgTeXlCZLWgL2WPD0e2BS7m+1l7d4C0rOu0CMdpr8C4dAMnlJO/go0bSzkaYATHLCGjP0GpaNxdV0NqgEQCUbNOW9npxvpxAF4PvD36SVuCQNnjVZdrVzZK8ApO61SUdtkDGi4QG30R92d9MPVvqSguzEd8ho9zWidwetmmJyf3b+detg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(376002)(136003)(39860400002)(396003)(451199021)(478600001)(6512007)(186003)(53546011)(6506007)(26005)(86362001)(2616005)(31686004)(31696002)(66556008)(4326008)(66476007)(316002)(66946007)(38100700002)(82960400001)(83380400001)(6666004)(6486002)(8676002)(8936002)(44832011)(5660300002)(2906002)(41300700001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QUVVNEtCc3hwVXRlZXB0V2FwdkZZZzFPVTRCampCZHRQbkE3ZjV4TXFIMys0?=
 =?utf-8?B?Y3pTUmt6MjFZK2g4YWlpWEpWb0lvMVMvNmRYTU9mY2NiY1VyYmVUTE5wempU?=
 =?utf-8?B?MmU4MUd2cis1VVRjYXQ0dUI4aThXektvZWlnS1I1bjdkZ3c3aDF3TnEvZENN?=
 =?utf-8?B?VzRvay9ib0pvT2dwU0pSbEdKSjhyTGlDUW9uTm44clJWMS84eWpEOWdEcTBh?=
 =?utf-8?B?dVg0SEM4UVM1YXpoOUwxVE9wendTdUl4U3FsVzJkN01tYkN6WmFRZlZHZ0R4?=
 =?utf-8?B?TnVmelY2bUUraWhyZ0RtemlPYjJrSDhCZkdiNHBleDBWTXFzTTV1VWZNdHBj?=
 =?utf-8?B?MDkraWt5ZmFIUlpMdEFmdnRIVVR4d1hObGF0RFdHTHNTc2Yxejl4dEVUNnpx?=
 =?utf-8?B?Z3crZzJwZ29WK0hpMXpTWmRiTGdLajc4Qy9Xc291R1FlQ3FRQUpMc2ZIYlAr?=
 =?utf-8?B?cTJlelZPdnAyZHNJWEV4bElrcEwrOWk0ZlZ0L0F6aUN4UzNpOENTTk9NZmFt?=
 =?utf-8?B?aERzZkZNYVpaSi9oRlczK24wWGdMSkNpZHZpcDFRb3NZT25LQ1dSU2NNK0pB?=
 =?utf-8?B?Zm0zYzA4bkVEMU50YWpwZjJpZ3BHMnU1QVNVbEo5ZVc0eDc4N1Qzc3F0dTFC?=
 =?utf-8?B?Zi9NUjhsQnNFY1l1Y2p2MDdXczRBQ2FhOTc1akR1Uy94QzdwT3NGS1dpaXVU?=
 =?utf-8?B?d2lGY2ZPRWZZOUFzTWJxWGJ5WUN2Z1hDaUp3amlXMTFaTW5lVzhlZmJmdUMw?=
 =?utf-8?B?QWpBeGJMN2FzWXNTdWFTN255aSt4UWFPL2ZKT2IvQ0cxVng0RXNqeWV2cnFm?=
 =?utf-8?B?MWQ2aWR2TUswNDRSRVE4Y294NEFKU3AwbFZySi9pOFJhVXcxNVpYcENaYm5n?=
 =?utf-8?B?SjBkUE94UXFtcmg1S1ZPMFJuM1lRZDZFaURIYWtzMExhQXgvVG9XRHRWUTJ5?=
 =?utf-8?B?SEZRM0JZdUhrVW0rc2lUaWhwYXpiSDRSMVhmQTZKZEplZlVhMFo2WElkQ1o1?=
 =?utf-8?B?UjRKQmxIZjdkeUlSOVE4dnlNRnZaeFpOMDFhWWFMdnI1YUpOL1Z1aFVlMWtl?=
 =?utf-8?B?VkhZU3F1MjFtTmYyWHk0T2lWc0xKdFpQU0w5S0kwTWlLL1FzNk1jMmNyN3JS?=
 =?utf-8?B?RUtoeXY4VmI4NmdzVGlhZFM4WEZqVnQ1VzRZcUQrUGlDYnVENEtHRit0aXBk?=
 =?utf-8?B?Q3RUYUM2TUlMYktpSFJwY1d2WFQzdUFaSjdvNFVOWXhCNjhnM2IwUnF5R2dr?=
 =?utf-8?B?Tkl5VW5TM2htUDl4cUJEdlBGdmdpLzNaYVgvamYvd2JyVFkwWDBwbVJIZUxT?=
 =?utf-8?B?NC8wTVUxdm1yRUdHUGJhb2lRNENPNXZQa0dPZld0S2tqYzRlYlNDS0NyS2dH?=
 =?utf-8?B?VEtiY3B6anRyckJxRDlzOHFsdWtWaUhNOWVnUy9Lamd1SjVkb0UwdXNTeTJt?=
 =?utf-8?B?eU9CTkRYK0twbFZtWno2Z3c2bmFYWHViek5NRXQ3K1BBSWdqTitVRjNLOUNQ?=
 =?utf-8?B?ak5VRWJGQVpsZlZRaUpGUHl0RjR3eUthT3hzcGxyREJHY3h4MTBSczh5Z2M4?=
 =?utf-8?B?alVzMGdkc0tOK1hvQld2YXNuNDZyM3JXYjY0Sk1idFMxZWwxWk1aR2JzMzll?=
 =?utf-8?B?Q2p2Q1hiWUhINzRIQUNMaUJEYVY2MG8xdUNKa1JPRjFBeCtrOEg0K3BkSjZR?=
 =?utf-8?B?V0dOaXFHTDVmSG5wMlFhR0ZFU1M5d1RveDhYdzRBQjBqVWx6QUtmaEoxb290?=
 =?utf-8?B?OXVKVHFvMktGUmY4N3FOWGVnT0Z6bGNoUmU5SFNUOTU1VkNIdkl6Y051aFM3?=
 =?utf-8?B?eVF1RG8zN0NmTUhaNWlRRnNnWVVzd0Z1YjJjNEl4RWdXeDVRM0lFSnBrQW9H?=
 =?utf-8?B?TElheEJJNnBzQXpScHFCMUVFejc5akY5VU9EbjBBdlRYZTRXeFZZTlN1ZWQ1?=
 =?utf-8?B?b01xbTg0SDhvdVJrdWZIQ1N0dUZGbzBISGQ2TWxRdUdQb08yTnhRM0N3RzFk?=
 =?utf-8?B?TUg1RXRLUDN2QXNkeTUyWFdCR0p6cm9HQnV3UjRRT1J5L1NldS9NRzE2R0Jh?=
 =?utf-8?B?OGg5UXZXd215MnhTRzh0WHdKcUM1MlYvQnEwai9PNkNjTFQwcGVRS2RYT1NV?=
 =?utf-8?Q?nMTv3u4Vsoa3bNOqbmTOq62oC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d74aa4ea-3066-498e-1318-08db6dc6b070
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 17:33:53.6660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jjBeYhcixIipMvaG6Ic5X+rJBdxdyoa992CAvxS0oDQuU2Gou1zpZePDxAiRaTPoQvq+BjWy3XPCM+T8nlsuXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5031
X-OriginatorOrg: intel.com



On 6/2/23 23:13, Dan Williams wrote:
> A CONFIG_DEBUG_KOBJECT_RELEASE test of removing a device-dax region
> provider (like modprobe -r dax_hmem) yields:
> 
>   kobject: 'mapping0' (ffff93eb460e8800): kobject_release, parent 0000000000000000 (delayed 2000)
>   [..]
>   DEBUG_LOCKS_WARN_ON(1)
>   WARNING: CPU: 23 PID: 282 at kernel/locking/lockdep.c:232 __lock_acquire+0x9fc/0x2260
>   [..]
>   RIP: 0010:__lock_acquire+0x9fc/0x2260
>   [..]
>   Call Trace:
>    <TASK>
>   [..]
>    lock_acquire+0xd4/0x2c0
>    ? ida_free+0x62/0x130
>    _raw_spin_lock_irqsave+0x47/0x70
>    ? ida_free+0x62/0x130
>    ida_free+0x62/0x130
>    dax_mapping_release+0x1f/0x30
>    device_release+0x36/0x90
>    kobject_delayed_cleanup+0x46/0x150
> 
> Due to attempting ida_free() on an ida object that has already been
> freed. Devices typically only hold a reference on their parent while
> registered. If a child needs a parent object to complete its release it
> needs to hold a reference that it drops from its release callback.
> Arrange for a dax_mapping to pin its parent dev_dax instance until
> dax_mapping_release().
> 
> Fixes: 0b07ce872a9e ("device-dax: introduce 'mapping' devices")
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   drivers/dax/bus.c |    5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 227800053309..aee695f86b44 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -635,10 +635,12 @@ EXPORT_SYMBOL_GPL(alloc_dax_region);
>   static void dax_mapping_release(struct device *dev)
>   {
>   	struct dax_mapping *mapping = to_dax_mapping(dev);
> -	struct dev_dax *dev_dax = to_dev_dax(dev->parent);
> +	struct device *parent = dev->parent;
> +	struct dev_dax *dev_dax = to_dev_dax(parent);
>   
>   	ida_free(&dev_dax->ida, mapping->id);
>   	kfree(mapping);
> +	put_device(parent);
>   }
>   
>   static void unregister_dax_mapping(void *data)
> @@ -778,6 +780,7 @@ static int devm_register_dax_mapping(struct dev_dax *dev_dax, int range_id)
>   	dev = &mapping->dev;
>   	device_initialize(dev);
>   	dev->parent = &dev_dax->dev;
> +	get_device(dev->parent);
>   	dev->type = &dax_mapping_type;
>   	dev_set_name(dev, "mapping%d", mapping->id);
>   	rc = device_add(dev);
> 
