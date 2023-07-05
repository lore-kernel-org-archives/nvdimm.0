Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B0114A8D
	for <nvdimm@lists.linux.dev>; Wed,  5 Jul 2023 18:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688581237; x=1720117237;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FQRJHRDp6SHINzzqDYAyJA6MbtzmyR6EAXy01blKnDU=;
  b=oJATW68ao7KRkGIZHb5SgY1mKSV5oEs+zmKPRyGEvQHVUh8kyupwQnak
   A+amgTTAKrVjqdP+IIYTCbr964WSktBbgIA2nXkpyZ6nN9kN5tRim9xvt
   2cih6t3FlMGiGa5/aDIqXRUwWJa3Nty88QusNsnCpQNIFK+BaqF/mahfW
   6ETGg5b3Rrdgmo81SaRam0DxamDy7cLgAMzYpMZQ/dljO0ONkNz7ap5ej
   fS3v1IHAke0qDeeFeckiBMy37nHEe30t87jOHH1GV+KD3nX8A/evdr9TV
   +xkgLMdwQK/63Geeg5PxLwEIkr0ONmalvK/ycSUJpMi1y5fLhIXYPRZA3
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="449776706"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; 
   d="scan'208";a="449776706"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 11:20:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="893279052"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; 
   d="scan'208";a="893279052"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 05 Jul 2023 11:20:35 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 5 Jul 2023 11:20:34 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 5 Jul 2023 11:20:34 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 5 Jul 2023 11:20:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=medZkbOcEyFaLdQhaqk/2H4pTCdWeh6IIqGkhYyyqvtPJx2xVn+QdrvsFnoYzawt/A7cltOIY+zE3VidM4BRUx4QuQJ9R93pJpae5BC2lZWWSalGLlMX+TNmUeZx92f6YvHrwLXzIuncW3nNtBRR5XBcCXybeGsU29I6jeyo2CseP12Y6SESHdeukCXJEAc7zyrz8AZAuUjY0XiwiFa10uqvmE5YNrkWHyYcDm0Q3RZ1kDJb4FE7h8YB5iFYqm46W3oU2VjEd6S9CATaXSP1CNT41i1OLayHeFJPtYRZDM3AH+oAOfJZo8fJbbC2DTDnnSF2QPR8Q4MM/iZi/LpBpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ZapvKESCujzUeAhsnquEHJaUpP351huk+m6ZIpXUaY=;
 b=aNE1PSOq/xcm0tyzNHLgJMItlpa43MYgVDMcxdP9FWfk6r/hwbqibWh+Dgx1T7Fg8rC3JdK1Ldsc6RlV1kbTQR+yBLCCqWk5gcApGA7KoufCDcwb4e8rOhvms3q2QrMV+kuJlGcsPhdvYr1O/TpQBsxxa9zU++cd6leGsGAQAd+7KWWgh1iHzulrZGmMNKLzoz6R+Z26AMqMageSdMqLa9iCTkYh3vCKD4EDk6xVzp+EmeopXilHjSA1c6GHCjhTRX3VFZ+Fi64lF5aPFRpX0HURiiCeRuOIgzEskNRVa5/R0L5DVt+KhpzIH7zA8t9OVdsQ6rOsPHrv1qfez6bIJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by BY1PR11MB8053.namprd11.prod.outlook.com (2603:10b6:a03:525::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Wed, 5 Jul
 2023 18:20:32 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::ef38:9181:fb78:b528]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::ef38:9181:fb78:b528%7]) with mapi id 15.20.6544.024; Wed, 5 Jul 2023
 18:20:32 +0000
Message-ID: <f00df1a2-77d2-cea5-7ec4-b34c175eac34@intel.com>
Date: Wed, 5 Jul 2023 11:20:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Betterbird/102.12.0
Subject: Re: [ndctl PATCH v3 3/6] cxl/monitor: use strcmp to compare the
 reserved word
To: Li Zhijian <lizhijian@fujitsu.com>, <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>
References: <20230531021936.7366-1-lizhijian@fujitsu.com>
 <20230531021936.7366-4-lizhijian@fujitsu.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230531021936.7366-4-lizhijian@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0126.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::11) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|BY1PR11MB8053:EE_
X-MS-Office365-Filtering-Correlation-Id: 48e265ea-e258-4e82-54a7-08db7d84793e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JzM3wo037sND2h9b1xADIVpkQYGFHQd+lvvbx4Nzhhm1ty/0PcHGQoHWOhcmK5FMequp7yYgRJeZ58OCIWATJTIlRPd7uE7LrcKEDuz5v8GT1KsY0lRtJkmhTP/vvncNMdGMaIOcwkTttJnDuREx1mxOrNxPjOedeiLnh0HpFh+HjckdaEuDcHUuu26zwGAzb1IghRGCL0yzvKvBY2uUWWXbqbMHm5+gFF/c3JBMOaKtfMzKs8yzitBznbXgHaQAhNzvGc6VgfQIUBwD00/FWnCAZHVqgXw5cBIYku8oUUzN5GA1QevsdlxgQRR2YeLgpgaaWXOpvHfkIvco6hJFKEDcloJrftQ9ZREN3UmzvOPC8eUV4LF/YrkJm/HTeW2rGTCtIQ/4Ed3e+5ATKHy85ZjCoIQu81Iu/peHUkSnf41+9vO7dWi5hcz2TPNJFZGz9dH6fApVRZCBZ6F3RCl/7FO9XmGbqM93siL13mEaVlbvhNAa6vG3J1C/axZnzOrh7rHvt9mkzE3EUQUBk6gdf9NMEo1++syQYWwyf0/PjO4pPgeraVpik6eLp+uMAZsWY2IN/oCt3xhxXE+aYBidiQ3olPmKMoi/u6tDaDs5iAKETD/nQegzZGaJUSyMCYmpCjpH628qvSxyXaLcbrwSKcuOtVnePgHARY4YVZRpYW0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(346002)(39860400002)(136003)(451199021)(66476007)(316002)(66946007)(66556008)(107886003)(38100700002)(82960400001)(4326008)(186003)(26005)(6506007)(6512007)(53546011)(6486002)(478600001)(6666004)(31696002)(31686004)(2616005)(83380400001)(8936002)(2906002)(5660300002)(44832011)(86362001)(36756003)(8676002)(41300700001)(40753002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bTlhc3lSbGpMNXAxc0hKMHNjTmNVUlhlNU4xZ2t3MW02Zk52cXptY1QvVnEz?=
 =?utf-8?B?WjYyakFsTENUcEJhd2l6bFRwc3VoRlRaVlhCLytmN2tpdCtSN0tybW5JZStH?=
 =?utf-8?B?cXRUSlI4V3lRdEUzUGZvdkozY0dtQzNadUJBNFRBWkIzZXNuMFdlbmtvYUZ1?=
 =?utf-8?B?bStFYVBhNHJqd1UzcTM0VHJQTXphQnVpOHhXd3RwSmNoSktiTjh4NHg3YmtG?=
 =?utf-8?B?THA2TTlnV1NvbFkvNjNrODBuWGNsT2NSK0F6RDBCSDZyblZiMVI5TVpNdXJB?=
 =?utf-8?B?QzZmdmwxN3NnYlBZV21ibHpwaEg5aGY3REhIV1dhdzJlSExtcGN2V1BPcnpw?=
 =?utf-8?B?MEVDQWFyd2pCN2JaL2Nnb3pNckJXRHlmV1g4REZ3YU56ZWJ0K2VNRWpPWStH?=
 =?utf-8?B?djlzNlBXV2JTendxdW1jZ2t4ejFJRG4zMFpkdEk5TTlHaHdONEFoblJBeU92?=
 =?utf-8?B?c3J5c0FSYmgxSDNPQlZTeStRcExrbjErYUk4YkZpM0l2aG1oazQzL2xVcXp0?=
 =?utf-8?B?c1pMeG5QSU1FaE5lSk92US9WK3V2azVXUG53OXhOZlc3RGpON01XdVQ0VmRz?=
 =?utf-8?B?K2JCR1d0WWpzNWVxYUlWd1lGT1BuM0NlTzJuTGx2R2pyNlhkdGJ2dlhOem9q?=
 =?utf-8?B?RlVTMVhhTHlNaW1sU0hBQlRWOVJYbEQzREVDWE4yNXdQTlZGRTFFNktCZmNQ?=
 =?utf-8?B?NThCSXAzU1VuQTRQZ2RNTVc0M1hDWWxQNUcyTk1zT3FINnh6LzVtcFVqKy9t?=
 =?utf-8?B?UWQvS21oaW1Pc1dQRm1wd1hNWGczSHVzaHdRZTFOV2twdnI4bGJTVHZXSGpT?=
 =?utf-8?B?WXVIdW9GVnpLTWpCaGluRDZ0QVlMVUR6NWl0MnFHZDNnazMyaG5ZVStHQVJS?=
 =?utf-8?B?RGtsQ3M1OWxBQ2t3Szc4RkFoK1BXZk1tcExrWGw3YWFERkluZ01YTjY3eW01?=
 =?utf-8?B?K0pyWHJyZ0I4VElnMUU2OU13cC8xenAxMlUwdkY0TDhOSFp4dkxJcSt5c0xV?=
 =?utf-8?B?MERHek5xQ1ZPZmg5dFZ4RElxbnR1RDNjbkNhYUI2WEJ6dVVSbjNGMGlHL3VB?=
 =?utf-8?B?b3JMSVBOUWVlakJxbVFNSnVYYTBMQU95b1lnbjJqKzQ3TkhGS0FXbUt5RFBU?=
 =?utf-8?B?N0RRb0F6UXdvQ2V2bEd2dHNkK2w0b1BkTVU5UVlVbUVoOVVvM2lRdWVaME8w?=
 =?utf-8?B?T0x5aTJmbVNiK0pySzVuQ3BIT2FURUpCZWxTZ0J1djA0TUVuQXdjd2pDdlRB?=
 =?utf-8?B?SFRBVWlIUC9tKzhrSlhJTDE3Tkowb2g4K3FTWXJRWE92WVBVR3NEOGZqTkZM?=
 =?utf-8?B?SGFzRXhRaWZZVUNhRkl3ZUpkYkVYbjRBYUR5U0FZd3BERDB3VE4wMnc3T0Nz?=
 =?utf-8?B?aXErYjRhcnpweExsMXNwQXBhbTBCTDN1QVlQS004QUxwUlc0SFhDNm1hQjgw?=
 =?utf-8?B?ZmpZZENmUElrbFhqSEJsTHFVVDZjNTZRLzA3MG1URHVpZ3hIQlBhME5pcFhR?=
 =?utf-8?B?MC9PUVJNTHJQeWZLcHZHdENwQitSZTltTjFaWEFCYktSQWRaN1dhUVdtWWJt?=
 =?utf-8?B?VnJZemZkK3hVTnZsRWQxWUxXVW00VzBVNVFlNVFZYW5mTnA0bmdHUjNIOGpJ?=
 =?utf-8?B?eVJFZjZSTjBGZzRhTWNwNzdRbnpLckpPVnZYcmhON2dxTm1ucTZPS29lY0dG?=
 =?utf-8?B?V1ZIYXlxWVZwMDdiWnFlUmpQOHhTZXdtQS9ZdXVSY3V0R1h0RGdPK2hKUC9Y?=
 =?utf-8?B?ejFnQW02S3VjRkRiaHJBb2xzS3JPbnpXdmxPdndCUGNENUFPM2Y4cEZaeTFO?=
 =?utf-8?B?aFREdGVUK1VUK01qVEk5Y25UQ2kxZGNZR2lTQkFHbXpRZ2N1em5lbVpteGE1?=
 =?utf-8?B?T2pRNmtSRFMxZUJ4NjdWVExQQjVvK2x0TmthZkliRVZTVFJtSFVrQ24wYmVy?=
 =?utf-8?B?ZE4wVjcrWjgxQnVxVmhKakZpRDNMWHI3RzlFL09qM3lGTWtUOUZ4Y05XWHhl?=
 =?utf-8?B?djA3WDBGK1plM0dPY2JnNGRpVlVCQVkrQjZHd2VDRS9FbFE3OUprMFVEcytV?=
 =?utf-8?B?dm4wYWN6OHFtcmVJeWtxQWx3MmM3dGUya0UwVkdqaExqdUpqRTlCZlNPeHJq?=
 =?utf-8?B?K284a3R6TGdUNnRjSzREZFEzTmdpTWVlQlV2bTVBemhxdzNPMzZmUGZlMXBD?=
 =?utf-8?B?cVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 48e265ea-e258-4e82-54a7-08db7d84793e
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2023 18:20:32.2477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BJJlCo/CF4ywzLM7r9iuz2cSRvuSIrjT+8F6mUDwabORvQT618XcJ+JXeiK4DFPdyRCIvb9E2Z2GDwXz09bxkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8053
X-OriginatorOrg: intel.com



On 5/30/23 19:19, Li Zhijian wrote:
> According to the tool's documentation, when '-l standard' is specified,
> log would be output to the stdout. But since it's using strncmp(a, b, 10)
> to compare the former 10 characters, it will also wrongly detect a filename
> starting with a substring 'standard' as stdout.
> 
> For example:
> $ cxl monitor -l standard.log
> 
> User is most likely want to save log to ./standard.log instead of stdout.
> 
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
> V3: Improve commit log # Dave
> V2: commit log updated # Dave
> ---
>   cxl/monitor.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/cxl/monitor.c b/cxl/monitor.c
> index f0e3c4c3f45c..179646562187 100644
> --- a/cxl/monitor.c
> +++ b/cxl/monitor.c
> @@ -188,7 +188,7 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
>   	else
>   		monitor.ctx.log_priority = LOG_INFO;
>   
> -	if (strncmp(log, "./standard", 10) == 0)
> +	if (strcmp(log, "./standard") == 0)
>   		monitor.ctx.log_fn = log_standard;
>   	else {
>   		monitor.ctx.log_file = fopen(log, "a+");
