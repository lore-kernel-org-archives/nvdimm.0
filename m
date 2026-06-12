Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BD438CFFE;
	Fri, 12 Jun 2026 18:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781289764; cv=fail; b=a9nqX8bb7Yx0su85isXYZ+9jfSKmwzwT9SjxAjdOTmh68cakT/w1F9C9CK0dD43NojKkgIArTKsJ8wO6WrTdUzPGoboLCZnJ+nc2/D2AIYTM72dMvtT2h95Z1yJ7ZaViz/tJb9TGWw4a4S8XEM+B1o+72iNHAyK4pcabizq/aX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781289764; c=relaxed/simple;
	bh=AeCLB1SyUPtbca/LUfVdprCztRG3mcsw8q04yzJu5cw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Z20NUDttZk3CLMHPKQDB4q4TgFH7KCX0/d9OE2r6+TVuc71UAYcOKXoLj9ttHFXIys9VOjZ/mvjdKnxbq/SARMPtbGEyV6AiWXDKrAI9o8VM67IIZuuvihv0BxVqp9OxOGVmviXUX9YgtwtsMDHTWJ1oLFjALiqN40XvTShCl5o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HPl4sg5r; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HPl4sg5r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781289762; x=1812825762;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=AeCLB1SyUPtbca/LUfVdprCztRG3mcsw8q04yzJu5cw=;
  b=HPl4sg5rpDDN8lSRCC1grDO2zJdIgX6pK15novu7q21AsXeqF9c11cEV
   ZbdE0fHzYi3e7zQsa3BFyObUUFZnCR0TUeEmskWfBmZKoJHMxeganNmIn
   XZSZKQc2dzzZowhfjiv1UConq64TmWzWj9aXUFPe6bOrKkbdmifRJdGwi
   JuSnLJcBeJ/iG7IKhGEcj9ImzLS0dmr+qhc7+qNMmV9CQ0fNm3bZ3jtzo
   D40cVFjwTz3L3dC7WXf0g1BQ6duKhH9TrScokDSA25Z9zGB9E8uFuRKWh
   bTtFgqBhqFYFlEuKSAdG/i140Gs+eYl5avSaFGdVxUpbL/0bv5zbmuI2o
   g==;
X-CSE-ConnectionGUID: xy2e9IPISbKHuS7bpX+E/Q==
X-CSE-MsgGUID: jXWO3rpRS/ahqC9ShQnOcA==
X-IronPort-AV: E=McAfee;i="6800,10657,11815"; a="81970261"
X-IronPort-AV: E=Sophos;i="6.24,201,1774335600"; 
   d="scan'208";a="81970261"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2026 11:42:41 -0700
X-CSE-ConnectionGUID: iFA7VldsTaCA4o9QCaahNw==
X-CSE-MsgGUID: EfjqFg+mSn6EEKxgapU1RA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,201,1774335600"; 
   d="scan'208";a="246761351"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2026 11:42:41 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 12 Jun 2026 11:42:40 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 12 Jun 2026 11:42:40 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.60) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 12 Jun 2026 11:42:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ovMYRanT4KHxkEwi+7nQQTFR3x7Bp+F0SwsnY6Cl6tykwblwGJHjK8yeJR+lHWNysvQEnFdRzbBQM5UQ2ySVTl8u/SmGYF2EP3TgrmG/n9Cl/Hlp1btF99NnGP+C5vHQgp8gSuwMCaSGVLYHYQ0wL4YahlsIX5+LPDb5gADuYAoYawvE3sBoiUUYbl1eieg3rsTCzvS64biLVfnVffb5bdao+ByuLgjrhQp1SYdgVN4zGH9yGx+DQFp8u1gCBGCGbytcbx+rFiRh3DGtUOuCN62X8z6DWsUmFOE0rDZw6RdgBnEeygFjROZ+fAV3MqB6r1vJlpWHLilU2GqGnLr8vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+h3CT9TtbqeKJ9PwHju6tpBY0I6VoJArdIgD5VeGEFo=;
 b=d3zRXP+ixibN97wpOtGEuqEuxHl13xee0j31FE/TYgIPWs/OgM/6kImy1eh89s1aAS2OpgYOwuNa27e9hiR3EzxJoL/j4gWf87ZUPF2Y+WASCqqn6oMQVDDfIFOHwWEHmDE2Y7R7iVk2SsF+b/0oJHJWY5abHhMwfSkH1gbZXB60YXPDdAH57F1E0Gs9viev4mUROgZwOCIrgW4MQLKIzrmAUbA52S19fGkNN6qHTBf8XxsxtxJLf7RpkP5tYzsdqq3qrQ2IfgV6JG6rw3/1fJtwXFrb7MyZqefkQBe+Wp6l9xzUcJheuIUNL2qI4yiyu1ppkMr4d9pcq8OCXrz0sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CH2PR11MB8835.namprd11.prod.outlook.com (2603:10b6:610:285::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Fri, 12 Jun
 2026 18:42:38 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0113.013; Fri, 12 Jun 2026
 18:42:38 +0000
Date: Fri, 12 Jun 2026 11:42:29 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Li Chen <me@linux.beauty>
CC: Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	<virtualization@lists.linux.dev>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/7] nvdimm: virtio_pmem: fix request lifetime and
 converge broken queue failures
Message-ID: <aixTFVGZVDaCxMis@aschofie-mobl2.lan>
References: <20260609120726.1714780-1-me@linux.beauty>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260609120726.1714780-1-me@linux.beauty>
X-ClientProxiedBy: SJ0PR05CA0141.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::26) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|CH2PR11MB8835:EE_
X-MS-Office365-Filtering-Correlation-Id: 74c87762-992a-44f4-88af-08dec8b260a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|11063799006|22082099003|18002099003|56012099006|3023799007;
X-Microsoft-Antispam-Message-Info: IN/VecJO6bpDVWhU3pEnwl5WBSMpslmZWqydM84Uys+kJmhKeI79mkQALyPK85RrlL8p83cz6vcb/deuUEjozeMR5Pe9vls8Cs6sn5092f21k7TUSmYAfw7eGzIIueVg3vj9y8Mlfhqbw5ZmSAGj127BBN8Z4bbmPKwCeEkIqdRZVl7PSDEJdubuo2tmcQJxfKKGTukvkedhIgAyrW11uRf3fmr4UloQ9i7j5/ZQ3CQDgt8K4bR06uMjaqVHTAd7f+fPxqrPO9tTmMZ4P1BiSlcE/HIlOemgbxvDjZjeWjikkQrBR5JLgfdz7y+tG4KyWT3boQuTqH3vDWjgAyfe8JnthXljgiRTbVHoHmYA1kC2ee9E71bHElyqTjoNLzyKVujhWOMLaVS/KWkUcO0V95OLZOhD/bUmiqPpQCGaKcOyD/vEQf6EF3KP83InYNJQSQhnJtonzuCOJ8YOue71U9QfmZNAO35iayE3t/b+gucEGgIDuySSwjeWu76yHjxnAx430Qoei+IxLfVZyx8JnCAy8m6Wmw+4I+GlZ8fvpYPYi/1Z1KYFutQsNHzFUJV1AyPE3p/wt9xoggPB6tnpnohrSeMjpUJHdjLhsLWfr2Sow6D9/uKQ6+rxW6DxWZ7t1E/23lf9D+RO7NopxORBMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(11063799006)(22082099003)(18002099003)(56012099006)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LDoSZO4snajRQwO0UwCzdCjqMFiIHJDbOyNUMs90g5UWslgm5E5LOIX/tFAv?=
 =?us-ascii?Q?mulScBV9JWcwUHWtWYk/7AzGLjRDPmnbgu/5QRznmWXRir3VDdjncGUAo/WO?=
 =?us-ascii?Q?UicLjDzWHT6td4BFDfzz3Qsb+PGm6ynAqDIj1iicUw+dwM/Rt9TjQfVt5aHw?=
 =?us-ascii?Q?IV/TJvvuHN9J2bv+96V9DVe/zkN9TwDaJAHTFN9k21jAWW6txgqLrbE4jOAQ?=
 =?us-ascii?Q?8iwCAFEKgLa/mMxodzAhy84ekaEcJCP2siVocAJjj3hOrC151aXy1q/Lw4V8?=
 =?us-ascii?Q?C3hheiIMiZu8b5y0JRPrtOoe5GiH61U39AuydLBYPJ6FAQEO4zqDprTwd7Yh?=
 =?us-ascii?Q?+dOraiP1h/z6hnW/4Xjs9oWXvmqMt9UZHeBRmLCTJNJJMXQCANNsRIhePZQ1?=
 =?us-ascii?Q?/h4m4AUZPVq4n8XpqDzZv0uuVhpCZVntriG2Csn739OwDH4WGAwe4yJTg0nz?=
 =?us-ascii?Q?CuZKuWjtxANpYJo7M7SaLaD1XYqXXj7GUUhw5drZU8EhArMFtuvy5hx+sU4J?=
 =?us-ascii?Q?hVo0e7LPACm//ZEHN8EHiMi36z9/kdYQDMlLYsSxmTvxd+hiz//5DUCOd5Vy?=
 =?us-ascii?Q?BeKAjnB9IrQ9KEZ7GCHVuJHLP2JJ8md67yPARYEQ7wkCT/wYjw9biZOrLWPg?=
 =?us-ascii?Q?C+ezwC71NPJv7rnyKhHur//6+NHLS+iQbF8gBLiC+7RH+uyvY89MltSg2MY7?=
 =?us-ascii?Q?yVGFmcYscYynUgRgVFnfWiWF+V8PUBwqOtw7fzIBh2hnq6CFVhYUYnpUGi+h?=
 =?us-ascii?Q?7JsSe2NiCPKkPZ0mDVc+6g0MZIIruDrMewMdYZwyKKS74ExfsvK6SDsQUkLw?=
 =?us-ascii?Q?yAhmCoQktqO1KfETLq/JQXSWpClbwhhUDaom8quXxmOCtVBFK3UBZiQb8Y8Z?=
 =?us-ascii?Q?qO/IAEb+6LNlgoGa3O3WVMq2YZlJ3rVMQhaXPSzn6KAC1aLRJMRIiFkxSar4?=
 =?us-ascii?Q?HFb+oITPCKw8ePXab0iEy5wtxzKxHuRGsTwtkk7Zwr2Mfxit8QX6C5Ec02Xh?=
 =?us-ascii?Q?ltQVcTnJ+N2mqkYIHIm0kn/yObU201bK3ifq5VjIsryIwzRtFoQDt+LUvl55?=
 =?us-ascii?Q?AXWBMwCGDwB/KCzIT9MQI38xsE3eXD9ln6b/rzqW+AjvbTZAKknGj14mC/Tp?=
 =?us-ascii?Q?YQEeL/JatPbHy+D2v/N/qR+6akqPiA6kjEjew4LLRyaU8vQDErRh+ETtdWPR?=
 =?us-ascii?Q?NUeRUv5vUO+pscUr5Sdyj6jK8AjqhfGuYAQG5NBf8mW1LvpeIbTJkPXuXYdl?=
 =?us-ascii?Q?Nl+vqJF0P5Ws+0QeqpuyjL48sodpQC7LQyPG4r+3lVySFJpAUDHPh4bCkI1A?=
 =?us-ascii?Q?zGR3bdHpUZREknubIgVD2VnUZoenJXZl7oIrMOVx24NOAgkJCPZlglrrTO24?=
 =?us-ascii?Q?46X+PP5H13ujGRMFFku24FdCHmMOOdVbs+bSKOd3vlS45pYCnO9u/1ZYFHZw?=
 =?us-ascii?Q?arXcmbfD5/SRIkF/w7z5IMevpfetmaIQrKA61nTYFwHBXyds/UW674ZRSh3e?=
 =?us-ascii?Q?F/+gUAxOo9NrSHOCZUtdw0ZVCHhjTSO9+wZcs0PLM6LOsn3hRz7lmgoYwvD4?=
 =?us-ascii?Q?e2MxuF6CWnymF/xElAVmiY3z9fmRdVxL8EDWZ1qWqZkbodpSFeVmW/7TFBN8?=
 =?us-ascii?Q?9m2cJfmYEnrichUUgKRkgFwvf4YDY//YOeN3ejHUGx9elLhpW3w3IHP4gIa4?=
 =?us-ascii?Q?6op2jNrJhyCHZaVZplwWT+dVOzfjXtOJNkL289cK6iycIIgGhBZVRTRLEjYE?=
 =?us-ascii?Q?9xPYMZ27Z0DZW2916tfWytjaJSCJUnk=3D?=
X-Exchange-RoutingPolicyChecked: ZUP12xkg9YEVorT5HArbsd+2nQofEHWzaR95KeLXsFvTpj/Omix4vpX1YJCK2hf+GkgtFfLCRH+apjNpFP9CjLjJ0EC+OU+PdhPoWYId/W+VYVqMdabjW78Q2N8g1yhKUq/0qSvJUdpjdoqlcVOH9Vm31Bum7mknkLo0qA+0K9QK6of51cq+b1b2a/mK3wEB60MeSDxChvctyhvi+20N8BsR2CrlhgJWC2ordGPH+c0MbIgxRBndNz8EvNHZQ2phxxCegFqLR0bXE2wY60Kgc6p5U3WQVYqpAuusnT0cLS5dzFCaGhWORMwHleayiDPAdDKCcrta21x/BHVomtO3mQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 74c87762-992a-44f4-88af-08dec8b260a8
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 18:42:38.6942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ErwuM7s3/1oD5SgMwM1LfdPwXQ9PT7BwuYJkufcMExGPtMb3VRldXskdb4RnSDClcK2FJQW2EGUcL2J2/jjycDCmX8usBAP+sqMa2EwV6vE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB8835
X-OriginatorOrg: intel.com

On Tue, Jun 09, 2026 at 08:07:14PM +0800, Li Chen wrote:
> Hi,

Hi Li Chen,

In case you missed it, a Sashiko AI review of this set has posted
feedback. Please take a look.

https://sashiko.dev/#/patchset/20260609120726.1714780-1-me%40linux.beauty

-- Alison

> 
> The nvdimm flush helper currently converts any non-zero provider flush
> callback error to -EIO. That hides useful errno values from providers. For
> example, virtio-pmem may fail child flush bio allocation with -ENOMEM, but
> that is currently reported as -EIO by nvdimm_flush().
> 
> The raw failure seen in the local mkfs sanity test was:
> 
>   wipefs: /dev/pmem0: cannot flush modified buffers: Input/output error
>   mkfs.ext4: Input/output error while writing out and closing file system
>   nd_region region0: dbg: nvdimm_flush rc=-5
> 
> The first two patches keep provider flush errors intact and make the
> virtio-pmem child flush bio allocation use GFP_NOIO. async_pmem_flush() can
> allocate a child flush bio from filesystem flush and writeback paths;
> GFP_NOIO is a better fit than GFP_ATOMIC there because the allocation may
> sleep but must not recurse into filesystem I/O reclaim. With these changes,
> the same mkfs sanity test reached mkfs_rc=0, mount_rc=0, and umount_rc=0.
> 
> The rest of the series addresses virtio-pmem request lifetime and broken
> virtqueue handling. The virtio-pmem flush path uses a virtqueue cookie/token
> to carry a per-request context through completion. Under broken virtqueue /
> notify failure conditions, the submitter can return and free the request
> object while the host/backend may still complete the published request. The
> IRQ completion handler then dereferences freed memory when waking waiters,
> which is reported by KASAN as a slab-use-after-free and may manifest as lock
> corruption (e.g. "BUG: spinlock already unlocked") without KASAN.
> 
> In addition, the flush path has two wait sites: one for virtqueue descriptor
> availability (-ENOSPC from virtqueue_add_sgs()) and one for request
> completion. If the virtqueue becomes broken, forward progress is no longer
> guaranteed and these waiters may sleep indefinitely unless the driver
> converges the failure and wakes all wait sites.
> 
> This series addresses these issues:
> 
> 1/7 nvdimm: preserve flush callback errors
> Return provider flush callback errors directly from nvdimm_flush().
> 
> 2/7 nvdimm: virtio_pmem: use GFP_NOIO for child flush bio
> Use GFP_NOIO for the child flush bio allocation.
> 
> 3/7 nvdimm: virtio_pmem: always wake -ENOSPC waiters
> Wake one -ENOSPC waiter for each reclaimed used buffer, decoupled from
> token completion.
> 
> 4/7 nvdimm: virtio_pmem: use READ_ONCE()/WRITE_ONCE() for wait flags
> Use READ_ONCE()/WRITE_ONCE() for the wait_event() flags (done and
> wq_buf_avail).
> 
> 5/7 nvdimm: virtio_pmem: refcount requests for token lifetime
> Refcount request objects so the token lifetime spans the window where it is
> reachable through the virtqueue until completion/drain drops the virtqueue
> reference.
> 
> 6/7 nvdimm: virtio_pmem: converge broken virtqueue to -EIO
> Track a device-level broken state to converge broken/notify failures to -EIO:
> wake all waiters and drain/detach outstanding requests to complete them with
> an error, and fail-fast new requests.
> 
> 7/7 nvdimm: virtio_pmem: drain requests in freeze
> Drain outstanding requests in freeze() before tearing down virtqueues so
> waiters do not sleep indefinitely.
> 
> Testing was done on QEMU x86_64 with a virtio-pmem device exported as
> /dev/pmem0. This v4 series applies to v7.1-rc7, builds with
> CONFIG_VIRTIO_PMEM=m, passes checkpatch, and passed the local repro checks
> with a local-only virtqueue_kick() fault injection. I also checked that it
> applies cleanly to next/master at 6e845bcb78c9 ("Add linux-next specific
> files for 20260605").
> 
> Thanks,
> Li Chen
> 
> Changelog:
> v3->v4:
> - Rebased the series onto v7.1-rc7 so it applies cleanly to Linux 7.1-rc7.
> - Update the allocation site in 6/7 from kmalloc(sizeof(*req_data),
>   GFP_KERNEL) to kmalloc_obj(*req_data) to match current nvdimm code.
> - Add 1/7 to preserve provider flush callback errors in nvdimm_flush().
> - Include the GFP_NOIO child flush bio allocation fix as 2/7.
> - Renumber the old request lifetime and broken virtqueue fixes after the two
>   new flush error patches.
> v2->v3:
> - Split patch 1 as suggested by Pankaj Gupta: keep the waiter wakeup
>   ordering change in 1/5 and move READ_ONCE()/WRITE_ONCE() updates to
>   2/5 (no functional change intended).
> - Add log report to commit msg
> - Fold the export fix into 4/5 to keep the series bisectable when
>   CONFIG_VIRTIO_PMEM=m.
> v1->v2: add the export patch to fix compile issue.
> 
> Links:
> v3: https://lore.kernel.org/all/20260226025712.2236279-1-me@linux.beauty/#t
> v2: https://lore.kernel.org/all/20251225042915.334117-1-me@linux.beauty/
> v1: https://www.spinics.net/lists/kernel/msg5974818.html
> 
> Li Chen (7):
>   nvdimm: preserve flush callback errors
>   nvdimm: virtio_pmem: use GFP_NOIO for child flush bio
>   nvdimm: virtio_pmem: always wake -ENOSPC waiters
>   nvdimm: virtio_pmem: use READ_ONCE()/WRITE_ONCE() for wait flags
>   nvdimm: virtio_pmem: refcount requests for token lifetime
>   nvdimm: virtio_pmem: converge broken virtqueue to -EIO
>   nvdimm: virtio_pmem: drain requests in freeze
> 
>  drivers/nvdimm/nd_virtio.c   | 139 +++++++++++++++++++++++++++++------
>  drivers/nvdimm/region_devs.c |   6 +-
>  drivers/nvdimm/virtio_pmem.c |  14 ++++
>  drivers/nvdimm/virtio_pmem.h |   6 ++
>  4 files changed, 139 insertions(+), 26 deletions(-)
> -- 
> 2.52.0
