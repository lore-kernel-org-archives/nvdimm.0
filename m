Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A4C2BEC52;
	Thu,  8 Oct 2026 01:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791421380; cv=fail; b=SAsCJGeHqtoIC/iSBjx1mTzBpaHJtE3Ltzn70kL+Uii3uEkcws/acD6sFwS/yT8cebMu6NiMCtvrvzoR1blMaYJEBbDZKl4Vatj4bQ4+vzHk6vq8R/9eTp+YkiXR4YDAkU1MUZvfjDOntLt9vGTb7o1Qu9n4WOOKtozeXYmMmN0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791421380; c=relaxed/simple;
	bh=asj8SWNmeFIrmxYrq9h8JPHF4uZCCUs+Eka5tYTkrSU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=D/1jF72aSD8bonhypZrk08Vo7bUQvLdiEARz7FChk10gM9aBt5GqIGAJtTnbM222RmBZITHBmqdzlzWMmQz4i8Ec/bUv/Ilm97KzIW97FKMSTm4B1CL5VdGyQlnePs+6OESvgOrTnt+13GnzedFfuYM4ClIL8JMQ2DZhp5auJrc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Enw6GI2/; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Enw6GI2/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791421376; x=1822957376;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=asj8SWNmeFIrmxYrq9h8JPHF4uZCCUs+Eka5tYTkrSU=;
  b=Enw6GI2/pQvPXk9ANcHWrjRK/bh7VdgZXuZFZLxGmEDdgIlJpBrzL4pJ
   34hzj5pvZ4RbgNdI1Ol82pJUoZopPDfYKrMN0++bs+jXh1aMUpUHoAw/q
   8oM4FpTzujNl3NYdVguE5e8EiRdq7IpEYy1Ysw2c9iTIcEQJlwzJfmsOR
   lwu01loidAXfybNHdxGDSwb7AVPWn6FccmXPumWK4n+xeAOthY4/c74L8
   SN0GrKo6xP5lCSnsn3jV62jRdQ8Wt99UFBDgSUKEmvqQp6cL8L10HeF8k
   No5aGzxkq9BZqgx80HQQtcW2X4QVr+cCyM7OLAy8lZOX6PO7lCuvqAgG9
   Q==;
X-CSE-ConnectionGUID: DTgdTD95TLmBarEBV1ABVg==
X-CSE-MsgGUID: yisXbNAuQ2Smjsq0MTE/qQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11928"; a="189422"
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="189422"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 18:02:45 -0700
X-CSE-ConnectionGUID: IAzJ/LAmR2esxcX2uS754g==
X-CSE-MsgGUID: ytjRqTFQQUmJQRkbr0rMvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="213172"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 18:02:44 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 18:02:44 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 7 Oct 2026 18:02:44 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.15)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 18:02:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YaIvtEvj9GElNfDGqRX1nBZrEMW5ZTJhOFxFP6cD5Fdy15Yw52DVyd0qfMLlwW1HgZgCF8Q+TlCxuajVbLjdA9M2UAFAFVCFDEBieCV3wWE0pyaQrDHc3AGfhBeY18njryYsH+sZQO48x2TyfTwFaCdUY1Xdj/6U2EjoeikszmkOXg7YUzUVzELT6pp7Bj7MtRlxWZZ88wNn8rNJU+wiTc2rqoqzQkrrx6RETO4mMBOlFzNOU7W5hRySV97vXgJGPdmiL5hXleXSJCDXxxMmbYkcF+cD/khqQMYZIuDIl6ypWn1y9m1FvJwxpodJkz57suUkYmnBX28L4On3x+/x8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rsz/Ahc+WbOBYMDM3dnFP9lakVm+YBO7v8bpEsID1WI=;
 b=evkQqsXF0P4l66W5Ae6KSvL6e/ww2rirodG2lssBfzRukgkDGTM88tGoSjqP+Qhp14oDBfAZeA5esl7Akgs8eYvJ7eHV8xlXQ++CvBEL0zr/HP8TPltepYmbJ2gbT5zoOynGTpzRuHAnUmk/FVKriaugz5jaEFt9stKSEI+k7cASMvxJAqOK3L47cqMhej4cJ7eV5KgapN5Sa052FCBXddGMmcQ+GKDnFyMB1fOB8kxE+ApMK+sVWM25OMD4iOs1sGhpx7GsgY0ZBo/yPYYf3fbWlHCQgnGuApfH4N9ju8JI8IW1U4sjNO1k5eyf2969yA0ZfEQZSgUURL91GapKdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB8891.namprd11.prod.outlook.com (2603:10b6:208:56d::20)
 by SA3PR11MB629882.namprd11.prod.outlook.com (2603:10b6:806:58b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Thu, 8 Oct
 2026 01:02:42 +0000
Received: from IA4PR11MB8891.namprd11.prod.outlook.com
 ([fe80::1128:c90e:54:e8f1]) by IA4PR11MB8891.namprd11.prod.outlook.com
 ([fe80::1128:c90e:54:e8f1%4]) with mapi id 15.21.0496.015; Thu, 8 Oct 2026
 01:02:42 +0000
Date: Wed, 7 Oct 2026 18:02:38 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Miklos Szeredi <mszeredi@redhat.com>
CC: <fuse-devel@lists.linux.dev>, John Groves <john@groves.net>, "Amir
 Goldstein" <amir73il@gmail.com>, "Darrick J . Wong" <djwong@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	<nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [PATCH v3 2/9] dax: use READ_ONCE() in dax_holder()
Message-ID: <asbrrhh0BrBDDOkj@aschofie-mobl2.lan>
References: <20261006180115.1425232-1-mszeredi@redhat.com>
 <20261006180115.1425232-3-mszeredi@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261006180115.1425232-3-mszeredi@redhat.com>
X-ClientProxiedBy: BY1P220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::11) To IA4PR11MB8891.namprd11.prod.outlook.com
 (2603:10b6:208:56d::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB8891:EE_|SA3PR11MB629882:EE_
X-MS-Office365-Filtering-Correlation-Id: 585c68c3-cf08-4cf7-b9a0-08df24d7dadd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|18002099003|22082099003|10067099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info: 8NH4zYXurOOfkHOjtuueA2TtZjLrbxG/wHiToh7Amvc+ZZC+WUlX5V5TdDsld28z8jEcwnE4bcxYdXmajmciLjGqZHZaiBzAUl/70YAtz7p3re2eJROwhY2hTcmiUMw/a6KtdGXjie+iH5n1J1L1g3HbCCcfOSwMwBFUoS1HevU4dvPGiTTppgzlSKUUQhQqvhxBGiDwYzdFzSmBL1Vz6nI4XY2hEFZTaImqswUY4Z+Vf4rAkO9HONQCUsUzup8ONhI8bxPal+JEyExhjb7v629SsQeENx7ELp0Fpq6v2HI+3dY9ediieW5IVIeqD7xYmDNNJQKi1XER3uLBUnkaMRlmVYWPu+UuiZ85Y3u0trZ3ZwhAsY/6xeLMIwmTdAeVy43xIlSOTxFg+e5dqJCZ6SAzNpY3YqXOS/RlS9iRK+oDe9TcAgsu76oh+nKtRYQnYDncuNfzsVuCy8Hlvmt76kMA6rjPP22zMDNmsy6JgpKhd0ekQwkNve3XK1AFjTqPzlD845C6GqugbuVZf+c8PMcDBr3nB0BrRv60Q6chUUpVIqdHbnqV+iXD6aOOpgiOikrUJhEPf3m9twjrLLLUr6SJnECfiFhX4xD4hElBrNqdvf2d8szGqqXjGmjCeq5L0zr2718VJEK2xEx70yj6D57kJ2j1UT4W7OzC42zqCYA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB8891.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(18002099003)(22082099003)(10067099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5Q+NIh4qUDO73DwPle1kK4c+7upUFx4T0RPHUmWxrMnPd27YLMajOn4voYsx?=
 =?us-ascii?Q?VSRDsGTvTIs11lSlxmZYR0+LUZj+kv7gFqAOLEdY/Rka8f7Ofrh+Qd0OfIVD?=
 =?us-ascii?Q?/gp+dKWjOLRDgHtohrRMk/TP5+FQYGVC7NysIhrjiIJ5YFhv5kyMoWBX4oZX?=
 =?us-ascii?Q?Lrm8dzj808TCOyI3obLjYzqsTs3iOVStRjGFwE2u/jAruJdLIoQSWEAMsaL5?=
 =?us-ascii?Q?ytEta1Jm3LoD4W9u7ruHmK7+RWmf2gp9h60HN64yHimOodQjDy+59/jYIs/1?=
 =?us-ascii?Q?GyrZ3+vo5C7XA88yA85h+H3gVXF4r602n/LR5XOVFy4qMSPBiCDGpiO6L++Q?=
 =?us-ascii?Q?WElYk8M7RQn4ESyvJkvdAnG7e8BBmCm7hlF5cbEoyHqh873aObAPQkpBnXEM?=
 =?us-ascii?Q?ssSWpf0k0CnoEYJ1t09979+N/Z+d5JDx3nRWGUMU3KgmyV6Tv6TxIe5lEyw/?=
 =?us-ascii?Q?i9XHqOdO+1nBdqDKt8aHk2hY5DNAt5mCH5lVKVdgdkS0K9G5TgCEYyYofeP/?=
 =?us-ascii?Q?p/Gu7pbNA/XZyb8zv6k3dOooeK/4ScKdDjaLNpoaFjXdxRFo+G0tyEVTa6ET?=
 =?us-ascii?Q?pJ0utGCeavTVpMtMaLJF7qyF8oI+xZwa5QCjvmelH7A23zCFOAybfqI8Ad/Q?=
 =?us-ascii?Q?jNvFWn7r9vGl30Rx5y/zMLsI73PInPHRdEQZa7xuxiXX+oPHwbEhXcy/08h/?=
 =?us-ascii?Q?qukvSRDI9EehRGu/xRYdeRrIeE7/FI6i5EBF0kvMiHATa08F87t0+5FjYVND?=
 =?us-ascii?Q?rQwLXNLLddSKEniLax8aHO1YlJxYWFdym6txvp+y7/oBwJSQUwYg3M+JMVqT?=
 =?us-ascii?Q?ssiBytXIR2Tk7SkWlNOPqKNQAslg1XV2SXgctmPKqovkJ1Fqw9wafE31B5rB?=
 =?us-ascii?Q?d98p+L08moV6ocDUbwpJMpaHWOK2B7Eap4OW4eoQ5Vfc0yv6YED6z+flHf7n?=
 =?us-ascii?Q?LGYHPBLo6k/6zfl8GCKUAPeWsxGVpIYqmziUp3/R534T5aiDv9Sia9S/lAOw?=
 =?us-ascii?Q?SXoshyoOnhY8RDGk1E28ShBfB5rJhL7oKhtiPZzmp8nmR6/4IEZteZHi7+IP?=
 =?us-ascii?Q?hET20Jz7G2hxQwuFbE/bFInB5w4PVIdHztWamXY+4SzHDj/4I0Pj9vB9cilk?=
 =?us-ascii?Q?51kg7UE4VU++bm/5eTIFfx5WLZWRkn4R8wxjt/KN5det3cA6+M7ptuUSpMji?=
 =?us-ascii?Q?s3sk0EOkWnT5cceAwqn7V9rLIJpt4hUOkgI/o8JskhJ/lsBJGqe0uDJ63M6J?=
 =?us-ascii?Q?7amYoT+K8Yb9Kkj901YnsiqJyOtbFhmiOtXIXT8nIm38A2gLgOFSYwaOerYk?=
 =?us-ascii?Q?PvVxNF00NTaoJ+qVlgiaGoFgcgw8r+SG7/lBo3qinTfr2cE8kUSucIPm9Cpf?=
 =?us-ascii?Q?zZ4Ci01MXlplLhyaCpBIVo0YQwzs4nXdVn0z9UqpXIWs53fEgaKobbXIkupi?=
 =?us-ascii?Q?BLDvR1a9J9yr+9TXKtTVMrYviJ4c08D1IO+tt8mqW2Ri+EOisNizTmPiiucJ?=
 =?us-ascii?Q?fFsUS1oSN7poqL7KYhJo0tlIU6KOQOp9zOWivNXVgjRk1LmS9j5A3A+HBFkO?=
 =?us-ascii?Q?REGTa88Qv1TH+PcpzRTot9Z6WVaT/AB4RPnOqCLMwuMAK12qEeHcF0HqNF9c?=
 =?us-ascii?Q?LPOh509RD7vwkNBBY/VcektUXjpGH6PXaTNFMwd9TxdO9YiEfX65ccsAAGyb?=
 =?us-ascii?Q?yMVluJPGMTAt0Dk7xn7XrbHeR/jAgB3YRVe5qhkAOHhQBuxx+Klzegz44F67?=
 =?us-ascii?Q?IHD6o5rBze6dWX64YJPbnZaRuHXM1MA=3D?=
X-Exchange-RoutingPolicyChecked: c0suWeQ4KE1rdPi8ixDiaedTnq0YzfPGoLsrAX4s7kI2+IGpG/B5ir+gaIYRItWZTa2VnCGKl9/vur1tw9RgS/j3CgvHr+7LcVOzmCKbhsd4Lrnwdt0/r6Yj8FfcnmJjP8r/IwTQgYONtOG8pMIx0noojTJaHjOccg6vvFi4Yd6zacAQNbiSz6Y5FF3n25oZ/c3L5jUdlPweOv0szQzFgR+RF9ITKKrZ287MtJHpkZGQe72j7svQ8mddtn6PYu5iUq8Fs7KCeE21mPOiUbnrj7D0loOyteQDV+ooREZ98dCH8nsTM+493pbcqUsgyZFdbGPiwpC4K8aBAzq4a1o1MA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 585c68c3-cf08-4cf7-b9a0-08df24d7dadd
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB8891.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 01:02:42.4045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aGSZSVYnIHWe21VPm7P064bh0shtRYMI4XPBtzmnD0ndSph3ePHV10JslnaoMG4/44NVQSglZysHLrRHJ622/4mDKGQagR/XZ/zRbT8ldaY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB629882
X-OriginatorOrg: intel.com

On Tue, Oct 06, 2026 at 08:01:07PM +0200, Miklos Szeredi wrote:
> Make sure that a non-NULL check in callers remains valid even when racing
> with fs_put_dax().


Hi Miklos,

I understand this is in preparation for the new FUSE DAX backing support, yet it
does need a changelog that stands on its own.

As written, it suggests that READ_ONCE() makes a non-NULL result safe against
concurrent fs_put_dax(). However, READ_ONCE() only controls the pointer load, but
IIUC it does not protect the lifetime of the returned holder.

Could the changelog explain what READ_ONCE() provides and describe the intended
RCU-protected access? Include what guarantees that the holder remains valid
while it is being used.

Also, is this RCU-based lifetime handling specific to the new FUSE implementation,
or is it intended to establish a general requirement for DAX holders and callers
of dax_holder()?

-- Alison


> 
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  drivers/dax/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 824e1f6df378..0a440f8b42e4 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -677,7 +677,7 @@ EXPORT_SYMBOL_GPL(put_dax);
>   */
>  void *dax_holder(struct dax_device *dax_dev)
>  {
> -	return dax_dev->holder_data;
> +	return READ_ONCE(dax_dev->holder_data);
>  }
>  EXPORT_SYMBOL_GPL(dax_holder);
>  
> -- 
> 2.54.0
> 
> 
