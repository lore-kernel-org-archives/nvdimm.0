Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A23D25A2A2
	for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 00:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792111882; cv=fail; b=rRQnMLjciDOAYmwP8t0QeOs+RzeXwVACRe6uMK07X2g/qTbV7xVScnkCnAal4PGUWX+MXgbaDvJ3eice/pPl5MHzCZ3CnG4hrtTNR2+OJYJafLXgqgGIr9i694DaZyTeX0GovfkPAIOIlcBP4oK7hP0HHAwosJQ3iRAIWdf4UVw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792111882; c=relaxed/simple;
	bh=qVEj/S4myFIFDabZGx6ajsUGFtWes/52J1V+Tw4kUUk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KA7oROd+MGC0C7omBRIG+ew+1H3SaZVaIzZjqvwXO8iz0XlNGQlrI9HNnfj8wRnp+JH8ikapAjXUHGGd5BKTYeyB+wt8zHYnJvCVr9He3tR5RNdzEki0cVlJkmEMWGmcAPHuk8fgIvG/SXQirzUWn2oi8vSK4OtM75BSpaSJXXc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WYzrb40R; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WYzrb40R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792111881; x=1823647881;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qVEj/S4myFIFDabZGx6ajsUGFtWes/52J1V+Tw4kUUk=;
  b=WYzrb40RFK7FgH9cIQVeMoo6uaVs2SgqzsMktT3qxWtnuc9o8tQHo34O
   3m2FhdM9/540sFiI5M7ZsjcyXx29LGEOBXQq9oUewChKpwwas+VhvHBJw
   cX0HSq/2w9T7+ywu7ZH9CBoCkrLhlraEPTcc03Lrd1DtB81DJTalQ4xHF
   p5E8sNyGw4ZupV6D+zETpVDz2G+Tayo1DqH7A5aAj0YFwY0yqD7KlH4cx
   eOM0FR4L3nKNUqWY4eQ1voDnzvupXpyK0DypXA8apQMj4TTMkhPfbejbL
   MflM9bZ41Cy3gA2E+4wsO4iuzqM5nnVPFbZR7eeDZGtDeHjRs7Kpm7wWo
   g==;
X-CSE-ConnectionGUID: rLO+j9Z2SQqXHbyVL3258g==
X-CSE-MsgGUID: jScV1bQeSci0TP8luYDP4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11936"; a="905460"
X-IronPort-AV: E=Sophos;i="6.27,160,1787036400"; 
   d="scan'208";a="905460"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 17:51:20 -0700
X-CSE-ConnectionGUID: a+OTlvR6Qr6ZPC8Hvkm92A==
X-CSE-MsgGUID: 71dsQsV8R6iX4V8hrk1ClQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,160,1787036400"; 
   d="scan'208";a="1799851"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 17:51:19 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 15 Oct 2026 17:51:18 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Thu, 15 Oct 2026 17:51:18 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.4) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 15 Oct 2026 17:51:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G/IBOeFSpqHyxS1lSvM0UrNtacahdplOeqGz0/rSm1ZL+bhPYDQFFYCe6A/W2sF0S4RsTxt2z3bP/0uYSOCm+nTeOT9Rptb+9kuUi14/08LmNmghy+ke27NnF/3r3H1HKNbjzAJWLZx7zXneRYdopIx3f1Xf487CwCQ/yVQZWqigjLDiO20aXzKoDdApiC7kSDVdD4TAWndZDLP/zcCjBvAGS8xNVN2tnWlUdmQ1Nr5EeyVlLy9S3/g1xd1sxsiZEnnA6HcGaQxSaNol6MhhLwWUxrxvboOwbzAVySg4548RqGXXkr6d+QjHWqftTIACY+l77ElawgVQcoOZTIV0XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cZz9MHwzYor66WvVHlNmu43KjstMS4YP2UF0koPouUM=;
 b=XazRBBF1Em+jkjSrEguIcgKZahb0Zcug525UHwiNTPzILUn7i0C8EJkdqSm30054KT1VAio4p6ySNydVawCSr/2Xf12AkaxNKdSQtt5xNZJNDmpC80Thg9puFY+yUHLtF2NdhKhpwRNtqh8J7F/IargvMV5ZjGbRJDRUz0qck3X8LQWmZkNG3BI/4zfqQ6e79ggAdUd1VLpG3n7uUeJYo/xqw+W9BiEdyy7EzNkiWvLZn0fx4bqNr/6eR7tQsscA0a42s7cJi2tnKBsCH+WBCdSRPn4GmDp+6GNAQ2yQDGBdJege8LIAeSPg2D2olZW03+oUz+J7SUoBPwmuE2vMTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Fri, 16 Oct
 2026 00:51:17 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0522.013; Fri, 16 Oct 2026
 00:51:16 +0000
Date: Thu, 15 Oct 2026 17:51:13 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <jianyungao89@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
	<jack@suse.cz>, Dan Williams <djbw@kernel.org>, Matthew Wilcox
	<willy@infradead.org>, Goldwyn Rodrigues <rgoldwyn@suse.com>, "Darrick J.
 Wong" <djwong@kernel.org>, Shiyang Ruan <ruansy.fnst@fujitsu.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "open list:FILESYSTEMS (VFS and
 infrastructure)" <linux-fsdevel@vger.kernel.org>, "open list:FILESYSTEM
 DIRECT ACCESS (DAX)" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v2] dax: fix dax_range_compare_iter() to use correct size
 and address offset
Message-ID: <atF1AdT5tF2qWt4T@aschofie-mobl2.lan>
References: <20261011064840.1296-1-jianyungao89@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261011064840.1296-1-jianyungao89@gmail.com>
X-ClientProxiedBy: SJ0PR03CA0272.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::7) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|BL1PR11MB5271:EE_
X-MS-Office365-Filtering-Correlation-Id: a5459f4a-794f-4461-a3f5-08df2b1f95cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|261009223027099003|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: iHfvHFJj1ooIrD6rveC9KCASGKq3Lv8nutmPuwkVT8LV+bz+yyD1ItOpk9vdBBGhOdmSxPgNYEqTAnbLqQLLmlWK08llc4tqjsEd/0iwTsmqigFfFdzUGd2tXK5VLIj8iyVxPjfUXQhjSM2ehzuceU9u61b/LNnrPOJzqEPsJtjgpy+VUXLk8atTI31Eo3gCqSoyiFZ+g6BjVThZsebpX1f2/+4FT7ps5aDYzc9TQtzBurva27VX05BzdIgg+/Mv3h2/NNv+G4voLaKdL/uOYYu1kxqHeJauLmZQ57vjTNesLfPkB6lyiQ5HxYQIa6xZ8rK9CwgnfLq/7yy/vwyRMhXC25MNISkwhQ8mQuDolKqOWIAd9IvFwDWfa+CKxj8eZwO8y/9l+V3R1VUtU+zhtxanZjCEeIj/rh/ok2LPuk5gn1ydC7w7zNDUqC475DU9a6vGIsxjp47Oto6fK3OHCIhvlk+nJ3BD6LFl9iudQl1XP+3I1gILZ1uDOqxByshazhq+5igzVtLAc7N2N4Uo3bcLRtgnhivbJCwgVih2ZupeYGL+ZO4Ou8ldFreISmaqwiJoNxKCgWmSs29hR//x8yoDdJjz+V3Sp9X9fzjNtzH4R0nZ2Vf8V/2LSI+XZoTL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(261009223027099003)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iUNoiA3BrE+LRpXDJxhbCwtkftYAYTFdmmIQpqIKfHknCYODfOHKdKMd4wwR?=
 =?us-ascii?Q?nGiQg6lLf60JbqIZDR9r3zV05LTBv6nBQbil3MLSOXnZmjRRyF9O9ceVsVIR?=
 =?us-ascii?Q?BPeOnFTt9PpWLSEorXdUpp2ps0A/dJunHjqSVM/VUb+Wizx8gSLcv3w/BfNZ?=
 =?us-ascii?Q?XP2cN1HHvXg3mwMtiP0rFn+he8MXaai4C0rHEv0mgQWISKKIQPDJ/mfJdIZK?=
 =?us-ascii?Q?EPJv7erPNUc/Ytfd41ShXYFN8jCuWmL+tlwMg7pJucliovY93+UkrnHexu1q?=
 =?us-ascii?Q?Xrf+VP2mknyTH1jSWikI/uVcW+0TxvSFe3KAM4dvSJb3jvPHD3pDhF+TapZw?=
 =?us-ascii?Q?EpGMuJw1PtFGZ/pFrzq1ekWo7Ea9hCiNDgMAVfkFjYuuz1fPI6gjzrBVubDU?=
 =?us-ascii?Q?OOSYUgHzZYPnkrjU3eR/ia597MP8IGU642LfcUlbzuRFtThrXNph/2iHIRSI?=
 =?us-ascii?Q?0nLXopwkSi8HZwMGpfFHKdDEsFlxaGxmgVoNAoifXiKuL/fO613zSpgtvd3m?=
 =?us-ascii?Q?HSdCx/OmXGdn9zWDben9MJ7dIBmqGoErDc2R+jQt+beSSUzZMzgHlDXSTPmY?=
 =?us-ascii?Q?peIqNl1A/b1ObIPs4LxCsHq0hlLD0mAyQF7FJptuI05MP3lH+kT7k3Srhf/I?=
 =?us-ascii?Q?QjZ+lVjuR67ubc73FdfJl703s+gj+5YJRfwLPso76izQp4MwS519NUdadndb?=
 =?us-ascii?Q?DxI3H30FOW6WEmKpabnm4Rm38K02pjCowOG7H/0jaLYKSPmV+AQ47D44mheg?=
 =?us-ascii?Q?dop3xhlGZ4wMBjJ/w9iLvELKMYG9BXBoUXpcRrY+TgIl6RTO1F8n14Vm2wpP?=
 =?us-ascii?Q?PGxW9mcpXfoUIJBM2h9QxI5Vy374ERkxgs8iZ75Sg+crFUCBbCYJo86SblMu?=
 =?us-ascii?Q?g8b83i5tHj2pSP77VPifhbc20KVEEVdiFORXjALe34ZN4MoX+UPt27+wqsjN?=
 =?us-ascii?Q?wkTHdfRSCuVl7Ar8qAyqpqiUeBjqVJKMXxKoJqeVY3QQgY3OxGraozILwttH?=
 =?us-ascii?Q?YMx862qYWZ0ZfxObJw8kz7P4MEWyE/XdcjrpoPPzZuI2eo8PA+nxM8aPwJ6d?=
 =?us-ascii?Q?WGkSgNjnQJl0SsfPEvd67UMmIkyFJVryomckCqdiVp3nVU+uTVP8MgsC8I0o?=
 =?us-ascii?Q?v8WIxLmz1w6tHjBetmN1/gYC4oYj7UabK419DoGwMVHNlPIjepCwIIR0VuBi?=
 =?us-ascii?Q?3P81AWqTFuWwVr8xTVJEAJPawmntu7KvN62gsZMCcxhPPA+DEWS73nmImm6m?=
 =?us-ascii?Q?yABW5QUARLoNs4rkywt88pKHLFrLEJgfNF1zNaQLHfUnall3ZnRANWD106NR?=
 =?us-ascii?Q?jJIngJoVF1PnZC/8l+/rfr8UWOz7OpanXO7iOecr6EMFYZE+LSDR6EOchs99?=
 =?us-ascii?Q?1GiGCgpcjkpCNIHPQteBmoOuSUACk5R4I1+MKK9jpdIhZ2YxSqq8aP1scvlV?=
 =?us-ascii?Q?Gb/aDDwSDUHmQS4onQkxWnbbRtewgC3XGWsKeEyd9j36VU+7yjSg3V91VHmZ?=
 =?us-ascii?Q?RC2w7gKWnvoSs2NK42N91eXCu25YPuw47/Yl575ADeJPfv7EEyUz86CRM6B/?=
 =?us-ascii?Q?PmKQT4AfWcn5whVpNQH6W0ycze6vJMTmnpthArzclJGCcNjt/EaiBnAgKleE?=
 =?us-ascii?Q?HO3RgIswECARasqoa8rtP0Bj+s+TX1nVrXSKYwMGj7gcV2xR+k/0ywMZH53k?=
 =?us-ascii?Q?1+LTn2Odr4bdHHnuRkAya4AM0cz3BWh614QiJw3NmjctwOOvFl2KqCqoDl+t?=
 =?us-ascii?Q?/zTqOXAzeA=3D=3D?=
X-Exchange-RoutingPolicyChecked: MwpsvhrnpLxaCdcM7iE2L7/tS3a0q3uSeK+cZKhz6mXdMoFnOI/9Qyl+tSkRCPk9RKS3o9IN8Jyt0FuBfJ37TvS8/D/BsEb/44PrdBhxF9w9OrHEDZChGQ1rJQ4Txlx35hYLbGHQYtkVtLj9vjoF763F0C5R41gNpSE+6UgtxRAGSq+34hyzkjk0SKp10m2bxsSPO+D66dDybcuj/Aht9cw2d7uAQYz0ik0tB7qWrqnUm7b9s1N6KkwqGju7tV1E7ZwW/qdoY8wVbF+sZB7+0aTQILSPfhhZiWEC22dP7cMcTWcd/7dP0JZTGI+KB1GPEFhXtZbcARHmPWntAkhrUw==
X-MS-Exchange-CrossTenant-Network-Message-Id: a5459f4a-794f-4461-a3f5-08df2b1f95cf
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 00:51:16.8916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nc+qQ63mmsHbThEeUMBhu2bjjcRmFs6zr4uDN/9W0xqOiCHyuZ/ue7LKc+36uTTp5szGH9wZzgUBsLIRZh7L+KuOvsAgYyZ7gRmhiEU/kxE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5271
X-OriginatorOrg: intel.com

On Sun, Oct 11, 2026 at 02:48:39PM +0800, jianyungao89@gmail.com wrote:
> From: Jianyun Gao <jianyungao89@gmail.com>
> 
> dax_range_compare_iter() has two bugs in how it calls
> dax_iomap_direct_access() and uses the returned addresses:
> 
> 1. The size argument passed to dax_iomap_direct_access() is
>    ALIGN(pos + len, PAGE_SIZE), which is an absolute file offset
>    rather than a length. This causes the underlying dax_direct_access()
>    to request a massively inflated nr_pages via PHYS_PFN(size).
> 
> 2. The addresses returned by dax_iomap_direct_access() are page-aligned
>    starting addresses, but memcmp() compares from saddr/daddr directly
>    without adding the page-in-page offset of pos1/pos2. When pos1/pos2
>    are not page-aligned, this compares the wrong data.
> 
> Fix the size by computing ALIGN(len + offset_in_page(pos), PAGE_SIZE),
> matching the pattern used in dax_iomap_copy_around(). Fix the address
> by adding offset_in_page(pos1)/offset_in_page(pos2) to saddr/daddr in
> the memcmp() call.


Applied to libnvdimm-for-next:
https://git.kernel.org/nvdimm/nvdimm/c/a4bfbfb4e98a


> 
> Fixes: 6f7db3894ae2 ("fsdax: dedup file range to use a compare function")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
> ---
> 
> Changes in v2:
> - Add offset_in_page(pos1)/offset_in_page(pos2) to the saddr/daddr
>   arguments in memcmp() to fix the page-in-page offset issue pointed
>   out in the v1 review.
> - Use offset_in_page() macro instead of (pos & ~PAGE_MASK) for
>   consistency with the rest of the codebase.
> 
> v1: https://lore.kernel.org/lkml/20261010071453.6028-1-jianyungao89@gmail.com/
> 
>  fs/dax.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 6ba50142eeb2..b08d408418bd 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -2197,6 +2197,7 @@ static int dax_range_compare_iter(struct iomap_iter *it_src,
>  	const struct iomap *dmap = &it_dest->iomap;
>  	loff_t pos1 = it_src->pos, pos2 = it_dest->pos;
>  	void *saddr, *daddr;
> +	size_t size1, size2;
>  	int id, ret;
>  
>  	len = min(len, min(smap->length, dmap->length));
> @@ -2212,17 +2213,18 @@ static int dax_range_compare_iter(struct iomap_iter *it_src,
>  	}
>  
>  	id = dax_read_lock();
> -	ret = dax_iomap_direct_access(smap, pos1, ALIGN(pos1 + len, PAGE_SIZE),
> -				      &saddr, NULL);
> +	size1 = ALIGN(len + offset_in_page(pos1), PAGE_SIZE);
> +	ret = dax_iomap_direct_access(smap, pos1, size1, &saddr, NULL);
>  	if (ret < 0)
>  		goto out_unlock;
>  
> -	ret = dax_iomap_direct_access(dmap, pos2, ALIGN(pos2 + len, PAGE_SIZE),
> -				      &daddr, NULL);
> +	size2 = ALIGN(len + offset_in_page(pos2), PAGE_SIZE);
> +	ret = dax_iomap_direct_access(dmap, pos2, size2, &daddr, NULL);
>  	if (ret < 0)
>  		goto out_unlock;
>  
> -	*same = !memcmp(saddr, daddr, len);
> +	*same = !memcmp(saddr + offset_in_page(pos1),
> +			daddr + offset_in_page(pos2), len);
>  	if (!*same)
>  		len = 0;
>  	dax_read_unlock(id);
> -- 
> 2.34.1
> 
> 
