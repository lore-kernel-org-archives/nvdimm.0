Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6902D052
	for <nvdimm@lists.linux.dev>; Wed, 28 May 2025 01:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748396183; cv=fail; b=XmvUi4SHUNBPWSBoQlMepvNWN++/jZjGJsZ+zhLJ5HkST91IhbDyaJ4uKa2wglVgPpA00pKIH9bNP2HSdCU1EkLR4K9f8ftY+SCYBNbXkWudPTdebvGwQRc6/WbnMbXgtfzxVGoJdkG5q2Y62lj/pgR99N6RPAfokVYOXb31AtM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748396183; c=relaxed/simple;
	bh=yO+VrVX7uwg3NtZsfvfTUwG6UPISzPmszwoO0MxisNo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fsIW8bOXg4y9GPgphXFtp9yH8Ji5tPoxD+jTS0yrGiB5yancwMWTRYzWzI3N7YaqD3/Yw/zfBQ4t7JDEq42v2t5xnlyvLIMKKeX8hceiic+ClLk/WXY0P9ttoZYDwWT2pRTUpkXUZbOk4UAcxNmr31E6VDUZm/r6XFDzGGIQt/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gjtI1ceZ; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gjtI1ceZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748396183; x=1779932183;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=yO+VrVX7uwg3NtZsfvfTUwG6UPISzPmszwoO0MxisNo=;
  b=gjtI1ceZpnXOqCExla5XjJVbs+Xh7o1I8jkjGnWKnw29D1T40AKeHMd3
   3Ikbk8gNw8OQh0L5/b4HDD2R9YSvQZI4NCCms6EdmZCIk6Y7ukELy7QoU
   K3uDc05Ce/y2/k/XmiQu7xNGnxf2IcIA65XP9G2gG7RCCSbF1VqYaPx33
   YcXWQnyDIAOsySZclRMFVNptWpKmxPDFYgGV6m9KEE3JLcySdes+I11sA
   CS0Ex9bp390xelUY/5G2jaFR24Kr12P5Z3l2ouQK5n1hC4w32hX8bsdtZ
   3CAt+Z9WDnYAv5aI9Hf4sVymkDoGo3DaFxq85MNctwo0zhUlLVOhZetVu
   w==;
X-CSE-ConnectionGUID: FjoPh+tIQfqU776N20OQbA==
X-CSE-MsgGUID: FgzcF0qKTe+RdR7v+ymz5Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11446"; a="50282542"
X-IronPort-AV: E=Sophos;i="6.15,319,1739865600"; 
   d="scan'208";a="50282542"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 18:36:22 -0700
X-CSE-ConnectionGUID: ORkxQxf5QyeEse3EYCXuRQ==
X-CSE-MsgGUID: PQoEuF/gT9ar3O/OxDD9cQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,319,1739865600"; 
   d="scan'208";a="142980748"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 18:36:22 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 27 May 2025 18:36:21 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 27 May 2025 18:36:21 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.61) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 27 May 2025 18:36:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a6XdCpQgFg4ZbH0TvHqL0WCTq+81ODpBXO+rw9COvZSmwRPB5IQn7NoFXu2pAqq4FKGEd5lpUlLNiO8pj7wVMkcT1oN3rGuFXwkdPdeZ252u3qm7ZXxBTjlqrbv+hi4vMdLvqG2bLpQ1f4MVqKuFmNzXSFq5VweutECk8qjzARylo9tdDvGi1REsd5j0oJqNUtggfKA3Qf03epSYgvtqhhSr3ry3Tq2JmVNLu6USAw5+dgukz863i3OB/muZCSoQf5xzDEHfA+AjioWwNLexvJR+hrM85juro3x+v0nEQh5sMoEjniElqxvOnvzxB0VcXTdgKn4JWfMGbdESekk3+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=65+XZMwgDGyGo71151G5J1nPxHyb0Ur1LjoC/tiLqLo=;
 b=Oo3nHjrvssoGc8FVeFuc3p2RjncvyebF7DyPPXgy9pkRxKQBDdmK0O0VewRZ+JT96xioXrr3KvJxF2It6rKp+a8mZpYyiotaIjxoD7w4XWIQlsJ2jVf8ZeTBK4LxBLVDKvaEQ2wHBbwMIKvCEo7kv4nRex7GeQ1MbkuO3Qvrp1UYCEN2tbf4T8N5JNUN/LSNWuCUE2bjM1EN8cMarPfqUzzLZ8UO/DhHIhj6ChcSTEkFQCaiEfMVIYD4MbNfOOt06GCSyVzW5jHjR9HsPoBFQg+59XPUNZrBYDbwqmsxYkEZhhUX9+C6qYBlDZ3LgS0cz3ZgQeojLlaRu4ztSfBnTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by DM3PPF97A7CBDC1.namprd11.prod.outlook.com (2603:10b6:f:fc00::f3c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.26; Wed, 28 May
 2025 01:36:19 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8769.025; Wed, 28 May 2025
 01:36:19 +0000
Date: Tue, 27 May 2025 18:36:15 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<Marc.Herbert@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [NDCTL PATCH v9 0/4] ndctl: Add support and test for CXL
 Features support
Message-ID: <aDZojyrklB0-BqEe@aschofie-mobl2.lan>
References: <20250523164641.3346251-1-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250523164641.3346251-1-dave.jiang@intel.com>
X-ClientProxiedBy: SJ0PR03CA0171.namprd03.prod.outlook.com
 (2603:10b6:a03:338::26) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|DM3PPF97A7CBDC1:EE_
X-MS-Office365-Filtering-Correlation-Id: 15241039-8a93-4bd3-9abd-08dd9d880b6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?uopj8qO6HuJcJQsqrBYMFILk5zgI+b/IX1uR+FCbXhhXyqU63xfJOv+7/aWf?=
 =?us-ascii?Q?kgduHSm/Emd4DJ4C3yAeHZXJk9NKcK87Y505VQT6Q3n25tHtVEWZ1UHvXTgh?=
 =?us-ascii?Q?12u5wAEV3FT3rTeyhD5EhI4OSFuXg9eGETkLCYi2HB+xCgJIhh356kPHXBVs?=
 =?us-ascii?Q?DYjCHu3VSa3x5kJGEdcxWF64ItIbOHppWv4A1ZUgtBzMc85uA69aPcAfK5s1?=
 =?us-ascii?Q?zcXBqhDDuBo3oRiAWSGK3MHLqr0ObXLPmHKiqZzeNN4PJOtZ/fiuyzrkL2px?=
 =?us-ascii?Q?froLtsxlI4Tqtm4duiwwrf5sKfXAlyxRDvxPMw5wcV+2oUBdjuR7RT1200va?=
 =?us-ascii?Q?PzdJoOYhjEwNIboYb/T1Z2qWHK+QgY+SXQ4TTuUSEHS/GnpAJqmduERIxpaD?=
 =?us-ascii?Q?pgpGf+fQouE36apjPIvKckbFFYBfgfCAD8exbrmgcr6tQxwKLuigywC65FEG?=
 =?us-ascii?Q?Iyc2MkBodReQdvaoIfd8QjITMjmJk/1ocdzcriRvphqXGlmC11fMW+O3jp6v?=
 =?us-ascii?Q?Pp5Q1n094H3eGIpVNxG10+Iz2VacmOZrYHZ0Ev9OvouCkAjdKPuEyI1qszKs?=
 =?us-ascii?Q?BMtiR9d31esltTwqHH5gBmFDs4wqoEdpBILIl9cg/cGaM8We870LpXIYvFiX?=
 =?us-ascii?Q?D1seuaoIv0Gj1VvTxymS/vjHcJLygqGUBaQeQrnMuUvx9bLv80Zer7LE5Gdz?=
 =?us-ascii?Q?xemIovVlwHLJD3jhdZ1dUWTBdmBX0xvSauh8UiCBbtNUB2y6M5776soxEmX4?=
 =?us-ascii?Q?g1D6jk2CA8PWv+PpQTn3dFZVeq5VNLzGEC3GeYYZfR8PPMek/gyDlewU1FFf?=
 =?us-ascii?Q?fCwL/RPeREXG8NGNpSpA09Dov/iMWvK2GFR7CjsuPO5tRzR/+uTSa5eP6U90?=
 =?us-ascii?Q?Fc1sfwssZ2j3clkuBEzsAFvJwN8sZx9GECunPcY+Pr7RZYOhOZqBgXT+jeuL?=
 =?us-ascii?Q?Wz/tBIzpB4hVVo7yLvSKeybka3x2cknIxRlGwt1lVAAD54X7V2T7UNn+pRIV?=
 =?us-ascii?Q?/JchS09XUvCUoXlH+ucY1xqleFb3htrG37r9aeMz45YY5CxCUl5sN5o/P2rK?=
 =?us-ascii?Q?TRPzNnyPXD7C/f97YivyUm7si+AbeSldZqb/O8ZuS9cXrjVTSd0HaRVBN2CE?=
 =?us-ascii?Q?TRAG/fwNR7JWbV3wMjDK2VgoPUqchs4rKHQEdNHsl1fbSSqZJL5DDplIVmTL?=
 =?us-ascii?Q?XP7/vGwnfOH8wPzqVWcPQCUrVXn9Y1C0Maf6TPqC9FHB76iubEC71A1SL51U?=
 =?us-ascii?Q?fW4JTylpYSfHIRGFtiq+aUs/TeoTIz+wy538iQV57mNwhtQKzjqmmViE6Jr+?=
 =?us-ascii?Q?GTs5Qdt8cghAlLZP7pD2RkOA9Hef/baTAcgW2KtV0AFtL5QSaEuH+PFbShuh?=
 =?us-ascii?Q?fj7SS/8CxhW77/eTJ+0WMyojh2nu?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cq2rUwfmr3uIkrsOAmRg+rp8dXPe8adH+0Y2GhZguxBCjcYbfp6kGQ9JZkme?=
 =?us-ascii?Q?TV/98kklVBYPOLxkcCrq7VunEYa6MSmLjTdUiAA1B1IRdHRWXS4jIILFBqsn?=
 =?us-ascii?Q?T+TJzTEu6idmeJWacuJ8QVJEOKcZP2neq/WBBcUV7jOXTAgm5Q5jXcQGZ65m?=
 =?us-ascii?Q?gJ9S0skWk+tLvTF7d76iFiQvl1ovbyJ+6QuBOBJdwQSlei+P4qL2tDE4wr+5?=
 =?us-ascii?Q?nud52+jWolfKixDktvsq2h9J2MLkJI8+ul+obAcQJlqAGTRNuDCmmDj2vE7q?=
 =?us-ascii?Q?Bfu/41fYgBxEqciBNvF8hdUWkmd9Tilq2PfnD2hHE0efi9dQfH7cBNutbCHU?=
 =?us-ascii?Q?t0/E7HGuxrGstdU0pPSHGKXX/3EnwU0OqWu2DBV33mYXpZxCE0RC+FWFDN0F?=
 =?us-ascii?Q?h3kVfMKqGhVKXmLK4A7nrcKI9RMES5qO886CC21kN4pcDvqGTQwaDFPBNtK7?=
 =?us-ascii?Q?2MLm/zj8srHa78JZfOYOfzBtDlUHrKpQ/FoHESC+YIQHqRVkSyTU7YnRn2bO?=
 =?us-ascii?Q?qPage8gKpx79+d9I9Vyyh3FUMpIbdC+vlb9RHHd6hq8cNkstoQ8W7I0jRSBd?=
 =?us-ascii?Q?0W3TS2SlX39BEGyTMN3vIlSpO+rsUa4+G85+/Odq80TQ7E8P9bBWGLukVjqV?=
 =?us-ascii?Q?XulFbj+/Gb30DNGQIblNb8nlHKpQX4oYCqQq35cZ7p/YtwHNRheZ+ihVitCq?=
 =?us-ascii?Q?LKL37UcOpj5fZZiFHqM5HbiySU0R/HmShtfkYJ8CAyJHSNcIX3N5Nq7irrKr?=
 =?us-ascii?Q?1HvtCN6n0J9gkWS/5ZbCCD4268eKgNbAnZuIlhsHjuwfNhq4dPREE0VaXjJS?=
 =?us-ascii?Q?QBwR46ylngW8lZI/KpVrEYfQwf3QD0drpyJ7t67AWe/vCCCsxtkVmsa10Lfj?=
 =?us-ascii?Q?3+DdH+WiuqSpPycGr44FpIrB32v9+pK7CEN4z8cY3cVpkAhmLLjftbdPdx0X?=
 =?us-ascii?Q?uc9b5qJQyU2Yt/lM+x5zXyb7bKOBr/JeAnzgofQIFQGYyj/6M0thqbEZKkT7?=
 =?us-ascii?Q?5NgLSOwo2eQw6ytAwyz1mv/1SIoFjO7OHn1N8mcMJTi9VZfLEScilnJvl/qA?=
 =?us-ascii?Q?kXU+vjYBlXF9L90//2TeCsMDBndJMI9IwHGt84TCT+qjI5/jkZVxmavPEV26?=
 =?us-ascii?Q?VczmgM7GDQXMMst34pIE+iqHB6JKDT2h9GkzUQGyEUTkr94jhdf6DIF2fSiN?=
 =?us-ascii?Q?pCzdGILDdlPpqSBdSXTkIAiIdxPy+GMvCXRCnGTlsX2hxm9lb1JsWYtsO/At?=
 =?us-ascii?Q?aPpRXn1qcfnb1MEctWXA3BhT70nphMau8k+R/vt8vDamEBOUhIq4+THK2klG?=
 =?us-ascii?Q?lwNbcq19cqUaSNKFsrgWgZuM4M/c8nnVs9ZLixckhAf504kq/pHrZ+t0H1Gx?=
 =?us-ascii?Q?e2eY7J1+mNTSpftbdSQAwlLIkGN8GEGKzSBQsaUheiyobnOwGtc3kmBApDRt?=
 =?us-ascii?Q?xWxkUkpyn2Ws7Iq8wLcvmgioEpIx/entiac/f2LdZF/PO/arThlaeI/07XCJ?=
 =?us-ascii?Q?doZ9+A+5dhwJSUdXnbsXmxobezOBOwbEwepr1sxhVZLeyYib+a/IKktSa0gL?=
 =?us-ascii?Q?0ntz/dZXmuia362xpUhzxqlhaH9CT1XrnKr19rs6poToCaJoKNxWHUiEBUij?=
 =?us-ascii?Q?LQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 15241039-8a93-4bd3-9abd-08dd9d880b6f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2025 01:36:19.2823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2uvEwUPWfB1ZunDvmmRLqzqmBseCypb0rpxBZjWD9a8XXvFu3vPIT+GNA0Amh/aU0HFqMb8FMRPrXIcVKbGXqg43mhDYeYop+x4Ou7FSHpE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF97A7CBDC1
X-OriginatorOrg: intel.com

On Fri, May 23, 2025 at 09:46:35AM -0700, Dave Jiang wrote:

This set to applied to ndctl/pending.
https://github.com/pmem/ndctl/tree/pending

Marc & DaveJ - take a look and see if the unit test reflects
your last comments and concerns. I err'd on the side of
like-ness...keeping it like the other cxl-*.sh unit tests
with respect to what is kept as boiler-plate at the top
of the test.



> v9:
> - Move script body to main(). (Marc)
> - Remove uuid dep for test module. (Marc)
> - Remove removal of error trap. (Marc)
> 
> v8:
> - Stash fwctl discovery functions behind ifdef (Alison)
> - Deal with old compilers and __counted_by(). (Alison)
> 
> v7:
> - Move enumeration of fwctl behind meson option 'fwctl'. (Dan)
> 
> v6:
> - Rename cxl-features.control.c back to fwctl.c. (Dan)
> - Move features behind a meson option. (Dan)
> - See individual commits for specific changes from v5.
> 
> v5:
> - Add documentation for exported symbols. (Alison)
> - Create 'struct cxl_fwctl' as object under cxl_memdev. (Dan)
> - Make command prep common code. (Alison)
> - Rename fwctl.c to cxl-features-control.c. (Alison)
> - See individual commits for specific changes from v4.
> 
> v4:
> - Adjust to kernel changes of input/output structs
> - Fixup skip/pass/fail logic
> - Added new kernel headers detection and dependency in meson.build
> 
> v3:
> - Update test to use opcode instead of command id.
> 
> v2:
> - Drop features device enumeration
> - Add discovery of char device under memdev
> 
> The series provides support of libcxl enumerating FWCTL character device
> under the cxl_memdev device. It discovers the char device major
> and minor numbers for the CXL features device in order to allow issuing
> of ioctls to the device.
> 
> A unit test is added to locate cxl_memdev exported by the cxl_test
> kernel module and issue all the supported ioctls to the associated
> FWCTL char device to verify that all the ioctl paths are working as expected.
> 
> Kernel series: https://lore.kernel.org/linux-cxl/20250207233914.2375110-1-dave.jiang@intel.com/T/#t
> 
> Dave Jiang (4):
>   cxl: Add cxl_bus_get_by_provider()
>   cxl: Enumerate major/minor of FWCTL char device
>   ndctl: Add features.h from kernel UAPI
>   cxl/test: Add test for cxl features device
> 
>  Documentation/cxl/lib/libcxl.txt |  26 ++
>  config.h.meson                   |   3 +
>  cxl/fwctl/cxl.h                  |  56 ++++
>  cxl/fwctl/features.h             | 187 +++++++++++++
>  cxl/fwctl/fwctl.h                | 141 ++++++++++
>  cxl/lib/libcxl.c                 |  94 +++++++
>  cxl/lib/libcxl.sym               |   8 +
>  cxl/lib/private.h                |   6 +
>  cxl/libcxl.h                     |   7 +
>  meson.build                      |   1 +
>  meson_options.txt                |   2 +
>  test/cxl-features.sh             |  37 +++
>  test/fwctl.c                     | 439 +++++++++++++++++++++++++++++++
>  test/meson.build                 |  18 ++
>  14 files changed, 1025 insertions(+)
>  create mode 100644 cxl/fwctl/cxl.h
>  create mode 100644 cxl/fwctl/features.h
>  create mode 100644 cxl/fwctl/fwctl.h
>  create mode 100755 test/cxl-features.sh
>  create mode 100644 test/fwctl.c
> 
> 
> base-commit: 1850ddcbcbf9eebd343c6e87a2c55f3f5e3930c4
> -- 
> 2.49.0
> 
