Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CFC3B2BA
	for <nvdimm@lists.linux.dev>; Wed, 17 Dec 2025 04:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765946206; cv=fail; b=ZSiF+XMB9rCXyuR7/FkqUPWgbDtEtABQOYE29iKp7I+eEhTpkSmWfuQSArJpE6iDgiWHbnOzfxslJkjMHB4f1JdToWTMNATlAO4nBaQT+TYVumorUmcHDwMRDJotWTbzWpO9Q2Uy4I4+LNjasn2orIoKfmytW2Q6x/GqvXE3Egg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765946206; c=relaxed/simple;
	bh=2r0wJaZ2SfG5mLLxNsbwvsBAIpHnmvkqfJQcSqTF4mk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IDmjd6z4PJ4Ofs9EaVQ8OwAxiBBtK116x6AMX8krH4E7ZuduWsHcZ+rXW9MgIiREotrnW2zXn62qEhXVzJ6wd6wmdWvOe46j0A22zMCg/HSnJCN5HKWzH10PJsUlvQrk/846iG4C2maQ4mus8seWTa32+8Qb858487OSG4Pjb+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ClqpQXnM; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ClqpQXnM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765946205; x=1797482205;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=2r0wJaZ2SfG5mLLxNsbwvsBAIpHnmvkqfJQcSqTF4mk=;
  b=ClqpQXnMmXMn9z9Hm3shqtIStxgl6fmLdQevED5NZlZWYzQKhzR+xZUz
   KstVWJVeI1R2wSky2XL9XSRnJiJ+KOKpiiU30ishEWsF0Q2F5n0DroY5Q
   4T8des2woskItV/r5oagkaVj8G9ZQqT39SGV8AHSFRCoouCOxfk/tqffu
   0ROEE8H01y/O//Uh1WjfPwzXDEQUHcNIX67h+kl+lY4S2iEmIv1CLO/JN
   wyrUWVupe2VN4cE9w7wsm934WQrOpyxA1Pa9LJ7TMHmqMS6F17dCv9tNv
   VK5xEQWvoicob3hT32nYMkvwjxEby09bGbMW+0ynFQVK109+L3McyqGNW
   A==;
X-CSE-ConnectionGUID: q/55KwgfTuyTwDyaACFprw==
X-CSE-MsgGUID: 8Uyfucz8TgyLzK4qRUvfWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11644"; a="79330239"
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="79330239"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 20:36:44 -0800
X-CSE-ConnectionGUID: hAlVP2R6TZeT3U5WBH6s4Q==
X-CSE-MsgGUID: BBfy4n3YSXqh2p00DZs1AA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="221583897"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 20:36:45 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 20:36:44 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 16 Dec 2025 20:36:44 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.35) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 20:36:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fv4WIpemTB7l/CY2lSgHWk3s4FVYgcITpGv8xf5pWcpxt19U3izvWAFbejEnJ3yQsgDlcR//+fW/M6B/wipJNe2Q/cPgbYVMjvYC/UwEQ0niMuQpVtjCaqQR5jddYm8zyQ2CZQYZi65ITKIdVDpYzNz5ryzCdYwBjh/Qo9B+xr6qqUDk0cbzNE6VWXyFt20ZWPXtRHjo2Wq9ac7+5pGCYGd3SwRk2Gjuozm/n5eVy2DRmsRAcnYpbTaHuEQYUpp4PtrAvWztFVTUX699Qu5ej81MFWhQ3Ctn9wHgEDu43BsFFXUKzoWhHXGwNAX3qBteVoFbkg+A8nFXIqlCi1TJfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=obXLclaYBKujMmwQ5R+KN08tCSljeRKl8mbha0CzVPY=;
 b=fhaearqOXu2B4QzJT0e3UStrY7XN5Doqor4F55LwOkDDY4SPN9xpk9Nyl6PD1Z9/AYxJR7ng6W6q5Z4bpaYIw6IREEET+8tW16KvaOZmTjhyfB/0nD6+hABzI7um9uGhlKOx1o+4GM1fH957uNrCP4sxzzcO3hSE5gBlPDEvDeXU4eDb04BSCO833VwzH6BVWnLJhB9JF7Ib/OaZTTF2jXiHGudk36VFTrwrquih+d4UYho0DN/gsNrF7eSTbMbfnrJdoD1b2b5NhO5hYGFqXipJiLf0uk0Ff2Qi2mcu5ow6C0H/IVDuGehENkkersleU5S86yPUf4qKL5coWjfaGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA1PR11MB6735.namprd11.prod.outlook.com (2603:10b6:806:25e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Wed, 17 Dec
 2025 04:36:41 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%8]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 04:36:40 +0000
Date: Tue, 16 Dec 2025 20:36:37 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Cheatham <Benjamin.Cheatham@amd.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<dave.jiang@intel.com>
Subject: Re: [PATCH v5 4/7] cxl: Add inject-error command
Message-ID: <aUIzVWxpu_nHBKVo@aschofie-mobl2.lan>
References: <20251215213630.8983-1-Benjamin.Cheatham@amd.com>
 <20251215213630.8983-5-Benjamin.Cheatham@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251215213630.8983-5-Benjamin.Cheatham@amd.com>
X-ClientProxiedBy: SJ0PR03CA0210.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::35) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA1PR11MB6735:EE_
X-MS-Office365-Filtering-Correlation-Id: 10ee79c5-0c43-4d2c-136b-08de3d25df54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?YYSNnNdQUYloMNrt3QXS+ZLgKKnijxsKWi6Dst59tFtitibo6BGFGZd+yQaf?=
 =?us-ascii?Q?EHxZzIuyDJTUk15giUv6WbnZus7IOPoPrfgVE4+6LIpmYccuEFTJIjgC3+58?=
 =?us-ascii?Q?RatY2/eJAHiu3pk9ed1vJXbgTXllwqwtEgH4YjGz+vqtlEinStU5q4CfeCwp?=
 =?us-ascii?Q?AwOcPnTaOamvFoR+JBXHwRehDBLjdXtFnrJ0yqQWRBa0BI1HBENXSQD9kFZR?=
 =?us-ascii?Q?S3Ived1OQnkLumX6APJxMFWg5zlzNTf3xfxe4qIBwchZE6WNM1T7U/kKA367?=
 =?us-ascii?Q?NX0n+94UEeKqErFkMUbYpZOdi935Cy8yDQSdD0z54lvM9PK3eydjFbADMocm?=
 =?us-ascii?Q?D6UjgbjntxTKtARS4X86ehaYajEMwMRrkYnaAeLQeHfAs9uMoHCTGfMXy+FI?=
 =?us-ascii?Q?JMWAQsJuE2svUm9mDr+Y1ELKYRfURRcAxqsSDQpBJhJUTL9WNBXiGP4fhB36?=
 =?us-ascii?Q?WzWTORijEgn0kIwR/IHBqOAEFcboW0o2lFh1SVXKC0Dqn9TQzdsA9cm6UUEU?=
 =?us-ascii?Q?Oc1sMrTlXattQOpCdn2hkHABgcwn4opseHTsbsWBKYkcoAxk2W1rN+aqPepD?=
 =?us-ascii?Q?d88ByFAfhJS/vZZflpHld5HcHbCDNkCKH8AofNKaXHAj9FgRFGsYSXurM1jr?=
 =?us-ascii?Q?tsat13aJ/CO7ceeKrxmDXvLSDxB/g7K1N2+yEVMYSP18K+IK/e3jCd3BsszA?=
 =?us-ascii?Q?D2dY2o+V3IiPAru1sYR2TeYIilKkpWVRRIrR93TsfH87AxU2qi1n4quN2eCn?=
 =?us-ascii?Q?PaKbgjtg/6/TMyASYY65IQNVEQkdJe+ju1YN+TKoFT01DD0imlWi+hxnjEBM?=
 =?us-ascii?Q?4M7Zz3EgOU3WxbKRTiMlsfuSesYVip6jVnAKJM/YKAFZBrSQKMIw7KELF1zQ?=
 =?us-ascii?Q?YXC5zD2QWHtfvTsn0eF1NSulS67Jp58Fynj4dc5rLIFrxsUhJD6PPWbYFvyi?=
 =?us-ascii?Q?0rwiK6CBgAq+KW1BPTeo1z0vkyco5HtpgjTzn3C0Bh21SFDWsBhVEgcwuF7T?=
 =?us-ascii?Q?qM/ndP8oTc2X19lq3ohxvz7ZE3XMMGvEVGy4hc/ugw3cIB/zvTHB/5eAXne2?=
 =?us-ascii?Q?i4uAJ0f3e3cNM57YdcKJyhZ5fu7kUIYCkuquRhUC3loQ7vVtCkFTWZWsdtSP?=
 =?us-ascii?Q?OiWxODydL97ZlUw5gxPMU59eBtPvUW5Jjlj795RV+FBx+pHWR1LFSPkkt3Gr?=
 =?us-ascii?Q?5l/ffopn4ZGN/jA3lj9y5BmbwpTcdGTjz7htlVbxHhkfI4pPs8S4aA6hwZRt?=
 =?us-ascii?Q?Z6pOa/2cLYux8VqGaRRDA7797chpEP8IgYUtsKtj5tyn7WvZkI6+HmJKNX7R?=
 =?us-ascii?Q?Y/57fHdd+paeytiRr1GiGEWveXzrU2FnpN0fz/w45K8OIAbZpXlDIYzBWHF4?=
 =?us-ascii?Q?jxDE0qpojwYV9B7usQpmJOElogTBsvrmjQP9dS8DJNCppbSkOe/kbwIn5H4c?=
 =?us-ascii?Q?qNvI/dDxWaH5a628iHSxBOx8n059llzI?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eFJ81EhO0c4Y5CwvT5V/YF6Ii6wGK+tmKTePyCK1mnpND46U5/SBsdcKEkzg?=
 =?us-ascii?Q?DWuIN8fzJAqJpSwGabR5gFlnGVtd4LjLRyxuXQwhM/c8eZ90/8Wfwk+vYb8x?=
 =?us-ascii?Q?xlU4TbjHaGe5kjbgeHGNtri5QtgH7hSYt1tpRFi7LFURNLXxfeIX3I0AM65o?=
 =?us-ascii?Q?PNGaoTTIRoryMDW4Y2N45a24d87K3SGJ8DFEyp7vCJNV7J61DakYbscNaHOm?=
 =?us-ascii?Q?h+wICw0s+N93PA++eKqsrbCQAc9gCdfqvzU+cq2u/WsaH0BT5FMFxLTvWeNR?=
 =?us-ascii?Q?wCksFww9rSWqXqKxgz6h8+QTs9SpSspMPOd5+NZotNbDSIi4Ios4398WoGVc?=
 =?us-ascii?Q?Gek8sTH4uHDnBPEkMCspYq7HvqvCzGXPmwO4BGJ8LwuaRXb5Fx/HoSdl6f8l?=
 =?us-ascii?Q?tjyWziu8UVgnEZTpf5oSwAvCodDCn+2TIY3asFQkA9veU2cgQkpF6hDOms3f?=
 =?us-ascii?Q?yEACNd13yRs1xERsVzEeOEEbEhsmlNRFytnurB26oNnDG33jid4NKdHjM9s1?=
 =?us-ascii?Q?1fz1LHiK0fyOx9bTOKpFlzr4kg7U0Xq8e4FQE2IyUxEvU5eXgcfRnnsLg3QD?=
 =?us-ascii?Q?zgrNyfv4C2twN4JupJ1NVaXpPrA+IOKZCOBKRCxV5rtfJXjJZ2tQKIBP+Lh0?=
 =?us-ascii?Q?a3fJF4Doc46DOoWj/QN3EDDyH10VFgRIjXFYUJotsMKRAnM6cdpHVw/3mlvh?=
 =?us-ascii?Q?NLY8jgl2Ox5Q/ZvckRtg2EV7Q278xqtSB5XK7LM2PkYXGrVzg1vhg2xm1t0h?=
 =?us-ascii?Q?Ecc93tCl7bLsp+xYeJqRA/YW52sf3oKv0y5794PFwYrQXyeHQwjZV/gww9tl?=
 =?us-ascii?Q?L5lalqXxALd8QOkDbwVL9qEESqeIOgXjeuGhfUX2KYDpGnSnt/5OK2mqgANS?=
 =?us-ascii?Q?tx9XQ0M47UrFXdyOwWmf8Rils7u4DI1tp3vYSPHJHWo3VwQTAVkwRlE8FV/M?=
 =?us-ascii?Q?jssYD+xNm1U9RewVi3LmCBY/6wa966aEYMbqxofesgyV+YT23g3OdbLhKDfq?=
 =?us-ascii?Q?DUeM0d/EMnmIPWjNShd4CIE8XtMuEzalzjtngcf5L7zL/C85kKJ3vAgrxcGr?=
 =?us-ascii?Q?R6pbVQoRspFakIwUh4vKpwrKurwhQP0PYZgUod3iL/KucoyR/QNJ5LRnzvhk?=
 =?us-ascii?Q?wd09axQ74oOYtw3bFpCnAsXF6IDTJd5razBt9IEUMDyJFe3sCj5q1kQw+k5/?=
 =?us-ascii?Q?wB8DiaalnO/30wXxJWTKd6ZiNFd1ZWyVcmAjVPbr+PiI+wDeIjgkxll4+irj?=
 =?us-ascii?Q?OdWQgGKMBMBOLfnpB1tmZ89W8ZAsVdQDcQReURZWaQ11Mjbwxk9uFs0fuuuq?=
 =?us-ascii?Q?USsce+NqBxY8NzBanCRL2o1Gxa+UdfcfDVejsZMnXhH+TFJ82LgHwXVFTa4s?=
 =?us-ascii?Q?N8EeeFKJDwB9mPstvGyJlHqjSiBWVSb8NujjpU+mApZa5kQHmEX44evQZOeq?=
 =?us-ascii?Q?5fqxiC0hTUzOgLtMni6qw+rE5GXGjD4SZ2l41+jRzyrFSvvBUv/38wkGK/aD?=
 =?us-ascii?Q?+wznj6LyvDCFpm3IM7FPt2+sPL1udf0dIHSkoSzlBCSIS/HqZMMWqSvCvV1x?=
 =?us-ascii?Q?S9X0gV/lTVvG5Z1ACuMjDeRukAhMCiHKUck85xCJVO8p3w6jKQ1l6gNYke/d?=
 =?us-ascii?Q?IQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 10ee79c5-0c43-4d2c-136b-08de3d25df54
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 04:36:40.4715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gLirl/dvN76eG+hy5ebTCWS4nL/iMLhzgzQiKw34AkWcRkaL1lLe4L9ymYo9GZyQfuVZTdmuW5IY0UQr9eRkgmjp2VN2HeBMa44sZBAncmU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6735
X-OriginatorOrg: intel.com

On Mon, Dec 15, 2025 at 03:36:27PM -0600, Ben Cheatham wrote:
> Add the 'cxl-inject-error' command. This command will provide CXL
> protocol error injection for CXL VH root ports and CXL RCH downstream
> ports, as well as poison injection for CXL memory devices.
> 
> Add util_cxl_dport_filter() to find downstream ports by either dport id
> or device name.

Does above comment match code? Does util_cxl_dport_filter() match by
'id' or 'name' ?


snip

> +#define EINJ_TYPES_BUF_SIZE 512

above appears unused


snip

> +static int poison_action(struct cxl_ctx *ctx, const char *filter,
> +			 const char *addr_str)
> +{
> +	struct cxl_memdev *memdev;
> +	size_t addr;
> +	int rc;
> +
> +	memdev = find_cxl_memdev(ctx, filter);
> +	if (!memdev)
> +		return -ENODEV;
> +
> +	if (!cxl_memdev_has_poison_injection(memdev)) {
> +		log_err(&iel, "%s does not support error injection\n",
> +			cxl_memdev_get_devname(memdev));
> +		return -EINVAL;
> +	}
> +
> +	if (!addr_str) {
> +		log_err(&iel, "no address provided\n");
> +		return -EINVAL;
> +	}
> +
> +	addr = strtoull(addr_str, NULL, 0);
> +	if (addr == ULLONG_MAX && errno == ERANGE) {
> +		log_err(&iel, "invalid address %s", addr_str);
> +		return -EINVAL;
> +	}

errno best set to 0 before strtoull
there is a type mismatch btw addr of size_t and strtoull

snip

> +static int inject_action(int argc, const char **argv, struct cxl_ctx *ctx,
> +			 const struct option *options, const char *usage)
> +{
> +	struct cxl_protocol_error *perr;
> +	const char * const u[] = {
> +		usage,
> +		NULL
> +	};
> +	int rc = -EINVAL;
> +
> +	log_init(&iel, "cxl inject-error", "CXL_INJECT_LOG");
> +	argc = parse_options(argc, argv, options, u, 0);
> +
> +	if (debug) {
> +		cxl_set_log_priority(ctx, LOG_DEBUG);
> +		iel.log_priority = LOG_DEBUG;
> +	} else {
> +		iel.log_priority = LOG_INFO;
> +	}
> +
> +	if (argc != 1) {
> +		usage_with_options(u, options);
> +		return rc;
> +	}

The above catches bad syntax like this where I omit type:
# cxl inject-error mem10 -t -a 0x0

We also need to catch this where I omit the option altogether:
# cxl inject-error mem10  -a 0x0
Segmentation fault (core dumped)

> +
> +	if (strcmp(inj_param.type, "poison") == 0) {
> +		rc = poison_action(ctx, argv[0], inj_param.address);
> +		return rc;
> +	}

snip

