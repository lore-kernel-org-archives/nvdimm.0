Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F0EC141
	for <nvdimm@lists.linux.dev>; Wed, 24 Sep 2025 04:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758689197; cv=fail; b=LUaHWMO1tUrfUHskRL2JqSN9XrWcD0Fa/2tYuteBru5dvcUD3/RBYfko8RmNqJS4cRAtibhiKmbfp2z5Xmnpva44hZJi4vD2DD8EjIIEEHSsJVD/Bw60CsDUQJsiv4lEzr+zdY2tyUWG41tlxQ8WpkM5VkfeIepE34hEh9Rf/zg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758689197; c=relaxed/simple;
	bh=DT227Dr9Y+iaGunEP9PG2ZR5Hldeow209sN2i08K1aQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ogo6S5uXxflXlqje8bJ3oFPbKXA3x7osT5Aw79vLwJKHEY8DK2SjwCjqJdFQfkeLo57bm+3HAvng/dc7r9QbeHInWSK8lJiYBW3U6KnM3O8c1UfnXJ2BOoqgj8RNrTSZBXwjzWJe0Rjyso/T3GQl16+Iu40pL/Yr4QDO8h9EWZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DjJ4xvrS; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DjJ4xvrS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758689196; x=1790225196;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=DT227Dr9Y+iaGunEP9PG2ZR5Hldeow209sN2i08K1aQ=;
  b=DjJ4xvrSkMTN4EohMhNd0gm+HWFn0QTa09THvZlEWDptA8CZfgEVIxcE
   zSWV5FQmXAVglVjSKV+6fZUoIHpmkanJxSJP3VkycLTzL2J0KHPt9/T8n
   jxqD+S/pkEzehn7No+358G1L2cjefx3DPLOu+ncfhsnwTPRQmkQylphHs
   ySCKIRJroN2Rky7YWHG7WII87e93cWT9WEGlPbNzBXJ61EGYQT74Rwp6s
   KtdT2KBijDSj8ezdA1vo6xMMy806ULK9JjXDz1jToQWfDywUK7mzot50t
   l46qHayfOM8AcNouzvYOzDoJFMGbIIaOIyaYw6AX/upKtAvkMgLQ8Q4wI
   Q==;
X-CSE-ConnectionGUID: qEbiF2AmS6OxH4Mcc9H0pQ==
X-CSE-MsgGUID: bFUSCF6aRn+JVGV9soiZxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="61149187"
X-IronPort-AV: E=Sophos;i="6.18,290,1751266800"; 
   d="scan'208";a="61149187"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 21:46:36 -0700
X-CSE-ConnectionGUID: mvfxgQRXTsi33oiSumpsOw==
X-CSE-MsgGUID: AFzM53SHRn+06ve0pRMhdQ==
X-ExtLoop1: 1
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 21:46:35 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 23 Sep 2025 21:46:33 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 23 Sep 2025 21:46:33 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.29)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 23 Sep 2025 21:46:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BkrYqsJ6BxQlWEcH8GvznjsELADXW69hdejVHF++UyYMGwme3eN7zH0SiIwvwRqmiNm6+fpNon9qmX+mvWqQVXnreg6gQ2sRP1OOr+FZ4EU1u25229Mb5wunDHtpneHqDtV4ZQCkD40dHG+vKj5j1ijeQ4OaOsoCdAUo6PZNltG48OxbSN0uqa8BRk+jnPvq449Va9i9MkJ2Rl2ZE8sUyAZw3vaagHtMalbkRSbJSfA0U737nel1jzcsMMdjT7iTm3z7+XYflSqC2sWMbXyhEg2L7xGCfsdvFz0i0766K2OrFtPyg5UM/Sq9VhEmjBFsU9XIJo10dCNivMEQJhszuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k9WMRQ5VdTnaitMBDB3rGq9IJZch/4Q9tqKEDchMBu0=;
 b=JU8fmjcuTtVk1ATI3qmbc5zdsA65Zi9/j0DDFzCaRceksaxIOnj1x3xOCKhZmwPkVZYs9dDQoM84DtDAsIAT7yhmVwXqM0hwegr8GVINgKRspL2VbngBpapBRNfTgS9+D7zng48qJUlSl6P/UosNLRNNxz4GwNK6io7irvw8N1bnE5EETCluIJS8oQgxZFp2EsC/IcUnElL70hwcAqXLvVYICC4hv65ulQjoEMjNGi88oIQPKPw8FJdNdzNBMWId/jtA8b6aOAH+KGMT+1Ozrk4C/VHq9dL204ACg/cqMfzdq+d5MeCUjl0rYiybDsu6w1TMXCIXvoDE5CT72AQ4tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b) by IA4PR11MB9393.namprd11.prod.outlook.com
 (2603:10b6:208:569::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Wed, 24 Sep
 2025 04:46:29 +0000
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde]) by SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde%8]) with mapi id 15.20.9137.012; Wed, 24 Sep 2025
 04:46:28 +0000
Date: Tue, 23 Sep 2025 21:46:24 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <dan.j.williams@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>, Andreas Hasenack
	<andreas.hasenack@canonical.com>
Subject: Re: [ndctl PATCH] cxl/list: remove libtracefs build dependency for
 --media-errors
Message-ID: <aNN3oG5fYRSZEksv@aschofie-mobl2.lan>
References: <20250924013537.84630-1-alison.schofield@intel.com>
 <68d34e77bb7b2_1052010056@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <68d34e77bb7b2_1052010056@dwillia2-mobl4.notmuch>
X-ClientProxiedBy: BYAPR06CA0024.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::37) To SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF0D43D62C4:EE_|IA4PR11MB9393:EE_
X-MS-Office365-Filtering-Correlation-Id: 15569f3b-b77e-4e6f-c334-08ddfb2552ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?rNXJoxHJ0S61c6THVYgmryp8r+jX7NfOfQ3QnWiyjApJE8euHwI+GriLQZLt?=
 =?us-ascii?Q?v8Y7qUljXC7/kb6fhLtDB2EdD+HcPjkOsp+Kl5BBz7kmlgqdeKc4JHgGroPU?=
 =?us-ascii?Q?KBOqnivWdARD0YeVs0cimiKDeWlePn//Sl0I1kQSlhpvFtubFh5cPBh+pXnn?=
 =?us-ascii?Q?EyFfjMonQ2sWPbt4s98rUNZHlKIJXL8ZEcknZ21tvoD79H/Fvsub7SVk6+xI?=
 =?us-ascii?Q?qNCCMDFgnF9QNIREOIMIRR8hZbztId/FOoAkB3Ji/EGrpjF6RMcd+Uq0CvvY?=
 =?us-ascii?Q?Q6BahaXMb2hWiFuyX2FbL0Tp4acbo6+qmwoVrU0oXjFRc2SyfplUw7DfIyGu?=
 =?us-ascii?Q?MqFH+h90mSRYWkd8XCYYrL3Ke8Xp2uf2H5xaTPy/7Buxf+UaQxUTKlDqe77p?=
 =?us-ascii?Q?RVgwNFlTpC6us1NcR+QibxRSzfOWtrnD4MQvD3hT4lOmwsDB6ABMY2Sm4J9j?=
 =?us-ascii?Q?TrhLWaFo1qjbMpF8aPIeaUJrCsxpfua8JlX1tI+uookFE4S0bFId3cB7B5yn?=
 =?us-ascii?Q?X1Y4FwAa/m9KlT3A+/RR6TvAOBfFAWC1tcwDbJa0nfqBSjz9VWs6XV9RkrbI?=
 =?us-ascii?Q?qOTjgo56NKcPcUkRLOxymK/IFQmuDwKGdFV7WMkFLc0aSdjSF41ZOrsMFrfG?=
 =?us-ascii?Q?pibBp3td0uxjuhwGX87oy0nzpXHwtfZKTxxGbXlo6vSc1f/qDTyY6SAZIHRW?=
 =?us-ascii?Q?WL2wshd8XA80QlpOSXmq9byZ8gVEVarSYyVGKiwrXJdEER4VcwOuTGYG7vrW?=
 =?us-ascii?Q?ZQ10X/Hop87Dv4FRU9EY8XvnCf6KUjAk8Z7oSLcWkGn7s2tn2z0vBRJofVhW?=
 =?us-ascii?Q?h2shvDJLJH2q2rTSoHSMsffcUpiMdHtIfn69JCX8e5ih/oKqzCb5AtgbjHMf?=
 =?us-ascii?Q?4texLtaptwUd0Vt42Up1aclglw+dAcYUD4ao6zPX6UEwT2nE4ardHFLV8d4x?=
 =?us-ascii?Q?ZVQ9bLhlYpP/oQM0rxGjQ0yYrWKixmTIgSibHXvRGjQLJrB6BHYbHNxD9SDU?=
 =?us-ascii?Q?t4sb7gGW/Kx1O8BjRffPR4hca1vDSl9RZzqFZ6XB0mBa0aZ6yrMMWC96S1Y2?=
 =?us-ascii?Q?4Fyh4XnjY3uBgy2+tZJUbShESjTorAePHJ+11y2ngf4Qgnr7MWRLlTturF+Z?=
 =?us-ascii?Q?Is5a/3CkubDzarkZEp1wLjW6xcBxIdvIehRY8YOguu+qut3p4h3UNfPLjjOC?=
 =?us-ascii?Q?zOlOdat43Yd0UXjkM7iWQGl8eIxFI5RYBRe80fLgey3Fib2J7+6v0KhoPKEW?=
 =?us-ascii?Q?azKknYPOl8Y4E88PcpeEdIXB20i89d3992v34aPXNh/XxNEP5HJV1+chdx3M?=
 =?us-ascii?Q?08Xs79tQUs3B3ZVzys06zvffBk5gBI7xo5iwI+v1aO0ftbfJicDbVIFXglRy?=
 =?us-ascii?Q?339AL8LDmXDwcq3Y3/NN3Z3vUe+v41ISNXzgqY8BM0kQrL96qwTlDX6jPC4p?=
 =?us-ascii?Q?5COZxQaOmkY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF0D43D62C4.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Di0aDg2OhBNO2+GHYBXa2kyggtAVUzfjnw0DFBtar8ZbwF+3qSRJqtE38aXE?=
 =?us-ascii?Q?cKYbp64Nv+dEn8R15qigVjk0w7Pt/tejo98+IUMWCIzt9J+lU2NexP5knyyf?=
 =?us-ascii?Q?1VFZ2vf3KYikKCMQWszvM8RIqmF/KVgdgWmyd53iYz6a12S2XXaMtW10zBLD?=
 =?us-ascii?Q?nYxTbKhDp4jmZVgLPQhoOP2kkqafytNFXsa0IxgEdhJKvLPPCWJ2rFp7hLzf?=
 =?us-ascii?Q?yLgs1vZ8LIyN7gZA+HpY0bmKqot2Ue+XDV7hy0FWnXU/2AFjcLiBL316jbQ6?=
 =?us-ascii?Q?mGbFs9NOVtfeaeEe34uqvWgRZ+G+1C2UndwOurV36xhb/cMNQoduwh06nqSe?=
 =?us-ascii?Q?kQNRZUiyo4QToIUTNnu2c2SFe56EgCSzNlsd8ZAW/oCXdnSRW6g5g4xx476I?=
 =?us-ascii?Q?vrSTr2vqn9X/cJGcj5zXtbT9HmSJWyOxdLQmwdE+rhfCsW0spwduvMBUpLao?=
 =?us-ascii?Q?Cnuuy9GX9pJdhgaXuXBwNrNJbjhyOekQhpWNvYmPCpvdx8QuabcpeNY1lxUC?=
 =?us-ascii?Q?COBrZ9wPHmgR8aBM26vUkKX4cuUw/4a7sb5hkBKORBp26RtT7XNPP19nMoha?=
 =?us-ascii?Q?k1WTevfOKBH67QTLFLRJ8hrhZmTA7hzmHBdntTZePpM7sBfDZD+m+QclIsYP?=
 =?us-ascii?Q?WhcqswL1WLhgAWZslnd69mUemPpj8t+XJJgh5I+lzEaPwvzvmS8ChX3RW5Wr?=
 =?us-ascii?Q?R64lxaopLNgzfISTEAg66Mcz+AEYC7Q+fILHWNEAPov57aDticFS6zc6tW+W?=
 =?us-ascii?Q?kjIvxHveYSXfhKGD1youtH6uGQsTo0i9OZw3nZzjWK8xlTl9M9aLs5icXyyG?=
 =?us-ascii?Q?oWsh2qoyEIQbBX2cmiGDgRxKdDXph/2v5Dan3hU3XrEcOizFBrJMBJP76vD4?=
 =?us-ascii?Q?PBlcD+XaLHge0ZUDWjD54EzdKponcvLYeWkdQ8bKYpyDNwSCtzwbGdNAihN7?=
 =?us-ascii?Q?RXjZ3q7Zd7EsnyaMxvIXiYgZQxYp0FO0OChmaLnB9cgjHtP+lU1Hxj+oWgkX?=
 =?us-ascii?Q?wYPmeKK4edOCmVQaX1rPhRS0F+nwQ+L0nKV3HXU2DWnoGGWL+v7rxfMOpJtM?=
 =?us-ascii?Q?8yNsdNV7UQnkLDTGXJB/dibwcFBAisEplXbkywmBv4Q/f3FES4dpA2PYcxOj?=
 =?us-ascii?Q?DN6Y5Hnw2pSfwzpgSkfqX3WzYlItCSi8ulZ36icSPBT2asQPhhI+LQV8KoQe?=
 =?us-ascii?Q?snlmed2ZvezXMu1gAEycPAADik3nMSsdPaYpy372KNsmN3WgrKH6RDDyQbcG?=
 =?us-ascii?Q?4gW7aE0MwyEsur9f/oC5+xOMkNKJBPR1FjJ2HvzKYEBL1AOJWfYmCdKFf21e?=
 =?us-ascii?Q?Fv1uQK3KDrhc7k3IItawb3nWDMNPfZoAzIXucGbpnOzqBf6mqOTpChMElBq7?=
 =?us-ascii?Q?Z/mD8VfomX8HNyZsaaejaRAvob78SIN8JqutF60fcLy4INfyY5Q78k51699T?=
 =?us-ascii?Q?6dbBKXvmOdsdNkjkNo6c5rDlrePAORNu7d8qyaV9YM0JSPI4/1r/U/89NKKY?=
 =?us-ascii?Q?g5Uab/JpWdWcNa03OqsZ3yYtC0GTR/77xDDzPih5cp6C1Y4cMdg67PWGb+W+?=
 =?us-ascii?Q?8SjJEfCuhkfg2KQ06tmLiSzKQyEItHCojAT7pouLkLr3+sm13NI2oSmm5hPp?=
 =?us-ascii?Q?IQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 15569f3b-b77e-4e6f-c334-08ddfb2552ef
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF0D43D62C4.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 04:46:28.2935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t0Fo+qsvLKo16xRYrCcOybAq8sBCJuKQY5HNOl640201sQZ3yRidyk85GOGMKYtWdnbUcBBOB6VmEWF3GBR08uFq1KzqYpGirEhUV2MBb6c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9393
X-OriginatorOrg: intel.com

On Tue, Sep 23, 2025 at 06:50:47PM -0700, Dan Williams wrote:
> Alison Schofield wrote:
> > When the --media-errors option was added to cxl list it inadvertently
> > changed the optional libtracefs requirement into a mandatory one.
> > NDCTL versions 80,81,82 no longer build without libtracefs.
> > 
> > With this change, NDCTL builds with or without libtracefs.
> > 
> > Now, when libtracefs is not enabled, users will see:
> > 	$ cxl list -r region0 --media-errors
> > 	Error: unknown option `media-errors'
> 
> ...but it is a known option that is documented. I.e. I would have
> expected:
> 
> 
>   $ cxl list -r region0 --media-errors
>   Notice: --media-errors support disabled at build time.
>   [
>     {
>       "region": "region...
> 
> Let the command continue because that would also match the behavior of:
> 
>   $ cxl list -vvv
> 
> ...which does not fail when media errors can not be retrieved, and would
> also make things like:
> 
>   $ cxl list -R --media-errors --health
> 
> ...at least give some useful data and succeed rather than fail and
> require the script to be re-written to drop the option.

Thanks for the review. I've implemented your suggestions.



