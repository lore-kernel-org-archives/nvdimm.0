Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EB2413D63
	for <nvdimm@lists.linux.dev>; Fri, 15 May 2026 20:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778876142; cv=fail; b=NCU/UPXDQioyBnmMHTJoGlWHIw5cvXDLs5Xm3EZzalkceL9YNV6jk4RXGogiVMDUuY5jSQkiCJ84IfmKNmnnFmaq1NGrWpYDBEFbgaYTrB/VJdbVMs5cXOkBo3sauAQc2qHK1TSEcyO0xURqxAEtnYb+smBX1IpJxczPKUfd6Gk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778876142; c=relaxed/simple;
	bh=szAS+Hj435PFOgDPnnaBQvpCIgAZEIICkiJzwLISUXE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sfhqtygJo9Fck5y3ty2JkuuP8cjC8azklBwrerUNXyTO4dVKabg88C46Z6AG+Qs3ebOU819UY+ByIUwyifuh98WSdOV7LuRaCTWe7zjjVihM2UwrTF/PtbIGLAonHGe5akqgl/MRYY9oJc2sufazo5GUfnsETiLGoB4/IZR+u8U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U8TqV1nq; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U8TqV1nq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778876140; x=1810412140;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=szAS+Hj435PFOgDPnnaBQvpCIgAZEIICkiJzwLISUXE=;
  b=U8TqV1nqUnRB+D7H8MLCvFBZt8A5I1DvJxbx4y9D3g7hiHc9E5qf+LzQ
   0KaS5STiukuEi5iZqF0Uu2wWriG3nAUKgF1Oj0Rfi5N7wzpU/c37IsUNK
   7it4ewP4NO4FMAV6H5B32swtnzZ2LbCYdV4XIMEDGDJTMCDhiLao8PAos
   /l2V7RlAwesDI7ohF8UNkHLX/3PnIRay4xPsXpuzCmSZmEGRS5Yix+ieT
   CrAZ0A0ZIRfsArMJOSf3wcLgYYZ7x35hY+ITGRlGoFve46HUx5iv2NHIX
   0tBA4PaD1qYxDuptMw28YsEUac+Z0+n5sOq3X2iOL/3t+Yw6YBD+rBcB/
   Q==;
X-CSE-ConnectionGUID: DPNUtl39Q1Ot+XATdgV5qg==
X-CSE-MsgGUID: Nvu7+/8aSpCetxBWB947Dw==
X-IronPort-AV: E=McAfee;i="6800,10657,11787"; a="80007875"
X-IronPort-AV: E=Sophos;i="6.23,236,1770624000"; 
   d="scan'208";a="80007875"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2026 13:15:40 -0700
X-CSE-ConnectionGUID: fGnzeZS5Ra6JgPY9btXcBQ==
X-CSE-MsgGUID: 8gEL2hCMQz61KzUyUhG1qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,236,1770624000"; 
   d="scan'208";a="243120643"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2026 13:15:40 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 15 May 2026 13:15:39 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 15 May 2026 13:15:39 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.18) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 15 May 2026 13:15:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bWiTRP5wQhstDSBvTAgFM1lfyWM1b13XS4hLg0rj9woqZw1DK8hVvoVytTYzBzGVE+5RhgI4b6KWB3kUcXzv658vsKB0/S5tYnClIq/y482F/s90WXa3QuQB91XaUwm+XkeB7iPaVZxUtyTzPfAXgNFPvOWmp/9iWfc+TeoQKgVru8c4u0k+GtH+Q1ru/4OfyAXc+umMf81AOl055bIk1AhZ4gPHneeiN+VEU7gsTCoGKZGHTh7960h1mn+GFZbPrkCTbGWVCjw7hl3T8d+esZgQAfTA/1fBUfR82gRZJKWCJ2E/QR0IOSD9/M0ezDxynkU9ckr1fZjN1KHbkSpNPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bq66BLXs5XyqTc32jZdE790jVDEZhF03459ffK7XOS4=;
 b=lslReqMSA6WVz5hDEs/z+RfnzJHVfVNph7hzzhcmAF1FLMM9Rqpc41uo8W9Gy9dmhnvkmAFR7Q/WqJvhm+sofu9+H8ntjurvkLE7069ePKzjntg/7exqyW29mquZSI0seN2AO5cqyi6bVET6+diLUXFEgLXZfYTAq6Cf+BgdoTnSRW0VBcK5GTpvFeYAiGNmZsw/lkvtvqNZ+LGYQS7MJgM3cJ7x9udpeDX7Vgabg1cNKtu3M17YIJfpysogkvZwnV9IXU6NZCgy7Q7DEq5aboKNGhSfa5oXNLj9G/u/1Idc3zd4wpQHEYVlPtCkPTSf9DFXfV7z2wLQu9SK7J/YhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SJ1PR11MB6107.namprd11.prod.outlook.com (2603:10b6:a03:48a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.12; Fri, 15 May
 2026 20:15:36 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%8]) with mapi id 15.20.9891.021; Fri, 15 May 2026
 20:15:36 +0000
Date: Fri, 15 May 2026 13:15:28 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <iweiny@kernel.org>, "Aboorva
 Devarajan" <aboorvad@linux.ibm.com>
CC: <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v5] nvdimm/btt: Handle preemption in BTT lane acquisition
Message-ID: <agd-4JQ9SLZi2zVo@aschofie-mobl2.lan>
References: <20260515014729.107329-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260515014729.107329-1-alison.schofield@intel.com>
X-ClientProxiedBy: SJ0PR13CA0042.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::17) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SJ1PR11MB6107:EE_
X-MS-Office365-Filtering-Correlation-Id: a111704c-4d97-4258-d09d-08deb2beb971
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|11063799003|56012099003;
X-Microsoft-Antispam-Message-Info: ZHcdXgzHWfaJVLFfSr0pE4DicwiwsnLZjuM1t0Ac3KYWm/Tl+l9ldrFq/0xDkqggXVjcoXBiML6FD/+MfrRSBWqoXc5Fbuv+gk1QZTDMLTJWIyvg8Q4Op3jlGKXu8cVaQkpi0F7L6LEDr4+yij4T1MKYBtYA1yGKmGpeTYW9O8TALS/qI+pEidrVPykf2uuiPM6N2B2KVpbSy85Oc7LMhzutDpT1JcpBXzcsDPA4F8g/koSm2piovAqLc2ccDDtVwdTsuI1BnilZeApU6SUmErRARdPfFqGNJSYUH/kT+BN8J2LLadWQ1jN2vot1fSTLEc/ZQTBdJqtpnZt/GjGFmk5FKrQJdeFPOV+a6EknfRHf/4FvXgIxnkylA/yydph/Mef5nTklNlw48rCWueuM118btuhjwDYHTGm4xNlOnMzKlwJ06m5dsS30sDX0RZd7XuhJ0MfwG0m7sqw8Ohga3RzqK38AQO2wKqOiigOTwdbbuHVdhG7a/sXhQXGmg7EaL2Thg7EBvtnL48PzHSQA5AWarV2MMC2zNuK01BM8uqyEUYy7+zt1KDDzjPy0LwmgTy909Oo5P450VNxQ6fRwca+Bpd9W7W9q239IvLuXZHhnRAtNKAAYNj/MOq01NzgW47u447i2zV8g0CFLxAexDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(22082099003)(11063799003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cE5TVrOp66OlZtCjNTsT12LvRtCU9iKpyz+2dU+e0NbMy5fTQmwkQVNj3JBf?=
 =?us-ascii?Q?+jUXFROlvIb0w6rqdgftojdlrYzAZ37wkcyGiS/M7R9aO/5EhhPk73YBVgq2?=
 =?us-ascii?Q?kjJOFNCdv1X0YfzOIg3Y+t5Ht/tbb8fxIbrfEAc5szAcfE/Az33drh/DWPFy?=
 =?us-ascii?Q?8pPg/Cg+iyasyetnvt8JwAtmttluVRqYlGI3qwe3zvKrMqfKnQZk4XkdiiqE?=
 =?us-ascii?Q?zmI20j/GtUdikiKKH+eblI4CAJEWNPGFV52Z888GlIIVN66APzmxA6NFT2GB?=
 =?us-ascii?Q?ELMHLkKLQ3xcMW1l7qwNb20HmOGVQQrbQX2vPIM+txU5LlIkRWU9vyhmuLZ8?=
 =?us-ascii?Q?xALqpCFdrPLBg47ZixxEzX/iT+2i0Feidh7pkiwUrScqdErcosi6HrDARka3?=
 =?us-ascii?Q?t1fAGbbAYrv7jFSyn07Ap0BMyMJNoGxo8cPrvXwgXaIxno8X5qFIyFsdj2nw?=
 =?us-ascii?Q?nlVSXITEY8RQqRok61oLNpVz1L5xVTtozvQPxtqqKi7RmythvXnTA9YscMTC?=
 =?us-ascii?Q?Gw5rPWxc3cSP+DWu/GQuKMOZrbGaCJ9k46fC7fwXVg1L0DqJq6h0JkmJDdip?=
 =?us-ascii?Q?TXA/XhF1mM8p9OMFPKQQqxKIVdJ6ltdQqRY4Mhq/4N8w5ABH/MfPmb/fWLdn?=
 =?us-ascii?Q?4hbSIwAtGlTtdA05V2neF6FX0eCnDk+UknjUg1sSSUZMUtQHjgTa10fzdy8e?=
 =?us-ascii?Q?I9GPvbaOHLOQZTLF5FmETD/OEbbvARZltPt40QINZnSzR4mpgplH1yhw1eU5?=
 =?us-ascii?Q?UN34AwC4NKWtceDLUM5GLVGxdErnxVaWOYrmn+Noh1aXoahMqCsRia9/5gof?=
 =?us-ascii?Q?WxbyjHe2IIulSdI+T9toJlHdo5yoaEK/5vKOTrPeGMyULYwFLCjYYQpxAXsH?=
 =?us-ascii?Q?UOT7RUa3aRZ7ADQ8z/Tnv9CHPH+vS7OJTulmemVYzUjwNNhKS4MKxOELn2Ru?=
 =?us-ascii?Q?Xer4h9doX7p0rPUUS/YlYPg01dFluJTQapY8XqPNECBM4RAw8oJ8Ak3wlQcF?=
 =?us-ascii?Q?gDilAuDGqcQU5UMB1vl8/sluwqBIqUfeNBBR9MqJzrx690Ub3IIajq8lSg9J?=
 =?us-ascii?Q?yYwkljcAtFTqLc/q+nE7RE/p5MsYgLWv5nX4VTWvcEgay4bR4T3YsrEipu6I?=
 =?us-ascii?Q?ZodivLYYjtYdFHsaopVD6wIxWJUZuckUif9Il4w+N1AuwcFChWVOY3616GQ1?=
 =?us-ascii?Q?JpQGEM2V28RZ3nNL4sGzjjSHHCuXz8LuOQ428nSsiY66pOAl61ZE9ZHxad+O?=
 =?us-ascii?Q?MUUnqh+FUC9nRfjrIgkkaisRKlnSnLgIqRnye6+g0a+MOau3C0F91i+bJmKU?=
 =?us-ascii?Q?8u8j55OEQHN22viq+NqTWJcLdo3S56sM7a6bwUShK64T4liiVD/ZsekN7e6n?=
 =?us-ascii?Q?jGwbRWPxLAR74QRrbpp1gBfIalCexhjBUIn8ejUEBS94FCIP6RBbxeL5zoOD?=
 =?us-ascii?Q?UHQqAyEQ3wF0lXuzdamJLuQqZEaHLgiiRxziBl73SzeaiVhSn5ywiAuZcAzT?=
 =?us-ascii?Q?Yu8iqRL5BAbGscx5ySKOmTi8XBC1ree1TuCXIBgoMj32O2pS4yi6fhNvkhsb?=
 =?us-ascii?Q?WXazSollZbnCdNnf6naUA0ozwrXi8rY1AkV0Ju65UBg20p/s0X/eWXTAuRKW?=
 =?us-ascii?Q?8iu9sfL6B6Lj6qNEDlZ4DRX8h+1QafTGIy703R4W2kckfzHEgaBIDiFrhDXl?=
 =?us-ascii?Q?lgipZQlW5RVazHYDlyIaHbY1oc6O1UPCver0J+2bje/h1VNIWBsBaUROhAF8?=
 =?us-ascii?Q?+YC+9MjtD1uvurZfMZJNRopRMfHa6hQ=3D?=
X-Exchange-RoutingPolicyChecked: a4/KmLZS19ilYVtvLHgFNcAx4BAdJ5K+UiJVfq8StLqj07aGsmqAI2tbsTOlKI/qpgkFqaP5hqBi26V313JNZR8oMJLxiq08EYxKN96I/Q/zoVRhkQJqszi0UCYPW9tH0iU3Jgitv/Cajo+84oQT5e/wUJD64OLbBygdeeJ46tvlqQxNlbFXA3MgY3GblVRsPnynOYhGjWK8/vbNOzy8W/fBDN0DpIKrZJcRxk5+XAKdWjbrhs77eM0hEjRLkcQXiKCxpTyamOSG+iQ7NoBy6fhCMKqcK+iJ2xb7l0abUCR+shWJxVEwWzcz1SAVM6uimbvG2Eg7MUnsSwsY9B/fnA==
X-MS-Exchange-CrossTenant-Network-Message-Id: a111704c-4d97-4258-d09d-08deb2beb971
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 20:15:36.0138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8niYcsp9xO+ZpOYdpwNhPrj16ONZxBpCNJojEjHL0lUk6tqysvG/sG0Ii5bG7+4FoEpperE3rWjCLmirSmCx7Gp1pw/to7F/nvHm75pmCw8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6107
X-OriginatorOrg: intel.com

On Thu, May 14, 2026 at 06:47:26PM -0700, Alison Schofield wrote:

Sashiko AI had a 3 new things to point out with this v5. I'll address
them inline below and expect to only make changes for one of them,
destroying the mutex lock array.

I'm going to wait on some human feedback before creating a v6.
Thanks to my humans so far - AboorvaD and DaveJ.

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
> BTT lanes are also held across arena_write_bytes() calls. That path
> reaches nsio_rw_bytes(), which flushes writes with nvdimm_flush().
> Some provider flush callbacks can sleep, making a spinlock the wrong
> primitive for the lane lifetime.
> 
> Replace the spinlock-based recursion model with a dynamically
> allocated per-lane mutex array and take the lane lock
> unconditionally.
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
> Changes in v5:
> - Align lane mutex entries to cachelines in SMP builds (Sashiko AI)
> - Add sparse lock annotations for lane mutexes (DaveJ)
> - s/spinlock/mutexes in the driver-api doc btt.rst
> 
> Changes in v4:
> - Replace per-CPU lane storage w dynamically allocated mutex array (Sashiko AI)
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

snip


> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index e35c2e18518f..9f5a34181cf5 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -192,7 +192,7 @@ static void nd_region_release(struct device *dev)
>  
>  		put_device(&nvdimm->dev);
>  	}
> -	free_percpu(nd_region->lane);
> +	kfree(nd_region->lane);


1) Sashiko pointed out that since this is now a dynamically alloc'd mutex
array, it is bad hygiene to skip the mutex destroy.
Will fix up in next rev.


snip

>   */
>  unsigned int nd_region_acquire_lane(struct nd_region *nd_region)
> +	__acquires(&nd_region->lane[lane].lock)
>  {
> -	unsigned int cpu, lane;
> +	unsigned int lane;
>  

2) Sashiko suspected the syntax above could cause an undefined
indentifier error when building w sparse.
Not an issue. Sparse does not warn on the annotations as written.


3) And, Sashiko's 3rd point was asking "Since the lane lock is now a
mutex and can sleep, does this allow us to fix the lock drop race
in btt_write_pg()?"

It may indeed be possible to close that window entirely. I view that
as a follow-on cleanup, not part of this conversion. Closing the window
in btt_write_pg() changes BTT write sequencing around freelist recovery.
That needs it's own review and test coverage.
So - no plan to add here.

> 
