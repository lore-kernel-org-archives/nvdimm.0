Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4CB3085DF
	for <nvdimm@lists.linux.dev>; Thu, 19 Jun 2025 01:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750295952; cv=fail; b=XaTzDLTARoDVnxLllb00c4Ma65RvtnKA8/3LeDFJd2RORhgEOEWBDc8JL3BcgeeNZSc7O6LmOJvB6kYJu8v0Ykcz4rh8G10kVN7F3EC+jyD98NXXf8wf+tkr26Dul94gSnAvCMkKrCTiVXid+QkpiOevwz6FsSsz3uRbkAwX79A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750295952; c=relaxed/simple;
	bh=TcI1ASHKr9n9kS4M/38opWjR2yHOLr53TeZzk80bAAc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YfmVncwa7VYeIT546t+FtDlBk0din3uLv1tXpfXyfM/OIQmvSsDsfIxW2+FTcjMrCiXcJHqY01S/w+GJlGr6L/FvpFG8UeNK+I3OvKL+azxklaW706OX9wFifDpCNKHIDpx0D4TtXxS0qwwPbtdR8i4zIYKCnE4xI5hZFaCeOLc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bk8EgvtG; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bk8EgvtG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750295952; x=1781831952;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=TcI1ASHKr9n9kS4M/38opWjR2yHOLr53TeZzk80bAAc=;
  b=Bk8EgvtGXSM6qPL6cFD6u/lb+L9G+FHQfhXGmPXC4vTDMVO2vP6LWP/I
   lh/tYLjFJAIiUELAop/e3Z1+MCPhqPqOcxw0WLUIQ1LADgZDcXvr3X27k
   NJ8+wPYqIQAq/kAi+V1bRahd3aUCGa4gjrjgHBEsb5oSLNjrhKdl7mypx
   KI43kZWgxbNSWI40GoZDE4sO3HbVdp87grgw4yvD+WhbOdqrYqZQXA2BJ
   ffFxieREvpzXk/V9hvFYCLXmPSj1GWOhA5zOkZCNXaE4llbJ075CZ4N3m
   cnnBf6HDX1bcnV2VaCK7oYypiwB16ouAh51DeY1zbRc+jpWV6gZv1zmVr
   A==;
X-CSE-ConnectionGUID: JrQCSWkNTYaFzwvT/ZZ0xg==
X-CSE-MsgGUID: V42fArrFSN2pgTF4AQUBlA==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="56334336"
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="56334336"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 18:19:10 -0700
X-CSE-ConnectionGUID: YrpMcpeFRoe0xkd8nX98kQ==
X-CSE-MsgGUID: BlbspuKRQsqVSrxKxpwnlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="187601823"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 18:19:10 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 18:19:09 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 18 Jun 2025 18:19:09 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.74)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 18:19:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CkIskBjei4vzjdQDJesBZq2GuRbt6WgaphY8d33GnYZwEo9ChibURA5y1uH7ge0H+tRgvvKPEiaFJLLEQRcsB7JoiSKP4Ho6wuVRAUq6Y/uF7a1iTQCzKu6YaW9oQ73iFSeGn3RPJVti83ApUDY1t9mKQlAyfTYFF7csyvhjoOKq7gsUJDH9hDvIW8082SoE9Hn9Uw8fBdpeGG0Qe5cwDd9zexsfVEBc+y3NN9+bVi1BQqxjPai87RoJmqCpuiTk9yntwJDj5W4L1eFvENPq/1WgtOuuUS5YPXkTl7yv8N85sETVgdmVOUTUsJMRkqgoNmPmKcMeLziQT9dTe54LdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PQuCfC6UYCxt4uXzsSZDNHwSru86OJkOFxomSU4ScFw=;
 b=Ufg7pxX8mhoK9Tvgn+5QkOZwJV3uzaPQM9OtLq7BZEAQUmL5PzNMXFktRmbJw6M7T+1cSW5cJ0bdq+jWczqX2XUOXMmu75c/QxynWNtan/Erm63apcLUmUeHEQ7aaPiL9agnu0ZOtzwUQNZ9ChU/QYH9yvOqoeIeC6Om6iFMMbZFH9zUHmo/5RG9v87mFfIH8FBI9CgwywU503M7D/4bLrQqqTA4uMXggr4D8a+8kllffeFlm0tnPj1v30pidqVVZ2YYebu2S8kj7yFIjCoU+kUxdnpEPJCxXG6kqhdqCfbdQYlNO5mzfIjbNNjTU/a+XtEcxuFUpp8AsyW3CUek3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by DS0PR11MB7877.namprd11.prod.outlook.com (2603:10b6:8:f4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.28; Thu, 19 Jun 2025 01:18:53 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8835.027; Thu, 19 Jun 2025
 01:18:53 +0000
Date: Wed, 18 Jun 2025 18:18:50 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 0/5] ndctl: Add missing test dependencies and other
 fixups
Message-ID: <aFNler_s_2TO8KBz@aschofie-mobl2.lan>
References: <20250618222130.672621-1-dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250618222130.672621-1-dan.j.williams@intel.com>
X-ClientProxiedBy: BY5PR20CA0012.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::25) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|DS0PR11MB7877:EE_
X-MS-Office365-Filtering-Correlation-Id: 40bee7f0-c177-4abe-7df4-08ddaecf40f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?s7T5eReCQOkrxvVmjsBRgcjDLz7t1oM41QLiuu3FJSeXEHODOD6JZwWziPcJ?=
 =?us-ascii?Q?TjvmLR+byWqGlIdG4l/8PC1/4DSUAEOKXnKzMufZLKOX2SwMvkyAmU3hq3/3?=
 =?us-ascii?Q?a3shMaqPJ/4Fq8LkVhY7VWd3O3pibUpqbvlt8QGL0L+AR9L8Vm8H/K3eGqWS?=
 =?us-ascii?Q?gpXhHtiAi3fOTxWT/edcOVxnzCLW30NNajDamTq/qHVOCT8iSw3fQnI4bdlh?=
 =?us-ascii?Q?s3y0b2S7JpMizGh+FZGdtGcPRxF45uTFxIc4PR9v3mPV5kvufY3OFY9g3G/E?=
 =?us-ascii?Q?4rNG6lDv3sZUrPiQMARfMnDADax2bcZ6MtG80oGwb3kB4Rbwg9LfTnZ7h/Ij?=
 =?us-ascii?Q?Fml3wbZu+eCPDCK47P8ZAwxvsAQMJB5fisbaOGOZbBJKm1yB16KJowuvpKVt?=
 =?us-ascii?Q?W3rTvRsXK3FPiHQ++p9q6sJT6AeddqKzi6kd1ogAIJex7wWyRIggL66fdHTC?=
 =?us-ascii?Q?dOefRekEVrG4ViocDdnvSXSLdMv8Try+q5xl9FowT7esuTNH3A+gt2wmVj56?=
 =?us-ascii?Q?af0PThPOT644UCo5wHIC+AatcR+H5TvjqOhLZySTUoBYhsmOYSNR4WvI4LNv?=
 =?us-ascii?Q?F79bbTo4/SwcISbdPv084UGNkCwPVNANZusJNeN0I/0Gbfz8U9Fd0Z/Ukl/c?=
 =?us-ascii?Q?QL5+vMINznqhenkb8GoU2FxHhIQfJzJ1hfU9BDGsuc28IA8RrhdpXoMjoDs0?=
 =?us-ascii?Q?1n7XCxBNW0ZWieF7rWTFLnvC8Olga0U88A5IGnZc3tXQaAidIgesw9syMvES?=
 =?us-ascii?Q?WhYPA1dBW9xDku1XRid/KXOQVfqips1v6d6pRc2wU3ISdLmJNXeqopwAc6RV?=
 =?us-ascii?Q?lCZoD+qwBE+q9CTnheESrhhSg88eGcQH+aWLGFACbWuV3c2nOXs1WHlLVp8G?=
 =?us-ascii?Q?my51Ibd944FuM90t0Mmzw6QLhMO55Nq9iyCrWRvd8NBdJDpRBYoOHtcIzRqH?=
 =?us-ascii?Q?7P002O6NEhYf1H4GwkdWF8/ONB2YyEiphJYRQ2TxU610AQYphMX6MT8gIve9?=
 =?us-ascii?Q?uSOe8yI97YNQgbFrY3FaHsqSPDnv9e13CRGdHpaJM/OsKIBIWR1jD0rBSMef?=
 =?us-ascii?Q?wKtCbm1LUrCb3NMTFdhA81fMOuGkD6fHtWNPry96u3/dFpO5wKkQY12juOZ1?=
 =?us-ascii?Q?7DSWR+Mu4B0YIgiXOL55jJkWoz+/94EDcn2DoGc5g2d+0DOTZVNjDTu0Uo3d?=
 =?us-ascii?Q?Hdie0I9ZIowKWZ403Wpj2ApWoJva6or+7M5vFk9XgQa28G3zzZCPWdmsRL2P?=
 =?us-ascii?Q?KWe9NM7juPeD+DBIPFTUCRdqqGAW20UuJPdLq5Ff2UsScqUP2v9C2sRpRBl4?=
 =?us-ascii?Q?ggWEa6eb94X1s3fQhVeyaf1IJoxTOtBsisp86DzzhpiOuntlVKunsQuxJxAV?=
 =?us-ascii?Q?PyFuoYWiYiysfIzDeOi9Qei2VYU142P3fvpdrDOccc/zROvqtB2N025WZydx?=
 =?us-ascii?Q?oaxthzXqsKA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sSilkvEcyOJJ7ILIfkIsnlZwTx94ibXWr5RQkTTi6/lbG5yon/fG7KLWfPpQ?=
 =?us-ascii?Q?BtNAqwcXRE+O77/prc55Z0SPnRJ7sWTZ5Ufgd6lQ/oZv1BcM7GvyOLU7tqkw?=
 =?us-ascii?Q?oUlBrdUodbUOVGA/wZ1JaTcatxxw+Vc+exBon9J6y+rT8WrpyXQLiSpdiAcx?=
 =?us-ascii?Q?NuZoCqwfLsznZD8ogiSreKTX5P7jdpjlF4YHK2KdCrPpAnPc1WFcdUuqnwb0?=
 =?us-ascii?Q?WAKcxZ6XHIZlqDWfE937FRGJ7haZ9cYAzcd25wi2v1VEoqiNQgh7rUeAWToT?=
 =?us-ascii?Q?Jf416Cmh26unYtWX6C9dOHKZ+jxKoqFAfZYwBI5LDDc9H7r4953i+Q80P83g?=
 =?us-ascii?Q?/YEFhDZ8OlEZBgMiQiwjqker2IpILjYChwaDYaCKYeZfx0bjEFxstKO9CBuE?=
 =?us-ascii?Q?uZOsC/hsj7uYPtc3Z1Ajdg7i1OJgvvOYXAsub/c3pRY7XOdWhKDABMa3ijiv?=
 =?us-ascii?Q?0/RNN42gz15ZPoRBC8MN53uH6l8Pb/n6YJW1Hx5OwtF1dMP+B61G2R0y+Y6O?=
 =?us-ascii?Q?cUt2cvTGatvWiTPKwSmAZPyifJbGo1P6LItD4Eq6SNvBxBobyOULvL5U61qu?=
 =?us-ascii?Q?atcFOtQIKtwKv+n3NKcct11YU9gBktCHpVlNweHAv34o7I/rEDrMkXAt9Xyn?=
 =?us-ascii?Q?jRpM5RQOgQ1YpFOHJ7dfmbckXhLanq3DiHr6Li/C8Vmbk25EbRXkp9V0fxnf?=
 =?us-ascii?Q?bjNC8+kwzzuTjDS8hRW48gtHMf2gHaCBvXdfkkfpfk+VwOLoeC/p/bgnLmXJ?=
 =?us-ascii?Q?ezCh9N7iVsa1Co67H9A/FM7IecLWCGCAkYnhMjQorTZjaWzQjFpAcH2GR0si?=
 =?us-ascii?Q?g1qaJD1vZVH2/KHD3dyaob89AQizSR6VVr8eC5duMlECj4wrm3cFBPltHNYW?=
 =?us-ascii?Q?UvnsV0kYGu37ZNfK7ccyV6vS6bl8bBcoMejtRNZkUbD0ik4kShujMzcgJM5N?=
 =?us-ascii?Q?MSlrzrvijkbIR5IH2E3gJAFe6i4KOJzez8CCauYsWaiSKmgLm9ihMutypnQo?=
 =?us-ascii?Q?5MZ53FIInlgZWA9G6/rw7LjV1WCYTOgYjSUvMY+0U0rXs/8Q0HMX16WvAW13?=
 =?us-ascii?Q?AfXbOrd3tg3eALFGL1Yg003TxeK/510ZPkANIdBYFa7LJrWce5nVGeO9ylni?=
 =?us-ascii?Q?QT/HAUgXFH1ZDt5nFu/UHw36NYoWJpnqfVdKvFxqBgEJdHR4hHkWwJ7ZNAPE?=
 =?us-ascii?Q?W2meXA3WyEA+L0wZvS+y4UjUbX0BkITkpkMSJNdPc+JwroGuXxkiFy2R7MsE?=
 =?us-ascii?Q?HAn1QTUXShOzz0ZFBc89ehG1dXKfSEptIevyfoWfCJBkfE+Io491/79jUt0G?=
 =?us-ascii?Q?4bR+OKuyNGohdjNKm/Aa6C1Qnk+5XvSMSdesunckbSj1Lw4mjv35X7y0Q795?=
 =?us-ascii?Q?kHuV8qeLNf+dHO5umVPqqvMmCNnMhD1sy43dPOjjspyYRFxsye0IuOkMnT2z?=
 =?us-ascii?Q?0Xf/lAUNDxEgdgcXZULoR3Gt8YF3EfdbWxFQQnr1izgCweeYXadSHVTavRG2?=
 =?us-ascii?Q?kKW0Wh2ygto6/5eQW81vMqB9UEdf3J/fGjrUE3afAxEBqQh3D4PhIyzEzjTB?=
 =?us-ascii?Q?uJgA1M15z/FjKAyg6MnslDwFpNuwxx5vRCbYIWfGo5lxNFYg4/J2gYa4dt+b?=
 =?us-ascii?Q?mg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 40bee7f0-c177-4abe-7df4-08ddaecf40f4
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2025 01:18:52.9394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EroKzJZmxdX6kuEgztxNdB5jTi6JbOls4kniRXpr0UIAmfTsu7mFeETrQb3AbceEYPeI5TRxfraDjL/D1i3rQLOobaIlCtLmov4RjiIAbHo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7877
X-OriginatorOrg: intel.com

On Wed, Jun 18, 2025 at 03:21:25PM -0700, Dan Williams wrote:
> Recently I stood up a new test system from scratch and discovered some
> gaps in the documentation and the tests.
> 
> Fix those up to get all tests passing with v6.16-rc2 and latest version
> of all test dependencies currently available in Fedora Rawhide.

Thanks and applied to pending at: https://github.com/pmem/ndctl/

[ commit msg updates and the mentioned dax.sh awk change ]

> 
> Dan Williams (5):
>   build: Fix meson feature deprecation warnings
>   test: Fix 'ndctl' dependency in test/sub-section.sh
>   test: Fix dax.sh expectations
>   test: Update documentation with required packages to install
>   test: Fixup fwctl dependency
> 
>  README.md           | 5 +++++
>  contrib/meson.build | 2 +-
>  meson.build         | 5 +++--
>  test/dax.sh         | 3 ++-
>  test/meson.build    | 1 +
>  test/sub-section.sh | 2 +-
>  6 files changed, 13 insertions(+), 5 deletions(-)
> 
> 
> base-commit: 74b9e411bf13e87df39a517d10143fafa7e2ea92
> -- 
> 2.49.0
> 
