Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBE61D63EF
	for <nvdimm@lists.linux.dev>; Mon, 28 Apr 2025 20:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745873794; cv=fail; b=m1gRFruy0mmbv2rrXf0sqwX1Us25h24D6spbs4OJCK27YHnEJR3Lit5LYy13eNPCf9RyeLmMZTh13bpi8qVDQ/l6amwIF/b3yGItZVrcsCLM5upucpGC03si+hT5WPekbXUAvu2cFJjRDhRUoFzD2hT5XVgon98ecwLEulaWZFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745873794; c=relaxed/simple;
	bh=awQkZD+QztVtK+zI8F9W/JXhKOqIMSlmK+3MCQgj1Xw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VXECBaoGONCdbyKnPzDOcW1BpZbbYevuDW3ofETWIpM0PxijyeFfZPS1fUQ8uXS+Pr2WrSp9I1dLYptq7s6yerlJlYan6HVpr2wnUTJ+0KFl4tza8+AjUYUmzCy1EFMxJNzUDjMXxtrAmY4ov+QO+r82kEBN1Ik9NFMnCuwm8h8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BnqEjJAg; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BnqEjJAg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745873791; x=1777409791;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=awQkZD+QztVtK+zI8F9W/JXhKOqIMSlmK+3MCQgj1Xw=;
  b=BnqEjJAgaF0VuoEs3PpfaQ64rYU6JSlQCKYCtRkAw/cczD6UliI25c5f
   dOAxKtOBMIWuWPmXdXGALwwxySt1DaQebcoccZyddLbxUQKm2DT60b9n9
   T3XVMOIemQLg9ekX1oxRR6hZOtTN1wsUAGdB0zI+YApTKZAR9wxuRSiET
   b2hxehGZw6IVczocJu1YW/0q+inZpUieeH6EFnhU+AcCkfzg0I4eIVDH7
   Iv1nKtwJtQp0USS6QRr/dKspjMYd8q9heSyA1fP4wBscBRquEEsAzBHqz
   cDxtDydO3D6A5ZY1kysnNHaxVviHdOesss9gK7cs4gVkbYqbiU/epqtIs
   g==;
X-CSE-ConnectionGUID: G8kmsbaSQtaP3dq6RYlcHA==
X-CSE-MsgGUID: KD6QzqC5TaqMtJATHmXLbA==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="57681858"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="57681858"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 13:56:30 -0700
X-CSE-ConnectionGUID: SfArshZYSziayCRUVKFsIg==
X-CSE-MsgGUID: cgDPM71RQgeuNCSm6RTxUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="133940363"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 13:56:30 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 28 Apr 2025 13:56:29 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 28 Apr 2025 13:56:29 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 28 Apr 2025 13:56:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z7mup4r/j/4JU4UYEeN3WhE2FCQ4l2hOgkznnmj/kytIEw9Q82N3S9wOjRR0UPv49COzaPtqnf1o++E3GdfXMdonAgnHFEh1fU8leqC/EVIcR03EBx2g1bf8h78NmmEKRXZIEFO3zWKeeapGKAE//yWhGJJQo3BUJ3ybypEEuNMtPLHouxNsACaO7o+FoVbBJPmPC3XSfFk8cU9JH76g3lygoHJ9jqBznKaT05BdjDTCWW8gRRVs2y7X5OaSolHrvILaLq4YbUCjyvBggAOqzM7YBPm1BLpb60PC/0ljK380hx3Q6VLv72DbbfaoYIiCYvRMp9FqGDhaWOXaUka+YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z+zM2AF1VvuW39LnmZx3JM03W7W2eIsgWmglzYZlHsU=;
 b=gdOBl4K7PZ9CTvMrBu81xuYQOxEOCLPZhzdr8Ph7M8ADZYUgRlZ05G1FOP7woeCjDGloTqNT5wip9MFFSnvsV4kWHm9tcf1ub9R5PdMf+FiQqW+CT4wA5w26u5F94KTEWDSQzbUKA3OgGaCbBYZhQs2b29c9rOMq+qtLX5Kh1q+TZOCQ7gxjk+cRV1fxt+K3g85+aOcXVk9e1B52lg0sdunSNebGKqbD+hppGMD2cj/o0PZpi3lyCgimTBabg9CKDKHjkFZ9GEdcWlqEfEt/JC/MFpgeW65BhS87xjFNrQVKObH4YSr3rUM0lssuBz96cgds+zdHK9GS8ZrJ/mofOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA4PR11MB9418.namprd11.prod.outlook.com (2603:10b6:208:56f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.33; Mon, 28 Apr
 2025 20:56:27 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.8678.025; Mon, 28 Apr 2025
 20:56:27 +0000
Date: Mon, 28 Apr 2025 13:56:24 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: <akpm@linux-foundation.org>
CC: Gregory Price <gourry@gourry.net>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<kernel-team@meta.com>, <vishal.l.verma@intel.com>, <dave.jiang@intel.com>,
	<jonathan.cameron@huawei.com>, <alison.schofield@intel.com>, "David
 Hildenbrand" <david@redhat.com>
Subject: Re: [PATCH v3] DAX: warn when kmem regions are truncated for memory
 block alignment.
Message-ID: <680feb78d4923_1d522947b@dwillia2-xfh.jf.intel.com.notmuch>
References: <20250410142831.217887-1-gourry@gourry.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250410142831.217887-1-gourry@gourry.net>
X-ClientProxiedBy: MW4PR03CA0327.namprd03.prod.outlook.com
 (2603:10b6:303:dd::32) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA4PR11MB9418:EE_
X-MS-Office365-Filtering-Correlation-Id: 12b175aa-89ef-4bc3-1b0b-08dd869724ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?dj8ILjcS0HLvdtCaAAE0oqY7bZCkRZkV6vda6sN4u4XJwfrlamB9bJX4WpgN?=
 =?us-ascii?Q?qG5kRQSrkEjPahuLmaehbxo0nMNJTj2OENfmtO5hJS5q1vDSR946zQJ+8ocv?=
 =?us-ascii?Q?akuVoIHHGFNSQeHU134b1BzHqvNTSM9MOIM9HLTcExj3UzETKX+b6c31zUsx?=
 =?us-ascii?Q?cFEjyRFIy2suU7DRVCJ773NR/pwEAJMQG6sz1/hT/+7ruYOIN8R7z6jw4znv?=
 =?us-ascii?Q?rJKmmmGnwUWodvjEdNwN/hJub+3gczywmUT9f+CFzBpdIy4/2IqL5er8gxsm?=
 =?us-ascii?Q?572CUut91GJ03VoGBK/KbAfsDZ0XizHQ/lK72VdjtIFKJHX2B7nHgNAlszvN?=
 =?us-ascii?Q?F+RkahxzqpPwBqngZiBGAe9/BZ9WWgE50kfr9kdf2NJUUgdkOM0F8u0rldJv?=
 =?us-ascii?Q?vhufuRNiQ93ekElM2DwlF86io5+EOdsbtDIcWT4RWy3FWpBlnt71Tq0KoCoC?=
 =?us-ascii?Q?LlTnhfJcsDC58W0hsNkuGAbYIiTgf+ayOKPSD0tgmr1X6CVtoCnH4I+Bcb7y?=
 =?us-ascii?Q?NqLig2sLKQYRr1MTCfDBO8e5WQns9ciT9lYGUIMT1sq1QLpRp7pWKoLLAJ0K?=
 =?us-ascii?Q?Cd78zDHyx2FCHlXhwOkzHSrz1Rc6vKAk/UHATkJOM2eWX+nYe5NtrF247Ywv?=
 =?us-ascii?Q?lqB/fG6g9NUWtUasuOhgg/1oA/+E2S4+JC4AwGgO/tksq0qEB+uPX80fe1mF?=
 =?us-ascii?Q?sf6GWs8siVR6AVBORX+I6fxVIaQzZVxZGOvaWomuaQ6P1tdbC8w+ONMvgBgn?=
 =?us-ascii?Q?ocSjxfrUxTGg/uWt0vPUXvNXP1O0LuBmcEvxk6AZTORF8gCo25mj9rjwKQMk?=
 =?us-ascii?Q?xRkHeg87VSmPxVMqLXnw5b8r1xTho4M8NKP7/0r8j64Hgono+5vjWJvfhO6B?=
 =?us-ascii?Q?ZPqinbC6hEmwOvCBR8kzuUUih4lLuf+hxRCNFe+/v+2fFjQ1V5YIQpEFevTk?=
 =?us-ascii?Q?mG6E1Jlcxm2T2hEnuECwNEIIgIV1/l6fKessTfOeBzluVXiyNjmdmzflj/y3?=
 =?us-ascii?Q?RYj2wHY8oQPObK1domYV3j6DQCNmIYVBah1wGOY3IWVUJ2bk1TqtABbl2K5R?=
 =?us-ascii?Q?acAwklkO6eeIDXhMdeELnOZma33WM2n3wiYbHaxUnPzIYCh8PMXr4BUpSLvF?=
 =?us-ascii?Q?rKhmE7YW9VSvHB5eI6T9AwfS+0WoU437R0CocJYYq+NLjfCukV2r9/RXI31y?=
 =?us-ascii?Q?eCniF45HdEDMwmIw7xDmdhix/LX2XqHp6MMofq8XKtIOrdKRFRTS/jXL2fkN?=
 =?us-ascii?Q?uggvgJeyaQ39Hltlx+qkBVn7bGevTcWpCe12b6UVIHHSnknEUd9J0jE8uvMt?=
 =?us-ascii?Q?RrePUqTzdchAMQXWwkD/OMLRy2lj8YNCOeLhjvRlsfjgWcRw1+NQ6CX4a5y2?=
 =?us-ascii?Q?qJMjcHglPyvVxD3xKEqsGSAzSH2q7riUDzL1nHcYUSA5zyKJJw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RCqSXPFmnMtwesOC+jvnHA3lByI2X0czRUk0VrZRUS3YtV4r2+61OeBiONKx?=
 =?us-ascii?Q?GbgM8wx+cPUt4wkDaBr1dvt7KxMFDeLdka8ERyJswb2pQEyRmcw4OApT4owy?=
 =?us-ascii?Q?ALIymdfkuE7V5tC+mzUueAEGHf9tdNVQdJa5vZLFDCGKFTgK3YFpTcw6wlBz?=
 =?us-ascii?Q?iL6x6bkBq9HjGnWZsMOmV1u6l9SvAK0Qhbg8NuXzWhPLe2E9G0+MIVQ7VPzm?=
 =?us-ascii?Q?i1QdJWnPyLXq4NnV4PsbH9pAN5h2tBi0sxQCkzv1JkoMLyfxUHBWahAVUm5T?=
 =?us-ascii?Q?c9qN/XjCwfnU8sTSk/BEnNv7CG0/6a9bTSaPu0P00wsuY45dFQFq1g1ypRwY?=
 =?us-ascii?Q?unbN9QSbfaDds/qShg0vqF1cI+aRcC6/9tFxrcUj1ikSa7HgblMsANg0U/zv?=
 =?us-ascii?Q?4Ek6SfQE8Fugue+WwlKOAnNNekOJi3ba+s3yDeYMQ5MaCTEOlZJnZQ97bEh4?=
 =?us-ascii?Q?6bMrdNDTv+AAQ1pMQbP6/61z5y0tZCWIIVQMM71McNcGTjrpUHC5r/AXCk6B?=
 =?us-ascii?Q?G9lSVgSDpcEmOhEqyeb6pNm2wZz1ryFoyJ+BIx/WsgsOuBWV4iMXKNXPzq9K?=
 =?us-ascii?Q?LAjVyW/MFUUrIC2/zWwgrvGMzi2isLudDRh+qvJvlLLX/bfn3lctJ4B99z0f?=
 =?us-ascii?Q?sWgmZ/8zrytnRzj5yONnsplf+7Ljv8bAgP/iWoFNldigxyIQFf4zI25sU63x?=
 =?us-ascii?Q?hIuhK/5EfxcnxSftUNnP6PuxM+8tLBDc4I6EEUE6Z3zakl+x2/ZuU0GEXgVB?=
 =?us-ascii?Q?yRJ6HLPZfxxK4QLo1VO52X9eXKNlUwYlJpsTCKdFhyUqCbbrz7W9ur1uFTND?=
 =?us-ascii?Q?W1uj+BIuYQ7y0Obi9aJn6nBj90axDN011Lx58p59K3cHcdnV0tGybBDopL4S?=
 =?us-ascii?Q?ymfXD5/qjCFOnI6PPtWkje1Rnbz1bvv4wI2uHjDbudZtYYeAGe+qEF0ra/FH?=
 =?us-ascii?Q?Fn5hrh3ZuZ5t5+AntEuwQflR12Tyhoj79M3xzG0rNeKlp/HxnZXJyi4ZbYtR?=
 =?us-ascii?Q?YOYVswhScFZFOoevZvrSGbUXI1HhH5xIvJd6L4eKud3NzYgQNyWXgJLsUa9K?=
 =?us-ascii?Q?TrcXDPwTUUKY5icHjUdbsL/FHDf4UhrgLrFvoS3ynL+2zfBF7aZso6FGuVf/?=
 =?us-ascii?Q?aJmrVa1AOkR5baqFVqh3/B0rDA/IYeI3wfSB9ySKEPaZNG+2WGaSbLWZGRia?=
 =?us-ascii?Q?ua4UUvPSwwBTI1CqEBQGvWB1AzqqRkRSJCRQj0unX3+l6CYrRlaPiTTEwc0D?=
 =?us-ascii?Q?vP4bnXXXBtouyTy5ZA4N4SH8dHaU8jq+7AI6WTuo+TqCzk+GKNSu1X2HXjEf?=
 =?us-ascii?Q?bDOp2LnZULAinV35mv9/+pgG/PeIgqiSxEuUACF7EukXfr0FMTEflmQGt5JC?=
 =?us-ascii?Q?IyhmhC1esIe4CWS3u0G+JUGjioR/voMT+Nztppb6Xnd0rFx/HATZD8vhtOCR?=
 =?us-ascii?Q?bhwbj9VEddV/xBalgruOTWxavs95FxS9QihZatzQDCf3AzCmsPOLGPge57yr?=
 =?us-ascii?Q?PtCyYppEYciLNxOLIayUE1B+XZa7PNWLqC2RHYWVxkA36U0om/z8z/wEQG0g?=
 =?us-ascii?Q?VSCuQZkG6qepKMfWC1Pl4WG0O+nQoVJ8QzifJ0h+4g10UTFwjAzF0lSjzgeS?=
 =?us-ascii?Q?7A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 12b175aa-89ef-4bc3-1b0b-08dd869724ac
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2025 20:56:27.1597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +QlGHAfksmPkfzLb+nSQKHsF8D7LX216u5o0xyO0kWjVk7j6E+5/wOpY2EDWL94u61QgujCZXvDEQo389gdADjae4IMekSBT9YptOYwucdM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9418
X-OriginatorOrg: intel.com

Gregory Price wrote:
> Device capacity intended for use as system ram should be aligned to the
> architecture-defined memory block size or that capacity will be silently
> truncated and capacity stranded.
> 
> As hotplug dax memory becomes more prevelant, the memory block size
> alignment becomes more important for platform and device vendors to
> pay attention to - so this truncation should not be silent.
> 
> This issue is particularly relevant for CXL Dynamic Capacity devices,
> whose capacity may arrive in spec-aligned but block-misaligned chunks.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Tested-by: Alison Schofield <alison.schofield@intel.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Gregory Price <gourry@gourry.net>

Hi Andrew, please pick up this patch:

	msg-id: 20250410142831.217887-1-gourry@gourry.net

...for -mm. I now notice that MAINTAINERS does not make clear that you
be Cc'd on driver/dax/ patch for eventual upstream merge.

I still support dax patches going through -mm given potential
entanglements.
