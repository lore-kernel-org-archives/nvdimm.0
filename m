Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AA11CF7BB
	for <nvdimm@lists.linux.dev>; Thu,  7 Nov 2024 21:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731014908; cv=fail; b=iQ0/Z57T9vj5DZ7F4s8497T4Chjdnhovos53Gb6KGwx/wh26OlDhqEUWIodv1XULwzbqjlW9S+LwVVwBL2/tHR4HXXcPF2KVbyMof0PckAx1+Ky185t2TsMAk/Lo6SeE3EvckQYrVkinVGH5tfY0hKMkdDjH1cJC3dEwfc5YuvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731014908; c=relaxed/simple;
	bh=NO+n64gSIl6a9NSGmrydMtPOUXdyJ4dRwTYubnrDuSQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sAfJ7N9QSdFYFKTgRJZIgZMhPrchIogjZJSoBq1ZQQ6ygfqpnFxR2N7sek8gT6yOIfJ4bpOLsul5ULMIT+xF/AP5NGe1UDJpTG7AdSjBGBA5Y3Rhq8nO8MMmisGumakFgliYkD+i+DlxMZEAVQG1Thy5dMbvfOFEdohfi2r0M8M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q1sjyEDD; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q1sjyEDD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731014907; x=1762550907;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=NO+n64gSIl6a9NSGmrydMtPOUXdyJ4dRwTYubnrDuSQ=;
  b=Q1sjyEDD/NuvNGgiKZKjDoqJc3TFPpie9w0JA8us7mvoIw+7R4P+Sj2E
   Mrr3EeJH3T/htZtSjnmex/jtau0H5KzMKXat+5l1BXCOrqB8Q37FO4GOS
   W6i7THsY0131AMLHLRzOaPJxABDkFJSGae9qSqmwStkjUK50fdziH/db9
   gGMmkzI6BPItK6YZslk0aZEFD7kLY4B6GkgQuPHFkP84jSpFm6mLzpI+m
   lpIs4bWFSdigsXdGCzxhgg+kvjbb3XWiXPkcb4uZsLKVu9xiyGiFfJLzb
   rXSy/FmkW1AGFoX0KLXZhFJyv6mYPQPjltV4cD4v2Ptjd/JGYxn6DXtYl
   Q==;
X-CSE-ConnectionGUID: mJMrIa7XQQWEx2BJnTbLBQ==
X-CSE-MsgGUID: jl7NCnLARQuZ0CmxhpHaTA==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="56281927"
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="56281927"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 13:28:27 -0800
X-CSE-ConnectionGUID: 6t3iufltRG+cQgrsqRk2bQ==
X-CSE-MsgGUID: Nh36Qz+oScqSMO3IcTeFpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="108513674"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Nov 2024 13:28:26 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 7 Nov 2024 13:28:26 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 7 Nov 2024 13:28:26 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 7 Nov 2024 13:28:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D+B469Rt/M88vDHROJ7kB0Ko6oXfYxw9I8h53uqZmlg2phoFcOpEMbP3GndqeetXyr8wY2TAcf/+k60l9agCfgqNLmv3BTMVwHg5gIgB+f3qXbz19/+WaL2dKjX2H8Tf2f1KnsWmcPwUsFRL1tEcGavG/42LUWYOqqhqs3RceUBehcgYlWg1vpLFszVo2JtoG2C2lpSbk4nJZ1NMSBfvcIJUomVmvapTsgQyKZCjrwd9wL6WrnUx5e84Wt4bBYenfQuWAXETtA/LsLrJORAmPxvK2O/6Q+i1A1Wz9Ughlcm7vgmEhOS631ykqcy5of9HGcgyVryO+aBnvJ3OwFJNuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KtMd/8Zi6kEl4hBb7XqZURrx1aBgaf3A1IeSSsrMJh8=;
 b=KQJPL1MY5a19FlAAUZdPLuhQhL5rOHOmcLgoPX0RghwS6PqelWZgk4V7mc0avCwy4ocRP5o5FHw2B9CtBp7DYGXYPumjAWOCNFfMd0cy+L1e9xF4Ijg1jE1VBMT6FAKrm75kOaqKZN0TTPeggxbf2VIaWkHpjVCKNXWjqegeRHKl2p3z9al67E38bTRiptVEsdJunFItPMuWBM52My1d6icddBoDa0qDUi2otjhO3clRH70y1BLXeRHjFs8Bq9Pspg9zcKjIQHuAn+JejudXrZbH0fTd10Vq1Kjcu+tb4hC9fUVOuKgTqmX7vpaF1oMwVMS5JPY/1BRQPzv+hrRgGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SA1PR11MB8327.namprd11.prod.outlook.com (2603:10b6:806:378::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Thu, 7 Nov
 2024 21:28:18 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%3]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 21:28:18 +0000
Date: Thu, 7 Nov 2024 15:28:13 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, <ira.weiny@intel.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Fan Ni <fan.ni@samsung.com>, Navneet Singh
	<navneet.singh@intel.com>, Dan Williams <dan.j.williams@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, Sushant1 Kumar <sushant1.kumar@intel.com>
Subject: Re: [ndctl PATCH v2 4/6] cxl/region: Add creation of Dynamic
 capacity regions
Message-ID: <672d30ed15788_1b17eb29449@iweiny-mobl.notmuch>
References: <20241104-dcd-region2-v2-0-be057b479eeb@intel.com>
 <20241104-dcd-region2-v2-4-be057b479eeb@intel.com>
 <Zy0AK9FHMvst9fm3@aschofie-mobl2.lan>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Zy0AK9FHMvst9fm3@aschofie-mobl2.lan>
X-ClientProxiedBy: MW4PR04CA0245.namprd04.prod.outlook.com
 (2603:10b6:303:88::10) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SA1PR11MB8327:EE_
X-MS-Office365-Filtering-Correlation-Id: a881da79-5b48-4ecb-9947-08dcff731896
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?uo9QFVv7j7104QvjNTa0gsFaB3uP3XodEppycMcsxER1nPLgpet0dw5sxk2Z?=
 =?us-ascii?Q?1WK4EIvZHhd5Ij8hj9Pnzdm57CC2t6El0Zz7oZeLZe3fNvBnecUZQLK8CrAr?=
 =?us-ascii?Q?YyaYJftXHqFScV152/xhHYdrvfQlSrG/+R0O/MY8HxYfW/p1kOlfoi2Hhl8E?=
 =?us-ascii?Q?Wv5tElc9kXeFWACeEgmhR8+NV9y257ue9UXb46q+lM2UEswaeCd3fH1DDuX6?=
 =?us-ascii?Q?VPRs3SQNSVcXW+av92wRs5DO8hMe0VfwNr9m1U0g1VdWfA1TzCpiHakb3hvf?=
 =?us-ascii?Q?z6Y73Wr9fuxvLvjSccvpC5zubunA3nPDG9pUoMnSUlgaN93CVoUNIYSNuJb7?=
 =?us-ascii?Q?MjGvOe6DZdrhb6Lx6FJq2QmSVAtZJ37U9zrkNysN5wCwnupeHBnu+E7FmG9d?=
 =?us-ascii?Q?pv1fgmboBy3MbHrLQPn255wSRaAwCam5NUdjF7Cmb2NYZ7A1ih5YlWnTta2A?=
 =?us-ascii?Q?RWdVjdrnfgkRvcLj8hum0bMqT+7PjpeGEGmRPbjUI50gMz2/UmKPAvJlj98l?=
 =?us-ascii?Q?DrI87BnKYhMOp6En//2S55G1Hf28rY9jRgRwKF/w3iNitzRfENfXcl2TXgHf?=
 =?us-ascii?Q?Jabg4prRR3mKeIm5x65d0WNzJ/R53sq/x3Y9MseYnHobxjLIaE2P8ZD6LUTd?=
 =?us-ascii?Q?YK+gmwq0ukcYCWAx1tWaqDkM7e+hY3J5xVS8EnHwIqdqsdlAw3Dh4DcTQWZs?=
 =?us-ascii?Q?4uc2ZZRbGumKDJ5tZU2dPdJjGf7szoBoX9PenTAJYvoAv2wj5d+WC60Oob4R?=
 =?us-ascii?Q?2uogNJnZaVAzgyfhE8ANCXI/0gRk/u+XiwcDvvkHs1X8fuvc4skyCtj+AmWT?=
 =?us-ascii?Q?Xa5DzLv83GK9LaoGSW8JAPmdqOZk/7FtL6KQxkcOcFnRDA0wasEtpWNaFccW?=
 =?us-ascii?Q?2ZCvMmXWWtkBBUaEthmbk5YFS/3GxpGvy2W+KyuRosS+4vms8ded7wOCkzXQ?=
 =?us-ascii?Q?cP20hTLnCFfWpEfneWk0k252Fwz4TXwH3+mhwpXlo0W8iq7/f/cK/3SPAxGl?=
 =?us-ascii?Q?TgPAfuez026lj3DzLcy1cAOjsopvIphHu2UZvFknA2R+1vjBBIOrrUwETQql?=
 =?us-ascii?Q?rzeYYXG4qtW+A/pPVDh3YI5iKpHqnmaRmV5wQnyyuGRWQBdcCNdfZ3Beb7y5?=
 =?us-ascii?Q?Fc+M0ncPcX08zAXH5m860xL58WQIP0O7xO4I03m1mZw9PlT95I4LVCwtpkBO?=
 =?us-ascii?Q?4ZhgkxonZlleG1S2rS/TBYmNq6314+3K8E1rAm++dgmRUv5igRszdCWViG28?=
 =?us-ascii?Q?E87mIvArMpR2+KenVzqWrORAsc8vq4/WFoNyjs08sK8SIaFCdZvjzmnpmN4X?=
 =?us-ascii?Q?hkSqPyeNR/yDNoeYdMVcWRXj?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Th9GH2jh9RY6qKAHU4DIfXmxBd2sxdeVRKXdNRIz+r8xh4ex7QAD23It7aNs?=
 =?us-ascii?Q?kXrJmEEmC/6yFtRDQAZ/e2OtGN3yiyickLr6JQWqHolnlGUT+IgLfV6ZFrfl?=
 =?us-ascii?Q?zKED4HB2vo5XWK07Dr5c5iRIBaZ0t+vY/KkLI7hShqoBojsfXaOdGiKF7Cxz?=
 =?us-ascii?Q?XeoOdEQcgvEEzLoacmVL+iEwkMqg/DozJRHDK0lNoGM6rZ8+CS5LwNCaim1V?=
 =?us-ascii?Q?xwySYc/9ZGktErLYaoTSHACpgfGO//LMkexEdZ8lM0SwwpPAFco8zqZhUA31?=
 =?us-ascii?Q?jx04H3y//BQRlbnIKiW1CDAPdYvOs7p4qB/oyUELU9Uw9xrcweG/vJ0FRCi8?=
 =?us-ascii?Q?9S4Hyn0DeDMOlrj2krSUF9R4KFJFHIBMdAcGedRPcoLIC2q4DCMVXsTOEaXY?=
 =?us-ascii?Q?JOJSsFNDa3Tf4vjaJdLflpEh2jLhPpatDwie3Kh6/QYeWD5zZK8P2g600/mN?=
 =?us-ascii?Q?Ht3w0Nu1YlWpgNp/+vE8gJfSRZIapzF+VhpAMDNStMnWspZGosGuDzg3a5uI?=
 =?us-ascii?Q?Gaco0C8maMAGE8KMNEXaSOJti6ywVI+EmXz9SpaLvrEc+xmefiDWeSpX+MPt?=
 =?us-ascii?Q?CSFaXaV1UduE8KTLVXyS3vl0fX79AadpjtK5q2/hkpzaHIqQOZQQDE4f6L6P?=
 =?us-ascii?Q?6JO0W6UirLX++CA35R9Y9YamAkyBjMVR9+N4m1x4ugJFFoDAyH5rxmMv1qDw?=
 =?us-ascii?Q?9AQQYEQZvNwy2PK2tVD5iK2wtnmRUWBhhMNBLpXJ8nWser+tTNOzoeqMKnsB?=
 =?us-ascii?Q?Uq6kxxsbErAEhX2JHREZ+KBubVipi7SgM1LgwCz24r4nQlPrB5CLeyDiqAcM?=
 =?us-ascii?Q?2SMJXn88ZQ5JT/LLhrlmi2/XwI8tS/Wdx3ILIYQ7vKPAUUC0i76cIvVDep49?=
 =?us-ascii?Q?8GA3EOLcWGtLaEiQR3EvNgg7Y86F+GJ9hK38VFvc7gKTg1MSpqgeCMklHMOv?=
 =?us-ascii?Q?c5GSN+HtZrO3E1+Y0qbACOaxI8ElES8L/t0p8RW7IU2EmnwEjjOPyf4BAWOP?=
 =?us-ascii?Q?2h4Q6fYr64Gsy8sfONCrQSRcV6ppnDJn6Rwr2B50fROUVBOd4DaIci6V7sa2?=
 =?us-ascii?Q?8U4tslllnpjd50tbhZS89itD/wetkIlJm73Ohwdv4Y9WUshYQctvmBxNbj/l?=
 =?us-ascii?Q?Vr1Ej5NBa2/heJ9Z0r22wjBZhZCVYInOcAuZGPQAubTp6Ywrux/la+U4xy6e?=
 =?us-ascii?Q?EZkWO6aJu7+IpIWW5XlBBy1JDx/bneQvHdscYu4N5RTPS4/t1BL3TPF9+lMI?=
 =?us-ascii?Q?qaEq1y5poPn/jk90cf3Y6Zu/kzQi9r2DDRVqqrG3vvyUTv7yrMxPyKjpNbTZ?=
 =?us-ascii?Q?prIJPBnFb67XSz4Xzzq6fWp/hxCS5+14OON7l5BaSswebK2cjTX/LLWLlkFt?=
 =?us-ascii?Q?aN38TqvHUn6GlBSe7y1jHcyKYXmT0r8RXghuhGXfshJvDLnPJClCvo10mThJ?=
 =?us-ascii?Q?xTKMeZiS7PzbNgEuqW0PPTdI2ROni+S//vOnAyvTQMi14D9TN6qQlgi9eTmI?=
 =?us-ascii?Q?HqrZC8wAs4p/C6/lobouvgZRe1pp9RelSpIXD2Pw5qOItXeRIUbNJJ9abEIJ?=
 =?us-ascii?Q?NvNp3317AoMI5MtdJTRNGKuse2c/k1iW9nUc+5W1?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a881da79-5b48-4ecb-9947-08dcff731896
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 21:28:18.0975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0i+UgyfZMqH1Ama98LTAxvl4sKyA3mVSP5ETZ4X6EbjGqPysky2gBVx/BEoopdMj0FjZ6Ib4Dl5EWvpr/9D6kA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8327
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> On Mon, Nov 04, 2024 at 08:10:48PM -0600, Ira Weiny wrote:
> > From: Navneet Singh <navneet.singh@intel.com>
> > 
> > CXL Dynamic Capacity Devices (DCDs) optionally support dynamic capacity
> > with up to eight partitions (Regions) (dc0-dc7).  CXL regions can now be
> > spare and defined as dynamic capacity (dc).
> > 
> > Add support for DCD devices.  Query for DCD capabilities.  Add the
> > ability to add DC partitions to a CXL DC region.
> > 
> > Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> > Co-authored-by: Sushant1 Kumar <sushant1.kumar@intel.com>
> > Signed-off-by: Sushant1 Kumar <sushant1.kumar@intel.com>
> > Co-authored-by: Ira Weiny <ira.weiny@intel.com>
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > 
> > ---
> > Changes:
> > [Fan: Properly initialize index]
> > ---
> >  cxl/json.c         | 26 +++++++++++++++
> >  cxl/lib/libcxl.c   | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
> >  cxl/lib/libcxl.sym |  3 ++
> >  cxl/lib/private.h  |  6 +++-
> >  cxl/libcxl.h       | 55 +++++++++++++++++++++++++++++--
> >  cxl/memdev.c       |  7 +++-
> >  cxl/region.c       | 49 ++++++++++++++++++++++++++--
> >  7 files changed, 234 insertions(+), 7 deletions(-)
> > 
> > diff --git a/cxl/json.c b/cxl/json.c
> > index dcd3cc28393faf7e8adf299a857531ecdeaac50a..915b2716a524fa8929ed34b01a7cb6590b61d4b7 100644
> > --- a/cxl/json.c
> > +++ b/cxl/json.c
> > @@ -754,10 +754,12 @@ err_free:
> >  	return jpoison;
> >  }
> >  
> > +#define DC_SIZE_NAME_LEN 64
> >  struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
> >  		unsigned long flags)
> >  {
> >  	const char *devname = cxl_memdev_get_devname(memdev);
> > +	char size_name[DC_SIZE_NAME_LEN];
> >  	struct json_object *jdev, *jobj;
> >  	unsigned long long serial, size;
> >  	const char *fw_version;
> > @@ -800,6 +802,17 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
> >  		}
> >  	}
> >  
> > +	for (int index = 0; index < MAX_NUM_DC_REGIONS; index++) {
> > +		size = cxl_memdev_get_dc_size(memdev, index);
> > +		if (size) {
> > +			jobj = util_json_object_size(size, flags);
> > +			if (jobj) {
> > +				sprintf(size_name, "dc%d_size", index);
> > +				json_object_object_add(jdev,
> > +						       size_name, jobj);
> > +			}
> > +		}
> > +	}
> 
> how about reducing above indentation -
> 
> 		if (!size)
> 			continue;
> 		jobj = util_json_object_size(size, flags);
> 		if (!jobj)
> 			continue;
> 		sprintf(size_name, "dc%d_size", index);
> 		json_object_object_add(jdev, size_name, jobj);
> 

ok yea that works.


> 
> 
> 
> >  	if (flags & UTIL_JSON_HEALTH) {
> >  		jobj = util_cxl_memdev_health_to_json(memdev, flags);
> >  		if (jobj)
> > @@ -948,11 +961,13 @@ struct json_object *util_cxl_bus_to_json(struct cxl_bus *bus,
> >  	return jbus;
> >  }
> >  
> > +#define DC_CAPABILITY_NAME_LEN 16
> >  struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
> >  					     unsigned long flags)
> >  {
> >  	const char *devname = cxl_decoder_get_devname(decoder);
> >  	struct cxl_port *port = cxl_decoder_get_port(decoder);
> > +	char dc_capable_name[DC_CAPABILITY_NAME_LEN];
> >  	struct json_object *jdecoder, *jobj;
> >  	struct cxl_region *region;
> >  	u64 val, size;
> > @@ -1059,6 +1074,17 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
> >  				json_object_object_add(
> >  					jdecoder, "volatile_capable", jobj);
> >  		}
> > +		for (int index = 0; index < MAX_NUM_DC_REGIONS; index++) {
> > +			if (cxl_decoder_is_dc_capable(decoder, index)) {
> > +				jobj = json_object_new_boolean(true);
> > +				if (jobj) {
> > +					sprintf(dc_capable_name, "dc%d_capable", index);
> > +					json_object_object_add(jdecoder,
> > +							       dc_capable_name,
> > +							       jobj);
> > +				}
> > +			}
> 
> and similar above.

done.

Thanks,
Ira

> 
> 
> snip
> 
> 


