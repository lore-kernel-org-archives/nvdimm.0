Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD132F7AB0
	for <nvdimm@lists.linux.dev>; Tue,  2 Dec 2025 22:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764714106; cv=fail; b=Kyw9AxyHXIhjwTHvjWDaWmJdgy4FdSPtwIZ/VjO/VFupxxi8sw4ez/g4v99wfXlRGeVFiw43u77CETwEWSd534romNdFhcq0/PmUZfCczYsFx3+Daz5SAZmXB8hk/k+3ivVUBNu5dGXh+TwFBXwY9Vuu0NZvGqXQOTgc3HkuqZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764714106; c=relaxed/simple;
	bh=At6hfBBwEMEUoykiwqk9PhIOgLHrWlZMhb8ehhABkck=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QJuyRUJlUPEj9ZnUDS+44wGGLv+koZgx2jC5XeH6/Oc/0zKSJx2xVxv+b3xIWyImzOGzQoULPIGw/x6SaAqKhLmb7Kn9KN1zICkhlQ/F6+c+yQ/hTx00e7ZYVYH1WMKJJ/8CkTdK620EstpSfHgweFfjZHLirhB1UYjyDTK2DYE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QsK7NZXL; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QsK7NZXL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764714105; x=1796250105;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=At6hfBBwEMEUoykiwqk9PhIOgLHrWlZMhb8ehhABkck=;
  b=QsK7NZXL0cUYia233FBFFpLbpBm5AJ49fpzEm18iVNp1EL+HxH9vfWHB
   HvvA4egZtDuNj165RWVxmhaXLahYCpKuaRKi+j2p67+AlUBXx9uFLLxP2
   k7T0dsFDS61bR4U4r1wQwKXMqWe+ilk2x00EwYvLOESIvTl765Vkxv/Xm
   1Q+mkZqxFQmgs4rbdciZOo3z2IuHEl41xFdR6pV3r5UoyW46c4vOAGoww
   yvyFJOniRrg2cZTcC/DTKO59IKVj/DR614fln/4PHyKseV1q5qpBwvK7l
   8H5hhCZD9MwDeq2FLjWjtX5ITx/95uRSeaijSTW8oCzvYaCHdwSfVlWMG
   Q==;
X-CSE-ConnectionGUID: uf3xTpp4TpqmQ8o/+Hk+EA==
X-CSE-MsgGUID: lcNZnFp7Rs6jjWXleo1Y9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="66733811"
X-IronPort-AV: E=Sophos;i="6.20,244,1758610800"; 
   d="scan'208";a="66733811"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 14:21:30 -0800
X-CSE-ConnectionGUID: APD3vO3WTl6jqnDxHS9pbg==
X-CSE-MsgGUID: rYoyTy7eRY++EKk81mIoFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,244,1758610800"; 
   d="scan'208";a="217846203"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 14:21:30 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 14:21:29 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 14:21:29 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.60) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 14:21:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fP8tQHr/O4jG7R4jnAuzR/YKNxGs8XvQh4kL9RPkqcU6miy0DUuf+ePWcbJDbPseanrjjmEoGMD9SlTkM8RTMgrrIWE8E3HM6TbG/E5dB6WFRh6o/fN6UZVc27py1e/H/XnaysrrhjJEDSHd44s9mIdIULIU2kI+XG+rS3O/dp2x6ye+Tfcig2y7fjL5BJrXk4K61Ck1BGPSvAuIhjWfvFqknlo3dBY+SC9IimjZ3Vlcn3pJYlDmm5j1r17yW1buEoXVWDbi+rtJO0f9bJwWxnrW7/lFbKIeY44Z58Og/sCHb5E1tYQaCTI7S7XQZjIjrC3chis5nldPjJI141AiVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=At6hfBBwEMEUoykiwqk9PhIOgLHrWlZMhb8ehhABkck=;
 b=XMoh2NWymP7cOLDJiiYj/nLRRm3EBM9j2yGsa99ci7irBVWaIq8KHiaQlvc6E1AcopF/aloyLCpJBYswtrRKJeW8vViFXdeE5wcEJWyqgPddEpBPFoz9zKwWAeILhuRvn//npMSeWtRkCgHE8ATvAyhUnexJvQTdK50mAOs5z2IPK5vpTcvIJzKy+2xpnHtixOrtAMYlSnUCkXJvlldXyCCVc/shYjFfYz27+fItskPQZG5sR88gEXiKpXMFo1fbkrgl1ZADEHw5yQRavgZjT4j8/dIYR0bhLVW8ybrYp2DdWyEWa441YRIMMJTz8fKe8t5s3VytspssNvlyQG7bpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DM6PR11MB4611.namprd11.prod.outlook.com (2603:10b6:5:2a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 22:21:27 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%8]) with mapi id 15.20.9388.003; Tue, 2 Dec 2025
 22:21:27 +0000
Date: Tue, 2 Dec 2025 14:21:23 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>, <dan.j.williams@intel.com>
Subject: Re: [NDCTL PATCH v2 2/2] cxl/test: Add support for poison test for
 ELC
Message-ID: <aS9mY1e-v7T-cVt7@aschofie-mobl2.lan>
References: <20251121002018.4136006-1-dave.jiang@intel.com>
 <20251121002018.4136006-3-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251121002018.4136006-3-dave.jiang@intel.com>
X-ClientProxiedBy: SJ0PR05CA0153.namprd05.prod.outlook.com
 (2603:10b6:a03:339::8) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DM6PR11MB4611:EE_
X-MS-Office365-Filtering-Correlation-Id: 184d7e2c-8255-433d-1ecc-08de31f12272
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?g8w7bFTnOGJot3MUG6FoDptsO/PFjQ2R73Od9OA5+4qELFGAC+oZW7g5Wq8/?=
 =?us-ascii?Q?v7Mgb/1DTXKuF7KwSTHUKFhrUT6tNlbE++fE1uOQkytBCk9xO6bkZP4zhfbP?=
 =?us-ascii?Q?O92D0BRyLmyWRZ1u17ogy3TVza9Yzuda01nAONvqJEF8WIiWTvTyUJaxgsv5?=
 =?us-ascii?Q?zYwvGBDuH3RKFkCVEuzhQVGkDbdFEdFHnKUHonRHduFbjyyIy3mu6cdBK6bs?=
 =?us-ascii?Q?0LqAKPxRQ4yJiFTLJDh7XtUl3MXDOWJNu0w+cP7bEkJ5CsanKax9mYxYKjhJ?=
 =?us-ascii?Q?fM1jY0yNxjEOW16KCQ8KCQIrl8inmM25JsJLtCWy0UVOEBzq77zpLFTR3wv4?=
 =?us-ascii?Q?WXqz5YQCD0BnQo4o/MmSFnQ5TFcpypwlRan+xygKNRgrgJK2PgWF38agFQYY?=
 =?us-ascii?Q?KcRd/h7GESG3QD3mHVwMMV3BogRr0+Smc0Ro/NvUpR3/YhuwhygOTLrznrfo?=
 =?us-ascii?Q?wDmA0Paa6PBGF9l4r3qcGLnCu+Wtb6unsuKGaqyTgsGShraUywpHPvrEp7n6?=
 =?us-ascii?Q?OpFvi3vaqE4PK5MWp45Aky7Q9a+iwu6XbK+Kmyuqbbo5LD6Mix9/7nTiDY96?=
 =?us-ascii?Q?cnE/2bDgNgOi/p4IfB7amQ5SYTs48izbVTCBPJKxySUcGWxykqaAEW2ipsub?=
 =?us-ascii?Q?4nEd/7TixpahF8+rbZhb8Q+W0U7qjqT8MfwGQ0ij8ObDIGuJCGm+1pOVuSEk?=
 =?us-ascii?Q?YLeD3WQeWkDnYhFZ4MsMp+VyDhBOAl970pwDNjvfG76JvUpwvAZctYR2Y2J3?=
 =?us-ascii?Q?4V1lVnDpKVOgPjapUCEDUKp8te0GdtUGAOD8DKQ1BuRDnYwfbG25oLD0U9I/?=
 =?us-ascii?Q?In5WUPxdgVI4Iw4J2+C+FvkY6p1MVTN1odxbYqagm29UeUimvxhI0JlYXMpQ?=
 =?us-ascii?Q?zwh/DqVQrLTg+rnyeAOYcwXxDV+C9ILN7LAkPQ4jyo66QTSIgL+IuxTksKlk?=
 =?us-ascii?Q?ihsFS2nB/qUGIiEUDoGWEDgfcvK33/dqFn06VK2zqDt3Z+6vF1MIdncqtO8G?=
 =?us-ascii?Q?+vBKiJhrGpqihtE0GlaynHMRHw8Spt2q3NChuFunwwlJrtWopEmkkCmfayge?=
 =?us-ascii?Q?7Mma04qwOo4m+du7OuRpoliIMeVUbrzI3IITajgO6BMdBfm5pcw+CHhRz76u?=
 =?us-ascii?Q?W+CoE1uwWTuI3RvkDWCF3FPeWm8a+yj/w6JV1UuTZcwvRox0lKiplNpfRccx?=
 =?us-ascii?Q?//lYsn0PM2ducl/udlhHi0vZIwpk6mEa9Q/uZ6VMnlOhX8GA6p2LiKOFpWqs?=
 =?us-ascii?Q?hgT5J6VUmr50laAKfgSxo7SpxZO0k5VjOVZd9aja84ib80jA8lPwQn1qoSDe?=
 =?us-ascii?Q?0umVTdpvWyW33ZGT7EXZe31eydxMlyTzJwDQDwRP6eD1MwaDpOxywETD985h?=
 =?us-ascii?Q?mYotzTOyUO6MytQp87eNVoxzPgf/VSih5H0lK8gtiypKWHRffoY4+mknAqCr?=
 =?us-ascii?Q?U30Ja03hL92iulChBqFyNXYfMVNlqtt93OrD2d5ecyKjo1+yJ2Bjcw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7zsaXswJgjGjhJ1+8M/0/AL9/f8VYkdPPdAXtToj4gZhBHyb3bOgdtz7M6RY?=
 =?us-ascii?Q?bgLtZpNCZFUBLbVuCw9pTH6gqRwbDW1/pxSaxjojOdc4F65QFOvotYPhNLoW?=
 =?us-ascii?Q?Z8Peh6whJ4WmCC7vmXFqZdozl5+kmMz4vBG2N8RHek8LlDXoTtMex5upfORj?=
 =?us-ascii?Q?XWsnqbRbYtxjVdc6+7AgDNcHJymWcFAPrfA9WPkrr6sL/rs2kZGpxfbTMsH2?=
 =?us-ascii?Q?JEZwt7NBytcySCK6FilevrN4WsxJZ/mUMKFztrPqC02ZS90g5A75Zgd/97To?=
 =?us-ascii?Q?wrXsI+aMZJyx7nTeTXvSLuHRRfnh9mA9VjIZ8ZM7BeZrs+ys716T0rwdgbvd?=
 =?us-ascii?Q?d91IrfbXKzxwDMFwcrUGA+kQH/j5d2pxd3NMPwkZdmUw8OTGhZxN+chicn39?=
 =?us-ascii?Q?tW0iHHKg5HePcloaOk8br9dVymIqzk7OeuibCkxixblSU6a8RZnGhiLtlv64?=
 =?us-ascii?Q?N7EpZbUIXC5qpCmNtC0/wQ6gUTeDtXHPD9vgJwNs+orLaYauiZSgwulQ5CV9?=
 =?us-ascii?Q?ZzXvEdy6VUWs7I4nSqHue+29JFMervQXCCJhP1/zQRQC89shuAkV0UFgqK+s?=
 =?us-ascii?Q?2Zm831PXUcil2thAm6dgL4iyzUPxGElROOl+cyvxN4fvcV9UqgCR9sbOjusM?=
 =?us-ascii?Q?RWCuAtLQ/ekptvnupNQ7VCWD/xUcACnx9xrzTXicPabDip6025gnmgF37Wpc?=
 =?us-ascii?Q?mUvHjDE9J5PAwR613aZ7g9+PRlzX0JiHeaLjmfAroacOgBo8jQfTDrrQK/LW?=
 =?us-ascii?Q?KMMEX/fDVsPKFMq5xlweoj3L/SPHpCHVJ04scsKUs6EjcoUoUu2zn4IPRLk9?=
 =?us-ascii?Q?z2Sqd97iEBIcWw1BdoYChzMK52MEWeun2laAjcdppjIGYmjL6LCC14kmYNqn?=
 =?us-ascii?Q?/hXL7dB8VQAncCNr92qJ73lZQdGDNIoPOGyxMVr7mw1o4DecBhEfQ3YTntJG?=
 =?us-ascii?Q?n78g1YhkKntRk68B4ukwS1KLcbN6S+p2M+N/i8bLn3L3k8XWYXDeAv6SBjDD?=
 =?us-ascii?Q?N5rmH8g2ZmniZAnME3M29T4V3T4v7d+KxsyiYgqS2+Vvlq65dcg65MJW2YO3?=
 =?us-ascii?Q?nKgnfJz9/1tqjnm4V27kdSB+KKut9HUUU7q1KGRxV6IUIixJ/a+J7iPyeroc?=
 =?us-ascii?Q?tFH4IrCD+EGVIJhEsmZzD7ynm+daqnVyE0ETXAPBOLTs1om1YnRdBIizbF5b?=
 =?us-ascii?Q?75SspfIxJYlHqEU2EA9Uy1Z3OqhESJTyHP6dzhQSxmEPFD+bAYx36BVFUurV?=
 =?us-ascii?Q?8T3XoToI7kIxpSQ7d1rWuzZU2h8bJcQ2uDQJ4H2tkL+WRwUNXxDJajjIDZS4?=
 =?us-ascii?Q?p0uIbUJZ0IA8o71AGQKBhjyNR5xmqsj7qAvxVJSd7SfbbueQO+/K/qXxdDYb?=
 =?us-ascii?Q?8+oNCcMotIpTi9TZK5Kb9mSa+afGhNmDrvf7w4x6XPgCASEZyNs2Soc9e3Mv?=
 =?us-ascii?Q?HShDndzcGPHKnEvgqV+xbISVBtFhrOVL+s/dO7qBiwH8/naRCEhZ2Sczzlny?=
 =?us-ascii?Q?jCpB+UHxy7JFyHBRIZjVq5rGvp0JHyLkglI0wTkmift15uoL18alsI7WHKrU?=
 =?us-ascii?Q?sP8PcQn9yIaFXT3l4gHJz/g0d/KBz41GtZcg7u1clOEUhsq/Rw8NLBczJLKb?=
 =?us-ascii?Q?Eg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 184d7e2c-8255-433d-1ecc-08de31f12272
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 22:21:26.9631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d+eSFN5co0e1BqTbO0jGDrXoakQWoYabvPrsR1fmx2YATcc+aniEHXowDY7/AaYHLQ9+y3Sqilnc7ChQzqfG9xqEhTnQTTxxcFoNu7sfpcU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4611
X-OriginatorOrg: intel.com

On Thu, Nov 20, 2025 at 05:20:18PM -0700, Dave Jiang wrote:
> Expand cxl-poison.sh test to include extended linear cache testing.
> Additional adjustments are needed for test_poison_by_region_offset()
> to test ELC functionality.

With these:
[ as: do check_dmesg only once before exit ]
[ as: skip the ELC run if cxl_test param is not yet available ]

To avoid noisy skips on a test that typically has no skips added a
kernel version check before even looking for the new module param.
It's just on pending, so if you don't like, updates welcome.

Applied https://github.com/pmem/ndctl/commit/39085f7

