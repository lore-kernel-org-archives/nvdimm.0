Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD106AB9
	for <nvdimm@lists.linux.dev>; Thu, 27 Jun 2024 01:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719452305; cv=fail; b=LbWOWXIF31ItE8U6hN2elGZJowrb2Wopcew8ZEA92TiiPv/k1chjfEoKMZXZCvihHkm4IyO8zvFXfZmI4fFflr5SR1n4z5TVww14Hss5V4uDYVpCr8EVcuVJnr3Xhl8stffsEZk4eZ5ogiWWD0AoOW26ITI4hVqluBH5Lwpu5a8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719452305; c=relaxed/simple;
	bh=6EjFDSMVLwoa8Pp6MQCuTikXIAahnpeSEENcvFX/LR0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LWUnPNW0GQJNj2l7YeJTIfQM3gxs6LvhVYA3JHy7dFeSmaOWr+VAWV/nzZ6zLAQXdsZvw3cJ+Bz3KrRdoCBHTTvvd95/0nIo0a5m/mrnGlIk6CyniHvnsKWb+a5GuNKMwOOF53ZAtvBqzUu45TC1RW7tri9pak/WD3q2HNJ5QaI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TAU6YgXA; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TAU6YgXA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719452303; x=1750988303;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=6EjFDSMVLwoa8Pp6MQCuTikXIAahnpeSEENcvFX/LR0=;
  b=TAU6YgXAsZrg+VvOc4y1zWFvwbgW13xTYDFCyXeRplbJ8gym85UPJFqh
   LCPQN1y4Od7pqIeQBSHRg1BNo0NnMcXVjY6sILLNtOwUXr36Um7hzmmJ9
   IBi7EF332Fi4ZTo/MRxU+mTDJ5ALj1vQGtafVaxVSp/0eEXnhUbcZtThx
   xX0DXfEmTLAuNZHcTVce1MNZJdi0u9o7jGqs1pXmQIGfBwThP70/s5Ghs
   i9B0Ndhf8/v79t5w/lIvGuHGWOQMb4SZWZXlWS8SEkNyK+xCsBAiGoxKp
   90ImAm96mLpztUWK3mN5NW/VUb7q6vlZkQrHIFBwya8DX9J8873NmoFAc
   A==;
X-CSE-ConnectionGUID: iLvEf/YlSYaOm4zU4+2SYg==
X-CSE-MsgGUID: WxuLMSOJSzu4KENthaNi7g==
X-IronPort-AV: E=McAfee;i="6700,10204,11115"; a="16694379"
X-IronPort-AV: E=Sophos;i="6.08,268,1712646000"; 
   d="scan'208";a="16694379"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2024 18:38:23 -0700
X-CSE-ConnectionGUID: 8cSJSpu6T/erHyNegF9eOA==
X-CSE-MsgGUID: hZ4iYBgrR5+0UIskMuJFjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,268,1712646000"; 
   d="scan'208";a="44106192"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Jun 2024 18:38:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 26 Jun 2024 18:38:22 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 26 Jun 2024 18:38:22 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 26 Jun 2024 18:38:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bh3mMs6vB1VQsM35efzfGtSlpPZ88e4gt5d8+h88XCjZNRCpy1e222VrRyTzJDCSljNQCFUHAq1lctCllrQ7u5m3PmxIchGNPp7HcUuQfaVTCuHeCt6ic2Bwyrtw6ULGUOdkBj2EIgxoJayq1fgBVk79aT+HIuuIiqDNasE7fVvMtu4w2mn0B+HV8D1/v6rrGQecPnUzmzHOq+sOfrKfaG1qOhasVtSUIyOKFi0Ex+qGclQsl80Js1rapB8dPnh20XKf5erhUHNTOAKLXl5livmwy8IEgL9/QMO0Y3/NdY/iWpQ9o/SejTKAnnGQ65gaQf9yQ9cu1yRJJLEcEQLZRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EDBC3H6pky6Iq7zVJdUNWnRvVnMowFyTtHx89a3ew38=;
 b=LiHVNOd5RMagbhkr0VfGB2lY5N42YbftfRRRm6MavNNzZbbQ+i9nbDokZjaLiwUyhhC7EzhnsyVKywnpPg44Qj+2Iws+eOqFkMIcUZI2APOT3O2pXuPdF265MJkmKQGcnP9A5ycGCrrIo+pRdWUwAbOjLu2xqFydYbM9vDCviY7yuf0fi9lBfpNMw9vyJQcIWdtWbyvCERYhNcTboZzcEWgDNY5PRI5Sy+DhqENEQSy3om/tf2qZe0osLgzCCo1aVpny2ke20XDNqyDHQB0irgjssY5/wR7BOBMLqTHMv3uet9vGGHudmgtZjzLvoGdGGUhU2NwberlBsNTYQjLx2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA1PR11MB8325.namprd11.prod.outlook.com (2603:10b6:806:38c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Thu, 27 Jun
 2024 01:38:14 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.7698.025; Thu, 27 Jun 2024
 01:38:14 +0000
Date: Wed, 26 Jun 2024 18:38:09 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
CC: Alison Schofield <alison.schofield@intel.com>
Subject: Re: [ndctl PATCH] cxl/test: add cxl_translate unit test
Message-ID: <667cc281d0550_563929412@dwillia2-xfh.jf.intel.com.notmuch>
References: <20240624210644.495563-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240624210644.495563-1-alison.schofield@intel.com>
X-ClientProxiedBy: MW4PR04CA0036.namprd04.prod.outlook.com
 (2603:10b6:303:6a::11) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA1PR11MB8325:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ff9c05e-ad2b-4f8f-4a5f-08dc9649cfec
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?6wqqkBjuUTzddVmx1UB/v4miz4cGZszTEEEC9a8K/9xgYfnOyB1QpflkbT3G?=
 =?us-ascii?Q?SXeJoup8HhQ4Sz+Sdp9/KaOyFWZhMqv9f5qNEKjUXotxHavfOYWAmWH3KnQN?=
 =?us-ascii?Q?uyy9fjEreBrRjfZWmfxYuVb4VbyeX7Ynxtw0LOm+YfgkweGeoGR721+4ehYo?=
 =?us-ascii?Q?FT4MAFde8wfy9kOVvuHs07IiGWuCfYyfsb+RScZdwJnoz3FlTf0HiqbZl3tM?=
 =?us-ascii?Q?1Afnb0F8roi4LLPfDpnunt5LtXRS/uEyiq5r/QJfb+gKzmS41/md7beIMv4I?=
 =?us-ascii?Q?r6GLGJIaUEKy/CRfBWfRaAHOT1nVQ/dlyHOxN0pC1b1oSs4XwTOSSE+9DIKG?=
 =?us-ascii?Q?DpcC8KxK1QhV7FdUmIoBCnOWsBc47p72GvEXKQU4V+SiA83s4+QuvbV//m8r?=
 =?us-ascii?Q?h0lrUnqc4qOn6QliNrC5jLEyikUQlv3zdeTAa+LWRbNC5+P+lwHdSFBQ/thj?=
 =?us-ascii?Q?6JlgHg7mD5pKjUTFSBJEagetbb0HEl6pPt6T9Nt00+6rVnQ9YZ27gGwQ9HnG?=
 =?us-ascii?Q?hlZfz/5wu50Y0B0VfVNbOBi1/zsKfxrpjSPdibPwLwpUM2lkLCUMGP8HWRxN?=
 =?us-ascii?Q?wkrB8cJ1Ga8WpmKslIEqmi/bWDm6c5nqVMD8ImHqCPNqcI0N2RDcsUPrabGj?=
 =?us-ascii?Q?zkgcVRZIE10dXXvEDkgNGYXopgy7fw8RKGvi5DibliwGPMoO+Jkih8nbBSTG?=
 =?us-ascii?Q?3CkNNtj7liDFIwzHN+3zmFniwwtYwtMUNEphdtItAvWBZEoGMsuOV4dJjEBf?=
 =?us-ascii?Q?heUWTofRM9VB944paQp3TDPgFzKqDyeDDe5j89MAPzmjHuOiu6cklqF7H3xQ?=
 =?us-ascii?Q?X+1xnsHq8nLDbRucb+Q5tOSt/jSRUqs+xfBqPnV07AX3F380EagKo5XbEIDn?=
 =?us-ascii?Q?f4+i9LX9RH5MkSni/5lpmI7BYzk6JycicNmqYQSMdqBnSgJ/+DcPEPz8FvKC?=
 =?us-ascii?Q?47nbHaY6KlnGuj1eTrvXeZQZUzBItN7yO5XAQcCjs4PCcqxMzEDeS4eL5gxx?=
 =?us-ascii?Q?ATA6OWQXGw6F3i16VT1dgsTPn4851R7NN9D9DCYNz4vD47jk10N2cskyL7FS?=
 =?us-ascii?Q?ArHZ5R+TteBiRwjKfB84pGw+VFiXqTSl46jOpzXEoXbVa1m31kWeOc7wv7xv?=
 =?us-ascii?Q?to8SJAavNDRQ1fSnjnQUkYqMDd7f5i144cVpv3LBRZSgbwneT5+8a943qJl6?=
 =?us-ascii?Q?eyH1C1aw8+zps5UEvUUlq3S5UuanPifiLvQPVPTrV02l311ipFBlOWMllKGu?=
 =?us-ascii?Q?RgV/EX7vw1Ml9K3VL5Hkg07g8NA5vuuc4B9ojCVpEKMtmxBdI+8ajHfnSp8A?=
 =?us-ascii?Q?jkc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OZbQx1LIbaFjSTilHNt+Z6qaZIJrtHrHVSiiNkb31wnsUKEgMaHwv233MQpT?=
 =?us-ascii?Q?hBQ+6OhV6eAY4N2Wq6Q9CH4B2PzdQTpBLznoqKdghXhojPkuA4DNL+EaBGwW?=
 =?us-ascii?Q?BRljb15DygY0B4YOCRflPXPEG9DuZH/RR7JPMP7puRWzAtV8nwOdWVJmL4Ip?=
 =?us-ascii?Q?PG05EC8G/d/QuCWzg0VaZ0Ow93aetY26JMWtGoahtCaNtbvI02SfrQ0AC5SQ?=
 =?us-ascii?Q?SbGIirupMQQulIMgLY2Y+WzFQdhWrgAUyTL6EmXxwCpK1oAIoerOtIezbHX5?=
 =?us-ascii?Q?DUsU/5W/L3XIBHN+WHD4At6XGUGGSSnrYDc0S+eMZE1dgsjjGgrss22EVyyr?=
 =?us-ascii?Q?GTKIErV0nU7V+fxsgyGzNWu0iNHZREkbopvOVWtKvQX0aa0IjfB6GD95FIcW?=
 =?us-ascii?Q?SMtdg1d7LBGijs9FN4RBzhVOB6PeQ6sbFsVj3vjErskI2hF51P5UAmf+R3FG?=
 =?us-ascii?Q?Xfc8yUcw3LbTPwF7D5aZ6sdbyM96azq8T9/vZ97f+1KtX4iTDusdwVcvcp5U?=
 =?us-ascii?Q?4gPotrRT8Nq+eXrx9acg8gClo5rihrAdorkJe5sApYahSRnPPSiysz7m35Hu?=
 =?us-ascii?Q?nZl8oOC1eqFQyA8UkyYG2UIuUxqRmR3Uk86aNs/jTcn4oxE2EPZSU9hBaRo9?=
 =?us-ascii?Q?mKeGBdS3QEDuDildAGKyMu498NMhBMIxTqL0dfhu5tXQxhYH07z5Psgqh69w?=
 =?us-ascii?Q?AI4bkvNjgaW++KAGtZuL5fhHI0/MiA3oNN4mLBnD12c0Fe0Dm5kkZkWnZN/G?=
 =?us-ascii?Q?ZUAKKj+dDciACl4SG4hJ/QG0ER32bDvgEizIQA5FsRVZocpHPXSjMvQtVBFi?=
 =?us-ascii?Q?TfjDsBVK5lyQIXOcv+QCd506OIT2AcO8iR0keMv9l3WdGTKhHs5R3WFMZQyn?=
 =?us-ascii?Q?/PqXhM+BPITTKgGW+JWdlljMi+7KvQLrWOgrCMnU4DPiS7r/39dHziBRFSOk?=
 =?us-ascii?Q?AdWlm2r3MgInzd0NML0YVVX3qA9fvFBwboruMMuiljCqKlIJiF4TkjJ58/jI?=
 =?us-ascii?Q?5kwNvoTDEs04st+2/wIUTb2NvWtXGO0wA9nbheEfZlk8dfYj8k2kDoqKpn4t?=
 =?us-ascii?Q?+M5Ds2c1Amnd4sHf03Bbm4O5Yj839PWRei2HY9s1YiT89NIxConlyPDpOFUn?=
 =?us-ascii?Q?0dxzffNaZHx51ZhrM6F6u2LX6RG9o4ACTe1aANpO8DIAfoOiqR++807Ca74g?=
 =?us-ascii?Q?yIWnMVTkPnxrBGNjPrSJ3fiMG3kdyWmiHZtvz7uhCL7WKWaWM5dAQrZbJOAD?=
 =?us-ascii?Q?KMRD/DyXunxrtPWC4fh0WcN/LXYnKZnbE7XFpFxjpKJX5rSMOmz7KZVIDklY?=
 =?us-ascii?Q?3zp/LOOoNsXYCHX2ERYPv4bdfvQ6NVOTno72TtY9RF6qV+tSjKugFQVokkkM?=
 =?us-ascii?Q?nn6kPJT2Trrb8ea0hJiPaBAok5gkWldjg4ai1oRidKEEoSwVSHqbDkroyM2V?=
 =?us-ascii?Q?l/9y6iKsMRM+XqJpFwHkLgRvgww80yWJYgEfKH7ZWJWBMprK+y7hAxQP/aMi?=
 =?us-ascii?Q?HanFLDbMKbIdM4a0gUHHrulZiui91Sb2PG4uF2nPUzXaJ+835fOFT0AhJH2w?=
 =?us-ascii?Q?Aj3WTlZZ7znndT7aWB6l4u5Mu0SvLZYrsAOCTY25d6udd8xWYaCNceDf1fVI?=
 =?us-ascii?Q?XQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ff9c05e-ad2b-4f8f-4a5f-08dc9649cfec
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2024 01:38:14.6212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yJ4f2935xf0euZpr96oSGoHGo+WSBHJDhn9t8yF7ZbKw9ydmqKA3FQ1wz+jVffvSe18IIIyy2ZM8152JLopHgi5kHt5+CG2w0SoWxgNvROQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8325
X-OriginatorOrg: intel.com

alison.schofield@ wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> cxl_translate.sh is added to the CXL unit test suite along with
> a C program 'translate' that performs the address translations.
> 
> The test program performs the same calculations as the CXL driver
> while the script feeds the test program trusted samples.
> 
> The trusted samples are either from the CXL Driver Writers
> Guide[1] or from another source that has been verified. ie a
> spreadsheet reviewed by CXL developers.
> 
> [1] https://www.intel.com/content/www/us/en/content-details/643805/cxl-memory-device-sw-guide.html
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Thanks for putting this together Alison!

A question about whether ndctl:test/ is the best place for this vs
kernel:tools/testing/cxl/ (standalone test, not cxl_test
integrated). Some inspiration from xarray described below...

> ---
> 
> More sample data is wanted. If you have a sample set or would be
> willing to review sample sets I generate, please reach out.

Or, if you see the kernel translation coming up with a wrong result
please work with us to get that case incorporated here for regression
purposes.

> The CXL Drivers Writers Guide update that includes the tables used
> here is under review and not yet available at the provided link.
> 
> 
>  test/cxl-translate.sh | 215 ++++++++++++++++++++++++++++++++++++++++++
>  test/meson.build      |   6 ++
>  test/translate.c      | 163 ++++++++++++++++++++++++++++++++
>  3 files changed, 384 insertions(+)
>  create mode 100755 test/cxl-translate.sh
>  create mode 100644 test/translate.c
> 
[..]
> diff --git a/test/translate.c b/test/translate.c
> new file mode 100644
> index 000000000000..e39637d6a8e1
> --- /dev/null
> +++ b/test/translate.c
> @@ -0,0 +1,163 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2024 Intel Corporation. All rights reserved.
> +#include <inttypes.h>
> +#include <limits.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +
> +#include <ccan/short_types/short_types.h>
> +
> +/* Mimic kernel macros */
> +#define BITS_PER_LONG_LONG 64
> +#define GENMASK_ULL(h, l) \
> +	(((~(0)) - ((1) << (l)) + 1) & (~(0) >> (BITS_PER_LONG_LONG - 1 - (h))))
> +
> +#define XOR_MATH 1
> +
> +static int hweight64(u64 value)
> +{
> +	int count = 0;
> +
> +	while (value) {
> +		count += value & 1;
> +		value >>= 1;
> +	}
> +	return count;
> +}
> +
> +static u64 __restore_xor_pos(u64 hpa, u64 map)
> +{
> +	u64 val;
> +	int pos;
> +
> +	if (!map)
> +		return hpa;
> +
> +	/* XOR of all set bits */
> +	val = (hweight64(hpa & map)) & 1;
> +
> +	/* Find the lowest set bit in the map */
> +	pos = ffs(map) - 1;
> +
> +	/* Set bit at hpa[pos] to val */
> +	hpa = (hpa & ~(1ULL << pos)) | (val << pos);
> +
> +	return hpa;
> +}
> +
> +static u64 restore_xor_pos(u64 hpa_offset, u8 eiw)
> +{
> +	u64 temp_a, temp_b, temp_c;
> +
> +	switch (eiw) {
> +	case 0: /* 1-way */
> +	case 8: /* 3-way */
> +		return hpa_offset;
> +
> +	/*
> +	 * These map values were selected to match the samples
> +	 * in the CXL Drivers Writers Guide for Host Bridge
> +	 * Interleaves at HBIG 0: 0x2020900, 0x4041200
> +	 *
> +	 * TODO Add the xormaps as test parameters.
> +	 */
> +	case 1: /* 2-way */
> +		return __restore_xor_pos(hpa_offset, 0x2020900);
> +
> +	case 2: /* 4-way */
> +		temp_a = __restore_xor_pos(hpa_offset, 0x2020900);
> +		return __restore_xor_pos(temp_a, 0x4041200);
> +
> +	case 3: /* 8-way */
> +		temp_a = __restore_xor_pos(hpa_offset, 0x2020900);
> +		temp_b = __restore_xor_pos(temp_a, 0x4041200);
> +		return __restore_xor_pos(temp_b, 0x1010400);
> +
> +	case 4: /* 16-way */
> +		temp_a = __restore_xor_pos(hpa_offset, 0x2020900);
> +		temp_b = __restore_xor_pos(temp_a, 0x4041200);
> +		temp_c = __restore_xor_pos(temp_b, 0x1010400);
> +		return __restore_xor_pos(temp_c, 0x800);
> +
> +	case 9: /* 6-way */
> +		return __restore_xor_pos(hpa_offset, 0x2020900);
> +
> +	case 10: /* 12-way */
> +		temp_a = __restore_xor_pos(hpa_offset, 0x2020900);
> +		return __restore_xor_pos(temp_a, 0x4041200);
> +
> +	default:
> +		return ULLONG_MAX;
> +	}
> +
> +	return ULLONG_MAX;
> +}
> +
> +static u64 to_hpa(u64 dpa_offset, int pos, u8 eiw, u16 eig, u8 hb_eiw, u8 math)
> +{
> +	u64 mask_upper, mask_lower;
> +	u64 bits_upper, bits_lower;
> +	u64 hpa_offset;
> +
> +	/*
> +	 * Translate DPA->HPA by reversing the HPA->DPA decoder logic
> +	 * defined in CXL Spec 3.0 Section 8.2.4.19.13  Implementation
> +	 * Note: Device Decode Logic
> +	 *
> +	 * Insert the 'pos' to construct the HPA.
> +	 */
> +	mask_upper = GENMASK_ULL(51, eig + 8);
> +
> +	if (eiw < 8) {
> +		hpa_offset = (dpa_offset & mask_upper) << eiw;
> +		hpa_offset |= pos << (eig + 8);
> +	} else {
> +		bits_upper = (dpa_offset & mask_upper) >> (eig + 8);
> +		bits_upper = bits_upper * 3;
> +		hpa_offset = ((bits_upper << (eiw - 8)) + pos) << (eig + 8);
> +	}
> +
> +	/* Lower bits don't change */
> +	mask_lower = (1 << (eig + 8)) - 1;
> +	bits_lower = dpa_offset & mask_lower;
> +	hpa_offset += bits_lower;

So this math is what we want to validate and make sure that the kernel
is in sync with the exact same math in tree. If any follow-on bugs are
found, both the kernel and the test code need to be fixed up
simultaneously.

The easiest way to make sure they can never get out of sync is to just
make them use the exact same C file.

This is the approach taken with xarray tests. Where
tools/testing/radix-tree/xarray.c *includes* the kernel C file and then
runs the test in userspace, but built from the kernel tree directly.

Now, it might mean that the xor and modulo math translation helper
functions need to be unified in a common translate.c, but that seems a
worthwhile price to pay to know that a passing test directly implies the
kernel would pass with the same inputs.

Given this would be a non-trivial refactoring on the kernel side I think
the current kernel patches can move forward, and long term alignment of
the kernel implementation with the tests can follow-on later.
