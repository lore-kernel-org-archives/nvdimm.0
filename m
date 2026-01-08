Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E042D7801
	for <nvdimm@lists.linux.dev>; Thu,  8 Jan 2026 17:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767894419; cv=fail; b=CEolXC+ABl+pDH0pcVbP4IrBeUxpErL+cSSlgx0+VgiR9JPzoNESuP40OtJWimUyU+4/bvqcq2qdIFNNwpHl41ZGLVTG6ccnQY78vhX114TLVTyytIaeccHaOppn/ezoNnGw+/2OtWaqlfzMERthyeWuDx6q41DEm1DZ6HZkWos=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767894419; c=relaxed/simple;
	bh=NwcgyWD6nzTyOutoBEbrb6QMLoi1Q2diA/mrQQk12sk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ahy5PXKKxA8CXzWX1aZaDbyEZ5u/NECr5MBd2ofn3WIWy91sYxqzFN3S/T1vyB4DKVYkEf1kqGbTPXfS96WBMLr7cMC5hBr3FBWqNpJ+qw1W9ltLLQCzszMn+Yv+dlmlE70QkurStp6VbNhBqTzOse72iUSdE5L8kBI8pe3/D+4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lQDN6xYH; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lQDN6xYH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767894417; x=1799430417;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=NwcgyWD6nzTyOutoBEbrb6QMLoi1Q2diA/mrQQk12sk=;
  b=lQDN6xYHNZ8c+jdBpWSnk23REc4WyAGVldjjBTDgZY8TUUjEW3wfgr8T
   sFusDCMhw8Yq6QbK4jWSxlYhvQov2a54X0KtbA3Fuu2gWJeVLEk+duJWo
   LeAatjflbPMeErifz+jmObIEKXfy4TazxJHBI42hjXytopQlWcOM5qJi+
   uru+GLEqGzaOW+PTHmfWBcPSNAE/3H30JztWU3qPSZw6ycAsOeljZdmyV
   7rJoaraRqY3F5i7yPD/cleMc3XDOoNi0inb+j3r/zDa/eBpJ8pJZl3J/W
   7Ylz7AskqapYr7op9933T+pF45y4gCc++eT9+qlpmrD3v3z3alUO4ta/+
   g==;
X-CSE-ConnectionGUID: OvZdLIihR7Kuigg9RXIHUA==
X-CSE-MsgGUID: HOfe5XDBQ6uUY3zNCAjjvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="91939656"
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="91939656"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 09:46:56 -0800
X-CSE-ConnectionGUID: i2PsnrPhTT+6XnVqEbjT6g==
X-CSE-MsgGUID: YEEED+tGQ96RWiy8ySZBag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="203541961"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 09:46:55 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 8 Jan 2026 09:46:54 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 8 Jan 2026 09:46:54 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.41) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 8 Jan 2026 09:46:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GYrcHkUSj1X4Ue01a1UzjNlUnn/bWyr/URD18RvGZ8OL1PTNtNfQlOgLnT6D51LjdnFRpuZgBkYS44ReFNpb1fc2aZI7sJp8z36Cu2yUczD8/xXgBl9qN70to+fUaRf47FEUe2yOjMKePmCn3jcnnxISeHNKzqKrH3gGfxqgzRO9Eb75Yg5DuVWVQBUqRPQcB7Bx0oV+97nnLcA1CU3Dpcqf8hEIb4FAdiw5zAQg6iqQ5vmER4mrss4xbis1ca+lK5fD6fSNRk4c4sxUbV7VH6jBAvhczyl36zdn0djgRJ3d+rFkbYyee1kH5l57fkuMf6p/5yV7O5V87QkrW8ha3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DxwWDhMq9YJ+/+xNRaEEdwpU3ycmIAQD26TJnuSv3Dk=;
 b=hWXxG7BYOPpZ5ZBGCWKlR/5j45Wd3Z+Bx53yKhiUHZfby5D1lmhzDUyRZvZJnFcWcw8b7MVRAAcZ47a/T8+pjHa9xYSXr6g60ysW659TfGhtsyGZMW6Uyobb8dn+390dHylBveDqr2xbOknev3ITDEqEAI9tX7jE4/EYidr2S431DW319aHfFnT7ocqB4AdzByZwi2Qkgo4S/g5nWYhSu8yiHlA08+x0O5P/ilkW+DN4Kspgg2wUl1P8luqSE1XVfG6Dvbts0NuwiHJzbgpffJRNneGtU20pzxqUul5ZoSQIyVabFGHtouh30Y1WKhjwBxuG4+6kXpdGZwoOzXozrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by BL3PR11MB6457.namprd11.prod.outlook.com (2603:10b6:208:3bc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 17:46:49 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%8]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 17:46:49 +0000
Date: Thu, 8 Jan 2026 09:46:41 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH] test/cxl-topology.sh: test switch port target
Message-ID: <aV_tgUOQOh9U6-AE@aschofie-mobl2.lan>
References: <20260108052552.395896-1-alison.schofield@intel.com>
 <e2608021-a3bc-4598-bb98-2a8a885b9f8d@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e2608021-a3bc-4598-bb98-2a8a885b9f8d@intel.com>
X-ClientProxiedBy: SJ0PR05CA0088.namprd05.prod.outlook.com
 (2603:10b6:a03:332::33) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|BL3PR11MB6457:EE_
X-MS-Office365-Filtering-Correlation-Id: aafdf6cd-4ded-43f4-bcf5-08de4edde699
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?reeOIW/euEDLDxatw8OSZH7gnb49LpH51/0tAEZGQGGK2a4EwsI/L5irQ3vJ?=
 =?us-ascii?Q?5SDAlpWk6NAxsrqMXRrBBkdMyMBRAWLiNHVn2S5xCoU1caumH7VgUj9WSaKn?=
 =?us-ascii?Q?xVDFd7gqvzE4gFemeX3pdUjP9iTpqpV1sN8FUlDZHmE4albTfnbnl2euwhdd?=
 =?us-ascii?Q?BxjozpdrPTtQ+XgbKeTxPYn7CfH+TBPEBzAHS72EmIAh1BN1QNB66w3YtmqI?=
 =?us-ascii?Q?Mm/X1wMhzwJldfTfdHx6+X9mW7Am4iwya3cjxM/XaW4U0p8UKVdNqg9V69dn?=
 =?us-ascii?Q?4B3Z7YwYTaOu52nD3yKa5dQfS415qTv5gXDPoWGz8lW/LxfYw14i+Ju26laN?=
 =?us-ascii?Q?DEOLSsEMTZKP057Hz6ZXE4YNMIQhrjV16djJPXnuoH6SRzZYAc2VHq4xxbIC?=
 =?us-ascii?Q?kC9NcvElodFO7mVUdyhl5zP8UzcT84ibdxAbP/1Z5FG7mjxVgEOjNn9PfgSW?=
 =?us-ascii?Q?mX9sXQdtrmMXzxjaENloKs32bshBeT836pCfDXFgCzvy3Cu0ljk2mAUb3k9o?=
 =?us-ascii?Q?bjhnPBS/AfT1x8ql7R9WoDxdEXduN/SmuW9OtVLRcUvDmeo+pkIoulrPPHxX?=
 =?us-ascii?Q?EWql6fVydjKNDmBnugDykEif7Du/Au/5U9CUs5+sP4X2/AFZNP3uCVNJ1cml?=
 =?us-ascii?Q?XGowZPv6m51pbIRSZq42BkWcl+4zp7/Pr9gNfiElmvxavYtN68fLHDm7mrMU?=
 =?us-ascii?Q?D7USwKkpdQjouQ1ul2/NXxlmIrR6aY9gxB/VvFWckMXMMP6r9dyROvVJmLId?=
 =?us-ascii?Q?VfBkDmhyWfRLU/VrToiTKrx5EbSgSU95WlI/2+YdkBxTFPN5RgBXEg5QILab?=
 =?us-ascii?Q?HwpLXpjN/Qefpk2wAEZAK1p8EJAiudvIrx5qp471TbPG122J+XNXzz2A8wpO?=
 =?us-ascii?Q?9BzvXwYZ0GR7VZgKzksfgs9acPdDJIJDo5hbj1zZhQCS0P8nEl9pBbnDinNc?=
 =?us-ascii?Q?KvdWaCodHSOl7Ai807yKWXSQoEKHez45UT0xR2Mw3msYCtluPmHYEBvKm0VT?=
 =?us-ascii?Q?Xm+6rZaAehi2Lt+AyrENTiomSFg3uu7AVygGcks+AhbzixJK/hjcFw0yoeNU?=
 =?us-ascii?Q?b1RnC5J4xk1yDyZF3Dq3mFySZ4NhVv51kqTEkfkyM2lUA4cMQEk5SHVijt72?=
 =?us-ascii?Q?NPfjs55tPKz3YEefUGRBsm5O32HwpUaZTnYROpgbEBUvfNLYvYDWUAqF9njz?=
 =?us-ascii?Q?QNp6mdZuyEc6uglfAeMkexMl4b63cQR1J5+ZuTpAZ97Yhoc/beAVcO3SjMvh?=
 =?us-ascii?Q?ovcNiUBhPA7QCX2Ky0fWlz6eP0BKzyp+X6nqHcIFKo/dp9m0CgRToRqBg4LM?=
 =?us-ascii?Q?qWuXk+Aea919rrBgrlk9SmVhjgAGOUItNjrYDrMSuRlM4x7IQVVEetz+swxE?=
 =?us-ascii?Q?7an39Zs7q7vmJxmXHIuAg0nyzW5z2xNJC3zKLnyLgRlDPPkssy93n405HcGx?=
 =?us-ascii?Q?ZAy3ldzOnvBMvjF6MYBLHO7UauCkxY9c?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z9QeO6ktoJS0oroHYKHuYJchfv9lg69bV5dGAdni5qGSJ8ZJouEhV6ycrCAi?=
 =?us-ascii?Q?8wmM0qbR2gk8oK8c95RxGSwnHoQSmewNb0TwER9lAQmLIvpeNckQYJVed/YF?=
 =?us-ascii?Q?dNLwRbGtv/KMFGzQW3B2wjNC7c4dMFR2Ac4AiNYiyOL6hq7bUNixaTEbJXi+?=
 =?us-ascii?Q?xdbpJ7AywKs2muN8cofE0OZBKfnQdzMzhafKCiFF6Yp2F6uRlgeiGOlnS8cp?=
 =?us-ascii?Q?WpBrvWGE6Rs3iopImGXoX3nZDikdDB2fXxi8hknZlM4fnth1es/DDF7MyEkV?=
 =?us-ascii?Q?zI8s4ixqrXeqRv3kHpCO7lPSDznIc7lp4EbkC4vPMLFDtSJGkWMAz8zJmawB?=
 =?us-ascii?Q?xBhbBSs2CJy/X21lDeX71QgJVSf621qAuPtHG9Hq76vLrGeRbgLi7VDwVPQz?=
 =?us-ascii?Q?ER6AuwBurnZCiAMwPh3yuWCLFSd2AQMwNXGFPdBzlA8a0I26oXJaZJjdsDjp?=
 =?us-ascii?Q?049L4ksEwV8kRB5q7IE8XYAi08ajxE+hbTsMf4O0otYb1KYuXglbKqvyPRj/?=
 =?us-ascii?Q?BtSvo5KeghKJWa+uankPXMs+pb+Dn71+h9i9j5NQoCcng3MZbUeHUjQUPIdN?=
 =?us-ascii?Q?+RpweKnvOJWNt8YNwRRXPBtpKlAXxdEzJDnrF44uXiMGnNKue9a5M1nyiUhq?=
 =?us-ascii?Q?bRO2aZGAdbzRISIJxhFj6rzoEWzR6ROgq6fSOXBiCDf+8IzW+XDfxHS8Hjup?=
 =?us-ascii?Q?yGL+hyZUnUOEXPYf0D+NktzEavbVWd9d7YoyQkUaNkLAx3IiO7oEzoA7QhNl?=
 =?us-ascii?Q?Yc1JM0dJ9Bu7nzma91JUTqzXd5gOAuJ3fuEM9rPFA63mi6gE71tBAyyeZq2c?=
 =?us-ascii?Q?hb+8oHoEoAMa2J+oB5DHeunb1MnxHkAcY3b9rYtER30mbC3QXz3IrmO1wekj?=
 =?us-ascii?Q?nwQWb8RPS/drKuSzMz1kUxX4GoKGaTqyu0P9dHMx2s/kWO8mrtZ4HATxcr0D?=
 =?us-ascii?Q?36OuQbxRtSwUdPVjNU2TdwJabM8/5feeBtLQY9BML4cS3ODx1rWYk+r1Djrz?=
 =?us-ascii?Q?3FLx6T2cLqDYoeP9X6ie2EWlyVW4OfEPZPxbi/njbZLWXT2Pzky4Io+6/L+F?=
 =?us-ascii?Q?cYTbX6bgU55upUjoawMQB8Zb6EsJliGq6NGuN9lmrmomR4WOzm2qr8STg+/3?=
 =?us-ascii?Q?L73skx2zxAsQKWef+d+5L3eQsnGA3Tb8EQdC2zYOVFeqx+5wqSXf+EKo96qq?=
 =?us-ascii?Q?a2niLE1uTQXWh9nRuj5pmsWnedwRzPAhJLQR7yMnFQhuXP+/Vpip4Qt80QOc?=
 =?us-ascii?Q?DFQjcpvdwuBc4CNav75jnnBfnsvRIHY8rgcGV7DEccX0m/GEjmUM0O8N0wWP?=
 =?us-ascii?Q?iIReaPRR1gipxGv/Z/g7XZcGd37+A09pPEZiTi5bvnsynA2gtKnkxzUfycC0?=
 =?us-ascii?Q?LwcG9koIsvO+yaIRQmpBM6/2EZZhkZsuzzTeSLFVHn8Xpi+5ri21mpauyms7?=
 =?us-ascii?Q?G2JGWaY7kXshNWxIWG8bSoXUK2mkhJm37L8lO2swKenYht45U0YsSaHZ42Yy?=
 =?us-ascii?Q?yoNeDiOn8Tu+R5qYP7pOw95OyzrQGyM+FY8+nLUdcDSu7LHQ5E8TzDHeq/R8?=
 =?us-ascii?Q?GbW0MveONyXn5YyikeoErqIoPTpuvXOXAYlDLZjQLeDxqQU+umm4FYG2Zi8J?=
 =?us-ascii?Q?bKgj9ygotT/v5n3taJdhkI0msHnVrRje9zza9C2oLhvGtmPef4NC7jakmPW+?=
 =?us-ascii?Q?1uFoG8RuKb1DjVNV8chYQQOKgA9l4L73ZDm3nNfOmfuDnBjaXvEMiwC/Zsd9?=
 =?us-ascii?Q?9F07c0xV0bWdo3Rg1bCB3cVRdYmuIdA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aafdf6cd-4ded-43f4-bcf5-08de4edde699
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 17:46:49.8105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B5vUoFmwNTVEQNJ/UXlaBDydAHHH2jbZ8/8tkFWVuHCCjlclkB2FLwQJ2uQ4E2F31koVJJkIBqVpvWLCpGKIDF8AUA59TIBc0CCckyIzTCM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6457
X-OriginatorOrg: intel.com

On Thu, Jan 08, 2026 at 10:02:58AM -0700, Dave Jiang wrote:
> 
> 
> On 1/7/26 10:25 PM, Alison Schofield wrote:
> > Add a test case to validate that all switch port decoders sharing
> > downstream ports, dports, have target lists properly enumerated.

snip

> > 
> > This new case is quietly skipped with kernel version 6.18 where it
> > is known broken.

snip

> > +}
> > +# Skip the target enumeration test where known broken
> > +check_eq_kver 6.18 || test_switch_decoder_target_enumeration
> 
> 6.19 I believe?

I found it fails with this commit introduced in 6.18:
4f06d81e7c6a ("cxl: Defer dport allocation for switch ports")

So intending to skip that single kern version.

I won't put this on ndctl/pending until the kernel patch is merged
in 6.19.

Make sense?

> 
> DJ
> 
> >  
> >  # check that switch ports disappear after all of their memdevs have been
> >  # disabled, and return when the memdevs are enabled.
> 
