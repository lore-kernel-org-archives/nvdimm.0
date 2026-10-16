Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D041923C516
	for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 01:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792113217; cv=fail; b=ry5qlMDW6wzZD83GTpYuheXbZkg+SvmqVnr9LfpWG5ssVGrdUKIn/arc5EVoxBiTf/47DD2VyEDLnCX95AJYFWYlsg3M0ocdG0nG0hVJAvQ1vEP2kJn0Nlqd6fTGipC51BK0c/xB51+S2kccPbB4+tFzlRdjk3ajoexJgPeiPd8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792113217; c=relaxed/simple;
	bh=p1vh0FQxlkGf+BCo+g9/gSfmBce8rX2/3zAwRKRMz00=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LxGFBMkRgi42igx02RXNroIdFREO/ATvhFANWJl8/ehzyB58+NYmtlsIO1DIgo/uhOl9Vz/eYIbrOj6g3EjVHXSa6R6wE+JoLI02DZmsTR8Py/nGEfwnOu7DmoIAS5/5yel6Q8Xz5+sDEInMX1/yS12Xc8dLWHYSwBGt5zv09uE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=es1Q40Pb; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="es1Q40Pb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792113215; x=1823649215;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=p1vh0FQxlkGf+BCo+g9/gSfmBce8rX2/3zAwRKRMz00=;
  b=es1Q40Pbnyr6JEpwNKx5kNMu90iMNZUDZarnXwuk09rVhAFTdfWzw/u+
   PSQAfAvW3hyd4u1W6LS7Y2R0HsVtbWvl/Z/imsDJAPsChayim11fKWQwi
   yPr8/oNugTgJszwxwFJ854t/XFwPPg1gDPbf0nxdT4LQPDk1FT7Z+hm9h
   nUQaT7Odi1WFTWRkOamYu8AqYit3/+dgkchY3n4deXrsqoK4Ze/vw50yU
   Q+VTbsWaCQOiTcInOzkBTE77JzlxGtywJAlreNT711CcFGIBorVeuKTgv
   M6E1Unr/SWq2un1XYxLK/lMOkHJ6BZmo7etr+BnsnK9uaDFv4QgocQHgk
   w==;
X-CSE-ConnectionGUID: JRTATrHWSF2OfRELVQKlxQ==
X-CSE-MsgGUID: +dINHHMzQqKhhzTXzk7nOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11936"; a="800465"
X-IronPort-AV: E=Sophos;i="6.27,160,1787036400"; 
   d="scan'208";a="800465"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 18:13:35 -0700
X-CSE-ConnectionGUID: UePD/zVhQz+9DA+Ag+zxWQ==
X-CSE-MsgGUID: 2gbuweDkRTOPtkUEsn6A6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,160,1787036400"; 
   d="scan'208";a="1794798"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 18:13:34 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 15 Oct 2026 18:13:33 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Thu, 15 Oct 2026 18:13:33 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.70) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 15 Oct 2026 18:13:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uZcRKwCA87/QyWTXvqnqvuRgUPyGb5VtQ17eR318Mlta+tVM4YAsChPvYod9UaLpkYpCKtTOQPhavVEBfOKzdS3Hq7l6uxTgZE++BDVqwotVnFuQyf2GKCwGHCJRN8Od9ZNTcEcv/EZesAwUgY1WzN3/ZD+oVdklKNfsmNQEVYdMyUSNCrMZ/OfdUX6y/7xiYYEhwZiXNqRn5Es2dDbydx1eaFyOdx2gOltlThFwDKZfya9xuu3+dckpYZ2IRHSK+vG+/PFg3kHgfpAh70lWuuZQ0hO7oDuj5WhTeS6uai5wlgswOY0jzGAIFMW2gcrYyQ/pD2sI5AdLbcH0oQy2ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zhgVb3cUAscBriTwWcTT8kW0ALpt8OotDr/YcR8YlDY=;
 b=kFShpB2ugaReT0UlA4oV2cYJDfw/V95uaZsY/iJ5kyc+VdyfxqF2/SvSGMiW1tW2CDBqs0OkERa6xhuVNYamEcog1dr8xFNI0R4cpslucHh+d8ZgnV1V7/pmjQjOYwYJmHvVPkDghRx0CvW20AaU6y5kf7nw8ho8DnXtAgR3syHXc7aQGe8tWL78sgtcOMG1dhuGNWJBFl/4h+lrU0eNfbo6m5WPl3Lkv3WxcQQW1sAxi+mjtdCdfqk4RFOlH1CquDqzg3wdqs3wmYnRULYyJXsYV2Nji2jdyf0B75IN/ozlzVKFeZOMwjz4g/qjPrLFcuYDjiqbxs7zvYq6WDUV9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SJ0PR11MB4992.namprd11.prod.outlook.com (2603:10b6:a03:2d4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.15; Fri, 16 Oct
 2026 01:12:59 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0522.013; Fri, 16 Oct 2026
 01:12:58 +0000
Date: Thu, 15 Oct 2026 18:12:53 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Muchun Song <songmuchun@bytedance.com>
CC: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
	Joao Martins <joao.m.martins@oracle.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<muchun.song@linux.dev>
Subject: Re: [PATCH v3 1/2] dax/bus: fix mapping attribute error reporting
Message-ID: <atF6FWA0d3IYWZfv@aschofie-mobl2.lan>
References: <20260924025035.1265035-1-songmuchun@bytedance.com>
 <20260924025035.1265035-2-songmuchun@bytedance.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260924025035.1265035-2-songmuchun@bytedance.com>
X-ClientProxiedBy: CH5P220CA0016.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:1ef::22) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SJ0PR11MB4992:EE_
X-MS-Office365-Filtering-Correlation-Id: cf845542-dd40-4f09-acf1-08df2b229d69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|56012099006|11063799006|4143699003|261009223027099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info: qja7wWRqcohTHRvjSX/92DbBYq/CZRM8mRoBU+I3FXfelk+rg68Ig8XdnFYM4LpnyljH/QQ351e7wsjFCCpe2XtCm48lursEFSBAl1r24jvm3ao8ja38qInbSm/lxqipzpfutNWK38fp78bahoVrxJAN4eyvZcV9vOt04FLsOWNHH7ii2A8k+73wWjXIZrCHdQhOVr5n/Xape5UpkrjYHupNcYRdmeecM1LbmxOROhnM5RRBkNnUz3GVoQu3tJ77oOzRrW1zs8LXLPxF9xhEzkzWj4zumv4bTHJdPBM+68bMnCXFg77R/c8ekYgIVia3qqCjqB++0wlfqDfBxSgTzk2u9YRcVCFkWdY/nLIAf6LgB+TH4JZY44jgUkt/G4mKtnGitUmEC+WyVMYyI2FaljffLQSREYLi7RzlAVnFFQBUtnUO05cKjev0tW+jKkxw11lTtza5+R0XWj11Ul67sWzjgCoptwsmuZ+tMtVd8setG054b6VAhb96VtWpb6j9hjTqvikfza4uPM2dT5TadMGgnJk5ulCRdpH+fcwtIVozOBUr+GxIxvv4YA8cAQ/yZD/rS5RVXKZxuhoTxw+RVqcYt587RN+ablf1HBB2PX4Gg6ztJXYlSSdOmj45ovD5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(56012099006)(11063799006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kgoMBBILaQDVb1EkwP8sEygXhk1fsI5z/Ca6xaNuppkOdSaNblNBnJaF7JYt?=
 =?us-ascii?Q?2HVgCAZ6Nh/VaRyUIUem/3716e8ru8/dUPJBLDCmRcLySMduoBnmY2+d98+d?=
 =?us-ascii?Q?thuVgvU386xj6rHheTSYHKkhIL5L55cbJyEkRTLmvx4AOPv++6waBJcLHgB2?=
 =?us-ascii?Q?sXEZgJtObVb5V6YGDfFPX25ee7/aauKfgxXfC2fLka9CXlFrjWaiM89Dw2CG?=
 =?us-ascii?Q?hyEiwD0vvqX05akB3bkRV8WRYYp1S84rUFQyiRr9ZPSN+Vco2Slx8+fAsmCZ?=
 =?us-ascii?Q?hrFa5eZocv/hqMycl0ElSw2HMyPT1aI0macMygy/Bh0FdNsniDIg7gSQEcOW?=
 =?us-ascii?Q?yro3QhbjiLiVgy6rPHEk0rQZXN/DBQdeX7UrYz/ZRzBaH/5/8uDwHzmwNnaj?=
 =?us-ascii?Q?n3onhzBWyiSrV57cLy3rkb9U4vZ04syczSZQZayW201y9HY+i0Dj4gmCz7hK?=
 =?us-ascii?Q?1K5Tb6FK8r5kCKS7M6S2fxv+zbk8rU/td/cQ5mDWKyV7/9FJgjqpFISzjJ/I?=
 =?us-ascii?Q?5m2RQ5iFMZ55kpuGUf4OeguoX0FVdMJySNBP2hIhZN5lNixJLtCwjrFF4gdX?=
 =?us-ascii?Q?kgBMkgct12mYAHiG6DoRtI7Y2wRzD6LLzQ13ZjutZZunwQGPA4B7s1adx5ks?=
 =?us-ascii?Q?7noDfmSZhbLvgpGtcurujvnh3OL7juZENW23rFHxbNrrjSJ6d5w+Qq4rsGoc?=
 =?us-ascii?Q?km/vYfbdlrCzAsv3c023O6/9IKVKlkuyRARAwdD6s3h+xz6hGDSq++pq3z/f?=
 =?us-ascii?Q?ZtJw7XsXq7mN0pLok61ZiucT7NMWaXQkOZ26NzAL0oT7zvoL2hg3VXOyQgiB?=
 =?us-ascii?Q?fMFGD2F37mpvRxLE8mzHIRUqVJgdsEe9/uph6mGxivjwWRvR6kvaKshOh5Fj?=
 =?us-ascii?Q?vKNFavK4aQxQDHg6OgbZ2QctFESYaRe4fmh5/ewVyzKg7YU8RcMMdVH0jWBG?=
 =?us-ascii?Q?2bdKaNvIigfZS4UsG3ITwGwUHFpDlMbOKf81miitWFL2jxVh6T+AmTNL/zgY?=
 =?us-ascii?Q?BWPqKEPg0HldQ/c5Ep9wv0unWXM11KmjWQtZnZvcgsbzAFXOyjFj9oFe8vR5?=
 =?us-ascii?Q?aZwiuGuGrG5pbBcZhRkc4McZTd3z3ZVD+fUPrneTOi5oHIdnxYWbsD7Umnso?=
 =?us-ascii?Q?cOV53+rpcwiXQS5qN+jdhyCGg0mN9IOT5g6MUuQf6qHQMK11lxyINtA1EJ8w?=
 =?us-ascii?Q?s8uztxAPnmho/FH3cGx2DyOFz66pccEdJkXdk//UrPPR6IAiBBP0C5Rghf5q?=
 =?us-ascii?Q?mgnDeB28m7coxKblEZ3fgjupG0Y937Q2744q6IoL/D3waDOaUcmkhLyby2kH?=
 =?us-ascii?Q?h8rJLMy7JinXHJN2MwnEx8JVJikv8cGUwdSw8TF9CIL8wDvEG686FIDpYvxx?=
 =?us-ascii?Q?rUhRvzNOymHC09ZM/Lj6/W1pp7MalxrpuePZ16rPF1du5gHOUNQMq76vKiSj?=
 =?us-ascii?Q?ZFdCVMEcxI41WAo/LKUMIHR8X+6x8j/tB3F0ZmXE86m4S3a6BliADMcj2WHv?=
 =?us-ascii?Q?87Hr2T2aHRbxD5HP/WXtW92C2NSdB5QisaFeewqnWorBDeBHwaw55zh6Tv0e?=
 =?us-ascii?Q?INsK5TyXv8Iz9iJwDWanRvry98tB4QbAl9AUKBxhHpKsISIy5fHZASPcbqH3?=
 =?us-ascii?Q?ydxrJY78E8C3PqHragP/DFSXsgGamLG2rtoF4ygJvgNIm3BlcprGW2C0MPuc?=
 =?us-ascii?Q?6eogf/IdpWKYOhp65j2nBaUgDQ13OZCvBmq2S7h2tYkq6rOq0526uTud1Iw8?=
 =?us-ascii?Q?IU8e6u3AfVFOF9xDy4MRThWDA/52L6I=3D?=
X-Exchange-RoutingPolicyChecked: 4ICr/vJNjEw7+2Axkuvotc1ggcjoWBLcTIKELn/SVDn3y2Jq93xHWAtJyD3PRp4t3ZlWW3Gyu2E7kiGg1FfK8FnM9PS9E2yqiSDlBDGThrYOwNpdk87JVso0fvsYM0qKWaRksBkjTxTE2ZvWeHrVyekMg1y/Xpu/11j+HH/Nv/9cOBxjk44TOvQXnE1ii/0xo79LJ8IIUWjoB/GfWWr1u4BIn6ddKaEJ6nuEK9+/IBWGKe1bevrH0D5BNZ8m7ndKYSky7qTt2Daf+9o+SLBZeVyb0Ru3XEZHGunDDiEI+pQKTj3HjF8UjNYMLLOsXvV2QT9ffs7bztGhldh4213wbg==
X-MS-Exchange-CrossTenant-Network-Message-Id: cf845542-dd40-4f09-acf1-08df2b229d69
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 01:12:58.2555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CT/sBv21K9/ZYz4cy1UZJuzUqJq2vQ0kc9DSL88Q6nL1gnGjA+hxAdJSLrIrV7IKeLziEJo/dV8qkN7mestx8tuCSVMeeqBq5SmQy/VuNIg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4992
X-OriginatorOrg: intel.com

On Thu, Sep 24, 2026 at 10:50:34AM +0800, Muchun Song wrote:
> After the DAX configuration locking was converted to rwsems, successful
> lock acquisition leaves rc set to zero in mapping_store(). Two error
> paths can return this stale value: an unbound region driver and a
> misaligned range size. The sysfs write therefore reports success without
> allocating the requested range.
> 
> Return -ENXIO when the region driver is not bound and -EINVAL when the
> range size is misaligned.

Applied to libnvdimm-for-next:
https://git.kernel.org/nvdimm/nvdimm/c/df6cc0a24717

Muchun, I applied this patch 1/2, so when you revise the second
patch, just call it v4 and send as a single patch.


> 
> Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
> v3:
> - Collect Reviewed-by from Dave Jiang
> 
> v2:
> - Return explicit errors before Device DAX range allocation
>   (suggested by Dave Jiang)
> - Move the patch before range alignment validation for independent
>   backports (suggested by Dave Jiang)
> ---
>  drivers/dax/bus.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index b809e1a264af..e40c25401cf0 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -1192,7 +1192,7 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
>  		return rc;
>  	if (!dax_region->dev->driver) {
>  		up_write(&dax_region_rwsem);
> -		return rc;
> +		return -ENXIO;
>  	}
>  	rc = down_write_killable(&dax_dev_rwsem);
>  	if (rc) {
> @@ -1201,8 +1201,12 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
>  	}
>  
>  	to_alloc = range_len(&r);
> -	if (alloc_is_aligned(dev_dax, to_alloc))
> +	if (!alloc_is_aligned(dev_dax, to_alloc)) {
> +		dev_dbg(dev, "%s: size: %zu misaligned\n", __func__, to_alloc);
> +		rc = -EINVAL;
> +	} else {
>  		rc = alloc_dev_dax_range(dev_dax, r.start, to_alloc);
> +	}
>  	up_write(&dax_dev_rwsem);
>  	up_write(&dax_region_rwsem);
>  
> -- 
> 2.54.0
> 
