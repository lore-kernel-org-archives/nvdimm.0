Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1772F1FC7
	for <nvdimm@lists.linux.dev>; Tue, 13 Oct 2026 00:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791850845; cv=fail; b=IDuOlYz0FfUpTR/5ge34NbsOwQJW9lNesXagx+Fmcd/lOzdNXilf2vWShI8he+BQOz4WECofojxshUTiUBa7Isp03pm6pRXj79zt4f+xbCR1IUgj01NvbE0XX+wUnkPbrJLibQD4oFmaVhpDCE5HSI+gKJ7VNw5HVQTn2sfxw+s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791850845; c=relaxed/simple;
	bh=Vvyu4wOQs8c6BX2hErZGoEaoL1NQF/UECWxOYujDXlQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=P7ZgZYb1DO9LZ5UNTx6ZP8dfFoHD8QCw4iEvuFFn0CgKFxgfi/Fy4vWBacpgr8EQGgKIh7yIlCtX66rWs3Z+tU3weMAm1yO1PAcWyKLOWWNvNQC/K85C6LNXjvS2SJ4cTVw4087NqsfqP0QYV9sn8c0LhnHuXuoGPHSCP/Yicms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ISItDFko; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ISItDFko"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791850843; x=1823386843;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Vvyu4wOQs8c6BX2hErZGoEaoL1NQF/UECWxOYujDXlQ=;
  b=ISItDFko0Fhb6Ohvle/WoC3qDIIZblTIKQyLN/aYtKEhJG/Tm0qoUf/w
   a145K1ooLtQBfp/xDUH9H13KOQimNX7hRGx6pUhBbIYU0KtCxkspylWKo
   vxtxQl9TpD093bzTpK4KapuhEIYO+I0dAoOMrCgCOyGNcFZTbZAc/17sb
   wqFK21yBYzdjmRElZJqFalRBOr9i6EXQ2Wh9ORY4cj8ujNC+pXErTnU8K
   YrSzqifGyyNhmCQApCfU7IYAyGGphM5gdrF+fmPgCUJ3D5qKFQAk/Lfgn
   E1mgeqW5YWsJ2UwqxHhinseurrMb6UYldM2Q4o3/w5HxanS3PIQzvyfM6
   A==;
X-CSE-ConnectionGUID: XQSXeSrRQNOdn9TNPOXWDw==
X-CSE-MsgGUID: rxjygJC0SQW0qy/wtgXxzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11933"; a="577488"
X-IronPort-AV: E=Sophos;i="6.27,154,1787036400"; 
   d="scan'208";a="577488"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2026 17:20:43 -0700
X-CSE-ConnectionGUID: JnRtj9hAQ42qKsiZ9sQdCA==
X-CSE-MsgGUID: cw0TOizpSZiSTBVp+e2QaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,154,1787036400"; 
   d="scan'208";a="2784282"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa013.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2026 17:20:39 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 17:20:38 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Mon, 12 Oct 2026 17:20:38 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.17)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 17:20:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UqBqu9PGTG/YSWpU46lAMDU4Y7XIBBTiFBb0UsXR5YR1kJ1iTzpdZv7xqADcaIdBFA5DAxCGKAcyeG9hdbwZHXKmCc83sZofj/OPyfuGb88cFComMYK/4As1K2mxnxSSsej/+stJzqw9rbTJ1uiscGlYs/Z7ntRQNl/KQm2ScZzcETupWOMbwwfbD3MXaV/ODGAdy/+/q8eTVvp6XCe8Ub0EjV+4Bl6SwdJjRfps4E8pEfF0F3hCkjiL4ZNx+PMLBXcuTFexKIeE/SunBBX0071TvdDi59ndoxdDCP/jrYXW/JpdIES1tAaP8u+wI1lVhfGOv9VZqxgjTpROflvh8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tlkP0IxOIC1gMb9cyTB6S3iYjerlalLYraHkkLuMQQk=;
 b=QZ1TWd/8JPnTIdSUMPl2SfrS+JrWq4ZgNQoh6DpsYzKuGPdqgH/dkM5ODh7lkj4EObbaXWP/SU5kXL+YVvz1tFyNMMuAWvXWFfh7bGmMK4bCn3WfJ2jBPzX2C59LMPWLMaJ5//dvoo3TQjxVfAExbgEl/Gl34oVDlmD6KUQk18kTJMq86+n2ucd2ifhW61FT6N8gDSF2QOfB+FYVEkGDVJbWfC2RZ0p3UzPNGeympPI6hOqJ0mbdjP67nOQLj9oUoX9IqOh026nc1eRkyc8SIEmwk+ov+qBqEjH3+eH/gOI1rtt7nJ5kK9eF1vJAy+DNwrnK3NZ3kcJ1L/DN6Nny3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA2PR11MB4825.namprd11.prod.outlook.com (2603:10b6:806:111::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Tue, 13 Oct
 2026 00:20:36 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 00:20:35 +0000
Date: Mon, 12 Oct 2026 17:20:31 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Muchun Song <songmuchun@bytedance.com>
CC: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
	Joao Martins <joao.m.martins@oracle.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<muchun.song@linux.dev>
Subject: Re: [PATCH v3 2/2] dax/bus: fix Device DAX range alignment validation
Message-ID: <as15T35oOudDM64C@aschofie-mobl2.lan>
References: <20260924025035.1265035-1-songmuchun@bytedance.com>
 <20260924025035.1265035-3-songmuchun@bytedance.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260924025035.1265035-3-songmuchun@bytedance.com>
X-ClientProxiedBy: SJ0PR05CA0090.namprd05.prod.outlook.com
 (2603:10b6:a03:332::35) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA2PR11MB4825:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c382b28-9a3d-4d51-f9bf-08df28bfcd1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|11063799006|6133799003|56012099006|10067099003|22082099003|18002099003|4143699003|261009223027099003;
X-Microsoft-Antispam-Message-Info: 5+/4xhmm3nYOXTTfZYgOFYXYxEFGxxZ1fSkSYCKbu3qxC36+iE0JGZ9IZ8D+p2ik4+ddrHJJuAKOM4X9gKo3ACED04dK7VEyuQhMVnUesIhMQDHQap09sKQ6mmhQabYlz8Q3aM8W5hv8BCCN0zE7X1F4g+KyZikhpQZV105hS7IRNBhsgQ31nHUiL1GJK6d8FjgEnxT8wefX4il4ifvWy4DYoIW1zDn1HB8oMFEABMFWJFz6a+4JuGug9eco/b56ZeSW0ap/6OBYnxfHvsb/YyD1Q+oh4p28g0HZObxcD8WtRQ37JU6j9GW17cQ3mtNw5QQmvxctppn0fApQMt7aYtq3TQgYYCnrsRXujS/svoUL6urAYBq44lTZrKjf3HjSYcuPzCXJ84nGsrjROC6dTMtA1ppX+zcz9CsEpW3dTul43SUaHqiEdBZrd1tx7QpRuOFlcixtJL0Xe8kCNBdQL6ex2SxAbq0qDosPDYUxVuU6CCd9R4lFnIbOr8E0nXQPLapgZt7mOBvvjrHciUFdSolVJDoGPFmRtReRJyQC6ludUNKKuIpGoZFhhbVu1Dl7FDK3zw7w/bzQP/f/L2cXQO6zX1REq3LVolqS7R2AXLkfSHsLw8uxgToK33KlTj18n7k/nsHzCM3hiHdUyD8WWOWs/2AaxqHn0z+A79jfAB4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(11063799006)(6133799003)(56012099006)(10067099003)(22082099003)(18002099003)(4143699003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y8VeFVsZRCJqnSDFyBh0r0L+8qyoF66IoB85XYBAeGtRF7GW70q4DYxpCehX?=
 =?us-ascii?Q?Xp/sQZ8RYwt09544lEuIIe6vRm8+NU86INSCrhnLg25ZbvznbHWkTs4HTeqC?=
 =?us-ascii?Q?qbEA0SBkAZn8RENd+l5TbLKCvq1iNhnJ4FPWsdyrHeSyDQPyrRfxkIgNX9eC?=
 =?us-ascii?Q?ju/pETKDw2y1Zh3KYN1zTPOm+YNSK2Akv8mv3RB9cnPhjVrTZJBnDLmt3TXF?=
 =?us-ascii?Q?mhinpddNh3DhFOxxfXrtNOjyi7EflK0+IDV2i7LUUv1I19gBav2NeCTa90Ma?=
 =?us-ascii?Q?Zyr6obqLYEgRixkmBVpScb36SdAgTyWjrdP5j8wN8voCO6FYU6izNko7+mOq?=
 =?us-ascii?Q?4SEjpTbIMyDu+glj1I3nlCuj5w9VnqwXU4u6fk6yYIpfTzdJIUy6+32kwj5X?=
 =?us-ascii?Q?VkW/1NjpyRP71DYM+c6im5Q4wrskOZFillfBiMB3RbmJ0L9Q9mFRobBz8pU9?=
 =?us-ascii?Q?78oPvtwB8RSgkF8vFZbJVvRZ0rbXkA/HN6AuniKc+z/JXgNmRgN97CveQgND?=
 =?us-ascii?Q?mcKXBNugD7HNGcLfI4nkGkFdfMC4C2Og6MmhriyTBo5pd1G0OhVT0QWFFacs?=
 =?us-ascii?Q?SG/rk28gd5GPKpQcFYV+x1I9WV1DVKh1txWmvq4fvgSX/ZM1+1pG1SuNyefL?=
 =?us-ascii?Q?/HF0rrrxAqpaUOQ9RX8mOBnFMosdBuy2P1Z42361mfFbS6jbYAjPKV+SybhZ?=
 =?us-ascii?Q?1vBYA367FGJFna+BquEePnnsmZJxfgd2VGI4TTSfNy/rAQw+s/QL9P4w9n+d?=
 =?us-ascii?Q?ls3O1u73fyc0YTqXNY2L1S/n3qzPkaO/etsaygO0qHlsEyZVHcaBmte+edTq?=
 =?us-ascii?Q?nrSoDtUKJwG18bdHrw+C7lAk1XllxcYUz7mdENt1mnI5ZcBUvM8z2pM+vEwv?=
 =?us-ascii?Q?gt9yv2n3omaaF+Zoo7ykEimsyJ4fLO/fifSz2s3jqoCJ28KLrS+N6+suVG2g?=
 =?us-ascii?Q?vyj04TKipJ8OClOcBzWnFTehgzlzRxfaxRWAoF4+eDcrvQ3OL9TVVQz4d60w?=
 =?us-ascii?Q?o2sQscC1srw9C6K2rjRVUUoElG/vo6c1tD1jgv9c9Eu+fTpSJPcSFNTxluuN?=
 =?us-ascii?Q?P5aL1cxfvbjRy4/2jXJU0cH/1AsqxDUsiHTpCl8CP+rVlpZeCH/ss0eU/sIx?=
 =?us-ascii?Q?jlCpYg3k7jwXkIUaQIfeiWwLMXd6d12pjj2NmIkMpkjdF3YjlS30SgUDTMzw?=
 =?us-ascii?Q?WEKRl4k0tEXaLXl3UMTIKLjldAjp6j5Y427NfstrCkcs9HdOGepFxfaje2vV?=
 =?us-ascii?Q?ctTvmippDJAiDJcrJtTyt8Ge3EZo+VhuZ5BQQAAuyfcXmU6wn6nUOK0vPCIY?=
 =?us-ascii?Q?jTQIWW5Rj0aqH1c8SgoNkYX0i3fbOqHcFJC7VmVKlDlhg9398MSZNjlm8RtR?=
 =?us-ascii?Q?eimAMRESOrVa80Va4w+a2344epFimM0WR7LOuZFSXtNuHKSn74C8SJjlGqaK?=
 =?us-ascii?Q?KafoPhPQYYeg8HI4NJjmCx7zHt5h/ZNkheLG83aTr4Lv34ACb9kqJhHZj+be?=
 =?us-ascii?Q?xnAgizPGuA+YJMDkZ9qmvTGAHC0CVJRQft3NVD25MVCKKEz+LleXNmz4Qtfj?=
 =?us-ascii?Q?q5YpSF/9NWhvZnqQREbdfuJkhPlsx+Ip4T1h2gBWP1jWflsD2pDMbamVCSRi?=
 =?us-ascii?Q?LWvCquJB4637YXfkHSfdzdu7cWsiPAJ/0jjGR+3uvy6e/cA3YzEgFlge9ZLd?=
 =?us-ascii?Q?t56yUM5Ma32eMrCw+9MDY+s4IdDdm4P8PLhUvNZUAGufgpsG6eAxxOmsNso1?=
 =?us-ascii?Q?j8rOrWnChPSBxR3guU4EP2Qm2pjFwJo=3D?=
X-Exchange-RoutingPolicyChecked: dKjpp9lekDr+1B8knOir8UKHrHNjCy0D2PFErfDTt8Bs+zktQqypU7PiLxYEpvS1J1hL6j/tBqirFwYSg/VG4421kTbtvC3ut/5Kml92xEO81JeTyBshsHLSmf4bBq7GNted5QcXU780w7Q/HSMmqIRNbvfuaCNIdk52xynuJEOspqzllMHJddUCnD9O8dOzgC544h/E8UkqVOMMlBlzg4+KATV3NXANuvTl3QHIXpEXllyiKg+XUnPXbn1P22SmidQRFaGRtn+IO9bRGRCzqeh4BwOePZ/iBuarc3OgQ04wFb9Mhg2zw6/wijRq/WoZUbmlO3VvO1llfp24EfWX1A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c382b28-9a3d-4d51-f9bf-08df28bfcd1b
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 00:20:35.7112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PJzeLQlL47yd7PbomjtJxVBHmuoCRoW3WjcwRLbRdVwK8qT4owjWlzQ6vhSYgd32i+QIQ3JYiTE2mUrcSqDCpa7h2pnlhVIV6MUlGLoQ//8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4825
X-OriginatorOrg: intel.com

On Thu, Sep 24, 2026 at 10:50:35AM +0800, Muchun Song wrote:
> dev_dax->align describes the page size used by a Device DAX mapping.
> Both the start and size of every range must therefore be aligned to it;
> otherwise the starting PFN cannot represent a naturally aligned page of
> that size.
> 
> Only range sizes are currently validated. A dynamic device can therefore
> select a large-page alignment and allocate a range whose start is not
> naturally aligned to that page size. The device binds successfully, but a
> subsequent write to a userspace mapping may trigger a kernel panic.
> 
> The automatic resize path can also split a size-aligned request across
> arbitrary free gaps. When devices with different alignments fragment a
> region, this can extend a range by less than its alignment. A later
> allocation then fails, leaving the failed resize partially applied.
> 
> Validate both the start and size of allocated and adjusted ranges. Make
> the resize path account only for usable aligned space before changing any
> ranges, and skip gaps that cannot satisfy the device alignment. Initialize
> the device alignment before allocating its initial range so that all
> allocations use the same validation. Perform size validation under the
> same locks as alignment updates so the alignment cannot change before
> resizing begins.
> 
> A mapping with an unaligned start is now rejected with -EINVAL, while a
> naturally aligned mapping still binds successfully.

Hi Muchun,

The commit message could be condensed. I think the two failure scenarios and
the changes needed to address them are sufficient.Implementation details
are excessive.

But before that, need to address something else, see below-

> 
> Fixes: 6d82120f4156 ("device-dax: add an 'align' attribute")
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
> v3:
> - Serialize size alignment validation with alignment updates to avoid a
>   partial shrink after a concurrent alignment change (reported by Sashiko)
> - Document the size validation serialization in the commit message
> 
> v2:
> - Keep the alloc_is_aligned() name to avoid unrelated helper renaming
>   (suggested by Dave Jiang)
> - Move this patch after the mapping error reporting fix for independent
>   backports (suggested by Dave Jiang)
> ---
>  drivers/dax/bus.c | 144 +++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 109 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c

snip


> @@ -1468,6 +1542,7 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
>  		return ERR_PTR(-ENOMEM);
>  
>  	dev_dax->region = dax_region;
> +	dev_dax->align = dax_region->align;


Moving this assignment means that initial allocations for static
pmem regions now go through the new range_is_aligned() check.

I'm concerned this may reject existing namespaces with 4K alignment.
nd_pfn_validate() doesn't require the data offset to be aligned to
memremap_compat_align(), and older namespace formats may have offsets
that don't meet that requirement.

Can you check whether an existing namespace with such an offset
would still probe successfully after this change?

I'm also wondering whether the initial range needs to satisfy
memremap_compat_align(), or whether checking dev_dax->align is
sufficient here.

Have you also tested the static pmem Device DAX path, particularly
with namespaces created by older kernels? The reproducer described
in the cover letter addresses the alignment failure, but I'd like
to make sure we aren't introducing a regression for existing
namespaces.

-- Alison



>  	if (is_static(dax_region)) {
>  		if (dev_WARN_ONCE(parent, data->id < 0,
>  				"dynamic id specified to static region\n")) {
> @@ -1526,7 +1601,6 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
>  
>  	dev_dax->dax_dev = dax_dev;
>  	dev_dax->target_node = dax_region->target_node;
> -	dev_dax->align = dax_region->align;
>  	ida_init(&dev_dax->ida);
>  
>  	dev_dax->memmap_on_memory = data->memmap_on_memory;
> -- 
> 2.54.0
> 
