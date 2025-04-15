Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAD9208961
	for <nvdimm@lists.linux.dev>; Tue, 15 Apr 2025 04:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744691329; cv=fail; b=RtzLQ57rKTryyjvOS94KOBzW0MPuVLb03Yx0V7paqoGx/x83RJ+WAwfiZjuXY0ko5paqp/Ng1dPjADOyc8PZn9BTGjd3P7xVaUyrput72fcfPkL1fPXivWXdfDQsywwMjNI1k0XbkAF5v/uN4cjMBY1ZH4LaBijwMgzeE/2ITBc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744691329; c=relaxed/simple;
	bh=kE/Kprl5B+2UqthNBbYGXgkMrE7eENbByFzGOYyJW4Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=brqtDzP9Pr7tePxPaR2TRKwkCCzmrdC7pwf/AjrWkYf9fCoVnNXRgLywpegX7rCUYbQKvKuslvjCfOpmPeLoBp3H0lyWprJ6uEDdSVxN+K7YzbJKn1q/NtsRiu3yoZHyks/EBFNdGaYOZ1fF/HoGz7OrN9mJmHYxMWyuDW2Yg84=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P/Xrd5D4; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P/Xrd5D4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744691327; x=1776227327;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=kE/Kprl5B+2UqthNBbYGXgkMrE7eENbByFzGOYyJW4Y=;
  b=P/Xrd5D4pdTaQ50ubPC/aeeBOv75ZFCLugj/MKiIDUN3v3LzmE6xBFoB
   8hykbzxKjTI2hU84OqmQUND7WqcBfuwtk0EMcitEpRNADF/b0lj/3OeY+
   yip536h08PFegtaN/EhOByBOHbMzk2v4kApQ+s8sjrSFTlNN5q1Ux4Xfu
   J7/UZubUkxYRn1QG4MnXcOV5aoGUEG3xhCdxNNcn76dUtI7ueZHUGCDoY
   q1wpwuBGmvXGVqto+HPxsmGWrZS5Jrh9S9shikIOOh0EfiNbmmCGnbR9Y
   fhhkRCoAEQcmRZFPsg2HIDawLnduB4zUbNW33+r2rtV3voEaKnHfbUA3i
   A==;
X-CSE-ConnectionGUID: taA43x+NSe6n3qQAe69tKw==
X-CSE-MsgGUID: Curq6OmQRQidozBhBQJ9AQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11403"; a="46311303"
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="46311303"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 21:28:47 -0700
X-CSE-ConnectionGUID: TS2bU/MRT/CyCp372Kh/mw==
X-CSE-MsgGUID: i26z3lD+R3SrCd1ZnkWOfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="130544440"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 21:28:47 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 14 Apr 2025 21:28:46 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 14 Apr 2025 21:28:46 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 14 Apr 2025 21:28:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FfDQ9vRrnydHnybfOtyGtk6aFg/iqj1b433ttzKTpnJCehxUx3BLCQVLNpcHkeRPZX+QDbELiOE6w3iOMjhY7F/U5SNlmzpfjXzjv2zbbXANGS748I8+wXp3qtiSzVqd9iRidPL9RKIdEvG2sfgzTokZk4ETC9zgGKu5e25i7hvSLy9BdCMYTe0IKM1z9CfuRZWWifSGSNndlz7ogGOIL5O2qIptU4yjkVd5xcKQC+GiIT+kkDQdt66c0roHkyabFz00RWNNiBJZfkhJ8l+99urpc8I+GsY/rsZZjd/brjae59KcIQcoeVP94gGjTA9rt0RbL/HojdQuDfC0VO5NTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0V0eTx/XBtLJGSVmO8i25KIlraL+bM8fc4LhBhdPn2g=;
 b=di2flDIW6AFDoWRqTPe9Mmea1eKxpOWwtRK1QUhvVJYo1uYjKMepSSL8RtVF0nalVo3ueHPa8y4FDFyPGR93m6plcuo22Cwu7fuP8UIyBZWvQ3BYoAM60dCip+OdJcTjSTLasGuTiDlOt2T0SvCoxbl9CpVBHklgXV0TmPtZitwts1MO4TxPaGtY+CB+O0tiYIZRTefUkKvDaeQRepWbrZvxjmQJeCy7kSLlfyUgYWczK5SVqnnD6iwNLq4kJ5vzJG/FbW57lD84EExGwU3QrpMIfI+jqAZ+fYt4Dg8FhPwuVJ77NEGhbjo+onzZdnEgaHPR11CAgYyY40yM2tJSpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CH3PR11MB8493.namprd11.prod.outlook.com (2603:10b6:610:1bc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.33; Tue, 15 Apr
 2025 04:28:16 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.8632.030; Tue, 15 Apr 2025
 04:28:16 +0000
Date: Mon, 14 Apr 2025 21:28:12 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Ira Weiny <ira.weiny@intel.com>, Fan Ni <nifan.cxl@gmail.com>
CC: Dave Jiang <dave.jiang@intel.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Li Ming <ming.li@zohomail.com>
Subject: Re: [PATCH v9 00/19] DCD: Add support for Dynamic Capacity Devices
 (DCD)
Message-ID: <67fde05cdc323_71fe29420@dwillia2-xfh.jf.intel.com.notmuch>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
 <Z_0v-iFQpWlgG7oT@debian>
 <67fdc64e3fa03_15df832946e@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <67fdc64e3fa03_15df832946e@iweiny-mobl.notmuch>
X-ClientProxiedBy: MW2PR16CA0033.namprd16.prod.outlook.com (2603:10b6:907::46)
 To PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CH3PR11MB8493:EE_
X-MS-Office365-Filtering-Correlation-Id: c8e1e4b4-676f-4fd8-f503-08dd7bd5f149
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?aq/OQtNTdpGpY7U1zH4iko1dfGUGRf1FuA5M6nVDz4NWU+MoV4AbtHuk0I/F?=
 =?us-ascii?Q?rBlrsjrQFSsSAd8nW7zBX9rx2MJbTM17SHr+nWOLVJsY5EgXIW4tnjJd7C96?=
 =?us-ascii?Q?F7hyCpIkHs5ttmuHyIRGtc+tOIj1l0RMqoJ9dZDWQrhQWL1OjhdYWM7Xxmpq?=
 =?us-ascii?Q?6QjmPXfw6POMRB5lR0hpoph17hqYLLqhLfXVadw0Hjw22PtiNG0gzVFtwNmA?=
 =?us-ascii?Q?W4nrb9NdHnOvRjb5ioO/BWR6G12CgEVUHkiLFgxKU7e3yFPTWSeAC4gX1gGF?=
 =?us-ascii?Q?EaO/6Me6v04RHh76vagHPo06IyIO/J7en/E8wgUtqNBu7tu9eeNu7zkgO0vM?=
 =?us-ascii?Q?EVC9vhMvbXypc6fXbHp2OC+X4gVSeVLJonjvuFR+TMxQ/bcVmhYk1yGQ8ZWR?=
 =?us-ascii?Q?XQQTqr0IcLOzy99Ce7rCzM0mjBOyQeHTxXe85xOPC73THCE+/nxKOmV9zL9d?=
 =?us-ascii?Q?WoSUXmmxaumsxVsAwCT81o91+2hMxq1xSA/UIpdzgkRoUQYOXAggTDd97eFE?=
 =?us-ascii?Q?jo27dRwPwxpU0EAzT3woonyoAru+C14vRrFlunwjqgVzv3WtbhQAHZQ8KXQz?=
 =?us-ascii?Q?WVipiG2GCGbt454nptGI2NEAmxfmkTEkmO2V7rRcENCe2Wnwi/GJJQbjpKKW?=
 =?us-ascii?Q?c8vVUaa+N2RfMebW3qsQmKbcfieidO3P8YNp1VX+o7zwe6GValtrEXumf8l/?=
 =?us-ascii?Q?MX+ZISJfBRgnB8g9LJeBuJPMmHBWhMhLuR1k1G+X4dPORF5JeQ1LdwkWovjm?=
 =?us-ascii?Q?SwY4I/PvCTYe1dnjPtJn4A1qF7nTINX5mc8kp8ShCJx+hwu4H7V8rvlidP8y?=
 =?us-ascii?Q?huJUAJl2ZZIDvTrMad4Nr7i6nop1VAojUAqCnGmF32HKR8J3gWafMdyHyfY8?=
 =?us-ascii?Q?hpVBvJxsasXXYRHMaCXy9UrvuHgaq8/UauQg0z2LwaUavEanhLyrmItjhDHy?=
 =?us-ascii?Q?mex3hKeBH9ExUwTIPedWy+E9Rolwcriw4DP9aGReuDbzOcFj+0lTw0GOW10H?=
 =?us-ascii?Q?6MmKATzbYVUgGhHarUdI4OYdFceOsruRPCYeDpFSur4H4dXcrY+nYmrpNu8G?=
 =?us-ascii?Q?6WoGd6pUBY5oTat7n+ELOWlc4ZIocqM83/8/5Pha5VG8s1eIcSfZbz/y9tO6?=
 =?us-ascii?Q?33Bgf9uw35Xqvq3bPVsl1DAtkakOK8b0QZoumxbMCLss+jtYY8vm4fLfxeY1?=
 =?us-ascii?Q?NSHR+8rGnnfszG6JgTxqs4X+QtR1YnNdh+vyZxPgaYcYBFMNdYizqMc0EPRJ?=
 =?us-ascii?Q?nQa0S9iBRWwkrRp6m5PeVzT9MtAM4VXr5AYOkg51zUHcyw/ZMZZjnkEA4DyN?=
 =?us-ascii?Q?dme136nkZNulIDFvMRGqJpuXHRxWC5OFt1yNSxJ8wc9U5NTizqsXKSOxzXQ0?=
 =?us-ascii?Q?FFuG6WEqHfxUgtf+OJoG+UwNLbpHkmixAERXNvnIqGpRqrTdjCFTYnoIuNRu?=
 =?us-ascii?Q?I9qi935LpzI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y9eVzJ4nyTXySQz6ceIS5nE6ns4Jvxffz7ox4CRk2BGfGJu4baL2o/9WLdVv?=
 =?us-ascii?Q?4iTtxXWYy+vqjIV12+/dEFjkstXANBSDaIzIS0MR0fEmP8QixOKgPmXVVx1U?=
 =?us-ascii?Q?kjA0itp5fPK+77o8AUfqCZmB4FYLySKWJ89oREjx4YiBsz6NvU680w870fQ+?=
 =?us-ascii?Q?7mRVTjW5bqCH8oOvdpEGav2Nd4cTKtH1a5W68d2vufsdaDhyBmv6KLizeapz?=
 =?us-ascii?Q?S4GGbSwmi5YbAK1tzZj+Sx2y/dvxCNnw+qHkDAmXiN4eg2kIs918R/nZg6SS?=
 =?us-ascii?Q?wK4rN8ttjE/g/EQNL+qfyNSay+50YCiIWrXsBmsghqooNSm0vsaPqLjuAp9b?=
 =?us-ascii?Q?kZOhjQEHOlzafBNPjHUuTrlqAj7XrnbU5sKIq/cegg3Guie1YfFYpCSukDsR?=
 =?us-ascii?Q?yetEH12/D7D3PkkNSqywOdJA+go/5xbwGiSt+aGsLD959JnDlXuNLuk3aCkC?=
 =?us-ascii?Q?L1AxmrLYwzgh4rWblWyHKfOHL2OiBam71BlU5cKbE7mPlEiOaIOw3kT/uAkN?=
 =?us-ascii?Q?KbMoY/Aa8ovn5dqvSmJCYp3mRQ3dlRjh3/3VgEfEIdwsHtM3Lb7IMKT6Zr0T?=
 =?us-ascii?Q?t9g7slSQL+sr5KPQJx60CbywL4l0k5bZ5Ku2FXl8mGMCFLsb4XHB/2KD87Fk?=
 =?us-ascii?Q?qrX3owTTQMJ4qMaMnV6AzBeJ8HtO9Idv6BAcPPqseheiU7HGfQew7r+vc2Cp?=
 =?us-ascii?Q?Q8z2Tdgr8PEmWRVju1wvtOZHaPpD+EZYwTDyxRqFJRfUa4YQNUqzohf6WJh0?=
 =?us-ascii?Q?Bifg1tK77yrAcNREqacxaYadzodgIYbgIB4dQDL5q0F3ow7+ZsH0YIo+NUzY?=
 =?us-ascii?Q?r/rFBWu2xwJKkV2hlmrFBxvCLkrGDVHQi8tx4bjlBqUwYbC/7TpFWrQIz0qy?=
 =?us-ascii?Q?Hr7cvAyGAJSblse/SKaxhgo+noIt/50jgtyyJeNChaZ6imTuYusdzj69SxOt?=
 =?us-ascii?Q?YSCQkFZ/krtVl6r3/Ymy4wqPCUHIInRlmgMwVA0b+KsgeYDZYuw0PcCMMjbX?=
 =?us-ascii?Q?O/UyXVxYAKB6UDrUsXyj/xiXJa9Fr/fmptqH6F96r2qY6tE9/Fzv/pMp4kSG?=
 =?us-ascii?Q?ajH1rcm3kWt0PHtYtP+BtBBNLQYahGWBP3Qq1d9R3kDiul+8Ctxqc8PrAyui?=
 =?us-ascii?Q?MjhzA++xLjcLj6wSKAElsoGa8IpdHqCm7WkujHtIk2+btdGd7aDG5iMFXho6?=
 =?us-ascii?Q?A03JlRIpTG83Ie+kZbKodqn6C8vdAh3V5ODgzVwNWvgwAQO6+dIKhqFHHyJF?=
 =?us-ascii?Q?TDA8PTxOy1AhXRGFuAkidsp9Yy7jsbtLTXYsMva254l+MyTfwAE95HJOvO9R?=
 =?us-ascii?Q?3LVK6GMEDZishsZW8YVdVjy6NHXex7eqkyoP4GZNBCjY4meElVlKov9TJC+j?=
 =?us-ascii?Q?QBOhHhjZizckYxyjmff8pbnr73r9UYnkAsfqAryqOO77txYYhcjVgk9LeKy2?=
 =?us-ascii?Q?lTwHhkDet0b/ps6qd3mPUCTKADqYSlCPSWAcIcd7jx6FUhRlfTQnnmguZzKv?=
 =?us-ascii?Q?JcGvOIIQY4nJvti38SVDCPnnb1zLn/3hQ+fNfffYPxtcQuzJ0EfI7THcdrRb?=
 =?us-ascii?Q?PQjAtTNg880qYmqBybi549IbmgvJA9MIlLoecg0VIPD4zYpaMxVoAYW/2CKv?=
 =?us-ascii?Q?QA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c8e1e4b4-676f-4fd8-f503-08dd7bd5f149
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2025 04:28:16.4736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CNx7tkwMCMwc1S/oAQdzyqcO/spHfHwBfKdUxRXQRx+OGduORNEcJWFZfbKMFTlvJedRTHGmGpT/CctDiX9zZ6wTvHSUozvzpJsDjkxOgvE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8493
X-OriginatorOrg: intel.com

Ira Weiny wrote:
[..]
> > However, after that, I tried to create a dax device as below, it failed.
> > 
> > root@debian:~# daxctl create-device -r region0 -v
> > libdaxctl: __dax_regions_init: no dax regions found via: /sys/class/dax

Note that /sys/class/dax support was removed from the kernel back in
v5.17:

83762cb5c7c4 dax: Kill DEV_DAX_PMEM_COMPAT

daxctl still supports pre-v5.17 kernels and always checks both subsystem
types. This is a debug message just confirming that it is running on a
new kernel, see dax_regions_init() in daxctl.

> > error creating devices: No such device or address
> > created 0 devices
> > root@debian:~# 
> > 
> > root@debian:~# ls /sys/class/dax 
> > ls: cannot access '/sys/class/dax': No such file or directory
> 
> Have you update daxctl with cxl-cli?
> 
> I was confused by this lack of /sys/class/dax and checked with Vishal.  He
> says this is legacy.
> 
> I have /sys/bus/dax and that works fine for me with the latest daxctl
> built from the ndctl code I sent out:
> 
> https://github.com/weiny2/ndctl/tree/dcd-region3-2025-04-13
> 
> Could you build and use the executables from that version?

The same debug message still exists in that version and will fire every
time when debug is enabled.
