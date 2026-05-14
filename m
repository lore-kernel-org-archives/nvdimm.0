Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2458386553
	for <nvdimm@lists.linux.dev>; Thu, 14 May 2026 20:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778790218; cv=fail; b=RK5NMd/ujLzJkUybdxUO58RmMGQJL3LtIbrnF9o6cG35XL+lTdEQdL7bPeXTXpd0DM9PBxfSAdgBuVZ5fcOHpucK2d2qfK93LxDFl5GpAkizmnVcMuC9CN6lNYziYQllBw/6dp+KyB1ypK2CFJd1xeYtT4B0EGVjSalDVPvDhx8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778790218; c=relaxed/simple;
	bh=efpM8Wz7OXUKIdEqk/fNnNaYY/HJwoUdLBYA0rQj7ew=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mGD5AwvVq0F3cxv9U+98lt7FRLbGPTkuUtYSB2JThMTW1IlmWz/P6wEzOVDyd28e9qo3mM2Ez7sf4QEBJiteN+mf3ka9I82C/oijDn2oIlMUxJltKbGhg4BhMKFvjOrtViSWZMSphI2KRNJSMcGVr6rQPpwTOscxLo6iBf+i/Pk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kcdYQX7l; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kcdYQX7l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778790217; x=1810326217;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=efpM8Wz7OXUKIdEqk/fNnNaYY/HJwoUdLBYA0rQj7ew=;
  b=kcdYQX7lMdoggdskV04f/FCPJpVlVjnW8ZkGtgzTiJtXo5M3ELHRrj91
   fqaRwuLo/qQd0wj45VeG2N8mdb+jOOIK34GuEle2cht+qfcdefKAQZSu+
   x2WtLLkj7KMTP8G21X+qIN8UmrQy+SSeJn+4JGV9IKKJVSM6g4LE9zdo0
   ESQOYTEP5yuKf5RON0Kcrk0i+/BE6q1ctINVWYeDV9zh/ZqKfdIo3CGuO
   Wfgi1ZOUdaerjcC69VtU1CrTtSlIonB4tFSvsfevYTwDijSzWo1AQOux9
   7OHA0D1JFg4h9EgMlKZzcrTgGanCrq33OqMm6jx5PQSIgEWZmHbRBGTyf
   w==;
X-CSE-ConnectionGUID: xXS1eBD1T0yxnUMQ0c3HqQ==
X-CSE-MsgGUID: zQ1pp5bcRW2E39gAZyfTOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11786"; a="79696827"
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="79696827"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 13:23:37 -0700
X-CSE-ConnectionGUID: uR1dzx+IRDeCJh42Gbet5g==
X-CSE-MsgGUID: Lhu5AnHKS0S1vDSNTCUwMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="238748717"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 13:23:36 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 14 May 2026 13:23:36 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 14 May 2026 13:23:36 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.1) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 14 May 2026 13:23:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gpTLrjn7bbnBQ91GpaSOcaWw2kODVt9qKVWu1iRuMc38a+vAFVuZ3ZxGSnrWqt9dS8nNiTvUOZ0Xtd0MnOnVcliaZY43I62i6wQ5rAPPMCnviUhn5gZ9nBdMK25VOEtv1jlIrDvcrpQDNMuXtB0xrPaC+SyuJTR1QGmLZb/CmUu0LCk7+UV7vpvVEc3dAxo3KrWVEKxcvocOSrVvbagqC1BqMojwxAFJbaB9nd3R1PLg25Q2/CQZHy/jqGLlsPfptHhH1lhvF8wJprgpYNBQa6iFcABBfTZ70KCyDOyOK3Bp68XesnNLBkVshOqiSLCdms7Cy/pcb4mz9DQC3Lo+JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FHnJSB117vjz0XaVu2w/HAlvlxPFNa5YDXqDl01FYzE=;
 b=VpPL6O+2aYbNsoH5uo3dbovglYyFgDiXlvb2doCvrT9YI2Pxe7VLR95wqqhU952LxF5KTEX+QaZB66thYmDAE6GvVOaY6tb8YWB7bl0sMHODfbqOMg1bRPjrO01wVHpcqTPUYyjHKZbYXhVGjyjrbfrEKjnz5MdoU/3j98cwhSJvgSY+VrZJhl9cKhcM6fQ0rra3dfsAt2qyP8PkUGtBasunj5p5UdKYR3cX/KZCo2+X8Hb64uJxQUo8Y2VIEk91KZGunQg0K1JGyVY9zZcxqYSVz9etVkca21Cf5NSeEKawmyGDHj0oFjyvtLIQ9wHsJ1nD87iforEz8uaScjH++Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA1PR11MB6848.namprd11.prod.outlook.com (2603:10b6:806:29c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Thu, 14 May
 2026 20:23:30 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%8]) with mapi id 15.20.9891.021; Thu, 14 May 2026
 20:23:29 +0000
Date: Thu, 14 May 2026 13:23:26 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <iweiny@kernel.org>, "Aboorva
 Devarajan" <aboorvad@linux.ibm.com>
CC: <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4] nvdimm/btt: Handle preemption in BTT lane acquisition
Message-ID: <agYvPlySfQn9Rq6M@aschofie-mobl2.lan>
References: <20260514201757.86486-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260514201757.86486-1-alison.schofield@intel.com>
X-ClientProxiedBy: SJ0PR03CA0115.namprd03.prod.outlook.com
 (2603:10b6:a03:333::30) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA1PR11MB6848:EE_
X-MS-Office365-Filtering-Correlation-Id: 5067bb9b-dd17-4011-0192-08deb1f6a952
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|56012099003|18002099003|22082099003|11063799003;
X-Microsoft-Antispam-Message-Info: o24bPX91A4GAvpoO30e7aEGbjwJetTsFIEKASAb4XAAahN71rPlh4HwtvvbDj1obsRm96UKkdvnQMt/ytUxsq/9nd54VYRFbnQtnksbyHnSMYvxxo6RCxLaTmi5NvXMpPlQpy0sAp0GhBEJKjECHC78gIqZtors9T9DPQRkF3roMSYhtrHqGNFjDbTBpG1c00U7NZzZzSjtYo26DZv8cPWax7h+O/Sor95n4vfnkuViWfNm6d/9MmtxsxqfJcsDjBlF6Zc4O5Zv915/QfzIFcQiWSU9GoMa5psBKHKoWvKvbh8yZavIbE5ahy1WvKxVUIU5uwNpuOXkXLwrj4df9L+f3c/HD67dWoBD6SitrSENQhC+5+UX4uLSNL9iqVc+rxjx1MgxB1Q5trdu6qSW5jJU8hLqWgZ90yAC76fboo2DyhiSkiITJyYZstRqfXzra5KJWI2PZsE4BxqSv2FggUlwMdeT8fjW2Fk/toecjzAinmW8tY7seNwEJ3aQFZuxcJrQ6DEmCjy+mfvAS9E9UYMBxVzZE8eYlzSkeuCZERn0F5b163I2r8bpbZfpfWszpoUTeVpOXTlTNSa7sUBsSghDsg9are0trYEct9kRNGqFYw/M0WPBaSQraZP/+ak5Co83ONUalbxFxd+i8LpDdgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(56012099003)(18002099003)(22082099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KPLLQuyPasxCDPE12GLaMILIpRjUZqJ8TKxiwfkE2QR1bH8XjOF1VX37RpLd?=
 =?us-ascii?Q?V7hwlJtvOwzHN9B9WgT5bKXWACrl0bcdzxOkstefXalFcgBg05PKd/wMrPav?=
 =?us-ascii?Q?hwil2DMwEImtQ4aVKlyaExaZYNIDc+jshyI8jJtZQhSpx7RxDIn002U4DTRq?=
 =?us-ascii?Q?LY4hnaYLxeyBcMI5XtqIBjlX66QdD2JT4XI+5CG2nm2DR5ugrs3NuYKQ2gIS?=
 =?us-ascii?Q?OKSeagwQpLmmQJm5vUf4QwsR+uNVmS8i0WQM3Ifd7kY7PXpitzBc9bzb6n61?=
 =?us-ascii?Q?ukVNRxlq7+WmBrE7uXDdkTFWtdrcG7opSrArsjmuZN3Yc942ck+f1EmQ12SE?=
 =?us-ascii?Q?3q0HyIcP2+2iRmE82KKwbVLKhDaRRxBccHR1LWE5ut2zSfjiYM8MieL8WYmf?=
 =?us-ascii?Q?tw79h9fKR24n0I82ODEyijl7lUW4n47Px7CkWBmAEDyyUTLlAfHzVb7Gmffy?=
 =?us-ascii?Q?gBsmROV8l78mmygCschdPLbTb+J2bwLwKv98bTkMpgXecfjMqP35uFx1Z9w5?=
 =?us-ascii?Q?st36Eb2bAJ/xrq1NgQJ/8b6qpAnuNa6f5xcFbK36GSgrRWyFUdvrzf3cvn8p?=
 =?us-ascii?Q?4NAbaPEIT7CSE9XSikMQuCSP6kYVR0YzomLgLUfiIQWPkeX6pkx5wMYtYU3c?=
 =?us-ascii?Q?Ren13JZZR+fu7ECNP9PouLSO/e3WwraTu72Jw2PWM9KGrFuyIP9ExdYvgqqt?=
 =?us-ascii?Q?/pjwYZqSyeE72r1PBIJAEGs82ab0fVMW144ZSTZmwrEDyWVE/8on/x1jMWUv?=
 =?us-ascii?Q?wiHK9ohlHbZ/fxQOI+tov63ZPfThEVZY5k/s/ZRCrd/m0xn/8Iw/+pTuwN7C?=
 =?us-ascii?Q?8AjPJjUjuFeWCl53O4vQ/5yWp8XpPHbia2RCrI2paQnTcy50Ob3Q5swHcbpA?=
 =?us-ascii?Q?xGPkyW4kerVHn1U/kuQXWqE4MdKFIPNcz0NQBfwXYwUIQsKsgUJsUUpZEAGb?=
 =?us-ascii?Q?w62lwTd/MO+vwbxCkKHdowAmCGSKYLM0Uy5WTHP1nPtyYjzQ9CTWZyagpyrG?=
 =?us-ascii?Q?wz0+gKhVYL4etBOzdHjc5Pwm/CnfFbtYmK2cZcNubf7Zay0+1N++zUwezhrp?=
 =?us-ascii?Q?yphEGLEzGHGmmrjsefs4GU47u1bs2xkyfCw/xO18ffXVjDZSFls/5QMoWs4V?=
 =?us-ascii?Q?4OsActTnXANls0frPb7DOgekmlCddmEeDOuPxaIpDKD7ITf5qTi6ElBourVA?=
 =?us-ascii?Q?IIB1+k3NYdEVnMHwGuW4SdhLOAUBYzoyT49wcMYgOor6ro4iMn40YwxGhf2R?=
 =?us-ascii?Q?IMB4aUDH+NYz2B4haYRWntwsgaoo6wOZg7lJkZCHX6Qs5HpP42RD6XLnuSSV?=
 =?us-ascii?Q?zxwztD4G7CN7Zrb9mrdgw+JQ4ccrg3blYj1CTtsjGcuQSwkWOUvzsC575TkO?=
 =?us-ascii?Q?aDlfxnrxL2QZy9YK4Wri3iAl+8VKZPcF61MJ6pojlg8ymc9yR1MyIfsCvtTQ?=
 =?us-ascii?Q?dHWTYfaXFN7yxJ9aSCKkkpRoiSKr7vFku0fd4oPmSbfKQ1KBTeHkvNwfDKXi?=
 =?us-ascii?Q?2Z4+09nqZvNbrFLseF95hiV/vz2xFF7Z2uffdPiLbXpjdb1FAvMN9xg9Zuer?=
 =?us-ascii?Q?Hgk2dWiZgh5znrjneWjNvmGZeEQO300bMkmlJRg+QYAjA4D/LTWtzaDEgbRg?=
 =?us-ascii?Q?BJLMKqhEz1dF63UQSGwt3fGlxM8fWfOHA835CcUYQfKO8DkySJJxb35xpUT8?=
 =?us-ascii?Q?YmnCg7e/rTRsRPUm24eIzGGI2V2tJ7OLmaMXNxMrXVDYRuRGzGgbl3QkSnKM?=
 =?us-ascii?Q?egPcsaSQn4cs1aaz6OXJEerkSYNOmM4=3D?=
X-Exchange-RoutingPolicyChecked: Uw4UNAgcCQxcMWgUXhpbKlmc0NPwyLNhvhCUbHQHxpiSUHni4Mm0JOFpqGBysM1VOMNh1bhD6zBNcL1E9cTojqpHow/R3Rpa1R1flAG+VKkQSPLCgrxOoII4pDphzWSDnF3Aj7W5ZJ0cLaFZqmHlEBJPSt4yxxhLLKlt4rgTPCFc8DLUdC6AgBI/vo5W9bHWggje9xdPtMp4DhdThwFWfX0+WarsakLXL7XVNJzPOdQxPKj9bVHJ6g1ndOUQ8Ettvs9/Cu3lfalWpPGaiykNhY3IxertBNBPB2wwMrHasflozyGH3qwVW4nAijdt1khamy3l/ItHcgL2Zkl9SLHDaA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5067bb9b-dd17-4011-0192-08deb1f6a952
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 20:23:29.5558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QNYCCAHR4wyHFMlVv0rD78DAwPclHkIBsnSnAcnfdHKszpfSQGUdlX5qgCArvTrhwK2+B25kC92Y8BrO5egbRcNtscF9vtTpYlKGhxl6wiA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6848
X-OriginatorOrg: intel.com

On Thu, May 14, 2026 at 01:17:54PM -0700, Alison Schofield wrote:

Sorry to folks that got cut from the To: list.
Here you go.


> BTT lanes serialize access to per-lane metadata and workspace state
> during BTT I/O. The btt-check unit test reports data mismatches during
> BTT writes due to a race in lane acquisition that can lead to silent
> data corruption.
> 
> The existing lane model uses a spinlock together with a per-CPU
> recursion count. That recursion model stopped being valid after BTT
> lanes became preemptible: another task can run on the same CPU,
> observe a non-zero recursion count, bypass locking, and use the same
> lane concurrently.
> 
> BTT lanes are also held across metadata and data updates that can
> reach nvdimm_flush(). Some provider flush callbacks can sleep, making
> a spinlock the wrong primitive for the lane lifetime. That issue
> predates this fix, but becomes more visible now that BTT lanes are
> preemptible.
> 
> Replace the spinlock-based recursion model with a dynamically
> allocated per-lane mutex array and take the lane lock unconditionally.
> 
> Add might_sleep() to catch any future atomic-context caller.
> 
> Found with the ndctl unit test btt-check.sh.
> 
> Fixes: 36c75ce3bd29 ("nd_btt: Make BTT lanes preemptible")
> Assisted-by: Claude Sonnet 4.5
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
> 
> 
> Changes in v4:
> - Replace per-CPU lane storage w dynamically allocated mutex array (Sashiko)
> - Remove the recursion fast path and take the lane lock unconditionally
> - Update commit log
> 
> Changes in v3:
> Replace spinlock with a per-lane mutex (Arboorva)
> 
> Changes in v2:
> Use spin_(un)lock_bh() (Sashiko AI)
> Update commit log per softirq re-enty and spinlock change
> 
> A new unit test to stress this is under review here:
> https://lore.kernel.org/nvdimm/20260424233633.3762217-1-alison.schofield@intel.com/
> 
> 
>  drivers/nvdimm/nd.h          |  5 ++-
>  drivers/nvdimm/region_devs.c | 62 +++++++++++-------------------------
>  2 files changed, 20 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index b199eea3260e..69f329075527 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -366,8 +366,7 @@ unsigned sizeof_namespace_label(struct nvdimm_drvdata *ndd);
>  			res; res = next, next = next ? next->sibling : NULL)
>  
>  struct nd_percpu_lane {
> -	int count;
> -	spinlock_t lock;
> +	struct mutex lock; /* serialize lane access */
>  };
>  
>  enum nd_label_flags {
> @@ -420,7 +419,7 @@ struct nd_region {
>  	struct kernfs_node *bb_state;
>  	struct badblocks bb;
>  	struct nd_interleave_set *nd_set;
> -	struct nd_percpu_lane __percpu *lane;
> +	struct nd_percpu_lane *lane;
>  	int (*flush)(struct nd_region *nd_region, struct bio *bio);
>  	struct nd_mapping mapping[] __counted_by(ndr_mappings);
>  };
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index e35c2e18518f..bc5e402bbd9a 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -192,7 +192,7 @@ static void nd_region_release(struct device *dev)
>  
>  		put_device(&nvdimm->dev);
>  	}
> -	free_percpu(nd_region->lane);
> +	kfree(nd_region->lane);
>  	if (!test_bit(ND_REGION_CXL, &nd_region->flags))
>  		memregion_free(nd_region->id);
>  	kfree(nd_region);
> @@ -904,52 +904,28 @@ void nd_region_advance_seeds(struct nd_region *nd_region, struct device *dev)
>   * nd_region_acquire_lane - allocate and lock a lane
>   * @nd_region: region id and number of lanes possible
>   *
> - * A lane correlates to a BLK-data-window and/or a log slot in the BTT.
> - * We optimize for the common case where there are 256 lanes, one
> - * per-cpu.  For larger systems we need to lock to share lanes.  For now
> - * this implementation assumes the cost of maintaining an allocator for
> - * free lanes is on the order of the lock hold time, so it implements a
> - * static lane = cpu % num_lanes mapping.
> + * A lane correlates to a log slot in the BTT. Lanes are shared across
> + * CPUs using a static lane = cpu % num_lanes mapping, with a per-lane
> + * mutex to serialize access.
>   *
> - * In the case of a BTT instance on top of a BLK namespace a lane may be
> - * acquired recursively.  We lock on the first instance.
> - *
> - * In the case of a BTT instance on top of PMEM, we only acquire a lane
> - * for the BTT metadata updates.
> + * Callers must be in sleepable context. The only in-tree caller is
> + * BTT's ->submit_bio handler (btt_read_pg / btt_write_pg).
>   */
>  unsigned int nd_region_acquire_lane(struct nd_region *nd_region)
>  {
> -	unsigned int cpu, lane;
> +	unsigned int lane;
>  
> -	migrate_disable();
> -	cpu = smp_processor_id();
> -	if (nd_region->num_lanes < nr_cpu_ids) {
> -		struct nd_percpu_lane *ndl_lock, *ndl_count;
> -
> -		lane = cpu % nd_region->num_lanes;
> -		ndl_count = per_cpu_ptr(nd_region->lane, cpu);
> -		ndl_lock = per_cpu_ptr(nd_region->lane, lane);
> -		if (ndl_count->count++ == 0)
> -			spin_lock(&ndl_lock->lock);
> -	} else
> -		lane = cpu;
> +	might_sleep();
>  
> +	lane = raw_smp_processor_id() % nd_region->num_lanes;
> +	mutex_lock(&nd_region->lane[lane].lock);
>  	return lane;
>  }
>  EXPORT_SYMBOL(nd_region_acquire_lane);
>  
>  void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane)
>  {
> -	if (nd_region->num_lanes < nr_cpu_ids) {
> -		unsigned int cpu = smp_processor_id();
> -		struct nd_percpu_lane *ndl_lock, *ndl_count;
> -
> -		ndl_count = per_cpu_ptr(nd_region->lane, cpu);
> -		ndl_lock = per_cpu_ptr(nd_region->lane, lane);
> -		if (--ndl_count->count == 0)
> -			spin_unlock(&ndl_lock->lock);
> -	}
> -	migrate_enable();
> +	mutex_unlock(&nd_region->lane[lane].lock);
>  }
>  EXPORT_SYMBOL(nd_region_release_lane);
>  
> @@ -1019,17 +995,16 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
>  			goto err_id;
>  	}
>  
> -	nd_region->lane = alloc_percpu(struct nd_percpu_lane);
> +	nd_region->num_lanes = ndr_desc->num_lanes;
> +	if (!nd_region->num_lanes)
> +		goto err_percpu;
> +	nd_region->lane = kcalloc(nd_region->num_lanes,
> +				  sizeof(*nd_region->lane), GFP_KERNEL);
>  	if (!nd_region->lane)
>  		goto err_percpu;
>  
> -        for (i = 0; i < nr_cpu_ids; i++) {
> -		struct nd_percpu_lane *ndl;
> -
> -		ndl = per_cpu_ptr(nd_region->lane, i);
> -		spin_lock_init(&ndl->lock);
> -		ndl->count = 0;
> -	}
> +	for (i = 0; i < nd_region->num_lanes; i++)
> +		mutex_init(&nd_region->lane[i].lock);
>  
>  	for (i = 0; i < ndr_desc->num_mappings; i++) {
>  		struct nd_mapping_desc *mapping = &ndr_desc->mapping[i];
> @@ -1046,7 +1021,6 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
>  	}
>  	nd_region->provider_data = ndr_desc->provider_data;
>  	nd_region->nd_set = ndr_desc->nd_set;
> -	nd_region->num_lanes = ndr_desc->num_lanes;
>  	nd_region->flags = ndr_desc->flags;
>  	nd_region->ro = ro;
>  	nd_region->numa_node = ndr_desc->numa_node;
> 
> base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
> -- 
> 2.37.3
> 
