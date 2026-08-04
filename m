Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619183AEF54
	for <nvdimm@lists.linux.dev>; Tue,  4 Aug 2026 01:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785805381; cv=fail; b=I569pPlsHcetGTSfo2ihtcoJF7Tuj2wMbJae2Hnoa+qJ+1ow6ceiv0nVPAztTo5Jk8mv+CGFaGwmwavYNzDMPenzVE7XCx2X3Cfss0qufiCKBpJEsmYjlBjWZZIX/hCk4e2aLrVKNojyZPe/4MViRqVduewhM7Jss7ySe8nz/rY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785805381; c=relaxed/simple;
	bh=dxVsj5qWXuLN2LbWXLSGXGNoNInMP/loo2nO9d6DLsk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZE7gtSa2tXPVV4DVC08/9iUEuQ4IS3TZKIpFV+j2Am978eH86XJMtuYryxBa0yGEbckqBF0OrLxNQXhsfByB185+5ceyJuK7qv6qlcrBmv2T7Fh+vn+FDJsTOCSWjPEZQhK7R+L1wVk2sNUhOPu3ABZ8sE770Tzc4IykwAqubLE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RArdfBkT; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RArdfBkT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785805378; x=1817341378;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=dxVsj5qWXuLN2LbWXLSGXGNoNInMP/loo2nO9d6DLsk=;
  b=RArdfBkT2E4PR6iCjMO7SiK2fowyc/QG36rM2NMPihfAYZNMsp5gXtgp
   ANjrqs5KPD+dQnxC3PcSuVfW4ij5OLroPnCntqzNllEhxh5aY8moGiRtX
   /+SSRvFmHxSRWe0auKk//CCe15M4ljFmV3fQBhGbU6SXkHOcNs6l55hnE
   Lh8cBlR1SVaGpwuMMwOlbWWjQjxGBkQV2w4TDhWML83T+i3fJY21bZoVg
   PsdDR7opua0tqhCoJ4qxeJIFZeiNzrUjjhrpUkKU7C2ve2dE4st9FZXXD
   Z5RCgsPJVIg/lTYzhWgzybQV4nCpiCoAuYZblHTpPixdvhrpW7wClhC9a
   Q==;
X-CSE-ConnectionGUID: Oehwq8ygSwW2m71VT7dGoQ==
X-CSE-MsgGUID: ZUHgkiSASxWVdFELHCfc/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11864"; a="86203169"
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="86203169"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 18:02:57 -0700
X-CSE-ConnectionGUID: duPer/57S6Kck7lqPXrpbw==
X-CSE-MsgGUID: QKw9KIG0RNqgc4s+oTvK5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="263347161"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 18:02:57 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 18:02:56 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Mon, 3 Aug 2026 18:02:56 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.53) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 18:02:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qeYh/EjKz2fZwVP/tGf8wYnld19LEdJleCJSEz548Bba5lYSfCUK6du3My9U2nN3H17akz8rPgfeVMsnvBYxsgm2a8PZ0SvhetBgpDC09BZavUPV0HRhmXhJNLNGLf/w0jyuPQVKb0lKnzDJWbcBgc8kUS5YgU595KZYHy1o2ZbayA2nV/hqHhaQHe2BecZIK4zMb6WTHz8XWFrVBpXbu/Jwf8WwqDJDbTHwKxNs1mu3pRtLyu610yNBQMSuF9JMRMhrVXSVgcTtCJaj6zW7EbDpV+b6uqZgc1/qKv/LnhVx2QJefBJ/ILV/NRXlAodAQxXWX6soPwm5xMMZGCHXKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZNaetu0Rb5D/2yi9NeUkyS6q57rpX2gfzs2LfnvJUGQ=;
 b=j0nIurd4YknYVrPmvdnhdJZMOdi/+Mux0BAX8gwFcYqcws1NiwXiHQA2seK/b7IVD+QTjSIdExGTrXUr+rLNzxfWvvfoIFNwcwTTI4TS/+izKnGt7JFWcaVvCQAyCU0EdO+tFJ+6vPTrITJaoyw27g5K2O4rCIGVrsY/3YhwWyLPS/JHUvkJc4G6Jnxe2k6UpRlID5p1b4o12OXuBEvzBAWfOi6oiBWm1uEjBJaTlOoIRoobPyXvkhe8TesC+U8LAdZ12WPcZE39nnyoL+Ctr48IUWzMzKbf3iMr5xzv4uVVfVcLEPmLJvRfb9JZpAUwz26ir92kvCXtjmJrjBVBLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Tue, 4 Aug
 2026 01:02:53 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53%6]) with mapi id 15.21.0270.017; Tue, 4 Aug 2026
 01:02:50 +0000
Date: Mon, 3 Aug 2026 18:02:40 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Anisa Su <anisa.su887@gmail.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>, "Jonathan
 Cameron" <jic23@kernel.org>, Fan Ni <nifan.cxl@gmail.com>, Li Ming
	<ming.li@zohomail.com>, Vishal Verma <vishal.l.verma@intel.com>, "Davidlohr
 Bueso" <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>, Benjamin Cheatham
	<benjamin.cheatham@amd.com>, Wonjae Lee <wj28.lee@samsung.com>, Junhee Park
	<jh9934.park@samsung.com>, Heesoo Kim <habil.kim@samsung.com>, Anisa Su
	<anisa.su@samsung.com>
Subject: Re: [PATCH v12 7/8] cxl/core: Return endpoint decoder information
 from region search
Message-ID: <anE6MEdR8guvLEzM@aschofie-mobl2.lan>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
 <20260731084901.1512819-8-anisa.su@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260731084901.1512819-8-anisa.su@samsung.com>
X-ClientProxiedBy: SJ0PR05CA0110.namprd05.prod.outlook.com
 (2603:10b6:a03:334::25) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SJ2PR11MB7546:EE_
X-MS-Office365-Filtering-Correlation-Id: 69b6c8a6-43ed-4021-4faf-08def1c41b15
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|23010399003|376014|1800799024|366016|18002099003|22082099003|56012099006|4143699003|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info: QMMy1n037kFZr9ChRiInyXaJJBHzC7qNsK7rkLNKHDmM5aOngXgbXxLOJUhWOcfWWNc9+gowAlTiRcgOwZBuaOjiifRF2bCT36A/wIVgk46x975rQ6SCRa5Tm/XObUv84dcCjOAPbjdPnPW4sfpGGVc+8JMy1lHXGWVuHtltQ9FLW3YdcSdaFyhOO7ODFaCyNvVJUwftScq53Nadg0rR/TnJwpLYxHqsd92138jcC1zU4phrEVaCZ4iIXuNkJIo+Z1NfUXrGviogHV2asAuFnNaL/tq8GF/wqqt+Uv42O2L2bnbFwA1i0wHue5/0yHiortShcWTFAO5gf/W4ZqetjuP3tRrzoPmijbV0bkQZ3hgktB2s+h1FoRIFzqUooC8lkjbC+aCMxW9BLRIkjTAHRJTGjr9AcrBFarmSRnHOacMg+H1bCpA4SY7NWFHPuLupwh+BGK4339kTWNEHXXu2trNaKovNNLgFuZHw7+ZppecznGkH8W1heUqxYuExH1XuOQhFWLbZlvEmWxms/aP1qgZMhX/J6LpQK8FoPMDQGB+frBiKdsATh0iXP2nTWL9hdesABVDztBjESDo/G4m7pha2WD8glEa8t0TslCA0q5ZiolwWWaeJQmMrZHIcvdcDw+HCSqtQEnND6/bPS4dUxdoZaj6ntsN8tdk4/0UeMX4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(1800799024)(366016)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MiHUTYKpQYn2zVgQG2YiHHYW9nL3FbAqWd8ggyVKSz0RT5BusS11R1Fdp2E5?=
 =?us-ascii?Q?eb7yZIgP1eexYE812EveggK4uE0wGI8fsozrinvNmt+J8SuJS4pNvVzEqzh0?=
 =?us-ascii?Q?HowCFls4SNADKZEAiXlJGEZSpV0nDb2Wxq8S1m/HpPIDg8tgN7wJq7pcdOwJ?=
 =?us-ascii?Q?l6/zBlLe6fvmiIqSeOAdv213SeM22AxmUbVOG4b9jq8pdbnk+RGAukU3HP2j?=
 =?us-ascii?Q?9hRRruRxZRv5ZnWmHilTJUU24Pd02jKZTlFCemFCjmlrjfnRKz7vXr8gsBox?=
 =?us-ascii?Q?oV7/ri7HYeIRu6edfQltSkJm47AngzjGxlchc2JAw5d0UsIhEaNXpUy8nR/1?=
 =?us-ascii?Q?3Fh3MEwwophy/vXFqQ0lLF6UmquVFy33tZ77hHHX9GW+f0aah8Eqp879ttyN?=
 =?us-ascii?Q?xk8lJJ8n4BMJBiVs1cOxq4WXPC/APHxPGF5zEywZWzc96adU3AsekT7HKDe9?=
 =?us-ascii?Q?U4uPLlGQpqtx/keuvS0BBdoBmUTX75tZfQrOptYiYwVVywbicmOiRszBYvif?=
 =?us-ascii?Q?4lU2xsAETHfk+erHCv6PcV0nVLMz1fqu3NZnU2ur14CruE0FgFleX/0S2pQ4?=
 =?us-ascii?Q?WjTrcj8vMFhM40Vfmg/usTdNfUTf1W5lxtSTuZj3u5HEvZTEM1b2qab8tMV3?=
 =?us-ascii?Q?UDEZdhniMjZ9fMLKpAJXz+c8xSvjb5C9r5C3uBBDO/fbC+P3xqosvaQeffnC?=
 =?us-ascii?Q?mkVnybiBAqE/2MHpMob5PIs0dhUtqaoc0KvzC0GW9hUUFHZJx53czbsWfhP4?=
 =?us-ascii?Q?yWjIjIUGeajMq9qPJw+oKOJR4foaIoKhCCUQF94TNZBP3+xbfXKsVvbS01TL?=
 =?us-ascii?Q?Ho5tQohUnt+NUQW7uY266n2oQ1EDAIBu9ab61vvW9n/+9zIa835dK/mNudre?=
 =?us-ascii?Q?svuGW6z7g8npyQ16XCJtiao4P2QcSWUrXmgWXmQPl9/lVSl1MrEu/T4EkJTj?=
 =?us-ascii?Q?GYPScm9xQocjpXrQ5ONMkaFacwYM0hCWaxvDldHuZOpNiLJSWC3OllqbkLMm?=
 =?us-ascii?Q?O4CCQdpUAZalvMaZRPLx1GhcgieCaT0oaBCjlhU7sijUhqa5AOEV09830WKH?=
 =?us-ascii?Q?s2j1btaCsR8qvvkQphDY9bQREvKJZr7k6+c0kKCROHSDbOU0vsQPYTzcuPjQ?=
 =?us-ascii?Q?d5sKZ6V+hEkWRxac8Mhlc863z7atCwFOJHWE+ZSHnA9PG3mTBGiYd3J9Ms6M?=
 =?us-ascii?Q?4goTMQJEC52g9dY5VHRGFrQQ8LPPzqKjpNBYUzdYqimucKoyOY8B8FzbTdD4?=
 =?us-ascii?Q?mO1YwJWMsUfo8uPc5akN7cXMzaHe8s8AhWwKZ9JCXt1NKVZfNzb8hP1qxsyK?=
 =?us-ascii?Q?xdxYgMYuLfuqV4bC9PHcHEcwixlqRuYQwLRsluFNwFoGw/JmOvbwVCpSOxeY?=
 =?us-ascii?Q?/TqqIq7bWEVJaJJCoDC8KAn8yoShbZmatoGgdz8SooHvWNhr52Z+Mo/tqHp6?=
 =?us-ascii?Q?7lmQl4yeerV2VWWVXdZouRq5qfxQrnlsZ/VL7xJxHuc5wSQChcc+2Gr3yYR1?=
 =?us-ascii?Q?i45E7Ms2sh1LrcjpUoWvre5CXv/2EWkXitDE6bihlsR2c++OukA7kd0u33m9?=
 =?us-ascii?Q?mYljX3gYVeuuCoQALyVdmm6DFjneJZXa9G8p5Y2iMXCdrhzo/3bh+zvF3ddd?=
 =?us-ascii?Q?Il1F6qbQeohWC18MkgQKpYmqcoTUGyroTFYPv0Kb2aGVfgCl+Y8oUC+ODLJT?=
 =?us-ascii?Q?/ITh4bivsBmd4bGTRGpn2/iEbocqXbvh8T7NbouAiwA7DAeMqU+tMdOnP4D0?=
 =?us-ascii?Q?e5IUag/JrcEuAW8Ax2SmI0qLjSQJSso=3D?=
X-Exchange-RoutingPolicyChecked: b4YPnNRR4bV+keDTZKBOyaa5YZ1Fp015MKTXT0YBBG3oZmTHdDTLUzsL9MGL6tHS+Jy6kAuXLe5GKM/CigtnaBXQTGHsY0xuIZIdfxHrW13et/bt6sss6gpdSTYCOcFguSlvvsstvojWwmbuFyVa4wb5VxBNZ+jLS0yNju6Sem/U18HP8f+yFUl95kVrP/EfT8Yi6Qllpmga+MWq1/M1WA+/GEreUQhYTnqIzHf8l+zSu/P9ZvyMfhnX1+i9a03izD7JdWRL6+TOVe+6zpklh7FIbH3evO6O5T2LLLRLnI0K6F9N0hH6pYMJOlBPkFsupdVcH8uPBw/DZoEqI1n3qA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 69b6c8a6-43ed-4021-4faf-08def1c41b15
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 01:02:50.5864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D4Upk20rA/AghP4ZmWyYL/vDria7QBo3AoCAanhUrznTVd6idO4G4jb7KwVTeCDRBSwzIk/vfUftvAoRBeCQ8D4Crn67Fj14dKG1uritCEw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7546
X-OriginatorOrg: intel.com

On Fri, Jul 31, 2026 at 01:48:12AM -0700, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> cxl_dpa_to_region() finds the region from a <DPA, device> tuple.
> The search involves finding the device endpoint decoder as well.
> 
> Dynamic capacity extent processing uses the endpoint decoder HPA
> information to calculate the HPA offset.  In addition, well behaved
> extents should be contained within an endpoint decoder.
> 
> Return the endpoint decoder found to be used in subsequent DCD code.

Hi Anisa,

I realize this series is intentionally preparatory work for the next set,
and that's often a reasonable way to stage things. However, this patch
is an example of where splitting the work makes review harder because
the new interface is no longer paired with its first user. I also
realize this patch carries review tags from the earlier posting, but
those reviewers (me included ;)) were able to evaluate the API together
with its caller.

I went back and looked at the a v10 series where the caller is present,
and the callsite looks fine. But I don't think reviewers should need
to consult an earlier series to understand a new API, nor assume the
caller will remain unchanged by the time the next series is posted.

Can we either -

1. Drop this change from this  prep series and introduce it together
with its first caller in the next series, or
2. Keep it here and but clearly document the API contract, that *cxled
is only valid when the returned cxlr is not NULL.

As presented, no caller requests cxled, so the intended API contract
cannot really be verified from this patch alone.

-- Alison

/BTW - I think other patches in this prep set carry similar issues
but this one popped for me because of the subject. I headed into
it thinking a quick ACK, but no luck.

> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> Tested-by: Wonjae Lee <wj28.lee@samsung.com>
> Tested-by: Junhee Park <jh9934.park@samsung.com>
> Tested-by: Heesoo Kim <habil.kim@samsung.com>
> Reviewed-by: Jonathan Cameron <jic23@kernel.org>
> Reviewed-by: Fan Ni <nifan.cxl@gmail.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Li Ming <ming.li@zohomail.com>
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  drivers/cxl/core/core.h   | 6 ++++--
>  drivers/cxl/core/mbox.c   | 2 +-
>  drivers/cxl/core/memdev.c | 4 ++--
>  drivers/cxl/core/region.c | 8 +++++++-
>  4 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> index 07555ae63859..e4bd220faa92 100644
> --- a/drivers/cxl/core/core.h
> +++ b/drivers/cxl/core/core.h
> @@ -47,7 +47,8 @@ int cxl_decoder_detach(struct cxl_region *cxlr,
>  int cxl_region_init(void);
>  void cxl_region_exit(void);
>  int cxl_get_poison_by_endpoint(struct cxl_port *port);
> -struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa);
> +struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
> +				     struct cxl_endpoint_decoder **cxled);
>  u64 cxl_dpa_to_hpa(struct cxl_region *cxlr, const struct cxl_memdev *cxlmd,
>  		   u64 dpa);
>  int devm_cxl_add_dax_region(struct cxl_region *cxlr);
> @@ -61,7 +62,8 @@ static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
>  	return ULLONG_MAX;
>  }
>  static inline
> -struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa)
> +struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
> +				     struct cxl_endpoint_decoder **cxled)
>  {
>  	return NULL;
>  }
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index a6cdea9f4080..b18ea02ed2e6 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -969,7 +969,7 @@ void cxl_event_trace_record(struct cxl_memdev *cxlmd,
>  		guard(rwsem_read)(&cxl_rwsem.dpa);
>  
>  		dpa = le64_to_cpu(evt->media_hdr.phys_addr) & CXL_DPA_MASK;
> -		cxlr = cxl_dpa_to_region(cxlmd, dpa);
> +		cxlr = cxl_dpa_to_region(cxlmd, dpa, NULL);
>  		if (cxlr) {
>  			u64 cache_size = cxlr->params.cache_size;
>  
> diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
> index 33a3d2e7b13a..1565a5cf0f32 100644
> --- a/drivers/cxl/core/memdev.c
> +++ b/drivers/cxl/core/memdev.c
> @@ -317,7 +317,7 @@ int cxl_inject_poison_locked(struct cxl_memdev *cxlmd, u64 dpa)
>  	if (rc)
>  		return rc;
>  
> -	cxlr = cxl_dpa_to_region(cxlmd, dpa);
> +	cxlr = cxl_dpa_to_region(cxlmd, dpa, NULL);
>  	if (cxlr)
>  		dev_warn_once(cxl_mbox->host,
>  			      "poison inject dpa:%#llx region: %s\n", dpa,
> @@ -386,7 +386,7 @@ int cxl_clear_poison_locked(struct cxl_memdev *cxlmd, u64 dpa)
>  	if (rc)
>  		return rc;
>  
> -	cxlr = cxl_dpa_to_region(cxlmd, dpa);
> +	cxlr = cxl_dpa_to_region(cxlmd, dpa, NULL);
>  	if (cxlr)
>  		dev_warn_once(cxl_mbox->host,
>  			      "poison clear dpa:%#llx region: %s\n", dpa,
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index 1e211542b6b6..ec5e5b7090cf 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -3012,6 +3012,7 @@ int cxl_get_poison_by_endpoint(struct cxl_port *port)
>  struct cxl_dpa_to_region_context {
>  	struct cxl_region *cxlr;
>  	u64 dpa;
> +	struct cxl_endpoint_decoder *cxled;
>  };
>  
>  static int __cxl_dpa_to_region(struct device *dev, void *arg)
> @@ -3045,11 +3046,13 @@ static int __cxl_dpa_to_region(struct device *dev, void *arg)
>  			dev_name(dev));
>  
>  	ctx->cxlr = cxlr;
> +	ctx->cxled = cxled;
>  
>  	return 1;
>  }
>  
> -struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa)
> +struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
> +				     struct cxl_endpoint_decoder **cxled)
>  {
>  	struct cxl_dpa_to_region_context ctx;
>  	struct cxl_port *port = cxlmd->endpoint;
> @@ -3063,6 +3066,9 @@ struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa)
>  	if (cxl_num_decoders_committed(port))
>  		device_for_each_child(&port->dev, &ctx, __cxl_dpa_to_region);
>  
> +	if (cxled)
> +		*cxled = ctx.cxled;
> +
>  	return ctx.cxlr;
>  }
>  
> -- 
> 2.43.0
> 
