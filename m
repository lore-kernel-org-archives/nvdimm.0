Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C55185B74
	for <nvdimm@lists.linux.dev>; Mon, 30 Sep 2024 22:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727735205; cv=fail; b=Xncz4AJByabF0K+yj8XkKFOemDvjLYE+bMG1NN1jZZ+OTNIDHs8exUt7bnwudb3ccvq5PbgE/WndiYC/SgfM9YVk00ygCCYJ3YAo0w23gasIb3sXAAiVe8ZlBmpJaWfejVxcOnAPrGDAE8Oo4w80ZnOkJleqeieawa/QHy3Xj3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727735205; c=relaxed/simple;
	bh=KlR+Wmyg8/z+BmmRW06xwQMxho2hll3Q9g31ZN+AmPo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=H+EUBU79sNc0qdJgMRCXK3BmO7g6kJ2lvf6nYcpZyGxobvKUFSCdIGFXIG8kt+6riqJD8geDwjyNEoDgSTbcesnwZElyVoIklYkTGdOqrUZo0a4LVwjbhlD40quGWK3bNfb6DFOpOtP49Qn4LbUMfKT4NvKrSTXFo7cdp9XjDV4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dY19to2L; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dY19to2L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727735204; x=1759271204;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=KlR+Wmyg8/z+BmmRW06xwQMxho2hll3Q9g31ZN+AmPo=;
  b=dY19to2L+NCgRBXsatIcETdY2/L8c5WQ4Rfh1k0uJv1Z4bB2bFzBGkmI
   zbKD3w4ucsmV+a18USg2lHRnapQM0CBpc8VmFk4t+DBnk4wVdqejC0ilH
   2uFJXM60iRaYRtcSWqOJFH3V6gLe0GM9Dncf78QMsv3MYKlHZTS6mrgJm
   z6VLywvAnLTRCESTARY9PsCiKKmK4xgjnY5lgpfcb8LoNQOBE1L2lkaDY
   zR5gDtfQsdW4lfv2uTLV2/TPIZ3SBrTv7oIRk1GAe5o7gZTFlI7T8xBau
   o/XJc7rxPaOIzRQtxQlScFQOhTfGz2yEK4270zPwYOq+iznZeFJretNGG
   Q==;
X-CSE-ConnectionGUID: X0BuPu2OTrGS9IMoqmbf6w==
X-CSE-MsgGUID: yB/wtLKhQJO5TEMIHwWhLQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11211"; a="26731198"
X-IronPort-AV: E=Sophos;i="6.11,166,1725346800"; 
   d="scan'208";a="26731198"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2024 15:26:42 -0700
X-CSE-ConnectionGUID: 1k5LqLn5TLGNMv8Wauuq9g==
X-CSE-MsgGUID: Ia17OWQLTT6LrHTkM2QxdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,166,1725346800"; 
   d="scan'208";a="104231022"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Sep 2024 15:26:42 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 30 Sep 2024 15:26:42 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 30 Sep 2024 15:26:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 30 Sep 2024 15:26:41 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 30 Sep 2024 15:26:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TAU6rBQGbYfbcxge1TIwo8mEhD3bPzLk7UKKtTGf44SvAoDkNYcJS3+WsVV/IfGWqT6MjmtCXgORXRO4gBcylC77m7eEHqEp7xfwzGnO9FV3rLO6061HG2iXL5t9XMO0t4xKZhWZgA7ezSHbd8Njq8/wPU37sJKI7Bz5IvJc5eBReHl+42A7+HrOYeJl8Q5BnWayh1nwDYpRTTYcT3sF1c6nBzuG8hcq2R7PMsPkA4BezU6PVBshn1jdcF6kOGXqxSXbTYT5PrlMNOlF/mVzN16V3MBKFSPEW/fXF3j7hZ5NLo1dwraFZ8kewGP0nvFT8hWv7BJQVSGu+XSqy58fZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RD0uTDAmiBZTNIPfc8gcXcZRVhgytPWuxh9Y8LSXgSI=;
 b=u8wxJOHHX/lwoLm/29UkTWm9iA6+DWXUr0TVeI7PcHTVC6kt5I07PtYH+rfB5ZrvLElTdvp/PZvM7pyspZab60SoxylmFLZ/ik0wbk1QaiByR0E6y9KPWdQQrCSqHWaeOj9b+ZJ8xnbyiB3/6XyiTNO/Q4WTBLolE03ApiPdjvzudZGFsrj7Vh7Vzv9fTmxpiE1rGGAP8D0NWUddUfM2Ls0Dmoy35wS74rwprcJ/0P9zojLA28wb/9d6ey1uEz1svaRzs+s3iXAu5z64zeE3cZWOf1LszK8fLMR7DpiQlre/BoSBC+8a1KkuTW7tVDtgAa/Jk7fTrGCjLrf7IElqRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by PH7PR11MB7717.namprd11.prod.outlook.com (2603:10b6:510:2b8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.26; Mon, 30 Sep
 2024 22:26:39 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%3]) with mapi id 15.20.8005.024; Mon, 30 Sep 2024
 22:26:38 +0000
Date: Mon, 30 Sep 2024 17:26:34 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Julia Lawall <Julia.Lawall@inria.fr>, Dan Williams
	<dan.j.williams@intel.com>
CC: <kernel-janitors@vger.kernel.org>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	<ira.weiny@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/35] libnvdimm: Reorganize kerneldoc parameter names
Message-ID: <66fb259a15b42_a31f2294e5@iweiny-mobl.notmuch>
References: <20240930112121.95324-1-Julia.Lawall@inria.fr>
 <20240930112121.95324-6-Julia.Lawall@inria.fr>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240930112121.95324-6-Julia.Lawall@inria.fr>
X-ClientProxiedBy: MW4PR04CA0172.namprd04.prod.outlook.com
 (2603:10b6:303:85::27) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|PH7PR11MB7717:EE_
X-MS-Office365-Filtering-Correlation-Id: e0fa2c9f-6b34-4c32-e20e-08dce19ef38b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?8+kX66ZBACv4pUchMdcN4mPJWHjrjKTegKtBH1Em4aG1m/UKEcpj7KbcLG51?=
 =?us-ascii?Q?3x3L3h39xAJaXD4LIwiSXVWti3kqAa+R/xVU93E2Rq7st/9UbxqXXmDFC7Km?=
 =?us-ascii?Q?Qd1B4helccxM3/3T1IhUeBbIvSDFRh9KtInJiLwUmFe3vT6AGwQtQgwCF+bV?=
 =?us-ascii?Q?Ie8My2jfMqNM3cdtzl8B93jEmEQ4+m3Sne10WJ7RhORm/wW3+QfGQkjohorc?=
 =?us-ascii?Q?RbvETmon8KIg0iiw8ADMQ+ywCQbXOLD193SFxY62IEtNNMj8xrwl5jlSnvvF?=
 =?us-ascii?Q?M3OzO7mjjAFJy4EMdpjOOzfEKghuM/DfDVh5ouVMdh26PugXSfuzsAWYf5u0?=
 =?us-ascii?Q?sCUr4m3gpy8Z7gF2lqGNZ4GPbZCjlLo5UO5Bt2UTP2OVQELQtHJyP6cannf4?=
 =?us-ascii?Q?5wWp9dVBSn6Bl+MoTpGmH5WhOoGItlYhUYHVPVJu/MyA7pGwk31PTdXs0Lh8?=
 =?us-ascii?Q?nIqW70gCuX78KhajddDsdaitTl8uyXHn8QlOTo/qsXJJMS00/zmik9dh28tX?=
 =?us-ascii?Q?vSI6yPxD1N3Dgj6/C/FSHJNq03OR2pSeRs+2sd7s0XGFutdOOvrEsEh3KmYE?=
 =?us-ascii?Q?Y7+wKJLkhkPK3Sft9WcxjVQen6MOLmyJXTJb+az1WDZY7LPTWjGybxiKHjt9?=
 =?us-ascii?Q?B2O5EbFEaXQaVUSdj/VsNDemegGPXmPfRTNP2h60cfF2TIIAElr7WVpShSof?=
 =?us-ascii?Q?C3Q3iTqBhEVByIi0ZVZNhoJ8bGgE4r7R0SEMkDZfccYPnWhH3hhDreYJTlDW?=
 =?us-ascii?Q?4+dcMYL57TyY6i7cUxLFBs7lTT5fEQ68YbganK8FJn2T0hZmOzpeqUPb5ZZa?=
 =?us-ascii?Q?LGL2I2DhMrlwiuz8h8EkX6lUvA/kOaSa4Kmwob97Nru2dEh/sbbd+24iTQhr?=
 =?us-ascii?Q?8Z7NRrIlqttxW4GBu3752UR8fGXvDe1As3GJchJDFIKD2EfwYCcWQtlcdzcL?=
 =?us-ascii?Q?clvSB5/4pIJXzax+3lIFQEc4yJT2kY6ywu5P2o1smZs+Vh2ZnPS+ucL/m7QR?=
 =?us-ascii?Q?8RYTLO3anmrG45Hyu8HNucg3joo495sMJ96lNBMHKIWNs1qkUPbsgRz88+Ql?=
 =?us-ascii?Q?Y9VcF27S6ZWZWULliPoeWrEVsw5X4AJFqplsPpT3rNreSbXAVw3LuBwtLwvx?=
 =?us-ascii?Q?NqmLTT424RMIpzDhNS1/WdWdesSRP4VEafEdBhXyqPBBxgeeVVf8Q4lNEIO1?=
 =?us-ascii?Q?9cfdZ072GhVOOijpjh+jXPGWDrQUhg2ng7nIRvtgaZd2DPObmUoRPDdXVqRD?=
 =?us-ascii?Q?WJ0iAFsLiR5zTdB8tNY4NfAkjZoYXl+R1vGRoW9MhA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iPokEG73IAkPqt8Vdo9zOsjvFHAwYOTY4q8MV2P5IyKKjSuECMcBlYGh+Vbd?=
 =?us-ascii?Q?vRYWdZkI8EGzHtEV05UyZ4esTgR9Ng94REE/fGGogD7mE4W2C+v0EhfHM82Z?=
 =?us-ascii?Q?AIxDPBuV75IS+3rl/1QTx2BAlxv8nRyMjxxcxmHb0jMRPOHofsvy+7V88nr4?=
 =?us-ascii?Q?Ib+PMB9sJo9jdqOuonPzjAvR8LwFuHNMAIM0tq2TV8uznOMU9VkGlTc7VK3z?=
 =?us-ascii?Q?8vnC3ceXJ65uMVFfn/8TNkthYdSP9u8n2UhLMfH53L1i8eRafzmsB1a+sQkB?=
 =?us-ascii?Q?zdUnOM0DqB91RsucURyOQzVSJruCI3rOiQUNJxMS8SVJ4bv6GM6jTpPhEUqx?=
 =?us-ascii?Q?k4jJbxE0te4oJZjeu9EKXrE34cVHsZi/iWwBzjvhdDzJz2akQELldhedzMkV?=
 =?us-ascii?Q?KaTEx/9Vh3zq40Rpqf0K9xTNbx9pLJJ7+Y3reKcnxIIbYcl1s7F0kb6TQCki?=
 =?us-ascii?Q?Nru2KKvkNEDiCdRcv3vtz9kad7NbOUTnku61nJ8KIY2Ydhlfw+NtGBC0lcx1?=
 =?us-ascii?Q?PCRvPU9GysjX1EkeColHkT45GAI8V6RmpGJyIAf47215sxNvjh/MXo/Ao8PR?=
 =?us-ascii?Q?NT5cwX2eHN3884mB4n8CoHvRINEaJQwoKRE1WWJtQfINK/u4XSsL9T4GHn4d?=
 =?us-ascii?Q?Ej7166qUYE5h4OiV9rv2DSp4wcfr9sK3iQn+UyR368E3B6C//oPyIZaQi4Y9?=
 =?us-ascii?Q?0mj4Jp8I9MT2f+n5m6CTyo5iOYpyHKbsG2oxLNPe5uZA2YpA3aTawQx9u1pE?=
 =?us-ascii?Q?OneSz3hGWKF4GWwzihuCRjiBrv7KagAfKJf0bMmQtjDnCm3btScrbTfv3z+m?=
 =?us-ascii?Q?bRNctrfyjaxruYn2ecmiDGTHOeg+G9VO+BFZ20ZdmJ2PPK6S7+qt+n+BjMrg?=
 =?us-ascii?Q?ZqvWR1U/32mAuqHZUZ+aK3hKlJDhac7TL3BHSPah5aWlfNPwrMBbIZUB28lq?=
 =?us-ascii?Q?LO4YK6M21Fx5NTAjo77zZOnItyoRUeWd1BwHFbScKNXrluoe0r9oqdUoEgsz?=
 =?us-ascii?Q?AeBxfdmbpp6GV7RH000mdGE1E7Ymj6TWUVNu2RFBXjsW8a48SPjc8sgOtQGF?=
 =?us-ascii?Q?8tc2+moACx+vMoRAhxWFMwMyRMSCyNsQuGU0tGO0B+xCTi/feXalL7itePh0?=
 =?us-ascii?Q?QrpIatCt4Voev9tvnj49lotkbdM8ETCKl+U0hbQ6aQ1Dsxh2Eml/0ykbIFm3?=
 =?us-ascii?Q?yuX2DLzVF01U/TPrXMqhjSNJHnLtUx3AuhDphiFNnP2qGqbNxCzNDGCYPxOn?=
 =?us-ascii?Q?+qWLkwdhyn4aBmPs22uVP52+RK/EZ7I/oqX13MtTxkwgyUCPFW8wPDtjtJY6?=
 =?us-ascii?Q?4uKjLDufgLD9dk499j+Z2R6brMb6WdBDPbe12C766/5S0sRu5qQBsbs/bunp?=
 =?us-ascii?Q?9tfGdiJTMAsVWcmmKgsyvkpogeWjH4Ee9pIBCw2nqjTyUVr7JP0VPDOIoLM1?=
 =?us-ascii?Q?b0lLtPe2QJ+KjonWDjk0q6a9YCseKVdNPx+stxgnulWryd4eXssSXZ1vgLhc?=
 =?us-ascii?Q?VsAG00pz/B5jDNObZj33kd4i9WmglfGdJv35RUNCAX4lO1JNhUT0CSPN6XsJ?=
 =?us-ascii?Q?ngcrqdLGAycA+57QuUdVwOeeSvDy3aUra1RBDzs2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e0fa2c9f-6b34-4c32-e20e-08dce19ef38b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2024 22:26:38.9118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l6O4foQ6YkoBgoRt+oyQvHE4lCfhsRtijBRyzL/UNHUMjZhK2ADtgZfRU2tc3087AplyCw3W+TDx7k6tLM5XaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7717
X-OriginatorOrg: intel.com

Julia Lawall wrote:
> Reorganize kerneldoc parameter names to match the parameter
> order in the function header.
> 
> Problems identified using Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

Acked-by: Ira Weiny <ira.weiny@intel.com>

> 
> ---
>  drivers/nvdimm/dimm_devs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index 21498d461fde..8c35502638e2 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c
> @@ -767,8 +767,8 @@ resource_size_t nd_pmem_max_contiguous_dpa(struct nd_region *nd_region,
>  
>  /**
>   * nd_pmem_available_dpa - for the given dimm+region account unallocated dpa
> - * @nd_mapping: container of dpa-resource-root + labels
>   * @nd_region: constrain available space check to this reference region
> + * @nd_mapping: container of dpa-resource-root + labels
>   *
>   * Validate that a PMEM label, if present, aligns with the start of an
>   * interleave set.
> 


