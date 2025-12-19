Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEED219A7A
	for <nvdimm@lists.linux.dev>; Fri, 19 Dec 2025 04:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766119144; cv=fail; b=RjvPAA+fnFEZXiQJOLVB4Kzy/gn0ETrAhTE458BcACF8BQqcqDZq+bwOL4ZpGVfNDkcCAR2gfkzaCCy4pHFXo3dTjhehImnoK1hfOC4AmhhPb7oVTJw2LKfCXNEICSW0y/82yfeJq7FXf++NYwq+VtqBCDwMc6ttP7cDDq7MytU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766119144; c=relaxed/simple;
	bh=oTO+27IfELb0nr8CVKRCXBX0i2Cns6EzWxuHRD09Xp4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hNSXyYB95JCtGg31L9YkQx2tdt8eODCJUYDzIOAPWFxuEeVrTrvgEyoTQvXXrpSLte6S7iggh0/jR78r+8wFFCC+r+6ZhsbfRujVoliXRyx/ZwA62Ngg92n8GPsDHaYNLVg5ZUcDfXK84D4grNRLWwhqw84zTEPaaYfQ7632pzE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lVAbpURi; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lVAbpURi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766119143; x=1797655143;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=oTO+27IfELb0nr8CVKRCXBX0i2Cns6EzWxuHRD09Xp4=;
  b=lVAbpURi5wULpCGxIi/BAy7+a9SB7xAxkNHWWQxFuI2GgB2/SzhvyEvs
   cArmpatdhhyvAyW9LZ5kyTO+w8GRp06/2qdxUs5Lr1KbkEtzzDC9zg5ZW
   o5MdITbHMF4tBF1WHiD2K/dUOBvppxNLXxp8GmP/yPZGvkDqyZ2B+3FEN
   VfzP0zA/RGPobQuILmOYxKEwUJhLUSgF1vtWySD0IfFBQ65GMZ0bQ8Gsx
   icrujxAE9diDvPz82ELUQtvMLfVtxjam8+OeiF1zsUBpSm7wstabMsu9o
   qlDXoQZ6cM4ZzdkT8lyP/s+ow2NYcO6rL1y3gooubIeRqyfrvhsKlKX16
   g==;
X-CSE-ConnectionGUID: OtBxrFVETk6YTQL+6DAm/g==
X-CSE-MsgGUID: sCpmfYtzTL6XnPWtwTynug==
X-IronPort-AV: E=McAfee;i="6800,10657,11646"; a="85666658"
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="85666658"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 20:39:03 -0800
X-CSE-ConnectionGUID: 1MIEvPcrTlKl3gpSWf8khQ==
X-CSE-MsgGUID: 9qrghxwxT4SCs2VOymr7QA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="203279297"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 20:39:03 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 18 Dec 2025 20:39:02 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 18 Dec 2025 20:39:02 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.36) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 18 Dec 2025 20:39:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mPMk4GmUh7gvj/X8Hp2oQJS/bA/JKqzyGUr8ztDyAVy2YnfidW1Qkr81f7De/xyRqmcLLLRgxX0ioD9mjZJqDLB5GcJurrO1pgyJu6KmLVHVpDNCy715/ZOcWySGv2DgCDMXhT0WjFniwT3sA1DL3Zfp5XToAcBx0Pp7rfQz18t8lWixUiMbtLExx20PbVL7n/eH3T1K06ehZ9jQsnDzoIubhuejoDtYcJjTlSFnEd1gQZm/imjCoXsHK1Vz9ZyrwvQQIMfd/qWFzDoQdP2vFplxH62KdByDYyZhLUu924AgaYsTd7wG61hh7q89ZwFfRS4BUNXvGV+tX3rCJ6Popw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fgpwt4c90CnjH4jBVWB1hqZ/t3e1fVwoPO8IR+1LUv4=;
 b=fP3J+0yJVJcl+ZfKNIEP8s5xMgS0DH3fE3C3y92gPg0H7IVTRz+W0a31L4gbW27GiGCIMmUiGJCUly1h/jyBFAeJSPWyKqWxANyNrfBgVYQ8bkboaiEc2A6ZhfhnCdmHXK3yAWs5Sojju7aT/pHBWh/fyziXsTvVCgaVecYEiN0yQ8PXH51tAVhQdyOEIgXoYFtu1vyGUnfsje+BTtIigzcBVjM0ozpVXd2jjkp2qCD0I8kalkbKUJ6njFT613lBA0xQPn+j63U3Mwc6+az+8jka7uKfCLdewRVCGnDC3kUftUZ7egJjEvzq8FhT5f+T3G1VvO9srAAGLTCab6RSWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SN7PR11MB8284.namprd11.prod.outlook.com (2603:10b6:806:268::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 04:38:54 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%8]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 04:38:53 +0000
Date: Thu, 18 Dec 2025 20:38:46 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Cheatham <Benjamin.Cheatham@amd.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<dave.jiang@intel.com>
Subject: Re: [PATCH v5 2/7] libcxl: Add CXL protocol errors
Message-ID: <aUTW1pvDvKMRqWPh@aschofie-mobl2.lan>
References: <20251215213630.8983-1-Benjamin.Cheatham@amd.com>
 <20251215213630.8983-3-Benjamin.Cheatham@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251215213630.8983-3-Benjamin.Cheatham@amd.com>
X-ClientProxiedBy: SJ0P220CA0026.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::30) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SN7PR11MB8284:EE_
X-MS-Office365-Filtering-Correlation-Id: 82d661c1-a5f6-4902-57ea-08de3eb8838c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?fOY6/402beJB2pQRW9QVwCWRm2nCNE45OixjuQyx2jtzR5bIkt9Ew1fYS0ku?=
 =?us-ascii?Q?gb/LTHH9H5CdnzMqsPnP2Y8raYHz1o/tU+/g0apyMYCxKI6i8dZbQGaYUMDf?=
 =?us-ascii?Q?44mvB1LmNtn4Suykhkeo4AGxg/Gj4a0nS0PxWp/Q7IckRa5dGupyg3/cVTgT?=
 =?us-ascii?Q?QmL8jpUPv1jK0TgOSeKi0oZwUEd2rQO+5gxK0QUSQ17OymJZZMGaBH2JHfed?=
 =?us-ascii?Q?FVRSrGm/2eOf0jqY8gYblAcoMlfqNdB13VdYWWGZIU1YxolOv8iBbR56apb8?=
 =?us-ascii?Q?Zkd6BF68PJNuChqcOABtEX1UiDpl71dl8VDO2jAbd+UpaSVhE7zfUH6B43Bq?=
 =?us-ascii?Q?Z8ilvUnhTjFnTjk1Jkr3MAQRVLEOGotb4IylC2dP0j7kJVjKN0HHgKRFlVXJ?=
 =?us-ascii?Q?tHGxOatIuCI6j78Nt2B44QvFlYDDE59mcFQBn3xchtpg4ULRFJ53VTyHI2A/?=
 =?us-ascii?Q?FDECwl4F1bUpuM67fn/fIVT3ofvgrp5P1pdbEtpT8DamQf2wDgYirrngIBZW?=
 =?us-ascii?Q?lt9jFH9on/I2a3FDkNikWlHxeY4az11r87DPTR/de8w9MvhoQQW3vEMhzYyy?=
 =?us-ascii?Q?ZRX788CsDsJ2Jh+dEVr5lepayNHs1orflDyYsKKiCoqynYEz2CUNwPhEajdK?=
 =?us-ascii?Q?ovE36uGpk6fai6f0Zx5nB8HKh5uzGGrt3EoRTb0MWaZ3gjYlCzZ/NBtcqj45?=
 =?us-ascii?Q?Pg6JegFJtFFC+P+djIcwQdzvMUmRMNKfpknaperP6QC7nlmm0Kq5GrgF7szq?=
 =?us-ascii?Q?DpiX1PEQB3MQN92Aqkh2aqqTVE7FSCHQkxfJg4xi8AIE/dFKca+LVIbAMNbz?=
 =?us-ascii?Q?yY4/nrkHg7f77Kha5MguSMy3iIVRve4agw0oUUCm/5X9RyzeLCq8l8ItIc08?=
 =?us-ascii?Q?Cj0X6iyQhfgDlnUWYgb1g/laEsmDfISWAf/pJbXU2WA5+3i/ytqxGZmvK3Go?=
 =?us-ascii?Q?wFoH5vnJxT+GIvo8lUCiqnlPD5aQotWEQiwqnD0bFUGE+dH50ynYpfTLmnls?=
 =?us-ascii?Q?A1yKDri3cRTQL0fnCP2InYx4hI1q8gO/OzPO406VQpYAHUdw4uZ9x9wNT38M?=
 =?us-ascii?Q?F/7ARKzkNfFvPhgmq1d6ts/D9TjXOty3SrsSr77tlxC+ITRTWuce8HC+YD7h?=
 =?us-ascii?Q?bw9h+92dxuUaCpNQFVOjzv5kMwBU5Bt+0nomvR7pn6HJlKF7QaYMrNGE0Vm+?=
 =?us-ascii?Q?dBbpMl66nu6YR/xVOi9aCpbd226Z6xDfgBjLM+dgwGmOLDbuIP1ELfGsS6Q+?=
 =?us-ascii?Q?ec98bR98XGvAc1ikpXpw6BIpVMFI2BnFsJuridPQ+Fdm6CSmDfiyIYFzJItH?=
 =?us-ascii?Q?M41JeR63zACQIcKaZJzAlM6prj2UhXLDE2hDLvdKM3okNj5Ssxg+x1lcpi46?=
 =?us-ascii?Q?AkLb1H06s5pZTB0UolY6tIz+c+DfBCFagLSbz24CEFaBLnvzu/Akx3hr3ATp?=
 =?us-ascii?Q?MUY7j266jZr1N/DCnZVInYdFApTsWmob?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qa/enM8kZvDVqB2YF435J8EPuutClBCCDhkgu70HQTNqQNY4fZChsKzHofVp?=
 =?us-ascii?Q?oIUpB9w+LZMNpKJfKCTspIjgr6GGMTf1o7fhVfBQJmuPNraNdzfV/isTPhlU?=
 =?us-ascii?Q?BEn0cr8J1rGbI0bthZ5QVsvct+6NGAbRW2g0mKJQSpkivS6S/HDT8CuIPd0B?=
 =?us-ascii?Q?B6d1Ha5Z30c/HQXBTI1wz7iZ0UhdcGjjIkX768ege2jbuXB11OMPgOctHnDX?=
 =?us-ascii?Q?AaOXZsMJ8+tZ1jcGVYGnzArWn/YnYbiqMrLoAoyvtgVqVIx8hK8IWsZSsDlB?=
 =?us-ascii?Q?k2JgQdrTBRBfCNLRAJY/kaH6edD5ZOsrFrOeY+c0AmEzfqZaBapjm0E7JsIo?=
 =?us-ascii?Q?4pDXtqNn/REWIS/ykEnL1VGkFTV/jzXpV49BYvKaStODIchhXSFCCSv9eAg4?=
 =?us-ascii?Q?wVWPBTKRiIVhoO/PJoik3lMe9v2wmq+rmAS3kBpxNyoSn3KD4Iew3aEw+FtV?=
 =?us-ascii?Q?dfggM8T2VOwVYWLDh3hHyzhSWpCZJxM6yv8lhav7eaGgbSbzDEyuIe8bZFwr?=
 =?us-ascii?Q?K1a/fOJG4DKH5ZrV6aWfWJBNOqZqSi0nOL6AzSu03SYcZQL4xZYjWvdsodD6?=
 =?us-ascii?Q?rXWmDTEuddzXpsda/4TT9H5nLBGgJ0gCjFQ7RD1TQk53FCklJtW0xGLVWr4R?=
 =?us-ascii?Q?KWyG8V04XGUfXkDyspFaSwi++doRk0Qmm3KbFbXOx28uiPS5EPIMLjdAH413?=
 =?us-ascii?Q?E0RNJ4p02IqcYjjyg3o+uM+FkcFydWYDVtujZgKke22X2OQoaTPqLoW4vdTc?=
 =?us-ascii?Q?LCi3bpsafHQPdF1BbRoadd9KzG11sPmwJ7/7VL1w9jHHsW0GIcGYoxe1sjtd?=
 =?us-ascii?Q?NpFOCdZW1cgzxOcqUTvybEEYTJCpcLvfrj3PDg0bV3ZDuIO4XRAaICXhSCvf?=
 =?us-ascii?Q?loVH5Rz8PVIDZCESuXHO6Kn+TXl0gQ/jBKOTjpogv/lc8LwMgvPdR/Ftu3Ek?=
 =?us-ascii?Q?p771vQATJy8CZh8jY5jpMKa0YgdfqzE4Dtdct/bml5T0bq7YivRgiSr6lMCW?=
 =?us-ascii?Q?hl7ANxoWBRYzFpzYeEBC0ZbXYTj8enkebwWdvqSUPRaFYzro6GUon5WJp2bp?=
 =?us-ascii?Q?m7WOvMP7WablrLn63+yaK+6h6X5oZukKC5DeZfvLFZgabExJUCOHTlUZkngx?=
 =?us-ascii?Q?FFRJRuql3edn8XwQLx35QtVJuCkrxDTfDpH8KqoUU9579jYovem+fgB5lf5o?=
 =?us-ascii?Q?DCFR7cZq4oSVTnEmHggwD5aViSWMJ89Or0GKesN3amm9rFP9nsCKI/CNnKHr?=
 =?us-ascii?Q?uqKkcZvsyzKCKCBA8VNL0inby7/iA7gbslJcYPzaSa+P7SNAeH/AS4VxTqcq?=
 =?us-ascii?Q?xN8tykvlR9LxFua5mp7C+PiqRZp1E5VdX9SR9xXmczTbk+8eMdi55mkuyghP?=
 =?us-ascii?Q?Z1Lj72TBUosnWDpRsZ4c01cQXlP6IQQeAGDPRhsw/ncnFlWN6L1vbwLbHmLD?=
 =?us-ascii?Q?PsAMkYvjlHXDq52jf6AUMCEnZhzFOUAWA21wpr3BErj6H1d/oINmmTNK2nO3?=
 =?us-ascii?Q?1IK/QvwLzYaOJ2uVm4lfL45hOZWiUy7Y/wYHZKxXKMDSsi/WjaY1kvv4r5Za?=
 =?us-ascii?Q?L1MsxuGFgh/2L5SR8wdy+tSeyrFD0Hfm0MUaGgzDl6z+Ay7ULu435wpCw6cB?=
 =?us-ascii?Q?pw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 82d661c1-a5f6-4902-57ea-08de3eb8838c
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 04:38:53.8744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qEVz4/+MsTb8vVd8lKI6w3R/svAnX39smsJ6TjBiI3mK9rHli9orh0a74mHDtqXvoKZE2NCtezLgt/BxwV7Na3zg1JyxNP5DagtfqZUfxAk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8284
X-OriginatorOrg: intel.com

On Mon, Dec 15, 2025 at 03:36:25PM -0600, Ben Cheatham wrote:

snip

>  
> +const struct cxl_protocol_error cxl_protocol_errors[] = {
> +	CXL_PROTOCOL_ERROR(12, "cache-correctable"),
> +	CXL_PROTOCOL_ERROR(13, "cache-uncorrectable"),
> +	CXL_PROTOCOL_ERROR(14, "cache-fatal"),
> +	CXL_PROTOCOL_ERROR(15, "mem-correctable"),
> +	CXL_PROTOCOL_ERROR(16, "mem-uncorrectable"),
> +	CXL_PROTOCOL_ERROR(17, "mem-fatal")
> +};

Can the above 'num' fields be the same nums as sysfs emits?
ie. s/12/0x00001000

Then no BIT(X) needed in the look ups and reads as more obvious
mapping from sysfs, where it looks like this:

0x00001000	CXL.cache Protocol Correctable
0x00002000	CXL.cache Protocol Uncorrectable non-fatal
0x00004000	CXL.cache Protocol Uncorrectable fatal
0x00008000	CXL.mem Protocol Correctable
0x00010000	CXL.mem Protocol Uncorrectable non-fatal
0x00020000	CXL.mem Protocol Uncorrectable fatal

A spec reference for those would be useful too.

I notice that the cxl list emit of einj_types reverses the order that
is presented in sysfs. Would be nice to match.


snip
> +
> +CXL_EXPORT int cxl_dport_protocol_error_inject(struct cxl_dport *dport,
> +					       unsigned int error)
> +{
> +	struct cxl_ctx *ctx = dport->port->ctx;
> +	char buf[32] = { 0 };
> +	size_t path_len, len;
> +	char *path;
> +	int rc;
> +
> +	if (!ctx->debugfs)
> +		return -ENOENT;
> +
> +	path_len = strlen(ctx->debugfs) + 100;
> +	path = calloc(path_len, sizeof(char));
> +	if (!path)
> +		return -ENOMEM;
> +
> +	len = snprintf(path, path_len, "%s/cxl/%s/einj_inject", ctx->debugfs,
> +		      cxl_dport_get_devname(dport));
> +	if (len >= path_len) {
> +		err(ctx, "%s: buffer too small\n", cxl_dport_get_devname(dport));
> +		free(path);
> +		return -ENOMEM;
> +	}
> +
> +	rc = access(path, F_OK);
> +	if (rc) {
> +		err(ctx, "failed to access %s: %s\n", path, strerror(errno));
> +		free(path);
> +		return -errno;
> +	}
> +
> +	len = snprintf(buf, sizeof(buf), "0x%lx\n", BIT(error));
> +	if (len >= sizeof(buf)) {
> +		err(ctx, "%s: buffer too small\n", cxl_dport_get_devname(dport));
> +		free(path);
> +		return -ENOMEM;
> +	}
> +
> +	rc = sysfs_write_attr(ctx, path, buf);
> +	if (rc) {
> +		err(ctx, "failed to write %s: %s\n", path, strerror(-rc));
> +		free(path);
> +		return -errno;
> +	}

Coverity scan reports missing free(path) before return.


> +
> +	return 0;
> +}
> +
