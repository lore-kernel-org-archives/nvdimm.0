Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108C215A858
	for <nvdimm@lists.linux.dev>; Tue, 29 Apr 2025 02:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745894309; cv=fail; b=ZeQGuh2/umwQ8Oz+1KLJEskW6e9eiZZtGukeUJHOCObEkeBXHhd6SMUaVdqv7j8aHojY21DXid427buMiraigDkIvH5eh3QQRcwdspyTeXyzPxysFpAbUTRFmKjL016+8Gp9rEFWDI42DQaLL51aPeHlk6eASF8pujq7wfB5o3w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745894309; c=relaxed/simple;
	bh=yYwPgc+Q+hDCS2QM38Rkzoq9nzfMIcpxLJdlE/CAvr4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pFYmZFhov3Vb294jMUdTxOBe7Xy37RJ6ZKi8NU/C9FhqEl6WXOdiJy2HtMU4RrdSh03QEICS0iCoZXWVW6O4O1EuU4QIP5Chtg49JGksSYZv+QyH9KoFKVkZzbzPW6gC/96WkXlvSji2cmbZOr+n6erq/l5/90sEBQ/MWueRiBo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D4hfG2SH; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D4hfG2SH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745894307; x=1777430307;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=yYwPgc+Q+hDCS2QM38Rkzoq9nzfMIcpxLJdlE/CAvr4=;
  b=D4hfG2SH/xpX0QY01oTi1yN0vKfDOjDwPxpdouFt4hUABam+h4A4lwVQ
   tTyWxHArVRU+2dBeOBGzilstQBn4mjVxnK/G8iOGhDlUYPpS4LfYC+wD7
   jXH23uAUPA+cb2hSwfex8ZzfQ+kvXEa2HRMAgPiPGjbWsqlOynV3WOnoD
   3Ehsz1fnZbaJTj3Af6yxRuVSYLUw2Wx+bzie2labrd9XFMdg13z+DdIif
   D5iXPqjvWoS3Q9spH1sV3MjGeIKNEtGsBWAY09nPzZ0axIdT0oFD8ZvMr
   Ij++67/+Y2OjsAZW+htN7IHB6two3UeHKjdfhdDBUNKZt2H5K9T6mgJgY
   g==;
X-CSE-ConnectionGUID: rSLkT9IZQCGhiiu7cW6rjQ==
X-CSE-MsgGUID: VZlIYs0lQ1qyd/BJWR7HMA==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="51318763"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="51318763"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 19:38:20 -0700
X-CSE-ConnectionGUID: Ii57X/R7TJ6PUMTDYVzMjg==
X-CSE-MsgGUID: 97XrcMhPTTW076B72cmC2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="134649628"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 19:35:15 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 28 Apr 2025 19:35:14 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 28 Apr 2025 19:35:14 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 28 Apr 2025 19:35:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bAReYfhV/zTy+JyDdrCPZdBr699vtk40RUWwsBbjFFEUo6xvFsAYLRNWZRrsmDzg0JQqXH11MkRHJkP5vRGSuKJ9PeRBWlIyo+nVewGNWgL042gKo1PKYwFqgC61tPpgRz26xDK3ZmNnXy28jgfzYlTudzLSxpFHkIUekcHZ20bFYZyK1XYfO0BkxX5IpPaJiJM37h7lAc25Yhy37kXq6S0v/KyyCLoc0voA9R3CMzztolTlgkZ1VfKCwUuxuaHY0ORyxnQ5nkhG/P0WjC4UL8Vq41BxL2Gk4lqMVBYfaVxXlwtlciHAm4ABKdLqqNU4VtoiAZU8O55+SZoJeNpI1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jtiZJBsXumla/S5k4x8G267yvmHAnJC0z8D4PuTlnGw=;
 b=XJfuUm2KWgjGUUO7JHS4r7xUmrOYIapNGzKbAK6d8S7oW/haxHH6xJWrlRMJgVCd+2CHZTlQbJBNkDxR/sPduvFt+Uve3poZ7Z1VqUosSszDLM97oSuHKWyAyf+IBRT1+R3bfR1cMzUSTq4o6KUeyhgvl3kao9ubdkPcFu4hB3zv755FlnHDH6n9ZtlY0U2USZKYShpjXJUtBGkcbDwwytViAnQFFqi844BfePwIyR+NDC9wvH68SJ1nhnz3oHZsblKtWAor/kOTS/64FLAf0RaqBCaK6MPmoPVOul9ecp4P5LPcrjecTlGd6JI9DXdENG4q41CfGxmqHulRXl/pxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by LV1PR11MB8842.namprd11.prod.outlook.com (2603:10b6:408:2b3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.27; Tue, 29 Apr
 2025 02:35:12 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 02:35:12 +0000
Date: Mon, 28 Apr 2025 19:35:08 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Cheatham <Benjamin.Cheatham@amd.com>, Junhyeok Im
	<junhyeok.im@samsung.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 0/6] Add error injection support
Message-ID: <aBA63FNkc21vPZ1d@aschofie-mobl2.lan>
References: <20250424212401.14789-1-Benjamin.Cheatham@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250424212401.14789-1-Benjamin.Cheatham@amd.com>
X-ClientProxiedBy: MW2PR2101CA0011.namprd21.prod.outlook.com
 (2603:10b6:302:1::24) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|LV1PR11MB8842:EE_
X-MS-Office365-Filtering-Correlation-Id: 63349741-edc3-453b-8648-08dd86c6775c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Ye8lrtqnfi2JADJWeNDXalWe/avuGOH5w4e4QX26c0tctAx8PjHr3TbrPs4o?=
 =?us-ascii?Q?9IZUu3l8CppOZ/09S2jnnO6o/PHKfsoqKfpjOI+2ZjQ8pUfqazZOOS2I21AC?=
 =?us-ascii?Q?6S3/UYSl9YJnd9Ak7y0QJCXgkTVYPTrnFUYhG6pfhL4Z6NlDwRfVDSSG3LTF?=
 =?us-ascii?Q?9Jy2EMxNU/u10+yYE/gNAxzyNX2Va/GxX6NroXGt6ynVgtHKUvUi0voYJ5Rk?=
 =?us-ascii?Q?0NGyvPvkkSCkLZJ3t/ymfb19+9YP9tTvkSvCktUy8ZfRRdAZcRFsULCGMIDN?=
 =?us-ascii?Q?QuBBA5ukfs/DVVm6NbiWoxg5oUIdguVVxtUZgGT4ikZCEhf1kfkQ5XlrKIgl?=
 =?us-ascii?Q?YV5wC7XRcgiAXDfRiT8TDakQ+iOstFs04skCkHTjl3t7qBRk8516AlGvlDzy?=
 =?us-ascii?Q?yUAqxeczVAGXl89Nze8hiEvLYLiKSquVivvJNNOsEtnQDrwa6Tlt3Jb9UlTm?=
 =?us-ascii?Q?zlHaTpGVzwoD83ShILYaJr6qOSQnbKbuxb/LHgf5kMdpbmUtJuqx578i77re?=
 =?us-ascii?Q?6iBXawZf1UwjMMnyhgCVfG4t33DCvXVpgZWdCFfEKEaZ8kDcUAduqoCgDTlH?=
 =?us-ascii?Q?qU1jZAsZtzwQXlMQ0/8vzeeHtmLOOUwRgxLsv0eKJhe3BV0hGi9mwovCfIjw?=
 =?us-ascii?Q?rzrWWDERfSHlP/vAr0EPxoysYMxPfSvATrrQmHcs2k5LJpm9baKDxskgTCt/?=
 =?us-ascii?Q?i2rxdeFD7acReXTk9nj1Jk6RIDtBBvfe5htzxj5wvj04XOzzlFNWJx3TuFZv?=
 =?us-ascii?Q?1VXbTO0EBsAdQVr4Vg9Fsaa87XX9/eMx+W+jW055qYWKtV5xfiqEPnUYYGvv?=
 =?us-ascii?Q?7ITDmhysZOvcwHIk4dmCrsxgmsy6L1Eu5j5Gf+baWmFsqcziTSElg4enmvE/?=
 =?us-ascii?Q?OEcHTvlZ7+5SGckKksWl6woutLukc4k13S+GwbS423VIbwz2RPG0u0xZICeZ?=
 =?us-ascii?Q?EUQItVfHMkE/BOV7h3aiQthPQKymLtzYbedTLdFM8jrAijnnSEGy2XOCeGzZ?=
 =?us-ascii?Q?LSeG+6YlADgJq0TZtq+HPNdcJiD+K6yLhH4pR5eGLPQob98oVc/LGrn2aa9r?=
 =?us-ascii?Q?CyKwxb4iLrqDWRb9P2zeZK91WXxnN1uM2wjcXVoVqnzBhbFLVW1KPqOJTEyZ?=
 =?us-ascii?Q?i9rgFBNySAZxy5o66aQLl6tzdKdtnMUhlZfAZNEYJtxJW/ifi8DtrcyupPKG?=
 =?us-ascii?Q?Xgc97locfDacNfh0jigHbeQlCVEtKlQST60IYVy/Bwy7FzHPFJ52ytXyXa0C?=
 =?us-ascii?Q?KNALI776MVmZA7iqHXqUeDMZjngJXkpwFOaunv/cq4bpWE/EMuW3lTtTrj3W?=
 =?us-ascii?Q?vAH/mcFAnKYH5j36nQOhd37rIW4YXLrOrf+psqzsZdLsOBmH3tFbUYonVRCt?=
 =?us-ascii?Q?ic+3wqY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+PmifkFuXWC431IOS0SOdEbvRdz9lwtlma6IYjQINoyHZ2sFaG1Rf1jLSf9L?=
 =?us-ascii?Q?aS5iOk5wDBhcoszDvjDmiimq8PMx2v+63i6WZFaltVzmD4Pkzzl/ThdvoZsA?=
 =?us-ascii?Q?j0pFGXAxC+63padNl6FfzMCdCJ3QWTJKQXmm9zJm3ZacpJt5/12Xr2Iiu2cP?=
 =?us-ascii?Q?TY+Aq0K7lIt1FIWySrzh3vOkIkvcuAjwXyycglGQ9Hcz+TH/Ks3DM9XoA2tb?=
 =?us-ascii?Q?hLdbm6q60dUKmUzOFJU4NAMJpW8HNniyZY4ed8t2srJW7AePgNgCr1l+u1/P?=
 =?us-ascii?Q?E/mo5MP6pYmhGxNIqf9+ksVQboed+dVCizu/mXX+EaIXTcMiE8AJvvM520Ng?=
 =?us-ascii?Q?X2znjFEQGc4hG5dYmw4mXJHXJq7BdJH8m5ehUwNqHHGXev9XbrDoU39lHJkH?=
 =?us-ascii?Q?eQO03huRy+LmhypylfyWnz8GRW29oZOaygEgl+GDeTn+Fhv8u1iCohvU7qxL?=
 =?us-ascii?Q?GJ5fFb5Kfve7iErNRTIJtx+nAOPjUywmaI29dnE4mo4f9o4H7cHaKzZTotrE?=
 =?us-ascii?Q?iwNyt06fLQuwSlSRSiGV6AGownlE235e/Z8rEPXaIhFECurciek15cvfZD8q?=
 =?us-ascii?Q?InUM3mCl8dYvnKgyiBISPVlzLwxcwjkZ3LBOvXelNXCWkJJ8VoYLqOZPxENz?=
 =?us-ascii?Q?IVOf36E8tXrtWSTtwJF/80SyicFlCquJ7/Q5MdvQFJ6pdB7hUJuq9hI0eA2g?=
 =?us-ascii?Q?gEmkJVt8lxplDg8tFV9md8POVo5bN0CGBDD+czadPcDzL2qqWfgU/h/0PBsy?=
 =?us-ascii?Q?a0oHXE5jAH6t32fSlePvDNSOh6GE7uXyg72Zb4bri1KsyjBXE+6NcVqLTzkU?=
 =?us-ascii?Q?SOGcvjDJ6IwIZza0DpZ33QbQYx8MQ8gKXBH8btrchi3B80qTdficNUufL0Iw?=
 =?us-ascii?Q?428h6RkFhQE3sTnDT/NtkEs67ZfDi09l+XxVDKLGARmIqvbT7KKqLnP2+ybz?=
 =?us-ascii?Q?I7TZA1LjmkWEXvuF8FQz827FHtKwP+nNbVjKpZv7daq7mdewupkj0j+ZYf25?=
 =?us-ascii?Q?frPdLf5BvyYOfM1IrZ9tfgToHCTP8UrA1bUWISTRocnCXAD96ekhROz7S0lc?=
 =?us-ascii?Q?6Q1SGANh79UO7SuDb6cJmdfoNbDDeon4/Md3xUL5R86s2WPGEKGT6Rs7aE6+?=
 =?us-ascii?Q?oOQIawaONbu+Lca0huM+KIdUr4HULXQ2J4oh+T3lJitkVPx340TRH2JOspXn?=
 =?us-ascii?Q?fBN8tJn5xbiONWnuUTEgODU2XfU67pSaNtPjvwaDpI2kWvqVhHuDcNMFhFSF?=
 =?us-ascii?Q?UBlIiG6OoZzj0Neuqpsryxg+tarYu07jN5J3MJAwOABKjKvDHqZJqngmkfn0?=
 =?us-ascii?Q?TH7c8bHMqUi7+VZlrhpQcps2vwlTViaJ9fti/hXUad154dP4Bnw0tDezcVrR?=
 =?us-ascii?Q?9DBfWZJ8zu8lXtuuQh2DfeBWfbB1VhdFfpb0ghQimVoHBA0y7TRNjTF5vFyB?=
 =?us-ascii?Q?hsKCny0l+/ZxgdyqAvEhD7tZZyn1KcgqqDGlZLwGM6bHKv9sW+Z/Ug1QSWMT?=
 =?us-ascii?Q?/YEuu5axo21k08/BPzfUYKun5cJ7+7r1lIrJiU6vMmXLwUdq/lL7nbc2A5YQ?=
 =?us-ascii?Q?sKDcVSI7ViV/UZBcfDUbX7lIEaCQ0Gduqn+m9cqqpCjQ6FvbCU+vAIIA8woe?=
 =?us-ascii?Q?5Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 63349741-edc3-453b-8648-08dd86c6775c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 02:35:12.5243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p9hhXF2zdSSrPKTMMfHpYYeO1eULWnqu8DGDmpckAZWsc9ZxJJNaBasXT2kAEjtsbc3yidxLlCdTPRmVvf/hy1Yhg9Mwf1EO4qalnmOj1tw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR11MB8842
X-OriginatorOrg: intel.com

On Thu, Apr 24, 2025 at 04:23:55PM -0500, Ben Cheatham wrote:
> This series adds support for injecting CXL protocol (CXL.cache/mem)
> errors[1] into CXL RCH Downstream ports and VH root ports[2] and
> poison into CXL memory devices through the CXL debugfs. Errors are
> injected using a new 'inject-error' command, while errors are reported
> using a new cxl-list "-N"/"--injectable-errors" option.
> 
> The 'inject-error' command and "-N" option of cxl-list both require
> access to the CXL driver's debugfs. Because the debugfs doesn't have a
> required mount point, a "--debugfs" option is added to both cxl-list and
> cxl-inject-error to specify the path to the debugfs if it isn't mounted
> to the usual place (/sys/kernel/debug).
> 
> The documentation for the new cxl-inject-error command shows both usage
> and the possible device/error types, as well as how to retrieve them
> using cxl-list. The documentation for cxl-list has also been updated to
> show the usage of the new injectable errors and debugfs options.
> 
> [1]: ACPI v6.5 spec, section 18.6.4
> [2]: ACPI v6.5 spec, table 18.31

Hi Ben,

Junkyeok Im posted a set for inject & clear poison back in 2023.[1] It
went through one round of review but was a bit ahead of it's time as we
were still working out the presentation of media-errors in the trigger
poison patch set. I'll 'cc them here in case they have interest and can
help review thi set.

How come you're not interested in implementing clear-poison?

[1] https://lore.kernel.org/linux-cxl/20230517032311.19923-1-junhyeok.im@samsung.com/

--Alison



> 
> Ben Cheatham (6):
>   libcxl: Add debugfs path to CXL context
>   libcxl: Add CXL protocol errors
>   libcxl: Add poison injection functions
>   cxl/list: Add debugfs option
>   cxl/list: Add injectable-errors option
>   cxl: Add inject-error command
> 
>  Documentation/cxl/cxl-inject-error.txt | 139 +++++++++++++++
>  Documentation/cxl/cxl-list.txt         |  39 ++++-
>  Documentation/cxl/meson.build          |   1 +
>  cxl/builtin.h                          |   1 +
>  cxl/cxl.c                              |   1 +
>  cxl/filter.h                           |   3 +
>  cxl/inject-error.c                     | 211 +++++++++++++++++++++++
>  cxl/json.c                             |  30 ++++
>  cxl/lib/libcxl.c                       | 225 +++++++++++++++++++++++++
>  cxl/lib/libcxl.sym                     |  13 ++
>  cxl/lib/private.h                      |  14 ++
>  cxl/libcxl.h                           |  17 ++
>  cxl/list.c                             |   9 +
>  cxl/meson.build                        |   1 +
>  util/json.h                            |   1 +
>  15 files changed, 704 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/cxl/cxl-inject-error.txt
>  create mode 100644 cxl/inject-error.c
> 
> -- 
> 2.34.1
> 
