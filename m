Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152C72FD7B1
	for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 00:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792111629; cv=fail; b=k1inmzWdyvmDAOPOwQnNOfP1dntnrzh2kL6TRpUsnOnDUG1hDVprdeksZVk4jF37g8tyr5dUJOWG1zF8DeRN8xoOjPfk1IW9GivDl54QyfTvqGQTJMhQf8fxloEjs4vIVs8k962mbcMqnNv7pmvUedJZszj7wtZDCwGPMN38GO8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792111629; c=relaxed/simple;
	bh=Ml2HKmehdeI0Wh3hRshdqMeF+3S3M+FdBDQRnrFQrhA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ci6K3TnRJcFqYKteOXcmyzDMh3vqpy75CKTr8KiyTtIJP8Efm8dVzU4hZnJAEzVIGoyLfiJ0ZIa2Wz/oQKDQ+M0WSmKbI4wZZnmcdQU6IvqecY+3qFp5VLbz1322q6bvd4Yl+vFEKGfGuKWo+HVvtTP3pOduQgaoAxb7B8eIrfs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ljsQCilx; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ljsQCilx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792111626; x=1823647626;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Ml2HKmehdeI0Wh3hRshdqMeF+3S3M+FdBDQRnrFQrhA=;
  b=ljsQCilx7v/fzdILATd36s8nSxBOHKvTW6uxyO82RC6hLh92JYGVSRUG
   DR4nZMXypw64D3GdkfB0iGhybKO4otthhDWy+CbqYld8NrqCzSBLOXf9e
   8K5at3tgzHd4zL9rL1fsXzthZAXGxGMCYT+1gCEMz+mP81LTx64rCN68R
   R9rxet/N7XtDwHp/X9mNQ97huFMqobyX0znZcnFM3BFyZi6wzDUvx/qxi
   K79faMGTZj/1uuP2J5HA1NBOR0l3x7UrTn3hRKHYsKGA/6YllUak/VQ4H
   gXYy3dPXB8LNWsAfbIWPswv5RCqPv7Mq032CAaEWY/saouKWqe6VY7m+p
   w==;
X-CSE-ConnectionGUID: srP9sqfpT7GbYxVoNX8ghA==
X-CSE-MsgGUID: DE5bx8d6TVGsxiqfZ4eFYA==
X-IronPort-AV: E=McAfee;i="6800,10657,11936"; a="895770"
X-IronPort-AV: E=Sophos;i="6.27,160,1787036400"; 
   d="scan'208";a="895770"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 17:47:05 -0700
X-CSE-ConnectionGUID: HJ8K3mEOSoOzEpELVIp4oQ==
X-CSE-MsgGUID: 5bJuI/WOTgSqYA6x3ZhV8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,160,1787036400"; 
   d="scan'208";a="2140390"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 17:47:06 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 15 Oct 2026 17:46:50 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Thu, 15 Oct 2026 17:46:50 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.18) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 15 Oct 2026 17:46:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jZjFCwQzRTsvZELIbbPQ2OeESXNKuA2HCiJ89TjofUoSufTWWmuQPcyEKYy/3Z8LVn0dxL6An5wvFLUqtf2xhrli+TQkgTe2VyT352998rlbeKk3EnkcC/nbwkEV7YAFC98cZG4KAIFWPgzhJPSE2sjUPonDGrs6TJ3fjOXpJ2jC/Z6FQEiDHk9f0Vl9Xsw6tI1f0oJdnESx382bLSDGpfRiytV3zJz7mLL3fajcx0t+q4IkT8N+2Ey4sVb9hnnleuxWfafae/h1Guz0+KVsF3y8HaoC9T0J7b1iWQmaiPeEh0acF8XiVmsFCQL9PLJXN6vhxsCXLn6AM8jC1Ni0bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O6XYqXcOObnVjTg2mu4wqLoMcQhLo6pv2A07DkM4Npk=;
 b=R7S/ZDC0tFTSGysL1yTrGP52rousn+ZSRdwaCuJtDmmAjPXhQB7dASVEyN+cX0tPFJaq4q2R7ndWCP5hPeQT+ZK6b37sSHaN1mVOrHjIf4bOovgl7xxvCtlDVezVhGbJw+2DFS1gd4fa4XrsdKDUQPaBW//00whlBJ/iPi6DF3Cb9Iokn1g3cQPR7KXyTvl2XQgcUeHobr775VcB47h7zlMuYK2JFaOAMbSzHnq4qjrOSWQ4dXF/bBItvR8Nxhc0ryDUPJuk63FxY/LKB6Su11+yB4incDt7weu5TQsIf40RMSucAyJdFR5RCZw0IB+Iihf+idSt6Oct70DNg7zTJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Fri, 16 Oct
 2026 00:46:48 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0522.013; Fri, 16 Oct 2026
 00:46:47 +0000
Date: Thu, 15 Oct 2026 17:46:44 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <jianyungao89@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>, Dan Williams
	<djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang
	<dave.jiang@intel.com>, "open list:DEVICE DIRECT ACCESS (DAX)"
	<nvdimm@lists.linux.dev>, "open list:DEVICE DIRECT ACCESS (DAX)"
	<linux-cxl@vger.kernel.org>
Subject: Re: [PATCH v2] dax: fix dax_core_init error return code
Message-ID: <atFz9MI-ojTVzPPq@aschofie-mobl2.lan>
References: <20261012151857.22534-1-jianyungao89@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261012151857.22534-1-jianyungao89@gmail.com>
X-ClientProxiedBy: BY1P220CA0018.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::8) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|BL1PR11MB5271:EE_
X-MS-Office365-Filtering-Correlation-Id: 60ed3e34-261d-4074-b572-08df2b1ef537
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|261009223027099003|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: ZqtIXIMpXkGeMJUCkenjLTx+iMTZZ6xYw78KqQm+xG2L7RWvgmwGpk2VSJKLKLxOt2gJoMoOtmMZZYrqY6RQhfwSdhDhjYlW1rUBDrVYL9434V830ZCrtPfCV7C4oLVk+PUlhPKi53IpYg3iZx3FqTil9/vTw/nMHDxNCP0IBn2Dn1v6fhoftWJgd428IEdI0ikLNEbpkQZ4GaZ2JS1odEIC/7ahv+I72drxPzXDEe5GfpIe5Y6WSLjM+H8AeOwY+g1UOlbiF91cNfCWSWx6yepVRcgZIYcbjtHXMjYCmBf2ESvoNkZbhaL0oHHc7HNntTIoEitkOUvtr4OC9ZN3uC7zh5Qiqj4CYFmsgo/n2zZDF3hoRElnXR4aEUetxjphCMk5tBzCQSFZM7yEJpwjgUzxk/GJHkII9XrzFPHjOV/0735o0GS4edAO6taRYEqhG0hCEBUgR6mO4bFHr7hxyGIesk/KEtvF8HNGustHBxtnMm26GMWbqdzI9Pb3BacQonzjUMvqHmWvG639mNRCxrLDhScQ5reE1lTuU8o9GBwK4+lTn9Ow5+52tHEKhyrtBlPsygwoFBxuIMZZec+jOr5RkK2Oih/ZSxvCGIXY/juP9EOquvLxAw7n472lpI1c
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(261009223027099003)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VRC5VgZYOVG275vXL4SlrvPWISQj5EQx5zrMSKoUzLDbBWJQl5KPoIuZ9QVz?=
 =?us-ascii?Q?HC0ew7/Sdov9nmnhil0fPHWgZPN/2y0DylxnJKJys45koaPmzMlnEJuFljFh?=
 =?us-ascii?Q?m3XnB4MrCbYW2Mhrh09ZQ6R9w8tchj/6mnO0Ce01cZj1h+TspJG3MDuBhd6O?=
 =?us-ascii?Q?V8OKZHZf/cUXKpHcrVSpbdbhxRq3JhUB0UiH1H/iw5j+kwroB3s9VUvC9yhk?=
 =?us-ascii?Q?Flk7IUPV7G/FLRSUAsvYEIHA1kszmV2KcmtmGvktU18kMzjGSWT+hRiP7AiF?=
 =?us-ascii?Q?JsUcdSwZ0Kn/R7FwmaPdD0L9v6e/TmhOCoFU5qpWyE1d1VUkjxPePS291hBU?=
 =?us-ascii?Q?OWh97KyWwfJvT0vWp0AvCLz2xywsV4uB/m2moUk7AUzW6P0q84nE+sD4CdZU?=
 =?us-ascii?Q?CfyUcd82Mzc1N7qMRgJ7Xq/nT7BHKU3fXSSyXTXqKkW+ac5rX/gV38fPTIR6?=
 =?us-ascii?Q?EeOtLlAy6KjDGLIclmkATEp4FkaPq1ME5ZQADQD8SzesakRyUzek9Yz99216?=
 =?us-ascii?Q?Z7tW5RDibW4H905IpjRW0wtcbEZdOt9TfPv3z8N2tLYhjcmgLJF6eV+LcUbn?=
 =?us-ascii?Q?5k/F4BdKviQ/xfR4+2rO/X4ygIWmVrdPPKlFw9fYYyR69ZyOOU6PLEcU8JRN?=
 =?us-ascii?Q?vp6T/UjReqqcLsmGqJxWftJlwLJX9SMmYVbD0AyJvCcNdnXbaEQ/khJJUady?=
 =?us-ascii?Q?AIIFVNWC3pZXPZH4f/fJTH+r9QWgqnf+kqPrXPWO87emQO7NJjAHKSFgAVBz?=
 =?us-ascii?Q?gtKcYZfmvjnAt5aZl7JKrCK4a75hOnuattekTJLH1gC7Cxz5QvsAdQRDuKk+?=
 =?us-ascii?Q?w4f+fkgmgnwhqXonhdH2WBzLK3aAQeRipuBcG5Mhv/JUlnvFON7O6FBaBKmX?=
 =?us-ascii?Q?7QqX+8774ArlDzOC6j1bWCSlHleyHHHXNXIpGN9Mi3BlJx8WmjLnye/zQfkc?=
 =?us-ascii?Q?u2y5q0H5WV/9porJSBXorIA67DmqHqtqDYCsYy+rcKscpcQ2QmysfX09YrHi?=
 =?us-ascii?Q?5qlpp4DZIb3/A1VwN8NohG5DO3IsrvbzXYeZm9ldf7GRGiTvScs06OJySw/s?=
 =?us-ascii?Q?O9e1jz8tD/UtrIHAGinO+n/xdJSxGKLU4h1sQMYxjLOAyhwUBO9P2yiVUyOo?=
 =?us-ascii?Q?uGClvOayRnkBMiUStE5+/LnUqWhvgrsNWsfnKPyZyoq/EuLinYy4KZsdRQxt?=
 =?us-ascii?Q?396zPIBFlViUYACxhGkgZ+MHXpyDnbORszuL4Fj7PJQ77iY7DZDLAtCuKuAd?=
 =?us-ascii?Q?/GxOh4RFQl/bdFiQPzo50ReSw7+0oLGCCBMa9gRySQ8iTEVx3tYWXufbpIho?=
 =?us-ascii?Q?bUa6zDahvInubKU9Ta6/QJLGw57QKBa5Hh/yIU7c4/Ur71jWSNWX/j6DERcL?=
 =?us-ascii?Q?aHQkX16Gq34UokDd9lyH2ryvos42nXNbal91mCcGgoIXg1bNtoG6KubQQ2hx?=
 =?us-ascii?Q?7RTDxIu4zoX709+SvvbF6pDN9KZohqqC+SK+X/8FmjQHyxigYLtTnv21n+qE?=
 =?us-ascii?Q?f4PsALb6VIxbEMuz8B06kC9Z10v79KeBh0Ys90C8rDalX+H5NKSPeF0x0kPC?=
 =?us-ascii?Q?NXDiVGOL84ZLvif/Z4d8vJkfM893DUyvAzpU3GtBgcbsRPeZyXRcKviXJBp4?=
 =?us-ascii?Q?wMmpp6Ef240inhhaSih+0Pu3LGPJW9jb3GFVQB2mZZRdxDXtIZD/kUFOu6Tr?=
 =?us-ascii?Q?8BFFf1HW9xZwBzurleGlRYN4AyKekzqF21zt/nc4N+JS0r4R2uegbnlVCIxl?=
 =?us-ascii?Q?2ChxrfDkrA=3D=3D?=
X-Exchange-RoutingPolicyChecked: EZGOEPExLE1Xp4ISg+kPDgxYMuKUPIwhJhBBR72Mqr/8wuM0LQRvk/hZ82El6WzRFPOr3qH/sLc+Wkuzb2JEO457jW6q961qA+9nU//qn5H8kPieyEOtmAeG3nJDhrQ4ZfaG2OOA62AbzpbCy+9p0hId0Wqkp3Kx+JKWzBiXHtT3hbM9pmj+jcNrnthhUzx6ZuGaSZCLp0jWIH9bDllgkQCyKTwjFbqBhUZISMIt2PwXsA7frukVfePuE8H2pPaN74e6rZ/bwnoRFdcxi4v+qaP0C3iefQVdd3BWg/3nf0k99fy8UXC7qwICwkXcFY3c5um8fLQoKD8ZFVYRSJ+IGA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 60ed3e34-261d-4074-b572-08df2b1ef537
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 00:46:47.7101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eeK9XtLbg7OcGFU2O48Ym0ErJ04U4wtorhnVVX1CI5OgxbB1smm+msS26JbhXmdH602+4ZDEt2OLz0K4UvIXzCjwN6hnAT8qnAvoxeRvJV0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5271
X-OriginatorOrg: intel.com

On Mon, Oct 12, 2026 at 11:18:57PM +0800, jianyungao89@gmail.com wrote:
> From: Jianyun Gao <jianyungao89@gmail.com>
> 
> dax_core_init() mistakenly returns 0 on error paths. Change the
> error return to use rc so the actual error code is propagated
> to the caller.

Applied to libnvdimm-for-next:
https://git.kernel.org/nvdimm/nvdimm/c/4da700e2cad



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
