Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F373F23D1
	for <nvdimm@lists.linux.dev>; Tue,  4 Aug 2026 16:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785862573; cv=fail; b=Uo+PfFMZ7/ZyjaE6ccTWBFUowtdTbq2gENHueh945VGI1AN4U3rEKNlKQELG4i199tFm+zijfz/T6dlLEzIbkRf1HdHPvG48vA8lq7lH+Z5VnT+3/h6lt6Y0RNf/sOvUgr/D2dGERVFM8U6kZP8saB6BN6fPuh2mwnvJaQDnvU8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785862573; c=relaxed/simple;
	bh=5IA36ibQY4GxNqKsx+VNLUYSiPvJ255sP6LicQXbp8I=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=e5sL27lJ+0Ul0vKhkCRNWHNstMEDuQ659Y07PGoPtsnJE30I6x4SJ0+aV3Dan9EbA+Jk4HdVIFoNmCSCKPkB58Pu4AHx3wTwnh27S2rGMYZJ7MRuiQYrN9nXZCAVCLYmGLci7YpnxdpS/ykXQL56M02lqdRqASm3cIJjAj52l0k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mu9MVONZ; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mu9MVONZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785862554; x=1817398554;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5IA36ibQY4GxNqKsx+VNLUYSiPvJ255sP6LicQXbp8I=;
  b=mu9MVONZ2Us0bE4gk5upYFgoyr1VUzV/lWVMTiiv7mhrxLVgNeM2m93q
   C79bm9hgo9/bdnNGBd0xLQ1u7LTPuefQseA9KTtA6ipBkWNb5GhvraTEa
   hcP36qCR1JyxbTNQSSe6/9JugMhIBxhyHp7OZkPlcoCtNyYwxq2NaEQM1
   hpRaLLfCDZk3IyrILhScDRCYNCm/CO5cSP1q9TiQE8O5QsvwgNr1ARGPQ
   0LVu/Ne91Vxr90w3LhuY0AuD7YtYt6Gog3MgWAjSgfYA6mp36lSuDUflJ
   l+RnbNQ+JBAJ+fb974xozXWVug5FRhk2ua7nKD+MKkbiAtzHzevSB0fs2
   w==;
X-CSE-ConnectionGUID: KzLj6VKNTuCAY2jWu+LmkA==
X-CSE-MsgGUID: Zys0T/cvRbCaWtGRgUk/Iw==
X-IronPort-AV: E=McAfee;i="6800,10657,11865"; a="97926093"
X-IronPort-AV: E=Sophos;i="6.25,204,1779174000"; 
   d="scan'208";a="97926093"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2026 09:55:49 -0700
X-CSE-ConnectionGUID: l2UfVgAtTy2eGcjKlKB0Qg==
X-CSE-MsgGUID: wfHgn2wsQJmQJDYWM+uvHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,204,1779174000"; 
   d="scan'208";a="265065259"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2026 09:55:49 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 4 Aug 2026 09:55:48 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Tue, 4 Aug 2026 09:55:48 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.24) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 4 Aug 2026 09:55:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v0B/toEm1+dtLZdE2XSkgFYygV9VGUQi+rGA0rUWj4x1MzFWiPusF74+FPxnm+da/qUo2tv9ICJiQrfUf+Ctgygn1Lig6CgA9krdfHYKr2PyFpoZsAxHr/AMDYjN0rBq+akPqjXMwVXQcnkfJWULMeMDlfhGNyqMT8gma0Q/N9of/Sp8Imv0Mx3YagzFE4g9o2bp62uSxB+sOqNG32wuf8Jtu1u3lt2aKZcdpg5BxqWmoO8mmolSPMTR137dtx/9pEQsUZOzk/gAVtfpkWTEZDuhO8ujKnC9aLBZ4AqLMOzBwn9SAFOomFZfxELSjGBeJJP/h7JOn4pmpZiuw21dwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q9vHrDlin6rDZJA6KlALbG2Vl7T25bvWS5H2m/9C/vY=;
 b=EO5c+FtHX7hxwxN/6P/CjEld/JbIlrUdeydZpVamC5u3cUHUy/zmdCYtfKn3tl0V2gMZYzLJl2p4WU0NfeihJG7cGLu39vXKpoJuuXDJzu36v9RWw3r/tvxs1wwtWaB4JenSxrTolnh+5nA7OiIzWmcNYAyyRTgMlsSLdQ+Z63tyIpFYbQmL511jg1JlQ2X3NJzk3DnwiK38jTKAAuwYhHm4bTyii1ndH4R0+ctyaRPqK6+mglFdZl5AvMOOwrGY6nMq9EHoEmEsOXrJMMMPKu5dYqLbz8k/YjYqdrIeZRfhmLNuyuqNVjVtu7OPgQFxw37Wpe+n1Ipi0ahElRCUBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DM3PPF74831EF4B.namprd11.prod.outlook.com (2603:10b6:f:fc00::f2e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.15; Tue, 4 Aug
 2026 16:55:45 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53%6]) with mapi id 15.21.0292.013; Tue, 4 Aug 2026
 16:55:43 +0000
Date: Tue, 4 Aug 2026 09:55:36 -0700
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
Subject: Re: [PATCH v12 1/8] cxl/mbox: Flag support for Dynamic Capacity
 Devices (DCD)
Message-ID: <anIZiJ8E0EXs2kS0@aschofie-mobl2.lan>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
 <20260731084901.1512819-2-anisa.su@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260731084901.1512819-2-anisa.su@samsung.com>
X-ClientProxiedBy: SJ0PR05CA0028.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::33) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DM3PPF74831EF4B:EE_
X-MS-Office365-Filtering-Correlation-Id: 68dc5466-3448-4138-f047-08def24938de
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|23010399003|11063799006|10067099003|4143699003|56012099006|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: cM2BZoxYCnQvHWPUTTLbqs4hETdNvdB5vM8CWwTymjpZJQtr/Um3XXy8e95fKlx4nb02zJhZJY3eWSLqFCMwNF1QUL6pOCoYVTA3u0zUORX+JBe6AfXk1ZrfMD4M5XfZ1zyH2yvQxunqx3AjCfMHpY3zGB9vkD/0KYX4QIjaYCoDY7zDFnPrZ/A49oeV7kgixRFqu462oWeyjprDQmB4VmYwfi7krUifPEAS1iz00FmkNQooTRXmlazlaEJiAp/JTPFjWeSFLHDAdPN1O65IG24yiZyym8GbQj3mXTIXVruCHrNNK2Hw1TI1UviTBRSkbPEjdHvX7wTg+vjCSlyoOmB8y1Ttg8x5SlG56GdayHAZuObsm80ICFkDKkJYwLIz1JBr6w0S8tGlWxcT00ykiMuN/bCFIi0zMg6kMGe2QnGtYK0q+Y/iUGSugPtj1TiPY1z2OTADiIOI/1I14M4AgRZOuokKZZiPkaumFWehx1Ilo6BYYxvHno/uKBvhc2G4Vnuwg4PQBlZZ2mLDGMjF1DKb+Jrp2cHGI9xAAFpvXucK2GIhkTK4IDUWH27+uGCSpzlOXcKIFoBRkX592d/JAg25sZZ/KZPAuGSawrfnbJGOsMd2xTyF2+GWb2KL7acXiwBRTgrWbB7iAdaKDDKDC3GfbSI9HAcKfYgnVldE2uU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(23010399003)(11063799006)(10067099003)(4143699003)(56012099006)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rhqeIWa/FKhub8HoNgH4uh+OxsOwKPLxhzGb6F8Z0zR88pe6zO44+sg5F3Lk?=
 =?us-ascii?Q?lLWj3vgKHyhmnGWOdeCqePzvkFKw9YIHKmai8YpxuG9T5xzrAeIb7j/YODlQ?=
 =?us-ascii?Q?A8EARro2H+/sQwGKQgewYPbQwItI4mcFqIRSEpaoPU3pNnzZYVi1BCD62m1v?=
 =?us-ascii?Q?hK2bWijjJTP9jrRkQ+Fz7zPo1zaZP6dINVVAiJKaq0OcrCsLb3hJ2bTrQkT9?=
 =?us-ascii?Q?XuU0lfCiHGSPObs62mg6smKqbMz/TCvDuXcf8Hol7tMENuSIWrMeOSuAoYst?=
 =?us-ascii?Q?DssZsxXDPMTXRnRP1gjx8JNgpqoiWedh0+I9rzRBgNGxTxPvK/2dI8af0QAP?=
 =?us-ascii?Q?A3m8wnEvP4JsykQiLkE9MZJizaV1Lo3YRMiVyjXULlCi0DWt4SPaKU4e/Djc?=
 =?us-ascii?Q?KeCJS0+4VduGwZHV5+A5jYpm48Y4NPeS70gmkbBDFOmHWDgIybYGi1E/dQ7g?=
 =?us-ascii?Q?9W+uGgdY15JvUhLcnC4Y1oBgkEWYXjQGEjA8HXDw0QVNmeWiTB4rSffwNYUC?=
 =?us-ascii?Q?+zjOYHaNpC9lcTbdGt6ZrhEo1JNuxcYerEinW3/BJJ23bQAI6ykpw8iR+XvF?=
 =?us-ascii?Q?CcvGxQSXQoctO0Qs4nXYfqQ17WrJTn+/Ftkcte5PadcV4aKWQwQYWscpJb8t?=
 =?us-ascii?Q?a87NLjrzYq6rjjEYWeUC3RWEduN8qW8k7xf7C3+SCheDQgP2PhVl6+phi/Jp?=
 =?us-ascii?Q?6FriBz1eDQQ4yBnPPw4xrbmYN+heOtNfLAWXglp9CGwgO+a1qrk0E5PVaccM?=
 =?us-ascii?Q?E3gPOadQCrbyI91cz6oGPmYT3TAjd9WVfSXJ8T/GlOw9q98Ol2zK2+BIXVbH?=
 =?us-ascii?Q?YhP9HggMW86LDgLE3SYaeaC0AUmmOO3mldSWd9nIK9U15MLEkMEr8tgBlR90?=
 =?us-ascii?Q?O3j63iPZ5A6lg4xSjBmh3EVNROsaC53BxpxD9Abx9CqhKNVW7xznOriDqVSO?=
 =?us-ascii?Q?DdJKUDlSpFgjEDRXOsrEvGMVlGjT6dQriOnmMBEt4OCr3JvEn4DZmrwWyVQc?=
 =?us-ascii?Q?uXca78m0wtrvV0WIwpCuVDluqgjzPRzVjZ4IPJEVRp/yN6rNrHH+3AC85x6s?=
 =?us-ascii?Q?dV9pb+b/1YLEbOF/XINQtrFM/7xErryGmPS/AQZ3h/bZZ5r18nq958hS/B7v?=
 =?us-ascii?Q?d2ZNxlIEQPLG4yD+ut4HcljCdL4mUNyhWrdLckMme55NRdP8Zv/AKE7Z8ide?=
 =?us-ascii?Q?8pji0SmwHxbf11ABY2WmM2NADp5MEvo5c/rQm08wDfnLd9JPpFwhsHnRXE2k?=
 =?us-ascii?Q?4ogwsge+XZ22GWBz7tQQj82s0PRRhBsQnTVx/84QYZrGRSjxjJ+Hr75x/ZO7?=
 =?us-ascii?Q?2dhn34TwKuqxw/pVb+Wc8ythSvDmuIUxkZD4rqkQ6eiS8GXzYSP6DbFDgRCB?=
 =?us-ascii?Q?IBCXdEDTQQ0vZiw3XQ7VXUhoSL/u5pV4CeYNjoHHUCv41HMCBhVAdFm2d1l0?=
 =?us-ascii?Q?lqbgoPaNBqS7icJ/LTsYGC6NiEFTW2vf+hDKAhddDWUx96GyPGLEQw+RNB6X?=
 =?us-ascii?Q?QwOoSD0maVE7o1gujO6HtkXld8ZByYdEsNpmy6DVkPCKBzPcQtljA2i0Kaih?=
 =?us-ascii?Q?x0cgbLynxZSkLo9clNmfGw4LIeXHFHmmvOhs2dezMlWf1OHk+94fWPrunhp9?=
 =?us-ascii?Q?zO/ohdXxUPT2fXksKjQWABRww2iXVD7eMCn/sM92hpepi0zrMJhbaZujRXTa?=
 =?us-ascii?Q?RVljO8UNpQ5CkmlgzNZkcCjRUNxqZM0j16ekXJ9/mW8YwK5xUjBqiWiOdyex?=
 =?us-ascii?Q?US9BIi0a8uS7D98zmLLEq34K8RYy4mw=3D?=
X-Exchange-RoutingPolicyChecked: T11CDeDYJSbhMDv2bsq3Sl4XDjOaCI+f0Dih9tcuEnfwSowkwjfcDi91P13vr1Z2cgV6tdIsnl66OYFRoKcSJBRJhoyjMVrQJkwwXpt71wahlNr/lR48QlEclrJQ/lCf+fAFdQWTPlySLoJiG2Rv3Du2ApD+lvVURB94OWE7c3NVl7HIOfN0EYYhsglPqVaceTd0dfA6KpbJfeG5CwgY53HYZUAcPuvEXSDzez/ackZOzYCclhYaMfUMajPtdQ4mMiVBQhSr58/Ye/sXn+9T2nwnu8nWtVuGTwUfLUk/WkyeBU/YcblfvO1RUmbHW/hHrTYxsIwbYEMHstnEZw4pKg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 68dc5466-3448-4138-f047-08def24938de
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 16:55:43.5722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XpJbn81mw0PQEeWgzSymEb7yxf/UnKBskZKQh8SgIjCZROsoyti0KYNRQmxoSwvA5mF67i53orjch6K+yRuZ8VF7dJPjB8C6XyLUFalyNWI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF74831EF4B
X-OriginatorOrg: intel.com

On Fri, Jul 31, 2026 at 01:48:06AM -0700, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> Per the CXL 4.0 specification software must check the Command Effects
> Log (CEL) for dynamic capacity command support.
> 
> Detect support for the DCD commands while reading the CEL, including:
> 
>         Get DC Config
>         Get DC Extent List
>         Add DC Response
>         Release DC
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> Tested-by: Wonjae Lee <wj28.lee@samsung.com>
> Tested-by: Junhee Park <jh9934.park@samsung.com>
> Tested-by: Heesoo Kim <habil.kim@samsung.com>
> 
> ---
> Changes:
> 1. mbox.c: leave mds->dcd_supported false so the hardware enablement
>    patches can be upstreamed ahead of the extent and DAX work; the
>    event handling patch re-enables it.
> ---
>  drivers/cxl/core/mbox.c | 44 +++++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/cxlmem.h    | 20 +++++++++++++++++++
>  2 files changed, 64 insertions(+)
> 
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 7c6c5b7450a5..4790524c32a7 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -165,6 +165,38 @@ static void cxl_set_security_cmd_enabled(struct cxl_security_state *security,
>  	}
>  }
>  
> +static bool cxl_is_dcd_command(u16 opcode)
> +{
> +#define CXL_MBOX_OP_DCD_CMDS 0x48
> +
> +	return (opcode >> 8) == CXL_MBOX_OP_DCD_CMDS;
> +}
> +
> +static void cxl_set_dcd_cmd_enabled(u16 opcode, unsigned long *cmd_mask)
> +{
> +	switch (opcode) {
> +	case CXL_MBOX_OP_GET_DC_CONFIG:
> +		set_bit(CXL_DCD_ENABLED_GET_CONFIG, cmd_mask);
> +		break;
> +	case CXL_MBOX_OP_GET_DC_EXTENT_LIST:
> +		set_bit(CXL_DCD_ENABLED_GET_EXTENT_LIST, cmd_mask);
> +		break;
> +	case CXL_MBOX_OP_ADD_DC_RESPONSE:
> +		set_bit(CXL_DCD_ENABLED_ADD_RESPONSE, cmd_mask);
> +		break;
> +	case CXL_MBOX_OP_RELEASE_DC:
> +		set_bit(CXL_DCD_ENABLED_RELEASE, cmd_mask);
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
> +static bool cxl_verify_dcd_cmds(unsigned long *cmds_seen)
> +{
> +	return bitmap_full(cmds_seen, CXL_DCD_ENABLED_MAX);
> +}
> +
>  static bool cxl_is_poison_command(u16 opcode)
>  {
>  #define CXL_MBOX_OP_POISON_CMDS 0x43
> @@ -757,6 +789,7 @@ static void cxl_walk_cel(struct cxl_memdev_state *mds, size_t size, u8 *cel)
>  	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
>  	struct cxl_cel_entry *cel_entry;
>  	const int cel_entries = size / sizeof(*cel_entry);
> +	DECLARE_BITMAP(dcd_cmds, CXL_DCD_ENABLED_MAX) = {};
>  	struct device *dev = mds->cxlds.dev;
>  	int i, ro_cmds = 0, wr_cmds = 0;
>  
> @@ -785,11 +818,22 @@ static void cxl_walk_cel(struct cxl_memdev_state *mds, size_t size, u8 *cel)
>  			enabled++;
>  		}
>  
> +		if (cxl_is_dcd_command(opcode)) {
> +			cxl_set_dcd_cmd_enabled(opcode, dcd_cmds);
> +			enabled++;
> +		}
> +
>  		dev_dbg(dev, "Opcode 0x%04x %s\n", opcode,
>  			enabled ? "enabled" : "unsupported by driver");
>  	}
>  
>  	set_features_cap(cxl_mbox, ro_cmds, wr_cmds);
> +	/*
> +	 * Disabled until event handling implemented.
> +	 */
> +	if (cxl_verify_dcd_cmds(dcd_cmds))
> +		dev_dbg(dev, "Device supports DCD; capability disabled\n");
> +	mds->dcd_supported = false;
>  }

Hi Anisa,

I read and agree with the other reviewers that this does not need to
mirror the poison and security command handling.

The one-use cxl_verify_dcd_cmds() helper still seems excessive. The
bitmap can be checked directly here:

    if (bitmap_full(dcd_cmds, CXL_DCD_ENABLED_MAX))
            dev_dbg(dev, "Device supports DCD; capability disabled\n");

And then once DCD is ready to be enabled, the assignment can become:

    mds->dcd_supported =
            bitmap_full(dcd_cmds, CXL_DCD_ENABLED_MAX);

-- Alison
