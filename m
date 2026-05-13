Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA733A5E65
	for <nvdimm@lists.linux.dev>; Wed, 13 May 2026 05:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778650360; cv=fail; b=tNiNhP1Vy90T4ro43uxRrNzC0INaI30fpIElV6c0fzyxCaHqh4J70izGCOnCfBtaxCwuJY7HWaQhDf4aUEdB5RwxDVXeWSOtGqlFNbF0DBfWdRQIx5C4wVnQFUy+XewYe3bMBj9ruyBObSitmp58EiPT585ibj96JJYDAq4At4M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778650360; c=relaxed/simple;
	bh=9ENRS1iHArjSLjL6Sveo9dapYt9DL08z1wl0pZ/H8t0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=d9xbCxm5xYWbe3jCGIzTP0Snpe3XVT1z18/qTw5WYqNW1VvzBXkpM4lVqBv5/7cw7l7ZmCH/TdHAmyWR3wRStM4Z6dYiP9VmljTORa31Qt8MinYBgQyXWV60JmYVue/9vGUFrmoGtTDpnJ/GXDcNdfWJWFVbkDOCNcW8r8TA7T8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VYBemj+4; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VYBemj+4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778650358; x=1810186358;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9ENRS1iHArjSLjL6Sveo9dapYt9DL08z1wl0pZ/H8t0=;
  b=VYBemj+4sVwApRe7CFc8CNdtwFbKbHwTy1+94JYycP8NE5xhkCs7va+G
   0lY+OLaLH1aC7h09HpHyLoJmCQ1dur9A0peOzqDvCdR3tVtvWz5olmjyL
   uy1UnHdw2zrZypZvdYjzVwXVjGrXQjZjmNpCnNG1SjbZg407k8wxR7hH3
   cL1HgUfyXcRmYKkhPfI5Zb4Pj29WQ65RkyJtpxF3KCoh+w16ZcPQx50Kl
   KoPX93V40smGOm1oz9jn1/DdJy931zUL7SDSOf86qF7pOKhz+CYm4/5rI
   8e5N44lh62pvludIMrg02ZDpLP9kaMR0Bx8duQJeyHyWhBsak4FxtCiXq
   A==;
X-CSE-ConnectionGUID: moevU8MwRWGMoq8Ak6LRew==
X-CSE-MsgGUID: Q6VPLDWcSw2uBYv/l0jHIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11784"; a="97136264"
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="97136264"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 22:32:38 -0700
X-CSE-ConnectionGUID: NGyquGxYQpyvwVEP/EuLBw==
X-CSE-MsgGUID: eB7XBmOOSMuDQH296Z/acw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="233706498"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 22:32:37 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 12 May 2026 22:32:36 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 12 May 2026 22:32:36 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.46)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 12 May 2026 22:32:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FaqV+p/bo+20ddhUpq6J1ideZiXe4m+wwkgbtTGYq8VHFNRX9UcA3ykVgevFPwPexGhG2O1YsKjlQC2TJV8PKtn0z6MbUBTCgcbByJuETWaHTkdxk9I6lPtLbuCqxQ1bjijPVB/3MVyvd2JdLwrqBYLfBKc1hv4I9HJzW5uH93AdXMZgbDrBYv6pTkvVbl+Yu5Z3Fa6g5iTn81yKEpA4EFAywbCaXbE0JShX5pbPIODPZZc0l/g1hF6vqAfQUNrDy3PTODjS6w0++3mrn9UFW5aiP57bhiNa6aKLdEqA+jBtxsJfo7Up1nh7dHdEjDji7aXWsnepWGTg0Mf+t39fFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wqQQ5JD6GZbIculwxRu5XFY32FDSRgI7Uc32uPZAqLI=;
 b=KZrojbqc+JOgYBNjsBnuBQ3HvEkIO23Zj3ZdkO2JQT5OI5ERLKih0bMTeK27AJzx6cp9tuOh9ucGBVeeBmZcv+n6PuzYD6iKhh+JlLudx0D82wtHeHdacOLmC5yMQNnU+NvZpddVSgTjta8TOYWab9B+ougcjKWC8Pn4uOYx+r0dZ1bjaVjoZtBsxGLKPItox4KcWm6ukbIvBPaxqlX8RRNM9FMO+yRlK2OgIYq8wP6sAiLzjmdAEhJLc1nXPgBBEYYvT08NO99ec5g7RrmsbrwMO9UiHfniVInib3e66tvCwg4qtncrBObpnERC/Id5Hbq8UXpQmtnUQgukiaWvYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH0PR11MB5111.namprd11.prod.outlook.com (2603:10b6:510:3c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 05:32:16 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%8]) with mapi id 15.20.9891.021; Wed, 13 May 2026
 05:32:16 +0000
Date: Tue, 12 May 2026 22:32:12 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: John Groves <john@jagalactic.com>
CC: John Groves <John@groves.net>, John Groves <jgroves@fastmail.com>, "Dan
 Williams" <djbw@kernel.org>, John Groves <jgroves@micron.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>, Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>, "venkataravis@micron.com"
	<venkataravis@micron.com>, "dev.srinivasulu@gmail.com"
	<dev.srinivasulu@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>
Subject: Re: [PATCH V5 1/2] daxctl: Add support for famfs mode
Message-ID: <agQM3KXNMvtbpb_0@aschofie-mobl2.lan>
References: <0100019ddf064477-8322b695-f2d8-481c-9fcd-8b16fc97ad4d-000000@email.amazonses.com>
 <20260430153405.84164-1-john@jagalactic.com>
 <0100019ddf06b207-eaf8cb8a-066e-4642-8947-effdb4848c20-000000@email.amazonses.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0100019ddf06b207-eaf8cb8a-066e-4642-8947-effdb4848c20-000000@email.amazonses.com>
X-ClientProxiedBy: BYAPR08CA0016.namprd08.prod.outlook.com
 (2603:10b6:a03:100::29) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH0PR11MB5111:EE_
X-MS-Office365-Filtering-Correlation-Id: f59ef810-8213-4e2d-fa99-08deb0b0fe44
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|11063799003|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: aBjUgs/qMSMp4tVg0owT43yyd94/aicfJ+zshvCdXq0v3F5rteOQ4wCwBVnYho3i9EITDxKEft72/79DEOn4nFRoBAobh1NCVv7x95bMWusMApP1pTWeNeYNqCZkVZ88UHfkDQOdmOUnLAVT+IgS4gXAPiHRoZbD597a1TwLsirG2wSeSFIhrWLstlEh9IDhyZl7q3dRHknLW0zxx8zJjVbc0QJrjnKPyOilIRpI7J22veB7JbDCjTuegy5Tn+AVKso9aZV6RSeay1QI0dLj/djzJNlCe4c7xRBPn54dM/q4bdPa9EGBfyqWKJKWoK0d6iSoCpgFwXMzkRhY4+pHdvaHii/V53CcycIzSwNT+Wztf7GYrd0G/AESbld+tdXGeNNJauTCVtk18P/DlJ37diPzQzq4iQSUfU9IjPKWzKb5iEATKnlNNwAXdhao8/wBoACpDtz6HlWA9hvdlt9+SAyDxGyWl44BevWdSgXyrDDe9HfrLX9LapPGQtI1Y301IFzSEEZjldZNIupKG8yOzD2lYPU39Z7+aBRRMGade+OqxuDdGMkTnoqTOP8lVrDAYodCvGrDmkG3UAKQuAjNSoUOmG1NXNOILkPg/UdFky0UXwPUyjt9j+GJ1vPZWlxsxENb9h9/P6f0DlMUPdHZkq0t4ZEUbp+EB6qGT7vX1/6+GenZNrP1r9VqvLddTKVU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(11063799003)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rDLyD7B6sxd9433xhdPq0b+X5DQJZdmShWT6pF2lOgfJG4P7tO/B/Yr77SiB?=
 =?us-ascii?Q?nYbAHqb7paKbRd157F5hTsKV60GTfSeenE/VXGSOcJncEh3aRPVD/mylCsYC?=
 =?us-ascii?Q?0nZLHArCK4FRgE6LAiNo34/KnIWqmYbl2Evij6uq3PSdP6qwy32RWR8hLIc3?=
 =?us-ascii?Q?XiE3B8lCu8ZoJSPTIU6eX9/oEaFeyJbyHdmu2KtWgf5yOCFgZu+CB5hWkcZj?=
 =?us-ascii?Q?i35xjYF8ToMRPLURioNRwfy6yfDnF8NrdLBe3RHW89gn/xIrDHIkTj1bapor?=
 =?us-ascii?Q?t7GEHy8R2KsgvUSRnU/Uri3NeizXbVKtYVbEKIzPk3eiEWUR71mURCoxYAeD?=
 =?us-ascii?Q?m0A05weGozjh2Wlb1DOGaTq4z5eRXaY3yhQwQ21m/m+ubzvEk16QNWhjjWHx?=
 =?us-ascii?Q?L5rJnQukJsSDuI5FJlSQmKajzVvDfPxRswGx2OamqzIhM7EavLLJLo9fU3TV?=
 =?us-ascii?Q?H6YO+jl9YauWmMIWJ1BHaTs1j5e4Hemf4lAVxHdMui4ywQHvNn+JdE2fpjr2?=
 =?us-ascii?Q?Cw21617HEWRAvTiyyUsF5TuQ4CmP/bhu1aIJYefwdwd6MxdhJcN46wcZCyiA?=
 =?us-ascii?Q?Q1Exm16qTXpBPoH+zULrAXg0JSLVwmlWUwstIXt2SDal+ZwsGJK9iLmFF+pc?=
 =?us-ascii?Q?Iw/EFfZwlCHAXj2dQzaO4xaiwNIWlOriKpidwCDVCppkK5nBAsz4+AmWVfEa?=
 =?us-ascii?Q?v+HvBIRMn/INPs20EdMMg+/0CX161+awfsKp/Y8kN29HN6mqC4YX35ZuGAHc?=
 =?us-ascii?Q?NZduCsUxkvsUBSGZF1fKEx0kdiCuqk4f8UyUcFuc1GzT3JzG/w3i1S4hS5/a?=
 =?us-ascii?Q?TN6Nyk+zo1SsYfR24aj3X9VQzIn9OhktQF6KquyegSSc5nEUSZwuNfcH/j8/?=
 =?us-ascii?Q?ZCaOn7iuCaljrCQr6K8V7nSnlGCmpQKw/JyybLtbN8flojiUjFr6FAYhto9K?=
 =?us-ascii?Q?exxfQdOVLk6SzJEs76OXvMB2HdR5hyRTJwoxgB9hrLUYtnYs6Y8zO/ql4/sX?=
 =?us-ascii?Q?2oXCbDhEXv7UGyYzNZ0eVkRbGtZ3xu8m3gWhUTnfW+mzyHcArdKd5xI6TP84?=
 =?us-ascii?Q?COEjdoNxj+ZspllOCiliYf+YDfXmmWyFX2tkTJQEobN/GnSpTYuereesZ3d7?=
 =?us-ascii?Q?XdifZqp8akv20QD4EQiAyoLaFLpuq2QOqWmJ4gUCfNjUMtJwwYG9nvppdCV/?=
 =?us-ascii?Q?ugT6hTmjDym3o9/0N8wdjyFFRwLVMeZYX9wb6ADrWsHwLFL7ZXMf+7Y+Y6Bi?=
 =?us-ascii?Q?uJ8WPjaMJx+cqKq1kgHfbPC+51/PHBm4hcvkBPwJNUJC6E+byn1KpGNZD7yu?=
 =?us-ascii?Q?AJL5A/oIlHuFbKO/LvqSYb3h21C9SF39XWmy0WjLJV0RgTU1vdQxMUkFADAc?=
 =?us-ascii?Q?I0CYx7PuSBaFwZswDOQfd48+v+QARIMdFyc/8i3zFV+YKbsw1LbXgj4Ofuuc?=
 =?us-ascii?Q?+VtlaFYfRpZ8Yv0gtznKbAx3f1Aa5F/6rW3uLuXsXluLYjA4BguWGkfZvYQp?=
 =?us-ascii?Q?ejwdUxeMpth9IWf8NHzAjnI4jzRKuH6UxEMpHVC5FJg8SpUcyneLPxh/gtmM?=
 =?us-ascii?Q?kqEuuhCgHFsdYKkLJBlJStiAdIQcxBJNJLy1dwZ55skG7C4dSazH5NErq3Sm?=
 =?us-ascii?Q?KTkff1cUF9lul7N2ATyFabQLJQq15mqtKOWKBADBUpafpgZxGztYWxPF1cQr?=
 =?us-ascii?Q?9VGr1I0pZ/mlsVEE/RFKlkYVTF8TYkMx5tLsJ6nOJK4POXc3wdek1Fq58P8a?=
 =?us-ascii?Q?j12VweJJRDvCRZiZaWzy9JXBCxzKvUY=3D?=
X-Exchange-RoutingPolicyChecked: jhgBknffUGG/cNqi2GECmYFWhdZd7l9WXSyVUfMrpIdNysgWHJlqYVkvmJvSn1XC89btK+57MyXVYVbn4kk4ZUgASKV1mk0Zid3JZFCQbmxoV3Mdw6/hmn/KSU1e/RgF58QQzKR4H6cyn5K6FDv69yWsRPqb/kSRE4CVd4W+jpqGU9FcAQ6wDE+5X95eVIe2QzmxeATlreDRW/nbGbcJB0v3n04vJ9pH3tMzGMQ1ZoQTvMC7mdXdSULIn5hsMYzlz1WrsCLwUe3peWt8Qz9qaVvgrzqfbuwk272jZChJStyjRMl84hNZLKvOqvW/M8bMuoCYJT2jQZFEHmPff8qBWQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: f59ef810-8213-4e2d-fa99-08deb0b0fe44
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 05:32:16.3059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EU/+0u/xrM4EfAObuz11W8O6gfgWZ2z0gJBkEVdI+X2nrHZigsmPK128S957hOvrvRyoywszCPvDGYjOegXaDVlNUJsO/lUvAxXq0ZUIJ+c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5111
X-OriginatorOrg: intel.com

On Thu, Apr 30, 2026 at 03:34:11PM +0000, John Groves wrote:
> From: John Groves <John@Groves.net>

Hi John,

Please add an intro paragraph saying what famfs is, preferably
with links to reference material.

This patch doesn't update any docs. Please take a look at what is
needed. I think at least this one:
Documentation/daxctl/daxctl-reconfigure-device.txt needs to add
famfs as a 'mode' option.

> Putting a daxdev in famfs mode means binding it to fsdev_dax.ko
> (drivers/dax/fsdev.c). Finding a daxdev bound to fsdev_dax means
> it is in famfs mode.
>
> A test for this functionality is added in the next commit.
>
> With devdax, famfs, and system-ram modes, the previous logic that assumed
> 'not in mode X means in mode Y' needed to get slightly more complicated.
>
> Add explicit mode detection functions:
> - daxctl_dev_is_famfs_mode(): check if bound to fsdev_dax driver
> - daxctl_dev_is_devdax_mode(): check if bound to device_dax driver
> Both delegate to a shared static helper daxctl_dev_bound_to_module() to
> avoid duplicating the driver-symlink lookup, as does the pre-existing
> daxctl_dev_is_system_ram_capable().
>
> Update mode transition logic in device.c:
> - disable_devdax_device(): verify device is actually in devdax mode
> - disable_famfs_device(): verify device is actually in famfs mode
> - All reconfig_mode_*() functions explicitly check each mode
> - Handle unrecognized mode with an error instead of wrong assumption
>
> Update json.c to report fsdev_dax-bound devices as 'famfs' mode.  An
> unbound device continues to be reported as 'devdax' (the legacy default
> when no driver is bound), to preserve existing behavior.
>
> Signed-off-by: John Groves <john@groves.net>
> ---
>  daxctl/device.c                | 132 +++++++++++++++++++++++++++++++++++++----
>  daxctl/json.c                  |  13 +++-
>  daxctl/lib/libdaxctl-private.h |   2 +
>  daxctl/lib/libdaxctl.c         |  39 ++++++++++--
>  daxctl/lib/libdaxctl.sym       |   7 +++
>  daxctl/libdaxctl.h             |   3 +
>  6 files changed, 181 insertions(+), 15 deletions(-)
>
> diff --git a/daxctl/device.c b/daxctl/device.c
> index a4e36b130a09..003609e4abba 100644
> --- a/daxctl/device.c
> +++ b/daxctl/device.c
> @@ -42,6 +42,7 @@ enum dev_mode {
>  	DAXCTL_DEV_MODE_UNKNOWN,
>  	DAXCTL_DEV_MODE_DEVDAX,
>  	DAXCTL_DEV_MODE_RAM,
> +	DAXCTL_DEV_MODE_FAMFS,
>  };


The above enum dev_mode in device.c shares enum names with enum
daxctl_dev_mode later in this patch (in libdaxctl-private.h) but assigns
different numeric values. The overlap predates this patch, so not
something you introduced, but adding FAMFS to both is a good moment to
fix it before it gets more entrenched.

Two enums with identical member names but different values is confusing
and risks silent cross-assignment bugs with no compiler warning.

Suggest renaming this local enum to `enum reconfig_mode` with members
`RECONFIG_MODE_{UNKNOWN,DEVDAX,RAM,FAMFS}`. That confines it to the reconfig
path. Then the library enum gets unambiguous ownership of `DAXCTL_DEV_MODE_*`.
After that accidental cross-assignments are obvious type mismatches rather
than a silent wrong-value bug.


>
>  struct mapping {
>  	unsigned long long start, end, pgoff;
> @@ -471,6 +472,13 @@ static const char *parse_device_options(int argc, const char **argv,
>  					"--no-online is incompatible with --mode=devdax\n");
>  				rc =  -EINVAL;
>  			}
> +		} else if (strcmp(param.mode, "famfs") == 0) {
> +			reconfig_mode = DAXCTL_DEV_MODE_FAMFS;
> +			if (param.no_online) {
> +				fprintf(stderr,
> +					"--no-online is incompatible with --mode=famfs\n");
> +				rc =  -EINVAL;


rm extra whitespace after =


> +			}
>  		}
>  		break;
>  	case ACTION_CREATE:
> @@ -696,8 +704,42 @@ static int disable_devdax_device(struct daxctl_dev *dev)
>  	int rc;
>
>  	if (mem) {
> -		fprintf(stderr, "%s was already in system-ram mode\n",
> -			devname);
> +		fprintf(stderr, "%s is in system-ram mode\n", devname);
> +		return 1;
> +	}
> +	if (daxctl_dev_is_famfs_mode(dev)) {
> +		fprintf(stderr, "%s is in famfs mode\n", devname);
> +		return 1;
> +	}
> +	if (!daxctl_dev_is_devdax_mode(dev)) {
> +		fprintf(stderr, "%s is not in devdax mode\n", devname);
> +		return 1;
> +	}
> +	rc = daxctl_dev_disable(dev);
> +	if (rc) {
> +		fprintf(stderr, "%s: disable failed: %s\n",
> +			daxctl_dev_get_devname(dev), strerror(-rc));
> +		return rc;
> +	}
> +	return 0;
> +}
> +
> +static int disable_famfs_device(struct daxctl_dev *dev)
> +{
> +	struct daxctl_memory *mem = daxctl_dev_get_memory(dev);
> +	const char *devname = daxctl_dev_get_devname(dev);
> +	int rc;
> +
> +	if (mem) {
> +		fprintf(stderr, "%s is in system-ram mode\n", devname);
> +		return 1;
> +	}
> +	if (daxctl_dev_is_devdax_mode(dev)) {
> +		fprintf(stderr, "%s is in devdax mode\n", devname);
> +		return 1;
> +	}
> +	if (!daxctl_dev_is_famfs_mode(dev)) {
> +		fprintf(stderr, "%s is not in famfs mode\n", devname);
>  		return 1;
>  	}
>  	rc = daxctl_dev_disable(dev);


disable_devdax_device() and disable_famfs_device() differ only in
which mode they accept vs. reject. With reconfig_mode_* switching on
daxctl_dev_get_mode() first, the caller already knows the mode, so
the internal mode-sanity checks are redundant.

What's left in each function is daxctl_dev_disable() and an error
fprintf, the same code in both, so collapse to a single helper:

    static int disable_mode_device(struct daxctl_dev *dev);

No mode parameter: the precondition (caller has matched the mode)
means nothing mode-specific remains.


> @@ -711,6 +753,7 @@ static int disable_devdax_device(struct daxctl_dev *dev)
>
>  static int reconfig_mode_system_ram(struct daxctl_dev *dev)
>  {
> +	struct daxctl_memory *mem = daxctl_dev_get_memory(dev);
>  	const char *devname = daxctl_dev_get_devname(dev);
>  	int rc, skip_enable = 0;
>
> @@ -724,11 +767,21 @@ static int reconfig_mode_system_ram(struct daxctl_dev *dev)
>  	}
>
>  	if (daxctl_dev_is_enabled(dev)) {
> -		rc = disable_devdax_device(dev);
> -		if (rc < 0)
> -			return rc;
> -		if (rc > 0)
> +		if (mem) {
> +			/* already in system-ram mode */
>  			skip_enable = 1;
> +		} else if (daxctl_dev_is_famfs_mode(dev)) {
> +			rc = disable_famfs_device(dev);
> +			if (rc)
> +				return rc;
> +		} else if (daxctl_dev_is_devdax_mode(dev)) {
> +			rc = disable_devdax_device(dev);
> +			if (rc)
> +				return rc;
> +		} else {
> +			fprintf(stderr, "%s: unknown mode\n", devname);
> +			return -EINVAL;
> +		}
>  	}

This if-else chain is repeated in all three reconfig_mode_*() functions below.
Please add a private helper and switch on the result. Something like:

    static enum daxctl_dev_mode daxctl_dev_get_mode(struct daxctl_dev *dev)
    {
            if (daxctl_dev_get_memory(dev))
                    return DAXCTL_DEV_MODE_RAM;
            if (daxctl_dev_is_famfs_mode(dev))
                    return DAXCTL_DEV_MODE_FAMFS;
            if (daxctl_dev_is_devdax_mode(dev))
                    return DAXCTL_DEV_MODE_DEVDAX;
            return DAXCTL_DEV_MODE_UNKNOWN;
    }

Then each reconfig_mode_* becomes a switch on the current mode. The
precedence (system-ram first because it's detected via `mem` rather
than driver binding) lives in one place instead of three.

> @@ -750,7 +803,7 @@ static int disable_system_ram_device(struct daxctl_dev *dev)
>  	int rc;
>
>  	if (!mem) {
> -		fprintf(stderr, "%s was already in devdax mode\n", devname);
> +		fprintf(stderr, "%s is not in system-ram mode\n", devname);
>  		return 1;
>  	}
>
> @@ -786,12 +839,31 @@ static int disable_system_ram_device(struct daxctl_dev *dev)
>
>  static int reconfig_mode_devdax(struct daxctl_dev *dev)
>  {
> +	struct daxctl_memory *mem = daxctl_dev_get_memory(dev);
> +	const char *devname = daxctl_dev_get_devname(dev);
>  	int rc;
>
>  	if (daxctl_dev_is_enabled(dev)) {
> -		rc = disable_system_ram_device(dev);
> -		if (rc)
> -			return rc;
> +		if (mem) {
> +			rc = disable_system_ram_device(dev);
> +			if (rc)
> +				return rc;
> +		} else if (daxctl_dev_is_famfs_mode(dev)) {
> +			rc = disable_famfs_device(dev);
> +			if (rc)
> +				return rc;
> +		} else if (daxctl_dev_is_devdax_mode(dev)) {
> +			/* already in devdax mode, just re-enable */
> +			rc = daxctl_dev_disable(dev);
> +			if (rc) {
> +				fprintf(stderr, "%s: disable failed: %s\n",
> +					devname, strerror(-rc));
> +				return rc;
> +			}
> +		} else {
> +			fprintf(stderr, "%s: unknown mode\n", devname);
> +			return -EINVAL;
> +		}
>  	}


Same if-else chain, second copy. See the helper suggestion above.


>  	rc = daxctl_dev_enable_devdax(dev);
> @@ -801,6 +873,43 @@ static int reconfig_mode_devdax(struct daxctl_dev *dev)
>  	return 0;
>  }
>
> +static int reconfig_mode_famfs(struct daxctl_dev *dev)
> +{
> +	struct daxctl_memory *mem = daxctl_dev_get_memory(dev);
> +	const char *devname = daxctl_dev_get_devname(dev);
> +	int rc;
> +
> +	if (daxctl_dev_is_enabled(dev)) {
> +		if (mem) {
> +			fprintf(stderr,
> +				"%s is in system-ram mode; must be in devdax mode to convert to famfs\n",
> +				devname);
> +			return -EINVAL;
> +		} else if (daxctl_dev_is_famfs_mode(dev)) {
> +			/* already in famfs mode, just re-enable */
> +			rc = daxctl_dev_disable(dev);
> +			if (rc) {
> +				fprintf(stderr, "%s: disable failed: %s\n",
> +					devname, strerror(-rc));
> +				return rc;
> +			}
> +		} else if (daxctl_dev_is_devdax_mode(dev)) {
> +			rc = disable_devdax_device(dev);
> +			if (rc)
> +				return rc;
> +		} else {
> +			fprintf(stderr, "%s: unknown mode\n", devname);
> +			return -EINVAL;
> +		}
> +	}


Same if-else chain, third copy.


> +
> +	rc = daxctl_dev_enable_famfs(dev);
> +	if (rc)
> +		return rc;
> +
> +	return 0;
> +}
> +
>  static int do_create(struct daxctl_region *region, long long val,
>  		     struct json_object **jdevs)
>  {
> @@ -887,6 +996,9 @@ static int do_reconfig(struct daxctl_dev *dev, enum dev_mode mode,
>  	case DAXCTL_DEV_MODE_DEVDAX:
>  		rc = reconfig_mode_devdax(dev);
>  		break;
> +	case DAXCTL_DEV_MODE_FAMFS:
> +		rc = reconfig_mode_famfs(dev);
> +		break;
>  	default:
>  		fprintf(stderr, "%s: unknown mode requested: %d\n",
>  			devname, mode);
> diff --git a/daxctl/json.c b/daxctl/json.c
> index 3cbce9dcd651..2a4b12c2f925 100644
> --- a/daxctl/json.c
> +++ b/daxctl/json.c
> @@ -48,8 +48,19 @@ struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev,
>
>  	if (mem)
>  		jobj = json_object_new_string("system-ram");
> -	else
> +	else if (daxctl_dev_is_famfs_mode(dev))
> +		jobj = json_object_new_string("famfs");
> +	else if (daxctl_dev_is_devdax_mode(dev))
>  		jobj = json_object_new_string("devdax");


The 'else if' above, and the 'else' below, both assign "devdax",
so the 'else if' is redundant. And once daxctl_dev_get_mode()
exists, this becomes a switch on the result with "devdax"
as the UNKNOWN fallback.


> +	else {
> +		/* Legacy condition; if a daxdev is not in any "mode", that
> +		 * means no driver is bound. We report that as a disabled
> +		 * device in devdax mode. (the disabled modifier is added later
> +		 * in this function if applicable)
> +		 */
> +		jobj = json_object_new_string("devdax");
> +	}
> +
>  	if (jobj)
>  		json_object_object_add(jdev, "mode", jobj);
>
> diff --git a/daxctl/lib/libdaxctl-private.h b/daxctl/lib/libdaxctl-private.h
> index ae45311e5d57..0bb73e8c04bf 100644
> --- a/daxctl/lib/libdaxctl-private.h
> +++ b/daxctl/lib/libdaxctl-private.h
> @@ -21,12 +21,14 @@ static const char *dax_subsystems[] = {
>  enum daxctl_dev_mode {
>  	DAXCTL_DEV_MODE_DEVDAX = 0,
>  	DAXCTL_DEV_MODE_RAM,
> +	DAXCTL_DEV_MODE_FAMFS,
>  	DAXCTL_DEV_MODE_END,
>  };
>
>  static const char *dax_modules[] = {
>  	[DAXCTL_DEV_MODE_DEVDAX] = "device_dax",
>  	[DAXCTL_DEV_MODE_RAM] = "kmem",
> +	[DAXCTL_DEV_MODE_FAMFS] = "fsdev_dax",
>  };


Add a DAXCTL_DEV_MODE_UNKNOWN sentinel here to support the
daxctl_dev_get_mode() helper cleanly. Doesn't have to be assigned a
value, can reuse END or add it alongside, your call.


>  enum memory_op {
> diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
> index 02ae7e50b123..33121dcb1d1b 100644
> --- a/daxctl/lib/libdaxctl.c
> +++ b/daxctl/lib/libdaxctl.c
> @@ -385,13 +385,13 @@ static bool device_model_is_dax_bus(struct daxctl_dev *dev)
>  	return false;
>  }
>
> -DAXCTL_EXPORT int daxctl_dev_is_system_ram_capable(struct daxctl_dev *dev)
> +static int daxctl_dev_bound_to_module(struct daxctl_dev *dev, const char *mod_name)
>  {
>  	const char *devname = daxctl_dev_get_devname(dev);
>  	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
>  	const char *mod_base;
>  	char *mod_path;
> -	char path[200];
> +	char path[PATH_MAX];
>  	const int len = sizeof(path);
>
>  	if (!device_model_is_dax_bus(dev))


Nice!


> @@ -406,11 +406,13 @@ DAXCTL_EXPORT int daxctl_dev_is_system_ram_capable(struct daxctl_dev *dev)
>  	}
>
>  	mod_path = realpath(path, NULL);
> -	if (!mod_path)
> +	if (!mod_path) {
> +		dbg(ctx, "%s: realpath failed for driver link\n", devname);
>  		return false;
> +	}
>
>  	mod_base = path_basename(mod_path);
> -	if (strcmp(mod_base, dax_modules[DAXCTL_DEV_MODE_RAM]) == 0) {
> +	if (strcmp(mod_base, mod_name) == 0) {
>  		free(mod_path);
>  		return true;
>  	}
> @@ -419,6 +421,30 @@ DAXCTL_EXPORT int daxctl_dev_is_system_ram_capable(struct daxctl_dev *dev)
>  	return false;
>  }
>
> +DAXCTL_EXPORT int daxctl_dev_is_system_ram_capable(struct daxctl_dev *dev)
> +{
> +	return daxctl_dev_bound_to_module(dev, dax_modules[DAXCTL_DEV_MODE_RAM]);
> +}


With daxctl_dev_is_famfs_mode() and daxctl_dev_is_devdax_mode() now
alongside it, the _capable vs _mode naming split looks inconsistent.
Post-refactor all three delegate to daxctl_dev_bound_to_module(), which
checks current driver binding.

Either document the semantic distinction more explicitly or consider
adding daxctl_dev_is_system_ram_mode() as the preferred interface.


> +
> +/*
> + * Check if device is currently in famfs mode (bound to fsdev_dax driver).
> + * Returns false for disabled devices: the DAX bus does not retain the previous
> + * driver binding after unbind, so mode cannot be determined without a driver.
> + */
> +DAXCTL_EXPORT int daxctl_dev_is_famfs_mode(struct daxctl_dev *dev)
> +{
> +	return daxctl_dev_bound_to_module(dev, dax_modules[DAXCTL_DEV_MODE_FAMFS]);
> +}
> +
> +/*
> + * Check if device is currently in devdax mode (bound to device_dax driver).
> + * Returns false for disabled devices; see daxctl_dev_is_famfs_mode().
> + */
> +DAXCTL_EXPORT int daxctl_dev_is_devdax_mode(struct daxctl_dev *dev)
> +{
> +	return daxctl_dev_bound_to_module(dev, dax_modules[DAXCTL_DEV_MODE_DEVDAX]);
> +}

These comments claim "Returns false for disabled devices" as if that
were unique to these two helpers, but it isn't. daxctl_dev_is_system_ram_capable
returns false for disabled devices too. Either drop the comment or move it to
to daxctl_dev_bound_to_module().

> +
>  /*
>   * This checks for the device to be in system-ram mode, so calling
>   * daxctl_dev_get_memory() on a devdax mode device will always return NULL.
> @@ -983,6 +1009,11 @@ DAXCTL_EXPORT int daxctl_dev_enable_ram(struct daxctl_dev *dev)
>  	return daxctl_dev_enable(dev, DAXCTL_DEV_MODE_RAM);
>  }
>
> +DAXCTL_EXPORT int daxctl_dev_enable_famfs(struct daxctl_dev *dev)
> +{
> +	return daxctl_dev_enable(dev, DAXCTL_DEV_MODE_FAMFS);
> +}

OK.

> +
>  DAXCTL_EXPORT int daxctl_dev_disable(struct daxctl_dev *dev)
>  {
>  	const char *devname = daxctl_dev_get_devname(dev);
> diff --git a/daxctl/lib/libdaxctl.sym b/daxctl/lib/libdaxctl.sym
> index 309881196c86..2a812c6ad918 100644
> --- a/daxctl/lib/libdaxctl.sym
> +++ b/daxctl/lib/libdaxctl.sym
> @@ -104,3 +104,10 @@ LIBDAXCTL_10 {
>  global:
>  	daxctl_dev_is_system_ram_capable;
>  } LIBDAXCTL_9;
> +
> +LIBDAXCTL_11 {
> +global:
> +	daxctl_dev_enable_famfs;
> +	daxctl_dev_is_famfs_mode;
> +	daxctl_dev_is_devdax_mode;
> +} LIBDAXCTL_10;


If you resolve the _capable/_mode naming inconsistency by adding
daxctl_dev_is_system_ram_mode(), please export it here as well.


> diff --git a/daxctl/libdaxctl.h b/daxctl/libdaxctl.h
> index 53c6bbdae5c3..84fcdb40c7a9 100644
> --- a/daxctl/libdaxctl.h
> +++ b/daxctl/libdaxctl.h
> @@ -72,12 +72,15 @@ int daxctl_dev_is_enabled(struct daxctl_dev *dev);
>  int daxctl_dev_disable(struct daxctl_dev *dev);
>  int daxctl_dev_enable_devdax(struct daxctl_dev *dev);
>  int daxctl_dev_enable_ram(struct daxctl_dev *dev);
> +int daxctl_dev_enable_famfs(struct daxctl_dev *dev);
>  int daxctl_dev_get_target_node(struct daxctl_dev *dev);
>  int daxctl_dev_will_auto_online_memory(struct daxctl_dev *dev);
>  int daxctl_dev_has_online_memory(struct daxctl_dev *dev);
>
>  struct daxctl_memory;
>  int daxctl_dev_is_system_ram_capable(struct daxctl_dev *dev);
> +int daxctl_dev_is_famfs_mode(struct daxctl_dev *dev);
> +int daxctl_dev_is_devdax_mode(struct daxctl_dev *dev);


Mirror whatever you do about _capable vs _mode here. If you add
daxctl_dev_get_mode() as a public library function, declare it here
too.


>  struct daxctl_memory *daxctl_dev_get_memory(struct daxctl_dev *dev);
>  struct daxctl_dev *daxctl_memory_get_dev(struct daxctl_memory *mem);
>  const char *daxctl_memory_get_node_path(struct daxctl_memory *mem);
