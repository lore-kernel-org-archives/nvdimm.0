Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE3F21831F
	for <nvdimm@lists.linux.dev>; Thu,  7 Nov 2024 19:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731008799; cv=fail; b=trmHs4Mw5Fijim2WM0C7aBviXZaqmQWKJCPJla1DFR+Nwb9rj2rjT6gDpb2ekvbk2j+JxESmP6Do1GrBD7cJ9hP3aVvCHcmlmNR/YlcHjjB5wnWyJ0PAsQMHuk9+2lH43vWOyKQbNkn/+ciAAdOJA/bxXPEk6d3FYdIGv/batkg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731008799; c=relaxed/simple;
	bh=E9QW8ZfkYuRxBw9T1VMCCoTbYDlo+FJ+ekR8SPl5w60=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=THQjB180XhBGNHs3JnVZ/HpFvHbBlwSKIvXHTXfo26O3hxUCBFJeBr7XmSSVJD5WqJctWx1jKSSBaO8yDdzebASItA76+vQHgIPEVFlvFHk4Gpzs9ZMZszJcMcWGJraCY49LUNQhaj7GqAncCDyZzyfBzPeO4yaNnCGL00N5G8I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T2CB32CR; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T2CB32CR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731008798; x=1762544798;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=E9QW8ZfkYuRxBw9T1VMCCoTbYDlo+FJ+ekR8SPl5w60=;
  b=T2CB32CRCEkhIQnJfR1yctNEgIUfzEd63jC5YvzfUrna0w4D71kj3Lma
   xXmo1O7wKYAZsPSNM+EG1HFuO3HAVX0EhAOaI7191CmtULuH5mzRq0AcY
   bl58h+RPZgNMiF2My4GhmHYhyPqbXYlG4Qckv+Mu0WMqi5roRBLQqjxOt
   OIKP2q9c+fuhrJjYxzBILC1ELpDQ2F6d8df2laifDNML9hDPgeeT5bPea
   mW1QS42izFpD/Ryp+X3wu9w8AEbawXh/e1G5QUeeCl032WrE7snLB8uDi
   C1x+f2KLSif7QkpHFdBXLu4DxpkYRGrR+btYddDRXHhSUwWoxSleImgvR
   g==;
X-CSE-ConnectionGUID: BO1zzQweRi+lTLoDgEA/vQ==
X-CSE-MsgGUID: 7M8HteHDQl6HFFS+ihcZGg==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="41495216"
X-IronPort-AV: E=Sophos;i="6.12,135,1728975600"; 
   d="scan'208";a="41495216"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 11:46:37 -0800
X-CSE-ConnectionGUID: VmgknzfyQtGDRrnf95ysuw==
X-CSE-MsgGUID: vDAAMzh0SsC0dpuknS3TkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,135,1728975600"; 
   d="scan'208";a="84833203"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Nov 2024 11:46:37 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 7 Nov 2024 11:46:36 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 7 Nov 2024 11:46:36 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 7 Nov 2024 11:46:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RubCPE6BnYdL2Gx5JK/kTi35kKoeBXYu/anD/51Iyhuc2LtJw9uBwQlt38yD3wL1tsswfvqvWUXCVpksqCoFS69eH7xiR5rNwPOLczkO4v2c6W7BzW03RMY5OCl+i0WqVisYwdj7J/pIRT1hPo+7FobZxxO0tIWPjOCzL14LI4/J1oz2W1GXjNH+0upk2BoYydgkym/kMRIkrXWMexoDuh2k7wq5T9khYS3f4ZoEHVYvGZ5gAHoFjnVF/voCeOa56TVEpOXO/ckCb2223RB1eoWCgeTukWC2jTq6Mq+/TasVRqU11pvvQXkMS+cyBym935tnfEyCavSnULUdxY9Z0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pnGXodkHaGJeS7Nl30CAycynID1HU4OBl66KE96LYyw=;
 b=N7yauheHtwOzEaIgCAVzT3RrmhgVYw2CDBSbSEX2JXR+9ANt2Wqp0LFDsx00ZfsU1njV28n6zJyeQFJ57a4rfW+++ApH508jNo+No7/RAo7L9+6FvT2OTZdgJrJhHQjUuIa9BiJCsY4Xi9z5XWbuSfZNv0CUxnw4KvbYs6z6HEdTbTOAM+ODaFcRsd3I1kTwETW7zZnytDulNNA+nfmpWu6roQhhP0ZE1d7bCPyKdMcwFLCCU69NasI2/kio1bxKocGbtLgvucTw+ZA7TVYfCIYq0XrrBjdpdw83wOnEzDUMtgeph8b3JrHjzI1WFEvj10488Rr0qMyoRUtSQInnHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by PH0PR11MB5095.namprd11.prod.outlook.com (2603:10b6:510:3b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.21; Thu, 7 Nov
 2024 19:46:33 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%3]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 19:46:33 +0000
Date: Thu, 7 Nov 2024 13:46:27 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Ira Weiny
	<ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Navneet
 Singh" <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, "Andrew
 Morton" <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<linux-cxl@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 05/27] cxl/hdm: Use guard() in cxl_dpa_set_mode()
Message-ID: <672d1913dbd6d_1a578429496@iweiny-mobl.notmuch>
References: <20241105-dcd-type2-upstream-v6-0-85c7fa2140fe@intel.com>
 <20241105-dcd-type2-upstream-v6-5-85c7fa2140fe@intel.com>
 <20241107110810.00000fc1@Huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241107110810.00000fc1@Huawei.com>
X-ClientProxiedBy: MW4PR04CA0345.namprd04.prod.outlook.com
 (2603:10b6:303:8a::20) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|PH0PR11MB5095:EE_
X-MS-Office365-Filtering-Correlation-Id: d8846931-99c3-4ca0-daa2-08dcff64e1ae
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?TjvPKSIa279HMNH3XkmG1LJNQoTFSq2U9t2jx91DumSoQQbuGyq4oT6hgu5f?=
 =?us-ascii?Q?PtEOrP8g/hzfCsJLuwRKk+M1pgqHu2RwEGD6ZCzsUmJ/etYmWD7ES7bWPSy6?=
 =?us-ascii?Q?4ziMjGr6AEulPLrGrq5JJdZSAbXSI7qACjxradjvprie+zeIEhWeFgctsGCf?=
 =?us-ascii?Q?6vGVP+p3b2wX8kAdlL4FeNuvdzpmjeLBiiCOjWJ9aGUXNq+hyr5b/ewUEMwJ?=
 =?us-ascii?Q?w2qGiQstV434j7kChFXGj03YlEg69bv6yZ1RnCsJuzDWYw5OdikSEfYu5A2T?=
 =?us-ascii?Q?+aq3DoF+/ZMCXZUiOQjrLd7zbV39bIWMXZDUTZuxDtl/H7fLj3CBTrNJQbhy?=
 =?us-ascii?Q?JUJoPBB6N/2RaJiGwOPb6g6oXfnrwsbdTxvCqYoBScjQPeKRfoL4ppU4VUjj?=
 =?us-ascii?Q?PESv6a/oCwDJooiDoc0OZsL37keTqitJlto6S9lO/QOmB4G54Ho+l1T1YAzb?=
 =?us-ascii?Q?NOdnp/snpEgttymDahnOHvKqkOoUi2dZUNa8+QmMnbMclTwj2QBSMcn4PtwJ?=
 =?us-ascii?Q?Kf2GBIfkbFrOz9FFv7vLy+oHJwV3uU6LgGic0BlZ1xHF7NOGbq0Mc+0x4oSI?=
 =?us-ascii?Q?kDMoXeHm3qYP0tzKUNzJV8UfWTrWG0FVEL1RiQKdnkdN/XrTENIFvZQsFuCv?=
 =?us-ascii?Q?dB2n6bfcemMwt8MW0Nisrtx2jL/fVhoC92kx0vx5Rz9QDj1lIvhALni6gkck?=
 =?us-ascii?Q?qSQ/hYbmZVoY04+AASlPZVDXzi+Js+mEks9wXEkq4P7W95ig3hDBzkdYxRAT?=
 =?us-ascii?Q?lfLr1w0nnddaDZm6sdM7hDIkP949IqI9B39uUUKVs8kjMkZ2rfAcVwHs9jq3?=
 =?us-ascii?Q?bzBo+JrBoVcIWzz2wQdOth+Nt1Yq6AblfDhJozZ/mf4EWRlJMDa3YmoX6ziA?=
 =?us-ascii?Q?N0qemhMDxFenbKsKGAnvkRvagXlk4hExLHIYsDU+srtMm7vY65v1oJtyIAU9?=
 =?us-ascii?Q?2qZhFaIXAu2bZjtnEzbdYz3y3cn3Te4pCKdYqfgltS6B3YNMeSYspOzUS2kw?=
 =?us-ascii?Q?lA2zLhUFY9xWmvfURgnlye2Xe49cTgbBXz5Q0TiuLjLXYG5W0dsM5sSGUPQ9?=
 =?us-ascii?Q?Nc3XmEzk5JEY3o60Dr5G1uJAoqYlq8ETDRQDWxq39gts4QAqFCeooEUP8ZHk?=
 =?us-ascii?Q?IfjWzdwN2kZP6Pql1DvA5y6YQm8EN8jrSDaEZ8csYKEyvYMyviKScgLId1a7?=
 =?us-ascii?Q?ahckT0hBhhTFLrRulpm9iLA1KzUr/85rn+VA7ee3Xqi049Py/q3gr326YMNL?=
 =?us-ascii?Q?yGrCsRRol2agCnllvhUQGmi64XtiGP8/2z/WNA6t6zEwmaT4gujAjyV1mCSX?=
 =?us-ascii?Q?ZTQUTK9tdr+wXDnUmirBsSel?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SSobtdeSVRt8lGAKRYpNm1KrSwIvQKHNZ2HLkU5/KYOyyebaxBIBNtLRKBiO?=
 =?us-ascii?Q?RqFNYpBcvD+qPStHhQd+SVg3X4hMf0QKUANbNy+PrFc4kSKsrBap9HMo9AfH?=
 =?us-ascii?Q?9z1D71L0iEdDvL/MoUY0mOLL8EPYOrJbS2nby2tvv83uLaYzWYXvRW/Yd0af?=
 =?us-ascii?Q?3w6GCC/cHcSwGUuVZwJ8Jhx2cyKwA23wgEwOg3tn2QRnDmpxJiqZlF1WmYa9?=
 =?us-ascii?Q?JFvsgPKRtgkZQD1zSSfpcKieXfJ7lJ40qZIj/K7FY9Pl6ybfdrRZWrKwlTab?=
 =?us-ascii?Q?xOwQrvFEBxPNY6iw/mvTu3J5Il2D8YJHD3rhKJ4QtYHs3/gPwy4Fnl4f6ebH?=
 =?us-ascii?Q?iVkmEg45e/cVMvdXxx9sSp7CEV7WDGAaYiToMJRvEx5o6e65Z9rYxIqIE6zY?=
 =?us-ascii?Q?v2i8B1WcG/G0EKiF9XnWS5TIA15emkc62wcLlXFq16QCSrvK/9+ORRzwKVzq?=
 =?us-ascii?Q?3q4SxCVvR4DpaYF6n1Qp7pRqdKdeecGaQTmGtxVsAEQadMhUxwVOGyo8zhcb?=
 =?us-ascii?Q?ogEY2lcbIH+BdKh4S7km86/MC41l1EFyDPmBs3u3UM0I78uLURJGIPxhFSSw?=
 =?us-ascii?Q?Vfk/dthB0H/7IEeey5iirfCdFKuKeWKfca3xS3d+cdDdXhiFVXvmSJHOj98J?=
 =?us-ascii?Q?YuzdFVsjGcaCVn+flYiFXfa4NJhxbHSbg6uJkubePLesko6ZBHGB0JZzMr1w?=
 =?us-ascii?Q?iNOhukhYFR9j48SkgHcOoFSkYhtl08CrHwAK+4MxiZXiIBkRahTPDp72LS3g?=
 =?us-ascii?Q?/XsRUE++TgHK03UTZFRy+i4PB4DGSOJ9jQ/01y+KMSbVdteUsq7EQO7wKqS+?=
 =?us-ascii?Q?dLkb4Bv4BxXtdI5zP9KKsSJO/y5hVLpFzwpwcKSmmlvEKUxXXe1iJjwxVkT/?=
 =?us-ascii?Q?9MwpI1n/Dhc3b0/v8crideYoLjfy8Ym7xwkjQwgvLjWngr1LaLXxpJN2lNS3?=
 =?us-ascii?Q?qcaKQd9MGGQ+5MxJP4LokY3PQgXJ3XX2hgY/Nd5Q1dZzIhkY59SAzUkJ6oTh?=
 =?us-ascii?Q?EWUJIP3V4hwmLKDHSHZh7UbdBCXiEEFs8zcZODYYxfni6mcabLFTZc8ETHA0?=
 =?us-ascii?Q?DTIjL4iJxlJhDwbSo/Dfqs+6zajI/P2qrcUxe/iCdUriDogmllDlz+cEIwaU?=
 =?us-ascii?Q?dYRnuRqjNd9992xsOMFzOOEGhXLYjfpI/QwF78jL9MVOl/KaHI6KiqqE8yhl?=
 =?us-ascii?Q?Pfnkh9bGlH3gvTt68XWIuPiuhFJnheMBbFwnJZC9wsB09aHv848lzqAaNNO+?=
 =?us-ascii?Q?wqwBw4hZ/kElQBZcIink56luQQm1sUUgDEZNFjIHOCXdB4nwx6VeA+tiZzJ8?=
 =?us-ascii?Q?UAUwrNIxHWBqSmizq5s2rurff0DfeCFdcUoSLpwikaxLCe4uK9TJRrWtP/TZ?=
 =?us-ascii?Q?QXmbWpD7kZkRV0nq70WdsFq5nbEV42yWEL52YiW75n14XAbnxkdAM8t4hc8i?=
 =?us-ascii?Q?ivXZTejaLS7NvohYxRCW9CcEz95R/UIrTFiK0w8AmJ5tbhYUFBlWp094Bz6W?=
 =?us-ascii?Q?S1t58GAY9DAJHxztDXoJuciRyLgCXpBV4OapMgpiDaFq9t5hBx9pUQdWNfxM?=
 =?us-ascii?Q?WR8YJ7XMcBP2uaqXcnRppDU5HOfIXPy/Oiz36vZa?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d8846931-99c3-4ca0-daa2-08dcff64e1ae
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 19:46:33.0392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S6x3ttBPJT32TSveLk8XfvZvVdDlsAcT3Q6LgUeD4HNdbRC7AXIta2xsZpzm2MaFKXwH8zoeQpttunLi7Bi2Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5095
X-OriginatorOrg: intel.com

Jonathan Cameron wrote:
> On Tue, 05 Nov 2024 12:38:27 -0600
> Ira Weiny <ira.weiny@intel.com> wrote:
> 
> > Additional DCD functionality is being added to this call which will be
> > simplified by the use of guard() with the cxl_dpa_rwsem.
> > 
> > Convert the function to use guard() prior to adding DCD functionality.
> > 
> > Suggested-by: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> You missed some RBs from v5 and I don't think this changed.
> 
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> Davidlohr also gave one.

Apologies.  I've been using b4 trailers to pick them up.  It looks like it
worked this time just fine.  :-/

Ira
