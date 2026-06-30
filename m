Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DB73749ED
	for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 17:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782841227; cv=fail; b=qCAjlE4K/ZiVsp4oilKWf8oaRK8/iG1ouhO7SAtyfupmbwK31UmzQyhFKnPWda/qzgnpL11TcsiVjlbxrY/sg8zSZAM07HBtm7XghW+yWfS9o7wTOpn29f9GeawclY9R8aUa1DFcWjNVornlOpiM3p1gO4y2wLKiwFmGaeh4uLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782841227; c=relaxed/simple;
	bh=II4XiHNRh6nzK0A5CDX7x0SuwOrZh9ZRApfJ1TiSBkY=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aWgv2gnnU09tuUVJoHNZyf8BLCN0GkY1OFTCtaPzU/haiX4PUzWkONCe6zYLOtakxjiloBZrOUFSW7Oj2yoz2Dsf8lytQHRNQlZ6WjqlFzz0KtXtUAvfs0JyHYGUWa90DjHlB6Smtk1cz+EDemG7ZPP31iXyJvqfsxcxvuZbYlE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ndW3yoV6; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ndW3yoV6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782841226; x=1814377226;
  h=date:from:to:subject:message-id:references:in-reply-to:
   mime-version;
  bh=II4XiHNRh6nzK0A5CDX7x0SuwOrZh9ZRApfJ1TiSBkY=;
  b=ndW3yoV6RK+bRyLgHs6KKZ/6ZFjMus9Jo6wAmQeAxsT/e1GhgiE4DlnC
   lkG7RysUIRIKmRRh6gXWhll9LOfWq1De7hWRw+tdxvPIU/iOvQ5iWlcw6
   ljBKomn92ryy8dV+S9nsjvket9FzsTKY+EZLsfZe2hv50c4yoPuiYSL73
   AQ4NvliwwGs5JTNWMFrQtB4lwv+YmN0Yb3apAOBTO8hBO958Zu2Ckwe8X
   iMhO+qkarAY60dC87c+pebq3M+w0ayGAmV0lN/5JYJ8zZY0lZEaqe9GLU
   V7nj0quJwLDhJjSHKnH8RCJ+80qSKjVCOAYm2onwY7k5rkrPdhE3ikI8I
   Q==;
X-CSE-ConnectionGUID: Vf8CNcxsRgy3JUE+RNh1uw==
X-CSE-MsgGUID: TP+TlHbSS8G/svJRcL5iIA==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="83698672"
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="83698672"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 10:40:25 -0700
X-CSE-ConnectionGUID: lljIVZ8LT4m+8aZkkW1/CQ==
X-CSE-MsgGUID: SS4TEptmRYqzO1HipXjM5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="256710311"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 10:40:25 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 30 Jun 2026 10:40:24 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 30 Jun 2026 10:40:24 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.50) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 30 Jun 2026 10:40:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=goAaCP/cJhCuMWvwwWOAx5twsIhTgXiANMCQyKUxWmp9S4dAXSK8Tpn8nyfAakxVUltbuwQfPXMGsAmQAY1ZqWRx7MzM+ZPXXwPdoscnPBE0zx0eXCfDqIv+pDIVNOLNYFK2HYp7Tn+/C0l1FTZYxz1HSO0rNMRyt1DEg7nEJCdxwGhv8I5fYijEn/R7kAyslf/KbuqNbmM//qhsFUzVWrvQ1vuxJ1CIB1p6SstWfayQ+Bv+RphI99vHdreBfyZ1PFgRfUaHSvf6xRVBwfpdwe2StNK/5B/fQ4rbyWr6no4DTYpyY3+cJ0qf6acy+QGC0ZzkTZgdFL74MHIWRehDCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NkRcbwaIuVWDcQQKNwMgqiRtCC7oFm0EyK1cqZV9bRU=;
 b=RJ/oWMce51VwxFq64Im7z1BHq/NkVIAEskH1egKLSqZOqTKpoZc83o7GDlwp0y2RN4TfJruMRowAPZ88XsSjWVx6kYaTRV71uc88X9+7ZS1uN2cmjw4n1mC4036QaD4SP+SDj1ATQlhJlAQORnxxX5VoMTUvA5u57J8E3KNFbS9VIuUOK9Cnz+dLHugVESJPsz7SWY+FYwmKb+WNdTa9Kb68hiTZJ9To5pc0vYJCPPeqDYaeWIhaxYVVaoiOZvm89nutfONjv5obMidJgd0c7kBJLhc4xPcb1VKI2hZCcpF+DXyhwlxHge8bfBCHjgl5nFEJpeuS24yI6E0NLZWkJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA0PR11MB7955.namprd11.prod.outlook.com (2603:10b6:208:3dd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Tue, 30 Jun
 2026 17:40:20 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0181.008; Tue, 30 Jun 2026
 17:40:20 +0000
Date: Tue, 30 Jun 2026 10:40:17 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH] test/btt-stress.sh: add stress test for BTT lane
 race
Message-ID: <akP_gbvnr47-hXuF@aschofie-mobl2.lan>
References: <20260424233633.3762217-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260424233633.3762217-1-alison.schofield@intel.com>
X-ClientProxiedBy: SJ0PR03CA0220.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::15) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA0PR11MB7955:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e1b1eab-0ae6-4f52-b5f0-08ded6cea804
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|6133799003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: lAz/8VfvWlYRIAua2MMvPPUZE99UAlkpecsmuooGNaXHuoDyCe8WPrLtNynBS9rjm8oCp+zirAc/K94OYf2hVzAYQzZ80/DRrgZs7bq1nRNPI6TTKpHUwSqAseU7raT7JL7uo5qdW6oQkk3rwS3ScH05olLFgVfMrbE1MTG8+Yf7Z9xU2S6u8ilPR8MyOliUo/P1cotY0MyIAvGoZcZl3B6ztZuSWRFDdP4nR43mG1CVJl1FUR92W+q+AEBY5+ujL3C5/6iMektmI3MVv9JeJk7kD6NGLkseziZtFzxPEjZQEno/tQCEkiQ+5d2kdksAHrOrJbt3p7l56NxF88QIX4RKC5pkK4kJ4xL6wIW/k3EUqUzIejEfH7wbx8+oXtkC0bKcovp3WBweKn1Xkg1xtoqdkrdaH+6fNk0i7Ulj3tROslmGg9uWzWbP0JS9w7uECco83touIzui/iuEbMHeC+oxrBiz/3cztLdNTAOss7U7lKWEhZXjOEeKYuPmhi738hIAu3XmHv6b1Yo6QZNkDyLlTVgyejWEhPhu8Gha281DRXGrnCUGICpECM7dI3NqCtyAybRlxSv9zKTcMz5raCKHsNHkkjVAnAIZlbsjRfxMCPcvPspr0FO26NUpoH+UTuMHpqKhwah0ncqirChaYyA7ZJHuJEIVTCtHsCFlhEE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(6133799003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ewrYH4+tyJaPt7806RtRt0VnDA7D869FQ64VsSfwh06Wg3huYHPKzwiOA5VA?=
 =?us-ascii?Q?9QzCORb06VjcqJQHPGW8xuxq1JZq+fvnBE98jtkUjcKAQ/nPckehQZgBxDyx?=
 =?us-ascii?Q?Z1LxBK3fQu3RIP2kOeGoZ+TtVYHG15iG2mMAgu8q7P3TOHP8QCbcD8PXTdAK?=
 =?us-ascii?Q?WnDFqYJpx8JTFQAFLeNwMDkEiWARcicYn4Cd4YPYBvgYxIKz83vu6s8Onnma?=
 =?us-ascii?Q?ynxpHqGxRH91rIRgPy6bVuf++HUeghX/pSmHskn4Fj9dUlFNAqHN+Kf4a5I0?=
 =?us-ascii?Q?ZbiMKCm8jDj6T0Hyc0j2DHGdAp+L4ivmr0qwGJkA8//CkrUl+JorNuJMK/x9?=
 =?us-ascii?Q?0JVSKGyfRm8J+H8jgT3Tucf/SFoM2jrQf0t+NKnUQnH3fN+miyEhi96Cwsyi?=
 =?us-ascii?Q?csDNkMYTRl21qqsiSReoB6Pmj2toj/OJSVybnUgaeBidXvOi7RyyAq95mLdh?=
 =?us-ascii?Q?qyMv8eq20tkFd8vwq+cFyzVaa+sepDTNH9pVIUwcgyc3mwh0EZNk0Pf88A9R?=
 =?us-ascii?Q?pLdXucN6TwfMXwpBh+qHpj1wwtcn3LloQUOo3ZAiMgHjzFZlX/ZqSqFGR2dH?=
 =?us-ascii?Q?k2xEn79Il0ouARde4SYGcTXrs9j00kUD1tuzLAeFjSVBoRTeULXenuE0hkz5?=
 =?us-ascii?Q?qf9dNg6TrbS7byQsqY1kbYCjha95u7d1KGOdvdnn9hxB6XzdBbH+O5giQ0/A?=
 =?us-ascii?Q?SmElDVnP4PGruBeUXYpj9ejAFSI5NvFFQf3GzBjN5afvajlhoHuTIYot9QPF?=
 =?us-ascii?Q?xZB5T95AIZkFE6zE0ziGNpJ44cuwFLhh5zJSjyT8lGLqN9dKjT4Rg/CIaMUT?=
 =?us-ascii?Q?bsTSDwqx0rtnZqKJ0CBzsHZPjSd/HYJXJiWlu0KLsh5ywehgtk83d4s/yYgA?=
 =?us-ascii?Q?PR+1tb90D8PYhoNfuG4R69WzBoQDnGJ2sdT826xDW15DqKzVcF3ew5q4oJZK?=
 =?us-ascii?Q?bpLHOCF753jYkP89uFhrMP/9cAjDZwO7q1iaUrTMVrvaDUE39BHydd8MhK92?=
 =?us-ascii?Q?kBWw0fbYLZIbRRVk1ltJOmjeTMkYsJe7ikimd32iboIQeYrJi8MWmaUf35Ea?=
 =?us-ascii?Q?Cj0xms3A/pDZeAfXfFREVAB4SZNbN3HcoYi5uzyJjJa4o8IVt67QKbnC2KZ0?=
 =?us-ascii?Q?Rkh6JRhLTVgHX8EB+mI2vqggfKA86gMuOFV3JD9yaMCkh5jkluv8PfJnOMhz?=
 =?us-ascii?Q?tif+prjF9fnTfHrvtVK5L+7lil6I4Q4wwgVhPHaWSpQAqCSEwtjirkRX3qpw?=
 =?us-ascii?Q?g70WiN1vIKBa4nqu/mVMfEmVIP5/AwKRYLdDHXaU4c+1oqBwe0MnEe9gp45r?=
 =?us-ascii?Q?utvPsBOUXyqheaTGQmb/UiuUXXHVz886PsONxSU/+6wI25yx3U1WTyzZHoun?=
 =?us-ascii?Q?AxJ3KgBAAn4uZI+GbuYaScPb9UdQ6iiFgqUhiB1Gxna7rP9+g+ltB9c7WiUY?=
 =?us-ascii?Q?KwYNn/l2zsqSIpprNF8jy8rJ6aMO9vJWkwrToVyOWAxaJ4wq9GKCaUVHGkjh?=
 =?us-ascii?Q?dgtKpCzrsywuuyFjgNlXxHsZ0usCda1bCAkvN919SkeeyaZbPVvwrMntey/I?=
 =?us-ascii?Q?3hktzoz3RTLMnyldu8o7xN3PUjvef0LYX8ae/WTkftrQ+QYJuC2yXm88AGZI?=
 =?us-ascii?Q?3fJGQBABnMd4mJHVnJ3eMy6drdnajQncBLJ+6tv9Hmuj+JQvUh5O1IiK+RMK?=
 =?us-ascii?Q?8P9NUrur/DKfSlYHNADDlZjYoRHZ0qbYjIDhJWD2i6HwGvKXtYGhXigeHHXn?=
 =?us-ascii?Q?tk7P/M9CUMyDVr96Kppq+svYiBMlSu0=3D?=
X-Exchange-RoutingPolicyChecked: JrC/fg7HWThIVoNDjRVBFUPgDnlIhP8CFd760P3J/aI7cnbs2TH61x51CubFwtgcyf9jW1dIFsAUCwOqF4ZcoBj0w7opSJPworJhvvPYnYQ/1QMQFn0wsowXK3NtgTRO5J5Au1RCDNw3eNmf0LOzyEEMMRfP/iVWVR8LDRZke56USU7foEdEODD2oZF4acRKW7uO7QwGCWO3AsmU7COLE0bj10y/ntufTbPpQOxfM/DKEu1nKJje/jPK8BEoioiSq2BbWisMLs3/LYxHYJG5Uzbdj2Dpwome/jIFUUncXq1ny99nJcABFnIdIrrZxC+aV0GH7ZSqRJOgUrSn/tPd7g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e1b1eab-0ae6-4f52-b5f0-08ded6cea804
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 17:40:20.6626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aVdYsi8Es+2DT9OBUD+MyqUHI0nu95FlO9cPlXCYQfLMgp/FwgJ33htrnxwV0Kz5czMBvD1OKQvYNwDpI1lbIx2QDoILWhJQEDDKVHLJZbg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7955
X-OriginatorOrg: intel.com

On Fri, Apr 24, 2026 at 04:36:31PM -0700, Alison Schofield wrote:
> The btt-check unit test exposed data mismatches during BTT I/O in a
> CI environment, indicating a race in lane acquisition that can lead
> to silent data corruption. The failure was not reliably reproduced
> under typical test conditions.
> 
> Add a targeted stress test that repeatedly writes, reads, and verifies
> data on a BTT namespace while background readers contend for BTT lanes
> and CPU loops increase preemption pressure.
> 
> The test reproduces the race on an unfixed kernel and passes with the
> lane ownership fix applied.

Applied to pending for NDCTL v86
https://github.com/pmem/ndctl/commits/pending/

> 
> Assisted-By: Claude Sonnet 4.5
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  test/btt-stress.sh | 111 +++++++++++++++++++++++++++++++++++++++++++++
>  test/meson.build   |   2 +
>  2 files changed, 113 insertions(+)

snip
