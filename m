Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF5A17736
	for <nvdimm@lists.linux.dev>; Mon, 29 Sep 2025 01:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759109186; cv=fail; b=NdoDviQNRx1TVTn+jN35xO6mDs4ZswELFQHnhgmAe5AdRYZMwv8r4kyLRYMMfdDCS4Z7N4RY1sUZXBvdpRE5F6HvfRNMEzXzShLQ/o0cgpBoPVtkYl8zZAaw4vvL4BZcjxBFwloHxDx96D7prKT6N3XwggEVGSNaKLGSvJFxgNM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759109186; c=relaxed/simple;
	bh=X0UdIsETHUlQDeQKo/QfVh/W5W1m0M+RUPWQqIeB+8M=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ckwRl1pELIJYBzv6iZadbVVNhPBZKn03ZUSpXN5dY9diylBV9/LVSxYuO4rLcwemNCMrOSRYv4imTJy8UumcfGHPi3MYB+CwNPNZwgpkCr1ZY5MlwppP4VOyLCDQfzwXoKTInITymRvnZMR/XnQzMHxNFGEG+4YuZT/I2UFRR+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZQXl/RTE; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZQXl/RTE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759109185; x=1790645185;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=X0UdIsETHUlQDeQKo/QfVh/W5W1m0M+RUPWQqIeB+8M=;
  b=ZQXl/RTEbofBSXKcWObZXt1h+sPPVYa6gkgERdpnbPnJqjmeD6EGbiCg
   q9hvRLwy+wjXuqClgzBY0tsE6fm0mX+Vq20fgFDZ10wsqZi7E0gCyJKEf
   /e0L+cnDMjrHtcFLqi0VxYzxMBKiN4hzVfhM9LkvDFxHuB1TfrhdPd0dh
   Lu+UHClvwQacmLk0CFrp/vmvq6WG0gmwm302U/GdJGUV8zc3T2OcavTT9
   iikzR4t8h3t0lfdgcSr7dLuLuygLsXRzVi6wA+2pDYVbnpW4sg9F+bSIo
   Qvx5sLDb5U0Lffg9SLVZTHguwc6tyC2JUZnCWFCPayMEpcInrUwtfeoUh
   g==;
X-CSE-ConnectionGUID: d0C2qLwdR9KzuoYMDZ+Lvw==
X-CSE-MsgGUID: 1lw8UlyUQJaZ0nVu9FZPAw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="65163505"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="65163505"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2025 18:26:24 -0700
X-CSE-ConnectionGUID: qOrBWdKvTxmZyH5UfGTFCA==
X-CSE-MsgGUID: KivbrUEZSQW6xy1TTQrnYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,300,1751266800"; 
   d="scan'208";a="177699491"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2025 18:26:24 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 28 Sep 2025 18:26:23 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sun, 28 Sep 2025 18:26:23 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.17) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 28 Sep 2025 18:26:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jXmdjJv3NckDsP74mFJnHiuLWk+uyNMAtjQZNFbt4gGl6aSxF3KlEJl5sANx562ypaNVz8axSx+/WQWCBxCxtnYjEOCibo37t47J1nULSNuC/O3kxLj3kIIaNxLm1pjejSOEUowExu9TUgvW9c8TOR+pMB7e+Rw3WgFpSppV8aD+Z2LW1n1PnghCPtk/qfOttv5siKVMPZWL2TTEw2bW8WmGfNkx+3JwC+IriuCJ5R2npO+TyA0aDa9BMn0m6r4jThiI7bzmlPFa1NFz0mtDL7XmFRBDQjKfBoPFCe5W0szE7Y/xqRXE9Cq0CHJ9kPyG2958lEWMJmj26idtKopATw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nsH1X7DmS9OXlUn06wZ+wXmgUpmZ9he6sIrB90joDTM=;
 b=s9DT0S9SeiOgWCtguQFfO3QKdU9seU59f/a4u3RFIVTkcSit5xjPsysteC/INJ1sY386cCI8Zn6MB3yCDsd4zAozp4fXNXHhU2Fix//Kpk1iLFSGGNTd7nOYgbmVCtV2fAIU0mY6JeQa7YXN3ImrE4SfPjDfQwIOFmkdjQvgcEASgqctiCqQ9jLrOUcks/RCLrBkVLvXEDwVtcrWLoPXaaucVNCfH1SUzKU+INGVh67UAoEnk5FI/MV7bp8/w8h9PmM2k4oTbi2rggWyVEPv4ZnJMbkHFUYoeUMfwvQLeOPRV/AW9EVUjBGG3rH8qcxzwnSZojt4cnxGev2DMUqIgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b) by PH0PR11MB4950.namprd11.prod.outlook.com
 (2603:10b6:510:33::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.16; Mon, 29 Sep
 2025 01:26:20 +0000
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde]) by SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde%8]) with mapi id 15.20.9160.008; Mon, 29 Sep 2025
 01:26:20 +0000
Date: Sun, 28 Sep 2025 18:26:13 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
CC: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next] nvdimm: Remove duplicate linux/slab.h header
Message-ID: <aNngNaDpVJAyYKYx@aschofie-mobl2.lan>
References: <20250928013110.1452090-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250928013110.1452090-1-jiapeng.chong@linux.alibaba.com>
X-ClientProxiedBy: SJ2PR07CA0023.namprd07.prod.outlook.com
 (2603:10b6:a03:505::9) To SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF0D43D62C4:EE_|PH0PR11MB4950:EE_
X-MS-Office365-Filtering-Correlation-Id: 73a82a13-94da-455d-0b72-08ddfef731c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?zd+vQ+FMqXPDQvnLkZ4ButICeoWFO7Kj+0T8Wo/QrKYRSDovNB37r+4ou3gu?=
 =?us-ascii?Q?uwrbdk1/b2tzLvWpzHdjIesF06i+7JUQgPePFErWZ8vBu5iTiFLClJEoJD2C?=
 =?us-ascii?Q?ktBdCTE83tvYJMW6nAFSqxJ2rSuSIKUUi9f11hAxQA3GjfIlh8e5hMYdFsqP?=
 =?us-ascii?Q?vcbwSMg59DyFS6XLVIiSYl7BOxdv2v45QcFh2MqMsNQn4uFhegrrW7PvyqQD?=
 =?us-ascii?Q?0STzWNdDJoYMxHspabkWtI9ktsIk8BboV1nk34WbmEajpcgqUjWLLPZ3qf5d?=
 =?us-ascii?Q?nFvv3MB5M3NNcARqBAivwf9m3MZ6D9wj8xXCiDzTMvupwhwR0tfMma8g9mTh?=
 =?us-ascii?Q?mreWJGz+dNrEd+tgKxxJ2sCchNQ/TB78GtfL72mdjH5PYa9dZ+hn6e86QGQU?=
 =?us-ascii?Q?MAoOQcVRXPLnfNkjkawssO//qzaX9WgD+R5tAkmNaW62Ve/00HbMcfXweBV9?=
 =?us-ascii?Q?BYmrq2zmgqdHNbd6W4GJOY5wEILrnCYGDAOQwV0ghLzjKefA2cTLfKmwPa8D?=
 =?us-ascii?Q?NveuVUv2pGq4L5BWqYELx2IcPkEVdNG8hLpKdV3MhXyOnebKJgXF2bNZBuRZ?=
 =?us-ascii?Q?CI8LUPqBwgRPGR6yHjS2sV6U/91YXHohjoHNuU1SsUYVWgI7RMfHGcxgQ96b?=
 =?us-ascii?Q?sUl8W/+9S7fR53UsS86opH996jKfrJNF5jU9zzXdyvnaY61cwgSuBQz5tsiX?=
 =?us-ascii?Q?P44sZH2xOpoC6T+pzyB2IugVIcqw7PSO9Gp2SBm/R6wARunLELhhPZvlqOSV?=
 =?us-ascii?Q?j++4hUcwUna1p6R7Q9E/4njkvdrUax+4PJk6SH44v0X+986iy5YSHoE03pJZ?=
 =?us-ascii?Q?SMvzv0b4JOIASrk8b3m7/Ym1bsUttU71h5djJIpM/o9Ekdb3FzTidgw8SBfE?=
 =?us-ascii?Q?jOZT0WXpsapAPztPCXP3mlaihPxuCzdiQflITLx5sDUn2Vys5MB+y6fYs8kA?=
 =?us-ascii?Q?+cmhOh75lR/S1Wj1gFnZJCZ6eq0p3wWRftp6Z1jAuwitlDjxAJCj7XKgVCbD?=
 =?us-ascii?Q?0X5fQbxJ8RB/QZRB20xbOzRXEB+OjRO4MXVyKqqYX3auStvTbnWzkb3ZtJtE?=
 =?us-ascii?Q?4N1k93rXZc5FvSnW0dR3dL/Ggu8bB4vwxYLAxsED5lAujeuQokK8U6tMaFWV?=
 =?us-ascii?Q?70X8/vl0cD9IujsooijeeZBgPRdTgWHgMyKOgVO12a2XM6x0YCv1bE/tyI9S?=
 =?us-ascii?Q?IrFt6Dfmkn9VUiewlKrYGF2U+sEo0KeLjYiHMejUpotVnwOVDPSY84xE4oyR?=
 =?us-ascii?Q?W3BBvkwpOMk3YDeEWgqVvIISk4RqNK4+OOYlsplsPuWb3oTlLYq730czbXno?=
 =?us-ascii?Q?fvMxwH7mdIaXn4Ph1N45zx/e3UpkQl2dktBE/voPijZa9KB1QbTIgGj+idyy?=
 =?us-ascii?Q?zFhram2xuxMqxtRVKaU5sF9azhz19QIBGJHP7/vEUNsfyzAsnw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF0D43D62C4.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MoQcVtGyyit/uSD4JqoaWqXN6y9cp4l5FBZE+PY82ZEMg4/U7QRb9fGjC2zp?=
 =?us-ascii?Q?qV/GEfc6Hg2hd5KSpqnMM1unYR4uCIkc19pSmJe00NlkMblarQn6P1WUiuhb?=
 =?us-ascii?Q?iOw4xLFGnFEMamo6p4kZsQnea0tfilw6poyAIAJvsnUeOX681/Vy08SrtzSx?=
 =?us-ascii?Q?Z9No4r5bfcfhiiOh/lBQGKl6sCbefzbg8eR0CXbmFhkx0LVJA1HwyepBhe7y?=
 =?us-ascii?Q?jDkYTqBp17bp6QTX9gS+nW0hn+EFNTqepooj1DnRrPqMzb/DvMBVrKz3GzlW?=
 =?us-ascii?Q?ez1ePIVVu1ayiASpLD6NveTIsV9My6f286/1fSG8+cmcrJp8d0CybEMGyrCS?=
 =?us-ascii?Q?7+5z3BLec2yOUNUVdmSQhHH8YQmY20KC4DL+GR1O5WGH9xdoiVrLMYrVe2Qp?=
 =?us-ascii?Q?+bNhnTJUV29o7Nzdfzr1I5JWAb3PxLN2FgOEjp+GZBfnXVHOfxLYz6hB3JIY?=
 =?us-ascii?Q?sv7tVirLzFIzYO8/l2qW+k4OQ473Ch1XzU1I1HNkzOb5CJjKtnnYgBft5FIt?=
 =?us-ascii?Q?8XuTTMC2w4Z6nXdMGgJz5FqHBEp2CLrKiRaE9664s47AUWNeJ85Vs81a4nfz?=
 =?us-ascii?Q?VbuoL9CA/IupyNMo76QwzG9PfvmwX1+Oli0GCtE5t7Ejha8g9Ja4tKM9vyaC?=
 =?us-ascii?Q?/eF66px/iYZnKnbh96rF7AC39/iIOo+tqYNjq7PzvJJpBrE6jDv9TvcGitvq?=
 =?us-ascii?Q?JbFrl10RSCuvMCknq8Jzfv7lWMnldcLLat0DDwAoy3dJJDb+aHwxpWRYWH+f?=
 =?us-ascii?Q?OkKoppvHQ3cOZMHyaYyLQpaqCp5aQ2rsxm9FSm3NN6aLySOlAACX+x1Ul/wa?=
 =?us-ascii?Q?3Nb2Bdu6DhEwUUS0DMdQtlu7i9vFKGPnwS7iKycnBFNC3viXUqys05krK3aB?=
 =?us-ascii?Q?2s998Rfdt8xqbaTns/pfduRfXAjROybddFVtTwCA+Ndmw3o0qiKFwo+q8HtS?=
 =?us-ascii?Q?Xr6ylWoVVmV051Hqhi8rum3oArRmbRbAb5hJ36bUgm/P2sln2+L/dtPgnePX?=
 =?us-ascii?Q?Yi57U/1h8GyOWwfJvb0Yn/WV8RTC/OqsCbqdRCNCUWqrzzlNt7UxtXbzR210?=
 =?us-ascii?Q?i9Pgeka2Ixr3JH23ZJzBlPIuHjZzMZKAZ0bICgQsYHt/M8xRqvE/W0IcVtXy?=
 =?us-ascii?Q?JYmmqIStIupo6RV7SrT9JnwQf0xdn9tXMUnol50Kjb6swn612aWpN0k6XhkJ?=
 =?us-ascii?Q?wDltKuV9EiV3MaRVz41oCqaMWgjLiLrUCEf8wvhADsg3VdhBRgQqyGo8rjUi?=
 =?us-ascii?Q?DqTzcx5c2w4hN4TaT+txksSS9TvhJMx+Cab+4YFPCEX6NbarTiMAt4R3WH0N?=
 =?us-ascii?Q?lLoD8oiY6t/fTCEc3S9TdLTI+5TVeCjR60lMRpTsXFsZcXqqCawHxkZImucx?=
 =?us-ascii?Q?fnbp/ADASoO6eCOojc08VqA7hbGU2hX5mT0Uz96hzZ5DFjjQcDP4PTKqrQnj?=
 =?us-ascii?Q?ajaFwPVBqedm8GW4GR6hCEx6QYpv3JWhuIeEjbV0vrGwasR/fcZvgSPkILY6?=
 =?us-ascii?Q?kfMx/UWgwYKLN4wf3GMAeX/LVOsqPjU8pDFjolGlchUtsRnLQm2lWBfi/0c+?=
 =?us-ascii?Q?ZVWlO5w+zCcdC8KfX7YS8sXZHjk13xucmg0g9ZMVkHDUPPY7N74lAF56Eqbu?=
 =?us-ascii?Q?xA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 73a82a13-94da-455d-0b72-08ddfef731c6
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF0D43D62C4.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2025 01:26:20.5941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JbpVfUdPR6j4bQdoxf0kIqVX81K6jyLUePzzVsqktQEvf6oHiI7vTiYdwm+/kJIMj2LniKjdvo3B1T6Rd/JAxaSQ1Ru/vLhJXSSIDdDXuVo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4950
X-OriginatorOrg: intel.com

On Sun, Sep 28, 2025 at 09:31:10AM +0800, Jiapeng Chong wrote:
> ./drivers/nvdimm/bus.c: linux/slab.h is included more than once.

Hi Jiapeng,

It would have been useful here to note where else slab.h was included,
since it wasn't simply a duplicate #include in bus.c.

I found slab.h is also in #include <linux/fs.h>. Then I found that this
compiles if I remove both of those includes. It would be worthwhile to
check all the includes and send a new tested version of this patch that
does this "Remove needless #include's in bus.c"

BTW - I didn't check all #includes.There may be more beyond slab.h & fs.h.

--Alison

> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=25516
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/nvdimm/bus.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> index ad3a0493f474..87178a53ff9c 100644
> --- a/drivers/nvdimm/bus.c
> +++ b/drivers/nvdimm/bus.c
> @@ -13,7 +13,6 @@
>  #include <linux/async.h>
>  #include <linux/ndctl.h>
>  #include <linux/sched.h>
> -#include <linux/slab.h>
>  #include <linux/cpu.h>
>  #include <linux/fs.h>
>  #include <linux/io.h>
> -- 
> 2.43.5
> 
> 
