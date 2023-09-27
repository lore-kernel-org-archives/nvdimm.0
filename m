Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA5633E5
	for <nvdimm@lists.linux.dev>; Wed, 27 Sep 2023 14:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695825603; x=1727361603;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YCGUNtd+sUhot8c4gRAzsoUfuK6mHaupgSNMN0SnujE=;
  b=FpkSteH2K3gLWHbbq9IuORRE2xMRingJ9tZ4xFjaDiEAAfCiLJ9dJAFL
   c30aTUnICeaSK2j+OqJrswK7Xit2DLNAIDpzTPJvKHvKhjHcHK3bZVlzU
   gwyTFvNzDRgxlH99ZxuGU59zNNMMx/yP7XO7sX22Pqal3ii8ZZW9f/Sz4
   TCkNOefOT83+7e1Nuhs1U5/bwDCWMboNWiJ26GC+ER9hhmXcOmMYQO+Zm
   vMqOkZZCvXchEQNWXoute4GD8rAphl3/on4DGKe96QtNLFgdi1+LLHR3C
   WA4Co1XBldiWX8aSsDvXyBmoB9FoVN7jOvjYJuOnv6rQ+RxrUL3wdyT/Y
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="412750050"
X-IronPort-AV: E=Sophos;i="6.03,181,1694761200"; 
   d="scan'208";a="412750050"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2023 07:40:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="725830322"
X-IronPort-AV: E=Sophos;i="6.03,181,1694761200"; 
   d="scan'208";a="725830322"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Sep 2023 07:39:59 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 27 Sep 2023 07:39:58 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 27 Sep 2023 07:39:57 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Wed, 27 Sep 2023 07:39:57 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 27 Sep 2023 07:39:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LPP/t+8G22rz8eRfsnfHzjLp7qvdgp06Ay97IUKL84IGJjINS+kydw7CWnMGDoDDuCL+UbbGez4InjQUsd8XhctGZKY9KbH5mOzXhYPyKd4GYezo/FuYFeeFyT+x04qaiHEkiuWqUCFqSqVySLa2lW71xW/p/qB7XWgG8YB76HObIz48FsgMoiYqKdJL+KjjjmgYSwRkQU0Soxsm4r1Z0xBzUPnTd5Y3dcI2oWk219MjJokKoyeG66mEHQrLmDGjsGOdF6AwYfa/ygq5TfafOzk3eAVMeBcobxha7H3/r5urpFOGqmW8ufofyoPqgPlkneRfcQrp84qd27gUPY5VSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=quwc3OeF0z7fsS4SvJMuXMnbiJF8PeYNcdXCzKsFgGc=;
 b=eyBFU84gQhNp2l2KmSYzeUgzFnUII4gUtQWaC35NeVPrvKXwVkh0gOX+lq96Byi+RGOIwAnYtLdAbb6p32RBGbqN6dua+coVVWVI9dHacwCVjrS6iMqcNxB+wdwM3+iYu1SS+/RR2PW5/hb6sxNUrUiOgFJ/U/AiSC8/1vFg0WXZO3O9LJBP4ZavTr4YII1fgg0ZTPHltw9JFv3ueaxgHywC+5n7sNO3RMJR9lhjRX5fzyWcQu2goyWitvvYqOC0DOCD78YfryNAM0kEQfps+2nrCdfiHRBsesFMDZydruF0XBWPxsxyg2nYyJIBvnRo1YX0pKE47k9yeB/crlHXGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by BN0PR11MB5696.namprd11.prod.outlook.com (2603:10b6:408:14b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.22; Wed, 27 Sep
 2023 14:39:55 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::e9ca:a5a7:ada1:6ee8]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::e9ca:a5a7:ada1:6ee8%5]) with mapi id 15.20.6813.017; Wed, 27 Sep 2023
 14:39:55 +0000
Message-ID: <b0714f5a-2969-38dc-42c8-f151c1111d5b@intel.com>
Date: Wed, 27 Sep 2023 07:39:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Betterbird/102.13.0
Subject: Re: [PATCH ndctl] ndctl/cxl/region: Report max size for region
 creation
To: Ira Weiny <ira.weiny@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
References: <20230926-max-size-create-region-v1-1-d3555e91087c@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230926-max-size-create-region-v1-1-d3555e91087c@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0387.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::32) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|BN0PR11MB5696:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f9ab72f-99dd-43f7-cc9d-08dbbf679dca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Dkrx2p2SeHoXEkyAwWILGmv7HIrmOVf2yWaE4MxXOz+X4/2C0gM5lyaFXzGdrec4BH3nbT2aI+3J2gBHFt3Ch+Wu+5xwk/lsw7y7DRpUsrCyZRGbUa/vkEekxWzk9zX46Vbz2pQsv6sQmj/KdC5/kdza14UZseiqitvlJrqSYpHA+mk34aaohC3oAiALkFOO72eu1bJeKOh4DRLJFBJUZB60IBLmSxcRxuGHL0plSQqzgDRvNGMnU//j4CcncGY4t1YqUC5CODa45z9tihovSsSQqv1yiEj+a/KuIDPFFUtP693L9vyhSxfvMoVa61KXL6tR7WrFqfDXXkH/k6zB9qSj2hl50ufQ/He5z9f89k+34gUcvmlULUB6oulyr92MQLLwiupCNKCxj4R2FqNyWaAJrSa6LKAPV+a6CiTDpnsjAV7hhDA0mnBn3huc64X0HlB9jJkhMWIF2wGACi8LwaNrAG1dgKtYlsfYojWsIiURAqo+4GVcQ/NWzzXa8QWGc6x+RfhxmrrwgViqoDnPn1VEzWGPwujKLyvKpIEKjUTVDBXMQkuSMBmxK3pT4xZXFbTV38+L1O/1RJeJ6KsaDI+WDZanoEEBHPwUdVm9cS6wCPR9eVXl+MQidWGexPhlHbov9HF4J/Q+ijOnbZmqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(39860400002)(136003)(366004)(230922051799003)(451199024)(1800799009)(186009)(41300700001)(44832011)(31686004)(5660300002)(66556008)(66476007)(66946007)(82960400001)(8676002)(4326008)(8936002)(110136005)(6636002)(316002)(83380400001)(38100700002)(2906002)(478600001)(6486002)(26005)(6512007)(53546011)(2616005)(31696002)(6506007)(36756003)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1Nha2phVGRMdHhMMUhLdXNsTW9FVUZ4NzhxSENUR00weWl2eUZjbEtiM21G?=
 =?utf-8?B?NXlLY2hYWXZDUG1DOTZNMTFDQ1ZRd2RRaGt5b1NxUjc0TUNMODIreHhaZndH?=
 =?utf-8?B?ZVNLNVZ4Sm14enplTUtOVzRWM2FaQUJ5UFhhUTlwWlRKVnRwbDdya2Jxbjhr?=
 =?utf-8?B?RUlxSGFTb3RhZ3N3RjJPY21kUG1tNEdiUlB0VGVGM3dmc0hjMHAzM0o1ZG9W?=
 =?utf-8?B?Z0gySC9pdFV2WkhMN0JJVFBVQnZ3TUNlbng0OCtlMC9DcnN4WVA4amsrYjZt?=
 =?utf-8?B?K0NGdTJjZHpLUnViYXBSdmZQSkhoelVPSW9sK2RBcWZ5ZEx5Y0x5UEdmU1VG?=
 =?utf-8?B?UGNiMFMzWGlzWXp3WWVaNXVva1NLa2ZjMkpNZmhBRlhzY3k0amlGWFhJOUxE?=
 =?utf-8?B?c00vZEVKdWptcEd3OXA0M3dERWlNVld4a0VJT0RJTEg1ZWdEa1JMNmt6dVli?=
 =?utf-8?B?eXQwc21IZTdNS296dDBUYmVOZlExdm9tTnkvTTRDSHZ6bVV2VVRnSUsvT1Z1?=
 =?utf-8?B?ekZYN0h6c1FMQVFycGR6SlBrVFJXOGdqalpTOEFNYVFrREloNm9qUHZNVFlk?=
 =?utf-8?B?OERQbWxGenRqUkkyb0NpWHpyd2UzR2VVdXJTdTVoTW9sVnBHUmNWc3hKYXB6?=
 =?utf-8?B?dGxZMFUvVGhIWGRQUmo5THhmL2FrZWF3d1lHMjIvcHZmV3l5Z1pheHp5WVdI?=
 =?utf-8?B?elFENXpWOURqZTlZWng5YUJiWS9qWnA0SnFudjgzVHdjcmowQ2xrbnVSTE5Q?=
 =?utf-8?B?S1BuaVVpRlNqaFpROGN1Y0UrdldLY3Q5OG5xT0RBaE1ib3d4YTZXQmNRZVlz?=
 =?utf-8?B?ckRKSVIzci9TSSsrZSt3R0t1OTE2bkZSTkRieFZseGoxMnRmZE1rNmJUWU9T?=
 =?utf-8?B?dnlFMU5jNjhmQW5FdTg2SUl3SnpmNm9LZm4zV3I4NHVqbTh5NVV3U2grUUhV?=
 =?utf-8?B?Sy9GOGx2YXhsVytURExoVE03eXZMb2JORnR4YW1vRXEyZytkeFFzUGgwdmNt?=
 =?utf-8?B?Um5DUS9WVm5rWDd0TFl0QUhBeE5NYTBVd0ZiTURSUCtwdWxUNVdUQW14ajJ3?=
 =?utf-8?B?R1M1cWlCeXhRZjdQZkZoNmJsbEZxVWJuOW9JeUlTaGdtU3QyQnIrc1lncFBI?=
 =?utf-8?B?Wm10TGtRTnlGMmhwMElCaitCSWlJVzlsaytDNEt1RlFHOEtjR1BDYXY0d0RY?=
 =?utf-8?B?VWtacnZXVTZ0U1JPNGszOHBkVkkxdTJBeUFJTUJ4ZmZwWFlacFpadW5rMXla?=
 =?utf-8?B?a053bGNoZy9PQVhRWTFZU0hqZ05sMXhYMHVlZGVmT0g0RGd4UkdCZXVZQW4w?=
 =?utf-8?B?YjdINTB3SVJ1aVRRbWRkQjRRc3JReC9BcGRSMld6aGx3SkhYRHZWK3RDSXE2?=
 =?utf-8?B?SXdGUk9zbUs0Z21lSkk3WFNFSTNjeXgvaXNBRExYVHVwaElqWTE3WUdzODNP?=
 =?utf-8?B?VmdtVllPQS8raXlDY2tIMlZCdmxqMHZiaGN1YWp2cGRKbTJOSUtUZWZOTTNa?=
 =?utf-8?B?Zk45YXhxem4zazBIWXhMVEl3WHFtZ3l4ZGNMSVhkTzBQWGozbWVucWhuZEZS?=
 =?utf-8?B?NWlsaE96RmVpdS9hbXhaV0EzV2Z6WmM3WHZ2eGlTN1l1QzVoMFowTkYyQnJu?=
 =?utf-8?B?T3piRm16S2orM0xoUk5yeE4vcDJFQWtLL0c1NWR5SFp0N3QwaUFhQVFQeXA3?=
 =?utf-8?B?YlVYRVRocTF5VWNVNmJNcnJGYmlDdkdrZjdkZzMxaTc5c1Ywd3U3ZXZxL3FK?=
 =?utf-8?B?bCtZZDdsL0pIREszQngySkhGUjJDampjSE8rTWlmQ0djZXRYSHdjYTVGOWY1?=
 =?utf-8?B?ZzlPangrMWhNZjlncWdYODJneTdGTDh6KzA4eTRrcWF2T1F1TWpZQVBqNmtj?=
 =?utf-8?B?aFpRY3M0TFhjaUNzcWtJS3dSUXBkQ255ZjNHZGNIQ1Y5WitCNzdHUmtSK1VE?=
 =?utf-8?B?WHlCV1M0MEpUTUlOckZ5RnU4b3lyRTB5d2JRZFFBQjNVTExWREE4a1RZMXB2?=
 =?utf-8?B?c0tRektoL2IvNEJFV0YwV3NQeE10ZzhQc2dyTkRCOXlleGs5T0NySnZtd2tP?=
 =?utf-8?B?dTFWcVU1M29ZcTZiZTdCV2tuQXpjM2VXMWhwV3RTNmZnc3hIL1YxVUtmdmZi?=
 =?utf-8?Q?0LzzRsGLusPMoGwysbb3W4gAU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f9ab72f-99dd-43f7-cc9d-08dbbf679dca
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2023 14:39:55.4541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3UvqJ89Ipt2MfT578k1EnVuSCqUv+I7KaSx1ehJShhiAYIf57TSuuSadCgDJYz8Hfn2E8U5DANVyRpvPpSaDaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5696
X-OriginatorOrg: intel.com



On 9/26/23 17:24, Ira Weiny wrote:
> When creating a region if the size exceeds the max an error is printed.
> However, the max available space is not reported which makes it harder
> to determine what is wrong.
> 
> Add the max size available to the output error.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  cxl/region.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/cxl/region.c b/cxl/region.c
> index bcd703956207..cb6a547990fb 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -623,8 +623,8 @@ static int create_region(struct cxl_ctx *ctx, int *count,
>  	}
>  	if (!default_size && size > max_extent) {
>  		log_err(&rl,
> -			"%s: region size %#lx exceeds max available space\n",
> -			cxl_decoder_get_devname(p->root_decoder), size);
> +			"%s: region size %#lx exceeds max available space (%#lx)\n",
> +			cxl_decoder_get_devname(p->root_decoder), size, max_extent);
>  		return -ENOSPC;
>  	}
>  
> 
> ---
> base-commit: a871e6153b11fe63780b37cdcb1eb347b296095c
> change-id: 20230926-max-size-create-region-1f57ff3bc53c
> 
> Best regards,
