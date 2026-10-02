Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A232D46CE
	for <nvdimm@lists.linux.dev>; Fri,  2 Oct 2026 01:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790905213; cv=fail; b=YWyLFPNN4nP69LQDJQePIFQEKU0Nty8j23Bhe8fAKoI4txo9ZlM4/ROOaNV96B6mXmC0evP0A7JUhHGSvh2hBh1i5py0ElDwxuoX9kuPIKWyoJlcFRJtWkKnNrr+HpiIxCpZvDZ3BrIS1B1p5HmpDJJ7HGAtEbZ5Moe5OYODccs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790905213; c=relaxed/simple;
	bh=HLQpyi3GbKx0WacHHMwozuSJAzx9lUX+8xlGDuH3blI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MRHpKrYAXFWgT0YjQbO4XWMy4xPUzBTRkgncqEpEp18QNDhS14tf9qpBJ18VJj8/lyUCcBExNMjl/ff7TLvbcZ8ECNBoQmiNUA+9yME5TmwoJsnylVrDGR3JPxMHHKO7BQnYM0Bpa2iGMbMXfx0Bb0Nxp0KRo5HZ7GUc7NqOA6A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F5mPeUPK; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F5mPeUPK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790905211; x=1822441211;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=HLQpyi3GbKx0WacHHMwozuSJAzx9lUX+8xlGDuH3blI=;
  b=F5mPeUPKBSijphTe1OkIln8lyZJrZDPQm9bGltwQns/bey173a+/hjOj
   WpGUFWo+NtiNjvcqj4WjendoK3Vhezb5qm0sBsOZTM14TcEs88j3Vd6KB
   HsOojaVHh4qPiGtPg/hLtxqSPHxepU0s7WXPbZWaYmK3hD4s0c2s0SzQd
   QXCPaPTagY/AAr52AQ3iR9RJQKY7/2tptH/yB9+9lAH6ntZ42VTLB9oae
   K3TMfTyB9Lg5dDzhTqvvOdGSDbbEgxnwJqzjLv0eSEBbmuN/wJZW7LTJj
   DQiP5EssWLKiB6KQ3gaFKj1/4md8MWoudX9Y2/SzS5aZ9CjE2OuoDYkCI
   A==;
X-CSE-ConnectionGUID: CPXhEYYoRnOyBGLIvHuylg==
X-CSE-MsgGUID: r6zr2lrjSkWFfTcwOg1IFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11922"; a="90707878"
X-IronPort-AV: E=Sophos;i="6.27,135,1787036400"; 
   d="scan'208";a="90707878"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 18:40:11 -0700
X-CSE-ConnectionGUID: RxCa9w/7SuqKrbDFsNo7zA==
X-CSE-MsgGUID: 0NOavW26RPeHdhS8N12wew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,135,1787036400"; 
   d="scan'208";a="302395348"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 18:40:10 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 1 Oct 2026 18:40:10 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Thu, 1 Oct 2026 18:40:10 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.13) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 1 Oct 2026 18:40:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l9Mdmm4RZazSlbNO/mt6I7ZacCKkQeIBbNCMci+7f4dt0YQ+yzuAwqf4ty4cjW85iWSv5bEQwlXLpu6zuGAmUr0VDQ2Yyb+iK4aRNOfauFfHCtWzsk252pQER2y14pR3XUzD85gOqA+V6x8miYrNOxSusX3qqKxCsWsKKf0osTKu92BMTCIZOtrZmLO3KENL9vxvS+ixKIc8eH7/kq51Dg971FJSw9PanBOsQmDQVQmI/QtrV2pFqzr5Nkf3pENfb2jnEtAG/fvxStuqO4XZZqNZ4wg5UG637tD0Kv6n/DEB0BlQBN0xyWod4TC3U5Rnults2/iypIMB+FnYnJBhsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rEwYrRtXByxBs/0lsdLVs81GREfRvxihjWEob93qAjQ=;
 b=ucXD07DYNI4FJdptiBtXhzkF7AhSZmVsSXOFhzFEmBM48EoHU3WeQJWJK9i8/4ioxcxLGXuwYDBWdJiZs1xRuSz0mzvdo8XvFxAIsGwuVHknc3rtXY9qZ8Hnu4SR8UzK1c1XJnkCHohMpP/msP2W8d7sCuCh538mVv9a40B46k/JqgDb07j3mYsw6Bj4pu2bB51nyWdRZwa85CUyZmpkOKJ5XJFpZXil+FYCKJ/Ef+3Ux6VUG9UZS2mwNEF1oubgOqD8S8FQSKmh2z1QEebIKk9XDQYl6mzFpWr9NPy5Z5mf8UFIAHAKQ1tsW1A44kNNpxi0hvgC/mgWDp/bW9d78g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA2PR11MB5019.namprd11.prod.outlook.com (2603:10b6:806:f8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Fri, 2 Oct
 2026 01:40:08 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0472.016; Fri, 2 Oct 2026
 01:40:07 +0000
Date: Thu, 1 Oct 2026 18:40:03 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Hemanth Selam <hemanth.selam@gmail.com>
CC: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] nvdimm/pmem: Release gendisk on probe failure
Message-ID: <ar8Lc1-griI_TwS4@aschofie-mobl2.lan>
References: <20260911082543.473670-1-hemanth.selam@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260911082543.473670-1-hemanth.selam@gmail.com>
X-ClientProxiedBy: SJ0PR13CA0193.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::18) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA2PR11MB5019:EE_
X-MS-Office365-Filtering-Correlation-Id: 22645d77-3b70-4bb5-3de3-08df202616c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|10067099003|56012099006|11063799006|5023799004|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: bLc1oTZz2J23vIDYF0CtsIn3vVwL5BW185ujujCDLUZBWmVmcqrP894LHl8GviDJMd7Tr8yJhn48WfL9Wdud1H8VpG26AJg2ysDGlQ6wGq53IW7oQQyClUc06IFtQ4loGNwMZv/XnsuDr4to1pkUEG60BF2FuX0JOq3igXRffm2dJycPv/ReXFMkgNjJnZrZ5jaY9tlYqiR8sCyypjUVv0sHNtg9afrjgr4m91eYaxXAgsEK3ZxfVgLvY34NUJ2fc+pcvMChVOE1VUed8Dem5AhRMIBlE9aNVwiySBCumq7GvdXBIHrVDy7+tVMnTPvGwjh935rtk9MIp7GlMX7J6kCTpxkyU+LGuPihyzIKmFXffOyArE6/9+pgK5JJq+thI/Hf1sVw4uXIF9R8FiCNFU4TgXgsyrqIICfhJK87+r3hh3AhRR3izkBgT8R2Eht/z8SMSxmJTTcaO3OMoOFKrAGYU+AJyUKbRB6sWj0s2yVKlUzWS/JzRn2rPCgfR9w+yW7HfpQJo6vLhDo1fVSR8SjJAbIhA7tYajqW6JFUgD+Q2tUM/SvHfK/lK2NAw/9EM2w+1UMHis2XBkoTyX2mMkc9U020KC5rMAOX+bnZTbMNZsnJhN3hzTPn+Wjo8wxvCNe65hB3lmbwG4LU0G2Vio9TplmwN9JPbVBlYRAxogw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(10067099003)(56012099006)(11063799006)(5023799004)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bM50FHv8DhtKa+5np4dchOb6NQrJmMm5FKwmFXQioVuIn5QbGqC3HhlyMZ/Q?=
 =?us-ascii?Q?V7JAlYHruvmtibBxXBKrUeKzR8Gouhv9UFJ26hgtPReBSOmmWt8TAjrDyl31?=
 =?us-ascii?Q?aAy8Z7f1bNvqP+bjpTvI0BwA8nijov/dCWdi78//m+MV4fALoD4Cela8eMim?=
 =?us-ascii?Q?GamMl+eeyMFS6LGr5pVR8wn/sCXgPnbIPbd3msjpJK46hE3wSd7UoSFXpmWB?=
 =?us-ascii?Q?HqPYANRYS1Uro8zR10pU8j2YVaMe23Exr5OWE9/k19LxSy5+aXsfApViKqTr?=
 =?us-ascii?Q?e9q4aNJeCdDKwfgJ7pG30kmGPU1h2IjdMTovp7nldoxORiDOaGvzbpCeWr2g?=
 =?us-ascii?Q?SKdGXEAW1EZBj++Ecz3avtZBGkBLMju9f2Tmt99zajSGKBoQwhIlXbvBCxNY?=
 =?us-ascii?Q?k6iJCru37XRNb3A6Uu6rUZg9Nu8OsGNY73kRo5bQV7Uj3YhOmK5mmv0UGj7A?=
 =?us-ascii?Q?UxDjauuoYjRnz6Uxz7dxwN91xOuANM8mO5rBLOyAzdruIC476h9pIuQrjOe2?=
 =?us-ascii?Q?f2pjbsRm3bI0EqZfldnjiOQxecuHXxIwmPxxUmfizHCbzuV4lgO1pfsduDCe?=
 =?us-ascii?Q?qVO447WSf4T9/uqJy6V1kp0Zyyl0Xg8SBkSbqd5XCdkV/9leocRN0D06oxtJ?=
 =?us-ascii?Q?98/dkabb6ssA0OU6edT+Ly0fWNGFhzBc+GXvIjaEuPKMgZvXfClqy5miYpfI?=
 =?us-ascii?Q?ptVY6gBwsKSOSFR1aKQ3i90O3mw62xsZwqzA+k1VRV036c9I1r8Kq8Z7w8fS?=
 =?us-ascii?Q?9bsZBRIrMe2883IL81J7WG+U7u2h68+YTqzEV6mQnG0/glrEPphHRToIMjKE?=
 =?us-ascii?Q?gE4cPx5BbvagITFmhVLQMEg8nlfo+YQEbQ71rssxtJcUQElBwe9KyXEzRZbf?=
 =?us-ascii?Q?Wm6gygT+O/WUoWZKWRiLBLkPlCJHkvMP5F2lI++/Lb5pD+YbTqqKWMWkNfRq?=
 =?us-ascii?Q?40aDqN8S0TPSGmFVn2TBWk2Frqay+dVh4rYiVTL9Gb6+/S9dZsvDEO/erbQh?=
 =?us-ascii?Q?lg3pX152EoB2Jaza923GUOOvwwxcbGJMzXyO+BOLPz4yYu+fnR+1IyYAW3Cz?=
 =?us-ascii?Q?hk0CqfPeV55h/nc8jKey89bK+erBepiPZF8V5ZxoCAgSlUgoqXCYrAxGio7Y?=
 =?us-ascii?Q?A7kH8/cjkJncPSFku7k4i5EdxJXZdLtHYKATcSMNIVYkzDCQMdEX2xwPGjB7?=
 =?us-ascii?Q?OgLfi4sT3dm+mEWlyzXidfE3mJ3nBxwMZKwdTbRwpOxH1kYLAFiMHjHCu/JT?=
 =?us-ascii?Q?de3Y/R6nGwe70RuCyfudZHjZ/sPg/wl/PavhqenuBcNXFGJPUjmuBoJWk9gz?=
 =?us-ascii?Q?+1ZSkIBgsYgd/2+NS/Mf2b9reWvZJSuMZQuYN93oNsAESRi13jGazukODJKV?=
 =?us-ascii?Q?H/C9Uq448PyX8cApVzk/+MMgWs+OCOhlndct34EDjL1njlPV/CU+z5CMhjnp?=
 =?us-ascii?Q?k5SdcNiXmCkKgRk3J8eaoTky1SFhGRQua357kH4Cb2iwZT6TZq5bfzYVaxmR?=
 =?us-ascii?Q?vv8pvdXRy68MaP1Hv1EzV+2kKgsu9aSvi8fyvVZ+qvw28ikdKvwE5TilR3nc?=
 =?us-ascii?Q?561ZwcHxkifZc/ivoK2HARAkwJ1YTGUdeyUQUnRP7AtuSSIDk51tUUfilyER?=
 =?us-ascii?Q?kEY8uLzja2AfuuwkCW4LsB2WKOTMzYrQc6/E4fAgdcKa274vF3nVPq7wTG8r?=
 =?us-ascii?Q?gZXVOebyviLuaa2BvAmAF1F23HaFnD88fQmmWE3iNpqmpN9FfwbPAwSFrIGl?=
 =?us-ascii?Q?GfLLViZT/vIcC+1adCi1/mX9jAw2/9Y=3D?=
X-Exchange-RoutingPolicyChecked: hyQatuAg9n/BgUJch6CAVSeToMrHH71LdBAsP8R/rvJ3lDVamBKevs0qmhLbICmVKtE3u27NutGSgRtr0NL3Q/ztiUV9RzALlKpW0haUZI56mvWUbfi0JS6B96x0T4A6pCHY277zvw1FDw6NitLhIFYNV4Mi5VdciRusqGQGb+kMGiyhXXStzlAsjZjYtJt+CWaijY1Moh+bQuHSyemEorTl9ffxytIvlMlhtlammm6Oa/l9AoUkgC3nrg0cwwClaBS0v+gyqjQvlYXITbij2NLXQr/efyo40uG82aXZMNxC4uWSMGbzlzv0yjUIMX2BE7FJZDbnf6luBIL8a6mnmA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 22645d77-3b70-4bb5-3de3-08df202616c7
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 01:40:07.7588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eU/m85KPQdEGqJ5Bd95YpfAYrWDZT7DFE1ZvqSv+/6AZ8Dc6swllHkxOfj4+xl5jNn8na806BRUn0kA8WGf8hJX2j6A/0NsxEHcM8fRpRXA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5019
X-OriginatorOrg: intel.com

On Fri, Sep 11, 2026 at 01:55:43PM +0530, Hemanth Selam wrote:
> pmem_attach_disk() allocates the gendisk with blk_alloc_disk() and hands
> it to devres only once device_add_disk() has succeeded.  Until that
> point the probe path owns the disk itself, which is why every failure
> after the allocation jumps to the out: label and puts it there.
> 
> The devm_init_badblocks() failure returns directly instead, so the disk
> allocated a few lines earlier is never released.  Nothing releases it
> afterwards either: the devres action that would have done so has not
> been registered yet, so unbinding the namespace or destroying it does
> not reach the disk, and it stays allocated along with its queue and its
> bdev inode until the machine is rebooted.
> 
> devm_init_badblocks() only fails when a single page allocation fails, so
> reaching this at all needs memory exhaustion during namespace probe, and
> because device_add_disk() has not run there is nothing user visible left
> behind: no device node, no sysfs entry, only the leaked memory.
> 
> Release the gendisk through the existing cleanup path on this failure.
> 
> Fixes: 3dd60fb9d95d ("nvdimm/pmem: stop using q_usage_count as external pgmap refcount")
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>


Applied to libnvdimm-for-next:
https://git.kernel.org/nvdimm/nvdimm/c/855a46681e0b

