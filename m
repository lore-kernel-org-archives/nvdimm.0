Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6141F2C3B
	for <nvdimm@lists.linux.dev>; Tue, 15 Apr 2025 04:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744692640; cv=fail; b=FoL3B5OD5JilPuQbhIw+HktgKodGlVWm8JtQI4XtyMHM1/9S9Vt/cZxDdHIqnZhkZ1P3k4NfnFgANiBIbo3KageEJyRI9aVaVTvYqOduhoQuC1d9d58YbCT5PnQm+WCZGgElcws3x5uXM+6iKaOSGBfH7x/H8IpMj/aGkn3zNoI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744692640; c=relaxed/simple;
	bh=p6yiQUWDfLaLFtsgtfHjiydnwftCly0pwIEH5dV7VZg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iy6L+QWou8AHjMwkFtzd9wz4GhIZk/LaC/UbB7gIuBBvVfcHMKDeedH0O6pHysLSnkhfsyMLgWaQLCPauvx3EIWs/yYi5pzbd7nYjJt00cWfuMs3n9aMOQSRtmCo4qbW8tg9hTPnbKHROkB+CrhJ1h9xMjH0kQ91AScTAwmF270=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W8divH2z; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W8divH2z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744692640; x=1776228640;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=p6yiQUWDfLaLFtsgtfHjiydnwftCly0pwIEH5dV7VZg=;
  b=W8divH2zry0o2r9jWwgZYlmpil53oQZ3DueTRSxAKTQY9IOCcKeaLVLO
   2RlnzzX31yqKKkJRPe29qgOGI4MCIYAXO0iwyGvajhpXwc0JsdvNK+gTZ
   v5eVMSFeG3/LkAhzo+IyGuxOuwCju1+aD+HyhFCEtf4UddOIonFnNBaFo
   wo8NAjQC8Y4GEGMlMR2HYOgtfhdXivCy1UWD9M75OpeiWoEqbOA6OmtLP
   ovZtIYQjrDglDuKHYnX26/cvvvCCAqMgJZeWfjLdYQZv0BSLb5BqJXCgf
   Gcr/jst8Q9VwIKHaTP0HB40fM8GUvmY9HXb6dPDEnFkF1IMDdZ3k0TNpQ
   A==;
X-CSE-ConnectionGUID: 0k1LVCMIRa2Bl0uVNPiu5g==
X-CSE-MsgGUID: s4/GxxEVTjGh9hgko+K66w==
X-IronPort-AV: E=McAfee;i="6700,10204,11403"; a="57548458"
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="57548458"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 21:50:39 -0700
X-CSE-ConnectionGUID: LhMvGxctTkSz4CWa4HE5ig==
X-CSE-MsgGUID: 1jmNqIriSVGX8eYC730+rQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="153201003"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 21:50:38 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 14 Apr 2025 21:50:37 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 14 Apr 2025 21:50:37 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 14 Apr 2025 21:50:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BKvUZmQsjuy/lQMDL/NNIkUYfeuSp2fqVoTwInlpcyuM6HZeKh9I2JRX8WbrvXXEkamoPe+iAEyJQoevyREKqcyCdPFtgityKTysqiTyziLjj3jbUMlYGXWntCG6jjRjIfnguJHjUukTxAtABIiV+he4ryMFxHbLYxYvBs9QaL8h3+xI5B+YdhFqlFMuOv0lMH5a24MWQo0RZW/JwWdL2siXc2k8tE4TsUOUXg7kQzOWb1NfaTh/fL1BBhZIKCa3Z/mLUtHPqmsdqYBfvS4yD408uwqBDuruXkYUvmF2wZqgmtN/cs3q194XYU95/60/+oN2VePDRWxbKxPLB414mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p6yiQUWDfLaLFtsgtfHjiydnwftCly0pwIEH5dV7VZg=;
 b=vfEtQcePS26vnIlo/q3U83zIVvNSEXM95kfxT1Cy/3+yduqwjdtWolLx5Je5wYpWkA3kVyfGCy03iAUrL6jlj9vd4t5FpTz0ApNqUQCeGxTF3ArbdA9HUyhsKF5M6737Yce8gg+q4dOqBlGiEottftEEmmrQ7mKHFWS5YPAf6v2f2GFI19nwYeP9JMIeNwa3lAfvhIxp902AT0xVgCL8k/MpfpOGgOA0K3IVArfK5nt1M4FX73l5FyWsbuGcXc+i5h6caLgDMOESZiwLykwzHbGX1WKbo77v/qhiaXsFnYOoGqhIJutulfs6AiUeuPnl7h5lY6Rmh+34RnGJpviXVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CH3PR11MB8240.namprd11.prod.outlook.com (2603:10b6:610:139::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.35; Tue, 15 Apr
 2025 04:50:34 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.8632.030; Tue, 15 Apr 2025
 04:50:34 +0000
Date: Mon, 14 Apr 2025 21:50:31 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Ira Weiny
	<ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Dan
 Williams" <dan.j.williams@intel.com>, Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Li Ming
	<ming.li@zohomail.com>
Subject: Re: [PATCH v9 00/19] DCD: Add support for Dynamic Capacity Devices
 (DCD)
Message-ID: <67fde59784933_71fe2945a@dwillia2-xfh.jf.intel.com.notmuch>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
 <20250414174757.00000fea@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250414174757.00000fea@huawei.com>
X-ClientProxiedBy: MW4PR03CA0277.namprd03.prod.outlook.com
 (2603:10b6:303:b5::12) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CH3PR11MB8240:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e13067e-617b-4a8b-6d33-08dd7bd90ea4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?JeQPL2lzILNXiv+QWL3aTG4l0EcFDn1nQVL5Dn3yD9LtHNC5HVKOzcDCLBFt?=
 =?us-ascii?Q?d2dv/B9NI6XtQoBcKx324eC1sT6PiMYl022rV3CJP1YJUWdcwkQduE69i+Ir?=
 =?us-ascii?Q?FqurjmzlsVyvibewsioTrCODMqNz7/DHZ2IqChGEOkkiSt0F3S82bKtpkGAH?=
 =?us-ascii?Q?ZYQr7mhOWdtBFKjlRYc6sWkQ6m7aUoxFpk2gcuwZ0oArAn7F1t4GOuY3XuBs?=
 =?us-ascii?Q?0PPWASgWhKu0r8tw8G+twlAj9oCmy1HVJ22fEjMaTbqNzqsRkw7p7Yer04J2?=
 =?us-ascii?Q?Lxcz03uZEQY/GIteD+a15sb/cnAuOLied2PBJZMSd+2rqJ+G4WgflbwC2Nv4?=
 =?us-ascii?Q?a61yVs8hWIl4S45SfJ4Lo3BXOY6yKdoJjAosmYPYkPs/NaoC9j27ArJkzLPi?=
 =?us-ascii?Q?klOtdBjUmSDEAl6u47oseUI15qM3n8i+cGdbU6EAtFf1wznceQBuQdZevSHp?=
 =?us-ascii?Q?pH3tX97BTm1nlOn0UITpOQgqAOqNvfyoo5+H60RqAK5AjLZlJLgtNqVW7y6H?=
 =?us-ascii?Q?bBc3esnZe7lUVhUA8CRcv+hHjBvdqNO+yxLU9VHNoxHCBnuHwFRhEvrDstev?=
 =?us-ascii?Q?Yaxqiyc1MZdiAcJbFFJ8g48EOU7oeSv+VE9kghZaCwx4UY6jDG1KsibUKRWB?=
 =?us-ascii?Q?vkq1D6LumcEmC43CcAfhhVzmK3EZCg6HcV9coVJiXKIPMH/8/WFlFlCBiisE?=
 =?us-ascii?Q?W0xTlBtE8FLNmskDJARil5hoairkGAVca2+2emroLlE30Gkbj9d5GNR+lKzj?=
 =?us-ascii?Q?yrjgQjVkaCK5RPqWOnZAwxai+X0nqmlERJrbpsefCKjgjnNxbRqrjbQW7Dre?=
 =?us-ascii?Q?Dh4XORwaD+zYLcSUjysdT40+oHcG2sIeBnoFDIMxwRONXfBT+CT/VVHJqB3M?=
 =?us-ascii?Q?BcFJgL2UyAqmwH6vlqNFrDE3ExSYTwYJEfNJ1pA0/APrgP9dBpL0COKoRjXZ?=
 =?us-ascii?Q?3JMBXGy/WSNkBDgtEk6WOBJgQskmh1W55C01SZR8p41A2yvOfuAgPLrwTQpU?=
 =?us-ascii?Q?Uhi8E2CnOghuhalxt6pTmAoT7fe+zlJar6CN6uV2fNbMern+5QngaGjtjpOE?=
 =?us-ascii?Q?QHHbupjMBmPzLBtKuFly6yd3SxgVkWxfOVu4xJZr264i1uepOSHMrOStnSth?=
 =?us-ascii?Q?HKqCOv6Wgb1HJVHdE6uz5Gm3qseImoU2isawA47nCcofMc7QuzmKEt4p5IdA?=
 =?us-ascii?Q?4bw+UfdKCm7+d3aNfgA3PZPlESMFuNBFY2coSnxPsxb/Qv9/19MAlImfIp5G?=
 =?us-ascii?Q?IzGvky8TJlpRavBLaxqPTk5mImlglYA9SahHnnJD6x109J9bDpiev3VwoDGk?=
 =?us-ascii?Q?oJROsWRZ00sg1B5R01WMwFXdsThtRupVb1L+ISmP/OO/7kAYrsq8gxvWEWzw?=
 =?us-ascii?Q?xIGhlBF/vI2rRccEii/CmpY00xIvIrnXe8gjx+atdyd43fcnjp9jOlfrCroR?=
 =?us-ascii?Q?9DdIsc1BM64=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6lUkJ5XkNlPEcwxl6JMzfPUMoiG7Ma9k962RGf/cxgFxLjzCletsNYahBl+L?=
 =?us-ascii?Q?ZhG5s48WjiMBPOM5/r1tgjpVApEQKKJT8XlwLqpiRuy6BzOCmzYOn7LsOeD4?=
 =?us-ascii?Q?43G3fUl2fyn1CJ0dj125PLw+EPYatsAjB9LElvj+pOr3zZunDoMzvpdDyOnm?=
 =?us-ascii?Q?DM9tZMfFOnj6PsWjVVPDV/8ertwY203bNOnt1SluAAXs5hCXFq0HAb7z0EDX?=
 =?us-ascii?Q?jyFBzhNwQ3Ce/m3Vz3smF0NyKdQt94MMKzx9mwQM5quuRONE6PwOwCwa2ah8?=
 =?us-ascii?Q?jxq8e/y4w48avKHhFbGlvZ+hssbW9C6hAYJ0euK6gLwY5k5GNIpZ/eQ2BZz0?=
 =?us-ascii?Q?P7GLQXlo85X1YNwTydyItJNGQiRZrsd57u8pv4ir1NXZgzYQUY2B0/1EqKvI?=
 =?us-ascii?Q?itYE6PN8Hv5cRK0C69NW9B4OZLNOIpkYsEH/zx3ZKY7WD48vDrUjH5eZQbD5?=
 =?us-ascii?Q?O7YH+PdZhab0nGg8aJOwuC/svc9bNXrxchu3POMF96G891PE4nuRYd96deuR?=
 =?us-ascii?Q?zwK4z9E3r3xYWFY2MtrHpBStC0jApJR807H7juOQFG1uZ+ZiVMJleO9VLlcE?=
 =?us-ascii?Q?r9Gt/R+0m6zclPp3sWo6D1CwNUhyEoKR8GrGtZe/MOjA5ABigcqfO4jWcNua?=
 =?us-ascii?Q?4/OhJJvdSwDsQv5H5z52oiGhOBDfF4hWYDNMbZv6ff5Q0ZDAb9BTtmzQecNF?=
 =?us-ascii?Q?kPwPzP+jUQcnPTPNt97sbEChOibj9uLXOeed1BDJgDneNPm8SOQpVQaGj2Ve?=
 =?us-ascii?Q?sdrLHGH7KuhglsAZh/q42s1XKGnCv9wx77EhDkQOOYpJtkGz+55qgem7dyqU?=
 =?us-ascii?Q?kriDK+woJtu5anJlIg4mOtVz2s+E1B47v7dVxaG0j8AxLVT9L8nWQ3y+xlZS?=
 =?us-ascii?Q?50rNeMQHd+ECuzmiPpik9sS7uhozGJF4TZBbZxoWn1z3z7l1YCCCU3+fDOci?=
 =?us-ascii?Q?3XAz63lYPyjgYwtwF6QTTUMrC1mgkPiEhKuLfhJeS05YByYZ74hK1UPHOt6a?=
 =?us-ascii?Q?X1oKRMUqlB7714A7z2jxVuRQFyYI49E1WvbnypTQUPN8Rgn5f9Wk150I9+Vl?=
 =?us-ascii?Q?+048khiwwsjl0nrk0+1HW0ZUEpaGdq+2q9T9gYeUXjH/LZcYgABmPRg95/u6?=
 =?us-ascii?Q?bMboTlH5rR6PmPi2LUYubxwfb72UhQcZdnO7QotB/lVtKFQyuaBwRqxw5m8L?=
 =?us-ascii?Q?1szJbUpN77d9mHvXX6MGPP8wPXNNmqDyE1V8ulP59LM/lVTuPPKRaCEL2+7T?=
 =?us-ascii?Q?1re+fVD0ZQEys+0MSMgI4iIRrkObOAnr+BxKwZDvmJZcue4BNcgKQCVITtgL?=
 =?us-ascii?Q?otENjmvQu1T5FuFzXfdd7YR3+RH9kOEjXf0R+WuIcwguCKlM2kbZ/Fuo88+G?=
 =?us-ascii?Q?QwnkSatiwLLhvQ7r3wCriXLF8Q4zA7+9n8UZ+dUH7I98ngNSrq22Y1qTnFyE?=
 =?us-ascii?Q?TandGTJDRPO9B2LpZ+ol18JveJDtjDr9PW35D5QZq0d1gmL53Crfu51iAfGh?=
 =?us-ascii?Q?mWSQfjqIX7jWpUdoNLOQOuh2ab6u4oB2YDtPCzYLvNq3x374ydoDSNrkinAq?=
 =?us-ascii?Q?KDClgtHLcVOI0LVNhzRnA6QnmiFe81cLdP+VV3CFiawZgGp0QgpcXovM/8fg?=
 =?us-ascii?Q?DA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e13067e-617b-4a8b-6d33-08dd7bd90ea4
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2025 04:50:34.1896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Krc9pBqp8vb/A6Rc6wwXe0YjQTp5/wisOpkmXr+3w2eUQwV+tASiZtNrC6+K23GFOa4PsYiyG+gky2qpctDM8yi6nbNrgglYzR3PoY+mhFg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8240
X-OriginatorOrg: intel.com

Jonathan Cameron wrote:
[..]
> To me we don't need to answer the question of whether we fully understand
> requirements, or whether this support covers them, but rather to ask
> if anyone has requirements that are not sensible to satisfy with additional
> work building on this?

Wearing only my upstream kernel development hat, the question for
merging is "what is the end user visible impact of merging this?". As
long as DCD remains in proof-of-concept mode then leave the code out of
tree until it is ready to graduate past that point.

Same held for HDM-D support which was an out-of-tree POC until
Alejandro arrived with the SFC consumer.

DCD is joined by HDM-DB (awaiting an endpoint) and CXL Error Isolation
(awaiting a production consumer) as solutions that have time to validate
that the ecosystem is indeed graduating to consume them. There was no
"chicken-egg" paradox for the ecosystem to deliver base
static-memory-expander CXL support.

The ongoing failure to get productive engagement on just how ruthlessly
simple the implementation could be and still meet planned usages
continues to give the impression that Linux is way out in front of
hardware here. Uncomfortably so.
