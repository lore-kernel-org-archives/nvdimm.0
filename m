Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3452E0C2
	for <nvdimm@lists.linux.dev>; Thu, 15 Jun 2023 17:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686850509; x=1718386509;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7leU8N7yM60FegfZ0Pl6tUidar021/ZFTiZbfVG9Ak0=;
  b=A6HxhNQ85FlxofiH+49kRtNyrkyazQ+wIXi5LSxiKNbEum0Cx8TwcDAg
   ghysmOefy/dFdv4SZxRNtRvFP4lDPocYNTBFIlLodzb3OxKMK41Z6Zojz
   TzDzOsFoIbGTB14YMmnRkK2p47B5sJC5zvi9e8FkNVQeceGoNjxuWL0+z
   lybTdMqWUyGx5BWwOFhpySeb2TKFftY/UpYZ48vIcF8GpyjwHwfCJE+EP
   voSs73QNk1hSfNA8mH6b+FbsniVpH7FhvhtM2makuinxXHqFDZMC1Rc+M
   zcsYkNrd0fk5eYx7csz8oy3v03ElRWYbn7sNUSqzlRuxFsg8WHN0YboL0
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="357866315"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="357866315"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 10:34:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="1042781086"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="1042781086"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 15 Jun 2023 10:34:39 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 10:34:39 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 15 Jun 2023 10:34:39 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 15 Jun 2023 10:34:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UjbjLwEWDTM7NjhCgsui6dgZSA16/Mk1vDFSpbeSFsL1RgF1g2wCvuxdMyapiLashvYsXyZ1PKsJgCkvbUVyfUW8/kpe3VOGzKU95c/Alx3hhYWKTjI41JSg8WgE/GJdx7y8Hxshm08uXm0EBuMYD+dPR7TTzfvwK+pjZzaCWaqW8REkB7edu/2L9KomiBEL7F8Cwc7Kk5QAiX0PZgsmNlVY2CgjytMrDaNlLhp9diW2ICaj52df0AFWgO4EddefbYBfprEggnixUixnP02OKWZcPyMPDDyxmXRY6QgC3pt9NoKAwnDBzH7JWyTMgn+OvpJ9oWwyezFWUpluzAWjyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fuqZUAF4b/jWbpHfrTquPu+8dqI7jEL2JIRV5AqGtL4=;
 b=c3eXCZbdPDYhfV8ytclew9l4opQMORyVPLcnwkdodPFRero1t7v3u54cDZPimIt7X0yzoyWbXEOTPvVJntdeaSJuwST0MyvO9STYwxB2Ld0fhSDxhOTQtu1WTWE22eF5qhzS52+2bRJdlP/Fp4Sa07rqmUcXbqwqB2x2pBu71q3Cp7qxI+49tRIu6IR1SqZHPvA3+R1VmaY59B04tZX0jAgWT63vNtsIrruLkPk6Ep6UxWNXGAp67Dup/t/7ifU/+cSVP9bgk+qMPq4w/qPPSiGnEv3r3uhrytzIOkx7AFvy24I24Vz47rPPdZtsLnhGM3/pmuzg2sINzAhm6MJx9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by DS0PR11MB6544.namprd11.prod.outlook.com (2603:10b6:8:d0::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.37; Thu, 15 Jun 2023 17:34:37 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::ef38:9181:fb78:b528]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::ef38:9181:fb78:b528%7]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 17:34:37 +0000
Message-ID: <d3d55ee0-53b3-3084-cf22-b64a59da65b3@intel.com>
Date: Thu, 15 Jun 2023 10:34:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Betterbird/102.11.1
Subject: Re: [PATCH 2/4] dax: Use device_unregister() in
 unregister_dax_mapping()
To: Dan Williams <dan.j.williams@intel.com>, <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>
References: <168577282846.1672036.13848242151310480001.stgit@dwillia2-xfh.jf.intel.com>
 <168577283989.1672036.7777592498865470652.stgit@dwillia2-xfh.jf.intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <168577283989.1672036.7777592498865470652.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0051.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::26) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|DS0PR11MB6544:EE_
X-MS-Office365-Filtering-Correlation-Id: f793b945-3f83-45eb-291a-08db6dc6ca56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HzZ/pnMCm5zrjEVksYCLwXI6LHLJqrSEhOM34a8sMx0do/iK7yEHamFdKyfiEqj/8gqTteUcRlgeCdLpnwJeX7C+B7CuiiCyHjUT6XMbkUg3WZTl7upbtS1Ry/h1YjxQTLijcrf8GIXIlf8BgNvDmjF4DarSfERuGuekP0Lj0lhOl6MHkCkpHM8oqPZr3ZW9J8WVK9dM5WZ7ALKtPGrZSvC4oNC6cksInSUXIWNdr/fYVHMikSJC7Ku5S4SirCUWuGl8vZJHonrz/1J2HhHSAbL6ajSriBm+aDgr3KsFleDOlSJjHoKQmcpY/O01T42KjRnbE04O2ENcn9jUxmMvYa1iKprt6lR9h2qnkBXPXPUk7ThjV97FRZ25SRW3TmfbBGutClBknN+J/qde25kR95P7IU7FbeX5GpUusuAE3Ldcx1eU8x7iYVhDG2+ZeRqf+T/Ql6j8x4NcfprabTa3biwGmAd33BD8ESZ0LrkVMDrU48lv+XH163AtARK+6Fd3cq7hKLZCrJS8a//gUjboYIHq/ZijSxU07o3IXaxThK2iu9szEyhW5Ned2UtOTE3C6uC31mocnhMgmLxtmjnZ5xBCesPs9jpEGgruJTSkbo0jWLuAGiYkIjpST1IU0f6K6FFhtwt0sr5sU537ta+Mdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(396003)(366004)(136003)(346002)(451199021)(53546011)(26005)(6512007)(6506007)(36756003)(186003)(478600001)(6666004)(6486002)(2906002)(4744005)(8936002)(83380400001)(316002)(41300700001)(44832011)(31696002)(86362001)(31686004)(38100700002)(5660300002)(82960400001)(8676002)(2616005)(66946007)(66476007)(66556008)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NmRwY3BONUpMeDRLN3FkVDBkRjVNbnB1ZmVkN2tHb2tlbHR2Y0ZLOE03M294?=
 =?utf-8?B?SDJsdW5IYzJUbUJudmNmRk45Q2tKUzRSSkhOQXlacy91RHVZa3F5a21PNGJj?=
 =?utf-8?B?bFF2UGUwT1dqa1lzL2haN25hSjFzWndhOVNzQnRIcExXdnhSVUxJK3JYcGlS?=
 =?utf-8?B?UGc4d2NVV0RqakE5Z3ZuL3hJVDRtL1RBbzRBQWpNc2xORmdOZTdWM2JEaC9P?=
 =?utf-8?B?REY3TGhYbUVRWWYxaXcrWndaWXpxQ1poenFIZ3JYQXR5TnV3VlBRbXZtb0pv?=
 =?utf-8?B?cG15SFpRdGJEOTQ1TmpOUkk3cnR5RTRTblZaWlFVRmxXT05NeXcrazJaZTlS?=
 =?utf-8?B?UEh3bGRuYkRuK0YrMDFsd2ovL0ROTHFjSzAyRXBCRldwK0R4eUJLMlQvQjhn?=
 =?utf-8?B?bEdFNU5URkxJRjlnOGJXam9IMDlZZi92Ull4MVFCT25DeGRFRFdlTEdTc2NP?=
 =?utf-8?B?SG9LSm16TXNqYW45S0plcnlpd252SG44Ynh6aFJMRVZEMlBLdjEyclA5dlI5?=
 =?utf-8?B?dkdiT3lyVUlWSE9LVXVzbDRpNFpYTFRzTFZTZjRnMk5Zem9CSktvVGJQZzFR?=
 =?utf-8?B?WGFHeGxBOUZXTzk0R3NqT1hJUG51RE1rekJ1amxobitaVFh5VmZQNGdSQ2xU?=
 =?utf-8?B?SzBXZlZhVkJnM202cXB5NHJ0SnM2UDhnYVVJSXkvVTlLYUt5c3JmdFZ5dUFt?=
 =?utf-8?B?NnpTdFA4V24yYUFOcng0ZHQwYmNsdXJJWmhJOVgyT0JXME5KbGNQMXdmdDY5?=
 =?utf-8?B?Ylc1RmUwbFVmRC8rK24yRmEwc3pvQlBJZW5NU2pvN05FMVltR0ZSUVJOTjYz?=
 =?utf-8?B?SVV5d2JDVzZJelNKRDNlbjJYOVh1dkpZZHA0NzIxbjBFNkg2a3JZN213YVJS?=
 =?utf-8?B?UTRjMWR2MzRreFRqbENMeUFTNnJNNk5ZY1EreVNGblVMVHlxVytTdnBlSTQv?=
 =?utf-8?B?N1NZSWdqZEVDZHdjbEk4VWlUbys5TzhOc2VKdzNoanpOczRjeXgxNDQ0QWtD?=
 =?utf-8?B?eWRvd1RvTVg1WnBpWnZRK1kvK2hpTnBZT25jeHJobHhURkMvd1hPTGFIUUhn?=
 =?utf-8?B?OUdpTURoT3ltNGs4dUJkelplOVdBdUZHQW1rVFFEejZTQ2VIdWZkU3VXZnB2?=
 =?utf-8?B?amVXRlBhQTh1NjRITHdROGMyYzRJMW45eWpNTFgxZXNZZi9PZk12bGtjdkhZ?=
 =?utf-8?B?bVQvZUFpcm1jcDhnMS9pbUZFbTB1MkxmRzNqOTRBc1pHUmxVNU9wZThBcm5s?=
 =?utf-8?B?YnFvY1lvSWV1VE5XUjRza1RGcWhMenBHa0dLWjFJVFpXVzBESlhrb2hQem8r?=
 =?utf-8?B?WEFUQWRsaXdUa3cwTGhFbW5iT3dON2xRcmcrZmtWSjRLbDlwMWVnTXRCU3hp?=
 =?utf-8?B?T3lFRUo2bWJ3ai9PRkRleDQxaVZ5Uk5vY2J1Rm1OanlqeU4yR0dQTmpyS0NN?=
 =?utf-8?B?bThFQkJES1kvVnRNNnZxc2lMS2tMekNYYXhmcEZnaEpuWnBYQjRsaGExSk9W?=
 =?utf-8?B?RUs0aFVyZURMZ1YxUHRIKzRNN0JkQlZaeGdyK1VYNzJEcURWMjE5elZWR2xE?=
 =?utf-8?B?N290Z1p1ZmlDc0R5ZkVwZkFDWE02MlBlWFZCbzBaYjhLeEhzdWFBRnJ3ekpS?=
 =?utf-8?B?dklyVHZvV05peUJWZlNmNkJrUnJSUnBrSlpXdWU3aitnc0hvbk5vK1lrS0t2?=
 =?utf-8?B?Ni9meEszRkRaWUp6eUJCWVBqMUJ5UVpGM2txRDJRSi83b2hOcFlNQkZ6T2I4?=
 =?utf-8?B?TEkrOXlyQzFPdnMveXJaMkdBTk1NYllFVGlqRmtVQWJZNG0zdVpWSlBhK2pL?=
 =?utf-8?B?VWpCdDlFa2J2alNvVnF2Ri9yVGJobkRCb0FWSm42alZ6SGhKRmVVSTVVMFBI?=
 =?utf-8?B?YjZCQ2F1a2lqR0JvMThYZFJ2YVlQT3RHM3NtZ09URzVGandsa3FVSnRpblNs?=
 =?utf-8?B?VGk1V0MxQ3FQQk5lTlVnc1o0ZEJQRklZNk0rNDlwMEdEWTkydXFwanIva1dS?=
 =?utf-8?B?WWx6WXhIdW9Wa3E3SGRkaURrQnI0T00yVk81YjRNMnY2RmZNZTdSZkhwQTJR?=
 =?utf-8?B?QWRLejNkSzNRZWZlYSt5RmYxUUVYZUllcUpRZndPNTlDZWtMRzgvbGlHNDhC?=
 =?utf-8?Q?xxTT0j0A2P81RzxV9sXGeSaCQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f793b945-3f83-45eb-291a-08db6dc6ca56
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 17:34:37.0948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ayMbDVh4vsrA+KHdFnfIY/pA8155Fg+YN6rcMLi0dQqTzpBxmQJTOJ8RnG7p6XapSdo3HXHGR9MK09tBqphpnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6544
X-OriginatorOrg: intel.com



On 6/2/23 23:13, Dan Williams wrote:
> Replace an open-coded device_unregister() sequence with the helper.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>   drivers/dax/bus.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index aee695f86b44..c99ea08aafc3 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -657,8 +657,7 @@ static void unregister_dax_mapping(void *data)
>   	dev_dax->ranges[mapping->range_id].mapping = NULL;
>   	mapping->range_id = -1;
>   
> -	device_del(dev);
> -	put_device(dev);
> +	device_unregister(dev);
>   }
>   
>   static struct dev_dax_range *get_dax_range(struct device *dev)
> 
> 
