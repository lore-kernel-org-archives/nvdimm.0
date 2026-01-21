Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6AD2C0F9E
	for <nvdimm@lists.linux.dev>; Wed, 21 Jan 2026 00:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768956040; cv=fail; b=P9+74+jjJUg75gAz64Z3wFn/IWOYmC4seTr26HnOEY/nqT6OilgP0HvW2CHmJEprKI3Fcx0l6sYkaPmqCLA068BJplFc/fBZdkOrPLfSLox52hCPzjR2Q1FdmkmTYg6Urv+z+sr1QiKDZtdIrVdfqHR/giyX6QIyXV+4/WMEk6Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768956040; c=relaxed/simple;
	bh=qeYLY5wGIs4OQytBheruw+RjhBJgx8NUGq8iYiuMSno=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ThDPguvfyhI6JWG3uqE0EN+uD0zAiEY+p5RfiupADjswUoMDqWUraoIskO/6L+LS5s0rzjgToOS9YER8qLs5dg8+7k3Qa6cKBYHhCTapYB5BtQ9C110Cbz5xQpuKHXDj9tVYnbxhsl42t5lhvcVemMHpQ5I/+iUYHNw2Csnxb3k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fn6tU95s; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fn6tU95s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768956038; x=1800492038;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qeYLY5wGIs4OQytBheruw+RjhBJgx8NUGq8iYiuMSno=;
  b=Fn6tU95syuzlgpFOChre8psM4iAQlhIr+3AEWNUKUyT8gyith73EhVqA
   QbJfxjshaHDySwBCSUQGH2mRaQ4754ULgRfC6QVRmkXubrlnWl9pWB48i
   7wZtykbOD8lHwslO1/bp7oRkLTNX19RkfjUbNI63HhebbkAfrAFnnq/1J
   nSSCqf7Wy0Ou7FJfRDHmcnTNvisBopJ7RUxvbL7B+8me1Qoti5rl2MH3U
   K+s6skyZ4aHgmtWOicnqvFOvE2vEIz5uPb4GMmtT6Pg1pn34+YVNOceeD
   ucSqbNKn0RGctoK7fWphnDObd2OOx9+BNIYuG086/AW7PwDutLBTnknmj
   A==;
X-CSE-ConnectionGUID: ipVRdQxyQfGRxRYoOMIKqw==
X-CSE-MsgGUID: tdQ1fEpJRnubcBzdsrIPuw==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="69375497"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="69375497"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 16:40:38 -0800
X-CSE-ConnectionGUID: Eu4uqRtjRyKEZXQ7UMvgwg==
X-CSE-MsgGUID: ZYdhpRDKTeS5Q/z1FIgONQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="236940480"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 16:40:37 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 16:40:37 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 20 Jan 2026 16:40:37 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.26) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 16:40:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iPWGXg7y/D/H6Vymd/0oE3fuOtFU7L7ZGWVDYlSdL4xvRrcGloiGt1//oSdE0dOSnUGEHDFkwjcFrxwuN7tmLAK2LzRbB45AuyiIoXa13I0MRAtfdnRHm5ZoqVJLK2FFIfC6wmWVOrHTa0EWgI27TBIIinGuRXS7Qx0DtBOHOYDiMfdnGub/mcqj3bMyvzW4mWBpGR4Iz290DHSVFniAlCqC1yW22CfDYdi6Vvyf57ilWZvcwE+ZFnfnTIPsM9M20EMdpj5ElJ14i6GbslOs0BeKGiqxgAANELo+ociXmATD4fmNaVo3wH5wP54me5QxoYS1ljppBIEqJInPIWSsBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UOjC5PcS+JBZH+ePAyczT9WcR4oSYxy2ZtIJJ9sew7A=;
 b=IB7hfQEFnT193xrxwFF6rcQ1eMaU0WClDCtit6wJdu0RpKrUou3D3jfIk+S6P0smHzPvAhDxrK0UKw15rXrlyDRoV3t0N+H6TpK4HK6YHq4bLFPCK/yYk268GLF+YkUxJDSxqTHAp3khpIkgylRJ+3ZB8C0mHrKgTsNsw73nJiaWNVAx+5wPEoAJgETVNcU7kNVe/bmO9firY91Zbf1V/8Whm6FXlZS5WGloFFB3/945yENd2Q0T8xekSSj8+NtAf53qrbBunJfJwoM4QZ+lsMQyVxn+P5U56A+1+TXnoS25T/pLMPruuHyB1dBqoMHXM2Sp7t7dqlDINoZeGa9YBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
 by DS0PR11MB8229.namprd11.prod.outlook.com (2603:10b6:8:15e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Wed, 21 Jan
 2026 00:40:31 +0000
Received: from IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2]) by IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2%5]) with mapi id 15.20.9520.011; Wed, 21 Jan 2026
 00:40:31 +0000
Date: Tue, 20 Jan 2026 18:43:42 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<gost.dev@samsung.com>
CC: <a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, Neeraj Kumar <s.neeraj@samsung.com>
Subject: Re: [PATCH V5 06/17] nvdimm/label: Preserve region label during
 namespace creation
Message-ID: <6970213df0774_1a50d41005d@iweiny-mobl.notmuch>
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
 <CGME20260109124518epcas5p26832d0b4ae4017cb3afbd613bf58eabd@epcas5p2.samsung.com>
 <20260109124437.4025893-7-s.neeraj@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260109124437.4025893-7-s.neeraj@samsung.com>
X-ClientProxiedBy: BY5PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::38) To IA4PR11MB9131.namprd11.prod.outlook.com
 (2603:10b6:208:55c::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB9131:EE_|DS0PR11MB8229:EE_
X-MS-Office365-Filtering-Correlation-Id: 112e8274-58cd-4771-4fcb-08de5885ae69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?jTGiHQ1KbV+dN25Rst9QZIodtp1C/gZ4WwMoRrY2jmTR6nvqJ8wLRJHq4TFZ?=
 =?us-ascii?Q?utdqsdMTW8T21kFlAaJ7TUx73yi5ioGttMvNBAzkIOpOSphSRUvP6oyC61tm?=
 =?us-ascii?Q?uwu4Yp9JKawxLLpmN3Bpt4RW/KBb7RGKGRZOP63AeqXidjOFgUHpUMbU3ARs?=
 =?us-ascii?Q?X7ZZpzamu3/FlRZKBImumL4aLR5nZ9pZiHQCGcIaK4hnda3KETsCtC143mfn?=
 =?us-ascii?Q?DqU4i/+V3aSAk6yiqHpGg3sbcmR7xaYGt9iMMSWd6QOu8ok2pzGCkg4B9mNz?=
 =?us-ascii?Q?l188hzc3oJSGO+tpQQleRbD9o09ARq8GSw+YFeBKsQ5ogRoNsc4cTiXF9OvP?=
 =?us-ascii?Q?rJifb9h52cRRoygFYZ6YMK2IOJsdmxsaQknP3K9RyzK9sLNTK27094PawLQ3?=
 =?us-ascii?Q?ZQ2k03F9KYog/Pp/2dJVkOtilLmJnXBYHPxbLlaaXMLxJaU4BoiYUxp1pOP/?=
 =?us-ascii?Q?FNZ1HvxgA5CRp6PUaUGrcvgYOV3L6fb76CEzLkqaCqe5OUl2Yd6MduwXB2AT?=
 =?us-ascii?Q?Q+H0U96OpiFdCsQREE2GE93V8GPJXvCAaWLRfoqwj4NrWjIzPMzFUcwEEAqQ?=
 =?us-ascii?Q?xZPgzo7EekY8l/f3qwrJupG6FyPfSQunoeeXv9b8DsnlCobcQyyY2BMe8nv3?=
 =?us-ascii?Q?afhupTuWe7CweCq5/lJpqdZY9ZVpOr4V9thuxS86Rcw1+VctQmCdmMPYJj/D?=
 =?us-ascii?Q?V4Gx0lbqQAXl9ixWzzed2ujNIusjXieT6q9rSSeaV5B+rXHoNJtZfc5YMNL6?=
 =?us-ascii?Q?hOhUUW9zO0pUOT+4CJF7qMky7QhDTCgU9bMOyf0chEIaAP4oCfn2uoB0SFsv?=
 =?us-ascii?Q?DGUd484VL4Se6sFUP6Ha8vEcC4Qn3yqDdsJSs4j8zeplgSU6ohESaAnwsTWH?=
 =?us-ascii?Q?V/kfBozdPF96bhAA4ERYaZmQbJIw86t7d9hy+xEGYa4ywHEHIWKaYmuJdvOq?=
 =?us-ascii?Q?q4/P6WdiBlXCno12ocXrpNS+J8eA9bPyOjlBRlDtaYSCOiag7Qq2earChOgr?=
 =?us-ascii?Q?Y5BV4jolSUYtxZdlOGGXJV02DJxd2SJ+QvOhpsHJtEmUwt+DBt6ijEkz9iOl?=
 =?us-ascii?Q?4zc3xofpVWIR/Zxc4OY/jz61dwJv3S4e8SCUU+yvDC+qAwtTZhj3Ap78GDyD?=
 =?us-ascii?Q?Os2ZGS1zIOv2AYKo+la9wretNBmrrsoYeyKLxoFEOZrGLG0cmjIk4uNcMXc/?=
 =?us-ascii?Q?SlmtU0Y2cAIYKGDXJjuQMDvyqUbNu4lftcLySy0NGgqHRHY3N7p0gS/cTsto?=
 =?us-ascii?Q?HP2JHL9UQlYsHdsiQog6OXx0xYdo0uUSI0iZHXfYZTUKVbSFeEEjZoW2MOGy?=
 =?us-ascii?Q?szmQCnV2yn/T+ChiYLNk+7oHdhSDKRS9zeh5yiSL1S0hSzCxkMyBX32BhcA2?=
 =?us-ascii?Q?jp8sWGNpxwa2NE/jt98Ub6opuTXXGTQZLFJQm6B19Jzl6J8Ww2IvR/EhdUGq?=
 =?us-ascii?Q?tm7ASAce34f2ohepBDw75mSwRrlbWoLnH22cdbl3b/9y8y1FJvEb3PuN+PFy?=
 =?us-ascii?Q?0i5m31IYTVTvcKJ7N2qvIeSgZ3UZhZTfqA4LLpz7TkkvxMATIDXOK+oAKcly?=
 =?us-ascii?Q?4o10vgihvwxF3zVpJS8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9131.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xZRkuYsmFci/nPkOsP9/k4vsmTMzd+/YoE4QuQHuU50B8aG3AyUY+UgYeNou?=
 =?us-ascii?Q?9L15PLI18yNVz5IoCbsTsT/vwSqYzz6DwzCQL52RxzfRmygrtxzOWZNJz3RW?=
 =?us-ascii?Q?buLGe4mHfwGzkUVswrWNkj5jVejlzGACb3YcbQtUvCPm6QL9Ak6MOg1PV4sQ?=
 =?us-ascii?Q?Z2GBpUTWVMD2h70MfOYqET608EdLSISYOLWhp1Arngqa42PeN1IHYt7b7vgs?=
 =?us-ascii?Q?rtxE+z6jpWm+hqg6+6xF/sj9dvIPWHtjm7oA+VnlOpJLDpTEgJtzARiMTXV8?=
 =?us-ascii?Q?qijBxHhk/mPAgo2EGNSN9AY967RXlBFMlzxR560RBXcvOiWz6/mFtr7YHIbF?=
 =?us-ascii?Q?4CLNCKu45NyYXrpaeduGarYN5FCbhPsErFPz8zIlxwOX0xrB7uYCJ7/4FBr0?=
 =?us-ascii?Q?NeYU1T52TjupCKpYKmVMK23UV0Ev7c1IAXMKKXj/SvGOw2sFUmpDwSUC/noU?=
 =?us-ascii?Q?bBJVkLuSwjjNn+dMKPJbJ8lwkA9DKaPxzEI5UAcYFaIY0QjKWKKT4DjhIbB9?=
 =?us-ascii?Q?tYP6BY/euMnWJAuFTLAVZ68uDcMl0MzUFPqF8v0v+h41/oPFymJ/Byki/4PT?=
 =?us-ascii?Q?4qQQ28PZjp+/8glGAXd0bBU7fmOm1dnAprMojuVCH+CsTbu+gGUnOWZHWauR?=
 =?us-ascii?Q?DDQHTZfm4IQ3N4000CgcKcOJVRwY0WaqVB/2LGZWWTQUFkbBZVsoDwKCXUcK?=
 =?us-ascii?Q?r+VN2drur8cHa6S9KR7CA0i+uoz8nV73X/ci92RWgRjT/G2zLoNhXV0+7XKd?=
 =?us-ascii?Q?wumqdzSvqcTGqRf9yu77gTnChMRmQ1tv/te0/uYP9SMzOitxUzs5QUJ4htXw?=
 =?us-ascii?Q?7zZqb8CQTsyt/TsP8Brv1CrpVojfklM3K1dKslW4r1+stFc8WBlc15nhanVT?=
 =?us-ascii?Q?+x6gk31XXiCH4x1aC+hkwy/8wpORLl5ZVQ54JluC4FwGzGn6L9xLbjPGwheu?=
 =?us-ascii?Q?9xO/ge8lGSIJSgBKmnLCehRHw/8B8UrI33Ayky7KLmahpGoyrwJx2yLIGOLZ?=
 =?us-ascii?Q?ikIqp+hG6Mg4l13Yn2ZZFXij8jTttLMhtmqSRTlReWs3JAPyY6TXigXayohf?=
 =?us-ascii?Q?xU6t7DYrwfLi5IfZ3zbjx9xyxBZTqVgXDFsOosiPcAUrB3zeTU1Y2woSVu3S?=
 =?us-ascii?Q?KGDCQtyVUplbo+SDHI3Rsh9ZJ0AMRbuZbVS/U5uIoc9n3qkb7n1YeWLCHB2K?=
 =?us-ascii?Q?mNECjyQubWqn5DPNJ1bRiPQrnPqK3+Oka22UfAzBfbjHQrMGFlRzrZ7QYwm6?=
 =?us-ascii?Q?SFmlelCZM8iq8WO7JtKe21lNLGK2XCtrvHM7zUwFcteFTjDD2LZwKWDJG7Tk?=
 =?us-ascii?Q?FpAJbMI6onZ7tsMFWeN6aFggJJWUYVafOPubuDbd9+PPo1qoaLBrQPfitrUF?=
 =?us-ascii?Q?rhr2QQUhhW0QsglFW/tTAH8Hs+n3CRrOj48VIypOJ+b8QCUn8Vn9jkL/KwFD?=
 =?us-ascii?Q?ZgByPmUw0hDzQS6wSJa24/N93hIVi+5HJSFRWYm1ICMH0vY+xr/2OQmWi9VG?=
 =?us-ascii?Q?Q13rtx+rxQpgpNPYUwqXuhebqlQ4oUZTAqRorwxai8iC/iiwN3bvYkcpgJRk?=
 =?us-ascii?Q?wQWW08KTrjRC2j8x9DuFHBNTj9AWuVplTKZnjw+M8qAPx1o7JjH1+l8+Ret4?=
 =?us-ascii?Q?S3rYEa5FLsGBQBTfOr+cFENWR1bdWDm+KwesDKW1rLq0qyIbBOgcc11o/n6d?=
 =?us-ascii?Q?Gm5afwu3j//wrmKDd39Zz79tIG4Mk73K2O16qgOXCHNyRaq2Pmly8nMPrONP?=
 =?us-ascii?Q?H2sNPnQASg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 112e8274-58cd-4771-4fcb-08de5885ae69
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9131.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 00:40:31.4308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nU1L9N25FgjtRNqPlihMEpppwlchzYaZykqSB1CcoSIoT8Y0XABZNOAu3gmwIq0dAw6A7LooSYzxwHibco9Hqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8229
X-OriginatorOrg: intel.com

Neeraj Kumar wrote:
> During namespace creation we scan labels present in LSA using
> scan_labels(). Currently scan_labels() is only preserving
> namespace labels into label_ent list.
> 
> In this patch we also preserve region label into label_ent list
> 

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]
