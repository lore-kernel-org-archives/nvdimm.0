Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E064146B5;
	Wed, 20 May 2026 02:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779245354; cv=fail; b=rKMSDKOWQsV2DxNaQeD0Otr8rIPivvXN5mJTLhINTZnQy7jjadDvYReWTpAGGcCdEDeR0tN0QKH/jV1QsWNzx7Fkq+N6yfkO++9PdzMHBaRBDwGw9WgDuq0vlAGLU1k58pu4edx76RCStNET9n8FI4U+pxkgMwpDQXW7MDhjFcM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779245354; c=relaxed/simple;
	bh=9j3dqES1g3F8f3HLBeSZu7rtz3hSFMOeTPcM78tcrjY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RySWyBSiVmwcyebuYeVCZ3s2R9KHO0OL7D44lQtrwm9lipYtpkKokgOHzjnMjFxz5bhq6LhZCT/bScbJFvqjtmSxX+UtmijCIpbvNOU4ds1fTjvwvXSjWep+pWEHOFTHOFXwTeaO7ns9cRbUueUHifi5Jw2kzAtfaH2/ZYUBqws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y3zBIyVj; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y3zBIyVj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779245353; x=1810781353;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9j3dqES1g3F8f3HLBeSZu7rtz3hSFMOeTPcM78tcrjY=;
  b=Y3zBIyVjHYOfmvQRzIhuQSesVCQoakYPFpAZYG6dRhW1qWKVhgN6sIhc
   PAHSiLfeLVcMHZYFg6s2ROhqsHEpQr+nF8X/GxAS1kdHOt6uc6YS3nWmS
   da54BrffefUl/ls3S1taCKGz97PgvH0A45Nmj0f61JB2ZvYD2TI58uzeU
   gN851wkXAppQ6/KTSY9lklK5BmU4SWM4REvBABpb11n1php5veupIz02D
   /Sxz/EVONE1lIxg2Nn2pAdfcHeqMJuxKb0fpzn5VDb0MqlR7eAKizGXEm
   tioQNtANGBxl88HTZYo1fYEjm0Wa7ToBC02bpIDcalyOdmuqbjeawhWhN
   A==;
X-CSE-ConnectionGUID: +5xPDcH9T6W8EJJZg07PmA==
X-CSE-MsgGUID: 8IbqYfZETL6jx2hGk96DVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11791"; a="80170887"
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="80170887"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2026 19:49:12 -0700
X-CSE-ConnectionGUID: z/nX6x2xTy2mZOw8M4FYVQ==
X-CSE-MsgGUID: xD9dhpPDS6yXuhKynUyOcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="244957943"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2026 19:49:12 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 19 May 2026 19:49:11 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 19 May 2026 19:49:11 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.41) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 19 May 2026 19:49:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VCYYi74Dd2e6nwO1/NaLWIA2WSFCuC+Bcxt9j0yRoDclKN+AojB2QFHRuI23KiqMeN6v1gWOnPF2GHBCzqf/R815f1RGFVdZaj81AkLgFVUkrxa8g84QrpCcHzxEyV6zQ30vuU2N6bSAxlGJ9PhlTSbg8RwPn14MBziT9yeKRak10gMqBN03MFETbmuqWM+UicF4qc+vcu3MxMuK4kZHbs/xkkjhal2NDHlFRwbj7GNt6H4ngVS5J+7+z2h3Np2INN6WIw82P7Rc+S4kM4jnO5/CgVEYvdEndXQyjIKi8EHpynyMITi+HXUjvR80iwGneAMCWH5gLGXdysIlGuUmLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A3+EWjofD/Uc+FTmo/8We56xe1hRWY49TcqIJ01I9gA=;
 b=dsxjJ9YSBpbD7PZTDAm7WxubLdvtWq7EnEDgjqFwB1jgX6QzD7QpPy4iFH9brhWgJIeW3pKgM2IMrJaq0whjpb71jnXjYr0oIvb2MLBuFCbNWGOXKKMbjCR40CXWw9o9uz6Xj2gNMMLDIKBLzEzIYFpHh4z40R8gmIJZWAc+KsD/MjRYuEREnLgxIpmGXu4DdlfnJdQVB6bJe2LKqXePnrnIJYVso9+KP6C5XwMOFLZc9bub7OVxadAZpDJIASEnw3U1E3BoYraTJq97hBuraU4Uqzim1yfi35l8ZmJF6XHdsEc5wT7BSBePr2gVjy+5BxuTchi/THp6PupiS1iEqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CY5PR11MB6341.namprd11.prod.outlook.com (2603:10b6:930:3e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.24; Wed, 20 May
 2026 02:49:07 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%8]) with mapi id 15.20.9891.021; Wed, 20 May 2026
 02:49:07 +0000
Date: Tue, 19 May 2026 19:48:59 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Tomasz Wolski <tomasz.wolski@fujitsu.com>
CC: Tomasz Wolski <tomasz.wolski@fujitsu.com>,
	<smita.koralahallichannabasappa@amd.com>, <oe-kbuild-all@lists.linux.dev>,
	<icheng@nvidia.com>, <linux-cxl@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <nvdimm@lists.linux.dev>, <ardb@kernel.org>,
	<benjamin.cheatham@amd.com>, <dave.jiang@intel.com>,
	<jonathan.cameron@huawei.com>
Subject: Re: [PATCH v2] dax/bus: Upgrade resource conflict message to
 dev_err() in alloc_dax_region()
Message-ID: <ag0hG3she2ZRNGyX@aschofie-mobl2.lan>
References: <20260519101832.31988-1-tomasz.wolski@fujitsu.com>
 <202605200842.i0s39151-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <202605200842.i0s39151-lkp@intel.com>
X-ClientProxiedBy: SJ0PR05CA0156.namprd05.prod.outlook.com
 (2603:10b6:a03:339::11) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|CY5PR11MB6341:EE_
X-MS-Office365-Filtering-Correlation-Id: c908bfbc-7f03-4f72-f5e0-08deb61a5ca4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|11063799006|22082099003|56012099003|4143699003|18002099003;
X-Microsoft-Antispam-Message-Info: rbgCPdCuJTENaQOXIYHt1MNqPhz9KMOLOG4isiZUHSFhTXNidU06HEIXOtUxPOPubNfX5SiR/o1QCo7+85gCNPDmJ2qbNAX50E2zn0LikOf/8LJzmmb4X9/Y1qwATUd9sG2/W9doSRXyu0f3Qp2FXQBDf2SwduF5bTRIR0vmJJfRRhGn05PReiRgsX4v/plWelso/RiSwcBlXIteNVhc4xnAXlxaz/b+tBJIshy+xgswcXkwOAjC4SijrJ/WKApXQhHu0hEtU3zLAz2pqa4bDPVICDe7eDrsi5UKW9bF52kOMmYSTQ56rsKsHgNycvB/+Gk9wzBxOVfckRrbFVVV1ZeFkspRIDOh/gerrEfQK+pwnvCrEgDMjAwVQOdj2th2DpPljsZb3ZX++UC8SFKqweKW+jt/5XFUUieF8ZXLSAsBP7q5OoRpWDWAyisOIRpvQ2hJ+TKIxS1nYmWhJGhZ7OPpVtjFyz8OnX4pXTiiCg1HYDiQvQKzpryk+NN3eBYFO8D07fY6AELoIrDoesdNCWCKFS1iqcInjqgal4oQR4JRukIJo1aDEUWlIs5Bb/YRz3ej1Zt7lnhWTUTe5QIz4v5UBEGXgs8pFGcW/MSKB05EbYkLKrfFMU44O72I5ZTP5DpHw8dBwvGpdS/ss3cxgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(11063799006)(22082099003)(56012099003)(4143699003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TcyHiZLG2j0YSnIoGj60kO4OVPy6e+lk68CfqS4YPlBrnmYy87icuUGVD2Aq?=
 =?us-ascii?Q?hsyOwZH116PAMSBaVQbYqkEaQVPH+I2W5nWHHxzuiLH9GhXqozSg/PuPes7y?=
 =?us-ascii?Q?NSV5ttJjUX91mmfezFd6MLInnCbSCOMQokAsJOmsW4FGqjQF3DclbItSD7nN?=
 =?us-ascii?Q?1FhR1+AYU5cPaIdfXBNA9M2sdRnFnd2P7a+Hj7RyyvWkNa7uEdWOpmNVbK/0?=
 =?us-ascii?Q?i0stTUarZXRaknj4cyIybhXmGnY4taRUhzkfBfnxfc+ziahjEU0zrH8s6Gt1?=
 =?us-ascii?Q?SBQhZOq3fiBVYC3gUcEio+7nTu3uW4ivYEArxK6/bQrU9ahHK8l3JxLpo852?=
 =?us-ascii?Q?VduiCYjTOriMUv+ljFDjfimI5yXBJS/RN6UbdKExFb2lO4CoebVo4W9HpO+y?=
 =?us-ascii?Q?N4UIyWnKOBhO7Lxj8EOzaKVc6lRb7POvZekProTqHnYWBpRSIYerL9sMfIVn?=
 =?us-ascii?Q?S/eVF3fqV8N/d2K7V7n5s91mhLkOYaQL69oS5k2n5EeI/jERp6f9vUVyav+W?=
 =?us-ascii?Q?WEwe9W/HmS7LQxIKocH6jRsorkfvZTQtG4LdS5dbrm/TOhxXib1Snp4r64Ko?=
 =?us-ascii?Q?3MWQH6I/Y4I55Nd7H2eL+tamw7aTz4nGoyhlvQZuThWgwqUsQz7XTKVMgSu+?=
 =?us-ascii?Q?ZVdEW1fyk8wgFUrHPeKVz6vQYjqYT5XdjBtLou4sUaaX+6HBao8feAOL30UK?=
 =?us-ascii?Q?St9g3MaVK6tmSuG6HQ8sdD09EdyQNpQ3oTn7ONMyTGEBIz+pH8tTRC8t7zOz?=
 =?us-ascii?Q?Yh82vYMqCFzQH6ElZqDu2PAmZfsJduf4e25FToOAAHoGfj6aNSDTswr53MkN?=
 =?us-ascii?Q?+l/cbE8cRgGi3JDn5EwTIciz8A9v9t3w4eoKWIXowYaGqIM1akCeWq6MOh/E?=
 =?us-ascii?Q?dWxVPJlwOutSYOdv6yBt2NVcQBirinz7PaO3ajyCz1/0UJ1fgDQxtHsHMt5h?=
 =?us-ascii?Q?gyLAwhEh39Dzufkj9X7qgn1aLoomXkcRhvwVfjrcs6uQct4Hh3UoI4uR0JB2?=
 =?us-ascii?Q?wr9uyUrmi1L+wv7FNaM/ruPyeto4wqZ4zmvFPX8jmlMo7rwD0W82DqwXhfWI?=
 =?us-ascii?Q?DUeGWDnf2uw4W0k+kC6Nxt65Ji9/fStDPCx1aEuiqYkwxfd38DV/WKT+ZpiM?=
 =?us-ascii?Q?XYyxAq/2PdGfk6EPh2oXwbfTlOkjckHWurKN1hEmRaRAJ4quJ/DkBzeSjbHe?=
 =?us-ascii?Q?dhY6wMWcl3dKvmlbwaHAGN10waPMsmvxp//F5k+Q+ttp8abacejfgYfpTH2C?=
 =?us-ascii?Q?je8TUIfcHhUDZvxMFRh3u0HI5Z0AqlyoK5dSf6ljlSHaJ9NXv4h7v2aACkL4?=
 =?us-ascii?Q?TudjP5hrfUGUUmEfUainECI7/JUZcdgeB0tyEGF7AXCP8UBJLginDDB6nOu5?=
 =?us-ascii?Q?dIXVAUYBuJmfKBjJo8/e3HsSSQzezNnDX+YXcHp78U78JzvPn6GKhuvEMjWQ?=
 =?us-ascii?Q?76jU6aAOBABuNr+QYEPs6L9TpKpk9n0zq95ObuQEEmgbFbfLpujmMHyFj8P2?=
 =?us-ascii?Q?SluCRnhMuYOtAQn8VO/MOi0pdRJN8SCMPHn6onr/wwatYKHGC9Vn0w+79bDJ?=
 =?us-ascii?Q?uSRS+5KTGb95GDx51aEczM8zzi1d1FFiOeMooJEj00Ed0zpMYOdI1cM91cYp?=
 =?us-ascii?Q?gjguu6Wej6VSJraQyM6vATANPdCoAfHq5NQZogzy4bDoCv3nmAN7NlLFwSp/?=
 =?us-ascii?Q?Nv9ASsHptoThE620cR8d7aR36yCk0WVVSd1YqPUabHTSrj+dpILP5uYO9euv?=
 =?us-ascii?Q?MkSQXCnpn2ozZwvnx1dLOEpNH3ZW0rE=3D?=
X-Exchange-RoutingPolicyChecked: VDjb3yIXbIQZ2tYO4qrRBFqIRee6zo26u9NAjh8CRSdgjGa5XnBDywlBtmExgDvCktNRz5p2Uw1V6sZrESOtcIfJn5uJ6ypeXAr3OJwer1H/RWhbdvtOTrhDV4j4HMl7RQlG8HRNTM79FU2vUhi2uBjlF4GUVmIjJ5lPxshGEyQxzEtQ8N3jG22OPWykqPhuGwikdzG6t36X/1BkMeqFaqKqROZetpQc7sxElU0rJ5WjQHmS2IXouviSTKTFWu4kFjLBQTRDaBIofkWDyKbPgkg8q9YTyXMyPmJXKzko9y4RnLp5YGLmPXPax4G29cnYOj2ROBDYhDiFkQhg7PdvEQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: c908bfbc-7f03-4f72-f5e0-08deb61a5ca4
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2026 02:49:07.4267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +0jc1sfTnFhDYR1qDB/r+ctBtBw1h5+GBxOVB/MIagOyZxHRJ07m06qKTrdMxTxaRnDtejKSyx3My/2UGW7mMdLFh2U3R2LB8gZm71xU/sk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6341
X-OriginatorOrg: intel.com

On Wed, May 20, 2026 at 08:14:43AM +0800, kernel test robot wrote:
> Hi Tomasz,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on cxl/next]
> [also build test ERROR on linus/master v7.1-rc4 next-20260519]
> [cannot apply to cxl/pending]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Tomasz-Wolski/dax-bus-Upgrade-resource-conflict-message-to-dev_err-in-alloc_dax_region/20260519-182401
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git next
> patch link:    https://lore.kernel.org/r/20260519101832.31988-1-tomasz.wolski%40fujitsu.com
> patch subject: [PATCH v2] dax/bus: Upgrade resource conflict message to dev_err() in alloc_dax_region()
> config: s390-randconfig-r072-20260520 (https://download.01.org/0day-ci/archive/20260520/202605200842.i0s39151-lkp@intel.com/config)
> compiler: s390-linux-gcc (GCC) 9.5.0
> smatch: v0.5.0-9185-gbcc58b9c
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260520/202605200842.i0s39151-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202605200842.i0s39151-lkp@intel.com/
> 
> All errors (new ones prefixed by >>, old ones prefixed by <<):
> 
> >> ERROR: modpost: "request_resource_conflict" [drivers/dax/dax.ko] undefined!
> 

Sorry Tomasz - I thought request_resource_conflict() looked sweet, but
apparently it's only available to built-in kernel code and not to
modules. I'd probably try a prep patch exporting it, based on looking
at its kernel doc comment and neighbots in kernel/resource.c that are
exported.

-- Alison



> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
> 
