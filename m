Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6D91C0DE8
	for <nvdimm@lists.linux.dev>; Fri, 16 Aug 2024 17:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723828510; cv=fail; b=casMDFN7gAsgwtA5pNO6w5g0yZL91571D89VLK3iskkOeL/m++APcoerPH89zRKTfttwT/YX57A1Xo6e1diIx4CsoOO5YM/r6JCuP2sGuLd1kJOV50Kf/hIwfa+cLMI9hRVdZmcz6+OREPj14V91oP62awuxZ3JfN4Ew2at2bQQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723828510; c=relaxed/simple;
	bh=psB8eagKDpKuCdGS7Ia2FVvfNQZGNqGm2dx13whJT5Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nchfSjE6S6Llw7eSWskelREwjOboP+6aUgWh5bmDAyrjfW5ObeJ1ktJj6wGxFaHQthkrFB/1oVlwRQX6PYLKOiSGPG64KBgHSB/FX9CvaheKv9BqrERfNVU8J9p05P2AflhKRSQYbwsNLzx8fUOf8ZlXgBfIvJrKMaZG5OizJt8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VZ+AMlZG; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VZ+AMlZG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723828508; x=1755364508;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=psB8eagKDpKuCdGS7Ia2FVvfNQZGNqGm2dx13whJT5Q=;
  b=VZ+AMlZGz1LBryozxB1ONfQZtuFfHxis6dGcWmUZnize6ZuCr9e3v0VT
   tOf8wIhOpsYFzx2WiqyO62PY+th+eY7266syEox7SrVVPwDGgOHpD+/On
   zGl7vlCLQJTb0xEP1oGyafV/D+XMoBHktEgSrlpYmu56RW47m3p4fYTMB
   N3UEvokOEWmgkcdDzPXP2a1i48XUw2xJrXZF2n4XmqdFoSr1pQy6lcnmQ
   ue6ABeNygtyBlseI6xjAwYFD8TcwlMXVWA08Vq23nImuVmcBlh4pZ8gut
   laDvJtTl4kzSReWY0HLM5hbCiTB51yPO+yuWtYQE9/Cnl6aRn2znckWWk
   w==;
X-CSE-ConnectionGUID: OHVm2NkySZO4TwJjFaOmzg==
X-CSE-MsgGUID: v65z9QTxRLCBEpyQ7V5HJg==
X-IronPort-AV: E=McAfee;i="6700,10204,11166"; a="22291483"
X-IronPort-AV: E=Sophos;i="6.10,152,1719903600"; 
   d="scan'208";a="22291483"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2024 10:15:08 -0700
X-CSE-ConnectionGUID: a6xdosLuSIah+6gBNGOonw==
X-CSE-MsgGUID: UZmXT0QrT7aUjy5tmNrRMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,152,1719903600"; 
   d="scan'208";a="59360776"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Aug 2024 10:15:07 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 16 Aug 2024 10:15:07 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 16 Aug 2024 10:15:07 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 16 Aug 2024 10:15:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w1uHXvv+ayH0mLpHba+Kn98+777XaM+X7sqla14f4sIwxf6OApYaSfcuI7VgErJaJlF5BbtaAJDoUKswQzGdWVjwpFGjb+lIhZmB7Pw8eVUYTGVWRiwtOJFA4VYpuklfGXcjoFtWQm+EYoXSNghsHf80zYC9PiiCIup144aJLmLJSc0kRHU0uhg2tqV+8Llu1lk/eT0aJ4VUkIZiQfU1323t8/qyYNsifAuxVx22VfHo9GGeBfG31whicSysDSxwVKu9lFri4sMY2f6IBaCdGagb3uAyaxg5Xc70Wncx10KpTRDhMgLas37jYez3tJqqhjCtubh8V+twIQgsO+1IpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Evd90fHZW/JtTzVkX2M2kDCm3syTErNCUgABlCBD8k=;
 b=xIYJ5Zt28sEldjVdGHobf70+cGVF5IXeDqOjRSWfoY2V25zUmjJZE7CJqpCTF2UYuIubd0JcHvW3vMrU86JleX3U8Jx5QS/fHe0jOm9cUDCfMMl4FntG1nQGEkfWFp976OMuh4dow9iCEJ2HtakyUSoZhAX4IiFPC27Lv//kJE5YPqLMLFi8hUBM7aNBqSjhgXY6WbvQ/vIM1/REl3V721UaYyMOi+f67LEmG+puZDaxC/M3eDDNNc0pHSCrHZoM329FcHPYg8lXW1UjWxHDqKssRkQMUMUy3wyG6lbUynG4jEmWYYVrBGoGHaob3cnVfzgX74VfPPYh/TvrANxm5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by PH7PR11MB7605.namprd11.prod.outlook.com (2603:10b6:510:277::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.18; Fri, 16 Aug
 2024 17:15:04 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%6]) with mapi id 15.20.7875.016; Fri, 16 Aug 2024
 17:15:03 +0000
Date: Fri, 16 Aug 2024 12:14:59 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Ira Weiny <ira.weiny@intel.com>, Linus Torvalds
	<torvalds@linux-foundation.org>
CC: Zhihao Cheng <chengzhihao1@huawei.com>, Christoph Hellwig <hch@lst.de>,
	Dave Jiang <dave.jiang@intel.com>, Alison Schofield
	<alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] DAX for 6.11
Message-ID: <66bf8913bae92_23041d29441@iweiny-mobl.notmuch>
References: <66bf57c7b023f_22218329410@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <66bf57c7b023f_22218329410@iweiny-mobl.notmuch>
X-ClientProxiedBy: MW4PR03CA0127.namprd03.prod.outlook.com
 (2603:10b6:303:8c::12) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|PH7PR11MB7605:EE_
X-MS-Office365-Filtering-Correlation-Id: 91b2619e-af44-4124-e2d1-08dcbe16f7d8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?30sWgXPFDYjSXuDk5SrEGIepRSOe8Wy8kWzoh1D8M6C3NV9mqm86UUpypmbp?=
 =?us-ascii?Q?ayT+pmDT9qYd+NhT6ZJbjR8Xq6v0rIQuUVJZViddj/GM9fCZnEvu0QT1I89u?=
 =?us-ascii?Q?BzxI1wLyWa0MsJg1eiU0otTLhM0diXZBaH/WYSfApkkANVIUA/iMMOzsu8Dj?=
 =?us-ascii?Q?7O5aPWdFRY19IeQHK1I7aYCBp2pXRwokWhY3hKLzglP9p8+XbszKPIIt9bOS?=
 =?us-ascii?Q?tLgu3qLOnJm4d+M9d0fg1dPVEgKCbUnio/zSJ/+QgKqVuzGO0y9a+kr90fE1?=
 =?us-ascii?Q?/nls0q0/oivDBqFTmLAPl0b9K6aP1gel8uK6ZNb3AEkkMnrIwUqCa5jPjqHF?=
 =?us-ascii?Q?FMXBPWZl/rjB3a2aJ2l6nYGfbFW36PGQAti/GSpWPGrUfd2tpg2QSWNiqLGL?=
 =?us-ascii?Q?oQapURUFkgobK9TUNx9E3WoFny89lA1c6UTvI+QtakEZCvJDRqX3TEgadK5X?=
 =?us-ascii?Q?rTVfzpPYCUKmX2ddMqL1wwDtcjcuZgYQseeFxN1rYlvPiXiiOtC2FQg6SbOp?=
 =?us-ascii?Q?+Pbby91e4wUqhq7H6mvWNcewls9XHXYsks9gmJ5O++foUM2lMWpTLktPg11Z?=
 =?us-ascii?Q?RG2Sv8yVKVs5Vx4o0b1/7wMD3bHPG9quJhGfTxBqXdNo7pR9gCNyDH0GHVSR?=
 =?us-ascii?Q?X4+qWFCaKxFlZIcYc7muGSnGY3+AbLT+MXbwXFrqXP+H9pIQGwE5N6y8O15s?=
 =?us-ascii?Q?tmK9+Zwgvh/zgzsa5XU1bYnEs5yAonJskmVaIBgWC6tGBMqlmAbTQQxGXBVq?=
 =?us-ascii?Q?J7wlR5YzMGyFFPW6smoJONCF0j+3NsJ3VsbT/nWn+TCr+50KDvvMYTbQaerx?=
 =?us-ascii?Q?lG9ky0nc2DcoFY1gLOSa3BIvUAjEawv7DpF+6ME0xsfjduYxB+lKznO4sUeX?=
 =?us-ascii?Q?4IAQhBLYdPMcYwIsEQXLzcB1PaBNaf3mWs2nPTxw6IeAVdkyt91UieWuqwxL?=
 =?us-ascii?Q?jrtuEU50aomHbntuJhYL1SvwcukDXPwQdrJkg29lHfh21mIcHmNnT64Gh//y?=
 =?us-ascii?Q?OByu4LpPfCSJYZZwNohjN4l4rudzDRWbR4CqRNzy6KAPed8s6OfjUamcfdRF?=
 =?us-ascii?Q?0t9Q+rPZeIjQj3jsodHP0WOChbFSjS+Iarh1kurQ03zkobjK6954quBdm7mp?=
 =?us-ascii?Q?WzwKyA3oDNsXS8JGo8MVeTLc/HBl+mSBY9MYN1vBpL6+KyjZ5pgphowGJH0D?=
 =?us-ascii?Q?4obXzmI/3rxwoO4ZwqOQkZjUKco5EkNX/zfOscpLWUARf9lqgTFgtNxtdMHb?=
 =?us-ascii?Q?1W7rcUApXpVIvnE7ib/KOICxVjjRi0SLpLJbbhn/ogVRSLk3u7zkgcVSVmxB?=
 =?us-ascii?Q?Fgs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jkfdfp5a5+E9krMmvopEaBZLEz5bW04ZBXbvWCLFdV0ZOTOnMWORkzp9OqzT?=
 =?us-ascii?Q?ZpKKSCAZkMvNsjB2/+3hvGwuvMUDsvRaEpYvU42nG91TAPhY3+n91pTvW23i?=
 =?us-ascii?Q?7cqwCOs5XRFM00wgHPktpmMai+iTIeap71u//1o2JBPUulT5DOGM0dKPATYZ?=
 =?us-ascii?Q?WxcmNcdt++NfY05yv3IMq63SQDhCQ90n0jmy3V7CBXTLmFiDpfQMauaHm6gq?=
 =?us-ascii?Q?PqD3zsR0mS2qYhshjw1ENqfbN4kt35w03a2IyCxxPxaLySwCoQvQl0bbpSoN?=
 =?us-ascii?Q?VWBk+V/1GlPPzE6g+p5xli1lU+y7+NmaPWzzSXJLnP0HGng/aaYvnoxC3DYt?=
 =?us-ascii?Q?bNvKkBzIWAYOKx0uOewoRDAzNH3wxw+uxpY859QBHybAv+Qjn4+l0gaEZnvo?=
 =?us-ascii?Q?vtUsOnLIfF13Naqx5NB4n/AIJmzCvD4427SWg9sXv8Ln0ldlXsA1m3/nFnZf?=
 =?us-ascii?Q?+SuD/57mnqOH7lHis4rEOEiezmrCn9ptCl0GGMd0MzAXDawTB9XrVzK/XQZC?=
 =?us-ascii?Q?6uOgWuhaoZWhswRB22AfypWn+qUOd2t3WgwJq3yNhlS/Og9cLkRbnQIA3pZo?=
 =?us-ascii?Q?5z04Pbzj7iFjibb/2B82uGQ+uQfbQwap8waQnbrtW3G3Gg3yb8LBhtOrwczG?=
 =?us-ascii?Q?LYc95IVXBZCyxq7ljJaViDVZeDAWDGDEr/GxasQ+bo0u3JtYoXMA7WDVmhYH?=
 =?us-ascii?Q?dBjxutwOPMxHd0gP04wD4MoOa+BJEhzhb7Vk1oKErEwDYIoMJAJ4aPXK8EaS?=
 =?us-ascii?Q?3DfBdOTvuA+1/hITv8DdxbKj77UiT/UlydL2iT6yr4Sc4SwFOb3fURJfJs2z?=
 =?us-ascii?Q?bUAkRFQ9FYGrRdQOgGAuNu+jiwgoF+v7YIyFhxQDyLExYx4uBgFbYwQ5n5C9?=
 =?us-ascii?Q?nUnOQRhXhqtlxHVDgh57EbYQES0uDzfWiuZUkPMY/3MNNU2ZN5FSPJ4Naznr?=
 =?us-ascii?Q?feVv4CrQcMwK2uFrIXI8MKO1Aq2E1mh/Vx368mHvzi3uMTiTlPcgT5u/bCae?=
 =?us-ascii?Q?WD1ir8ULlQFUw/O4Wd14VtA7uvzK2NQT5CL00qNO4b7GHgdHzoslNKakO8ky?=
 =?us-ascii?Q?jblrjYZoNoQuPfT9NJtsmuxfmLv+87d+ACmF6ZYeN+ZSHF6dFAwGOQxbDwr8?=
 =?us-ascii?Q?vnJCZPPx9T3CWN3vfFSLrwaHG7aK7mT/iK5SKIhFoUhFA+5e2AZSYsrF7VBT?=
 =?us-ascii?Q?aSZuGQIIkI8U5gX+f21XijUmHCGGcNLWlD+0fo8f9xn+NgtcBJ04POL1H78Z?=
 =?us-ascii?Q?1LnjuQ3SX7cDSrTLoNdvRWHYxk/qe24ainLG3dbgtxBUxvl8T5BOZ1n0vgih?=
 =?us-ascii?Q?d1/u0rMCAEObqh29VRB++w04L3hLH/qyTdDfhZ4bXYDuQT7vO0TbkA4cPj+c?=
 =?us-ascii?Q?r3iqULE15zyf1OZFw3tW0xrMcP/fKuGz/nJsXoaVt3dNoRGAcn2v5PvFOEJk?=
 =?us-ascii?Q?flfusRpBfhk7IPTOD9htOPWKW22UWCP5ZZnlTWnb9pq/F+M+HYV3N1/d05GV?=
 =?us-ascii?Q?2baKfrqXwiZDxgvWju/stNkSrM8mFMP3qSMU+pi7UCqIh6TT0yGvmZsQ66eL?=
 =?us-ascii?Q?LZiW0zNe+N8wjJ0BPVNajHMXvfz7s0CnTBjl78eb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 91b2619e-af44-4124-e2d1-08dcbe16f7d8
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 17:15:03.8420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vHTFaIfg3yIFt4nTCY7PVuPHZ2uTxAcPpaKzN+HvQeEUvrE6XHs/YjdmNrHC7X2X9hMhSKI31B4E1xt5TTygSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7605
X-OriginatorOrg: intel.com

Ira Weiny wrote:
> Hi Linux, please pull from 
     ^^^^^
     Linus.

Apologies,
Ira

> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/ tags/libnvdimm-fixes-6.11-rc4
> 
> To get a fix for filesystem DAX.
> 
> It has been in -next since August 12th without any reported issues.
> 
> Thanks,
> Ira Weiny
> 
> ---
> 
> The following changes since commit afdab700f65e14070d8ab92175544b1c62b8bf03:
> 
>   Merge tag 'bitmap-6.11-rc' of https://github.com/norov/linux (2024-08-09 11:18:09 -0700)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/ tags/libnvdimm-fixes-6.11-rc4
> 
> for you to fetch changes up to d5240fa65db071909e9d1d5adcc5fd1abc8e96fe:
> 
>   nvdimm/pmem: Set dax flag for all 'PFN_MAP' cases (2024-08-09 14:29:58 -0500)
> 
> ----------------------------------------------------------------
> libnvdimm fixes for v6.11-rc4
> 
> Commit f467fee48da4 ("block: move the dax flag to queue_limits") broke
> the DAX tests by skipping over the legacy pmem mapping pages case.
> 
> 	- Set the DAX flag in this case as well.
> 
> ----------------------------------------------------------------
> Zhihao Cheng (1):
>       nvdimm/pmem: Set dax flag for all 'PFN_MAP' cases
> 
>  drivers/nvdimm/pmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 


