Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC6D50276
	for <nvdimm@lists.linux.dev>; Tue, 12 May 2026 03:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778556743; cv=fail; b=K5o9wlmGZo1d3G0k8QFb6ApZRCdMaaWXGQJIv2HwKAEC5iz2chkY3PH2VFX9K6FGQkO1lxrktm6ixZWMZr+ii2WbDxDm5Fv9MHtsMrgiTeUqEJqbJc0X+EHI9Ha9X8/0spWxtOy2ynXxnevvc0Fyt3pn2PPPZY/OkYTOf1Bdrdg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778556743; c=relaxed/simple;
	bh=bDMKPI9RD2erwA0iP4jb6dNjd9nlxmjZKMT7059W52M=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=C7bUv3Q1qmFGrpAdKaIF/tjjYC2efW2mjtpfuFldbCS8y0m8GKmqVFXBBnJTnkCFLb4zcqEDXP/AM+dv78yR+BdvOmcyV0W/Em//lXZ/63E6HMMBjplGQGNF4ocp8TG+mAIPZe8AonM51UILusx8PQhxAGpFMPJvNLmcqGdTHdA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nb/jIUDj; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nb/jIUDj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778556742; x=1810092742;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=bDMKPI9RD2erwA0iP4jb6dNjd9nlxmjZKMT7059W52M=;
  b=nb/jIUDjMpi135fN8wFa/RQ7H489Min5fyF2mte8L0uCwxoyBknEzT7H
   OawJtVSGM4OpX9zIU2q6RgMz30FYw2ICMnPQscD5kB7WU7mLierjxu7Uu
   ZAK/W/Qmr6qwJdz5z16Hke2huT3oZfiQM04oiSuRj3VIkLdzng3TRfPFU
   IXJiP5qaRemd9QRferNbCZrKRgkTmG20LdJc/ANZ72y3yClxK3uLcJCn9
   2S849R97xqc2PyOl9LQZljckovlW/iufWZiOH4W5kzE/HuW1iUENbivno
   LOwA58G7pBJU0OXBfXeBo6FdVHGVjijcjYJFz2Yw4yl/4MdOLwxNB6LFG
   A==;
X-CSE-ConnectionGUID: RvF1tWWyTz+/r4HV8C6b2w==
X-CSE-MsgGUID: eMORSf8NSfS3c2xJp8+uMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11783"; a="82021192"
X-IronPort-AV: E=Sophos;i="6.23,230,1770624000"; 
   d="scan'208";a="82021192"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2026 20:32:22 -0700
X-CSE-ConnectionGUID: 8efDjQ3RS0maaAcz4NA95g==
X-CSE-MsgGUID: u8x2lgtfSNKcCSDx/xFs+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,230,1770624000"; 
   d="scan'208";a="234595289"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2026 20:32:21 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 11 May 2026 20:32:21 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 11 May 2026 20:32:21 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.13) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 11 May 2026 20:32:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LbqPbPTZLVDO8KOYu8J90i06cKbpgQLTijpEdN8BjFGAF2EvtiEYiA/pzDCB3+7LbMue40vFIdDiptr2T84DqXTD1cLdOA25qg3pIP+fBQfjW+B+B2Sjbeo+MtdquoOLkNW+FHb801ZdK2nKFwtfUquRmvpx05A5GfQ0nYn5I3hEjcpM1LrRSoltU2vKY0XkXlDixDdgB7xO/ZZor8nOwCVbG47uqgXj5zfAHaRqXfrwuIEKl4aKn609H2RqU9bfJbKuGWdp+ffAOyZxUI4U5QXhZVAoka7GjOKaHK+iGJP0ujkNsGctg+fR9AXgpHbfwprqKIPOgI0rRq9pYWhJJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TQ4tfnIxamuGvnrUwiN461F0fx1OcPqXhfQQRVCnDBQ=;
 b=kXdw1+RaaQ55VvshDChdUuh/XR1o3eggCG611zcwRNHK4cvdxhb9OPPY2a0HGyN0x3O88Cdfpzx9USIG9KzTR/18bKsLS2iDhhmXhIBgW8ZuzTrutgIi2DY3bFCWqshWoIef7mwQyu66Z/RWJW5v36v3c8b+fREcfYXm+iC8MBZCh9+YMqlYdjaPNYs5gmGvd4yCDmc0FGXKZj58vS+p6lKcV6QGmhg/5qEMEICVIChYOSfkG707rT3p6yIrHr0dyDIPiMvy0mIch5PRlVmOEitgYWe8e0qnKmxrY6iktQA4V0PU25sAdYyHqLs3ajF/ykvT45EKEqALp6RkZ8JE6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SN7PR11MB6775.namprd11.prod.outlook.com (2603:10b6:806:264::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Tue, 12 May
 2026 03:32:17 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%8]) with mapi id 15.20.9891.021; Tue, 12 May 2026
 03:32:17 +0000
Date: Mon, 11 May 2026 20:32:12 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH] test/cxl-sanitize: avoid sanitize submit/wait race
Message-ID: <agKfPIco7XnwHZLd@aschofie-mobl2.lan>
References: <20260430021843.3919334-1-alison.schofield@intel.com>
 <7de20386-21d9-4e37-96bf-1e6397d4408e@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7de20386-21d9-4e37-96bf-1e6397d4408e@intel.com>
X-ClientProxiedBy: SJ0PR03CA0355.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::30) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SN7PR11MB6775:EE_
X-MS-Office365-Filtering-Correlation-Id: 51afe92e-70b5-4982-060e-08deafd710ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|11063799003|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: w3e2q9+R2iLezs+aD36IBa6fIbv2mWGJ92SUHgeCSi2CdXDcvnIZWyg0zERg3R8VUxaaW9UXZBwrg45Hgvhm43rQF8ZtKwftG69dSGevULAR094RNRXE8L4tddD3zYrncvpqCSNV+cGOkYO0komWe0edr+99WHUFSM/gV7Rh58Ov4ZBSMmaPWUF2UJvGq00x3eAIxRCychxaieCO6nXcEsnjVb6ckV/pKKdt+2ZOCMps8/mVrcnuaNt5DsAzX8YLQhe2SlutDwQOjMY0wTHSfjfD9cyEk6fjH5lAl0qAMESXzHISCq49DqW35AejoL95A+cdRHSO90pq/rRLyN3gjcPGKNqN0QHsaLqkz+aCYBtu2u/AAKVYMD6ijFEWLJPczmJ8vZwcLAuOdfKKSXj+B+FnB28Ug3XGISk+haivv0LeXBGnIQh7XCSaf43SSE2PRD5RAQarDJ/TVgEkFysamvj/nVonViqzqdV93dyyo58plFdauHUpgzT3+nWRtTScl8A/hD0VZ6JxonvCotlVSRDHYAcOpwiGrazUteyK8tSmmMLXQiXswsNiURnT3I/hxwQVc1Ktl+3A2NR1Fc3FHqrDlLciDG0frKwID2fPW0ZbXkGjEDs7R4diIMKR0Z5sx+SVIuowoPRq4fgvdKDgKjv1h4kqNwLcelgrqZjLFnsWYOnDcIf2fOiGSnOPeldsZIZI/hDuv2fN/wMN64SDRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(11063799003)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1LsLVF3022FfiJ/ONA1rSN3S/RLK9W8pfRw7kmDKNgSkT4Wr8viIHeWE+AQN?=
 =?us-ascii?Q?FnAWODy7B4xTV0jyWUY5Qmu4lq0CFOQxkOZvl5Gt9FHQ1RyuFcZwbk+umgC8?=
 =?us-ascii?Q?nUrj7Qz8Y2LOXUw5qamctYxICNW9EQL2l3VpMWy6RkBGRizggv0E+WEguGUE?=
 =?us-ascii?Q?A8fsCVQ0ifoeznV7Dt4XgHCsc7Rj7n2HFcv4e8O8Aw+/8nfuwaRJDe9IFxdB?=
 =?us-ascii?Q?Mg/e24o3MzwmueX4M0SK0jxmZBe19lK78IhWzrqOPxho1Hm9CY2rqZZD03f+?=
 =?us-ascii?Q?g2p8sP0oTtp5RCBZAacSpgXJEJe9CZZP1fMQDZBAnrxjDPLcGSjuna3VxO6A?=
 =?us-ascii?Q?CLykW1rMvVyCVWpauFKuqfwCFfJzBpxd072s2igLlBLaafhQMLgt+pefOJhd?=
 =?us-ascii?Q?uPRtGOzZ0+L7/+eGPXCQ9CQImOm+H18ZO4v+te5h0M7S0xX3q1y5a2DXeGen?=
 =?us-ascii?Q?EvWnSo15Ss22nYtAo7QRdMbHl2KeazZplShg+j4B6Uinfg42kulcjz2UTuF1?=
 =?us-ascii?Q?CtMF+zZ7/qhLskHNAsSk7u+6s3V1hz+6z/dAAqBcSIhToe333Fyw+rToBs1z?=
 =?us-ascii?Q?ge5Kuf51PAb3sSy6os+JRSUsr3tqprASPFBkwB7F5V/JTqnr0OIcO5Wyfxvq?=
 =?us-ascii?Q?jI0IxRvZrG+7ggDfF/Kyiio3VSSfiLht/390tsoj4mqfdEu0CODVrDtXp3AL?=
 =?us-ascii?Q?nzuGlCZCrg9qSt7G+ABf8q3PTmhfXPvTZ2G8YDulrmild6EiKX4luM42GSlV?=
 =?us-ascii?Q?jTSWN+xzrDdA456WW5TWZQVPY6ghLuEq4IF4TrIkZgjTJ1v8fPVvRIz/uNc7?=
 =?us-ascii?Q?dJq4PvRRdTTFUCC84ZYQYYGY1AAUGSz4/oFZKfZqCa5CFnIlbgfSdr6pic4q?=
 =?us-ascii?Q?7qJGRW2AE4m0kiSK/tFMtYOsnfs6ABU+7dFpeQ808m1luCQTyNtYZfVaKe0g?=
 =?us-ascii?Q?s3n4MgDrP5KzyBfdxe0ALG0bwB3O1myNmAvqZ27G6OIOp5blszb609crN+mr?=
 =?us-ascii?Q?sQ/JeocDbt02xoTbLCBQR2ESXMvVVxR7LcGrgWGO5rNUWcuZDXcrDmMdTD/c?=
 =?us-ascii?Q?JsJ4gyuvs7ARwZCBplO8Ir8VFDoqV0y/VoAr+/XYr619MQYPUz6fN7aNMHQs?=
 =?us-ascii?Q?B08O8pl0BxEKWPiYpt2y5AMGY09MuRe4tDy3saPc8A7KRuGhXMuwy960JrNl?=
 =?us-ascii?Q?DZ+1iPFHYN/MCqgXXSbL81zkys16nVRR/YA6QXQpreMUfhDU3j7UhwOlL3yj?=
 =?us-ascii?Q?OI1jgB0PYMM7AmDDr+p0ntr5EfrqEV2CL6IIzEzdhPY43RYznRpIYUXg350p?=
 =?us-ascii?Q?yAf5drPn8r18B0WW098T2FcC4/lA5IWu9bFf/BN3q4L1GLtsY562IeLDXORW?=
 =?us-ascii?Q?o5iX8ONP8wVo8iSHrwrvV5VCzau2r1W0Eheu9RXUuhkmO4xzPtGzXqY8+w7M?=
 =?us-ascii?Q?p5s8tuwRejr9SJK0a0kVeeVZncZkoPSNv8QchSDLdVGhNwxVcJhA4FY6X1ut?=
 =?us-ascii?Q?RJkZcdZSTaEY1rCiz46tIB86R6W1RBiOPhiYFc2cRbM5+qq1L03xZ+5sPME5?=
 =?us-ascii?Q?xgxrFS0NH79Ta3xIpp/IK+sW1kDGAW87EisIxyomlnXk3qdPiD3+tlj0Ij7Z?=
 =?us-ascii?Q?CpVXvRAo/vdxPaYYf7m/kJrN0TqJjf3wfaLG+0DIXBy8gRxGmpH/eSznO3m2?=
 =?us-ascii?Q?R4xk8TFVGX7Qe52YAQ1NxMhpGGRF0D97tWnKgpjN+YcciONTKAn6plLytlvn?=
 =?us-ascii?Q?44cI2PFhFhCOGavsdKySPSqcmGhvCtY=3D?=
X-Exchange-RoutingPolicyChecked: F39beym2NljQZbeszkHLPYH/LwGb/I4iYc5NrvQ58rgZ/Sq2s/0UpDds8ngFSvskX+UFNcZe0XrR++FAy4SNYQ7OnS8snf4EOnkuG5BBg+vc1eRseHgAdKQTUPWBFIVCAoPkDAMMsAUChV1Uhowi5PoRNuI/A2DpLk3JJK5NCuX4qS8MO5x0iuitY1Hmrc4/tU65AMp+YDIb1JH956V/VWwqnbsoVNWVFVqA5OUrK545SytlWEdg8uOapW6IC7I6LLAL378QOittySUUizUAOht2/EmpI3iF704PGn92vxjxqwbKuTnosRqC8ehtJ7OO1ypZLBIyO0gaaBlZ4etM/Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 51afe92e-70b5-4982-060e-08deafd710ff
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2026 03:32:17.2624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SXJxn4ycRoYrHENjz/jpLvMQWcnBFFA52kUQcp82qeGjxYVRq8T36mz9Xh4jMs1WC1VXbG/FUYoCTfJcQQ17e6MbMm4J2wyQ29f7faEy/G4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6775
X-OriginatorOrg: intel.com

On Thu, Apr 30, 2026 at 09:31:42AM -0700, Dave Jiang wrote:
> 
> 
> On 4/29/26 7:18 PM, Alison Schofield wrote:
> > This test verifies that wait-sanitize blocks for the programmed
> > timeout after issuing sanitize on an inactive memdev.
> > 
> > The sanitize request is issued in the background and wait-sanitize
> > is called immediately after. In cxl_test, sanitize completes
> > asynchronously via delayed work, and the sysfs write does not block.
> > This creates a race where wait-sanitize may run before sanitize is
> > observed and return immediately.
> > 
> > This test has been reliable since its introduction, but recently
> > started failing consistently in one environment, suggesting a
> > timing sensitivity. It fails here:
> > 
> >   ((SECONDS > start + 2)) || err $LINENO
> > 
> > Add a short delay after backgrounding the sanitize write to make
> > sure that wait-sanitize can observe the in-progress operation.
> > 
> > A sysfs-based synchronization was considered, but no in-progress
> > state is exposed to user space.
> > 
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> 
> Looks reasonable
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Thanks!
Applied to: https://github.com/pmem/ndctl/tree/pending


