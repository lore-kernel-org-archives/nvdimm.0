Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7173806D1
	for <nvdimm@lists.linux.dev>; Sat, 25 Apr 2026 03:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777086196; cv=fail; b=u8yej/6wLNm7pcTprdwS1deGK8HhcCFVpBQHaKi/KfLf7A+5JG9aQiVl3mHXazJOdJa51qaibZ3vXNrwNvuvZtfg/J27mJ6p7qlNc/GYbIK4OspOmvdGbaMcXnnZZtVDyukWO0CwT8hBXWnKm9d3JOiMAbDffhhw338PrCipHVE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777086196; c=relaxed/simple;
	bh=/nEAuZLS4fZ9jDDiIN1zpVMDQG1GjD8UfUa18PBrPic=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=llZzff7IABX12lktOeOWlMUKJam2SgkkYwbDqR95pn/V9JQiCh4MMYYLz8JywLqLOIN4jchAOpvk21SSDREOgSCrYmkxJQmnOXQJd/ggpoEGt2E8KVxK2v8kysnFGqE8yv7aPLy/3IULsetm7726gsvvrFs7CWTxmK+tF+WnHPM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RFxUPRvR; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RFxUPRvR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777086194; x=1808622194;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/nEAuZLS4fZ9jDDiIN1zpVMDQG1GjD8UfUa18PBrPic=;
  b=RFxUPRvRrqvMPS+uHtEDqm4vEQZtDwb96AQOU2PCxkHwZF8fS8ilaSMH
   ieNpuFfj+c+3ZtGscukFDNOy/J8Lb+asbz9NVfg6NeRxzL/oUHQGkZ61+
   F8V4cUzQqOQDRwC4FQ78BiMvsYL//7gFVmSzO2B/1H/xQlon4f6zk+4tU
   Afs+1S4fKNusUOFXMhmrDdlXLthTO9bjXcdWxSrmHkzyH/9KFbzguNIv+
   4dhpFj3xewQJxklQd7OAEYplWUPjNIk7v/uh5wko3Ft8G7Rs1lpSW7IFF
   x0O5I8vSpz3+QjWhNPxKmZbMsh58AzG8eBjeptK1gWcEM7mLu1nL+kk3+
   w==;
X-CSE-ConnectionGUID: ayiuBm0lRjGUzzvf21sXGA==
X-CSE-MsgGUID: cF+fxZgVTvyTaQsuAWmThg==
X-IronPort-AV: E=McAfee;i="6800,10657,11766"; a="88766278"
X-IronPort-AV: E=Sophos;i="6.23,197,1770624000"; 
   d="scan'208";a="88766278"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 20:03:14 -0700
X-CSE-ConnectionGUID: SW4j3Ea+TpyNhyCVV+qT6A==
X-CSE-MsgGUID: bMGUB/7JR7mjf4SwmbDU4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,197,1770624000"; 
   d="scan'208";a="263510714"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 20:03:14 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 24 Apr 2026 20:03:13 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 24 Apr 2026 20:03:13 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.65) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 24 Apr 2026 20:02:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LO+SR1tafmqWhyRvV0t5zfSpw7kVklLITYfd3vuIJtJK2/D0RXoX4cpq1piCubMtnAZgoIXvqMln6b2i2Px+Bzx3QE9kjZ6HyKHv34BcXey/+44RNYjOHQznCa/aJR733cFx85Zc4aIuO/H6vpOKoMd/L7zp8cvkOMyyFu1rChVpf4dG194xvqXv1RMw613Y6Gty46oBU2+X7Sj9Dl/le4Wred+aV3ZSHMU+ltd55GWWRhXlE/MLdhXG9KKAxgX+aMB5GQdXuymBQkX1Ju9mLAhhxQZGWfd/8nFgVIeVuGd+z3lIKot9GXijPMsHwlPmpu+tm88vFsVRmJ1KoVTIAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=He2nUTqkN1CKxRhOLck0F6k8+HBVgQQiN80XJfjo0cs=;
 b=OQy2rWOpDOt+FiABlszQO14Hi80b6beyM6+CE88rWnGGtVSp7YLHYQ8FyLFYk5IFJsEwj7jQ9dDEYHWEbcSpXlAxMxJEMGvaxz4b25y7ZuvhHRU2h48uTV2HeD8SycxYKyN+0yKiKVxEsTlQ4LaOkIf/YZiq25npVgG4c+6QVxmAeIqWnsn7C0qgZo5KSaHOihJlsysfeUYqzGz7pleWwYF+YePdhyNh6iRHUAYCfrUbvjFME7q9eAtRScVNUREPpefSLqhvmgWF30/1aCGtJHJEDWY11Jok0n40BtApOdMCaFvroNL2qIqXFMhHr63FB7t0VCVdHqbTXhwutvBGaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA0PR11MB4559.namprd11.prod.outlook.com (2603:10b6:806:9a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.12; Sat, 25 Apr
 2026 03:02:31 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%8]) with mapi id 15.20.9846.021; Sat, 25 Apr 2026
 03:02:31 +0000
Date: Fri, 24 Apr 2026 20:02:28 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>
CC: <nvdimm@lists.linux.dev>
Subject: Re: [PATCH] nvdimm/btt: Handle preemption in BTT lane acquisition
Message-ID: <aewuxLg0TWgNCzbh@aschofie-mobl2.lan>
References: <20260424234405.3762827-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260424234405.3762827-1-alison.schofield@intel.com>
X-ClientProxiedBy: SJ0PR03CA0389.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::34) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA0PR11MB4559:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f5485e1-48f1-459c-4bb9-08dea2771778
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: 64Zfibw8+CDXpXahqtXXe2mL1tG6+muUc/qyZuw9mpP+VjrJom8hmV9Bjth+6iLRh3PvRYAYcPTqdk1d/7bH1dji8FJQDDs3Ot7dxN2+BpoAnGEkkeeskieGwD1bbXJdz5lRENG80dasuOn40KHV8DK9f5AFz3cQXD2BO4pkI4J9du2r/cG3PCTssCOerGNJzKkogIBuiEBDCwFRGYTGeN/AONZgZ0bZHotjtX0/9QlMQ5EiGrZNSf/vz3A/Fg6xd77N6LIsyfwzQQzzVCo/zKTZ7sVVGVmaZ55u9SdA49L7Vnjg8cypWYivgcdBjcVFe7MX8vIaQ7y0YG9VcK9TdRJ4Dsv04cI9sdM/D2irqxpWh5z8yARsgYOSobPaMz07/PoVI2oL5W4bDCbMn48E/eJZ/LCav+aQiI6aaN1vy51zK0tFVgSpUDegoxUbQyOYnEPdErICHKs6DkpkGaYPqxulXNntzNcIgPGzr7xoeRSJHwBE4Jks94qxNNkq4oYfOqNSSH6fhh6zhfzrp0CPfhE8P+lGj7+CXhndUKUsYEyshjUiSiFjoO2HeLEDe1GWfX3WToISX4f9gyDiExhnqInLHNFNS276HKNC6aKv6zd0VYTSi2iin3+JbJpxBWfeS0ftg6HqX2Ctl0U4YvCRTrjgQhLYzic5yTTtHSCLRDG18xdyNVpNZhTsLNR4/DtO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rozwYTsWcaMAE7k9q+xzPDxKVgCeN9UlbVJDsuxgb/jRfCWuvcfKiwOn3ZrK?=
 =?us-ascii?Q?lOLNIWxElOrTnyKqUbhIEznVpSgh7zO486JTfXqwGWYfHO9eTKELfqLR3WC4?=
 =?us-ascii?Q?GgwuKIp1+jmSh7RK1kabFD+5QxBVAbeifoCYWdvMM96MUYA5RaOUKgErP9F9?=
 =?us-ascii?Q?3Z4+NllHTFqGvrD7rSi0VCSCQdlnoRyJDqIOgghrQc7kjCYexOR+ShWKbGBd?=
 =?us-ascii?Q?XThYFtP6PkMeybKVN2I2PlBM1DYsW6ExnrrLeZlotfg7ksEHP8LleQyKjal+?=
 =?us-ascii?Q?0Y5Zw/9IFjDOSFZM1oZ1hNpw8+/+CRMsCPiUkggEl7qVF6gtvEgDB0d58vAY?=
 =?us-ascii?Q?buAayNQQRwTBHYGRttU7s2ezA4lPGcnbRYPVN+A3jgpIrbevi4H6Kq0r5sUS?=
 =?us-ascii?Q?k/HVersUAFRwSHsMQP2hsdkZR19PODEY5uYwl2VvvKZeSb/Y89VIfd3ZOkvp?=
 =?us-ascii?Q?ehH0SXqHLvvT9NlcvyGjDr7DgemgsmOHHU8N+NQ6flQRV+0xKYrFVemRAf7+?=
 =?us-ascii?Q?srl5CZV8dW9yp5tw+5D4OqrK3fbIScZHhbMEJzENXau1/K04+frebwLnkPAe?=
 =?us-ascii?Q?1ldhkqsI93mnVGzOL4cUx+JICifXcMqLkMDvxUaD2z6x6AbUhmfnuwquXGsK?=
 =?us-ascii?Q?GlfdHgT3uE9mxWfZ6iooIXm7HdGTL8CevkSUVWZZP3F8IHj+vDKU5KJ7rXhE?=
 =?us-ascii?Q?9nd9eEORCW/wSGvkEhyiHqbf2Fs/xd7F+KRaSM88xt3YioxVqKb0jsIUd9r8?=
 =?us-ascii?Q?w+fYNCXyVpqaECPRELh2cEv/VJJe4XIP4oLMj/+dC46ZFQk6hoZvQ+3dRbi6?=
 =?us-ascii?Q?GHG7B1SVw/5b5kM1gKBBbTgtmrgL0ngA6L1zHST+SxWGSIIuhWX5OvJMkWvV?=
 =?us-ascii?Q?Z1Z8tIwjtFrTTggB3tsmkreVviZouORaLxZU0lPU56BWcTXxYxWJqw5npEYj?=
 =?us-ascii?Q?II6NEf4xwcvkahed2gjVgdjOvzloL6e1KBx+OhzKRkRFLtXCDnpZAwJFAxak?=
 =?us-ascii?Q?rA3qB+nHzdO1LaTyc50za0+wgHmNDzOdRx35wNHj5K7L6NAcmQ4b/twfW/5v?=
 =?us-ascii?Q?Sdu/Z3Yhfry9DlocOsO2q6YGcAviV+Pji0C/+EGShIpMXink0SrTvU/QaFfv?=
 =?us-ascii?Q?KCI6v1CJ2CZ56cO5y2KPuoD1kyJYA7j7xwQdDycdwl9RVyyBdhjTtddBn3A1?=
 =?us-ascii?Q?KCwKfT9+VKT7iWZyOYXDMLqn3ZTPkf1BEAozJmt/S0iYuJ1/V69v3tXAT8NP?=
 =?us-ascii?Q?KVCT7LS+GF5L5ywHTO+msSumzEIXO/BYVGHo097dTELb1x2zKo1uDccZLLtZ?=
 =?us-ascii?Q?zF1rilDv7oSebkHynzGMkRx52LGTXbQZHDAM8CGb58EIZHuQLCJimWwybAuL?=
 =?us-ascii?Q?iSu6xQsA/RyTL9IByUzJ0uRZWnSUWzPCP6xeFT6xy0ScGFs3oTdGw6JAfkVR?=
 =?us-ascii?Q?JnVddCV2iNBZ1w7a29bIsU9AMV86KeBCG0NZ/o6Ef3pHEKWjG5l0O1f0/GKZ?=
 =?us-ascii?Q?QkAUXJMnAZxDPgcq0Lv5oPt5C6oH5g2KbLDeDmQxth9UjPKgXE5LpiNZ45lH?=
 =?us-ascii?Q?+iL3mM50C7RyxrYCevfv+GDWh2IcXSscsDAYkSsI6P5xqJDIBzG93e2+dbA6?=
 =?us-ascii?Q?ROqPkMlxYurnGpLafsDAE+i0h1z1I6aF4WV2VYjMhPB9b8fnnCeIUY8AzYiM?=
 =?us-ascii?Q?tPDMaOYsJYk2b3CBtJhgrcgJqhhk337r8uyEZKhJ211qsSNjMvrXTdTuT3SO?=
 =?us-ascii?Q?FikFNhAHAX9tgPeRbL4rz3Ge7dIBrhM=3D?=
X-Exchange-RoutingPolicyChecked: JC0OpXZt/Eg2go3RXvHVNRA+25Uc9P5lEjXDgKchJMm0yDSAfTsSkjupp4bXH2Pn1GsLRPke+h25vfn424U6lEfkyL6ITNUZBEGzi286GJm1LbOKRYniU6pXmvv4PT8HpAC9kJwUev+OneAUnoiNL22sqBA8ku/sRSU2ibjq0FSmhC+98lE2X1eY2HUmyTJGeAvtRhibVwo0uWalN+910hIDbCmAYciFGoIZTIaPeu0tNJQp9DoYbl7yUpbA5vFnhyX9VzcDnd86kFDDK83ixBpZD7hPNtKHulX7wP/NgEiJtvw8Gy/slupCAOjgu52mvvimEaS16HnTTjp4G0ffIg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f5485e1-48f1-459c-4bb9-08dea2771778
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2026 03:02:31.3925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: faQ2zW4WE+WNFQM3i9sQno+RbKELfHfQmsGrRTHPlUhE6JnVxFEoWpqdzpTi+EoYCJ+AR7Q8R8qHk2IKZX/rI2Sdicarsi/vBkNl3CNdk+g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4559
X-OriginatorOrg: intel.com

On Fri, Apr 24, 2026 at 04:44:03PM -0700, Alison Schofield wrote:

snip

> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index e35c2e18518f..830241b93bf2 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -905,11 +905,10 @@ void nd_region_advance_seeds(struct nd_region *nd_region, struct device *dev)
>   * @nd_region: region id and number of lanes possible
>   *
>   * A lane correlates to a BLK-data-window and/or a log slot in the BTT.
> - * We optimize for the common case where there are 256 lanes, one
> - * per-cpu.  For larger systems we need to lock to share lanes.  For now
> - * this implementation assumes the cost of maintaining an allocator for
> - * free lanes is on the order of the lock hold time, so it implements a
> - * static lane = cpu % num_lanes mapping.
> + * Lanes are shared across CPUs using a static lane = cpu % num_lanes
> + * mapping, with a per-lane spinlock to serialize access when multiple
> + * tasks share a lane (including when preemption causes multiple tasks
> + * to run on the same CPU).
>   *
>   * In the case of a BTT instance on top of a BLK namespace a lane may be
>   * acquired recursively.  We lock on the first instance.
> @@ -920,35 +919,44 @@ void nd_region_advance_seeds(struct nd_region *nd_region, struct device *dev)
>  unsigned int nd_region_acquire_lane(struct nd_region *nd_region)
>  {
>  	unsigned int cpu, lane;
> +	struct nd_percpu_lane *ndl;
>  
>  	migrate_disable();
>  	cpu = smp_processor_id();
> -	if (nd_region->num_lanes < nr_cpu_ids) {
> -		struct nd_percpu_lane *ndl_lock, *ndl_count;
> -
> +	if (nd_region->num_lanes < nr_cpu_ids)
>  		lane = cpu % nd_region->num_lanes;
> -		ndl_count = per_cpu_ptr(nd_region->lane, cpu);
> -		ndl_lock = per_cpu_ptr(nd_region->lane, lane);
> -		if (ndl_count->count++ == 0)
> -			spin_lock(&ndl_lock->lock);
> -	} else
> +	else
>  		lane = cpu;
>  
> +	/*
> +	 * migrate_disable() keeps the lane stable, but does not prevent
> +	 * preemption. Only the owning task may recurse without taking the
> +	 * lock.
> +	 */
> +	ndl = per_cpu_ptr(nd_region->lane, lane);
> +	if (READ_ONCE(ndl->owner) != current) {
> +		spin_lock(&ndl->lock);
> +		WRITE_ONCE(ndl->owner, current);
> +	}

Sashiko-AI review[1] pointed out that softirq re-entry could bypass lane
ownership checks and deadlock on the same CPU.

In a v2, I'll use spin_(un)lock_bh() (above and below) to protect
against that.

[1] https://sashiko.dev/#/patchset/20260424234405.3762827-1-alison.schofield%40intel.com

> +	ndl->count++;
> +
>  	return lane;
>  }
>  EXPORT_SYMBOL(nd_region_acquire_lane);
>  
>  void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane)
>  {
> -	if (nd_region->num_lanes < nr_cpu_ids) {
> -		unsigned int cpu = smp_processor_id();
> -		struct nd_percpu_lane *ndl_lock, *ndl_count;
> +	struct nd_percpu_lane *ndl = per_cpu_ptr(nd_region->lane, lane);
>  
> -		ndl_count = per_cpu_ptr(nd_region->lane, cpu);
> -		ndl_lock = per_cpu_ptr(nd_region->lane, lane);
> -		if (--ndl_count->count == 0)
> -			spin_unlock(&ndl_lock->lock);
> +	if (WARN_ON_ONCE(READ_ONCE(ndl->owner) != current))
> +		goto out;
> +
> +	if (--ndl->count == 0) {
> +		WRITE_ONCE(ndl->owner, NULL);
> +		spin_unlock(&ndl->lock);
>  	}
> +
> +out:
>  	migrate_enable();
>  }
>  EXPORT_SYMBOL(nd_region_release_lane);
> 
> base-commit: 028ef9c96e96197026887c0f092424679298aae8
> -- 
> 2.37.3
> 
