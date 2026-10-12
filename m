Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580D53B19BB
	for <nvdimm@lists.linux.dev>; Mon, 12 Oct 2026 23:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791847314; cv=fail; b=rFvb1eR/tlKE0QRWO1InxpQ74gVdqnZ7DQjQp/N/XR+e4zVP84WQK7CpToATtBzUqcwIUX/i0ZOHgXwBY5kNq/RJDEP/ygRDeLRTmVldUbIMuieWV4p/TNEMwE+Ml6yBgPZ/0VyN2LJnelKhsGR3Udpc9a8GsCk+5h5ufQDTIfM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791847314; c=relaxed/simple;
	bh=jpI3wMKJpUhvDY4D4yaIOfRUMQ355bnzMjbwT/IVpbk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ceo2GVVFB/mbc+0uFs3wLvAy+q58qCUExhJ9dOYWdEHuAnZq2cy8TKVd15z4qznAKUP+Xm2hjfY7kCQdDxgbRdoZOMMxrp9Whzq2aWQffpb1jQ8+yWurSiFJVPLi7e4lSZv3oXZeXA1GLDVc671Z8Btclu21fDkTOUMQn2Ic/r0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qf63zsOR; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qf63zsOR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791847313; x=1823383313;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jpI3wMKJpUhvDY4D4yaIOfRUMQ355bnzMjbwT/IVpbk=;
  b=Qf63zsORZCx4Uy4509akcWJsKOLOztp6b8hsBjrZ4x/TDpwvsPK7lx1w
   F44+8JWkwHy0EZZS5dhnttzQToWQW9agsqeVB1td0+Zr/O8HdqX5BxE9e
   NZbQRNVmru7yij/Mu3DEGuo+1kViVtnpaVBxXVQTncVtxduVM8rTaQg3m
   3ntSd10wY2Vhcc3gJYZWhY0Y11ZryXZsAms3QzWJ7ZooNYtf8hN5XExr/
   uWoiPhRr95FwBTubzXUKPVMGewA92bbkcmbFoM3T4LgRkFB+U6nDHoL7g
   1sYyNdJ2c+jITo/j4PHlVSLcDBMLfs1ihYK9nurM33xuUHJ7TmBCjOH5U
   w==;
X-CSE-ConnectionGUID: wy6TKf9rSpSYW7ePWolUZg==
X-CSE-MsgGUID: j1UOZubcS/2173xQDQ67rA==
X-IronPort-AV: E=McAfee;i="6800,10657,11933"; a="468817"
X-IronPort-AV: E=Sophos;i="6.27,154,1787036400"; 
   d="scan'208";a="468817"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2026 16:21:53 -0700
X-CSE-ConnectionGUID: yF3uc81gTfSBz2u/2np/jg==
X-CSE-MsgGUID: /ifafl9YQ1m9QlYmIZ4GLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,154,1787036400"; 
   d="scan'208";a="913889"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2026 16:21:53 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 16:21:52 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Mon, 12 Oct 2026 16:21:52 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.22) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 16:21:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aUtS/iJntPbOO+8NJW/3WzE012DnMKUYa3qNDOlYbUC9OjsnyUbE8nktEbT2tZ18mMDJlyx4rTtR/TNFIBi75VIGarcq6xGwlXTefeXVhdYDakMTK3utsm+WVDsMxO6jl6k8iVx+pPkEXVg78MhXzJlBAGkBaqinKN1vK22UGYakjTQZR1DeEpUawRR8nMZyNQG8pRQ/JZUGJ7S0BD03UZ90RR4G2iSEfqsh2UJzcJsm8K/SIVZCYnW0fV5BiuVXjTbMNpXyJZxUUNGC3Z1pBx2ZAkokz/vCMma8VblhJUjax2hfm+mtqovByksS0x9bI99GMK4eYLzJH1djx2ZAzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F2ZYwyzP4aTuCNofEhfshnJdMGJQki1wgz3zu1bOvf8=;
 b=juUCEHiCqWTxhQup/KeBPcuDXb28yiClsSTbx4Vr30QQ8pQTYwCog+CLvtvxQ6r4VoU2HCCB0CLd2FJldlxgBUKMDQdC/j+2GFEbo7GJTGohewTe1iqdpXOPezAFb1AxwBcpaQFfSKREZZbHrUnJDiY8lr59xxlqWzi2oOx0RdlX3lS7swaDteFkca81QZaKEeHtt9zGXjUmLaKPTmpjXAPcPiQDtKcES0YQnrAZzs5jNieFxMTbOaWwTgFa7i4TYzZdK1lcwjCjE/cVxAsspwEzON8IBewm+KY9zb4wZRoPptPZ+b+il1blnfVcjCWz6xCpNp13C6qkkzrw39rt6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH8PR11MB7117.namprd11.prod.outlook.com (2603:10b6:510:217::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.21; Mon, 12 Oct
 2026 23:21:49 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0496.021; Mon, 12 Oct 2026
 23:21:49 +0000
Date: Mon, 12 Oct 2026 16:21:45 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <jianyungao89@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Dan Williams <djbw@kernel.org>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "open
 list:DEVICE DIRECT ACCESS (DAX)" <nvdimm@lists.linux.dev>, "open list:DEVICE
 DIRECT ACCESS (DAX)" <linux-cxl@vger.kernel.org>
Subject: Re: [PATCH] dax: fix mapping_store() returning 0 instead of error
 code
Message-ID: <as1riZMcDaX5niW9@aschofie-mobl2.lan>
References: <20261011131857.30481-1-jianyungao89@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261011131857.30481-1-jianyungao89@gmail.com>
X-ClientProxiedBy: SJ0PR03CA0287.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::22) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH8PR11MB7117:EE_
X-MS-Office365-Filtering-Correlation-Id: fb5f0880-72ee-46e5-4757-08df28b7971c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|11063799006|56012099006|22082099003|18002099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info: JMt0qvyecfE1fCGt51B86peW8NvpxcoslUfTKM3Da7PD4OFlY1of/fgToZSUs1XjRXEPuCbYEOp/gJasfxtC1EPeLaW1OmOh3QMX/QF4QL1XPBvev+dRo+XPbnkkBZWlZBfx5GKeWuI+K2hXv381A0nMNvYgVItIliu0VCOyFGr+qtZh6ds6sKLL2GQLaKq6ABP+Bvp4pe17JbuMRStfrH79n0b+lB8qfGjSt7wMm++tWBF7+64IWIgalgPzIdZAiInJD/iVhC0x46K4DqOCyfzDK0XJqhjc+HLqNziIoqAGAQprdDt3dAsmptYpXirWyeWgdLuG1M8uyAoLSHSktJwAleuphsxoyLI3rvvF2g5GSD7BFkXUSXndm2Fd57Zc4LdEm9YPpPonJNKRk/jxfB9W5ItQIQeBmLG7n/AzblW9c+NeAAOGlG8rRi/oB1NuMzd0aDeuMDcvhGMjfPS2mMbBgN1HzBQKYiPpasy6UqRbv+nYpUE4YYTVasTXyLyw4dkLKnyVsuF1UwMGAo8H3eTMa3OSNxRUU0MteJaruc6O0yImobej/1w7Gv4tiVaN6Hhg8paMOy83YnnomdfAbv4kbOGpdUDDkf015eruFr77bbBOPnMZdrVQtijf4nS7zkFNGFDUxyDiJtoCY+UUb92iK0EWs/ipVFbpdM2TXYM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(11063799006)(56012099006)(22082099003)(18002099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ABpEiWvCjJ8UQUqTLku0dEImqTa7mhY2nQuk5d/CR/uUUhuC/SczYbBsZLoI?=
 =?us-ascii?Q?tt4n194B4HnrORU4WLh0Inp1L/GaH1MLfsdLIUU+jIWigpRV2EoKdHguSJbX?=
 =?us-ascii?Q?kcrhnPbHFXj8jjOZlxPMnmbvmhPHcofCsLIKNV3OOWcq5M8IGdydr0MT1pWd?=
 =?us-ascii?Q?nBgV2Ah+BthE1CF1zQbs53bil9nhimUUWsKZQ8HTyCWlm1HRYPvZZDC6kDaJ?=
 =?us-ascii?Q?SByVB7NPtN/QJ22TyAaeSyUscT0Y4FIrEoQ4Fe5b7X8NfUQid+wLody5VCVd?=
 =?us-ascii?Q?eaVuw8NNwm6777BkiOk9rrwCn93LPS0osHLo4tE6VkSk6U6mOJGXiBiut5sw?=
 =?us-ascii?Q?Wuax6qP+7kv5rAxUmP/2fRGw46fPHacf/OdW0GjzEpBgHCReZBcaYzI6QKx4?=
 =?us-ascii?Q?Tz+ZYf0fBC4LiuIRUcprUUAAX0c/FJyPtITaumlrS/h84tYlfXpU0g0fHgK+?=
 =?us-ascii?Q?GN4V/rA0j4XNr2bzFdn1d1nssMyztFIFP//tZighzFkKSsHkUAtf9O6K55dv?=
 =?us-ascii?Q?4/tPjTHCEUgGMBMpW9um+IoKvZd/Flv3N/dUM3+n6wcYkMyNBzK0WQ9Vrwih?=
 =?us-ascii?Q?x9oJ33bUla48qp8VZDPCjJEVlgcXAlkPK+y6XLqXov56Ew6elVyiwnjRkd/s?=
 =?us-ascii?Q?oB6eArVOQCbJaZNvgo9llFbcf4LT56aajRKpCIh9KI3iHLJUij8XgeklXbUo?=
 =?us-ascii?Q?zY3J/1RVALmLIcmVx7/nAQQkeeiIrPJ8kWEyH3RZFwmM/PLFS1CFQit3NP+r?=
 =?us-ascii?Q?qCHD/+7mRuaIfcZlmjtPSbosqBNR4Rf2Q4OBPga0nriT+FH/6P6caVduy+Fc?=
 =?us-ascii?Q?EdEmLVmuDtfb3kvlA3gxSElTvmHV39BmBujA1RA8OiVdSRFPueItra8H6QsP?=
 =?us-ascii?Q?J67eKP62qQF9L+JlXkDMjLdDM9Os0NmxPwmQ8LyR7u/0RbcFcUdRMaelQVWR?=
 =?us-ascii?Q?TvmJY7vK94p58EdAwCwMoRFCymvgwthw4sodeyOOiPSrsfAgZGqF7XD7RWj5?=
 =?us-ascii?Q?bCNLIyDdZXUfyFyBzR2L5orolkyMbnrb1HKaHiXh1y6qUsMlAzq9Zc4fWhKI?=
 =?us-ascii?Q?6BeVQcZ6RRPpxhxajYqxJVu4sXI2pNbVoDqUyIZGoHQSB1VgvSXvRU8JQm/Y?=
 =?us-ascii?Q?GDzeR+AHfPLuB3wZ8LwhtdTzFxS+xTqTyFaBy9cifgF4ejHDGrLVwQ49obWk?=
 =?us-ascii?Q?HseYg9xl+UpOyORtIe7kfDCTIAdI26gXN7a5THSkaMImauHjf18mWU9BcukG?=
 =?us-ascii?Q?/xI3xc1hJuvJ2xVfdpSnnuxdFCuW53Y/yYQUK/A6bvJ+U4SNTRBQugD1nXmC?=
 =?us-ascii?Q?+gTEPueKZ2xdDH/V7ZQe+rmYFRrMc0gNt2X5QTGiJieMG9iZPs3tYVkEO/FL?=
 =?us-ascii?Q?gC0hKeRelQqEZHxaUPAwrtIv2NdefFfjywmmoYV97J2ZRLctJIx9dsOWbbh/?=
 =?us-ascii?Q?IQOpRMqch2v2MGicWt7niRxGs6zwGcw/AMPJLk/ow23kfuP5UujQwnt+QSWT?=
 =?us-ascii?Q?Miji41U2exElNsfC6hY5JhfTc9F8qOz/yi86Iwl6pDLNb5JnAXrZRMV3Sxg1?=
 =?us-ascii?Q?1waushzohwR9PDFGqgGcV9SbPrtR/9BG2QZUJAeLlSEXfMUZjV88CDZoYVlK?=
 =?us-ascii?Q?KJThjD1w/SD2KUkb1fMKXMJjd8Bz3S6iaAwosIoFuftvxJ1afkPNL7w/7lwo?=
 =?us-ascii?Q?EDUDaKwmJwNZ5JzBvX8WxCiJ0EhtrezcDy5X4tA00nqdKMrpzSgk0maSdGVT?=
 =?us-ascii?Q?KgJwzaegNoDNgAUrQeF6ZjXM/2/lF0s=3D?=
X-Exchange-RoutingPolicyChecked: iVocGvILH9UHPGrR8S90TYnBuuwOfBJwQsemOlYIcKoG+oa0DyPCTTZJWEaBIirqIW01mxgNfwcpx3JCQNjvBFZbw07Tj3lXmezqBEi9b7ioVp/A0bmppHxdaom+iG+b+hp2TWBwyEQWpOX1914kAGyVf59K1l/TnkJGyhVp8TDpgLkThzwlOJawPQ9BYVBzKlKnmYo4Vm/jsQxiZWgLr5UnkT7a2BlKBjdBqQnp5hOJ5WWS/64hujCHUoXnD1ysHOCiD8bhmPGSrWfPQuanbJuOb7KAK9E/sknyrU/aVfWWydQ+00UX7LbQ8wYj5pqkLyFSt5liQ+g3acXudWkEVw==
X-MS-Exchange-CrossTenant-Network-Message-Id: fb5f0880-72ee-46e5-4757-08df28b7971c
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2026 23:21:49.1900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KP5aRJRHCJd9JBRrtYDgwXs2pxuUAcgC3sP3q4QV6qtaIozsRFyRt6AS9VFlXJHGGBR3pMyo6CCAICCuQ54Mn0BtYHFQAJmrkuDO1pscSsA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7117
X-OriginatorOrg: intel.com

On Sun, Oct 11, 2026 at 09:18:57PM +0800, jianyungao89@gmail.com wrote:
> From: Jianyun Gao <jianyungao89@gmail.com>
> 
> When the region driver is not loaded, mapping_store() returns rc
> which is 0 at that point, instead of an error code. Set it to
> -ENXIO to match the equivalent check in size_store().


Hi Jianyun,

The change looks correct, but there is another path in mapping_store() with
the same problem. When alloc_is_aligned() fails, rc is still zero, so the
sysfs write reports success without allocating the requested range.

Muchun Song already posted a patch addressing both cases.
https://lore.kernel.org/nvdimm/20260924025035.1265035-1-songmuchun@bytedance.com/

Please take a look and add your reviewed-by tag to Muchun's patchset
or comment if it doesn't meet your needs.

-- Alison

> 
> Fixes: 9567da0b408a ("device-dax: Introduce bus + driver model")
> Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
> ---
>  drivers/dax/bus.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index b809e1a264af..262f97b5e7aa 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -1192,7 +1192,7 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
>  		return rc;
>  	if (!dax_region->dev->driver) {
>  		up_write(&dax_region_rwsem);
> -		return rc;
> +		return -ENXIO;
>  	}
>  	rc = down_write_killable(&dax_dev_rwsem);
>  	if (rc) {
> -- 
> 2.34.1
> 
