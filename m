Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571A718C23
	for <nvdimm@lists.linux.dev>; Mon, 30 Oct 2023 17:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aH0Obpgk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698688727; x=1730224727;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7NBHHl6oRLqunbGhudoGfAT1jlp/0tMYMsAwvZ3jl+w=;
  b=aH0ObpgkNBGKiS5JEg92yk0jbeiqf7hVC9md6gBwVzD5FmgTiKXIFCeg
   gKeiToNfUvZVawfpgAUXgR/UZHFpvXlSR2GyDNssPKLQ0xYiWHQJNma7o
   K+OelMsxVLTD+SU8kKafsOdYqCBHnQ3UE+AMiqTnjApqs1CtIWFXyXfhO
   esAWXsvdo0yqMG5NgyNCw21Sff2KjwdaaewyqRgeFgiQzqLBqy0EBoO1A
   /9odfPTnPib9FxWeSky7W4zLsSa+NHnUeKzCUsSgJA1SKFEry1YsQbLTz
   8SOQ2cvykOsDBS8ZuTGd6pKqqSvwyinO5/XRvQQMD1pDTjOQoB7ydcg6A
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="970251"
X-IronPort-AV: E=Sophos;i="6.03,263,1694761200"; 
   d="scan'208";a="970251"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2023 10:58:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="795330878"
X-IronPort-AV: E=Sophos;i="6.03,263,1694761200"; 
   d="scan'208";a="795330878"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Oct 2023 10:58:45 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 30 Oct 2023 10:58:45 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 30 Oct 2023 10:58:44 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 30 Oct 2023 10:58:44 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 30 Oct 2023 10:58:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aHtLyDJLA3Y8bTZitkgG7ZDomOeHQzUQfHDT7QCLfMmK3be6PAn3RvuO9E0892WsPvcVePkAWks/3H/npoH8Cz6MdhBhmYZWxGOCkRn4pTFe9YkszuO2AC7nWqjdFSQWxV+Hrln5HImxRIfem3DydIx5IXyWZMOydH0DVaZ1sKVZ4iGbQoSvquDOMNJkQgIb3yb2BSEx6oNiTp8CFL2jH23vOkTKrwcMBV9teXwLyJoYl0dEXYD1nBmTzZb1UUeYhggBeflnlqzko7c0BvCMsVyeGuDhw9M8udapQC4jZUad6tu3/GAbLAiGA3UPYx32GmC2/WG4MgfWt+xOtYPsew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xBKyRvA+0n0ZlGtWKArmU9WvLt3fRLaKKiUrShZzQ2s=;
 b=AU0BgtpHL7mmKEWG2Q6tSWE63d5MLCuc9MrmybH+NTOusp+W4GIpKKAVUFrBi6R4okqVYb7xgPP8pbCk1k8I7nbS4OF+0I8vOYd3Q9gqE8xhBn47tm6HUBn1mbH/T6Wo3bUk5F+RrkaMsNHkkQG3tnYuJiFaovU2w5hV2Z1K+3nlTmthOVyY49EnzjrlQAc/sFqQbMlQRTgfIslEvc7GsnMnaSYiNrDRa5JzfPYoiikShldPah70MbPzCYYbfKLO24ikdZ+EoHQxsWH9FO5C8KBEJs3oy4v8UWwA+ASFV7v135k7zIBuWSJHdjhZFKDmkvZ1ZxO+P90LLTY3Wstm9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by IA0PR11MB7308.namprd11.prod.outlook.com (2603:10b6:208:436::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.28; Mon, 30 Oct
 2023 17:58:41 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::a353:a16f:7f8a:86aa]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::a353:a16f:7f8a:86aa%6]) with mapi id 15.20.6933.024; Mon, 30 Oct 2023
 17:58:41 +0000
Message-ID: <77008633-cc26-462a-a363-0270420b7cc6@intel.com>
Date: Mon, 30 Oct 2023 10:58:38 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [PATCH ndctl] ndctl.spec.in: Use SPDX identifiers in License
 fields
To: Vishal Verma <vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>
CC: Jeff Moyer <jmoyer@redhat.com>, Dan Williams <dan.j.williams@intel.com>
References: <20231026-spec_license_fix-v1-1-45e4c7866cd3@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20231026-spec_license_fix-v1-1-45e4c7866cd3@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0103.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::18) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|IA0PR11MB7308:EE_
X-MS-Office365-Filtering-Correlation-Id: cf0d7fd1-e15d-410b-e9af-08dbd971da00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lte+hPoyBEzc7XrTmtvFWvziAXz6Pii4gpoxmEc2Mfpmz4NNgopNnopO3wSSR3Ok7eEUqZg1f0h+yqJu0KIikRW41L/v00bmpqqGNLbq1laaO+E0HOrTsHHncYPLrR2r0Lm94gqoDj01AS9T1/YoPz0benimizNTYZRutR5szOCI2DVmCtP0mV3PVT9ur49MmUZV3639DlJcp6mJ2c3W7HPEvLH9czokC8NZhnHj1s62nlFFGWhl+2bEX6hKT9WpVULAhqYXDmpCUh4t1HkYQYnyfbZTWMLWyXUSR9ko1kylOfDPY6YMpPSlL8Muv6b7G4ebXrSz+eekvlbJ8i0bkElobUEo1n7VnuTAXRVBQGFZRVZt2j8DzZ3C3izbTXhmhpnbw85h71ylCUB2EezONyHIasKqfeLiS8toA2CwY2rPB7kqWgKjCIYRsgGipSNXZkwP+iBLI4SX5eA0en9XO8i636m5SzA5OBE61eBBkknJR35nE7+0Wv5i2SAtwEQi4/zvzBY310AuWnrKQtaisCzkKJqHDyWrsze18nFuFzRLkK/EZ0fV1Stra6yuXibx4le9v80AnF39hEznl9RirN0vddc19shtBD8mEk3oERGvW/ZdaOlHYHOSmHf6LAZlblQ+fnUt7n2zfp55hotO4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(136003)(366004)(346002)(39860400002)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(41300700001)(54906003)(44832011)(316002)(66556008)(66946007)(66476007)(26005)(8676002)(4326008)(8936002)(31686004)(966005)(2906002)(6486002)(5660300002)(478600001)(6506007)(53546011)(6512007)(36756003)(107886003)(2616005)(83380400001)(6666004)(31696002)(38100700002)(82960400001)(86362001)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3NaVWtGakV2Y2laUHlPeWwrWDgxODdCQ2liTXdYeDdnTDNJeWNkQjBVMlFp?=
 =?utf-8?B?a0FJZ1Uxclc4WVYzczIwcXVUTU5WdlpUcGFVc0tCMXBjV0lMb1RSTWYxWjFB?=
 =?utf-8?B?bGl5VlJVZm9GclZJY1RWYS9KbmhEWkNQOGNURzZIZWZkUThQOHNtNWJReFVZ?=
 =?utf-8?B?U3NqZnBvUEM5eS93TzBUdFFaUDB2T1lnckYrK1VEb3RSMU5jRURscjBSWVU0?=
 =?utf-8?B?Zm1DTTdteDl3ZTg5VUE4UjNpMUhzZGVuQlVFUmNraUZNWm1VY0M4b21ISXc4?=
 =?utf-8?B?dGFTbFgxcE9XdUZFYXhPTmI5YjQ4SW1nUmRJREZtYUxvUFdNaDlBVWxDQVBk?=
 =?utf-8?B?SElYdzFLa2dPTng5NVIxb2IrQjM0cDBSQW9CQnNPZnZtb1FyQ2Y4UUo0dFZx?=
 =?utf-8?B?ODA1dTFSYmhXU2hSdWRxUlZpaDFBNGNvcjdnaFp1TjJmdzJjVUtJbzFZYmFt?=
 =?utf-8?B?UjJkaTcvNEJ0bEJuSUszdUhabE1tK3BmQXpUbjlqbnNYTHc2TUw2OVBsZTEz?=
 =?utf-8?B?QWFQZ2ZYeGFSclRVRjlLSXpzS0ZmNVl6ZjJ4S2hTYTVDL1BwaHRBcE5Na2Q0?=
 =?utf-8?B?c3JBNlJSemgwZkp5N3J3WklaMUoxb1Z0bWw2TUVDWGtIdWkrY2xOZU5zYXhM?=
 =?utf-8?B?NnJjYnV4YVAzc3F2MVVXYWR3YkgzcVlKM1VWOG8rREsrQ2hnQm9ZNG5uSFpm?=
 =?utf-8?B?MzhIUEp2eEgyZ0JLMWhmTVF5WlFXd2FFL2tXRzh0dUdRNTJnQms0V2pqRHFO?=
 =?utf-8?B?YlFRS3lBeGw3OG8yRmhiRWpRdm9pUmdEdUwzODZvRno1MWNlcldyM0dGd3dX?=
 =?utf-8?B?RWsrSTgybjNFaVpCVDZ4MWNzM3EvanZVc083YXQzWnVCczgraVl6a0ZkL0d2?=
 =?utf-8?B?cHJOSVpoZU5ZRm40WUdFY0FRcWhVbXplZHk4Rk4zWFJvbUxQdFRueHZmbk5m?=
 =?utf-8?B?bkdXMmlFWUNlcnhhQUhSWTZ1dUFsTjVFZDhtSWNXc1ZNSnUrRmNUUWljRGQw?=
 =?utf-8?B?TzZIdTFvdnhVSHdaUm45cUp6aWpVUVRsMUFMSzZYVldsRExaR2pvWXA3dkNM?=
 =?utf-8?B?STNWNUVHTHBuU2E2L0pqWmhqblhBZi8zUitDU1E2OURzMThPZEtjbnkxZFNm?=
 =?utf-8?B?UWhlSk5JYW9JME5TM1VyelRscHh3ZGtPbXpSSDZUVFB1WU5ndS9aYjZka3hy?=
 =?utf-8?B?eXhlT1FCQnIyRTRFcmdXV3dlbTA2NzEwa1FTaWVwekhpajBvV3dIN3Z0Sjcv?=
 =?utf-8?B?dlZ4VHk4UEpjZ0twcUlMdWRYTXQzT1NydFFqMXdOWXN2MCtReEVxVXJGdVhk?=
 =?utf-8?B?MWUwOHpOQ1FycjRKU1hLK0JWN1dWaGhIcFBGSXVSeTl5T2pabXd5TmxoV1pX?=
 =?utf-8?B?OHd2MEI2SGVJdGZFYm9CVERma2FUaTRIMWtDZDNLemZveUtDQk80VmVrRmsx?=
 =?utf-8?B?cTY2TEFRZ0t5Q2JCdUJFcFBFdStvcW15MFl5QmVvSExNYWIzZDdlNzh6Znl2?=
 =?utf-8?B?Z3lhMW9xVW9Cam5rSXZiQnhxOXF6VXBNd2RQdEhEQzBDZVpmZjhyNVovVjVD?=
 =?utf-8?B?V092NGw0K0ZEcHhZbDRaMUdlMVNuajVEZURyL1NqcktOeGFjbnlQYVpZeHpG?=
 =?utf-8?B?bVlLdEF5ZklNZ1ZsenFXTHlHbmNZVmQ1SVlTdnQrbXprcFhyOHlyMUR5TVdN?=
 =?utf-8?B?RS9LaVJ6M1JNT0pPUTZhRGRxZlZSaXViT20vdWJNeTl4M2hHUXQwaDQ4QXZO?=
 =?utf-8?B?dUFmVE5SQW93M1RUWVVGeVBUTmd5b001R2lSd1hiWlNhbFB1RVd0VzJ0Yk9G?=
 =?utf-8?B?SFEwUUF4SkpreVJGK1g0S1pBOW9zRi83ZFVQV2lXc2VqMlFNUWJnQVZGM3pR?=
 =?utf-8?B?bXQyem8yaG1mQ21DNm14YmJjMVpwZXZxNkNBeXlBcC85YnE4SG1IK3IwemJR?=
 =?utf-8?B?OElrdkZYUENxQTd2YUx3OGhzZHRXWGwrTWN5N0lJWXNTeW0yKzhxZy9lMHpT?=
 =?utf-8?B?ckk5KzM4eldtbWVrQ0JWdVdGL1g5T3h0TUVMeTRZQVNVa2htdlZpZnpHMmZJ?=
 =?utf-8?B?RkJjTUtZVlF0a29HbjV4MXV3ZTJyUlVMdW1GT1BlQThTQ1IwR3dub3hDdDcy?=
 =?utf-8?Q?zcU/UJ7Io65jb7hpQy8rNsm2h?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cf0d7fd1-e15d-410b-e9af-08dbd971da00
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 17:58:41.6974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sJZICTV/2iQqQ0inzC+2ikmeKiQah+alCJcP9ZO6zAeP0nKwAhO2kYVPGkX6lbIqNB0W4qFQw8MqPwdao1yxbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7308
X-OriginatorOrg: intel.com



On 10/26/23 12:04, Vishal Verma wrote:
> There's a push to use SPDX license IDs in .spec files:
>   https://docs.fedoraproject.org/en-US/legal/update-existing-packages/
> 
> Update the various License: fields in the spec to conform to this.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Reported-by: Jeff Moyer <jmoyer@redhat.com>
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=2243847
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  ndctl.spec.in | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/ndctl.spec.in b/ndctl.spec.in
> index 7702f95..cb9cb6f 100644
> --- a/ndctl.spec.in
> +++ b/ndctl.spec.in
> @@ -2,7 +2,7 @@ Name:		ndctl
>  Version:	VERSION
>  Release:	1%{?dist}
>  Summary:	Manage "libnvdimm" subsystem devices (Non-volatile Memory)
> -License:	GPLv2
> +License:	GPL-2.0-only and LGPL-2.1-only and CC0-1.0 and MIT
>  Url:		https://github.com/pmem/ndctl
>  Source0:	https://github.com/pmem/%{name}/archive/v%{version}.tar.gz#/%{name}-%{version}.tar.gz
>  
> @@ -48,7 +48,7 @@ Firmware Interface Table).
>  
>  %package -n DNAME
>  Summary:	Development files for libndctl
> -License:	LGPLv2
> +License:	LGPL-2.1-only
>  Requires:	LNAME%{?_isa} = %{version}-%{release}
>  
>  %description -n DNAME
> @@ -57,7 +57,7 @@ developing applications that use %{name}.
>  
>  %package -n daxctl
>  Summary:	Manage Device-DAX instances
> -License:	GPLv2
> +License:	GPL-2.0-only
>  Requires:	DAX_LNAME%{?_isa} = %{version}-%{release}
>  
>  %description -n daxctl
> @@ -68,7 +68,7 @@ filesystem.
>  
>  %package -n cxl-cli
>  Summary:	Manage CXL devices
> -License:	GPLv2
> +License:	GPL-2.0-only
>  Requires:	CXL_LNAME%{?_isa} = %{version}-%{release}
>  
>  %description -n cxl-cli
> @@ -77,7 +77,7 @@ the Linux kernel CXL devices.
>  
>  %package -n CXL_DNAME
>  Summary:	Development files for libcxl
> -License:	LGPLv2
> +License:	LGPL-2.1-only
>  Requires:	CXL_LNAME%{?_isa} = %{version}-%{release}
>  
>  %description -n CXL_DNAME
> @@ -86,7 +86,7 @@ that use libcxl, a library for enumerating and communicating with CXL devices.
>  
>  %package -n DAX_DNAME
>  Summary:	Development files for libdaxctl
> -License:	LGPLv2
> +License:	LGPL-2.1-only
>  Requires:	DAX_LNAME%{?_isa} = %{version}-%{release}
>  
>  %description -n DAX_DNAME
> @@ -98,7 +98,7 @@ mappings of performance / feature-differentiated memory.
>  
>  %package -n LNAME
>  Summary:	Management library for "libnvdimm" subsystem devices (Non-volatile Memory)
> -License:	LGPLv2
> +License:	LGPL-2.1-only and CC0-1.0 and MIT
>  Requires:	DAX_LNAME%{?_isa} = %{version}-%{release}
>  
>  
> @@ -107,7 +107,7 @@ Libraries for %{name}.
>  
>  %package -n DAX_LNAME
>  Summary:	Management library for "Device DAX" devices
> -License:	LGPLv2
> +License:	LGPL-2.1-only and CC0-1.0 and MIT
>  
>  %description -n DAX_LNAME
>  Device DAX is a facility for establishing DAX mappings of performance /
> @@ -116,7 +116,7 @@ control API for these devices.
>  
>  %package -n CXL_LNAME
>  Summary:	Management library for CXL devices
> -License:	LGPLv2
> +License:	LGPL-2.1-only and CC0-1.0 and MIT
>  
>  %description -n CXL_LNAME
>  libcxl is a library for enumerating and communicating with CXL devices.
> 
> ---
> base-commit: d32dc015ad5b18fc37d3d7f10dd1f0a5442d3b7c
> change-id: 20231026-spec_license_fix-cfe7c9bf1a0f
> 
> Best regards,
