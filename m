Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA5341C94
	for <nvdimm@lists.linux.dev>; Tue, 28 Nov 2023 18:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J5GHhAAW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701195302; x=1732731302;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qlQzgx7i4L6QyAS+INgqIRHOtqwy/5qJvHKU5Aa7GkY=;
  b=J5GHhAAWVpdzqlc5nD7B3TydF6VySyefnRM8r58gMCvvkJvxS2N9uH7P
   BE757j8xdDkE6xJEq4BAPBkrmpuFjERBMHrWO97PPdBPF0KSwIkZkvxT8
   ivO3GQUH+uPuerCwlPqPnc6MGVlJWheZmkvid5DWyl8zX3UXwBp4bzv0c
   xPB9HlC2AS/jUfmQE+tz3aHVQwhko1vw2XlCbXa/3u4yvFAQbOe8KtvOc
   OJmKwXhQdD9IHobO9mCDf7kMFnbt3XJHhL4uZplmSr9ZeeAw8FmZnB2YD
   XQtlHPkNsfmuMFfqiHcRcFIvhqCDrPKBakBK1TPNGAs1pc9rxwg1Q5qQS
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="378010245"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="378010245"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 10:15:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="912527079"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="912527079"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Nov 2023 10:15:00 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 28 Nov 2023 10:15:00 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 28 Nov 2023 10:15:00 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 28 Nov 2023 10:14:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FOFBeTRQfNK5q6ri3O/rFpTc/aSPNQTEXKqa5xlBoK1PKIj7kB5CcYc5Pk8l0MMfMfD7lfG5+No2PVE5vSxEiQIzBw5GvBss9UOYTcIgw7hN3cS+mMiSBnYrI54ZrWO68LG1W8swJ5RKFXDphKuEtiZdiWQW9qIJ+5hKlm8q4rQwNlp0/G7RgW0cumIU2iexaHKs2W/h0xTfPlGrDiy7UyuWDxkc5ICtF3dvFl9dA4CHxZbYg02ONZXfDSr5RsdufHiRStJUQIJQVEdDV4v6ihL/TdH32jkEg90H2R2iYs0IDrizSOiJkIfKrf+bCoE1niZasTVEtQbq2OHK/waiqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bkxaXFRmHsX6oLE0O5vmHzPDHZTah/wAh4ARSNjkVWI=;
 b=YwknYQp/6Ltu0gu6Yei8FuWVGjMcsXNcxVpEocpTxAGuRAy5aGCXK0Pfp51CB4SGtKx9TR65p1AkMyBNYxNKui2QYq7AcpXgmYpJYFXJq0JYgYIxmLjvo8E5a0jnRikMf1IdvTnZ1VUwjrTMIb5tbwRpFi91bDGOcjseCXXsPRUDXNRSEWarB/FDXPgzoltRgINGN2p7xliin9Hxou1q20WJ68MztXgBrSelc9GO4aB1zxQxjDgDthXV+cz0y916CHmlT/QZ1SXy9n7aol/9Sx167XmGSksKlLOYUsPaPDafZUwlUU/gGysBDE1E+ha13oYQBFevnUdiG8Sz2Z/eoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by PH0PR11MB7470.namprd11.prod.outlook.com (2603:10b6:510:288::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29; Tue, 28 Nov
 2023 18:14:57 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::6f7b:337d:383c:7ad1]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::6f7b:337d:383c:7ad1%4]) with mapi id 15.20.7025.022; Tue, 28 Nov 2023
 18:14:57 +0000
Message-ID: <c5629492-859e-4ebf-b98f-399b46e3952d@intel.com>
Date: Tue, 28 Nov 2023 11:14:55 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [ndctl PATCH 1/3] cxl/test: add and use cxl_common_[start|stop]
 helpers
To: <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
References: <cover.1701143039.git.alison.schofield@intel.com>
 <d76c005105b7612dc47ccd19e102d462c0f4fc1b.1701143039.git.alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <d76c005105b7612dc47ccd19e102d462c0f4fc1b.1701143039.git.alison.schofield@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0058.namprd07.prod.outlook.com
 (2603:10b6:a03:60::35) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|PH0PR11MB7470:EE_
X-MS-Office365-Filtering-Correlation-Id: b8ee0dda-bbd5-4d31-f59a-08dbf03ded9e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e7jMcJKzgo6NAyri7R4Pnm6iAoWJVh99x+niyvtQJyvjhXtWBkPgP3Y/021gZpzSGcV1e9EqN72QzBMzGvRKFcfkJUgiBtmni2ZArTqEFVTlBtlPr1JueKnqNLjU2Sg3apLsD7iZM7mWZz8DOhExx/qfsVaACfRL1DxwNpQjoID/j5H2PO3dqL6fJiHmhRIy4HE4waFHyPqKqgUaE30e6Ch4yWTdH4vW5DHgMj9MKsCjVoJUgxWJaLslFoMGXYd/s5Y2dxV7p8uRqTuXSgKGyUmDEF9b7OJjAreqcDFeE/rJmZSQcJ4JrtkJZsLkAy9AIJSSUQAW+V+QMvn2wF1aP3MrvFlgJotGrDQeXMUaFLoeaKV1WvFOIUCVcOLeg8hLAkpG5RMZRAo8CxGJgr2ADsTN3L0eupxiE9QO/OsIjM7TNqksteQ6bfC1hhFxKjyBkojT/DzQY76s0wbf4R9qujXav7pF0S29vUsi9dBOaOyQpUZK/FMBaWQnMPKkwj+wNdB7gGqPoX6aOlXBdDHHTnpQ6NPhyGlBbJ6QKzedyZ1yPnQj2abR80dHoxmmN7Ykf2jahECw6aCa9Nfq/XRJSjXkhDALgy7OvBr8fuOMMF1hoF9MH+bIpdeZHNBmaAHk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(376002)(136003)(366004)(346002)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(26005)(6506007)(2616005)(6486002)(53546011)(6512007)(41300700001)(5660300002)(6862004)(8676002)(44832011)(4326008)(6636002)(2906002)(316002)(8936002)(478600001)(83380400001)(66476007)(37006003)(82960400001)(66556008)(36756003)(31696002)(86362001)(38100700002)(31686004)(66946007)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VGQxWStWS2R2RnhWUVlXdHpZcFdQSlc5dFRKR1pxelFZeFFrLzdhYTFhWU4y?=
 =?utf-8?B?VGo2akdOUTlQUHgyYVRHYms1cm82UmRYTU9OUGhVL3BidUJBWjhKWFdiNnlG?=
 =?utf-8?B?RUpxa3dSdEEwOFY3ekJEaUpvWmI3QlZyVGRZSVErcDNISU9PSUNTM0E1dkpx?=
 =?utf-8?B?UnNKRER2UHVDZHFQQUROZm5kcHNmUjd5bTRNMEVtaEJva29pbXpaVHJRMzEw?=
 =?utf-8?B?MnJ2dk01cFY1d1gwZnFZbkhhMG5rcWt5QVFYSU1lV0F0U3MzTFdBWjczYk1D?=
 =?utf-8?B?OER3bUR0eHVrUnFBRXdWMnBqWFV4aTdIK1QwSnRTZjF5dTZZY0k4RjYxM04w?=
 =?utf-8?B?VTdTRlVQYkNpZVhzbjB3d2htdW5aSUw2a3dUd3h3cCt4Tk1uUEFsOTJCMjVY?=
 =?utf-8?B?V0RiNjNvOW1MUHpFT3d0eVRHa3ZjVDFmeWw2K1EyTHhQd3llMHdsTlVORHho?=
 =?utf-8?B?dWxxc3Y4WWhXUGpLQ1dtSUpncTlKTWp5ZlRuenF1ZTMwUVdYT3VwbTlBb28z?=
 =?utf-8?B?RHhzYzRuYlk1WFRMNE9FZUtVYy9CRmI5SHYxU2lvbTV6bVFudDJ2bVJXa2dr?=
 =?utf-8?B?TVpJS1hsUTdwbXpxc3pNdy9rVW0zVjVqazhja08vemdqOTBNQ0ROUjg0UnJr?=
 =?utf-8?B?YnNseVhvTHVwaG9NMDM2cTAvOVdXSkhkOE5ZK2hLWGptZGFyT2pzL09xNWhL?=
 =?utf-8?B?U044ZHQvYVVCalVyZzhLcE5ZUWJFU1B0dTlzZTNDTjZyRnJlSC92V2ZDVXp5?=
 =?utf-8?B?Q29EVHJjOVkzSWVlRzVsUmFVaFZEUlJwV1JqaVE0c0FUb3ZUaDRYN3k2amt5?=
 =?utf-8?B?UElDSUVxQ2VHL2VNVXltOFl4bVRzeDZ5UmhidjFaVXN1UVowZy9tSk1YQWFO?=
 =?utf-8?B?VVBzeWUxN0hlcVhpNnlhaFNkODhLTW9KWEFURy9EenJDWWtzekp2dGJnbE5x?=
 =?utf-8?B?MFd3VWNiSDdkcWpJUVozcXZjaEF0WmxxWkt2R3ZMRU5pM2pScG5UY3pncm0z?=
 =?utf-8?B?b0ZxL3paQWFBTmR6VzRDTnBPTHN5bEVHVHd4K0g2a2VHekZRWHFrMEJjd2RY?=
 =?utf-8?B?Nm12aUNmQWN4RE8yTkJoQmNsZkcvNVNkYytJaG1TbDdBNlZERm1sWFIrTHZs?=
 =?utf-8?B?NmNXZVNRTkQ1a2Y2cHhwdjEveTFQYzdOQkhKTXFLOFNZWEZ2SlNxTHhGdlI2?=
 =?utf-8?B?L0FaVWNxZGc5QzZsSmJ4eXcxOTZJVSt1c01PWUo1WEJFdmxLMVhxUjdiV1U0?=
 =?utf-8?B?VHNsQUNyVEQ5TjNBM3J5Si9IWlc0Y0duZFdLbE1BOVl4QStMblJNM3N0dHVr?=
 =?utf-8?B?SDI4VmxEaHk3VUxySDBDTld3ck1BT2RuU0lqeCtEaC8za2xVSmkvS1VTRXZp?=
 =?utf-8?B?RFlMYk5Idy8xOHc0ZFRWenZnNUhTS1BTRHRIeWZGODBVMVhNRWhGYzNtVnEw?=
 =?utf-8?B?Q0JLTGtGVlVPSEpubmUvNFltT2FUSUFGNmhkMERvRUxTdTZIRFBDVXhwQzJ2?=
 =?utf-8?B?TVFoNlNLcFhlZmJkQ0lZSnZvMnFVYUliNXlPdEZ3ZVF6UnlJZmRWK2dzempN?=
 =?utf-8?B?Z1dRY0FEWW5YbmRZSW1YSis1NWlwbm0wK0F3SzJoVVNpRzhJNnladTFLQm1F?=
 =?utf-8?B?aGVEbm1KR0Z2eUo0MlJaUHZqS2VvZGx1azFCZ2VpSEY4K2hhcElRdGp1Ujl1?=
 =?utf-8?B?OXlKc2FZWUFGMkFsUFpjVUtVVCt5d01JQ2xzOFZWV2FmMTMwU1hJMEpsVmZr?=
 =?utf-8?B?RXp5cGFPOWJuK3hVcEN6MnI4QlJSWlA0MHNmRXZML2doZGRpUWs5elZFSU9L?=
 =?utf-8?B?V3JRUGJqVlRWLzBEeHNGZ3hoMWNuWDZ2SWJnZi9NTTRDQ2drcHd5ZitvTlpQ?=
 =?utf-8?B?b245YWxsRlFFMFUyR1NubTkrL0MvRG1SeDFndVJFb2Z4SWhuT2xKbTk2VDZL?=
 =?utf-8?B?d0s3YnNxZ1RyaWNJQ1pLY3FsRDBiMEVmVGVlTEtTUnhJWndBUUpoNExQU0cx?=
 =?utf-8?B?ZWlFTjltdnVRQ0hScGJ1dVR6R0NvSVMzczJQYWthaE5JNllXQ0ZDNTdielh3?=
 =?utf-8?B?UStBV2loVGtDWEpPZ2hUQ2Z5a3pxOEZwMGk1Q3VJb1dyZDc2MmJjeElXVjhn?=
 =?utf-8?Q?epAruwwHC4CPVCUDaRF6EWNWs?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b8ee0dda-bbd5-4d31-f59a-08dbf03ded9e
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2023 18:14:57.4312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PKHrzURp8A+UbRueJQHRZx3Kk0IYMDSFX5q4T2IikotBHGPLZPUu0hsC+izqg6hejCWW2o1lDEJ49GrrxNYXBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7470
X-OriginatorOrg: intel.com



On 11/27/23 21:11, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> CXL unit tests use a mostly common set of commands to setup and tear down
> their test environments. Standardize on a common set and make all unit
> tests that run as part of the CXL suite use the helpers.
> 
> This assures that each test is following the best known practice of
> set up and tear down, and that each is using the existing common
> helper - check_dmesg(). It also allows for expansion of the common
> helpers without the need to touch every unit test.
> 
> Note that this makes all tests have the same execution prerequisites,
> so all tests will skip if a prerequisite for any test is not present.
> At the moment, the extra prereqs are sha256sum and dd, both used by
> cxl-update-firmware.sh. The broad requirement is a good thing, in that
> it enforces correct setup and complete runs of the entire CXL suite.
> 
> cxl-security.sh was excluded from this migration as its setup has more
> in common with the nfit_test and legacy security test than with the
> other CXL unit tests.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  test/common                 | 23 +++++++++++++++++++++++
>  test/cxl-create-region.sh   | 16 ++--------------
>  test/cxl-events.sh          | 18 +++---------------
>  test/cxl-labels.sh          | 16 ++--------------
>  test/cxl-poison.sh          | 17 ++---------------
>  test/cxl-region-sysfs.sh    | 16 ++--------------
>  test/cxl-topology.sh        | 16 ++--------------
>  test/cxl-update-firmware.sh | 17 ++---------------
>  test/cxl-xor-region.sh      | 15 ++-------------
>  9 files changed, 40 insertions(+), 114 deletions(-)
> 
> diff --git a/test/common b/test/common
> index f1023ef20f7e..7a4711593624 100644
> --- a/test/common
> +++ b/test/common
> @@ -150,3 +150,26 @@ check_dmesg()
>  	grep -q "Call Trace" <<< $log && err $1
>  	true
>  }
> +
> +# cxl_common_start
> +# $1: optional module parameter(s) for cxl-test
> +cxl_common_start()
> +{
> +	rc=77
> +	set -ex
> +	trap 'err $LINENO' ERR
> +	check_prereq "jq"
> +	check_prereq "dd"
> +	check_prereq "sha256sum"
> +	modprobe -r cxl_test
> +	modprobe cxl_test "$1"
> +	rc=1
> +}
> +
> +# cxl_common_end
> +# $1: line number where this is called
> +cxl_common_stop()
> +{
> +	check_dmesg "$1"
> +	modprobe -r cxl_test
> +}
> diff --git a/test/cxl-create-region.sh b/test/cxl-create-region.sh
> index 658b9b8ff58a..aa586b1471f6 100644
> --- a/test/cxl-create-region.sh
> +++ b/test/cxl-create-region.sh
> @@ -4,17 +4,7 @@
>  
>  . $(dirname $0)/common
>  
> -rc=77
> -
> -set -ex
> -
> -trap 'err $LINENO' ERR
> -
> -check_prereq "jq"
> -
> -modprobe -r cxl_test
> -modprobe cxl_test
> -rc=1
> +cxl_common_start
>  
>  destroy_regions()
>  {
> @@ -149,6 +139,4 @@ for mem in ${mems[@]}; do
>  	create_subregions "$mem"
>  done
>  
> -check_dmesg "$LINENO"
> -
> -modprobe -r cxl_test
> +cxl_common_stop "$LINENO"
> diff --git a/test/cxl-events.sh b/test/cxl-events.sh
> index fe702bf98ad4..b181646d0fcb 100644
> --- a/test/cxl-events.sh
> +++ b/test/cxl-events.sh
> @@ -4,24 +4,14 @@
>  
>  . "$(dirname "$0")/common"
>  
> +cxl_common_start
> +
>  # Results expected
>  num_overflow_expected=1
>  num_fatal_expected=2
>  num_failure_expected=16
>  num_info_expected=3
>  
> -rc=77
> -
> -set -ex
> -
> -trap 'err $LINENO' ERR
> -
> -check_prereq "jq"
> -
> -modprobe -r cxl_test
> -modprobe cxl_test
> -rc=1
> -
>  dev_path="/sys/bus/platform/devices"
>  
>  test_cxl_events()
> @@ -74,6 +64,4 @@ if [ "$num_info" -ne $num_info_expected ]; then
>  	err "$LINENO"
>  fi
>  
> -check_dmesg "$LINENO"
> -
> -modprobe -r cxl_test
> +cxl_common_stop "$LINENO"
> diff --git a/test/cxl-labels.sh b/test/cxl-labels.sh
> index 36b0341c8039..c911816696c5 100644
> --- a/test/cxl-labels.sh
> +++ b/test/cxl-labels.sh
> @@ -4,17 +4,7 @@
>  
>  . $(dirname $0)/common
>  
> -rc=77
> -
> -set -ex
> -
> -trap 'err $LINENO' ERR
> -
> -check_prereq "jq"
> -
> -modprobe -r cxl_test
> -modprobe cxl_test
> -rc=1
> +cxl_common_start
>  
>  test_label_ops()
>  {
> @@ -66,6 +56,4 @@ for nmem in ${nmems[@]}; do
>  	test_label_ops "$nmem"
>  done
>  
> -check_dmesg "$LINENO"
> -
> -modprobe -r cxl_test
> +cxl_common_stop "$LINENO"
> diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
> index 8747ffe8cff7..2f16dc11884c 100644
> --- a/test/cxl-poison.sh
> +++ b/test/cxl-poison.sh
> @@ -4,18 +4,7 @@
>  
>  . "$(dirname "$0")"/common
>  
> -rc=77
> -
> -set -ex
> -
> -trap 'err $LINENO' ERR
> -
> -check_prereq "jq"
> -
> -modprobe -r cxl_test
> -modprobe cxl_test
> -
> -rc=1
> +cxl_common_start
>  
>  # THEORY OF OPERATION: Exercise cxl-cli and cxl driver ability to
>  # inject, clear, and get the poison list. Do it by memdev and by region.
> @@ -153,6 +142,4 @@ echo 1 > /sys/kernel/tracing/events/cxl/cxl_poison/enable
>  test_poison_by_memdev
>  test_poison_by_region
>  
> -check_dmesg "$LINENO"
> -
> -modprobe -r cxl-test
> +cxl_common_stop "$LINENO"
> diff --git a/test/cxl-region-sysfs.sh b/test/cxl-region-sysfs.sh
> index 863639271afa..2c81d8f0b006 100644
> --- a/test/cxl-region-sysfs.sh
> +++ b/test/cxl-region-sysfs.sh
> @@ -4,17 +4,7 @@
>  
>  . $(dirname $0)/common
>  
> -rc=77
> -
> -set -ex
> -
> -trap 'err $LINENO' ERR
> -
> -check_prereq "jq"
> -
> -modprobe -r cxl_test
> -modprobe cxl_test
> -rc=1
> +cxl_common_start
>  
>  # THEORY OF OPERATION: Create a x8 interleave across the pmem capacity
>  # of the 8 endpoints defined by cxl_test, commit the decoders (which
> @@ -163,6 +153,4 @@ readarray -t endpoint < <($CXL free-dpa -t pmem ${mem[*]} |
>  			  jq -r ".[] | .decoder.decoder")
>  echo "$region released ${#endpoint[@]} targets: ${endpoint[@]}"
>  
> -check_dmesg "$LINENO"
> -
> -modprobe -r cxl_test
> +cxl_common_stop "$LINENO"
> diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
> index e8b9f56543b5..7822abada7dc 100644
> --- a/test/cxl-topology.sh
> +++ b/test/cxl-topology.sh
> @@ -4,17 +4,7 @@
>  
>  . $(dirname $0)/common
>  
> -rc=77
> -
> -set -ex
> -
> -trap 'err $LINENO' ERR
> -
> -check_prereq "jq"
> -
> -modprobe -r cxl_test
> -modprobe cxl_test
> -rc=1
> +cxl_common_start
>  
>  # THEORY OF OPERATION: Validate the hard coded assumptions of the
>  # cxl_test.ko module that defines its topology in
> @@ -187,6 +177,4 @@ done
>  # validate that the bus can be disabled without issue
>  $CXL disable-bus $root -f
>  
> -check_dmesg "$LINENO"
> -
> -modprobe -r cxl_test
> +cxl_common_stop "$LINENO"
> diff --git a/test/cxl-update-firmware.sh b/test/cxl-update-firmware.sh
> index f326868977a9..cf080150ccbc 100755
> --- a/test/cxl-update-firmware.sh
> +++ b/test/cxl-update-firmware.sh
> @@ -4,19 +4,7 @@
>  
>  . $(dirname $0)/common
>  
> -rc=77
> -
> -set -ex
> -
> -trap 'err $LINENO' ERR
> -
> -check_prereq "jq"
> -check_prereq "dd"
> -check_prereq "sha256sum"
> -
> -modprobe -r cxl_test
> -modprobe cxl_test
> -rc=1
> +cxl_common_start
>  
>  mk_fw_file()
>  {
> @@ -192,5 +180,4 @@ test_nonblocking_update
>  test_multiple_memdev
>  test_cancel
>  
> -check_dmesg "$LINENO"
> -modprobe -r cxl_test
> +cxl_common_stop "$LINENO"
> diff --git a/test/cxl-xor-region.sh b/test/cxl-xor-region.sh
> index 117e7a4bba61..6d74af8c98cd 100644
> --- a/test/cxl-xor-region.sh
> +++ b/test/cxl-xor-region.sh
> @@ -4,18 +4,7 @@
>  
>  . $(dirname $0)/common
>  
> -rc=77
> -
> -set -ex
> -
> -trap 'err $LINENO' ERR
> -
> -check_prereq "jq"
> -
> -modprobe -r cxl_test
> -modprobe cxl_test interleave_arithmetic=1
> -udevadm settle
> -rc=1
> +cxl_common_start "interleave_arithmetic=1"
>  
>  # THEORY OF OPERATION: Create x1,2,3,4 regions to exercise the XOR math
>  # option of the CXL driver. As with other cxl_test tests, changes to the
> @@ -93,4 +82,4 @@ create_and_destroy_region
>  setup_x4
>  create_and_destroy_region
>  
> -modprobe -r cxl_test
> +cxl_common_stop "$LINENO"
