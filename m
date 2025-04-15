Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641961BC2A
	for <nvdimm@lists.linux.dev>; Tue, 15 Apr 2025 17:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744739181; cv=fail; b=HIC8BhWBxHFyMnX6MKuxMdssX/euGHE8Us7r0j8RwFltGVxQ+3Y2P7WG4obi3wL9D86jCprEnAPqF9PzPv0GC/NrYFMb9eLfN+sBRrqJ0811fTmIjTC04tLapVMsa6G7mtlm8EtQwxKWp2DTU2Z23DlStsJn2DJsI/HHNY2QNIA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744739181; c=relaxed/simple;
	bh=6Fb8GKkt+r5Qzsn4zZ/knnLkjxVpiI3/4uTG79Bkxi0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=m6pbjMfTlZUKbsXjBuSLL6lg4FrnI8IRUNVngx2zjdT8TINLZwYuMqs7iWIKLSoLu8FTjw2Pu5Tp79lhscNRjJ9+4NedqPKBzydTEoDYLl+s3JMwKNRNYNNZikOGGsu1Vjla/uQ4AzvMFU/MpWFZ10YXDGZ3wX9uQHhSsQlaaGM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PbxCM7Qh; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PbxCM7Qh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744739180; x=1776275180;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=6Fb8GKkt+r5Qzsn4zZ/knnLkjxVpiI3/4uTG79Bkxi0=;
  b=PbxCM7QhtpyFblB5GJQLRQsS1ieQV6YSnQ42tMruyfyfKxNIZ0ALR9EI
   KEpHs6HdwOq0QKEIuDoi5qSbzeMUzP69spg0TJutDgfFliReRfKxnzJjP
   sSKst//6hUaLo55xG59tmma7Xa54XmAk+/UW66r0F6IuoJSsibZzT45tR
   xkb+9ZqyK0D2+ffkoNT9K6hqctybsvDd8CJyzt5ZE2p7KPw2mctZWhETA
   aM273jnmVjN4Cxcvef40M4o5MonvFvlYMu0TgEo8bWkl6+rO4Sf8+krEP
   XEbLy1Yea79gBMWX33f5M2NJd3dgqc0eZ5lpmRW5JDb2w3O3n8uHPKdeX
   g==;
X-CSE-ConnectionGUID: gck24CGGRliLUvNnjYECLA==
X-CSE-MsgGUID: 54AoATrmTz+Fdp3ikz5PEQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11404"; a="50063337"
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="50063337"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 10:46:17 -0700
X-CSE-ConnectionGUID: KbnyzoRNSweNoh2KINO9LA==
X-CSE-MsgGUID: pDC+iicbSnCFF6sNtTYPPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="131171735"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 10:46:17 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 15 Apr 2025 10:46:16 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 15 Apr 2025 10:46:16 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 15 Apr 2025 10:46:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nbj1L0oZVSzPUMWICCzvPV0uSs3GJApw4jMv5pJjTFRaNUd+TYdB40B6oUUwcEpdBO9H8McssdTHdL5M5bKwjIPlvn1V2mWT4hYcJys3IAjT8MAgOQIvUP+UExpu+KPxJwo2f1jQTysmUS0Vxn/uUexHK2OJvVJi/1uYXme0wEWADFsoAD/59cY9/DQNBI5PZhtmNwIepUgtS40mKnPKk1jjDL4857C+6H5FjvxVxZog2Es/qocd6JHeXUOkXpQ+KCqosfGS9HqJs0V1ljzwQlYGEjw3sRFrpWPZMoHfCoCyeAZU9Hsh6ZqzNPOCujHkY86jC0silizlYW3eEsvhyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/saO1+V9fK3KMf3Fjwo3WAsXPP3I69CrznbKg4q8w88=;
 b=kZ3mpQ9OWQSJ4Elw1vUGVfHlSOvatJdQXqs5toD5q5bIceunwv9DY+bL3VjflSxYtluXaQugpIlx2sOROVC2gIfl4JPu6Te5kDEUUicWeDeZyBUvPHAYOUypywWSwLzLQNm+PUyYWf17DLlliKqoRPDBcUtoQezshtHRTgqrcmv4pUWQJt+mLw9TtEWXg3sm82e7LrBX4HeyvjVjC+RKmyM0LxvE53R1E83XiNUsD1JwK+Hg4sVrffw0QIMy0n+jDUcdS4rPMvQy/WKvNjsZ8+vWNQEY/E6MNiV1scmAqarmMO6EumZfb7eV6qEGPQKaxzdclvGTSwQqayUCG5Bzmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CY8PR11MB7012.namprd11.prod.outlook.com (2603:10b6:930:54::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.32; Tue, 15 Apr
 2025 17:45:44 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.8632.030; Tue, 15 Apr 2025
 17:45:44 +0000
Date: Tue, 15 Apr 2025 10:45:40 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>, Fan Ni
	<fan.ni@samsung.com>, Davidlohr Bueso <dave@stgolabs.net>, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Li Ming <ming.li@zohomail.com>
Subject: Re: [PATCH v9 00/19] DCD: Add support for Dynamic Capacity Devices
 (DCD)
Message-ID: <67fe9b44b7663_71fe2947b@dwillia2-xfh.jf.intel.com.notmuch>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
 <20250414174757.00000fea@huawei.com>
 <67fde59784933_71fe2945a@dwillia2-xfh.jf.intel.com.notmuch>
 <20250415110350.00006eee@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250415110350.00006eee@huawei.com>
X-ClientProxiedBy: MW4PR03CA0128.namprd03.prod.outlook.com
 (2603:10b6:303:8c::13) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CY8PR11MB7012:EE_
X-MS-Office365-Filtering-Correlation-Id: 524306bb-0963-440e-c764-08dd7c45590c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?levQXiVujEETTa5ltQHUvu5SopbkA4JZ0BtVW/vQk6c2XsX9LFnXQfnEef8n?=
 =?us-ascii?Q?+Jd/j14fIzyQdaPYBTV2T0L+1kaReoCgL44NHEu7l4CqqXvlcSlTG20ewWq3?=
 =?us-ascii?Q?SIS/A8G6ceM4589I82pPKl6PPhtWd0OpJZnI9NCGnYyI0O7nXBpA1GnapV2q?=
 =?us-ascii?Q?u8s2qZzMjFASJlJCL3LaGwlwkOU8PksF49xEkKrBCnDyn2LIRXKVW48roYRM?=
 =?us-ascii?Q?Ue9x9iEIYiJxbZ03gLIi5GnHZIjOnviZNgi1B4wHGRsqx2RhCVtSuwXXDvT0?=
 =?us-ascii?Q?ddgUsWLtU5vmk4gH2rrt3rz4iXZbAMB8/lnBEHCC8zCEJmz1HIZb6zmyeVf7?=
 =?us-ascii?Q?Fp2lMGjb15ykwnjmdd5oAYJXYU4QRPVSgW3HHwP2K1Q1T+ZQB85CFQrmjIIa?=
 =?us-ascii?Q?k/w+8QA3gI9docEcGtsnHpZ//b7PQzItqBzG7A78361aguc6Ybo5ilbScsnH?=
 =?us-ascii?Q?uu4L8vmVc9k7b959nhQ3RA1S5hM+0BPryh6jrvDFJFWSgRxiZ3aasLAuaHqf?=
 =?us-ascii?Q?nhcsKSXhvDdDjBxteRmV36M4/YK/l3tbqkYy1WcW/rfRKwGkLXpY0H2lcqy7?=
 =?us-ascii?Q?CfObLIfxjHIPjJUBbaZO3cl+Won0+J6iY6bfROaalEmF8XE69a34C3nDR3AJ?=
 =?us-ascii?Q?UeclKprwfnZdM0T95ifYjfs3BTuFI9Eb95vYR8Jcl2TpNI3y+SP13CBX9Tqd?=
 =?us-ascii?Q?vhWdueX0SK4Gwf2ehWGG4n5QccUCrbeMCPsx3t8PspvFPbavPfaNYBM1e9zs?=
 =?us-ascii?Q?RqpTvwbtjxgj/2S9Evz1jetK+TZ9afWnVihzWVMuE3HeQ3vOMlkMbbW4Xc79?=
 =?us-ascii?Q?XpjUA6rYKQ8d0l9xS8psysDHWL5PA6wSXhCS0rxNtnwKemxW9XhOCVqS1K4T?=
 =?us-ascii?Q?unKgATJ5I4FKnSVfWttH3GSzqHgTR9Isy3wNpF5xf6nFuI5x4+jHnfM1myJ7?=
 =?us-ascii?Q?OszHKtgykydKzE/UjVIrOFYzRgmKhgwGN/T0zEHy+ycI4HF4qGr9hwAex1cT?=
 =?us-ascii?Q?ijEr2TwDJJEV8LfN1iqiSm9I45EjzX712cCle2en5gMFvxktBSJIktLv7h+r?=
 =?us-ascii?Q?sN9CzbPpsGHpvhLOVIYfMxI4DGXtbBdofDtn//wnVQ2btUhU3qI3uNKoMDLA?=
 =?us-ascii?Q?2m0j8i1zPGcWTU/y+cPt5WwV6QOpHSLgdJ0q84ib+/FKIS/FqhFNBx8Ldi6h?=
 =?us-ascii?Q?LO/Ru98/+ZQIFD9MOChIBnTqn+4J3SbOS/EFLSwmQURWwZ8Y53NfHFCjO0j+?=
 =?us-ascii?Q?YuUGovw4wsGvLXSy1Ga+TBy4BcLcAzscaoR34fMVpEa7XpzmlJ07eyjOWgPp?=
 =?us-ascii?Q?ErY5nnICvQITZmfbyMFZYSuPVtcmnt7/hq/DhK1Waz/EVRVielfi9nUQ18C+?=
 =?us-ascii?Q?LaoJE3TobRF8ordiA8qYdO20Bwd6+sDb0t6IqbrwObq7NxHhWMX7WPNYr3hx?=
 =?us-ascii?Q?2ztI8Lc2088=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bgxcq214qDMxfc2XDIQkCPEnSB7ZIJrz/ZLqHKPs7sElOcKFvAbypiWO1PDE?=
 =?us-ascii?Q?F/SQC4YGoMFQHbeu0iMUh5ypsYlcS/wwv3Ctxu2ndFMcYLmdVVi/2upFQtrX?=
 =?us-ascii?Q?myYbQysouCjvF9dlOlNVqLQdBz6cSA9fzmw19KBZesrzWvFxLhoOkm+kSdZJ?=
 =?us-ascii?Q?xC+UnL68dpdVwNt4ttF1sS1uzQSuHyclccigfZk+FFD3lBahGG1/UBUJeLVm?=
 =?us-ascii?Q?YISqgIOq46mAekhqL8U/aWiPf484tgZsJQbKPPm4vg2TUJtkiDg7UvPJRjGe?=
 =?us-ascii?Q?X9t9MNoKi9/J3puU+C/nRdi26aVJJ6ml6ad59Q//EDS+5dsS6L4+UnI1veHl?=
 =?us-ascii?Q?P/PT86hLpztQLuLkSGJV4wIafENV8k8NtLrkSgA3ZzSO6AtYDotiQW0VeC5G?=
 =?us-ascii?Q?zWv/q2Fbj4LqfMSL9D3IU2KXU1r12e3KDQIReG42Ixx0rPfnVdRdtX7VK22H?=
 =?us-ascii?Q?hI1zLKPPFVRgzfeB1fqvlP6TMNokqh+mhzzDixwitKhNGohUEccdap4sja8+?=
 =?us-ascii?Q?jmXh6dGC8T2PtCDyuGxzRY5ThEdZzB6AEuOO7TdoKmwIk48Ueo8txKKKIkMg?=
 =?us-ascii?Q?UFeLHwleXokiA6CKk8EB6I9eUN6i28eNufRftxa4jWcPepiNe1e4nDGWUe2f?=
 =?us-ascii?Q?sZ2HxEuC4epSym+Wmh4uD5pDeHVqeQxa6m+f8EgBCd6rgnromve8xVEDQAYR?=
 =?us-ascii?Q?0gv8oqYa2xQf7VcXr17N7TSSFSoRH5utyrCUEEB7ER78c2RRVSRWbyZZM3QW?=
 =?us-ascii?Q?uNADROQQ7ryW0XzS2eKYCfml0Vovi9cVDQaa/hzqYAtd3obhmeLn9Nd+3wkw?=
 =?us-ascii?Q?xTrohZqq/uhpGmmLzJDnUNTSmcV2WKmc5CsInsJBbDODlSKY1l2ONUK7XcRY?=
 =?us-ascii?Q?kizxUjGm/5TUs5M3Qjvl9rfVGwtualFANUoUBMpbcru8tT7rNTm75Vu841q0?=
 =?us-ascii?Q?a6XWn5+Db8RwRYH9cuNV8KP8O0t4R0F3OVatd3mKdWbCFXXWKrA62gWTcy2d?=
 =?us-ascii?Q?8bgmScNBdeiQdgeJqDC8t7GE1+BYRIg79avSJlFalRIf86TS+HwTCnrQGByk?=
 =?us-ascii?Q?LSltJqyvuGqrJbv3BiDnkJuqejrqMgkq1+ct3FyxP5Mvqwn/diZs0BuJJga0?=
 =?us-ascii?Q?gAj5tVBdQxsRdATPuQEVhDwOCcWa/RWoOrh3bmtzveYIp8NWPnMfXxmKvNpq?=
 =?us-ascii?Q?y2zKw0doNT1QLdJVNbd06np/WANQmePjG1teoVavy1K8EcwCRIobB6Vp8XtG?=
 =?us-ascii?Q?Lhxm2Y6gQrq2qGBHT5ARiFFtYYkM5X271V63X6+B/nmIr/+MfYA8u+RvMttL?=
 =?us-ascii?Q?mgNfShwC2UyXJW4TCh/DSU5CCexU5lkqqENxSOX+tMLh8R8SSf+2O3fF+srC?=
 =?us-ascii?Q?DG++coPbUp+o9kO5fMqOYNTSMiIT8Ti0X1n/4KSLmpuExk6slhY4krrxptX2?=
 =?us-ascii?Q?PcfvaO1mqig2e+CWyIxgAXJa1bkZoYG2k9SqCj3e4AautwZS5SVoLnd29Sxb?=
 =?us-ascii?Q?itwLpfTUXCh8xjZvEKt9UYT1Mq7fNTb4hVhoDrwpluSw1umSONr9Z144UYHZ?=
 =?us-ascii?Q?HKBEQ+wgOp7A4hFh1B8PfnKpO2WGV9KFWYrNuZknz+JoTjLsWdZ/CeRY+nQe?=
 =?us-ascii?Q?uA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 524306bb-0963-440e-c764-08dd7c45590c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2025 17:45:44.6532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l1XlkfBhuZEfid6QL/v9MViOjo45KgXesPvzhRIeows2++9Pl8l1V7bVqGym0yMIAN7NHMVttkV/8TJdlf1dJw/LOMSpgrIPtrRB64g/egI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7012
X-OriginatorOrg: intel.com

Jonathan Cameron wrote:
> On Mon, 14 Apr 2025 21:50:31 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
> 
> > Jonathan Cameron wrote:
> > [..]
> > > To me we don't need to answer the question of whether we fully understand
> > > requirements, or whether this support covers them, but rather to ask
> > > if anyone has requirements that are not sensible to satisfy with additional
> > > work building on this?  
> > 
> > Wearing only my upstream kernel development hat, the question for
> > merging is "what is the end user visible impact of merging this?". As
> > long as DCD remains in proof-of-concept mode then leave the code out of
> > tree until it is ready to graduate past that point.
> 
> Hi Dan,
> 
> Seems like we'll have to disagree on this. The only thing I can
> therefore do is help to keep this patch set in a 'ready to go' state.
> 
> I would ask that people review it with that in mind so that we can
> merge it the day someone is willing to announce a product which
> is a lot more about marketing decisions than anything technical.
> Note that will be far too late for distro cycles so distro folk
> may have to pick up the fork (which they will hate).

This is overstated. Distros say "no" to supporting even *shipping*
hardware when there is insufficient customer pull through.  If none of
the distros' customers can get their hands on DCD hardware that
contraindicates merge and distro intercept decisions.

> Hopefully that 'fork' will provide a base on which we can build
> the next set of key features. 

They are only key features when the adoption approaches inevitability.
The LSF/MM discussions around the ongoing challenges of managing
disparate performance memory pools still has me uneasy about whether
Linux yet has the right ABI in hand for dedicated-memory.

What folks seems to want is an anon-only memory provider that does not
ever leak into kernel allocations, and optionally a filesystem
abstraction to provide file backed allocation of dedicate memory. What
they do not want is to teach their applications anything beyond
"malloc()" for anon.

[..]
> That is (at least partly) because the ecosystem for those was initially BIOS
> only. That's not true for DCD. So people built devices on basis they didn't
> need any kernel support.  Lots of disadvantages to that but it's what happened.
> As a side note, I'd much rather that path had never been there as it is
> continuing to make a mess for Gregory and others.

The mess is driven by insufficient communication between platform
firmware implementations and Linux expectations. That is a tractable
problem.
