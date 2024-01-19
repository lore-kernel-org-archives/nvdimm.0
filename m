Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AB958100
	for <nvdimm@lists.linux.dev>; Fri, 19 Jan 2024 21:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.55.52.120
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705699125; cv=fail; b=p8nGnaCj7B4HsfIoZLbt6pxXdhuYftaPi/GypMqU0ocvrMPO7yC3nJL/4U0CkZv6mIuD7O80imnrmlNdxfMQlfNZ/PHENKRIHRIDnjhYWWbVf+hVaSpIObXx1GcFBdqX5QBryQOWV9N+gecpXTg6atcjqcvFouAHmtW5cJjOFdw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705699125; c=relaxed/simple;
	bh=omhY5FalbbG8V6nC+ZZM/Aiwur2+PmSXcLXtyEa2x/w=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NI9RbPkvUYl8kVWsBSzyZ6ZJg8XMYpa1XT8+9nFCkyei5/7njeOjfLJvpK8uYYsw1LOWc59YG8lrPJ7HaKj9op5nS8SCTsbMVBn+gDe0x8oXX7/qJGKMQAMq6C9HVy0bflXPXMLYYk4pQio3253VNrmt4jnSBScW49LQDgqaG/E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UCIcCWcd; arc=fail smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UCIcCWcd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705699122; x=1737235122;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=omhY5FalbbG8V6nC+ZZM/Aiwur2+PmSXcLXtyEa2x/w=;
  b=UCIcCWcd1b9zftW55PG8meTUY0Jz9ZaHqx+NXRIXN8/0rGtlTsSZF+Ok
   p3YdMvDQM6b6n8RUNNYOBreuD/CLh1vpkr5kRHV04MJruDSRoeb5oxvdY
   s4YBhgsjBbAHALNRN6T6YLt1df8ol4XimenPjldDtD5DhnQFRFDmtszKp
   LyjBdMtntXNnRQ3FBjpZhVWo1Y0DN573r/hDlI+8bQaDYsh5WoBF7UxOe
   x/HMP8wToGsaouconGvlS5w3sW5mr43cx9c4R8LFPQXLJcqmvaojOeTKD
   3vugldyBzTxODAU3cBj7f2TjWe3LfkjzutMnL6gg1CLKW8JWhpmYzagmJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10957"; a="399716881"
X-IronPort-AV: E=Sophos;i="6.05,206,1701158400"; 
   d="scan'208";a="399716881"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2024 13:18:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10957"; a="1116336058"
X-IronPort-AV: E=Sophos;i="6.05,206,1701158400"; 
   d="scan'208";a="1116336058"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Jan 2024 13:18:41 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 19 Jan 2024 13:18:41 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 19 Jan 2024 13:18:40 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 19 Jan 2024 13:18:40 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 19 Jan 2024 13:18:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G4TH8IYyt9d+2DTyEfKaAwjs+V+AWLtLUpAe57+bD0NxMt901Q+v2zPBaO575ssUkezRFbQFJEALlFD0W6bnirM5wgRMcsDV/oq2S5fWZYIXINrJas7WYk24ZEfNKwLwgisCGO0Me79K5YAeennqYpu4vT9bSoaeBQjfYQ1MZKA7QlNjSGGXKwwXKoojhXwQYJO+iplEJSabeWkd5pLKCHEyLeWSAiZhbW03dG6s2MhVpVv6Zp3Eu42wi/Mfn/cdYOEBPD7On+Uc5iT1wWKH5Z3BT8QZKjBKOdvSxvwTwdP+oYFUgON2QSXqy67mXytvburINd6aFZV5npvwwKHWcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HJ3f/XhmR6t+/MBw6bSGlvNhD8alf2jU7CSWoImTXxM=;
 b=HVJDJ52Iw21tobD/MCmDxi3/nhZWDEQnwZ67qhY/8dAI1HdeHps+kIWpAyxORP1GJjvM3HwQBNmLSrDPgHnu1GEjNCtgdYDVKTv8JWn4TzvBKZ0HnLRaawPmdXAcROb6Vl/aR1NhttdrENdvCHKBRHimaIU+SyueG1kS0WEjIdBFPRHtpHZr8adTebzKENGBGIqrE8J2FzLwCViZ6FyYAd4slcKcoucQfuwVjUd0Ea61UIKo2NjwX/ogoMt/Z0DZZYSL7vFJdeuCiISlvqv51fLFVEWYWh19OrTM+etSqx0BGgOVsKFKNJS2eH28hCyGaxgUfoJ8de2aHYImzqBnDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by SN7PR11MB6601.namprd11.prod.outlook.com (2603:10b6:806:273::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.26; Fri, 19 Jan
 2024 21:18:37 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::780:d536:ff24:3e4c]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::780:d536:ff24:3e4c%3]) with mapi id 15.20.7202.024; Fri, 19 Jan 2024
 21:18:37 +0000
Message-ID: <71c4446f-b0d5-439c-80f0-4d2beb7aa667@intel.com>
Date: Fri, 19 Jan 2024 14:18:34 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [PATCH v6 4/7] cxl/event_trace: add helpers
 get_field_[string|data]()
To: <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
References: <cover.1705534719.git.alison.schofield@intel.com>
 <a4e63238ba2137f4a4b69d2c21c67badec15a659.1705534719.git.alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <a4e63238ba2137f4a4b69d2c21c67badec15a659.1705534719.git.alison.schofield@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0096.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::37) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|SN7PR11MB6601:EE_
X-MS-Office365-Filtering-Correlation-Id: 850b9dd6-2657-4f25-2e1b-08dc1934334a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4DpwKX/FguFjruLAtBqcOLu91GHv/HwIKJC9OQVf4g9d6RNgLdrtalIVNkBFdAqNrkjMNg+2Fsm5VEUz1qgGdQcX64uvHOM43H7oKCe9NZJ/Mq8RncifKUwaSRyKE+0q8FNCrpb2gb/Gs/rszay3l2hTqh4vuf2AXVCBo1oH0S95/g/Z690taUpFdMcsyTB4ClHLep71SdvcpceEUCnVeWuadQ5bqcQdcqy1j56q3BK0Dk9zeCxnu8dhlNKTCAkuJBaaNIvjuSH8P2ajWzEUxvYSlmJ3Oj+VaIZ2mNwCa8UwC2PEQ378kJPJ1L6FIFjmhsiBnDXyCSPMGFyyPfJt7gWVq6wZ1mdMtPIK7KXUujZKA2t1d8j2qLejOBbJ7fCD9G1bWRiH88PnDr4hirhTPIjihNTCeiy57A+yrW/si0z+4X1/Gp8CemeXbVR/Fx+ad1TRTNoKAhjySELxu9RbsyAqckJ/bNY0OcXc1MMxHGxOcGrN6lo6k1l0KbLQBVZUqJCXFK9jMQae06ozPbAUjG6kQsOOQUlQeSdWzx5f+hwN8ucvEQeKfV8aly+YrHqlMeQhtWynXGPHJDqk0Pt2fT/6ecrwDqnt7kSms5IO2+YLOAaq5Ui2g3WmOiJWTBbR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(39860400002)(136003)(376002)(396003)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(31686004)(53546011)(478600001)(38100700002)(82960400001)(31696002)(36756003)(86362001)(2906002)(83380400001)(5660300002)(6486002)(26005)(6506007)(6666004)(6512007)(8676002)(44832011)(4326008)(8936002)(6862004)(2616005)(66476007)(41300700001)(37006003)(6636002)(316002)(66556008)(66946007)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFRqL2g3dDMrNEhSRlZrdWhraHB2VzBrNTZSWXc2elc3Z3luWUdiL1ZYRXM5?=
 =?utf-8?B?Sjg0TDlTc1piSkFSRVJvbldsVDlJRnlPQVNLSnorYmY3cU40WXZEUHpSdjdT?=
 =?utf-8?B?Nk1WM2NFNzhTUjIvcTcrYWViY0kxR095ZU1QYXpSZEk4OG8yUGF1dkFTL0wv?=
 =?utf-8?B?QTlNVWZEWHgzMUhFOWU1Y05PUTlhYzNRRmE5Q1lHQTBJN0hROCtJVnpobnEx?=
 =?utf-8?B?MEVUWHFYRFBrc3MrNncyeEt4UllLQ25xOUNaWmZ1WnhnT3J6S2xGNzV1UnIy?=
 =?utf-8?B?eUY1R0RCS0JUbi9vdTFSUStrTTVBS1p6TkZTYzFUeG5jZ2s4VG1uWTk1Q3JR?=
 =?utf-8?B?cURTRzFROXNycWFEWm1VWlpLeGVSMnJHbHRDR0xwWGU2dVhpb1lTVFdEMUNz?=
 =?utf-8?B?azZxRkx6bmdmVE5BWGwwcTlDankvNEtYYmFIbzNOazdXUFN4aWFUamRHRmhj?=
 =?utf-8?B?djdHcWJKZTlGakF1eXNVaC9kN3U2UDJ4MC8rVCtoM0ZaR0tQczRPd1FrQWt1?=
 =?utf-8?B?ZHI4WXUrczdaQzcyVDg3aSt6S0YwM0paVGlEWUpSY29zK0lvS1RBVGJWT0Rq?=
 =?utf-8?B?YU9EYTRJbHRlR1ZIbHFpYzJoc1J2Q0hEcjkwRlViSXU0QkkrSnVBcUVZejEr?=
 =?utf-8?B?VFNpVTFkVVVmUUhJTWhvWEkrWm9SK3BrUkwwQzZhRk51UGdQenUybHR6Z1Jz?=
 =?utf-8?B?QllOOUE2cWkrbXdCQnlHL09ZNU5IcllWbTdMM0RaOVRrTlE2TC9MWXBVZ210?=
 =?utf-8?B?TTRaUHRHbFc2VkcrMm1NaUpRd0JIREZBaXRCVHRhaEFWS3NtZ1FuM2lvUC9r?=
 =?utf-8?B?d08ycVVwaDdhL3cvMkRVMkNHN25ab1FYcXdUNzdmbUVJK3R3Y3R4Nk1KMEZK?=
 =?utf-8?B?dWVmT0VJSHdWa0RWcmZHVndQUWRyK1ZtZlJJK1BCV3JnZkFtUmk1WmlPMkhW?=
 =?utf-8?B?enZvT0VhRFVjYXB0bys4aE16a0NBeDNrSzFaL3R5Z3FFcUY0YW5IYWxwUU9r?=
 =?utf-8?B?dXRnTmI3T3dJVlM3ZFBwb1hzS1FJNS9pSE1QcjVHQXl1aTZVU1hPYytGOHlp?=
 =?utf-8?B?OUx6amwwRS9RbjNwMm8xYjkrdzFNdXV1bnlLZzFaa2Y1cWwvazZhYUdqUVVR?=
 =?utf-8?B?VEkzdzFLRHp5WFlwY1lha0tWdEx6NkxTdXhFd3dQa2Z3NUF3dkRoSFFHdzhV?=
 =?utf-8?B?eHlIV3JtNVlKdm4wdzV1L2tWL0pJM3REeGJZRVpjdEp6VDR1amlYWGJXRW44?=
 =?utf-8?B?MmE3R0poeENJTXcwcFFlMkZGTVlKUllBSlBtU0J1OU40UnJ1VzZyY3dQQ05r?=
 =?utf-8?B?cWhwNFNKSW5zeXdjbzFjWW8zckwrZGNua2hHb0FzNXRJTitFdE95ZU8ySTE3?=
 =?utf-8?B?TDJLTmpCUkNYTTd2N3RBWXZRMGNVM1g3WFZ1akdLZDBWYlc2MndITHExblJZ?=
 =?utf-8?B?UlZ2OUxuczhFUC9pWUpFMVNYc3JUTDlveUhmK21KWlNTa2J5L1EybklNNUhS?=
 =?utf-8?B?SGtRQm5zMWsrZlIwdjFRNkNZSEU0dGU3SGI4Q0hNalhleHAzMEMxZkhRYXFF?=
 =?utf-8?B?dUZIc3NkZW1VTzlBL0hMU3psRmkxeWttdDZBYk03YkVvZDVJdWxoUVRiY20r?=
 =?utf-8?B?aHhlZjlUVFAvMFkxY2h2Y2ZRdnMxUXoxRG1LTXRPU3BsWmlzMGpiUnRNRTJ2?=
 =?utf-8?B?UERRY05YYjJRaVUvR0JkK2M5TmtyYmgyZlhkSUJUSlMzeDVtM0hZUkpPTkY4?=
 =?utf-8?B?VmZqckVGMjZCcDdEQWlBQ3BvUGJsb1RpSmwvcG9ZWGJLSVY5SkVLb1cxMk9x?=
 =?utf-8?B?Z1dmOVZaTWN6a2orOFVpb3NHU04xT2x6MHNGQU9iZHhsNE13bE0ycTAxMDc2?=
 =?utf-8?B?SmNWUW5iVjEvL3hsdkUwVTcvOVFaaDk2Z0UzM296ZGhMY1NxblpWbEVKeVdx?=
 =?utf-8?B?allJcjRUSjV4R0J4dEpXaWxNeXpudmxPV0RMVnNuVkYrYU9PK3d2MWFnbU1y?=
 =?utf-8?B?YlI5d1IyeGx1OWhZUGRpbk1EOW9Nbk80K3FDZExuUDl1ck45T0crRVlqVm5r?=
 =?utf-8?B?SldJNFFRSlpRSVE0Wm5DM3NwcWtaam9DaWFCemdmSkRvQUtrSHEzZ1BvYTRu?=
 =?utf-8?Q?isiXLKXeXGxayVb5Xo7GP29r6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 850b9dd6-2657-4f25-2e1b-08dc1934334a
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2024 21:18:37.0993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S147Y+enbrJHWx4ndhcaM+5oCbPE5M9S1zIe/jJ9MYcFbWXie4T88TK4HdL+xARlLvGImsWoP3n+lXOMBNsb6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6601
X-OriginatorOrg: intel.com



On 1/17/24 17:28, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> Add helpers to extract the value of an event record field given the
> field name. This is useful when the user knows the name and format
> of the field and simply needs to get it. Add signed and unsigned
> char* versions to support string and u64 data fields.
> 
> This is in preparation for adding a private parser of cxl_poison
> events.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  cxl/event_trace.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  cxl/event_trace.h |  5 ++++-
>  2 files changed, 50 insertions(+), 1 deletion(-)
> 
> diff --git a/cxl/event_trace.c b/cxl/event_trace.c
> index fbf7a77235ff..8d04d8d34194 100644
> --- a/cxl/event_trace.c
> +++ b/cxl/event_trace.c
> @@ -15,6 +15,52 @@
>  #define _GNU_SOURCE
>  #include <string.h>
>  
> +static struct tep_format_field *__find_field(struct tep_event *event,
> +					     const char *name)
> +{
> +	struct tep_format_field **fields;
> +
> +	fields = tep_event_fields(event);
> +	if (!fields)
> +		return NULL;
> +
> +	for (int i = 0; fields[i]; i++) {
> +		struct tep_format_field *f = fields[i];
> +
> +		if (strcmp(f->name, name) != 0)
> +			continue;
> +
> +		return f;
> +	}
> +	return NULL;
> +}
> +
> +unsigned char *cxl_get_field_data(struct tep_event *event,
> +				  struct tep_record *record, const char *name)
> +{
> +	struct tep_format_field *f;
> +	int len;
> +
> +	f = __find_field(event, name);
> +	if (!f)
> +		return NULL;
> +
> +	return tep_get_field_raw(NULL, event, f->name, record, &len, 0);
> +}
> +
> +char *cxl_get_field_string(struct tep_event *event, struct tep_record *record,
> +			   const char *name)
> +{
> +	struct tep_format_field *f;
> +	int len;
> +
> +	f = __find_field(event, name);
> +	if (!f)
> +		return NULL;
> +
> +	return tep_get_field_raw(NULL, event, f->name, record, &len, 0);
> +}
> +
>  static struct json_object *num_to_json(void *num, int elem_size, unsigned long flags)
>  {
>  	bool sign = flags & TEP_FIELD_IS_SIGNED;
> diff --git a/cxl/event_trace.h b/cxl/event_trace.h
> index ec61962abbc6..6252f583097a 100644
> --- a/cxl/event_trace.h
> +++ b/cxl/event_trace.h
> @@ -25,5 +25,8 @@ int cxl_parse_events(struct tracefs_instance *inst, struct event_ctx *ectx);
>  int cxl_event_tracing_enable(struct tracefs_instance *inst, const char *system,
>  		const char *event);
>  int cxl_event_tracing_disable(struct tracefs_instance *inst);
> -
> +char *cxl_get_field_string(struct tep_event *event, struct tep_record *record,
> +		const char *name);
> +unsigned char *cxl_get_field_data(struct tep_event *event,
> +		struct tep_record *record, const char *name);
>  #endif
