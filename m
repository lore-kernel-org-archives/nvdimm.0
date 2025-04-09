Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1662D8BEA
	for <nvdimm@lists.linux.dev>; Wed,  9 Apr 2025 20:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744229327; cv=fail; b=ayYzXhBg8wCyS3p6XklHduYkZnJLKGb5qpi7T43Zb/hTuv/lJwmUetSdsGnQ+x79VuQFfrZX5WEw9UNNWrFLPqMaXSNApMutRJ430HTwElWXI7L1DQ29oX/zB0Fb+c6q4ym/Bq4U7fhsI9kxl4Ys34K8FUIMl7P3blykmeXFefc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744229327; c=relaxed/simple;
	bh=8I9Se9t68pOa4UwfdjPjW5QQ68moTw0bfc5w9JbvvWk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UXo6qLNblZMNodLewwBKlRnpOOE/nQ7Oz3vlCQbIKnHF1rVrt1RzenKQ3SgEGGFgGYVZ6WXblo91ROKKE6w5MQek1+K4o+9XPTjzvkgkdgcJRVetlNc+wREZHJ2mvF4Ctf4OgWvcbUg+uZk6IRTVk7RCNcOGfgXJ/eqpHqhD+L0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kyAfxSaQ; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kyAfxSaQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744229324; x=1775765324;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=8I9Se9t68pOa4UwfdjPjW5QQ68moTw0bfc5w9JbvvWk=;
  b=kyAfxSaQNcKtlvRKHrpoZQYTKhSahokNJRjxnADocaUVRJ7Xkkf8LCGC
   EyFULPUf+EotGIkVyEvg/VB6nrgFKtXP2jOYF0AlSByh72GEXdVgEXBu0
   irKH5FKZhWYmZCVCUOIOTo556t78deLpbMUAcMIY8m2+S2Dj22w209UOS
   L2/Y/vKOCiPcK1xp69gIqilS19nEFVPeb/wEEQH/92BTsNUgj+FvUdo61
   /nX/DQYoNvgR0zC278xwbs2xqewWxFLC+IJjCjNnQBGsK8BiF4y0ygeYf
   OeKg7rD9Ra3030G92llLmlacan/+cf0tl+MJAyVGycE41i66eAkgogaLi
   Q==;
X-CSE-ConnectionGUID: MxAg4lZ0RnmB4IVSbRRpAA==
X-CSE-MsgGUID: FBXrMNfLQai6W7V6M/DpYg==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="49387077"
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="49387077"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 13:08:42 -0700
X-CSE-ConnectionGUID: EU7AwmfvR2ap9VhNHwoqDQ==
X-CSE-MsgGUID: Sa1uokS2QaK4nM4jrE7DUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="128600301"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 13:08:42 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 9 Apr 2025 13:08:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 9 Apr 2025 13:08:41 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 9 Apr 2025 13:08:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TgcJ6FJ5asluw0optcgqjuFQBQB+iDZglviHXn4Vf2F27CB8gTaJvC8uj+wGEbURDAp0rOwzIt5I1dcFDfGlaMiP0Jz40Wk5WcaVuoOnYVPZLHgY2FHHSFrndxp2PeCMJY0SS0HGZurqrgSAQb4zODDDBphC2ddNp0AuYvQGCgRWC50iPIIH8dw5AehwfCoZn/miQ/y+pEYNuieecafjZw/0B/1pgrFJOyjNG/eVFrOpWwmLufUuoLzEnqwfys2GYMDrqSmfl2HGyIjPAtszS8K5+sU9ZtM7Yjscs9tMLTMWSw6gfotZoZVPIDdJfmnfGA4xayn4kxVLjIrW9cLmBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1O9phLrcMXcyn4vMiB8yIqyFSzReTP2ChnQf4xcNWa8=;
 b=y/zwceK7IIPwuPE5J1ct0dnYWc91YJvg2MixefGD+htUTPmKzL+Trfr4mK7Tw2ULxtEc+i/0tiQFl4X5tG94B7XM9Cm8GkWNWXxMwnh5w2reGIxtCkpalIAnVgUe/2L0RrsGd2PuEsIj3oH8vdaLU9LO8JZSpTIaZ0M2jyX+QceSIh9P30xUsTteF+MoB3I+u9ylKmxIFcAoxeiQYOkTz/4/Mvs725++gp7y5jyC2plsaePia/2Q1uYwQUcBxy0xnS3XPkb0oqmWlV0FFTgRvnEucxymzAJBlv69vsg9QW4FtfThFIW73sftffFFOY2VWeSCMY5cohLZvXwp2xwetA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA1PR11MB7272.namprd11.prod.outlook.com (2603:10b6:208:428::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.35; Wed, 9 Apr
 2025 20:08:08 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%3]) with mapi id 15.20.8606.033; Wed, 9 Apr 2025
 20:08:08 +0000
Date: Wed, 9 Apr 2025 13:08:05 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: David Hildenbrand <david@redhat.com>, Alison Schofield
	<alison.schofield@intel.com>, Alistair Popple <apopple@nvidia.com>
CC: <linux-mm@kvack.org>, <nvdimm@lists.linux.dev>
Subject: Re: [BUG Report] 6.15-rc1 RIP:
 0010:__lruvec_stat_mod_folio+0x7e/0x250
Message-ID: <67f6d3a52f77e_71fe294f0@dwillia2-xfh.jf.intel.com.notmuch>
References: <Z_W9Oeg-D9FhImf3@aschofie-mobl2.lan>
 <322e93d6-3fe2-48e9-84a9-c387cef41013@redhat.com>
 <89c869fe-6552-4c7b-ae32-f8179628cade@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <89c869fe-6552-4c7b-ae32-f8179628cade@redhat.com>
X-ClientProxiedBy: MW4PR04CA0345.namprd04.prod.outlook.com
 (2603:10b6:303:8a::20) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA1PR11MB7272:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ca98087-5420-45d3-67c1-08dd77a23efe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ec5ekctKeU3byI6DS3DmNuD5saOqYoHATCpYZjzudazED1NsKLwILT/YyYXI?=
 =?us-ascii?Q?VyLY2dYoeTFCQLg4NhlW6tZ+sqbNPZX3zGZGnFsPPz0BFZ9m/zzTLik0mSJg?=
 =?us-ascii?Q?ucyYAAnf86Ao8eDO3S9MGNd/3XPIBOXprhy6b0ZUIEV1SLrVp+4FG4F3SNCA?=
 =?us-ascii?Q?Vrv5Il5aT6jkLZOYrXCnvJMjactKZNueuoqMssE/bxQtkRnOeXv5I+xaiQFU?=
 =?us-ascii?Q?qmaGQOtKS+iLMntsQNwQBLwh7bzLSJACISSmoE6riFyt9Cb7/S14IcVk7dlJ?=
 =?us-ascii?Q?T/FJ2bXNx/Avhzf6sjy5s20Yh17t/gcKsD7/U7zjVnt59IIU2L2+ZK93JWaw?=
 =?us-ascii?Q?u1DQtXynB+AAJ5TjNms4i+Tuu183Da6ALd0msPmHDrWXcnKvD62CdByHaDsJ?=
 =?us-ascii?Q?KP5VhDqgtwQxF4Fm4rjU+FQBxs6iXS8e+8FlPtGKkansf7nYs+6QwSjMakYA?=
 =?us-ascii?Q?evdqqrkXuHYXKSmkkQGlxDI1as+hiK2nPEYxS5Wy+nkq/SlqfCo4I4aW7kY6?=
 =?us-ascii?Q?/sjc8OAoid0AFSD32vzW0u+LZFLsTPC6jHocn1+//UJGpt4gl8Lq6QA0NC2K?=
 =?us-ascii?Q?/apxZ8SOBXuH9+MaX7WRoAXu1Lkl9wIRLzzZgGA/SWFlGPoQ/vqJLqZzoRmg?=
 =?us-ascii?Q?LDDJc91T7jmJexYJnXXyVvqXR3anjAVH1IVlk+Em8D9+5V112N9hcEzDN9ci?=
 =?us-ascii?Q?qT+wVLncIEtDHmjbKx1REf9t9pPiY3uHqTaibVZYO1fv1sLX6Oqk4yUsbpH8?=
 =?us-ascii?Q?7nggguN9Iu9QpkYg56AfyRMYGg1uXNwPCF1j9GwnO4yRz8C0CjlBaKMRag0k?=
 =?us-ascii?Q?hweAYnuyG4YTSBhw+iM/bRXzQrV63nGIGcAWfxbI7kJ03BVXcsIaUI8CDwyY?=
 =?us-ascii?Q?7ux/Z9ccbqtluyRTzETzkr/574FRA4pL/3K7zjvlKrgG61qPXLdA1r0eMHg+?=
 =?us-ascii?Q?AeeffbkwIG2EcMMxTVafQWzgn0CuU29YoXywuJqW2F9t4pSkWLCrxhE87faM?=
 =?us-ascii?Q?h6KTaR2MoPZFV9/kpCKYeSAuJAPnkjY8vvMzCjeKrFiCWfXixZLpAhFtRMtQ?=
 =?us-ascii?Q?Ab6cubkBfbe+KtmCPDf9aJKmfflMQWuss4v2NvKeH858sJVfBbM23MkD+ZcB?=
 =?us-ascii?Q?8dZhn6/oQ9T9rWxFYS72YsRIwSmyChvJRWThpAEnf1/hXd3kiMwwx8MVZ/pv?=
 =?us-ascii?Q?/a2JMAqxfG+vm9rTuO+vVLR8kL5g9mF8/dPqD4ohdPL2gvpMjntgYyVgd60Q?=
 =?us-ascii?Q?HEfkad0X9Yd4Pu26B1LJqXRVUgmlWxy+l+etq7RbM+FXTbv0MV87XW5vDV60?=
 =?us-ascii?Q?o4wtDtlbs3ZH+zLnQR0zxGd53CQ/S2GOhmM5iu+/Xy1i75auW8EufurC1/lf?=
 =?us-ascii?Q?YoIJPkV6atYGZ0KGmPVu/GpydDxk?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WM1cFz3CRCwFeb8XToOkSw+AAHVnH5PXNoGJxfwcPvE3hd/HXRqIXw9Vu8wF?=
 =?us-ascii?Q?7f4dNYI+UWnq7DlOEMHjWLgWFKVA17WJq7luh2V3yteY4W3jkaq6ob321uKu?=
 =?us-ascii?Q?dkUrQDyU+YHJiw3FaNvb85OXYuf+5TSXHSJfxwbXpfCTWP/wfc6RThRQ53wY?=
 =?us-ascii?Q?+IzwgWNKgDSRPrx/viy3IE0vussAAgjTtlL/qTLhTaecKzcjmgj59Z3fMNf3?=
 =?us-ascii?Q?fUhhG34jcortycaGeOgOsSo5ioeSd+3oTJDvP2tRK5hk8GOqBTRtq9EgYwGA?=
 =?us-ascii?Q?J4OURGr3m4GFSAhuR1Th0naZvczFu7ryxM1XmMJff79XMqza+ksaI3eBNOZR?=
 =?us-ascii?Q?VYv31fgDpRiatMMqar4pbEfltuoJ5rxs4ywYB0AsDKnDE5/7Mex7Ln35ySJv?=
 =?us-ascii?Q?HOxssrHfSBTqm9rqczTxnOg4TXR+tTh4JMzuj0nTUlxG3Is6kbkAtBj4YyrW?=
 =?us-ascii?Q?8ujn/fFLPYiTPV1nda6O5JeHAkJp4TdKrWG9bEVryNBowBrujB9ShP8WEgzG?=
 =?us-ascii?Q?Z092Bm1EmMX7NGAfMiK9p+HXBe7ldLMK+ZAyW9+R9ekVKC+++S8hyfkUuMua?=
 =?us-ascii?Q?86g63pBmybG1I9OeO6Nec5Th6smr064cnAorzwj8+MrWCz9UG21VAczkLb+6?=
 =?us-ascii?Q?8WW3EZ/tDTnuB0ECD+CsuNXMfbHi3rTKizO7zN1i1RkBA5LwePlOa0dVMgeF?=
 =?us-ascii?Q?bRwUzptzYtZmhVaqJxCWNiMzoEeA2Wo58Ebeyhynj18zfC3sm/MwntxEm73w?=
 =?us-ascii?Q?4+KlRhPwDjPrZJ4/FHNsJd//lj5HsArK2+BbJBkQTBgWorGWi6va3r756Zqr?=
 =?us-ascii?Q?kSVsbW5IwZbMAAQUg5oP+XtRExGsNWOhJwCxuNwCH7UiB6D5OquZK851yC5A?=
 =?us-ascii?Q?rIj0dJ8VynB1VXzyo0aA40wx0tuvN8LyTkoTMlUFBOAejlI8AvK44P11UnAX?=
 =?us-ascii?Q?Lxlgwg4Nuj+wdlbjiq4e8PCeGMrZKBP0CUyVczqY9rjcu/D/UgK8urVT+hgp?=
 =?us-ascii?Q?zwbYzZ/eaj3QH8IRviOSS7X3ukYEoMz1y69mRnNUIxsfXBhW1nV4Kft1F3/U?=
 =?us-ascii?Q?Zj5v/5tj/A3caI/+9wq7AFNoC9AHMMo0CObErxa15dOZZdZFZ5xjLOsjeaN7?=
 =?us-ascii?Q?tUvVWn0e5rZN+ob4doqK5a5ZXSkvCVprn1wzsVJZR1yhmmNqWxUXuI1fWXh9?=
 =?us-ascii?Q?L2VKqMuMe5ZJTeC+AdsyyCb44WRIuOUMlts9RasiCDzN7ON/Qjw2YAYfYu8B?=
 =?us-ascii?Q?0xuIDLH+FkSb+4q8N1USodmwrflh30wolFPQMANqyDOJGOqPRvQ8wNYSYfw7?=
 =?us-ascii?Q?6tP+K9CBMZNwHtPhOJD19BWn+PNmR7Hn++V1lPzU6q2JxN6hrHBlSS7dr3q8?=
 =?us-ascii?Q?m/vamA4MVYRzvgiR9fZ/qiRvrfU5pnnH2lAQd30rFvagBjvMSIxnuKyKbA0j?=
 =?us-ascii?Q?jLsLc6atJ1CAFy/rF7kMMq7hY8OYSLH461WBFY/mqtLnkfmBD3sD2l1HFhw0?=
 =?us-ascii?Q?5jq2UU9GYIEaY8qu7pFfrM51xhu2UDdW8wECrTdJeH/Q0a5ZHp/oNI5a6lVL?=
 =?us-ascii?Q?/AcTYnn1AnxJnMxwutiaZbfI/0/V0+rJGCPZSzOtrM4ZriZr09g0Y73FGeo9?=
 =?us-ascii?Q?/w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ca98087-5420-45d3-67c1-08dd77a23efe
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 20:08:08.3404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /63W0WxxPCkuP3PjNZSyOcQb49TUaOCJ/Ss8S4kTW0AaYJ3K7h3LG0rzfx+a76DTzocFJ/FhA3kwT5CY/1zqYk2BMBGr5XcoadmvjKcyLLw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7272
X-OriginatorOrg: intel.com

David Hildenbrand wrote:
[..]
> > Maybe there is something missing in ZONE_DEVICE freeing/splitting code
> > of large folios, where we should do the same, to make sure that all
> > page->memcg_data is actually 0?
> > 
> > I assume so. Let me dig.
> > 
> 
> I suspect this should do the trick:
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index af5045b0f476e..8dffffef70d21 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -397,6 +397,10 @@ static inline unsigned long dax_folio_put(struct folio *folio)
>          if (!order)
>                  return 0;
>   
> +#ifdef NR_PAGES_IN_LARGE_FOLIO
> +       folio->_nr_pages = 0;
> +#endif

I assume this new fs/dax.c instance of this pattern motivates a
folio_set_nr_pages() helper to hide the ifdef?

While it is concerning that fs/dax.c misses common expectations like
this, but I think that is the nature of bypassing the page allocator to
get folios().

However, raises the question if fixing it here is sufficient for other
ZONE_DEVICE folio cases. I did not immediately find a place where other
ZONE_DEVICE users might be calling prep_compound_page() and leaving
stale tail page metadata lying around. Alistair?

> +
>          for (i = 0; i < (1UL << order); i++) {
>                  struct dev_pagemap *pgmap = page_pgmap(&folio->page);
>                  struct page *page = folio_page(folio, i);
> 
> 
> Alternatively (in the style of fa23a338de93aa03eb0b6146a0440f5762309f85)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index af5045b0f476e..a1e354b748522 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -412,6 +412,9 @@ static inline unsigned long dax_folio_put(struct folio *folio)
>                   */
>                  new_folio->pgmap = pgmap;
>                  new_folio->share = 0;
> +#ifdef CONFIG_MEMCG
> +               new_folio->memcg_data = 0;
> +#endif

This looks correct, but I like the first option because I would never
expect a dax-page to need to worry about being part of a memcg.

>                  WARN_ON_ONCE(folio_ref_count(new_folio));
>          }
>   
> 
> 
> -- 
> Cheers,
> 
> David / dhildenb

Thanks for the help, David!
