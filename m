Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9040B22541B
	for <nvdimm@lists.linux.dev>; Fri, 16 Jan 2026 03:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768533456; cv=fail; b=pKxtNXHXiEqiZWJDT/3tNIIbYTlzV9x1YxlAGU2SH9NWC0t1xXr44CtYGefgR0IT0GSRDnl2NR1SkyR7P9X8PA4TqDKhCLxtlR5Gyyliv8bdR76drFWHmNpqDRIfQGI6NZ7fWSSCVSObZiyfIJQ7uSya3K1Y2I//eo3BQkNxXwY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768533456; c=relaxed/simple;
	bh=L8X5Ra72HgMbJiWvpjw9N7x1vjXqOShyZho4GHv/x4k=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=C1IcVY+uWaTc0UouGcQqu7lGHqbldOYOIpY6hkEsB7Uf1VrnijFCFt1bAlRoaU7BIPiZscXw4dFK7J2MGhViOQdAg71V8zt/Cpii5vQXA3bRox7axYq+zgb2WvoYs/q63af6hr6BbecqRy3we6bbG68WDEmyJRbJfA0/LtfeILw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hn51Rvc2; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hn51Rvc2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768533455; x=1800069455;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=L8X5Ra72HgMbJiWvpjw9N7x1vjXqOShyZho4GHv/x4k=;
  b=Hn51Rvc2S4VlowVqueB25vPYSXCE8Wv+qChwBBYhMNcuJTFLfWI1iN/r
   iHcnkqhvzbMjr8IGbIIyl3GrA9j9ldx0TgKEO2ZgveYj8hri5CfWeAEzG
   8O2bFqxxKC0afjH3Vl1y6ORxxWJl/UuiwY23S7AOJpPIuZv/jWWOWLAEj
   ib6g6FXII4keIteB81hC75Q5Z4hXQQwDDcelqwPeVgW1/MppbLN8b7tL2
   LfB9NtQ6DUZkaMxEq+SlO4g4gPE+ACRmFKEBdmsc9BWdwnanGZZ9+tjMM
   QCPzrCfHbufqtN7UlV9CeRX1TKmO7e49/OQZsjIEL8ZJYJn++KlcyvKaA
   g==;
X-CSE-ConnectionGUID: IegXDy7jTFmVWqGQWm/qGA==
X-CSE-MsgGUID: pIT43W0IQraYILqoYA5T0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="80154145"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="80154145"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 19:17:35 -0800
X-CSE-ConnectionGUID: UfI0nQFCRZW4E3h5c8LylQ==
X-CSE-MsgGUID: jcAzgr96RvO2lkyGXbwZlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="209613913"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 19:17:34 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 19:17:34 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 15 Jan 2026 19:17:34 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.3) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 19:17:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uBHuQPqKdMzva1lvcoR5/prPhRhsACR7pLRPx8WKkst1VEC/2wnuBRgD+xL5tb058R3e/V3w5e+g4PZ6sNACfLY0rKLoklVzlUZRNNQiD/l367V60p9YvGRQxxflg17s8vcnxbv4arkyKxuVwhSnlVfr4YR7hpOD8QfhfXcGGm0X1hQ11ay3JnCrs0bQ3B7cH/PujIqgSwoYAamkZevzaFg5MsA4w82rzBqcyT+/EwDOJ9+b7OyYb/9uamsPVMHcdwDIgnSzJzU8GUVg2HL6IRMGy2V87dOfSki85wq3cnUEJ3GksQToy2GmVbCLPhucee0aW8+45kFKV+BDPgg8GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E8BH2NOILuwu6WlRq1YWDvoSNGBF+I6SINy9bDFIePE=;
 b=lGrrWz+OhtsaVW5QkPrWgE9NPTNd//bhXtcdAntqcOu48EmSKUU415NtiM8F4uYh5Dris+9znVavCfiIljHBYr+etnGJ4rahYv3oG74e8//PklDUxE+GIPyucrDtn+BZ26BVnJdBXQQ0UKUoJcwiwxRsJt4jlFUUi6OqgHLcHtpyWOpaR26NR8gEShKozDGJmNCE8FMlBCZdNGGG1odk2YAf1efuo3ms5h4LPBy9Nym3SUrzS7XShElsBDMb5IiyFPEqxYw0pOBfrKl2GmT0qyl3Pvg5c/xm6lqHZbKj4jdv4Ej26TF9xPQhqz/HuzgtRDPpmHZXlNWIdAGAN1EiUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA1PR11MB8801.namprd11.prod.outlook.com (2603:10b6:208:599::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 03:17:27 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%8]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 03:17:27 +0000
Date: Thu, 15 Jan 2026 19:17:23 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Marc Herbert <marc.herbert@linux.intel.com>
CC: <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH] daxctl: Replace basename() usage with strrchr()
Message-ID: <aWmtw8DSPCnPSS4n@aschofie-mobl2.lan>
References: <20260115221630.528423-1-alison.schofield@intel.com>
 <m2a4yee8j5.fsf@C02X38VBJHD2mac.jf.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <m2a4yee8j5.fsf@C02X38VBJHD2mac.jf.intel.com>
X-ClientProxiedBy: SJ0PR03CA0236.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::31) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA1PR11MB8801:EE_
X-MS-Office365-Filtering-Correlation-Id: 650fc7bd-5f9f-449e-b180-08de54adc676
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?jg1hQwvcagRPjNuPXHeYoPhpnzB3YJ/JsFtLrK60FWjpqN49r4Ne8B75cj4L?=
 =?us-ascii?Q?D2QrFK+tXaVPEf4T7idCUo37ocQ0/gPUKpOYIC4/jWb+ZELCBNWOBQup62WG?=
 =?us-ascii?Q?YzY2bPZ8Qsuho3u7DI+RCO9ABr/OA1Nh5yVi0bAhh1TUKd8e2wJWz6/JXeV8?=
 =?us-ascii?Q?lLnupK+j5xZowRqU1SXsWu+YzxZZf4PPoZ+hkkkrIUTPRdsYvFDc8QSRs4N7?=
 =?us-ascii?Q?FXMdqX0lTmX+NohHkDsFm1ezIa4rHgcSYm5xl48GQvo4xhfCIPgeEU5m2mgb?=
 =?us-ascii?Q?IQTBPhpvHiulyp2CVoaSjD5h3rvQ6r5Ub+bcmn3gQeE+UOZU+PqFUhP5Dv5O?=
 =?us-ascii?Q?fHaeBXVFX5gfiiE0vtU07pfzgMQM6ocXhRh+j2nx874IvpJ8BoirYqT6TJZM?=
 =?us-ascii?Q?HL1t3C50LaB3UOyavIgjvQMP59HLDUQFTkK4RRlegBXUyFdj4+3Vg2pK7h9D?=
 =?us-ascii?Q?6m5u4YLyk4FtE9ZHci770N6EOMYKHcC7GSDolvEMgLhdIFD284ynBVdXhbEr?=
 =?us-ascii?Q?zgclf9BT8Sr70QkVX5eSYYiWRx6hAaTKX5VxR8b9ViF4jht37o7P+YNINj02?=
 =?us-ascii?Q?AUDM7hLzlCFGsKuHeYlzF9pU9OwkkaiA4jtbv20knsrqwzphwgrMAaDitWbl?=
 =?us-ascii?Q?Z2CtNOPZ4zEBlMmKJRSrjwg7qW/btquyqOKkEOAd9PeurjSFRbNv4CA9YC7d?=
 =?us-ascii?Q?AD5bdu0vHcGaOBA1w/fVETqWm0aJfEjDcDFqyP/v0FelcUxnyUUq0yUXefUO?=
 =?us-ascii?Q?MsaVVYtRcpShLdMiBIKXiw+JG7fbJZnXvMBN/RcfWeerlbCBbcU/dc86v2/f?=
 =?us-ascii?Q?7ez3U8C8FeNjuVzlGuPoonOLcZM99poTr8+OtB6fWUr4cWhFriY4ek8w7DpV?=
 =?us-ascii?Q?xj3wM9wYmXjwVGk7dm2B2BWK/RUw9fKYkWNKbdFqi5WVy9Zfezhl6myzS0lm?=
 =?us-ascii?Q?CoCrYNz1eCvYxCCO20vbRYwDPu+9htYsbmSXDRCV8tKvt7Pppk6Qz0XFkXWy?=
 =?us-ascii?Q?BdVfHHKRga4sKLneuMbUOXXQ56xmv2sDfAn6ryhAaCiOdl+do2Brv4N0knmC?=
 =?us-ascii?Q?gcS5N6oUcrInWyAzRsKf2zzJc0qs/tYfJf5bYYT89uk73ZDL4yErP+qdKFiE?=
 =?us-ascii?Q?1r1WW8ojnvFZ38t6uT/geOJGCdfe8Jn9mV95UhZS0Ryw8jU2lszI+zCKRUH5?=
 =?us-ascii?Q?jVSj8/Kshxj0Poyc+OzqaraoPvAI/ZeHQ7vQ/umrZGaCdohbZ5VnorqW1dwp?=
 =?us-ascii?Q?rTXrF0bzryYMoelFHanAa59N1Q5NLOcV1ANoQfnLVzLUT6sTLQIfByFTfkba?=
 =?us-ascii?Q?z3m+Nsb55LJLDmI2C1PdmAASN3CS5Xp/BQPGun92nsVPHUmCQ/QEuaCch/nq?=
 =?us-ascii?Q?EI4EkAsc7qeq9pupfI3uySIzK3ok6OO69+GK7GrprItxL7u2PaHexcFaQN6S?=
 =?us-ascii?Q?t06iAkwpsUacZeWpUoqeu6ssdvqjPPGKvx3FBYUqOMeqVj2SlunAlgy+RsV2?=
 =?us-ascii?Q?oi+ziDLrqyp2RzDHSebh7m6EYyVkZezUEz0AJQUvYHamX5GcHEXpC4i4PvcX?=
 =?us-ascii?Q?uS8V1sPx/bKyxnu6h1M=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bNJf7TCRlKIglWjTATM9Uj4h9NL1BvpkqkUKtz/LyRo27LBfugnvOn47yJR3?=
 =?us-ascii?Q?fR+AezYd5OUJFlfk8qghtVzkb3BW6TYjvayJi/94mXxQsO70pNMVkC91VViI?=
 =?us-ascii?Q?2PAjjBpnP9emu+lhg0EZPebo/eAnyQQVqvpPzz+Z5c0SFInAeLDiHtnU8Sad?=
 =?us-ascii?Q?KSkJ7we6FdOOCE0+1+17wOzoKZ1e/14NL044Pf65dVeVIOslq9obH3ELIi4h?=
 =?us-ascii?Q?NPGofL8KS/roH5PBRgw+tba7dmojO2Y3XVGaeaXD7Bfi+1MRpox9tYk6kFaN?=
 =?us-ascii?Q?6rrBUvFXAtRCGh3DbaWL2j77+kginmlwUbNt51BMkD/4S2bVEym7BeQpwupT?=
 =?us-ascii?Q?1f4b1ZrlOJ3F8GqdOScLO0VBzxi+6JvO3rQ3wH3pctK4sAV/9R28o05xYT4C?=
 =?us-ascii?Q?FOyKjT+5VxGSEd/Rjri2S6cz4YWeQmTly0Wms0vU0yacb0gc7dLtMzSXz5TY?=
 =?us-ascii?Q?nQ3paCU12SvaieLTW5YXVpHo2umaICb/l850hJauPP294XR3oQbhC/BdLr1M?=
 =?us-ascii?Q?m5fuCeN2zTHAHTEZP8pNJLDoSpnpF2IRNOp4JVt1h+xXsUU/N22q1pzTTltE?=
 =?us-ascii?Q?cGxuZuHjP4EdhY0uYcZitPQ9LxGuVRP4McFaWIfnjVR1oTQZIW19B2hy9a3J?=
 =?us-ascii?Q?TngDHra+Ij16S4BOgdg+MTPNe47vhBTdpLWsHcTS755q7uKlHj2R+T8krFWy?=
 =?us-ascii?Q?s08/vW8N1+mRwvtfp3X5ujQ09rk9YjoCLDj5aJqlo+WDUL4DOhnHxSbFGkgk?=
 =?us-ascii?Q?92t3XfKBa8i23KLiTfe9sYh8rNRQeFXUI7YToo3pb2UapaendVdwntf2Bky5?=
 =?us-ascii?Q?zISJjSX95lBmhptdBaCSe/9EJdLuLAtd2QIdSfisJuqD/XX3JXWq+8MG19Dc?=
 =?us-ascii?Q?sftsRO2ld5K9NdUEdQ3zfwoojv7x6JVlFNIZvPN4Rw3mSdSdcJySVzLq1DJe?=
 =?us-ascii?Q?v0xihQ6mZLzlELB94jNOOh5zTF/Mo4mr/CZlCPT0f8tbcUevbhDTdsw9oDD4?=
 =?us-ascii?Q?61CZEjjDbtQxuUpXXacH0fHkGzc9NI3gR4RZIXrdSSuFBdzEqKpdeOcL6+7C?=
 =?us-ascii?Q?zaZ6XWVmv6N9XlFs/WjJAjelEX9Mr7KC0RzAHx/C0SSuZzQxKRH7TnBN9L6k?=
 =?us-ascii?Q?8UhXLvG8uoy6Ip/4rlx53k6U5mZY+WqhZsc4X2lhDlFKLq/zmuEU/OQxMUgC?=
 =?us-ascii?Q?t2Ej2lD+J2sWCBXxNI2bxMU/IIOEZF0EoQhm93L1VAMd26LjvLJpTDRwfIp/?=
 =?us-ascii?Q?Gfj7QljQTDXb1KX386NLKNSc5aDaDK6Z1f3o68zbKlNhByvfzgjKqBlfzk7D?=
 =?us-ascii?Q?VfGWdJhUmyhwuIq+gBJeeHrJvymaN3DU6/03JthbTQVYhVji7p/PXi509msS?=
 =?us-ascii?Q?k9li3qCT+Ecv79x311aH9aGePbMwAHMG+lZa0LCHSkSuMMswbxXGNHwnjvcO?=
 =?us-ascii?Q?T700+enMUoTotgvtHQaObkDlkE26oWqhPz+HikUxim/LI0/YvFbEtpI3E5J+?=
 =?us-ascii?Q?0EqiCJIHoAk2MsQ/y2fbq8AftNpcQwUa3iUvl69vvkx93Qx5TlHcjR/MG4Nx?=
 =?us-ascii?Q?cbR3NSXoUZgEznR8j8eLuFOFZGgu5qJc5v5ZYGBk2w8tnhfgzMV9EFD/VKDa?=
 =?us-ascii?Q?ve7ipXwi39m7tJtthUAl4LYF9RcsRt+65BhKMmK9OjEcK6P1iPAbO5FT8k0Y?=
 =?us-ascii?Q?y1m8rubDRtZtWN1vA+cMauJ1fq08p2/BSA7/0pw/nrUftMXhC5iWkBj50VR8?=
 =?us-ascii?Q?WTd0SNZ0EpoorVLZlAY8hTLB1BSOzlU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 650fc7bd-5f9f-449e-b180-08de54adc676
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 03:17:26.9777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x0JI/RypyXi4w+dx5fqT9lRBoqX8Ap78XN2xyo9XyFZidzWUf5LsDS16Hn3RgXl4h6up6ZWtyqQ58NSCjhe//TWyQOgyWkExvGrM9scYbXw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8801
X-OriginatorOrg: intel.com

On Thu, Jan 15, 2026 at 03:54:54PM -0800, Marc Herbert wrote:
> Hi Alison,
> 
> Alison Schofield <alison.schofield@intel.com> writes:
> >  	argc = parse_options(argc, argv, options, u, 0);
> > -	if (argc > 0)
> > -		device = basename(argv[0]);
> > +	if (argc > 0) {
> > +		device = strrchr(argv[0], '/');
> > +		device = device ? device + 1 : argv[0];
> > +	}
> >  
> 
> 
> 1. I would add a one-line comment in both places, something like "This
> is like basename but without the bugs and portability issues" because:
> 
>   1.a) It's much faster to read such a comment than understanding the code.
>   1.b) Not everyone knows how much of GNU/POSIX disaster is "basename".
>        You summarized it well in the commit message but it's unlikely
>        anyone will fetch the commit message from git without such a comment.
> 
>   To avoid duplicating the comment, a small "my_basename()" inline
>   function would not hurt while at it.

Thanks for the review.

I'm headed down the Dan suggested path of adding a helper.
> 
> 
> 2. I believe this (unlike basename) returns an empty string when the
>    argument has a trailing slash. Now, an argument with a trailing slash
>    would probably be garbage and I'm OK with the "Garbage IN, garbage
>    OUT" principle. BUT I also believe in the "Proportionate Response"
>    principle, which means a small amount of garbage IN should IMHO not
>    be punished by some utterly baffling error message or (much worse) a
>    crash. Did you/could you test what happens with a trailing slash? If
>    the resulting failure makes some kind of sense then don't change
>    anything.

With the implementation moved to a new helper, path_basename()
I've tested these: 

assert(strcmp(path_basename("/usr/bin/foo"), "foo") == 0);
assert(strcmp(path_basename("foo"), "foo") == 0);
assert(strcmp(path_basename("/usr/bin/foo/"), "") == 0);
assert(strcmp(path_basename("/"), "") == 0);
assert(strcmp(path_basename(""), "") == 0);

I think this sticks w gigo principle and 'proportionate response' too.
It's safe for valid paths, safe for unusual but harmless paths, no
crashes or undefined behavior, and the thing that inspired this, is
that it behave the same across libc implementations.

Watch for the v2 and let me know if i missed any string tests above.

> 
> Note even when rare in interactive use, "Garbage IN" becomes more
> frequent in automation. Then good luck making sense of a cryptic error
> when you can't even reproduce the elaborate test configuration and test
> bugs that trigger it.
> 
