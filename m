Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9911B946
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 23:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709766472; cv=fail; b=NLMDShBHgq9bMAOPoMOiuupa3hi8USUBWBBrUpHnIJ4lPFb/sVafRJDB6ZTxzOL1xCK5OaUgJkZyuF4RuRlDqrDmknAxQneNM6EVNFQEnKsTgcDJHthmjdxX/QrqD3C3nSGDmVYdIlEONt39bT7grJ+27TCE161JVfV7ngWycJg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709766472; c=relaxed/simple;
	bh=W6+sTWrsNvSzk07qZIAKDA724wG48F7jvhAwsiJwe3M=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=smRJKBaZOVShyDFhvN/3FVBnuhntax1jqf2zRMxOGSqwXa7kiz8RpGy1I/mDTGygRVh2Fm00yBtYXP7/y6fqrD46aP001PnCDMOAPoyTxpsNW5iMaDTA6z9Vv2QGkXw0pxgtEMDcK+cfMVEGm5IBywxZGKVtKeUfmJkNBf06Yck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jfz93/fK; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jfz93/fK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709766472; x=1741302472;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=W6+sTWrsNvSzk07qZIAKDA724wG48F7jvhAwsiJwe3M=;
  b=jfz93/fKvZQSbdprlAEAU0FIhg0PBQXHIssvgOk7Fv4tifWlrPYX1oiS
   W74R7v7BBcn++h2PNnOT3puIN+N7ITFBDfv2fXhlfo+eAWCSChk4yCWJb
   NMGooohawHvsNFhYFa4emXMy0rkoaQftchXND9RpVETZR/U+ADlFVgyNw
   mWRI+bqk0EtpnK7fl9CEg9O9ocsFLFf8UtHctT3sk4jlEldTTV/FQBCU2
   knexWk4Th4OW3iQadYPTNZ9jdzp1A030QAxvb+71LiVY34CqrUv8+uS11
   Wi8dEyQOEWZP+nxsX0OhCqMlb0rTO7xEfSxF3nhqexutbmgNGByKR6334
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="15548194"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="15548194"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 15:07:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="9890589"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2024 15:07:51 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 15:07:49 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Mar 2024 15:07:49 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Mar 2024 15:07:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a3Y+UixK8Bq1Zi90Ty1h2uivlTHKLdfI3JIzYY9KhyHj83tgHbCFDVKa0SQQdMTYxVwF/XpEBfCCuNebUBLIbVmhPeomVj7h4nC3/67ferCdxadWPn4XVjRu6xPiOevEhTicp5yXY1tN2akeQ0Ntfgwepzoj3BB/Xa/Ut3wEuwRLcYwquKMdF/yDzXgqXSM30mVB8hEZd8X9fB0n8vYP+aCZVjVCxb3GA/CiJKZB1tfRSYuFCx1IBGdmMY1hBU8dum0t8mRjHWy4dJoHW0zIC6QOsVNNoCdrd1qDaAIG3+gbPLEJCpPRnTKpHxqa7EP7X3YFElfdFcjDsqek5GqUKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4fi+JxSu1rriAlRetb4hj7VZWjafbzlSDbpB0qG4raw=;
 b=BO5PYNV2thNSRAWQ8DgnNjmxwLvOC4LDWB4pRGuBKikEqzrX7vS3vBPoUrgBaXALYhUPMgIVkzyYAQDh/ODSyMwu20PwPEd1Z8NBQWDVHzSbGqU62QaKqJJAteXw/F4tNqFXHh0KALzotbZsJGuIh0Kteyx18/zQ29RsolCH18LakfV5eei85HorZNpM/L5MhBdt3K3CxrpjY4YArC95ceom0ZwWza/X2oH4tkWAALQYOe6OB+lwP3nWPeV3Zok1BKdYOvDvk5i9A9SEtxmdtjK7H5AtEyGf0DO3ex60C2u0u8iDoMvpODDCGj/v00p117lr1otoT5+UCcPisIb5dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA3PR11MB7464.namprd11.prod.outlook.com (2603:10b6:806:31b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.6; Wed, 6 Mar
 2024 23:07:47 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71%4]) with mapi id 15.20.7362.019; Wed, 6 Mar 2024
 23:07:47 +0000
Date: Wed, 6 Mar 2024 15:07:44 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
CC: Alison Schofield <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [ndctl PATCH v10 1/7] libcxl: add interfaces for GET_POISON_LIST
 mailbox commands
Message-ID: <65e8f740b8d0c_12713294f@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <cover.1709748564.git.alison.schofield@intel.com>
 <c43e12c5bafca30d3194ebb11d9817b9a05eaad0.1709748564.git.alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c43e12c5bafca30d3194ebb11d9817b9a05eaad0.1709748564.git.alison.schofield@intel.com>
X-ClientProxiedBy: MW2PR2101CA0002.namprd21.prod.outlook.com
 (2603:10b6:302:1::15) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA3PR11MB7464:EE_
X-MS-Office365-Filtering-Correlation-Id: 4dd59726-c786-40c8-1a37-08dc3e323cd3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NU8d+h7FJPBgEQ2yOYyLwFnHvzkiE6TX3cXGgorfTyRlApfZUmVsZiqUVBsR40IlBDe+dM+OEptsL9IAwEeYiwzowtY5FGZPPOELPrbKJp9o8g2n4EmiwYlqykq+P8935If6aaN21lI+pTPcbrD2XxP0vmGHG2uyeixvrF9Dg9W8bt/BGKWjYFev/cpcj2O1FSzwQ2tXXGbpzw2/B+WRIpbLCl3R+MjiX2enAFZZjcXbvJLgWK989mOTLhAPw5e1IODxMv2wVUv4mtBX+NfL+RGvDTiAeb3SUaxVsefnBjLfJaSznJ7AmKAB2+/s2Rvhj51ZLuaJiOKfRLAVjXpXxL/NPwawmIkVmwC5skzzaQcWoiC9yI8EwC4GoTspf9dfTOEXp/CQJqFUorr+cAl6IjjutR+DlTkV2k6N6baXfGBvJf8ESyqIwzaaaCvs0jK5WIQ6m5ZT7FkMSvOz64JFj7+cA909EpxC/KxjDQ4LjmscUNS78Zh0Pqsq5dClpdAGpZhKbfBKosgTDbEO0M7cTBdMDmxedBfBzjHLyTP7QoZ+18T6P8IAboM39v8LO8akBOoBTYOv5OAwISOnz0HaP598c3oBE2fuQ6ZDtgPJ0XuvGsot1gwkDx/zUiXytBJkuVYSonNxjXih8AYVrswVInm78aqcm7+IfeeOWTSI/pI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lHWZfMT0a1DCq5YTlHTySjarTp/Uj2MZf1D67CCte+XwSdjViNNQNBWPPu1u?=
 =?us-ascii?Q?hat9GJhwAaYndwkX1Yb87t6mkiv3+SUPROMMJCvq3U1qR9GUjH3tmcChzW5a?=
 =?us-ascii?Q?Znox8VieYfORM5HJx63uW/PRCT0dLJmPWMlutR/51FSCZ/NIYfgZUKRyy7Fg?=
 =?us-ascii?Q?F/VomBwbw7xOKBvdfPG+G4IsSVEfNBcJAaxOxFoGZqM8xEQKDtcw5j3nhBIk?=
 =?us-ascii?Q?y3yblX/GbG3aqW1E29puxvK5ZaVFQ/gGNO6e0RMh7aPzoRITPWPiL2xxH0rD?=
 =?us-ascii?Q?GNnjaVCvVR7ZDlm4i8d5jly4EvoPc3rZ4qairl206pful/uY0OsMRub9EvIy?=
 =?us-ascii?Q?3ObP5es/t24i+HGUc4iR9S86FB3qBWWkTrwUJ87qB7linnlB46sHxev7wh3T?=
 =?us-ascii?Q?APNyUU55JHOdYkLAlIO5qMy2JFo0WIeKe+ZpOg+Nm9ictsbSX9aTWtqghtW3?=
 =?us-ascii?Q?2Q5F+pFXrA5fkDzEflmjuuIXefvh+bLFBA7h9r1Ybgu99GAK5OBjp7FQqnL3?=
 =?us-ascii?Q?9pP4LGL1gqrp1r3Q60/iwd373yIpKqqIistS5hq0MFrh8TD1dVA1RDz/iPL2?=
 =?us-ascii?Q?vkVVBJHqJ1eZxHFbm+MjltQKxH8LGIJdGeW1gEBnhmlCviA8Vy2CKt2yfzuL?=
 =?us-ascii?Q?ZZBOmCBxtcjpbExDrLVRyu0N5KKmflrIf9ICB6UPa+38GfeRZg/7eIgxoTxT?=
 =?us-ascii?Q?Wwi192mtxJbPbioyfHC/cn3ph3xLWYfjmjScg5AbDkugF0HGlKn/Ada04vNM?=
 =?us-ascii?Q?Ze86XwHITeiLnxB1SXQATfPgxFzFeBv8PmvAqVODGWe+MPm9VdO1RI8EOIbG?=
 =?us-ascii?Q?njzBtmkU1U2BbVO9/rUfkoegUbWCKnwC5OLYNU4NjwstdRSnrTIYHO4QgtmS?=
 =?us-ascii?Q?o/7TQiGNa6I6KYzL6eICeo7E5vxKEiI/X7m/x48vKXGjcbWoJkcQyjzu8/pO?=
 =?us-ascii?Q?npF6BqtVZeSwh7ko5CwXv8zkMMXC8tA/11bwQ0to4jFRcpmkrTb7lexQMg/L?=
 =?us-ascii?Q?4UtWICtxIbSKOOiXL5BR3Vi+zYFLXR314NKwDOjxgPPQsj5bB3edhihS0y65?=
 =?us-ascii?Q?IruNoJgmaSJO8oV7dBx7Yp/bzTG+2YrAAyJkGbG5EJ0RQabOzCzBB25e87Ak?=
 =?us-ascii?Q?z94Df0Toyk7O8ZxLVo9TikIGe1zdhNAS69KJvwqcBnRUNsEWNO9Y1oNxj19b?=
 =?us-ascii?Q?0uNB77XB5O2v4zMzG30Z/s+AfDQ37ZhW563N6IX7MDU4OJZG3/GNNmQHbO0M?=
 =?us-ascii?Q?mliIwajeXk8+0yWzLKQI/KxHVNSu3tUgO5UjjXqwO/bTRRRyE5TEg8trtffP?=
 =?us-ascii?Q?hc9tTqw3SiV+XXdD4VndjrQqhCZ3lQXc8VAVtcbkTmeVJlv32UQNhXmspKMh?=
 =?us-ascii?Q?aWuOrU1cGTWcU+FMVcHsypTNTR76Whw8Zp+gT3HcjIxouFlM55ZTWa/OXQiW?=
 =?us-ascii?Q?V60U7ylI+8KFQURs6X/KFYzt4oTdlEozqR9JkDNc/g1ZnVZp+FnaE2i9uZGw?=
 =?us-ascii?Q?mIBLEgughwgk38ZUF4VGH0OOUqGPiQytgEwH41rV+As/bPrr6ybfZZY2E/SZ?=
 =?us-ascii?Q?TAaQAS24PyaFRV4eWxE3PGcGwhAf7LfZ+67KW63uXxq17cs9r09LnFUieJsr?=
 =?us-ascii?Q?tQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dd59726-c786-40c8-1a37-08dc3e323cd3
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2024 23:07:47.1679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CRjAbxmKz8HUIvnj6w1xdVxCYxbAOzgBFj027GmBZrxjLPgmVTnonMoSqCUEgXhBKvUae6ZyBHObqb7JoXW5cUEP52cwJMpEj89Y65z1JA8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7464
X-OriginatorOrg: intel.com

alison.schofield@ wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> CXL devices maintain a list of locations that are poisoned or result
> in poison if the addresses are accessed by the host.
> 
> Per the spec (CXL 3.1 8.2.9.9.4.1), the device returns the Poison
> List as a set of  Media Error Records that include the source of the
> error, the starting device physical address and length.
> 
> Trigger the retrieval of the poison list by writing to the memory
> device sysfs attribute: trigger_poison_list. The CXL driver only
> offers triggering per memdev, so the trigger by region interface
> offered here is a convenience API that triggers a poison list
> retrieval for each memdev contributing to a region.
> 
> int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev);
> int cxl_region_trigger_poison_list(struct cxl_region *region);
> 
> The resulting poison records are logged as kernel trace events
> named 'cxl_poison'.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
