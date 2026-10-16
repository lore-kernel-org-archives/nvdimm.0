Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6536B1C5D59
	for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 01:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792114179; cv=fail; b=Zu76xS5L7OO6gOrB0RNAaOaH/TbrohjSsqZKSwtjT3SyaGXXsbGmMxAq08xOvxuiB7ldRpg3KM9nG3N7ezhRBY9eUP0M0ugS2tRn6q/hryAG12K92e9glAJxdXr0+Vt+ewvO8aD5eIcHk2+gwETQ6adVTqu4xo7Ahg8AxvfVuR4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792114179; c=relaxed/simple;
	bh=j3xQ6vcvdSEiHze2agfrwxskH7s+3aYB3sYv2dRel80=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DCMDtaordnevYnooD4F72f38fN3PE0Xd+x6aK5ZTnF2uGVUgiLGmxswqwU3dNgVSlUdlwQ64DbvrB1Gr06Z8vdiSHQTgQofXaNPyg8GWf7DVGnnaBU+o8sugBUIdY0GVM08u1Nw3g8K3Unc49voy/U4S3ekwxX2etSbLATnWwBQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MAtFEEdD; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MAtFEEdD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792114178; x=1823650178;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=j3xQ6vcvdSEiHze2agfrwxskH7s+3aYB3sYv2dRel80=;
  b=MAtFEEdDqhPnrJWGEmbroFW7/dBkSlwH3T+A3v+p6MD0+yZrhKn60xoA
   i1e/kxmE6qng5d65L8ZmVisphGCAyBT6ckharaqmZbEScXEu3tI31GnCG
   3zPOWVBoNcL1fRBAuYr7nG6chhgo1LNR0WNvEu3gfuMwOToMEh1MCJpzl
   DJuG/UizU8qTedIymTXhMId2OBSCGONGrQygXVuXRSR0vfvjtVt5eGG/W
   W7tnkPPuJstY01rVZBICep9eUiYF5AyTNNXWw+FQsSsw26KcBwmSLfD5N
   90qzQ9vhzcAFQqBIF6zHJ+7T9y8E/9+Omsw/E17gJu3dPn7qjpOAkTfTC
   w==;
X-CSE-ConnectionGUID: mqB23cypQdG7X5f+5NEKvw==
X-CSE-MsgGUID: OuX1ORGlQH23tQ/syqw30w==
X-IronPort-AV: E=McAfee;i="6800,10657,11936"; a="910748"
X-IronPort-AV: E=Sophos;i="6.27,160,1787036400"; 
   d="scan'208";a="910748"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 18:29:38 -0700
X-CSE-ConnectionGUID: QcZE2wTsRPypdY3+oFpCDw==
X-CSE-MsgGUID: YomViFZGTyaiQZyWOdgdgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,160,1787036400"; 
   d="scan'208";a="3608877"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa013.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 18:29:38 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 15 Oct 2026 18:29:37 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Thu, 15 Oct 2026 18:29:37 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.9) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 15 Oct 2026 18:29:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZxUvT0M2Ff/q14j9CAWSxJ7YUJVwC/WZmeooJTT6mkadqaIFQ5yARZsOejm6tNmauUA6V/oVWLaah1Yib9rsPe2mKsk4/6Rac0EuFCz0hl9XrYtfeciadwRpmFSyuCwnnbOBGa6NUD7moKsI7nPVOIPEmt2YCa2VEFGuJgT+uYwqmcO44hnbSKbWiC8F4479zJZO8eBdvfBBXYiImagk0Iny0FdLPQdR0oYJhdqK6eVNMs1+OwVWXWCtdIDvc1muGupWaYZ2Q7OFeOU7RRpKEwLB4L8+DTOeHEPCJyi3mkZlEwKvuswp8nxOCUZDNGc795dTWkRhP0wbacphcHeWxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=71UPvDasy3Fkt+TMI9My/1voJTchEMCCv/yBgdlsd+M=;
 b=v+P7935M7CeCfEdoI7LOX5htYsuEwM8IO7+Cu69YXRJvwEJTWPMxmMHxQ+5T/aH3XyBZRabMW4Fju0wEceADB2HUUgS4Se6dcFC/gPrY18oMbT5gLHcoaxZiZVmrycy5iqskbEj3oDRqNz4YO2XjGs0eVup8ybHW1hPA/rDS/8TVZnRtTgWlF4qZulNtdZsMNLhum1yvsl090E6ValiQIrG7+6+0fP1BBgFgZ35pWjmvDl9V4PlxmtozWObPfKbJJweRHJsf6OxETlfTkON5cK2sDV1Rsxgyck11/xhbKsweJj9DrzyzAtym8yfjDbs81FVc7HU4GoHt9h9gUp2Bqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH3PPF2B89F77E0.namprd11.prod.outlook.com (2603:10b6:518:1::d11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Fri, 16 Oct
 2026 01:29:34 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0522.013; Fri, 16 Oct 2026
 01:29:34 +0000
Date: Thu, 15 Oct 2026 18:29:31 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Hemanth Selam <hemanth.selam@gmail.com>
CC: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <iweiny@kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] nvdimm: fix typos and repeated words in comments
Message-ID: <atF9-7CD_XRiUH4v@aschofie-mobl2.lan>
References: <20260907063434.23060-1-hemanth.selam@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260907063434.23060-1-hemanth.selam@gmail.com>
X-ClientProxiedBy: MW4P221CA0021.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::26) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH3PPF2B89F77E0:EE_
X-MS-Office365-Filtering-Correlation-Id: f5bac114-65f0-4b96-f01c-08df2b24ef39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|6133799003|10067099003|18002099003|22082099003|11063799006|5023799004|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info: hDbwF6O2o4zwJegKLC3T8qDkd6LRMNuZqMMTdwOPEBIUXWBjK3wjzQxFkRM2HC8v/P/P8AT1XcqvxAf9x6A9qMjcBfIGSwUOScqrcwNARR3XwGKWypI0ekvIGPZ/WEBDVott47921RMTqAiDSM2LeLX/oc6LqIYreaZ1T6UfSVHSX1NVlqKCiSWd+fFFyxFOzPUuP1wNqSOBiYCBz7TsCwgRWPoA2nbTZQvI8ULq4EpMRklYe242cQiAXRenOM2+l95FVLHhSmH/UwFJrvPkTdO1twuNboNZ4mYrlEWyTuDTCqLpp7r/aHQ+LcyXICHHHqPh6HQ34IJH6K7kkuGI7owxdIPio/IGuJA8l32hV1ILDuV4WUMfJrfiRx0sQ5K2DN5bdF8WBkcWGuRbKUJXA6iIti2eC8Z885Q/f9NbEtfDmToh2du51EMdJeCKlA37j4xhuSqcRB7dXVspRePrNNeIqpkgGbS9MnEbeEAPwoDQIdKoG/uyKWWKKgoM++7P27WaLdzrZqJGsMfC7Su086yAQ4gnmPKS5VJWEFBfnK2D/MP8C27Pbo7WjegBFemDvEDk/3hwapoOKymQ3+srScG1MbA1ZpmITV+KGmXuqLIs/qOccB52gdDdDF7R7tRCbOGcmXDx0YFcxMYPhYKcpYo8UQQOIOTwJ096v2OJcbA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(6133799003)(10067099003)(18002099003)(22082099003)(11063799006)(5023799004)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dGAsoEcqr3vwvFelIPkBjSwpr40u6m8K+lW1I2yyLuxMuua2naS8BNBlAfXq?=
 =?us-ascii?Q?eeMEcxFgSeEWqSHpDICExGzEM5X41hLc5WJCxZYD7TJCZFNVdTG0GmvEEaNr?=
 =?us-ascii?Q?THg/rOBByoqnerrCJGD89AtzgOoEILuWXIvSBsGKFeO1Mjrn4m+yQ7lYXYSi?=
 =?us-ascii?Q?VImkMhVV8HqRxf6C6Yd9C7vVZOW6uCSquRedOsgNa9dG8uaIIDdAQ99IQoJO?=
 =?us-ascii?Q?pDQHQGt3XAaj2LUymZi/tGgyPwbD/CUNmU4xCLn/v6JkrjM7PzateLhAVAT3?=
 =?us-ascii?Q?mNP0OTvIeAvwdric3isWkE3g4XezQhNAIQHNGKqsQexZpLzBgSCiB+dZSOB/?=
 =?us-ascii?Q?gPyJgwp9J9+Ack3Hnn2uxB1wASJk2K/NunRxnD5yEhIE0lPra+HIatgXwJf5?=
 =?us-ascii?Q?d7Tj6uvUZzH+KRFbnegRc9NgxDTux5DrtHVV7Hax6jey/H039PQHyv7+Lity?=
 =?us-ascii?Q?pVvMwP8vH/zokKzpW22kFphy/JGsD4QIHjmsOAQ6Y1Zh7h3kzRhBTH+ZW8BG?=
 =?us-ascii?Q?i9e1W/M4ct/Y6O4kL9w/DAq9XhiwYIhluyDUKSLCKPzcihbtZkKQ1gM/mSCg?=
 =?us-ascii?Q?gM0yqC43YVugbjsJGcTumxdzcnIOCiwos296KeLTHI/mIbU0IvvOdImfIXS8?=
 =?us-ascii?Q?hXY1zPkEpAykMCsZ5cBfAG2ADx5Z7OcZQDo3syy8aiKKRMEmrNviVxKiJbzW?=
 =?us-ascii?Q?vQUppaKLC9ZVvo2l1y9Rp7Gg8rNGxMBz/MEB5teGsYq0jtTGIczLH6qwleHr?=
 =?us-ascii?Q?zo2bT2HZs+U5e05MCujp2QLTOZJyweiNAf2hX3bSGlieEUavVr20O8mHzBSA?=
 =?us-ascii?Q?W2weIFgSMoWGwWD2zHvgEuMOvkUO7alKJOaZl4pu01IL5Z2ni6l16cY4kA2K?=
 =?us-ascii?Q?GmTTK4wNrNe0n2iOAloOOfBKORo3KURAEYHdZCNI4EVjQA/RVhtwyI6v8qSC?=
 =?us-ascii?Q?9kx3udVva+xSQh6P87I/EkjO07peqc9oRPbw6fnv4ReXqKxuIK/RDwUPqgo/?=
 =?us-ascii?Q?xCqqtTgDMB6LwDUSpiAqW3d+6dwdFiUsMuKrbNzMn9IWEUjzHtc/68hXhHZ9?=
 =?us-ascii?Q?3eIPvQNJnnlqP3j2uRDLLs4FnEh1/ZjgVv1oQvcj/Y5ZDKIxy1iU7L9d48vg?=
 =?us-ascii?Q?4AbmKxR+T0Mb3tpfw3aIeLX3p/wxOM8B38H8rUjH+jEq/Nw9/ML9pv9FnR7X?=
 =?us-ascii?Q?Q4ach6wVSE0XAA7mPSh36+Wv52afaDdln4f05aZcNc5C4LJqOf7J8OQyBFwV?=
 =?us-ascii?Q?eiko2FcqG+JeErJEgVGDYY/HmY23Cv8TZuHeCdw+cG94AlmXsiYeUONUmIRW?=
 =?us-ascii?Q?tRDbb37QYqX6NR5SEoqJeqbdM7uhzKoA69iZliBaIZa6IvbO+1ZinwbFhbVS?=
 =?us-ascii?Q?u1PBCxAYQfKBmlS39lsJ0FPRO66uU8FjWUAXw9o4ynhYWkA82mg/NElT667o?=
 =?us-ascii?Q?4kCgvXxCsbH150KMu6J7467bwDd7KinlZWDq1HHmgGBt9SeSD7SLCd0/QB70?=
 =?us-ascii?Q?zc8cIpx5W3tt9WizEaNkfln4W/h5+/t7l538CPsK6t+EttfuzvEPl+cTf6yw?=
 =?us-ascii?Q?NOmhbTReboLNErXR2nQ7tZxPSZzfbmwCO19528KVy37f/cxGudjSI8buStrZ?=
 =?us-ascii?Q?L/WmLWHO1PifV4J1rL0oilB+xTYsM0jGxA4FHWLhpQPhaKorfbUfWqMtr12d?=
 =?us-ascii?Q?rU46oqzjSrztbL7sXiDaLLJn3BAz+8W3kXzuYJ9l/K0zgwsgTL7CAsx7jU6c?=
 =?us-ascii?Q?LorCqYxpZJt0c4xrWb5urBdjEVM/bPY=3D?=
X-Exchange-RoutingPolicyChecked: DQxT8aS3j+H72VW2WGunYXrg9dyq5Q2Sj3/s51XpbIb2cB5S5J8ipJEnhXNmAsVOuplHBipq1hXsZ1Lei2hHm81w50FgqZNxrlSCzvhnbEfYhpwMuEYsb2DtBmTL1h9NCYbBqYeryWYw7ntKALMg+TZnm336i8k+T5Gfe/Hg04v5teWcJ5WUhTNa4K8kzSAJP6UDIazIFByutSQHPp1hcsDgjhMiqcm6mZWVQt0heEVUuqADlgp9GP8/8grFPIFhDgl4PMbg1gHEFWmvSrw0ZpeBBwGo++F/ZCXGLboaRWaa/fuySrlBUOx6h/lCj/WMZs1Qo0WCOV2JCKwgOf0uEw==
X-MS-Exchange-CrossTenant-Network-Message-Id: f5bac114-65f0-4b96-f01c-08df2b24ef39
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 01:29:34.4433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ujNdC8dvldokJSY31z0nj/pw5ZXAG0yssMZu42ok8UG0+h2RWeH96+JbkggWNdmxvMR27RaN30ClQc5dZ82+KT9Jli0AlBJSl5Cq42MTxk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF2B89F77E0
X-OriginatorOrg: intel.com

On Mon, Sep 07, 2026 at 12:04:32PM +0530, Hemanth Selam wrote:
> This corrects 2 misspellings and repeated words in comments.  Each is a
> separate patch so that any one of them can be dropped without touching
> the rest.
> 
> Nothing outside comments changes.  Every touched C file was checked by
> dropping its comments, replacing each string literal with a placeholder
> and collapsing whitespace; what remained was identical before and after,
> so the compiled code cannot differ.
> 
> The mistakes were found with scripts/checkpatch.pl against the list in
> scripts/spelling.txt.  The scanning, the edits and the changelogs were
> produced with Cursor running the claude-opus-5 model, from a request to
> find and fix spelling mistakes across the tree, and every correction was
> then re-checked by the comparison described above.  Words that name an
> identifier were left alone deliberately, even when they read as typos,
> because correcting the prose would make the comment disagree with the
> code it describes.
> 
> Tested by building x86_64 defconfig at v7.3-rc1-269-gbc35965f6940, which
> is clean.  Nothing else was built, so any patch touching code that
> x86_64 defconfig does not compile has been read but not compiled.

This one is a NAK

Not going to churn for non user visible typos.

> 
> Hemanth Selam (2):
>   nvdimm: fix typos in comments
>   tools/testing: fix repeated word 'from' in comment
> 
>  drivers/nvdimm/namespace_devs.c  | 2 +-
>  include/linux/libnvdimm.h        | 2 +-
>  tools/testing/nvdimm/test/nfit.c | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> -- 
> 2.48.1
> 
