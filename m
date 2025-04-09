Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E941E5205
	for <nvdimm@lists.linux.dev>; Wed,  9 Apr 2025 22:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744237351; cv=fail; b=jWyXgwIo4kbDGXnob1tLnWy0Le97HcbBFC7idvPwADvNWwTONNe8ODF3kIfQFD2BUm/K+Nn/AwjMrdzBdPTsVMr3GyX85Ga+69E2SBkib8DAoHloH58+NJ6b9g9xBWT5X6At+Z5FfUjAbtoypxUR7IdR6/4n4k+kukGW3lWtR1Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744237351; c=relaxed/simple;
	bh=WUN8sFsb+Y3u5k3fYrWjaOlHs15YB1iShXwICB4rRqY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=V+u8i95l77toe9n6awBeZiFxriKsyFDwWNltKOG9ahK6QXN7ci5/AJFy93tI6Px6EJlYTMh7eIZxnO2oRIt+NzC0D/jLnCH201Yqv63/htHQsDia8vmQzXxacUx/FqNXKfna/7TM5bx0/Xvaof/YH2Dp3/sfH6NZOf5fxX7GGmw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=liDFiyo9; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="liDFiyo9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744237348; x=1775773348;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=WUN8sFsb+Y3u5k3fYrWjaOlHs15YB1iShXwICB4rRqY=;
  b=liDFiyo9t/u8HhmWfMM2ivbicfNwxp0QObU2V1ZZ04J72M9hQANcW3/d
   WyxXCYvujnG5ruPAYa8YNaIot5D6MKQ8GDfRXADIdj62p8khvmpYd0RqB
   N3kl56jFQ8qpHUWg8lT4pGmaQg5Z6l3o232dlVtdp2pH6+Z8piNh9lwXy
   tYHKQrp48x8nP6DYeY4HnEmcPnwVmqK4XWVAozzGWLQWe8GcfkykkNk2L
   xySx2akr0vJhqS+0vWMXWxNXDD/6FwyngQvklkA3jdDkgS/BdY2dPHXal
   ZpQMUkg5bxqlkRzj9JD/JziEa7Dq80PvGjuVgOn4XZRuNyfz8aufz8VnU
   w==;
X-CSE-ConnectionGUID: TFrkL9iPQzuGQ+nLEoxDVg==
X-CSE-MsgGUID: CVC+mUvhT5Wg9okKwC0RBg==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="63130986"
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="63130986"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 15:22:28 -0700
X-CSE-ConnectionGUID: X6b/vKM4S9yWom31RXSDyg==
X-CSE-MsgGUID: Wd4U+MoTS0CUcYtq4JL/sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="165932938"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 15:22:27 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 9 Apr 2025 15:22:26 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 9 Apr 2025 15:22:26 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 9 Apr 2025 15:22:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KusK/Xq+CISyp1MvDFnIZmCcE6lNxNpGx7/6j8pt5j6pFa0DbhaKXaZXNVOtbxTQz3VaxkSkHLcNwVTI4ZhFYpvQJkraQqtGXZ8qpyuYZV8fgB1Ik7G6Hmau6ovlLMkdy78GgxzHSnfG0RiPJWVP0jkWb3oJQxDJWlyzmiQY0quDwnMN2/Bkvex3+DEx6AM/+omyOtPMD07ruJNZ0bDjDaMvJBL33RGLR+W4Oyc6Fjx9kkoB9qVbBYw9n8+p6Ht5TGnXnRLp+/AS1qgySdJNFMiEQz7ztcKKkjWiQhogXFEHzL5BXvkLQHYKNtwNpi3UjRCqefkUh03gfGRlKkKfsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CTNeOLt81ziHketwi5RthvODKyl73JuGT4zWKh+8hPQ=;
 b=UaNCadktOEd909bWGOUC7tkfV4BtDBG/vRjLElxn4jthuE+N5a1p4SWglTG3V2B01IWNsCkd4TOpP0oYY/7gP529WVH1BdiE8ERw8Nk3qgDRoEoKRO3hCHYbFHHbiPHBJTI+beMlZ/6SZGE5l52tPHecp67DXebzb02vrxqdjnpsr8mfmG93UjGIzhdabytI2HgJc5Tlds0YvDlUvaaT7CEs3eOFbdz7u6wdeDeJ/okAF5ae6T+9kEW+wlWCsHdOd0TUeTl7nyG1UGFX5W90vD6gYrilpCKIt+VUf+IqUFE2wjBiWQW26tpkjfjm9FQeBkvoM+He0SPEg28nyu6bgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by SJ0PR11MB4942.namprd11.prod.outlook.com (2603:10b6:a03:2ac::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Wed, 9 Apr
 2025 22:21:57 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8632.021; Wed, 9 Apr 2025
 22:21:57 +0000
Date: Wed, 9 Apr 2025 15:21:53 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Gregory Price <gourry@gourry.net>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <kernel-team@meta.com>,
	<dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v2] DAX: warn when kmem regions are truncated for memory
 block alignment.
Message-ID: <Z_bzAapzjzFR3u_P@aschofie-mobl2.lan>
References: <20250402015920.819077-1-gourry@gourry.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250402015920.819077-1-gourry@gourry.net>
X-ClientProxiedBy: MW4PR04CA0309.namprd04.prod.outlook.com
 (2603:10b6:303:82::14) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|SJ0PR11MB4942:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fd250b7-08c0-4f44-fc86-08dd77b4f0bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?j5Tx5lWA28/jDvcLzN2SO/Dlu9aY9kuvNHPEwZTxDgnT0kZey5ZHWRHrPcVj?=
 =?us-ascii?Q?Msxnt44QrVguZDF141A04p8TuI/NVDCGCNhXxRqAF7VM5hQwL8kufmLnWvHk?=
 =?us-ascii?Q?uGlrUm5f9h8J5oBFoaY/lXcPQ0WV/tzoEs6+wrn2o59FdRLbEefyt2A1y790?=
 =?us-ascii?Q?43ounHAtONBdUnQd/1WAluibkQAPlvo2i5uPN8dbqv5NvxGzBCjvke5E6nF7?=
 =?us-ascii?Q?uWq1qizk+PwdFYPXhRlsdXiaCgKuLt2zSOUOcGCmDHzbLPe8Oy747/xbOLoH?=
 =?us-ascii?Q?UH3LT9qDbW8S4Aw6tVMEzQjg2h1H17Jj7N3CcQik/nf4I5QQEM+7twO7XzTm?=
 =?us-ascii?Q?wnAKKikl2EQ66WTEkdUpKdWSw7Y5pZuNIRvCDFGL7dEcfc+FIBOsn9nwPqfZ?=
 =?us-ascii?Q?Lx+kxqmj3Eqslr8ykANTHbAgnrX/oIl8JyHK2QvigCyoTt2tpojq8pChJyES?=
 =?us-ascii?Q?0HaO3JAP/J9OYmbr+m+4NySbERuyeFnNoJEmYi0Gh5hX21B26T7wjwEyao3z?=
 =?us-ascii?Q?YmE9cwvzH8QzIABAJIvgqAUH2EL7uaqHcl4Usjc4qDvZgHPJ3BD0l8jpVOlv?=
 =?us-ascii?Q?uVbS7RafxcOPD1VzWhmSPBvLydy8Q4EO6NQbR4spwlXwXF+0G0tpMzDZYfMC?=
 =?us-ascii?Q?nsp/CjzHboZG4Aagkwu2rwjyIrzILwzkZy/UroKKeVgilDxLHG9xNG7D65F8?=
 =?us-ascii?Q?9rmDB33xwafeCZc68uOE8gQXvpr8IEFiOT8Ymrz+OPEnVrOzvx3HPi94VzoF?=
 =?us-ascii?Q?DVL/yfo+VvdVuutp5oG/gVPBmdX5AZFnCr1v0LA2idvDWU7nzz15tqTGfi6w?=
 =?us-ascii?Q?BHtCIW8s88Oce4BxQ81HBUYewoeuyMTNfw8Cz2OXzU5iO3Hrn6uYWOkacv5A?=
 =?us-ascii?Q?Nhepk7R3GjLXc3DAwvjEFOgHY8s1H9Nz3jZC+jgw/sAJllnwZtjp8Y/hKtKO?=
 =?us-ascii?Q?+8P2yzKTyQQ/N9oQLdj77h5/OZDgEklMrAuUN8SJjn/K/R+J2xJg19asfuP1?=
 =?us-ascii?Q?yVC5Ra/jqme1leU95KVVH4w0NazDNzTAYdTRXF1+ds+oYZaOOU3I8f+Y7nEz?=
 =?us-ascii?Q?a/B349VJ8bmUEGefqzZCMAsp2HoEZeow0MPaNW5Njz6jMCviZVHxtmkmMKEc?=
 =?us-ascii?Q?XJuKjzzC4nfzZ1WHc/5pprhSu4iSena/Z1lXCysq5bDlLjM92I4Xv2EuO0ma?=
 =?us-ascii?Q?vMSsNsc72Bso18MbjgZCP2Zbuwl+6i/MnDbSbdQIdbeEVhV3dgv8iyZepYDt?=
 =?us-ascii?Q?y7ylkpzmiIVuTu0Fe4E8tKgYYUo5NmpE/EMN140xdE+uXLHgknoN+VKpRIML?=
 =?us-ascii?Q?6P3M1V5rV8OJoUqTrm6YI2tL/e5gq+rpMw2CiDet4d8G2CDh+BsmGqU5q2i5?=
 =?us-ascii?Q?UFYQpqXiaumaVFstJFRbtXY9S5En0LeQyOfOqQ6plJat0HzlQHHDzqZiqou/?=
 =?us-ascii?Q?u8m1o9u1rso=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UyLE7P2c4SfSk21X/o8z2JBI46jwr9LPULyncbxQhzV7tsVio9i8P9J9MrEm?=
 =?us-ascii?Q?W8WTG0wTRAJCX+06y333LhlYTWYTZ0U3yD79ah67a2fuz7taW/hC4j5SrwmW?=
 =?us-ascii?Q?QXd4d3u5VMldV9ECSBI4YzS8V/2DMif3GJgXmMynVoHCWkHwcqf41Dl8gCl1?=
 =?us-ascii?Q?E6ulKKWqyPH4wYzGsMa/XcW2aWtUeHMFQT9FkMuysJhLtdftp8WVL4z16Yte?=
 =?us-ascii?Q?Nyqll3FJqgk8vPtAXqO3sdOmr28tL35XD8QuFxwpR8EP+9Y7Le6ObIk5mobX?=
 =?us-ascii?Q?wy5fQSdfY2dBLHbDzkzxq5f/dbo3dM8CSqQonxQKvo6fTutt2UgM7NUBtrYc?=
 =?us-ascii?Q?YVdUJkLxHzImYXljUbyMYdV6hD8pCS7LLcI7pNrneg1QKkui4iu8Zrp6lYtZ?=
 =?us-ascii?Q?hvu4twhVJ37Dj81Na2tQ7PLzI0mpADoDpS23e3sbRY4IKxe2fBG5Fw10ylRk?=
 =?us-ascii?Q?xBFC83mgrhiTBIcUgMlbuYFFh+wXczHFttD2FnsMNmRKIkbPa6JV2d9UMJgj?=
 =?us-ascii?Q?Yn5yP8fmkpixcpiS3NXokR2AKqwYXe31InVnUDJd9GWULLhBYgOpbu71F+A1?=
 =?us-ascii?Q?FesElEANq+gsmWXfaEW5uG6Fr3X984kbv901BggNNGVxhLKsyLok+AN1N1sz?=
 =?us-ascii?Q?ypjBI5zdNkx0/mcZd6dEJZo0nlr4OfX7GbusC65FBbGeuePrGwtEmuvKL56x?=
 =?us-ascii?Q?1KU6YM7Jos1f6Pa3snJdRez8RiognndLhbEd2YV+gaYpd0gVQUgpxspRa9i9?=
 =?us-ascii?Q?pQ1nuGF9OfvZVXiPL9br2HsbTpIEaV5DoT6UPHIu+b/lj7hy0Bvmgvib9jL7?=
 =?us-ascii?Q?k7CaUkeSqKYSl/M4WdXeD7yjXjw4e0SI8XEsJFw9Y0ZqmIzUSG+Thv3aVIDg?=
 =?us-ascii?Q?WCf6WmYgtorhXVBTcUl96hwN+MgPb8WniNJZU3KegbrSsfVFg22ean6PaYr8?=
 =?us-ascii?Q?kkIU0GYR+ufA0DlJcrNNpGUEzhuEaf77orkvVFs4GFs3kHJ45v/jMJJpjLrS?=
 =?us-ascii?Q?n9dMHh6T7PqrgegVmwdwEB3zAgEZUpL/jGZQYdVQmPYvmwoX7W9q/QUTblRS?=
 =?us-ascii?Q?AFWa4FU5UmT8KaYcSoogZMnxUTuXHHdCvtaQoki2IhgzEYblMeeKfrSqhU3I?=
 =?us-ascii?Q?WBwexIOT/aIlOWrGNA6rtcoSx9R2Wp2P4qjUHjprT7m62OyF3CF7d7scXLsT?=
 =?us-ascii?Q?aHxzq2IhRx/vP7AQwQJsA01vu1uYAYxNoecQ9H2bCZNE40R3f4JqbhbWaGRb?=
 =?us-ascii?Q?isqc43zzCIw5lJL1FKvODDhFjh2iPgCJ+85wbRE4wM6QIzOLN9vORqqhoRTB?=
 =?us-ascii?Q?4+Rb/iMlC+VTncdiPlokxcYNih5rNnYZyuYR8BVrbklwnnOYskNqhTXCkyJ7?=
 =?us-ascii?Q?DyzzEbKUWjt6m1oQe37+8ibD/gkGZAeapUa1zDXxEClAhECSn1Aiu9rpUfRm?=
 =?us-ascii?Q?WmGvtC9Uqdm16zIAqQrw3g5c6cLRXwGRpEgcJIqicBL/tr+1XEDLS9AQkKsa?=
 =?us-ascii?Q?8cpg7b9Yv+u+92C8zfWURIH2mZCqyLkBVUQRpfcVxTE4gfQNGu4qRTEkr1VM?=
 =?us-ascii?Q?WQNECgaO8IXGnTVuaVlZjgGiwJqUep51U/7mNQZ+cWho+mxP4oWhWLcOEGW1?=
 =?us-ascii?Q?ow=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fd250b7-08c0-4f44-fc86-08dd77b4f0bc
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 22:21:57.5708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dKzOh1B5d7xoBNUPg0ytlBNCPyTMiHEuYKIrNSTTHCqC27PyWApIQ0+7myECZFVW4VAm5lmToPqjw0Ios9ywqQkgDFUx8lq57sqwVRq6z7A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4942
X-OriginatorOrg: intel.com

On Tue, Apr 01, 2025 at 09:59:20PM -0400, Gregory Price wrote:
> Device capacity intended for use as system ram should be aligned to the
> archite-defined memory block size or that capacity will be silently
> truncated and capacity stranded.
> 
> As hotplug dax memory becomes more prevelant, the memory block size
> alignment becomes more important for platform and device vendors to
> pay attention to - so this truncation should not be silent.
> 
> This issue is particularly relevant for CXL Dynamic Capacity devices,
> whose capacity may arrive in spec-aligned but block-misaligned chunks.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Gregory Price <gourry@gourry.net>

Existing unit test 'daxctl-devices.sh' hits this case:
[   52.547521] kmem dax3.0: DAX region truncated by 62.0 MiB due to alignment

Tested-by: Alison Schofield <alison.schofield@intel.com>

snip

> 
