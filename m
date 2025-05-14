Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3982750E3
	for <nvdimm@lists.linux.dev>; Wed, 14 May 2025 19:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747250488; cv=fail; b=oYDUiyRletwbeqnAx8pqX+qsu/C7xH1zTspRgDWbaFP2UL76dZiVfpQLs3Cfvix6MP3CvVk3Z2os772kYn48E+TpbU7Dsi7Bkuapa+RM6hd/653UsBDBgriSlZA1Id+JtDGJ+fdh9LFyCmsgWcH391+ePtVIuQBec7VKBtIdqeM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747250488; c=relaxed/simple;
	bh=jK89e+ywqjvwPOwA32HaEzwovMuDzsO8Tvz3s7RkpHY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rQUAJRUJjHOoJAu+gRLymFRevllfYBbh9PgX+n9/VnQClWvHDVJEngopbCqeCohZB4Bzfna7y4yP0hHaA4WNbeh9Ulq16jFRLd3R0sxFTLukN0G7cRD0f1H4vmNiUwzJUEji9qWytD7xg/rMaVvj9SfrKVe8K64DUrDjdWcZDts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Di1LFsrB; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Di1LFsrB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747250486; x=1778786486;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jK89e+ywqjvwPOwA32HaEzwovMuDzsO8Tvz3s7RkpHY=;
  b=Di1LFsrBHy8wM+ZUVPZX6DKH+0kZIkkp098v9Co55df6gtCNSvXwV2DA
   /aOw2vuZsSZCZMKOBuGu5c13AH/OUKl5xtZW0/5sqrlIfPN9EjGpf+aff
   wbURWVBN71eEv8oGr3N0A+nr1i3gQKgELRUZAQVgyCujuQeUlzAGZ5lOF
   /TfyM+ZtlDUwZLvVYZWgS+gVyZrgG5FDzEcZ/Qu2TCDemrEB2fQsS8l04
   VxL5O9ImZ6zMZ6pvAUkX0O0PVg0CDxgR9/yDO5ukEAFg1gniv5FJHgzxm
   C03Kel56Wfj0jHCw5P8NSTLUPHhw6Bgrqu996BOVMUcvAHB9PNlDTCe3N
   w==;
X-CSE-ConnectionGUID: vr8EBFLhQD+S+wxqmqcJkg==
X-CSE-MsgGUID: dRr0M4rpTAuUgwmPDiZDEA==
X-IronPort-AV: E=McAfee;i="6700,10204,11433"; a="60567822"
X-IronPort-AV: E=Sophos;i="6.15,289,1739865600"; 
   d="scan'208";a="60567822"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 12:21:25 -0700
X-CSE-ConnectionGUID: lvnXWQ1jTomy/0DmnkB2Sg==
X-CSE-MsgGUID: 2mOdM5yUR4G1SdIZzxkO5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,289,1739865600"; 
   d="scan'208";a="169073489"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 12:21:26 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 14 May 2025 12:21:25 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 14 May 2025 12:21:25 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 14 May 2025 12:21:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DC20Vj3eM/CT4DGqH+tTrVysgOsKxXzHUjqMdvnhyacC/z0K/hHGXq/0V5QxomUhj+Dh+3H5DZItmlfPsR6x4oX0B4MdCp5dNwlEhGC/XaPXmYfdnQMc7SBPmH18V5E1AxyXABpdk7fspVDO9NUdvLkbF1CQQcviVHjU6H52MWQFhJoeIsifAV2EpmHZ3IeDop0ayN/ltdQs7w4ZFrSqcJGI0j/9mSaqYGteQKLceEol1srDvxb3329ymE0R+B5lUp/rEXNgXEhNtRg8E2XIYlXtzV1AgVSXAY1JgKc0veB6AqHHQnsEZuJRoiPOBSDwp81hb7wqLH+WZU3F06+r7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R1pmWU8FmzYwbHF05N/ZVPjgiGCk6CXkrWVZ85ArCP4=;
 b=y3Df2uaGAPVlWiIWf7jN3J+bgSICXbZ6aXqHsW/dwYKX1K/mCxZdfXbkVA4IevjxZOvsWMBGGWGiisOMhsYNI+9p7Of4qrso/UsS0b6tmcT7TRwiEq23tpBaT2Ru0nNctnixhbT3AZfDTMEe83z1fcU8kUsItdndz25hoUhUnDZoH3slKvGpmAMRcIjlAKCu294zAG+dMRAfdjEQxzWL/76fi1mMPW9CYzJHs90GwW9nZu4ee93RWuIszFzHHuUSgq9deUQjew03L/NuqiZGRpv3wZubXZ6waNesTHYmsdnxO5Ky+WvP/3oTW5LM/5PbNS1FsTfOYzJ56nvOaiK6Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by CH0PR11MB5315.namprd11.prod.outlook.com (2603:10b6:610:be::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.31; Wed, 14 May
 2025 19:20:55 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 19:20:55 +0000
Date: Wed, 14 May 2025 12:20:52 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
CC: Dave Jiang <dave.jiang@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [NDCTL PATCH v2] cxl: Change cxl-topology.sh assumption on host
 bridge validation
Message-ID: <aCTtFOKwurphnMOJ@aschofie-mobl2.lan>
References: <20250508204419.3227297-1-dave.jiang@intel.com>
 <1a69ac7c-7a8e-4351-b07f-642b39208c84@fujitsu.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1a69ac7c-7a8e-4351-b07f-642b39208c84@fujitsu.com>
X-ClientProxiedBy: BYAPR07CA0084.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::25) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|CH0PR11MB5315:EE_
X-MS-Office365-Filtering-Correlation-Id: 68fe4943-6d20-4a48-0f22-08dd931c7305
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?SbkHNErG/KG7DTINxIHMZoA4xxPwAo2mddg/ppuKBUj4kWhHDra307nOMD13?=
 =?us-ascii?Q?x4/9p789EoI4Fsu1owIuEzIrFZyO2KeKjyTu2z2RYadIQDBOMbUENAawSIgy?=
 =?us-ascii?Q?7vLMqgD04QOvfWLUnacC0mDdkuwI4O4qe7KHsijYK02ip7cIOUYUUEcTENR4?=
 =?us-ascii?Q?uPWcqQMLGNU6oOXmV5Ebmz9ZDuXNyi52XOeJirgxpUoAeD1COcL57tSZltRI?=
 =?us-ascii?Q?DiSz2ISxWJcv+Co9VQLqhwW/cIF1ZX9QEQa7Ggusu4JVzDJS16z2ZYlSyTXx?=
 =?us-ascii?Q?fk31ln/nsHhk4swdFwQ00fxEeQVX4EE5wIwv6Fk8YbJCtN+5qVvkTRFl02wV?=
 =?us-ascii?Q?qPF3vf+q5fi+gCfpfS6MeXfe4kgSenDhnKGMTvwwRtoTEuWXRY+pIX1n009P?=
 =?us-ascii?Q?xmrgFw+tNkrfUDjYCQd7OG2nL0rs6OaOe53I6UL+6WsEPf/kKfehqYTfAyGd?=
 =?us-ascii?Q?IQRPl7/chpbq/pzzHnhITVlAhHJmhUnJNOyKWEddh/LfyNtIwWNelEAZvJqA?=
 =?us-ascii?Q?QQfD7OgRj9EBX54nWmicr1oH5lmFwnAHonRn5x/bsO5L7euz3BMixgoOFisu?=
 =?us-ascii?Q?CDXvOP63r2zQhKSDlNHvmxG1EyjZ+g25FO2oU07H96M3wFPnVWuJTgeLBCPd?=
 =?us-ascii?Q?1srKs7P0tsjNnQpd7sFnoBWijf1yvu+IYMMazAPwTDibwOK5q5DFTOqlMrvw?=
 =?us-ascii?Q?umQ6AMFwnWX65iWepfoIUuy42k9Y0LxSJEQr0OvzbBSb9E8KvX6/64FtqFWM?=
 =?us-ascii?Q?aERXjW22BFs8jRGU6JeFU7+0pZMNyT2eiLIZssBdzmUs/dFdrbZfX0R5XmH3?=
 =?us-ascii?Q?VK3ls4j5H83UFY5QFOl7vfVoZJAlva/oU3UPePEQVqcY+Mspv9aRvZq3AuOd?=
 =?us-ascii?Q?Gy/8MjVKMKm2In7LTMzEtdy4zv08lLhus+jyyAQlNW/ZW0XLka7DEFxCRo+T?=
 =?us-ascii?Q?8xl9N+vEEwQ9QG4zILfRQh5FNr5+PwVWn+/nvgaWrP/FQ/OnIrqqHqHN6xEC?=
 =?us-ascii?Q?OCkskEjhv0EFK/5LLx8868gFwS6SfLqQQswwdjQMZpZFRzpZ7fEKcv8EbRuX?=
 =?us-ascii?Q?TgoMwnadshPD5+Swlv9to6kppozkRr3sAeB+/cPtP6/uejhwwgFj7Di1DgZk?=
 =?us-ascii?Q?inHx3Pq86mt5KgglZYU2o59U9hLjcrHBcmNu1EorfcqFfHCA7/69KT5iDjSO?=
 =?us-ascii?Q?CoBeWpiEZBDBSQQ6CG9jUi569ykpkOrJ4Yve9gXxM0/oKU6BrSPWLN7fl1h6?=
 =?us-ascii?Q?GX+AQHzSxBdG5q3ZOBmp5RA7xz5zg5I9N8k81FtwQoj2ZOUIiXtNnqS6fflg?=
 =?us-ascii?Q?PBeuT6iQHqeCwn/LOTVTgYplmyM9hZPAiEeKtwJh1RkvU4Na0S8Vhw7kvs8B?=
 =?us-ascii?Q?YvZzX4o3NS6lVEmif/V+EYf6SNm3r2N7STc8SJTRWSTiiyi0t2NJYac7+yVZ?=
 =?us-ascii?Q?z1YgmVrzIIg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nOEFnhNnACh3t+R/hR+bH/v5pWYbt70IW12J0eQ9fa/V8CVsFmCD7P5RRZjV?=
 =?us-ascii?Q?QKdxt+JQT3jZYDFsAPmh05EGvI5X4HPA0m2+zIxJ7Fs/sLqVY9Xy2XLOW1mA?=
 =?us-ascii?Q?IUNMHLEz1Gpt1PSnXpvFyA7B+FxZOa8h+ZrYregM3OxtZ0wC6S/LD+YU+oai?=
 =?us-ascii?Q?saQBVKA4cEN1FSgF6giKeOesYUk7//B7NPtMNaX27G2ikx4BQxtWGQxo+ELA?=
 =?us-ascii?Q?SizfPEi6sBXlAqi5O2ti4DZ3YTK12D97urGTIRkjmMPMJF1YK8BHW6dnrs62?=
 =?us-ascii?Q?z9k63oa4v5RmocBORR0WAfITMHeaaCH5GTcaQPU0ife8ScnZ5e3AgNK2W/EX?=
 =?us-ascii?Q?ZGf9yPmxGSx3v/7R4vn+e4HazASP2EIKANFFmmfTvXm8TjJSFv6igqjQQH8q?=
 =?us-ascii?Q?ir1Tpo7vxxNS+RyFfIdlXP05ziCok2c+df/YxRL5gVoAF4SHdnWgLnvqdjm1?=
 =?us-ascii?Q?nPR5ILlDlFiaOr5ydh1zULuRaINk6/sLbdrBjQlqdZDmttQRB0bwJCHNDApB?=
 =?us-ascii?Q?PHF1QmPOYS/pWAYiTOhxhOajWIB8w6pFOyWpjxLKHSjJ+ldKCoBVgQieEedi?=
 =?us-ascii?Q?uRsBmmXQfleYp8EdJf9pQOntxq1Mhm2R7GunieOslS4HYCY3NCZlJaTjjyfP?=
 =?us-ascii?Q?0EaRXusAsjAU48epqabS5GhmH/hhza37RPeLIDpZjBj1XASww6s2EOLh+Lsw?=
 =?us-ascii?Q?1cV/nsG6Nw8+ly6uxrqUaZNtEKCIO0ZUrQ0bI08srfVXxHqh9+QxYlb8Bxyh?=
 =?us-ascii?Q?9U0ISD9yFSBItbKJRANUMNX/N1PdyM37FDu6sta4zwKJfFHofsXmLdLNWbC0?=
 =?us-ascii?Q?v97W1HGQV+nCPtDm97hOp6WGCZX309ntgGWAp+yc7wjKEy+sD7F6lPHwbNyA?=
 =?us-ascii?Q?rkak2jAZ2h1OBskI591JlMW55hPwRndpkqlFFZAWK6F0Xqy6QKFnR16TXBcK?=
 =?us-ascii?Q?8vQHYnbhqnYb/SgNqcTxKxP49u8habpiLaNJWCxyXEXjXGxM9Hjf/aciTi5f?=
 =?us-ascii?Q?wzCUjw0WpolYuqmtRrmN2r+mvhjnjUjhXKawoXyJUTgnekruZ3atva0ro+Eq?=
 =?us-ascii?Q?vrPq8y9Qskx9sLqoIL3qkR8k4UITCdrOkn4SW9J6UuBh67JgnyswgGRInvX3?=
 =?us-ascii?Q?3GaKg014WkShZWRPT/SY5cVTb+bwC1zsiK3aa/ORNugc7z4jbbiikbmv7c0V?=
 =?us-ascii?Q?P/yqDkAXG5dauyp5isheGPxnPosLUmsQRhTriMSt8muh03T2GcW910tnVVx9?=
 =?us-ascii?Q?mvZFbOjEhIto6SSukdWYxUxM201ljjm+ofE3rqYjaxDiWeOhwXy/2fZe9QEd?=
 =?us-ascii?Q?017/KbhsozYDOLfH6+MtouaAa56aLGP0kFU8M1SwERdghM7EFgJ+xlewG8KJ?=
 =?us-ascii?Q?IL2vIagA1AxP3wzd1F3NiGQYbjSkmJH+FQh9+a/f/yFi5YepIQoM1RgfKi3f?=
 =?us-ascii?Q?VgWmn8PDQoIedesXafGS9Ultg8AMUxzOCe/cI1chaPkQMo+StkPhJkVp9q8t?=
 =?us-ascii?Q?/6+YkQAezapNA2/ujet89iMFOOqdKRNeJOwwTwnWTddq1h74pKz/EamDGJfE?=
 =?us-ascii?Q?QCnb50EnZ08uT12pnvKh3W62Qm4U01oIQGq0xvjaB7u5n2msvYNrtdsBPHZb?=
 =?us-ascii?Q?0A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 68fe4943-6d20-4a48-0f22-08dd931c7305
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 19:20:55.7559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 097wyoZ5dWfBdWKMjSpLQ+RKTbZknZrD6cf+d03XaUcpjTRqQO0XTVp0RHwH4KyghtBSBkv4qK/vUIWmyCDUaLisJc4M8Xcd/Ol94/t8xJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5315
X-OriginatorOrg: intel.com

On Wed, May 14, 2025 at 06:58:45AM +0000, Zhijian Li (Fujitsu) wrote:
> 
> 
> On 09/05/2025 04:44, Dave Jiang wrote:
> > Current host bridge validation in cxl-topology.sh assumes that the
> > decoder enumeration is in order and therefore the port numbers can
> > be used as a sorting key. With delayed port enumeration, this
> > assumption is no longer true. Change the sorting to by number
> > of children ports for each host bridge as the test code expects
> > the first 2 host bridges to have 2 children and the third to only
> > have 1.
> > 
> > Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> 
> It seems it's a bit later, anyway
> 
> Tested-by: Li Zhijian <lizhijian@fujitsu.com>

Thanks! I'll pick up your tag if I rebase pending. (probably will ;))

> 
> 
> > ---
> > v2:
> > - Merged Vishal's suggestion
> > 
> >   test/cxl-topology.sh | 31 +++++++++++++++++++++++++++----
> >   1 file changed, 27 insertions(+), 4 deletions(-)
> > 
> > diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
> > index 90b9c98273db..49e919a187af 100644
> > --- a/test/cxl-topology.sh
> > +++ b/test/cxl-topology.sh
> > @@ -37,15 +37,37 @@ root=$(jq -r ".[] | .bus" <<< $json)
> >   
> >   
> >   # validate 2 or 3 host bridges under a root port
> > -port_sort="sort_by(.port | .[4:] | tonumber)"
> >   json=$($CXL list -b cxl_test -BP)
> >   count=$(jq ".[] | .[\"ports:$root\"] | length" <<< $json)
> >   ((count == 2)) || ((count == 3)) || err "$LINENO"
> >   bridges=$count
> >   
> > -bridge[0]=$(jq -r ".[] | .[\"ports:$root\"] | $port_sort | .[0].port" <<< $json)
> > -bridge[1]=$(jq -r ".[] | .[\"ports:$root\"] | $port_sort | .[1].port" <<< $json)
> > -((bridges > 2)) && bridge[2]=$(jq -r ".[] | .[\"ports:$root\"] | $port_sort | .[2].port" <<< $json)
> > +bridge_filter()
> > +{
> > +	local br_num="$1"
> > +
> > +	jq -r \
> > +		--arg key "$root" \
> > +		--argjson br_num "$br_num" \
> > +		'.[] |
> > +		  select(has("ports:" + $key)) |
> > +		  .["ports:" + $key] |
> > +		  map(
> > +		    {
> > +		      full: .,
> > +		      length: (.["ports:" + .port] | length)
> > +		    }
> > +		  ) |
> > +		  sort_by(-.length) |
> > +		  map(.full) |
> > +		  .[$br_num].port'
> > +}
> > +
> > +# $count has already been sanitized for acceptable values, so
> > +# just collect $count bridges here.
> > +for i in $(seq 0 $((count - 1))); do
> > +	bridge[$i]="$(bridge_filter "$i" <<< "$json")"
> > +done
> >   
> >   # validate root ports per host bridge
> >   check_host_bridge()
> > @@ -64,6 +86,7 @@ json=$($CXL list -b cxl_test -P -p ${bridge[0]})
> >   count=$(jq ".[] | .[\"ports:${bridge[0]}\"] | length" <<< $json)
> >   ((count == 2)) || err "$LINENO"
> >   
> > +port_sort="sort_by(.port | .[4:] | tonumber)"
> >   switch[0]=$(jq -r ".[] | .[\"ports:${bridge[0]}\"] | $port_sort | .[0].host" <<< $json)
> >   switch[1]=$(jq -r ".[] | .[\"ports:${bridge[0]}\"] | $port_sort | .[1].host" <<< $json)
> >   
> > 
> > base-commit: 01eeaf2954b2c3ff52622d62fdae1c18cd15ab66
