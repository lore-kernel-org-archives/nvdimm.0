Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83194322B
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 15:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740668920; cv=fail; b=hsUfj1BkGt+0RMyJPeeMtuoDod5eAtyGfez3ldWxlnHG9AtFDWpA0CQM9/eKx4aMRpQOjNA9uFVXMANfSiiqcBDExkX4GnTl58EgFf8k3/xC6UAC6yVNV5ZXQ5vCTu8uYNRYAnM1O694MeOnq2eGlGUzi4w2FuZ9A+tS4aDQe+s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740668920; c=relaxed/simple;
	bh=0dB04sgWHXHY6erKJ93uTz/ZLI9T+x+aZfvhWUVAS64=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kupttrF25JtvjKa+SGHruCGxqQ04NELujcBddGRfXDh+GGFr6eYSNsb+fH5F5cNuly3HUm5+9M3chHdiSh3y3mWWsuEo9Ey+DFxmSzJXADJuCf3b6J3NR09ygX+CXsycaEZbKcICoaZ1b75GLDcxErhMiuATJYIo2fft0KVoA50=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LGMuad/R; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LGMuad/R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740668919; x=1772204919;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=0dB04sgWHXHY6erKJ93uTz/ZLI9T+x+aZfvhWUVAS64=;
  b=LGMuad/RPExHGkomziP/1dCFWmeEagacCTdweIqr4KF2HSpmwz+E/nnA
   +NLPf2u55duHqCq3dPAhiWi6dKmkc4BvEB97M8ODAAwEzyonrhHfnu26g
   96OhynV2as0B++YCBgnrjXz9Y8H12nn43aqr7LJlBTxH6K2vO4+qUvcCj
   4vo/dyv2SU+A9b8PyvRbL6io4qJhVP2hJt7vPesEPEG+BW+PN3+QZMDzP
   ksMz9mHyNA0RDQMG4NLunrUVvJ79/dYKuPI3XZOFzBk1pUZ+AIEt+HVPL
   h1U18m3rg9/fCTKEBsmXkp9eauoVHvgpxyKPJf91xpE6ygBIjvcSvl/oa
   Q==;
X-CSE-ConnectionGUID: T7ce2lxwScCumvnUIAY5NA==
X-CSE-MsgGUID: eKOmlcECT9KLEskN4gTRfA==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="64030436"
X-IronPort-AV: E=Sophos;i="6.13,320,1732608000"; 
   d="scan'208";a="64030436"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 07:08:38 -0800
X-CSE-ConnectionGUID: lsk5zEmZQYeF4LVt4yRfaQ==
X-CSE-MsgGUID: ABSsQkmmT3mQ3GIJvy0HBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="147968201"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 07:08:37 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 27 Feb 2025 07:08:36 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 27 Feb 2025 07:08:36 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 27 Feb 2025 07:08:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yvanWeNEIn8ycYqMxLXhdttbXHvRMyO6qScCEJiTd4LZ+Z83C95ZIW7+UD01q2/f2TpgAQiX/uxijwytNV2l2M7D6mgUYbm77RwmDcf/8DncdMXLMuZNSDOEmf64g9VxEqvPDz5fQGzXjTatEZXkJQw/yzQUzIDw7dXXj7BIO5rGnZe8+0HKh96k9BHL68sirohOQAMgoot3gYdsITg9LQGRRQfM5ilWf6F/IYxY3y3Z5D1qknxOWNjIdVjiSVe9pv+nraSOjletXsf9BUyCKSkdGVp13ZJlOS7D3U0qfGPWQtlOo/fq0TjCN2UhCIZm9nnnuIuE/eOfT9KDpqo9MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DSLHobSZ2maUKUHSiq0hUvp02tER7PPhmEJGn5QkCx8=;
 b=NrvPf8rBZ0jJlRVs9yxocO7dEh375QE1SPEZfPKffBaFIsQhlafFuIFXgm4tPgtGveB2d5s6zWaJ+i7ihT5dviL9wV6jj2otGMhIjgDy5jvwydQ4P9VRrmBktBu24SqTWooBdmu/zOThLmlPw2n7Bz5PE2qM7fSSTFNw5S3zE5qYNQeM/XE4RTcX+WNs/sUgd7rsG9KvfL8AtGdGRsg38VUh+ECql+7ClUirWZXVEIbvfHLGmS/SvUM4NKmuzuuj5T5WK0dw3yctbXeNEI7qHDyOjhHSD8dEFRXALC2DtchCkYoBrEhaGE3M2s4y85QvYppxEEbds1PA/C40So58xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by PH7PR11MB5913.namprd11.prod.outlook.com (2603:10b6:510:137::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.19; Thu, 27 Feb
 2025 15:08:30 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%5]) with mapi id 15.20.8489.018; Thu, 27 Feb 2025
 15:08:30 +0000
Date: Thu, 27 Feb 2025 09:08:28 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Zheng Qixing <zhengqixing@huaweicloud.com>, <axboe@kernel.dk>,
	<song@kernel.org>, <yukuai3@huawei.com>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <dave.jiang@intel.com>, <ira.weiny@intel.com>,
	<dlemoal@kernel.org>, <kch@nvidia.com>, <yanjun.zhu@linux.dev>,
	<hare@suse.de>, <zhengqixing@huawei.com>, <colyli@kernel.org>,
	<geliang@kernel.org>, <xni@redhat.com>
CC: <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-raid@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<yi.zhang@huawei.com>, <yangerkun@huawei.com>
Subject: Re: [PATCH V2 10/12] badblocks: return boolean from badblocks_set()
 and badblocks_clear()
Message-ID: <67c07fec6b138_b295929498@iweiny-mobl.notmuch>
References: <20250227075507.151331-1-zhengqixing@huaweicloud.com>
 <20250227075507.151331-11-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250227075507.151331-11-zhengqixing@huaweicloud.com>
X-ClientProxiedBy: MW4P220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::17) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|PH7PR11MB5913:EE_
X-MS-Office365-Filtering-Correlation-Id: edcb5914-ce91-444f-5beb-08dd5740985f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?4t5rDDyISW73jRnW8+t6UXQ9d6hp3m5+srzRlMBGZJmGttba4MaODyspvDl9?=
 =?us-ascii?Q?a4WcnagF1doGYdxoj8kYRVzjeUzGQUN9YbwGmvOh3bN24clpACl8JX97u+B1?=
 =?us-ascii?Q?UK+kdQoHbdDG2ifKnRSAQFL7HIpTz7+dTxL9xooNsffOqPIDT7dueWe/57BA?=
 =?us-ascii?Q?rlbpQJjaeN3Cbf9VhcWjmPu2JGDtMwXKoKfCcG78H34ozUwBdM1tO/W5PLgF?=
 =?us-ascii?Q?b+ZYSjFzb+r3qiNIaVjpyHZ/mD9Lv68HsRY70uMRJWgTUksX19hCJXLUH4Zy?=
 =?us-ascii?Q?wJLObWSgA4zc7lHIeBErY7zvDqFFJdefc1WgMXPQEAt3O1VK8v4vmMNuNW5z?=
 =?us-ascii?Q?DABDGuDOVYMuWcy3k5WLJVlE1VHXJV2RclUiV/GdxX3N8Fm7EwnPH3nDHSC7?=
 =?us-ascii?Q?JfH7XTTbRg8P8x1SdOGQaPS6BZ2veQRz0CxN8D3UO/45/SHSKmrv6Q7u+2VT?=
 =?us-ascii?Q?jG/EVGNMZ4y54Y5xzHMUHDFPRRnhdlE8yLjp90WgFYpoXU+6mqmBBRSuuvIa?=
 =?us-ascii?Q?GJ138vwU6xsQfFfSWGepy5gW5ZXp4gmZg/af4gIvcLNKXn35E1ZxovAF18Q+?=
 =?us-ascii?Q?1bEB1gFzmWKpyHGE8NLZ53+ztAvVs/8Rm18gsEheP+d5wgbtFTQPJdw1YbeW?=
 =?us-ascii?Q?hY+HGH1OqbuBu0YzYTJ71xAyderNhDv2/Kw1vpYvzrvUqcFClGvRJAgf8VtP?=
 =?us-ascii?Q?63Qxuzu9sEvLG5oMrgTQ0oi0Dxvp7jgcMANn6imyEyNcucjew/+f5A36cICz?=
 =?us-ascii?Q?Yqw7VEeWukZTm52/Kc/zG3yvGOj/LWFuQINdq1iJPy+I+DfKtdEaedUBF5HO?=
 =?us-ascii?Q?V76tXX1uzpx7j6amC2M9w5xPeIVwZx3O/WALHDSGotL8M+K4IcYWXg1D0i5V?=
 =?us-ascii?Q?1j1eNCSvBL778+WJ1C3cWKuuLKI88m/Td9f9RjuNF8gLGTCWpyqTb0PP5LmF?=
 =?us-ascii?Q?9DaPpVvfwlYc9P4y8GsZpNT2wPqghCa3MHjhsCxXZRL308BGykb/poC2xpE1?=
 =?us-ascii?Q?aMhLt+nKFw7Hz8hU6n5F8x4GfnYgoAHPQTAuUMKdNulkkrBBhLaCjcn38sxc?=
 =?us-ascii?Q?8tarZfqPXciZ0ubOAPxiwQG4halFNhLedwcwsRa3fIT7By9NK5I8/n1BWBga?=
 =?us-ascii?Q?5a8Zu34itmfSZ/1jjNCraUfAQU48j8fjeTD7oaUU6tsaXLclcHi4bRpYQdTJ?=
 =?us-ascii?Q?/2Hi7r49/no7CFZIhslAm0d7dHYgxi6OBF+enSb40185l07DJk9rSicujjrf?=
 =?us-ascii?Q?h+dHxt+GYuiuE2IKPF333J3m9pBF+NujMJwe9mXleZIk4leqK7Rar7Sl379Y?=
 =?us-ascii?Q?8OgTP0DOm1FjcL9WzXXzpduMRZXBnJL2ZtaZ/yY9ra7XT32H+ugJf6T6V/QI?=
 =?us-ascii?Q?3Hnl2CGa6MEBgwIoaEcqyEIs0aEzBN2wD9jpjFVFACjNbWhaoqpNGiHvy1GY?=
 =?us-ascii?Q?bZA9UDRihVk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6bYFBbABAMTDuhSezbI4e5BT+MMaAWCzOaamYMGAEGX1lHfN5ykztWUe0jGm?=
 =?us-ascii?Q?4wJjfIIa0MubkQ6OMkMG3UMKGWDri7zktvumx64Ik3v2ubHIXbpsjqo5++/U?=
 =?us-ascii?Q?d5W+BZ8YtpbrtgzBFwrs+qNc4dMWzwnk7JOWrV3OukXn8uf+LxEgeFYzDp/J?=
 =?us-ascii?Q?VJqKqcSz6zVBfCTFFHwSNhQsdOqowRM2Tx7FeQEYMEqEBzS0t/S9tIvde2wJ?=
 =?us-ascii?Q?Gdarm5iGOw0uFQ/Yzu7z0R6BU2FVo4XMmuyr5/9rp1or5kIFw7JCasjRiGSV?=
 =?us-ascii?Q?XNEv5iFJVkfThKo0X/snsRciC2DIR8+HwOu3WoXwmnp5K/3iWMsb0iEaZIlJ?=
 =?us-ascii?Q?skXuB4fdwh2sOetU774uTx4iH2eSJYz+xrMxuvjn6o/P5beHv87DgexmQVwo?=
 =?us-ascii?Q?vSaOembUKgzm4c/3q8gu3YFYKKi76Uf7rwqFBkSGXwsGlU2ATW4iI+dKlR2J?=
 =?us-ascii?Q?DaBfW42vBHpK5GjCqL6YukRRGKXyr8wxPjeo6sERo8q+Qcw8L6U8T5ccXyQL?=
 =?us-ascii?Q?DM+AP4Uei/U5giFcVTEVe3FOgCl7WQeJDX2AyGi0v8b5V6Sq1cxaAnDCfHXH?=
 =?us-ascii?Q?ueqlbbbdOqKQYa1dAK6i6SGvF3ttq9gtMYXoXSfr2tE7xpNB+HDsyNVxPDtG?=
 =?us-ascii?Q?9Xdfeg3hmN0nnjBl+qf+sdDC5BUVOG4A6o7dTHMeFzZS/e5vaWSW1vV5crc/?=
 =?us-ascii?Q?GAAg0i4fJko6JJAzE7D+b8Ddv+G66R5iAsuQ1Kn0JBBPngtP68REnXRLvkq+?=
 =?us-ascii?Q?TaLqrxy4b4mIgZJwStYs43CFkG4V2OzFeMx11IKDy4IwtGZE+ziVgJcApL/y?=
 =?us-ascii?Q?OqT+pXoIE5nnCjrsVBIUpj7R1+e2D/YI8xz9nr4GjlUjY5uR66uStn8T1UAm?=
 =?us-ascii?Q?dKBfoXCNgCllviE/qh9htiwmGp2uOCGB78EWHrTCk9pwAMqtlE6Byzv6EVFx?=
 =?us-ascii?Q?xIFcXNk5NrjHOt2SskRM6kKeL2k0mUMy/uY7/c36TfTwQj3zgdNZhDILdzEv?=
 =?us-ascii?Q?DfWSz8OVvkGTM7bTdVh50WOJV7QS+HB9/GuDvANAhALc86jpqaoWCsrnv787?=
 =?us-ascii?Q?HzDn9wd/Iq8CfZpCovwH7ApqH3/wVQPu8PrwLiaJPbyRu3mheWNYJAwq22aI?=
 =?us-ascii?Q?gL7OvNfIw9qlsy4AEf5cwP7UvnRfyXWqAEWmi3ni21K9h2sjwVDHP+AB6YiR?=
 =?us-ascii?Q?N65Yzvm8b2nzNwb5rUI3Lj9JNjyqJ9HwAo5jsxXAs6RUZzUH3I5KI1s2AcPZ?=
 =?us-ascii?Q?016fT2evb4NMT/vqSyo5tsbKMJnPC7WZitpqEZaR/NafyZeDsXdHQlHxyB0D?=
 =?us-ascii?Q?Iv1LgmsCnzaTCu45a8G4v6xpwBMPYaWqyKCR124914Q6QXYColaCRX1QNacz?=
 =?us-ascii?Q?VotUQLhJb0ilpCjiiuEyPX1t8AT4Yd0U9uGuLg297MDX2g/5ARkZARRdSV9a?=
 =?us-ascii?Q?zvXyKDkXvXHq3O1RxnMB+WT9FKssXHrwI3Wy61WZ2v7L1sNvMSd7Ao/U2Wyw?=
 =?us-ascii?Q?pax+W+8ec8wH6GaBdYuyKtzfMLa2iqBqLVeszgXMtp4/qrfVNURu5+oYzRFD?=
 =?us-ascii?Q?zahlHyhNoYMECPkPjtmFdW5RVB1zssonPZt/1Vu0?=
X-MS-Exchange-CrossTenant-Network-Message-Id: edcb5914-ce91-444f-5beb-08dd5740985f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2025 15:08:30.4234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WyLf2wAgcrLuob5585hG3+z3f6ejlL+GYlns0AYl+2ajtkl+jTqRoJE1n/5VMV12GSgJBbfXjSDwgywcad+BFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5913
X-OriginatorOrg: intel.com

Zheng Qixing wrote:
> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> Change the return type of badblocks_set() and badblocks_clear()
> from int to bool, indicating success or failure. Specifically:
> 
> - _badblocks_set() and _badblocks_clear() functions now return
> true for success and false for failure.
> - All calls to these functions are updated to handle the new
> boolean return type.
> - This change improves code clarity and ensures a more consistent
> handling of success and failure states.
> 
> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
> Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> Acked-by: Coly Li <colyli@kernel.org>

I'm not really sure this patch adds much.  But for the nvdimm part.

Acked-by: Ira Weiny <ira.weiny@intel.com>

[snip]
