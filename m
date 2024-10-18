Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE32204091
	for <nvdimm@lists.linux.dev>; Fri, 18 Oct 2024 19:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729279943; cv=fail; b=e1JuOujdiCGY0UL+CMzXUpGbdGM2zt7nLxuQQTOw+URZNJVWSVyMpG4dEcWg1O1ynDwRKoNHe78PZFwA9briILp+Wbcd9ZEjLC4Zzq/2DevqJZIqfasJBogHli8I90mtRmvHv3MFnbiDnAGEn5SEuVesnKPHwRlmel6T1qNhFqY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729279943; c=relaxed/simple;
	bh=TjfmZVmPqvWsur+h5RDO7pDCjQZGh/4W/O7j5ZuMCHQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LkZjcP7IkzhJ7odJlBk9gP60WzkiTdtHe76oj/MGdYodn7rTvTxZAnYhnnxwUo4SDcAY5unK/D/Zwaqzo9iUyL9RqWHauiYuX8GwrUV5s1MWv+RN+UNY+lKU0WKVPNQeKiQrDovbcSx3Eidlt8otAS9bXzAtfo2YD5w1/mZ3yN8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jxZNsGhQ; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jxZNsGhQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729279941; x=1760815941;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=TjfmZVmPqvWsur+h5RDO7pDCjQZGh/4W/O7j5ZuMCHQ=;
  b=jxZNsGhQc4LTzqcFAd8hdd1kwAz0aCe3b6yRhlbbttVgL6T1r35f1EOL
   r2mNOystFQva1KifWJHCzl56WhURsalPcqa9Rz3J/FFIt2KH3iCs9og6Y
   /cO6dStkJBr12BdjWW0lXLGwqXwJrYXRPke0KVMxQU2or7jjRNNqmzFfJ
   21ehTJRnSRxPwthORY1dD4xyThJMNRlnV5z6dzmJm9elpv98H/aaB29/c
   lJSRUqYu2cgMzTFyIw4ZymjhDL13xAyTTP3RJ7AG2TCCctzOywBg0SX8E
   EFxO8asQcSswnr80qIPGQh7VEnQmZrXRoGNYcxAc5dQC6aXQclqnUChWT
   A==;
X-CSE-ConnectionGUID: OQNxSvQ2Rt+Lsjyz8MajBw==
X-CSE-MsgGUID: xONt8jMXQcy3V+uK+nqRtQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28783762"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="28783762"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2024 12:32:20 -0700
X-CSE-ConnectionGUID: eLM73JmrS0KxKj/nUrMSsQ==
X-CSE-MsgGUID: gccg3kymS2OHFwIRKp/aZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="83782335"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Oct 2024 12:32:20 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 18 Oct 2024 12:32:20 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 18 Oct 2024 12:32:19 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 18 Oct 2024 12:32:19 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.47) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 18 Oct 2024 12:32:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yeYL4ZlXAlY0kV31InoQYdnkgBXd2h+yldYOgWkac+PeTN1m4gOuH+DXtupzBgVoq/DyuTOMLQ/RJ7/4O3qsdYCpkkNIkIYo8wtdmP/MuXPOeHZXmJ9Wd4CBQ3tYm1v3Osf9hjkhNI+0+q+54g19IxV+iZb31yLO6TjFEDJPrHqR2Tsi6X7A/e1xZq4WJX/lCyoJl+bdHAtsE4LTkBG9BxUjo7/Nc95Fgh8446tQo7H7qiUqLj/2Ycvdb1A9Qazw/0qXwRc1Z1aM0eR1ug6JnJyqLLp9Wjdo4oOFXk3ZUwoSmPKwLgUN3dkK+cpAcPB63/LyF9pl9MDd+I9FzBzzxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qICsmAD93J4OgTW4eDlf2hGZe9och4BRfo+92/TGS14=;
 b=hLX6nJoP6tDOFugm5MUTl6UVJjWOmwPYRJe9nJCVc7SUA2F6gX7ykoGWcZNvHcw0xSs7ZD8QLHmEsAHCmAMUxWtWAuHkySiBCvQvM1xiKcesI4lrHIfqvE4Wwt0eRIxgsPC8BSJSfpbhcAF+FtvKg9yu7EsZWm+8Uw+JiuYU/whZK0BO2fcSW/6bEJV4ssJNRLNtmJbK31vPG1jY+7SNaTZMf2e+/F6fD/VAMpPQ3e2qVIAQJ7ETuPOYYBBSsiFGDRNO9uAEaVe0BIeDJeleDBbokuwHLQdSXHeaeV5j1lw0rVI9HWPspx0F8rPfwi5D97qnfM/vOFnjx+iwItd5Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.24; Fri, 18 Oct
 2024 19:32:17 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.8069.018; Fri, 18 Oct 2024
 19:32:17 +0000
Date: Fri, 18 Oct 2024 12:32:15 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, Coly Li <colyli@suse.de>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: Removing a misleading warning message?
Message-ID: <6712b7bf2c1cd_10a03294b3@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <15237B14-B55B-4737-9A98-D76AEDB4AEAD@suse.de>
 <ZxElg0RC_S1TY2cd@aschofie-mobl2.lan>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZxElg0RC_S1TY2cd@aschofie-mobl2.lan>
X-ClientProxiedBy: MW4PR03CA0352.namprd03.prod.outlook.com
 (2603:10b6:303:dc::27) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH0PR11MB4965:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c7a06ee-aa95-48a2-6777-08dcefab9379
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?2aMdaOVa261WvVVXi3jd/dpKFz2aLgpOj+SEhePfgoa8gZEIpYCgoS2jK0QT?=
 =?us-ascii?Q?Ystg7I48q8DM2Ri2NUsI8sx5HhyNW7Q/6WYHcjum4deiZD/Vb2nr0lZ51HfW?=
 =?us-ascii?Q?+s70PJ6XprSIRjqiMUiA3bgqlRcNzprEVY0stFkgZJ8Q5kVu2fUxH/3EmSFw?=
 =?us-ascii?Q?PmaK/pm/LPazeC2tVd7ipruhK8c8z3IgYZaTOi8SgwjiA/R4u1IhEmAIUO5+?=
 =?us-ascii?Q?D4yoGLscYLUylKOTnLAlgmr53ugH5nCqXWEaDUblyZapeybC9pnLunXAzcM1?=
 =?us-ascii?Q?ac7AAbiWytAwKl+I0kA1c4sVTPyLQ8+rptAQlTQLpBgTCRfEnbghtGTVJ1Ua?=
 =?us-ascii?Q?hKwqHI9cbBsQ5cG1Z0/eXg+PUY4+/bTRYA2WjHKv3coop7cxblihwbbwqAgp?=
 =?us-ascii?Q?xneT6k+swsdLEgQWA+XeFlZzDL48Wa4HqW1H8/emcMF1qQvl1LXBfb11yMAn?=
 =?us-ascii?Q?Px8kt6qxsrI7bx47kwtYmv5GCkQQ8NLcH19p17gOrDTSZHgYIvxA4HspNiJr?=
 =?us-ascii?Q?CBvAGnuwfUomb+fyw2Ya3Gje8LrgYYyP0eXYfTtbSDlqZExjtmNsA0KBycs1?=
 =?us-ascii?Q?PMijK/TeceRlrUtVOJzBShFfkj5s77fzXkkHV2RJFuYQQQylYSJbukKqm5nI?=
 =?us-ascii?Q?UzspFIN7agdYgZC9/l0lFv5bKFnTmAylsZ/+hAWts2IzaIpQmvnSbAqJBUce?=
 =?us-ascii?Q?JiLoA+FprkY3ops8BXfhDR4d5DjbdkBQDZ4XR5on2HeLyL2HWZTOSnz6a19z?=
 =?us-ascii?Q?SanaPii3QdcHASA37QcP5BbTlV7oBzMzvZLsNLI3BQoi7V2/nL8PwU1PUEzy?=
 =?us-ascii?Q?TH4By7ozAH5jSjr+zraOtTDrEh7EYTC0vseXpR3q//ydunNvptfuXzy0Qqwr?=
 =?us-ascii?Q?wEwaygv9njyTirJECigzcWWEDT5S9vFEEcT8NjyjOMN5pBheSrYOKDy8Zozp?=
 =?us-ascii?Q?HiiExAwIpw2oTQAIcUDZAmhjVrj2o2OqFal8wm7jdiibNSEdEMXTMYBoGbqr?=
 =?us-ascii?Q?fgJZfdmHGgVv8Kg3BKY8E2y9ps2dXvXDxRdAOsgOcyn6Bm9K3jhhXbKpEJqI?=
 =?us-ascii?Q?KvaqqGAWSO2S55PPr2Ro2S30hO9TCPrlVba4LVMy6MOsXH2L2K8qO2VxRcHL?=
 =?us-ascii?Q?DolV7ApIDBRp3ePGDQiokaBbkmQJqAZfqZrj+XtcxrQsjMu1YgBXucOYwjq8?=
 =?us-ascii?Q?Rd8bbkQF5IyPhYuVBE6pxSKuhlSBPI08ZJ9PW1b2/OgGUuraSgclLmtzGKIA?=
 =?us-ascii?Q?tFdkUmHFpxabvJZ+O38qn4Azrtfxc55mvQ4KMn5QA1BM++CagQ4Aps042w9B?=
 =?us-ascii?Q?uFrkbSJJVnBOkrApXJdw79XQ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z5emJ7dPPDj2XZlKZdaa9zfLpu3VVhGDwY/RyYQF//hzu6+gvIUOdzjArKDu?=
 =?us-ascii?Q?naQvYIj0qo0ko2tuWDGrAS8tDG3NAOXLB5FdHrifCzmmI8+zn8XwRh0j91JA?=
 =?us-ascii?Q?FSSwpfIdtw2BRlYME3zZ43nG1oDZ+z1qwrdunbpYQZssAMTOAG7avknVNSkM?=
 =?us-ascii?Q?5cSdgf65N4Cg8wUCjWO+h9hFB341wmMyIw+FMIGAyiQLSvdziPQKEeT1fSjc?=
 =?us-ascii?Q?K9loux7V9Gz/E8W3Wdt2yZStTxOS5dhwJW5XIF6kmAM6CkxCKrAu9sb3Yypb?=
 =?us-ascii?Q?J1JqE5R6goRTklLPrBkVvmWKQIovA0TiNyZFR+6nTeb8rOStg/fsehCdvcOG?=
 =?us-ascii?Q?KQC/RQev80LqYKRHRxCESUcxmvyipqMsEsEQvum5enUGQKdhzEWJlgTju9Sf?=
 =?us-ascii?Q?gAMhYHkcY2QsCyQjZGUL9rpobCD/PN/uC/9ZhabeOlrL2JlsDtIxxc8zOPpf?=
 =?us-ascii?Q?YL5xFddmZyAhBjA/oq+xDFq/Ul6POpbT77zeHV3eLyPNZYbzEJxZQ5l1r0bl?=
 =?us-ascii?Q?8hnZKagwLsZVi0JGJksucS4X7eB52mQR4mqA7h4/j1wZEXVS8KSDZ/JOeLMy?=
 =?us-ascii?Q?10f5C0HHymhIcyDJEse+f5wXhw2uDD7A3GiYvDcG7GQRcmEgAF6niyp1VfoK?=
 =?us-ascii?Q?P5oRrt36vSiR4VLVi9GpTcbbUkSlgco3dZ+v7f0A/SYc4Klb0PSyMj1oXYMp?=
 =?us-ascii?Q?gi72FZTef0A/ODh8vq2Zf2tcPsDHj1G7njL/uls34oywKJXrxyhTBROjgKMO?=
 =?us-ascii?Q?J8OPEpgPQnjWieevUjY+xheCqGoLD2467UWdvTJGTE9PxWbs9dA4ibdtk7KG?=
 =?us-ascii?Q?smqLvY6ecl6KoDan1tIdhpxAcsXxyDP7Ai+ObsmJl78I9/d/W8INF7SoZGay?=
 =?us-ascii?Q?QhB8QdjaUK+TSBjpqgDmyiWqe25zonmAhMBxvbgk04RTzsSJw+QHsdXvU5gd?=
 =?us-ascii?Q?rGjwK5i/VWMIIB+7ibakfzqQqwXf0mEQcMvWqYqzpm9A9tBXPMJdiScgzbNT?=
 =?us-ascii?Q?++a0IGSvLpKHSRMF49712xAyZNdoEfHmvodKkIEuX4EnIhLlZ2Vz252e3RgJ?=
 =?us-ascii?Q?jQ2RFEV0Irm+ZMFMVBBbfhvwjYeIKMFHhQ00SE6D0zQjbG1cFKsg5ppKcmE9?=
 =?us-ascii?Q?09rwwAB1LJ/KhJ5bndcgCHDJ7On/UwTVeKMvnJx555Xk7PYKia/eCTj5ob43?=
 =?us-ascii?Q?fks229kt7oLDqeQmzrRDcZcjuUU1O5FcuxXYI2fXPSBB/bk9lEEHE8QPCzWT?=
 =?us-ascii?Q?VphS7Dr/PCpIVL+MWpHQBRP9BIyo5WE9A0AcuWLqK7hKb/IdZiL/cPV7FGv7?=
 =?us-ascii?Q?kuEYV0h5z8BisJT8kJN8dPBo+z6rhIpQMqW/eChY3TvSKGNl1BUZU5lJ16e0?=
 =?us-ascii?Q?OgL7teJAj8GeJB3Y/gJcmO+0Vm37aGG23btovCHq1gNHWYWmzACuGqT7kYci?=
 =?us-ascii?Q?bMfO879k+m8wHB2KvSwvpKC5n6n8nB7T2B1nrbNq9QU0bakamtWnkM6zOrCI?=
 =?us-ascii?Q?NAPA2uLJXADUEL0ow22VjvAY3ke3UZpAvkkdM3oyFZ6ZvBsDmmWDfMmNGiyi?=
 =?us-ascii?Q?1oxq8i3Via4uRyiRjc5hrxasNuerGpMi1uAZKEe9OmnNx5gldrEdmV+68Quh?=
 =?us-ascii?Q?2w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c7a06ee-aa95-48a2-6777-08dcefab9379
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2024 19:32:17.3840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w07GS7PpJIlB9nibpQZHECzX1BnjxQjjOaWnlFmo5wPalOHlypxXxm9UZoEii6IzdI+Mp5fSug5J3+SozvSgY2QAWC+PdOXbRLaC4sI+wfA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4965
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> 
> + linux-cxl mailing list

Thanks for forwarding...

> On Fri, Oct 11, 2024 at 05:58:52PM +0800, Coly Li wrote:
> > Hi list,
> > 
> > Recently I have a report for a warning message from CXL subsystem,
> > [ 48.142342] cxl_port port2: Couldn't locate the CXL.cache and CXL.mem capability array header.
> > [ 48.144690] cxl_port port3: Couldn't locate the CXL.cache and CXL.mem capability array header.
> > [ 48.144704] cxl_port port3: HDM decoder capability not found
> > [ 48.144850] cxl_port port4: Couldn't locate the CXL.cache and CXL.mem capability array header.
> > [ 48.144859] cxl_port port4: HDM decoder capability not found
> > [ 48.170374] cxl_port port6: Couldn't locate the CXL.cache and CXL.mem capability array header.
> > [ 48.172893] cxl_port port7: Couldn't locate the CXL.cache and CXL.mem capability array header.
> > [ 48.174689] cxl_port port7: HDM decoder capability not found
> > [ 48.175091] cxl_port port8: Couldn't locate the CXL.cache and CXL.mem capability array header.
> > [ 48.175105] cxl_port port8: HDM decoder capability not found
> > 
> > After checking the source code I realize this is not a real bug,
> > just a warning message that expected device was not detected.  But
> > from the above warning information itself, users/customers are
> > worried there is something wrong (IMHO indeed not).
> > 
> > Is there any chance that we can improve the code logic that only
> > printing out the warning message when it is really a problem to be
> > noticed? 

There is a short term fix and a long term fix. The short term fix could
be to just delete the warning message, or downgrade it to dev_dbg(), for
now since it is more often a false positive than not. The long term fix,
and the logic needed to resolve false-positive reports, is to flip the
capability discovery until *after* it is clear that there is a
downstream endpoint capable of CXL.cachemem.

Without an endpoint there is no point in reporting that a potentially
CXL capable port is missing cachemem registers.

So, if you want to send a patch changing that warning to dev_dbg() for
now I would support that.
