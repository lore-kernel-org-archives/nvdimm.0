Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63828364E84
	for <nvdimm@lists.linux.dev>; Thu, 27 Aug 2026 22:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787871101; cv=fail; b=jGnyfrIZE+HFu3quqHz7V5dL4ILLSjrr4D3UftmkAWwHn3hkMyT+1KvofdpaUWERSIPgLdQLN8lJkeiS6JRhcYZ7MriNOOw2+D22kJ5kLvYj+irwLqLj0Mdg2QtLfJZSgwwSvUJJQLBnC4zIqS3l3asTY3gmZAAHM1rx5l2jKRw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787871101; c=relaxed/simple;
	bh=hPpLOVW9ISWY0RrJDohw7q83eqyqc7YRIbn2CCTlpks=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=A8EDkm5pwEsAdSvbVCSFCEepnGL4ZhtI1Lq+sE5L4LHz0rxzhOMc6mylwClwrk6QVv64m1pBzuc7ebrDtzQGEX18Hi8t7x5Gxceji+QNt2IuZK0IQOwLz/bm25EVNgfdHgqs5bxLff62+IyyAsf6CaTbbgNVz+7v3ZRqd1Wobvc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MysbdYVv; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MysbdYVv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787871100; x=1819407100;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=hPpLOVW9ISWY0RrJDohw7q83eqyqc7YRIbn2CCTlpks=;
  b=MysbdYVvcei4QXbAvGkVSK8Yr9xipKKInjGkVbvOnT4G2EfKEKKLfUxU
   naZcL0CNWThc6aEv0/vZWO69BkK4VvZaYPWelXtC+KGHfXLpkmYba0s+N
   w8+7qFCtLr9zqF3FZV1KtssVElp6xx7Dcbs1VnOLzG18q7gWb7gVlVkn1
   vaofi2G9NwClUYh71bHQ/MPO+kLPbxgXNN99zWhZKd6g2Zxil6KHcx71A
   RE6DDwjS+LjoMaHyuE30nRR12hCLat7zkA6B9tPCeB5oIOGajH10OiO5f
   fRDP9Y2xBnaYFVbIr5cf9WUkgL2fPmRivuB7Dp6K0JtQkYwltiNpQv/J8
   A==;
X-CSE-ConnectionGUID: AmtUwGjLTSeSai35MBQ/Hw==
X-CSE-MsgGUID: f6kBVzsNRxegGbkTbv9UGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11888"; a="88434090"
X-IronPort-AV: E=Sophos;i="6.25,247,1779174000"; 
   d="scan'208";a="88434090"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 15:51:40 -0700
X-CSE-ConnectionGUID: ClDuPa/DTRupVEmmSx/X2g==
X-CSE-MsgGUID: mRUyM7XlTPGwrLYTZNrmpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,247,1779174000"; 
   d="scan'208";a="292814161"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 15:51:39 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 27 Aug 2026 15:51:39 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 27 Aug 2026 15:51:39 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.71)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 27 Aug 2026 15:51:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VlJAtGvd5rh6K6LIYg/Xoj2g3P44RjNZ8ksX/JgyJiu3Kp6U395UnnWKDihKDAuJe6ERVTlsJ6MKAVmfgbFO0uMQ/xaRsb0Vg4ZlIazckEUw+1radSiSluiBUQhsULv+vaNQutlaSKNJS0InfiMxDx/TQIgAAvD0VRBtL6/YSMOD7kAMPdRfkLB+SCkHa9CFI2WcnBCSSzRdiHt3XPp4QLxcPvDbrKKb2g/eVYbxG8Z6xI5edKosJstCBX15pi1hrYA8RBBcW+2OOVUJ4H05a5P75Yd7kl6VBBlDOk3b9jzj5fDQ7O61XtYzjg66Ea1B6MtuWQf3utBJw1n407j+Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZOHiMql4DBwEO3Tdb6ivkAs6BWlvy+Pv+hWJdc/g5pM=;
 b=vlUqTvf3M+tpSMthE9aei3Oni09kXXYPcYwdei7hfuyfPOVcAgXowdAZWriqop/Q339Wl5tkyNuEG/To9E1JV9w37HDVopAfsIOen5l0HpSQJkzBcISGgIXbMjb0P7AaII282t+ASGSuHYlBuhlPEjFrtKycXuxGBYlQbamQLOrwkeva7HuX3DYbeK/Oh/g/Is+T69wiGfdjiJWY5nHaysO8qrdEuyWJ6KL7iN84UdVTD2oEfUVZksU2Xd3Jhg805xIIl3rtUk6Z17kr89CuzK6r9shYL/SyvsaJ81SZ1676Y1jjIUAYa/MGFzUDLwpnKI3LGL04JVqX3+nii0umEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SN7PR11MB7603.namprd11.prod.outlook.com (2603:10b6:806:32b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Thu, 27 Aug
 2026 22:51:36 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53%6]) with mapi id 15.21.0360.008; Thu, 27 Aug 2026
 22:51:36 +0000
Date: Thu, 27 Aug 2026 15:51:29 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Hemanth Selam <hemanth.selam@gmail.com>
CC: <djbw@kernel.org>, <vishal.l.verma@intel.com>, <dave.jiang@intel.com>,
	<iweiny@kernel.org>, <nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nvdimm: pmem: fix gendisk leak when badblocks init fails
Message-ID: <apC_cdRF-Ycj4SbY@aschofie-mobl2.lan>
References: <20260824060113.2330468-1-hemanth.selam@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260824060113.2330468-1-hemanth.selam@gmail.com>
X-ClientProxiedBy: SJ0PR03CA0252.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::17) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SN7PR11MB7603:EE_
X-MS-Office365-Filtering-Correlation-Id: c2496a79-0e60-447a-fa2d-08df048dbf83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|6133799003|10067099003|56012099006|11063799006|5023799004|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: OEQSqC6qC8gi63dVYymKw4H1YVsH/DT/IIt9lL9wsXTZAeCMRw2NuhyZg6CnOT34HfT7yA5oL8paXkK1gRD0jcwrfMOPhsYIBIIfxCzazW6cYS+9ojMLpT9NCbS/UwTVA7YXHl679Q5/teHL7Sgb0z4kwO90bwFhU8L3NFMz/Ln9tTHYM8tXsZLNjOJPEvbt1TCXvDZFJJviBAD+FKeHQtudmH8IyPY6LakuwySJ2PLsveCfWsvvatXVUY4DD/e+3c1DLnOmGss1x5wJBZ3PGj+VjVxw12SSBsiABSYc7pXBktZinHWwnOxa3A36z9rPUY98LhZikSnmeCoZyTc6t0IlNSmYJTPMQQhQeUZTgJpqAa8vTGUQNIUliuK1CdDCaqATFsGPFIzQ46XC6CSdaaClMdBFr5sVm3rjWlsbe3gMVElSjmkbAYh4L6wBXmfKk6NYkFMhaAODEIGOdD0pZ3duqkymgwRGbr6Egn3bmg8PXOUWQeg1ib7eMb8aBECdKHIZmPSO0DMeBeK7gVEKqXsq5GhQi2GqTy5rbdbiOzBIRbGnKrmkleUhHp0+HJl0e77AQUQk7deCyJu5ZssdnbHaiu7TF5PUSZuHGDn4Ri0Lg/c/5EHinfmdCXZHuAlL6+yhbXfQdGVzT3dhd90v34Cso6jOSjQXiLjYRLvUybg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(6133799003)(10067099003)(56012099006)(11063799006)(5023799004)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yf+65VWnFxMqvtNnN4tXgc2zD2bGjjiv23v5U5mRTjBuNLx5iZJ3aIcQKb4L?=
 =?us-ascii?Q?MuM2rfF2ePIpnnjr9mISQQSFt59fUYx1y2n+zgme1vRNThMibOifwKHC8TKN?=
 =?us-ascii?Q?np00EEzejxjBrrX0CdPxDPJHKO+AYclif/dB1IyrNRqPx9DyPhBTHRZ3FFTn?=
 =?us-ascii?Q?Tk4qrqYpwJu23jcEwFJRh/cUXKuWjLHi2nV9n7EJ3ZlwOoWVX5R6M8eRlowx?=
 =?us-ascii?Q?YEiChGl/9h3KcBNbvRmo8kZmyFhrwHvAt1oBQWgEkLRABsdUFURmJJb5q1mt?=
 =?us-ascii?Q?Oox6Xm42/6sCB1z9TAOIo8kcs97zZ5sC9nAmDq50lK5+co3lvM5cv/SOvoLF?=
 =?us-ascii?Q?RVxjTrGTYG4ScuRnCQI9jLhP/nyAq9MpsoOqf6XKzhuoaqHRxLsoEK2ntNPG?=
 =?us-ascii?Q?PfC4prq58bN4aKWllxDLsgCVgVGniZCoABrKy19XbwgP2+TXKVi3oNQbqXHZ?=
 =?us-ascii?Q?zfa0ac2ed7rabZpaywuHA/M0RMyWLaNERlZbyldNt3of4CAqVqC3Hyw+B7bw?=
 =?us-ascii?Q?qXRcpLtCKuwjcKE1TtdiWSWpyC4an6rx2wMd/TincJ9X3W2VVwnXg3KWLucR?=
 =?us-ascii?Q?ncxpo28QR/ziH3YhlpfJQsYjWDgWZ6+94Dka++4VOoTAMDd6eQ9817iTzBgJ?=
 =?us-ascii?Q?lspO5FaZ4PIx25Arr2osM9fCUVeCKpZUl+4CB7+6bu4HnQrHWWcVcCfXMMVY?=
 =?us-ascii?Q?8uXIT8N2opDeWf92qTGRtXCk6T4seFVmguEGx/oUAfRNCmxl2kuLk/5o1K1g?=
 =?us-ascii?Q?N4FVKfxBT0hnjtW/bsvSue+jnxRliwYChH7P+fF3cZwfDOqlHELHk8995h2t?=
 =?us-ascii?Q?+vAkx35E6mACMg15OY11rX7uuSq4xQPwH3jHdVrhWLWBuMBQdOXlKtLrD//S?=
 =?us-ascii?Q?tWWPmJudGkQrtg1SzosVXfM8XYxGdHUDzJLuMGCgjRFTwlIfG16rF09oXc5I?=
 =?us-ascii?Q?fW+x1JJaIIFQ19sUy2a0qWLd8sXtIX/bb/In3ocsJ3SmsNj7svObIKUvbpSq?=
 =?us-ascii?Q?zVMBtN1eEO+Z4hk6iuJ1dMqVQtAhmFPNFN+LKGCYZ+CWyof2eEVhbPbc9Vsp?=
 =?us-ascii?Q?xVS62cDRhTyeBOoHNkrbVd+8N3xyIgaeOejt5KaGtpLNvw+b68tiPL5eUAEZ?=
 =?us-ascii?Q?/2fF0XbrZOuWhpaJrhRm0dAPP6+Mj+K3AxjEp4A42KYB93j4bR2KVjgJD65g?=
 =?us-ascii?Q?ExSTb2hEXWjiGGZN1hO7GsBTGcFMjVpF7YNR4+Kjf2T4FUkbrcdOv9/Xkm6L?=
 =?us-ascii?Q?s7XqfA6QZRWG5PJqDA9QLLjHwoLAWy6ubfmxRs7J2u70ZNAe7t7pHxWzUHVN?=
 =?us-ascii?Q?xw37CanHD6zKyUQEL5KXYRawX44c4oetafOvFEIgqe/Hvv2pRydMjXEH52ab?=
 =?us-ascii?Q?zhB2Uy1kc9OqQAbcfuhOLW/HxAezst/H4wpi1Ojf9KlnY1GGuk4s/x8TceKx?=
 =?us-ascii?Q?OR5IJcL4hZK4Dtj0QTANH2ejai+oTXSeYeeTSjuQiGjrp36L+MMnLbrD4CLL?=
 =?us-ascii?Q?AO4eZ/TrfwGBEB7+HSffuunzxLy/8UdxVqNvO2Saapdvs3utnuOSCsFbNw8B?=
 =?us-ascii?Q?ECLlwkQH6M8+76x13SvrXXADPvh95WpiTUg6dkYdhS9PskE+I+U+vytLBgbb?=
 =?us-ascii?Q?/zPH4GLhnDCDDxR4+oZRiP2rsx8a6UuZpVA4hTlTs4vRxEZixze4ULifpcre?=
 =?us-ascii?Q?qetHGrxCpnirJcoqW+mBobO00/bxAnFLi9mx3r1jp0knuaKiC9gAlb8VEmTq?=
 =?us-ascii?Q?5vg6odVYgSBuRFbK/cD3mmFpBAIFgIw=3D?=
X-Exchange-RoutingPolicyChecked: LIyqx8Ht0ioZp1qyYqb2SaU8QiURUaKg3Dog8V8euvhpIIrQSr5ICQtNGThc76Fr7R32Jz3DgwNr6PY/Xyw0YwpdLmL4DwFQB9njhbbEHx0NLI70sVvNTy0JfWZ7L095LkZNT41WbukOSx97HmhV0aivCx9Kf5ZN81xHvIyiG6p0icoR8HsShno8G+vwNhaBt9uA6N9zxs0H7K9RgXqsEeHwurkoWbW/zYN5nQzNL/CNjJYO40YMH4gACACk842hTIQbk8bFT+Ee3aH9KTW1FrvbhB9lP4zrOedYuNqnMcCPw9IO2Dyd+AQ9tmeP+1RKlfTX4jeKz2tPphFqJI6u0Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: c2496a79-0e60-447a-fa2d-08df048dbf83
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 22:51:36.2234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IeOgVJXe/zzyfGuIPD9VKPmAeFH/AqBLSd8vsnSleZ/4nG5kt4XAa9aYsblkjbURj7l5KjvaMwQ/KaNetdw2gAXsUKo5SJiLs1o3Z+PHzak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7603
X-OriginatorOrg: intel.com

On Mon, Aug 24, 2026 at 11:31:13AM +0530, Hemanth Selam wrote:

Hi Hemanth,

Thanks for the patch. The fix itself looks right but the changelog made
this harder to review than it needed to be for a simple fixup.

I am fine with an AI tool finding a correctness issue, and I like that
you found a way to exercise and test the change, yet neither needs to
be dressed up as something else.

Suggestions for a v2:

nvdimm/pmem: Release gendisk on probe failure

> pmem_attach_disk() allocates the gendisk with blk_alloc_disk() and only
> hands it over to devres at the very end, after device_add_disk() has
> succeeded:
> 
> 	if (devm_add_action_or_reset(dev, pmem_release_disk, pmem))
> 		return -ENOMEM;
> 
> Every error path in between either has nothing to release yet or jumps
> to the out: label, which drops the last reference with put_disk().  The
> devm_init_badblocks() failure returns directly instead, so on that path
> the gendisk, its queue and its bdev inode are never freed.

This mostly walks through the code. Please structure the changelog as
background, problem, impact, and resolution, without narrating the call
sequence or error labels.

For example:

pmem namespace probe allocates a gendisk before initializing its
badblocks state. If that initialization fails, probe returns without
releasing the gendisk.

<Describe when this failure can realistically occur and what happens
to the leaked resources. Is the gendisk permanently leaked, or is it
eventually released when the namespace is unbound or destroyed? Is
anything user-visible left behind?>

Release the gendisk through the existing cleanup path on this failure.

> The disk has
> been allocated before this check since the check was introduced, so the
> leak is as old as the check itself.

I don't think that establishes the origin of the bug. Please look at the
code immediately before b95f5f4391fa and re-derive the Fixes: tag.

> 
> Forcing the branch and rebinding a namespace 64 times shows one gendisk
> leaked per failed probe: disk_release() is never reached and bdev_cache
> grows by 60 objects.  With the goto, disk_release() runs on every
> attempt and bdev_cache returns to its original size.

I like that you found a way to test the error path. Please state how
you did that, what tool? Make it clear that this is a unit test of a
difficult-to-reach error path, not a user scenario.

Also, 64 failed probes resulting in 60 additional objects caught my eye.
If that difference is meaningful, explain it. Otherwise, I would leave
that level of detail out.

Likewise, please say how the bug was found.

-- Alison

> 
> Fixes: b95f5f4391fa ("libnvdimm: convert to statically allocated badblocks")
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
> ---
>  drivers/nvdimm/pmem.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 30a51c365ce8..648fc7d66063 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -563,8 +563,10 @@ static int pmem_attach_disk(struct device *dev,
>  	nvdimm_namespace_disk_name(ndns, disk->disk_name);
>  	set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
>  			/ 512);
> -	if (devm_init_badblocks(dev, &pmem->bb))
> -		return -ENOMEM;
> +	if (devm_init_badblocks(dev, &pmem->bb)) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
>  	nvdimm_badblocks_populate(nd_region, &pmem->bb, &bb_range);
>  	disk->bb = &pmem->bb;
>  
> -- 
> 2.43.7
> 
> 
