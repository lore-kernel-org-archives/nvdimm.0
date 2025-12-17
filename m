Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701D63A1E66
	for <nvdimm@lists.linux.dev>; Wed, 17 Dec 2025 04:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765945893; cv=fail; b=AReYpJa/dOvXw1sjVeBi2Y7tGiP0uRQ+ituJ+2DMrxet6NTMgU60qy7QeE31R2dYMBR2NoIssc+2qj5dqPJT+30u5P3RXKqUW+N07xhG3JP1x0do6yeWd9nFpGgIWORP9vM2As1/K7Q0sfy9CsBNAYFU+rbTVdJY2fysH5V0Rv0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765945893; c=relaxed/simple;
	bh=UqEYg4IGLmadXg0EmaUlKLE7Q6AnLsx4V0FAiH8jixw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FbJficTrYIe0GBhXmGCbN/AXaYJhDhtyZ99S6yuL49i7wocSP+0weCSAL72WxoxkDlfJkO1lCziY48nOFDIwyjDSISidnKozgihZoHDcUqg9P5zV4ZIIs6ONUshUMf4ZFOk7XbZ+3hnJjmXinLDICUffs/TIXNR8Oi08rorXYak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B604Laow; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B604Laow"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765945892; x=1797481892;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UqEYg4IGLmadXg0EmaUlKLE7Q6AnLsx4V0FAiH8jixw=;
  b=B604LaowKvqIKD7YViMs8zHpiHvRRrmUviLp20FaGFh0AOpxV8KPVaEA
   bhcpnU3mbx3um/VVkG0YYDd1OU9w6gA6E5nHD4ayakQ8lReMHiWl1g8Hh
   IaE8zOd++oPQb22N8rvrcvj+TyBBLCAnLhFyY8ohtz3rmzdXTZ+kwUXoO
   HTUEDFeB+GZPgWmgZ8qIyspX2SUy3x+IDuPtKdSltAvx3UnkYNqTfjcsn
   iVUYcCfI6IEPUlPGRYMFX548DhtonGIGzu3xmi1JFgSXWVo4yUgH3EEaS
   fhIitkt0zXnG63T7Ic34CY5yYriiA/RN85hme5Rf/0i2RzxpxXFfj1kMg
   g==;
X-CSE-ConnectionGUID: +rqeykz8TpiPYNwNfoGVNw==
X-CSE-MsgGUID: BQZ2+x9PQV6dTCtlRlVrzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11644"; a="93350261"
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="93350261"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 20:31:32 -0800
X-CSE-ConnectionGUID: ZNFlKjplRDe3HCExA1WC8Q==
X-CSE-MsgGUID: Q+vl7f2VRG2VqRMkdZs+4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="197483772"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 20:31:32 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 20:31:31 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 16 Dec 2025 20:31:31 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.56) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 20:31:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HGjR9KAK5z1N6wJ1+Ma35q0pFJyov6EKOwuis2rpWIMmaga2wztryPbRneIW1Paec8Md4ZwmcuU7IBtX2u/09NjD0zseLE29z99IHXmE/aCWkFJXbO2oeUEJB8KDPjGQlgoYYNsY0D73nDD00qvFinPxb5h0E3IFIpBrm/Ve3Tzw90VMatdR80I+SFFFplLV17bWDkIKlsrQAZ1gWxdYfEZ6AAbqiWeYp76PhfATa4arTBRrv5UuGhbOHvj9ygJ9DQCj3Sq+2BVH/LDM9sVxJHyTtVU8jhpDAYjkDEjABsXA+j/ElGmhBZdfKIvPmJwDlNIiHAJJHto63L8bhYWE5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v7WICN0PRRElHojBlc+Og+xNKkqR+t4NZPQsjvvtUDo=;
 b=AAR5V7TNfIBDFLkVWWmqCQehC7xiMYMoLJGwnEvBn0TeXjR4X6n31utgeMxaIpA/tRUKK2ZYJh9R5Kn3W+hPd3M5GpwJWiPsMIvKFb/J8+nVgk/nuj70VlvdT4Hb7GnACLT1rVDEfWOFB77OMMplHIw++rPPQQL1jhu0fDgUq9P5oUUtjDQ3cKkVm/nFG9z5FfC77zzQwkHYtqzTRCStj/RRLcDPJ8i5i1NdiC9XNAtx7Yd4nRbXjNqhyERm9x/bodMWe8xQ9B/zqY8+le085V4XM6xBF0C32fC0rT2+GlWFFG6DvQRQ7olF9av2AqQfvHeXYLzmanZbLEU3tYJyyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA1PR11MB6735.namprd11.prod.outlook.com (2603:10b6:806:25e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Wed, 17 Dec
 2025 04:31:23 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%8]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 04:31:23 +0000
Date: Tue, 16 Dec 2025 20:31:19 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Cheatham <Benjamin.Cheatham@amd.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<dave.jiang@intel.com>
Subject: Re: [PATCH v5 2/7] libcxl: Add CXL protocol errors
Message-ID: <aUIyF08ItHTBoZ7A@aschofie-mobl2.lan>
References: <20251215213630.8983-1-Benjamin.Cheatham@amd.com>
 <20251215213630.8983-3-Benjamin.Cheatham@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251215213630.8983-3-Benjamin.Cheatham@amd.com>
X-ClientProxiedBy: BYAPR08CA0063.namprd08.prod.outlook.com
 (2603:10b6:a03:117::40) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA1PR11MB6735:EE_
X-MS-Office365-Filtering-Correlation-Id: 107c85ab-a89a-4106-2f15-08de3d25220f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?LHfwhFIoN6fU47L4VviRKVK16suQ0Ro70WiqLTK5NVmoaZfP8G9ci4CCKkJu?=
 =?us-ascii?Q?I2EPYweUo5yTiqsz/Fxk89oW/8ZFneBE3zfrTtw6t2DIf4shvRQT8PauvRJC?=
 =?us-ascii?Q?2GoNz1R5tBgkkntgAnGJux19UiR2muGu+W8/BYb3oUVTQupSFoGQLnujGBK+?=
 =?us-ascii?Q?piN2qBKKlM6P+uVKFXsBmJKxekMmrdxrFL3/yarfnm8w54YM64FPr1nzUOP7?=
 =?us-ascii?Q?07C5y+QTCs157QVqJ7+daXtEybu8q3nxHJ5N6ScRJXuqTGCmtWPFUF4WBxtf?=
 =?us-ascii?Q?lYENpJpo8V4iYvyNpFeZS/2CEr0SIN6HaX7gqWvVz9jHeyUfgyLls7nqGrCp?=
 =?us-ascii?Q?E4YW3+zzUGDvZ/VfUSPUVCFKR57kLK+YSItOua7tHsbh96R2DefaBXwXS6O/?=
 =?us-ascii?Q?BOB4FAgkd1b6D0kjKNiAQIVrj6O+FY1gM9HzkIqOaLKQUE5pV4DxIVG0+8I1?=
 =?us-ascii?Q?Dlp+W4V1vdCmEMKZDCUZcgUOc4vvjVVYVGmrer59xaacdPBMATvJWdfjWg66?=
 =?us-ascii?Q?ALYBnL+j2YG4G13AJ3syHSCq7FtqSh5Dx2qm7Ew4Z3WhWm1FJNVlWtLjTCcY?=
 =?us-ascii?Q?Bbhn2nEv+ZbDsa6Hi/VwBIwtYackBB1Tv0DjRgu5sOu3IQPPEDk5G0/lzHN6?=
 =?us-ascii?Q?kLvqm2mT7+DJVJSGhMakhoGP3qa7c1Of5XA8wTVPxvkO8P5Wl93HMvC1aoi5?=
 =?us-ascii?Q?JUDIDft8mEXz71BWYocaPhpzN3MiuOBALKev0IOYg0AhFkETCCufipj10zr5?=
 =?us-ascii?Q?ttqKHEcj7WHtWrtxMdGgQf6Iu8VfqaX+nUlNKnjzc9lCTQrZDYM8lAEdt898?=
 =?us-ascii?Q?Y8THF+EzeTVIUEnUdgUQRuuFa1MwH+12OUHnrq5EjtWOxC4fHsrXJdht0bSm?=
 =?us-ascii?Q?NAnGgKHveb5VfOk9gLTyJ3sS8emCfqlgmGdUWL1kh5CR447h5dbx74ytpqWi?=
 =?us-ascii?Q?hwA0ADI8mCP8GH+XZb5+w9H8nuaSNLdrMdWLRV5FZ21FMeXJZieB0fjSmMBB?=
 =?us-ascii?Q?22BZYYJISxvbjqy5q2IWLp9ikJoO7oqHnK9YPJuwh26N1MqpzGRRMLlCKQxd?=
 =?us-ascii?Q?ultavZk7vPQ7vMuykSvX79j1tUVMDPjBJOjnT61Dqt0/SMhbrUgr1tiSBIaK?=
 =?us-ascii?Q?gbjVByzlqumZM7hKHUN+hHndF/IXYV8aZ6JuaDB6ZDfVuKDboVrz8V59nXHn?=
 =?us-ascii?Q?ZaidJttDaj05LKJuX+Oyk2uHC4FqdUu2Ppz6yNq6pl9C0W6O376rLuS/8fL2?=
 =?us-ascii?Q?vkGAefCgt6IqWzDXB+t9yESNwY4iNRqJtRRzZ0lYEdgut6M50haomebzKvut?=
 =?us-ascii?Q?ZqXpFVymEc5RNYpgA4Rx+lZc72cTfjugVTHDgHAeg/KgCsf1/OVM69KBSURv?=
 =?us-ascii?Q?4QSUABJX1BbWcbNasanndZULUiV4sDn5yuWD72bjRjT8YyTwHnAadW5Xv9UO?=
 =?us-ascii?Q?50CZwfFlqfv8DbPRwqw9t/pVAHxj3diP?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A9GIj/s+h10MoRsIOZb8KqjKoDy8u5xACuraYYbL37cXzsqyoFg4Fm9Hkc4c?=
 =?us-ascii?Q?tUaOZirZayfobPFKi/odt020xZtSi1Ixs6SfGP8GxUzt65oUskQMJ005HBEB?=
 =?us-ascii?Q?XDaTuJ5aWvWnokPAnOIjmXZTgyFf9zW3bohro0JAOnz/uRkxMG+UC41I6EYO?=
 =?us-ascii?Q?Sz42+WGuAJml8WnX2Pw+GBCuifE4gTagWC5MYBnHXC/bxp9CtJ1uqx5XBz3y?=
 =?us-ascii?Q?wADIgLmF6q6109omZXXgfFJ6J0vcjQpL4Glqu3ITI6lF+MkOY62A7qZAGPX2?=
 =?us-ascii?Q?Dp47yqLdyayko146BtHN8w3h6tvyI3/2lm2MSc4wrEvEfVqfq0NbIs+pZAEm?=
 =?us-ascii?Q?DIyVZoOezMRooSYjBqaUUXc2RQ/782zeP9TCIE0pixOTd7ooe8GlP9IJcLda?=
 =?us-ascii?Q?cNQTzCgibCxtiwVr+Mx2gOY3B90P+keYIb3dMoSQ9VfXZlOxTk15R78U1Nyj?=
 =?us-ascii?Q?y1e0xFw+RqeJw5YDDhc+6XH8cch3aPye/+tD4bBJmXLHjiMT7JdXGmC/la4j?=
 =?us-ascii?Q?I6RUTc9WyftCTri+8ZasnDn9zp5tiEDaYGsv8M20mOMHsXSF46xZA8j3xOm8?=
 =?us-ascii?Q?GNVWaKyNIIEAye6fiK6qQGnDAu6C5bvT8QJNFxqSH9DFsplDbLgTPhiVAdAB?=
 =?us-ascii?Q?evW3UcJDOV9IkDnIxmAvdu5t19CfgD76xHflVrY+b8CygD4+O0ETxoMgZA02?=
 =?us-ascii?Q?8jLiHnL0TlQKlSKLwOMFAohPmFRW6uBC+whH5XiiPp//b2ps6u7h1hxYJ0sf?=
 =?us-ascii?Q?2xDPeTPxlHGwRP+KLxBp8MWNrWL21pjB0BbA4CNOF0Xh8Ck+4DMy/xEGDDn6?=
 =?us-ascii?Q?8RNL2jWbf77ws1MiIgYzuNlOazaeBJvH9ZAPC/QcqxIklLokdYf2zvl6O3Dq?=
 =?us-ascii?Q?gkjpo0yHuxd+khqUu+MUuBLrKw25Mq9U/ax0xocZbA1E4/IQuCCygeFnk7mQ?=
 =?us-ascii?Q?XZZk8keDVKcfmuNDfQOhSOe1ZRiZ9FjzPgTt6QsCZCsV29uAE1s6/lIwTYMG?=
 =?us-ascii?Q?xSAc1FQ9yHajILnxY1L9XZQunmjWE14kPJVFXgt9pa/5RkWPc6WE68SDwhoH?=
 =?us-ascii?Q?gzYHzmAAoHPV1Ewb0bvPTa+SGb1debqSLZVXuz6aGO0E/8Yyhcz9uCx1jWvv?=
 =?us-ascii?Q?+YsnoRdkVL0qwsZZ7az0bYns6EoqB6zkT4nRdPnv67LKmTG5uD37z3AZX9D4?=
 =?us-ascii?Q?Y4ZBjIJHYBgttRKGdoQ2tLUB73T0isGUCduth7h8TCOhKZm6ToFeC1u9ei8K?=
 =?us-ascii?Q?6oQ64mlned840CXUtsIGpanBOu9/xQ4g7p9jLC/w5XacLxn2/XailFITlfsA?=
 =?us-ascii?Q?m/ALAbBnMwQjII6PdZHuzp0Mbcon/FBTP4OTrnFEhIXNGqMns2bqC0TgqaXU?=
 =?us-ascii?Q?9DACiB7SkpgHEvgA4JcjCfsaaGnX9XY23/f6sFVA/bpaDGNC3kWEJgXOI0pp?=
 =?us-ascii?Q?xcfs+Tmu7+fT3NVwPSTWZIBv4StdHIl9eTeQ5hQmVLuPJcGG6x1pX3iqAMFN?=
 =?us-ascii?Q?J3ecJ3vM2AfLnV4nufkudlFlFFO3Cp6YaclRHqNsMzeyWVzwQJmKP8qmg6GA?=
 =?us-ascii?Q?crAupax8yaL6BTML4By8zZJuLbB16fFHmqsh/A7Tyxq2aSX+whD3VyX9HrqO?=
 =?us-ascii?Q?MA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 107c85ab-a89a-4106-2f15-08de3d25220f
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 04:31:22.9288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e607PEXOj7+cTjsLdGIob6USDdbsfQwoHwib2qSXd2/pNsrEssOwPC6OZPK45n7nk5tAuO7s3c4xVxKrIRJzqQBVd5dCNQCdfMjmShoPdzI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6735
X-OriginatorOrg: intel.com

On Mon, Dec 15, 2025 at 03:36:25PM -0600, Ben Cheatham wrote:

snip

> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index e01a676..02d5119 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -299,4 +299,9 @@ global:
>  LIBCXL_10 {
>  global:
>  	cxl_memdev_is_port_ancestor;
> +	cxl_protocol_error_get_first;
> +	cxl_protocol_error_get_next;
> +	cxl_protocol_error_get_num;
> +	cxl_protocol_error_get_str;
> +	cxl_dport_protocol_error_inject;
>  } LIBCXL_9;

Please rebase on pending [1] so this merges nicely. These new symbols will
land in LIBCXL_11 with the new ELC symbol, all destined for the ndctl v84
release.

[1] https://github.com/pmem/ndctl/tree/pending

Thanks!

snip


