Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2AA28DCF
	for <nvdimm@lists.linux.dev>; Mon, 27 Nov 2023 23:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XSJqvzIn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701127690; x=1732663690;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=k92xEC5bzDduiMUYUbmz2Nn36sZm0FqXxY8PaJa2WYQ=;
  b=XSJqvzInIm2CtOT57PrM3CNKLMJdJmISFmStt6ORykW0ZFSckSXa0NN9
   UagMgE/p5GV3mwgWK6ha618WTZdunDMC3BOMSa/yGcY8j5cbvGWiTi1OE
   zzDG9y4KFQccMLijSiBiyjsEO/rCvn+nnDZyHoeWI0G0BzQZRZVkL007b
   9QMvbU0UdHEXUky5pkPI7ey3zFEWFBDNBUP3GVNS5nIEmapS2EDez7vpr
   pM2terNtB17m+/c83XJ0LqYo1QrH2LQ2+Qfprt3uPIX8rcXx+PPBp9te3
   IGLuBRQUzLir1Uf2XkKP87p4hQne/O2cT34fgDTfb0kosXwz326I3LEZu
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="391686676"
X-IronPort-AV: E=Sophos;i="6.04,232,1695711600"; 
   d="scan'208";a="391686676"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 15:28:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="744725821"
X-IronPort-AV: E=Sophos;i="6.04,232,1695711600"; 
   d="scan'208";a="744725821"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Nov 2023 15:28:08 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 27 Nov 2023 15:28:08 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 27 Nov 2023 15:28:07 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 27 Nov 2023 15:28:07 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 27 Nov 2023 15:28:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fyOqWkd5wxlOJaLA0gjej0hRHkzPm2+mqfVhGCqf9rEj5AbVoVlg6P4Eso+cK0HlL9XFlFbBWNtvQ5angZk+94knEfeAextnkrTcLHxhIiW5Vtn2vAuO9gZ37rBNEz/KeM7//qQ8RGYIAnssNepdIe+IdIDmWH+sjxWTelpQ6/jzCr+AAX8yDOLhCK4G4QDRsMf0UBTRuNGP2cMy/YxuGYaT2bhUekCSPIKAvMTskdvHfpGpEFX978TseBVj1BW504DVUVsD4BDdOej/HU7VVJjg2PdUOkqoleAmR4o9+VCmAT08XRO57OFDftmPKBTt3MAZ9JFK2TWhaseeXSV9Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k92xEC5bzDduiMUYUbmz2Nn36sZm0FqXxY8PaJa2WYQ=;
 b=nMCJs1AWZ/Kr0Rcdt+Ky8vbZ7m6UHvKAzNv7u/2HUBKhqX1bq1eHfoPUbZ2WrjhEutR6nRBag9tw6RAZmkQO0ir8+rdqGGPQlLyY/iZERoR1EhEbAkM6Sv7DwkyJzAhpDaL8iDNqPucSIsnhefKMtm5r0a/viQSm8yyKhnXZ5lKW1/6gslwXtO/NPyEFlLCC90mk8wt43Y+rb4ZmG809uVojY3oteLggW1pJffEV8ZtpbjkZltxxFhdRNvVfIJjF57samFRYFSHQPaq6EhjsGFGjiNOcjb8XAkEFboHyme22XnCyeCWFHs0OtoB7/lUbZh30V7x2EGwVmoJ8UbLiVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by MW4PR11MB6692.namprd11.prod.outlook.com (2603:10b6:303:20e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.27; Mon, 27 Nov
 2023 23:28:05 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::6f7b:337d:383c:7ad1]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::6f7b:337d:383c:7ad1%4]) with mapi id 15.20.7025.022; Mon, 27 Nov 2023
 23:28:05 +0000
Message-ID: <9b72eab1-2fb6-43b9-9858-7bf809f77c39@intel.com>
Date: Mon, 27 Nov 2023 16:28:02 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [NDCTL PATCH v3] cxl/region: Add -f option for disable-region
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "caoqq@fujitsu.com"
	<caoqq@fujitsu.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "yangx.jy@fujitsu.com"
	<yangx.jy@fujitsu.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
References: <169878724592.82931.11180459815481606425.stgit@djiang5-mobl3>
 <4910174f-4cda-a664-62ee-a6b37f96efac@fujitsu.com>
 <1c5f9602-7226-42f9-937c-671947ccdb73@intel.com>
 <47fede41b87c0686c3dfbc95bf7c2e21b84c5100.camel@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <47fede41b87c0686c3dfbc95bf7c2e21b84c5100.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0007.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::12) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|MW4PR11MB6692:EE_
X-MS-Office365-Filtering-Correlation-Id: bb77f7ad-d266-4ffe-9b78-08dbefa0813f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 71/VUGUugOXn2qfaGLyllTD09WDcElSgpm7lrrDL93r1HcOVpOWp6gw8QG+i/5JRswoBI1dAUd24xiycCPENTNMhy1ZeSze9uSNxbOmRF14+ejf2Ob7U/C3Dw0IjX6nsBofRlptZZZFSq1MVHC/C+RUkvjMmWMU9C+ZJsc/hiaSiQub6H/x+vuzUO0f6XaKjOE37AUZU1+NiOj7MQcJ8GScLZR0BuISF8FWnBGhpyBz83ttb0TOAxDCwI3e0DEOc3c50s0fByBZJxdvHiqJa2Lw2wOdo7ykSZuJMzCsNBtJtNpxvjxf9mvibDtQBw6Quja03YzDun8+vWdHM9TJQNGE6FSWUycjbTD8DS8Qt1XiL6kzH8uqwj9ZfVbJinECird5eaS99KhZpEPpxrLQInbRR1drTm6piQxUR92iJ2nwQxUWPLfbr31B7+w+5ZjPH4CSLhAbHEEaCjNkamv52ueme12Rch9YmxC37pWK8OeMydJ8voStlXLwVjeoihT/T1BU/16uHaBej6lHEohynbOliUo4PyxPP8RwqoKfoPQSLIE0BXMB8ITxyQuCX9qEN0SKGoq3ZHIBT6rs+OfA0/y/8n1y9YjTkDMA8HFoogB0VmRZMyyjQHVcqmcHy/qU0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(396003)(376002)(366004)(136003)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(5660300002)(2906002)(86362001)(31696002)(6666004)(478600001)(2616005)(53546011)(26005)(6512007)(316002)(66946007)(66556008)(54906003)(66476007)(4326008)(36756003)(8676002)(8936002)(6486002)(110136005)(6506007)(38100700002)(82960400001)(44832011)(31686004)(4001150100001)(41300700001)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3lvMEU3R1QzMDNTVGY5eEUxanJ2QWFPc2hZVHh6cm5WNEtENlZ4aDd0T3I3?=
 =?utf-8?B?UXdjYWQ4d0RYN2pmRU5kTzZYWDNlbTBLekFFZ05wQTJoaHQ5Uktadkw0bUt3?=
 =?utf-8?B?d3BNc1VQMC9MVlJrbVdmNUNhQjdSVjJ2ZDgwZTIvajVTWUlHdzZQTUdRbElJ?=
 =?utf-8?B?QXEyRTltcCtQK3ZsYzZwQjBhZ1l6bFNIaGM5YmQvU3hIS25CUU4vMHFDenZs?=
 =?utf-8?B?R29uMHNzLzVhMUxQanNFbHpmYktBVjNvZlg0VW5aVVFTZ2EyR2NERmQ2eXZP?=
 =?utf-8?B?UnZaenVoOWg4MHczbVA4NlU1cVdONkxmRzhJNWhLeFdVMkFGWXpUdEUyWFhC?=
 =?utf-8?B?VTVNUWxFdjcrN1FaMDd6YVVHV3RCc1JEcjB4ejg2T1N4Nzg0dUNPdlF2R2JQ?=
 =?utf-8?B?VEozNTFNUGM4ZmdOeEc0bEpIYmNhbE4zZG42VUxMN1NKSURFM2tUNE9MeTZT?=
 =?utf-8?B?RGlqU3pNKzd2QzVTT2NocmhlK29FNnRqZFlOcmxkR0g0Smh1K1dlNmo0SmVE?=
 =?utf-8?B?SWdseEFzdTlvWExqMS9STXRhbkVVNXVTdW14OTdOSFhJRUU2dHZoRTZqQml5?=
 =?utf-8?B?dnBOc3hITmhsZXRCdTlNUzNFRkVNRWNEWG9ZRTJ0R1VyRHhkUVV3bHUvSGxa?=
 =?utf-8?B?SkREUXE2d2h6dnJFSFRSVTBiWC9CR1ErbkZYTUgzNDdqVVdhZ2duR0lodFRt?=
 =?utf-8?B?SW55cy9JdXRiU1llWXNDNExNZ0tYUjE4eWtEaXFoNm5Mb2lLQzJmSndsOTRN?=
 =?utf-8?B?VHh5RnNwV0dCcTNaaDFVYXFlQ0ZoSkpraFd4NmdjcGc4MFNMNEUxRC8veUFj?=
 =?utf-8?B?RHErbTJyeGVremJxZWNnK1NjM1pSWEtPeVhIOTY0UDdGRnErY1AvaFdQbldG?=
 =?utf-8?B?azhMR00xemVCRTA0RVVSbkNVSnM3OHQ0WFV0WmxmeU05Smc4SmFNdFloN0JV?=
 =?utf-8?B?a1JGUkJpMjBiaTVyRHBLUHk4ZzJkNklISVh4ZXVSck9paHZGYWZBRVB4U01X?=
 =?utf-8?B?T0hnRzd2ZHp3NFppZEJDK1BraWVoSFFKYStERDdNVlQvV0lmb01sc0NDM0R3?=
 =?utf-8?B?ZUZsdWNuTkk3T2ExMjdDU3VJeTBtZjRBTWJzbFIwNUhSOVpVYUxWZE55bklq?=
 =?utf-8?B?OE9taVlNMkEwa1hxS1JsTWp2dHZIa0N2cDgvZnhMMnFOc1NXZm4wYWNRaWpk?=
 =?utf-8?B?UlVqQnA4YlVZa1V0NHAzb05veklUMGRtcllFbE14RWZKbjhQcmU4TTVUUVJH?=
 =?utf-8?B?WmM5ckxQaEpvM0FCeEhlcVgwRmhHUFR1VzNiaXVYT0dpZytFaGNCVDR3ZFVZ?=
 =?utf-8?B?cEhzU2VBcmNaZytTYndNc3BCd2JIa2RuQytwZytkSkFEaGdnajRadDM5S2VW?=
 =?utf-8?B?ZDkzRGhqQ2picWlpWUx0cW9uZ3VhODdkUUdRRmU4WjFnTTdIQS9DL0xqZmVt?=
 =?utf-8?B?cTVObFZhV3JJcFowa0RvKzZXVnVLbC9yM2libzdXSk1iaFJuVko3aENKU2hU?=
 =?utf-8?B?Y0hIRm1qU2t4MThjWFpJNExXMFRHN1pRdTVqQkpIZ0Jtb3RZRWxTY1g4blVl?=
 =?utf-8?B?enU3WURkZnpkcXgwalR1U29ESjRHd3UyUERtNEZUZTZUZHUwUGNxaWQ3cWVV?=
 =?utf-8?B?MXAzeFVZa08vWkpLb1ltcXRWMWtCdWE5ZzIxNElkTzFQcDk0ZmJOYTRRa0RR?=
 =?utf-8?B?WGxKNWJBdi9HZjhSRmQvRTRveHdzQWNVLzU4YUp0WUhXMkJ2SmNaZFJHSFJZ?=
 =?utf-8?B?RGd2Y3UzSlRpTlRiR0Q1MFY0enludTJLbENualZjdlJuR3l6aUJsWmY4OFh5?=
 =?utf-8?B?VUdCdHhiRjVxdHdGbnhya3YzMndnRHhUQTl2RldSMGxSY21oWFhjM1M0U1VY?=
 =?utf-8?B?NFN6azJGUk5ka2tFUUdKcFVlZFpRL3Q5VHVvTlpKdkVnZE5yZDZUYnlSL0hs?=
 =?utf-8?B?dmJwdXBhVWpYcmZuZUJZQzJsUmxSUUFvaUxYaURwZWR4Qk9TaFZpVDJwOG1p?=
 =?utf-8?B?R3M1NU0wR1pZek9DOXRPbmtrUmc1WUUxTHh3ODd1VzdmanVDUkMzbUJacFJS?=
 =?utf-8?B?dlBwVWtJLzVlWmRBcTJmdlB6b2psRGpaMGNzTGc4Ly9Xb1h0NHgxMk5yd09D?=
 =?utf-8?Q?GZ9wwJxWDidJO5CIVq4mwwdeU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bb77f7ad-d266-4ffe-9b78-08dbefa0813f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2023 23:28:04.7434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6GzZ93VtpaNrnHXGiHihAhZNJawEJpkXr5c/aTpiftwbXz7bahrKtD3JWV0FiFi5er5UIJnbsyPvVS6DX3m5qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6692
X-OriginatorOrg: intel.com



On 11/27/23 10:58, Verma, Vishal L wrote:
> On Mon, 2023-11-27 at 10:13 -0700, Dave Jiang wrote:
>> On 11/27/23 02:34, Cao, Quanquan/曹 全全 wrote:
>>>
>>>
>>> 1.Assuming the user hasn't executed the 'cxl disable-region
>>> region0' command and directly runs 'cxl destroy-region region0 -f',
>>> using the 'disable_region(region)' function to first take the
>>> region offline and then disable it might be more user-friendly.
>>> 2.If the user executes the 'cxl disable-region region0' command but
>>> fails to take it offline successfully, then runs 'cxl destroy-
>>> region region0 -f', using the 'cxl_region_disable(region)' function
>>> to directly 'disable region' and then 'destroy region' would also
>>> be reasonable.
>>
>> To make the behavior consistent, I think we should use
>> disable_region() with the check for the destroy_region() path.
>>
>> What do you think Vishal?
>>>
> Yep agreed, using the new helper in destroy-region also makes sense. Do
> you want to send a new patch for this - I've already applied this
> series to the pending branch.

Yeah I can send a new patch.
