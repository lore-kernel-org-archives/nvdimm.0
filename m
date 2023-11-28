Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6802339AC0
	for <nvdimm@lists.linux.dev>; Tue, 28 Nov 2023 18:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LtEKrOiq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701195543; x=1732731543;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6OMv5M3y2FuFyTCERW9TPU9/ZbNfo2Nzw6BHkeBNxVY=;
  b=LtEKrOiqrNBuWinnObWBqI0JKtNarmSTyb0tze4qHeTqL3xOzsqoCXfH
   ckDRI0INDdCh0pdOsmi9JRjFcGET9ITiUaEwYlTtjANc0JFuk4zZx4nEj
   KhOeS7TPW/x0GotKv9a7xDEdziwfzAdElJn8CZ3k4vRQeZdAYJ2nYxceh
   P4joLLiqfCSLFjy0glGbWLaVi740ie0Fedbp/XRecDW6DZnXhmkQrrEvb
   6jORxvBqYNqZPffgo6Ff39Bdt9aMsTSndjPsaF6KWZm4Ziw0HJoTswYlV
   UMK8gJdA3C3CzuAqqGFFq9vlcjD67JFjtN3OfBVycMqsf6N7EcndRQmSh
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="390138774"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="390138774"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 10:19:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="803024390"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="803024390"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Nov 2023 10:18:59 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 28 Nov 2023 10:18:59 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 28 Nov 2023 10:18:58 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 28 Nov 2023 10:18:58 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 28 Nov 2023 10:18:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bXOJoRMg97aq/Alw7zhPG2fgggrD5qWQV+OkMHi8PJZDu26W6YLDLaUWhwo8Bt+2UtZDXHpOUTpt/j2kkzLz/V6L04OMQCZSUWjjREgfQrW4gKq0v8htlCHIf9/5x3lYn/e18R+NpdQp5fjk17HPDov/LewLVWgtGuUNZFMu68gz0zqCwwem5mDn39QvMFiGvWZSQXWa5YncoU9xuYWPlAQxOklD3s4S6XwaH6eAn3c4eluIOgilT4gu37f/lfkSBg62Rg3tF24bGNBemb42EmZG/IdF4C6yvAQQASWfcwfaQFiV79eKV7al78FoTaMAeBWl6JbKNUZ5fxHTvU5khA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZCZ6iozy+/XMm9UcGatsZ+gUfD1VqE0qNWyrS/8yb0I=;
 b=C7dFC+K1M+G8qApjmGXGwoJmlkE+KcrPUUcrjSbpCrn4kO9WpY7keqsP8yq9QMdCz5ZoStS5Xgurz6isMDLBoa2l/pbsf8Kn+vxnHLb0JhCiZtXhJq3bKkJZanFDyo5eIhOyxhmA1arICoCubwodXY+HjB39EDs65N2uV3U8U/5oOS8LATV4b0m5qjzAaInDaqFIfZ8pXUWirjFQvvfgdT4ndxchwbve5NoWuMzcHjXn1uAzjhmwXi6kEOcW3t5zyUK7Z0/FBYUewiKbooHOk2h3GjdN05P6/6HeSQFfntulvjxvpRXouILzfnBhDYc9g+5wHkXh5kvu5B/uyCrIvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by DS0PR11MB7959.namprd11.prod.outlook.com (2603:10b6:8:fd::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7025.27; Tue, 28 Nov 2023 18:18:57 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::6f7b:337d:383c:7ad1]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::6f7b:337d:383c:7ad1%4]) with mapi id 15.20.7025.022; Tue, 28 Nov 2023
 18:18:56 +0000
Message-ID: <4a3177ec-834b-41f9-b065-f27410a1b8c7@intel.com>
Date: Tue, 28 Nov 2023 11:18:53 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [ndctl PATCH 2/3] cxl/test: add a cxl_ derivative of
 check_dmesg()
To: <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
References: <cover.1701143039.git.alison.schofield@intel.com>
 <39c11efdefeb12c3c928f36e9c59eeb40a841e72.1701143039.git.alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <39c11efdefeb12c3c928f36e9c59eeb40a841e72.1701143039.git.alison.schofield@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0122.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::7) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|DS0PR11MB7959:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a7d16a7-99e1-477e-0d3b-08dbf03e7c52
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bu0QnOfYXSb3aV8ZKNLA8yYaS0hyDxqCdBGXOGVJDJbFIPGpBIIlNE9ZxDaiWf8RgtlZxFsJ4q+BLNtkRwtBdZjG21UcQL+Lo8j6NhChFwMYnU3VfIb6O40yxi/34mVZUQz2EtLD8I7GVFa+nNN0/hmiNmCWZEpclTlKV3f1T7PSOlvsfMAzP0KmQ/IG6UjBpKD2PXm3MK+de/1LxWjA9RyX6CpiIt9l7ltKGR2DuIBBVJRoFO5Rz72evSv8zrLKUFj8v1RUdmZ1ddrbHapd+HXCCmZKusVIbVLe+/XddLrVTrE7YUsaNDyXlBt0wGMXeDoxZ3RzWk7iPc4dPZmWdL8FiQh7ka5cvVfmAzGA8qAuqQQpjMQXX2u2Ha30CApy8YLrmYpqs2wIPxKxaJORePgp0DLVRzUjtkRqxTmjrUKQYbC+d1IijGVo70FUFcBo9bATZNSmVsUTDjZ8ziVYqTiAArY/5b9MtsJnzApUzf71NdTNLii0LUSpRROEifnMnlaaGpyEIV4sn5mlTDFrhO2RX+DTCCKoHObwHUHdSm/IE3LwtikCCK06E0DL4wnkIElTbGnqF3sh2goniOKcSyzz0RQmc7U/F6xsVri38F7wuH6srJAswvZXlinOkfUG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(346002)(376002)(366004)(136003)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(41300700001)(6506007)(53546011)(38100700002)(2616005)(83380400001)(6512007)(6862004)(4326008)(44832011)(2906002)(5660300002)(8676002)(316002)(6486002)(66946007)(66476007)(66556008)(37006003)(478600001)(6636002)(6666004)(82960400001)(8936002)(86362001)(31696002)(36756003)(31686004)(26005)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjBGZVJSZTh1SEdMRzQ4aFdJTkxYc1o2N1pvclowTjhNaHEzZ3ZqYnV0MGt2?=
 =?utf-8?B?N1lvTXVQcVlWNFU1dHgrSENSWDhjN0ZXc1BKZjRKc2FkdlArZDViZ1pYTWcr?=
 =?utf-8?B?TlZHQkkvZmh1dzE5SUlsSWxHSllYU3pseXR2Z1ZwU3Q2NXRWcGc5VE1BbHl4?=
 =?utf-8?B?elZVOEw5MFNpTE1IeVNIOVNaVVN6VmRxWllTMW9HSDZBMWdTc3lWbm9ZVkVs?=
 =?utf-8?B?a0NacFhTUC93aXUyYzlxZ3lOazc2R0l4Rml2YjM4NmxFM0xWbnhrekRLVzZD?=
 =?utf-8?B?SmxPbmgxMW5hV0FuTzdMdFZ0aEZwL3A2Y0JGT05DS3ZxYzkrcnZTSXVKdjM2?=
 =?utf-8?B?TlhhTFdDeW0xRVlEd01OMFlqYXFPd0RHMWJxT3VENGRGMGtlclQrK0N6TzhR?=
 =?utf-8?B?MFRYMU9wZ1UwSUFrM0JuN1VmekxEeis3SVd5eTduZk82MnJ3ZEhUWU80emdV?=
 =?utf-8?B?OCtjaXJtdUJwcVNkUlR0cGxEekN3Ty80T2RzdUk3M1FvSmxLbU1YV1ExSjQy?=
 =?utf-8?B?Y01xYU9ndU1yREhhNGFKMVBTVW9oMWw3ZjhvSUN1Q0ZLWjlDMGlPSkwwaDV5?=
 =?utf-8?B?dVQ1WXlqbTZUSzR2bXMyamUranZ0Qm4rZndlWThTcHR0NVZ0QkZyVkpsMG1E?=
 =?utf-8?B?OVlxbG9DMWlEcm9wZC9Kc0hNQi9wNCs1S3lweXVscTVqTEwxM3JpVEN0WTFl?=
 =?utf-8?B?aTNPZWp4b25iTE1TbDVDTEdIME83NVlFVHdCVHp3bjNXd3BEenpTUy9WSlhL?=
 =?utf-8?B?cDc3bGpYWEJjc3lLQno4TmRJdXFHNzIvN29OUDRlaW0xNHVxYU5KeVJUdVpC?=
 =?utf-8?B?OUNmUTBKV3NqYUljTEdYRHUwZ0xHVHZ2L2FvcUkvbjRWWkhjNEswMWpFUUhH?=
 =?utf-8?B?NVoxdFhXeC9sSytOcFMzVDJWNlRPREZoTW1WcjBWd2JTdzlGdkVaTmZ3YmpH?=
 =?utf-8?B?aEpxRU4zdklFZUNRM2l1VXd2T1lLY1BFMGdyUVJoYVMzZVU0YThIQnJJdFZ5?=
 =?utf-8?B?a1RrT0FGTkQybVB2NjV2Z1BaaVBNOXFacXYyRkNRVERWK0V1d3VualhzQjMz?=
 =?utf-8?B?NjNFSGVNUlhOTlRUOThqbS9wMWY1M2FPTDR4UUV2SHpyQVpwSTNReVRlQlBy?=
 =?utf-8?B?bUp1TmlmVVNGdHRWN21ZeEk1LzErMUV1MGhQUnlYbmVIZytScnF2WkduLzQz?=
 =?utf-8?B?UzF4czJlaEk5NG0zb0h2ZmhjOWw3S2NQQkR3TzYyQVNTcXZ2T0ZmUkdyZTVN?=
 =?utf-8?B?SW1GNEF0VUtzT1dqMURhVld6TnRLMUpsL1N3TGlVUWV1YkRQcXlGMWRyU2NK?=
 =?utf-8?B?aGZzMkMvanJ5Wmg1Q3RjZVY2ekp6L0hiMHdld2lUZE84M3dzMW5JQ1BCcFFx?=
 =?utf-8?B?QXpreDBIVGNuSlNOc0NYVlpMU0VmQ1poN09NdnpwVGxqV3c0RXd0M2tvZ2pu?=
 =?utf-8?B?cE0yTjM4NGFTb3FxT2xVbTlINjZFc0p6bDQxTk8zNWo4SXBNM1JPelRyUDBy?=
 =?utf-8?B?ZVhSMUFPZ0tadTVlNllva1NvWUQwVVg3V2xuSE9Gc2sxTWpacUw0bzNUVEdM?=
 =?utf-8?B?T1RhS0JQVWhhTjVlV2x5a0twUXUwZVdwQUYwVnE2OURPM1NQa1JnaFdEOEhK?=
 =?utf-8?B?NCtHamR5RVJtY1pXb1ludU1vYWltUS82TG9SanJFVlhnRSsycUpGTFdVak9o?=
 =?utf-8?B?T3VSdzdHS2dWdGN5ejZSNkpFTGdKaFltYkFINEdBN29ZZCtOWVhHaEY0cEkw?=
 =?utf-8?B?MExmR0dhL2pyRFRScWJUS1dkdHY4bkM2UTJOYkduTmh0bERZVVFESkpTNC9R?=
 =?utf-8?B?UjMwVXRSWGVnL05ScWlWRzhiMTlwSEpVbWJNSC9nMVJvZ1lRSW1CNlJ3cnpw?=
 =?utf-8?B?K3d0NHNIaXZSTWFiN3FqSlFTVmswTGtQZ3FKeElsUFhLMEJrYmIrdlE4aVQ1?=
 =?utf-8?B?a25ZeDBWWHhiekJpcTV3aSs4Mzloc1pRSTZEaXZhZWZMZ205RDFEMUZjcTZ2?=
 =?utf-8?B?UVpGcWxmNFdsOUZBUDRFT2xtRzZZZHJackZTUlpreDJXcjE1NENYUTZ2dGhG?=
 =?utf-8?B?QjBjL0toRFllNGh0WFVWZDZiMUUzVEVQV3BjRTZnVFFNTld5dk9UckI2bDJL?=
 =?utf-8?Q?ADSVSryQbm6oRovSABSt8R6yy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a7d16a7-99e1-477e-0d3b-08dbf03e7c52
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2023 18:18:56.9112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +3+2eLpMVVHPpDInaN4Rv2Y5w5ULrEFYzG5adDORNfpREycX95dhEKXsmmUHUeB08RB+xZ6lV+GHLY+jpOMXNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7959
X-OriginatorOrg: intel.com



On 11/27/23 21:11, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> check_dmesg() is used by CXL unit tests as well as by a few
> DAX unit tests. Add a cxl_check_dmesg() version that can be
> expanded for CXL special checks like this:
> 
> Add a check for an interleave calculation failure. This is
> a dev_dbg() message that spews (success or failure) whenever
> a user creates a region. It is useful as a regression check
> across the entire CXL suite.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  test/common | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/test/common b/test/common
> index 7a4711593624..c20b7e48c2b6 100644
> --- a/test/common
> +++ b/test/common
> @@ -151,6 +151,19 @@ check_dmesg()
>  	true
>  }
>  
> +# cxl_check_dmesg
> +# $1: line number where this is called
> +cxl_check_dmesg()
> +{
> +	sleep 1
> +	log=$(journalctl -r -k --since "-$((SECONDS+1))s")
> +	# validate no WARN or lockdep report during the run
> +	grep -q "Call Trace" <<< "$log" && err "$1"
> +	# validate no failures of the interleave calc dev_dbg() check
> +	grep -q "Test cxl_calc_interleave_pos(): fail" <<< "$log" && err "$1"
> +	true
> +}
> +
>  # cxl_common_start
>  # $1: optional module parameter(s) for cxl-test
>  cxl_common_start()
> @@ -170,6 +183,6 @@ cxl_common_start()
>  # $1: line number where this is called
>  cxl_common_stop()
>  {
> -	check_dmesg "$1"
> +	cxl_check_dmesg "$1"
>  	modprobe -r cxl_test
>  }
