Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578B82FD68F
	for <nvdimm@lists.linux.dev>; Thu,  6 Nov 2025 20:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762462660; cv=fail; b=hXHWP8Gnm/HJFhoNN8PTridM3q9A8c5gaAy2Ex3nsMbcWgzCgkMwziYscatBjNR15mAwM1wSIJQInWahqT7yCtSJuFNMQeMX8kLb1lcn5PAbtCcWCG/Mtbn9WPQsjXV7mjhmAQ53+nXMehFv/6Ctz6UzgSwu7Nl3HGqybL0ZorA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762462660; c=relaxed/simple;
	bh=V3hW/LqbI/ynikT6ybLLEQDZzucq2lX+s1W/qyy61Ig=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=K3nF9M6gccdV+55ZV/SXADq9858is0oPObdLzXCe3E4483KHzdrz/eiHhVxIPxrZRHKm8Df6DPd85cFmZUh7GblkOaPs4ZgcZbKusrRu532bBQbPNoGh13ps/mrbchdDfRzZLHYBIiuWua2yAptaYuupwhhJI+k9NvPYYORQSIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kB2EOp+2; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kB2EOp+2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762462658; x=1793998658;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=V3hW/LqbI/ynikT6ybLLEQDZzucq2lX+s1W/qyy61Ig=;
  b=kB2EOp+29R6mXLup6sdEsvjqmuVId5lxQadAXAVTdSdtW06my4DfA/kr
   t18ry88LbL896buzgLKb4bJQkmoSGMem7bHyPVFZ0L38SWtLappvgxX4W
   ORgll6tun4Q+8oApLrBXpth1DFTUiaFObMaiQiYGsjY0fB8p+EjqdLG0I
   sPMSsozKamz6cpMFBCtYvVz8hNhoLOX4rSHZzKiVJlJtsbUBBW9MKAe2r
   M9LhPUCM5836iIYTyWYAl/CaS3khV0Z8B/JjDvHX6KOumCbf+smNUwa6W
   UQ4q2QC9rC0W8VLk7Y2KohW30ezCUSswKQ2KPg+wuFuZcJAqYWgxBTm3y
   Q==;
X-CSE-ConnectionGUID: pcKGt4HPS166OLtv8gs2Uw==
X-CSE-MsgGUID: IsnHt2jrQDaz59BlJ1QEtA==
X-IronPort-AV: E=McAfee;i="6800,10657,11605"; a="64765762"
X-IronPort-AV: E=Sophos;i="6.19,285,1754982000"; 
   d="scan'208";a="64765762"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 12:57:37 -0800
X-CSE-ConnectionGUID: H+ki7b4dQBq6J3t6D5ihgQ==
X-CSE-MsgGUID: dRZMAwRpQ+Cc1Rg3VrACjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,285,1754982000"; 
   d="scan'208";a="225109257"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 12:57:37 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 6 Nov 2025 12:57:36 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 6 Nov 2025 12:57:36 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.54) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 6 Nov 2025 12:57:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nQ5cLCuKKzdt0+HjrZZymK3kxBgw7Xp6cM2iPDG/WSQ4gVxNmMiz4mTs933ktkGR3CYnGyEx8TZE7idaPWdC8qn4QugJOqjWroGuMb0a+eOzEecdF1HBc8FadZuCYA6ZJIFXDqK94LQoJifhP5e4sEad8YWb/k18mAQwY35rGD9Du28DJgYOAx0QpLuYf/0NP2S8pxQprzg1GyQwQl5bJNSrppnTWoTBB4hGe+hsJCrv5fiEtj7TsjPvdd8MUWcDX+XCcvwBhmySG89J7+GpQ7mYhpY6lpJAatYut2M48INlbDxyq7GJZFZnqSqd71wRybM8VloWMOiAQEYw3Rc05w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gJ7Y716Z4cpzI07IU0EWhIb3fGa+r1EA6vgFee8voMM=;
 b=xu7npxLtpa5qR98CkwtmGtvY5P0KUM/OYeePyj6RrLUaOoGWd1e7MLJ04Dd9S2buYmkFuaBMxBazoRyW2ZN1dkOukREOfENmVt43c121AirAYTbTEiePV/4pFfURddr+s6V7vNRvGAhNnx3lqTOZ6lb9VJwh0XNjVqUODpjw9p6vpAqIlY0uo8us9AwPMRBLsa6DQ7TK2T4yA6+mjHkPsO2iE4QN698dAhhB8e0OajZ5TaLUwPVRbW8wwuNlTw8zFjFHNs7WkNAjlio7spvZ+s5w3z/rKCwrfowWxzVW3n1L+0cx662+z7+t+vqI8Sg5Fk00xSAbGRTudoJpF1Bw/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SN7PR11MB7565.namprd11.prod.outlook.com (2603:10b6:806:344::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Thu, 6 Nov
 2025 20:57:34 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%8]) with mapi id 15.20.9298.010; Thu, 6 Nov 2025
 20:57:34 +0000
Date: Thu, 6 Nov 2025 12:57:25 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Ira Weiny <ira.weiny@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH v1 1/1] libnvdimm/labels: Get rid of redundant 'else'
Message-ID: <aQ0LtdyI4XzL1yDs@aschofie-mobl2.lan>
References: <20251105183743.1800500-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251105183743.1800500-1-andriy.shevchenko@linux.intel.com>
X-ClientProxiedBy: SJ0PR13CA0040.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::15) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SN7PR11MB7565:EE_
X-MS-Office365-Filtering-Correlation-Id: e6056b6f-7457-4f76-9d09-08de1d771bf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?rMmt9Lc8LxKHv3NFfGGSxwqP9v9vZd/oBJkzmNRjysGNhI8ZNanDOkfK85xl?=
 =?us-ascii?Q?282pa6S+Zkw9GhvGEqozle9uByhhHBBluMwePbe8CGqCvesnQrc95fiwYlt7?=
 =?us-ascii?Q?TjY0SO/pAF/AEYRy4OdxrE2a95GjbUkof8tkqYd7EHoQ5BnHZPSQROpQr4QY?=
 =?us-ascii?Q?TIIGVJHFBImtyY8Q5m5ebnYYeUzWCAMmvYJSDAaPJU/834FrwoQ96mWq63UB?=
 =?us-ascii?Q?cybXr8nxjkocnTsBUtuuNaqJ1GS1eKQAeM5PNnNJB0+3ka/4u+xPCqvKVgkU?=
 =?us-ascii?Q?SYT8Oz2QfFYuxm2CR37VStRR1EGf9nBzV4ryGrOduNDBlUZOtp7W9RaW5BQi?=
 =?us-ascii?Q?eeWVrMUZL42KY7WP7ev9T/VMNgSxbAo9Fky/G/GJQ0OFU+AU4s6yiP7zeYLN?=
 =?us-ascii?Q?Z9Df3V90neUiQwrmXHSYFEHYkX4vPmFztSJ3i93eHnWUDuO+hvrUICqnvwaG?=
 =?us-ascii?Q?f77vFGKAjsqfq5s9jF/B2TZFXvLxoqgGz0uZETCIG6iTKu2oh3RO1TlgyzEr?=
 =?us-ascii?Q?JVaR+SYFmB1AFv1Z/a+TqDTKRIe8PaozTALxZ0pnBSQgvxmvUkfOtK6K97Sy?=
 =?us-ascii?Q?p+1gAe2B2jaqkvapjrgnXcaKi+d9CnqTIWxmGEnXi8eTFAJyv0JdTPYYDlcs?=
 =?us-ascii?Q?VH5qe+4PsReIhcY7wDfysmmf+zaB9tqhSk8ZRbx1+hvZoJux+ZiOnsvmyGIp?=
 =?us-ascii?Q?OVxOdNXLQ02qSDx0pYTUyUcgYTUF8RZrjLJsdbWwm5McliHzocbVIv8BGwkm?=
 =?us-ascii?Q?VQ/mbHXFgOYeV0MW92dwf+9uYlhO7nXdTJOKbG4dvHj59GFowgQHqa60nLi3?=
 =?us-ascii?Q?hbWDYsAR5vuOKWWG5n7FuXrudRQFjvJGQTGJDNZI5n6TmPzHr9eT1W2Bv1fw?=
 =?us-ascii?Q?0z1T94tqdfbcABNmP+7kCQ/aXCoGHUuM3BwjAezndbWswZiGo/hcXTznOlIm?=
 =?us-ascii?Q?ZJPVdTXXg5Q/8uRmMemXfBEtX/BO8zIO/L8Dm3JPLoLHXwh6U9+e/fn4iTxf?=
 =?us-ascii?Q?uHec8jJGh0GMJGrvw5CNfjoanxw9njH3I12YZlYqAFBY4ZqRlZXKx81GM2bW?=
 =?us-ascii?Q?JhvlvH4/8gqhVsJtPiV4IOvW9mDdv2GAWhX96UoDMn65dymXcD7x2tTLE0hg?=
 =?us-ascii?Q?y+QT/BDUHMhP0jwXGMnWrnmrGUg8hlp3xIgQ/4nf5cVCkuGq+KcEMOm4WMY9?=
 =?us-ascii?Q?+U+CrfvHg5YKHiNTEhmdQSFNtkaruuontuI3iM+ThkU/PV5B3XNKQPIVot5a?=
 =?us-ascii?Q?oBmvRGJsyegi7b3QSjdZEX22MLPpxrHNgrW6Idk7kdYwrOslvHIBb0X6cH72?=
 =?us-ascii?Q?dn6TbMiQuskKpNNgTy3BgeDMvsXB3q0yfXWzOTtQuJjdE9DV2+Z+E3UAPHyp?=
 =?us-ascii?Q?J/gNABcJ/FsVF6I8ZOqFmONIgLmBrtFAVRV2GxU6Bjat60ianTm3ciTB58gw?=
 =?us-ascii?Q?1zldD+pXbQXNJD/ZB7RLQ4eUL/JTZnO6?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RT4IeeOuumvoUnNOe7lF/8rSVyZeVrItxyXwup7xzw9zj3TeK3EhNGSJIgNg?=
 =?us-ascii?Q?NAD9jC+5ojBTsjsVuyyEBBTyD2oe0TyaMNY0d6yU+Rhb/Vkq0NAulJYxwqsJ?=
 =?us-ascii?Q?PDcTz7NkIiVwZtRyHfFHoAckWm+mqUAxtPApENGWZqqtlcLgADi54anE8auD?=
 =?us-ascii?Q?gNm7auvfcZTvkEEOX3VFPf2/eFgmMw+ApR8T4h4w3yHCWCLJAU+Fd4ddxWwy?=
 =?us-ascii?Q?cKABshQi7W7CFsFzztT09+Hn8f7uJxCbo+DKfwDpAwefetkwhZTGTcFKJjPp?=
 =?us-ascii?Q?bK3+n68Xmkx8QSQ7t/urnp17w5QMo/dlfD5cvxBHM3bwR/Hm1FGhP4aog5L3?=
 =?us-ascii?Q?sPPzQ+vnzLkz0nmngd1We6HPj8El//mY37XkC1B5Wi0vY67rZqp3scwWEbtf?=
 =?us-ascii?Q?D8lMjo/+kZ+7DT0fbNzaHd9Mx/4b/uykdw9wXhU9DrOLKwuEBDU4syZRGmX5?=
 =?us-ascii?Q?344CRpfJ6OMnHqFZuNSEx6wywQvGS9oeyQBLHbPbyjMZdW1Hdr8joHn7zeQ4?=
 =?us-ascii?Q?bLoz0R8rDPyJBOf5basg+yWBoyO/wssRlEdAbsYEQ36YG/atyAWeRoY7rkoB?=
 =?us-ascii?Q?b9dDeBJ+ahc7BsYu52VEbziAisirml8aWrZvVsgVm1nle/7dlQeu6GNCeFw+?=
 =?us-ascii?Q?KIWyDUPvVxVmuy8E7u/cDvyEScmuk6xQBNDozzwlFbAqZrlGz4s7LxNvY1qZ?=
 =?us-ascii?Q?iw/jP7j102+J8XQMZO7Qb1kyRVMlic13DzRia3nGqjFfyYRnmjEp2vzlD6k9?=
 =?us-ascii?Q?Kh82jkXFUouzvVQuQZKgKM2BBlktbLD4BE1pQ0i6lfl/KUCaPjwiAYwHi6Cz?=
 =?us-ascii?Q?U/u9XNF6Rv0+0vDieCzwmx3Rk2U4Y8QTQNtyDfz1Ac6gGvU4hn3Y7JLAZjBg?=
 =?us-ascii?Q?iUXpLe9jzO/wk5i7TeE2BKcohxxv6AeJBkSXDd5Ogknh6p4UpGNU6AIu8pjt?=
 =?us-ascii?Q?K6U2+0zJv95rRCGI6WGPohPwfcijZS9SAiCkmuXeBWQ02mXOsBYC/Id/skvI?=
 =?us-ascii?Q?wbwAn1doF4an8RcQhNH/3hOj1FCLEnFtwktzetCR5WixqN0wdri7VakIo3tJ?=
 =?us-ascii?Q?r3/rYObSBXhpnTmvoHXwm52EU17Ng0a1KgewZc/q+02M51/hEuod4eQqGCuC?=
 =?us-ascii?Q?BtdO6dYd+y9Qvd2r0oVpOzOob+skrFVsQArTYEoPVb3xizTuHudIAe2SKbig?=
 =?us-ascii?Q?h9oDRwTdXNZ/xajPEfbiDoYwZXaNxN1uBkImENDMNcaR8D822bpM69nsv3YI?=
 =?us-ascii?Q?NRyawhHpXS8gzd7kMXHSfHBXeEMUn9s3Ruow7nHmqJVc7vry9gh14uJQ6QJQ?=
 =?us-ascii?Q?kxFSGdxMI/GNIxx5uzTj+2YC964DYAZu9K8+9fU9QqbQjsiNUlK1xbAvPEc3?=
 =?us-ascii?Q?txZR7/wKVXX8ytz6EIwRWd2aBbbpRCNxfffLQGLbonlqodciPHqLV89efzwc?=
 =?us-ascii?Q?u4n5yAifZnzzN+Tal9amlJwDLvdp4GANHACTkmT0YMST9thiMyhNQPy9b9d4?=
 =?us-ascii?Q?TXaThqEPkcw2ylKnNKw0PanI8+Yq14/3xpzZzdo7LO6fIlnPC5G+G2ns7n2S?=
 =?us-ascii?Q?wh8htyqDzTkEjpyiGmg5IglMO1WymKbsaWyJ6+w6H//hoyzHHZ9fojYPkJG7?=
 =?us-ascii?Q?eA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e6056b6f-7457-4f76-9d09-08de1d771bf6
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 20:57:34.2354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EiJMpAeSEmovFXdMx5aLLYHaqE90YNnTKABfBU2PVNJuFw7c2F8z4M5Jof9PeWz06lLk2UM7yoNnwpAVezLxxU0lWBPJqo+2eUUHQ/Hn1fo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7565
X-OriginatorOrg: intel.com

On Wed, Nov 05, 2025 at 07:37:43PM +0100, Andy Shevchenko wrote:
> In the snippets like the following
> 
> 	if (...)
> 		return / goto / break / continue ...;
> 	else
> 		...
> 
> the 'else' is redundant. Get rid of it.

The commit msg doesn't explain why the functional change in this
checkpatch cleanup is OK?

It looks like both to_abstraction_guid() and to_abstraction_uuid()
change the behavior for invalid or unexpected enum values. They use
to return &guid_null or &uuid_null, and with this patch they now
return target. That seems to remove our protection against future
enum values or corrupted enum val.


> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/nvdimm/label.c | 60 ++++++++++++++++++++----------------------
>  1 file changed, 29 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 04f4a049599a..b129f3a55a70 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c

snip to the abstraction funcs

> @@ -768,20 +768,20 @@ static const guid_t *to_abstraction_guid(enum nvdimm_claim_class claim_class,
>  {
>  	if (claim_class == NVDIMM_CCLASS_BTT)
>  		return &nvdimm_btt_guid;
> -	else if (claim_class == NVDIMM_CCLASS_BTT2)
> +	if (claim_class == NVDIMM_CCLASS_BTT2)
>  		return &nvdimm_btt2_guid;
> -	else if (claim_class == NVDIMM_CCLASS_PFN)
> +	if (claim_class == NVDIMM_CCLASS_PFN)
>  		return &nvdimm_pfn_guid;
> -	else if (claim_class == NVDIMM_CCLASS_DAX)
> +	if (claim_class == NVDIMM_CCLASS_DAX)
>  		return &nvdimm_dax_guid;
> -	else if (claim_class == NVDIMM_CCLASS_UNKNOWN) {
> -		/*
> -		 * If we're modifying a namespace for which we don't
> -		 * know the claim_class, don't touch the existing guid.
> -		 */
> -		return target;
> -	} else
> +	if (claim_class == NVDIMM_CCLASS_NONE)
>  		return &guid_null;
> +
> +	/*
> +	 * If we're modifying a namespace for which we don't
> +	 * know the claim_class, don't touch the existing guid.
> +	 */
> +	return target;
>  }
>  
>  /* CXL labels store UUIDs instead of GUIDs for the same data */
> @@ -790,20 +790,20 @@ static const uuid_t *to_abstraction_uuid(enum nvdimm_claim_class claim_class,
>  {
>  	if (claim_class == NVDIMM_CCLASS_BTT)
>  		return &nvdimm_btt_uuid;
> -	else if (claim_class == NVDIMM_CCLASS_BTT2)
> +	if (claim_class == NVDIMM_CCLASS_BTT2)
>  		return &nvdimm_btt2_uuid;
> -	else if (claim_class == NVDIMM_CCLASS_PFN)
> +	if (claim_class == NVDIMM_CCLASS_PFN)
>  		return &nvdimm_pfn_uuid;
> -	else if (claim_class == NVDIMM_CCLASS_DAX)
> +	if (claim_class == NVDIMM_CCLASS_DAX)
>  		return &nvdimm_dax_uuid;
> -	else if (claim_class == NVDIMM_CCLASS_UNKNOWN) {
> -		/*
> -		 * If we're modifying a namespace for which we don't
> -		 * know the claim_class, don't touch the existing uuid.
> -		 */
> -		return target;
> -	} else
> +	if (claim_class == NVDIMM_CCLASS_NONE)
>  		return &uuid_null;
> +
> +	/*
> +	 * If we're modifying a namespace for which we don't
> +	 * know the claim_class, don't touch the existing uuid.
> +	 */
> +	return target;
>  }
>  
> 
