Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240A1265620
	for <nvdimm@lists.linux.dev>; Fri, 31 Jul 2026 01:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785461818; cv=fail; b=HLNmBeWA0/TlVktL95rRhyU2xJkGUIQdXynGJI6EPvwVaYhiwrCVPXj9HvWAYm97mscZgZJdnYbGmJm6WbQoOjx+X7oaWlYwGJ4U6qJclsKeqdLN8XpBQqkovFoRkjpKKuKzxetnCO+mHMPfuzBfChP1B5AodfOvofShImFtBAQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785461818; c=relaxed/simple;
	bh=zXavVQoG9DZJchBFW9q6nPz3tXnnHPetm18W3fHyKiA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JYTy0EsCb7OvhSsaBjHJubxYmWBvGJ4/kVRpOdkygyJzyJ/uVI+/E2hODGdW7WzJF1MedWEJvqz0iwBVOltTZsY+vlPlkLAbZBmoCRU7UK47WT+wYm9fzlvF0Rec8SmZpKez/KePNy64om+ORIDHfRD2gTlm/iGWz1O5OkHadhk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UArbl/HG; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UArbl/HG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785461818; x=1816997818;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=zXavVQoG9DZJchBFW9q6nPz3tXnnHPetm18W3fHyKiA=;
  b=UArbl/HGI7nlF0EGjUdhPoXcexKULMA546DcTqjufoA+GSBINY5N7X1N
   mBpWQD7RX0lkuvQibwhyujh5m9JR5aw/UyEWocpr57Ks+tqR8DYGSCy3D
   ncs9KE1/rNLqDkfeCps+G7/iE4nb9mzoWRLM3yIl30R/0X8B2SzlqW4Vx
   XskFiyKqUyVHThD21sV4r8tVcdIdBnT71U+lM7uMGNswPj6RM7nGeKtaA
   3vJ2pq67BF9gJWYKHkACHzC4mEs6zOAfGC7g1BpKVdAs5UprKcncjc07M
   OhgDAL1SPS0/KgfcI0mJuz9iytm/KgeCtyf7MJVj2Icu15z7MZWRNBPET
   Q==;
X-CSE-ConnectionGUID: 9aV668aHRCi2QqotCPuzdg==
X-CSE-MsgGUID: 3JTk3KwLQUu5VHtUUa23Kg==
X-IronPort-AV: E=McAfee;i="6800,10657,11860"; a="108881584"
X-IronPort-AV: E=Sophos;i="6.25,195,1779174000"; 
   d="scan'208";a="108881584"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 18:36:57 -0700
X-CSE-ConnectionGUID: FOFvNbwTQrSl2hIzHSN7lQ==
X-CSE-MsgGUID: u3uyMQgOQbStSXdknkV6GQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,195,1779174000"; 
   d="scan'208";a="259208491"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 18:36:56 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 30 Jul 2026 18:36:55 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Thu, 30 Jul 2026 18:36:55 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.71)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 30 Jul 2026 18:36:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hot51ydtIDo4vkMK5EoHaF10yPRb4ZMwvDQaMATYMop5pgjim66+KV0QajaIfPUT/6OzIi7MJrC1Hqr3z9NPYG0s1y6RZfeA9R2dgQgUQIpbpFM9GD0bKd98jTsjXoX51sDcCtOzhXMxr/HFiZu2/0pnbkIcYi9bPUuZUsMiaZTj8WpzZUX2NstDsMQJegRcR85HGKiwSVpZathqY4pi19GWYmbuz6rzoFM9jSuGSLsy09LiV+JGTef+rPOgNkJh9W4P4jfu7wbb2T9at3xDMSX53+FzsKSlePDvJvFqIgNvLyntm/FM4NN8nsLNd/b1kq75ShD3y6CRZPK8KFvoyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xh/7sYyt7l+eD/nF7YwkCxlgQug1Xxc6hbduWFiqFtM=;
 b=Aj1sbOXtoQlsN84+VgygizVkxtcEeZes69LguJwsWrp1Ai3UxrblZjPbwK2mw5xX+xgjO7Oi+YLNfozhebdMCnyF0t+GKH9Nm84+YrMWLtgx8EfEgYqmCRtz8wayeCGP7OWo/zS6x0GnzhkMLa+/H6swQ9Kbk39tCERbjJCn49DRB7Fhu6b02ghy9AN/s6NKTxh/Sen6e2/unlzeuNqb2D31NqEDKWBEzYHPW0hfLEWas5RGJbf7N0cBr7cVKKmwRQUuLvH4krRmL23n6Ypel0uyllng8gZYHA8dkXUBL7+Hpbf2nZ2cHGUJMlQJIlcAHkdAcMbYoAcD6U2sCKFxhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by LVUPR11MB9833.namprd11.prod.outlook.com (2603:10b6:408:39d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 01:36:47 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53%6]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 01:36:46 +0000
Date: Thu, 30 Jul 2026 18:36:42 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Richard Cheng <icheng@nvidia.com>
CC: <dave@stgolabs.net>, <jic23@kernel.org>, <dave.jiang@intel.com>,
	<vishal.l.verma@intel.com>, <iweiny@kernel.org>, <ming.li@zohomail.com>,
	<kobak@nvidia.com>, <kaihengf@nvidia.com>, <linux-cxl@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH] test/cxl-topology.sh: test zero-sized decoders
Message-ID: <amv8KubdJk0PC9SQ@aschofie-mobl2.lan>
References: <20260709022857.18732-1-icheng@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260709022857.18732-1-icheng@nvidia.com>
X-ClientProxiedBy: SJ0PR13CA0218.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::13) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|LVUPR11MB9833:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f185923-a84e-4b22-cb77-08deeea42e9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|18002099003|22082099003|3023799007|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: cAPQdk802yxSkosncIC0MKTWa20WMPP2LjJ1dSemZQFW+rclux17UYB1jjcbcl/KDeRUcqgS+okdATu4Dz7POPMMHnf1vIFbXvhJ/flxSLL1aRKaOytBk68FFsA53qzIhFKET3WaGeueUGbXta3HrMOxWyt0V7qmR2BKwqwh3EVbvSnpxSln9mpYyI7YN6xT47xyHVYzGb52UFTCVPJ8eC1f0Yy39vozUwwxyyIBLoBbGUXFGkr9GPSB/Jl5Wwz8lq7KQMOnF35NJSJ57vbU3hEqNzcTlt7JbYWLuM1NRjFthIv9hB5worqadxxEEgou/1RgPA5gOK1JpekHknpUMepkzSEn+8yooi1yIuGlpZxq3jgwz+Alg7c7rGyMMPi9VJNsIYFHG9K5ikDW0kaoHywA9IrxL0FUZ+t6Z1292AV9jcHd4n/0qL8gEA1d+RzMg0XKRxscODMpwbUV2BoLHspGcbQIep4epFRQ2Ux5+xc7TyeeYrmFLTylpQPkDgNof6aIFFw7m1xZvkUzZfDZwABycLQJc8QeVLeZ9NvMRfvRsk0EHjP0ml6lTBwGBzMT4GyMvRgnF3CXJAYkdnYMQzyr9h9y3uUMI79UZO3rP/bWbiL1V2O/mEt+BJDJ8Ii5aOUNEwv5iCjVA41Dv9nbRFF352c18Fd1LE6TSJURrIA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(18002099003)(22082099003)(3023799007)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dWBf51YTtECbCyHQiAHKM3BinrPD65MElhAzL5kOrkFFOVL+6lcrXQ6xzJza?=
 =?us-ascii?Q?VNVQ21ALHZI7HGjceq8HmxGW8lD/q5khu1xc0hFFfsr/YHFfON0Tj2cHtkDp?=
 =?us-ascii?Q?BnLD3q+R8N0G7eQ8rWNJRnqzDzg/jCr+/n+jG5d1PafSY8UkXuFoGfctPzip?=
 =?us-ascii?Q?/Vfbc/WNSa1tGIhRxGOw85P9ciKXpewBS5+geBIwBjkRu+PJjG3qR8a9WwSn?=
 =?us-ascii?Q?Q0CeqjnLII//SZK+k+of+GFUyV00MKLFeJjJsuhMuh7G1I66HYdZ10j8F8/x?=
 =?us-ascii?Q?rzI/BryeljaZHhnmNu+6QxLFOFvfWzZ8ptI4Cqf2An8BdbCK6sJgbZGbFShF?=
 =?us-ascii?Q?EROxqs5BUTK0oLk5LK2n3SZH3aL2iAnwubjd0Yo9zMop/QU/l+Myn5NRI7St?=
 =?us-ascii?Q?az1h45CVYS4ioBRJZpS34UVwTWofa5qNF1+Q18epfnFSm8Q4OZrmjWymTEfe?=
 =?us-ascii?Q?KeHBwCdr7NZ/l3+7Fqm5iurQs2f7u9/hQQePIWNXbHG/0V+N+hPoKxlUWdS1?=
 =?us-ascii?Q?82LX6oe+MHyEYvPH8lxINth9R1UNtqJ6E+SQeHxEyzGljaVlXUyHCcQdVsUd?=
 =?us-ascii?Q?2Geeu4nY4srx+mCIWdfpNACzY+pV6YIBT9W9LEc/dfqmz9LClJI2rAt7CUUJ?=
 =?us-ascii?Q?KMVGteWckdIrtZugCJSB1o4KQtLjFW8P0hJVgs4XUkiRCQja1iwuHMwzaJ5O?=
 =?us-ascii?Q?LIHzNqOQX8xJmPwwp6xStWR1FVhmnlVoLfn8SaoqdbTdQQzOz9ka3QXmae3p?=
 =?us-ascii?Q?Oyq8Y9VMgaoTGezi2XxpU+gdPG89WFiaTToIYm9k+2VRPWqYm2vK207pvMfA?=
 =?us-ascii?Q?HZLKAmPaJ7t/NRgiBS5WQyUPFKvtZ990yDcJGdzwnOlNmHc/XQnqLxoHoVMU?=
 =?us-ascii?Q?FUYIyYy6DEr3wYf0K3hZ5GP3riRAyzcztm+euwvJtu2/TNKJiV2Wmbms6rZd?=
 =?us-ascii?Q?8qv/DnZnEEnQ7Z+IBbrPMxZEC2I4lhKa4Yj5bPLVuZSTCG4Ct0c36AZDgEbW?=
 =?us-ascii?Q?SNjGrAMk5UFZbuyA90EUstRidAR3Q6DQ7wlTsQYWvmFkyPfqIVzZNDRK49fw?=
 =?us-ascii?Q?1oLzgWk2j92skyBMbDhq4xd2TYGiK8ASddwR3GERGWEJbU3o1XQNBldQZ8BN?=
 =?us-ascii?Q?T60oJUdMU5hIIkKHHkAluqSTTxvpEnISjxtRILpQtKPZhZflyeVKOxD/SMrt?=
 =?us-ascii?Q?NbM+mp0xwTq0DS9jay5xK0VEgHC1yG580LvwHTJnyhg4m7sAH3VqocPHYKK5?=
 =?us-ascii?Q?U4TmX572qAvbKcNoFgTU8WId7mgqEpASk0BPJRTeLYL3fTwdBzEbbf+lbHNA?=
 =?us-ascii?Q?wuL2TZd990ZILzckc3VpsVSoYTvCpwwp9NSXJwraaBRq0oBe6cyeb3qcQ7Vs?=
 =?us-ascii?Q?Fs0JhXV2iJ6XnjDCP89LVzDXngP+QMn5FogdcnSGrikdUeM7jDLPYHo/gwJ3?=
 =?us-ascii?Q?FjULIItpSdUoTIoJEBacG38fE+erpjJxuBeWplanlc7qlN1Ax9CAUe9KVBl9?=
 =?us-ascii?Q?UzaU/A+8elKFUTMcT41wRZLeMQWUbZyIR4UkWvA0fvq97Z2Zq7BwF0U1WLBw?=
 =?us-ascii?Q?Rtj1t1PHEI8i7oylTNjMNZI9M3oMBqteYT9nEeaAAoe4IyI6yblAgSrHYXgk?=
 =?us-ascii?Q?bhDzSyFm9OlzmAjTXlj7zqNWNdLkytQIlUDBb7xXCOAy+kC+C+lc2g2E/E/N?=
 =?us-ascii?Q?3Bix+RYEFVltjO56T2fAzJJolFvZmF+vBo4+B4QZl5L7zzQmc3QiPxp2kIZ0?=
 =?us-ascii?Q?vuYK1JrWWY99WU3Epx9ck5oCms7zkrA=3D?=
X-Exchange-RoutingPolicyChecked: PTb17phuW115eBX4ng78QxNQikO25p9wXgLXWpEploCWDlgeCgERXehvoUFguq/DN/ntov2PRC+UFwodhxU6FR8AN30F1UdZJ+OkxKS3tTr7LRrSYRJ04YCfMpTl8qJYhbvnyeV9FGQVq9MSYrtR7yGp8Aeo1r9rHn51hlBg3OVzUvCC0y6xHOT2/X9eTQth7gl+CBS9UehEmsl1Dzx40V98o6cXtgb+/Hx+O1BMKZbPWD19IPitBuNk3lEC+QtATaCJIDVDtz6ssShtPPepBTATd8Ea8YPsSMMmVUHBHLrz7PSFV5KfY7OfN1Yb1qAuRjeVv7PxQqrZQmmHcHavUA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f185923-a84e-4b22-cb77-08deeea42e9b
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 01:36:46.0793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jUjWpHZBWXfElV+0IiUX7sW8H0Ex/MjrlKbUO9kl5d1A67ygA7S3w4rWIslo1tB8t0+90cWmfad1/MXJU46idPedeq4e10cCySiXOuF9u+M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVUPR11MB9833
X-OriginatorOrg: intel.com

On Thu, Jul 09, 2026 at 10:28:57AM +0800, Richard Cheng wrote:
> The kernel series [1] teaches the CXL core to enumerate committed
> zero-sized HDM decoders and adds the opt-in mock_zero_size_decoders
> cxl_test topology. Since the param defaults off, the existing ndctl
> suite never exercises that path, leaving the series without userspace
> regression coverage.
> 
> After the existing default-topology checks, detect the module param with
> modinfo. When available, reload cxl_test with mock_zero_size_decoders=1,
> discover both endpoint decoders through the auto-region mapping, and
> verify that decoder IDs 1 and 2 exist with size 0 and locked set.
> Unsupported kernels retain the existing baseline coverage.
> 
> Tested on arm64. The focused test passed. The full CXL suite passed and 1
> unrelated cxl-security skip. Four zero-sized endpoint decoders were
> validated, cxl_test unloaded cleanly, and no relevant dmesg errors were
> shown.
> 
> [1]:
> https://lore.kernel.org/linux-cxl/20260708104024.68029-1-icheng@nvidia.com/
> Signed-off-by: Richard Cheng <icheng@nvidia.com>

Applied w some minor edits:
[as: move new work to a function and add code comments]
https://github.com/pmem/ndctl/commit/02754b5c4b60

Richard - This got me thinking about how we display these with
'cxl list'. Please take a look at my follow patches.

