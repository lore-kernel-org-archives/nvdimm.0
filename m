Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2613BB10D
	for <nvdimm@lists.linux.dev>; Fri,  5 Jun 2026 05:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780637713; cv=fail; b=DMUquIEGsCwpaRd3fVoMcGqsZSSDcNlunj74YsT/tnzUWhzodQYMaqHmF+wNQg33CqogfIPNhDowqGf1CJYG5M3qrG9gT69sa1c94Tsjo6G2n6Jv6rjMMnmki4sCDtZit13t/mgQRMVgI/h7gRcydK97t+f4BYCHp+ijJtYiszA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780637713; c=relaxed/simple;
	bh=c6KJdT+kkOKGzGf8E8VgdalAjGcsirMyKXKhjG1C1qo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TWJ77b3ajfnz43BA3fdYDzbX3S3jg8GEzB6iMx61QRN+GribXjsHemA8/HFyEeNLKGaX7ch8JHLxXoV0JmnVNQMus5hgsQnbtPupKpP3Z3/dwcotmlQaW/0XhSnVkpFBVT4FaisxUKy1e8/J5QFNIyXG1aWJhwPtUcePYeLiNu8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HYz6R3ET; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HYz6R3ET"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780637712; x=1812173712;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=c6KJdT+kkOKGzGf8E8VgdalAjGcsirMyKXKhjG1C1qo=;
  b=HYz6R3ETSCV8zl9Lf7a/xdOTEd5DwhWBG/QmVlLasR0IVoR7zqmPEsOy
   xTWbFxeahJEAwrREU6ZEz6KyIzP6vMOZO7gOsOCv0Mm6qJeQE481z/l0y
   Mj5PFDfXUHCJMJY3xsejtqSN6FP6POFNWOAmEVKtk2Y38026aS7ks347q
   Rf/pJpaEpPW2eP4m0Eqp4i4aopCrc6vLRCy4gUjaxkCM8ZeLPAp+v8BLG
   HGp9j3TcL2LA4jE7/L+tCwVcN6isR6o0/PIHiDcmUz7XxKjfJXoAw4N6F
   4GzjSq/K2OB0+YuCOOHK4Xkq/o32WTKtu4I0ehUjIMUAnGjtlK12nPHU7
   Q==;
X-CSE-ConnectionGUID: V64YplBDSWKlfttkyXqg8Q==
X-CSE-MsgGUID: vTjffUZ4ThuKjiNLGkTxkA==
X-IronPort-AV: E=McAfee;i="6800,10657,11807"; a="81656005"
X-IronPort-AV: E=Sophos;i="6.24,188,1774335600"; 
   d="scan'208";a="81656005"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 22:35:11 -0700
X-CSE-ConnectionGUID: yb8LZqhxQNCrwPmgbzbeHA==
X-CSE-MsgGUID: ZnbcGQ6USjeshUzGiSdUEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,188,1774335600"; 
   d="scan'208";a="248678299"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 22:35:12 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 4 Jun 2026 22:35:10 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 4 Jun 2026 22:35:10 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.63) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 4 Jun 2026 22:35:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZqaKqG1togbPVd06UN5EpU9ttyovA9NOxhX+zbYfE9mSa2cROSC02yAiABccnZn/7iVAZ83QKPSAeKocC1Ooo+zp+QCswka0qO6BuflnK2vznFGwlMFZ1P0exVbiQ1o3AiWEKE8kGxg434FOMP3W//6VHmyGRB8nPMgRyGHA3s4JL/IJ8H6igqQwWxNwuUAF0RzBWzLCvUxdxdY6YgTKvOShRYizUYpgCl659HUf8Oi8dLTRaCvpUsdbmJCIWnnMWS7rvTBVGIM1/PSGsvLzl8tsD+zSiUxLolaHa9xBx3uVpMk8TEiQ9SNs+wpxdznfzhMX+T8AwLQh4jAVheeQNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZicnBXozKBExiFh7eKkelBh+bJNDa3Cpl8TuMEGeRDM=;
 b=M931uembOrX9+t4xv3z5/6y/ZUCPZ1FIq1XoYV1j4J7XJM8dwdMnnqq5bVR9hLjyGF40AW80zjkA+tLIbZKvqnJyiaXcxWlUqY5BANl3v93h/mjAysDte6NX3q5pjLXQyVkM5hHp1KIYmibRLawGQISRFoM9x0qMdbRppT5yQofmLTFrXBgK/kPfmfrYfkihGQCnruAOC2l6apKJpMiXYKc5QV+0xMauHmqz2EX6qSJJsa7waD/07hzUqZzqSKl3J8dBvHtUplKq2RB50tFTwwf3V9CJXCQXo90T5LC1/ArKDPpF0O4g1UWssCvgbznvCB5X9WadUqrObCGvSPtupA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CYYPR11MB8306.namprd11.prod.outlook.com (2603:10b6:930:c6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Fri, 5 Jun 2026
 05:35:07 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 05:35:07 +0000
Date: Thu, 4 Jun 2026 22:35:02 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Anisa Su <anisa.su887@gmail.com>
CC: <linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, Dan Williams <djbw@kernel.org>, Jonathan Cameron
	<jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, Dave Jiang
	<dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny
	<iweiny@kernel.org>, John Groves <John@groves.net>, Gregory Price
	<gourry@gourry.net>, Anisa Su <anisa.su@samsung.com>
Subject: Re: [PATCH v10 00/31] DCD: Add support for Dynamic Capacity Devices
 (DCD)
Message-ID: <aiJgBmxiwx0DWduN@aschofie-mobl2.lan>
References: <cover.1779528761.git.anisa.su@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1779528761.git.anisa.su@samsung.com>
X-ClientProxiedBy: SJ0PR13CA0173.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::28) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|CYYPR11MB8306:EE_
X-MS-Office365-Filtering-Correlation-Id: 194a0984-46b8-44ea-418b-08dec2c4338c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: YrGIZ7YxBOVQPZY5EpFNB/Bj9lvLtcj6GD45G1vUA8JsmudkSk/VIGNAY5rZ36NwngNYWPntNijvcnYJ/4hvMZrNtz/cbZpZ/WWLi48WCqZ9H0vdYgWxczxJp2hcGPM3Ns7Rlfs7Dmab4tAs6DPGz2Xxu1yXw8ZTz53hxPFrwIO2bPlqnfzbUj2ccdNye4AAMZoywv1tbp0StemR01FjgXr/s4MIjhxqc0BpSvEaH8JCrfH8h/PPtTc7eVV4QBCB2EfZ4ZCsfqNrUotEqCM3EAVDQSz5sRyZxj9OER2OXdJ+Ytn1ZYUs1xnPRwjXqgWCu3/UcP7eVpWIEH5rbvPWRIcz8+8C/IJI0LRP5H2rlqDz9LU2cnRLeP03BsrhfO5j014QraBLz0sBVvJTLd94A5jsq2mzOPGs3NoneP9om6ktgucvWwxeo11CNmRBXgbZ+xRFolDBlJMxHGBpAr/fFc+uXa79/AKUMU0SO6jdHV3yOusOB1YGYv+d97ATme7xWdHXVIVfpGHWR2LCjBIJYepBpXHDvMc9408jvxxjM+/qW5a219HYewhe+SuY5baeKc9YcYTzmqeFSqHMwWjlIIDkArhnpXvDAQMWpL1LbI/cKQ8zSEwcRik8K53rX15+pP9XEssQbIGcLHh2TVlEvQKY7Zzg31s5UIzoloJz9pucT0nepVVzc3dCHPOnSc4M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N3Cd0Hdvha6Bm47f1icxn7YhcY5oDUssxrlsLcQzf3TmL5rqx9HZkCdBd0nu?=
 =?us-ascii?Q?ZgaJ9drgkZMooTXw3VtY3/YaL/yVMP5UCoOGbay+YahT/Fe3LeqtQVN92mOr?=
 =?us-ascii?Q?LiliqjoMj5jtiCMnR3a5XJAbDplNOvqqoE3Gkw4ovQwIl0yUTl/dZt7nwB33?=
 =?us-ascii?Q?kz+X14bJsbJ5RJLDhPgU1vL9lr7bQDuJ+DHwfVFDMfB2392IhE+/ZmX9AvCd?=
 =?us-ascii?Q?F3ELR8cMF3R+CL42bx+DEkXv8FfITMvXGzJ0Fffa9SDOxretIN0Bn6mC8zTm?=
 =?us-ascii?Q?Z59i0q42/8MMBCzG3WEM8R+urjz+qQL8lD/Zpx0seYC4oCFz1fPl+BRIATDE?=
 =?us-ascii?Q?XR2g0HGfTpP7O0FjjRZBc7D8xm2cRCoHaedy8wGt39xoy1Ivf4H0QUDrlIJq?=
 =?us-ascii?Q?jN3N3hgqMnJZHDSKywRlmGnx1YO5H8g87l/HmjRXwrqVuhjTuSAc68/oC6xd?=
 =?us-ascii?Q?Q4e7ZurDP23mzcGNoaXZinETIFvnpV9l0U012eO7WEC/Ty578TrP/6mhdsay?=
 =?us-ascii?Q?b2xHsLX9rdfdtmm89hsllzc4YK7PmpB4141Knig+3MtXESBmxdrwzoVIbJng?=
 =?us-ascii?Q?VHVscbOmtdC3rF5NA5VUfnYIWYAE8h6oXpWUq9hW6Bg7ulYg1qmz8HDr5y8C?=
 =?us-ascii?Q?tNi56pM9yTpNSlnuzKKxNMInHpqGSA7Z0nBXgX7nUYDEhlTLWCSmKcSdO2Dn?=
 =?us-ascii?Q?oo8rb8L1HZAfqn8CMujYhCatZ+LcsBofpU+4YRmyyU8PTK5jEiZ9U54yHVP4?=
 =?us-ascii?Q?5dYoIM/O8Ip9Ts+qfM3YnaHnUGfWRzNw8to8Jr5gdfFuk/vfkcBtSUDSPKLS?=
 =?us-ascii?Q?r3ResalX5ogzslx5DE1X3LhNAZLzyB3/zGsYpuwRt/foFnXqkLXWu0D5vHPm?=
 =?us-ascii?Q?pBE/YQT4AAE3AqFq2wluGAUEpAYyhRCIY8uYd39xz9MF45xyfczXA+nF1SNb?=
 =?us-ascii?Q?jd0j+se5gUMSRQ4jZJWaja2Vk8nWhL5pgMgDofqqF+XK+0bp2juGnSjcmlc/?=
 =?us-ascii?Q?TyA39JYQ8I7Sy264d/S8zyp4xOCH7LZlL0C7yVv1T2KvkoweFxsmT95lqHD+?=
 =?us-ascii?Q?ouko9XbIlDdHbwR6eAqX6ic6gitjesRvCG7k5h1xX7GpUACKsPlLRCOfMrmK?=
 =?us-ascii?Q?P4NT2w+rGwu9fLZ0YNPpeDcy87GvgGnUmVrNOOpqGrdGlHjV3iPbHAu6P0wY?=
 =?us-ascii?Q?RvacGKFF9vT61gZxu+D06JP3GBWayHi+dzB2MPFFxCTF3nrWQA87dZxpDUWP?=
 =?us-ascii?Q?SbTTqu20Lm6SeUQUkYulfIF6Q4dmoXuvpHgcdAeFSpVcLA0IdWeL2bQhoCFf?=
 =?us-ascii?Q?QnbaBoFmu2lC5unQSg9VVceH6Ie+1m1z8C5n4vCrBxVf3b1o0Cn/NICozuec?=
 =?us-ascii?Q?GLiDRLNnuCQfUB1DoQt1luVFxFHINcuWimFIGC3/olTCY7jDGpYXvedPKw+B?=
 =?us-ascii?Q?9s+Zfw8E3IPhx7QPPnOct12Us2su1QSEFP3EilPr2aIMeplVSm9JvWVGWaxB?=
 =?us-ascii?Q?9qRtFWCLQsU5ARfDtqODf662wsqcAagqkUIxbS7vu3g8VrCuLP8k7pvom+sH?=
 =?us-ascii?Q?C/la9eM8o3FhJPZSNpIsV6XKM/gftI52uMVjQTYBRjzNRppTbWDIhR2W2UHk?=
 =?us-ascii?Q?KRTvXYAlg4Ze52F/CVo9nAxhD7X832GEIa2eA/WMpFHVGAEriq6sIP2ZS6gI?=
 =?us-ascii?Q?ScQBp1p86xj5vueRRYq4CjmS8Vsi0CA7Ek3n2R2Xy1/Hfg3mCqxx15AVRL+1?=
 =?us-ascii?Q?ZTr4yhokn3TaD1Bh19h/gThIJ75pMlE=3D?=
X-Exchange-RoutingPolicyChecked: Zwq0vdr+C5uRjXhPUK7Pi04cxagtXjLfrXrBfRk+frjPjO7F1rx9A9YRMhFb2kADqnoqZKCwyX45eKjNnF3KSnkNnzyqIdluDv8vsOWbt5T1m3ygeYawNypQIJVX8Kt2aW1hnZd06gR3Z+B1A1wQ5ebWC5i6vZQfzQpqQg+3rW41JhrnbxzMrtbPA8Pfww5WBPs0cox3QqLpTKsKkoWYI71xDjEo2yjVY8Wctw+CFuknfCFtKH5qpeRZubZlQeXjnGYxm34OctLiPmSuU50hYjGcIowTBQro/HIUxcD93pe0RJ0DmBpEYrn+nx+kDBrSjld4UeMjvF+XgVGivG/TbQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 194a0984-46b8-44ea-418b-08dec2c4338c
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 05:35:06.9897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: veoDFJZ9rPBcFc/+nPYlYBp09wL4uq8xEYXU2caKqxDCm+vFjX2vwU4JL8OYlAWWwJPhyQ0T/JiPi9yjK21vaVlzYQwo3ACK6Wq5Z6GQhYs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8306
X-OriginatorOrg: intel.com

On Sat, May 23, 2026 at 02:42:54AM -0700, Anisa Su wrote:
> Table of Contents
> ==================
> - Use Case
> - LSFMM`26 Discussion
> - Updated Design Overview
>     - DC Add
>     - DC Release
> - Series Info
> - Changes from v9
>     - CXL Layer Changes
>     - DAX Layer Changes
> - Testing
> - References

snip

The cover letter is missing the list of patches, diffstat, and
base commit which are all usually at the tail end here.

I noticed because I went looking for the diffstat to see if there
might be a Kconfig change. Didn't find that info here, but very
happy that this seems to require no new config parameter.

Please bring those sections back in next rev.

I did fire it all up and will post in the ndctl patch first
findings.

> 
> -- 
> 2.43.0
> 
