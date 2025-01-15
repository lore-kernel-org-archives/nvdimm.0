Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A83341C6C
	for <nvdimm@lists.linux.dev>; Wed, 15 Jan 2025 20:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736973211; cv=fail; b=o0FL8VU+dbCqyeqDAdFC7BV4QIEf8iN+QPvICIWHFeaUIp/ElylUF+AA12rkaye0bvnCOjtW2RnKTI6yqUKSxYdD0Vqkko9PQs3xmsBJViYgILioDeUb/q1x+eSE2B8vB7Vdyr1gIqmOXx/ExmqlzZeQ/o0HXKTIcyqJy3sx9qU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736973211; c=relaxed/simple;
	bh=XWDaBfAFnDTKGOmlwhzeZ6VP/+98YohgKp9HhJtu8qw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ftbjvoSINC9mzRR9tu6k4V64ZV479t4tlZqTG9nrUr0QdhvKOeVZHSRN6yvjk6CTZ7zJsSMGp+gNuWbpwc4vr4v6r4qduIMoxv3DfKs9ZwVRtaB5Dz3uD7lKSE6EAP9yVWFKil2WR+wcqX+NF9dozi6RXqB3a3anws5XmWaEplA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dUuWcBUw; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dUuWcBUw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736973208; x=1768509208;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=XWDaBfAFnDTKGOmlwhzeZ6VP/+98YohgKp9HhJtu8qw=;
  b=dUuWcBUwfyC1CLCXmv0TAVGzfafjg2EpaBp7IJVP+BkVrnBoq1wFuQ1i
   b/28QPbqYvmhXCtj53XOOfgUnwm2Nlhbf69g7NUdka1031LVH4rkgM5Dy
   +rWkYiGlT3RgBFEZmcTaM7R5lnO57TEbA7srS97gUqpiCsugWt3mztdXm
   4QcGZzqRigPE1UehhO7MdAPQniB1PogKAiz5H2Z8huZLUDRfsogpeolsU
   3BO8pY5Io9Yiuj7nn8iHKYwj/CK6tLjM6PmmKPV1wf3Zoto67ck8nax9d
   Zfs0MSLAJJM2CwE4pOYA9oKBxpkOQeaMyZcqPNQNuuhv4lj46x3EXJxAP
   Q==;
X-CSE-ConnectionGUID: t/N3EqRnT+ebLStw9DVyEg==
X-CSE-MsgGUID: xBD+uHP5Re+DoZloVwqR4w==
X-IronPort-AV: E=McAfee;i="6700,10204,11316"; a="41009124"
X-IronPort-AV: E=Sophos;i="6.13,207,1732608000"; 
   d="scan'208";a="41009124"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2025 12:33:28 -0800
X-CSE-ConnectionGUID: k8iIyRIGRfebEU2AvusOuA==
X-CSE-MsgGUID: SDd2RuXJQkiwiX6QEzrrVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,207,1732608000"; 
   d="scan'208";a="105793668"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jan 2025 12:33:27 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 15 Jan 2025 12:33:26 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 15 Jan 2025 12:33:26 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 15 Jan 2025 12:33:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YS5U872GITYr+1suBCjR4VhspIC1HwbT/fRFds6ztxPvcfFOWnr/tLO5ub+u/Z5aiRqjfu980zG9sPt5iN0uDcs2HucvvMzypS0Cp09Zc/sTYqvOO10eX+tTzSnU+FzSyLWk3xt8X0ptJVKrZiaTyeGTknom9+EDPAjx3MU+kBzDxpkJUvCszyczceVCpqc6GwFAvpWRpkBwF9k+Rgx1d5p6Hk3KjRbaYq1ioT6v7/uf2SLVIOF6ToWtf/UuAswWhQZF/winaM72kdeyrjS8xwzFTTv/dm5aNmyO3QSGkb5O1FFgn0dxrHiWOLivF46FnTe4GaKPhvptvGbm9A8WRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6dCyHgEPla4DiGcNF7BcZt7a26Uob74PR5vQ/qJGA2s=;
 b=b61U8/+8FVc2S7g98C7AzB2h7GPXQkHRtXfntZlUmL0yHFRnn8NaCW6+jNGFH4dKeC5BbKQAF+CKQF2jHHp0l5lxq8sOdGtgd+pOT1tmzZjNE43BBJg1MQjgrD7E6yX7IhRWqkd0ceGRr6yVQvxSx8bIaiwFJaJGrK/G7FKvvJ8tPqaQNFqDGXXdfcMvkYcDQIDis7graWgqd0Q76lMyC0NacNNJCq+tiVTT+jN8jKK8cJGf7VvcRj3KlnfxxW52yk6Z1+qQmVpTWQA0ordXZkpE/UlAmN95EFEytBTr/jwF1I6A8N08jtmKDEAjxclyP1fAEV2s7Ib9ph3GOMleMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SN7PR11MB7067.namprd11.prod.outlook.com (2603:10b6:806:29a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.12; Wed, 15 Jan
 2025 20:32:40 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%5]) with mapi id 15.20.8356.010; Wed, 15 Jan 2025
 20:32:40 +0000
Date: Wed, 15 Jan 2025 14:32:32 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>, Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>
CC: Dan Williams <dan.j.williams@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Alison Schofield <alison.schofield@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	<linux-cxl@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-hardening@vger.kernel.org>, Li Ming <ming.li@zohomail.com>
Subject: Re: [PATCH v8 02/21] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <67881b606ca4e_1aa45f2948b@iweiny-mobl.notmuch>
References: <20241210-dcd-type2-upstream-v8-0-812852504400@intel.com>
 <20241210-dcd-type2-upstream-v8-2-812852504400@intel.com>
 <67871f05cd767_20f32947f@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <67871f05cd767_20f32947f@dwillia2-xfh.jf.intel.com.notmuch>
X-ClientProxiedBy: MW4P223CA0024.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::29) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SN7PR11MB7067:EE_
X-MS-Office365-Filtering-Correlation-Id: 946efa92-5cc5-4365-48cd-08dd35a3c1a2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?HmbHmT8Jp1tU7gkbF5L/fzqdyLcj9tH1EpfQ5tqSRAGp4up/U7dIADStgne6?=
 =?us-ascii?Q?D69mW7MEphN3u48IkcrbX8L+la0xDTK40xrCuclmcvswnFZfjC4POReSlcqv?=
 =?us-ascii?Q?zKppFnmHy/WKsuXdzpTWK9bbjiKTeOLM/vYHoz+U58IvvhIWZXREFfxdUWOc?=
 =?us-ascii?Q?hnJzuqV0YITozp4PVAvx9DSfRRm6h6il6nwtsiaYS+zHk/CF8oeZfAu8zPR3?=
 =?us-ascii?Q?RACQdCNqeaaaRmzhyD2wbFHE4xfb8NwgfrlvRzIcsZqIowOG6npJjoKHa+Uj?=
 =?us-ascii?Q?VoDTcEfkwu+++6htbmEA/O/SnUjwzVAnsewmTJ7kjQeV+k4mzCyTzzHIM0MJ?=
 =?us-ascii?Q?uLM0rPMH+uVe7BLqmT3Na6RSVO7L4IGL/4KLzErs8jATfeIoS5wUVicEQ1QJ?=
 =?us-ascii?Q?BL7R8G8kJmOmq8hflmcSrK/JEya32PcTh9R2Q9MTKPAXw3t4AwWO/C/rrVOm?=
 =?us-ascii?Q?9vUqB46Ak7vWNPn/EX6Bu+61pcchBxH4YMIeonSPqyEY8hGFAvBa0NADdxd1?=
 =?us-ascii?Q?2lkbiJhPBJEeHR+yIuZdo1nZFNKKLvI9Pl8cfHWqIdj1x3MrPWTEOJDtBSSI?=
 =?us-ascii?Q?lltSZqh2z6AJ+InhYXJTe/Obv85ynyCgUdU9TB4iK2kWRD1p05sS02LEkeCS?=
 =?us-ascii?Q?wle5oITXBLmhmnO12NSVAwMSmZgx/57fDyMWHI8LyhG4Sm0BRvRdn6EIE583?=
 =?us-ascii?Q?1SiGJY9BUxNNKRW+VIyDL8oj+VNN0FhDzA1GRITBq/Pbyvn6W5d8879lqkZU?=
 =?us-ascii?Q?jb0mQtfDhe77pE/H4onG3Mr9EWiXqG1vk+ITt6PJdoe+cSMBdUU+6L+CpbqI?=
 =?us-ascii?Q?b/TlGbggs/U44CE32B8wsh0Vy3n1Vz8DAgLYmf5y+a0xmXEplixF5/Hojr7u?=
 =?us-ascii?Q?4LcVdVLsKE/bVJbY5cF4s0bU7RPYtvSA07/Gg9ZCfj6BjXDfo7ZQBcFi5YLO?=
 =?us-ascii?Q?u1jw1hb41cQgOmecxyfOoXeE7SyyBnSi7n+K0xwEpvdlF1IecaqnFlFT+eNJ?=
 =?us-ascii?Q?BMJ1nfDE9ekhAH11y8CBaZUZ6s+QGoiFAiLAL9wwudsbOMonYeo7VSy4EQ4C?=
 =?us-ascii?Q?46v377Dgb0vYpZU8yPLwspIp9n/Hpgy5YsowPgLjxSduajVf7BdDfMtyZ1yj?=
 =?us-ascii?Q?yNrRXpW3Op/4QAkV93DNJ0QTcy+4OFpKBaiCrt215M7/Z3rokBJxPcD3blgP?=
 =?us-ascii?Q?gBcTFJraKwX9EPOrl9YlvL3Z0SiSUgtd379boFiAgXtgafEThwdbVazOPir1?=
 =?us-ascii?Q?ERACNmhk/2jOf53U6XLl4nbhlgcjUZrjbNIoL/MVShYBnZMXr5pU1ez0jPvo?=
 =?us-ascii?Q?/B9pR5EMHhMmRPwjfZdp4BADdI5RvUYoxCnKqtRQrXllKpyDf4KK/vT1wntj?=
 =?us-ascii?Q?kHMJU+HT6UgTu3nCg7ZsZnPEUIbJ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k8SrtiDSa+0EYS7g/xmQnCX16YI15jfX7QzTdebWmijZaugQ8xJDZeSl50EO?=
 =?us-ascii?Q?b1EU7TgkXWSeyctUgCIwRJ8q7QVmxM6ZXJQzNgsWykSrgylP5BzL7SMYnEm8?=
 =?us-ascii?Q?Yxy1FydUe/Q5DTlAcjn17ak+ntUSuTIHumx5E3Gvxu5c/Qc5V/sCy0DiwdaD?=
 =?us-ascii?Q?ePLt0cnsUkzDPcWtwE6WHdnCb6JB3zirDHqAK1mLuTSKdsLIGNQMSEwwo3Sx?=
 =?us-ascii?Q?1cvTRAAoKPp66YYDY4otXcAOI//c8nZRgYjmHuCfJdHsQLAeCDmDeAQ9OZo7?=
 =?us-ascii?Q?rP2xKfiMeaEbjBBUrGb8v76VCzk6ICqdm/eYK6TRn4yoKDwXdGWdSBqebR+x?=
 =?us-ascii?Q?AVufqsZZICDXbNj82cAjFZ1H6ya/IJXrD/GIazXeft7yOR9p14eWZX0oUBYX?=
 =?us-ascii?Q?ES9P5xHkkAkIqhIETCK50nydJVkNPsfl4/GVlx56V6MRv4066cmuCXVQvf9g?=
 =?us-ascii?Q?8PSbVo3b2ABVJyhWBdEghs9wleQ1rKWeWPu87xy3E8Fvv/25WzL3GK0IWmk6?=
 =?us-ascii?Q?rD/PpWYOt5Gh4Ui/y8qOzX7L4Up4F/whtqzPlcPRJ62Kca9R/SP57BluaNi/?=
 =?us-ascii?Q?YiVENfw97QDbVakl20mBpkJ9GG01UzY65k0xViX4oXP2LVRLNoTFLpcsYwBF?=
 =?us-ascii?Q?3dPUUgb60YNTrLyPA20P4NJDuAr/tfKMCw45f3XP5rXIXRa/aQ3emsbeDB6K?=
 =?us-ascii?Q?PDNsqDsZgLzRqRsjdxH5FY6EehSN+AxTpA2Joplh2xxFv/t+cRti02I108o7?=
 =?us-ascii?Q?zsS/zbOw1/3rJh801GVcvDhciQbuVqjCxtxXYuQpt2iq6cnEpZInVzUPWwwx?=
 =?us-ascii?Q?MPqGJAAHm1fiVATUvGUwtyn9wrPKyBFwkZ2erMveF3Q69122nXJq+tCskkf9?=
 =?us-ascii?Q?10/3jt7VRbjUofY3VkGcucGL3c9u2qhyAo9hnO1XSSXBVdkM09QE/7kvlkj4?=
 =?us-ascii?Q?+RT3EdNQWbHGVznQgfP3F03STIVlXVsZWaMSJGaFw9hVpGR6z8v4hae5b8NP?=
 =?us-ascii?Q?GdcY8cTU8Q+hcuCl1hkIn1hYNBuDTqHjh7IqaqW+sKL9+LRkkfgZ/YGkPSxG?=
 =?us-ascii?Q?9hl0fjwUBctBUNq8JdgQ8ZoLYQXz/RCiYmXfVC/+7bNjV7Xv+lnZTnwD8tWI?=
 =?us-ascii?Q?VfsqwowzXzQ2Dk+70V8PP3EK1yZOlncY37eSAcVG8pOLWHwtyUv4FCWea9DG?=
 =?us-ascii?Q?b4p4DhmRUja7f9xRe8QV/j3CIBIZ8MoOxnOP3BykRCLoB1wgeuP/5lAtD3Pf?=
 =?us-ascii?Q?zHCoCxxvv0NdpzGvCWE1/XBE3UBFkHSl/5nkgQ9TmDVOV9+LzVVXb6iZxJRb?=
 =?us-ascii?Q?bXXhaIdydWODZNseL0IqE06330HOkBgXMejjGMqHF0GOK36FAX62aUpIeNaJ?=
 =?us-ascii?Q?UBgQwlYavKfnScW/4+Bh3ny1b0NrtvJem+CTzWBm7NP73ahEkQAPNy4l+UPL?=
 =?us-ascii?Q?6OUB/XMWZcgDb6zMp5zXs/mr6l8ogkcU0ZIXmxEMp8DhibE4XdT/zailD8MG?=
 =?us-ascii?Q?GtZLh+2y+OElBy4mg7i202ltxSYWaoLlecxEuih/NEUqoBDsQBMhjby71iq2?=
 =?us-ascii?Q?kitWV/d5LIdb+xxuzYEQr02H0V2U+OThRvLzDwY6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 946efa92-5cc5-4365-48cd-08dd35a3c1a2
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2025 20:32:40.3264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QM17XLKQMqYCEtRXofIev6R6mtxgHvxETKS71RYbKCZa8uoT6mdca7rW1+k5QkjvAxvQtR9yGB6Lc61Q11mM5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7067
X-OriginatorOrg: intel.com

Dan Williams wrote:
> Ira Weiny wrote:

[snip]

> > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > index e8907c403edbd83c8a36b8d013c6bc3391207ee6..05a0718aea73b3b2a02c608bae198eac7c462523 100644
> > --- a/drivers/cxl/cxlmem.h
> > +++ b/drivers/cxl/cxlmem.h
> > @@ -403,6 +403,7 @@ enum cxl_devtype {
> >  	CXL_DEVTYPE_CLASSMEM,
> >  };
> >  
> > +#define CXL_MAX_DC_REGION 8
> 
> Please no, lets not sign up to have the "which cxl 'region' concept are
> you referring to?" debate in perpetuity. "DPA partition", "DPA
> resource", "DPA capacity" anything but "region".
> 

I'm inclined to agree with Alejandro on this one.  I've walked this
tightrope quite a bit with this series.  But there are other places where
we have chosen to change the verbiage from the spec and it has made it
difficult for new comers to correlate the spec with the code.

So I like Alejandro's idea of adding "HW" to the name to indicate that we
are talking about a spec or hardware defined thing.

That said I am open to changing some names where it is clear it is a
software structure.  I'll audit the series for that.

> >  /**
> >   * struct cxl_dpa_perf - DPA performance property entry
> >   * @dpa_range: range for DPA address
> > @@ -434,6 +435,8 @@ struct cxl_dpa_perf {
> >   * @dpa_res: Overall DPA resource tree for the device
> >   * @pmem_res: Active Persistent memory capacity configuration
> >   * @ram_res: Active Volatile memory capacity configuration
> > + * @dc_res: Active Dynamic Capacity memory configuration for each possible
> > + *          region
> >   * @serial: PCIe Device Serial Number
> >   * @type: Generic Memory Class device or Vendor Specific Memory device
> >   * @cxl_mbox: CXL mailbox context
> > @@ -449,11 +452,23 @@ struct cxl_dev_state {
> >  	struct resource dpa_res;
> >  	struct resource pmem_res;
> >  	struct resource ram_res;
> > +	struct resource dc_res[CXL_MAX_DC_REGION];
> 
> This is throwing off cargo-cult alarms. The named pmem_res and ram_res
> served us well up until the point where DPA partitions grew past 2 types
> at well defined locations. I like the array of resources idea, but that
> begs the question why not put all partition information into an array?

For me that keeps it clear what is pmem/ram/dc.

> 
> This would also head off complications later on in this series where the
> DPA capacity reservation and allocation flows have "dc" sidecars bolted
> on rather than general semantics like "allocating from partition index N
> means that all partitions indices less than N need to be skipped and
> marked reserved".

I assume you are speaking of this patch:

	cxl/hdm: Add dynamic capacity size support to endpoint decoders

I took some care to make the skip calculations and tracking generic.  But
I think you are correct more could be done.

We would also need to adjust cxl_dpa_alloc().

I thought there might be other places where the memdev_state would need to
be adjusted.  But it looks like those are minor issues.

Over all I did spend a lot of time making the skip generic and honestly it
is probably worth making it all generic.  However, I think it will take
careful review and testing to make sure we don't break things.

> 
> >  	u64 serial;
> >  	enum cxl_devtype type;
> >  	struct cxl_mailbox cxl_mbox;
> >  };
> >  
> > +#define CXL_DC_REGION_STRLEN 8
> > +struct cxl_dc_region_info {
> > +	u64 base;
> > +	u64 decode_len;
> > +	u64 len;
> 
> Duplicating partition information in multiple places, like
> mds->dc_region[X].base and cxlds->dc_res[X].start, feels like an
> RFC-quality decision for expediency that needs to reconciled on the way
> to upstream.

I think this was done to follow a pattern of the mds being passed around
rather than creating resources right when partitions are read.

Furthermore this stands to hold this information in CPU endianess rather
than holding an array of region info coming from the hardware.

Let see how other changes fall out before I go hacking this though.

> 
> > +	u64 blk_size;
> > +	u32 dsmad_handle;
> > +	u8 flags;
> > +	u8 name[CXL_DC_REGION_STRLEN];
> 
> No, lets not entertain:
> 
>     printk("%s\n", mds->dc_region[index].name);
> 
> ...when:
> 
>     printk("dc%d\n", index);
> 
> ...will do.

Actually these buffers provide a buffer for the (struct
resource)dc_res[x].name pointers to point to.

It could be devm_malloc'ed memory but this actually worked ok.  ram/pmem
just use static strings.

I could add a comment to that effect.  Or I could define a static array
thusly...  I think this would go against defining a resource map though.

@@ -1460,6 +1459,10 @@ static int add_dpa_res(struct device *dev, struct resource *parent,
        return 0;
 }
 
+static const char * const dc_resource_name[] = {
+       "dc0", "dc1", "dc2", "dc3", "dc4", "dc5", "dc6", "dc7",
+};
+
 int cxl_mem_create_range_info(struct cxl_memdev_state *mds)
 {
        struct cxl_dev_state *cxlds = &mds->cxlds;
@@ -1486,7 +1489,8 @@ int cxl_mem_create_range_info(struct cxl_memdev_state *mds)
                struct cxl_dc_region_info *dcr = &mds->dc_region[i];
 
                rc = add_dpa_res(dev, &cxlds->dpa_res, &cxlds->dc_res[i],
-                                dcr->base, dcr->decode_len, dcr->name);
+                                dcr->base, dcr->decode_len,
+                                dc_resource_name[i]);
                if (rc)
                        return rc;
        }

> 
> > +};
> > +
> >  static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
> >  {
> >  	return dev_get_drvdata(cxl_mbox->host);
> > @@ -473,7 +488,9 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
> >   * @dcd_cmds: List of DCD commands implemented by memory device
> >   * @enabled_cmds: Hardware commands found enabled in CEL.
> >   * @exclusive_cmds: Commands that are kernel-internal only
> > - * @total_bytes: sum of all possible capacities
> > + * @total_bytes: length of all possible capacities
> > + * @static_bytes: length of possible static RAM and PMEM partitions
> > + * @dynamic_bytes: length of possible DC partitions (DC Regions)
> >   * @volatile_only_bytes: hard volatile capacity
> >   * @persistent_only_bytes: hard persistent capacity
> 
> I have regrets that cxl_memdev_state permanently carries runtime storage
> for init time variables, lets not continue down that path with DCD
> enabling.

Yea I thought these were used more than they are.  I feel like over time
they got used less and less.  Perhaps now they can be removed.

> 
> >   * @partition_align_bytes: alignment size for partition-able capacity
> > @@ -483,6 +500,8 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
> >   * @next_persistent_bytes: persistent capacity change pending device reset
> >   * @ram_perf: performance data entry matched to RAM partition
> >   * @pmem_perf: performance data entry matched to PMEM partition
> > + * @nr_dc_region: number of DC regions implemented in the memory device
> > + * @dc_region: array containing info about the DC regions
> >   * @event: event log driver state
> >   * @poison: poison driver state info
> >   * @security: security driver state info
> > @@ -499,6 +518,8 @@ struct cxl_memdev_state {
> >  	DECLARE_BITMAP(enabled_cmds, CXL_MEM_COMMAND_ID_MAX);
> >  	DECLARE_BITMAP(exclusive_cmds, CXL_MEM_COMMAND_ID_MAX);
> >  	u64 total_bytes;
> > +	u64 static_bytes;
> > +	u64 dynamic_bytes;
> >  	u64 volatile_only_bytes;
> >  	u64 persistent_only_bytes;
> >  	u64 partition_align_bytes;
> > @@ -510,6 +531,9 @@ struct cxl_memdev_state {
> >  	struct cxl_dpa_perf ram_perf;
> >  	struct cxl_dpa_perf pmem_perf;
> >  
> > +	u8 nr_dc_region;
> > +	struct cxl_dc_region_info dc_region[CXL_MAX_DC_REGION];
> 
> DPA capacity is a generic CXL.mem concern and partition information is
> contained cxl_dev_state. Lets find a way to not need partially redundant
> data structures across in cxl_memdev_state and cxl_dev_state.

I'll think on it.

> 
> DCD introduces the concept of "decode size vs usable capacity" into the
> partition information, but I see no reason to conceptually tie that to
> only DCD.  Fabio's memory hole patches show that there is already a
> memory-hole concept in the CXL arena. DCD is just saying "be prepared for
> the concept of DPA partitions with memory holes at the end".

I'm not clear how this relates.  ram and pmem partitions can already have
holes at the end if not mapped.

> 
> > +
> >  	struct cxl_event_state event;
> >  	struct cxl_poison_state poison;
> >  	struct cxl_security_state security;
> > @@ -708,6 +732,32 @@ struct cxl_mbox_set_partition_info {
> >  
> >  #define  CXL_SET_PARTITION_IMMEDIATE_FLAG	BIT(0)
> >  
> > +/* See CXL 3.1 Table 8-163 get dynamic capacity config Input Payload */
> > +struct cxl_mbox_get_dc_config_in {
> > +	u8 region_count;
> > +	u8 start_region_index;
> > +} __packed;
> > +
> > +/* See CXL 3.1 Table 8-164 get dynamic capacity config Output Payload */
> > +struct cxl_mbox_get_dc_config_out {
> > +	u8 avail_region_count;
> > +	u8 regions_returned;
> > +	u8 rsvd[6];
> > +	/* See CXL 3.1 Table 8-165 */
> > +	struct cxl_dc_region_config {
> > +		__le64 region_base;
> > +		__le64 region_decode_length;
> > +		__le64 region_length;
> > +		__le64 region_block_size;
> > +		__le32 region_dsmad_handle;
> > +		u8 flags;
> > +		u8 rsvd[3];
> > +	} __packed region[] __counted_by(regions_returned);
> 
> Yes, the spec unfortunately uses "region" for this partition info
> payload. This would be a good place to say "CXL spec calls this 'region'
> but Linux calls it 'partition' not to be confused with the Linux 'struct
> cxl_region' or all the other usages of 'region' in the specification".

In this case I totally disagree.  This is a structure being filled in by
the hardware and is directly related to the spec.  I think I would rather
change 

s/cxl_dc_region_info/cxl_dc_partition_info/

And leave this.  Which draws a more distinct line between what is
specified in hardware vs a software construct.

> 
> Linux is not obligated to follow the questionable naming decisions of
> specifications.

We are not.  But as Alejandro says it can be confusing if we don't make
some association to the spec.

What do you think about the HW/SW line I propose above?

> 
> > +	/* Trailing fields unused */
> > +} __packed;
> > +#define CXL_DYNAMIC_CAPACITY_SANITIZE_ON_RELEASE_FLAG BIT(0)
> > +#define CXL_DCD_BLOCK_LINE_SIZE 0x40
> > +
> >  /* Set Timestamp CXL 3.0 Spec 8.2.9.4.2 */
> >  struct cxl_mbox_set_timestamp_in {
> >  	__le64 timestamp;
> > @@ -831,6 +881,7 @@ enum {
> >  int cxl_internal_send_cmd(struct cxl_mailbox *cxl_mbox,
> >  			  struct cxl_mbox_cmd *cmd);
> >  int cxl_dev_state_identify(struct cxl_memdev_state *mds);
> > +int cxl_dev_dynamic_capacity_identify(struct cxl_memdev_state *mds);
> >  int cxl_await_media_ready(struct cxl_dev_state *cxlds);
> >  int cxl_enumerate_cmds(struct cxl_memdev_state *mds);
> >  int cxl_mem_create_range_info(struct cxl_memdev_state *mds);
> > @@ -844,6 +895,17 @@ void cxl_event_trace_record(const struct cxl_memdev *cxlmd,
> >  			    enum cxl_event_log_type type,
> >  			    enum cxl_event_type event_type,
> >  			    const uuid_t *uuid, union cxl_event *evt);
> > +
> > +static inline bool cxl_dcd_supported(struct cxl_memdev_state *mds)
> > +{
> > +	return test_bit(CXL_DCD_ENABLED_GET_CONFIG, mds->dcd_cmds);
> > +}
> > +
> > +static inline void cxl_disable_dcd(struct cxl_memdev_state *mds)
> > +{
> > +	clear_bit(CXL_DCD_ENABLED_GET_CONFIG, mds->dcd_cmds);
> > +}
> 
> This hunk is out of place,

Not sure why they are out of place.  This is the first patch they are used
in so they were added here.  I could push them back a patch but you have
mentioned before you don't like to see functions defined without a use.
So I structured the series this way.

> and per the last patch, I think it can just be
> a flag that does not need a helper.

Agreed.  This has already been changed.  But these functions remain
defined here along with where they are used for proper context.

Ira
