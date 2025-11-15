Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F391C5D6A
	for <nvdimm@lists.linux.dev>; Sat, 15 Nov 2025 01:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763168412; cv=fail; b=LKA3WQ/EGAeWAdAg9uhALdfz+k/i75p3GEWO/QMeeivvIvTHBG9qkLm2T5FDp7+G10sqKEWCjO+EkGJqyUQChKo98TTEOnhLnElKfY3ED2VENtJYG8galAHGJF+45gwHuZNfsqURS9C8DtXyKHQSC/sSy/hfhNdiLuoiD6IvDxE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763168412; c=relaxed/simple;
	bh=Djm6qPJSa6J9TdrllonPIKoR6DSNBrg68WsYtCMswYM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mnYrIjyBzKKsRfZcOXlZaqdxGBrq8lmK6Qv9PJ8r/1HH4IHKwII6hWYN+n7MMCdJHvWi9N56bBgZn6HPBDqZhucEzsjAaZacp8q8ea4hve8DWF0ZTvyIChpTnxWp/c7Np5XTqbYhz+A/u+19/W6rpFVbd8RlTO7AxZGX+I6zmJ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=menal05I; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="menal05I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763168411; x=1794704411;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Djm6qPJSa6J9TdrllonPIKoR6DSNBrg68WsYtCMswYM=;
  b=menal05IzlqUpPI6geq6xn1LdDroi2d9lCsfjebHZYPkx1O4g9Ni2uRy
   Bkv4n82scuLMngKVI2J8ey0XD6UW9EdKc6Jyby1adXX6SbQXV8zhwC/K9
   2kObn82iDp7woi4np/EkUrLZPeJsUDiWs6gP96mGiiXFEk/V5osW6hX1C
   eH7VAhWfZiT5YhI2aTBBIc4jqsYXNDWIuhYNk/1qwiZZby95gRlMJtKSl
   tzBWZAh9haxH2nmyqJhlTGsv5rOPpYfkOkFcXyeIIZkQdksQFEeuakxO4
   fArwa6FdUIdGeExH6p6cVkHzj3GxFFa4hlhmlGAKGjb6hDm7Lo2zwVw0q
   w==;
X-CSE-ConnectionGUID: JMHkjqX7Rla/Bpw9s+eFhQ==
X-CSE-MsgGUID: JSt4QJtKRHOsrVBElo8JYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11613"; a="69114537"
X-IronPort-AV: E=Sophos;i="6.19,306,1754982000"; 
   d="scan'208";a="69114537"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 17:00:10 -0800
X-CSE-ConnectionGUID: 7SXjyUHUQAWgKzBRffvyLA==
X-CSE-MsgGUID: xC2CjZKzSViXCcPCSu7ZnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,306,1754982000"; 
   d="scan'208";a="194013963"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 17:00:10 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 17:00:10 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 14 Nov 2025 17:00:10 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.38) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 17:00:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qjhyfpNkZWyJtEPPy4JcFxBxMuVmmFJPp/djlYcBWGreFjLl3bk/VaBqORoOHE1nWred85rMTHozZ+YSYK7rgqDzmOzOJtpSLjOi8Od0e3BZ8Zn24nUxSzRqYFursVlJlClPoxPu1gBFT50hVyqESUwto62v5Zq09eggzTF8csxpNH9ZIk/7uj4Yd1PPeb0eaz8wcuE9P11MbIhpHRBWW01OSfCGJpRLhIApSC1Ey4wbx1TqCZkZtdufXXZfVUlDWJVDa6a54shWTvoS6PyByOqeXgLMw0RUDAEMHLkQ1X93Fn9ISj7SKpX9Q58a3d6Z6k1fKrtITb+W86f/QR9mlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GWLKqzsKDdCF1nIV60YnZnRPCQhqodASUV43z8APW9E=;
 b=krewsDmW+Y67p5q/Ms72xHOcQDew8MfTRRrgWABgvFIQp785+GLc4akMCOHvTv/qZlQGsgT8KZvfn/PfFK3vhhw3VeG4cJ5hA16n51/5NEZ+vuOCGsRIKZOAzDipgMqcuTUwjtjqTsKbOzST4FcjkIWxWOAqGxLGTnKs39xsdUd2zfe4riyyAqzqdYOuhWaDhv9D84hLzBbWXfU7fSU/seTxOnl/3Rt/2k/tFT4S/0V02/gQd9XQXtuiyDJZTmEgpljp7cITBwALmpX6q+sWfuTZs6CtrQJDdtHqyfUW1m3CxTqpJk9CdVt9pBcFTU5SFBqhXOZGXJ00IgaA+0xEWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA1PR11MB8448.namprd11.prod.outlook.com (2603:10b6:806:3a3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Sat, 15 Nov
 2025 01:00:08 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%6]) with mapi id 15.20.9320.018; Sat, 15 Nov 2025
 01:00:08 +0000
Date: Fri, 14 Nov 2025 17:00:04 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>, <dan.j.williams@intel.com>
Subject: Re: [NDCTL PATCH 1/5] cxl/test: Add test for extended linear cache
 support
Message-ID: <aRfQlGMqhyXYffka@aschofie-mobl2.lan>
References: <20251031174003.3547740-1-dave.jiang@intel.com>
 <20251031174003.3547740-2-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251031174003.3547740-2-dave.jiang@intel.com>
X-ClientProxiedBy: SJ0PR13CA0229.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::24) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA1PR11MB8448:EE_
X-MS-Office365-Filtering-Correlation-Id: 34dfbaab-9bbf-4af5-6c9c-08de23e251fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Pq1O4u4jc+mpVI4uSjtP/t+C1coprPmRQ2pMbCdSUh7bTqVh1nszQ5veByKc?=
 =?us-ascii?Q?CjFIaQP/NKu7Le5FyekBNjpLM42xF83NzsrfTKUTTUKUxeRKsCr6KlxA2gIi?=
 =?us-ascii?Q?GDYORtIQe5YG4lM9/xYByp3qNj/5A20YMulm6azI2tdiSP/vBZR//ileHY2c?=
 =?us-ascii?Q?T2G86+cBCtQawJlzV+DQ7gYo7qCks3er7P2Iv254tg9l+Be165TgEOxKHc4o?=
 =?us-ascii?Q?EouSICygV6ruGyFqcwVn3WVo5USYIei/F3WgSAIpbJbmuROWSO5B8zrsG6BA?=
 =?us-ascii?Q?R4+Cq+x5UIVuY4i1dnGeuNZtBmYjIhjghAU1nkwXIdwhGzulI1USyfXwRLmV?=
 =?us-ascii?Q?/2VGQjRXsC1NNrugePS+uDZjmIXuth1Bkyty4U03g/v1ulSfALDeyyhSZfBb?=
 =?us-ascii?Q?I3QtNXWAcCUkU3i7l+cyXoIlqrMI2wM7Hvelr0nthS9ypA5ftogzgE3nhTbh?=
 =?us-ascii?Q?+aQvdjCoRjP587gA1bSpnnuq9kz6XfjRLBE0l5JTFOEtAr3pB8gxs4dAbqfW?=
 =?us-ascii?Q?Y+CgTkEZKsI7/8Ps3MKCZPRM01e/MYBGP5SdjRaPnb0n8bGV2qz+g1X48VwM?=
 =?us-ascii?Q?whCJcc72m1vstzKvCxCcrUvceJAaxWgN/FP7jMrQdLvx4YWQV9ie+5f4Fz2a?=
 =?us-ascii?Q?5SWfXC7QL4hMB/jgnfEsy1N4LWjyYBSDEzn5ZWRMOhm3vAYIcUZUTxJlsN7C?=
 =?us-ascii?Q?n40OxzFDXbcra+BlvpaKwdAUsQk3KhVmo3XyTPhXD3akot07fvMeIOO9Hi+b?=
 =?us-ascii?Q?Fhui/RgGG0StxNb9reTQtTynV7LtA/ka6ogCau8dhyQWkjPlBqq1oLpnrAxg?=
 =?us-ascii?Q?Spz8PwUzbRPzicVPg+GvPoGolcF6xUEyO7dIgXW/dSz6FTidnq2wgOeMiYPq?=
 =?us-ascii?Q?xvPyuRyqc1FfdQrV26NSI0HclbUkgCUgvKXfec4YWVufwO/WRxxMnv3VbExf?=
 =?us-ascii?Q?RhXfMb6D6OHFycjrPWSxqwPS3qFYdfSqheid8vgKMjZQiko55AyXasnBhN+u?=
 =?us-ascii?Q?keVKHmgCbjSXt2h3ZKqfH7otZAQm+HWlqhAXkaouZ98beBhsJeT6IB46KFqX?=
 =?us-ascii?Q?vPRqI4zksPphh3xYeWhw66Tf2gvLUfgiE5pTKjhreG2ZuHdtETJXRuUHctGk?=
 =?us-ascii?Q?BXSKrjSq4+7y43xel4leccRDkI3zaQ71ThsB3jQaggnYkPs2EcYfUdaqy7nR?=
 =?us-ascii?Q?Wt0RSXKufFz0lFxZB/pG0Xzk6ke5Tf1A63idwVMrIyK7Q76aL0tkEiKhJaSw?=
 =?us-ascii?Q?uyUM9hwxqf09c7nXGgAKalIrWI1N6qr7Ho6nqZ4Kbje6qnX1+UP9MRoVPcds?=
 =?us-ascii?Q?lbGnf5B4C/CjkjQMNtEaN86s5LM1lPXKJDX0xeF+pTuQqdSdLK09DONxjF+i?=
 =?us-ascii?Q?6MvpCB9ERZYVCczBZ979zTHLhFhkOPAthlv4r141OvyG9aLtzNI+I3wuv1Q+?=
 =?us-ascii?Q?/fhT7gwwFHH3niCZwtK/ocT9KEZGcf97?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qu9QcUDg9dOhsrvI+aHJ+YvyzPlOWn3SdboXJ1Zq+uXOiXNnDmqWKiwXZPmf?=
 =?us-ascii?Q?Z8798ourxl49SHNqFaJ52EIfzwWcem1QNizrOswyD+yfO1Ii0CtOAO2M3gGy?=
 =?us-ascii?Q?SWP7UZgNfqegHSkl7wDt7v/OpCu4fjeKHMG/tUZom9Nc827Dxbotg5FhXwsO?=
 =?us-ascii?Q?p+ZmXzZQ2JiWs6R5jLmIm6i3NV0LRJT1TQvlaosuMCM+b+hsz/84XFc+po4g?=
 =?us-ascii?Q?0+gwyuDe3SuzkQsM3cBiW1tGmQ1LxIomejLYOWBrbiGGhhRVEdyHOmPv4xCD?=
 =?us-ascii?Q?xT98FW8D24e8jipucR1lvDUvPkT94tbfNTI1JPjIWu8fno0Nhh+d4DjHX29V?=
 =?us-ascii?Q?logj6mB1265zgyc86R0BkOr6iYM/s9nK2z9d9vKQes3NU1jL3emvBcCdc6wI?=
 =?us-ascii?Q?sYwV/eERdDu34X4jaI/lTTMy4wxbkWaZBG3LyuVrJBDmPOjSkEZkWugTTwVf?=
 =?us-ascii?Q?oQJaqJq4KqaPU5IGd8ahSfrOgmpVTLVDyfeb+44sPCYIVvnFUmFpaM7u4KIU?=
 =?us-ascii?Q?qvHPcn7wYUi0jZ0uK8KC9SIdrvIINoxKPxYrjNuB315Y14dvPy17THgJE9fT?=
 =?us-ascii?Q?UxurLI0FpNMI4Kpvm90+gZuTEWzwrGX5tW43N8gadzTvHlYIs4eg9OO4YM9c?=
 =?us-ascii?Q?p9kKnJ1P43CKZJP4i8gPBvJr4Uld6AV49jZdSBqIPMeyuQPzBmkYwCSIPxcm?=
 =?us-ascii?Q?VUy1797nEwGBjJ4Q0b6o5xittw/5ScmsNsyWdIU7iGi3b0Y+aWQ4KlxYrXuI?=
 =?us-ascii?Q?YZh001jHHDZuisqg8dYCVuAVAN4utY+nexsgmy2Ohy6ryGFx9haq/AOkJ0Uo?=
 =?us-ascii?Q?8/Twz89FDuYrXAFiL//FaJHOqBU58fiqyfCnlfYrJDtaBz6pLoBguHiqPWnE?=
 =?us-ascii?Q?tOA0ooZgMdpY0e0MK9zgZANOF+oZsVr4Lcy0nhC03LjH2BBwP+kFi2wj9Iub?=
 =?us-ascii?Q?g+4PS3cnLZfoFid2eDLkwJLTzxgXVK3rMLFOctNry2bw5WfqqrnelaaEZfJP?=
 =?us-ascii?Q?m9Gno539KMAe1QRJDwcAnK5h2Y2PU2rigqel4rGOVAtdhNuDyjCYCpGdUflP?=
 =?us-ascii?Q?auGUop8/I87V86MADa/w39yeWROq/2jcsy00eZHsFXGyBUYg+acl+jd/+iXJ?=
 =?us-ascii?Q?dYbQ+hT/bHF9VyIsoSl8bWBrmZos/bGAqjCqtj7CQp095XrAnuUu0hsqf2Ll?=
 =?us-ascii?Q?99967+FvteMCz8iZxvw5qa8I6TaF0FxT+oKojxcSnidsy7asGUenO6MQkk/X?=
 =?us-ascii?Q?K0MHNx/VdmUxGixaiuBJMcJc+WXSXddyc/CYo+w4UFYOgTiGRk/jGNsKgQIj?=
 =?us-ascii?Q?UEDtJQB+EY4bYT9724PCWNjobtzZWUHltvREPrEj/1iKkMmILGmeDGWhkKXN?=
 =?us-ascii?Q?28tPC+sfua557mSBYQsXw79y71Mh8AQkWKoefPy11wMb0bb9RPyWD/cFqevU?=
 =?us-ascii?Q?6nFQd+AoLGebaGRPY1f+JQfVMBt42C5ca9bWLpqYgmLQIOy2iKey0XUhFRP0?=
 =?us-ascii?Q?Geckqi2c6SrMgjEel9cPp3xgGG8al6yC/07xr0Sbye2iX647vmgPhIla+MmB?=
 =?us-ascii?Q?Fi5lkTue/tRa/H7tod34yc3DG5nKB+4TKDbRNMP2qHnJ/oX4xl+jBNVGhPRH?=
 =?us-ascii?Q?dQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 34dfbaab-9bbf-4af5-6c9c-08de23e251fd
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2025 01:00:08.0188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KU9+J5hE/jVOZqXY7R7lrqyIUrPjOhd6GXapv4MQLq+BFuOXMMkqSPzW2odLZ4dZa66qxM+vsL8l/l5TTTE1Zd4notFSb8CZ7kq2xrb9GGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8448
X-OriginatorOrg: intel.com

On Fri, Oct 31, 2025 at 10:39:59AM -0700, Dave Jiang wrote:
> Add a unit test that verifies the extended linear cache setup paths
> in the kernel driver. cxl_test provides a mock'd version. The test
> verifies the sysfs attribute that indicates extended linear cache support
> is correctly reported. It also verifies the sizing and offset of the
> regions and decoders.
> 
> The expecation is that CFMWS covers the entire extended linear cache
> region. The first part is DRAM and second part is CXL memory in a 1:1
> setup. The start base for hardware decoders should be offsetted by the
> DRAM size.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  test/cxl-elc.sh  | 89 ++++++++++++++++++++++++++++++++++++++++++++++++
>  test/meson.build |  2 ++
>  2 files changed, 91 insertions(+)
>  create mode 100755 test/cxl-elc.sh
> 
> diff --git a/test/cxl-elc.sh b/test/cxl-elc.sh
> new file mode 100755
> index 000000000000..632e859c21f3
> --- /dev/null
> +++ b/test/cxl-elc.sh
> @@ -0,0 +1,89 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2025 Intel Corporation. All rights reserved.
> +
> +. "$(dirname "$0")"/common
> +
> +rc=77
> +
> +set -ex
> +[ -d "/sys/kernel/tracing" ] || do_skip "test requires CONFIG_TRACING"
> +
> +trap 'err $LINENO' ERR
> +
> +check_prereq "jq"
> +
> +modprobe -r cxl_test
> +modprobe cxl_test extended_linear_cache=1

With 6.18, this reports a false pass when it should skip.
Make sure that param exist w something like this:

modprobe cxl_test extended_linear_cache=1
[ -f /sys/module/cxl_test/parameters/extended_linear_cache ] || \
    do_skip "extended_linear_cache cxl_test param not available"

snip

> +retrieve_info
> +compare_sizes
> +compare_bases

check_dmesg and remove module before exit.

Please fixup the shellcheck complaints about needing double quotes.


snip to end
