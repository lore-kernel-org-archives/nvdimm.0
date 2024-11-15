Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65AB1E0E18
	for <nvdimm@lists.linux.dev>; Fri, 15 Nov 2024 18:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731696604; cv=fail; b=NNFRX+npp7bqKkI3ATax5C8+XMZTOT4g/2YTB4kw32AXXh9RjI/m1MrbYm5xMeI4GKrm53du6HlKz/oqu/xD2Ho45YedFOrmn2nfnXj6QYZZz8dg2k4n1OZKqMJ3btaP6JiJfjufPoaMT8R4gjtiP37YGFGNS+w3J5zcdx+yJnc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731696604; c=relaxed/simple;
	bh=d1awGD9GCldCmYMpZByqWPnFU/4/y+aOo3mUnJSHDK4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=seEEcIacYOxQfQaMqYHBm7aYJBwr0qxtpo16praJBsfwryK4mx2zZgq9qLcCfLokBVhx2AA9zfZ0IFlempMtt7CbHTZvVrF6fnaeO8xncvF9R6DvvxtjdOl04A2YbHzpBadAeraGc0CYeRbEdiMg5ftzS+q47uDcGrDYkrSXtbs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CP6/JTWj; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CP6/JTWj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731696603; x=1763232603;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=d1awGD9GCldCmYMpZByqWPnFU/4/y+aOo3mUnJSHDK4=;
  b=CP6/JTWjEuy2g3WWJe5r9rJM5v2iJJjXSEzcPZxoyFAkaoHw9fXpsl2s
   TTTfSZVP+Ais+9pW9nLPZqOVSKZdhJFb8XFkkv357eCOVh6zStCpa3JEn
   G66x2sZsHqJ66DJA6bynlIdl6dxFzlIpwb+rlk5F5Ici1HIcSi2w+CvSW
   Y4MpWSrLNocg6o6p/F4dOnse2dDbHhN90WWPqXGZiT7ea+CoDKwZQzS+w
   KeiE5O0FTQIoptf+DXGxi8Eno/9u/KIjGNTB80NkQ8WuwWJIKrvyIGtF7
   eHKAjIBbpg8uQuzOaP/GrbxDce0YEzrsY/vKbkl3TQu5boLuiPPp5TT+R
   w==;
X-CSE-ConnectionGUID: 2MV7ptrlQQqOP1PvkgePqw==
X-CSE-MsgGUID: BiVB55z6QaeVWt5B/BLckQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11257"; a="42248333"
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="42248333"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 10:50:02 -0800
X-CSE-ConnectionGUID: mXu2YxL9TvGLbFjP+6/z4g==
X-CSE-MsgGUID: Mz89+jtMRQGvIwgsrOwjig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="93478044"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Nov 2024 10:49:59 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 15 Nov 2024 10:49:59 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 15 Nov 2024 10:49:59 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 15 Nov 2024 10:49:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LIEiJhCgxkjobhINrHpMH3Wa7jV5U5frzijgWiOACJtiDuXOI3sAHrhM9D7dSwi3+rbhHra0OlLHL/YudBu8An9w5QBnQO4H/K/guA52bJBWraS8JpQ34X/iTti+p5J5BLHCMxa67z0tqGHM8oQqf/vVG8L5jKMtdlvh+kJ1jDZ1SQQHeLyW/ZoX4mpnCcNvkOIFht9XvkN6o2uWOwsMfgPt4SXRsGL6La9i64VLhNUnoMKS19zNtSBQZcqq4V0h2VKpHUcEiLeOJJsPrbCiQcsCK5mSLhUT02vvnyxKRJmDvkyQkIaKEZSVEYKQvL6oAdvJzfIfEoip4rboJMH43w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZN1OL9NHolwAppJPOzpy+tYYYPr+6Rf8jF6Ylqm1y0o=;
 b=nlW76blt5+ve2WeCgQuY+UypnLmAem9OBODK2BMro+7S5TuZtmHbscWRYSC4AXJoDlMW6A5j5Qv6x+wddOm1EGM87KNFgLFlMug9f9xz4iD7vMrSdqpdBSJ4did71c7rtf97SkGX4RZEGBSiFe5DEGJjjrRhX1auAFA4btfnieye4s5EXbsSrZ7Kyd/Dfdqh+Lpc+IWtO2Ww1swOlfaK5kU9ghAU1IuFDT4zRaIqxzAdPM/JkjGfp34dr9m+cBuUznbR1/LmXlKkjehi1N3OaWBKGgoEQ/+iXFQg4F/AZYhZxtbIf2oUHqcLIDM4EgUmcD+Kvrgw1xyYcWEihEJgMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by CH3PR11MB8362.namprd11.prod.outlook.com (2603:10b6:610:175::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Fri, 15 Nov
 2024 18:49:56 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%3]) with mapi id 15.20.8158.013; Fri, 15 Nov 2024
 18:49:56 +0000
Date: Fri, 15 Nov 2024 12:49:51 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Ira Weiny <ira.weiny@intel.com>, Alison Schofield
	<alison.schofield@intel.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Fan Ni <fan.ni@samsung.com>, Navneet Singh
	<navneet.singh@intel.com>, Dan Williams <dan.j.williams@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, Ira Weiny <ira.weiny@intel.com>, Sushant1 Kumar
	<sushant1.kumar@intel.com>
Subject: Re: [ndctl PATCH v3 0/9] ndctl: Dynamic Capacity additions for
 cxl-cli
Message-ID: <673797cf55ad5_29946a29437@iweiny-mobl.notmuch>
References: <20241115-dcd-region2-v3-0-326cd4e34dcd@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241115-dcd-region2-v3-0-326cd4e34dcd@intel.com>
X-ClientProxiedBy: MW4PR04CA0046.namprd04.prod.outlook.com
 (2603:10b6:303:6a::21) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|CH3PR11MB8362:EE_
X-MS-Office365-Filtering-Correlation-Id: caf0e7d8-c178-40d7-7d89-08dd05a64c42
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?P9GBlg/fhHt/3RsVFUz/OveapsGuZBCOMzADMaLqDXg8srjNSQtJJBSI0bJb?=
 =?us-ascii?Q?+Ns9DM7RawvScBInQsRRVzAR4VJzudR2iNpUXe4wzP49VQbuSmmUrtWRfuFZ?=
 =?us-ascii?Q?2+wtQIoEF9zjS8VkUE8o3jMIkiQgoc96i42nTYiMLxPsWtFRUnlYlCiZ+GLI?=
 =?us-ascii?Q?5C+2ittkCs8uzKB2EsUbCUYhTmdzvXFE0MXOu3/yzPyhvmvLRxJSG4QltpC1?=
 =?us-ascii?Q?p4PS5bfGkiDhhPhkw4IuEjt1dcy/3YsyVXdEFknpn1QHAP35KZO4Ca0U4dzm?=
 =?us-ascii?Q?BLrJz4JKTvFV+fOiW6yBVrz0zdatOFVf7jFdKnM9X/KVQwJ622w7zmbtl6W7?=
 =?us-ascii?Q?y8QM0RCaxwV7xKB+I8kMxlNM7CU2vA01DIk6OQyBWaiEd73g7N01OXWafnI/?=
 =?us-ascii?Q?gndK4u0KclWcZGPDkTMXheBsuUxcqQCs483slVgA67jlZv965yD5YlqyywJp?=
 =?us-ascii?Q?25m8OA/mEfj3nLSnvoH0/whmhdx73YvEuApjR9w8ARy1AKnufgeZp2QDkwEU?=
 =?us-ascii?Q?hWpoDcxLDoLF2+LV638YwPTwH3UXVSxW+Xa8sWi7lpY6+fwN6tTdMg1SEdVc?=
 =?us-ascii?Q?iJnQo0P/BfIoAJaCYbbhjFXYjYtzQKnJet5xpfc2q2B8k6z/0BRqoPEFWXrn?=
 =?us-ascii?Q?wm5QK/EgTLUb49Ex39a2X9TPKJp2UTa7x3c5mKW6MZimXeVtqlG73HUzg6JT?=
 =?us-ascii?Q?949IshsmLSJZOj3mlJksIQAznGfI1QE7VZw/9PYzFy/EF0yV6RB3kekrb3LO?=
 =?us-ascii?Q?Z9dUU+JlJ2HRXnRU5Rr8Qq7X/q8I1envUcIm+rwSCm1sEi1zxFBxrLX2rCy+?=
 =?us-ascii?Q?o5DC6ChRqCdA2rUA7QO2617LGTEEtFNfWmkRi6lYphjBWXYuwCdRJMbfO4Lx?=
 =?us-ascii?Q?9kJQ8uB3UxpNsvpTpcZP2GhAcqcGD0PlVs0c1/Npay0bhC1Z7jN6y5p02mUo?=
 =?us-ascii?Q?HP+dzRLXelXTOHnBGF/WwJBMqq6jHczDiYR3cqFUJB1L+n/hPML7sGh89PvT?=
 =?us-ascii?Q?T2iVAxkHmO4AOy+kpjMsKZ7sVrhSNtD8fqOkAHROEL4s9Y4RAAwmxkc2pT2U?=
 =?us-ascii?Q?hf38D/byEm6AI1n0LgWLRX3pUBzPQIruKZhZuQ235p/cdaJjSRNxaaYQjv/C?=
 =?us-ascii?Q?/zDPRnJJB/7S6DA4/jStvhbnMDL5cg8pxcuQS9hleRF3Ltsu2KDuEDoyA/5x?=
 =?us-ascii?Q?ryhrM6imPzI4jIsOEG0oiWnpFLEFrpJh8xgd/JiiwZ6Ko/k/pITaZihkZndN?=
 =?us-ascii?Q?E48wJDyQV2cFGxl9nlZAcXdfEw+o9fVbaj1js2hM+Q=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dMc7oSERtsj1jxE7SUzxj/6/3SNXmhrs0h4yU+SawHhXxxU4Au5eNNFg0bDL?=
 =?us-ascii?Q?yiZNck/9JtWDQZqCHP0oHCY6AQGdRGlAx4ahCTxhRF91V0XanteHEDWfRC0I?=
 =?us-ascii?Q?pqUNlhSUFITgRZ02KhhPiMiO0pXiHJxaDFhlpX2dw8pioTVqVn7o7zwbc2K3?=
 =?us-ascii?Q?nw0QWzXYzbaOuwDDUz4rX23YLRxsPeCa8tHV0G9r55U3SYkYFUkriYtkO7QO?=
 =?us-ascii?Q?4hkulMXaAKmd2i12abN5/nlWBU9TDDUnx3MuzrxIButeE9DK0I/F7OdoOv2I?=
 =?us-ascii?Q?wlWVb6SlO5Uku+m/8K6JaxDIA+wJdNTnZY4T4M47cgzZGRegkcEw4jLwX1rc?=
 =?us-ascii?Q?pG1+yidgsNFV7E2/vO+7gIh7zApFQ1PsomJBzVfLZEEkQHk2y4Kc5wdsykP1?=
 =?us-ascii?Q?Q73wWtFwV6k3rt20C98rUoR+oiG7nWpTgSTxHn4svMn66fSFhfjQxVqx13Dd?=
 =?us-ascii?Q?CsT4ILqD1FxA5tMMq4l6txvJpv2rOapisN07tCR9sY9uwmGmzjJ0ZpEE58fl?=
 =?us-ascii?Q?AHaXwZnuzXgK+/0oL1vQ7AWiHI9RMsw1sRWRGKL9EZbdE5tcioW6XWPNbJ2g?=
 =?us-ascii?Q?h71KIIik+JaRJm0Hu2pwlDdbOvbMhbaTZAe9MME80rxe9AUgvMeAol0M+uom?=
 =?us-ascii?Q?QpgjubwWYWeQICd9OVepNmTzIFPNrvv38Kq1j6tUscg7otlDAd8js4Njj4DZ?=
 =?us-ascii?Q?2vgOdGSa6WjlKxQ52lVXPo5JOYCYjG+RpUbGw92jPXbR4oFhJnmzTedAMRRc?=
 =?us-ascii?Q?E3QkVekoVgmWephtiYd95Kcbxg0VKFfAX/9iD5zIqEvNTAfh2cW4dFuETiXR?=
 =?us-ascii?Q?egKs97FAvphRYc4JSqyiI8Emc57ARjFZP4F+Q4WOKOHDVyuGse3FchEeCSWM?=
 =?us-ascii?Q?OHn3muzXXThs2LkswgnZPXqrxterD2jIIenFobYLojvQ8J5xi2h3lY9yuCpt?=
 =?us-ascii?Q?hhbex9765e90M5ZafQa0BUhhFKbFRW99JOkR/0OYYtth2LekcyEzvsu2EADz?=
 =?us-ascii?Q?6mppO/EYBq4Rmon69Jy29CWtkYbDtPm/zCPpyd0JlaLzCRWUx1dGHmRLFSAU?=
 =?us-ascii?Q?QDlv+XNeTGPa6TpMDY69iscxegOWsny13/X7qDmJkcw1LO5+qhSeWZoSkYFM?=
 =?us-ascii?Q?hUZ0pEJ5WTioBE7gV+6gS7DA5AcCFrz6ZA70yZ55vRqEKKXIZJlVMarkNnV3?=
 =?us-ascii?Q?78pL1y/OrdGwXb8Rg7rylsppY4N3CkUeYtdf5gafyw4J28L+bF1OvgMlfs2V?=
 =?us-ascii?Q?9FIFSMinME6tYgp0hO8z4dvaaqmFnbtUaNk0160vjbQ57OXqa4HCN/xiXaNQ?=
 =?us-ascii?Q?baW1zUOn3ZQmoMAXus/8C8feLcEYZq06rc4rq5aT4Y7NFxSHmBkhJbG8KDyw?=
 =?us-ascii?Q?viQ2k5Gk6+OUmLZlY/BrE1aIA/DTkzE6k7wj6Hjy29eKWTa1FxyD63AgVI/1?=
 =?us-ascii?Q?kuvT8ueC6JBAnh9gHa7zqg/Yd8dTZ3iKoC5uX94PNxnwcw2ISKALlmvY8Pwk?=
 =?us-ascii?Q?x7BM8w4hk/WDd4qFsKasKhhBVR6Bmwdg4pDlXlL4haTSdsjKVGTdsBn2DXrx?=
 =?us-ascii?Q?9Ma9/O17WNlyvhdUArmkuu2aIL47/rzGKNz/LNIt?=
X-MS-Exchange-CrossTenant-Network-Message-Id: caf0e7d8-c178-40d7-7d89-08dd05a64c42
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 18:49:56.1461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ruE2qAD4mfXHW6xsRHdcVrUFTuBnB8ooHdseNVHz1jh3Ga9uxtVg5DGharp97b1NN5ZPS3BIQ2tCl3zQyAOntw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8362
X-OriginatorOrg: intel.com

Please ignore.  smtp failed after only sending patch 5/9.  This series was
resent correctly it's entirety here:

https://lore.kernel.org/all/20241115-dcd-region2-v3-0-585d480ccdab@intel.com/

Apologies,
Ira



Ira Weiny wrote:
> Feedback from v2 lead to the realization that cxl-cli required changes
> to address the region mode vs decoder mode difference properly.
> 
> While v2 separated these modes they were not sufficiently separated in
> the user interface of create-region.  This has been corrected in this
> version.  Specifically a new option has been added to cxl create-region.
> The option requires a decoder mode (DC partition) when the region type
> is 'dc'.  The option is ignored, and can be omitted, for ram and pmem
> regions.
> 
> Other libcxl API changes were made to simplify the interface a bit.
> 
> Documentation was added both at the libcxl and cxl-cli levels.
> 
> cxl-dcd.sh was cleaned up quite a bit an enhanced.
> 
> https://github.com/weiny2/ndctl/tree/dcd-region2-2024-11-15
> 
> CXL Dynamic Capacity Device (DCD) support is close to landing in the
> upstream kernel.  cxl-cli requires modifications to interact with those
> devices.  This includes creating and operating on DCD regions.
> cxl-testing allows for quick regression testing as well as helping to
> design the cxl-cli interfaces.
> 
> Add preliminary patches with some fixes.  Update libcxl, cxl-cli and
> cxl-test with DCD support.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
> Major changes in v3:
> - [djiang: rework test script for clarity]
> - [Alison: split patches between libcxl changes and cli changes]
> - [Alison: fix lib symbol versioning]
> - [iweiny: clarify region vs decoder mode with API to specify the
>   decoder mode]
> - Link to v2: https://patch.msgid.link/20241104-dcd-region2-v2-0-be057b479eeb@intel.com
> 
> ---
> Ira Weiny (7):
>       ndctl/cxl-events: Don't fail test until event counts are reported
>       ndctl/cxl/region: Report max size for region creation
>       libcxl: Separate region mode from decoder mode
>       cxl/region: Use new region mode in cxl-cli
>       libcxl: Add extent functionality to DC regions
>       cxl/region: Add extent output to region query
>       cxl/test: Add Dynamic Capacity tests
> 
> Navneet Singh (2):
>       libcxl: Add Dynamic Capacity region support
>       cxl/region: Add cxl-cli support for DCD regions
> 
>  Documentation/cxl/cxl-create-region.txt |  11 +-
>  Documentation/cxl/cxl-list.txt          |  29 ++
>  Documentation/cxl/lib/libcxl.txt        |  62 ++-
>  cxl/filter.h                            |   3 +
>  cxl/json.c                              |  80 ++-
>  cxl/json.h                              |   3 +
>  cxl/lib/libcxl.c                        | 261 +++++++++-
>  cxl/lib/libcxl.sym                      |  13 +
>  cxl/lib/private.h                       |  17 +-
>  cxl/libcxl.h                            |  96 +++-
>  cxl/list.c                              |   3 +
>  cxl/memdev.c                            |   4 +-
>  cxl/region.c                            |  93 +++-
>  test/cxl-dcd.sh                         | 879 ++++++++++++++++++++++++++++++++
>  test/cxl-events.sh                      |   8 +-
>  test/meson.build                        |   2 +
>  util/json.h                             |   1 +
>  17 files changed, 1519 insertions(+), 46 deletions(-)
> ---
> base-commit: 04815e5f8b87e02a4fb5a61aeebaa5cad25a15c3
> change-id: 20241030-dcd-region2-2d0149eb8efd
> 
> Best regards,
> -- 
> Ira Weiny <ira.weiny@intel.com>
> 


