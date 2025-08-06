Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD04204583
	for <nvdimm@lists.linux.dev>; Wed,  6 Aug 2025 21:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754516649; cv=fail; b=g6pajt98Ani6n40iVLLcz2IZw90I72DnUUC9QJCb0ozNEAWOMvJgGMLD5rw0c34PfBXCli/PXh8osarVEYZfin/54CFAfUwUIIYeGa+GcbO3Bo43wCV8DSDSwO2Jjd2KoLr45rgTd0bZBLWhsQ1O2XXN/z7axP8RiseBV01h/2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754516649; c=relaxed/simple;
	bh=T5njk0PrvsNOxFwMUbDcCNAZjhFcEui+FezyE33X+6Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OAcLumvqEV7pf9NP911I76bxaPPSzbq+HiKpGye5TAAppKaqF+MLJJrNPiDmc7BZhmvEmQpz35fsSejtfn+K4Wkwt43v4d0ol/MmBU1sPYpbAu3GneXsDFJxCSIkXx6TrkDPGablEZfn7BYWByXNIJ5e6eJUPFbYMMEP9cQ4zlY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VdAIzgDZ; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VdAIzgDZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754516648; x=1786052648;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=T5njk0PrvsNOxFwMUbDcCNAZjhFcEui+FezyE33X+6Y=;
  b=VdAIzgDZ0OX2z6PD7EgG/P1F1V4UKnvvjys6CPpXm7w3TWFFNWy/2s1a
   NM63ljsHNMzi9c/3mfsJYHrz29cPSTpN2kdgzxGoyC4NfN23Yj6YPyxnX
   u37Dy9szT5bZi306OnqtKrfCUEw2+H9V/RJyZ4SHiFShViIDEHf4Mnxjk
   Lw8pI8wcHYOHyqFWeVbN0AlERNfDfaeTWFl52zaPvEGmh4SxTrYB3KboK
   qLa4WpAAViUch4DPzlvDp0KLghavQE24dlCTE+0rkHYTURaB1a6rwHd1z
   H1i8l89ri0MDAgn3t9hOGeGqp9pX4JB7goFyvNRIWS5POrzya55fcPu6H
   w==;
X-CSE-ConnectionGUID: TKDwEUFLTJWjvJSmWhzAFw==
X-CSE-MsgGUID: iQLMO3JbQM2WKkjOn7sf8Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="60477243"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="60477243"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 14:44:08 -0700
X-CSE-ConnectionGUID: NqyNlyGlRWWtJKeIbSx9kA==
X-CSE-MsgGUID: Tl9vFn7kTjWZfB/sVHOz3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="170150702"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 14:44:08 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 6 Aug 2025 14:44:07 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 6 Aug 2025 14:44:07 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.49) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 6 Aug 2025 14:44:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YW+J4ApqA8SRwxoofD7Zz/mp8BSQG/no47HRsu/44cFDah0Mpa0Yhjy4nwTxKvN04VEObIZd3SuYC+VshVhbYH1Bpy31rdLG3L0RgawgR1YkFW0OZ3qg2xC1XaNhRdmgjC6qXgqm9lfnAzKiXgKMRScKvR9Rvm6aw7cM7aJupj1gqolRRNpDp0bpLVWAU8ePvUr9VkkJdIchqZ7QoXsbMwTsO06Kh3tIJAglteHBJ/tWK8i8/ecETYlZU4Ae39nmOJBfgeEbYJMKIhIJY0OgN7UDXCw2qQds5EavqG7WJ/Ox/dUK5fn/0hC4vz5VD6ELKkEKjO9CfGTgnf9J07MEJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yUn9sNutFTxtKMgd+KOLzz9hQfVAN4nX2M4fr+tOYfw=;
 b=B+ZbvyFBOV3nUcLgDLMAQ3qA9LoZ49+K/HhLm8lotc2E9XOPv24XpwGFP+tgFcpNPLxb8RVM1/epfgx0M0Fz2yorzRsW3W6EM4NfdHQaRhgYX+I5WswWIxVDqj4vASLMX1sDp2FMSzpczaPcb463V4B3MtlENK2DQhobtG3uDM/3n7hjiaZHn7JsMK0YMU4kYEa23FgEePMHjbQIUZeQSgIPYtbOY5HuxIvOXMbvI5pcAi/+UvwzVd+cmfLW/m/0LUaM0IOj8K7zFxQyjAHBwE6XZUQKy5dGBwGHgFnIMhwNpFpb7YZHXx1scOG4oBvsjj3vYp60Ekwlqid/vHH6wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA2PR11MB4842.namprd11.prod.outlook.com (2603:10b6:806:f8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Wed, 6 Aug
 2025 21:44:05 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::4e89:bb6b:bb46:4808]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::4e89:bb6b:bb46:4808%5]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 21:44:05 +0000
Date: Wed, 6 Aug 2025 14:44:01 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <marc.herbert@linux.intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <dave.jiang@intel.com>
Subject: Re: [ndctl PATCH 2/3] test/common: move err() function at the top
Message-ID: <aJPMoabv2omytz66@aschofie-mobl2.lan>
References: <20250724221323.365191-1-marc.herbert@linux.intel.com>
 <20250724221323.365191-3-marc.herbert@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250724221323.365191-3-marc.herbert@linux.intel.com>
X-ClientProxiedBy: SJ0PR05CA0175.namprd05.prod.outlook.com
 (2603:10b6:a03:339::30) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA2PR11MB4842:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bb6b67f-7bee-4823-6bcf-08ddd5325d80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?IDf7muC2wkJwkmvnvBQZmuDf3hmHgGABTOafhruai18Y5QCPyjnPHBFKXU1z?=
 =?us-ascii?Q?QaaO/8afbml7e3YlKemjwPsD/p9zvWOija28Dwfc9/oxyj8WEj0L/dbgmfWO?=
 =?us-ascii?Q?AvXBzJPmKbIIKS1mE+tPNPfPAKqI3oA+00MTDwl7WjNszRy9jEcxL2dT2UpS?=
 =?us-ascii?Q?FjIHVr1hOGH55K+Wuw52WxoFoSD/7bq6V8QyGhyF+EvTKxs3sqixXF06l5uH?=
 =?us-ascii?Q?+ERG2itcRIlMwisWPBgITq+RwHY/jn0Zi1ITPvicXyutNNgvMYJjNjE7tNGH?=
 =?us-ascii?Q?CA3lkjxa4i+FHAPKd8s4SlMmG4vMhoPBguKmwKavHs6JETFxutzlap1NR0i6?=
 =?us-ascii?Q?XKLrgcW4lWEBqHyec1Ty7+T5HFoxZUJy9+CNhg8n9nUrlULWLvMETSOWILdC?=
 =?us-ascii?Q?9fGW2jQ/kd5I+sF6aYP+qGT2Km1OMM+psfmLfLdDMIgXR4TRXcp2eyLDKPIm?=
 =?us-ascii?Q?rBWJb9FrliubmCuiQXNrOIYjQ5rEmz1v9DSXuT3TWBvf58M45kgpGisQFt2T?=
 =?us-ascii?Q?4bwk/LUcG7RGpGOOrIvArhbAiJIawYL7VG0z2QH9dMJJ2uwLj4aPPTone7rW?=
 =?us-ascii?Q?QzfTDO9DCm1F9ftis03irYYdBKPhbnbC0CdQHp3j4O54DK7Wj7fi4JhZShRs?=
 =?us-ascii?Q?RLfMGGotq4q8y7VgDRqCDxmIRmagrPaq0C2bsG+ubGL8T8RntJG2RGAU/2nx?=
 =?us-ascii?Q?S2V5bDfdhnxg/RlmyRH96aygrTh/qv1P7tJFM/GtVb7w3ENpFZ7Vvta5feTm?=
 =?us-ascii?Q?GBGb7pTlOqp2nVzys4AUGNmhpvscGuIaOnG1BRuswkCfbpklzjHAdCtwa2H8?=
 =?us-ascii?Q?M8GVQQyqiK7/+9vVXYHXX09qcT5N/Aw2i7lybIRoh1Znad4ATjJqz2PtNm4+?=
 =?us-ascii?Q?6eOQBAW+1L7ompfqI1wQ7Je5XFn5J+lH/G56L1MLLEw+SzpZZQd23o1jeuQm?=
 =?us-ascii?Q?0vp+LSlUZuXQTdhWbpXvxs+XIhr73udzxlVCprfOYvNFr8gD5/Heu7Ig9NmT?=
 =?us-ascii?Q?6oSmEdj7mtHSQYXOxyofz+l+bN1H3yZNkuo5mCmAto04BOEb9WJxkCzQ9Zp0?=
 =?us-ascii?Q?GiLKaAdhQjlPeejIszDI4HYClKd2dIy79dKU9jre8q2T1Tg7LzqoC7xIrzwk?=
 =?us-ascii?Q?mL4792aCI3PKVgEHjUo/Hpr+URQt6VES13lES6aYn+UOLQ8SwFsVrNfY/gPu?=
 =?us-ascii?Q?eYGWMybnLtwrMJcUuJH2U69CQDZ+hRvlttrdlziROw4xWjT3MRPykQdJTO7+?=
 =?us-ascii?Q?0ym9P9+2lARbT+lj4+XAQFmaVwTvQR01nEl4Sb6kZ1a5FwIVeMYmc1ftPozm?=
 =?us-ascii?Q?GfmTts1eMvRs7vY5vk9eb2sVkx1zZb9TyJbq9E6EO58jhaNPkNW/H+ieR07m?=
 =?us-ascii?Q?0gb0DpA4RT4CLJZ7VNOG5h2vqOHLKrn07yFVCOzUDkeex+B0eBd6UG5BZK/k?=
 =?us-ascii?Q?znNPzu2KqNo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h6/nWNsXueM4egUgNif+l+2YvEsOY1y1YNleU529FZkPRcfbbrDifM3R3Dmd?=
 =?us-ascii?Q?1jFwHCXFw6Y/JwrBnJeY/PTkQGsvrj8fqE8b4Zw7bU0OnhSGGOlFr57o95C5?=
 =?us-ascii?Q?Ks3oDWIEg7O2RNutqpBG/7vahf2uwOp7JEzhpeOErUPIDmivCc9M8TvfgiNE?=
 =?us-ascii?Q?6fpHY6JrwsjP8rIyRqEI2WjTFIw+tXEUTwma7l8JHDUzBL6F2wZ3AE6c9rDb?=
 =?us-ascii?Q?sbqoHqCwacFrSsfsS0dQGY4DpkuMiD+PmAjJENAZoJ4tGU5z7E04dPyWmB4r?=
 =?us-ascii?Q?ksm5x2qI8j7YdhOeLN9JGaxeSaUgihBVohp7CFG7P6+QTpOcYnM2kOpukWVZ?=
 =?us-ascii?Q?0Qxgno0W9Ba7jiGHHT/g+Iz9L6xZ9WW5p6KXWqqLL5jDcMFzF7NnGyolsei/?=
 =?us-ascii?Q?r/z2ApdxI2Zw8UD2K1fJ0y7ZBJ1K4WQ9J6EKrSoLYC7SOLT9RTxHVoyGMKEj?=
 =?us-ascii?Q?tNfAKWGTB0beXjcvPRgNJkRnST8JmyqqP9+G0Q43jWwXu8RLIhx35XwUZm6y?=
 =?us-ascii?Q?P3HLUyIKuQzpopcPAbz0ES1Ej/XBupdzP7GoOnpbRSHnLS4xlB0DGN+15TNB?=
 =?us-ascii?Q?Ahz5XTKf+PoG9xGZMsVFPgwuhdia0Xog1U3jQSJlMQQ7d2d6rX4UQ8RSiRaI?=
 =?us-ascii?Q?MyXGlpny2s1cwwOTPC4URkt06R5txDd2P80lDVge4+5JWfS3os2AA0GUWJdi?=
 =?us-ascii?Q?mrjoWifMTkpVSLBJXz1CC4PCPTco/9Ws2ZsY8zSYOPgULXVsjsxVvg9WIV/C?=
 =?us-ascii?Q?ND0k43hAtpkU0hQ/+8K3TcZoo7bVhBYdvpWTW8HBkZBLJ1dQLlmH0ZxDWC/h?=
 =?us-ascii?Q?+mqOEXCeU72KVSuRO7DyPIinyOT2wGaIgvK6/ipWRAQCTOxgzprlUsQn4Sf1?=
 =?us-ascii?Q?BO4G+CgnQsDY7eOeNxkPOY+Lzhi02gr0NdRuqdVZ1jOY9Twm6HFyWsTxbKST?=
 =?us-ascii?Q?jcVAal/brJuTd3LE7AoikuVm3l0q55ge5ldzB0SamCySlmmaqutOAKsceFbf?=
 =?us-ascii?Q?c/sPLvPrfFDwbtdbfZhpxrcQBcHl73xF2ULq7LNtxRwte2fQkcFZj423P31W?=
 =?us-ascii?Q?LRlcdDjNKso6o7BpkGwKFdB5OsTvPy5dQi1U8ys4A6B6MEad0tLpaf/jf0Cu?=
 =?us-ascii?Q?HKb4Gb+LpNTSp/hWphHzOQkbyjn3h3LISXfmM9zmOLD7o3lCDmwJgdeXMrdY?=
 =?us-ascii?Q?bRaGbH19sYgoMaXUSm90O2hVfQsg96D6Wi9RkCQkl9UD61C7/o0S0tdzzxdS?=
 =?us-ascii?Q?8Tq1HNNg2GgAdqK00egofA+tFwuVgLw+nJciZ3UEqHj3CGaUuI3iL5EQjFw/?=
 =?us-ascii?Q?IpjK3HK3w9CvLIBr1a1qI4ZIp+KZUxFyPJjldNTM6WMZbhKJ1dOO14It1ENY?=
 =?us-ascii?Q?1Cfm+dpXtooruHnjA4Njh/kGQvfv8g+kgSpEYfR+WW1vkmdBhBvcVjIkFceU?=
 =?us-ascii?Q?NaKhIy12ysi1wQYubzAU2BNCSXICuD54Fg4AROdWFZWvoMUD6piCghod1XTM?=
 =?us-ascii?Q?Z2hmWXHTErAZtsHappm3WlPvngDUmzx/xoOP9/Kq7bBXUpdOowmGvnG8TDZE?=
 =?us-ascii?Q?jqxVnM1pj3rw7k3IS3juIU0jW8BdDx0N1zv9EELcdvR0qiMoVNtJcFYZL4XV?=
 =?us-ascii?Q?0A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bb6b67f-7bee-4823-6bcf-08ddd5325d80
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 21:44:05.2178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ITKjc5ka7K6szxcM7BZ3yKC3JkaFiSQeV+zLwayD7OHELIRShhOtyPLdu3x2QUQJfmMdjjuS4bFvBRmFpw3RzMGUZnjwNX1Hun+QqbRkyCo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4842
X-OriginatorOrg: intel.com

On Thu, Jul 24, 2025 at 10:00:45PM +0000, marc.herbert@linux.intel.com wrote:
> From: Marc Herbert <marc.herbert@linux.intel.com>
> 
> move err() function at the top so we can fail early. err() does not have
> any dependency so it can be first.
> 
> Signed-off-by: Marc Herbert <marc.herbert@linux.intel.com>

Thanks!
Applied to https://github.com/pmem/ndctl/commits/pending/
with [alison: edit commit message and log]

> ---
>  test/common | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/test/common b/test/common
> index 2d8422f26436..2d076402ef7c 100644
> --- a/test/common
> +++ b/test/common
> @@ -1,6 +1,20 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # Copyright (C) 2018, FUJITSU LIMITED. All rights reserved.
>  
> +# err
> +# $1: line number which error detected
> +# $2: cleanup function (optional)
> +#
> +
> +test_basename=$(basename "$0")
> +
> +err()
> +{
> +	echo test/"$test_basename": failed at line "$1"
> +	[ -n "$2" ] && "$2"
> +	exit "$rc"
> +}
> +
>  # Global variables
>  
>  # NDCTL
> @@ -53,17 +67,6 @@ E820_BUS="e820"
>  
>  # Functions
>  
> -# err
> -# $1: line number which error detected
> -# $2: cleanup function (optional)
> -#
> -err()
> -{
> -	echo test/$(basename $0): failed at line $1
> -	[ -n "$2" ] && "$2"
> -	exit $rc
> -}
> -
>  reset()
>  {
>  	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
> -- 
> 2.50.1
> 
