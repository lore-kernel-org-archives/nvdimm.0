Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B272132115;
	Mon, 10 Jun 2024 13:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718027913; cv=fail; b=kto5aVHVtGQOYV2HtRTVeoJT5uXsBuYqosTnR4nZCWlVpXnQ2vptAAOen67oPhbNuHMNsqtt+NinF0TqpATF1T3vGWom31UPXy69OzuH4rY7eIzF8JQqmRcpjZteWHJMDvHaswgirrv7FMnmwirwbXFyn+ukTmC0XMxE9t1KEcw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718027913; c=relaxed/simple;
	bh=84sz7+nQoA9I1lc5No3mwaD+nbIbzHmRJ5+TWaBixzw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=m+0rOkZqJe8kBgtqMIEC+u/ALuyfjV/Dhitdt5NuDdkQIrYgCY4ngCU/YT1WxXdUW7uZfBQCEPRIaEBbgTY+N5folhDTB6jgYNUtRJBjuXHm6eC67D2I2wgfSSO9Kc7hw4DBkUlIJiIodofwUW5wwBlFU0U+sNsRmmpnqORf9Uo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RR1ZVLKa; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RR1ZVLKa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718027912; x=1749563912;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=84sz7+nQoA9I1lc5No3mwaD+nbIbzHmRJ5+TWaBixzw=;
  b=RR1ZVLKam93IeU54cdoclJ56qpkvCi865wJ3SSAD9x/qgG6ISqiNXgLe
   surLYR1+31yK1SJ7TLwAM2PPXV/COuPTGXXvwJ4CUfPIF8TxRd4F8TbEc
   xiqAU4IMDge9vam5Ct7KS2WMNy3gcfArrWo/1jM7DyRzmFYpabqeC+nB+
   BD0e7QdoUdtqZHM/TiFRw+DFGOW+cj606jGrsAHLg3iov/2XAQuJObHeA
   It/7X6vmTIvXPVrTKyEiAJaDMiqoksF6e7/RxnNbMe/Oc62DGbrUFlhJE
   o6PJ1D69TgEx1z0ZawRsAzsFGTMBs6FQ/fJujQ4DYHOo093QxpI9pexxQ
   g==;
X-CSE-ConnectionGUID: d2UxuUz5SFycWPFZfMALNg==
X-CSE-MsgGUID: wGGUUCW8T2SRIIpqkKW7TA==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="37212960"
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="37212960"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 06:58:31 -0700
X-CSE-ConnectionGUID: slPLyT/BTuqmGOXyB1Q0Kw==
X-CSE-MsgGUID: uGl4Ai/JThKfyV5ugWgN+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="39520278"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Jun 2024 06:58:31 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 10 Jun 2024 06:58:30 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 10 Jun 2024 06:58:30 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 10 Jun 2024 06:58:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IgG15szsG/BMy0VEf54VyFKEEq5cxNqTKG5r+BUGNRXIE0238XSTohLBVUUcNp7SyFH01Dp1sa2VF/KhI0u26RzWwNwZzPS205NtdN7HkbG4N5W8KyF920MU7TbjddC6Y/+sowcEZMWmqskQ+5y2IQXFpRWfHeaifximhuNYoqJ6BIUPbcRYRg4cnAfIi3EdP7O+X4hZk/NqzgkA3+k0yMVk7hRNDp4oc7Cc2d5djAfPYvF6rz9q0esr+OU93kNVaXkJw5ESlNip5tS/MnGg7sSEPFKFxSDMC88bSpIW7sUDJ2ZEba1WetcW/HG4IoAH9OOXOxDcRrinA6FbPWGKrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kVMvx4lSMLBPmmtsYcTSwaRfH+FN74PHlFnyBuneOW0=;
 b=aN/H2MOGqTD+OF83LzvHMUUbHkIMcQgMJmDx6pkDPLvFZxpWiSXwnPq2KBDyWCUazOqoMcECldw2hLf5PKfM4A4U7BKkn5iZX2thOcNa+z0tGG66ouK1a8auz1AmLnNZs+6DVgcDm+RDk8vDHkstoiPcY4JERb+omZFwnBwQXOlwGmHVxemio7XbtP2Tw97hvj/326WcKc4V7kCvJxc8CnkD/PNAtgY3jSrZCyXdTyMeJSt24EksZmZsr2y4ijOiPxOjtqMS+b2h7dBY5uevKmPoOc4sVpxt4zyJQXOmFm8Lvxv8AJ/zf6UsPwcUcq3w/O8SPunoaLgYgPjnFbHcjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SA2PR11MB4793.namprd11.prod.outlook.com (2603:10b6:806:fa::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Mon, 10 Jun
 2024 13:58:28 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%5]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 13:58:28 +0000
Date: Mon, 10 Jun 2024 08:58:22 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Jeff Johnson <quic_jjohnson@quicinc.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dan Williams <dan.j.williams@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, Pankaj Gupta
	<pankaj.gupta.linux@gmail.com>, Oliver O'Halloran <oohall@gmail.com>
CC: <nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <kernel-janitors@vger.kernel.org>, "Jeff
 Johnson" <quic_jjohnson@quicinc.com>
Subject: Re: [PATCH RESEND] nvdimm: add missing MODULE_DESCRIPTION() macros
Message-ID: <6667067e7e152_1700b5294ed@iweiny-mobl.notmuch>
References: <20240526-md-drivers-nvdimm-v1-1-9e583677e80f@quicinc.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240526-md-drivers-nvdimm-v1-1-9e583677e80f@quicinc.com>
X-ClientProxiedBy: BYAPR08CA0033.namprd08.prod.outlook.com
 (2603:10b6:a03:100::46) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SA2PR11MB4793:EE_
X-MS-Office365-Filtering-Correlation-Id: e3680fdd-4b62-49e4-b046-08dc8955678d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?vq0WAQb1flu0ov/MT+z25cSJAx/JHZwimw4Jpb3OLO4lCnCVDwZ0VV+18pjT?=
 =?us-ascii?Q?l0C30o7/ozEtrM1OYbPtz3Jhq6a7EG5Hct4/x+mE8Sf27GtgwlC2pD6oFqQL?=
 =?us-ascii?Q?p6G5uX64JBzjeFOrScaVvOT7srmWpIYhyAcoS6g+lblfF+4P02n8Y515BI+e?=
 =?us-ascii?Q?FsWcXqRjDLbbAHo93L47csMH7WWNv2xyn9SmDFxiun5g3mbYOQfgQuM2j9EZ?=
 =?us-ascii?Q?vzfICvhA7HciiNpEAKSwPVdqfM8iLp43/kKjdVCZMo3AyQbwiHgA1WAUnvmI?=
 =?us-ascii?Q?BhUFJYrRXRE2F6wO+RjE6Hrwl2iUYbPH6I7KOJ3GnTWw3x31Kf5QwUFgIhyk?=
 =?us-ascii?Q?AT0SXMqrBh16KLAoG/tdBrfvUqFGK9rf98KzWJ6vAXdNyVyGtmt1HyKgIwSN?=
 =?us-ascii?Q?8cJAtC3wpXejdtFpEInnIDBaJaP2TowlhP7hMJhpC9D1t72F6b+Qajcq21Ip?=
 =?us-ascii?Q?aJ0s499QvsoFNp9/IpesEErIpSyhx+sD7ipnfKciGp8C/vq4U2VR5UAT8TgM?=
 =?us-ascii?Q?LR4SQu70pOwtpryNNnbBYwyQ/5RLlKcOj12iGYQonIeiAP96h4R8MXnyhU3+?=
 =?us-ascii?Q?oW+gTqBFFYR36bnCdQDiF6FAY0UX5SA2+eHUT52uxWglEEeLkcIl8aWL1Wba?=
 =?us-ascii?Q?1wYm6/mZ0yrPL0MqnFzOD0HztPO0COPgr3wQTre9AkjALgwKbR4mDMhkRDrB?=
 =?us-ascii?Q?F8FvyQKUOTkDEPl/VQnsB3ycWaAqCaOjtGr2Onpw1D8BKcSQTfRYqMA1PXFY?=
 =?us-ascii?Q?RIHAnz79ZLC1Oa45AKCha1/ojA61nj/Mp4384Jt4dBFSJrfDNKr3fMvdDSYL?=
 =?us-ascii?Q?fshuZvmV7r19OEDotMubMmFVDdErMxzmrkldQlFNfPbR5MN0xnOdko8Q7TM9?=
 =?us-ascii?Q?wsMbf99hlEvMznEzyja7JM7QyObrUnMm00VpdV6th4hxi0YlWkBFt4laDeQM?=
 =?us-ascii?Q?2AZrtQ/XX8uqNfqQuFMLyfMjfklWcw6pPHoWBcxfgiUcVHXlz/DWHQ9+9ocE?=
 =?us-ascii?Q?6I5VvtS9P8/MGZHaX/LYT7UX6bKVuTNnyCjIxBB2sI+57RYlA6l8p13yz1uU?=
 =?us-ascii?Q?cNLq7v/aRZfMabssgoyLZKsE4AGsygmuy6MgplFMPdsKToLPNHVlOiREmvVa?=
 =?us-ascii?Q?6kiVnBih8bD4UcYoW+LMxhfuOrXuy/7kdh3Wruude7B1WEqQJSv+PxMbKCRn?=
 =?us-ascii?Q?DzDJAkpy+a/rcKgkNJxVtwDNuNXfWhP1/vhgij96TbPAIzwDoCJVyvGeUmMu?=
 =?us-ascii?Q?Oh02fXKwqjYeyguW5vzQNaZ5ZdF47JautORZ9rvDgLAcoOpIKdgao3IEmBd4?=
 =?us-ascii?Q?KfsO1BDkoX6RSbKhxoUQjtPN?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YqrKJHkqwBtDPWD6XQCiCJ/LLgFRMLwF99sR3a7NftZCYh6etLBMz+8PaxM4?=
 =?us-ascii?Q?NWsMFyLP2VTSleotDMZ9TSy0Y4o80vaJa+8eXXx8+1mIrA23qH0qM4dJ65Sq?=
 =?us-ascii?Q?rjq680VE+MFu1CPQS89g2+Bjp+CemZeBFdw1PtKIEih7pLaO4JdKhPGUmdtw?=
 =?us-ascii?Q?OW/xlFlE/CukRiXvdraZJqWQhNTT7zZrTGuIBBoYCiuV62sUWwHsHDLR++rl?=
 =?us-ascii?Q?8UK69I2wOXhwCYZ6Zp6lVnl2PdNJXtC5JDbwWqdwlAdxVA3l8+Te/FoYkUUz?=
 =?us-ascii?Q?bqP6/peO1of5ya6YPq9b5XLfhA+JPobHmbmcevUOsMCQgZVLDW5ZdFHqGRKQ?=
 =?us-ascii?Q?yW1tBNYkFbajJ7mvyoXGL/fIyMRVCtbYH/3YSnGlE8lgHllUfKNU1syYbmXw?=
 =?us-ascii?Q?hS/6YKdukX3/+cyIEU/Fq5vpPRQV4SrpH+46FtKGT2y+dWoruuGULzhTRF94?=
 =?us-ascii?Q?UfMSMH9HgZbWGol1ElKdq91+gbKURkbuBs9Yp7d9EbgIYKdyxQjT3vmF+89E?=
 =?us-ascii?Q?PDjcC3ceKuNHF3rffDqgXNuRoC5+RraxC5fkxEeiDu0XtHngXH6HjxEQIYXh?=
 =?us-ascii?Q?AJVOV46N8QZxNK8AikDTJRxh/XtTBcgN2JsDJIwUtcEFNstJj7LF48vtbEjA?=
 =?us-ascii?Q?GaKAYuRfMGjhOuyTUn+9qDvUC+sBL2U22G+9sE1JAQWHXeCclHkFp+9LeKXF?=
 =?us-ascii?Q?ngDd8cjiHPGx/s5uBUmRLZx6bip3thmQ20kHFnR145qIoNfZByj1gi+a1dDK?=
 =?us-ascii?Q?3zHAno+aN88f/11L9eExP9D6lCccH1IKXxys3Sv7do9VPcLvblpQllvKnD7Y?=
 =?us-ascii?Q?6/ex0Ka7FIwxIM/xJ8KV3ZyFZMGzhsATwR0UXuQAT4ls1BZV/fBjDF/KWJvT?=
 =?us-ascii?Q?r1jzbX41jQAS5VNcSq7bT+P6brPmTypnxE2SC4tZjWRHbxPcVOw0RGZc2B5d?=
 =?us-ascii?Q?5XP14PsmOiT6x8YIpMj9+Tl0CeNm4GlGBH3Ovqur7yB1fv6aliV+jqLxOHl5?=
 =?us-ascii?Q?fQStx8UEnko7+yIxqWSWsh6qAzilYctvMS4KC5Z83YogUq+dBo2sDwRZXy7E?=
 =?us-ascii?Q?dGipujlzIaZV4JG1H2gjQdJcwrXFI0whp718CuriC1/hmy8N/Cc8vsEjSzcY?=
 =?us-ascii?Q?T0JePqDhgSNgg4aSMqrie5mfCJT0GGsOuhlBjPQqaX7lzD8vsqtjCXbRc1DY?=
 =?us-ascii?Q?zmmt7/1sH4kafzEUHC79awmRpMIJueM99Dn0VfvAma/IpqTF13XOpwkvxuXc?=
 =?us-ascii?Q?3lWx+zg6UasRsc09QRCLWDbd7hKEY1CA5NrNCIDYIknu5R6s8IcMDkutFOFT?=
 =?us-ascii?Q?v31REHB/mRx2xT1inAsBu0xsaR1h61Fkr69lR06f02gMQ185igPdOpsel970?=
 =?us-ascii?Q?MWPPBOHhZq4tfjjR6HARckEoGmwYCtwQ9KV26b6RqCvIfyJNjpAFI4UuqWqs?=
 =?us-ascii?Q?ETLOmEajjPKWmBPgV/QmssxV0dYtK+VEWpA9c5R+0y6JagUvdPfI+kZnBLxo?=
 =?us-ascii?Q?9JsAWvPwpf/R7sRdNMk894iqBTltUdx/IDpZXo+AUwUP8SKzGNBOj94HlHLc?=
 =?us-ascii?Q?QokmJUYrZEeRPMAPm9LT//uma+W8Xs7CSEJG/4AP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e3680fdd-4b62-49e4-b046-08dc8955678d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2024 13:58:28.5414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LMYBGgJcXAWosHLe0fDUUxi2jy2Kn1bwG4vN8U+tXfzivzOlC64zFdfNoo8hPEw1vuHXG3VjXhD1D8Thzo9TkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4793
X-OriginatorOrg: intel.com

Jeff Johnson wrote:
> Fix the 'make W=1' warnings:
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/libnvdimm.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/nd_pmem.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/nd_btt.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/nd_e820.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/of_pmem.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/nd_virtio.o

Just to double check.  This is a resend of this patch?

https://lore.kernel.org/all/20240526-md-drivers-nvdimm-v1-1-172e682e76bd@quicinc.com/

Dave Jiang, I'm picking up all these for the nvdimm tree and I think there
were a couple I was not CC'ed on.  I'll coordinate with you because I'm
still seeing a couple of these warnings on other modules in the test
build.

Also I want to double check all the descriptions before I send for 6.11.

Jeff is it ok if I alter the text?  I know you mentioned to Jonathan you
really just wanted to see the errors go away.

Ira

> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> ---
>  drivers/nvdimm/btt.c       | 1 +
>  drivers/nvdimm/core.c      | 1 +
>  drivers/nvdimm/e820.c      | 1 +
>  drivers/nvdimm/nd_virtio.c | 1 +
>  drivers/nvdimm/of_pmem.c   | 1 +
>  drivers/nvdimm/pmem.c      | 1 +
>  6 files changed, 6 insertions(+)
> 
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index 1e5aedaf8c7b..a47acc5d05df 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -1721,6 +1721,7 @@ static void __exit nd_btt_exit(void)
>  
>  MODULE_ALIAS_ND_DEVICE(ND_DEVICE_BTT);
>  MODULE_AUTHOR("Vishal Verma <vishal.l.verma@linux.intel.com>");
> +MODULE_DESCRIPTION("NVDIMM Block Translation Table");
>  MODULE_LICENSE("GPL v2");
>  module_init(nd_btt_init);
>  module_exit(nd_btt_exit);
> diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
> index 2023a661bbb0..f4b6fb4b9828 100644
> --- a/drivers/nvdimm/core.c
> +++ b/drivers/nvdimm/core.c
> @@ -540,6 +540,7 @@ static __exit void libnvdimm_exit(void)
>  	nvdimm_devs_exit();
>  }
>  
> +MODULE_DESCRIPTION("NVDIMM (Non-Volatile Memory Device) core module");
>  MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Intel Corporation");
>  subsys_initcall(libnvdimm_init);
> diff --git a/drivers/nvdimm/e820.c b/drivers/nvdimm/e820.c
> index 4cd18be9d0e9..008b9aae74ff 100644
> --- a/drivers/nvdimm/e820.c
> +++ b/drivers/nvdimm/e820.c
> @@ -69,5 +69,6 @@ static struct platform_driver e820_pmem_driver = {
>  module_platform_driver(e820_pmem_driver);
>  
>  MODULE_ALIAS("platform:e820_pmem*");
> +MODULE_DESCRIPTION("NVDIMM support for e820 type-12 memory");
>  MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Intel Corporation");
> diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> index 1f8c667c6f1e..35c8fbbba10e 100644
> --- a/drivers/nvdimm/nd_virtio.c
> +++ b/drivers/nvdimm/nd_virtio.c
> @@ -123,4 +123,5 @@ int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
>  	return 0;
>  };
>  EXPORT_SYMBOL_GPL(async_pmem_flush);
> +MODULE_DESCRIPTION("Virtio Persistent Memory Driver");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/nvdimm/of_pmem.c b/drivers/nvdimm/of_pmem.c
> index d3fca0ab6290..5134a8d08bf9 100644
> --- a/drivers/nvdimm/of_pmem.c
> +++ b/drivers/nvdimm/of_pmem.c
> @@ -111,5 +111,6 @@ static struct platform_driver of_pmem_region_driver = {
>  
>  module_platform_driver(of_pmem_region_driver);
>  MODULE_DEVICE_TABLE(of, of_pmem_region_match);
> +MODULE_DESCRIPTION("NVDIMM Device Tree support");
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("IBM Corporation");
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 598fe2e89bda..57cb30f8a3b8 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -768,4 +768,5 @@ static struct nd_device_driver nd_pmem_driver = {
>  module_nd_driver(nd_pmem_driver);
>  
>  MODULE_AUTHOR("Ross Zwisler <ross.zwisler@linux.intel.com>");
> +MODULE_DESCRIPTION("NVDIMM Persistent Memory Driver");
>  MODULE_LICENSE("GPL v2");
> 
> ---
> base-commit: 416ff45264d50a983c3c0b99f0da6ee59f9acd68
> change-id: 20240526-md-drivers-nvdimm-121215a4b93f
> -- 
> Jeff Johnson <quic_jjohnson@quicinc.com>
> 


