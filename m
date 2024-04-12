Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D919610B
	for <nvdimm@lists.linux.dev>; Fri, 12 Apr 2024 21:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712957413; cv=fail; b=T6Z6GsbPOak0JKPXZajeq2PWkYpfXE8hKvsztEbXujUjUPIWPTiE35D2GRaQSpJECE8TFl6rC8sys6QLW6M34alBVUEI9R17q3V9Twsq/FRLgwLX1Qp9iP2psHaimFw0Pjzufpos1M/39vKw3XHZrlC2JU9VgxQ3Y4hS5i4BIDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712957413; c=relaxed/simple;
	bh=VWyF6qFoCNcm2nfAw1ubWtZ65i0QZ2BFWiGd2cQEU54=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qhdMaDb4ltm9BgQrykiYN8Rt+1gvq0H5pu5gfqLCgI6L0syRFS5rsVfNMlvf/7E4ypYUsgWncgR4NZrwPHDT8v1LaoZB7VHw4uIqT1W/ttbSEKUj4gKI7lgv6cwBxP0NHaUTXf/HwOtlHhWPOWuFMv57NPzMcSjkE/5Y16y99tg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z+B9XRYU; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z+B9XRYU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712957410; x=1744493410;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VWyF6qFoCNcm2nfAw1ubWtZ65i0QZ2BFWiGd2cQEU54=;
  b=Z+B9XRYUKKpmHSCE8g9KJzChAzBenSZ9YngnYhQq7qHMKK5aIkovCvdV
   2s4NklfPTbcFxCud7EVcGdk2+dyKVDaPeGhFaxXQm4N+gHx6irZUc3e0r
   kd/CyPRndYkLB3aHblaTWanul5FiVShXHTVIpIg02t5yxW0jv7ZbcfCAA
   Zl1XQwGtjPaOQAWr2bOW9I/mzXnzdAl4ZWEwAL00iD2ncpq8UJRHpi0GM
   eG+W22wtxNO8N/1m+rNQS4PMj5SZEnb+6i04RT6x4vVUHxV+KiR9jJZcM
   6muRZo0ifO+Yy6RV6TMl9mcmsfR1CuStIKoXD2Xhl7+SyQ4QHhgqYdGHx
   w==;
X-CSE-ConnectionGUID: t99MdtZsRp+K6ImOM++8yA==
X-CSE-MsgGUID: SuvocUCJTuakOwU5LCQmkg==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="8539249"
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="8539249"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 14:30:10 -0700
X-CSE-ConnectionGUID: tdmT4RQCTkCl/viKNyTHMA==
X-CSE-MsgGUID: uLhDcAXmTEW0gIKT2c+Lkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="25894497"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Apr 2024 14:30:09 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 12 Apr 2024 14:30:09 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 12 Apr 2024 14:30:09 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 12 Apr 2024 14:30:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NxHUIlC5UsJ1wEgCOv6m5JMEVuyPm2T2rLdLl4iVSQpdRLQM0SgjvpKb+3595J67a87T5WLm4n7cRKi4thMBOGkgUJEcG+YMcITiOWCUnB5SVdwfr+A2nCnXVX/HwqWJ5DVvbp4K3wlYXx19WCB9ppVX+xGpaTOIxpxjpmQ9gG3Hem7Z+YdhhVRUeZywLm9xtUraGju8V+9B3TRyEPgyjPAq0Ue1pSFvoXxzqLYal4aHGGO/9qvv8EoFfjPfJTyt83Gs97XYLZVa33Po7JFQgk7dF0M77oaQG5oMINS7kW1AlcfGGLDjdLYkFDRhBYj9ips+4KoNRilfV686pZmmBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JRAf2iTXMyVOoA2XaHyPxqElJi7W1mgZghMLr5Ej70g=;
 b=UnnuouwEkkiu/5KZIcjq+Bp6/JlPVGdEcsqXhJ3bYf3ecIllOZIODH3vXbtyL/D0iH46uTH/iJK/wAYDdYTEwim18MRzc6rxQmAVTvNgF+Szz4ObLxZEJ8OGi0tIm87aWOwexhi3rEBnzk3rU+5cirQSF1mdW1qqC6NbPVQwcSV3g2bNE+xSg85DNsduHsEU8/aTLBOEgOG91CRhImtzqpcFP4i1BPWQRA8d69vLphykal7BH6wmYWHJgSaLc+b/A7N+PtqVkAsA4wdKCVCX1fsZiNWahqozYETvmYixvTanwpqdOY8P9N8sdYg28o4HX8UZFAuQY5bMpB/9T+gRzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by LV8PR11MB8680.namprd11.prod.outlook.com (2603:10b6:408:208::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.26; Fri, 12 Apr
 2024 21:30:07 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71%4]) with mapi id 15.20.7430.045; Fri, 12 Apr 2024
 21:30:07 +0000
Date: Fri, 12 Apr 2024 14:30:04 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
CC: Dan Williams <dan.j.williams@intel.com>, Alison Schofield
	<alison.schofield@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	<ira.weiny@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH ndctl 2/2] daxctl/device.c: Fix error propagation in
 do_xaction_device()
Message-ID: <6619a7dcd1a18_24596294ec@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <20240412-vv-daxctl-fixes-v1-0-6e808174e24f@intel.com>
 <20240412-vv-daxctl-fixes-v1-2-6e808174e24f@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240412-vv-daxctl-fixes-v1-2-6e808174e24f@intel.com>
X-ClientProxiedBy: MW4PR04CA0351.namprd04.prod.outlook.com
 (2603:10b6:303:8a::26) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|LV8PR11MB8680:EE_
X-MS-Office365-Filtering-Correlation-Id: ecb8f9fd-6a14-4ac6-77ac-08dc5b37b93e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jjtIEeELSJDN8IFW8Hn6xPVvR6puYsc7fToiWYYN9roKIOQDNmKV9jzJCXbmF24vkR7rwc8zfn445pYlThsxtvwGyLSAy+tr4xBLFclMaXysdWDfFkuL6+saaFkzUvG7RHNzm4Nwcgm73rv6Zac20oGvlPRLC+nZ93Mf3gXRx/RLA60PHr+37yoc1MxKoijOYpYjHeL1Zok6CTYVHAn7MWrGbIoI5ac3EIllHwFRHpYA8c8rImaVrtZ3pEkvGWzBunbzTzL9YayekZ825Ir1qj5dw+damfJGRFKSou/Y6Y6wsc0EQgEuQE8AcW2xwMtECQC4i3zmHufNNAyCT3gU/wfCG213zE/hGVlU70mtqJVVfEEOW1I3wIqMRfrR0f0SNaziAGW6MMAlyZvCUQ3sPKNBiQneYTqCu41JxtIahW87sG9cw7yDxjmxdRBSnmrvnstUIPfGcuS+h7x3v6ocw5zo34UCCgNQZbxRcFw3uM0n92KAO05YTqCdNt3C9GkSlzBl5AtH8G2suz4iaAx3xSVv+C4ZGilWf99m4zJj5U6FctuubRl85g6dXO0ykgWqF9CyanTYfMt4ANxmixklKXLJNuRQIOpf4tYX6KDyxIXePJAty4D0ENbbHpl8fHZkKX5/1Os3qsHiGiiJge4eI6VLV5f8bLm8Z9Tk1A5dYx8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V/fZPzEjeVO6kInkVhqlzqkaXgP8maBAknC0iu/KdY2/ITPlMTyfrZLXI/AM?=
 =?us-ascii?Q?NCYup7+sxvpqiI8URirW7RcEMTkxEu/s7/FJ2i3T32KLlGSMXlAijbGIwvMF?=
 =?us-ascii?Q?8q2jkJyP6zFbmXrVtgpvMESNWCIkHA+nXiZdFYYMR9zdremmH5lFqHiHnANi?=
 =?us-ascii?Q?eNrEcSHMvwfbZ1ObVvdg3n1rQvE6loxIox07/I8ZzTFp5VNXyIaOrVNG5EBj?=
 =?us-ascii?Q?zHandqB/nWpl4irN01XJwtg3YtDxxGb8TyzXTg9mQ5IXxEv3+SqgNwQ7mUcq?=
 =?us-ascii?Q?58pJwgvs1C2lKuZZNVpg6syp6KbeW8auaDrYmfDAtuV2JFrI9zqpqTS7UTvf?=
 =?us-ascii?Q?9B+7f1d2yfLlE7oJ2KdUIXlJ0hmJtNmVUDBO2AcD+fe6T5RoXX8lhTTTVg2C?=
 =?us-ascii?Q?SWBs1Z0SguFyCOouENu67NpH5tf8rRk2+rqbXALh/6bjDXwYgIsUgLWWevPE?=
 =?us-ascii?Q?UQGryDpHhUmQV1xaScFpSSg3m6RVSOdYOFw9S5+2TDdV1JFsLR9/cj1fUPoj?=
 =?us-ascii?Q?BlARzzIH9iAHC1GVTX5DhT3LYEm9B5BDDMTWaJEWWbTo7WIATOWwZanhxFiR?=
 =?us-ascii?Q?evgs0zzE9b5uKKgeGsOOw1Mj/NZwxy1uJbBkeNEFysLLlt/SaqLd2hb9kSyn?=
 =?us-ascii?Q?Gxf2cXLQ0XmRBA8ishxmdbARhUM6olXGcW9vM8wHJPw2wbJgabK3nditUZX1?=
 =?us-ascii?Q?GvzytYPLGC6HZStr7RDhKeqjS+UY94/bs8rNS86jJjhR4gKmw+l7/knh3RUY?=
 =?us-ascii?Q?VTs3nh31JmKB91UnSYDqvOwFPfvf8xFYyMiuGmODo4xoMQcI0tfnnfFGqf+w?=
 =?us-ascii?Q?LiKzQtQw4WBCWske5k0MybNC1Iav2nNF1EvoU77Fw22j6sXiaQEbWHUs7mAx?=
 =?us-ascii?Q?zb9FajlLe46FmDZFlWBjpPzMBrAEky3JHdXIF5jy77/wfdrddJ6eczArG5O+?=
 =?us-ascii?Q?4ViGWw3pO84x1jFXPQ3ZHkrI1ly1fMyNrWWQbJ9d1iEwgDlneugjI+bmGHjt?=
 =?us-ascii?Q?oj4sgveutnWrB15IS4n2nzKngZ2HS2TixwRlOtKYdsq0vIfN+hHGX1yUKVb7?=
 =?us-ascii?Q?BNSwLIEKIy/BNf2j9cu1po3iBmDqJLm4OYcA4P1I9rSuKi3W5apCaQDBUj/l?=
 =?us-ascii?Q?80Z6INSvX5svGd3xeLsduDADpD1wabCj7FtKPVVBtcBTyMzypz1QoMobbncc?=
 =?us-ascii?Q?bY8o1DWVJPrp0RqgbGwIglIttIAgYrq+UWB53XOswQPN4L8iUOFF+e9aXS7O?=
 =?us-ascii?Q?L1SnB0/8p1nPI+WoHVt2twq+gIFLOlETfonH8fGZRMYyWdNs/ik6Fn+jaRQ7?=
 =?us-ascii?Q?DKJ8rFwiOZNKG9P3NUGQmtsOufy4SMAP4DeJjK4W2ZnqFCeaZGdjh/hgq4wk?=
 =?us-ascii?Q?qXtG/y1FESdmsucFEPJy4mqeD7wJFMPlH1UzCwX7QZdhPDxJEi7SvJAv6/ZD?=
 =?us-ascii?Q?ItLM5P8etwG/TNip7prbu5Kse/6dst8WLJ37NsNc1qH0MV5MUxYxGlF2TzrM?=
 =?us-ascii?Q?UjSSFmgcqAK5qsBGMRRh9Z7R6KzcjAJIPr8Nww4gjHQYyrE2OoiCVoijg9ci?=
 =?us-ascii?Q?Jph0TKSZG+dNuBFCKC9kqH5ANaml/QKpjgS8PF0LMOZ9PtB48YQ63gpro5+C?=
 =?us-ascii?Q?Kw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ecb8f9fd-6a14-4ac6-77ac-08dc5b37b93e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2024 21:30:07.0717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Phy5U9g3G13T0A/zg2wjjYlNAFo7mjJrpQZzdbpQC3b+CMh9wh9o5D/qEF0FP65KOX99KrZL8UW9hQ/slP6pTw/F0YHmys5cB5guVMBceQE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8680
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> The loop through the provided list of devices in do_xaction_device()
> returns the status based on whatever the last device did. Since the
> order of processing devices, especially in cases like the 'all' keyword,
> can be effectively random, this can lead to the same command, and same
> effects, exiting with a different error code based on device ordering.
> 
> This was noticed with flakiness in the daxctl-create.sh unit test. Its
> 'destroy-device all' command would either pass or fail based on the
> order it tried to destroy devices in. (Recall that until now, destroying
> a daxX.0 device would result in a failure).
> 
> Make this slightly more consistent by saving a failed status in
> do_xaction_device if any iteration of the loop produces a failure.
> Return this saved status instead of returning the status of the last
> device processed.

I think "this is the way", at least it follows what cxl/memdev.c is
doing. However we have ended up with an error scheme per tool when it
comes to reporting errors for multi-device operations.

cxl/memdev.c: report the first error

daxctl/device.c: now fixed to report the first error

ndctl/namespace.c: reports last result (same daxctl/device.c issue), unless in the greedy-create case

cxl/region.c: reports the last error even if that is not the last
result, immune to the above bug, but why different?

The struggle here is that all of these tools continue on error, so it
has always been the case that the only way to get a reliable error code
vs action carried out is to not use the "all" or "multi-device" ways to
specify the devices to operate upon.

I don't have a good answer besides, be careful when using "all".

It might make sense to bring ndctl/namespace.c in line to guarantee
"unless 100% of the attempts are successful the command reports
failure". However, it might be too late to make that change there if it
breaks people's scripts. ndctl/namespace.c does not suffer from needing
to know that namspaceX.0 can not be deleted since the deletion there is
exclusively done by setting namespace size to zero.

I think this daxctl change has a low risk of breaking folks because the
primary failure case is fixed to swallow the error.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
