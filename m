Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417363491D6
	for <nvdimm@lists.linux.dev>; Wed,  4 Feb 2026 17:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770227659; cv=fail; b=F5IbBzlVMUZnHs65PCeryzYdXo16POakAI5Oh2kNn8ubJu6lYKNIoPKR1Ate0qLRnaRZGBw/fC62p3VNkerebgsvOi8zuEFMl/F5/64S19wBvMH0UGczRu+1WEnwSmIimrP84rZjvs8S4IDv/zKLBG1QeelftecTC6CcFefMZm8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770227659; c=relaxed/simple;
	bh=Jk5w76cV6ZokL2zoHrmqch8sfyMjJ441Z0Ck9m9iS/c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZagAfbDa5iIQaSx/+W9Lw0HRvAASBskxxXVaTCCzG7jxymVYSk4JYseSU7wrGrFYf+rbQ+nKJloX5b3kmgC7ZGHEB3CDCkussZLFfYNBbSo/kplyhdb7mn+IZpEcG/oiX3miDYRbtWX/Fn/cMuyFzinqQcudsLmt/z58IWlmIHk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FBCUuPmQ; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FBCUuPmQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770227659; x=1801763659;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Jk5w76cV6ZokL2zoHrmqch8sfyMjJ441Z0Ck9m9iS/c=;
  b=FBCUuPmQYVUo3x39Z3PLG8IKt5rpWyZIhQT7iBe7Mn80qPinr3adVNNw
   eyg/Kuo0hfIBAIro8Aey0tS49WybxvJGkDzrLcx+0dIvtpw4YE1doSZSa
   3VpkmmFpN8Jtua8LnyJ85hxZR6r1vxD+gXRBtciU5K4B3uMl+Co/SSTMJ
   akSjup5fT0niDqHhEbXnQodx1TSz/zp2hDXLDuLHgKfDrm8inz0eaLOk6
   QGO233Er61/sXZLW2/918L9OQptrb9wr8wNTEk6+UCbQYPhMIP/a1sd0I
   v2V4KEiHKWrCSppijc5L/huuv9qZ5LantkIZF+/PMqFS+gycHgmFNMh9z
   g==;
X-CSE-ConnectionGUID: R3dUIZp/QJymPA3HfYiyTg==
X-CSE-MsgGUID: /De35Z7yShiArQ2wFvcwOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="88839583"
X-IronPort-AV: E=Sophos;i="6.21,273,1763452800"; 
   d="scan'208";a="88839583"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2026 09:54:18 -0800
X-CSE-ConnectionGUID: 21Ze5MPfT5GpVhTdbvotEg==
X-CSE-MsgGUID: fuClR21BTgSy5VuWLz1tbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,273,1763452800"; 
   d="scan'208";a="210242908"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2026 09:54:18 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 4 Feb 2026 09:54:17 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 4 Feb 2026 09:54:17 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.33)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 4 Feb 2026 09:54:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l35BA0MpRHdusvYDqPt3OK3sj1YiwZ/0kinzqCSF7Mjxd30vpDNiCyaj/anXFVy72z653Yq5YpFGXVcGPWTCxSDPgJFjX3+hKf1RIcUWTUPevu1pu8sR82poQxuFjy5yX8B1lzny11YwqqL2XpT2Qx+3ldlAqHvfw+iRdJLAhmj+Wej7tocI1xldsUJT2+RYx3e0JT7jNVMrp9mmevkpo3wq2+W6w/AB2GuzvbpbtdGajMcTnbe7vVmA/RXPqWelg5u2Khce/VDunmoB7OPT8CuxvymX5knXlEFDVTist0bqlj5vtzxpl8GGxjkwY7oRLKTlu1r6BgalzdYiWn+ZGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wrh0/BPbRjblYRgLkr9Ffx0BeMyJkOyk5V848Ddc2FY=;
 b=fML3gQMiqstVD7sF8+IFuDZh4hufYQ8MOIyEmMtFfw8Amd92MJCBxHXM2e5C5Agksimnbkt2S2UvvGiPvgymdmZxKHlEjBNb10SeZj3C5dbL9oUDLM7GnPE154QIignyd3Fe7ecUMpxEG63W0gYVv3RerrFQm8mrV0vMPP/SaDO3vIBcjhx5Wgs6EN3oWzoDh8UHY49XTbe9JlQbHLBjddC/NZc8qenHQD/fqMJCJoQRWNxl/CfdV7Wflt5HBeI5dOQSqgujayNv+fFkaKt4vcP5+MnZdmNQhrMH7Kz+mJ5QN+R4CcG4DbDm83FUamRwhCsZL/sJGAA7Crukk1e58g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by MW6PR11MB8439.namprd11.prod.outlook.com
 (2603:10b6:303:23e::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Wed, 4 Feb
 2026 17:54:14 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::1340:c8fe:cf51:9aa2]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::1340:c8fe:cf51:9aa2%2]) with mapi id 15.20.9587.010; Wed, 4 Feb 2026
 17:54:14 +0000
Date: Wed, 4 Feb 2026 11:57:34 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Gregory Price <gourry@gourry.net>, Ira Weiny <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>, Dan Williams
	<dan.j.williams@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, "Alison
 Schofield" <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Li Ming
	<ming.li@zohomail.com>
Subject: Re: [PATCH v9 00/19] DCD: Add support for Dynamic Capacity Devices
 (DCD)
Message-ID: <6983888e76bcc_58e211005e@iweiny-mobl.notmuch>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
 <aYEHmjmv-Z_WyrqV@gourry-fedora-PF4VCD3F>
 <698270e76775_44a22100c4@iweiny-mobl.notmuch>
 <aYNh-m8BEiOHKr9h@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aYNh-m8BEiOHKr9h@gourry-fedora-PF4VCD3F>
X-ClientProxiedBy: BYAPR07CA0052.namprd07.prod.outlook.com
 (2603:10b6:a03:60::29) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|MW6PR11MB8439:EE_
X-MS-Office365-Filtering-Correlation-Id: d9fc7542-97e6-40f2-1b3b-08de641668a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Ar1+dSgqN8EO9NNeUGgv4i2099UqMARos1nj0vfQraKCQFvTFv5TPhlPBECJ?=
 =?us-ascii?Q?o5gzM4Dh4z/8oGEcLYpvUcQeYRwo0F9WcZI9iJY7S6Lznwl/eadwXgxSD8/t?=
 =?us-ascii?Q?liVOgVvwhA0MpY20fwwZBQkzPJtAPT1YHwqSi/f5RGJ6zfDw8dZjfxu+S4t6?=
 =?us-ascii?Q?xSQnXV3yJU/i+/tb04GLScxPZFj8Ir4t5gZDQMp1S+hYFEi0V4PrNUx/BRHu?=
 =?us-ascii?Q?IWoz1YKKzGi1mEVyk1MsDPMJHQMDzTf/LwMcf+WCol/bn/7iTmrWbDx1VcG1?=
 =?us-ascii?Q?v+CrAMke9wNBuz3QNN+tywAcgTVSH2yNelCBa0gruO/TaxTMpjq0Gyh0QYdt?=
 =?us-ascii?Q?e0vwHWde+7JGTW3u8CisAUrVHNOo+FH3RICUl7yRzKDM2qEAjls6IyPDBBu7?=
 =?us-ascii?Q?Fmnd7aOGJf5Ue7QmuSNJ+N8xr11MufdQ1OdEXr57Tktnx1cBZ7gmaj8hA/dw?=
 =?us-ascii?Q?FM1Ay6nS8tuSXckvZtIFSKdm4ukOsI7zT4MJCSOfu90IHzSHMxn/qHDNkcDG?=
 =?us-ascii?Q?FX6ziCo/Lg4DHC56ctnHv7IJpE66QBoPU/xwzvCPmXvm6ZrGb5oVsgTOu8Ay?=
 =?us-ascii?Q?Oo/2gyjGOSf7Lqpch4gNbt2WFm6B4B59R1DOhjhTS78eopoYag6Qd+7b/z40?=
 =?us-ascii?Q?JOK9HQxE0Csqcp5FpeEuCwh+Ga+HHCcZay/ybtDs1l6Sp7hUfcWU3VvXrrOc?=
 =?us-ascii?Q?i2qpV5kdpxbvfjG+cg4bgm4N7CY2FpqWJTtyEqfWVmiURB/uAJdsK/KfK3HT?=
 =?us-ascii?Q?fAHhpxK5EicxifQoWlMWqiQqTWTsHKBcfacn9r5itvClm04qV/K3qkYWtlkz?=
 =?us-ascii?Q?HeYHzh9kQwJi+nXyXmPyXpdjFlV4GNGwVLAyLWLZ3dzA6LH3XzVXT82gVNKc?=
 =?us-ascii?Q?yOOfEyVHRVc6sHru47AlgBSfiPp0KZO/czb4VCnL0qYBgDrZVbQjAluEF/k5?=
 =?us-ascii?Q?mrOfnaupla4xpsSgxqol4pqRHhbKcqyVf3q6K1ZTo6Y1APLY6+DMGGLcDYkc?=
 =?us-ascii?Q?QKY4aYQmcmZVOpRuimDPZGBWjN0aynK2Yknq7pf624eHQk0D9tFl0y9j3OE6?=
 =?us-ascii?Q?4z8qBvlU5yn3m7SKTRcUpN/9A5/4qj51+3iwlGgCs3goCBNkTbkwr0JTXTLK?=
 =?us-ascii?Q?3IDHnXJHRp6bHbEqAGWlLHrhQRhdRMAVJFAHYfvCJJhS92V7QgWZyBUmxwMG?=
 =?us-ascii?Q?dxIXdGmLKX8vpN08A4ERP1xeVVYXTREfjr3YXRZTN1xTuNRDdzk6Iqezr8H+?=
 =?us-ascii?Q?CmIHI80TSvzqBelU+ijBeXhBC9HCQNHsuam2YUTaCjv4gs3HPDQ+yG2Lzjx5?=
 =?us-ascii?Q?aXTzcKlfxqHrMeCl5uLD8trPe/y8DX9lUPk+l5bpFHCVUGyxpiOOAa0xNuL5?=
 =?us-ascii?Q?4BVyLxpbEJzxRxMEANZO16rTJYjbFZFi6KPESQsK5Xpx1QVHuDtAhN3pUhf2?=
 =?us-ascii?Q?bVis8RA5r7gYVDdwJgVxsMfA9KR57jFFFAH1BZ/6c7J8YwUmmd70VD46XfFl?=
 =?us-ascii?Q?1Io1UVIUEJUTRfrdcQXM4TruMI1728WEECtW0DPFzn55PKkztcM7lD0ZDntU?=
 =?us-ascii?Q?T3aWmGxSL8sjY2jJoHI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XPr4mzvl/3OiJmUZlDLH57X5qXLeU0wDueAjdu3eQyOxNd2PQwDNO7ynWQlm?=
 =?us-ascii?Q?yY9+sKVXKSShnBQN6xoAnCHT9YdW86pGciUileMANd/55V6x7FyuA1YYW6Ek?=
 =?us-ascii?Q?ZIQX90x2FUxvrHxjb3sgek1QcW2KjoJMXFSoI1iiZYiDUlb/mUNneo/gqB3j?=
 =?us-ascii?Q?fkLIlKKJ9xNBIe0GH3R6B6864W5jdaYDbHxbKO2FcacnHU1jvBO9+5b6Sd7j?=
 =?us-ascii?Q?87nw1ijLXnmbTkOi6l/gyxXR7A8Y7dwGxR4Mh5IBK7Pm7SDS+8HPlvsT/GXQ?=
 =?us-ascii?Q?bvMrwSUID5LDMg22scd5p+IrDa96bmXfkmk3+llUdr3k+Ua6TuyUEJRNgVXg?=
 =?us-ascii?Q?Z6UT1MJW9EGRv4/Z1LhWQPIBswzoTrNwUZpkch2FL666knKDJGyAr6AURCU5?=
 =?us-ascii?Q?LpbbtFuy1JpAlYbYnsSQjDi1ZFokANRF0bg4l+EePdxFm+7tEpoiujZ+gfyp?=
 =?us-ascii?Q?rXD+DMtCwGuiyzxlueP8GqbpHNYBe8Sv2o2kMH4KTVhw9UInd5pt+v7gv1gG?=
 =?us-ascii?Q?zC7cwyWKzhBgdIoM+5X72Gda6jtSLzdrcbcZJbNIpV83uPjcZQ4CVrvha2kr?=
 =?us-ascii?Q?7JUG/gcNXNG+3yTd1gkidWj7KleNHn3DkIfU4ER6l7ZBwnS4Agvkld3lepK0?=
 =?us-ascii?Q?PVX0/oKxUJwo1MZEUlQlpcS9nHXzXh2FVMEwr3ZQ61LqHHUPkibX2hwklEVO?=
 =?us-ascii?Q?LPHpIERbpk6l1PIxvOhZgCDirV8Ok+6RFMSIe1Y2XTIS8GISd+JPiHumkmED?=
 =?us-ascii?Q?aIACDE05ETPDXiXNGdkK2hkA/8URNf8sunytcBgAOGJe5Yw+WiE9vma9hFMK?=
 =?us-ascii?Q?MbKJgPCFvqBoAjGsaaDjX2naKRGGBsh2TCqVFaFboFTbnp/R38f2AnOro5hf?=
 =?us-ascii?Q?1yv1eL8o6m/ZhuW6sqYCTmKnoqKU0e7s4q16T/KOb/JQWIL58yIompJViTYj?=
 =?us-ascii?Q?XmERlOCsOICxg97UDzF4BjGCyJCS1jZruYFAa5S1opIXeKGgoEsPPI1IeQ61?=
 =?us-ascii?Q?6FPt8M0fuwQ3319KTB89VRBAE8PwG6H4y7kE4m5FRGfaKicNO/UHnmkbKj8Q?=
 =?us-ascii?Q?pyilk2YR4xfk2pophjBl4qfjEpqP5WmMYA/Xr3MpMVAuO2dc3jYK9jROLEQH?=
 =?us-ascii?Q?2U6xlB/YYaka0dzIWrey6D5qKy7dJYCKF/hUB5al6Dk9J/lNTkD32eqmTotY?=
 =?us-ascii?Q?QdNotA7ftRL+XdnqKtWUnTVoBLjLU8smJRY1kSIbr1lStqLCummZs6m65Ke4?=
 =?us-ascii?Q?0okhKwO6NQEO2Qnqz3vvpRzg3GgwDHScX1pifst99TMrTc1um3NvZry7gUw0?=
 =?us-ascii?Q?i693RLjk+PBSnI21Cp0pjAVCW7HWtOHkDkpnxYkCz54Nalp0JowhF7fUY/6Y?=
 =?us-ascii?Q?4zJCsPLsT/TJTK1Ts5JzbZN7cRFNgyCspZLqB59YD3mS7y+HHJ+ehu0X4Xm7?=
 =?us-ascii?Q?oGjJjfO4zd5LBik9eTqpGE11NMP4J21xXzklysJLhGGrap3+m34biTznSgtn?=
 =?us-ascii?Q?jDYe9xy+ZGkxWL/KgVJJAEHmfwasnBV+4FjxkKoh/b6ul5vRCSVALQNDgHJH?=
 =?us-ascii?Q?rXbdx7tXN6bAwsMrc8YpMGyQsL0T0/u2t2mPvNJQxP2e0zzogC0XdgWXCoQv?=
 =?us-ascii?Q?CFqb0SNhouC33WxHcUINhNWYhz2PcFesL6g89RX8FjvwadiskXruKs5nRk75?=
 =?us-ascii?Q?YUCOoiAwJ9hiPZlor++vQu2vywrWLY7Z0hVcwBH9PnZxjRVzrX5L14fKz/rV?=
 =?us-ascii?Q?A0cJrrWrgA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d9fc7542-97e6-40f2-1b3b-08de641668a0
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 17:54:14.1847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hSWaXIE3mf7pwmjB5ENPPaFBetYczbBMZC2jyz4gkiccIb+vCNS21Zuw0p929lb2A5xeXl0tF18atRs6UHve+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8439
X-OriginatorOrg: intel.com

Gregory Price wrote:
> On Tue, Feb 03, 2026 at 04:04:23PM -0600, Ira Weiny wrote:
> > Gregory Price wrote:
>
> ... snipping this to the top ...
> > Again I don't like the idea of needing new drivers for new policies.  That
> > goes against how things should work in the kernel.
> 
> If you define "How should virtio consume an extent" and "How should
> FAMFS consume an extent" as "Policy" I can see your argument, and we
> should address this.

TLDR; I just don't want to see an explosion of 'drivers' for various
'policies'.  I think your use of the word 'policy' triggered me.

> 
> I view "All things shall route through DAX" as "A policy" that
> dictates cxl-driven changes to dax - including new dax drivers
> (see: famfs new dax mechanism).
> 
> So we're already there.  Might as well reduce the complexity (as
> explained below) and cut out dax where it makes sense rather than
> force everyone to eat DAX (for potentially negative value).
> 
> ---
> 
> > > has been a concern, in favor of a per-region-driver policy on how to
> > > manage hot-add/remove events.
> > 
> > I think a concern would be that each region driver is implementing a
> > 'policy' which requires new drivers for new policies.
> > 
> 
> This is fair, we don't want infinite drivers - and many use cases
> (we imagine) will end up using DAX - I'm not arguing to get rid of the
> dax driver.
> 
> There are at least 3 or 4 use-cases i've seen so far
> 
> - dax (dev and fs): can share a driver w/ DAXDRV_ selection

Legacy...  check!

> 
> - sysram : preferably doing direct hotplug - not via dax
>            private-ram may re-use this cleanly with some config bits

Pre-reading this entire email I think what I was thinking was bundling a
lot of this in here.  Put knobs here to control 'policy' not add to this
list for more policies.

> 
> - virtio : may not even want to expose objects to userland
>            may prefer to simply directly interact with a VMM

Even if directly interacting with the VMM there has to be controls
directly by user space to control this.  I'm not a virtio expert so...  Ok
lets just say there is another flow here.  Don't call it a policy though.

> 	   dax may present a security issue if reconfig'd to device

I don't understand this comment.

> 
> - type-2 : may have wildly different patterns and preferences
>            may also end up somewhat generalized

I think this is all going to be handled in the specific drivers of the
specific devices.  There is no policy here other than 'special' for the
device and we can't control that.

> 
> I think trying to pump all of these through dax and into userland by
> default is a mistake - if only because it drives more complexity.

I don't want to preserve DAX.  I don't.

So I think this list is fine.

> 
> We should get form from function.
> 
> Example: for sysram - dax_kmem is just glue, the hotplug logic should
>          live in cxl and operate directly on extents.  It's simpler and
> 	 doesn't add a bunch of needless dependencies.

Agreed.

> 
> Consider a hot-unplug request
> 
> Current setup
> ----
> FM -> Host
>    1) Unplug Extent A
> Host
>    2) cxl: hotunplug(dax_map[A])
>    3) dax: Does this cover the entire dax? (no->reject, yes->unplug())
>       - might fail due to dax-reasons
>       - might fail due to normal hot-unplug reasons
>    4) unbind dax
>    5) return extent
> 
> Dropping Dax in favor of sysram doing direct hotplug
> ----
> FM -> Host
>    1) Unplug Extent A 
> Host
>    2) hotunplug(extents_map[A])
>       - might fail because of normal hot-unplug reasons
>    3) return extent

Agreed.

> 
> It's just simpler and gives you the option of complete sparseness
> (untagged extents) or tracking related extents (tagged extents).

Just add the knobs for the tags and yea...  the policy of how to handle
the extents can then be controlled by user space.

> 
> This pattern may not carry over the same with dax or virtio uses.

I don't fully understand the virtio case.  So I'll defer this.  But I feel
like this is not so much of a new policy as a different path which is, as
you said above, potentially not in user space at all.

> 
> > I did not like the 'implicit' nature of the association of dax device with
> > extent.  But it maintained backwards compatibility with non-sparse
> > regions...
> > 
> > My vision for tags was that eventually dax device creation could have a
> > tag specified prior and would only allocate from extents with that tag.
> >
> 
> yeah i think it's pretty clear the dax case wants a daxN.M/uuid of some
> kind (we can argue whether it needs to be exposed to userland - but
> having some conversations about FAMFS, this sounds userful.
> 
> > I'm not following this.  If set(A) arrives can another set(A) arrive
> > later?
> > 
> > How long does the kernel wait for all the 'A's to arrive?  Or must they be
> > in a ...  'more bit set' set of extents.
> > 
> 
> Set(A) = extents that arrive together with the more bit set
> 
> So lets say you get two sets that arrive with the same tag (A)
> Set(A) + Set(A)'
> 
> Set(A)' would get rejected because Set(A) has already arrived.
> Otherwise, accepting Set(A)' implies sparseness of Set(A).
> 
> Having a tag map to a region is pointless - the HPA maps extent to
> region.  So there's no other use for a tag in the sysram case.
> 
> On the flip side - assuming you want to try to allow Set(A)+Set(A)'
> 
> How userland is expected to know when all extents have arrived if
> hotplug cannot occur until all the extents have arrived, and the only
> place to put those extents is DAX?  Seems needlessly complex.

Ok I think we need to sync up on the driver here.

For FAMFS/famdax they can expect the more bit and all that jazz.  I can't
stop that.

But for sysram.  No.  It is easy enough to assign a tag to the region and
any extent which shows up without that tag (be it NULL tag or tag A) gets
rejected.  All valid tagged extents get hot plugged.

Simple.  Easy policy for user space to control.

> 
> > Regardless IMO if user space was monitoring the extents with tag A they
> > can decide if and when all those extents have arrived and can build on top
> > of that.
> > 
> 
> This assumes userland has something to build on top of, and moreover
> that this something will be DAX.
> 
> - I agree for a filesystem-consumption pattern.
> - I disagree for hotplug - dax is pointless glue.
> - I don't know if DAX is right-fit for other use cases. (it might just
>   want to pass the raw IORESOURCE region to the VMM, for example).
> 
> > Are we expecting to have tags and non-taged extents on the same DCD
> > region?
> > 
> > I'm ok not supporting that.  But just to be clear about what you are
> > suggesting.
> > 
> 
> Probably not.  And in fact I think that should be one configuration bit
> (either you support tags or you don't - reject the other state).

Not bit.  Just a non-null uuid set.

> 
> But I can imagine a driver wanting to support either (exclusive-or)

Yes.  Set the uuid.

> 
> > Would the cxl_sysram region driver be attached to the DCD partition?  Then
> > it would have some DCD functionality built in...  I guess make a common
> > extent processing lib for the 2 drivers?
> > 
> 
> Same driver - allow it to bind PARTMODE_RAM or PARTMODE_DC.

ok good.

> 
> A RAM region hotplugs exactly once: at bind/unbind
> A DC region hotplugs at runtime.

Yes for every extent as they are seen.

> 
> Same code, DC just adds the log monitoring stuff.

Yep.

> 
> > I feel like that is a lot of policy being built into the kernel.  Where
> > having the DCD region driver simply tell user space 'Hey there is a new
> > extent here' and then having user space online that as sysram makes the
> > policy decision in user space.
> > 
> > Segwaying into the N_PRIVATE work.  Couldn't we assign that memory to a
> > NUMA node with N_PRIVATE only memory via userspace...  Then it is onlined
> > in a way that any app which is allocating from that node would get that
> > memory.  And keep it out of kernel space?
> > 
> > But keep all that policy in user space when an extent appears.  Not baked
> > into a particular driver.
> > 
> 
> I would need to think this over a bit more, I'm not quite seeing how
> what you are suggesting would work.

I think you set it out above.  I thought the sysram driver would have a
control for N_MEMORY_PRIVATE vs N_MEMORY which could control that policy
during hotplug.  Maybe I'm hallucinating.

> 
> N_MEMORY_PRIVATE implies there is some special feature of the device
> that should be taken into account when managing the memory - but that
> you want to re-use (some of) the existing mm/ infrastructure for basic
> operations (page_alloc, reclaim, migration, etc).
> 
> There's an argument that some such nodes shouldn't even be visible to
> userspace (of what use is knowing a node is there if mempolicy commands
> are rejected or ignored if you try to bind to it?)
> 
> But also, setting N_MEMORY_PRIVATE vs N_MEMORY would explicitly be an
> mm/memory_hotplug.c operation - so there's a pretty long path from
> userland to "Setting N_MEMORY_PRIVATE" that goes through the drivers.
> 
> You can't set N_MEMORY_PRIVATE before going online (has to be done
> during the hotplug process, otherwise you get nasty race conditions).
> 
> > > But I think this resolves a lot of the disparate disagreements on "what
> > > to do with tags" and how to manage sparseness - just split the policy
> > > into each individual use-case's respective driver.
> > 
> > I think what I'm worried about is where that policy resides.
> >
> > I think it is best to have a DCD region driver which simply exposes
> > extents and allows user space to control how those extents are used.  I
> > think some of what you have above works like that but I want to be careful
> > baking in policy.
> > 
> 
> I guess summarizing the sysram case: The policy seems simple enough to
> not warrant over-complicated the infrastructure for the sake of making
> dax "The One Interface To Rule Them All".
> 
> All userland wants to do for sysram is hot(un)plug.  Why bother with
> dax at all?

I did not want dax.  Was not advocating for dax.  Just did not want to
build a bunch of new 'drivers' for new each new policy.

Summary, it is fine to add new knobs to the sysram driver for new policy
controls.  It is _not_ ok to have to put in a new driver.

I'm not clear if sysram could be used for virtio, or even needed.  I'm
still figuring out how virtio of simple memory devices is a gain.

Ira
