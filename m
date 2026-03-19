Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5323123958D
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 00:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773880781; cv=fail; b=rx9C+Y7gaqp8fLZR3482Mspjwvz2k9rpW1aHySIULNrogVst+K0HNtrIof94joexbIGiiOfll6VA3kqB6dlTZ5yw4Fl5vpN+ziM8njoi5v3HX221CoZsF6NpyN+WxT+GroEiic05TnCFQKR/VknlfA5bCOj6FFQR1v2p/WoTsLc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773880781; c=relaxed/simple;
	bh=XIXYF4aRmJLx1sKLMzoLaNyH3WC/qXabFySBl5PUmaM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ulRkS0KVHkmx06tpg1X/FhfdnWM6gh8Uq73HtuNHxRMilroZfDDt09SMo9laZ14n1qUN8E3eLSAm16Gh3ZA24/O7IkCKgn2lof2uBUolKpbvuAbqbDxgzM2+em6VevgdUkDzOSn9scF3JR8fdFa+02pIyHZVzz+UDQRTOylMRSg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OgQyaKqG; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OgQyaKqG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773880778; x=1805416778;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=XIXYF4aRmJLx1sKLMzoLaNyH3WC/qXabFySBl5PUmaM=;
  b=OgQyaKqG/yBf4/xEL973ElCJN6WhCNL3gJdnmtnm+wxhNIhT9avhS44T
   +mGMRqVdy10osCv5aA9mPSyDHUcmEOS1l6CSbZ6eMO46zmc+HEMeKpF3k
   uL0AFnio6kKHzSUZLm6o+BqFmluRPtvxKFgHzAL1rOH9dfqDP2fu+JZf5
   +JgLu/4mBlHR3Inl//O5qu+rDK/i/RKu3wiB03DBAT+efTBJ8Td/ULyUu
   8kddPKqvTiXpk2zeOaBNor8r60BBG7E67fafgoo9fh/EV0qgwmFKdg+jn
   Lin8+95++ulseB2PUAakDARf8rYSu/XZrUsAN445uWXPxtoJ0OS/bPgz7
   w==;
X-CSE-ConnectionGUID: PO1nXybeRm2VsohC5hE9ow==
X-CSE-MsgGUID: g21uImojR86ACUcP/hXi/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11733"; a="78555308"
X-IronPort-AV: E=Sophos;i="6.23,128,1770624000"; 
   d="scan'208";a="78555308"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2026 17:39:38 -0700
X-CSE-ConnectionGUID: XMs4XDviQI+4UY3Ca3v/DA==
X-CSE-MsgGUID: h1VbGaUVT2+vkVcDZBfdTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,128,1770624000"; 
   d="scan'208";a="227500952"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2026 17:39:36 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 18 Mar 2026 17:39:35 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 18 Mar 2026 17:39:35 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.47) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 18 Mar 2026 17:39:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d3Lpg2zRSxdxwGsRobcZ4zRY6sqF4laPXBvN2ijjiousVW8KdhXC4l4QeL+UK+P4A50HNFfN77XBcGeqz9QA7hvwu/2UdlTsZt3x7uvf0du9rqDqoTanO4HoJD6Fi8Wq0mVPiF5J8i6VuZpdmtGMkr91ArNIoH0O2xzU6ZPw67n2zsyhfhPlasZ3jqw+Gk3YFRuR1YgLWiY5IWZ7nD7+z6LNALPUFRTurgvHe4QfWhEFdFzB/9At16YHY2GovLqRP04T1Lb/NlDdBkcV2iGOfZYhorJfLQLIJ+opzYuKglP6H1XqVqNtZ/ZmysTJf1SRzrI+v0hSVkb3kNc3o1IevA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O3N+F8y2AYyqnSurXfc3NIO+/2aykdoRg6SvOxNOf08=;
 b=oC/YKRxO4Y+meSoHdni7VujzVwYMSf2rBUg+olS6LL9z7gAnjLVIqgNHxwUxcWkh3WBJwHm+IQxDVlwhL2Lx0mCY6JLm6gmike80mwWPYkAF/BbJYXgrXI3v5/HGLUAatoVEOeY1Dn/rK1OnOePQTRSl/vTWXh5NjuP/ALv3bVYnyoJCjCAQifNqf/g3GRg/0DG0072Iue7imyqt33Fvqq+HbUVlpkWq/WJoZuxM6LQ5T6u9G0rhHH4SOYfbwEuNj2TqomMGPvM4KXGOATQnpWMDg0a2I4xw8lMVJS2flOhE/fKGeqksN3dG6DmzB7FzqNM67m5nIOlUJ4T2qK+D7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DS0PR11MB7957.namprd11.prod.outlook.com (2603:10b6:8:f8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19; Thu, 19 Mar 2026 00:39:32 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::3979:c00f:fdca:b895]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::3979:c00f:fdca:b895%4]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 00:39:31 +0000
Date: Wed, 18 Mar 2026 17:39:28 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <cp0613@linux.alibaba.com>
CC: <vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 2/2] ndctl/test: Fix meson configuration error when
 fwctl is disabled
Message-ID: <abtFwETtDvWPlN5-@aschofie-mobl2.lan>
References: <20260310024102.25682-1-cp0613@linux.alibaba.com>
 <20260310024102.25682-3-cp0613@linux.alibaba.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260310024102.25682-3-cp0613@linux.alibaba.com>
X-ClientProxiedBy: SJ0PR13CA0066.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::11) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DS0PR11MB7957:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ec02368-8da6-46c2-f9ec-08de854ffbfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: mrB7uHAjtbgkLcepudSE5DbPk1Xvkp2aQfCzXiZEhIgL2OIpT6AkXou3X1tvzVZENlQgUqb15u9PyRm8F4VlXA1bn/hg5LqS9EkNQ/QYBR8e6WBP1AEr0+4Ysf1bgpSpctT3COcJ4vA3FzxF4r4C6Sg6/aZqj7rY5v8UNl6FFuK9WCJw5xXWOZoELUANRRawrUx0Hnrpdmac8qc64i6X5ILr/yM/WhJEN3Q6GhwhLruvmMPdY4oDW2uP7/rHspu4kWlywaK5fFMyZwVKZwT3CzYUPsVmWlgeOqrjBugJjGoeJRVrsId3aiQ2fXfK/csDcDyB/+KflYzAkTE8PyL/QmKPpfTK124x8vZtdH4fI0dNso8UCdmB9zUTgxxgQW/vu/Rzrrvz3iSgapPugMNnosJ12Ow70UgYz93pv5mKMnogeNpeDIfwvBfqdHFjuD0CbGmXWVcueipUeKfcfWeqmxVL3a3/XqU29335rbgEgKdBQloodmSP9+eTTj6neJeun5JXWVxD+1i+OWHN7rJXj0a/S4cfdsvNBYf3HvOMlLBdM0j4BGs3tElcDJcl13QO8WyuYuCBdVddtbPFnZDJciX6ZSMF47D1y88geTBIDpzyIZ1mf518YV+UUwfH2nZmyS/o0142wW3/bt+gHgep1Mpp9XJohVE5S65DmrJpPP6LEkhbcCIz1XS/goo3U4JysXOWXdtfhYMUBsbem60N91GpGqvzL2vJiGuNEN8wVks=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?htXhCAlgcs4CiJUFIZZDaWBIbG8pZ3LeBzZ1Bij9ZoyQZyXQAn8c8wTaq4kV?=
 =?us-ascii?Q?BC78qZQIC5ClrCx5g6FxL/xq/iiB8441uOgAT2CWDA0/lIOwfAMvTJkGgYXq?=
 =?us-ascii?Q?8t24TilvvqlI1Ei17DrfwvVblinvvIxprIdfkpfG+2mdPwT0mpwaqAjqx9Nf?=
 =?us-ascii?Q?zfaOhJXriMWA5xLdyuPZoxgzhkYmekIzWM3A2/Wi+Q8FtXFc3JpJ1Qk8dNJy?=
 =?us-ascii?Q?8ZL0GgoKfFQGuS22TIQhxKaNkVpzElFWem+OUJhA2VOYdYhrWxbNq3WUAWOf?=
 =?us-ascii?Q?cfeF8k/Qryek7r033yRsEbL0Hmmcy9ibWBotfus7SHNZSRWDzMjyR2CQc/28?=
 =?us-ascii?Q?FfLHCNgH7NCVYJSdjhVmiz9a4sE0b+VZ1GSGmsI2RR0HFmgJV+r4jtpCZ+HS?=
 =?us-ascii?Q?J7YRc5EzKgSw8+AcSJevtrhSzswhsmk1+GlxDP45ci6eUgodetO8EWb+2nGu?=
 =?us-ascii?Q?l3MXRJ0RrhbA2Ao96wk+JkvxmYL0qw2noe/2zHg+DQ7eAZDy2kNVyTp0MbQa?=
 =?us-ascii?Q?s/ywiZPKZljk+AKVkgNPEbAgsDs81F2hJJ3DUmHFkQXdSbJaNJOSyragLcCr?=
 =?us-ascii?Q?qJoK/jTsz9d3vm5PZWzW9SHuuESCs47j3kt35G0ItQMqVRRtns3f21M3r/T2?=
 =?us-ascii?Q?0dMXK1icI+QuYgSGF6ngp2ye2M74QYC8cpLWb+QNTvgzAtwwSg1KfCwDOWK0?=
 =?us-ascii?Q?+sw2mnaWbvsHp039AJLXg60g45fGrpd06mgd1BE99hHvCa6BM1c0pbfvLhUd?=
 =?us-ascii?Q?MgHWQ3j+0eRMjFjtEBUtwcErHElPiozO0iGZfYv7kgVGVoVv5jNYWMDBYfEg?=
 =?us-ascii?Q?3xwuzDBVPqUBygT/DFjZcSTaXRfZnQlNjYbkxkZhy58LeRHdOOzhHK11y4VV?=
 =?us-ascii?Q?mJiiwFXRFbG6MdQmfqiISZESpAbwPRFfMgzqXs06bxdh++cc/Rg/UZr6d25l?=
 =?us-ascii?Q?KJ1UmhG2QPQomdiE8Lw5qQvO6t6ip64PAeVKuFCsOZkSB78Suvs31FO4f7x1?=
 =?us-ascii?Q?MdlTGNdQDX8BO099flQIuaz1mpC7n8noyUwTdbhmiNSZY7hquewnVUGQeIsT?=
 =?us-ascii?Q?Gc/r67SPYhTc2rrsMfQ00hVJs5R6MCaDO1jtlVHVrGnwV0cyBXQFj9WZ0C2/?=
 =?us-ascii?Q?t8qWgBhZ8MUDHBd3/IFM7ysSNeJER0L+yKTq6UlwWfW9ixPiwFoQfTeIv/KS?=
 =?us-ascii?Q?QVX3Dvk9hPwLCq3wkoCMG8fjMc4/XWVTHNq4lv2VLkoig9yas5zrNWU8WYBk?=
 =?us-ascii?Q?5wpwTCyxLAZugpkiBm0sj8hT03GLqnh9rG+a8SUrDaEbf7Umq2wvNLbwqeRn?=
 =?us-ascii?Q?DVsRj0vQpa2Qa2frkFPg5TDzdxh92HnfMdextGjH0tvptYn9xRMcDf03WSs0?=
 =?us-ascii?Q?luA1uKyne6jhtUHH+8Q3yqq0uj23KfznPtYpyXJMGHPQTxhqRDGCvCcVU6+y?=
 =?us-ascii?Q?tZxPiN57u/t0jaBTwqu/ew/ghdUCWUMU2Hk2GogOkiEC+6jMtQ7JWz3NaexI?=
 =?us-ascii?Q?2yvGe2jW4UY0AP7dYYqvNRxWPabLEyD+TI+LCT7PU3dO/xVFzbbgiVhout4p?=
 =?us-ascii?Q?y91b7wMaV15XgSCaPGOKIheFa/GEQkCki9jnIKA2sOiLPjUlHDjRSKjZfMVE?=
 =?us-ascii?Q?G5Y3ygI3be2dmXZH7lQSTnFsZ8ZdUAHYHjcFG8v9gaJKxkNaH39UxEOc7/oe?=
 =?us-ascii?Q?iJu0zuRaNf5RxBDXxKGzB2u6qE3frHl6dZOZz4PO9uv+9v8VLkJ+eV063QbH?=
 =?us-ascii?Q?3Os2D5r9ZYc/x5Y4w0MzDz8BMdnYUuo=3D?=
X-Exchange-RoutingPolicyChecked: Uh/vnINXF3WYd74hzRImwOjFIwUaiCooZVxYe2++fgKDuH4MNOT0GULcym7pa5GIGIh/bmnJhkoPKN5GAoZhNFN9n0yf3on+WmiZVt1iblhh5M9Q4mNu723+gkrsXbj5t7AtC8wFi4T4WUsvwQFO4kLa/iRMyB9NIalchEevT6MxQnN8jSBsakyFVr/i87D3RqVv8eXvwYwkpNqGhAtAbJ+fC+IIdmvSxf7phr3UpHLbjulRfDpQSpJDPgeneDVa/n1puTFVCFF+xuCw0C7PILgca6NJRsxO0SO9F4EISh6R375UItqPRqqQmGTdB1LHgNSzCzTWFnbWMd+EpIAzHw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ec02368-8da6-46c2-f9ec-08de854ffbfb
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 00:39:31.3649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IiHi2p6RRjCakmq7nHKL8x48jj9IsuMpNAkAK7ZNWNB3HVA3xdWwpLdWM5t5wY2R8gsTBjiMlYxwGjUwFw6iKVjKZhOF3Zf3iPjX6Aqg36Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7957
X-OriginatorOrg: intel.com

On Tue, Mar 10, 2026 at 10:41:02AM +0800, cp0613@linux.alibaba.com wrote:
> From: Chen Pei <cp0613@linux.alibaba.com>
> 
> The meson.build script unconditionally references the fwctl
> executable in the depends list of test definitions. However,
> fwctl is only defined when the fwctl build option is enabled.
> This causes a meson configuration error:
> 
>   test/meson.build:283:6: ERROR: Unknown variable "fwctl".
> 
> when building with -Dfwctl=disabled.
> 
> This patch fixes the issue by moving the test dependencies
> into a conditional list (tests_deps) that includes fwctl only
> when the option is enabled, ensuring all referenced variables
> are properly defined during meson configuration.

Thanks for the patch Chen Pei!

I've applied it with a minor commit message change:
https://github.com/pmem/ndctl/commits/pending/



> 
> Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
> ---
>  test/meson.build | 31 ++++++++++++++++++-------------
>  1 file changed, 18 insertions(+), 13 deletions(-)
> 
> diff --git a/test/meson.build b/test/meson.build
> index 615376e..a4e3805 100644
> --- a/test/meson.build
> +++ b/test/meson.build
> @@ -267,22 +267,27 @@ test_env = [
>      'DATA_PATH=@0@'.format(meson.current_source_dir()),
>  ]
>  
> +tests_deps = [
> +  ndctl_tool,
> +  daxctl_tool,
> +  cxl_tool,
> +  smart_notify,
> +  list_smart_dimm,
> +  dax_pmd,
> +  dax_errors,
> +  daxdev_errors,
> +  dax_dev,
> +  mmap,
> +]
> +
> +if get_option('fwctl').enabled()
> +  tests_deps += [fwctl]
> +endif
> +
>  foreach t : tests
>    test(t[0], t[1],
>      is_parallel : false,
> -    depends : [
> -      ndctl_tool,
> -      daxctl_tool,
> -      cxl_tool,
> -      smart_notify,
> -      list_smart_dimm,
> -      dax_pmd,
> -      dax_errors,
> -      daxdev_errors,
> -      dax_dev,
> -      fwctl,
> -      mmap,
> -    ],
> +    depends : tests_deps,
>      suite: t[2],
>      timeout : 600,
>      env : test_env,
> -- 
> 2.43.0
> 
> 
