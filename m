Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839191754B
	for <nvdimm@lists.linux.dev>; Thu, 22 May 2025 18:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747939122; cv=fail; b=YA5UmGQowDz1e48lIUQv9TEDmAvYwOPacAgA701tLaqp7k01fJXQjcv1PcooZkHXUDb+ki0aSCnSBZx3WvHJCbCFFO3MOxvR1BeRcLXJaQ0+S7Y/yXowXNm3e8G/PhKu9dxtOpx30jxQHTP09Z94uXCNTwxZAVd9cnIoJqmUkto=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747939122; c=relaxed/simple;
	bh=smCr2pgV1H269VfWOzjGrCBv5CJyd0N1S6Ru3eZ5T+0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HmHJfhAPs1dBX3fMd5IK9XTxTtRGaFd4eJUsYWNwKYLIN7O9smhOPXhIdSlq9oKbtrLAlIVDWYJbGSw1RfLB1hsY3O+3KANycumMPYlTvUKg2sPrwXTqtFozOlhtUszuu695O+keGmutQFg+izDhmN0Z8WomUtF0TRY+uhF7D/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DceVJGHp; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DceVJGHp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747939121; x=1779475121;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=smCr2pgV1H269VfWOzjGrCBv5CJyd0N1S6Ru3eZ5T+0=;
  b=DceVJGHpbX93Ul+RM59sA57Yk+OmIxa8b0MRjeNHlzC79SZgAuqho5zv
   XjrikDDMin3yxPAn2an54csiRSlbrW56uoXseG7INzqKdATbwjp5cKwAO
   1tO7ZOYwO9xkGQ/qQe6Je9e/BoIfb0jp7lv1sGlBXfeqs4H5qb0Xc8XwP
   nJExJ36Jvq9dAyT1oT2c8+LeXr1ER9msKQDBOu8LLd4Moc9C3QRS4c6M/
   fA3NSq8YYbYRIHmJN9xIf90T9VmmDQNsbARk/RGaR97oQBmvDlZ9P3/+X
   gUcvM/dBXJpd0gqn9jW6flsYWtsZ1uELEdRkR/ZsjvVw0xaVPdNMJHGKm
   A==;
X-CSE-ConnectionGUID: JeGAhxopSEyrYCK0fEqqnw==
X-CSE-MsgGUID: he7k3MPqQBOtfziUV0P6Cg==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="50147017"
X-IronPort-AV: E=Sophos;i="6.15,306,1739865600"; 
   d="scan'208";a="50147017"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 11:38:41 -0700
X-CSE-ConnectionGUID: kHsKT8j6RfSHcV1b76xxOg==
X-CSE-MsgGUID: EN744iQsTsCnrnxvQCyzBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,306,1739865600"; 
   d="scan'208";a="140790234"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 11:38:39 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 22 May 2025 11:38:39 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 22 May 2025 11:38:39 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.68)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Thu, 22 May 2025 11:38:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KUNOQ3NCq4yiPRUEAQtXEMAcc4hvD3di41eZYnVlMm7dpNjCfJfnu3oRvwzVSulem6RhUsLrBQNWMNJJTVk8uIUCrR1Kmt6HbOoXVYw7eD/4jD/QyegI9zT2V7VMuls/0C9vYhTULe/DYnqQy7KQKht7nVcj8frHwAjYyKBW+Iz06SZxnKL0f7Aa2oQQ2WJ+NQTbNHQdd2vsCCteuGBpT+9l06EttZWYHUYNEoNh86HlPm5MJUXBmnYCQHKN6dow+A9UmCnkSD0tUWAjLAUk1r8602QZYR7BLfNy/iop+xF+F00TB6bhdBSH2JRZE5wVjM+RNIcU+EGRbuBpruHOLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H1/aYMeYnJ9Rv99At6h8ppYlbXUbq78lsS415wVIQ+8=;
 b=B/VyaXfft0tjqrU8mXyHJo9ztwZA4uEWSvugt2DfJeo12ukpvH2cN8Ya14BO+n/vw+pfTTM6VZgJgryRk/9MD6Xj1cbQbvLaoKLcyvHXY20+Vd7PvlmCei9qmUxQa2CGpPST8lRoGKC5zV7gte8LEUEwZegLTAPQetEtvxmRT3rz7RYRm1xhIfC8mOziZ2jCh8d5GW+T3k44kyqshepeYyEOvOj2x/pc+DznLlCvg9ml7cm2SJpw1Qlkeoy+Mr1T/ejR1hhO1sAsN9JytEsM9q3/vfZ+QHi8+SMY5crg9rl83jKYkjkmJv6Qc59rmFJp2R/cr1HiKCbmHB4LB7uykA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH7PR11MB6700.namprd11.prod.outlook.com (2603:10b6:510:1ae::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.21; Thu, 22 May
 2025 18:38:37 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.8769.019; Thu, 22 May 2025
 18:38:36 +0000
Date: Thu, 22 May 2025 11:38:34 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, "Zhijian Li (Fujitsu)"
	<lizhijian@fujitsu.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, Marc Herbert
	<marc.herbert@linux.intel.com>
Subject: Re: [ndctl PATCH v3] test/monitor.sh: replace sleep with event
 driven wait
Message-ID: <682f6f2aab38b_1626e100c2@dwillia2-xfh.jf.intel.com.notmuch>
References: <20250519192858.1611104-1-alison.schofield@intel.com>
 <f5174c3c-81c4-4e6b-8d3d-7fec1624e964@fujitsu.com>
 <aC6pdLThSU_uudf8@aschofie-mobl2.lan>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aC6pdLThSU_uudf8@aschofie-mobl2.lan>
X-ClientProxiedBy: BY5PR16CA0001.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::14) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH7PR11MB6700:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c68457b-57c4-4361-032e-08dd995fdcec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?x/WuTd1SEisM9hcnZQojWAxFtpaMjy5kq+fOuKLQtVCTC3K3BVzOPYBOEwDw?=
 =?us-ascii?Q?NpnYoJApFCiJJUBCc1htc1qfUb/2zLHQVvu8dprygksLCR+KfB7pLnL2oKXA?=
 =?us-ascii?Q?OwPG3pK2j2xfwfLBEB+uQt2bZHdT3hr4jmEjnQS3DUYxwrqWmDJj+kDjHVWK?=
 =?us-ascii?Q?lM0MVPGBYkuE4LjS7Fb+205CBf3P0aGrspbK50TidxtJAgdp0N4exUFyyy4d?=
 =?us-ascii?Q?0/NSdauBdWt9hSXkD41anBmgQZPXvHPbhNCLA3WRpkLfG52Zkhl8o30cYFGO?=
 =?us-ascii?Q?gwVb7OEgR6accoupjGeDpkfIWP3k/YE/bN85k52nzY3VydtDlHbk6U3UfgXd?=
 =?us-ascii?Q?k3cS/iLshVZ5YO1EuY1Nu3LcaXHK2HV03TLLCfJSBDn1WrWS7usm0JOk2otL?=
 =?us-ascii?Q?u0xVFSmrEsXjGk36Yip+eviQPh3tUStoJmnRbbBZrLZfSsjnA2G2tkMBMRUT?=
 =?us-ascii?Q?M6YhyqXuEnKWev+gqDFsDNH0IBvtNGQ2Bqb0X8KFMJ11XP1LEtbgSLGxbmnL?=
 =?us-ascii?Q?xInAnCmj0v1wIO0BNAdp7zGjd1/ickhwEAzRKjqbCh2ZSqS0WsTpFdeY/Q55?=
 =?us-ascii?Q?cNwma/cfVXpi9pwt17mTYQlKT4zyJvcFU210rK/u5kx/ikf13ZM6fJtle7vm?=
 =?us-ascii?Q?S2PZhYAqqNY4IotQtvh8e3JqzBDeyAQ4BJylRqLdhzjDuqN+7rBfCRDcQXLI?=
 =?us-ascii?Q?R2pr72QhVn+gUE1o0Q1bW5vzkEtSxll7y2vdNeOZfGjAhu99VT644u0rq+da?=
 =?us-ascii?Q?xCVNTKSsHzKokcvanHbAYBoDjgeBQZp2reSAIzfzLXbqQinXOtFViSvIqEUF?=
 =?us-ascii?Q?A1m+r7aODfSEy50Z4LTco48fv1uey7Gt8UD0a6xgZGml9a22pFOxBIaOcGsr?=
 =?us-ascii?Q?jnvDOQFiHu49CbjHiah2hdRTx1ATJTulT/S32r8QFSy8SXoHQdFbuGlgkdyQ?=
 =?us-ascii?Q?WNQctKxAIQzJiOCWlbl9E1WtUWS1+n5KSp3egKSi8srRIAXbmA/1AqCO57/1?=
 =?us-ascii?Q?vfeHgnuqfYMHQFHJcUlca+9Jp6KZublHieMKFAGJg5ntGMLIMnbGifC6ueXb?=
 =?us-ascii?Q?inFDsVXs0q5TWR6K1ZwqccZtamXeRacweesNASxvS6ru0+1lVvzSxoHzkOOZ?=
 =?us-ascii?Q?GOHcL8pmUuB3P68+9QK2ZSaxqXgbmWjkrBXEX2BH3Y/7XT37s6fvP21Teb0N?=
 =?us-ascii?Q?sQbESH0tf7fjUgiyRWcz+hAorwjfLJH1hszLn/5BVgfAVrIJxTmchO1S5a43?=
 =?us-ascii?Q?wupNDFmscXD3MmpAWgA/+69FvJJeI8vMe1HA/dgMwcGNqjp9BlOfoq1JEZeJ?=
 =?us-ascii?Q?njQG7qSv7VN6yaIWicKJJWnb9rFwhQeb0oqxR6sIIniQN/2JpGbstXHNL6m8?=
 =?us-ascii?Q?/kST1yU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4gqArbO79XaAkv6iz10X3h1+9J6ebGqNIWYzAFrM9EXZvg3V3j+lP57Zoedf?=
 =?us-ascii?Q?BXmvxxZOK5TMxNgyI+KUHTJ2Igg+Ha13KT+gWZEF8cGJUzv968IlyxUbatP5?=
 =?us-ascii?Q?azcG4PW0FKs932osl1l019vA0NMA6mU+F+6RNy3YCCcW8Qzo9Rkol5feKvz6?=
 =?us-ascii?Q?S9Ge2tlamCeG7nsA+x5GTxqa0VCTNeptp396lVqpTAQ7X0rDMlUui7uG+tNf?=
 =?us-ascii?Q?Ruqw8t67lhOvNJUkkZ/Ia0GsEMmZ8XvlT/Du6Pgvfu1DPkunvn9Z8QO5vgvM?=
 =?us-ascii?Q?Xkvfvtvm5nTeRJYArQRC9IStRI0dhfO/usGdCqbyP05MRMNTdyLmDa0/L2wJ?=
 =?us-ascii?Q?0dMo60I4ifSEfvx/bnQBCu0tbKSTKcKGUdaXweXJItodYO/F1U1Vc0N+AX+d?=
 =?us-ascii?Q?PPRyQ93NepzyAr5EZUVpLa1DWBb1LfkWweVeU28LgN19FBvdslJzvXaEJDlb?=
 =?us-ascii?Q?gbm2B24IIJbzi1N/mpYHqRsrsVkXww+hsMzX1qylcWksvEQ5UW2zzsVbqzRj?=
 =?us-ascii?Q?P+uP75MaY81sZR1xa5Dm7Y+ZaNwEkt7R8/B40dW3SseEk/Uc36cinDuXMcy8?=
 =?us-ascii?Q?Uxg9xueuMhPZcAC6vf84Rc4L+I8M7XnsuGU30n2iRLrbSrJrWci2iIVJrDPb?=
 =?us-ascii?Q?4wIqTew/NpR4cmvskqudZGxgQZbSH9LT5nYPDltvCzhRohe7KHO/bvY+72Fc?=
 =?us-ascii?Q?YsTjetENrlNa9V0tXawkp+4jeXWZ3gNU7APry2ai+L5BWUonoZZv0pbjwzl1?=
 =?us-ascii?Q?US1ZVdsaHMr0N/NDoAQdHsFhYwJr/BrUSL1EmUYdxtrdA1jNI3ccqp5+1fyy?=
 =?us-ascii?Q?vLx5UkHDlNWpCAOt3LqsvznQXYlMLLe2V9CvPpUMYrqEV2Ay47lwSQXNsH/6?=
 =?us-ascii?Q?8UHGe8uPZuzYwVtUwvKRDyvLQ248A6KmyEyLyUnwDIFScZwb87zS13xmAl0c?=
 =?us-ascii?Q?XJu4c7EeWOlcqWMY5EmEPuicvfB/vvZQ5SHd8k6dNJ7naShIXW3Jw7nVpvXj?=
 =?us-ascii?Q?ON2KQnPFU67ow25Ou8DIXFiMkzfaUU+qp5MVXqiUxLMAvTNzl071bN7/BE2r?=
 =?us-ascii?Q?/ly6vjPnhRGd8iB3JfKgUV9EWbcDIrGz4eT7UJ6FMOZL4Y+M8+j+IGf2IBpJ?=
 =?us-ascii?Q?6fdD5I9WmsHTbEQ4G/lTvtA3X9fBi8rxW/ToYhBU/jqzl3ty4VivIuibe21O?=
 =?us-ascii?Q?5fiZbhD1Ry81DXSVsVuhxbVGnlaMpKPl37QzyukesoLblLFPUKfVXfJZym5c?=
 =?us-ascii?Q?AfoV7xsDKHElGt2AkFUgtj23keZYJLhjb4tqaywu4lfF3Atm8fPE949v4mdI?=
 =?us-ascii?Q?AFiqNTALJzsIGQPQpqCiNaGgnf2fwX5mW6dg5DJn6E4c3H6S4zT00b+IDR1v?=
 =?us-ascii?Q?PZQeHzof7NdjAbJKolFot5uy/iK0mCHTQi2x6D6W7ACPbGKZltOdDzcc5oTV?=
 =?us-ascii?Q?X7LY2Z/1AIv/CXEmTqTI/HywEBFPTteL99qxhVVyWhDjHDZPRvqlghagCjp3?=
 =?us-ascii?Q?SHa2murO79jiEm23nwg4jTU0kciairzV691j+7nnyIdc04hkbW8DDbPb51z5?=
 =?us-ascii?Q?TtqowW6wIy1UNirt6WzF7pNAD/KLGuEeert7HVvw+KDWB0G44savmp1lNXaR?=
 =?us-ascii?Q?vw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c68457b-57c4-4361-032e-08dd995fdcec
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2025 18:38:36.5424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xqr0hjw4I/y2KZlm66x4dk/wtIqz7YbtiepOczupS2lwwWo/b140QGW5YD2MYwYZJN40jk0ZJkNNs66+xxgt55nahpEMZ7ZsGWb/ihqloJU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6700
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> On Wed, May 21, 2025 at 09:00:19AM +0000, Zhijian Li (Fujitsu) wrote:
> > 
> > 
> > On 20/05/2025 03:28, alison.schofield@intel.com wrote:
> > > diff --git a/ndctl/monitor.c b/ndctl/monitor.c
> > > index bd8a74863476..925b37f4184b 100644
> > > --- a/ndctl/monitor.c
> > > +++ b/ndctl/monitor.c
> > > @@ -658,7 +658,7 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
> > >   			rc = -ENXIO;
> > >   		goto out;
> > >   	}
> > > -
> > > +	info(&monitor, "monitor ready\n");
> > 
> > 
> > This brings to mind my initial contribution to ndctl, where it commented that monitor expects to
> > output content in json format[1]? So this update could break it, does it matter now?
> > 
> > [1] https://lore.kernel.org/linux-cxl/4c2341c8a4e579e9643b7daa3eb412b0ac0da98a.camel@intel.com/
> 
> That is odd because right above where you wanted to add that info[] to 
> cxl/monitor.c another info[] was added to the log for the daemon starting ?
> 
> ndctl/monitor.c has a few info[] going to the log.
> 
> In the ndctl/monitor.c the presence of a log does not mean the monitor
> started. I'll poke around more about the need for json. I get that in
> theory, but I'm doubtful in practice that a json parser would die on
> those info entries. 

It's not just monitor, the expectation for all binaries in the project
is that all stdout is json and anything that is not json is only allowed
on stderr. That way you can always use these utilities in tooling
pipelines that do not need not to build a pile of grep and awk to
extract useful data.

It turns out, unfortunately, that LOG_INFO is the only log level in
util/log.c that violates the expectation that all non-json goes to
stderr. So I would support a change like this to remove that trap:

diff --git a/util/log.c b/util/log.c
index d4eef0a1fc5c..4ee85c7609c3 100644
--- a/util/log.c
+++ b/util/log.c
@@ -18,10 +18,7 @@ void log_syslog(struct log_ctx *ctx, int priority, const char *file, int line,
 void log_standard(struct log_ctx *ctx, int priority, const char *file, int line,
                  const char *fn, const char *format, va_list args)
 {
-       if (priority == 6)
-               vfprintf(stdout, format, args);
-       else
-               vfprintf(stderr, format, args);
+       vfprintf(stderr, format, args);
 }
 
 void log_file(struct log_ctx *ctx, int priority, const char *file, int line,
