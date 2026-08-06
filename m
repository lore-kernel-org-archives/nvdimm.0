Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB2233C188
	for <nvdimm@lists.linux.dev>; Thu,  6 Aug 2026 00:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785976359; cv=fail; b=Guy72gdUZr15QXNk6zsF9IYSnqXAidyPYizpv+yJn4FQoO4f+o5bxuPBogHb1AUNRE3eN6hcDhmubAKd2DkapyJps1V2NQyNjQwHXWapl8U97jc3863O6WDo5qKRdlromF/xlqC0nmuBoCoL13wNXQWaxUU7lPw8FSfCa4e91CI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785976359; c=relaxed/simple;
	bh=UNK3ZkrcDC3UtjcLj7v4Z9MfTGnoV0YfATwgujQDhiQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TFwRD8RqMNegALN3wr/YHdz70Rj+lRddTQekvgeGPPQ+19/NuWmoZd7xIfvkELiNP3MEn+cOZY72XeSRVscn5vUEfBrrrSX93mkWLcZ1MbsdziIerwZrDoGOQT/BjbEGoeSX4F6mg80hyjCuollt/zHtxKO9BA95YtG5OQ8CQUk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JHSLhFRw; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JHSLhFRw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785976357; x=1817512357;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UNK3ZkrcDC3UtjcLj7v4Z9MfTGnoV0YfATwgujQDhiQ=;
  b=JHSLhFRwmbw7+peWP6wxsu6o3aa3IzRaaSGQOtql81l1c4wkRlKZE+e2
   omTB/B6mXx5eTC9HCWnYLJZVfMSnbWNDVAF8vlpNtVQ3/2+vXm7avWng6
   41VA57/tbK6/fYlSQjaRZyBxW7wPrAibvdfBL67bwuk9l5OnRIJZonOKm
   VcTUUoD2PDgiZAnGkd3b6/ikI9Xy/TaoiFa9BTspZx/xdHNCh53dK7FFA
   KvcqgobvWqmb6EZLdNaKERyG+vutJWBG7MpuumIkD0YkYyPNQLPIj01Y2
   vqgjLDBzN7zAfwQ3mU/cyC79cYq2PW1Z0BTnKLw4u5AATXarSp4HiuReo
   w==;
X-CSE-ConnectionGUID: NaKdCRpUSJqiueY5rIiM8A==
X-CSE-MsgGUID: ra64NnBOTVS+wM0IoyIzbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="89085702"
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="89085702"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 17:32:36 -0700
X-CSE-ConnectionGUID: 303Zbb6WRsi/fgx2Dljb+w==
X-CSE-MsgGUID: O8/Nj+LWTb2GRIo5ovoICQ==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 17:32:36 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 5 Aug 2026 17:32:36 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Wed, 5 Aug 2026 17:32:36 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.67)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 5 Aug 2026 17:32:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VwBpKrxuISBRwCbUHBrscyLlwQ7zrVUvTdt+tO24da0Oxn8sqtZABhgxAgvF8/4tiMHHr56Vk9DHHtphwSsbDLZzvJdXdhUh+lyW9N0QvnrCiMkoppC0l81qxxAwaGBul73nCcs5qoN50Xl6NL6VcNotngFTMolGPGePjtDa992uUtV3o7zhzMIZTKITw2jir6FPGH6i/bS0jIdYljvSdplEjQrBLA7wL9MhcXKOUFBr11y/FrNamn3iPxoTP5TpQ7umSNlsAwERHKu1hc5AmilO6GUQCGgDA5aaipSpAw17teEXWPFeOWJnxAgyuguHMqhLwK7WtLU2H0OB9Jns2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IZhf5OVJPCo4f7nceTGmFSvSzeGPKOoeG3J1QK5xIKc=;
 b=lfYJ3ZcAxRlnMjpNo0BUiQGL8ShZkN2JyqrGQVa0mCrejEnlYx0jsRv4nfdR1nhJHKCH3e4Cpa5GbuO3lGjpPIIWOqiQ8eCJ/gmjKKnZmqtqgywq/mewyNzoIxBsqczliHfVvtDLajuTNmSesoGaFrrAeJpClRnBZdzp+to5kYsb/j90YjZGcj574AKYOciiFWG2ekGOedIbpcgtA6NVJkbYhj6pTfJfJ/Mz/rUgq22t0bKi8ZA83VMYzANx4zwJgXOvvdzHKp5Gv/y5qRsaP3pwRzfFM4xtBqyj4+5+V+ZaEZZokcUTnCBVSmod31bsOyk7g6I5Ce5sTRnE8/Keag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SJ2PR11MB7520.namprd11.prod.outlook.com (2603:10b6:a03:4c2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.15; Thu, 6 Aug
 2026 00:32:30 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53%6]) with mapi id 15.21.0292.013; Thu, 6 Aug 2026
 00:32:30 +0000
Date: Wed, 5 Aug 2026 17:32:22 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
CC: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <iweiny@kernel.org>, "Rafael J.
 Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-acpi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI: NFIT: validate subtable extents before parsing
Message-ID: <anPWFspQOA-7ejmi@aschofie-mobl2.lan>
References: <20260722041701.21078-1-pengpeng@iscas.ac.cn>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260722041701.21078-1-pengpeng@iscas.ac.cn>
X-ClientProxiedBy: SJ0PR13CA0202.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::27) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SJ2PR11MB7520:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a4e2270-0dd6-4e11-04a1-08def352330d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|22082099003|18002099003|11063799006|56012099006|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info: 08TxnOBC2ROHmwkCu2n4fNMBqCKtqn4N9K1ZxxV8Lesj59Ud731ecr7aNPVtgyNfU2aVuCYFMOMXaJXbGFN0ltPMh7QIyiHXs79kk24zHyraAECSYbgmV1hnNMpNr8vQYVD55420O2vAAqi341mkSfGZcTRiYvaNkBLpDt3vjshIuSeNz4j5x/W3mpabd7YeFYBvhf0fOOAyux49EOQ5cy/Y5Ae1MwAerZ38br6AgNpIM+jVPHTqkIngY54UZQvnL33E+TshFn4sUiUTmmYjt1zM7uSzy6JQmf0SDbOXEoaRXZA7NijGxgohLDtwVLEvtwrT2MUxGGpWD5nCYBTpw/mvYLTEf4hXdY0jaM6nD1/9qMPARCvKlKnoqzBEHGxyLMtAcNRfO/qI4rVG8Tf8yl/mh2x75JXm2axt3q7U7wh9anBboCPTYxty6ZAlVVDRHQqP8rzNbOWIks+8owwulx0i6z9w/FrmPKZAwfde/zyN8BV3i4cIl1SDzobPA9f5z6vtnuP+NHekZR6BwD1eWm6NQ97gu8cGF9hC68vjlOETqwohXIFvCU3vz8RCi6l2Auk+V149vIc68kPZHhTwD4nsq2Q+eCLWVYZCQwbSeeSVBjOwN5tuGq75TYOVnHer+4pPZ1haoN8mSUUQ9uEVFM2LcquAtG2xS/N/yaTucQ0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(22082099003)(18002099003)(11063799006)(56012099006)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yTrpa57dyiI4cgIwlGzwh2m07jY6l+pQdrltiJLh2QEX/MUpbaT3Pm8aI+LI?=
 =?us-ascii?Q?khR690+n8TKoJVP2YtnMfIX3a1M51Twj+MROeK6//KSKDUFvSpcAhvH+JUk7?=
 =?us-ascii?Q?YZzPb5KklKm0qJNfVpFiQTFQXEOZSv4V+5ruM6oera9fZAszXwxBxMIV3ail?=
 =?us-ascii?Q?7kGRi5xqSJ3B6/TfdZ6dFtchRd1daDpjg0f0bDtNcKbsm949qG+SUaThyNXR?=
 =?us-ascii?Q?AXo70lbi2OjgmHOcSlFM4nq0/PSbWpj9yxoWzxVwZ+HxKondxeJ3D0MEX3TH?=
 =?us-ascii?Q?mV2Le3p1AJXhrFEcLqiL9nF6sIfsqXBQcQQXIlWAWAjfEgJ9xk36lgh4FJXq?=
 =?us-ascii?Q?9S1FRp49FxYLcbiuI4t503G1fbgukcXuEq+iMPPRX4BKcXBWnsjGVQ/yRq9L?=
 =?us-ascii?Q?g9hm6JUAXACp7kWhNJpLeluqbkLjSVdXFMDRlj5cDimSLsEWWIgiK5p1Z1Gg?=
 =?us-ascii?Q?2nPuqULKm4x8Q3i2nGPszloI8hJLFVRyQw6JAtLyAH5Dzj7JDdRTH5eDbgqI?=
 =?us-ascii?Q?V+GsTInBrmrW9jVhdSapyG9qD+AjviRYtUJIUGaNefG9MDPNtpO6dYl0zU1x?=
 =?us-ascii?Q?zGZ6sD2c9w+vMLMtmlHECpnDL+bdGJRr62C+x2/uhoh16YRdLgbbJIVxOvYu?=
 =?us-ascii?Q?D2GQyIC1gKc9weOQ9TcVapgi2zl0mHyeSV8eClteuSet8XEQw6d4Z8ldC9yl?=
 =?us-ascii?Q?OOYJ9cnxuZQLviRnc+kG57q0MmhN2MLhuxPgYwrtwugfEaTINlsfO3vcSw7R?=
 =?us-ascii?Q?j1Ksp+nWdttOxbw8qWlT0yRmSfcQdkziNGZS6xeAp84kBEy9iZ5dHe2Tasbj?=
 =?us-ascii?Q?9Rz8quq4wLgHLg0izS7/9M8MbzPVK94Didzts3BADg3cn/a8Wp8pgapFR6p5?=
 =?us-ascii?Q?Y0mm+vfaYXZxiSnaKBnqnfr8jQ38oLO3yzAlpt5Nd16bTiJ7eaivZwN0LAOn?=
 =?us-ascii?Q?gRvjKUunkI5M25u54OS0fPIlzVRQH1hMNwKTTzpPq+yeNIj4mEscO4cxgC4Q?=
 =?us-ascii?Q?tYTmfHrNZ5ZQ00m8MrFs5jIZbWGLRaLBzD2V5wUOxDTYqmDXnGM9lrNN2YtZ?=
 =?us-ascii?Q?4q67rTcmsj+Sod40urjmTpl+DXfubT7VXbgQMjtM/dM0AbDw4gZYBfrMClIy?=
 =?us-ascii?Q?6DExYFQgAUwIRSIzOIGKZpwHVPbcOv51aaM75ppYjzWDfkdeyBgI2dsOnMCV?=
 =?us-ascii?Q?n9Cuw452r6xJZuPZTc+juxtPUYe8TcElqdS6RX4qetd6C1vNSjdUj9UIY4gj?=
 =?us-ascii?Q?1ZvR33VJcTcaElvSRL3/fas1PuTwhuR5iZTaXjX+Pxunoyq2bBEp0KZ3cnRg?=
 =?us-ascii?Q?R5JDxQ196Yx/MYqvGeccHsZpVocZVg3g1REyDaby8d3FCZC0ud4iZQSDO8rW?=
 =?us-ascii?Q?72zmPx/sNQwRN/SbgpbX+704lv1G/5h8tmbiKVngunruAtChh+k+fpVZRH6h?=
 =?us-ascii?Q?D51lLAviIJn9dsPFXmIfowDN5khrbsnrwWyt4YX8PXtwQ5usmeFFT+b5bMaa?=
 =?us-ascii?Q?n2YRdaahYsylVc6RrOKFWJS9oTggN2kVNEvviihuozQ5IicHbxJ5Roh3V32q?=
 =?us-ascii?Q?N8Wne/TDqIkA4flzgl6Zh5Q4rRaA9+hdgAp9q7yWnhwQvioHl6VGzVISpWLe?=
 =?us-ascii?Q?iUDC1Gp1f5Xi0quD/4kd+fJoG1UJ+Ze8LSSn60j6W/LlW1AvC3qB2rM7qMjg?=
 =?us-ascii?Q?E7zqVEnWndZZxL47Vi/d8BrktKrl8NdFmZuOeIO5yicbWJPKVGCGRyyCJfr0?=
 =?us-ascii?Q?cv65FbjEUcw18vSxcV/OMCn+o3cBoh4=3D?=
X-Exchange-RoutingPolicyChecked: eUO3GpG5+ATMJztqzIJa1DLMoHNrKPFgPnmtAwpcv6Ep5XDcInFEjm1mTif+VaUv7xjm1ducC4jR1Rsc4EfUojkA21Ve4Jm3Ww39LkrwL1qEvlZjHvDALnck31dSbn1CTwrlLb/1QWGC82hUPji2ADdJm3dm5N0xxsC/kKorZ2m1duoFk/ggfELBkvNEkhaIDaYphMuzvjShdLrkj9mrueXF5f+VKJX9x6e6cdAC9PJberuH/YE4PAIHo8Zbpg5jl8Erg1+0+uHseovC+xNqVR4Llz0qZD2lNJKu/waBq/1W2I0TjEaWfSIT+blOYXLe3vCMXZvDNQ6gOQN4aYFDmA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a4e2270-0dd6-4e11-04a1-08def352330d
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 00:32:30.5184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rq/HM54xMEfjWqvEgT55gZuVbZVoy3XX8CtoLLF2uGwo1rPI1+mCL+3x7QIijlsUwxJq5emL7vHGmWNMsfn3vJZ3o1khqSbU54+R2hcJwc8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7520
X-OriginatorOrg: intel.com

On Wed, Jul 22, 2026 at 12:17:01PM +0800, Pengpeng Hou wrote:
> add_table() reads an NFIT subtable header after checking only that the
> cursor is before the end of the table. It then advances by the advertised
> subtable length without proving that either the header or the full
> subtable is present.
> 
> The interleave and flush helpers also derive copy lengths from entry
> counts without ensuring those arrays fit in the current subtable.
> 
> Validate the fixed header and advertised length before dispatch. Ensure
> the variable interleave and flush arrays fit their subtables, and prove the
> SPA flags and capabilities fields are present before reading them. Reject a
> capability index that cannot be represented by the 32-bit capability mask.

Hi Pengpeng Hou,

Above the commit log could be a little more precise. The new checks prove
the SPA flags field and the platform capability highest_capability field
are present before they are read. (not a more general 'capabilities fields')


> 
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> ---
>  drivers/acpi/nfit/core.c | 43 +++++++++++++++++++++++++++++++++++++------
>  1 file changed, 37 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index cb771d9cadb2a..711ab639cb147 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -705,6 +705,10 @@ int nfit_spa_type(struct acpi_nfit_system_address *spa)
>  
>  static size_t sizeof_spa(struct acpi_nfit_system_address *spa)
>  {
> +	if (spa->header.length <
> +	    offsetof(struct acpi_nfit_system_address, reserved))
> +		return 0;
> +
>  	if (spa->flags & ACPI_NFIT_LOCATION_COOKIE_VALID)
>  		return sizeof(*spa);
>  	return sizeof(*spa) - 8;
> @@ -868,9 +872,16 @@ static bool add_bdw(struct acpi_nfit_desc *acpi_desc,
>  
>  static size_t sizeof_idt(struct acpi_nfit_interleave *idt)
>  {
> +	size_t size;
> +
>  	if (idt->header.length < sizeof(*idt))
>  		return 0;
> -	return sizeof(*idt) + sizeof(u32) * idt->line_count;
> +
> +	size = struct_size(idt, line_offset, idt->line_count);
> +	if (size > idt->header.length)
> +		return 0;
> +
> +	return size;
>  }
>  
>  static bool add_idt(struct acpi_nfit_desc *acpi_desc,
> @@ -907,9 +918,16 @@ static bool add_idt(struct acpi_nfit_desc *acpi_desc,
>  
>  static size_t sizeof_flush(struct acpi_nfit_flush_address *flush)
>  {
> +	size_t size;
> +
>  	if (flush->header.length < sizeof(*flush))
>  		return 0;
> -	return struct_size(flush, hint_address, flush->hint_count);
> +
> +	size = struct_size(flush, hint_address, flush->hint_count);
> +	if (size > flush->header.length)
> +		return 0;
> +
> +	return size;
>  }
>  
>  static bool add_flush(struct acpi_nfit_desc *acpi_desc,
> @@ -951,7 +969,16 @@ static bool add_platform_cap(struct acpi_nfit_desc *acpi_desc,
>  	struct device *dev = acpi_desc->dev;
>  	u32 mask;
>  
> -	mask = (1 << (pcap->highest_capability + 1)) - 1;
> +	if (pcap->header.length < sizeof(*pcap))
> +		return false;
> +	if (pcap->highest_capability > 31)
> +		return false;
> +

Does above break forward compatibility, like future FW
advertising capability bits beyond the 32 we implement now.
Maybe ignore unknown cap bits, like clamp to the implemented
mask instead of returning false.

I looked at Sashiko's issues and will respond directly
there. I didn't think any were in scope of this patch,
beyond this new return when > 31.

-- Alison


> +	if (pcap->highest_capability == 31)
> +		mask = U32_MAX;
> +	else
> +		mask = (1U << (pcap->highest_capability + 1)) - 1;
> +
>  	acpi_desc->platform_cap = pcap->capabilities & mask;
>  	dev_dbg(dev, "cap: %#x\n", acpi_desc->platform_cap);
>  	return true;
> @@ -963,14 +990,18 @@ static void *add_table(struct acpi_nfit_desc *acpi_desc,
>  	struct device *dev = acpi_desc->dev;
>  	struct acpi_nfit_header *hdr;
>  	void *err = ERR_PTR(-ENOMEM);
> +	size_t table_len;
>  
>  	if (table >= end)
>  		return NULL;
> +	table_len = end - table;
> +	if (table_len < sizeof(*hdr))
> +		return NULL;
>  
>  	hdr = table;
> -	if (!hdr->length) {
> -		dev_warn(dev, "found a zero length table '%d' parsing nfit\n",
> -			hdr->type);
> +	if (hdr->length < sizeof(*hdr) || hdr->length > table_len) {
> +		dev_warn(dev, "invalid table length %u for type %u parsing nfit\n",
> +			 hdr->length, hdr->type);
>  		return NULL;
>  	}
>  
> -- 
> 2.50.1 (Apple Git-155)
> 
