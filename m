Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9518D20E332
	for <nvdimm@lists.linux.dev>; Fri, 16 May 2025 21:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747431435; cv=fail; b=Df0YCA+nJoWq0YoEXFOK7rQz1cmRL31InsbKbJ3dd8r2qV1kiiCUC8G3caU5x10TsrGH4uxjbNblLKd3YwwyIzelNZEJzgYp1Cnz+t8L/kRbY62YYePQwz7e8GswAzxW4mo4BvClduZj4R2daBUzZQfNWQc7GErgxYs2OESdT/I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747431435; c=relaxed/simple;
	bh=ot6Nza2GyojpH2rOcX80MfnuRKMB+jxJQxUM7jvJ0ow=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cPYP9H1uYF7+XXco2mXSU1Y+8R9RgGq777GjKFTMkg6GRgJV6miLERGoRETIubsGWfKVz32kUrQteXuwnIuIr1AK/HYgrHDPGpVEgCprtDGFCgdjs0KApM9HnuLMT+GEkEpKFc3D7fXYFs3AFt++CT30wWoLU/E8xVMDG1coCqE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ckMxEt9X; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ckMxEt9X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747431433; x=1778967433;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ot6Nza2GyojpH2rOcX80MfnuRKMB+jxJQxUM7jvJ0ow=;
  b=ckMxEt9Xv5/VUR1lWN0EAPH5ud51vYW/SAJ+KMamI8riAj0cmTs/I9HE
   ewrDlngZgGEkyT5NKUZHHIS+FJeBUlCX9KYN4C9x5pzHeNl1eYUM7ow7n
   l3plJrHI3G2Xph3A39nEMEoOBTpTI/dQ3R7DtZ1+LrzZ7EpWy30WjGBrk
   F4u/kIzvjyBPaEe5se3UKhQz9FFrmkhYDE8sJ9SF6V6v3pt86Jeh1azTp
   3FkBuAeUhoOJg0mUz2lg777ls2NvWcDSl4cxL+rr/VhlWLELs1NLvjTYK
   AMFUzOxmSSQTTOHFIoxp2zyrNqbnH80NDkKR/ChgunCt/Vpq/K567pTHW
   g==;
X-CSE-ConnectionGUID: pNCPbHo0Slqac1vMmltyWg==
X-CSE-MsgGUID: muIJ+ZNKTxq7Wng9inh6xQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11435"; a="59645171"
X-IronPort-AV: E=Sophos;i="6.15,295,1739865600"; 
   d="scan'208";a="59645171"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 14:37:13 -0700
X-CSE-ConnectionGUID: PH0JB6EySc2syo9UMJ11OQ==
X-CSE-MsgGUID: X9j1KDsvQ5yb0FxzP/XseA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,295,1739865600"; 
   d="scan'208";a="139296958"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 14:37:12 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 16 May 2025 14:37:11 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 16 May 2025 14:37:11 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 16 May 2025 14:37:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k45ZeQmHnrfsV3aixsbxpGURQUA2zjkAN+tKTs5HKbNITvw8Lq/kaytUr/idDw8V7esvCSkRCrdsYl7Dixsq0u5U5XHjCt1V3kRjPepy2y/QrvjEClNihoO5oqRkYsllwtJdrKRfrkh+vj7m7u7/mJo93u7qB/tZjtWRSkk2X1BWW2YwfLYDK3ub92AODYNdY0f7mjRJ8h8Qzly8aftSsE3Nx1WtKdTRPz2UYUQrGTl5VzNMlGwsux2pEoRnB2Wefy6mlZLwE9bi6OrcOlZaSOdj2n+o6cRBAB7FTb4DTMcfaWl3/AxTKNmfBQEWe+IVoGE91hhedFGWuAouM0WhHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KLdj9NcC5QCxifh+vsvN6ZcMV7/EACziFnQE06xfFTU=;
 b=j/sLgWsRolIZ2g8OCOyv8zeIBcwXdouBtfVVXe3xavkpkJKXhna3cOs0l+I+y7ZT3obMIuFL0WjEgBCi2rca7uDaZtEeibkXny45yzWujBZYp1d47kNRJAkGToeguk8PgibWAPagcw+7gyfljXAkomvhHz/WG5pnCcr4knGrjgC0C7lxsYtN53eRCZe5xTy3zMN9TC1X5oWC7jQ+mOH0l6+pIbGissNloua66412xSjlMm6dnMYKosgNi0Cq5OOIhsT3K+eI7ASGhMN3Lw7PzRBLQ+BT8AeLNqn5hiGxa8ba4U5oIYupDmnsadF49eQAWMoh5Kq2oxiusW0kn/RGUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by IA0PR11MB8355.namprd11.prod.outlook.com (2603:10b6:208:480::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Fri, 16 May
 2025 21:36:55 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8722.027; Fri, 16 May 2025
 21:36:55 +0000
Date: Fri, 16 May 2025 14:36:51 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: ruansy.fnst <ruansy.fnst@fujitsu.com>
CC: <linux-cxl@vger.kernel.org>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <sunfishho12@gmail.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH] test/cxl-xor-region.sh: remove redundant waitting
Message-ID: <aCev83lpHZlsYV1d@aschofie-mobl2.lan>
References: <20250514112003.2150272-1-ruansy.fnst@fujitsu.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250514112003.2150272-1-ruansy.fnst@fujitsu.com>
X-ClientProxiedBy: BY3PR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:a03:254::25) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|IA0PR11MB8355:EE_
X-MS-Office365-Filtering-Correlation-Id: 27706622-3bf9-4aed-3174-08dd94c1c74b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?vsYlI58TZkoVy8puyVQc0vW8wTVoTayE/ENRe31+evz+PLblTxOI+rpsEYiS?=
 =?us-ascii?Q?t3MlapHm0slCppBgtwSdOmkbah9Z05x1fcLiCeiIV3kFxlM8coUJ8Ho4wh18?=
 =?us-ascii?Q?c9STkFngpanHVkE3CnOVnShmuUHrrM5d/0zO+nHgvQNS3o7BG56xb9PvTcXV?=
 =?us-ascii?Q?1vVrO1vqFmP9YY/Wwh5iL8iYhF2VV0EpYt7o2SzI1Q3hwXwK4x+chjyOM7Xz?=
 =?us-ascii?Q?9wrM/vq8CzwkswRfYJQEDuCox6OM8/uZYcnqZLIHk/c1kJ5sQWPpGSweaEcD?=
 =?us-ascii?Q?itwLIbCuNJMlJHw/PNM9BulPw4DP9IIx8kJT7oaSxogjkIYNooA14kGR33SO?=
 =?us-ascii?Q?5nUBlVdYdxvy7EWmFh1K1X6uHSAJN/gqwi2bk3dn+yx5WCsj60fheYEiVxLg?=
 =?us-ascii?Q?e2Orv81liN8LjEFxnRu7kKD+1P4niu9oEpNUDOS96bRizQZjoR4IdTlK4jqv?=
 =?us-ascii?Q?nKhKJM2m1EX5vwXd2/NFbOmCJ4tR0ANyaU+KwE17tCYBhHBYKoAGx/tz+LQL?=
 =?us-ascii?Q?3SyK9o5tlxEVJlDf3zKVg8bGT4IQz3EfukHlEs7nwZcA0EA2gDJ1yuzHnCcf?=
 =?us-ascii?Q?yNZbY+ELKUmIL8owwvwQW0J3TQlivSItqk6SwV3GphDrVWe3ljm5u9e+7XxS?=
 =?us-ascii?Q?bcDN3Fi8CSkt7hYql5xkkyOuH0ESweoWMlMejPNIDG7y70rXVlhreOB2u/Zo?=
 =?us-ascii?Q?ehfwElL+u1LV51q6QUvX1SSlLT/z/B81Xhi9dH16jeo24sAWeec8Vdj244dj?=
 =?us-ascii?Q?ZYHBkcnshEqV1iG0HLraeGkNp/WUGLZUG4mEI6piTmjGL3JFPaElQk0d5jXH?=
 =?us-ascii?Q?noIuq+mEuzQv+c/8L2A4krQmzQLBBkfjSCz1LBrbkboqAp+rP9x+yLwfOU7p?=
 =?us-ascii?Q?IJzu+G4jN0fzkXPBacZ3QajGhBGqxQ4ersqs19oIbBw94ch++iUIfWNFmrUM?=
 =?us-ascii?Q?lVTR2G1KhnbImjiJIR+bHiQe6nd1dhN/UvJdr8OUz2NZQjnDWUGbAmjAKT3B?=
 =?us-ascii?Q?du8E9J3Fl8OmwvT74ExTrFV7S7GzhXZ5/AWq+vEKdrvbaVl30TA5zIvBNLpo?=
 =?us-ascii?Q?dGJBuybdOB/CYUAf8vWJ4qTz7vV1CKlj1dvHBBBwRCki45XVTsDV80uJzKct?=
 =?us-ascii?Q?jTOTQTjVpkyN168fhElTXV8+BJUUS5+nlYJ2mCMxKDoFuOqQUFWRvvcYAabb?=
 =?us-ascii?Q?hsF2snuNvYTAatd4MIZW/+zEN7CfF+rschviPodl1lVz5KQ95k/8qEnGkxbo?=
 =?us-ascii?Q?TBPFLICS8sBD6SQ6zcB/YE9TXKNltdN4bgj4nIPC03z8RSPRFlVl1mJ0LkU0?=
 =?us-ascii?Q?zThl+/sNADJuMWzUWZcITd/H8yLu5EekpJLgUHNhfB0R8kpWmoTvft08qElU?=
 =?us-ascii?Q?Xfh3RrrQo8TWFNWIf8qiGblWbwv3BXSN3j0D1wBbISfUlJCCAw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q0w+701E9GdwG3CW1sOpffg3h/rCICFtUfbNPesEG380DZfihm+OLx/4x2Yq?=
 =?us-ascii?Q?c+yl9nh7ArRexdBigA9Hvszyk/zzJew4QH5fzpSF++7QCJmrWoa1qzSYzqRv?=
 =?us-ascii?Q?FJV4neYfnHH9UVG04l8l4GZQQjBSd/n403O+RtKjxBK598meZyPR9sS6eC4d?=
 =?us-ascii?Q?JpstOxud6xUj8hmKpTwRekqFV0FwB4eIKDsxtbm/dz3NYajzpu+N+G4tMkxG?=
 =?us-ascii?Q?Ktb59x93rUvCGUVRBIlbaO2EORcxPpDfIK3twZw/tHd8aX5TPM0vlpfO+6pp?=
 =?us-ascii?Q?hyiIBM8A64DCzbpFWxRz3vEbKXunnqaiTBovNi/IopEHQuLbchezw7R2gbuE?=
 =?us-ascii?Q?sTJDx6J3BHsizlBqSInB/JEmCd3JpaVAJ3gxNX9DHTmCsJ8MbYJt8sdE+XE1?=
 =?us-ascii?Q?jHAqt9p4EPzYWrveWWoc6i28kcr491+M6CGC7l3P4WBVm5lGTpgUU/m4BHjK?=
 =?us-ascii?Q?WlFSrDbuxjkk2biMOTz/gIQjeMRsPh5jFUh9wfi58ZPCnGzhzHabUjeMYcif?=
 =?us-ascii?Q?PkvTlLyb2w8t+Gsfe/dJa5b0i7TRPdXZ9hLs2g37wdHYDVdVSi2w0aNgqKlY?=
 =?us-ascii?Q?pip/0dACJWUepPB0V3vm6E0TJCgYd34SVgYnAaeRXTHropcHvxz/4JqS7f4A?=
 =?us-ascii?Q?vGT/0NxgC+ngSed8PeFMs86Q7oVzS230CVRmtkob7uymeoSMRhIewUH9oRnJ?=
 =?us-ascii?Q?SGgmUYLQLer4FBxHfT8rcX89Jp6+aC87VeeYfug10jTn5j+9A/Q0hjb5M/bW?=
 =?us-ascii?Q?Qu1L644yl4MRCWOVulWQZJuxj0viRN6tTceOHHiTUaincG9EKMfen54ZY8hz?=
 =?us-ascii?Q?KyOikLBASezUtmXJalohcReB6S44kGYumc6wwjhrkcKf4JmeKrflScr87RKR?=
 =?us-ascii?Q?d23CXC8JcqnkgLbVR9QYgWTAWLHmAVVp8FSh311J+CerqrvYz8vzPUTam0hW?=
 =?us-ascii?Q?n0qrO7IV8HeSCsE3PtnEcuYGLmhlMSNSUJRqbeZZGb0qMNsMZr51flwFIU7p?=
 =?us-ascii?Q?PXquElM0Gkh31qMaB9xOWnKvet1xzTCV1aUj+QartWFGXG7AuogtVESduO0Z?=
 =?us-ascii?Q?mJxn00Uh0ZRooP+RBmXXXPIxKI3nZto+xZoSWUGZqbumrKXP+SudxIsjnsHB?=
 =?us-ascii?Q?mEWDRPkMVmBqE2ctqpsd6KFDd0Pl9FpTqcxD53LW/clvcyAwwb093WRjxYBO?=
 =?us-ascii?Q?6qPBXdIGXgLwQPx32EDU3rGYQuxi5XjjCAvH2DRLqKGR6eVtbz8mAr0SNMQQ?=
 =?us-ascii?Q?u4fbr8Wzx7pQiBvI3MMqll2jbcj1nDVRUzGSBAoHrS3Hbr4oRjLqosUpENnB?=
 =?us-ascii?Q?eaWivf5QppliClj2d9PW3RLfR/5t38RTv4HpSb/+OPVNWlsZcEh6AjO1SN5k?=
 =?us-ascii?Q?5YDK2vVql9MQncYmBQxNiGpjWSUYsqHPkQ6ebsPn1pM8nJXqp0uxPUZoHj0t?=
 =?us-ascii?Q?Y74mvjVcIEKQS6kTkdln21cMjLFgHkMrogOMiY3RLWPmnsnGgHq9veAAGCgR?=
 =?us-ascii?Q?9qPvhcf08F4nve51qkUYdoSLbmufB4x9nL3b4t2gCOxKjc4cu07PStfc4HvM?=
 =?us-ascii?Q?pj47mPLLYUQYR/FFgiEuQMmU4xoeucBolRsm4GqijxKg7FHVDYJ79PVFxqJJ?=
 =?us-ascii?Q?LQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 27706622-3bf9-4aed-3174-08dd94c1c74b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 21:36:55.5133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2PGpxBcUpLjU0DYpzLF67NFlFDuRGMaREICErNFaOzHIshp9Q4X/w5Q0FSkafheZ4y1CRDOBjowbHnp9dxldY+icZSuRJXtFEd2cLBsYh1s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8355
X-OriginatorOrg: intel.com

On Wed, May 14, 2025 at 07:20:03PM +0800, ruansy.fnst wrote:
> From: Ruan Shiyang <ruansy.fnst@fujitsu.com>
> 
> Now that cxl_wait_probe() has been added[1] to wait for udev queue
> empty, the `udevadm settle` here is no longer necessary.
> 
> [1] b231603 cxl/lib: Add cxl_wait_probe()
> 
> Signed-off-by: Ruan Shiyang <ruansy.fnst@fujitsu.com>

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

Hi Ruan, It looks like I snuck this one in right before Dan introduced
udevadm settle and cleaned up all the usages. I'll take this patch as
is. The next time you patch ndctl, do these:

[PATCH] --> [ndctl PATCH]
Send to nvdimm@lists.linux.dev and 'cc linux-cxl@vger.kernel.org
if it's CXL related like this one.

I suggest you resend this udev question in a new email to linux-cxl
list to draw attention. 

Thanks for the patch!

> 
> ===
> Question to Dan:
> 
> I understand how cxl_wait_probe() work, but I have some questions about
> the motivation of adding this function:  Firstly, is it function added
> for simply waiting for new added CXL device been ready before cxl
> command does the actual work?  Just for replacing `udevadm settle`'s
> work?
> 
> Now I am facing a problem that cxl command takes a long time to complete
> when I run it in a udev rule(do some configuration when CXL memdev is
> added).  I found it is caused by this function: waitting for udev
> queue's endding but itself is in the queue.  The cxl_wait_probe()
> function does not seem to allow me to do that.  So, the 2nd question is:
> is it against the spec to run cxl command in a udev rule?
> ====
> ---
>  test/cxl-xor-region.sh | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/test/cxl-xor-region.sh b/test/cxl-xor-region.sh
> index b9e1d79..fb4f9a0 100644
> --- a/test/cxl-xor-region.sh
> +++ b/test/cxl-xor-region.sh
> @@ -14,7 +14,6 @@ check_prereq "jq"
>  
>  modprobe -r cxl_test
>  modprobe cxl_test interleave_arithmetic=1
> -udevadm settle
>  rc=1
>  
>  # THEORY OF OPERATION: Create x1,2,3,4 regions to exercise the XOR math
> -- 
> 2.43.0
> 
> 
