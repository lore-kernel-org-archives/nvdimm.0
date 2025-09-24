Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545E317B418
	for <nvdimm@lists.linux.dev>; Wed, 24 Sep 2025 15:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758728646; cv=fail; b=eu0lsGk3BtwT6eZx9dU2HpQNsbaBS+2pw9CrXRRB7QS95yz1c1K5njcQxCo6Na9GoxxU0EGhFYXs1kDiRzoMjaC53qrIxcS5urNPjsBuUMcVpjMjdX0EkASO5+q35jzZJxWWzW/dTsoASlJQl4OUWtPIt0HIB2bXBQRL6wQ2yiQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758728646; c=relaxed/simple;
	bh=OKGPd5s/GNiLXfww1bXr1bF27wcIn06rjCLARJDuh7k=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WU0Yz8ElIchvni4SCmtlQOBarNvSoKigPFwJVFd5qS8gT9fM4kSJ3p2eZsum5x6GrwvGtQ9ObvhF4OAN5w8OfYV8U1yEcslYnhTpuRmKxsMC7aqIMoPZh7nkChhjlThUYgMfEvNQnNFCy2CA6xZ7TUu0f6tUUZX9cC4r8MRcAEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HjakrQVQ; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HjakrQVQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758728646; x=1790264646;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=OKGPd5s/GNiLXfww1bXr1bF27wcIn06rjCLARJDuh7k=;
  b=HjakrQVQGx5xULWDSACQfGl5kiFf4zrCD+PqoewVAneyPyPThabEonYx
   dPUX8TLd7hyKQhYu3KNxJotiapkAIraWQEuQfs2WZ3uKCerOH0hFAwMRI
   ruU6mWYNt3k++XkrAuczuqFDcDQZnPOTS4q4Ptz1wEnBRA+SzvuhHlOfm
   bmOO60Ce+7upC/pF7C6NuaGESex80jRagWZgyYuszvX6470HxuieEoDKz
   JOQFg4UuYDhWifV+RRptht+sjVdYGKBO8nqLpPfMlA93JYVK7ofH27gCu
   XsFVo2MliKenV1amFCUSRPtd2HyK+Si4jypY5B6iZPKhUDbny7UWvNx6j
   g==;
X-CSE-ConnectionGUID: B0ItbpglSHy1gv2os5g+lg==
X-CSE-MsgGUID: I4rt+nA1RnOXrszHEK40Kg==
X-IronPort-AV: E=McAfee;i="6800,10657,11563"; a="83633093"
X-IronPort-AV: E=Sophos;i="6.18,290,1751266800"; 
   d="scan'208";a="83633093"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 08:44:05 -0700
X-CSE-ConnectionGUID: WmgruapYQdujQiZWDhdSXg==
X-CSE-MsgGUID: nmFG4YT8Sl+PvKCthINtBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,290,1751266800"; 
   d="scan'208";a="176185117"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 08:44:05 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 24 Sep 2025 08:44:03 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 24 Sep 2025 08:44:03 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.20) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 24 Sep 2025 08:44:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u4Bm7BgVsRQYxS+o3PC83kP3RyEwEwjfO4P4oX3XoeUNZp9h8uBEc6aqELwEXirhIsMzotrobYXhxM+JtorNzy7T7lqJA6A57IK7fAXyCEs1tAN/2Nbn/Oe50GrllhYevnHG5sgMlUfJUi7CK1YsDWCAQ+hLoC+eJsnNhcjKdjPGucwnZrR/YAnwcKy/c+WqTK4E1akkr+IBnp/GrzTLHjBH8jfaAlceCxtcVDSotdkx9PVcCsxZaqDhvI4k6070AlF/K6LEoga4Ujh9W/6AZKTUglK2qH28l+80SjOnWbHwez2120aBPe/AM8G5zAQ2tcDg1uFWcQD7O4JKL6aw6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6gxIPhMiAdz7Kf3gYAthL5aqtmPce05Uy43Z1Bzg7Rs=;
 b=LBZyc9PXQCv75gJJUT5KpvIAxaJgpOd0hV1/VAnOhPiYE/q7GbVqQk86Ce70sRWHyZw4Ntww3VdcRDCYnJPL4WNl9d4sfZN2Z9XJdu6nFfmjhWc4NpcUjxLNUFcPGOt4In42ugheubNnpKJM76D4Rza7rkxRG+R0oapwu4rFwKtel9THTCDYesyqu/O2pphA3UkoE0/f55Geaj6jnY+iEye8rTTrNIevRo6oFNBJiuVnIdCg4CwhHy6byCx6ZrK6mAjNmPXu4nh0yZ5MG+exnpAbznz6VSfiDWOBzvMd2iRRh9YWcWRHmXqQ/l6Nw9dhXLKoiUCf+mlVnNaJyR3Vlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
 by SA1PR11MB6824.namprd11.prod.outlook.com (2603:10b6:806:29e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Wed, 24 Sep
 2025 15:43:58 +0000
Received: from IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2]) by IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2%5]) with mapi id 15.20.9115.020; Wed, 24 Sep 2025
 15:43:58 +0000
Date: Wed, 24 Sep 2025 10:45:59 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Guangshuo Li <lgs201920130244@gmail.com>, Alison Schofield
	<alison.schofield@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Santosh Sivaraj <santosh@fossix.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH v2] nvdimm: ndtest: Return -ENOMEM if devm_kcalloc()
 fails in ndtest_probe()
Message-ID: <68d41237139f7_23bffa294a9@iweiny-mobl.notmuch>
References: <20250923125953.1859373-1-lgs201920130244@gmail.com>
 <767ef629-519c-431d-9a89-224ceabf22be@intel.com>
 <aNLsXewwa0LXcRUk@aschofie-mobl2.lan>
 <CANUHTR9X2=VPHPY8r++SqHZu-+i7GGP7sqbGUnAx+M89iiYS4A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANUHTR9X2=VPHPY8r++SqHZu-+i7GGP7sqbGUnAx+M89iiYS4A@mail.gmail.com>
X-ClientProxiedBy: MW4PR04CA0159.namprd04.prod.outlook.com
 (2603:10b6:303:85::14) To IA4PR11MB9131.namprd11.prod.outlook.com
 (2603:10b6:208:55c::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB9131:EE_|SA1PR11MB6824:EE_
X-MS-Office365-Filtering-Correlation-Id: aaca37d5-2f41-4116-3fec-08ddfb812d21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RzRJUzJmTDJIZU56TW9VQmFONHNuVzEwWlJTdVRkN0VDZTJpSmpzTkM2MW1K?=
 =?utf-8?B?VjExdStsSnViUmw4UDZjQTZ1cjZDTHVDQUZvcFFFbkYxQTVRcmN1NEl3Mm4z?=
 =?utf-8?B?QjhibzQ2b0NqK3NqT3YxS2xNZllXNUhOUW1wMVF0b0VTays3ZnpuYWk5MVZO?=
 =?utf-8?B?SHFJNVpHcFNyWVZiRVF6QXhFV2pjZW1sMFkzeWhsZ2kwT21LZzBIWFJuUzB6?=
 =?utf-8?B?V3RBSHZmb3NtZERESDRmN2lvMVlWeVlEdDRpdnJYbEFuZUVNYkt1NWtndHR1?=
 =?utf-8?B?WTNYVDJFdHdZcUExV1lBL0RJMzBZT3BnVFl1bnRRWWZaTy94MjFNVVBoUE5U?=
 =?utf-8?B?bnM3Y1l1RHRRZ05RM3dnWnNZTFZLYVJ1NDNldlFIT3BaZHRNalNRdXZSdTZB?=
 =?utf-8?B?NGFSdzdYSWZSMmIrQWlGUDViQ2V3MGI1WXQ1bDI4RllIWXVpZ09oQVNXVmtw?=
 =?utf-8?B?c09ydk43THhYK3Y0NUpRZ3BpbGhtRmdML1F1RDh3R3pwT3VWMjE3c0lGdGxj?=
 =?utf-8?B?QnNXYTJhOW1tR0ZQR254OURJSzh3emorWGZXdDhFVmhYYkN3bG9HWisraEV1?=
 =?utf-8?B?aFltN0hCU05lNHJvT3hCSGNQMlpkK2pOdG1GQWxNamVTYnpyU2c5Z2Z3RFpO?=
 =?utf-8?B?QUhTTEJjV0FubmNDcTlxNmNxQ2gvVG5rMWNDM1VwbytSU2tYUHNpRXkrV2hK?=
 =?utf-8?B?RW5tOWt2SXZCUXFlNjZQS0plOWxabW13SGVzTzN3Y2JOeEMzN2ZsVGlJTU9H?=
 =?utf-8?B?QUlNZ3l0YTcvSlV1UkVBUE1sVUtsSUc2Z0dtWExrc3pDSDRPbzBycEhmMks3?=
 =?utf-8?B?VEJjcE81dUxrdzlWRHJMTEt1VlVMU083elJ5bGxnUkg3M09RODlKdjgzMlNk?=
 =?utf-8?B?NkwvbnRpVlBObEhLNmVvNzZlaVdPWENZSW5JcHNreGJvZGhPdzZuTmo0OFZY?=
 =?utf-8?B?L01PMGo2MVhhYWVYTy9yZUtWQ1BpMFRuYUZCYTdFNVNXR2xHcVg1bisyMmpo?=
 =?utf-8?B?TTVlVzNMS2xvODBBN28yUnRDVU9RYVR5WlZNMlE3YlBRWVBwWE1UY1ZqM3ZZ?=
 =?utf-8?B?b2FLSmRGU2l4VXc3MlRVQVRQdzRpS094K3AvNk9oZ0dTdlJsd1ZmcXl2TnlP?=
 =?utf-8?B?VHhGMVV1dDkvRlY5NW1XNVIrMjRIampFUUZHWGNmVUxOcW90NG9RUktuc1Bp?=
 =?utf-8?B?clM1Z1FPdUR3Z05hWVFTVVdVaDRPVkhlMUFyQ1d0dldHSnFmZXZZNzJZTlEw?=
 =?utf-8?B?UVp4bUJCRHdnb2RvT0JXSWUxbExXZXZ0N0JCYVdqNkJpRWtRaTJTYmhwVXMy?=
 =?utf-8?B?TmxiVGVaRXpsb3M2SXk3U0crMWYvRnJXVTJYYVI1MjZqNnN4Q3l2UVM3VFZG?=
 =?utf-8?B?ejB6a2MremEwL1Z0WWc0Y1pQVU1GUXhxeThCanNpZEUzWEtTS0dTUVBJQmJS?=
 =?utf-8?B?b21lMUJTWm1JQklJaUQra1J3UmNnbmNFSytFV1llNnZHUU83M0JPc2FqOUsx?=
 =?utf-8?B?bVBQSjEyV2QxY005VS9aTTF2RGpNQ1Ixa2NJV1JERk1BOEFjdS92R1gvbFFu?=
 =?utf-8?B?c3ZhV2R5QUtUK1AzTUdCV2tQY2M4WERjenRqWVpJUldIR3dhYnJ0UGdNTkV5?=
 =?utf-8?B?R3dQZVJxM0g0SzVOYmFsNURLcGFqUVlsSE96WkdxTUhmdDZnSEliNEJGaXN5?=
 =?utf-8?B?YTltTUhpcU1FMEhzS0MxdWFGUy9reXFhUFNzTXJUODdnM2xOSmVocExsWDFO?=
 =?utf-8?B?UWNXc2NBYlZ2VUpaNXBWSnRzdVBKSlExTFNmM012Zm8yOGdXankyWjhqYWJ6?=
 =?utf-8?B?L2tJSEIvMU5rQWMwOGdjKyt5aDlXTzlpdGtmakhKaUxUcUlFejZNV1Y5WnJL?=
 =?utf-8?B?NjVYMUQ2Vi9hMVJkR1JtMmJzTHIzeDk5UXdUeHJ1OTk1RTJwLzFtMVlQeHZO?=
 =?utf-8?Q?iURy/WhIgeU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9131.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OFNnM2hwWWExbEhrR0ZOSFpHVGUzYUlvcmJDTkFJMm1GeUdVeElmY3A5M2RC?=
 =?utf-8?B?WjhockJTbHg1c2E4VkUwRFphNGZHa3V0cThNTW1hZjNEYVpGcUE5dUtnbFBW?=
 =?utf-8?B?UXBJQjFUNExCZWR4elVZOWFueURybHIxZmpMZEhiV2pKTnBpT09uRDNiNWhm?=
 =?utf-8?B?anhTcWRuNVh4dE1IR0N6SEdLSnRheVdKNkFCZm1GN3FkNFJZaUdPbUM4QUZq?=
 =?utf-8?B?cno0eUZCUmdPUk16V2NvUkh2UDZUY2tOVG5VcU9UcWpqZ2JiNDh3Q3JFbVEx?=
 =?utf-8?B?dmFSVXhHY2l5MjY0SDdBVm1LQmQxeWpYS1Q5ZG12QkRIZjhDWlU2STdWVzA5?=
 =?utf-8?B?NjhOK0FoaVFxRE91UGZYNCtzY1NzYU5zbE9qbFRvM2V2QnhLS0JyOUdtd1lL?=
 =?utf-8?B?b2RMa2hQK3Qzc1FqUEs4SGwvcmFBNWt3TnJRUk94dHV0UnQ5ditjL1RDTUJD?=
 =?utf-8?B?eVNJQXp2TjdqYThqcDh5WEZobExGTUp0Ri9RWmdPb1ZhL0RNcnhjWUtGd2xq?=
 =?utf-8?B?RnIzbzBnNTNUdmVqN3VFaldIckYvWFd0Y2pibFphTDBwTWI4NHRpWlZlRVhM?=
 =?utf-8?B?U3M3WkQ1Tjlib1VDZDFSVDhFdldFYTNvdGgwNFExY0lGQmRPZWUvM3E1eWtD?=
 =?utf-8?B?QXMyM2h1Mm82UWZrK3RHY3I4cVo1alRlQkM4dmtCc050MmlRWVNJNXE3TVps?=
 =?utf-8?B?STU5Mkh4bThWZnBqTk5JRVNhdTdMMzY1UzVCTkFLTDJyYlExQ1g5UTRhVVdn?=
 =?utf-8?B?b3Z3aW4zWmVEcG45UHZpWnZISDllTFZmY1NodXdtd2tDWFFIOWxYQXBrV3Y4?=
 =?utf-8?B?dEE4d2xTdVlDVUJBWVplSkM2bEtsbytqMVU1M0NueEpycW5hQU53UVBwSjRF?=
 =?utf-8?B?R2hkM2Jxc2k2dk5HeW13dzhsWDhxRzJ5bTZsTmdIdmdlaFlIc25HMWhlRUZw?=
 =?utf-8?B?dlJ6RndTU2ptRXY2UGQvUW1HcDZBRGhaMzdQNmM1S2VMVVRneGtxQS92U1Nn?=
 =?utf-8?B?KzdFTGZhR0lQOURFVDdVNEgrODJLU2FOcmo0YUxOTW1BWmUvMElQSXVIdm5v?=
 =?utf-8?B?dmxIMHIxSVdBTXVUc01BR1R2Z3FYZGJ0NStHSkhZSDZ6QllKTVhsejNObnd3?=
 =?utf-8?B?UnBpdGVFSllJQTVkeHNHYmxWaFIxTFZydHdUL0dWd0ZxQ2tYcVg0OVhLaDFR?=
 =?utf-8?B?RUxPcUJYano2U1Y4cjd3VGNNSzRDSVkxaTMvZEx6RHpVV0tqYnNNZHF4dlUv?=
 =?utf-8?B?U2lJdHFtbGpNN2VCMHNDeUN3eGMrMDdrR0kyM0hMcHZidU5MalBZQVp5NmZI?=
 =?utf-8?B?VUJmQnZyTEUyTUhBQkdYbnFJTVBOb2VHekNVcGZ0ZkEvdE9aa0RGMGpWUTU3?=
 =?utf-8?B?ZXdnclppZmhhUG5MMVQwOFNkeTUyeSs4QmxWUUZPYkg2ZkYzMVYveG5QbllG?=
 =?utf-8?B?QjJnMHNFQ0xHV25aU2tuYWFudndwVGF0d2oycFpGcHk2MXVHdVpkelByWEFE?=
 =?utf-8?B?TDlSeTRhZ01MaDZLWjZHd3JUR0NaK0xXdTZ4UVcrRnQzWVplWDRoamJ2SzJx?=
 =?utf-8?B?NitieXM1bFpNanFMNnZlcU5lYkVLa0NYNlhmMCtnaGtpL3NhWUEvWnE4TEJ2?=
 =?utf-8?B?UWRwdnNlcFpwbjRjWDlFcm1COVdFNWFjb3loNkxTbllENmpPa2EzVE9MbVcw?=
 =?utf-8?B?S3BmckZGQnBUb0dxb2E1WHFyRXY3UlBzTDAxWTdZTjlIYXVxb0p4djAxa2dF?=
 =?utf-8?B?cmEzN0gzTW44NE1PNzFBZm9Bb2xXNXBZaDZjRDl5K1hYSXM2a3ppOE9YZzlM?=
 =?utf-8?B?QXZxZDAwbUNwY2Z0VXFpR0xwQ3BDdjJEVzUxcnYvZDMzWXMrNjdwbkJPaklF?=
 =?utf-8?B?Mys4ZERWWXlEaldIa0JnZWdYRTJSSnJmWVRhRm5lUTZkOUl2czE2S3lmUUNi?=
 =?utf-8?B?NGc0ZTk5SDllZTlBdjlrTm5uS1NyQlhJU1hSRWs5OW5xakFieWJyemJiajRN?=
 =?utf-8?B?MTlrYlZ5T3JWMUZtQ0dubFp6SlBhdlJ2K3MxM0gzcHNpM29qWkFxRHF1ZDdk?=
 =?utf-8?B?T3ZBZllXaWFOVy9RUGozOS9GL0FYSlV1Z21IYzl6Y0ZsQVpmNDcvbmxEUlN5?=
 =?utf-8?Q?Xs13RoKWb6ijSWHg+AM/E1Ise?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aaca37d5-2f41-4116-3fec-08ddfb812d21
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9131.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 15:43:58.5102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JA0z3mppcpJbIh1ma7H/bhtGpC1PXDNKvToA4QM7P6XfDKAsddF20lfLkLNFZxAYdqv+SQhkTXKtcGRf7EwVDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6824
X-OriginatorOrg: intel.com

Guangshuo Li wrote:
> Hi Alison, Dave, and all,
> 
> Thanks for the feedback. I’ve adopted your suggestions. Below is what I
> plan to take in v3.

I would just post v3.  The review tags given on that version will be
picked up when the patch is merged if it is ok.

Thanks,
Ira

[snip]
