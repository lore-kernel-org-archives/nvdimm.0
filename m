Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988459465
	for <nvdimm@lists.linux.dev>; Wed, 17 Jan 2024 00:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.55.52.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705450612; cv=fail; b=MheqRcqyrt4FDJU2XSh7lCQXJnzWZ0QnXhKDVlBtIHF+aNNW1pdiiVcE2DB0xPvngD5nV+eynD65KybxBZT5PoeFMP0Qyy0ovbv08n1uwrHK109t/PUepHaGNbD7DovG3/IVQdpGZEztum5oDeIzpTuKVpnkLh7XrS+FP+Qd6tI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705450612; c=relaxed/simple;
	bh=anB3FMqtyfArjyLzFWDjrKDnYpTgp9dHNUZX6zASrOQ=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:Received:Received:Received:Received:Received:
	 ARC-Message-Signature:ARC-Authentication-Results:Received:Received:
	 Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	b=k5bM9UgsiQQ1ZBHA5EnK8z/NveuAXFM+Glvy+pWoe1cxEBA2mo3xxNQUByn2UAs2j3mBevVS4929ny3tCMAo6aW6aFjExzNK9dbxEQaQ+i+1d1OgPqjGp75mmptRdhpO2WLrYRsKpnKu2ew0wIXNeKS76CYza6qVMvDMyDH90LE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cKEkXR4R; arc=fail smtp.client-ip=192.55.52.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cKEkXR4R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705450610; x=1736986610;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=anB3FMqtyfArjyLzFWDjrKDnYpTgp9dHNUZX6zASrOQ=;
  b=cKEkXR4RESZkm2aLzqIceJROzCKji0FLIyhmNT0qOHvBQSoZQUeXq5Lf
   FxoCLyWarcL31HLj557wS+UM3vvQSQCJQ+9+AGMQxsVSIDUeR7SiFDEF6
   dEFXpwRgbn2pcz6CKmt3JYjEIzkG5kgtEP3bXKzoOBRIKgXbGWp0BlQQK
   QTa7F6cjR+yL5GOOb1375GjAn9gYn/ZKtKmTvQOdx/gyzUCxZdezxBCbm
   nWzRATl885NgPxCN/KQWUHHqZtLGk1nd72SxkTzeFbGLHOw393RdV2f6F
   x+m94YMjx5uZsCAt/9Sk/pGZkGWrljSf0gvmi4rHuokxR8isRYSjPNvT6
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="431187841"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="431187841"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 16:16:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="26296185"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Jan 2024 16:16:50 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Jan 2024 16:16:49 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Jan 2024 16:16:48 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Jan 2024 16:16:48 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Jan 2024 16:16:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YC7LcK6faK7c0U1GnaF3S2lc+vquI/0Jn2lN20IuEj1q0q2zm8Jxc8xScYObH3JoC9d6VfhijegAC7OUT2enHwz6dAb7pT2Ps8Dq8jWmv0AvxioKRN858q6syeqnq6jnAm//jhJUoZkA/9ddL68wcb7mxg2JXvBMKIsf4MJ4l2h7gf50GZUB8WfbSnWWsQ2evzafbH3YAp5hcz2ikoABc7wnI5y9tmtpdu1Ntz23hT+aaFqNALjuCZhW1DDh8O7ccyX4tPd2Hh0F2x+hyO8TSkAKOkFrR+X/IMWYPtGjY64QnlVsePjt9qBj/+3kFaxxrLEgQrdz0xoPMi3ab20Z+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rc1PKzb4wwEKP0qn1ar8eqMKTDoSxMJsa3hi0cB9enU=;
 b=F7dLSy4ruL8Z6jSWeCaVc1W5TN1ZC/01c+t8GrCS+kpiJio17pOkU+2QHS3TeXeeexgQAPPOtc1xl9ppzjvl0KYTJZzazUrQbPWj1sSvC/bYdXSSLWG1gVLR63pdT+HKx4V9MjtUi3oyrbee1qUJc0V1kOuTqIrTONVJINP2opDKU5l5nCaJQA/J80BiyMQwdqMB57XEfbLP00+ON3VW00vd888+q7rLN+ZwHO2Ji8PcUmM5SmoRCXKaXWRCLFIcteW9L5S7mmQrbCJqq4ZjU7jBbBOwy0fx3aqLw5Fk71+fe9YAAxv3k3wo3+h6CG31ovOiFza8M5WOfxRDS13WMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH0PR11MB5112.namprd11.prod.outlook.com (2603:10b6:510:3b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.19; Wed, 17 Jan
 2024 00:16:46 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6257:f90:c7dd:f0b2]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6257:f90:c7dd:f0b2%4]) with mapi id 15.20.7181.015; Wed, 17 Jan 2024
 00:16:46 +0000
Date: Tue, 16 Jan 2024 16:16:44 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Xiao Yang <yangx.jy@fujitsu.com>, <vishal.l.verma@intel.com>,
	<nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, Xiao Yang <yangx.jy@fujitsu.com>
Subject: RE: [NDCTL PATCH 1/2] daxctl: Don't check param.no_movable when
 param.no_online is set
Message-ID: <65a71c6c63120_3b8e2945c@dwillia2-xfh.jf.intel.com.notmuch>
References: <20230810053958.14992-1-yangx.jy@fujitsu.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230810053958.14992-1-yangx.jy@fujitsu.com>
X-ClientProxiedBy: MW4PR04CA0124.namprd04.prod.outlook.com
 (2603:10b6:303:84::9) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH0PR11MB5112:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c0b1e49-20d0-4e89-4a41-08dc16f19773
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B+og4Hi+fsj7H8bDMOfSL2tfF2KtQVZO7MIELRarortsW93/xirgLYJ1/6/xJjwKzIOlYeFSWWJkMO0oKhVcdWDnVnl6F88CPEnLfKyZ+3KxPwt7nL4Mz2fB/2iFxJVnb9uRsKrNiDlaefDkMvClKr4Y1FrNYB3uFCvYX/C+2GdxRi26hI9qQ6xnmOxOeAtKneXRuE61HztBJpgtdPf9jPLx9oNydREstl2xWEipOGXx5AMNEwKsDSm/M4HdKv0g34L3MmDhBZViVsvsv34p1Mv1Qiif19s3TVRi8HfWA0e9yGsJDWXMzyZ7zfRYujeKCci6WbmsM8KdfrXOOF8nNTQQOAoNVHaKnhcBiMxlA+UtZZQ+rHIHWwPovJtVat36kAeIgT86eASgXMfzvC9Vzfr1BIefWqFDn1640ZVmrBnrWY1QoKkxxfYHnHyFVE7HuES0NzCmG92jyZlYRbLp9z/4npEwbBUykNFuTXkAM8+uGUj/oU5eoTfllj8a5sZsvUxILXdiYRXYTX3i9e3WJZExew9lJX7bW7GTAUWAUuG0deYFCkLu0Yl7VhFik/RO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(396003)(136003)(366004)(376002)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(66556008)(6486002)(478600001)(9686003)(6506007)(26005)(2906002)(5660300002)(66476007)(316002)(8936002)(66946007)(8676002)(4326008)(82960400001)(6512007)(38100700002)(86362001)(83380400001)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CC2aWVfpWio8EhBlnynM8nEF+ZtyhB/imyPXDmB6NN7k7va5Rw6T1mIbKMgE?=
 =?us-ascii?Q?iNYBOZQIn1DhoRpBegNyD8Q4OevRGl/Lz92QXxmHSd22Sr+UaZGttlo4iFTi?=
 =?us-ascii?Q?Xmr0izzyXuUTLZT+P0KsPFA+t2Xrot4hkKZlfB0EW2i2Wrjt8pxq6hjRNqRP?=
 =?us-ascii?Q?twyYTddyfujYGxhqj93iQS+QuHLcnsEwjhi3DELR0k2Nke6Na0nWTXvHp0bK?=
 =?us-ascii?Q?vrm8wpshQlJokC3YkW820m0H2KiKbrw5SBs5UDwpVeW8HE8H4kAwqvnzWnKj?=
 =?us-ascii?Q?kWe1LC8QMeml4DaqQjvWHq1TQJixNxJNZyVYZEzOJjhhI5SOlqJdvZ061pVE?=
 =?us-ascii?Q?s6aXexniT7Q1nk43T/8314DlFb7DrTWifnrzl5xbDKtGUT380IXBj6LSNLw0?=
 =?us-ascii?Q?1gwDvFMe+zGKUquOyhT32aYHDa8oq/NgLTlG0f+04l/R7Gvvy3/wRc/YvCYX?=
 =?us-ascii?Q?NsegJ5O27erYbrIDbQ28b4fzpV5Esa70i+1NGMbAsZCXTNnmWXsIgNOrOqoj?=
 =?us-ascii?Q?Az8Ng5npv8fnngtz/uMaOUcF6ewwKo15MSVGWVA4YnIhJZApTSAemxxb0A3X?=
 =?us-ascii?Q?KSEs45s3kwNr8oEbm8qMBNllrUKxi23g666QNSCaza67boHuxv8+CuH4l/C1?=
 =?us-ascii?Q?xEgxHU7ms8Gtnj3NFrWFjCm9NyjDMjw+El9fC7lJR5sFlKY6AIPIKcx2a6IM?=
 =?us-ascii?Q?XWv5AWbjKxlFeDUfpjIxmbAVZVo36b1XJ6UUl4m4sYsAdUDybS2kRryA5KEA?=
 =?us-ascii?Q?zyOgb4qxzIChMPYcxNNBeV7q35sGvKZVQ6QSGJgjfODk+OJeqIQSxXju4Mnc?=
 =?us-ascii?Q?FPMACDBq1QfpVJtRQsipEavX5fTXHvlXutPwf8gHqNFsLnmGgP/7A39JoCxr?=
 =?us-ascii?Q?9DhGNCFimX2Ud5sByuUtPTuwpBob9bf3rg97TsqMIMGuMp+FqzmTRvSPO5ww?=
 =?us-ascii?Q?zyOgQz8KM78oLjGNfs0OKmDjxNbyK2d8kZslb22L3v6oibUxwxo4mi/yugeM?=
 =?us-ascii?Q?5zLvF3AyQwlMRMu3Vd31P2Sz7/RRn+wq52be2cBNcxrYQ0FScVOrZR14zyFt?=
 =?us-ascii?Q?4o7C3O59SIjchOSGqgBuF1Ht75nZFwsqkNv1KhpulHdGlogIlIFfsnAFPefO?=
 =?us-ascii?Q?sxsPz1DD6g+XJS5UpxHK3CkHRkzwNu/BchLqB6XHVhbuVja6XKnsfjSXJLTo?=
 =?us-ascii?Q?vS8o1uKHbbLNZ16AUr6rSWZnEw/8tpVbbMfFSO3EiT9DA5EQyChX5v9y+N57?=
 =?us-ascii?Q?hY0Q85YRs9/OCL1SBEb4pHCnf1s16vzUH3JMfjFNyNwnXW2n4shr8mgJp2nB?=
 =?us-ascii?Q?lt4o545GSIFTOvJV+R2BvjxegTKuF8S0wY1zMwjDdhepvYgcKE4G4qYDANgw?=
 =?us-ascii?Q?TOGu0SNg1Yv/zTk177dhgwXH/6Ep+jQ3i3kVwlyWbjqJS5bwFyhqFG44R0Wt?=
 =?us-ascii?Q?nVT445T/MySyLFRhgAXVHuCTftHkX/8qRtfeoMpR/WikbX05kSHlQOpCj/Gk?=
 =?us-ascii?Q?s9XALKLXa1xfZi4pRQXxj5YksWYXV1MYjug8v6lbuUMPHNgY3Gs6DVf0qXQT?=
 =?us-ascii?Q?MYK8FKV19Qc7BzC7WKd1LSaDjVeezTVE2P52zRCiDYsCsU/W9hvhJvco5aqI?=
 =?us-ascii?Q?zw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c0b1e49-20d0-4e89-4a41-08dc16f19773
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2024 00:16:46.5368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 91EwTfvhQ7qfMXqHdKDby7Yi+XzwS9+QJV5MBPiQdxqu/NXyYrA8GzlcVqWk5FsZLYy5r1ItuL7wti7764RYtIO3kYPgiAxmfEMMCa9IcdI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5112
X-OriginatorOrg: intel.com

Hey, apologies for the delay here, and appreciate the pings.

Xiao Yang wrote:
> param.no_movable is used to online memory in ZONE_NORMAL but
> param.no_online is used to not online memory. So it's unnecessary
> to check param.no_movable when param.no_online is set.
> 
> Signed-off-by: Xiao Yang <yangx.jy@fujitsu.com>
> ---
>  daxctl/device.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/daxctl/device.c b/daxctl/device.c
> index 360ae8b..ba31eb6 100644
> --- a/daxctl/device.c
> +++ b/daxctl/device.c
> @@ -711,7 +711,7 @@ static int reconfig_mode_system_ram(struct daxctl_dev *dev)
>  	const char *devname = daxctl_dev_get_devname(dev);
>  	int rc, skip_enable = 0;
>  
> -	if (param.no_online || !param.no_movable) {
> +	if (param.no_online) {

I agree that if daxctl is not going to online the memory then it does
not matter what no_movable is set to. However, part of what is happening
here is to communicate when daxctl options collide with kernel policy.

I.e. consider the case where no_movable is set and the kernel policy is
set to online_movable, then daxctl should communicate:

"error: kernel policy will auto-online memory, aborting"

Maybe the fix here is to split the no-online vs "online or
online_movable" kernel policy, and the no-movable vs "online_movable"
kernel policy.
