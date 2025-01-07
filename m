Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FEE46BF
	for <nvdimm@lists.linux.dev>; Tue,  7 Jan 2025 01:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736212299; cv=fail; b=awqiRb5+XZB20E08mSDEKZ70OyTslL2Y/OIMIfhR5KXLlBttoQCt2+6kWFkbmUklEvIRmUvJVtCPutTiDILvdOni8E9xBKTH3LMbJjqzFothSPcyn1WafDqeORYfO+1olrsCpGEjpUSl9CCnMNZcJ0AnMicNnBbLF+1BSz5rYk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736212299; c=relaxed/simple;
	bh=SBUKEFM4vARHApRCg5t83CNOvaMSZkd34vHLYXk9jEY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=S5KZMYQ8e5AsISRs8T87VHhEh6Pp0QraqW0HPjCtaKXHyYZ1Aq+QxLrfG/LqSK1DNTMlHvlLTX1h308+j1uepzmsxEYtv79rZR7vjhA7mmkwbWdEv3xgnEaXGASPN5tvIsv17zfNE5GDafIfiRni+dMU+ShJyhQUR4HeqTCjAQ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LTTByLvD; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LTTByLvD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736212296; x=1767748296;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=SBUKEFM4vARHApRCg5t83CNOvaMSZkd34vHLYXk9jEY=;
  b=LTTByLvD3XkdQOOUirMVfRzV5YYAK3aJGDcIXvdlBHvY/rdg4Rw5cRFa
   4cCpnyWSHZnhKXA0f8HQmfxocnHOnbVsEstzO1kDtMazSCBayLHZ6i6Ok
   tNkUdb/z32NiQvtISp9cjG6boC8y/Vp8/vasFUluM8tvHW5cet/tLDGTx
   ndP3z5Ay+PdEOyc78w8GcI583jhx5pNwuECrDhZJ4jBhyKQoQPVXXHSSk
   nhdw37gcJoVh6eA9jiClS08mjDPNomHvO2O6gwlyVENks8Wgp6nvcwBgD
   f58x9OwiNQYxE1xD2cPvFREt2boXT1Ny8Buijpkb6iUhePncP9bmf2Jgr
   A==;
X-CSE-ConnectionGUID: /FTzQbdhR1ewbFMKA1lnnQ==
X-CSE-MsgGUID: QhuH3tWSRw6ND5IR+vKg2g==
X-IronPort-AV: E=McAfee;i="6700,10204,11307"; a="23986044"
X-IronPort-AV: E=Sophos;i="6.12,294,1728975600"; 
   d="scan'208";a="23986044"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2025 17:11:36 -0800
X-CSE-ConnectionGUID: +hujOjbQRWWxZwx9EUflcA==
X-CSE-MsgGUID: TESpMatIR7q+tCHsB4G/CA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="102470771"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Jan 2025 17:11:35 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 6 Jan 2025 17:11:34 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 6 Jan 2025 17:11:34 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 6 Jan 2025 17:11:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NgixdFKMhkmhk8ZhsX5qB+ixpGAX8Tq1/XwURn6ibwn24L+/kwKSZh7GPCNPw6GnRbl42EnrALctkHN0fH4oGeYVdPE2hBNg2Vnaye6sZ+UR+mpFXOLmHYiVagbPdNB7EQw/QMZ38WZjfRzuayWGWptCZlxu0BCA2gzJi6uKi8TWmum03ipSCUgleCMV7IEh0Is4BJ0KE5eB26plDnEXOzYxRCCbPW1u4z0+nNDGWEfNKMgVKDMgnM33HOem69tAOgeyxbCwwv58HJSyXjg4eckFlFvnERhQ9Gl1L9w8m5+rxPrqDY1ElH2kTPL/WQPAbmz/mI5yO5e5oLyOYTd0yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uVRfdZtzd7wbIf11IjniouSAXv++FM7jCDevKH2yV40=;
 b=UDMsUNOEzIv3LkQOsSgevBRy/mdng4lCr4w4/465ZQ8atxxTppxSpHuv01t1IFO0CPuHM57+L5iSE3ZGa57k6N9Wo4rFwPn53CXME5LpxAo9Jo5uItCF7C63dVJt+e/Iu2ff15sbDJAFkMdfg2FKh4gti6Jb1GJJBITq+SqIg3s0NUCZm3bFcuKUModZw99lcBwTqjRnLn3Jh0duTcsQICi2cLsKbugGtKL8uWJPS5bWNCtu6eu0m0lUk+YGJtkOcoKSVrxfWZsDP9UFuaVdCzNrkMIdu2XzAlxsCzWAgKrhfLGtj6f7XnRsU2wv2Ms3OKwlJts3A9ODjUmTQN4tCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by CH3PR11MB7763.namprd11.prod.outlook.com (2603:10b6:610:145::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Tue, 7 Jan
 2025 01:10:46 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%4]) with mapi id 15.20.8314.015; Tue, 7 Jan 2025
 01:10:46 +0000
Date: Mon, 6 Jan 2025 19:10:39 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>, Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>
CC: Dan Williams <dan.j.williams@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Alison Schofield <alison.schofield@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	<linux-cxl@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-hardening@vger.kernel.org>, Li Ming <ming.li@zohomail.com>
Subject: Re: [PATCH v8 01/21] cxl/mbox: Flag support for Dynamic Capacity
 Devices (DCD)
Message-ID: <677c7f0f5ada9_dab0d2948f@iweiny-mobl.notmuch>
References: <20241210-dcd-type2-upstream-v8-0-812852504400@intel.com>
 <20241210-dcd-type2-upstream-v8-1-812852504400@intel.com>
 <67786b76a0c5_f58f294b1@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <67786b76a0c5_f58f294b1@dwillia2-xfh.jf.intel.com.notmuch>
X-ClientProxiedBy: MW4PR03CA0055.namprd03.prod.outlook.com
 (2603:10b6:303:8e::30) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|CH3PR11MB7763:EE_
X-MS-Office365-Filtering-Correlation-Id: 82a7145d-0f20-496e-da71-08dd2eb81dbf
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?w1iWPaNWhv8OeHvBWSx9/XcLZ1hcjmgY1hD8OMqecLCmFckYjiITpszc01z+?=
 =?us-ascii?Q?AhM1FmQFO7st69zW/mdyRP0h6pEPvmh8tLS8XOxduN12zK/cHy4cxpc5ateE?=
 =?us-ascii?Q?wy/geNzzyQZLACckZ6jw/7A0qUNmyz54jlkfJS9bDYEozGk5U93z6ly1m1xi?=
 =?us-ascii?Q?pEb0Bo0r9VyfpvfFxPce4MW2yPNdQUg9d58xXrySOYDzkWL1si1f5HGKwbZI?=
 =?us-ascii?Q?Q1zYOVhMrigGZWyTqy4yruT94Ju03emPaBTRr2oVDC4NfB0XW80lYXarIACe?=
 =?us-ascii?Q?3mhutNIGMvR8t246Hm44xmHUxrRxRIk0rkXz00eTRt3m6o1yGUHg+eUyDo+C?=
 =?us-ascii?Q?XhxB6Ft6y0/nSYJOSebFnVfWhXvBAXa9IGpRgdeVlB5ZQ3BUljBvujP88uqq?=
 =?us-ascii?Q?Hnv2AWTRfemu64qQLUw4zhz/u5wvlh1hmFHHseQ6T+zgwhNc4bsYin78nG+I?=
 =?us-ascii?Q?vwmK+WxNleklTKPHCDVlBl9WsgS3/z0VzHyoqp3cDMHPmx1ngZJsLRpzEwFz?=
 =?us-ascii?Q?zbtprDaWHx35fTvmcA1b6j3OBwoqsPmZOAeVve+BNwhBKIvAJzAt5A4m8neW?=
 =?us-ascii?Q?ZYUsUZgjVHIW/8mKSoAcIqra5+o59fwBLTLs1/c0z0bBY5rPiXGbJD2jPlpo?=
 =?us-ascii?Q?mD4NHq2btjKS5c0khQ+LQg4p+iFvV1QuDi6XUk83vCzsXuujWFEPeMbA8nJc?=
 =?us-ascii?Q?iu9XYyv2pLZQseq4ByRA2sIo8zC6dJbi1VsLpBfPidRsu2VmZuqloH/DBt0i?=
 =?us-ascii?Q?Oez27tghIq/b+nfPw1F9onFplC6rVEByHWY1D3A0yeoc7BqOBrlJg8UKO1Sd?=
 =?us-ascii?Q?h7PuueHHWc96+7btL8lJEClnVaG4CKCWwxTNBQE9SbkUWN5q0TO8Eo1HOHJC?=
 =?us-ascii?Q?irbXebrdQXaraAMaUvWXpRfqPcR00L4sTmO5tSr3YQr/dTzIccXDRXx8g5S4?=
 =?us-ascii?Q?1PX2Yni+/mZ7zK66W0hL0NXrM19JZi7wDOnZbC6UyUX4AXeralHxqGPnvktK?=
 =?us-ascii?Q?VB7tBmQvtGAWlYEwMVE7peRNftjdnPreczb/jsic+5UkYcpdFMjaODIKDfOd?=
 =?us-ascii?Q?wUnt7fm1BC7C4bWVogUuOWNy2TOU2GOUiA+ejSzgGb0QEwFBOt9d4WcqyzAG?=
 =?us-ascii?Q?WGBVLWTB74jCGJI+wNWeYfmbxC8yCCE4tP6XPOt1mAv4amu5/I/8VeKCz16n?=
 =?us-ascii?Q?36aTNrVCP+OtEfb6O2ADk33K0BTEtZEmItulu+Ku1U+kovEGWsrDM3pl5GET?=
 =?us-ascii?Q?ah45ZraAVkJ6TnSBw9Zo1pJ96yJhzldK4LNxoA0DbAAw27vkHoX2fgcZ7PBX?=
 =?us-ascii?Q?F93QBUZEdFNmxEUTX5TKI724ghxALBdQdpBq7k+mFUSRQIkqMrXsxedBIpkM?=
 =?us-ascii?Q?KHVu/5f7TrvFJF7RWHFBpkG8m/M7?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CCHqqfIafsQ62BUQu7+GxKrIOZOkQVbtAJaRb0765NjCmH8WdrTYsX1IdX/1?=
 =?us-ascii?Q?Z4k0KAnJMU2QRH1puS9QdY2UYHEJ7G9QNiY4qXCPK3EhWIjscHP2q4/f22YQ?=
 =?us-ascii?Q?rTfQaDklmoLWA8tK7/tdE8lGKYRQu/x4P78XaArZ/UdB8ZmRhKosQVRS0E30?=
 =?us-ascii?Q?wsLgUr8g/eTaGwk+RdseEqROMtO4dWwMazlXF0aGCUdr572ReTQZ3MYBvzbF?=
 =?us-ascii?Q?RZR7wWB6/Tbq2esRYy3WFN9Xe2ME/XQUgh3UptnsnOxghE2R1gLMB0fIQdKD?=
 =?us-ascii?Q?8s8hM3/DpWrjWXxA+c+LLFo8gDuhxeDdfmii83+skpp5FuJ3bOEjzQO6hvff?=
 =?us-ascii?Q?MY3/dR1rc9bVbs/CLPTpHdamd+2a+ocvFQiamlaZAr0eKxa2W5/GF/CCdPSF?=
 =?us-ascii?Q?HpteNCwukfb14ijEA4C79Jic8r5CtuqobSHoN8lTdmAwBNBMszgkoMvagJ9k?=
 =?us-ascii?Q?hwgnL5X4zu+9e7hrt0yYsFw95G3zLHCYLZ3+LFNrrRrTwVfBNNnwsTOz0i+k?=
 =?us-ascii?Q?RaQGtwmcB5kwnJ2hAa7ZADbcSHXvJHyOPih1CF7kDw/eM4KeXY8D5YMPAKna?=
 =?us-ascii?Q?jPYWMF2xZqBYFNbin2HgNEJbEZ3UJAE6E0M5HJ+TIuEAW3S3cwn1NX5wl4o8?=
 =?us-ascii?Q?DGMVT9C/HX8pxiNNueLMT7/7fOHeK/kzwb+MIJ/RVXAHD0FFGSwjnNNhHYSq?=
 =?us-ascii?Q?GJmA63znP789qeNSr5K/2kxPyC/hiPLJX9D7Ub3iNzHh4Vw7W1VDoQHUCy4r?=
 =?us-ascii?Q?v6usDmb46Yi5RWoOxA8JUsU6HbLDX6p5yRN0poXKwJZROg0UsTvKi+ArnnxJ?=
 =?us-ascii?Q?jtspCLOmcaCNUbuAAfhV5QhMbU9whCXtPoH/BRu+TUm/80vmmQbUoP+iaRFN?=
 =?us-ascii?Q?lL/QYptz7lYHKC0+aZBMkxDm8pLnZGqm/xRmr9JelQmjpvcHl4S6VhncLvMG?=
 =?us-ascii?Q?ZTP9YwivH5wRIjQHpirZExBHdFwX7ALepyZ7rBpnQEAykM6rGMAdcIbiF02m?=
 =?us-ascii?Q?cgEvXOdoC8cxE6TRINffq3H/YQTSye/xOStMQm0EMxS58tRcd5ctGsQG/7g7?=
 =?us-ascii?Q?o9oslHNVZT8yGvPr4/L/fECyEzl28WjvOf8q1UHNiWJ0NhlLc2IN0c0Df4eS?=
 =?us-ascii?Q?qJoSNYECA20W1C7nIugnNX35MDH+NJVd3TWnABDdokrpsgFAyWTqQryVJ6Ys?=
 =?us-ascii?Q?v5Go4oQG3rvn1j0JHeLcgRSXuS6hksytP26tv+aXFVlTACo2hPMsV9+y3OiC?=
 =?us-ascii?Q?8RVcFUlnO8ZGx8NJHgoHslfm+CdQVSvUzOJEuEs935ftpidlSYBrZuP9t42S?=
 =?us-ascii?Q?ejRhXnrnryIjyvRrD3V+4xPgD+fTjyC4qfNCfhcKZhOrFOMrnQIDHMMPP29+?=
 =?us-ascii?Q?q52h6TMGyxlLEsA2SlBzDUpheuWKtCrM+TF5dgDq3LaMgGwPvBiJ2hfb7kvt?=
 =?us-ascii?Q?4uMk2IsFdyuslbe5rV0Ar8CI8+JkkhSoFnDuqI0OEI7UbzFakeLFONfZxkbX?=
 =?us-ascii?Q?zI0aDCh89BNCX2QP4g1xM8hHoRl0LgiqAbn3SBbKXpq3ejeRUa3xlsSScHXE?=
 =?us-ascii?Q?eCe01kIbB6FFv4hGjqACNGuL+Ohe+urQLGDgbfqE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 82a7145d-0f20-496e-da71-08dd2eb81dbf
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 01:10:46.6500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P0iTwPyV+bKsYJM9X94guR9qQ/jXwhmVMTun3hJpEIPJ1JY3e5Bm6u6OVnLki1Gl5kQqUSLbZ1SnxbPLFzrOtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7763
X-OriginatorOrg: intel.com

Dan Williams wrote:
> Ira Weiny wrote:
> > Per the CXL 3.1 specification software must check the Command Effects
> > Log (CEL) for dynamic capacity command support.
> > 
> > Detect support for the DCD commands while reading the CEL, including:
> > 
> > 	Get DC Config
> > 	Get DC Extent List
> > 	Add DC Response
> > 	Release DC
> > 
> > Based on an original patch by Navneet Singh.
> > 
> > Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > Reviewed-by: Fan Ni <fan.ni@samsung.com>
> > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
> > Reviewed-by: Li Ming <ming.li@zohomail.com>
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>

[snip]

> >  /* Device enabled poison commands */
> >  enum poison_cmd_enabled_bits {
> >  	CXL_POISON_ENABLED_LIST,
> > @@ -461,6 +470,7 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
> >   * @lsa_size: Size of Label Storage Area
> >   *                (CXL 2.0 8.2.9.5.1.1 Identify Memory Device)
> >   * @firmware_version: Firmware version for the memory device.
> > + * @dcd_cmds: List of DCD commands implemented by memory device
> >   * @enabled_cmds: Hardware commands found enabled in CEL.
> >   * @exclusive_cmds: Commands that are kernel-internal only
> >   * @total_bytes: sum of all possible capacities
> > @@ -485,6 +495,7 @@ struct cxl_memdev_state {
> >  	struct cxl_dev_state cxlds;
> >  	size_t lsa_size;
> >  	char firmware_version[0x10];
> > +	DECLARE_BITMAP(dcd_cmds, CXL_DCD_ENABLED_MAX);
> 
> Can you clarify why cxl_memdev_state needs this bitmap?

Nope.  I think you are right that there is no need for partial support.

> In the case of
> 'security' and 'poison' functionality there is a subset of functionality
> that can be enabled if some of the commands are missing. Like poison
> listing is still possible even if poison injection is missing. In the
> case of DCD it is all or nothing.
> 
> In short, I do not think the cxl_memdev_state object needs to track
> anything more than a single "DCD capable" flag, and cxl_walk_cel() can
> check for all commands locally without carrying that bitmap around
> indefinitely.
> 
> Something simple like:
> 
> cxl_walk_cel()
>     for (...) {
>       if (cxl_is_dcd_command()
>         set_bit(opcode & 0xf, &dcd_commands);
>     }
>     if (dcd_commands == 0xf)
>         mds->dcd_enabled = true;
>     else if (dcd_commands)
>         dev_dbg(...)
> 
> ...otherwise it begs the question why the driver would care about
> anything other than "all" dcd commands?

Yea this could be done.

Ira
