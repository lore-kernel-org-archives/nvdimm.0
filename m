Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A96920297D
	for <nvdimm@lists.linux.dev>; Wed,  9 Apr 2025 21:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744233233; cv=fail; b=o4gFLHB1lIUOjCOHaKt8S7p3MAa6OpIj56p3knTQ0rKczRv+hf5GOSEAJ9OFIlHb/xW0hKl7Cnox/7BNOJ8s35YhiMXYUabTI2CJ1NzrfD/KFK3ozZWsrAw4I3Y30Wyl14NZWTci0fusTR5mKALs2ukgBO0n1hLFQCli+D4tsIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744233233; c=relaxed/simple;
	bh=xaDq0JGvsEWNa2GYdELnYTzJq09s4zQB7UTYz23U3No=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uKheahGeII/phNnrHjl9ZcpAmM6m4cnG7lvImTkvCHb1WGAVC1jVu748BYZjOKHnlm330cAXSBnapCwKn/ZNyzyhr55aBT6MJzed7Be2Fn8vk1qZ13vR3HaTF9GE8tg+2HSqqgsA9+DZg/S78+vWQoZV/sOz2DEfyhNXrkzEfQs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LxUJHSMn; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LxUJHSMn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744233231; x=1775769231;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=xaDq0JGvsEWNa2GYdELnYTzJq09s4zQB7UTYz23U3No=;
  b=LxUJHSMngd6da7DhxGu8uSevv/3RmdNxgYY9B3vzksY2LpbadIEpV8zo
   ck7A4q2lqbxnQRLLwqEZtxzvX5uq+vzsfTYcJY4qj9J8p5P5tDUIPzK5P
   aYsnq9RoRLUhCDXA2qPg0YDpjmUzJ2RnIIrx4su7BvIABBvGHugnlA3vz
   wJmMvhloy/o8AGWs2JRMQphthwQ3yn5Bi31+h7CcqUKQg5KJhDOVyxRPn
   g5bznPyCF+ypBnIN22kqMuZPGA3mgaJjVPpv+f4WXJjWApuQ4Cm9hJCb4
   38v1v2Gx5Po8ZIqAQ5SRFtqH/MYf5zaezpuwC7aSEwJGGvA87CV96N4ak
   Q==;
X-CSE-ConnectionGUID: b0OsTXayRDy8RFoeY4f9tw==
X-CSE-MsgGUID: 0Z6eh5/3SdanPT/T1F0q/Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="45852383"
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="45852383"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 14:13:33 -0700
X-CSE-ConnectionGUID: xNriG1QlQc+8NpihqqFy0Q==
X-CSE-MsgGUID: 4KsFcUX4TEeOP4z+9ltIhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="128677495"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 14:13:32 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 9 Apr 2025 14:13:31 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 9 Apr 2025 14:13:31 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 9 Apr 2025 14:13:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nyfh1954MRkTWMZHqqDW+lIKJ0kMUm1aypXXmJ/7TU1IFI6KRvJWZPkHHNrGn24G1oVoKOWVt4wXbfHKfdbPVSGT/pWxtbwq/Q3OvSpR75UpX+et6rAZuj49b/Z1Pp19qWVpNTNrYqQ2MPekicJMPq/KFYIgszDJLqGttShe6w0s8KJjJ5QI8Ko0tmVSMEDGSivjNPyCW5dreT62VuC6qdTOgn3HFHthM0ZQimKmgSun3y5ZsnpBnH89KoCfFLrjVWjl6fBlbx0ssrL34Li4mmuEEWIec3ejwOKE+iqdXjeWqNnGaFTVfgp+wJSaGkSc89PPRkDMwGzNDU+lrog4sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LFRmmJGYWBaDTNHhgNIHctWYXFcppEdv7lwrdVxGexw=;
 b=CKmrkh8THou8vqBi4Jg76fVVNQ3OS0sfaeEzDn1NNgjC0ZIeGu89NabO6vy3gUyT+j79NlQFkGjd1YW/Gl9mgIBWgpZhyzieGxXfuNVFTJ9I0/B78wjQHln2T8EK0umAgD0UxsiAI7w4iMuwomawhQ2Ezc6lBP9oKsb8ByC775LSgSwxq17ZyERPR7V59bQcD/DGE6eKsaQ/sRHX9grq9TMvAHt7neQRuq0rnh+4o0/NSN/4EzZ3oIQDkFc6OECV+pm57qztldJ4cB5Byp6fW3WUJstqSrTq+ADCOxckwYhKdJdgidR2n4NMOUZPeqzw2OomRnWXm2cbQqJrLQzhzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by PH7PR11MB5943.namprd11.prod.outlook.com (2603:10b6:510:13f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.22; Wed, 9 Apr
 2025 21:13:28 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8632.021; Wed, 9 Apr 2025
 21:13:28 +0000
Date: Wed, 9 Apr 2025 14:13:24 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: David Hildenbrand <david@redhat.com>
CC: Dan Williams <dan.j.williams@intel.com>, Alistair Popple
	<apopple@nvidia.com>, <linux-mm@kvack.org>, <nvdimm@lists.linux.dev>
Subject: Re: [BUG Report] 6.15-rc1 RIP:
 0010:__lruvec_stat_mod_folio+0x7e/0x250
Message-ID: <Z_bi9KY3q8h98hu4@aschofie-mobl2.lan>
References: <Z_W9Oeg-D9FhImf3@aschofie-mobl2.lan>
 <322e93d6-3fe2-48e9-84a9-c387cef41013@redhat.com>
 <89c869fe-6552-4c7b-ae32-f8179628cade@redhat.com>
 <67f6d3a52f77e_71fe294f0@dwillia2-xfh.jf.intel.com.notmuch>
 <edf48c4b-1652-4500-a2e0-1cb98a1f0477@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <edf48c4b-1652-4500-a2e0-1cb98a1f0477@redhat.com>
X-ClientProxiedBy: MW4PR04CA0119.namprd04.prod.outlook.com
 (2603:10b6:303:83::34) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|PH7PR11MB5943:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a9137ad-1dee-4f88-0ea2-08dd77ab5f5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?p8LTfsurzJ2CNmQJ7RlBeHBVqbwacz2omXHoMT6RUZko6sEXQT47jbsJmh+O?=
 =?us-ascii?Q?y9XIpLK5D9eA1NwvhERQLewpDYyEN5iaevmNzB0KTgnW4GY0E0qfk+Iho9v+?=
 =?us-ascii?Q?1CPN3MM9NZwOqTm8k3rK7Ws4MSEf+ryfsQYqAXGWOe0Y6x9n7nV5hcWY68dF?=
 =?us-ascii?Q?+6lJSfyx2VdwkHeEwxbcRanA28T1rQfTt4Y3FcsKmX4pAZOg3xALPR5/H0nS?=
 =?us-ascii?Q?dQd+CdtpKPhNRgOimPLtrLlcKhDz4jn9DkvsXSYOLhm624yDKBXYloBcC4p9?=
 =?us-ascii?Q?OmQGSqXhHlhppgZ79GjIyFi6FQfZr/7kd/lYlaow2JWYxhiqiZqWmR9TpsrI?=
 =?us-ascii?Q?+Bn7E16YFitvrPnyCbBiTuSsXQ3g3ezyRJMhwc9iipf5NyL0Ck2lRS4yU1DO?=
 =?us-ascii?Q?Qz+IJmASnC0Kor3qMJyq/GRgTG2/ZPF1W3Lh4ZnOB1Bgj9rHPndT5PWanl6e?=
 =?us-ascii?Q?k6ItxtIzzL/wGyAmB24bOvzuilQCLHO9/m7tXmtJD/yxm5eVHIX2GquJSA2f?=
 =?us-ascii?Q?ewgZWpnuwYj2AEh811suiC25i9zkcvpc8/rHZynrGX8EDWyn1y9Vla4FsKgO?=
 =?us-ascii?Q?gklRlyH1Q+JyiTS+O7UtLyT0sTsYi5kdl9t+1DQDOO/T9P1ZVVlTFZ1J9h1Z?=
 =?us-ascii?Q?OqEtcY/A3789CxFhLTrMq5XKKKSVdmQC/IJDTBIDNwzcaI2DIFdOBKBKAKM7?=
 =?us-ascii?Q?8x3wPYKFTLmZNhAVbEHq/OpVJH4VNJO2JztHThYdJk/ny++aHBHvxwvD0R7H?=
 =?us-ascii?Q?C6uItSGUuLfcDTRhh2dE57RDU6qinIA/7Vftads+aSwSGFvF5TvFkSO+h/oJ?=
 =?us-ascii?Q?HsqaaUxdmFNNISxPeiqvQs5KhaaLRM/nBUiMvgID9TpfcMXkbeLT8BfsyOL0?=
 =?us-ascii?Q?7d37O+AdctmmvCA1jPaQx3UFg4K8finkJkWgkH43vVE7kYdb6vbb22GkY+t9?=
 =?us-ascii?Q?ynA9ICbO3r4dSWcgJIzIkJB/EnQntcyyaSuz+RAYIxiPb8SYrTPmxgrCn6pK?=
 =?us-ascii?Q?vCSdlOEesRKxHHRolvIBQ41okzSJOGFE57K2HIHxMMg2N06+h2pkpV785JE5?=
 =?us-ascii?Q?qaawW31J0BP989fGlwkkKIaxTp4YB6814aTClGoqu8OL0DdTPyy4Io9gpcoD?=
 =?us-ascii?Q?DpBkdcXmZF5B1fAVP2CRL3NIvwkpnOr6ZlmfKkXK5o63gNf69Mdi55kP+TE3?=
 =?us-ascii?Q?0hkUsXYdTSZVHqhW9/mFmmo04kvVv+hRB77/6p+CuLg3EAHeHlbQs/2LE6To?=
 =?us-ascii?Q?8J0PeCv5Vnl5Aj66xOX/hzP5+tt6zjUpI4g7bKMAIgElHlxPp2nXCegMViTb?=
 =?us-ascii?Q?Fp44XQMpkOLwWfSZ4Z4agokYEVp0hPKWXQ3PCFKjPD3jWhJGpy8gVyo2y8bI?=
 =?us-ascii?Q?fNIsVpZ4we6m7R9DCeVLYuBlWATl?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HSyhWZacgX2+fQjM8vVEM48iVeYbKofpcR0WGszRyD1a4l85ZEM+preyL9tp?=
 =?us-ascii?Q?yhWiz+TJAQOVywa+tGd6WiGZoMxc++247dlyVtxbVDFMMUt5qP4jwqkvtE5r?=
 =?us-ascii?Q?ES9SlXZrYfTPL6PBa7Nd+2rgDwGoP3bZeEu8l2JfpXWr2WqlpUsNfGX0rRTz?=
 =?us-ascii?Q?1FELOs4wGg18HV29j8FXnMqpWZh9Xv9Zq1jwxT4gTz1MTqfovxOC5kNvQXjZ?=
 =?us-ascii?Q?u7uAJPv4sQ/5U35c0ZXs7oqtAj96JrxvOEPHb2yxgp4uIDHwbz4MlTnBH/lo?=
 =?us-ascii?Q?MFNPMF/txlNUUOg8l/M/g1k7KcjSSlM8VT9bVZMlCGpuYZI+/8yE9tgzqrd2?=
 =?us-ascii?Q?xRnNj4mVh04TH0M1SzXtj46o6T9hjKAW8gESJtqjMb36qymGlt+o1IZbgz00?=
 =?us-ascii?Q?UDd0QX7OqqB3EbYxwRAKpKFddeFIiM6lgCh0+OM4etI+utY5doOiERds7YWx?=
 =?us-ascii?Q?Wa58r+jlY5hTNPlrhylN6P3D3MHb3apHI7P3TBfAmfoEzoCUnKAsMpgL6Oap?=
 =?us-ascii?Q?4+IsTkDxUy6fBTRoWOoh5V7MuTcclkfGe0WVy06yrUxGil8FPHglRE30g0yQ?=
 =?us-ascii?Q?3nH8sRLG/farsnikvzrLFVrRls5GRQCTMP6bVX+n21Jy5p7UB9hPnIRn+Pr3?=
 =?us-ascii?Q?vee88i+s8IwJAwTCRm915ddFGoBafK2AS+N1rqEp8e6oZcK6jxRVk6Okse3g?=
 =?us-ascii?Q?ZAFScfNcvOchXY5pfecFlbB+otEEpFb0dZi9/baGeRfkzdzTtWEM/jQCv5Ai?=
 =?us-ascii?Q?16nhTsOPZ2/9E4V305bVsy63PVUjGqf3THZS5LbdKSEnjRXpvWQOHQ2K99RY?=
 =?us-ascii?Q?eR+r6pEabi9HzwzwLJ+bI3JHAYal/wAJ69Bqbxv9Ue0YoS+p04F5cRoY5y1e?=
 =?us-ascii?Q?YGqbu+f2a2jqqdDfc+8kZW65XXIvT3VsiE6b62BWbgDLcOaySH1x4NmB5tms?=
 =?us-ascii?Q?XklCB8S20ZoogkWY+SPZnqdoNvHN2jwPS6A0XJbxt2Kd1+nVJRbutTS8gy0H?=
 =?us-ascii?Q?7LANot+3w2VMZ2+WZjRVp6+aYNxgsnVkkai4AajtZT64G7dh99IafXOaQqRQ?=
 =?us-ascii?Q?bYiQNCHnuTbPgkzejygf7v9JeBga2KVlqhh8W+x64OGIR4cDSoLwhvSKbJjz?=
 =?us-ascii?Q?QSMIuq0DfUTMTV/6VDixEqHItBWwANZT6JuvyU+tK5gYTVI93J/9U0Zs/jxS?=
 =?us-ascii?Q?FzEaUeD69tKInXF0F9enysvXWTtYiirO2/TfCtEJiWjdzMPVEP+jYvAxGilq?=
 =?us-ascii?Q?IOngfK138q01gJUpOBysd+q4n3sBLRFjryyovWC4f2R5OxeJO98ps0y6mmVj?=
 =?us-ascii?Q?08eFEGUj68O0r8BZohSXaSZu0BAB8fR5+b+46kVlaaCkoIlfPP10i6lRdbQu?=
 =?us-ascii?Q?l+Z3d2qaPz2P0o44teQycpZj2XXg0Y9omEXgr06qyLXVty/sAwlzXvHnxjRs?=
 =?us-ascii?Q?Ytus51uJQ24c5HvFe1ld0+UULscFBEWl1rppIixNpP3oRTW1hbws22+FV7U6?=
 =?us-ascii?Q?UXwJ0QoCmgCyy/YhxNl4bA2vPnXksKuDL8VfLNa3X86X6Dsz+qzatoTXM2rI?=
 =?us-ascii?Q?m6n+rg53hGmU3cwPo7tBDoHCX9Lilam5pRq73tbGtRF3HAGp63AvQm1D576i?=
 =?us-ascii?Q?GA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a9137ad-1dee-4f88-0ea2-08dd77ab5f5d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 21:13:28.1144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /3QTvHNY/105dZlZCCnTBAdDsU/OrscZRcepmBJcC9xALAAzW2qiQkOOSPaW47lD23enPdNYI9BlYkE7S8PIW3/0fDA8kDdnRCCXqAwccEE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5943
X-OriginatorOrg: intel.com

On Wed, Apr 09, 2025 at 10:25:18PM +0200, David Hildenbrand wrote:
> On 09.04.25 22:08, Dan Williams wrote:
> > David Hildenbrand wrote:
> > [..]
snip
> 
> 
> Let me send an official patch tomorrow; maybe Alison can comment until then
> if that fixes the issue.


Either of the #ifdef's proposed resolve the issue.

--Alison
