Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE52CA64
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 23:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709766234; cv=fail; b=hLpxH7srDopGiXH19OkjkcoMe6+gqKkRuvIiPzGlSpqBb9oMVc/tyLEm/4wDUFSQS+uw3rWSzsQtI+n2Ubom57DlsGGejjsWFYMf9w4QcDjiQTmNki+WkvgExdMdyx/gj+OxYHd9dnVnNPBcFWAiBkrqtLQPt3ei17oyVhybwh0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709766234; c=relaxed/simple;
	bh=xrl943O/N9OhRFENwqyuZ7zRnutP9C4P/HKrHkJs30M=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=f00a0WN6lBFRbSGTXkAXFJOCZcLhjho6l4qoVva8iycwL0AZQlVNqvwKC4kflqGeqCrAd/3/L5yXiyyP4X/UwUFgQcoIrWsnsXR3tAYlVc3EptQXbQotj2uwvS149sewrZBNpuQgUuOjOOhT099kPmaxZh8pCucvoyHX6lGcICM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D3t2f6xy; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D3t2f6xy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709766232; x=1741302232;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=xrl943O/N9OhRFENwqyuZ7zRnutP9C4P/HKrHkJs30M=;
  b=D3t2f6xy89mR9V1i/nPnx6SxlJxHUrsxVEGYmix5mBY+E1hXzWGRDccl
   Da/7UR6JcM2mg46frLnLBdeIrNDxwDE+CEZ4YaC8AEZgBPMzrLJtgiYjT
   Tv99zeFHJiaaR5SQkNnxhcZkdTbi0MrUtT7kRj/ck3sh8z2oT7XEMcMi8
   cNWMD1P7EQ14/cKaYkuqry0Uh64lXueiK0dd1vPCB5bmzCGTjde6SQ+qR
   3tCw/OzbmXHhfPt1rZZThc8LLEZLI8DPiVvyL5gRxw4DtAffujzN/BtLz
   GZwXavBwFn9s1eue/SsC5Pp0GEFDvYjJVkbkKXxiZeITlRij4Qkn3bUu2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="15849222"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="15849222"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 15:03:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="10071824"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2024 15:03:51 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 15:03:50 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 15:03:50 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Mar 2024 15:03:50 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Mar 2024 15:03:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g2QfZn3GDybTEucP9XZeOWqwNF22EWIc7v/Dfesdclw3PNbAMjrE/QKGXQyhkYV+OTnHQHeq7++x5Xi8MBL89UROy157vBWsA1tMz8BAqNZIjxHg2i9plAFqWPv24eQPTPVryHUWE4fW6TzEXiHaVyB8k1Avr4O+Gb5R6zkhSAC+Dhu8E08S8MRIcCjnyZDV+XJPu6YwZ/pGpJL1fzrJNMqlgfYX65SwnzTFgFEAzuyOTMa/6yrks/ZJYPxd1Z4v/o5gKEsqN1vDU0DtUpRRkPU/vROYQ28ZJaDNCrEIkORkauqBOoouJg8Vfwivm9DliJttr3IAJIVj5z+ICNx4cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wl375/jFi9Clf8VauNGJ4KKa20DbEVeB34idbjhzEKU=;
 b=Dq5UpABw7+GYNG/4HeZKxWuahPghrfPYdUVO3oD1FKDb3nHps56VHgSUL+Of/bZncSLzFqm4mpGnsXww4yZNj+TZ3Wq0+Q9gL/XQTHY27o872uL1Kce33CVVoNZZW0Y2Ax0UDTqZofQCPpIGvRe/bJkqQL6YP2uqlJ211xJ0bZTboKLWR8TEwwiyU+6cOl2GvQPZr5wGYchb/r72hFkHIc+lk6oUAGsDNzvagaRCjmyHvdkXtsG7sbgDZDAgryc0KhSqIoLDRAIu29lIzZbIqdchPKwmAUmQXEUEu2ru1JHOWgfzXAR/nHiPxhs+I4z0ooRYw1WigEo1LKTc9Q+f1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by BL1PR11MB6051.namprd11.prod.outlook.com (2603:10b6:208:393::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Wed, 6 Mar
 2024 23:03:42 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71%4]) with mapi id 15.20.7362.019; Wed, 6 Mar 2024
 23:03:42 +0000
Date: Wed, 6 Mar 2024 15:03:40 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
CC: Alison Schofield <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v10 0/7] Support poison list retrieval
Message-ID: <65e8f64c6c266_1271329483@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <cover.1709748564.git.alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1709748564.git.alison.schofield@intel.com>
X-ClientProxiedBy: MW4PR04CA0218.namprd04.prod.outlook.com
 (2603:10b6:303:87::13) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|BL1PR11MB6051:EE_
X-MS-Office365-Filtering-Correlation-Id: 88ca9c8c-4017-4a58-ed8f-08dc3e31aaf5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6FkKsfzp3OBBFwZ/CYFhf8giz11UoHrzVMvr7L8EATnsD/1Vke7yPcBY9Dw1OdzRysDq5lYDS/vh9LME1qIpYhBs5xK//4xcAzG5at/oh+T7aOXubwRsHbqZxkdBG93JGV6OXUDI7DhMrKa2gN05vYPQqd7EHBbM6Es5CxEGQ8w4DdD7deghdaVuOErc0wSFROtuNyiMFq5iCcYdxbzcqYjJ+4aIq7h+BAxQ3YjIfq1D/AKqmKS0MRrTy5NPPRyjjzblXD+OmAcMwUu44Nmy8AfCvKwEb+ipFPGLpXPQ05rIn6/DjbZChjJ5khrKJEGK8l+6VC4ZuNqjDOPm1UY2hwy/NFbUOAtHyV7EK/tRLj+dkVu52HitylAh1uziqYfxr1kEeH8pJ3GWDvWvtp4PpVg7tSG1ti1GNxRODgtM7jReZ/cMvsVOmc4UjkCWCV1P1BuO7idMoS4rxNvYhKmn8EyWgf8XNEuOfU7hAjNTdELp51StzJQATAIkxw3Vis+7ks82XtZcJjoYImm2SKAgwBaZ2RrpF/Xnu8qH97ST9lcftHjwlZ4RZihxwO2JFRkwd8XD1UHuDKTQgYLu+b2nKWIjNSlgWsOFNUchMSayrqk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HiVPCkiDjMexdjjh46uIgPYy9QcWYsKeIqMxTGlqysngJwdgBWBrY0heLCet?=
 =?us-ascii?Q?uUBSOQpHMN79jBbOsF+CO9A/ff2PlqL7107WZBISgaTkg1CzDUYcNKYQ0Y5a?=
 =?us-ascii?Q?lgiv/mxwyqlbynz1f18GRxfWSrySQ0XXWjKiyt7goXlCOqJ6dJfDwpigxzw0?=
 =?us-ascii?Q?cjjmaQ4nAHppHiT8ppmaQw71ORmr6pCfUQIkGLDbItoKkGTDSJr2GEacFmqN?=
 =?us-ascii?Q?EeXBxBGOyLNnZdZsgWtjSx7Sn0X2vL5xxV1MM5+XenkbZP3ATt4p7/ldaDQQ?=
 =?us-ascii?Q?5jzdQAqnyHf5a59WeOH64Gqiqn6ICYHs6rAc9suOH5hQ2hRMqv3FnuMrT9un?=
 =?us-ascii?Q?I4YAYA1EU4NolAPTGelZWBR8xNFgBbKRjBDB2O03kRFQ4ckqZncqg5J8JBvV?=
 =?us-ascii?Q?8ugujCMmkmu7bsh0/NbogoVEyIUgFZRNjqfOFhRTfSnYG0XCn+ZGlHp4DzG+?=
 =?us-ascii?Q?WZCh1mrF4eY5T3xSJdgoSoPbQB3RGDTZN3z4ZjB/BfXOGFdYxDnJuBAUlBuR?=
 =?us-ascii?Q?mII3+P73MQtCWcW/Up+jM/iYHpiIHseFa74Os+0emE8MoM0l70ifUtlU7xW8?=
 =?us-ascii?Q?YmRptfgPaUfrSFsPSFGPI05mRneY8i1OSfySzc1HbR8/UfQXTO0VMYuibYHw?=
 =?us-ascii?Q?sUd+g+htAOAf2c8T1jcBSaJ7DdX7s/nepzuFIGoXuVsXRGnXe5sAjCXxLgxl?=
 =?us-ascii?Q?O9ys1izPteGCAUJsU7d2wEDpMxrgkSb7AhVK54ZSDLZk1v7QLbZ6cXeSwBr4?=
 =?us-ascii?Q?rr4eSxg1u3h1pjQyf4Z9dLeDC9iLKlzlJZq6xhcwjTzFBY4KtqUKV7PO8Pp4?=
 =?us-ascii?Q?K4v5s12s2v5Jf5pdh4spuFtguh0G8Xu06WXCqwvAI8ky4cZtO8s/fuJYhMdn?=
 =?us-ascii?Q?2KnxEWoK0M84ljxe6BNSdzatLZtQitjQJnlzg13aBis1vuAeLoYYhp5N8DvE?=
 =?us-ascii?Q?g1pZPIx06sL7b8fDBta8Duk/s6Uy879NOV/QDemQwbG83ipQEG/eVvpIXH1J?=
 =?us-ascii?Q?wfyG67AIFJIy0XeIZXygtlGyMUbgEaaW6e7x/Gvj9o19l3jArtNPLd5sGeS7?=
 =?us-ascii?Q?lHry14pjBFd5WYY+tXaV/KrFPFMvyie5n5EhWzywSxPPMVVRyqiVzAq1iVB8?=
 =?us-ascii?Q?8XvOPP2SNm0dVKA1sUCrIo4tFXSiK45sNUXz5c/tiSZPsb/5ImZ9jHAH9Ckw?=
 =?us-ascii?Q?9tFxfzsXphkyrpQKNT9z3WgXAwfmSE2yEUynHCuGbnTatG9g6+vzUCDywcIH?=
 =?us-ascii?Q?y0wtUw0XOCnf+GbkHxgqZArubvADLai42QsyVYUccKTXAuN8coAh+9ZHcTuI?=
 =?us-ascii?Q?TLNDD4DXPoHZYsslS+wdRo4dcf+/eYn2wrNMrTm+qjp9TE8+1zG6De5ZtfNI?=
 =?us-ascii?Q?EZ+XSpyivPHA2bF1yUqoNeMuqQdP/RdBrx+D634NkZDo4NCUUJDEnPTQz9I/?=
 =?us-ascii?Q?xYqZdRrytpehVESzNWgH+IqyDzxZu3Jk7r+6oxgeli/a04J7yLGW87+EG3w4?=
 =?us-ascii?Q?/5YglcUVHUol8VwRmDv9C+q2Vxoct32ce2eUSIX3vMZ+9Vz9c9YYpBsD0hi0?=
 =?us-ascii?Q?/0A3w/hUohJPgNfBNhheeFrAFmaIme7HnyzN+IN63ZvMLjGiHL1LaMIrwsmS?=
 =?us-ascii?Q?Jg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 88ca9c8c-4017-4a58-ed8f-08dc3e31aaf5
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2024 23:03:42.3431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zbjk8UeS99VWKvZz5ERoT5x9HuqC2v9oZpMBjCVoypycXvCURBIXgzuus/nIpoYC4UpTFmfRCkOJD4/Yc3ZLIbc1gxx6T7L/8eFXphUtpsw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6051
X-OriginatorOrg: intel.com

alison.schofield@ wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> Changes since v9:
> - Replace the multi-use 'name' var, with multiple descriptive
>   flavors: memdev_name, region_name, decoder_name (DaveJ)
> - Use a static string table for poison source lookup (DaveJ)
> - Rebased on latest pending
> Link to v9: https://lore.kernel.org/r/cover.1709253898.git.alison.schofield@intel.com/
> 
> 
> Add the option to add a memory devices poison list to the cxl-list
> json output. Offer the option by memdev and by region. Sample usage:
> 
> # cxl list -m mem1 --media-errors
> [
>   {
>     "memdev":"mem1",
>     "pmem_size":1073741824,
>     "ram_size":1073741824,
>     "serial":1,
>     "numa_node":1,
>     "host":"cxl_mem.1",
>     "media_errors":[
>       {
>         "dpa":0,
>         "length":64,
>         "source":"Internal"
>       },
>       {
>         "decoder":"decoder10.0",
>         "hpa":1035355557888,
>         "dpa":1073741824,
>         "length":64,
>         "source":"External"
>       },
>       {
>         "decoder":"decoder10.0",
>         "hpa":1035355566080,
>         "dpa":1073745920,
>         "length":64,
>         "source":"Injected"
>       }
>     ]
>   }
> ]
> 
> # cxl list -r region5 --media-errors
> [
>   {
>     "region":"region5",
>     "resource":1035355553792,
>     "size":2147483648,
>     "type":"pmem",
>     "interleave_ways":2,
>     "interleave_granularity":4096,
>     "decode_state":"commit",
>     "media_errors":[
>       {
>         "decoder":"decoder10.0",
>         "hpa":1035355557888,
>         "dpa":1073741824,
>         "length":64,

I notice that the ndctl --media-errors records are:

{ offset, length }

...it is not clear to me that "dpa" and "hpa" have much meaning to
userspace by default. Physical address information is privileged, so if
these records were { offset, length } tuples there is the possibility
that they can be provided to non-root.

"Offset" is region relative "hpa" when listing region media errors, and
"offset" is memdev relative "dpa" while listing memdev relative media
errors.
