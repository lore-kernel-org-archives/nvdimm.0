Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A2526FD97
	for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 02:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791598478; cv=fail; b=Ci8Tg/09nt5/JFZhuPZ9xOLTxjWhDqE5HNRhZKGqyVHilZ9HhxzV6GRZgU+VgDYr9G6LJ4sHKWCm1fJ3hG15b/aoxwsn5bZBZYsxtmderbTJDoDyZoF+nHy8qu70mYnUBP5uucIJlLW6k6ubbK3SDBDCw1t8ES6UHXPWo1Mqq7M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791598478; c=relaxed/simple;
	bh=ACL2PExxZnfVjPtsIbn2J3oVF3gQSfhllxugc/1aR70=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=J0b7unRbtHWZBwc88BF4yypN3Xh9fuEzJvejL9q5nIislxiHOCQoGGs3A3YZPPAFK+LAcyr+D2E7sURncZ0vDfrJcLhTrl5UwKCpa8Fz8+HSjnONwqpBg0Cv3XQEJNrC0EdsXAsjprAHYfF2E2PBlq7/jVl9kyqu5ZfOBTQ1bCM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MaGhEYkm; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MaGhEYkm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791598475; x=1823134475;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ACL2PExxZnfVjPtsIbn2J3oVF3gQSfhllxugc/1aR70=;
  b=MaGhEYkm3BfUkzqGMnXuz4G2U/zcOxK6n3XexheHjpCnU0WbAVdotvSW
   jzAGpQJyB2JG5c2mP+pZ3EA7bvMfDrrB+WTpTiMTfKRTB3G6KmH+RkXzO
   8m1PUS7IL4WyGCix00bDlyzzq4/kWi36qRTWuJzw3Vim8GU50UgvSObye
   wEpuU5FiXZQSRGZcZcKVW82yd9rPEjMOyA/ThQNRHHr6ePgjiEEZqUryK
   E5HQCIvHLIFonbX02zTuFMn8jSO7i/46QFnQki3QJ550RFNbkc5tkbVse
   DfNaSlAruGMuvL9BYVeUakpfaIRAl9zeQRFyy8eTEzwFkRb+7U0IszsdT
   g==;
X-CSE-ConnectionGUID: 2HmX61MdSru3xFEuFIoMXg==
X-CSE-MsgGUID: HcgTC9UoRH+Jqn7i/aBYWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11930"; a="299676"
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="299676"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 19:14:34 -0700
X-CSE-ConnectionGUID: FrWw01AGQa6BULPfH/DWtQ==
X-CSE-MsgGUID: 0KbZiDfjRtuKc5rF6CrFfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="766867"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 19:14:34 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 9 Oct 2026 19:14:33 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Fri, 9 Oct 2026 19:14:33 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.65) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 9 Oct 2026 19:14:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=INbnAHId5xgll1Y4idg2Ch/lT1cSGfw+IsGCpKofIdvy5G+RvOzfp034riQdVNO05QqpO8CUGYnGFTLhTatL5+b5zv0ov2fS5y2kYnXWmIQFkz1LNYUGvV0ORlXSt9TtyyHmqY4lHRz2ewT9JB1fAQp1tvskuAoe8BD5A7g/rxoTniyhu4Q7IVMHtLoiqzkXwMXd93pNPv5rUMDGGnS5gcZQayICQGXCrle2sUAPosfpWVCLlMOwwtegqAEp9YAa8e1LPdU0LCuVPXGEa19GeTRx3ypBKd6xtEyuVxihumhCI29VCtY2TiQsZZ3Y8KDqz3cpZjuakdlQ51+s9L7tWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cLgaFy5oKxKIZTMjz19TvIwNoD3n9madLgvlh00YqII=;
 b=c0TTFOWnLJxcD4OK3hvSaoiQ4gi2PqQTjsNcdGHc0ouXRUwYg4XjJAnKDZsh8SwhlSERGaOIF9GPSD+AwImTCyB7EeNwjhLbkB/v6G3q/Fh2p3h6CkYRL4sdBUYJlQpmMXceS219fN97H1KCo+Rpbzsr88TcXFErA8hnnbZVQqoPMq33ofyzOgEgPFkn7ldwXRhKYXEmWvQxKNQMTcK0D2yfdj4pxjpbTsnCYKgV78na449x4oRVlvPN9H0R/amSatrI+uIZwpIKn9y+1MVBRwFlnFU4C2FWPOVeDwrSHfQAqVliO+wjgnlLi1FzD1UwRBqQUGLcymjVRXBsFGcL5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CY8PR11MB7800.namprd11.prod.outlook.com (2603:10b6:930:72::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.16; Sat, 10 Oct
 2026 02:14:30 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0496.017; Sat, 10 Oct 2026
 02:14:30 +0000
Date: Fri, 9 Oct 2026 19:14:21 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
	<liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Dan Williams <djbw@kernel.org>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	<iweiny@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	<linux-mm@kvack.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Kaitao Cheng <chengkaitao@kylinos.cn>, "Oscar
 Salvador" <osalvador@suse.de>
Subject: Re: [PATCH v2] nvdimm/pmem: remove test_and_clear_pmem_poison()
Message-ID: <asmffUJ1gPDfaAvV@aschofie-mobl2.lan>
References: <20260923055318.57485-1-kaitao.cheng@linux.dev>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260923055318.57485-1-kaitao.cheng@linux.dev>
X-ClientProxiedBy: BY1P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::14) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|CY8PR11MB7800:EE_
X-MS-Office365-Filtering-Correlation-Id: dde367bd-0f09-4f7d-f29c-08df267437b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|10067099003|18002099003|22082099003|6133799003|261009223027099003|11063799006|260925021311599003|260925021911599003|260925022911599003|56012099006;
X-Microsoft-Antispam-Message-Info: l1jsDAQ9zQoTfeRJznc8g3jj1NUPFR2CbB6V1W21XwFzrwJ0hX0ds4sX1PrnaNU4x24W3BCv8eUdhXEQDQv4BInQKLPLjDZYV/I7ouJOJQzIZ6MBdXXQJrjvoIXOxEulyyKTsYycXGPCfRoKrK3PtpjUfLYiwLNuRh331oM7OKfFUMFRvuHLmTfHZVQfWOsVK14g3impYo49VO7SIRKIKDmC+xLXsRajMA/WZKieR0wEijhCjzoH9ghBPcNV0LGZyH9wMUn+qRG6sRaAF+tuAzoaK38rDQ2oqJt0CW/gl5OB5kZOw4I3xNkZekotGzPPGjNb96b2nuUw5A28CRF5q7bXjRmVAmwJaI+hEBrRIeDBmhB+V9Ho7g1oVIb+Ka5MhTWKayPmLjmrPCPOGy6buGd5W3OWqlyHjftrjUruizNUvt4uDaYN9LsRhTZGpyW7Y9+wf1F/ilKUfl0aI3hM0dB/Zr7xBVzLBCDiKd0wLwxaiWLBjMPNvZDdlBhPpuQfAskU+/cUgP5QvhI57ewnIaY0YgOljjNh13EiL74f3atFtGlKuoksIGapJPMeDf/DQZn8R7Mxgcou26XdgFzXQFniFc3jkjG1WEb72ItTzdQp+atZwKpdiLAshRqu2mUb6jwk5nNItCORK4i5m/65g7KiY10+qvX9W/HboasMTTY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(10067099003)(18002099003)(22082099003)(6133799003)(261009223027099003)(11063799006)(260925021311599003)(260925021911599003)(260925022911599003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8QGKyixvmquL4x36byEtCxxrQ7Deqh8siJZjQKbsEXQZUL+/gtgU8opRRE0s?=
 =?us-ascii?Q?kd8hDXMBhx63BISitZrPQEwqDJh5Wj5C957s7G7G0mov9njMnlUHkOzGwRJo?=
 =?us-ascii?Q?SFDZJ+uRfTAn0350c6X4qRdjsc4UP/8Kk64oHlUHcP1bnG22ewdUMlq6PCMT?=
 =?us-ascii?Q?Qa6CvessQLep7UEn68JhDOx8aKo4Vnj1mCXc635OPPUGaqx7tXQ55ewfN/7y?=
 =?us-ascii?Q?DtUhJhMvYvwfcOVsN2ToIKCiMjgtfM/yRu/r1hejnzFYbFB87yI1ydVfv4uo?=
 =?us-ascii?Q?v9ZY/5Iawb+idXFnepsC/9JR2BOpcMwsTjOusR9oiYBdhB0wWtnnOc7tYynZ?=
 =?us-ascii?Q?cIz9wg+3ZMJ319XZi2vvd6ato7n2gV2aHcjB3waMCLmYdLPSzNHoHal3dh4p?=
 =?us-ascii?Q?uduJ8Aekb+IfJuFw4Rfm4esTTm7S3Nw+0cVyb0ROILQWO25oNiiIZLxvvQsQ?=
 =?us-ascii?Q?4ZO1zEEQDbMMGRgxJZnwBCu1rZ0MOIARaL36wawFTF2Yv5psf628pqqClhhM?=
 =?us-ascii?Q?WZjZJEvaJIEzkk/56IvePEY2gkThdXxSNKWyUp4XkVzkEoAEt6Z3PY3qqjv+?=
 =?us-ascii?Q?KOObdBcjpjWtDtbTAHtnDu+okW/c/CTIOUJdiHY0R/exXf13mQxm+CDVjjZ3?=
 =?us-ascii?Q?GK6HzaVVHKev/wfbJ67+w9eBqr/qZbbE+HcwlP2gohqnBrNgmi4SM6TF3k0N?=
 =?us-ascii?Q?NJS3XykXDo5UjOS6VyjABHkW805grjQKcNNrO9STZM1PXg829ntdaDM1tnDX?=
 =?us-ascii?Q?FGoUChAoTwgpZT6YXcFMy/QJvijInQE4DC3Nam/mv4+5+YHNlmnS5nNKMCsR?=
 =?us-ascii?Q?bZ0fj0Xqt7u9jXdcY0qTL7PBcy7FLrqaGxk0rkaYtzB3/v/LQwafG2/AJgZA?=
 =?us-ascii?Q?3o5u31jJBo/ja9+M4i8OfRDDR7tA7yE4WIEZA44tb6PXtNHh1PVa/X/+ku7j?=
 =?us-ascii?Q?kzzzFi/UiuCRr1uhK091YVjhGGbLoXoAgdPQFYrTel1kb4gFmRfmbh6EDgLB?=
 =?us-ascii?Q?FDnbmDcIIcd6ND6oTHmn1Fmb58LZyH34STKRx9opPO/MN0dyB31CGPN1jDuP?=
 =?us-ascii?Q?wpNaWhDrSHwuAq58WMiVRGj/TxiKJse7YGBmTKTTC4jMVAllmxvgKxgXArku?=
 =?us-ascii?Q?sQ57ON/RlNKDQVtb/nQ+0vI6zqIZcqhzotSXy0zxkarmYMrBqSauSR6t1cD9?=
 =?us-ascii?Q?ckY9+lb0G0Q1IFenUTJRVun6EHA13+l8pu61T28Db9ljI1Mm8rwAAwsPSVY4?=
 =?us-ascii?Q?fphBvU7pCrS/kc+e7hcyk8Fe4vXqpJ4DMJRikdCQi7EIG9C6P+y8Wo3x/6H6?=
 =?us-ascii?Q?lb41V4K7XXfP9j8AP19WIz6kLX0eTPmvVEhyJ/ny052aBBcRcWAgR7AemoLO?=
 =?us-ascii?Q?FyjvUAHlUIdbGErH6mcer+Iq2RZZVBQB4UdRn0hPFf2A16l4qOM5OvratlkA?=
 =?us-ascii?Q?Z8p3TWrLkylwjxOms60i3wOMfKc7eijGu6Jo02UH6tsxDIJKwapz+xyweNYB?=
 =?us-ascii?Q?LpuDFpYm6RUlySYqzr7OOXgW3w1WAxyBmlQWh7y03MJwc2fEhIbFZ7/otdqE?=
 =?us-ascii?Q?gGreORUYc8E7F3Jw9UtukUqb+r8sa0pxhBxDwHx5UbtMsRt3ltDUTtXLjt+z?=
 =?us-ascii?Q?ml6ODjKW1Aw1Rgs+9xSoYj4Hec1lEPZHtq8O2jECRiSucLs9yiL7wECTc9oU?=
 =?us-ascii?Q?6+srZwkz8PG3M3eBheCTXr2j7yNIpYgvUCnN6QhryQAvpBM7FvsvpJ1335o+?=
 =?us-ascii?Q?C5di/nrVdp2xbsm/wj30Cu8iKHEwDmw=3D?=
X-Exchange-RoutingPolicyChecked: C7tCDtwZc1VVVge/Dz/7YzuYraxq9cj+TTwW7DZCCiSACl2mWahAopZ+ZLz4xreyVePoncRCVTR4GwhffBumSxJ6CZCiVfgtxjQ3oK07+hqb470X/bJ0H1DJ3i9aVikrpohfYj5QVyzvh7zYrle4r3f/LtanruRx9oP6bLfZm1wRvd6IcXxXi736mQP5/9c3xn0GvDxrql9kHyCW5D8RO5NJHv5bi8zyriPOVsyrzcU/sXDkXuAe81RUA6iZlTkV8gVqs8qzYndtWsLw2MxSh17pbvMax9IMmr9pUkIbYbE/hEunicpdVKU7e6EQXIJgeNX89Lg7k1DTySOfLxQ+Sg==
X-MS-Exchange-CrossTenant-Network-Message-Id: dde367bd-0f09-4f7d-f29c-08df267437b3
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 02:14:30.4332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tb1zQumAqmAjxWq5s975/z9+uTRs4yOgLNg03Kn1Yh9jWBfer/o6xS/GPCkbUu7D7spkdJ/QfWWDTt7DqebQez3hyNPAWfkgmPBufLzM9Hw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7800
X-OriginatorOrg: intel.com

On Wed, Sep 23, 2026 at 01:53:18PM +0800, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> The pmem driver provides test_and_clear_pmem_poison() only to handle
> the CONFIG_MEMORY_FAILURE dependency of TestClearPageHWPoison().
> The wrapper has no other pmem-specific behavior.
> 
> Define the HWPoison test-and-change helpers to return false when
> CONFIG_MEMORY_FAILURE is disabled.  This allows pmem to call
> TestClearPageHWPoison() directly in all configurations.

I see this merged here:
https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-stable&id=2492d9c0afc02cebe8318155829e7d03bea617b8

Still not sure how all that works, but I got an email saying merged, yet
this list was not on the email thread.  


> 
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: Oscar Salvador <osalvador@suse.de>
> ---
> Changes in v2 (David Hildenbrand, Oscar Salvador):
> - squash patch#1 into patch#2.
> 
> Link to v1:
> https://lore.kernel.org/all/20260903053535.17611-1-kaitao.cheng@linux.dev/
> ---
>  drivers/nvdimm/pmem.c      |  2 +-
>  drivers/nvdimm/pmem.h      | 12 ------------
>  include/linux/page-flags.h |  1 +
>  3 files changed, 2 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 30a51c365ce8..5fb86595e8bd 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -80,7 +80,7 @@ static void pmem_mkpage_present(struct pmem_device *pmem, phys_addr_t offset,
>  		 * here since we're in the driver I/O path and
>  		 * outstanding I/O requests pin the dev_pagemap.
>  		 */
> -		if (test_and_clear_pmem_poison(page))
> +		if (TestClearPageHWPoison(page))
>  			clear_mce_nospec(pfn);
>  	}
>  }
> diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
> index a48509f90196..76870505dd79 100644
> --- a/drivers/nvdimm/pmem.h
> +++ b/drivers/nvdimm/pmem.h
> @@ -1,7 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  #ifndef __NVDIMM_PMEM_H__
>  #define __NVDIMM_PMEM_H__
> -#include <linux/page-flags.h>
>  #include <linux/badblocks.h>
>  #include <linux/memremap.h>
>  #include <linux/types.h>
> @@ -31,15 +30,4 @@ long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
>  		long nr_pages, enum dax_access_mode mode, void **kaddr,
>  		unsigned long *pfn);
>  
> -#ifdef CONFIG_MEMORY_FAILURE
> -static inline bool test_and_clear_pmem_poison(struct page *page)
> -{
> -	return TestClearPageHWPoison(page);
> -}
> -#else
> -static inline bool test_and_clear_pmem_poison(struct page *page)
> -{
> -	return false;
> -}
> -#endif
>  #endif /* __NVDIMM_PMEM_H__ */
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index ae2ebaed6d4d..3dc79c0c5adf 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -655,6 +655,7 @@ TESTSCFLAG(HWPoison, hwpoison, PF_ANY)
>  #define __PG_HWPOISON (1UL << PG_hwpoison)
>  #else
>  PAGEFLAG_FALSE(HWPoison, hwpoison)
> +TESTSCFLAG_FALSE(HWPoison, hwpoison)
>  #define __PG_HWPOISON 0
>  #endif
>  
> -- 
> 2.54.0 (Apple Git-157)
> 
