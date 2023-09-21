Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B58168A3
	for <nvdimm@lists.linux.dev>; Thu, 21 Sep 2023 23:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695338394; x=1726874394;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=co4pvvSY158lBU1g788+2T1G1BNHbDG3fGe8YIx25x8=;
  b=ErpbWER7VpJhx/4kg0ptNeaLW71znIYPpH6UjalY8JJ+JFjCmJgE9vR3
   XGj0pl0uZUcatjLo0OV3tiAyV/WExWc0IsKcyRnXL54ZiUT00P2WdmUdK
   uECLbxbNprc3p/c6RxlMIELvgMJzXrGAShGb6RXW7oDRG7MrB7wZX67jN
   h9GRpVDK4hJuVBJtOTf9AZUjN4qITAs7o6lj1WguJf0jBcXLgHKPUynBF
   r7XRbdkUDmMkWYMFQ+kqa6jdZ0ShOxKadMs5ssHxRYefjsIYiwd2qBwM8
   a67BxB5R13oYoUkb822jDjjbNJNFjKwNWpJ/h0VM4ia62Xd8j04LOzS9l
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="371012150"
X-IronPort-AV: E=Sophos;i="6.03,166,1694761200"; 
   d="scan'208";a="371012150"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 16:19:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="696936616"
X-IronPort-AV: E=Sophos;i="6.03,166,1694761200"; 
   d="scan'208";a="696936616"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Sep 2023 16:19:53 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 21 Sep 2023 16:19:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 21 Sep 2023 16:19:52 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 21 Sep 2023 16:19:52 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 21 Sep 2023 16:19:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uyvlw0HUTlwxmbbPEjFb8u/MJSm6gRO+lW+C1oH7RBt/pZCe5zEqs3sgFZnCSxxfEWUe9buT3jadB8ATDfrAyJcWm3cqKpyxjMRpaCNBB/ZFPY3PRxFbKi/gkTlvKnx1RkNsmOdKF6ISatXrI/UOB+DPd5fOrdGCXHKy63237+LaVeRdUDD2rs6PNYpcZjkT/pqdKYXyE/SjFNlt9TXbN9oxh4EPXkEwGg5Jb71NE8+KmsjQj2DlWKDOIs6InoPoV52CWwYv/T+kiRvZUj+m2avZ+73xP57eoCiyqgRrciOZW54mau603l2LKgplnfxo3Ovw4ZCpyNuv1hJq+Jgflw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BkuWMRdcskh1sP+IHwRwzEBPxeO3Lvx/SgONw4A10L4=;
 b=UAvT1QSiysFl9USGikaNwySyDb0O5u4yOmAXwBTSbEssXrA3gcFu9WDrcwHCB5hvDjB301ZFapNN6D4dcesWaqHjUmA5yEv0NuaIhhMQY4gBtGGmNbmSYfyGwzAq/JFdCynH3DGPxsCV8hmL1QAxihx/JEmq/rpsoTD5fKfF0ZwROCaro8fOOfcIs+E9TcU5WWMGpdAiqOI6BqtAEe9rrRnMssfxRbG7tGVsY62NNAvPkKA4OxbCjIjSqFckXji6M/b0i51+Uv9HnmPzmVHBiJmxYOVBJpA2gHmvKguwd7ihOgfnHaocT8My9+6qHOMcOG8V3fIw9vo7MsQCBq7iTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by IA1PR11MB6369.namprd11.prod.outlook.com (2603:10b6:208:3af::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Thu, 21 Sep
 2023 23:19:50 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::e9ca:a5a7:ada1:6ee8]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::e9ca:a5a7:ada1:6ee8%5]) with mapi id 15.20.6813.017; Thu, 21 Sep 2023
 23:19:50 +0000
Message-ID: <11b727a2-0f86-64f9-cafb-a08e7e60bd39@intel.com>
Date: Thu, 21 Sep 2023 16:19:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Betterbird/102.13.0
Subject: Re: [NDCTL PATCH v2] cxl/region: Add -f option for disable-region
To: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>, "vishal.l.verma@intel.com"
	<vishal.l.verma@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "Xiao Yang (Fujitsu)"
	<yangx.jy@fujitsu.com>, "Quanquan Cao (Fujitsu)" <caoqq@fujitsu.com>
References: <169525064907.3085225.2583864429793298106.stgit@djiang5-mobl3>
 <a5f7fc5c-82a0-de3a-fe7d-f95e07e35ad8@fujitsu.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <a5f7fc5c-82a0-de3a-fe7d-f95e07e35ad8@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0248.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::13) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|IA1PR11MB6369:EE_
X-MS-Office365-Filtering-Correlation-Id: 33d3a392-d7ea-4225-1458-08dbbaf9408f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t+atWmNbTPGlN/HtjEqgaM9HqcYx41z7/bDuae7upvPIpR9PqNZAPyqbZxDplkDedXs2Gt/6KSvHD2aPXKb+9fWNBrAXSuSn6uigKwYNwfNgpGH9zUwsJa3fOEyud/3H/MDJgaJc+6tl0jLMl+XVk2hhZH6Q/21mhR7DFTZAuLfne6BRhZgkC5YDn3T96PRXa6fIq9ypZzWrwq/ESVuUOf49bwxC1eik+HUmM3HfVKFoAFo7aPMnPjTaYZx//LUqusFwRgBKJvSxcNf8dF3l68DhSmcvM1se0yE0gL3qaGd/cUKVI+GwEWdZosldDVEya51Bh5US4k6AQky3eUAd2DVDdNvre1XxuvGg/OwJIkD+qgKNlULlH17q+SSbFJfad328wQtxKGLRvVYxZh1gvDaUu+GMC6f/iBNpm+vGaGtRxmXuT6GkLkP08UZWK6YFa+QGH0QtCw43weiuXJVF1+RmN+VzbVEBSncJGB77okdjp7OQ3fKIIWTCw9iSBvjxG65k6qlKmbNjrzs0JrPgNMhLVKYrrdEYm1Ob/WVucDFRget80zhkDYLYVqmjRdpUlYobo5AfFZhDBzO8TxGiqx+rJWOXliHaGvhLQfW1BT6HjASb+EUlfTPnPZO8fM0TsPW+aw6XC9lIR/d1hqMQyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(376002)(136003)(39860400002)(366004)(451199024)(1800799009)(186009)(83380400001)(31686004)(6486002)(6666004)(53546011)(6506007)(86362001)(82960400001)(36756003)(31696002)(38100700002)(2906002)(5660300002)(2616005)(6512007)(478600001)(26005)(8936002)(110136005)(44832011)(41300700001)(4326008)(8676002)(66946007)(66476007)(54906003)(6636002)(316002)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OGJwbVVNci9yZWVTZ1pZRGhxYVFnVnMrTXZ1RGI0bFJ6TkFMVkx5K0lyNzBE?=
 =?utf-8?B?aTlDTHk2YUt1MEZLcTQ2Snh0VUoyVGN3dWxXdTB5Yk9TYnhFYVc5c0QrcHF6?=
 =?utf-8?B?ZGU4R2NkME1EbXJrN0pMK3RGKzZ1dGJ2TXZMMGlQcFhhK1dDSlhrei9BODk2?=
 =?utf-8?B?cUF0V1ZiQjhpM0VUdzFNcGFpeWtscFBST1l4QUIwREI3MXlkRDZ0Vmsxd3NU?=
 =?utf-8?B?U2pNR0s5clllVlpoalBaQTEwVmtpemhFRkpzOGFtOW5Bemk3Q2wvak1qZnpS?=
 =?utf-8?B?TE5LQkxhMTRTRDRrVGUzYXltQlZabnVLZkRoMWFoTWhOeUVubTNwVXMxZVFZ?=
 =?utf-8?B?M2VrRWVETlJDZ0MxdGdOcExRQmVRUE9VOW9DeHdvYmZBbWF6V016b2VXQjZy?=
 =?utf-8?B?N3NoYy9adUE1QkdRWUhMS2FPWXh3NnpGV2xqcldaQmxDays3eGI3K0FLN2Fn?=
 =?utf-8?B?bUJlOXI5Zk9QanRrUVpkWmpucGgyaUJrOHg4SVpmVzVMOGY3MllsYVF3YWtu?=
 =?utf-8?B?WHhBQ24vdGd4MWRZQUY3T2I3YUpETkdYd3VxVkJ5NlBXaThFWjBWRm1XeENu?=
 =?utf-8?B?cVd3QzBQYUZIV2hrSVhjQ00ySVNNU1RGcGFwQTVZQW40TkZsR2cza093TG93?=
 =?utf-8?B?YWFKdmkwbEJQOFhBL05QTFlucWdFTjZLQm1VcXpHS3JKMExrNURhOWVsUVM1?=
 =?utf-8?B?RmdlMHovWVUyUSt2YlpRaFRKajJ5MWMyZVRZZm5JTnhnQTA4MTFyUlRvbGJw?=
 =?utf-8?B?amVvM0I5ZUU5QnYwV1hWVVlEU2wrNXZmdFdMS1E5Ni9kYXBRemQ2NjQvMGNJ?=
 =?utf-8?B?UGhNem5PVC9YZ1hCbUxwSnhoUDdubjBNR2MrdHRQSWtHcXBueEhUTWk4dkk0?=
 =?utf-8?B?N2dLTXdSK1MwT2NqVnZHb1Rzc2F3T3Mzc2tpM1cycUgvc0VHelBqSWlIOWpr?=
 =?utf-8?B?YlBaMmJUZTFVVm9sYW9uVWVaWGNCOUJVb1lEMzEybWt2VWhvSGtCdXZyb0Jj?=
 =?utf-8?B?NUNYcUlXVEtSS3pEYW1QSXRqaC96Ujl6SlAvcE14OW9WZnNLRXluQnAxdHlo?=
 =?utf-8?B?QzBDVFlJblFod29zVWhSV1dQTUNHeDM0Ym01U0FCVTV0V3dTMjVCNnJocnR5?=
 =?utf-8?B?YmdaWXRETENiYUNNRGZGczQ4NHR3S2FmTWxOdnQ0YXFkTVRmL0dJSzd3RUdy?=
 =?utf-8?B?QUJqQ3RKVU1ML3NFdVVIeW9nSnpQRi9Yc1dvNWRYVFp3cWYrM2xFSS9IRmgv?=
 =?utf-8?B?dzNEU2VQVjM3bWs3MlA1UEZRUi80UjJtRnlweEg0bWp0OGppeXA1ZU9OdlJ3?=
 =?utf-8?B?MTBIOUxNWm8xN2cyNjM2TmZDeUI1eEtWSzFsTnR6SGtPOUh4TnY2SDA0RWZr?=
 =?utf-8?B?Uy9jVXBOT0lxRTF1eXBwVGJKb3BDNUFXZVprZFpNWmFrMDNzTjhkRTJuN3lq?=
 =?utf-8?B?R3hWaGhRRGMvcnhNczhUVHFwaXA4OCsxQ2luTWxuYnJhOFRtZGRuVGRoQmdC?=
 =?utf-8?B?a1R5NlplV2ljOER3em1IOWhsMnFtR0R6OEVENWgzdmxmbUtHMkRad2VIM3E0?=
 =?utf-8?B?N2ZpK3FvOWI4a0IvenZrMnUvZnBabCtQUW5tOUczV0FlRmJMUTBSK1dqVDdM?=
 =?utf-8?B?YldKMVAwVHBlZTVHaFhvcGZ1MTBHZDNDcG56SkY3TG03eXhJRXlWUzl5eHY1?=
 =?utf-8?B?cDFmYUVwbzFGOVN4S05idFBmczZvNmdUakNwbG84VUp2cEhmQjVHSnFjZXRr?=
 =?utf-8?B?blJ3aXJYRXVyQ0NlM0tsMjh1aTE1NDdBT2J3NE9qVng4bFFnUlZrTjZkZGlM?=
 =?utf-8?B?aWtqdXM5Y3ZXSTA2eU5EaVFjREFhN2lsajhvNjZRZTBiTjQ3dFRzdUE5YUxv?=
 =?utf-8?B?REJCOVdQaW0vWjlqRnFMc0p1cG5kZ0h5QzVrTE5YeTQ0RzNEL0hWdHpRVFd5?=
 =?utf-8?B?WkdFTVVOdWk1aElkbnlRZkhKRXpwMGcyc1puUC9qNkc4Tk0vZUQ3aHhiUVZK?=
 =?utf-8?B?RjNkdE40aWdVNS9OQ0E2U1dpaDUyZ0FYeTBHdExleWV0NEl0SHBSR29sdmV1?=
 =?utf-8?B?dGJpdXEza2pRbnpldWxwL0o2SlpkMkNNMHB5SHNtWkFWMzdlMEk5S2ZHR0M1?=
 =?utf-8?Q?LJsul8gL3DnGXJMgzVf8RLlfA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 33d3a392-d7ea-4225-1458-08dbbaf9408f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 23:19:49.7308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I/yNnTZdt0G8KyPYGwTQv9SEqELHK5i4+nR68RhPpPf4WHJLIaGp0QEzd99UWpALW5GTRekuHC98wCBzRFPxPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6369
X-OriginatorOrg: intel.com



On 9/20/23 19:58, Zhijian Li (Fujitsu) wrote:
> Dave，
> 
> Forgive me for not having a new thread, I'd ask a possible relevant questions about disable-memdev
> We noticed that only -f is implemented for disable-memdev, and it left a
> "TODO: actually detect rather than assume active" in cxl/memdev.c.
> 
> My questions are:
> 1. Does the *active* here mean the region(the memdev belongs to) is active ?
> 2. Is the without force method under developing ?
> 
> My colleagues(in CC's) are investigating how to gracefully disable-memdev

Zhijian,
So this was there before the region enumeration showed up according to Dan. Now an update to check if the memdev is part of any active region should be added. Either you guys can send a patch or I can go added it. Let me know. Thanks!


> 
> Thanks
> Zhijian
> 
> On 21/09/2023 06:57, Dave Jiang wrote:
>> The current operation for disable_region does not check if the memory
>> covered by a region is online before attempting to disable the cxl region.
>> Provide a -f option for the region to force offlining of currently online
>> memory before disabling the region. Also add a check to fail the operation
>> entirely if the memory is non-movable.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>>
>> ---
>> v2:
>> - Update documentation and help output. (Vishal)
>> ---
>>   Documentation/cxl/cxl-disable-region.txt |    7 ++++
>>   cxl/region.c                             |   49 +++++++++++++++++++++++++++++-
>>   2 files changed, 55 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/cxl/cxl-disable-region.txt b/Documentation/cxl/cxl-disable-region.txt
>> index 6a39aee6ea69..9b98d4d8745a 100644
>> --- a/Documentation/cxl/cxl-disable-region.txt
>> +++ b/Documentation/cxl/cxl-disable-region.txt
>> @@ -25,6 +25,13 @@ OPTIONS
>>   -------
>>   include::bus-option.txt[]
>>   
>> +-f::
>> +--force::
>> +	Attempt to offline any memory that has been hot-added into the system
>> +	via the CXL region before disabling the region. This won't be attempted
>> +	if the memory was not added as 'movable', and may still fail even if it
>> +	was movable.
>> +
>>   include::decoder-option.txt[]
>>   
>>   include::debug-option.txt[]
>> diff --git a/cxl/region.c b/cxl/region.c
>> index bcd703956207..f8303869727a 100644
>> --- a/cxl/region.c
>> +++ b/cxl/region.c
>> @@ -14,6 +14,7 @@
>>   #include <util/parse-options.h>
>>   #include <ccan/minmax/minmax.h>
>>   #include <ccan/short_types/short_types.h>
>> +#include <daxctl/libdaxctl.h>
>>   
>>   #include "filter.h"
>>   #include "json.h"
>> @@ -95,6 +96,8 @@ static const struct option enable_options[] = {
>>   
>>   static const struct option disable_options[] = {
>>   	BASE_OPTIONS(),
>> +	OPT_BOOLEAN('f', "force", &param.force,
>> +		    "attempt to offline memory before disabling the region"),
>>   	OPT_END(),
>>   };
>>   
>> @@ -789,13 +792,57 @@ static int destroy_region(struct cxl_region *region)
>>   	return cxl_region_delete(region);
>>   }
>>   
>> +static int disable_region(struct cxl_region *region)
>> +{
>> +	const char *devname = cxl_region_get_devname(region);
>> +	struct daxctl_region *dax_region;
>> +	struct daxctl_memory *mem;
>> +	struct daxctl_dev *dev;
>> +	int rc;
>> +
>> +	dax_region = cxl_region_get_daxctl_region(region);
>> +	if (!dax_region)
>> +		goto out;
>> +
>> +	daxctl_dev_foreach(dax_region, dev) {
>> +		mem = daxctl_dev_get_memory(dev);
>> +		if (!mem)
>> +			return -ENXIO;
>> +
>> +		if (daxctl_memory_online_no_movable(mem)) {
>> +			log_err(&rl, "%s: memory unmovable for %s\n",
>> +					devname,
>> +					daxctl_dev_get_devname(dev));
>> +			return -EPERM;
>> +		}
>> +
>> +		/*
>> +		 * If memory is still online and user wants to force it, attempt
>> +		 * to offline it.
>> +		 */
>> +		if (daxctl_memory_is_online(mem) && param.force) {
>> +			rc = daxctl_memory_offline(mem);
>> +			if (rc) {
>> +				log_err(&rl, "%s: unable to offline %s: %s\n",
>> +					devname,
>> +					daxctl_dev_get_devname(dev),
>> +					strerror(abs(rc)));
>> +				return rc;
>> +			}
>> +		}
>> +	}
>> +
>> +out:
>> +	return cxl_region_disable(region);
>> +}
>> +
>>   static int do_region_xable(struct cxl_region *region, enum region_actions action)
>>   {
>>   	switch (action) {
>>   	case ACTION_ENABLE:
>>   		return cxl_region_enable(region);
>>   	case ACTION_DISABLE:
>> -		return cxl_region_disable(region);
>> +		return disable_region(region);
>>   	case ACTION_DESTROY:
>>   		return destroy_region(region);
>>   	default:
>>
