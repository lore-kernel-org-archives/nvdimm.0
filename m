Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9471E573F
	for <nvdimm@lists.linux.dev>; Wed, 24 Sep 2025 20:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758747228; cv=fail; b=lWScVUZUAMoLuueikoJCVJHdt6M/bLE3mf8StnauhThCMv/nAjDMBrlBpWWYWoQ/Bo20oJR0YHFbHz6CuMAfNsJy0+7Dcri3Jk/iYGbWYT8RRftMSmEPe6RZMckYzuKhlVWqxdathiuOQ2P6x5EN+fR1H2NaoeVv1HiSI9DE7j8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758747228; c=relaxed/simple;
	bh=Jdud+fosFi6GfTqLYOtpVpkT5uiaoG81IS4/OlGg+74=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mIJrngkFAMco1Ifl4pT6xfTu6omOqQnf8GtAfA5+nNay4J+Cq4D4sFyXDbnkNjxFxJ5BCL30INh2CcAupCc+4FSCpwRsRudqpwQI6jr+gSM6c/dZcoYSmIWxOyeqghNERJ+VA5WVpc2vwu3+Gle2IkHH/xS5VeE+2TuQyrG87RE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GguCSsDK; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GguCSsDK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758747226; x=1790283226;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Jdud+fosFi6GfTqLYOtpVpkT5uiaoG81IS4/OlGg+74=;
  b=GguCSsDKccT91n1v/3m8R5hUArxNkq6jjcZXNJpKOiTYHSTKoihEN344
   F7gT7Yb98HYDjJcNs24xLCuu8mOcCXBBOjoM0IdkwhFtex7rDHeFyVPUx
   OyCTco2E2Y6Q2zkFUsz6K8fYtXB08bCbGvvuhW4HOFLFZ1LPMM/PYF4C8
   WdRg/G4BY/n7oFJ22R4/iobYtivtm2srMRE9FJT0Ft0+9zGwg2pcC5eGE
   oJlzxBWdxvRGW12zyBQRKYx5q0QrhQ5QAnP/PpuBRi+7uHdDYDAwliFmx
   0N2nvb9r+uJrOTg9WI0ns56/eYml3BZJnP/2mNqQnHF5wN/8XG6FIIy+r
   w==;
X-CSE-ConnectionGUID: LvTTMJr0STuW7/K1B/TXcw==
X-CSE-MsgGUID: z2QEJQtVReGX4W3BZ8Gnrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11563"; a="60947402"
X-IronPort-AV: E=Sophos;i="6.18,291,1751266800"; 
   d="scan'208";a="60947402"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 13:53:46 -0700
X-CSE-ConnectionGUID: xBzwHTDKRAKSej1BTmEFNg==
X-CSE-MsgGUID: fn0Oa8htR5aDIArU708rcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,291,1751266800"; 
   d="scan'208";a="207885057"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 13:53:45 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 24 Sep 2025 13:53:45 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 24 Sep 2025 13:53:45 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.51) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 24 Sep 2025 13:53:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N2aPW0TopNrLOicHnknGyP28L6Api2C735+Kjne6ZSym2+3gxWMYu0/CWiBSGEdqUrg7+PaXlyMOvYW6YHue7LOALh+AnG3kkMUbH97gSPyowC4J3HQZFSn3URP1R8IeXHa+LvBIlulPDiaYrnlDy0ogxfxEpCL77WbI7vnaDciIAMQBtYEgv3kEkyu0aRcsHjPXS1oYpUY2vQVBeCt6uSX4SiK9GsRwbMFujOLmxPvb9wk7F0NnvSa57JLoQB5sMaZObuBSgfDClS8KXdf+RotBleRBXJnUb1waCl35krVNItDAWfiM4LGnsZxc5UghasplUMgVI5oIzdUJdPmWKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1oZkno87JfMYpCmQg3tcO2BQekuIxFdsMRGh+1+iBx8=;
 b=LQuszNckYeqxeJe68VOX0dAe8j2Hc+Zaq6HEHZiFQQvDAj/bw+GQ+F8c7QDiM4Vm2ffQm75uNcZUOYDKtnJ7ENIg2J5URWtVvLURj4xtdYx0GRwmJ3lnZxgaKMpfBWEj5hHnbJJCfTAcdpmfD9azk7JwPIzQvOE+TUZ57ISWOZ2ySzaR674BfYMWhbSvwcOugVF28pZ0D9GEjhMyPrcMe9Dfb4f8yy9lpJGEEng8gNIdH2zkwGS4K5xJjCAmw5pCfYdxYzOoTHV/cDXefuMFJBY7XHD2QZoZF54YlcVQjTQ72VRAuycX1Zz0Robip5LWDbkfQUdHifo3vjqBIqvD3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b) by SA1PR11MB8376.namprd11.prod.outlook.com
 (2603:10b6:806:389::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.18; Wed, 24 Sep
 2025 20:53:39 +0000
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde]) by SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde%8]) with mapi id 15.20.9137.012; Wed, 24 Sep 2025
 20:53:39 +0000
Date: Wed, 24 Sep 2025 13:53:30 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
CC: Andreas Hasenack <andreas.hasenack@canonical.com>
Subject: Re: [ndctl PATCH v2] cxl/list: remove libtracefs build dependency
 for --media-errors
Message-ID: <aNRaStk2KQVKZtuG@aschofie-mobl2.lan>
References: <20250924045302.90074-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250924045302.90074-1-alison.schofield@intel.com>
X-ClientProxiedBy: CP3P284CA0109.BRAP284.PROD.OUTLOOK.COM
 (2603:10d6:103:6f::24) To SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF0D43D62C4:EE_|SA1PR11MB8376:EE_
X-MS-Office365-Filtering-Correlation-Id: a6c3976d-042b-4da1-4223-08ddfbac7050
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?4vdSTIFNUws5+X0pX7evBOmXjB1urEucaB2+QVdXDgC/TFGf7IphFifdzAsA?=
 =?us-ascii?Q?Wapzn0wgMwsCupl0ug6ME45LGUjEEmZLJkn14zWpplYSxQwX2TdTijnSXnjb?=
 =?us-ascii?Q?jTOO4xUpRpL7LBkznz2dib+ve2NYPQObTBO3GRNYwPxMUEYu0RVFd++OIxLh?=
 =?us-ascii?Q?ERMZpSgib2ex9QGY1N+F8il/aKXXL0m5mxbSZ75wgZrg+fUL4ZPp3gW45O6c?=
 =?us-ascii?Q?I2dfysdSWgWOEjGWc8HzxzC+E13RrZw1OqjDBu1LaboQMcpClBYC6uBEbbmN?=
 =?us-ascii?Q?DVkq6DDaFFbbJk1C5YIfsc4YXJzFK7Ez/KzD9GCxZUMYCxCnI+0yVlGAzwP9?=
 =?us-ascii?Q?IFVE5cT6gwtTE1WbIxOvu6A0S354jCtBaOEk/WGTd4c944Mm0I6UixJWNrFI?=
 =?us-ascii?Q?CC5pmTmz125UoHSLXpCGTEXyhKHIYGQ5rGlCJpLb/Yc73Rwn4aGk+3605IIB?=
 =?us-ascii?Q?qqY4XJPsm1mZnpv4c66hH/LP6bzSUFsZGNEwEkMirq9rdXlP7XZfTMw7EkzO?=
 =?us-ascii?Q?4b6e272SgCn+UXSNC8qAOJct2G0nR2/OTAM1Ndpc8cwNcjvxBhH7yokMR9ke?=
 =?us-ascii?Q?OlqO9IPv+2X6G4l1Q2XxuKd3XRnyFZi1ZHAzf5vA7zCHLfJsUNmFp7cegomj?=
 =?us-ascii?Q?8ONcwMRNl+fVZ1I29yowf82EdQ4OHkGO9m6xAbHoe3zu684Z1B7b/aQfDf0S?=
 =?us-ascii?Q?N2abFn4KyK/xXGiBKJ7XoRlcD5PFfrb1tqphkiaAVcM80j9HaSFgvcgt/ASG?=
 =?us-ascii?Q?NJylwgSQZn9Xp/aF4MjUfEiraE3UhkqWqzyJREIKfXBy4UB2kJCnxFYr0/IJ?=
 =?us-ascii?Q?md1wqCA5L+ZenyHqSTqkLs+eWyYMpHZ06hKESZoAMFUIJkNYJW2Spu+/F9zb?=
 =?us-ascii?Q?KDuD9FG5VYkFwyf3y+n0L6SLKXdbI3xsOGMYVwEYQ//CGDR1dTKpctUczXE8?=
 =?us-ascii?Q?cMa653xMqmjun6QF9e4grtEONPrEyhjVkjwM+pQ5UcPTJV1BRga++vrgDmKN?=
 =?us-ascii?Q?6iqe1NXB47dkj18yYIgWcTzTXShxXlUrO72hMbD7JM3TCNKWnlY3flKpsXoQ?=
 =?us-ascii?Q?DqutyAeG+9lpbmolXQ5bxef0TEGPIRf8PPCB4P6NdeJMKd4co3Ybvq1HITcL?=
 =?us-ascii?Q?DiPWtc04c75QZtCDiAeoRfZA8ouT///gdbdUdrUmZsWxsv/63rt6ZjTJc7zc?=
 =?us-ascii?Q?/I6WHsWsGzoy7Rifsh/GF4cWw7ZLsqA6sU1Ski015iTGxvCTXlpsm2gHnibP?=
 =?us-ascii?Q?/Lj8MiRPrW3VGDS1ANmCaVl5waB1KozHuEnAn55aDfkBwEeVtRE2IEAm+uXt?=
 =?us-ascii?Q?CdrkU3a0vrevK3f03dcvapSIMCmAfYaXPxNutsTloJL1q5vXYGpx1c5y/iYF?=
 =?us-ascii?Q?ytmMW1B4n0xzxVMFb2CwgPZjQ5p5TKwe2sODRBQPRNcUPIeAKZhsSk8FYC8i?=
 =?us-ascii?Q?uvyslxH/7nKXuGuhdrwbdfwPV1p+SSRV?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF0D43D62C4.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u//fO4PfTa6xDLD5LIIUKrKA1x0m/AT3sOoG9oXYig+kSkDHh4FhR5ZWJS1g?=
 =?us-ascii?Q?vN6dQ4E+GMgez0rNcLL873YCojGfsc9gbkrDxAtMBZUx5qmzUJ4phtMlYKe4?=
 =?us-ascii?Q?OsrPEfRHehqyqXlOPkc9ukKD1Dn/mp5EgJ4tFrg3V9nnPCkc4r8Mstv2dXND?=
 =?us-ascii?Q?gtFb5oUE2eVRyxsKIWRdNmvW4gLb+m5TYaKuXyJVdyH+fbr64WkoyIzT3WwH?=
 =?us-ascii?Q?T+YSxO7wiFHv1ATXzgFF+EPyq7FkOZRNuHPgz5RPKYixoS76S0wXRdUd6D/m?=
 =?us-ascii?Q?P9V6LgIgQj4ls/9kvfMizRzKxcg4HdomboCwtHAe9iM1Xhr3MgiwQMxGdSj5?=
 =?us-ascii?Q?qC5VRxSPbPHpKA5rX6cpI/Yhx3QBeG2JpRVO786zutwqLz2wFteFhhFl+8Ox?=
 =?us-ascii?Q?MjTbQ//dAaBgLfDiQl8A4YF0bLOpAiD396TqTbF3LidRM0FGKrbfnm5C+NtQ?=
 =?us-ascii?Q?kS2NehRGO0WitMA8EKCzi5qpm9xi/nxL1PRtsDbyilvoInB/2/ZIm3kFSLf0?=
 =?us-ascii?Q?BFlxS7XuoEXZrR21YcxMkD5oTUTm1bUGxA26CC7vfXRVjuW2DnVgHYXEd1Xv?=
 =?us-ascii?Q?pPtGn90fx8/4EPmD6TCBBuNinLGRKPpubE3y4GL23T8TbRSVhizWEsFYqs+h?=
 =?us-ascii?Q?xv3ZGDzbWaiGMeCYnY1Uxxm/9X+nWbYl98kr7VW9vKNdxse76QsiH54UYckn?=
 =?us-ascii?Q?Q4mClygKbLb2kWb5fFrvknkL8rlPR90Rff6IMdl+VKzS1zWH5zIsFUXtuQE4?=
 =?us-ascii?Q?cAxoTEXajWCjrLWRVm9YOl5lVKdPi4fa+AvyHH+vvti+5lQNNhpZz9gEGLx1?=
 =?us-ascii?Q?Qrc5qTeil+Mn29y9+PltdMQBlf3IKvB/l/kKUIqCwPDTv3JKpxAQLJW07l8b?=
 =?us-ascii?Q?hdq9g129lWjl6s4XLtmMyITYNLpmUNxssKJqD5dqWrSQOx8WpqyaUA1Mymf0?=
 =?us-ascii?Q?0wJAA1dZDxy+Na4laUYsRTA0MIFT5VE6rPEWuRj1KvcVI/OqClT1uhdD1MIY?=
 =?us-ascii?Q?piX1BlxxHRPjTskVJqcIrEYX3pW8DfwB3iPlUeTmOqrcwXrfGtNEIK7c1oJH?=
 =?us-ascii?Q?ACn/fzxp9YLYJy9orjpt+j3lTw6Rg0cLz9iS9SJNAZQTXC8MHNFLwN3psWoJ?=
 =?us-ascii?Q?eoHbDNkggfdJMTEU5XXP7lbZF+TX/DLq036x1xmw0cppDDEZ1OVTMs3EEToo?=
 =?us-ascii?Q?T6ngeYv2HpJn3tiT+G4rB04T9eWEhtahHDjDOzJ/wOK/cqMZ5lWakMb2Rsqg?=
 =?us-ascii?Q?p69g12FLaF+yoWZQ01CAu6Orkj1q7DReoXQbjJ1Mk7OTh0U/qM2kBykC+7j4?=
 =?us-ascii?Q?2UFl5rF+3FKXYOHNV4ipSL51OpGhkOmx32rXua1+ur4buHgvNyu3yObXDQwS?=
 =?us-ascii?Q?gSpjR5BGF8WqlrKwNVyvmPlZM8YC787yiNMc126XQ5zhodcq0X+4V4J57xdu?=
 =?us-ascii?Q?SVFR8PpF3mXEqhvYeDH4tv4z1/k5lw9S3MPL+RIw7FCixTOPVHSsm2WKEf+e?=
 =?us-ascii?Q?jzIf9amwNFo1fZ6+rM3sZVlVtq6e9OlQmT+yZwC0rn5XZuaHY6aZ0nmAkIXY?=
 =?us-ascii?Q?pXL0XlqCIDswvlJtGOUvaxvhesgcDWhsn4bww4mGiZFTaYZxBnBbbbT4Y3/F?=
 =?us-ascii?Q?EQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a6c3976d-042b-4da1-4223-08ddfbac7050
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF0D43D62C4.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 20:53:39.5036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nc3AjbFhtrwjU9Nu5wDJ3ysFkCk8dW6vo6Oa2SWB0rEHTHjG6F9J7GEvMfd4Gd4HU5hx2RwppTBridN8N/cN1/HsAYZe2NlmVEzvu/btKn4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8376
X-OriginatorOrg: intel.com

On Tue, Sep 23, 2025 at 09:52:57PM -0700, Alison Schofield wrote:
> When the --media-errors option was added to cxl list it inadvertently
> changed the optional libtracefs requirement into a mandatory one.
> Ndctl versions 80,81,82 no longer build without libtracefs.
> 
> Remove that dependency.
> 
> When libtracefs is disabled the user will see a 'Notice' level
> message, like this:
> 	$ cxl list -r region0 --media-errors --targets
> 	cxl list: cmd_list: --media-errors support disabled at build time
> 
> ...followed by the region listing including the output for any other
> valid command line options, like --targets in the example above.
> 
> When libtracefs is disabled the cxl-poison.sh unit test is omitted.
> 
> The man page gets a note:
> 	The media-error option is only available with -Dlibtracefs=enabled.
> 
> Reported-by: Andreas Hasenack <andreas.hasenack@canonical.com>
> Fixes: d7532bb049e0 ("cxl/list: add --media-errors option to cxl list")
> Closes: https://github.com/pmem/ndctl/issues/289
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Thanks for the reviews Dan, Dave, Vishal!

I've applied this to pending and I expect that is the last patch
going into v83 pmem/ndctl. Heading towards a release with:
https://github.com/pmem/ndctl/tree/pending

