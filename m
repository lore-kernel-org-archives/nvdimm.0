Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4879D41DE03
	for <nvdimm@lists.linux.dev>; Tue, 14 Jul 2026 19:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784057328; cv=fail; b=liM/CMk+cVZL7YuMAoIx5w7LRqff/dUAnF9mBkxdyKJsKI1FbJvE+04C1qrqrF0jY/TUdnDs5B4C7u1+8+s65rsdQI76Xkb+I5gOHuKT+M+J4FVatoERvlAn5deOLI+Toaxt6EQMSfc3y1BnDL5l1Sz9X2EWDUNm7fbd7dyGhGk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784057328; c=relaxed/simple;
	bh=5XFTu+5q+lTBjYpHx6L2vyODt9gzTWz2FQCz/UnQO1o=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BxZfB86NaahbBKKVtFfxiT7MBt9S7DjMm5HLXGoggF2N/jG/+ZjqZ0G/ylqCTyOvzyaG7Gum9s+AWb6zstlJ6HBzTI942gRTYxbuEycEV+DliGi2U4fhdnIuRbG8HeJ8PFNBf5GuCj0CvOrua1GJugt5q3C2qLNwGMbCet6hBls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bg1tK2VK; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bg1tK2VK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784057325; x=1815593325;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5XFTu+5q+lTBjYpHx6L2vyODt9gzTWz2FQCz/UnQO1o=;
  b=Bg1tK2VK6nS6q1BI5z3QX/uQfTEYfj6TKG0jAtdvvaUoJ9dhiosyuGgo
   AFya1UbON2MLJp0UP5e2HQHqj0H+H5qg2wunQVaAAQQC+sj3sJX6zvcEY
   EykptAlkC+CZw5JxD78b1cllcR+7tT1EE/rGHsVPwPFWL9+uMbgwKyeOK
   PmhkXOLp3klh8/KxX66FIOZq4uSaHGS0UTxAo7LDKfYv58G37ulTuPaeq
   DWn0rhc5ZuLLsbJaMfngDaVt8Ax7uaLjqyV2P923qhoUwcjQCzNNR1eiE
   P2rlPagDsYNks7QQDxS6QYuwQJdwxENOrbNGgCBBuNgl4kGll7SULvbbm
   w==;
X-CSE-ConnectionGUID: aCymnQ0TQD6j18jXgtDmEw==
X-CSE-MsgGUID: QIaRYDSXRDO5WxKNoIehuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="72212838"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="72212838"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 12:28:45 -0700
X-CSE-ConnectionGUID: a6XnCtMhTvSoKFIsH6xc9g==
X-CSE-MsgGUID: 17emov4YQ9uCdMZictYFZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="254829335"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 12:28:45 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 12:28:43 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 14 Jul 2026 12:28:43 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.6) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 12:28:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mDsvcdhX3eCChaw/BRp1jrBilx+LbFldE/JEjq6CQXWjYdxCghD7bohHXHOyV4BG4+cdx3TWPFXq3hyEZPCQ6pNcH9RnskS7LS2+hREYwKr6qjF8ly0clo2K7Xtw7V7C0eh/nh5fUPnrdjkM3t8uK7zphBsxS8s46VjWmj0TJmFT+8Bo1DMIGDG/rPbeIZmekUd2QiFw2A+iZaiODvuLQYDFiwRnIsvdvuxcIgdzowhujjwWRQ9Bq+8cbGtS9PROEk1gSh4c1kXzFt/DlxoKrvMQcYWQWLvPtgcwmdxV9s7t4n4LuYAKNmeww6+AgsqGphdVi0bdWFu0TtMnewCkng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mRqrLl9aN/2uBlpBKe9S/SpiV8kzWEkPEQp/4t0PVWg=;
 b=qV1JfYiEB/mWjMs5aWBMevUF3VrxQjdjsYVHbhE8YGWwLiGwzGX59qpPJNzGX7duT8OI8ZWwFPIqWf1my3N4jSJwVFcJIWfCz775i5iZUztc2UIfGh5GUkUcyRhCmMoroH8iWHgaryH3j501mFaspULunERC8lhUPcdLNVr5rgkIj/OHHk0lgmrYrOVV/dsKMe51x77yQL+8refC6l7eB114cf7glNjbOmZWSiuqVslydatIF9x6rWzVoNIfmaN5Vt4dIXiU8exsQ20aNsnZhkhuZuruuyGks550CeTsx4dKEEsCGZQ0VT2Heiv3ujwtP1iirt4nAc3bw62lTiev+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DM4PR11MB7208.namprd11.prod.outlook.com (2603:10b6:8:110::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Tue, 14 Jul
 2026 19:28:33 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0223.008; Tue, 14 Jul 2026
 19:28:32 +0000
Date: Tue, 14 Jul 2026 12:28:28 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Richard Cheng <icheng@nvidia.com>
CC: <dave@stgolabs.net>, <jic23@kernel.org>, <dave.jiang@intel.com>,
	<vishal.l.verma@intel.com>, <djbw@kernel.org>, <danwilliams@nvidia.com>,
	<nvdimm@lists.linux.dev>, <iweiny@kernel.org>, <ming.li@zohomail.com>,
	<kobak@nvidia.com>, <kaihengf@nvidia.com>, <kees@kernel.org>,
	<newtonl@nvidia.com>, <kristinc@nvidia.com>, <mochs@nvidia.com>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [ndctl PATCH] test/fwctl: Add Get Feature OOB rejection
 regression test
Message-ID: <alaN3HGUZ9Fl8vcD@aschofie-mobl2.lan>
References: <20260624140006.50773-1-icheng@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260624140006.50773-1-icheng@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DM4PR11MB7208:EE_
X-MS-Office365-Filtering-Correlation-Id: 5be14056-aab4-4354-3011-08dee1de176a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info: JBwWzbZ6xFK9J3Rq5sbdzQ+oIP/Z1rSY/99cvCJGF2B+QlgEyVWX+BOSvhnvJXUZod8Xe9hyuuiM3+rlfqWfNqOWwE7otzrxF6XR5MqbXnIxeBb4uMVigJ3KhSiN+IBCp4VBM+3OSrZZyaFxeOFpaCKFXa88FsESl2ImBBX3OEjT+5sfC7UDhPyr5rlwlSpVRuuUHsY++awV73iSlqH+selhUJQHKee/hcsMuKpZc0320ESRfQtRGLAweXubcvVJZrAFT+xUlv7JRwDQ+QROL7AZfQ8G8loRtpvl7yyY8xfgfoYJ+7Moxp/Kq9ppF5JAaRRBYkYARgIxklAh4VPE+NUqbpvYeiFmKSaVHN4iuq4QIUbkhT6jWeSs30eSuMW+TNPYLslKBzAf/KNnuC5diagW0K2HN7ZbsKQ8VoX5xQHrlvBtr7z98yKAfMJlTTbOU8bIXGGlIvfT+zavuItE6iKazb96cdNRtvsPq/x/pjGBTUsVAdEPVVMNZrjMZVvLwv4dOhelVszNn745FCnczGy8z/INYkRMnpd8aPUPRvBeg7Vz8p3e7Nwm7gMMWgZK3ZAVwx5hkW71eQ6blecySpTKWAtpNllxPfon1Hx1MW6NNOMlIwl50tLxiSHbcgmqvH8l0fcfF8gJf2YxUD6mxVAN0WV6EWylL2AtxK7FXWw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WxBRdBbIzas9p44WKS5LYrzzbZ0VRtcVPYHZvU0w1+vXQWL707b+b4mysCZ6?=
 =?us-ascii?Q?de+x2yd1UIpynAy4kuytD0x1GA6orwedG8VrX03Np9sYQCG3WjH/JlRHOAW8?=
 =?us-ascii?Q?1F8qJ+XNeCuoKf2/LmQaAtKwAyG7tCNQ2rlBerU+ZhYYGnoChFuHEyU+WxnQ?=
 =?us-ascii?Q?F/ImPAPE1gQceISoSPrWqa0Jf++nXyuOXUmZYImpCqv3huqskW3WtfIwBkA/?=
 =?us-ascii?Q?5XIgz/IHjslZLTCl8mDvItWRF1olAqB2snSxyFYrtUfTag9EPKUzYwaRRhRk?=
 =?us-ascii?Q?rCp4z0K+e14kekR8DTQNydBnIAKfT5n+xb0XdXvgXsIUZVqzg54tl+X7ZAbd?=
 =?us-ascii?Q?CgWBULyYbrw6y+P4+81os3QnEqFbHa7x7KMeOOs1MnS+uhICf0KBVjkteqxP?=
 =?us-ascii?Q?GCM9JfWpo0h/m6LrVQzhJ9ZD4/w5BMeUP8UTfpoTDKPKL72GVnuDHthQqOqE?=
 =?us-ascii?Q?7+nFHQFB5lYAORPe5StEUf1ckLs6ReNnnmfj77WED2QldaPxFefWYsNEI+B1?=
 =?us-ascii?Q?V8OAgzMp3cTi6GDCx0v8YEOQCbj5z0wLV6ndlXiFspf+HA2merrRzg123LLm?=
 =?us-ascii?Q?rz9rAJ09XVvgDsIaZMVbNstkaXZKLcVmddIBQLcXBoPzzV470/36nbTuznAY?=
 =?us-ascii?Q?PwFhsicegPmiknBwXbZH1MCk9EmKMp/KSdiCSq4T9ffFu9I3z8NI23GCr5vK?=
 =?us-ascii?Q?FbQKp8TpBIHur1UOHK18Zb4Q1g4/+QOBgcT8avssvFTalAm2Z/FfUnRF/P9t?=
 =?us-ascii?Q?IWUJ3zzVbbWjpYo2dcmu2ghbEjRQpl+z2SMWuKq8R1aR5fQQIMsGjRTG7lm3?=
 =?us-ascii?Q?/2ER/uU2C8GnT1f+6q3TDrSQsAUSN+LKedhTcxcfFgEkajM3M6M0T765gVEx?=
 =?us-ascii?Q?6lQXg25EbP5BlVeMNqqgYS7yPsmcc8cYPKYxc29RYw5jyy01RqURu6t6U6qW?=
 =?us-ascii?Q?z4HKa8v3CjRyb0ahyiz8vwM/AcjBva38p2GUgSGJ39t2pat24SBHaZp6HNQm?=
 =?us-ascii?Q?9sQNYWA6A8F+Ud3iok4CI03ZBgBxBOYvAbbvC22f8NjwwYxcDC1pncO65IaQ?=
 =?us-ascii?Q?H6YMiDHCTONnUgUZqVlrTccar9l6kRmUb0Mz8eBKqohlfWfCf9890UzXWZxz?=
 =?us-ascii?Q?lOhoBU/iOX/ZHRIQnnbfC+vfcKWKKQsz1p49VVrHHcHjUYEab/aiWpNHs6ie?=
 =?us-ascii?Q?bFS9538KLB7eNstSl/xCqWOpr/M7bR1wfNxOU1FVOyeIG+XP3YH9R4o5YsKf?=
 =?us-ascii?Q?/VflbJW1S6fek3p4jsxNWNdbcCJD+LhUeYyT5dWyRRrCXeU1u2nETy622Z4A?=
 =?us-ascii?Q?KN+3QO/9w8P4MIQdlT6Xyd/MJxuAf55UFGMvF0/m8S2gQpx1OH6i9fhWSmhA?=
 =?us-ascii?Q?i9iqwbWFcUYiaXj+qGyr7fe0QZmIVlFFAkhDC3juWUDbKY2YEJVvVxw7rCkM?=
 =?us-ascii?Q?U+R3S7IWh1kztkFSUdMu7WiOkeh1gilMWikpUnPzKsH9M1QU6s85AwAuTzMO?=
 =?us-ascii?Q?slmE7uiux9xOmZcAw9C3KqqmYtZjmu4ts7M0s7/+2ay87NY2CopsXMYdAuto?=
 =?us-ascii?Q?8a7Jxs1whI0mRIBPXZs98WOw/vd/S8UtqhyFprnHsrMoIJIwouRCLNlaB2gN?=
 =?us-ascii?Q?TVIqjk/bkISlaBecnPzNpOl8a1kjVt4kWvmC/oBxgZfTaeTkWRa9SkFu3o+Y?=
 =?us-ascii?Q?m62zxfueKiRZcIO0pf/sVjH+D9+HDLhNUuqoil1VZrGeBxi+v9yIcHh9gKdp?=
 =?us-ascii?Q?PZMm61pQ371jhjwr6LdI3E5zioLi38A=3D?=
X-Exchange-RoutingPolicyChecked: bAHAe3SPKJCsdAiVPHRaO0Rzov8aysh0LhlqygpRy7/xLcs1JK9tAaRNf4+EWjClM6HtZUdhTt2bUGvViw6lNBnBA2hKJpqhVNOnzw7CK5R4pQOYueCVtAuSNMUMFH7NYFD4StL0QAkzGMT5nRFY+8tmORAE0ros6AUa38V3MZw21m91szMWCMZumX8jdqRX40fOkLLKjA0gA6U8syOl0NaKLiasOda7jSo/9ZNLo7xS/Um3zFEgLV/zaNZVQyUpUATUrWiXj+r3T5teBX/d+pi72OXnXB6zq7QARoKw1tcwe0ABjAJpdkQt2OH0nxHiDnvWR8i/Kah+plxSlChS0A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5be14056-aab4-4354-3011-08dee1de176a
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 19:28:32.8439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3+g0RMxveml9BGqupFDAXRjT2MYrLbgrPEFQx+uYW2z5GWEbO8C0XA2a2bSBjR2ihWcMUHSg7efU1YtCkj+ytfKeW4UDPo4RV2zIQgkfTV4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7208
X-OriginatorOrg: intel.com

On Wed, Jun 24, 2026 at 10:00:06PM +0800, Richard Cheng wrote:
> Add a negative case to the CXL fwctl test that issues a Get Feature
> FWCTL_RPC with out_len == offset(struct fwctl_rpc_cxl_out, payload) and
> a non-zero count. The kernel must reject this with -EINVAL instead of
> writing the feature payload past the rpc_out buffer.
> 
> This is the userspace regression test for corresponding kernel fix [1].

Hi Richard,

I just finished reviewing the now 3 piece series[2], that [1] is now
a piece of.

One suggestion on top of the kver gating suggested in prior response
is to add a companion negative case for the Set Feature bounds fix
in the same series. Same shape as this one, ie build a normal Set
Feature RPC, set out_len to 0, expect -EINVAL. It's a stronger backstop
than the Get case, too because before the fix an out_len of 0 makes
kvzalloc() return ZERO_SIZE_PTR, which passes the !rpc_out check, and
the header write then oopses rather than just returning a wrong status.
Gate it on the same kver helper.

I'm stopping short of suggesting a test for the third patch (the Get
Feature per-iteration clamp). That one looks like it needs a
multi-transfer feature and a device that over returns on the last chunk,
neither possible without a cxl_test mock change.

-- Alison

> [1]: https://lore.kernel.org/all/20260624134737.49166-1-icheng@nvidia.com/
[2]: https://lore.kernel.org/linux-cxl/20260626104102.53892-1-icheng@nvidia.com/#r


> Signed-off-by: Richard Cheng <icheng@nvidia.com>
> ---
>  test/fwctl.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/test/fwctl.c b/test/fwctl.c
> index 979c1a6..69d0048 100644
> --- a/test/fwctl.c
> +++ b/test/fwctl.c
> @@ -5,6 +5,7 @@
>  #include <stdio.h>
>  #include <endian.h>
>  #include <stdint.h>
> +#include <stddef.h>
>  #include <stdlib.h>
>  #include <syslog.h>
>  #include <string.h>
> @@ -207,6 +208,45 @@ out:
>  	return rc;
>  }
>  
> +static int cxl_fwctl_rpc_get_feature_oob(int fd, struct test_feature *feat_ctx)
> +{
> +	struct cxl_mbox_get_feat_in *feat_in;
> +	struct fwctl_rpc_cxl_out *out;
> +	size_t out_size, in_size;
> +	struct fwctl_rpc_cxl *in;
> +	struct fwctl_rpc *rpc;
> +	int rc;
> +
> +	in_size = sizeof(*in) + sizeof(*feat_in);
> +	/* header only => zero payload room */
> +	out_size = offsetof(struct fwctl_rpc_cxl_out, payload);
> +
> +	rpc = get_prepped_command(in_size, out_size,
> +				  CXL_MBOX_OPCODE_GET_FEATURE);
> +	if (!rpc)
> +		return -ENXIO;
> +
> +	in = (struct fwctl_rpc_cxl *)rpc->in;
> +	out = (struct fwctl_rpc_cxl_out *)rpc->out;
> +
> +	feat_in = &in->get_feat_in;
> +	uuid_copy(feat_in->uuid, feat_ctx->uuid);
> +	/* non-zero count that exceeds the zero payload room */
> +	feat_in->count = feat_ctx->get_size;
> +
> +	rc = send_command(fd, rpc, out);
> +	free_rpc(rpc);
> +
> +	if (rc == -EINVAL)
> +		return 0;
> +	if (rc == 0) {
> +		fprintf(stderr, "Get Feature with undersized out_len was not rejected\n");
> +		return -ENXIO;
> +	}
> +	fprintf(stderr, "Get Feature OOB rejection test: unexpected rc %d\n", rc);
> +	return rc;
> +}
> +
>  static int cxl_fwctl_rpc_set_test_feature(int fd, struct test_feature *feat_ctx)
>  {
>  	struct cxl_mbox_set_feat_in *feat_in;
> @@ -393,6 +433,12 @@ static int test_fwctl_features(struct cxl_memdev *memdev)
>  		goto out;
>  	}
>  
> +	rc = cxl_fwctl_rpc_get_feature_oob(fd, &feat_ctx);
> +	if (rc) {
> +		fprintf(stderr, "Failed Get Feature OOB rejection test: %d\n", rc);
> +		goto out;
> +	}
> +
>  out:
>  	close(fd);
>  	return rc;
> 
> base-commit: 8ad90e54f0ff4f7291e7f21d44d769d10f24e2b6
> -- 
> 2.43.0
> 
