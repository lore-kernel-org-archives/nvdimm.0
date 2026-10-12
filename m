Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1F630BBBF
	for <nvdimm@lists.linux.dev>; Mon, 12 Oct 2026 23:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791846327; cv=fail; b=MsQGCG2nKSq6hYyftWY+0pknkuOjXWi35sAqwV1I3oXJTbUDtBsL6+bUxRBVuj+1FL6Vu9GPx6kjmcx5LFDHvN+JiF9sMTCy5W9t/Pcjeb53AGM9lUWKAav0Ogp/ryox6kzn8tXSQJP6HICFo56/bzUMzWOicnohRAC3hufyr0A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791846327; c=relaxed/simple;
	bh=5ojngxGhcnd9Rm0I0ShROQf7r2ZQhpelET1PYoRfVHU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OUhHwKIEBezhyQ+V9DOTs7x2owfEnrYOiMj6/OJDuw2B5ZEuZ3cedanxe+yF6lEV/Es1ilqk7U+W8pMuGWGneCFrvRqmkj+aMmocDU1mMDjQt3kAk9/xxK3Dz5sSDH0OIccfJ5tXqcNzZuHokV24CHMCqK0+5PdOrWqstgtDp1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pd1kIlUy; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pd1kIlUy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791846324; x=1823382324;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5ojngxGhcnd9Rm0I0ShROQf7r2ZQhpelET1PYoRfVHU=;
  b=Pd1kIlUyZI8TzmMD7jgEm7E2Bgv0Gyp5di09S8IJxx6CX2oPW+d0e5GT
   EbVX5Nj74CcsKxr7Y8UlhumzSxIVVOCaWYwiCXADcqdR3fYRipy5qM1Od
   uYFvVSUPR91MtVCeDzSYB5cyHfg4vj11TFLZGF2ATFw9wBRTJXNVPy6o7
   qTEfXHxcwhDZSEqG4KE8Yjm7PBVmv/mCRUGAP/OoHGfJb1+QePhBXRWuY
   KnDH66Re7DaOxZhJen5jXFGPje8b10aZE//i5p7FbnRhsyltcakGCQUNK
   jXEK1A5l+a2pcoh0pL4lHoPftyOZpbrpCaagAPmJsBa/8AePswiC26WmP
   w==;
X-CSE-ConnectionGUID: OOBpDk/jSTOpGbENSHxGIA==
X-CSE-MsgGUID: IODYcWanR5KcLuziiY4R2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11933"; a="569343"
X-IronPort-AV: E=Sophos;i="6.27,154,1787036400"; 
   d="scan'208";a="569343"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2026 16:05:24 -0700
X-CSE-ConnectionGUID: XeOARbvmRgahmh3WE0QY4w==
X-CSE-MsgGUID: da2HM93WT7OLNKNYw1d6Aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,154,1787036400"; 
   d="scan'208";a="1119248"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2026 16:05:23 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 16:05:08 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Mon, 12 Oct 2026 16:05:08 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.3) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 16:05:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t1e4CvS+oTjkV5y7LgDwFEj//EQC5j7zksKe6mD2oKwDf9GHgYlJjELSXy02AGIHBPQv4GFtBzuWdQS/GunFyD8luiJ4Ivk3Azvx6Iz11/y+jHNtvigy18wqBvM4rkdo0vrw5r9qXirpJAy4qQiCZsXV48MsrLNERdyNAeOvWjgSne4vxENuXeZiiXB6lid8kq5q9BDtCFaZrFvaODOdxvuRe2wMXqxOfxVT4Li1LzQ7pUbZ2JTIKTYQJYjkn60tcfJm96EDme6IPw0ytdMnUa99v116wvXB3kqr64oYuRByKY9Q5X4nPZBKwjvoUEo/c+K9ePTpDL4FfmgWdww6+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WhUNDK5TIeqmwxSpZw5sloEDG25sFQ1nASzAOprGqgA=;
 b=VhbRtn/MOo1fiaDcebbGqB43OGoJ4C9HRy8q8mnThv6euwvFvwOMNFlKJDGDu3ycrs3jVv4sMEXtjpO3mFx11z3DLsxrmYjVU6g+64+jk2a759Y8+ig37IT+dPuJ3dXEU1+G2OsBCvU2pp1vefiQAv/mi39dmQh1aGnHJkxhoOX1kyG83ChGcbsekyH0Y+bt1Vihe4IoXDBThc1BfkFJjkhJYWC9qf2C1vOgErhCKklE+TMTYceRvzALxsizCj35IwXFP6nuyrYg5XbODiAtlDOhzXqBJGmQcsaXg9GsTgVGv0bPYG2nn8F5mVQSeeCPlaPxEbMMa7paGSZOtvr2+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH7PR11MB6005.namprd11.prod.outlook.com (2603:10b6:510:1e0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.21; Mon, 12 Oct
 2026 23:05:00 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0496.021; Mon, 12 Oct 2026
 23:05:00 +0000
Date: Mon, 12 Oct 2026 16:04:57 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <jianyungao89@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>, Dan Williams
	<djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang
	<dave.jiang@intel.com>, "open list:DEVICE DIRECT ACCESS (DAX)"
	<nvdimm@lists.linux.dev>, "open list:DEVICE DIRECT ACCESS (DAX)"
	<linux-cxl@vger.kernel.org>
Subject: Re: [PATCH v2] dax: fix dax_core_init error return code
Message-ID: <as1nmV342j-eUOYm@aschofie-mobl2.lan>
References: <20261012151857.22534-1-jianyungao89@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261012151857.22534-1-jianyungao89@gmail.com>
X-ClientProxiedBy: BY3PR10CA0018.namprd10.prod.outlook.com
 (2603:10b6:a03:255::23) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH7PR11MB6005:EE_
X-MS-Office365-Filtering-Correlation-Id: 59822807-c139-41ba-6722-08df28b53ddd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|10067099003|261009223027099003|11063799006|6133799003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info: lSztvheXnQ4wYOeI5W9oJGeFok0yYE0fPgrZQDPO1S9sIJ65QvqQhyQgMObGVV5WbOwmQsGppXqIZkDPo/GErKrVQHyq9W7WAwq7ET8DR9p3EX8xKk46oR7Bdaxtm33VsWTCXFonqsnWUGzxTW9YA+wY2qw0zapnYtvEU0VTVMxX2DrXLfS6zlbz88p7IBGTJ3Uwro/g4HNTzF/uzKGzq4L/Bwj/LU6MCrIv0wvlvi104Q4zpDONWqjgND70kmVHQpu5fNbUQpr8ILkwpjR/FFgpymjQ0yH+1JCl9xZzZfcPTrgxBzr719hNj8GN48pUbS442ANwz+FJLiN3cyXHs3RPC1n7lVgd+NiaL5GFBX6uEl/QI3iTxzutBtduzcUIvLzfDiKBLPuaP9JdRlh9xD49bpfZR8afFwQw3M3hliYUigVBq5dMBI1+UhDPss5s/WT5zo6qRNDA8gvIWZvuYid6PUhvxtpkEBbrvgJYUX92LktUZMbA3LfaKUTQAgcJCzAO79hSMOPE9va9M2cHL9r6FBaBp31hzSgk5tk2L/MlBVvHZiPK1+Tll9VEvgje/BI5z94XY3LLKoJVdQHAmctE5f7vXrC/dNtnmxezEL0vsSGlJqrfl0obtTVax1woIA3AvnjC14NQdnVdTSNvArsOQTqmhhuw5dUYhw22cAM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(10067099003)(261009223027099003)(11063799006)(6133799003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?edfRcpzJ6wUpbsKtaXbNOVS2edbjkx5TP6ksgMzJg400Zl13r0HueBue7Kd/?=
 =?us-ascii?Q?yhpw3byzEcAzYzeqjRLg/RK/SFuPDpwn47ca1pgYZhSizf4ZFPeDkEr1L844?=
 =?us-ascii?Q?vaXiKGEFX+O8b8i/PEs5ZwRBhmXRMMPKUd0V16B+UC//N+nyw3qH0acHIOH+?=
 =?us-ascii?Q?djTBC0WlvOv6l2HXrg6GIDtYSfrLjIA3rBOsor+UEIuwa2MXlOzodKGq0WtA?=
 =?us-ascii?Q?rcF+iQ2q4D/IUztscEoH//GdtzW0IGdN7ORJzvWcSMSGLKfNHGTujsgxDpP2?=
 =?us-ascii?Q?8PRsf5zBZZjyBsoeWCQaflDPhxwJKVvqePeBFktF65uRJP4yFlCU7LDb3Uvd?=
 =?us-ascii?Q?T2Dv3o7nH9E4k7S/+C1A1RNkUXtwSlto60zQLICvOR3DaMC45kqLVuUiAVHp?=
 =?us-ascii?Q?P8ocC2iS+qv0yOR9H/ZjUT4Cm5WcqvGaTn8ESjRTLW8VwglzQFEFtCDlzl27?=
 =?us-ascii?Q?QC0hFJaskFUwwObccRg4+QjtjVg0u9heIlXjTeySJVpBR3Sumf822INIByk/?=
 =?us-ascii?Q?L3cHSqnVHvYOabBRoN/ZFZ3Hum1ubl6rl6a/wPt5Y5qA86mNwgzqS+o8Z2tz?=
 =?us-ascii?Q?OIrYO6JmFcy0ITBL9MSFSLO0k3y5TuMeH8U+imWX4t3i5GY1OcHy2rwxug4g?=
 =?us-ascii?Q?ZnmmKqYeHm1KUZvCJYgoJ4GyhTEArN1NDN2GXd6lRvX5rJpj8LkbBTjyl4Yz?=
 =?us-ascii?Q?6ZNhlkc4olen0Q61NutleX0l9yerFvy8AaBGcGpMI+SirK0nURNtdHERvBQk?=
 =?us-ascii?Q?Qt4n3DR4QUPf+aWM9c9dFKRjOY1IgkBll6W2232U+QsoBDK8E0iX+ot/Cnwo?=
 =?us-ascii?Q?L+CHZCG2XiP8Xb8TG2Ljq9vcxhuVf5fMoDBv42v0Y0Tw8PkR7fPcXuvaXcrM?=
 =?us-ascii?Q?KQq5akt5LNLcKVFBQswCTVLJutE9LP8nZiKCtBSCXMSQTvYr7WceZebISwL0?=
 =?us-ascii?Q?vjbHsJYBIBPq5soOfRZ3hOD8ZzMaIFyjvtm4hWvS/2VERG+2mxk6Xfj1CPql?=
 =?us-ascii?Q?yk0iUGIMf77mMwrZN7wfbMsPK5UKHelIP9rkQJfFeksKXz0f+dBZ4a38VwDR?=
 =?us-ascii?Q?PrHYz6OcYq6C7epIU0ewNIuUuQCeGot6CVS94oVyXFiuJj5lpibbpC31RTvi?=
 =?us-ascii?Q?3bO6heBZiRMClwgIVLJeJkiugssMeurEh/aev8DXiGjHO8CdERfHlU2Tht9Y?=
 =?us-ascii?Q?DuhJ6pQTOWvs6WeQlY8RlRM1QYpo9ncuswZfG8NNs0dzrdk5S29hOzPUl1bi?=
 =?us-ascii?Q?TZTDIqEmGtITj1GCve4u7ZSZWyyjfefpYH+FuJzadhiW9FdQXmSfPR/Mn/JE?=
 =?us-ascii?Q?0CBbJG3oKDUrmIWwclIg2hz3a/HlUA2LOD+q2WtuCpy1fXAPUBP+UqAByuCB?=
 =?us-ascii?Q?hcjYBVLqEZgAkppbYkihl4NTTNQPKFdeYuTe4DKcG/WljtQKQKTHeCdvnIJ6?=
 =?us-ascii?Q?WMAHadJ3xq04sts6w8YNPI975AyG6Isecgc5r+yTTp/RjAXUOyTm6X/oz01L?=
 =?us-ascii?Q?TvhjFlorQdhEJ38tF0Ge1V9hxtn0VjjTlgdjy/FPJk6mr8N/LXz/6fj5mz2D?=
 =?us-ascii?Q?E0HtRTLsnrD/AVwia1Gbq9kC08Tm/4inb5QbZ9PH8unaK6aBoYnrEkxOfvbo?=
 =?us-ascii?Q?wJQl/822AD9rrt0xIhiWQ4m+FmcCj3xeZiMPeIo6zg8ZGDGtHvFE+f59S3pH?=
 =?us-ascii?Q?8a6lBkfUwg4DdKkj3P3HofIYmVo3awCLFzVN257xyNjrIiR0SEmCISh4aYuF?=
 =?us-ascii?Q?imkwFPRzFSnPvkscmdhspObwjRac9Ng=3D?=
X-Exchange-RoutingPolicyChecked: 5otM4XMKqmWqd2uV3CU5XIiHcHxGcL+rDt99/MtQvz5D7nJs6vbL+gnOmDpov9U/BXWkzmxr0fz27HvjLEj3F0j6VhA/Agj6qBsmviRvwCK8O/4NDLbQHRN3pozrY++MraGFmQxCa4EBelHA10G6nms4I/uitIqE/6q0WSZJJ42ng3i1/T2a7AZ4UkSgcC6ibefuDryl2J0U830L1XvguFVS9+cLfTyUVccc2FLF39NP6+4OFNsjhtVLL5/ECnh3Vaxxjf5QAyWSJDqOprb3NcGB92oVkVzb0j0hWidn+0zq5sTs4zTQmPGOz28NQNCpaN0o2d9zUXKvk9u7Lvu2Cw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 59822807-c139-41ba-6722-08df28b53ddd
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2026 23:05:00.4519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gm7Gvylh6LVMZO/oO/7KseoL/xg3pRucRv/7VbrDtWL4/fzdeWxa3MpTd1OyOVBgz7iQlWTT1/JWX09m9LybJOkLnyaVytfeFBnrA5knXDQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6005
X-OriginatorOrg: intel.com

On Mon, Oct 12, 2026 at 11:18:57PM +0800, jianyungao89@gmail.com wrote:
> From: Jianyun Gao <jianyungao89@gmail.com>
> 
> dax_core_init() mistakenly returns 0 on error paths. Change the
> error return to use rc so the actual error code is propagated
> to the caller.


Hi Jianyun,

Thanks for the patch. The change looks good to me.

I'd like to expand the commit message to explain the impact of the bug,
not just describe the correction. I've proposed a revised message below.

	dax: Return errors from dax_core_init()

	dax_core_init() returns success when either the character device
	number allocation or DAX bus registration fails, even though the
	error paths have already released the initialized resources.

	For modular DAX, this allows the module to remain loaded despite
	failed initialization, leaving subsequent users and module removal
	to access resources that have already been released.

	Return the error code from the failed operation so that module
	loading fails rather than reporting successful initialization
	after the resources have been released.

Please let me know if you're OK with the above, and I'll amend the commit
message and merge the patch.

-- Alison


> 
> Fixes: 9567da0b408a ("device-dax: Introduce bus + driver model")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
> ---
> 
> Changes in v2:
> - Drop unnecessary goto label, keep direct return for dax_fs_init() error
> - Add Fixes tag and Cc stable
> 
> Link: https://lore.kernel.org/lkml/20261011132017.31131-1-jianyungao89@gmail.com/ # v1
> 
>  drivers/dax/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 45f84b0eb909..210f4af479f0 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -738,7 +738,7 @@ static int __init dax_core_init(void)
>  	unregister_chrdev_region(dax_devt, MINORMASK+1);
>  err_chrdev:
>  	dax_fs_exit();
> -	return 0;
> +	return rc;
>  }
>  
>  static void __exit dax_core_exit(void)
> -- 
> 2.34.1
> 
