Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6450D2110E
	for <nvdimm@lists.linux.dev>; Thu, 23 Oct 2025 05:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761196519; cv=fail; b=EXqfdgOwzIqu+9ndX8WwSo0P/QKYseTziCDlHowl3rLOcIVP7OJUaPHRshYwU5p8X5qwbNXCVz6ZOt2ZPnpS2LwrCVuQh3a4ORQDuoudYOIGcG7u4E54KQz+WWchGy4MR7mXBF/+0B1nc7cs1LvPXd57ZBpMyOeBG76lGQVVZvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761196519; c=relaxed/simple;
	bh=+Iym0utuBVmZ1NN8EDaMFZB08iCM72OVCGkPdbHvIHw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sPTWjzv1MIzt6+ajBmqa7h6ezufV38VaaxtBTTqZWOb+u4evKxRWGlkQ6NgBJt6+A90B2aoITB/iLhVvo066x3L356YNxXUOvwKD6Bn+91q94yP5Iw4G1cSKl7762R54VURLqnLVliRseylnGsY3Gk4GMrKtR03fXGsifRGnSzQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dOqZZ1A4; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dOqZZ1A4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761196517; x=1792732517;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+Iym0utuBVmZ1NN8EDaMFZB08iCM72OVCGkPdbHvIHw=;
  b=dOqZZ1A4cPI75cWqIlH20b9oHlDFaDda/CxzrdGKnd7gBAM3EIXmQi+c
   FMuXLbzjDuYt59DxxuFxWvXcS0MHVW0ys7xTiebx7Ezh4XHb0Ibo2tvp1
   VvykW5MY9Ktm/xF8WbSVnT0XZ2TtvQHj3KdjlXRueVVDvGudZ7Pu4kaJK
   UsTKD9Ge4IpL0qC5Fl+kZ18NadAgZAwkoPQojg42sDsDGqeY2VvQYiTMd
   tj2wTrXB4LfEKW8azCNXRoI4U7ByhHAqGuEJUwYepvZ3fb9JwOztM515M
   7kHfbCtCgLWtCJ6rnZlqfPuIo94MgduMyqPhC4Mbkk4agX8SkRl31mcmB
   A==;
X-CSE-ConnectionGUID: gAMo7RYsR2CP2Mikm7sqbg==
X-CSE-MsgGUID: PGXng74ATdeYSHyXV0LHIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="67221192"
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="67221192"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 22:15:16 -0700
X-CSE-ConnectionGUID: 3C3W6sIsSHKqlfkQA2KzuA==
X-CSE-MsgGUID: n3ogoUC0Rhihfhb5HHnuRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="183659574"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 22:15:17 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 22:15:16 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 22 Oct 2025 22:15:16 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.64) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 22:15:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jLEZmWDi56aaUEaNRidx/YJcJe0on6ohJT7U2ZlfIfHiC3OP56udusiJcGX2FEUbYLMo72/HDL7iNdxaYM9b5cmGc5xLwBa0yy4WA5dvGuPJZNOOcKn2oRqtMz6Lz1WMNlZ1zepWN8pywv9Xn/CSiyZGtsDmfF1MoPBXqMfEgpYe2P/udglX0ae2ojOM+wQGaZSffkLMg3Iw9M+mh9vNVgnTbad+QsJAtxrDlVBY+n1SOBD80lODjPixofwCpwSdlLPOUL3dmoCwtBl8MoX3CWy/f94vHBN4vChKT9DU2yjvE6wUrB4MW2kHy6hMHXbKYGK3Xy3Zo5ILw0PAIxPgcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bkpOZWOS7MJOqLtrNGji9QUKHhe8Vnd8/jtJ6Zzwb7A=;
 b=XNYg8s/+ilAysBO69q5x7dDHtSiKR7mW0JXhFjeZpRtPAm1Uu6mcsXfVen1AFWEr4t9rHuVxOeT+7attadtc7BMxeDRGPIOltXOBbXTdGj8TkuNZdXFzVSEd41lxw0UMSZeJubYGrn0vRMbceyThCuuX0V7dZf4zOaJD9hPIB0uyQVC0O3ZarRanhLivec0XQ2fDKw57DfaKLWZpe0tX1TohSYSzGSLdYTcAbDoee/7DkaO0mKN2ObwLjPjG3ySJdO5KvSS/I58CgpPwgVr8bRq9+CG//VN0xh98sJAHKZyBzF3l1AGkTlN2C1z4CBNoo03Ye1vXWo70jgmyMxyclw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SN7PR11MB7137.namprd11.prod.outlook.com (2603:10b6:806:2a0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 05:15:14 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%8]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 05:15:13 +0000
Date: Wed, 22 Oct 2025 22:15:07 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Marc Herbert <marc.herbert@linux.intel.com>
CC: <nvdimm@lists.linux.dev>, Marc Herbert <marc.herbert@intel.com>
Subject: Re: [ndctl PATCH] ndctl/test: fully reset nfit_test in pmem_ns unit
 test
Message-ID: <aPm524Y0hIEOUehg@aschofie-mobl2.lan>
References: <20251021212648.997901-1-alison.schofield@intel.com>
 <a9806830-6ce7-4d1b-a72d-7fa123e8b326@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a9806830-6ce7-4d1b-a72d-7fa123e8b326@linux.intel.com>
X-ClientProxiedBy: BYAPR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::29) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SN7PR11MB7137:EE_
X-MS-Office365-Filtering-Correlation-Id: c3afebfb-17d8-4614-dcb6-08de11f32559
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|13003099007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?thdzADy1OAN/qxTQsk5DRh5LjgY67vLDjA60vb1YDmYHNKQpY6MPlLtobmac?=
 =?us-ascii?Q?Vm0mukF0HuMit31f1EahMmS5KYhzTfoeYhTnN3eNJbk2Ju/nljlUnI2XXMX0?=
 =?us-ascii?Q?eo/sQiOcqY7A3J7DiCqtozZactK+wptLpBOAbbz/6CpQ6J1sGJVz8q8kr1dL?=
 =?us-ascii?Q?ZxRzPL0aef0W0DqrNrZtfbZl8Md+P39sDF32lsScF6OaHWzyJo+iBkZBfPVO?=
 =?us-ascii?Q?1TGmzAkbwZpN2LUhP3QyD7cMnDCruw1oP4pkqYvuTkVRrLWwrE5nmhFmzndY?=
 =?us-ascii?Q?JRM718ow5cVoyi9TNDhFzEXQvBZ83pYjsccvcMkAwV3KWCCDZu3bkIk0UeLL?=
 =?us-ascii?Q?ja5d+hswZ5PAZPw4uJfOlJlFi3LN4oodAou1D9DgWk3yusRBwYIcu0fDFI+j?=
 =?us-ascii?Q?mXOLBjDnT87G6/WBtW+hhyKucLY8GKr8WPYDHBeaNG+OdqKj4QoPfyq9ermv?=
 =?us-ascii?Q?RSBZdxVXgU0OxvuIMfG2yPYJ6uUjBwtf9MisjSsNdMNJwtDFxwQ5ISBE/UxC?=
 =?us-ascii?Q?a69dUKH7FoaQMVMY6uf2jQsWfFwyr4ft3urLeKNwdQPzBWQQY5PaFBlLrhcc?=
 =?us-ascii?Q?tLfqgkFl2kVZ9efRAuHehPyChvc3MVQ/g9c9WGmbyag8iVMA439sWTkF3iVF?=
 =?us-ascii?Q?rX5PmoWgbWMmR0FFBTo437OKPN0pnd9O0yc3708+eT9Z3vwmdj2LfiPD7ZXK?=
 =?us-ascii?Q?2seEPMa5DOeAZhz2+rUW7IJ2Y+UTErFfJw8r1ApNLmD+fCPw6RvnKikz94RN?=
 =?us-ascii?Q?dMUMQzJ3TT6IVf/J5QymISu2Ii8RLx3yMLYrI84Dg0E+8ghDDx4ArgTtfmXI?=
 =?us-ascii?Q?aCkFOvrS99sI34nbV8znjWnvAHwYH3M2ken7qtqtMzQ4QuTo5PauVtfKR5SO?=
 =?us-ascii?Q?dAWzyn9sfVRy+2f60ydDjy1Ri5/ZWIgc+knl9tFjHoJ3VDvL3xUMM4pHXavd?=
 =?us-ascii?Q?92AxdRZiPstk5BrzCOXt6e1fUXPyl6vEW01TAjwGKzv8oD3l2JPttn0HhgAb?=
 =?us-ascii?Q?USEfeEUAE+6tgXsJoQy9Ix3dDu5mN+PS1R7kpm0Qzi/QCbSm7uS7eFn59FgY?=
 =?us-ascii?Q?cN893m3uekKmqTCd8eq6zy6C7pneLgB36+pIMyjAcL1lmU6sg4q6CC3ZCl4H?=
 =?us-ascii?Q?pfQ/25CH+1gYEvTfhc7+JeQWaBNA+TTNJw+gN/5G3d1igCViokp8TfbJHvU/?=
 =?us-ascii?Q?b9/VOYsXuXhaOeRKgN4c0AHhYztKVuZenephu6yW46B5uIxI3gvVo8Wm7Zl4?=
 =?us-ascii?Q?h480/53lgyfJ/ZxuAAD83MrtdKy0mKm5j7VwPtTWJIL8BY/0yEvjadlQh7pO?=
 =?us-ascii?Q?E9dcDBNhQbvuJ47dYjV/u5/1445YnLiz0/1FLCDcwhXgM/rB4YpZR4HPk602?=
 =?us-ascii?Q?/vE+ryXinWWnlJ/afPC/O6PiVA/OlikpPnJz7dTizXf2QH7wb9eiFnP8uAXE?=
 =?us-ascii?Q?EbTKNQx2o3rbcnd6IFycm1LiianFzPjMLfSGHj/p+m2UqWIqJvAEgA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9Mq8g0UV8r8l8WC3GmdXzLY23yykczAvssEaX0EhD/g0dgq7GD2KnGBCNFao?=
 =?us-ascii?Q?TiNezzTqSsYU7pPzDURRb68F65e352cJv7SWk62U8t5zrxxBr3aLiThIEivF?=
 =?us-ascii?Q?z3VyQYSH7HbixysdOh4etA9PilEqtg0CGPAzdoOEd5/7Ory6sPmS8k39enhE?=
 =?us-ascii?Q?8V8Rvq2SuOoTqZ+1lRy/YLuc45mJPTr2z0ak+qL4jjHUQhuMGIRYNtbb4cWi?=
 =?us-ascii?Q?TmLk/kSYOUyQsy3zaK3jboj9gctrOXW3k15EtQjWO4BpW/I3Ko8thGP9Cu75?=
 =?us-ascii?Q?ClPJ4QI7sP11gAVDS2f8Q/SmDP1GFA4JcvklgaH26XZzvxKPefJlkdQrXtW8?=
 =?us-ascii?Q?hlIMQUO6qDfGit51Q3r3R+aFjy9BvathtYOEOVtwrCphRVwhHQYixfJkGR+C?=
 =?us-ascii?Q?lj8CZy0TciMgaVDoa8FXXwdMZo1BHIiN+h3pnbK7U/s9i8P6F3Etas7EecTa?=
 =?us-ascii?Q?taQv3bc+l7Lj0bJ+nM1x2y/odVYo2tXzGBqqaXw5fwzIoUjsbVApnoRb6Ipo?=
 =?us-ascii?Q?/yaumYcCuTuXALT4hyJYhX2y9YG+wTv/5lU7yNnCl+EC0E8bjzrfjNrzaDnZ?=
 =?us-ascii?Q?Hr8Loyv1j03QL1z40+OvZY1mQCh77Gxm7TbyLwrkzuJmq6u1suewf1Mx9iim?=
 =?us-ascii?Q?ddMXCnzNsoxZbtyVr9rv+YAXCSD6TP6lz+fbzlAs01zrXY0t5I7nyhmqwSd9?=
 =?us-ascii?Q?Wb+32pht0UGPlEbnyfk5s9lDKNZbtzJ4NrGSbQwHaBD1XrYplqJEcQTdWzkd?=
 =?us-ascii?Q?0On0HxKYs9cu5cuJAhTCBn0ggk06YqMHxDPzkLL1eV5XSSwpBA2QnrtP/m87?=
 =?us-ascii?Q?Qa5UupbcTEoBxGpxKhWNdzylRD+V1QQG9P7U0kgXTonnc/xSvKe5RqejZoFY?=
 =?us-ascii?Q?fnmZBrkAEd9yfbQJjEYXIezM/Qj6s5vMUs+Kz2x/yFA/ubiksz3GI6s47tfE?=
 =?us-ascii?Q?N9uxtkMCasnOt91OW2UcVBu1pNmkbj6YyyKCaBsYNAxutkAGJsFvWGYDtbM7?=
 =?us-ascii?Q?aodsMbigs58HDvg5qWeBBiJF3HPzOe9d4PBSX8a9ueoDVjGK10CueOgRvOLn?=
 =?us-ascii?Q?cxpJb+FcMckgPF8w7q7QyurV/azSnY3MmxYnAmVCbOhT0LgvpSeM8v0NCMim?=
 =?us-ascii?Q?u6Yg/jyi2FfizRJC01Ws24SbECDqgqB4dlZmNwuaTxgvoGfwnWombGv7BaGr?=
 =?us-ascii?Q?jrsHb/fnXybw3UswyWiPy2vuhcZqImOUeJtRxTS1GtnTI+CvGeiwnqSACSPm?=
 =?us-ascii?Q?yE4qFLJrLykBLDWVabn3aiJP4CpaqfghW+BpMKv7Sln2EPkPwgM21iZaL6cb?=
 =?us-ascii?Q?Ee1TG/vvs/6xYYPnES8Xg97k2eP2eAihNuGSwpCdCamN8CYy6pfqfmA6bRHa?=
 =?us-ascii?Q?NQRpVQSCexNK4CFxM7MFGqfWU89hnopbx39lC9NLl6Z4CPqV8LiiVpkLsZGD?=
 =?us-ascii?Q?ZaP7X/Utg3V7tIRYpEDJI2gEtaBxndBzi/GwcDis/VrI/WwNZHujJ+m917Lp?=
 =?us-ascii?Q?rRsR3jdsnIB0LpaTuyDoagMgxcDw50HQdyoe7NFskangJaa3kUsqDcAtpXVl?=
 =?us-ascii?Q?o8EO+v4FhQtNazMi7H4zdSIv0CRd+LodilsAI0AUtY3ecGPLK9RhuUQD6D2V?=
 =?us-ascii?Q?5Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c3afebfb-17d8-4614-dcb6-08de11f32559
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 05:15:13.8584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pXgqx//NXJQGeDY6ytcIMCqtgJCbGjeewxHXumRDivW5Nwma/gXk8fD3Kcr1H/f1tjSlK4bF+7HpyT1/TAuIyz1w9w0ebO5T/gbql0ZqIqg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7137
X-OriginatorOrg: intel.com

On Wed, Oct 22, 2025 at 11:37:37AM -0700, Marc Herbert wrote:
> On 2025-10-21 14:26, Alison Schofield wrote:
> > The pmem_ns unit test frequently fails when run as part of the full
> > suite, yet passes when executed alone.
> > 
> > [...]
> > > Replace the NULL context parameter when calling ndctl_test_init()
> > with the available ndctl_ctx to ensure pmem_ns can find usable PMEM
> > regions.
> > 
> > Reported-by: Marc Herbert <marc.herbert@intel.com>
> > Closes: https://github.com/pmem/ndctl/issues/290
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > ---
> >  test/pmem_namespaces.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/test/pmem_namespaces.c b/test/pmem_namespaces.c
> > index 4bafff5164c8..7b8de9dcb61d 100644
> > --- a/test/pmem_namespaces.c
> > +++ b/test/pmem_namespaces.c
> > @@ -191,7 +191,7 @@ int test_pmem_namespaces(int log_level, struct ndctl_test *test,
> >  
> >  	if (!bus) {
> >  		fprintf(stderr, "ACPI.NFIT unavailable falling back to nfit_test\n");
> > -		rc = ndctl_test_init(&kmod_ctx, &mod, NULL, log_level, test);
> > +		rc = ndctl_test_init(&kmod_ctx, &mod, ctx, log_level, test);
> >  		ndctl_invalidate(ctx);
> >  		bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
> >  		if (rc < 0 || !bus) {
> 
> Thanks Alison! This does fix the crash, so you can also add my Tested-By:!
> 
> But to test, I had to combine this fix with this temporary hack from
> https://github.com/pmem/ndctl/issues/290

Ah, yes I did similar to debug and test.

> 
> --- a/test/pmem_namespaces.c
> +++ b/test/pmem_namespaces.c
> @@ -189,7 +189,7 @@ int test_pmem_namespaces(int log_level, struct ndctl_test *test,
>  			bus = NULL;
>  	}
>  
> -	if (!bus) {
> +	if (!bus || true) {
>  		fprintf(stderr, "ACPI.NFIT unavailable falling back to nfit_test\n");
>  		rc = ndctl_test_init(&kmod_ctx, &mod, NULL, log_level, test);
>  		ndctl_invalidate(ctx);
> 
> 
> 
> ... which explains why I disagree with... the commit message! I don't think
> this necessary fix "closes" https://github.com/pmem/ndctl/issues/290 entirely.

Marc,

Thanks for the review!

Ah, you disagree with the Closes tag? I added the close tag expecting
the test case will now pass. pmem-ns will successfully fallback to
nfit_test region if ACPI.NFIT is not present or does not have the pmem
capable region. 

wrt the reason why ACPI.NFIT fails to find a suitable region, I haven't
given up on it. In my setup, it fails because the region type is 
ND_DEVICE_NAMESPACE_IO (4) rather than ND_DEVICE_NAMESPACE_PMEM (5)

wrt why it fails in your case, a full test run after boot, and with
my reproducer (simply run pmem-ns alone). I don't have the soln yet.

If you have time to check that your failure is same as with my
reproducer, you can collect and share this:

ND_DEVICE_NAMESPACE_IO is 4
ND_DEVICE_NAMESPACE_PMEM is 5


diff --git a/test/pmem_namespaces.c b/test/pmem_namespaces.c
index 4bafff5164c8..c2f25bb02025 100644
--- a/test/pmem_namespaces.c
+++ b/test/pmem_namespaces.c
@@ -180,11 +180,15 @@ int test_pmem_namespaces(int log_level, struct ndctl_test *test,

        bus = ndctl_bus_get_by_provider(ctx, "ACPI.NFIT");
        if (bus) {
+               int nstype;
+
                /* skip this bus if no label-enabled PMEM regions */
-               ndctl_region_foreach(bus, region)
-                       if (ndctl_region_get_nstype(region)
-                                       == ND_DEVICE_NAMESPACE_PMEM)
+               ndctl_region_foreach(bus, region) {
+                       nstype = ndctl_region_get_nstype(region);
+                       fprintf(stderr, "ALISON nstype %d\n", nstype);
+                       if (nstype == ND_DEVICE_NAMESPACE_PMEM)
                                break;
+               }
                if (!region)
                        bus = NULL;
        }

> 
> This fix does stop  the test from failing which is great and it lowers dramatically
> the severity of 290. But we still don't know why ACPI.NFIT is "available" most of
> the time and... sometimes not. In other words, we still don't know why this test is
> non-deterministic. Of course, there will always be some non-determinism because
> the kernel and QEMU are too complex to be deterministic but I don't think
> non-determism should extend to test fixtures and test code themselves like this.
> Why 290 should stay open IMHO.
> 
> Also, this feels like a (missed?) opportunity to add better logging of this
> non-determinism, I mean stuff like:
> https://github.com/pmem/ndctl/issues/290#issuecomment-3260168362
> This is test code, it should not be mean with logging. All bash scripts run
> with "set -x" already so this would not make much difference to the total
> volume.
> 
> 
> Generally speaking, tests should follow a CLEAN - TEST - CLEAN logic to
> minimize interferences; as much as time allows[*]. Bug 290 demonstrates that:
> 1. Some unknown test running before pmem-ns does not clean properly after itself, and
> 2. The pmem-ns test is not capable of creating a deterministic setup for itself.
> 
> We still have no clue about 1. and 2. is not mitigated with logs
> and source comments. So there's still an open bug there.
> 
> Marc
> 
> 
> 
> 
> [*] there are practical limits: rebooting QEMU for each test would be too slow.
