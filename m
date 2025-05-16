Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF16221FDA
	for <nvdimm@lists.linux.dev>; Fri, 16 May 2025 06:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747375811; cv=fail; b=etpf+13TWUy/33POvmA1bUmNa3EASXrc+9FNVwtZG4vyX00n+P24E8ldJspYpXeO/KbhbfwNdFoo/3pjnuzJocZVdbwAUSOf1sjEArPEBSff9BGFo9AStanLHvE65Erxe3e1ylzxbt+eZAF6Dbe58KSUbWCU9w6wEoDmoM9guWw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747375811; c=relaxed/simple;
	bh=hJlDtq3AYo69A4DMIZnQXovCCE0/FQ5BMpSTJ/3imUc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=b78Dl9j0T0youvH/nr5oUp6KsThXI0iMIe0aGtd+Yrc5Ap0gV46oFlRPcYQzDdwzRXDCYsFphBQOgdgk5t8feacow7JzqC/jp7LbuZ8ZxYbBwXYPDRIH9TR3ZgNAcrxoR/2fTCV/LOaSJxDimGra3PJRRo7Y17QiBJFXYCNmQuk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lW9Kirj/; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lW9Kirj/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747375810; x=1778911810;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=hJlDtq3AYo69A4DMIZnQXovCCE0/FQ5BMpSTJ/3imUc=;
  b=lW9Kirj/AjfoqqbAKYpatKvnSEFe3KMQj6pNwJXz25061Q/Gc2BIhCtn
   B+PoCGs8kHRaTEX8vvcFm57uoiAVzla79XfSRTbV2hro2RDjgHhbLZ4CZ
   yIEO4EG9QB/YvRfpDEoU48b82uciW/bg0PXiBQjjVmNzNALwhpaj0AZKF
   cwYJdG7RMW9/s+ueNJ8yD/etG9hmUKsOmaKxrdYVaiACV679exkRNgcxL
   DhUKdLLoCfLRp8aV0EI7dPQaBFXMO6UMVceVVEIyX+seLAGukNuN2RCzo
   YepO72HgNdhg507zEkLcEEPiWp4Q3l8rMTJeNbRPqZQs185C5SDsotIBK
   g==;
X-CSE-ConnectionGUID: AECLKSMpRguPoeztbDI0sg==
X-CSE-MsgGUID: mGKm2eYKTEuauwtN65tifQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="36955346"
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="36955346"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 23:10:09 -0700
X-CSE-ConnectionGUID: oRaKftQPSz2cZ0KDfOtWUQ==
X-CSE-MsgGUID: lntfgB+qSaq9BWMuUVsh2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="169657383"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 23:10:08 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 15 May 2025 23:09:45 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 15 May 2025 23:09:45 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 15 May 2025 23:09:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rfnYcAPyt/h7OFJEVcU/HAwftIBuv5ERWc6ZzsPh4TxciHEHmqQ+bAp5/NfZnfVNXLQK0SDmf/M3pQlfkeCOZvxtLJzQk9Gq/HZgm3yh/aHp5ugAYOM9N+1CG0SKwOUGuf7AjMpH5KOWvpd7UY+xqU2TZkLxhnb0SHeU3q31mCt5Kn4QBi56zqCshvbEpUwQMTMH/DAgMTU/DqPhBSSKUpYWZzvL10nzhe0xq6i9bD+BmH2O1JfWhNmb1Xr/BNPiCseN1okxuGhSZwNuTeUhFUrWnmAnMLNL/SkP+zNvswEpbrkGUpTanfNhIAFV9I9AMqfRcWLTKYl02YTVrcd8FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I3g2XvRoBAuOw2LInxUaYme/2l9Y8IUhE309ANtxvbo=;
 b=BzQu/vRQvySHKcc8sP6g2HGCe5g2o1FEOZHIX3GfzqbN/PFEhlr0Q4W7cqj4aGLRSkOadtwXB7y4YEYF+Mw3i8Kpfi/1iEkWkUpF+afAl8U1J+rRq5Sn7R2NFW8+AK5cAzgGrs2X2UNM+8uB80WWev8Ex3yIjibOZeHPBQtBDAv/09f1Bnaf7cO9hfhbIYDNEukWGrkbhlYFGbE4xjbGGQGavVhd5QvW9KUTH4EvY2g3CVHUsWVHFrbriHUhtYSPc0bZrN3E5h7Ns5KuD4HIPa7dUPJ0yswig0jEIrJQ4YgL/D4vBPWIUtlHC0fxU5sGvmTcNfiwdsEEsxPeIFIgVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS4PPFE396822D5.namprd11.prod.outlook.com (2603:10b6:f:fc02::59) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.31; Fri, 16 May
 2025 06:08:57 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.8722.031; Fri, 16 May 2025
 06:08:57 +0000
Date: Thu, 15 May 2025 23:08:55 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>, Marc Herbert
	<marc.herbert@linux.intel.com>, Li Zhijian <lizhijian@fujitsu.com>
CC: Alison Schofield <alison.schofield@intel.com>
Subject: Re: [ndctl PATCH v2] test/monitor.sh: replace sleep with polling
 after sync
Message-ID: <6826d67768427_290329430@dwillia2-xfh.jf.intel.com.notmuch>
References: <20250516044628.1532939-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250516044628.1532939-1-alison.schofield@intel.com>
X-ClientProxiedBy: BYAPR06CA0065.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::42) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS4PPFE396822D5:EE_
X-MS-Office365-Filtering-Correlation-Id: 703588a2-fcc6-4106-ecfd-08dd944024b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ECDmDMNx4F3LuNtI0gWZYyMhIqMOisXiL2eeJ6yX+fgLi7ZKp01JB7IVCB/9?=
 =?us-ascii?Q?aFQ1NrT4unH4X5m56o26Trs2r2JsIUMwBzgQatrkxSuvGNt21lDYeHe3sLh6?=
 =?us-ascii?Q?m9YkGxPnDtN0I3S275ZVP73g4oTQA6+pmcLQFWHFNFTMGCMhA7mdVXRRa1Ec?=
 =?us-ascii?Q?hSImboY/B/1it9+fQ2CNs2QttPUGRMWjfWYhmtVNzmygWvYguywdFyikzrb+?=
 =?us-ascii?Q?9jS4+tYHU24V/nC9tWK3OsV5Oset2C3lVdcA7ZUZYxJd6kSzN+c0d6M8Yn1Q?=
 =?us-ascii?Q?RjQcsS2eu+kiqmerEOqA3lQxovR0WtbTj4I3jT338wLTyXzZ6mnBxY4UOuYX?=
 =?us-ascii?Q?u9ZqVbT/8MX7du0CR09gwc18LHE91e9Zakm1RhzWhTPX0LP3VDS6kuZKOzZA?=
 =?us-ascii?Q?w4fXT4YM8ixs0Kh0T6xQPrllBCMQRjnjoP6CjL43X5jRDA3LaU3lxAZYv0q7?=
 =?us-ascii?Q?r9z3HMZ/9cy6qTMnG/dclyJEQItPB1VY+Trn1L0hHciCgzaEIOm8roc8npDk?=
 =?us-ascii?Q?nU2hixSct2WruPHsRcxXrWfFEoItajkp6fqSpvHk4pnXWtr6/Q6VK6+FYKNH?=
 =?us-ascii?Q?V8gQA/AiXykbNJTddox8e/NqZCHim0deRe7Tif0QtKoC0jho8Op3Fu6WCw7X?=
 =?us-ascii?Q?v4YKYuia8jqVZvYTE6g8VU/nu65jWQziswdytd2crWes0HvRTK6dj633oJj2?=
 =?us-ascii?Q?vgzguwYI9Aj2w2YzEFL/+ItputGlXj2XaLSGOxnYv/IVfVe/CeIskMN4OVwr?=
 =?us-ascii?Q?MGiCQoCieinqvjsqiNZAkloI4oA843lxduxHChq3efp7THX1JaUtz9yceqwd?=
 =?us-ascii?Q?nFGgojCYAmWa00At8IjkbHK4QjVEqIu9+4v3OU+AOv+G9Ed6gc0mr6MN8oR0?=
 =?us-ascii?Q?Fxl2D+5sMm6PrC39xEvAaBqHQAwUgwSK0i3qEUBbICI19wiJMITy5GZhJPSe?=
 =?us-ascii?Q?S0bssJfLX6jYrZk5b8zrlGHuVx89B0guzmixd3Wz2aKYVlUwUT9p8jFEMS2E?=
 =?us-ascii?Q?gjeXJqRVeuCm5pDCn50HuH08JRlzQdtlxAnCJ/f0MvopKkEVLGr9Pw6WvcFP?=
 =?us-ascii?Q?NlFX2E6tiPgT5xvsdkoAxI1Wji8O3dUWWaPkh6O/8niuEaejkU2Nfn7+MjkI?=
 =?us-ascii?Q?Y747XZ6J7hNeNnLk3fgrMvMLc7TqiABk1kKtRVluUaShKhm8junDEulhIMdQ?=
 =?us-ascii?Q?09cUvNkiqYhqnTVQZTUzOpVTf6pYBHVRDqg2leXwokjdMuZDewqWOAF65Ufv?=
 =?us-ascii?Q?xi8KOZIVfKhxRoySEN8yVf2z9tgI2pljbFirAuLlJjvcEVS9IncfU8UVXsdS?=
 =?us-ascii?Q?yFLfZm9JBrR0Dfi0U0uAYUuD6R/RWg13yylMRNaJst4Y2Xz7cznUqZ73A7vW?=
 =?us-ascii?Q?v/0/UUo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hyA5aBv+cg+JLQ2AiJj/Kv2jxV343ddg/lQuoCeajIog/iykqvza+mMWlvV/?=
 =?us-ascii?Q?YAPbgiu8H+uy4M3qlY8JF4YfBspaB99lRFk2nYMePuzvOm3/q/txqUnvmxVa?=
 =?us-ascii?Q?gO7itCNv6mCp/P+lGGFC3cZhNuHAhE3BJYmkYCa4QG9TKz3q140X68+SaOob?=
 =?us-ascii?Q?N78MPyW8h6K821zBwZOUwl0wt82lZEegdpJthPdJ6+d7IjR3E/UHRLtsW+l8?=
 =?us-ascii?Q?rm4rdzcCnCclzu2O6wmzyEGUr6tYHCsHCr3g1Xi3ECo1HJNOFTV1oz0Xy0MZ?=
 =?us-ascii?Q?F7V/cNkF5WF9/d4bk/RoyD58S1NQ4BUbnV1e2vfpgFNdrGPc2HCP1QjtBEnP?=
 =?us-ascii?Q?9TOb+0hShsDfX47R/ler+zyYyA6uEBIeQwJ296dF0yJjXw33kC+bhhhoXHJ/?=
 =?us-ascii?Q?P8vJr4e5hQ/WR02UYsm2btKkbQy/2rBDEUZcP2JiFddnU5kOVBl3lTPw5zEV?=
 =?us-ascii?Q?Si8+B5X8e2/Ilpb6VUgNMAYEOa5GfNglIJ22fk3qVw/OBV0Fph4IYramMc6i?=
 =?us-ascii?Q?4e4Uw05h7so6I+WOT5VHAHhB5DJJbqhuZzteXUwV8lc+8popQogd4Hgj9QBV?=
 =?us-ascii?Q?kPUks1c44A9YS4CZVLI1Bb/u/zn0r2RZn4WzjgN9sSScUl4Ry2YLL+ENT7KE?=
 =?us-ascii?Q?qwbrf9Oosb1tUaxCayexIBPeEBBEGOpg2NdV9CjQLevc6mWwMhs8/YplvA5h?=
 =?us-ascii?Q?buVRXNebLAj4L3IfYrWp6NUan5RyvfLOPnytLg/xgZnjEzPP1+m3P09K3842?=
 =?us-ascii?Q?EbjQPNux40mbZS6d29nrLQRt/U0Q0BV1rl1NZ8dmVreu85+yFoH77gvCVALb?=
 =?us-ascii?Q?2BcUlocPwkhWcSLo19LGAKyATsefSUVTwJt3pZFw5n4lD/9eebKdoy9TFlWU?=
 =?us-ascii?Q?LWTYIc20Or+0hFhA2C3aUAUsCD5sLkabohblAXshdEHajUf0T09p/wcyrVP0?=
 =?us-ascii?Q?F8g1SYnYhqTnVs4dbpz9TOKghihuJMSTsEqpyunuPBVITeEmgVY636MGRI7u?=
 =?us-ascii?Q?rDAq1NsIy9ppHcMjAx/lDbf/2KemiP0Q3NnJB7NNjoDxBANxAWcnhyz0ZOtq?=
 =?us-ascii?Q?pP83yze0uePPcCRFmewCSUSa1cl2HfXKdwO2CH+w6+SVpzBo7ZQRJQqwlfdW?=
 =?us-ascii?Q?3r0AABsGd6NLtp5qZL5WLNw4/8/MDVFANjqYz5VREUYbdvP/xBdaqQlciO25?=
 =?us-ascii?Q?vk9u64k+hq0d1Nwar3dgAbTwKvJgZ5Xc3pOc4/QBOFwv+NRN3PGhy4aD4tRd?=
 =?us-ascii?Q?pJ8jrYj8xbD7FCJO+hP6fq8xDBHZVx9rbam+7llZ6+s/Fe9Q/5cHUBu1LuJc?=
 =?us-ascii?Q?C6MQ3mC8XsZvM+LrEep7w6zh1KjxaNTHjkGwZ5nlpQlLus5ywNS4uFgp6s/4?=
 =?us-ascii?Q?SkvwP8ILKBQz55RfSUJoo3cJ9JwVUK6CWhKZ+sH9PH3pqgj9tm6XSi8s5SZb?=
 =?us-ascii?Q?nsdwiIahQLKNpzfbWKUtw6EvlEOyPdYhu0l5aYgTZuBPZMsQYOMuEVBgUG8z?=
 =?us-ascii?Q?hKgGdtaILYRBVt0aoZx1gFjNc5j/jGpr8sb/7tKrRpZbJ/X3gOgmXntNgXGl?=
 =?us-ascii?Q?cGXIiRYlQvUFiphuKu41gOyB+WpjNpkk00+Mb0ako9P+LdGIuBSoGUoXEYLV?=
 =?us-ascii?Q?xQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 703588a2-fcc6-4106-ecfd-08dd944024b6
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 06:08:57.3266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yqa2r4KsdVGkSbZehyNQLCmgV85LHrcDPHf4pFogW2GPJ+y5F/JTmLIbFsatYjj3ZWrymNQ4ZNPNtqGJH1O1nx7l/Uvz12lUlE2a0b6UgK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFE396822D5
X-OriginatorOrg: intel.com

alison.schofield@ wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> monitor.sh runs for 50 seconds and spends 48 of those seconds sleeping
> after sync. It sleeps for 3 seconds each time it restarts the monitor,
> and 3 seconds before checking for expected log entries, a total of
> 16 naps.
> 
> Replace the sleeps with polling that waits for a max of 3 seconds but
> does so in 30 0.1 second intervals. This leaves the current behavior
> in place but offers a shorter run time for system configs capable of
> a faster sync.
> 
> Again - I'd like to see some Tested-by's on this one because it wouldn't
> be the first time my golden environment wasn't representative of all
> environments where these tests are run. Thanks!
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
> 
> Changes in v2:
> - Poll for 3 seconds instead of removing sleep entirely (MarcH)
> - Update commit msg & log
> Link to v1: https://lore.kernel.org/nvdimm/20250514014133.1431846-1-alison.schofield@intel.com/
> 
>  test/monitor.sh | 43 ++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 40 insertions(+), 3 deletions(-)
> 
> diff --git a/test/monitor.sh b/test/monitor.sh
> index be8e24d6f3aa..61cad098d87c 100755
> --- a/test/monitor.sh
> +++ b/test/monitor.sh
> @@ -21,12 +21,45 @@ trap 'err $LINENO' ERR
>  
>  check_min_kver "4.15" || do_skip "kernel $KVER may not support monitor service"
>  
> +wait_for_logfile_update()
> +{
> +	local file="$1"
> +	local prev_size="$2"
> +	local timeout=30
> +	local i=0
> +
> +	# prev_size is always zero because start_monitor truncates it.
> +	# Set and check against it anyway to future proof.
> +	while [ $i -lt $timeout ]; do
> +		local new_size=$(stat -c%s "$file" 2>/dev/null || echo 0)
> +		if [ "$new_size" -gt "$prev_size" ]; then
> +			return 0
> +		fi
> +		sleep 0.1
> +		i=$((i+1))
> +	done
> +
> +	echo "logfile not updated within 3 seconds"
> +	err "$LINENO"

Hmm... not a fan of this open coded "wait for file to change" bash
function. This feels like something that a tool can do... (searches)

Does inotifywait fit the bill here?

https://linux.die.net/man/1/inotifywait

> +}
> +
>  start_monitor()
>  {
>  	logfile=$(mktemp)
>  	$NDCTL monitor -c "$monitor_conf" -l "$logfile" $1 &
>  	monitor_pid=$!
> -	sync; sleep 3
> +	sync
> +	for i in {1..30}; do
> +		if ps -p "$monitor_pid" > /dev/null; then
> +			sleep 0.1
> +			break
> +		fi
> +		sleep 0.1
> +	done
> +	if ! ps -p "$monitor_pid" > /dev/null; then
> +		echo "monitor not ready within 3 seconds"
> +		err "$LINENO"
> +	fi

This does not make sense to. The shell got the pid from the launching
the executable. This is effectively testing that bash command execution
works. About the only use I can imagine for this is checking that the
monitor did not die early, but that should be determined by other parts
of the test.
