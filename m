Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2752C347512
	for <nvdimm@lists.linux.dev>; Mon,  3 Aug 2026 21:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785792628; cv=fail; b=D/YF8YeZF0HpAvrCHl/THRANZAh8dtvDHKYRUqV5ONKEGNDMP1n0mUFHX6bE0k2kOq/K9XIRxdPKtwjKJMDVzc2D5x1OOdKE6yJYh/+sJkmkS0Tb5nzlKUIOZpI8a/SiYW0k/xTBry030Crq8j+ZXftCvJNw+Mxapl7VzBSfqy8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785792628; c=relaxed/simple;
	bh=gY8I6D4jWx+UcwBDLTf+L/D0uC95khEBg4tKBs5Rh7U=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FXXwU2Yv+BKAhzO3hsbXiq8Iuoj9Nsl8ySnKU5wrll8AQjRT/HNuTU8dTbMA0AOcUPGMe1G39922q1/Rxcjncy8d1bc+IM0nJTiPBAm4ABO7QzFTbR+qwRZnR2M7szbZ1FCXmQ3iy3Fi7Clvdd4wRESXxHFmKep8Nqt//q+cgZc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P0tTfHCV; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P0tTfHCV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785792626; x=1817328626;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gY8I6D4jWx+UcwBDLTf+L/D0uC95khEBg4tKBs5Rh7U=;
  b=P0tTfHCVvgMw5jWqjPEM+RLpcZ+2J5cClkcXHKOTPwlYeCtfqVYXZCMt
   O8DPICPx28Q2nYjANqN/uXqgxj0ypA4lOgY/liImNAmIkJeNk5GOOSS9f
   BCr/XSSReShAF5TDdI8RbuwvkFQdZdTYzHBJFQb+jSThlI1ryM22EYzqg
   XHLDabheqItPWTUoB/0XzClIDXx+GpzCkzPpooNZrx0qlCtghwDAbfSGZ
   5wuf5ko7qseiOYy8OzWHcBeG2C34ev6oZQYUzElD/rQPTWGClnyBuPJcD
   cmJ/H7UFJ1oO1Wyl/l9SP/ujgpitTlNdDqRR5P7uws4/hSgc+kKEwkpU7
   Q==;
X-CSE-ConnectionGUID: pqYwbD3sRN6dyOXJcLddGg==
X-CSE-MsgGUID: LBA1j9QpS3iF0Aqc2BcMiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11864"; a="96989969"
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="96989969"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 14:30:25 -0700
X-CSE-ConnectionGUID: Zu5eSjCdQOK243TNNE9VMw==
X-CSE-MsgGUID: +kH8OzXVQf2jKfqa6ZnpvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="261389962"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 14:30:24 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 14:30:24 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Mon, 3 Aug 2026 14:30:24 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.12) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 14:30:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MDhiZKGd8OXhfLAxIlWYl14YvItZee4DxUj3S7/mp4tEYck6LbpzwAP6UE5sXOGAlSvq7y2K2uFEmrMpUr0NDIWr9xK1+OOZp/NnWWZbQ8/ccdpsp9NnYfahDjkbIPNPrDwhAAR4g1V8D3X1K5650YhjJcc5ACkRVB42m5JIIA8Rng9TtMEKGYFDGUpQBSPx2rjV1WjA4hCln3vg4FMW50tOdQD02ySSjrl98tyhBdgt8HTFOLO8I1SJJO4Vx6yomGjRQP40oqtUKSqUDtZkj3feTwGMbvONbl+T8OMhjtbXO97QeXc/uSqp+uXFEF4yzYKIDl1MI9vuRhW0esz87Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gcC2rZiIoj7z6Qc7OGyVq6b5z38zSoF/RNA1Fb4ZTUE=;
 b=NreQPRqQHvTri24v0FlR6nUuUKYw0nTmp3NwSHBMTQ15juX83bQJbAhWIHmdNjK39NXN3SzbLlXvxWNhInmREkI6gEQy86xIwXsLLErbzimle+tTBYA8YgDYZhlLs6GiXBSBF1RTtafl4tEdEWscdE0epAS3I/lii5Tn/D6S3AW5s2R9LGqWLTcnZLOW48Awgyx6+dFl1EVWD3jVh8VoIMVRcR/IPxjDJg4dOWCf5oV0j/rP9J8d0GC5VUcZmfBfNWDgivyKLdSQ/t/kpPpL242/pYZNR/RoTcoYMzYDDfnF69m1rSzM78INSeTQneEeNQupSiwwFp7XUZcn/pZN7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Mon, 3 Aug
 2026 21:30:21 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53%6]) with mapi id 15.21.0270.017; Mon, 3 Aug 2026
 21:30:20 +0000
Date: Mon, 3 Aug 2026 14:30:12 -0700
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
Message-ID: <anEIZOTDKsj15Nhp@aschofie-mobl2.lan>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
 <20260731084901.1512819-2-anisa.su@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260731084901.1512819-2-anisa.su@samsung.com>
X-ClientProxiedBy: SJ0PR13CA0221.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::16) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|MW3PR11MB4554:EE_
X-MS-Office365-Filtering-Correlation-Id: b86e74d5-9a64-48e9-8f75-08def1a66b93
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|10067099003|56012099006|11063799006|4143699003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info: C2Da6GJIWgg5NdqBblIh6cMyx3X/mIMF2+hXoJLaxbBBpJZpTgGWLwdT6ZvtCYZ1AdmxpzosIB1F+OXBjzS9p1mybDkSEBbIxtnJh9xGJ2RtH+7tUUfbNJQJR5chzanKuDDME4fIyyo61b4IIEX86OfP+l267jGNn2oYpVezSsaf4mw4bf2Gxo/S2e7X+CPLKvD4dITd1ejkSD3LA3B4xisajozmxySJcn2R8SGSuK10tMqCfLuOzpN2M0GlLdLxvtBJrOBEkk1o8ySptGw9phfdIVrFZtOu8T5d1V6hhpRuUg5q9bjD4OZfgbZ4BmCOk0vHpL/2sqzxbQnkREl3voQjG4dq4I2TTPD2cDeeNI+bkWETqQM744t73wW+beP1RUI24bmKFV2ltVV8lLkDn++YqMxJcu46jxiq5qO6AdFVRO6h/XxJoeNorvgitzrvVDvF7Tm0OXDru60q3Cvl76I//W2gT2Ft4jcdWRxhXN6oOKqDlSmOBp0FniINtr9QsP43hMomMrf52exdOZEgkvRefGJMbNqUEQ/9Fl+8+KzPFEY0zwgc+jh4WYo4Q5U1X7VD8SOaOMCdyUD0CX83uPyBoyxZDAlxIugF45jHTvGB6vvK5ZCTZ8WnwD8DFTLtAdvaGfa5KY4wuwgagndN0pbWGYqhsV7kcIqrR/HCN08=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(10067099003)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Kk2K+D9YFBOtJM4uNkD8fZYlXuClMxGCMH9J4R88xyMbEjI+h/3JfWwrHKdv?=
 =?us-ascii?Q?Y7KCVVyJj8L0OVEk7APbPrwPwrriXztQkXl9ZCHZvCIpM8xLjiZ4rAGNofYi?=
 =?us-ascii?Q?rqMipm7UaQhryxTFkjx2clNQ0LYzn39FPrnNYQ1aUQNOAMYMrCXJEiLxh2uT?=
 =?us-ascii?Q?/y4DxWqNz3yDllmyjz8DeOKS9CTvdqnai14OEhGZ/enjwrA7ieV+7ReLpXuT?=
 =?us-ascii?Q?KW7GpscfQ6qgjX0BQ+ZKwu/Shlub1PgM9G1KLm5SBvZV5p9t52Fx6LC7GHwo?=
 =?us-ascii?Q?ApaQhwQIR8HBYva5ZUM/VmZ/R9phWDWluHfnj5uTX3zqQpYRYmC7Q+0sPT9z?=
 =?us-ascii?Q?7aMHEYzwDPpyXN3H1Le+ueM7Bht2aWZHhPnwdQMaYdN0mL31Ti3NLbXyb01l?=
 =?us-ascii?Q?rOB936GXuB1XZQMlboJjdY4v/jkdA+WL77IelkTRapa3NhBAFUcsYDsPj4zf?=
 =?us-ascii?Q?36JnnfTKst0qhPoP4q0vSrAvbhvn/rQ6xchxSAkp5Q3xI0qjBH1oqSeiW+KC?=
 =?us-ascii?Q?ugEOFw6ZA/XwoDY+T2OPJxfajZqlw/yK1cUyomC8+1Hq/ugzrGWKSOELXQuN?=
 =?us-ascii?Q?GELkg3ta77zsFPUv10aKRWTy4HYYj5qm9VNYW77SuNAqoe/lTh80tzSabO+C?=
 =?us-ascii?Q?pR2kQ642dP1+gZSNZlUxvQr35wVVczr5G7WyU/zxKKdch/1Lv4bDMQ03Zlw9?=
 =?us-ascii?Q?8MtX5qfmsSQHjtk60Y7yoEb/rIlwLtV2beipv4kqF7wq3e47iBgzptA4FrnY?=
 =?us-ascii?Q?WiXplP+3D0vO21Phj1MjeCcm/lr8x8P9U+i5COmU24sc+GqphOcqaF6tZGsV?=
 =?us-ascii?Q?UZUX47RM7VHp8Tdz7TT7JgVgE1+xKN23N4RGrPOvzHicOZuhvdeyI6C6XIpo?=
 =?us-ascii?Q?Gg9D+nj7u4QX04HY7nQUc6bQ6744B04SmJjINfkKSowGhFBBKQc1QbI0wErM?=
 =?us-ascii?Q?CsbmIYbG6AXYaIBge44qfdw762iOQ8DpAjVs9i7lx7b9SVwKoOLbC2cxUse9?=
 =?us-ascii?Q?71MgLoJ8LINtP91gr20oal2ooL2l7Epa7/LIZYxshxetdYtxawKLkBzx+Z4L?=
 =?us-ascii?Q?qVLgiituwkfJj6wOp7uVN0i8jNuDs0rTJERx2gQvcIRNRrglTlSlap4yPVGi?=
 =?us-ascii?Q?D/5m98h1bNFRYGlBXGhTEoHklyHBfTLqeMaNAainKNaB+RPtJCsBUAaMXidx?=
 =?us-ascii?Q?qcjToUpBqvLw8QKGqZkdRZ/bK0XBdzOFpokwLFQsuc4mVODWIswfmLHstjU8?=
 =?us-ascii?Q?xrs3cM1kvi2tx3zoYyKfxl+u0NNLwAHiJREzOC9ALdmlGRlaAJZR2pVn8fxC?=
 =?us-ascii?Q?AMwTNA/Os7onFkyEj7baFWnxjIcG9mL62ydWpYHcLA4bVQ1a6vb4L/4NzsgI?=
 =?us-ascii?Q?T9NW7YAh7GyAEHtyDZL+jp0USoz2W8IAj8dG4UcGh4K1JxJxG0/gPVl0Lm44?=
 =?us-ascii?Q?0SEVavvPuaQMx516PVkkVLZXPwtbjFB10uvrMG0PYsr7lBY6KgK3JMj6SYO+?=
 =?us-ascii?Q?Uxewbdyc8JUROM6H8jYDUrHW8hoTFYNySJFoyZKST78ARMcxP5LdJ+yK78t+?=
 =?us-ascii?Q?EMc/AuyCSZp/b2AwKjIKkPFw4+slGevjFtjPVupqUwreaXCDkMcPKJ9rnRfv?=
 =?us-ascii?Q?O375r3RBfLqk94LN0ppzAc+OoVrKm6QPthl8ueVggii4Vhrn9V04/ryEI6f6?=
 =?us-ascii?Q?hzx+OvosSOFrSe6WWPUmgIGO7EeESuEliOJj/CNFaWni5qOm65aYn6+RPbez?=
 =?us-ascii?Q?Kus/Ex7jasin/Og6HXkQSnP/llqOLoU=3D?=
X-Exchange-RoutingPolicyChecked: kKUGx5RMWw+6200sKoMr0DRVH58ElYyrcHqnWel4sM0L6ujdAphscwoy7CCXQzpAL1jubg/+Nlq0fhPzd1UP2GWH/L/srrK+sefZ2DkJFITGbrd01MBrDT5iKnWz55OUz16mBu94AMgj/lo12qwKNpT4FXnOVncZYzdLtYW1bL9TIEMX2Lv4ndzITmmQ+5ivWd2PDUwuQluazzMyjpG/G7lLWB3JcadOhAtBTad87An48yWZ90opmRakyjfLaxD+o0fi0B+qiZNjaotRH2Z+YrFXlb5R52II+0B0nLA1H79fDhHcIRzmZi1qhe0vPtpR5Ywb/HgGR9TwLMQsbncXLQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: b86e74d5-9a64-48e9-8f75-08def1a66b93
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 21:30:20.7429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s/QlH1ZPAvHeUZ59SnSqCPWxBMKzue0Hl15TWgBgwJqDwpf4aFOzjbKgwmJnwC6TJmUXbzNxQxREyWYGVDCjMdmm5aKEayTPlYJFIlvgF+I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4554
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

When I view how this lands in the entirety of cxl_walk_cel() it seems
to needlessly be different from the pattern set by poison and security
handling in the same function and structures. Could this follow that
more closely?  Doing so would remove this 'tail' work here of checking
and setting the boolean.

This appended diff touches patch 2 where it has the first caller, but
pasting all here for simplicity - you'll apply per patch if you take it.

The bitmap lives in mds structure and it is already where the bool is now.
The only piece of the poison and security pattern not worth copying
yet is the wrapper struct cxl_poison_state and struct cxl_security_state
exist because each grew a mutex and other per-class state, and DCD has
none of that in this series (yet).

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index b18ea02ed2e6..27cfe0ee4752 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -172,7 +172,7 @@ static bool cxl_is_dcd_command(u16 opcode)
        return (opcode >> 8) == CXL_MBOX_OP_DCD_CMDS;
 }

-static void cxl_set_dcd_cmd_enabled(u16 opcode, unsigned long *cmd_mask)
+static void cxl_set_dcd_cmd_enabled(unsigned long *cmd_mask, u16 opcode)
 {
        switch (opcode) {
        case CXL_MBOX_OP_GET_DC_CONFIG:
@@ -192,11 +192,6 @@ static void cxl_set_dcd_cmd_enabled(u16 opcode, unsigned long *cmd_mask)
        }
 }

-static bool cxl_verify_dcd_cmds(unsigned long *cmds_seen)
-{
-       return bitmap_full(cmds_seen, CXL_DCD_ENABLED_MAX);
-}
-
 static bool cxl_is_poison_command(u16 opcode)
 {
 #define CXL_MBOX_OP_POISON_CMDS 0x43
@@ -789,7 +784,6 @@ static void cxl_walk_cel(struct cxl_memdev_state *mds, size_t size, u8 *cel)
        struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
        struct cxl_cel_entry *cel_entry;
        const int cel_entries = size / sizeof(*cel_entry);
-       DECLARE_BITMAP(dcd_cmds, CXL_DCD_ENABLED_MAX) = {};
        struct device *dev = mds->cxlds.dev;
        int i, ro_cmds = 0, wr_cmds = 0;

@@ -819,7 +813,7 @@ static void cxl_walk_cel(struct cxl_memdev_state *mds, size_t size, u8 *cel)
                }

                if (cxl_is_dcd_command(opcode)) {
-                       cxl_set_dcd_cmd_enabled(opcode, dcd_cmds);
+                       cxl_set_dcd_cmd_enabled(mds->dcd_enabled_cmds, opcode);
                        enabled++;
                }

@@ -828,12 +822,6 @@ static void cxl_walk_cel(struct cxl_memdev_state *mds, size_t size, u8 *cel)
        }

        set_features_cap(cxl_mbox, ro_cmds, wr_cmds);
-       /*
-        * Disabled until event handling implemented.
-        */
-       if (cxl_verify_dcd_cmds(dcd_cmds))
-               dev_dbg(dev, "Device supports DCD; capability disabled\n");
-       mds->dcd_supported = false;
 }

 static struct cxl_mbox_get_supported_logs *cxl_get_gsl(struct cxl_memdev_state *mds)
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 77f6417a1de7..bfa746c5a7c8 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -443,7 +443,7 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
  * @partition_align_bytes: alignment size for partition-able capacity
  * @active_volatile_bytes: sum of hard + soft volatile
  * @active_persistent_bytes: sum of hard + soft persistent
- * @dcd_supported: all DCD commands are supported
+ * @dcd_enabled_cmds: DCD commands the device enabled in the CEL
  * @event: event log driver state
  * @poison: poison driver state info
  * @security: security driver state info
@@ -463,7 +463,7 @@ struct cxl_memdev_state {
        u64 partition_align_bytes;
        u64 active_volatile_bytes;
        u64 active_persistent_bytes;
-       bool dcd_supported;
+       DECLARE_BITMAP(dcd_enabled_cmds, CXL_DCD_ENABLED_MAX);

        struct cxl_event_state event;
        struct cxl_poison_state poison;
@@ -878,12 +878,16 @@ int cxl_arm_dirty_shutdown(struct cxl_memdev_state *mds);

 static inline bool cxl_dcd_supported(struct cxl_memdev_state *mds)
 {
-       return mds->dcd_supported;
+       /*
+        * Disabled until extent event handling is implemented.  Enable by
+        * returning bitmap_full(mds->dcd_enabled_cmds, CXL_DCD_ENABLED_MAX).
+        */
+       return false;
 }

 static inline void cxl_disable_dcd(struct cxl_memdev_state *mds)
 {
-       mds->dcd_supported = false;
+       bitmap_zero(mds->dcd_enabled_cmds, CXL_DCD_ENABLED_MAX);
 }

 int cxl_set_timestamp(struct cxl_memdev_state *mds);

>
snip
