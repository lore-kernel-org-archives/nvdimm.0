Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D1C16A956
	for <nvdimm@lists.linux.dev>; Wed, 17 Dec 2025 04:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765946859; cv=fail; b=Fp1lh3buxWZMPVhrmvBl72P0P1Psh9/UQJyZ4fb13VoWe5vy4vMT1fyUGMeOgOj5lJijZf3KxjLNDbuUtPWM6tOZoy3XKiDwho1Sv849ftKlvpbAOQt4C9h4FNSGJlxott3gSKG7vEvnTcc3N1VH3mM0SvUaILJjnQxRumfS+Nw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765946859; c=relaxed/simple;
	bh=sNklnEqFOnVj6vlWb55rkg1XXkkKrIW0FRmWmtW+aCg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=N0c/JdNgrJrGZbxPy90YAyakjcx4WSXJDBB+N4ikGn+6mUtaRynjgH4uDqmmb5cJR0/7xBtV3ddfbRbiE9navv3oml59gxLFXIT5+Z8Ig8eZjEOm+3F4tWf43xgyOiXap33TZeAZYqurq8OIWzr7YbpeqVjMH+YNtjPoadVuoOY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E9AG4A4e; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E9AG4A4e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765946856; x=1797482856;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=sNklnEqFOnVj6vlWb55rkg1XXkkKrIW0FRmWmtW+aCg=;
  b=E9AG4A4eql4zFcc0BC5n80y1CpkxA1+a7geGsm9R+BquNGXwNl61XS3r
   o7IGurYntbaMFcibR/TcjjHOaeq3zfcW28jqjKpF9UiWdp4DYmG5u5ZdH
   4+t0eTir1Zn4FddoYyTX+4VLYqj9zZrq58rqBN/fAI6ubL/y8vu1t3NWN
   UZDbe6nC8hA3r45Ks0WBdWjEc4XPc+0VUjZYdmLq0u1BcwFUz56KRNwJ2
   hoDoUQA2FBFXfmurbz4i55Tqob7Fzx/8PMtHvgusigF+ddM7eeLD8zeHK
   s+sjiPRkVeq/OFq77DxGGkZ27AYf6jmV7mRpNfXz970Tk+/npa9i7VZfm
   A==;
X-CSE-ConnectionGUID: IgBveTctTzCi4ljyw5OSeA==
X-CSE-MsgGUID: SGpW6d3NSkimT20v+8jasw==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="67814492"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="67814492"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 20:47:35 -0800
X-CSE-ConnectionGUID: O+T2vUImS2iywgNfeSGxfw==
X-CSE-MsgGUID: InaEYCWTSxemSAQ4NibNqw==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 20:47:35 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 20:47:34 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 16 Dec 2025 20:47:34 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.41) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 20:47:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lo4uyxgGVAZLxL8Zk0sGT7xw2XiGQNPvQ37+92FIAvoqxLKNailty6RmhLmPIlRQUTz+LKnC207in2tBBtLMp/6DxsPyeqbzc1vHp772SR9U09/HQHIPklWXzMa5hj4TZlXaOPRmWDwAeQyyCzH0036LwI8ou4A890KKk6YEaYzrzelD3B2DnWzpshOhkoMiNJU0IYD2/CBEBbTRKvlEowz09YiKWCFj9QzsHGBDXo9BMo625TOBswIJSiOtrSEACu8JxBEer7V9KteboydEftJ8/kqFVWRKL9O7od7/lqRapnrpMYN9nEAxDTcep3x9VWhn8XzfJs4Xdw4jf76qTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q40COH88nm63yCi6vmgCA2QbRJ0BmrzuhAwugrE2kec=;
 b=JctPP59pfR7AgkN0rhdcn9HpWyxOa2X0ktPtOh1QF0gn0EN8Q/E2ujqBZhyWIux3W+BES4KcrF6nY1R1JCv71mdnmlIXbPExxETmueujPrkenmtI5DzLCsDlGjHaN8sF4ESE+vcKjxiDtO2e/UjAT1ZADDXt8bJDazfLnOz3vIFIoDdbNKq5pwP4NwPy/hHcIx7Z/uBK3Y5yHVRzdf0V9D1uBKUuUXp6me0469qmHMTMsZVH8MMorDskDYGQ68KM470/7anR5UR8wq2H5/8hevgrIFwM24eVJnYUn/tDwppDPOkeRheDaczvI/izuCh4J9Rlu0bT+mrA14G1QdhXoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DM3PR11MB8714.namprd11.prod.outlook.com (2603:10b6:0:b::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6; Wed, 17 Dec 2025 04:47:27 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%8]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 04:47:27 +0000
Date: Tue, 16 Dec 2025 20:47:24 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Cheatham <Benjamin.Cheatham@amd.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<dave.jiang@intel.com>
Subject: Re: [ndctl PATCH v5 0/7] Add error injection support
Message-ID: <aUI13O1UFv4L__yw@aschofie-mobl2.lan>
References: <20251215213630.8983-1-Benjamin.Cheatham@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251215213630.8983-1-Benjamin.Cheatham@amd.com>
X-ClientProxiedBy: SJ0PR03CA0139.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::24) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DM3PR11MB8714:EE_
X-MS-Office365-Filtering-Correlation-Id: fca42ada-ab03-4e75-1632-08de3d27612c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?j+QyXHWwfwkuvbtagGoF+gFu62UeYJ/fb2IYGsztq41V+DAj745qZncTXxrM?=
 =?us-ascii?Q?Y8cFUDFds7zKL3DMxW5VadNmy3UDsxpzO6UeAWWDtwbBiVGg2+LC8BWXrvzI?=
 =?us-ascii?Q?kZwDUwlS+gFR7dWH0vRJnIq27wFmidXO1uMrNr18HLNx/vXHvpwZ6UPTy/Of?=
 =?us-ascii?Q?zdCplQq8ILt+usndNVyycUCB6QhzIplnybHBkrLbye1bWd8uCZtFWuASNlqV?=
 =?us-ascii?Q?9JPkhU4lqp4aGona9qSVwADuJIKEChfgoL0z24LwqlkITF6Dli1IgXZ/psUq?=
 =?us-ascii?Q?6/I+l+/ReusTn/nYOdFp5nlkRkqeTLWUFH0v46QqLeQNKuFvOsiix2XY7PKo?=
 =?us-ascii?Q?2QqZUEoeE+HuLaj3vhPLO/wgCJpnG3xCGNb9YYuxVjjJN07ER+XP8487YHZw?=
 =?us-ascii?Q?hct87GuwjmJN7VkdV1nJY5d6j9uPHyZNxGmOUbETaQacswbQZlVxNjjHbWXN?=
 =?us-ascii?Q?QEv985qrwx7KfNXl4x60hPxmvuxJgGEvng42GCZEv7ID0PuKUZc9wAXMIbXx?=
 =?us-ascii?Q?Fb7OGW5AtqgI45wAaPzNOyFXB6qmKa3F1ap5UYFa795Y5vl2eztm8Ip9yaK1?=
 =?us-ascii?Q?zXwFUdlgn0anxv2Aqn2SUHix4yDjM0v/6In5V0yJ+T2PIjD4VT++Vxt01Fdf?=
 =?us-ascii?Q?0qmnf11IubGfEKZevvMsrVaIhWZPjroThJmkVGbdobEklsnUwGW4QITb2WVi?=
 =?us-ascii?Q?csu9Vaom/e85mqBs+mScuH1l+NyyLLcZ8Qt5Thy8kQ48jfu/xCFknKeqYmEM?=
 =?us-ascii?Q?05dRB8USkyyVawsHQKvvpxUos7hT7xthT2JgShkLVbTHgw8BOH9ckfHtOxLU?=
 =?us-ascii?Q?R8J/j25/nt63ahJD39WbIEoNOPCZkAlHKojT8j1nYYbNC5xd8F8WtJnGnYNe?=
 =?us-ascii?Q?vP6QnMGEoLW+ueSzA7nqwSiiqBzhtZavSTnW2HsDL2aK9alIIa5xLKLU48y4?=
 =?us-ascii?Q?z13sCuNGHcA3BHgJIDk5wJrL7i2oeh4wQ6b10z/N/C3SEo9dP5axL2aBcvj+?=
 =?us-ascii?Q?AOU/QHS6S1wYIMl+YS9RyhCUlLFX8jvFrEx9C1cBhkdLLBrOQ3wya1o0xU3h?=
 =?us-ascii?Q?K+RVLhAqX67GJQNnOBwM+GII+tja3RRy2IIJigRT8fK6BM6KLnbECO2K/xKr?=
 =?us-ascii?Q?7eatV502kmEVXNiQT30/DushaYqO2oqR/MHm+coCY+j8yYMN31yfA1BRNvDq?=
 =?us-ascii?Q?3fyac+W/lp7mOLJ/I5grYDVu1qwHtlllcxLaWbrvF9zE0y5ySe8distZX5d9?=
 =?us-ascii?Q?PjCDtufoGC8uTx9vRgPlwxu/IyKqJJ9dv0vjtxcrfkzCyHD1t3OqkyCAGNsf?=
 =?us-ascii?Q?KkFEHrv6HjelLAiWl7wLsdv0rK47z8myt/DX/YuY7JwK1h64StUka8hwYv0q?=
 =?us-ascii?Q?vbuk5H7uJtdVGIxiWaI4RJSIgFwBgOGz0+HBjvt+xFySjI+lqQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ey0OSZWb+O7LNCNIaqK/I+xneslVi4CVPyEjFqVcz+/fD9jU3hFo0OPofJPL?=
 =?us-ascii?Q?FxEte32wfHmY32F97agCivRNcfVRVOaiejczDyF7hrQ6c7gyxxWHuHuUnTcB?=
 =?us-ascii?Q?iYBmn1nINiCQMx137VMHzqoLFuwvvXS4q5Lp958L4Vvfh272Frdu0r5UZ1yb?=
 =?us-ascii?Q?pmV51flAZ7k4uY2p0Ip52lEiPazaUBl6Yz/LE86bIbHUastocCMifkLv6EcW?=
 =?us-ascii?Q?c1pkNj3k1kJQVyBcRHTHikwRam79kxlm1alwSSOe/209RWLWuNXaA58kcjYM?=
 =?us-ascii?Q?vT/BCC4kdFcfneyY0tP4DYoa9oMiERBYwFR9woaLz7tvdVfQBSbIjmRQtn8J?=
 =?us-ascii?Q?cCMzAPn06QHR1XjAu/MsETiGiAx/9TCCBrg7pXeJR4RCaqEuJZYMeH/gh1Bn?=
 =?us-ascii?Q?YLIhZCZTA/NBG7c1TCdVrYjvyGHW5dNubKvO7GOvg5ycg3ds6LiKKnPl72jB?=
 =?us-ascii?Q?AOFug3bmAOvIvMMXTL8wLlky5IYvt7Ncyk6TiT/cxOUwdVip7s8KgYUXIzKc?=
 =?us-ascii?Q?4/7M7bzZP9kwha7OJqEPqeR8FYlj47YLi1AzKVfxAIpb3w8E0QlcOGDARTto?=
 =?us-ascii?Q?OVB43lCNS927qIvArJUJ8oUrPDtoMIn7Ly8+xqZ4bccDX6GVn5VQel77DDmk?=
 =?us-ascii?Q?FEN/NAT9YFn4mUMMUYobyr7Jhoy+pQGDrYC+vs6f0uaVC/m5M8kuK1rdHFx2?=
 =?us-ascii?Q?7/lr7fVRcmo2NH14lSvpt1Spc4fz/0Bbehi+/ASuvhiomxwZDkz6gdwgYq4A?=
 =?us-ascii?Q?oenvsOFl9hKc9f5k7B7VHDeflLoRMCjxibQxSKd4M+9bHZRs9p4yZV+GX5c/?=
 =?us-ascii?Q?U0bQQdl0zCBwtWDdH78A4jRm+AdE94Sn7X4G+Tv1RqI3kdwjqKTbhLZbM0b/?=
 =?us-ascii?Q?6H7BfwoBTbrTaNarHCwsgvVRomEBxh1Ni5kdH+bOjH0U7ksH/oi2MpLfK1wL?=
 =?us-ascii?Q?z+7FIBuW3IrLJjGASYCrg4JpcgBSqO9dajKgHL9VFHGkjcrYKFZ15kH6EpcM?=
 =?us-ascii?Q?X358khFvnT4llTEtSjc9PreB3+9lOx9HmyxeSEqjO+pt9bUk3iZSwlfVH7Fp?=
 =?us-ascii?Q?/RdJBXGC8GVYEW1JtSzmtoDmGloPj50nRfK96ZaG5b+fIEcYONPJdCgxCB17?=
 =?us-ascii?Q?k63kWW+ix9g7iCkUtyuj58HOiWHTTJc1s8pc3s8KSkoRBQ0chWYWbiIWH+Kk?=
 =?us-ascii?Q?h/xhg+qLr5kZlukcydb5aBSp7po11pkP146QO5Wqh7ZljaGkohyfQi6I+v5I?=
 =?us-ascii?Q?DzzT4RUq9qBZMw+fotuxqPyT1frbUcPBLx8icT3VVmH99xnPCCioS+HL+u4o?=
 =?us-ascii?Q?zEJDVnmYsUbpo64Hsa5rqBq8HG3V3bxKHAYL44jsG5h8FC1+9flLqgR4OSYi?=
 =?us-ascii?Q?fkk+91Tu8rqIC/qxKwfO63L3V/Ab+/MrTZuH9ML1CD2X02JzpUDDQYeNi+5v?=
 =?us-ascii?Q?YU0rfllWFq8Y8eCIkt+N/9BKftQUpKRLPBx7y9XRL67d3U32vSJAqvKnxX4Y?=
 =?us-ascii?Q?qVcPQ1uoaBxxU6pazBIuIP1pqg9re9R/Ddc3fsXj4IV85/oaXsvj/3EpYtX5?=
 =?us-ascii?Q?BIWs2CsWEC6Kib1+Uv4n9UHfQtnsfURQWEm6Hi5yCuE/+UAaRc4dsvAWznXL?=
 =?us-ascii?Q?qw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fca42ada-ab03-4e75-1632-08de3d27612c
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 04:47:27.7450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FCypXLazTmFB26iUF27WKPE7j3sAjZV49lxh5xcfCMj846pDrUrDtDoHfkET+vBFYbwIWJranp0HgMZt6JCThzgcqw+VAw+rVV1EQfPRJWw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8714
X-OriginatorOrg: intel.com

On Mon, Dec 15, 2025 at 03:36:23PM -0600, Ben Cheatham wrote:
> v5 Changes:
> 	- Use setmntent()/getmntent() instead of open-coding getting the
> 	  debugfs path (Dave)
> 	- Use correct return code for sysfs_read_attr() (Dave)
> 
> v4 Changes:
> 	- Variable renames for clarity (Dave)
> 	- Use errno instead of rc for access() calls (Dave)
> 	- Check returns for snprintf() (Dave)
> 	- Add util_cxl_dport_filter() (Dave)
> 	- Replace printf() calls with log_info() (Dave)
> 	- Write correct value to debugfs during protocol error injection
> 	(BIT(error) vs. error)
> 
> v3 Changes:
> 	- Rebase on v83 release
> 	- Fix whitespace errors (Alison)
> 
> v2 Changes:
> 	- Make the --clear option of 'inject-error' its own command (Alison)
> 	- Debugfs is now found using the /proc/mount entry instead of
> 	providing the path using a --debugfs option
> 	- Man page added for 'clear-error'
> 	- Reword commit descriptions for clarity
> 
> This series adds support for injecting CXL protocol (CXL.cache/mem)
> errors[1] into CXL RCH Downstream ports and VH root ports[2] and
> poison into CXL memory devices through the CXL debugfs. Errors are
> injected using a new 'inject-error' command, while errors are reported
> using a new cxl-list "-N"/"--injectable-errors" option. Device poison
> can be cleared using the 'clear-error' command.
> 
> The 'inject-error'/'clear-error' commands and "-N" option of cxl-list all
> require access to the CXL driver's debugfs.
> 
> The documentation for the new cxl-inject-error command shows both usage
> and the possible device/error types, as well as how to retrieve them
> using cxl-list. The documentation for cxl-list has also been updated to
> show the usage of the new injectable errors option.
> 
> [1]: ACPI v6.5 spec, section 18.6.4
> [2]: ACPI v6.5 spec, table 18.31

Hi Ben,

I did a patch by patch review but saved up a couple of usability things
to chat about here:

Consider removing the -N option and simply adding the new info to the
default memdev and bus listings. Both are only accessing debugfs files and
don't add much to the default listing, especially the memdev one.

For the protocol errors, the cxl list entry is always present, even when empty,
but the poison_injectable attribute is only present when true. Should that be
always present and true/false? Or maybe true/false/unknown, where unknown is
the status when CONFIG_DEBUG_FS is not enabled? 
And, maybe something similar for protocol errors?

Please add more strong 'danger' warnings to the poison inject and clear
command man pages. See Documentation/ABI/testing/debugfs-cxl for the language
we converged on when adding the debugfs attributes.

I have no test for the protocol errors. Is there anything you can
share for that?

I'll send a separate reply asking if you to append an updated cxl-poison
unit test patch to this set.

--Alison




















 
> Ben Cheatham (7):
>   libcxl: Add debugfs path to CXL context
>   libcxl: Add CXL protocol errors
>   libcxl: Add poison injection support
>   cxl: Add inject-error command
>   cxl: Add clear-error command
>   cxl/list: Add injectable errors in output
>   Documentation: Add docs for inject/clear-error commands
> 
>  Documentation/cxl/cxl-clear-error.txt  |  67 ++++++
>  Documentation/cxl/cxl-inject-error.txt | 129 +++++++++++
>  Documentation/cxl/cxl-list.txt         |  35 ++-
>  Documentation/cxl/meson.build          |   2 +
>  cxl/builtin.h                          |   2 +
>  cxl/cxl.c                              |   2 +
>  cxl/filter.c                           |  26 +++
>  cxl/filter.h                           |   5 +
>  cxl/inject-error.c                     | 249 ++++++++++++++++++++
>  cxl/json.c                             |  30 +++
>  cxl/lib/libcxl.c                       | 302 +++++++++++++++++++++++++
>  cxl/lib/libcxl.sym                     |   8 +
>  cxl/lib/private.h                      |  14 ++
>  cxl/libcxl.h                           |  16 ++
>  cxl/list.c                             |   3 +
>  cxl/meson.build                        |   1 +
>  util/json.h                            |   1 +
>  17 files changed, 891 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/cxl/cxl-clear-error.txt
>  create mode 100644 Documentation/cxl/cxl-inject-error.txt
>  create mode 100644 cxl/inject-error.c
> 
> -- 
> 2.52.0
> 
