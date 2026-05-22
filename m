Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8D2349CE0
	for <nvdimm@lists.linux.dev>; Fri, 22 May 2026 03:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779420623; cv=fail; b=oyYFDO5L6/q34Z3Ru+VIvtRAHwtjt9SxSd6sOenbMpqLUIf+HYfVQkd5XavjWxjF0lnAKBhyS3kLWxEUVN4pvygCrjttm8hb1lynXKHeFARu5xA9C0Dn82upYa51ilFCbHdzz9Cjm6I56LIc+l6ClkfeNaFF8O4UK193F5MfiQg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779420623; c=relaxed/simple;
	bh=YtjHY7v885otDJTliaZ1SJf7yjRYEoXYmnSLYgNq/QA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=glO82mwV8y87Ck1CB+X73Vr8fJ1GU81z6tgC4eGcRXiyGurK4SRh9nNRnDT+yi1TPZQ0mw+RC8VJy1U7NGSCCgYC2QwmaV01kvm6uy+OqNiEDVQQbRmBL8XmBydk0CVE1bg8Q/rwisO+JmlMOSBG48GJqLk9FFKcYd75GQTxy0Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=csjNOjcu; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="csjNOjcu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779420622; x=1810956622;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=YtjHY7v885otDJTliaZ1SJf7yjRYEoXYmnSLYgNq/QA=;
  b=csjNOjcuN+qBQkdAI7D3jMb1dQT21Ajne2BsobfaPB3bJUElj7+MLP//
   S6NWLc3LIf3/UJUKrYYk1aAJBFJPs9OCMewZCYhuWpHjr4JLXaznSqQX4
   PoKQ4+S+hlQqv7BF2PyohZgroDsfocQYOytx9Ni6Q/+c5i6ZHm4x54IyI
   m580P3jZMtHGf4rSuiKSkf+cOLcygEt+OcEMgb3Xu1j7nu24sabqD6CH7
   api1CHGT+J+6spnMoiL423LRdbH/UCTMGVEXvJQMQRJu2/HHRyQ9b+3Z/
   dxRgXJgeSpuRDxwcNHpgcRW4xgU2NoVUur8m+nGjiW3y0dT1DEiVEzLPO
   w==;
X-CSE-ConnectionGUID: C3+8cGaASmW0XyzyTE+zEQ==
X-CSE-MsgGUID: LThXKjijRKCBrcQzYukB1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11793"; a="80077155"
X-IronPort-AV: E=Sophos;i="6.24,161,1774335600"; 
   d="scan'208";a="80077155"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2026 20:30:21 -0700
X-CSE-ConnectionGUID: DwUZuEb9RzWyAmqyHymIGQ==
X-CSE-MsgGUID: qqkMvfGUTd+XkX9ilUYMUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,161,1774335600"; 
   d="scan'208";a="245818748"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2026 20:30:21 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 21 May 2026 20:30:20 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 21 May 2026 20:30:20 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.31)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 21 May 2026 20:30:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iwGh/IV54mshwG5olO8XVqRZ34UgKhRPsKJRfccba9bGBq8egozrtiARCnMImNA4KytHcUpjFHCpIUGQMdafdswTHqxh3plkyZBO+/XMp/0Gyg/nzEeThBmCVx+4PxTbKzrMHE/xxdAyP60yn1mbKMsj0mQYUUSEhKSabPdhYsOIR5bD6onzoq19rYXiTTDyUGSeGEM9ePhH3ofyahqs4GuxQtLDfEeNzDzI/Bp1XqINQimOKNd3aNLA7cD8lcZS9CnqLwXxQIxBvkrb9BJizeZsURmQD9klTlYeeW0vijBf7W86KrHz2ucnpD1r/LqJaDT9DXFyqpVIML86rO+DEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=klkUWLZcUlGvc5OMyEmecwpUl1G0QP5HH+19bSXNxIo=;
 b=TzTbIgSrqj4EKJqW+VSliYN6JTT42az5xvhPFkiND272gtqTlZrCd41lt7+SoX84nc1yV/dbAHyYZ5xPDN34/oo5vEZTkoAwp5rGmlsA40FH6G+id5FacgnfwbMiWWsA0zY33hNSdGl8I0y7u385j3SaLIC96QyyMFRPe21EFwQJQYQzBAyDx0KuECah5/3b6CrJVtxT8uYUfFUUNataK14KagQWOwoNSpTOJ4xFTO/WSUtUsZLVyMSTBlBjIjzK3i6eWyUsMOh4gQOJrjauDS80OpsrV6BB61hP/eYy7xQ8Z7qGulnMHTKmp3Waz3ZYJdtp9lTPLk6N0YFjv1/QJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH3PPF2CAD058EC.namprd11.prod.outlook.com (2603:10b6:518:1::d12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Fri, 22 May
 2026 03:30:12 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0048.016; Fri, 22 May 2026
 03:30:11 +0000
Date: Thu, 21 May 2026 20:30:07 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: John Groves <john@jagalactic.com>
CC: John Groves <John@groves.net>, Dan Williams <djbw@kernel.org>, John Groves
	<jgroves@micron.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang
	<dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara
	<jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
	<brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Ira Weiny
	<iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Fixes to the previously-merged drivers/dax/fsdev
 series
Message-ID: <ag_Nv0QwWPBg6bfk@aschofie-mobl2.lan>
References: <20260518213452.31205-1-john@jagalactic.com>
 <0100019e3d03bba9-d27282f3-5552-4fa0-8326-981e4c13dace-000000@email.amazonses.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0100019e3d03bba9-d27282f3-5552-4fa0-8326-981e4c13dace-000000@email.amazonses.com>
X-ClientProxiedBy: BY3PR10CA0020.namprd10.prod.outlook.com
 (2603:10b6:a03:255::25) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH3PPF2CAD058EC:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bc2566c-5c87-4397-eef0-08deb7b26e49
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|4143699003|18002099003|11063799006|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: szytIPHDJXIbCpRBo7Laq07BEmQqewZqQ9uJfPvEtLZ8VEKeBCd4Z7VPBQjJo8jyYWa2MBM7xX+9LUOqB+VqG/M+TdDcfc56L3qvbQcNaOyPiSTsHp7722aT/Spyx2s7Z7DBSPDZwzWlEk6olVA8jRprADyzC55qKTy7nzy9nImN8W5yAPL+sM2C5wM63S69+h/7Lv7rWeV8u0il0516JGoNuNHpNsKeX5uWnnRY6NKTRlmwpUU11c5cePTqXiEXYgfHKT2wFGI1xtZQNg1LiK73vswkt6+kpjnhpKrZ50m1206oJB6SZasFY/u2E8NYwr2d4Ol3W+DaSsD63Przrs4G74V+7S0DqzsJfcnTXp/FUTGMpTNVsKSfr9m4PG7dxRMwaeMRtPYb91emGF5Hqf8vOdutpdloPSDXT+jcUrjSuyA0uS/fIElOLzGgUskwXRbE/q7S1Uzl92Rjwjrq044GP8OBmoK4Bja6tSG13mXQ4RX/qTfyMbYoDjLj9mmgEfwLS5GZcgwa0CjLaUZEgRjWGrHFide4ZUXBbQqPFv/uaATMkz62KgZ3S/DDSsi6QgfEoSdJVMAeMAM3Gd6TCMMxYZbecbichp8fPgdX6lgLGRVvBWTOmrEnutSJC1LnxrLHUqa+i0mzObF5uuZ3M7FC0AmnbcHrp35bH9ALRdp2Upe4a0MUdVd6P/8xUTZn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(4143699003)(18002099003)(11063799006)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HFZkLfVViEtp0gHxSf6mbIADPRFaUdd00zUbg2yKiNpvKP4tw+vug7CevxCH?=
 =?us-ascii?Q?YNZuvy8UZCqDysZMFVH3trPzO07DqkIvbLpYf6wGkwUz7YxODd9+vf56HRR0?=
 =?us-ascii?Q?TEfcTwC3FzhMAnjzPC8vGnr+S+EYhJfPp8zYkhtG6O1FZ0oOgNuQC9sOiHMS?=
 =?us-ascii?Q?y09C/NRWGGwi35+r/LvJt/tAZ81eIGSFcwp8tTdFdcIuOhdYAwneiHLme6cS?=
 =?us-ascii?Q?ZeYY7oK0yL9PVowHoXmUxQ3fGj8s9hKH/Tb9J6ED+PnKh2zUftNbJj/9l5gA?=
 =?us-ascii?Q?Sk6zP3Ash/yMaGjwIUIrh4IZv4t9Vow5mQTd/+Q8i3jAwwOHkM4FfCqb9gTg?=
 =?us-ascii?Q?0uccLBWW9Y+Mla3sb+9GSfvTyh18bgP/5rNQkvRfdLKueF6dkbrsP0PXTxYU?=
 =?us-ascii?Q?DUGlCKDVCa2cUVRW7Oxat0Z/Nso/LuGXoLQvM+osioB6vUExr1TUjImRDAut?=
 =?us-ascii?Q?zZNGqTENiJLDUY4DFT54eD+UunItUey7iA5E7MZ/BG76xl157UuRnBKsd4Pt?=
 =?us-ascii?Q?2AYCkbrxi1Pillfewfaj6aw265rh/ZtXtdv6B3BMjq+T8eeyIFRgLIqXU6ao?=
 =?us-ascii?Q?CSqlwjExzpm43Gwu8haSbCn1O8UgswMndzkhGpryO3keDr81Hz0a8cRIie/x?=
 =?us-ascii?Q?kpcyIks4leeBGA+GMOfD0xTGEGfq0l4SsVSXDd2LHIv83xbcvgYV4FjxzQhD?=
 =?us-ascii?Q?nmu4A9Cx3EmUQgBUFuJPiVBwgFljLsSxNTk86lI0W9UTy6dEm8+t8iRD9Y4X?=
 =?us-ascii?Q?Z1RZeYcYUjxzNx1p5Egb8SErWL5Hdxkrkt1XRn1/lleW6R5T6JCZ8xODBngM?=
 =?us-ascii?Q?wBOPWAWxRXHKLX3Unkjt3zrX/0/Nvjr0Wu3UIuI5NB2y6LDvNT5o0Qx0k8vx?=
 =?us-ascii?Q?PzRYzsGl4MFO/ToYAA+fYwiDWj0f4sIhbBkaqT9vnC02C1QsK70TUmZFR05m?=
 =?us-ascii?Q?XTeGa4gDZ9PcKXadO4+yGDENXmDdCp/oO2LM7CwyYxczbK7oVy4KOSyzTtH2?=
 =?us-ascii?Q?FhYiejzktM6E6aK30v5dP9Lok6WZs3RywkueeCyHvK15noahbxKFt08kRaYp?=
 =?us-ascii?Q?o2fv/6DbxFNtOJNchL8D8iv/DVD3AIrZsuvc8CliMVMo8v5TA3COUQgK+WE0?=
 =?us-ascii?Q?cdk+rSFI0TtH8+sVzdsAxgIPn/+I/30O8XfpSkg/H7KaBJHi6OTyReu5Ip3o?=
 =?us-ascii?Q?QtvCeW5RJLhGOtDO6OsWN7svMuhpAop4EpGzjYP7b7zNxF6Mbv+zew/5c20s?=
 =?us-ascii?Q?fgJz4x4i0xtHhs37vpvRejICYRHgoyv1h+jz9pSwyANcIdBnCgSpCQdA2YTm?=
 =?us-ascii?Q?pEr1+uOBZv0CAIESi+LndbRi/DUpCrk1k7N+sjEqFD0aLYqzhuKhiqy/jsmx?=
 =?us-ascii?Q?38sT4gujzSMeWptD/H10d0lw4SVHB5ZcAGaIXAMJQHWNk+Le1ZYvsYhXnMcp?=
 =?us-ascii?Q?KK3qoEI4VPQ9bpK1cG2ooHWQ+fOLZbAxMA25oEP5iIU63GDYxqkZ3WFaH/dT?=
 =?us-ascii?Q?40sB+fajWitseJZIVe6ttTlvuhCb4KXSS54BbJzIBO/rBaHAfgjhRYZ9FI9e?=
 =?us-ascii?Q?hL7hvw8PZi1Ahz45N4BzpYhXQkWk7LJiP2JpOGxe2RMgwTwWYooM/IM/v+RY?=
 =?us-ascii?Q?Zm3Y+0mpFZXtsDtgQ9CeuNIE77+ZSkCWa+AT26P+W5nP2DS99UoaT3Yk+8pO?=
 =?us-ascii?Q?9/wavu6NM5j0Kh/2w3fep0AWciEIIs9Gr2D0Kx3OCDS94R/d1NWHGVy80Thx?=
 =?us-ascii?Q?SHoCnpzX677hCr54fwzoQS9izIlPSgo=3D?=
X-Exchange-RoutingPolicyChecked: o1rUWzdBFe9N1p5Fsht2mzWaXp/xSSOFKol0lNR5aqhNTL9/KUGOLFs7Z9apq1G/mLF4Xq8zlON9VtF0zL7Vy+YbMCa1mhjlo0jirfUaRraKsHuqD2tgbqoCsA3Le1aukovqAHNFtbqZcsOL40K+IXb5RMiS+eYBFKPyOnMN5Q6reBhOKzZq+9GnyTmY/Mv+zlIRS3RNKXtz+mY5XC+fVaa5bIIRSaKwF3orvhvwDISSf1OWPGoWQMffLEQ4XGISySvHsui7MQjkhnuCSlz9OGEX62whjPOmxmEQjOuDMo2ayF/ap3ShirGQuzAJPfvuuIFxT9Jo4QkRaIMB6iv2vw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bc2566c-5c87-4397-eef0-08deb7b26e49
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2026 03:30:11.7913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ynRmFEurpLw5gwDWoxoGKvNS1TVwPuYHzSotzCB2vAs+fs5lMfFYECyCKU9eLhLU14pCtlYChbR2lycPw3qSii4Kh+LKeL0Gvld9Hkp9Dg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF2CAD058EC
X-OriginatorOrg: intel.com

On Mon, May 18, 2026 at 09:35:15PM +0000, John Groves wrote:
> From: John Groves <john@groves.net>
> 
> This series applies bug fixes (mostly found via sashiko) to the dax/fsdev
> series. This has been soaking in the famfs CI pipeline for 2+ weeks and

I am not able to apply the set to any of 7.1-rc1 through rc4.


> 1) won't affect anything that doesn't use drivers/dax/fsdev.c, and 2)
> doesn't affect any known workloads - although the bugs would have
> manifested when multi-range DCD dax devices are a thing (soon-ish).
> 
> John Groves (6):
>   dax: fix misleading comment about share/index union in
>     dax_folio_reset_order()
>   dax/fsdev: fix multi-range offset, vmemmap_shift leak, and probe error
>     cleanup
>   dax/fsdev: fix kaddr for multi-range and fail probe on invalid pgmap
>     offset
>   dax/fsdev: clamp direct_access return to current physical range
>   dax: fix holder_ops race in fs_put_dax()
>   dax: replace exported dax_dev_get() with non-allocating dax_dev_find()
> 
>  drivers/dax/dax-private.h |  2 -
>  drivers/dax/fsdev.c       | 85 ++++++++++++++++++++++++++++-----------
>  drivers/dax/super.c       | 51 +++++++++++++++++++++--
>  fs/dax.c                  | 12 +++---
>  fs/famfs/famfs_inode.c    |  2 +-
>  fs/fuse/famfs.c           |  2 +-
>  include/linux/dax.h       |  6 ++-
>  7 files changed, 122 insertions(+), 38 deletions(-)
> 
> -- 
> 2.53.0
> 
